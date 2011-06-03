Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54233 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1FCQHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 12:07:04 -0400
Received: by gyd10 with SMTP id 10so803814gyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 09:07:03 -0700 (PDT)
Received: from tomh (localhost [127.0.0.1])
	(Authenticated sender: tom)
	by zooty.my.lan (Postfix) with ESMTPA id 398118848D
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jun 2011 12:07:01 -0400 (EDT)
Date: Fri, 3 Jun 2011 12:07:00 -0400
From: Tom Horsley <horsley1953@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: USB dongle running hotter in new kernel
Message-ID: <20110603120700.07acdaee@tomh> (sfid-20110603_180708_700110_58A75B9B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a Belkin USB dongle I use for an access point via hostapd.
Here's the lsusb info:

Bus 001 Device 004: ID 050d:705a Belkin Components F5D7050 Wireless G Adapter v3000 [Ralink RT2573]

On fedora 14, kernel 2.6.35.13-91.fc14.x86_64 when I have it
plugged in an running with my android phone connected, it gets
warmish, but not too hot.

On fedora 15, kernel 2.6.38.6-27.fc15.x86_64, it gets quite
hot (not enough to raise blisters when I unplug it, but still
noticeably warmer). In fact, I think the heat makes it shut
down because I keep losing wlan0 at random times.

Is there something I can tweak to fix this, or information I
can provide to help understand it? I see various errors in
dmesg when I plug it in, yet it does seem to be working:

[162935.466041] usb 1-3: new high speed USB device using ehci_hcd and address 4
[162935.753964] usb 1-3: New USB device found, idVendor=050d, idProduct=705a
[162935.753971] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=
0
[162935.753978] usb 1-3: Product: Belkin 54g USB Network Adapter
[162935.753982] usb 1-3: Manufacturer: Belkin
[162935.878471] cfg80211: Calling CRDA to update world regulatory domain
[162935.920599] cfg80211: World regulatory domain updated:
[162935.920605]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_
eirp)
[162935.920611]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[162935.920617]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[162935.920622]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[162935.920627]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[162935.920633]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[162936.063578] phy0 -> rt2500usb_init_eeprom: Error - Invalid RT chipset detected.
[162936.063586] phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
[162936.063647] usbcore: registered new interface driver rt2500usb
[162936.370198] phy1: Selected rate control algorithm 'minstrel'
[162936.370663] Registered led device: rt73usb-phy1::radio
[162936.370704] Registered led device: rt73usb-phy1::assoc
[162936.370741] Registered led device: rt73usb-phy1::quality
[162936.371310] usbcore: registered new interface driver rt73usb
[162936.446340] cfg80211: Calling CRDA for country: US
[162936.452577] cfg80211: Regulatory domain changed to country: US
[162936.452581]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[162936.452585]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[162936.452589]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[162936.452593]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[162936.452596]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[162936.452600]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[162936.452603]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[162941.448940] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[162942.035787] Intel AES-NI instructions are not detected.
[162942.049758] padlock: VIA PadLock not detected.
[162952.026015] wlan0: no IPv6 routers present

(the above is from fedora 14 where it is not running too hot).
