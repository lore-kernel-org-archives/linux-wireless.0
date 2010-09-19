Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:53254 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab0ISR0D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:26:03 -0400
Subject: [ANN] Assembler/disassembler for brcm80211 / b43 / b43legacy r15
 firmware
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 19:25:58 +0200
Message-ID: <1284917158.14353.37.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I updated the firmware toolchain for the broadcom wireless chipsets 
to support newer >=r15 wireless cores.
Old wireless cores r5-r14 are fully supported. For r15 cores, there
are a few unknown instructions left. Subroutine calling seems to have
changed in r15 cores.
However, the toolchain is already pretty much usable as-is on r15 cores.

To install the toolchain, fetch the git tree:
git clone git://git.bu3sch.de/b43-tools.git

Then build and install the tools in the "assembler" and "disassembler"
subdirectories. (make && make install).
Note that the assembler depends on flex and bison. So install these.

To use the toolchain on brcm80211 firmware, the firmware blobs first have
to be converted to raw format. The "brcm80211fwconv" tool shipped with
the disassembler can be used for that.

This will show you a dump of what is in the firmware files:
brcm80211fwconv --header bcm43xx_hdr-0-610-809-0.fw --bin bcm43xx-0-610-809-0.fw --dump

If you want to extract the r16 microcode (which is index 10. See the --dump),
run the following command:

brcm80211fwconv --header bcm43xx_hdr-0-610-809-0.fw --bin bcm43xx-0-610-809-0.fw --extract 10:ucode16.raw

This will create the file "ucode16.raw", which can be disassembled:

b43-dasm ucode16.raw ucode16.asm --arch 15 --format raw-le32

Now modify the ucode16.asm source code file and re-assemble it to a
binary with that command:

b43-asm ucode16.asm ucode16.modified --format raw-le32

If you want to use the modified firmware with the brcm80211 driver, you have
to merge the modified ucode binary back into the bcm80211 image:

brcm80211fwconv -H bcm43xx_hdr-0-610-809-0.fw -B bcm43xx-0-610-809-0.fw --merge 10:ucode16.modified

Note that this modified the two .fw files in place!

Also note that the --format and --arch options to b43-dasm and b43-asm are important.
If you don't pass these, it won't work.

And finally note that I did not try to run a re-assembled and re-merged
firmware on an actual device, yet. So there might be bugs left.

Happy hacking! :)

-- 
Greetings Michael.

