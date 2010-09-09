Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34075 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0IIAuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 20:50:46 -0400
Received: by iwn5 with SMTP id 5so518623iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 17:50:45 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 8 Sep 2010 17:50:25 -0700
Message-ID: <AANLkTim1G_bgGK4X1ThkSaW2+hEqLXjy=cUct-P8vFU3@mail.gmail.com>
Subject: reproducing ath9k TX DMA in 100 msec after killing last frame
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Amod Bodas <Amod.Bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a way to reproduce once! Lets see if it was by luck...

Sep  8 17:18:37 tux kernel: [ 7789.510077] No probe response from AP
02:23:76:82:36:16 after 500ms, try 1
Sep  8 17:18:38 tux kernel: [ 7790.010076] No probe response from AP
02:23:76:82:36:16 after 500ms, try 2
Sep  8 17:18:53 tux kernel: [ 7805.206862] wlan37: deauthenticated
from 02:23:76:82:36:16 (Reason: 1)
Sep  8 17:18:53 tux kernel: [ 7805.250071] phy0: Removed STA 02:23:76:82:36:16
Sep  8 17:18:53 tux kernel: [ 7805.250111] phy0: Destroyed STA 02:23:76:82:36:16
Sep  8 17:18:53 tux kernel: [ 7805.250116] phy0: device now idle
Sep  8 17:18:53 tux kernel: [ 7805.256628] cfg80211: All devices are
disconnected, going to restore regulatory settings
Sep  8 17:18:53 tux kernel: [ 7805.256632] cfg80211: Restoring
regulatory settings
Sep  8 17:18:53 tux kernel: [ 7805.256636] cfg80211: Calling CRDA to
update world regulatory domain
Sep  8 17:18:53 tux kernel: [ 7805.271195] cfg80211: World regulatory
domain updated:
Sep  8 17:18:53 tux kernel: [ 7805.271198]     (start_freq - end_freq
@ bandwidth), (max_antenna_gain, max_eirp)
Sep  8 17:18:53 tux kernel: [ 7805.271201]     (2402000 KHz - 2472000
KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  8 17:18:53 tux kernel: [ 7805.271204]     (2457000 KHz - 2482000
KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  8 17:18:53 tux kernel: [ 7805.271206]     (2474000 KHz - 2494000
KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  8 17:18:53 tux kernel: [ 7805.271208]     (5170000 KHz - 5250000
KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  8 17:18:53 tux kernel: [ 7805.271210]     (5735000 KHz - 5835000
KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  8 17:18:53 tux kernel: [ 7805.366167] phy0: device no longer idle
- scanning
Sep  8 17:18:56 tux kernel: [ 7808.156499] wlan37: authenticate with
02:23:76:82:36:16 (try 1)
Sep  8 17:18:56 tux kernel: [ 7808.250134] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:56 tux kernel: [ 7808.350075] wlan37: authenticate with
02:23:76:82:36:16 (try 2)
Sep  8 17:18:56 tux kernel: [ 7808.350098] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:56 tux kernel: [ 7808.450078] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:56 tux kernel: [ 7808.550060] wlan37: authenticate with
02:23:76:82:36:16 (try 3)
Sep  8 17:18:56 tux kernel: [ 7808.550080] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:56 tux kernel: [ 7808.650064] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7808.750061] wlan37: authentication with
02:23:76:82:36:16 timed out
Sep  8 17:18:57 tux kernel: [ 7808.800080] phy0: device now idle
Sep  8 17:18:57 tux kernel: [ 7808.806296] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7808.900108] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.000030] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.100068] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.210061] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.310063] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.410198] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.510065] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.613680] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:57 tux kernel: [ 7809.715056] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7809.810062] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7809.910066] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.010053] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.110245] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.210068] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.310065] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.410055] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.510059] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.610063] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:58 tux kernel: [ 7810.710084] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7810.810077] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7810.910077] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.010077] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.117792] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.210057] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.313458] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.410054] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.510065] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.613797] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:18:59 tux kernel: [ 7811.710056] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7811.810068] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7811.910065] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7812.010079] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7812.110023] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7812.220078] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7812.320023] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7812.420083] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7812.520078] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:00 tux kernel: [ 7812.620070] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7812.720054] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7812.820064] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7812.920035] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7813.020055] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7813.120078] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7813.220032] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7813.320066] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7813.420055] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7813.520035] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:01 tux kernel: [ 7813.620064] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:02 tux kernel: [ 7813.720057] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:02 tux kernel: [ 7813.807319] phy0: device no longer idle
- scanning
Sep  8 17:19:02 tux kernel: [ 7813.820071] wlan37: dropped data frame
to not associated station 00:00:00:00:00:00
Sep  8 17:19:04 tux kernel: [ 7816.596578] phy0: device now idle
Sep  8 17:19:09 tux kernel: [ 7821.590826] phy0: device no longer idle
- scanning
Sep  8 17:19:12 tux kernel: [ 7824.386516] phy0: device now idle
Sep  8 17:19:17 tux kernel: [ 7829.385579] phy0: device no longer idle
- scanning
Sep  8 17:19:20 tux kernel: [ 7832.216456] phy0: device now idle
Sep  8 17:19:25 tux kernel: [ 7837.215613] phy0: device no longer idle
- scanning
Sep  8 17:19:28 tux kernel: [ 7839.996524] phy0: device now idle
Sep  8 17:19:33 tux kernel: [ 7844.993853] phy0: device no longer idle
- scanning
Sep  8 17:19:36 tux kernel: [ 7847.786576] phy0: device now idle
Sep  8 17:19:41 tux kernel: [ 7852.780913] phy0: device no longer idle
- scanning
Sep  8 17:19:43 tux kernel: [ 7855.566602] phy0: device now idle
Sep  8 17:19:48 tux kernel: [ 7860.565641] phy0: device no longer idle
- scanning
Sep  8 17:19:51 tux kernel: [ 7863.426827] phy0: device now idle
Sep  8 17:19:56 tux kernel: [ 7868.425678] phy0: device no longer idle
- scanning
Sep  8 17:19:59 tux kernel: [ 7871.266673] phy0: device now idle
Sep  8 17:20:04 tux kernel: [ 7876.263363] phy0: device no longer idle
- scanning
Sep  8 17:20:07 tux kernel: [ 7879.056678] phy0: device now idle
Sep  8 17:20:12 tux kernel: [ 7884.053155] phy0: device no longer idle
- scanning
Sep  8 17:20:15 tux kernel: [ 7886.846581] phy0: device now idle
Sep  8 17:20:20 tux kernel: [ 7891.841048] phy0: device no longer idle
- scanning
Sep  8 17:20:22 tux kernel: [ 7894.656476] phy0: device now idle
Sep  8 17:20:27 tux kernel: [ 7899.655655] phy0: device no longer idle
- scanning
Sep  8 17:20:30 tux kernel: [ 7902.496769] phy0: device now idle
Sep  8 17:20:35 tux kernel: [ 7907.492615] phy0: device no longer idle
- scanning
Sep  8 17:20:38 tux kernel: [ 7910.329523] phy0: device now idle
Sep  8 17:20:43 tux kernel: [ 7915.326128] phy0: device no longer idle
- scanning
Sep  8 17:20:46 tux kernel: [ 7918.126440] phy0: device now idle
Sep  8 17:20:51 tux kernel: [ 7923.122338] phy0: device no longer idle
- scanning
Sep  8 17:20:54 tux kernel: [ 7925.936853] phy0: device now idle
Sep  8 17:20:59 tux kernel: [ 7930.935618] phy0: device no longer idle
- scanning
Sep  8 17:21:02 tux kernel: [ 7933.766660] phy0: device now idle
Sep  8 17:21:07 tux kernel: [ 7938.765609] phy0: device no longer idle
- scanning
Sep  8 17:21:09 tux kernel: [ 7941.566598] phy0: device now idle
Sep  8 17:21:14 tux kernel: [ 7946.563477] phy0: device no longer idle
- scanning
Sep  8 17:21:17 tux kernel: [ 7949.359516] phy0: device now idle
Sep  8 17:21:22 tux kernel: [ 7954.354267] phy0: device no longer idle
- scanning
Sep  8 17:21:25 tux kernel: [ 7957.176500] phy0: device now idle
Sep  8 17:21:30 tux kernel: [ 7962.170794] phy0: device no longer idle
- scanning
Sep  8 17:21:33 tux kernel: [ 7964.986495] phy0: device now idle
Sep  8 17:21:38 tux kernel: [ 7969.985634] phy0: device no longer idle
- scanning
Sep  8 17:21:41 tux kernel: [ 7972.806646] phy0: device now idle
Sep  8 17:21:46 tux kernel: [ 7977.805585] phy0: device no longer idle
- scanning
Sep  8 17:21:48 tux kernel: [ 7980.626447] phy0: device now idle
Sep  8 17:21:53 tux kernel: [ 7985.624768] phy0: device no longer idle
- scanning
Sep  8 17:21:56 tux kernel: [ 7988.416475] phy0: device now idle
Sep  8 17:22:01 tux kernel: [ 7993.410872] phy0: device no longer idle
- scanning
Sep  8 17:22:04 tux kernel: [ 7996.216475] phy0: device now idle
Sep  8 17:22:09 tux kernel: [ 8001.215635] phy0: device no longer idle
- scanning
Sep  8 17:22:12 tux kernel: [ 8004.016567] phy0: device now idle
Sep  8 17:22:17 tux kernel: [ 8009.015650] phy0: device no longer idle
- scanning
Sep  8 17:22:20 tux kernel: [ 8011.866487] phy0: device now idle
Sep  8 17:22:25 tux kernel: [ 8016.865703] phy0: device no longer idle
- scanning
Sep  8 17:22:27 tux kernel: [ 8019.686763] phy0: device now idle
Sep  8 17:22:32 tux kernel: [ 8024.682479] phy0: device no longer idle
- scanning
Sep  8 17:22:35 tux kernel: [ 8027.506556] phy0: device now idle
Sep  8 17:22:40 tux kernel: [ 8032.501704] phy0: device no longer idle
- scanning
Sep  8 17:22:43 tux kernel: [ 8035.276803] phy0: device now idle
Sep  8 17:22:48 tux kernel: [ 8040.275747] phy0: device no longer idle
- scanning
Sep  8 17:22:51 tux kernel: [ 8043.076475] phy0: device now idle
Sep  8 17:22:56 tux kernel: [ 8048.075629] phy0: device no longer idle
- scanning
Sep  8 17:22:59 tux kernel: [ 8050.926547] phy0: device now idle
Sep  8 17:23:04 tux kernel: [ 8055.924893] phy0: device no longer idle
- scanning
Sep  8 17:23:07 tux kernel: [ 8058.736991] phy0: device now idle
Sep  8 17:23:12 tux kernel: [ 8063.731313] phy0: device no longer idle
- scanning
Sep  8 17:23:14 tux kernel: [ 8066.546480] phy0: device now idle
Sep  8 17:23:19 tux kernel: [ 8071.540706] phy0: device no longer idle
- scanning
Sep  8 17:23:22 tux kernel: [ 8074.366578] phy0: device now idle
Sep  8 17:23:27 tux kernel: [ 8079.362608] phy0: device no longer idle
- scanning
Sep  8 17:23:30 tux kernel: [ 8082.166417] phy0: device now idle
Sep  8 17:23:35 tux kernel: [ 8087.165674] phy0: device no longer idle
- scanning
Sep  8 17:23:38 tux kernel: [ 8089.966605] phy0: device now idle
Sep  8 17:23:43 tux kernel: [ 8094.962581] phy0: device no longer idle
- scanning
Sep  8 17:23:46 tux kernel: [ 8097.786813] phy0: device now idle
Sep  8 17:23:51 tux kernel: [ 8102.782062] phy0: device no longer idle
- scanning
Sep  8 17:23:53 tux kernel: [ 8105.566532] phy0: device now idle
Sep  8 17:23:58 tux kernel: [ 8110.565720] phy0: device no longer idle
- scanning
Sep  8 17:24:01 tux kernel: [ 8113.356496] phy0: device now idle
Sep  8 17:24:06 tux kernel: [ 8118.355643] phy0: device no longer idle
- scanning
Sep  8 17:24:09 tux kernel: [ 8121.256574] phy0: device now idle
Sep  8 17:24:14 tux kernel: [ 8126.253798] phy0: device no longer idle
- scanning
Sep  8 17:24:17 tux kernel: [ 8129.076496] phy0: device now idle
Sep  8 17:24:22 tux kernel: [ 8134.072247] phy0: device no longer idle
- scanning
Sep  8 17:24:25 tux kernel: [ 8136.866450] phy0: device now idle
Sep  8 17:24:30 tux kernel: [ 8141.861026] phy0: device no longer idle
- scanning
Sep  8 17:24:32 tux kernel: [ 8144.656517] phy0: device now idle
Sep  8 17:24:37 tux kernel: [ 8149.652609] phy0: device no longer idle
- scanning
Sep  8 17:24:40 tux kernel: [ 8152.436446] phy0: device now idle
Sep  8 17:24:45 tux kernel: [ 8157.432603] phy0: device no longer idle
- scanning
Sep  8 17:24:48 tux kernel: [ 8160.296595] phy0: device now idle
Sep  8 17:24:53 tux kernel: [ 8165.292627] phy0: device no longer idle
- scanning
Sep  8 17:24:56 tux kernel: [ 8168.086448] phy0: device now idle
Sep  8 17:25:01 tux kernel: [ 8173.081408] phy0: device no longer idle
- scanning
Sep  8 17:25:04 tux kernel: [ 8175.877571] phy0: device now idle
Sep  8 17:25:09 tux kernel: [ 8180.872631] phy0: device no longer idle
- scanning
Sep  8 17:25:11 tux kernel: [ 8183.676542] phy0: device now idle
Sep  8 17:25:16 tux kernel: [ 8188.675628] phy0: device no longer idle
- scanning
Sep  8 17:25:19 tux kernel: [ 8191.476599] phy0: device now idle
Sep  8 17:25:24 tux kernel: [ 8196.475625] phy0: device no longer idle
- scanning
Sep  8 17:25:27 tux kernel: [ 8199.276619] phy0: device now idle
Sep  8 17:25:32 tux kernel: [ 8204.272599] phy0: device no longer idle
- scanning
Sep  8 17:25:35 tux kernel: [ 8207.126417] phy0: device now idle
Sep  8 17:25:40 tux kernel: [ 8212.121282] phy0: device no longer idle
- scanning
Sep  8 17:25:43 tux kernel: [ 8214.939159] phy0: device now idle
Sep  8 17:25:48 tux kernel: [ 8219.938259] phy0: device no longer idle
- scanning
Sep  8 17:25:51 tux kernel: [ 8222.756532] phy0: device now idle
Sep  8 17:25:56 tux kernel: [ 8227.752622] phy0: device no longer idle
- scanning
Sep  8 17:25:58 tux kernel: [ 8230.566457] phy0: device now idle
Sep  8 17:26:03 tux kernel: [ 8235.564779] phy0: device no longer idle
- scanning
Sep  8 17:26:06 tux kernel: [ 8238.406700] phy0: device now idle
Sep  8 17:26:11 tux kernel: [ 8243.402620] phy0: device no longer idle
- scanning
Sep  8 17:26:14 tux kernel: [ 8246.216502] phy0: device now idle
Sep  8 17:26:19 tux kernel: [ 8251.215671] phy0: device no longer idle
- scanning
Sep  8 17:26:22 tux kernel: [ 8254.032471] phy0: device now idle
Sep  8 17:26:27 tux kernel: [ 8259.031243] phy0: device no longer idle
- scanning
Sep  8 17:26:30 tux kernel: [ 8261.826567] phy0: device now idle
Sep  8 17:26:35 tux kernel: [ 8266.822608] phy0: device no longer idle
- scanning
Sep  8 17:26:37 tux kernel: [ 8269.606495] phy0: device now idle
Sep  8 17:26:42 tux kernel: [ 8274.600840] phy0: device no longer idle
- scanning
Sep  8 17:26:45 tux kernel: [ 8277.443465] phy0: device now idle
Sep  8 17:26:50 tux kernel: [ 8282.437891] phy0: device no longer idle
- scanning
Sep  8 17:26:53 tux kernel: [ 8285.246842] phy0: device now idle
Sep  8 17:26:58 tux kernel: [ 8290.245704] phy0: device no longer idle
- scanning
Sep  8 17:27:01 tux kernel: [ 8293.046716] phy0: device now idle
Sep  8 17:27:06 tux kernel: [ 8298.042603] phy0: device no longer idle
- scanning
Sep  8 17:27:09 tux kernel: [ 8300.866469] phy0: device now idle
Sep  8 17:27:14 tux kernel: [ 8305.864835] phy0: device no longer idle
- scanning
Sep  8 17:27:16 tux kernel: [ 8308.691223] phy0: device now idle
Sep  8 17:27:21 tux kernel: [ 8313.693486] phy0: device no longer idle
- scanning
Sep  8 17:27:24 tux kernel: [ 8316.476449] phy0: device now idle
Sep  8 17:27:29 tux kernel: [ 8321.472575] phy0: device no longer idle
- scanning
Sep  8 17:27:32 tux kernel: [ 8324.275072] phy0: device now idle
Sep  8 17:27:37 tux kernel: [ 8329.270912] phy0: device no longer idle
- scanning
Sep  8 17:27:40 tux kernel: [ 8332.117050] phy0: device now idle
Sep  8 17:27:45 tux kernel: [ 8337.120321] phy0: device no longer idle
- scanning
Sep  8 17:27:48 tux kernel: [ 8339.956359] phy0: device now idle
Sep  8 17:27:53 tux kernel: [ 8344.951557] phy0: device no longer idle
- scanning
Sep  8 17:27:56 tux kernel: [ 8347.859273] phy0: device now idle
Sep  8 17:28:01 tux kernel: [ 8352.855088] phy0: device no longer idle
- scanning
Sep  8 17:28:03 tux kernel: [ 8355.646339] phy0: device now idle
Sep  8 17:28:08 tux kernel: [ 8360.645801] phy0: device no longer idle
- scanning
Sep  8 17:28:11 tux kernel: [ 8363.498998] phy0: device now idle
Sep  8 17:28:16 tux kernel: [ 8368.498452] phy0: device no longer idle
- scanning
Sep  8 17:28:19 tux kernel: [ 8371.326324] phy0: device now idle
Sep  8 17:28:24 tux kernel: [ 8376.324070] phy0: device no longer idle
- scanning
Sep  8 17:28:27 tux kernel: [ 8379.126593] phy0: device now idle
Sep  8 17:28:32 tux kernel: [ 8384.123114] phy0: device no longer idle
- scanning
Sep  8 17:28:35 tux kernel: [ 8386.940349] phy0: device now idle
Sep  8 17:28:40 tux kernel: [ 8391.933758] phy0: device no longer idle
- scanning
Sep  8 17:28:43 tux kernel: [ 8394.736407] phy0: device now idle
Sep  8 17:28:48 tux kernel: [ 8399.735633] phy0: device no longer idle
- scanning
Sep  8 17:28:50 tux kernel: [ 8402.566318] phy0: device now idle
Sep  8 17:28:55 tux kernel: [ 8407.562614] phy0: device no longer idle
- scanning
Sep  8 17:28:58 tux kernel: [ 8410.356330] phy0: device now idle
Sep  8 17:29:03 tux kernel: [ 8415.354290] phy0: device no longer idle
- scanning
Sep  8 17:29:06 tux kernel: [ 8418.166371] phy0: device now idle
Sep  8 17:29:11 tux kernel: [ 8423.161763] phy0: device no longer idle
- scanning
Sep  8 17:29:14 tux kernel: [ 8425.956857] phy0: device now idle
Sep  8 17:29:19 tux kernel: [ 8430.955609] phy0: device no longer idle
- scanning
Sep  8 17:29:22 tux kernel: [ 8433.766430] phy0: device now idle
Sep  8 17:29:27 tux kernel: [ 8438.762618] phy0: device no longer idle
- scanning
Sep  8 17:29:29 tux kernel: [ 8441.586435] phy0: device now idle
Sep  8 17:29:34 tux kernel: [ 8446.582605] phy0: device no longer idle
- scanning
Sep  8 17:29:37 tux kernel: [ 8449.436619] phy0: device now idle
Sep  8 17:29:42 tux kernel: [ 8454.433490] phy0: device no longer idle
- scanning
Sep  8 17:29:45 tux kernel: [ 8457.276345] phy0: device now idle
Sep  8 17:29:50 tux kernel: [ 8462.271131] phy0: device no longer idle
- scanning
Sep  8 17:29:53 tux kernel: [ 8465.091517] phy0: device now idle
Sep  8 17:29:58 tux kernel: [ 8470.090979] phy0: device no longer idle
- scanning
Sep  8 17:30:01 tux kernel: [ 8472.876312] phy0: device now idle
Sep  8 17:30:06 tux kernel: [ 8477.875606] phy0: device no longer idle
- scanning
Sep  8 17:30:08 tux kernel: [ 8480.666354] phy0: device now idle
Sep  8 17:30:13 tux kernel: [ 8485.663606] phy0: device no longer idle
- scanning
Sep  8 17:30:16 tux kernel: [ 8488.459297] phy0: device now idle
Sep  8 17:30:21 tux kernel: [ 8493.455526] phy0: device no longer idle
- scanning
Sep  8 17:30:24 tux kernel: [ 8496.236311] phy0: device now idle
Sep  8 17:30:29 tux kernel: [ 8501.232607] phy0: device no longer idle
- scanning
Sep  8 17:30:32 tux kernel: [ 8504.026332] phy0: device now idle
Sep  8 17:30:37 tux kernel: [ 8509.025614] phy0: device no longer idle
- scanning
Sep  8 17:30:40 tux kernel: [ 8511.816533] phy0: device now idle
Sep  8 17:30:45 tux kernel: [ 8516.815713] phy0: device no longer idle
- scanning
Sep  8 17:30:47 tux kernel: [ 8519.596518] phy0: device now idle
Sep  8 17:30:52 tux kernel: [ 8524.592336] phy0: device no longer idle
- scanning
Sep  8 17:30:55 tux kernel: [ 8527.386363] phy0: device now idle
Sep  8 17:31:00 tux kernel: [ 8532.381486] phy0: device no longer idle
- scanning
Sep  8 17:31:03 tux kernel: [ 8535.176351] phy0: device now idle
Sep  8 17:31:08 tux kernel: [ 8540.172611] phy0: device no longer idle
- scanning
Sep  8 17:31:11 tux kernel: [ 8542.996350] phy0: device now idle
Sep  8 17:31:16 tux kernel: [ 8547.992603] phy0: device no longer idle
- scanning
Sep  8 17:31:19 tux kernel: [ 8550.796581] phy0: device now idle
Sep  8 17:31:24 tux kernel: [ 8555.791548] phy0: device no longer idle
- scanning
Sep  8 17:31:26 tux kernel: [ 8558.586356] phy0: device now idle
Sep  8 17:31:31 tux kernel: [ 8563.581794] phy0: device no longer idle
- scanning
Sep  8 17:31:34 tux kernel: [ 8566.366489] phy0: device now idle
Sep  8 17:31:39 tux kernel: [ 8571.363051] phy0: device no longer idle
- scanning
Sep  8 17:31:42 tux kernel: [ 8574.146321] phy0: device now idle
Sep  8 17:31:47 tux kernel: [ 8579.145608] phy0: device no longer idle
- scanning
Sep  8 17:31:50 tux kernel: [ 8581.936308] phy0: device now idle
Sep  8 17:31:55 tux kernel: [ 8586.935590] phy0: device no longer idle
- scanning
Sep  8 17:31:58 tux kernel: [ 8589.726491] phy0: device now idle
Sep  8 17:32:03 tux kernel: [ 8594.723418] phy0: device no longer idle
- scanning
Sep  8 17:32:05 tux kernel: [ 8597.516354] phy0: device now idle
Sep  8 17:32:10 tux kernel: [ 8602.511540] phy0: device no longer idle
- scanning
Sep  8 17:32:13 tux kernel: [ 8605.296474] phy0: device now idle
Sep  8 17:32:18 tux kernel: [ 8610.292611] phy0: device no longer idle
- scanning
Sep  8 17:32:21 tux kernel: [ 8613.086386] phy0: device now idle
Sep  8 17:32:26 tux kernel: [ 8618.085698] phy0: device no longer idle
- scanning
Sep  8 17:32:29 tux kernel: [ 8620.886318] phy0: device now idle
Sep  8 17:32:34 tux kernel: [ 8625.880915] phy0: device no longer idle
- scanning
Sep  8 17:32:36 tux kernel: [ 8628.668947] phy0: device now idle
Sep  8 17:32:41 tux kernel: [ 8633.664243] phy0: device no longer idle
- scanning
Sep  8 17:32:44 tux kernel: [ 8636.476851] phy0: device now idle
Sep  8 17:32:49 tux kernel: [ 8641.475621] phy0: device no longer idle
- scanning
Sep  8 17:32:52 tux kernel: [ 8644.276349] phy0: device now idle
Sep  8 17:32:57 tux kernel: [ 8649.275622] phy0: device no longer idle
- scanning
Sep  8 17:33:00 tux kernel: [ 8652.066314] phy0: device now idle
Sep  8 17:33:05 tux kernel: [ 8657.063397] phy0: device no longer idle
- scanning
Sep  8 17:33:08 tux kernel: [ 8659.876366] phy0: device now idle
Sep  8 17:33:13 tux kernel: [ 8664.872598] phy0: device no longer idle
- scanning
Sep  8 17:33:15 tux kernel: [ 8667.666412] phy0: device now idle
Sep  8 17:33:20 tux kernel: [ 8672.661712] phy0: device no longer idle
- scanning
Sep  8 17:33:23 tux kernel: [ 8675.446360] phy0: device now idle
Sep  8 17:33:28 tux kernel: [ 8680.445584] phy0: device no longer idle
- scanning
Sep  8 17:33:31 tux kernel: [ 8683.236457] phy0: device now idle
Sep  8 17:33:36 tux kernel: [ 8688.232605] phy0: device no longer idle
- scanning
Sep  8 17:33:39 tux kernel: [ 8691.039467] phy0: device now idle
Sep  8 17:33:44 tux kernel: [ 8696.040115] phy0: device no longer idle
- scanning
Sep  8 17:33:47 tux kernel: [ 8698.846307] phy0: device now idle
Sep  8 17:33:52 tux kernel: [ 8703.841296] phy0: device no longer idle
- scanning
Sep  8 17:33:54 tux kernel: [ 8706.646372] phy0: device now idle
Sep  8 17:33:59 tux kernel: [ 8711.640760] phy0: device no longer idle
- scanning
Sep  8 17:34:02 tux kernel: [ 8714.446338] phy0: device now idle
Sep  8 17:34:07 tux kernel: [ 8719.442601] phy0: device no longer idle
- scanning
Sep  8 17:34:10 tux kernel: [ 8722.266313] phy0: device now idle
Sep  8 17:34:15 tux kernel: [ 8727.265591] phy0: device no longer idle
- scanning
Sep  8 17:34:18 tux kernel: [ 8730.076426] phy0: device now idle
Sep  8 17:34:23 tux kernel: [ 8735.074110] phy0: device no longer idle
- scanning
Sep  8 17:34:26 tux kernel: [ 8737.876340] phy0: device now idle
Sep  8 17:34:31 tux kernel: [ 8742.871912] phy0: device no longer idle
- scanning
Sep  8 17:34:33 tux kernel: [ 8745.676333] phy0: device now idle
Sep  8 17:34:38 tux kernel: [ 8750.672616] phy0: device no longer idle
- scanning
Sep  8 17:34:41 tux kernel: [ 8753.569545] phy0: device now idle
Sep  8 17:34:46 tux kernel: [ 8758.568109] phy0: device no longer idle
- scanning
Sep  8 17:34:49 tux kernel: [ 8761.366806] phy0: device now idle
Sep  8 17:34:54 tux kernel: [ 8766.362735] phy0: device no longer idle
- scanning
Sep  8 17:34:57 tux kernel: [ 8769.156299] phy0: device now idle
Sep  8 17:35:02 tux kernel: [ 8774.153124] phy0: device no longer idle
- scanning
Sep  8 17:35:05 tux kernel: [ 8776.936306] phy0: device now idle
Sep  8 17:35:10 tux kernel: [ 8781.930962] phy0: device no longer idle
- scanning
Sep  8 17:35:13 tux kernel: [ 8784.726309] phy0: device now idle
Sep  8 17:35:18 tux kernel: [ 8789.725595] phy0: device no longer idle
- scanning
Sep  8 17:35:20 tux kernel: [ 8792.516378] phy0: device now idle
Sep  8 17:35:25 tux kernel: [ 8797.515556] phy0: device no longer idle
- scanning
Sep  8 17:35:28 tux kernel: [ 8800.296381] phy0: device now idle
Sep  8 17:35:33 tux kernel: [ 8805.291655] phy0: device no longer idle
- scanning
Sep  8 17:35:36 tux kernel: [ 8808.076372] phy0: device now idle
Sep  8 17:35:41 tux kernel: [ 8813.071444] phy0: device no longer idle
- scanning
Sep  8 17:35:44 tux kernel: [ 8815.866306] phy0: device now idle
Sep  8 17:35:49 tux kernel: [ 8820.865563] phy0: device no longer idle
- scanning
Sep  8 17:35:51 tux kernel: [ 8823.646312] phy0: device now idle
Sep  8 17:35:56 tux kernel: [ 8828.645625] phy0: device no longer idle
- scanning
Sep  8 17:35:59 tux kernel: [ 8831.436309] phy0: device now idle
Sep  8 17:36:04 tux kernel: [ 8836.434753] phy0: device no longer idle
- scanning
Sep  8 17:36:07 tux kernel: [ 8839.225269] phy0: device now idle
Sep  8 17:36:12 tux kernel: [ 8844.226882] phy0: device no longer idle
- scanning
Sep  8 17:36:15 tux kernel: [ 8847.026474] phy0: device now idle
Sep  8 17:36:20 tux kernel: [ 8852.021045] phy0: device no longer idle
- scanning
Sep  8 17:36:23 tux kernel: [ 8854.806320] phy0: device now idle
Sep  8 17:36:28 tux kernel: [ 8859.805525] phy0: device no longer idle
- scanning
Sep  8 17:36:30 tux kernel: [ 8862.596381] phy0: device now idle
Sep  8 17:36:35 tux kernel: [ 8867.595602] phy0: device no longer idle
- scanning
Sep  8 17:36:38 tux kernel: [ 8870.376319] phy0: device now idle
Sep  8 17:36:43 tux kernel: [ 8875.373436] phy0: device no longer idle
- scanning
Sep  8 17:36:46 tux kernel: [ 8878.206362] phy0: device now idle
Sep  8 17:36:51 tux kernel: [ 8883.202200] phy0: device no longer idle
- scanning
Sep  8 17:36:54 tux kernel: [ 8886.006570] phy0: device now idle
Sep  8 17:36:59 tux kernel: [ 8891.005597] phy0: device no longer idle
- scanning
Sep  8 17:37:02 tux kernel: [ 8893.796508] phy0: device now idle
Sep  8 17:37:07 tux kernel: [ 8898.795727] phy0: device no longer idle
- scanning
Sep  8 17:37:09 tux kernel: [ 8901.596980] phy0: device now idle
Sep  8 17:37:14 tux kernel: [ 8906.601684] phy0: device no longer idle
- scanning
Sep  8 17:37:17 tux kernel: [ 8909.406417] phy0: device now idle
Sep  8 17:37:22 tux kernel: [ 8914.401733] phy0: device no longer idle
- scanning
Sep  8 17:37:25 tux kernel: [ 8917.196362] phy0: device now idle
Sep  8 17:37:30 tux kernel: [ 8922.191159] phy0: device no longer idle
- scanning
Sep  8 17:37:33 tux kernel: [ 8924.976493] phy0: device now idle
Sep  8 17:37:38 tux kernel: [ 8929.972604] phy0: device no longer idle
- scanning
Sep  8 17:37:41 tux kernel: [ 8932.806506] phy0: device now idle
Sep  8 17:37:46 tux kernel: [ 8937.805595] phy0: device no longer idle
- scanning
Sep  8 17:37:48 tux kernel: [ 8940.606508] phy0: device now idle
Sep  8 17:37:53 tux kernel: [ 8945.603841] phy0: device no longer idle
- scanning
Sep  8 17:37:56 tux kernel: [ 8948.416431] phy0: device now idle
Sep  8 17:38:01 tux kernel: [ 8953.412600] phy0: device no longer idle
- scanning
Sep  8 17:38:04 tux kernel: [ 8956.206291] phy0: device now idle
Sep  8 17:38:09 tux kernel: [ 8961.205699] phy0: device no longer idle
- scanning
Sep  8 17:38:12 tux kernel: [ 8964.006379] phy0: device now idle
Sep  8 17:38:17 tux kernel: [ 8969.002605] phy0: device no longer idle
- scanning
Sep  8 17:38:20 tux kernel: [ 8971.786557] phy0: device now idle
Sep  8 17:38:25 tux kernel: [ 8976.785701] phy0: device no longer idle
- scanning
Sep  8 17:38:27 tux kernel: [ 8979.586313] phy0: device now idle
Sep  8 17:38:32 tux kernel: [ 8984.583529] phy0: device no longer idle
- scanning
Sep  8 17:38:35 tux kernel: [ 8987.428990] phy0: device now idle
Sep  8 17:38:40 tux kernel: [ 8992.423924] phy0: device no longer idle
- scanning
Sep  8 17:38:43 tux kernel: [ 8995.246342] phy0: device now idle
Sep  8 17:38:48 tux kernel: [ 9000.245587] phy0: device no longer idle
- scanning
Sep  8 17:38:51 tux kernel: [ 9003.056483] phy0: device now idle
Sep  8 17:38:56 tux kernel: [ 9008.052623] phy0: device no longer idle
- scanning
Sep  8 17:38:59 tux kernel: [ 9010.886339] phy0: device now idle
Sep  8 17:39:04 tux kernel: [ 9015.884621] phy0: device no longer idle
- scanning
Sep  8 17:39:07 tux kernel: [ 9018.737509] phy0: device now idle
Sep  8 17:39:12 tux kernel: [ 9023.737675] phy0: device no longer idle
- scanning
Sep  8 17:39:14 tux kernel: [ 9026.569924] phy0: device now idle
Sep  8 17:39:19 tux kernel: [ 9031.568784] phy0: device no longer idle
- scanning
Sep  8 17:39:22 tux kernel: [ 9034.376366] phy0: device now idle
Sep  8 17:39:27 tux kernel: [ 9039.375623] phy0: device no longer idle
- scanning
Sep  8 17:39:30 tux kernel: [ 9042.166470] phy0: device now idle
Sep  8 17:39:35 tux kernel: [ 9047.162614] phy0: device no longer idle
- scanning
Sep  8 17:39:38 tux kernel: [ 9049.946299] phy0: device now idle
Sep  8 17:39:43 tux kernel: [ 9054.943869] phy0: device no longer idle
- scanning
Sep  8 17:39:46 tux kernel: [ 9057.786450] phy0: device now idle
Sep  8 17:39:51 tux kernel: [ 9062.781416] phy0: device no longer idle
- scanning
Sep  8 17:39:53 tux kernel: [ 9065.639055] phy0: device now idle
Sep  8 17:39:58 tux kernel: [ 9070.638305] phy0: device no longer idle
- scanning
Sep  8 17:40:01 tux kernel: [ 9073.476563] phy0: device now idle
Sep  8 17:40:06 tux kernel: [ 9078.475615] phy0: device no longer idle
- scanning
Sep  8 17:40:09 tux kernel: [ 9081.256319] phy0: device now idle
Sep  8 17:40:14 tux kernel: [ 9086.255010] phy0: device no longer idle
- scanning
Sep  8 17:40:17 tux kernel: [ 9089.036367] phy0: device now idle
Sep  8 17:40:22 tux kernel: [ 9094.032018] phy0: device no longer idle
- scanning
Sep  8 17:40:25 tux kernel: [ 9096.816449] phy0: device now idle
Sep  8 17:40:30 tux kernel: [ 9101.810834] phy0: device no longer idle
- scanning
Sep  8 17:40:32 tux kernel: [ 9104.596516] phy0: device now idle
Sep  8 17:40:37 tux kernel: [ 9109.595700] phy0: device no longer idle
- scanning
Sep  8 17:40:40 tux kernel: [ 9112.376307] phy0: device now idle
Sep  8 17:40:45 tux kernel: [ 9117.375715] phy0: device no longer idle
- scanning
Sep  8 17:40:48 tux kernel: [ 9120.176989] phy0: device now idle
Sep  8 17:40:53 tux kernel: [ 9125.172357] phy0: device no longer idle
- scanning
Sep  8 17:40:56 tux kernel: [ 9127.966423] phy0: device now idle
Sep  8 17:41:01 tux kernel: [ 9132.961909] phy0: device no longer idle
- scanning
Sep  8 17:41:04 tux kernel: [ 9135.856743] phy0: device now idle
Sep  8 17:41:09 tux kernel: [ 9140.852630] phy0: device no longer idle
- scanning
Sep  8 17:41:12 tux kernel: [ 9143.740968] phy0: device now idle
Sep  8 17:41:17 tux kernel: [ 9148.739645] phy0: device no longer idle
- scanning
Sep  8 17:41:19 tux kernel: [ 9151.596392] phy0: device now idle
Sep  8 17:41:24 tux kernel: [ 9156.594159] phy0: device no longer idle
- scanning
Sep  8 17:41:27 tux kernel: [ 9159.386377] phy0: device now idle
Sep  8 17:41:32 tux kernel: [ 9164.381729] phy0: device no longer idle
- scanning
Sep  8 17:41:35 tux kernel: [ 9167.166300] phy0: device now idle
Sep  8 17:41:40 tux kernel: [ 9172.160633] phy0: device no longer idle
- scanning
Sep  8 17:41:43 tux kernel: [ 9174.946300] phy0: device now idle
Sep  8 17:41:48 tux kernel: [ 9179.945590] phy0: device no longer idle
- scanning
Sep  8 17:41:51 tux kernel: [ 9182.726299] phy0: device now idle
Sep  8 17:41:56 tux kernel: [ 9187.724178] phy0: device no longer idle
- scanning
Sep  8 17:41:58 tux kernel: [ 9190.536465] phy0: device now idle
Sep  8 17:42:03 tux kernel: [ 9195.532121] phy0: device no longer idle
- scanning
Sep  8 17:42:06 tux kernel: [ 9198.336426] phy0: device now idle
Sep  8 17:42:11 tux kernel: [ 9203.330799] phy0: device no longer idle
- scanning
Sep  8 17:42:14 tux kernel: [ 9206.166311] phy0: device now idle
Sep  8 17:42:19 tux kernel: [ 9211.162585] phy0: device no longer idle
- scanning
Sep  8 17:42:22 tux kernel: [ 9213.996609] phy0: device now idle
Sep  8 17:42:27 tux kernel: [ 9218.992621] phy0: device no longer idle
- scanning
Sep  8 17:42:30 tux kernel: [ 9221.776386] phy0: device now idle
Sep  8 17:42:35 tux kernel: [ 9226.775541] phy0: device no longer idle
- scanning
Sep  8 17:42:35 tux kernel: [ 9227.528383] ath: Failed to stop TX DMA
in 100 msec after killing last frame
Sep  8 17:42:35 tux kernel: [ 9227.528404] ath: Failed to stop TX DMA.
Resetting hardware!

I did this with AR9280 and compat-wireless-2.6.36-rc3 with some PS fix
patches I have queued up. I just used this supplicant conf file:

mcgrof@tux ~/wpa $ cat mcgrof-nexus.conf
ctrl_interface=/var/run/wpa_supplicant
network={
	ssid="mcgrof-nexus-one"
	scan_ssid=1
	key_mgmt=NONE
}

Then used the supplicant:

sudo wpa_supplicant -i wlan37 -D nl80211 -c mcgrof-nexus.conf

I long had disabled tethering on the Nexus One and noticed after a
while of being disconnected and it going into scanning and idle it
just hits that DMA fail issue. I won't be able to test again for a
while but if someone is interested in fixing or debugging perhaps this
can be tried. This could likely be accelerated by looping with:

while true; do sudo iw dev wlan37 scan; sleep 1; done

  Luis
