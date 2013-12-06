Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36061 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3LFLD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:03:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/16] ath9k: Identify duplicate AR9565 v1.0 initvals
Date: Fri,  6 Dec 2013 16:28:49 +0530
Message-Id: <1386327534-31105-12-git-send-email-sujith@msujith.org> (sfid-20131206_120413_955847_23B389F8)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 85 ++--------------------
 1 file changed, 6 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
index a8c757b..10d4a6c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
@@ -20,6 +20,12 @@
 
 /* AR9565 1.0 */
 
+#define ar9565_1p0_mac_postamble ar9331_1p1_mac_postamble
+
+#define ar9565_1p0_Modes_lowest_ob_db_tx_gain_table ar9565_1p0_modes_low_ob_db_tx_gain_table
+
+#define ar9565_1p0_baseband_core_txfir_coeff_japan_2484 ar9300_2p2_baseband_core_txfir_coeff_japan_2484
+
 static const u32 ar9565_1p0_mac_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00000008, 0x00000000},
@@ -182,18 +188,6 @@ static const u32 ar9565_1p0_mac_core[][2] = {
 	{0x000083d0, 0x800301ff},
 };
 
-static const u32 ar9565_1p0_mac_postamble[][5] = {
-	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
-	{0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c},
-	{0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38},
-	{0x00008014, 0x03e803e8, 0x07d007d0, 0x10801600, 0x08400b00},
-	{0x0000801c, 0x128d8027, 0x128d804f, 0x12e00057, 0x12e0002b},
-	{0x00008120, 0x08f04800, 0x08f04800, 0x08f04810, 0x08f04810},
-	{0x000081d0, 0x00003210, 0x00003210, 0x0000320a, 0x0000320a},
-	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
-};
-
 static const u32 ar9565_1p0_baseband_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00009800, 0xafe68e30},
@@ -711,66 +705,6 @@ static const u32 ar9565_1p0_Common_rx_gain_table[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9565_1p0_Modes_lowest_ob_db_tx_gain_table[][5] = {
-	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x0000a2dc, 0xfc0a9380, 0xfc0a9380, 0xfdab5b52, 0xfdab5b52},
-	{0x0000a2e0, 0xffecec00, 0xffecec00, 0xfd339c84, 0xfd339c84},
-	{0x0000a2e4, 0xfc0f0000, 0xfc0f0000, 0xfec3e000, 0xfec3e000},
-	{0x0000a2e8, 0xfc100000, 0xfc100000, 0xfffc0000, 0xfffc0000},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
-	{0x0000a500, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a504, 0x06000003, 0x06000003, 0x04000002, 0x04000002},
-	{0x0000a508, 0x0a000020, 0x0a000020, 0x08000004, 0x08000004},
-	{0x0000a50c, 0x10000023, 0x10000023, 0x0b000200, 0x0b000200},
-	{0x0000a510, 0x16000220, 0x16000220, 0x0f000202, 0x0f000202},
-	{0x0000a514, 0x1c000223, 0x1c000223, 0x12000400, 0x12000400},
-	{0x0000a518, 0x21020220, 0x21020220, 0x16000402, 0x16000402},
-	{0x0000a51c, 0x27020223, 0x27020223, 0x19000404, 0x19000404},
-	{0x0000a520, 0x2b022220, 0x2b022220, 0x1c000603, 0x1c000603},
-	{0x0000a524, 0x2f022222, 0x2f022222, 0x21000a02, 0x21000a02},
-	{0x0000a528, 0x34022225, 0x34022225, 0x25000a04, 0x25000a04},
-	{0x0000a52c, 0x3a02222a, 0x3a02222a, 0x28000a20, 0x28000a20},
-	{0x0000a530, 0x3e02222c, 0x3e02222c, 0x2c000e20, 0x2c000e20},
-	{0x0000a534, 0x4202242a, 0x4202242a, 0x30000e22, 0x30000e22},
-	{0x0000a538, 0x4702244a, 0x4702244a, 0x34000e24, 0x34000e24},
-	{0x0000a53c, 0x4b02244c, 0x4b02244c, 0x38001640, 0x38001640},
-	{0x0000a540, 0x4e02246c, 0x4e02246c, 0x3c001660, 0x3c001660},
-	{0x0000a544, 0x5302266c, 0x5302266c, 0x3f001861, 0x3f001861},
-	{0x0000a548, 0x5702286c, 0x5702286c, 0x43001a81, 0x43001a81},
-	{0x0000a54c, 0x5c04286b, 0x5c04286b, 0x47001a83, 0x47001a83},
-	{0x0000a550, 0x61042a6c, 0x61042a6c, 0x4a001c84, 0x4a001c84},
-	{0x0000a554, 0x66062a6c, 0x66062a6c, 0x4e001ce3, 0x4e001ce3},
-	{0x0000a558, 0x6b062e6c, 0x6b062e6c, 0x52001ce5, 0x52001ce5},
-	{0x0000a55c, 0x7006308c, 0x7006308c, 0x56001ce9, 0x56001ce9},
-	{0x0000a560, 0x730a308a, 0x730a308a, 0x5a001ceb, 0x5a001ceb},
-	{0x0000a564, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
-	{0x0000a568, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
-	{0x0000a56c, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
-	{0x0000a570, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
-	{0x0000a574, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
-	{0x0000a578, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
-	{0x0000a57c, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
-	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a610, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a614, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a618, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a61c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a620, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a624, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a628, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a62c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a630, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a634, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a638, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a63c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x00016044, 0x012482d4, 0x012482d4, 0x012482d4, 0x012482d4},
-	{0x00016048, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-};
-
 static const u32 ar9565_1p0_pciephy_clkreq_disable_L1[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18212ede},
@@ -1231,11 +1165,4 @@ static const u32 ar9565_1p0_modes_high_power_tx_gain_table[][5] = {
 	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
-static const u32 ar9565_1p0_baseband_core_txfir_coeff_japan_2484[][2] = {
-	/* Addr      allmodes  */
-	{0x0000a398, 0x00000000},
-	{0x0000a39c, 0x6f7f0301},
-	{0x0000a3a0, 0xca9228ee},
-};
-
 #endif /* INITVALS_9565_1P0_H */
-- 
1.8.4.2

