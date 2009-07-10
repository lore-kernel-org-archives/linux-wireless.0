Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46154 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZGJJb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 05:31:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: Fwd: 4318 misbehaving with bleeding edge kernels
Date: Fri, 10 Jul 2009 11:31:41 +0200
Cc: bcm43xx-dev@lists.berlios.de, Celejar <celejar@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Message-Id: <200907101131.41781.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


----------  Forwarded Message  ----------

Subject: 4318 misbehaving with bleeding edge kernels
Date: Friday 10 July 2009
From: Celejar <celejar@gmail.com>
To: bcm43xx-dev <bcm43xx-dev@lists.berlios.de>

Hi,

I have a 4318 (rev 02), which has been working fine with b43.
Recently, with 2.6.31-rc2 kernels from the wireless-testing git repo,
I've been having trouble.  Sometimes the card simply fails to associate
after doing 'iwconfig eth0 essid xxxx'.  It doesn't even seem to try;
i.e., when it does associate, I see log entries like these:

Jul 10 02:25:19 lizzie kernel: [  318.302652] eth0: direct probe to AP 00:1a:70:f5:76:7e (try 1)
Jul 10 02:25:19 lizzie kernel: [  318.310396] eth0 direct probe responded
Jul 10 02:25:19 lizzie kernel: [  318.310401] eth0: authenticate with AP 00:1a:70:f5:76:7e (try 1)
Jul 10 02:25:19 lizzie kernel: [  318.312273] eth0: authenticated
Jul 10 02:25:19 lizzie kernel: [  318.510040] eth0: associate with AP 00:1a:70:f5:76:7e (try 1)
Jul 10 02:25:19 lizzie kernel: [  318.511947] eth0: RX AssocResp from 00:1a:70:f5:76:7e (capab=0x401 status=0 aid=1)
Jul 10 02:25:19 lizzie kernel: [  318.511952] eth0: associated
Jul 10 02:25:19 lizzie kernel: [  318.513218] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

but often I see nothing in the logs at all, and iwconfig shows
"Not-associated".  I just keep repeating the 'iwconfig eth0 essid xxxx'
command until it finally takes, and then the connection seems to behave
normally.  When the card is not functioning, trying 'iwlist eth0 scan'
initially gives:

~# iwlist eth0 scan
eth0      Failed to read scan data : Resource temporarily unavailable

and subsequent invocations, when the card is still not working, gives:

~# iwlist eth0 scan
eth0      Interface doesn't support scanning : Device or resource busy

When the card resumes functioning, scanning works correctly.

I have tried both the old and new firmware, with similar results.  Any
ideas?

>From lspci -v:

06:02.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller (rev 02)
	Subsystem: AMBIT Microsystem Corp. TravelMate 2410
	Flags: bus master, fast devsel, latency 64, IRQ 22
	Memory at d0002000 (32-bit, non-prefetchable) [size=8K]
	Kernel driver in use: b43-pci-bridge

uname -a:

Linux lizzie 2.6.31-rc2-wl-lizzie-27873-ga483c23-dirty #4 Thu Jul 9 19:13:30 EDT 2009 i686 GNU/Linux

Celejar
--
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

_______________________________________________
Bcm43xx-dev mailing list
Bcm43xx-dev@lists.berlios.de
https://lists.berlios.de/mailman/listinfo/bcm43xx-dev


-------------------------------------------------------

-- 
Greetings, Michael.
