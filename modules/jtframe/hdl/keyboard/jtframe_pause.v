/*  This file is part of JTFRAME.
    JTFRAME program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    JTFRAME program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with JTFRAME.  If not, see <http://www.gnu.org/licenses/>.

    Author: Jose Tejada Gomez. Twitter: @topapate
    Version: 1.0
    Date: 26-1-2025 */

module jtframe_pause(
    input      rst, clk,
               key_pause, joy_pause, osd_pause, adv_frame,
               lvbl,
    output     game_pause
);
    reg  toggle=0;
    wire frame;

    always @(posedge clk) begin
        toggle <= |{key_pause, joy_pause, osd_pause, frame };
    end

    jtframe_pause_adv_frame u_frame(
        .clk    ( clk       ),
        .adv    ( adv_frame ),
        .lvbl   ( lvbl      ),
        .pause  ( game_pause),
        .frame  ( frame     )
    );

    jtframe_toggle #(.W(1)) u_toggle(
        .rst    ( rst        ),
        .clk    ( clk        ),
        .toggle ( toggle     ),
        .q      ( game_pause )
    );
endmodule        

module jtframe_pause_adv_frame(
    input       clk, adv, lvbl, pause,
    output reg  frame=0
);
    reg lvbl_l=0, adv_l=0, adv_event=0, restore=0;

    always @(posedge clk) begin
        lvbl_l     <= lvbl;
        adv_l  <= adv;
        frame <= 0;
        if( adv && !adv_l ) adv_event <= pause;
        if( !lvbl && lvbl_l ) begin
            frame    <= adv_event | restore;
            restore  <= adv_event;
            adv_event <= 0;
        end
    end
endmodule