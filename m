Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37360 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbYEaWab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 18:30:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Evil: Run b43 firmware inside of the kernel
Date: Sun, 1 Jun 2008 00:30:03 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806010030.03473.mb@bu3sch.de> (sfid-20080601_003036_424218_6700DC31)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I hacked up some patches that add a virtual machine to the
b43 driver to run the firmware inside of the kernel.
http://bu3sch.de/patches/misc/b43-vm/

This doesn't sound very useful, but it might help when debugging
firmware code, as firmware code is extremely hard to debug when
run on the device.
Actually, I found out with this VM that the RXE (at least) seems to be
highly timing sensitive. That means it completely breaks when some
magic timings dont fit. So I have the same issue with the VM (using
the proprietary FW) as I do have with my opensource FW (on the device).
I can receive one packet and then it locks up in the RXE busy loop.
I'm not sure why that happens, yet.

However, I thought I should send these patches to the public.
I thought maybe somebody was interested in flaming me for putting a code
interpreter and a disassembler into the kernel. So here you go.

http://bu3sch.de/patches/misc/b43-vm/
Get the two patches and apply them in the correct order to the driver.
Then run the python script to generate the dummy firmware that's run on
the device while the real fw runs in the VM.
Assemble that dummy firmware using b43-asm and put it into
/lib/firmware/b43-vm/ucode5.fw
Compile with debugging enabled (important!).
Then fire up b43 with the module parameter vm_enable=1
If the VM successfully loaded it should print the following line in dmesg:
"b43-phyX: Running firmware inside of a virtual machine!"
And of course it would break after the first received packet and loop
forever in a tight loop. :) You can see that by getting a VM coredump
by reading /debug/b43/phyX/vm_dump

Have fun and don't try this at home, kids.

-- 
Greetings Michael.
