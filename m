Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41346 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZFYMZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 08:25:00 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MJo0k-0000vy-8X
	for linux-wireless@vger.kernel.org; Thu, 25 Jun 2009 12:25:02 +0000
Received: from d5153017D.access.telenet.be ([81.83.1.125])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2009 12:25:02 +0000
Received: from Gert.Boddaert by d5153017D.access.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2009 12:25:02 +0000
To: linux-wireless@vger.kernel.org
From: Gert Boddaert <Gert.Boddaert@Boditec.be>
Subject: rt73usb (rt2x00) crash bug on (big-endian) ARM
Date: Thu, 25 Jun 2009 12:18:56 +0000 (UTC)
Message-ID: <loom.20090625T114232-539@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I tested 3 compat-wireless versions:-

we intend to use compat-wireless-2008-04-08. 
For our embedded puposes this is relatively stable (although it contains the
mentioned bug).
Also the stable version compat-wireless-2.6.30 kernel was tested, and the latest
"bleeding edge" compat-wireless-2009-06-25.

The drivers were cross-compiled (after some integration work) with the windriver
toolchain for the big-endian IXP420 (x-scale). 
We are using the 2.6.27.18 kernel.

the rt73usb is used in AP mode through hostapd, after some patching in hostapd
(the TX not acked thing). 
This works remarkably well, accept for the TX rate bug (low throughput ~800Kb/s
from AP to client),
which can be solved in 2008-04-08 by fixing the rate manually (e.g. iwconfig
wlan0 rate 24M). 
I am happy to inform, that in the 2009-06-25 version this particular automatic
rate problem seems solved.

Anyway, the bug I want to post about is presumably somewhere in the RX path of
the rt73usb driver (or related stacked drivers).

When running iperf (iperf -c 192.168.x.y -u -t 10 -i 1 -b 20M -r ) and
increasing the load on the AP-RX-side IXP420 to >12 Mb/s, the system crashes.

We are investigating how to get a decent crash dump from the embedded device,
but that will take some work.
 
I also tested the same setup on a big-endian powerpc-mac G4 (same 2.6.27.18
kernel), but it doesn't crash there probably because the rt73usb is connected to
a USB 1.0/1.1 port and the througput does not rise above 8-9Mb/s.

To summarize...

Problem 1
The device crashes when the load on its RX side goes higher than ~12Mb/s on all
tested driver versions. 
Is this a known big-endian issue or does this also
happen on low-spec'ed i386 processors?

Problem 2, 
related to compat-wireless-2009-06-25: I can no longer connect from Windows XP
to our embedded AP when using this driver (alignment or endianess issue),
although this does work perfectly with the other driver versions.
Strange thing is, that when booting my test laptop into (ubuntu) linux, 
I CAN connect to the embedded AP with the compat-wireless-2009-06-25 driver.



