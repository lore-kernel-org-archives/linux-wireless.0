Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.teufel.de ([81.17.209.37]:64127 "EHLO
	mail-out.teufel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDOJf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 05:35:57 -0400
Received: from local.teufel.de ([192.168.181.16])
	by mail-out.teufel.de (Kerio Connect 8.0.1)
	(using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
	for linux-wireless@vger.kernel.org;
	Tue, 15 Apr 2014 11:30:44 +0200
Received: from localhost ([127.0.0.1])
	by local.teufel.de
	(using TLSv1/SSLv3 with cipher AES128-SHA (128 bits))
	for linux-wireless@vger.kernel.org;
	Tue, 15 Apr 2014 11:30:45 +0200
Message-ID: <534CFC45.90101@teufel.de> (sfid-20140415_113610_131137_DFDE9338)
Date: Tue, 15 Apr 2014 11:30:45 +0200
From: Michael Hirsch <hirsch@teufel.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Connection drop while running iperf on ARM based platform
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have an issue using a with RT5572 chipset (TP-Link N600) on a Armada 
based embedded system.

After connecting to an AP and using iperf to stress-test the USB Wifi 
Dongle stops receiving data. Kernel version is 3.14, it happens both on 
firmware version 0.29 and 0.33.


iperf -c 192.168.44.170 -i 1 -t 1000 &
# ------------------------------------------------------------
Client connecting to 192.168.44.170, TCP port 5001
TCP window size: 43.8 KByte (default)
------------------------------------------------------------
[  3] local 192.168.44.245 port 55342 connected with 192.168.44.170 port 
5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  2.12 MBytes  17.8 Mbits/sec
[  147.046945] ieee80211 phy2: rt2800usb_watchdog: Warning - TX HW queue 
1 timed out, invoke forced kick
[  3]  1.0- 2.0 sec  2.25 MBytes  18.9 Mbits/sec
[  148.046626] ieee80211 phy2: rt2800usb_watchdog: Warning - TX HW queue 
1 timed out, invoke forced kick
[  148.058795] ieee80211 phy2: rt2800usb_txdone: Warning - Got TX status 
for an empty queue 3, dropping
[  3]  2.0- 3.0 sec  1.50 MBytes  12.6 Mbits/sec
[  3]  3.0- 4.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3]  4.0- 5.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3]  5.0- 6.0 sec  2.12 MBytes  17.8 Mbits/sec
[  3]  6.0- 7.0 sec  2.12 MBytes  17.8 Mbits/sec
[  3]  7.0- 8.0 sec  2.38 MBytes  19.9 Mbits/sec
[  3]  8.0- 9.0 sec  2.12 MBytes  17.8 Mbits/sec
[  155.047086] ieee80211 phy2: rt2800usb_watchdog: Warning - TX HW queue 
1 timed out, invoke forced kick
[  155.067200] ieee80211 phy2: rt2800usb_txdone: Warning - Got TX status 
for an empty queue 3, dropping
[  3]  9.0-10.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3] 10.0-11.0 sec  2.25 MBytes  18.9 Mbits/sec
[  3] 11.0-12.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3] 12.0-13.0 sec  1.88 MBytes  15.7 Mbits/sec
[  158.343582] ieee80211 phy2: rt2800usb_txdone: Warning - Got TX status 
for an empty queue 3, dropping
[  3] 13.0-14.0 sec  1.62 MBytes  13.6 Mbits/sec
[  3] 14.0-15.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3] 15.0-16.0 sec  2.25 MBytes  18.9 Mbits/sec
[  162.116741] ieee80211 phy2: rt2800usb_txdone: Warning - Got TX status 
for an empty queue 3, dropping
[  3] 16.0-17.0 sec  2.25 MBytes  18.9 Mbits/sec
[  3] 17.0-18.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3] 18.0-19.0 sec  1.62 MBytes  13.6 Mbits/sec
[  3] 19.0-20.0 sec  2.12 MBytes  17.8 Mbits/sec
[  3] 20.0-21.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3] 21.0-22.0 sec  1.62 MBytes  13.6 Mbits/sec
[  3] 22.0-23.0 sec  1.50 MBytes  12.6 Mbits/sec
[  3] 23.0-24.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3] 24.0-25.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3] 25.0-26.0 sec  1.50 MBytes  12.6 Mbits/sec
[  171.816309] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 14 in queue 2
[  171.827208] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 14 in queue 2
[  171.838062] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 14 in queue 2
[  171.848877] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 14 in queue 2
[  171.859690] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 14 in queue 2
[  171.870544] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 15 in queue 2
[  171.881371] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 15 in queue 2
[  171.892183] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 0 in queue 2
[  171.902905] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 0 in queue 2
[  171.913630] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 1 in queue 2
[  171.924348] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 1 in queue 2
[  171.935094] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 2 in queue 2
[  171.945816] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 2 in queue 2
[  171.956571] ieee80211 phy2: rt2800usband_entry_txstatus_timeout: 
Warning - TX status timeout for entry 3 in queue 2
[  171.967293] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 3 in queue 2
[  171.978020] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 4 in queue 2
[  171.988754] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 4 in queue 2
[  171.999496] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 5 in queue 2
[  172.010217] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 5 in queue 2
[  172.022059] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 5 in queue 2
[  172.033004] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 6 in queue 2
[  172.043807] ieee80211 phy2: rt2800usb_entry_txstatus_timeout: Warning 
- TX status timeout for entry 6 in queue 2

and it stops.

I noticed
iw dev wlan1 link shows a tx bitrate of 1.0 MBit/s and according to iw 
it does not receive any packets any more.

Running the same wifi module on a x86 Laptop with 3.14 kernel works better.

There is also drops to 0 at running iperf, but it seems to be able to 
recover. Also on a x86 laptops is see the TX Status timeout messages (if 
it's enabled in the kernel config). I followed the discussion a bit 
about those messages and can't say whether these messages have anything 
todo with shown issue (no packets received)

Any suggestion where I could start searching? For me it looks like a 
rate-control issue, but that's speculation.

Best regards

Michael



