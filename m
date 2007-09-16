Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51022 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbXIPWb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 18:31:28 -0400
Message-ID: <46EDAEC3.6020201@lwfinger.net>
Date: Sun, 16 Sep 2007 17:31:31 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: gmccullagh@gmail.com
Subject: [Fwd: [AirForce One 54g] working]
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forwarded to linux-wireless@vger.kernel.org because of "decrypt failed" messages.

-------- Original Message --------
Subject: [AirForce One 54g] working
Resent-Date: Sun, 16 Sep 2007 23:12:55 +0100
Resent-From: Gavin McCullagh <gmccullagh@gmail.com>
Resent-To: bcm43xx-dev@lists.berlios.de
Date: Sun, 16 Sep 2007 22:45:02 +0100
From: Gavin McCullagh <gmccullagh@gmail.com>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
To: bcm43xx-dev@lists.berlios.de

Hi,

I have a linksys WPC54GS pcmcia wifi card.  lspci details below.  I tried
it with the latest firmware and Ubuntu gutsy's 2.6.22-10-generic and
2.6.22-11-generic kernels.  With the former, I got WPA working
intermittently, but not stably (ie it'd die and need the driver reloading).
With the latter, I could only get it working unencrypted (I didn't debug in
detail, but it seemed like it didn't associate so presumaby the link never
came up -- I can give logs and more detail if it's useful).

I went onto the IRC channel and noted the suggestion that I try the
wireless-dev tree (2.6.23-rc4).  So I did and I'm glad to say successfully.
I'm using it now and have been for the past 6-8 hours on and off without
any reboot or problems.  I guess it's possible it would also work with the
current 2.6.23-rc6 development kernel.  Perhaps I'll try and check that in
due course.

A couple of things worth mentioning.

1. I've been getting tonnes of syslog errors like this:
	Sep 16 21:46:59 tilly kernel: [ 5171.869169] CCMP: decrypt failed: STA=00:09:5b:d2:f0:2f
	Sep 16 21:46:59 tilly kernel: [ 5171.872336] CCMP: decrypt failed: STA=00:18:84:11:78:d6
	Sep 16 21:47:05 tilly kernel: [ 5174.178449] printk: 122 messages suppressed.
   which all seem to correspond to packets tranferred between my AP and
   a second netgear laptop with an atheros chipset.  So it's not a worry.
   ifconfig shows a collossal packet drop count, which seems to
   approximately equal the number of packets sent+rec'd  by the other
   laptop so I guess it's the same error as above.  Perhaps there's a good
   debug reason for these printk statements, but they have their cost on the
   machine.

2. The quoted signal strength is 50% even when I have the AP and card right
   next to each other.  It doesn't bother me, but I wonder if it's correct
   or not.

I wrote up a howto for Ubuntu here as I suspect others might be interested
to try it out.

https://help.ubuntu.com/community/WifiDocs/Device/Broadcom_BCM4318_%5bAirForce_One_54g%5d_%28Native_Driver%29#preview

Gavin

gavinmc@tilly:~$ lspci -v -s 02:00.0
02:00.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g]
802.11g Wireless LAN Controller (rev 02)
        Subsystem: Linksys Unknown device 0049
        Flags: bus master, fast devsel, latency 64, IRQ 10
        Memory at 24000000 (32-bit, non-prefetchable) [size=8K]

gavinmc@tilly:~$ lspci -vn -s 02:00.0
02:00.0 0280: 14e4:4318 (rev 02)
        Subsystem: 1737:0049
        Flags: bus master, fast devsel, latency 64, IRQ 10
        Memory at 24000000 (32-bit, non-prefetchable) [size=8K]


_______________________________________________
Bcm43xx-dev mailing list
Bcm43xx-dev@lists.berlios.de
https://lists.berlios.de/mailman/listinfo/bcm43xx-dev

