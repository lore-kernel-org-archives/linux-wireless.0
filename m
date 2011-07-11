Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from afflict.kos.to ([92.243.29.197]:38373 "EHLO afflict.kos.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab1GKIGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 04:06:39 -0400
Date: Mon, 11 Jul 2011 10:58:38 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: linux-wireless@vger.kernel.org
Subject: carl9170 hangups on traffic (3.0-rc5)
Message-ID: <20110711075838.GA28945@afflict.kos.to> (sfid-20110711_100644_939089_BED76956)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm having trouble on having a stable connection with carl9170 driver
and d-link DWA-160 (A2). When idle or almost idle (ssh etc traffic),
the driver works without issues. However, even medium intensity traffic
(1MB/s) all traffic will soon stop, and the driver will start reconnecting.
This is with a 802.11g wpa-psk network that works fine with iwlagn equipped
laptop and mobile phones.. Usally the only sign in the logs is:

Jul 11 10:47:33 aimless kernel: [ 6130.120936] wlan0: deauthenticating from 00:1d:19:ad:d7:65 by local choice (reason=14)

With then lots of authentication attempts and CRDA noise until succesfully
connecting in a minute. The attached log includes a usb reset and firmware
load which doesn't happen always..

Riku


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="carl9170.txt"

Jul 11 09:05:53 aimless kernel: [    0.000000] Linux version 3.0-3-generic (buildd@yellow) (gcc version 4.6.1 (Ubuntu/Linaro 4.6.0-14ubuntu1) ) #4-Ubuntu SMP Fri Jul 1 08:21:12 UTC 2011 (Ubuntu 3.0-3.4-generic 3.0.0-rc5)
Jul 11 09:05:53 aimless kernel: [    1.420022] usb 1-8: new high speed USB device number 3 using ehci_hcd
Jul 11 09:05:53 aimless kernel: [   24.781437] ath: EEPROM regdomain: 0x80d0
Jul 11 09:05:53 aimless kernel: [   24.781440] ath: EEPROM indicates we should expect a country code
Jul 11 09:05:53 aimless kernel: [   24.781443] ath: doing EEPROM country->regdmn map search
Jul 11 09:05:53 aimless kernel: [   24.781445] ath: country maps to regdmn code: 0x37
Jul 11 09:05:53 aimless kernel: [   24.781447] ath: Country alpha2 being used: DK
Jul 11 09:05:53 aimless kernel: [   24.781449] ath: Regpair used: 0x37
Jul 11 09:05:53 aimless kernel: [   24.786136] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Jul 11 09:05:53 aimless kernel: [   24.786870] cfg80211: Calling CRDA for country: DK
Jul 11 09:05:53 aimless kernel: [   24.787890] Registered led device: carl9170-phy0::tx
Jul 11 09:05:53 aimless kernel: [   24.787915] Registered led device: carl9170-phy0::assoc
Jul 11 09:05:53 aimless kernel: [   24.787920] usb 1-8: Atheros AR9170 is registered as 'phy0'
Jul 11 09:09:08 aimless kernel: [  220.579176] wlan0: authenticated
Jul 11 09:09:08 aimless kernel: [  220.579337] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:09:08 aimless kernel: [  220.582113] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=3)
Jul 11 09:09:08 aimless kernel: [  220.582124] wlan0: associated
Jul 11 09:09:08 aimless kernel: [  220.592609] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jul 11 09:09:08 aimless kernel: [  220.592769] cfg80211: Calling CRDA for country: FI
Jul 11 09:09:14 aimless kernel: [  230.780028] wlan0: no IPv6 routers present
Jul 11 09:15:50 aimless kernel: [  627.305328] ieee80211 phy0: channel change: 2412 -> 2437 failed (2).
Jul 11 09:15:51 aimless kernel: [  627.783022] ieee80211 phy0: channel change: -1 -> 2437 failed (2).
Jul 11 09:15:51 aimless kernel: [  627.783035] usb 1-8: restart device (7)
Jul 11 09:15:52 aimless kernel: [  628.910450] usb 1-8: device restarted successfully.
Jul 11 09:15:52 aimless kernel: [  628.910528] ieee80211 phy0: Hardware restart was requested
Jul 11 09:15:52 aimless kernel: [  629.106142] ieee80211 phy0: channel change: 2437 -> 2417 failed (3).
Jul 11 09:25:44 aimless kernel: [ 1220.467705] ieee80211 phy0: invalid plcp cck rate (0).
Jul 11 09:26:25 aimless kernel: [ 1261.655580] ieee80211 phy0: invalid plcp cck rate (0).
Jul 11 09:31:05 aimless kernel: [ 1541.799451] ieee80211 phy0: invalid plcp cck rate (0).
Jul 11 09:36:37 aimless kernel: [ 1874.337461] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 2)
Jul 11 09:36:37 aimless kernel: [ 1874.353306] cfg80211: All devices are disconnected, going to restore regulatory settings
Jul 11 09:36:41 aimless kernel: [ 1878.392788] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:36:41 aimless kernel: [ 1878.396796] wlan0: authenticated
Jul 11 09:36:41 aimless kernel: [ 1878.396861] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:36:41 aimless kernel: [ 1878.399620] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=2)
Jul 11 09:36:41 aimless kernel: [ 1878.399631] wlan0: associated
Jul 11 09:36:42 aimless kernel: [ 1878.411359] cfg80211: Calling CRDA for country: FI
-hangup happens now and takes a few minutes to recover-
Jul 11 09:53:03 aimless kernel: [ 2860.369956] ieee80211 phy0: lost 7 command responses/traps! w:9 g:0
Jul 11 09:53:03 aimless kernel: [ 2860.369969] usb 1-8: restart device (8)
Jul 11 09:53:03 aimless kernel: [ 2860.370086] ieee80211 phy0: failed to set key (0, 00:1d:19:ad:d7:65) to hardware (-110)
Jul 11 09:53:04 aimless kernel: [ 2861.370051] ieee80211 phy0: writing reg 0x1d0104 (val 0x3) failed (-110)
Jul 11 09:53:05 aimless kernel: [ 2862.370175] usb 1-8: kill pending tx urbs.
Jul 11 09:53:07 aimless kernel: [ 2863.499869] ieee80211 phy0: wrong echo 4a110123 != 0
Jul 11 09:53:07 aimless kernel: [ 2863.499881] usb 1-8: firmware upload failed (-22).
Jul 11 09:53:07 aimless kernel: [ 2863.502136] usb 1-8: Failed to restart device  (-22).
Jul 11 09:53:07 aimless kernel: [ 2863.510747] ieee80211 phy0: writing reg 0x1c36f0 (val 0x5000) failed (-5)
Jul 11 09:53:07 aimless kernel: [ 2863.510756] wlan0: deauthenticating from 00:1d:19:ad:d7:65 by local choice (reason=14)
Jul 11 09:53:07 aimless kernel: [ 2863.580282] cfg80211: All devices are disconnected, going to restore regulatory settings
...lots of cfg80211 spam
Jul 11 09:53:07 aimless kernel: [ 2863.970159] usb 1-8: reset high speed USB device number 3 using ehci_hcd
Jul 11 09:53:08 aimless kernel: [ 2864.750079] usb 1-8: reset high speed USB device number 3 using ehci_hcd
Jul 11 09:53:08 aimless kernel: [ 2864.944378] usb 1-8: driver   API: 1.9.2 2011-01-22 [1-1]
Jul 11 09:53:08 aimless kernel: [ 2864.944388] usb 1-8: firmware API: 1.9.2 2010-12-25
Jul 11 09:53:08 aimless kernel: [ 2865.325260] ath: EEPROM regdomain: 0x80d0
Jul 11 09:53:08 aimless kernel: [ 2865.325267] ath: EEPROM indicates we should expect a country code
Jul 11 09:53:08 aimless kernel: [ 2865.325273] ath: doing EEPROM country->regdmn map search
Jul 11 09:53:08 aimless kernel: [ 2865.325277] ath: country maps to regdmn code: 0x37
Jul 11 09:53:08 aimless kernel: [ 2865.325283] ath: Country alpha2 being used: DK
Jul 11 09:53:08 aimless kernel: [ 2865.325287] ath: Regpair used: 0x37
...lots of cfg80211 spam
Jul 11 09:53:08 aimless kernel: [ 2865.326727] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
Jul 11 09:53:08 aimless kernel: [ 2865.332338] cfg80211: Calling CRDA for country: DK
Jul 11 09:53:08 aimless kernel: [ 2865.335354] Registered led device: carl9170-phy1::tx
Jul 11 09:53:08 aimless kernel: [ 2865.335407] Registered led device: carl9170-phy1::assoc
Jul 11 09:53:08 aimless kernel: [ 2865.335415] usb 1-8: Atheros AR9170 is registered as 'phy1'
...lots of cfg80211 spam
Jul 11 09:53:09 aimless kernel: [ 2865.681421] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 11 09:53:17 aimless kernel: [ 2874.041540] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:17 aimless kernel: [ 2874.043913] wlan0: authenticated
Jul 11 09:53:17 aimless kernel: [ 2874.044089] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:17 aimless kernel: [ 2874.047302] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=2)
Jul 11 09:53:17 aimless kernel: [ 2874.047313] wlan0: associated
Jul 11 09:53:17 aimless kernel: [ 2874.059513] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jul 11 09:53:17 aimless kernel: [ 2874.059695] cfg80211: Calling CRDA for country: FI
Jul 11 09:53:28 aimless kernel: [ 2884.870032] wlan0: no IPv6 routers present
Jul 11 09:53:42 aimless kernel: [ 2899.381878] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:53:47 aimless kernel: [ 2903.421125] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:47 aimless kernel: [ 2903.424754] wlan0: authenticated
Jul 11 09:53:47 aimless kernel: [ 2903.424946] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:47 aimless kernel: [ 2903.428549] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:53:47 aimless kernel: [ 2903.428561] wlan0: associated
Jul 11 09:53:47 aimless kernel: [ 2903.439836] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:53:47 aimless kernel: [ 2903.442045] cfg80211: Calling CRDA for country: FI
Jul 11 09:53:51 aimless kernel: [ 2907.536101] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:51 aimless kernel: [ 2907.538704] wlan0: authenticated
Jul 11 09:53:51 aimless kernel: [ 2907.538867] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:51 aimless kernel: [ 2907.541825] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:53:51 aimless kernel: [ 2907.541834] wlan0: associated
Jul 11 09:53:51 aimless kernel: [ 2907.553132] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:53:51 aimless kernel: [ 2907.553304] cfg80211: Calling CRDA for country: FI
Jul 11 09:53:55 aimless kernel: [ 2911.642142] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:55 aimless kernel: [ 2911.644626] wlan0: authenticated
Jul 11 09:53:55 aimless kernel: [ 2911.644799] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:55 aimless kernel: [ 2911.647616] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:53:55 aimless kernel: [ 2911.647623] wlan0: associated
Jul 11 09:53:55 aimless kernel: [ 2911.658521] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:53:55 aimless kernel: [ 2911.658708] cfg80211: Calling CRDA for country: FI
Jul 11 09:53:59 aimless kernel: [ 2915.751173] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:59 aimless kernel: [ 2915.753662] wlan0: authenticated
Jul 11 09:53:59 aimless kernel: [ 2915.753762] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:53:59 aimless kernel: [ 2915.756671] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:53:59 aimless kernel: [ 2915.756677] wlan0: associated
Jul 11 09:53:59 aimless kernel: [ 2915.765961] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:53:59 aimless kernel: [ 2915.769935] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:03 aimless kernel: [ 2919.865257] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:03 aimless kernel: [ 2919.867733] wlan0: authenticated
Jul 11 09:54:03 aimless kernel: [ 2919.867908] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:03 aimless kernel: [ 2919.870736] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:03 aimless kernel: [ 2919.870744] wlan0: associated
Jul 11 09:54:03 aimless kernel: [ 2919.882510] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:03 aimless kernel: [ 2919.882686] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:07 aimless kernel: [ 2923.983370] show_signal_msg: 24 callbacks suppressed
Jul 11 09:54:07 aimless kernel: [ 2923.983381] wpa_supplicant[1357]: segfault at 20000cd ip 000000000047d516 sp 00007fff71e1ef40 error 4 in wpa_supplicant[400000+d2000]
Jul 11 09:54:07 aimless kernel: [ 2923.985252] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:07 aimless kernel: [ 2923.987816] wlan0: authenticated
Jul 11 09:54:07 aimless kernel: [ 2923.987991] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:07 aimless kernel: [ 2923.991595] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:07 aimless kernel: [ 2923.991606] wlan0: associated
Jul 11 09:54:07 aimless kernel: [ 2924.002661] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:07 aimless kernel: [ 2924.002817] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:07 aimless kernel: [ 2924.050228] wlan0: deauthenticating from 00:1d:19:ad:d7:65 by local choice (reason=3)
Jul 11 09:54:07 aimless kernel: [ 2924.050287] cfg80211: All devices are disconnected, going to restore regulatory settings
Jul 11 09:54:15 aimless kernel: [ 2931.964311] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:15 aimless kernel: [ 2931.967149] wlan0: authenticated
Jul 11 09:54:15 aimless kernel: [ 2931.967198] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:15 aimless kernel: [ 2931.970194] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:15 aimless kernel: [ 2931.970201] wlan0: associated
Jul 11 09:54:15 aimless kernel: [ 2931.984925] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:15 aimless kernel: [ 2931.985483] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:19 aimless kernel: [ 2936.110903] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:19 aimless kernel: [ 2936.114647] wlan0: authenticated
Jul 11 09:54:19 aimless kernel: [ 2936.114709] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:19 aimless kernel: [ 2936.117880] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:19 aimless kernel: [ 2936.117891] wlan0: associated
Jul 11 09:54:19 aimless kernel: [ 2936.128851] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:23 aimless kernel: [ 2940.238323] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:24 aimless kernel: [ 2940.430050] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 2)
Jul 11 09:54:24 aimless kernel: [ 2940.434934] wlan0: authenticated
Jul 11 09:54:24 aimless kernel: [ 2940.435111] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:24 aimless kernel: [ 2940.438780] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:24 aimless kernel: [ 2940.438787] wlan0: associated
Jul 11 09:54:24 aimless kernel: [ 2940.448945] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:24 aimless kernel: [ 2940.449172] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:28 aimless kernel: [ 2944.564312] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:28 aimless kernel: [ 2944.566793] wlan0: authenticated
Jul 11 09:54:28 aimless kernel: [ 2944.566841] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:28 aimless kernel: [ 2944.571173] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:28 aimless kernel: [ 2944.571184] wlan0: associated
Jul 11 09:54:28 aimless kernel: [ 2944.582878] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:28 aimless kernel: [ 2944.584361] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:32 aimless kernel: [ 2948.701782] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:32 aimless kernel: [ 2948.707521] wlan0: authenticated
Jul 11 09:54:32 aimless kernel: [ 2948.707565] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:32 aimless kernel: [ 2948.710903] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:32 aimless kernel: [ 2948.710910] wlan0: associated
Jul 11 09:54:32 aimless kernel: [ 2948.723243] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:32 aimless kernel: [ 2948.728580] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:36 aimless kernel: [ 2952.821301] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:36 aimless kernel: [ 2952.823786] wlan0: authenticated
Jul 11 09:54:36 aimless kernel: [ 2952.823954] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:36 aimless kernel: [ 2952.827403] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:36 aimless kernel: [ 2952.827410] wlan0: associated
Jul 11 09:54:36 aimless kernel: [ 2952.839574] wlan0: deauthenticated from 00:1d:19:ad:d7:65 (Reason: 14)
Jul 11 09:54:36 aimless kernel: [ 2952.839765] cfg80211: Calling CRDA for country: FI
Jul 11 09:54:44 aimless kernel: [ 2961.050667] wlan0: authenticate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:44 aimless kernel: [ 2961.052941] wlan0: authenticated
Jul 11 09:54:44 aimless kernel: [ 2961.053009] wlan0: associate with 00:1d:19:ad:d7:65 (try 1)
Jul 11 09:54:44 aimless kernel: [ 2961.055930] wlan0: RX AssocResp from 00:1d:19:ad:d7:65 (capab=0x431 status=0 aid=1)
Jul 11 09:54:44 aimless kernel: [ 2961.055940] wlan0: associated
Jul 11 09:54:44 aimless kernel: [ 2961.068507] cfg80211: Calling CRDA for country: FI


--0F1p//8PRICkK4MW--
