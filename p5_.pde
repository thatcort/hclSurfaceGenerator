/**
 * This little processing sketch outputs the displayable RGB surface of the HCL colour space. 
 * It uses Neil Panchal's port of chroma.js (https://github.com/neilpanchal/Chroma) to find
 * the most saturated version of every hue-lightness combination and then outputs as a csv file.
*/

import com.chroma.*;
import peasy.*;


PeasyCam cam;

PrintWriter output;


int numSpokes = 50;

void setup() {
 size(600, 600, P3D);
 
 background(255);
 
 cam = new PeasyCam(this, 0, 0, 50, 150);
 cam.rotateX(-PI/4);
 cam.rotateY(-PI/4);
 
 output = createWriter("LABrgb.csv");
 output.println(numSpokes * 98 + ", " + numSpokes);  // total number of points to be printed; 98 = 100 -2 --> L=0 and L=100 are not printed
 output.println("X, Y, Z, R, G, B");
}

void draw() {
  
  background(255);

  drawLines();
}


void drawLines() {

  strokeWeight(1);
  stroke(0);
  line(0, 0, -30, 0, 0, 330);
 
  strokeWeight(3);
 
  int C = 0; // 0..128
  int h = 0; // 0..360
 
  for (int L=1; L < 100; L++) {
    float z = L;
    
    for (int i=0; i < numSpokes; i++) {
      float angle = TWO_PI * i / numSpokes;
      
      float H = int(i * 360.0 / numSpokes);
      Chroma chroma = new Chroma(ColorSpace.LCH, L, 0, H).saturate();
      double Csat = chroma.get(ColorSpace.LCH)[1];
 //print(Csat); print(' ');    
      double r = Csat;

      stroke(chroma.get());
      double x = r * cos(angle);
      double y = r * sin(angle);
      line(0, 0, z, (float)x, (float)y, z);
      
      if (frameCount == 1) {
        double[] rgb = chroma.get(ColorSpace.RGB);
        output.println(x + ", " + y + ", " + z + ", " + rgb[0] + ", " + rgb[1] + ", " + rgb[2]);
      } else if (frameCount == 2) {
        output.flush();
        output.close();
      }
    }
  }
}