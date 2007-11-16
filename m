Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55689 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752082AbXKPWUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 17:20:06 -0500
Date: Fri, 16 Nov 2007 23:20:01 +0100
From: Edgar Toernig <froese@gmx.de>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>
Subject: [rtl8185] driver working but some probs
Message-Id: <20071116232001.70a4ae77.froese@gmx.de> (sfid-20071116_222012_649808_AD677084)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[I'm new to wlan stuff - be kind to me if I did something
stupid ;-)]

I tried the rtl8180 driver Michael posted on 2007-10-14
( http://marc.info/?m=119238789630565 ).  As he didn't
mentioned what kernel the patch was for I took a 2.6.24
snapshot from about two days ago (v2.6.24-rc2-409-g9418d5d).

There were two compile time problems: the MAC_ARG macro
was missing and the symbols from rtl8180_rtl8225.c clash
with those from rtl8187_rtl8225.c.  One has to choose
either the rtl8187 driver or the rtl8180 driver.

After that, the driver works - mostly.

First thing I noticed: the reported "Link Signal Level"
from iwconfig was way off.  It showed values around
-170 dBm when it was sitting directly beside the AP.
It was easy to fix:

-     rx_status.ssi = (flags2 >> 8) & 0x7F;
+     rx_status.ssi = (flags2 >> 8) & 0xFF;

According to the 8180 datasheet, this field is 8 bit.

While I was there, I also added a check for the rate
field as the later indexed array isn't big enough for
a full 4 bit index:

       rate = (flags >> 20) & 0xF;
+      if (rate > 11)
+              rate = 11;


Still, some problems remain:

First, bit rate almost immediately drops to 1 Mb/s
even if the card sits right beside the AP.  Only
if I force both, card and AP, to a fixed bitrate do
I get reasonable performance (up to about 22 Mb/s,
giving ~1MByte/s payload rate - it seems the laptop
isn't faster; even on wired 100Mb/s ethernet I get
max 2 MByte/s throughput.).

Then, suspend doesn't work.  The driver seems to
work but it won't see its AP any more.  It *can*
see other APs, but not the one he is associated
with.  rmmod/insmod is necessary.

With the last problem I'm not sure whether it's a
driver or a wpa_supplicant problem.  I can't connect
to the AP if the ssid is hidden.  wpa_supplicant stays
in SCANNING mode even though he already has the AP in
his scan list.  Playing around with ap_scan=2 etc
doesn't seem to help.  Any idea?

Anyway, many thanks for a basically working driver.
I hope it gets into mainline.

Ciao, ET.
