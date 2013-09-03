Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33475 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3ICFC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:02:29 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] initvals: Remove duplicate mapping for AR9485 arrays
Date: Tue,  3 Sep 2013 10:28:36 +0530
Message-Id: <1378184318-1169-2-git-send-email-sujith@msujith.org> (sfid-20130903_070233_420333_1143B517)
In-Reply-To: <1378184318-1169-1-git-send-email-sujith@msujith.org>
References: <1378184318-1169-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9485_initvals.h | 115 +++++++++++++++++++++++++++++++++++++--
 tools/initvals/initvals.c        |  18 ++----
 2 files changed, 116 insertions(+), 17 deletions(-)

diff --git a/tools/initvals/ar9485_initvals.h b/tools/initvals/ar9485_initvals.h
index a3710f3..5b5ab76 100644
--- a/tools/initvals/ar9485_initvals.h
+++ b/tools/initvals/ar9485_initvals.h
@@ -20,7 +20,17 @@
 
 /* AR9485 1.1 */
 
-#define ar9485_1_1_mac_postamble ar9300_2p2_mac_postamble
+static const u32 ar9485_1_1_mac_postamble[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
+	{0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c},
+	{0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38},
+	{0x00008014, 0x03e803e8, 0x07d007d0, 0x10801600, 0x08400b00},
+	{0x0000801c, 0x128d8027, 0x128d804f, 0x12e00057, 0x12e0002b},
+	{0x00008120, 0x08f04800, 0x08f04800, 0x08f04810, 0x08f04810},
+	{0x000081d0, 0x00003210, 0x00003210, 0x0000320a, 0x0000320a},
+	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
+};
 
 static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1[][2] = {
 	/* Addr      allmodes  */
@@ -448,7 +458,99 @@ static const u32 ar9485Modes_low_ob_db_tx_gain_1_1[][5] = {
 	{0x00016048, 0x6c924260, 0x6c924260, 0x6c924260, 0x6c924260},
 };
 
-#define ar9485_modes_lowest_ob_db_tx_gain_1_1 ar9485Modes_low_ob_db_tx_gain_1_1
+static const u32 ar9485_modes_lowest_ob_db_tx_gain_1_1[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x000098bc, 0x00000002, 0x00000002, 0x00000002, 0x00000002},
+	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0x7999a83a, 0x7999a83a},
+	{0x0000a2dc, 0x00000000, 0x00000000, 0xfe2d3552, 0xfe2d3552},
+	{0x0000a2e0, 0x00000000, 0x00000000, 0xfe2d3552, 0xfe2d3552},
+	{0x0000a2e4, 0x00000000, 0x00000000, 0xfe2d3552, 0xfe2d3552},
+	{0x0000a2e8, 0x00000000, 0x00000000, 0xfe2d3552, 0xfe2d3552},
+	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d8, 0x000050d8},
+	{0x0000a458, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a500, 0x00022200, 0x00022200, 0x00000000, 0x00000000},
+	{0x0000a504, 0x05062002, 0x05062002, 0x04000002, 0x04000002},
+	{0x0000a508, 0x0c002e00, 0x0c002e00, 0x08000004, 0x08000004},
+	{0x0000a50c, 0x11062202, 0x11062202, 0x0d000200, 0x0d000200},
+	{0x0000a510, 0x17022e00, 0x17022e00, 0x11000202, 0x11000202},
+	{0x0000a514, 0x1d000ec2, 0x1d000ec2, 0x15000400, 0x15000400},
+	{0x0000a518, 0x25020ec0, 0x25020ec0, 0x19000402, 0x19000402},
+	{0x0000a51c, 0x2b020ec3, 0x2b020ec3, 0x1d000404, 0x1d000404},
+	{0x0000a520, 0x2f001f04, 0x2f001f04, 0x21000603, 0x21000603},
+	{0x0000a524, 0x35001fc4, 0x35001fc4, 0x25000605, 0x25000605},
+	{0x0000a528, 0x3c022f04, 0x3c022f04, 0x2a000a03, 0x2a000a03},
+	{0x0000a52c, 0x41023e85, 0x41023e85, 0x2c000a04, 0x2c000a04},
+	{0x0000a530, 0x48023ec6, 0x48023ec6, 0x34000e20, 0x34000e20},
+	{0x0000a534, 0x4d023f01, 0x4d023f01, 0x35000e21, 0x35000e21},
+	{0x0000a538, 0x53023f4b, 0x53023f4b, 0x43000e62, 0x43000e62},
+	{0x0000a53c, 0x5a027f09, 0x5a027f09, 0x45000e63, 0x45000e63},
+	{0x0000a540, 0x5f027fc9, 0x5f027fc9, 0x49000e65, 0x49000e65},
+	{0x0000a544, 0x6502feca, 0x6502feca, 0x4b000e66, 0x4b000e66},
+	{0x0000a548, 0x6b02ff4a, 0x6b02ff4a, 0x4d001645, 0x4d001645},
+	{0x0000a54c, 0x7203feca, 0x7203feca, 0x51001865, 0x51001865},
+	{0x0000a550, 0x7703ff0b, 0x7703ff0b, 0x55001a86, 0x55001a86},
+	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
+	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
+	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a568, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a56c, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a570, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a574, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a578, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a57c, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a580, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a584, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a588, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a58c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a590, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a594, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a598, 0x00000000, 0x00000000, 0x01404501, 0x01404501},
+	{0x0000a59c, 0x00000000, 0x00000000, 0x02808a02, 0x02808a02},
+	{0x0000a5a0, 0x00000000, 0x00000000, 0x02808a02, 0x02808a02},
+	{0x0000a5a4, 0x00000000, 0x00000000, 0x02808803, 0x02808803},
+	{0x0000a5a8, 0x00000000, 0x00000000, 0x04c14b04, 0x04c14b04},
+	{0x0000a5ac, 0x00000000, 0x00000000, 0x04c15305, 0x04c15305},
+	{0x0000a5b0, 0x00000000, 0x00000000, 0x04c15305, 0x04c15305},
+	{0x0000a5b4, 0x00000000, 0x00000000, 0x04c15305, 0x04c15305},
+	{0x0000a5b8, 0x00000000, 0x00000000, 0x04c15305, 0x04c15305},
+	{0x0000a5bc, 0x00000000, 0x00000000, 0x04c15305, 0x04c15305},
+	{0x0000b500, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b504, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b508, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b50c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b510, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b514, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b518, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b51c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b520, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b524, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b528, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b52c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b530, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b534, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b538, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b53c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b540, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b544, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b548, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b54c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b550, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b554, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b558, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b55c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b560, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b564, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b568, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b56c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b570, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b574, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b578, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000b57c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x00016044, 0x05d6b2db, 0x05d6b2db, 0x05d6b2db, 0x05d6b2db},
+	{0x00016048, 0x6c924260, 0x6c924260, 0x6c924260, 0x6c924260},
+};
 
 static const u32 ar9485_1_1[][2] = {
 	/* Addr      allmodes  */
@@ -874,7 +976,7 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x000002a0, 0x000002a0},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071982, 0x00071982},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -1060,6 +1162,11 @@ static const u32 ar9485_1_1_mac_core[][2] = {
 	{0x000083d0, 0x000301ff},
 };
 
-#define ar9485_1_1_baseband_core_txfir_coeff_japan_2484 ar9462_2p0_baseband_core_txfir_coeff_japan_2484
+static const u32 ar9485_1_1_baseband_core_txfir_coeff_japan_2484[][2] = {
+	/* Addr      allmodes  */
+	{0x0000a398, 0x00000000},
+	{0x0000a39c, 0x6f7f0301},
+	{0x0000a3a0, 0xca9228ee},
+};
 
 #endif /* INITVALS_9485_H */
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 41e8051..d1b5f16 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -828,19 +828,13 @@ static void ar9340_hw_print_initvals(bool check)
 
 static void ar9485_hw_print_initvals(bool check)
 {
-	INI_PRINT_DUP(ar9485_1_1_mac_postamble,
-		      ar9300_2p2_mac_postamble);
+	INI_PRINT(ar9485_1_1_mac_postamble);
 	INI_PRINT(ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1);
 	INI_PRINT(ar9485Common_wo_xlna_rx_gain_1_1);
-
 	INI_PRINT(ar9485Modes_high_power_tx_gain_1_1);
-	INI_PRINT_DUP(ar9485Modes_high_ob_db_tx_gain_1_1,
-		      ar9485Modes_high_power_tx_gain_1_1);
-	INI_PRINT_DUP(ar9485Modes_low_ob_db_tx_gain_1_1,
-		      ar9485Modes_high_ob_db_tx_gain_1_1);
-	INI_PRINT_DUP(ar9485_modes_lowest_ob_db_tx_gain_1_1,
-		      ar9485Modes_low_ob_db_tx_gain_1_1);
-
+	INI_PRINT(ar9485Modes_high_ob_db_tx_gain_1_1);
+	INI_PRINT(ar9485Modes_low_ob_db_tx_gain_1_1);
+	INI_PRINT(ar9485_modes_lowest_ob_db_tx_gain_1_1);
 	INI_PRINT(ar9485_1_1);
 	INI_PRINT(ar9485_1_1_radio_core);
 	INI_PRINT(ar9485_1_1_baseband_core);
@@ -853,9 +847,7 @@ static void ar9485_hw_print_initvals(bool check)
 	INI_PRINT(ar9485_1_1_pcie_phy_clkreq_disable_L1);
 	INI_PRINT(ar9485_1_1_radio_postamble);
 	INI_PRINT(ar9485_1_1_mac_core);
-
-	INI_PRINT_DUP(ar9485_1_1_baseband_core_txfir_coeff_japan_2484,
-		      ar9462_2p0_baseband_core_txfir_coeff_japan_2484);
+	INI_PRINT(ar9485_1_1_baseband_core_txfir_coeff_japan_2484);
 }
 
 static void ar955x_1p0_hw_print_initvals(bool check)
-- 
1.8.4

