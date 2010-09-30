Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.store20.com ([212.7.7.16]:59613 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab0I3RF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 13:05:57 -0400
Received: from chi (161.164.191.90.dyn.estpak.ee [90.191.164.161])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: plaes)
	by store20.com (Postfix) with ESMTPSA id CDF121A0B54
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 19:59:35 +0300 (EEST)
Subject: rt2800usb (RT2870/RT3070) troubles with hwcrypto
From: Priit Laes <plaes@plaes.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 19:59:32 +0300
Message-ID: <1285865972.5204.35.camel@chi>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey!

I recently got following USB wireless dongle:
148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
phy8 -> rt2x00_set_chip: Info - Chipset detected - rt: 3070, rf: 0005, rev: 0201.

The initial impression of this dongle was bad - I couldn't connect to
the local WPA/TKIP network and although initial connection to nearby WEP
network went fine, the connection dropped after less than a minute and I
couldn't reconnect anymore. This was all with firmware version 22.

Thankfully the module has 'nohwcrypto' option - with this everything
works well for a while (~10-15 minutes) but then it disconnets and
connections neither to WPA/TKIP or WEP network succeed.

This is latest Linus's kernel and relevant log (nohwcrypto):
[snip]
[ 4877.757059] usb 1-5: new high speed USB device using ehci_hcd and address 11
[ 4877.908395] phy8 -> rt2x00_set_chip: Info - Chipset detected - rt: 3070, rf: 0005, rev: 0201.
[ 4877.908617] phy8: Selected rate control algorithm 'minstrel_ht'
[ 4877.910071] Registered led device: rt2800usb-phy8::radio
[ 4877.910115] Registered led device: rt2800usb-phy8::assoc
[ 4877.910156] Registered led device: rt2800usb-phy8::quality
[ 4877.972274] udev[32182]: renamed network interface wlan0 to wlan2
[ 4877.980682] phy8 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'.
[ 4877.991466] phy8 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.22.
[ 4878.207281] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
[ 4878.208528] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
[ 4878.209778] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
[ 4878.211031] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
[ 4994.979651] cfg80211: Calling CRDA to update world regulatory domain
[ 4996.325764] wlan2: authenticate with 00:xx:xx:xx:xx:xx (try 1)
[ 4996.327403] wlan2: authenticated
[ 4996.327882] wlan2: associate with 00:xx:xx:xx:xx:xx (try 1)
[ 4996.329901] wlan2: RX AssocResp from 00:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
[ 4996.329907] wlan2: associated
[ 4996.330439] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
[ 4996.332021] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
[ 4996.333388] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
[ 4996.334754] phy8 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
[ 5029.712605] phy8 -> rt2x00usb_watchdog_reset_tx: Warning - TX queue 0 timed out, invoke reset
[ 5036.706050] phy8 -> rt2x00usb_watchdog_reset_tx: Warning - TX queue 0 timed out, invoke reset
[ 5048.706802] phy8 -> rt2x00usb_watchdog_reset_tx: Warning - TX queue 0 timed out, invoke reset
[ 5082.706852] phy8 -> rt2x00usb_watchdog_reset_tx: Warning - TX queue 0 timed out, invoke reset
...
[ 5332.706048] phy8 -> rt2x00usb_watchdog_reset_tx: Warning - TX queue 0 timed out, invoke reset
[ 5332.767054] wlan2: direct probe to 00:xx:xx:xx:xx:xx timed out
[ 5342.706044] phy8 -> rt2x00usb_watchdog_reset_tx: Warning - TX queue 0 timed out, invoke reset
...Tried connecting to another access point, but still no go...
[ 5343.661828] wlan2: direct probe to 00:yy:yy:yy:yy:yy (try 1)
[ 5343.706047] phy8 -> rt2x00usb_watchdog_reset_tx: Warning - TX queue 0 timed out, invoke reset
[ 5343.861046] wlan2: direct probe to 00:yy:yy:yy:yy:yy (try 2)
[ 5344.061046] wlan2: direct probe to 00:yy:yy:yy:yy:yy (try 3)
[ 5344.261045] wlan2: direct probe to 00:yy:yy:yy:yy:yy timed out
....
