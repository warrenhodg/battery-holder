$fa = 0.1;
$fs = 0.1;

iota = 0.1;
//box_x = 40;
box_y = 120;
box_z = 25;
bottom = 2;

flange_x = 3;
flange_y = 10;

batt = "9V";
batt_text_y = 1;
batt_gap = 2;
batt_9v_text = "9V";
batt_9v_circle = false;
batt_9v_x = 27 + batt_gap;
batt_9v_y = 17 + batt_gap;
batt_9v_x_count = 1;
batt_aaa_text = "AAA";
batt_aaa_circle = true;
batt_aaa_x = 11 + batt_gap;
batt_aaa_x_count = 2;
batt_aa_text = "AA";
batt_aa_circle = true;
batt_aa_x = 15 + batt_gap;
batt_aa_x_count = 2;
batt_space = 2;

batt_text =
    (batt == "9V") ? batt_9v_text:
    (batt == "AAA") ? batt_aaa_text:
    (batt == "AA") ? batt_aa_text:
    0;
    
batt_circle =
    (batt == "9V") ? batt_9v_circle:
    (batt == "AAA") ? batt_aaa_circle:
    (batt == "AA") ? batt_aa_circle:
    false;
    
batt_x = 
    (batt == "9V") ? batt_9v_x:
    (batt == "AAA") ? batt_aaa_x:
    (batt == "AA") ? batt_aa_x:
    0;
    
batt_y = 
    (batt == "9V") ? batt_9v_y:
    (batt == "AAA") ? batt_aaa_x:
    (batt == "AA") ? batt_aa_x:
    0;

batt_x_count = 
    (batt == "9V") ? batt_9v_x_count:
    (batt == "AAA") ? batt_aaa_x_count:
    (batt == "AA") ? batt_aa_x_count:
    0;

box_x = ((batt_x + batt_space) * batt_x_count) + batt_space + flange_x * 2;
batt_y_count = floor((box_y - batt_space) / (batt_y + batt_space));

batt_y_space = (box_y - batt_y * batt_y_count) / (batt_y_count + 1);

module box() {
    scale([box_x, box_y, box_z])
    translate([-0.5, -0.5, 0])
    cube();
}

module name() {
  translate([0, -box_y/2, box_z / 2])
  rotate([90, 0, 0])
  linear_extrude(height = batt_text_y, center = false)
    text(batt_text, 8, halign = "center", valign = "center");
}

module batt_row() {
    n = (batt_x_count - 1) / 2;
    for (x = [-n:1:n]) {
        translate([x * (batt_x + batt_space), 0, bottom]) {
            if (batt_circle)
                cylinder(d = batt_x, h = box_z);
            
            if (!batt_circle)
                scale([batt_x, batt_y, box_z])
                    translate([-0.5, -0.5, 0])
                        cube();
        }
    }
}

module batt_cols() {
  c = batt_y_count;
  n = (c - 1) / 2;
  for (y = [-n:1:n]) {
      translate([0, y * (batt_y + batt_y_space), 0])
      batt_row();
  }
}

module flange(flange_x, flange_y, box_z) {
    x1 = flange_y / 2;
    x2 = (flange_y + flange_x) / 2;
    y = flange_x;
    z = box_z;
    
    rotate([0, 0, -90])
    polyhedron(
        points = [
            [-x1, 0, 0],    //0
            [-x1, 0, z],    //1
            [x1, 0, z],     //2
            [x1, 0, 0],     //3
            [-x2, y, 0],    //4
            [-x2, y, z],    //5
            [x2, y, 0],     //6
            [x2, y, z]      //7
        ],
        faces = [
            [0, 1, 2, 3],
            [0, 4, 5, 1],
            [3, 2, 7, 6],
            [6, 7, 5, 4],
            [0, 3, 6, 4],
            [1, 5, 7, 2],
        ]
    );
}

name();

difference() {
    union() {
        box();
        for (y = [-1:2:1]) {
          translate([box_x / 2, y * (box_y / 4), 0])
            flange(flange_x, flange_y, box_z);
        }
    }
    
    union() {
        batt_cols();
        for (y = [-1:2:1]) {
          translate([-box_x / 2 - iota, y * (box_y / 4), -iota])
            flange(flange_x + 2*iota, flange_y + 2*iota, box_z + 2*iota);
        }
    }
}