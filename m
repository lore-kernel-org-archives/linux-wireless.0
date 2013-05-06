Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37186 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3EFEYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 00:24:01 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] initvals: Update initivals for AR9565
Date: Mon,  6 May 2013 09:51:39 +0530
Message-Id: <1367814099-7315-1-git-send-email-sujith@msujith.org> (sfid-20130506_062411_441681_D744AAB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* Register Modification for xLNA board.
* TX gain table modification for zero calibration.
* AUX chain (LNA2) sensitivity enhancement
* Modify diversity bias default setting in INI.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9565_1p0_initvals.h | 138 ++++++++++++++++++-----------------
 tools/initvals/checksums.txt         |  14 ++--
 2 files changed, 77 insertions(+), 75 deletions(-)

diff --git a/tools/initvals/ar9565_1p0_initvals.h b/tools/initvals/ar9565_1p0_initvals.h
index 0c2ac0c..e85a8b0 100644
--- a/tools/initvals/ar9565_1p0_initvals.h
+++ b/tools/initvals/ar9565_1p0_initvals.h
@@ -233,9 +233,9 @@ static const u32 ar9565_1p0_baseband_core[][2] = {
 	{0x00009d10, 0x01834061},
 	{0x00009d14, 0x00c00400},
 	{0x00009d18, 0x00000000},
-	{0x00009e08, 0x0078230c},
-	{0x00009e24, 0x990bb515},
-	{0x00009e28, 0x126f0000},
+	{0x00009e08, 0x0038230c},
+	{0x00009e24, 0x9907b515},
+	{0x00009e28, 0x126f0600},
 	{0x00009e30, 0x06336f77},
 	{0x00009e34, 0x6af6532f},
 	{0x00009e38, 0x0cc80c00},
@@ -337,7 +337,7 @@ static const u32 ar9565_1p0_baseband_core[][2] = {
 
 static const u32 ar9565_1p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8005, 0xd00a800d},
+	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8005, 0xd00a8009},
 	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a01ae},
 	{0x00009824, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x63c640da},
 	{0x00009828, 0x06903081, 0x06903081, 0x06903881, 0x09143c81},
@@ -345,9 +345,9 @@ static const u32 ar9565_1p0_baseband_postamble[][5] = {
 	{0x00009830, 0x0000059c, 0x0000059c, 0x0000059c, 0x0000059c},
 	{0x00009c00, 0x000000c4, 0x000000c4, 0x000000c4, 0x000000c4},
 	{0x00009e00, 0x0372111a, 0x0372111a, 0x037216a0, 0x037216a0},
-	{0x00009e04, 0x00802020, 0x00802020, 0x00802020, 0x00802020},
-	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000d8},
-	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec86d2e},
+	{0x00009e04, 0x00802020, 0x00802020, 0x00142020, 0x00142020},
+	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000e2},
+	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec84d2e},
 	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3379605e, 0x33795d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
@@ -450,6 +450,8 @@ static const u32 ar9565_1p0_soc_postamble[][5] = {
 
 static const u32 ar9565_1p0_Common_rx_gain_table[][2] = {
 	/* Addr      allmodes  */
+	{0x00004050, 0x00300300},
+	{0x0000406c, 0x00100000},
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
 	{0x0000a008, 0x00050004},
@@ -498,27 +500,27 @@ static const u32 ar9565_1p0_Common_rx_gain_table[][2] = {
 	{0x0000a0b4, 0x00000000},
 	{0x0000a0b8, 0x00000000},
 	{0x0000a0bc, 0x00000000},
-	{0x0000a0c0, 0x001f0000},
-	{0x0000a0c4, 0x01000101},
-	{0x0000a0c8, 0x011e011f},
-	{0x0000a0cc, 0x011c011d},
-	{0x0000a0d0, 0x02030204},
-	{0x0000a0d4, 0x02010202},
-	{0x0000a0d8, 0x021f0200},
-	{0x0000a0dc, 0x0302021e},
-	{0x0000a0e0, 0x03000301},
-	{0x0000a0e4, 0x031e031f},
-	{0x0000a0e8, 0x0402031d},
-	{0x0000a0ec, 0x04000401},
-	{0x0000a0f0, 0x041e041f},
-	{0x0000a0f4, 0x0502041d},
-	{0x0000a0f8, 0x05000501},
-	{0x0000a0fc, 0x051e051f},
-	{0x0000a100, 0x06010602},
-	{0x0000a104, 0x061f0600},
-	{0x0000a108, 0x061d061e},
-	{0x0000a10c, 0x07020703},
-	{0x0000a110, 0x07000701},
+	{0x0000a0c0, 0x00bf00a0},
+	{0x0000a0c4, 0x11a011a1},
+	{0x0000a0c8, 0x11be11bf},
+	{0x0000a0cc, 0x11bc11bd},
+	{0x0000a0d0, 0x22632264},
+	{0x0000a0d4, 0x22612262},
+	{0x0000a0d8, 0x227f2260},
+	{0x0000a0dc, 0x4322227e},
+	{0x0000a0e0, 0x43204321},
+	{0x0000a0e4, 0x433e433f},
+	{0x0000a0e8, 0x4462433d},
+	{0x0000a0ec, 0x44604461},
+	{0x0000a0f0, 0x447e447f},
+	{0x0000a0f4, 0x5582447d},
+	{0x0000a0f8, 0x55805581},
+	{0x0000a0fc, 0x559e559f},
+	{0x0000a100, 0x66816682},
+	{0x0000a104, 0x669f6680},
+	{0x0000a108, 0x669d669e},
+	{0x0000a10c, 0x77627763},
+	{0x0000a110, 0x77607761},
 	{0x0000a114, 0x00000000},
 	{0x0000a118, 0x00000000},
 	{0x0000a11c, 0x00000000},
@@ -530,27 +532,27 @@ static const u32 ar9565_1p0_Common_rx_gain_table[][2] = {
 	{0x0000a134, 0x00000000},
 	{0x0000a138, 0x00000000},
 	{0x0000a13c, 0x00000000},
-	{0x0000a140, 0x001f0000},
-	{0x0000a144, 0x01000101},
-	{0x0000a148, 0x011e011f},
-	{0x0000a14c, 0x011c011d},
-	{0x0000a150, 0x02030204},
-	{0x0000a154, 0x02010202},
-	{0x0000a158, 0x021f0200},
-	{0x0000a15c, 0x0302021e},
-	{0x0000a160, 0x03000301},
-	{0x0000a164, 0x031e031f},
-	{0x0000a168, 0x0402031d},
-	{0x0000a16c, 0x04000401},
-	{0x0000a170, 0x041e041f},
-	{0x0000a174, 0x0502041d},
-	{0x0000a178, 0x05000501},
-	{0x0000a17c, 0x051e051f},
-	{0x0000a180, 0x06010602},
-	{0x0000a184, 0x061f0600},
-	{0x0000a188, 0x061d061e},
-	{0x0000a18c, 0x07020703},
-	{0x0000a190, 0x07000701},
+	{0x0000a140, 0x00bf00a0},
+	{0x0000a144, 0x11a011a1},
+	{0x0000a148, 0x11be11bf},
+	{0x0000a14c, 0x11bc11bd},
+	{0x0000a150, 0x22632264},
+	{0x0000a154, 0x22612262},
+	{0x0000a158, 0x227f2260},
+	{0x0000a15c, 0x4322227e},
+	{0x0000a160, 0x43204321},
+	{0x0000a164, 0x433e433f},
+	{0x0000a168, 0x4462433d},
+	{0x0000a16c, 0x44604461},
+	{0x0000a170, 0x447e447f},
+	{0x0000a174, 0x5582447d},
+	{0x0000a178, 0x55805581},
+	{0x0000a17c, 0x559e559f},
+	{0x0000a180, 0x66816682},
+	{0x0000a184, 0x669f6680},
+	{0x0000a188, 0x669d669e},
+	{0x0000a18c, 0x77e677e7},
+	{0x0000a190, 0x77e477e5},
 	{0x0000a194, 0x00000000},
 	{0x0000a198, 0x00000000},
 	{0x0000a19c, 0x00000000},
@@ -770,7 +772,7 @@ static const u32 ar9565_1p0_Modes_lowest_ob_db_tx_gain_table[][5] = {
 
 static const u32 ar9565_1p0_pciephy_clkreq_disable_L1[][2] = {
 	/* Addr      allmodes  */
-	{0x00018c00, 0x18213ede},
+	{0x00018c00, 0x18212ede},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0003780c},
 };
@@ -889,8 +891,8 @@ static const u32 ar9565_1p0_common_wo_xlna_rx_gain_table[][2] = {
 	{0x0000a180, 0x66816682},
 	{0x0000a184, 0x669f6680},
 	{0x0000a188, 0x669d669e},
-	{0x0000a18c, 0x77627763},
-	{0x0000a190, 0x77607761},
+	{0x0000a18c, 0x77e677e7},
+	{0x0000a190, 0x77e477e5},
 	{0x0000a194, 0x00000000},
 	{0x0000a198, 0x00000000},
 	{0x0000a19c, 0x00000000},
@@ -1114,7 +1116,7 @@ static const u32 ar9565_1p0_modes_high_ob_db_tx_gain_table[][5] = {
 	{0x0000a2e0, 0xffecec00, 0xffecec00, 0xfd339c84, 0xfd339c84},
 	{0x0000a2e4, 0xfc0f0000, 0xfc0f0000, 0xfec3e000, 0xfec3e000},
 	{0x0000a2e8, 0xfc100000, 0xfc100000, 0xfffc0000, 0xfffc0000},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
+	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050df, 0x000050df},
 	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
 	{0x0000a504, 0x06002223, 0x06002223, 0x04000002, 0x04000002},
 	{0x0000a508, 0x0b022220, 0x0b022220, 0x08000004, 0x08000004},
@@ -1140,13 +1142,13 @@ static const u32 ar9565_1p0_modes_high_ob_db_tx_gain_table[][5] = {
 	{0x0000a558, 0x69027f56, 0x69027f56, 0x53001ce5, 0x53001ce5},
 	{0x0000a55c, 0x6d029f56, 0x6d029f56, 0x57001ce9, 0x57001ce9},
 	{0x0000a560, 0x73049f56, 0x73049f56, 0x5b001ceb, 0x5b001ceb},
-	{0x0000a564, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
-	{0x0000a568, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
-	{0x0000a56c, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
-	{0x0000a570, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
-	{0x0000a574, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
-	{0x0000a578, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
-	{0x0000a57c, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
+	{0x0000a564, 0x7804ff56, 0x7804ff56, 0x60001cf0, 0x60001cf0},
+	{0x0000a568, 0x7804ff56, 0x7804ff56, 0x61001cf1, 0x61001cf1},
+	{0x0000a56c, 0x7804ff56, 0x7804ff56, 0x62001cf2, 0x62001cf2},
+	{0x0000a570, 0x7804ff56, 0x7804ff56, 0x63001cf3, 0x63001cf3},
+	{0x0000a574, 0x7804ff56, 0x7804ff56, 0x64001cf4, 0x64001cf4},
+	{0x0000a578, 0x7804ff56, 0x7804ff56, 0x66001ff6, 0x66001ff6},
+	{0x0000a57c, 0x7804ff56, 0x7804ff56, 0x66001ff6, 0x66001ff6},
 	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -1174,7 +1176,7 @@ static const u32 ar9565_1p0_modes_high_power_tx_gain_table[][5] = {
 	{0x0000a2e0, 0xffecec00, 0xffecec00, 0xfd339c84, 0xfd339c84},
 	{0x0000a2e4, 0xfc0f0000, 0xfc0f0000, 0xfec3e000, 0xfec3e000},
 	{0x0000a2e8, 0xfc100000, 0xfc100000, 0xfffc0000, 0xfffc0000},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
+	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050df, 0x000050df},
 	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
 	{0x0000a504, 0x06002223, 0x06002223, 0x04000002, 0x04000002},
 	{0x0000a508, 0x0a022220, 0x0a022220, 0x08000004, 0x08000004},
@@ -1200,13 +1202,13 @@ static const u32 ar9565_1p0_modes_high_power_tx_gain_table[][5] = {
 	{0x0000a558, 0x66027f56, 0x66027f56, 0x4c001ce5, 0x4c001ce5},
 	{0x0000a55c, 0x6a029f56, 0x6a029f56, 0x50001ce9, 0x50001ce9},
 	{0x0000a560, 0x70049f56, 0x70049f56, 0x54001ceb, 0x54001ceb},
-	{0x0000a564, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a568, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a56c, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a570, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a574, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a578, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a57c, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
+	{0x0000a564, 0x7504ff56, 0x7504ff56, 0x59001cf0, 0x59001cf0},
+	{0x0000a568, 0x7504ff56, 0x7504ff56, 0x5a001cf1, 0x5a001cf1},
+	{0x0000a56c, 0x7504ff56, 0x7504ff56, 0x5b001cf2, 0x5b001cf2},
+	{0x0000a570, 0x7504ff56, 0x7504ff56, 0x5c001cf3, 0x5c001cf3},
+	{0x0000a574, 0x7504ff56, 0x7504ff56, 0x5d001cf4, 0x5d001cf4},
+	{0x0000a578, 0x7504ff56, 0x7504ff56, 0x5f001ff6, 0x5f001ff6},
+	{0x0000a57c, 0x7504ff56, 0x7504ff56, 0x5f001ff6, 0x5f001ff6},
 	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 7aae7d4..551c3ba 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -194,20 +194,20 @@ b836a622916e66da6a23c9cd34a7d933571ff6db        ar955x_1p0_modes_no_xpa_tx_gain_
 d9efd1c575ac43d60c310d717c59617a5323c111        ar955x_1p0_modes_fast_clock
 839b2486a70775db100fca6421860d4922fbf945        ar9565_1p0_mac_core
 c8dc777b012068116cd5282aade8eb460f397d20        ar9565_1p0_mac_postamble
-be2a958615907b5f7766336b124d79cb3dbb3c1f        ar9565_1p0_baseband_core
-7ae44b5234dc536c5fe3bd484ecbf4bd4f8f8ee1        ar9565_1p0_baseband_postamble
+26297fd915614c1f9ad22fb611335a2ac715a2d9        ar9565_1p0_baseband_core
+e719a3c597fa3511cfb436aeb4cfdda3b5949685        ar9565_1p0_baseband_postamble
 98708e6c8cde013777cd5c5c9ded6dfe038b652f        ar9565_1p0_radio_core
 bc722e44e8c7039983b485fc099275c6629974cf        ar9565_1p0_radio_postamble
 524fae156c2942a28c62603dac8f9ee99ff0e25a        ar9565_1p0_soc_preamble
 b045882e6e5b3f54d9eed19022abe6a44bc04e73        ar9565_1p0_soc_postamble
-bc0a956de3b035894bf68722ca4c8a4365fe0f4b        ar9565_1p0_Common_rx_gain_table
+6af86113836112173aab7266f22acee984d956a9        ar9565_1p0_Common_rx_gain_table
 4bf703cdebf0bfb9ad867cb53b79d6c3957b6f91        ar9565_1p0_Modes_lowest_ob_db_tx_gain_table
-2fbe90336971cd66f0264c0cc57605c2de069d5f        ar9565_1p0_pciephy_clkreq_disable_L1
+a3173672141a2ac797e660228d41a609f9ab2c4c        ar9565_1p0_pciephy_clkreq_disable_L1
 6db24dff7f419466d4734d59063314b9e52d4640        ar9565_1p0_modes_fast_clock
-d297fe8586260e902a2b629323e4802fe207f2b7        ar9565_1p0_common_wo_xlna_rx_gain_table
+9cbace0a26242ed035a0c2fbae7cec34267c7258        ar9565_1p0_common_wo_xlna_rx_gain_table
 4bf703cdebf0bfb9ad867cb53b79d6c3957b6f91        ar9565_1p0_modes_low_ob_db_tx_gain_table
-7e7f55da5f2572348ddf79e41e9ab9647d94caff        ar9565_1p0_modes_high_ob_db_tx_gain_table
-a67925a1d3f3263537a4a0d6096f3f8994190f14        ar9565_1p0_modes_high_power_tx_gain_table
+e1be4dc91b540109b236b6b4002a9108ad3a01de        ar9565_1p0_modes_high_ob_db_tx_gain_table
+19ed468cdcc0c0be512a64d55f40c609e6d75720        ar9565_1p0_modes_high_power_tx_gain_table
 87e0ecae5df96673e22bc448b17d813510964de8        ar9580_1p0_modes_fast_clock
 6b0fb5b3698c99f42a885c8e982ae436363f1865        ar9580_1p0_radio_postamble
 5b81bf27a30c826cfde3e8f6746473e949cb41ef        ar9580_1p0_baseband_core
-- 
1.8.2.2

