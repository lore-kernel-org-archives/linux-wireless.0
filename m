Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:40415 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab1CTGYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 02:24:07 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2K6EqHs017321
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 02:14:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 5AEEF1E0390
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 02:14:51 -0400 (EDT)
Message-ID: <4D859B5B.9050305@lockie.ca>
Date: Sun, 20 Mar 2011 02:14:51 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: debugging my card
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm still fighting with my PCI card.
It used to work but I guess the hardware could have died.

It won't get an IP from lbuntu network manager.

Does anyone have any ideas?
I guess one of my next steps is to find a Windows box to try it with.

I booted lbuntu from USB and this is what it sees:

[   14.160380] ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 19
(level, low) -> IRQ 19
[   14.583596] ath: EEPROM regdomain: 0x10
[   14.583599] ath: EEPROM indicates we should expect a direct regpair map
[   14.583602] ath: Country alpha2 being used: CO
[   14.583603] ath: Regpair used: 0x10
[   14.625139] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   14.625720] Registered led device: ath9k-phy0::radio
[   14.625739] Registered led device: ath9k-phy0::assoc
[   14.625756] Registered led device: ath9k-phy0::tx
[   14.625776] Registered led device: ath9k-phy0::rx
[   14.625780] phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
mem=0xf82c0000, irq=19
[   14.625912] cfg80211: Calling CRDA for country: CO
[   14.636694] cfg80211: Regulatory domain changed to country: CO
[   14.636697]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   14.636700]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2700 mBm)
[   14.636703]     (5170000 KHz - 5250000 KHz @ 20000 KHz), (300 mBi,
1700 mBm)
[   14.636705]     (5250000 KHz - 5330000 KHz @ 20000 KHz), (300 mBi,
2300 mBm)
[   14.636707]     (5735000 KHz - 5835000 KHz @ 20000 KHz), (300 mBi,
3000 mBm)
[  142.265205] wlan0: authenticate with 00:18:3f:b6:7d:69 (try 1)
[  142.268896] wlan0: authenticated
[  142.273175] wlan0: associate with 00:18:3f:b6:7d:69 (try 1)
[  142.278909] wlan0: RX AssocResp from 00:18:3f:b6:7d:69 (capab=0x421
status=0 aid=1)
[  142.278918] wlan0: associated
[  142.279566] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  142.279732] cfg80211: Calling CRDA for country: US
[  142.292138] wlan0: deauthenticating from 00:18:3f:b6:7d:69 by local
choice (reason=3)
[  142.294425] cfg80211: Received country IE:
[  142.294433] cfg80211: Regulatory domain: US
[  142.294437]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  142.294444]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (10000 mBi,
2700 mBm)
[  142.294448] cfg80211: CRDA thinks this should applied:
[  142.294452] cfg80211: Regulatory domain: US
[  142.294455]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  142.294461]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2700 mBm)
[  142.294468]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
1700 mBm)
[  142.294474]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  142.294480]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  142.294486]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  142.294492]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
3000 mBm)
[  142.294496] cfg80211: We intersect both of these and get:
[  142.294499] cfg80211: Regulatory domain: 98
[  142.294503]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  142.294509]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2700 mBm)
[  142.294520] cfg80211: Disabling channel 2467 MHz on phy0 due to
Country IE
[  142.294525] cfg80211: Disabling channel 2472 MHz on phy0 due to
Country IE
[  142.294530] cfg80211: Disabling channel 2484 MHz on phy0 due to
Country IE
[  142.294538] cfg80211: Current regulatory domain updated by AP to: US
[  142.294542]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  142.294548]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2700 mBm)
[  142.294983] cfg80211: All devices are disconnected, going to restore
regulatory settings
[  142.294992] cfg80211: Restoring regulatory settings
[  142.295000] cfg80211: Calling CRDA to update world regulatory domain
[  142.310828] cfg80211: World regulatory domain updated:
[  142.310838]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  142.310845]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  142.310852]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[  142.310858]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[  142.310864]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  142.310870]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
