Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:34275 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462Ab2E1Mxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 08:53:53 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: ath9k-devel@lists.ath9k.org
Subject: ath9k stops working (DMA trouble?) shortly after going online
Date: Mon, 28 May 2012 13:16:14 +0100
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201205281316.15008.tvrtko.ursulin@onelan.co.uk> (sfid-20120528_145358_608329_50D2B42D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi all,

This is on kernel 3.3.2, with the following hardware:

03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)

dmesg below. I wonder if this is a known issue and I should try
X, Y or Z for a fix? Or any other info / debugging you would like
me to do just ask.

Many thanks,

Tvrtko

[  228.410407] wlan0: direct probe to 00:24:82:39:da:c8 (try 1/3)
[  228.411988] wlan0: direct probe responded
[  228.413683] wlan0: authenticate with 00:24:82:39:da:c8 (try 1)
[  228.415073] wlan0: authenticated
[  228.430703] wlan0: associate with 00:24:82:39:da:c8 (try 1)
[  228.432663] wlan0: RX AssocResp from 00:24:82:39:da:c8 (capab=0x411 status=0 aid=1)
[  228.432676] wlan0: associated
[  228.432685] wlan0: moving STA 00:24:82:39:da:c8 to state 1
[  228.432690] wlan0: moving STA 00:24:82:39:da:c8 to state 2
[  228.432696] wlan0: No basic rates in AssocResp. Using min supported rate instead.
[  228.441326] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  228.441611] cfg80211: Calling CRDA for country: GB
[  228.448130] ath: regdomain 0x833a updated by CountryIE
[  228.448136] ath: EEPROM regdomain: 0x833a
[  228.448139] ath: EEPROM indicates we should expect a country code
[  228.448144] ath: doing EEPROM country->regdmn map search
[  228.448147] ath: country maps to regdmn code: 0x37
[  228.448150] ath: Country alpha2 being used: GB
[  228.448153] ath: Regpair used: 0x37
[  228.448209] cfg80211: Regulatory domain changed to country: GB
[  228.448213] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  228.448217] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  228.448221] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  228.448225] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  228.448229] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  229.716719] wlan0: moving STA 00:24:82:39:da:c8 to state 3
[  594.531570] ath: Failed to stop TX DMA, queues=0x004!
[  594.544193] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x000062c0
[  594.544199] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  626.232518] ath: Failed to stop TX DMA, queues=0x007!
[  626.245494] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x000067c0
[  626.245505] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  626.256935] wlan0: moving STA 00:24:82:39:da:c8 to state 2
[  626.256942] wlan0: moving STA 00:24:82:39:da:c8 to state 1
[  626.256946] wlan0: moving STA 00:24:82:39:da:c8 to state 0
[  626.259715] cfg80211: Calling CRDA to update world regulatory domain
[  626.268224] cfg80211: World regulatory domain updated:
[  626.268232] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  626.268239] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  626.268244] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  626.268250] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  626.268255] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  626.268260] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  626.268296] cfg80211: Calling CRDA for country: GB
[  626.281740] cfg80211: Regulatory domain changed to country: GB
[  626.281752] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  626.281761] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  626.281770] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  626.281778] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  626.281785] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  630.669794] wlan0: authenticate with 00:24:82:39:da:c8 (try 1)
[  630.671400] wlan0: authenticated
[  630.672791] wlan0: associate with 00:24:82:39:da:c8 (try 1)
[  630.674800] wlan0: RX ReassocResp from 00:24:82:39:da:c8 (capab=0x411 status=0 aid=1)
[  630.674809] wlan0: associated
[  630.674817] wlan0: moving STA 00:24:82:39:da:c8 to state 1
[  630.674820] wlan0: moving STA 00:24:82:39:da:c8 to state 2
[  630.674826] wlan0: No basic rates in AssocResp. Using min supported rate instead.
[  630.683677] cfg80211: Calling CRDA for country: GB
[  630.692040] ath: regdomain 0x833a updated by CountryIE
[  630.692047] ath: EEPROM regdomain: 0x833a
[  630.692050] ath: EEPROM indicates we should expect a country code
[  630.692054] ath: doing EEPROM country->regdmn map search
[  630.692058] ath: country maps to regdmn code: 0x37
[  630.692061] ath: Country alpha2 being used: GB
[  630.692063] ath: Regpair used: 0x37
[  630.692118] cfg80211: Regulatory domain changed to country: GB
[  630.692121] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  630.692126] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  630.692130] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  630.692134] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  630.692138] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  630.890348] wlan0: moving STA 00:24:82:39:da:c8 to state 3
[  912.230314] ath: Failed to stop TX DMA, queues=0x007!
[  912.243238] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x000062c0
[  912.243248] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  912.255151] wlan0: moving STA 00:24:82:39:da:c8 to state 2
[  912.255160] wlan0: moving STA 00:24:82:39:da:c8 to state 1
[  912.255164] wlan0: moving STA 00:24:82:39:da:c8 to state 0
[  912.256048] cfg80211: Calling CRDA to update world regulatory domain
[  912.264500] cfg80211: World regulatory domain updated:
[  912.264507] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  912.264513] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  912.264517] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  912.264522] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  912.264526] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  912.264530] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  912.264550] cfg80211: Calling CRDA for country: GB
[  912.277624] cfg80211: Regulatory domain changed to country: GB
[  912.277632] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  912.277638] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  912.277643] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  912.277648] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  912.277652] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  916.666092] wlan0: authenticate with 00:24:82:39:da:c8 (try 1)
[  916.667497] wlan0: authenticated
[  916.667922] wlan0: associate with 00:24:82:39:da:c8 (try 1)
[  916.669899] wlan0: RX ReassocResp from 00:24:82:39:da:c8 (capab=0x411 status=0 aid=1)
[  916.669912] wlan0: associated
[  916.669924] wlan0: moving STA 00:24:82:39:da:c8 to state 1
[  916.669931] wlan0: moving STA 00:24:82:39:da:c8 to state 2
[  916.669940] wlan0: No basic rates in AssocResp. Using min supported rate instead.
[  916.679385] cfg80211: Calling CRDA for country: GB
[  916.687438] ath: regdomain 0x833a updated by CountryIE
[  916.687444] ath: EEPROM regdomain: 0x833a
[  916.687447] ath: EEPROM indicates we should expect a country code
[  916.687451] ath: doing EEPROM country->regdmn map search
[  916.687454] ath: country maps to regdmn code: 0x37
[  916.687458] ath: Country alpha2 being used: GB
[  916.687460] ath: Regpair used: 0x37
[  916.687518] cfg80211: Regulatory domain changed to country: GB
[  916.687521] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  916.687526] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  916.687530] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  916.687534] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  916.687538] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  916.865443] wlan0: moving STA 00:24:82:39:da:c8 to state 3
[ 1037.234003] ath: Failed to stop TX DMA, queues=0x007!
[ 1037.246980] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x000062c0
[ 1037.246990] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1037.259604] wlan0: moving STA 00:24:82:39:da:c8 to state 2
[ 1037.259617] wlan0: moving STA 00:24:82:39:da:c8 to state 1
[ 1037.259625] wlan0: moving STA 00:24:82:39:da:c8 to state 0
[ 1037.267160] cfg80211: Calling CRDA to update world regulatory domain
[ 1037.280243] cfg80211: World regulatory domain updated:
[ 1037.280252] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1037.280257] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1037.280262] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1037.280266] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1037.280271] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1037.280275] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1037.280334] cfg80211: Calling CRDA for country: GB
[ 1037.293496] cfg80211: Regulatory domain changed to country: GB
[ 1037.293503] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1037.293508] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1037.293512] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1037.293516] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1037.293520] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[ 1037.677515] ath: Failed to stop TX DMA, queues=0x001!
[ 1037.690726] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1037.690736] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1037.766026] ath: Failed to stop TX DMA, queues=0x001!
[ 1037.779267] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1037.779278] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1037.853895] ath: Failed to stop TX DMA, queues=0x001!
[ 1037.866839] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1037.866845] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1037.941186] ath: Failed to stop TX DMA, queues=0x001!
[ 1037.954408] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1037.954418] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.028899] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.041798] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1038.041803] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.115927] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.128837] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.128843] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.203239] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.216506] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.216516] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.291031] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.304069] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.304075] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.379281] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.392528] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.392538] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.467257] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.480396] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.480406] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.555375] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.568592] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.568602] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.643291] ath: Failed to stop TX DMA, queues=0x001!
[ 1038.656526] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.656536] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.801886] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.801900] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1038.946423] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1038.946439] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1039.091380] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1039.091395] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1039.236286] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1039.236301] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1039.381051] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1039.381060] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1039.526343] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1039.526358] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1039.671709] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1039.671724] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1039.817304] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1039.817319] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1039.962424] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1039.962439] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1040.107396] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1040.107411] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1040.252486] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1040.252501] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1040.397395] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1040.397409] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1040.542392] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1040.542407] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1040.687369] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1040.687385] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1040.832296] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1040.832314] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1040.977099] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1040.977110] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1041.122315] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1041.122331] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1041.267236] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1041.267251] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1041.412253] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1041.412263] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1041.557420] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1041.557435] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1041.702354] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1041.702369] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1041.847331] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1041.847347] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1041.992260] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1041.992275] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1042.137278] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1042.137293] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1042.282021] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1042.282031] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1042.427392] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1042.427406] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1042.572078] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1042.572087] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1047.581356] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1047.581371] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1047.655973] ath: Failed to stop TX DMA, queues=0x001!
[ 1047.668918] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1047.668923] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1047.743298] ath: Failed to stop TX DMA, queues=0x001!
[ 1047.756517] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1047.756527] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1047.831443] ath: Failed to stop TX DMA, queues=0x001!
[ 1047.844618] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1047.844628] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1047.919536] ath: Failed to stop TX DMA, queues=0x001!
[ 1047.932807] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1047.932818] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.007632] ath: Failed to stop TX DMA, queues=0x001!
[ 1048.020754] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1048.020764] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.095332] ath: Failed to stop TX DMA, queues=0x001!
[ 1048.108596] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1048.108606] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.183755] ath: Failed to stop TX DMA, queues=0x001!
[ 1048.197020] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1048.197031] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.271916] ath: Failed to stop TX DMA, queues=0x001!
[ 1048.284876] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1048.284881] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.359270] ath: Failed to stop TX DMA, queues=0x001!
[ 1048.372504] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1048.372514] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.448820] ath: Failed to stop TX DMA, queues=0x001!
[ 1048.462098] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1048.462108] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.537261] ath: Failed to stop TX DMA, queues=0x001!
[ 1048.550461] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1048.550471] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.695330] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1048.695345] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.840033] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1048.840042] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1048.984342] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1048.984356] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1049.129409] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1049.129424] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1049.274384] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1049.274399] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1049.420255] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1049.420272] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1049.565373] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1049.565390] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1049.710580] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1049.710595] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1049.856408] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1049.856423] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1050.001452] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1050.001467] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1050.146462] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1050.146477] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1050.291382] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1050.291399] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1050.436246] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1050.436261] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1050.581037] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1050.581046] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1050.726343] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1050.726359] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1050.871394] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1050.871410] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1051.018460] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1051.018476] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1051.163294] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1051.163305] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1051.308394] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1051.308409] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1051.453435] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1051.453451] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1051.598334] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1051.598350] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1051.743420] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1051.743435] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1051.888385] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1051.888400] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1052.033408] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1052.033422] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1052.178436] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1052.178452] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1052.323409] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1052.323424] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1052.468436] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1052.468451] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1057.473846] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1057.473861] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1057.548157] ath: Failed to stop TX DMA, queues=0x001!
[ 1057.561358] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1057.561368] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1057.636154] ath: Failed to stop TX DMA, queues=0x001!
[ 1057.649399] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1057.649409] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1057.724193] ath: Failed to stop TX DMA, queues=0x001!
[ 1057.737409] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1057.737421] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1057.812310] ath: Failed to stop TX DMA, queues=0x001!
[ 1057.825516] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1057.825526] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1057.900146] ath: Failed to stop TX DMA, queues=0x001!
[ 1057.913342] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1057.913353] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1057.988190] ath: Failed to stop TX DMA, queues=0x001!
[ 1058.001407] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.001417] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.076127] ath: Failed to stop TX DMA, queues=0x001!
[ 1058.089370] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.089380] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.164262] ath: Failed to stop TX DMA, queues=0x001!
[ 1058.177464] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.177475] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.252146] ath: Failed to stop TX DMA, queues=0x001!
[ 1058.265308] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.265318] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.340389] ath: Failed to stop TX DMA, queues=0x001!
[ 1058.353569] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.353579] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.428225] ath: Failed to stop TX DMA, queues=0x001!
[ 1058.441466] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.441476] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.586368] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.586383] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.731394] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1058.731409] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1058.876382] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1058.876397] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1059.021447] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1059.021462] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1059.166366] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1059.166382] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1059.311356] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1059.311370] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1059.456369] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1059.456384] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1059.601291] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1059.601306] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1059.746397] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1059.746412] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1059.891343] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1059.891358] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1060.036435] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1060.036450] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1060.181498] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1060.181513] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1060.326381] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1060.326396] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1060.471354] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1060.471368] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1060.616395] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1060.616411] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1060.761369] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1060.761383] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1060.906210] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1060.906225] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1061.051344] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1061.051359] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1061.196354] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1061.196370] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1061.341328] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1061.341343] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1061.486262] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1061.486278] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1061.631319] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1061.631335] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1061.776370] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1061.776385] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1061.921369] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1061.921385] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1062.066331] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1062.066345] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1062.211313] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1062.211328] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1062.356435] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1062.356450] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.362236] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1067.362251] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.437216] ath: Failed to stop TX DMA, queues=0x001!
[ 1067.450436] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1067.450447] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.525145] ath: Failed to stop TX DMA, queues=0x001!
[ 1067.538372] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1067.538382] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.613066] ath: Failed to stop TX DMA, queues=0x001!
[ 1067.626296] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1067.626306] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.701155] ath: Failed to stop TX DMA, queues=0x001!
[ 1067.714396] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1067.714406] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.789193] ath: Failed to stop TX DMA, queues=0x001!
[ 1067.802397] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1067.802407] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.877353] ath: Failed to stop TX DMA, queues=0x001!
[ 1067.890446] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1067.890456] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1067.965170] ath: Failed to stop TX DMA, queues=0x001!
[ 1067.978384] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1067.978394] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.053110] ath: Failed to stop TX DMA, queues=0x001!
[ 1068.066348] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1068.066358] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.141184] ath: Failed to stop TX DMA, queues=0x001!
[ 1068.154397] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1068.154408] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.229391] ath: Failed to stop TX DMA, queues=0x001!
[ 1068.242578] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1068.242588] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.317129] ath: Failed to stop TX DMA, queues=0x001!
[ 1068.330344] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1068.330354] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.475222] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1068.475238] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.620331] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1068.620346] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.765329] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1068.765345] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1068.910410] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1068.910426] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1069.055425] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1069.055439] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1069.200423] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1069.200438] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1069.345344] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1069.345359] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1069.490397] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1069.490412] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1069.635378] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1069.635392] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1069.780459] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1069.780474] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1069.925291] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1069.925306] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1070.070342] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1070.070356] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1070.215422] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1070.215436] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1070.360356] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1070.360371] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1070.505353] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1070.505368] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1070.650342] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1070.650357] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1070.795314] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1070.795329] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1070.940442] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1070.940457] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1071.085395] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1071.085410] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1071.230379] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1071.230394] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1071.375354] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1071.375369] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1071.520266] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1071.520281] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1071.665195] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1071.665210] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1071.810223] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1071.810239] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1071.955409] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1071.955424] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1072.100389] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1072.100404] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1072.245710] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1072.245725] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.252855] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1077.252870] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.327154] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.340347] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1077.340357] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.415356] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.428554] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1077.428565] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.503202] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.516481] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1077.516491] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.591176] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.604412] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1077.604422] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.679195] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.692413] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1077.692423] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.767185] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.780370] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1077.780380] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.855016] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.868052] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1077.868059] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1077.942082] ath: Failed to stop TX DMA, queues=0x001!
[ 1077.955266] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1077.955276] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.030276] ath: Failed to stop TX DMA, queues=0x001!
[ 1078.043396] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1078.043406] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.118200] ath: Failed to stop TX DMA, queues=0x001!
[ 1078.131482] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1078.131493] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.206269] ath: Failed to stop TX DMA, queues=0x001!
[ 1078.219492] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1078.219502] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.364357] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1078.364372] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.509424] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1078.509439] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.654799] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1078.654814] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.800392] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1078.800407] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1078.945342] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1078.945357] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1079.090395] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1079.090410] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1079.235139] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1079.235148] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1079.380434] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1079.380449] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1079.525398] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1079.525412] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1079.670393] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1079.670408] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1079.815393] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1079.815408] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1079.960328] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1079.960344] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1080.105344] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1080.105359] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1080.250356] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1080.250370] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1080.395421] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1080.395436] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1080.540367] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1080.540383] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1080.685341] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1080.685356] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1080.830328] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1080.830343] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1080.975342] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1080.975356] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1081.120381] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1081.120396] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1081.265410] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1081.265426] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1081.410378] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1081.410393] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1081.555303] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1081.555318] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1081.700435] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1081.700450] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1081.845318] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1081.845333] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1081.990327] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1081.990342] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.135072] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1082.135081] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.210081] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.210096] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.285349] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.298609] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.298620] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.373247] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.386460] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.386470] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.461556] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.474805] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.474815] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.549311] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.562530] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.562540] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.637225] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.650395] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.650405] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.725176] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.738424] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.738434] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.813139] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.826332] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1082.826342] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.901221] ath: Failed to stop TX DMA, queues=0x001!
[ 1082.914453] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1082.914463] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1082.989177] ath: Failed to stop TX DMA, queues=0x001!
[ 1083.002401] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1083.002412] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1083.077146] ath: Failed to stop TX DMA, queues=0x001!
[ 1083.090238] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1083.090248] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1083.165271] ath: Failed to stop TX DMA, queues=0x001!
[ 1083.178466] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1083.178476] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1083.323396] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1083.323410] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1083.468385] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1083.468400] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1083.613341] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1083.613356] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1083.758393] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1083.758407] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1083.903342] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1083.903357] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1084.048383] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1084.048397] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1084.193386] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1084.193401] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1084.338314] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1084.338329] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1084.483354] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1084.483370] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1084.628341] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1084.628357] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1084.773341] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1084.773356] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1084.918317] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1084.918331] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1085.063335] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1085.063351] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1085.208451] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1085.208466] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1085.353327] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1085.353342] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1085.498420] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1085.498435] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1085.643393] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1085.643408] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1085.788238] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1085.788250] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1085.933250] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1085.933265] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1086.078397] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1086.078411] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1086.223410] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1086.223425] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1086.368355] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1086.368370] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1086.513392] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1086.513407] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1086.659300] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1086.659315] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1086.804392] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1086.804407] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1086.949252] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1086.949267] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1087.094368] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1087.094384] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1092.100198] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1092.100213] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1092.175343] ath: Failed to stop TX DMA, queues=0x001!
[ 1092.188590] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[ 1092.188601] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1092.263083] ath: Failed to stop TX DMA, queues=0x001!
[ 1092.276240] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1092.276250] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1092.351232] ath: Failed to stop TX DMA, queues=0x001!
[ 1092.364434] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[ 1092.364445] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
