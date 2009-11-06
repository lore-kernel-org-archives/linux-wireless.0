Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:15321 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbZKFQTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 11:19:47 -0500
Received: by ey-out-2122.google.com with SMTP id 25so295619eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 08:19:52 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Nov 2009 17:19:51 +0100
Message-ID: <ba4215e10911060819y1175e003g695281fe084e07ab@mail.gmail.com>
Subject: b43: firmware loading problem and sleeping BUG
From: Martin Fuzzey <mfuzzey@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I posted a couple of days ago to the bcm43xx_dev list about problems
getting b43 to run on a
arm (MX21 SoC). That list appears to have died recently (at least
nothing added to the archives
since last month)

That problem is fixed now (and patch posted)

However I now get:
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
pcmcia 0.0: pcmcia: registering new device pcmcia0.0
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x0D, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x09, vendor 0x4243)
ssb: Core 2 found: PCI (cc 0x804, rev 0x0C, vendor 0x4243)
ssb: Core 3 found: PCMCIA (cc 0x80D, rev 0x07, vendor 0x4243)
BUG: sleeping function called from invalid context at mm/vmalloc.c:1367
in_atomic(): 1, irqs_disabled(): 128, pid: 1361, name: modprobe
2 locks held by modprobe/1361:
 #0:  (buses_mutex){+.+.+.}, at: [<bf03761c>] ssb_bus_register+0x48/0x1a4 [ssb]
 #1:  (&bus->bar_lock){......}, at: [<bf038e38>]
ssb_pcmcia_read32+0x24/0x74 [ssb]
irq event stamp: 105917
hardirqs last  enabled at (105916): [<c027cf34>]
__mutex_unlock_slowpath+0x120/0x150
hardirqs last disabled at (105917): [<c027eee0>] _spin_lock_irqsave+0x20/0x60
softirqs last  enabled at (105853): [<c0042f60>] irq_exit+0x50/0x64
softirqs last disabled at (105832): [<c0042f60>] irq_exit+0x50/0x64
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2465 lockdep_trace_alloc+0xac/0xec()
Modules linked in: b43(+) ssb mac80211 mxc_pcmcia
---[ end trace 7a542bbcadb0bb88 ]---
ssb: Sonics Silicon Backplane found on PCMCIA device pcmcia0.0
b43-phy0: Broadcom 4318 WLAN found (core revision 9)
b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
phy0: Selected rate control algorithm 'minstrel'
Broadcom 43xx driver loaded [ Features: M, Firmware-ID: FW13 ]

And then when I do ifconfig wlan0 up:

b43 ssb0:0: firmware: requesting b43/ucode5.fw
b43 ssb0:0: firmware: requesting b43/pcm5.fw
b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 ERROR: Initial Values Firmware file-format error.
b43-phy0 ERROR: You must go to
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware
and download the correct firmware for this driver version. Please
carefully read all instructions on this website.

I am using firmware broadcom-wl-4.150.10.5 extracted with
b43-fwcutter-012 as described
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware


Any ideas why the versions don't match?
The firmware files are arch independant right? (since I run fwcutter
on x86 and run the kernel on ARM)

Kernel version is 2.6.32-rc5
The PCMCIA controller driver is new (I recently posted it to
linux-pcmcia and linux-arm)

Cheers,

Martin
