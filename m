Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43982 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab2BOUx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 15:53:27 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k_hw: remove duplicate initvals
Date: Wed, 15 Feb 2012 21:53:16 +0100
Message-Id: <1329339196-77044-1-git-send-email-nbd@openwrt.org> (sfid-20120215_215331_441958_C9E6C359)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comparing SHA1 checksums of the initval tables has shown that there are many
tables that are 100% identical.

iniBank{0,1,2,3,7} and iniBB_RfGain are shared by AR5416, AR913x, AR9160
iniBank6 is shared between AR5416 and AR9160
iniBank6TPC is shared between AR913x and AR9160

iniPcieSerdes is the same for all AR9002 based devices

The CCK FIR coefficients are shared between AR9271 and AR9287

Getting rid of those duplicates saves about 7.5k uncompressed (on MIPS).

For AR9003 and later there are some duplicates as well, but I've decided to
leave them in for now, as the initvals for those chips are still actively
maintained by QCA.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h |  270 ----------------------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |  107 +++------
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   98 --------
 3 files changed, 34 insertions(+), 441 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
index e8bdc75..ea4a230 100644
--- a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
@@ -459,97 +459,6 @@ static const u32 ar5416Common_9100[][2] = {
 	{0x0000a3e0, 0x000001ce},
 };
 
-static const u32 ar5416Bank0_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x1e5795e5},
-	{0x000098e0, 0x02008020},
-};
-
-static const u32 ar5416BB_RfGain_9100[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
-	{0x00009a00, 0x00000000, 0x00000000},
-	{0x00009a04, 0x00000040, 0x00000040},
-	{0x00009a08, 0x00000080, 0x00000080},
-	{0x00009a0c, 0x000001a1, 0x00000141},
-	{0x00009a10, 0x000001e1, 0x00000181},
-	{0x00009a14, 0x00000021, 0x000001c1},
-	{0x00009a18, 0x00000061, 0x00000001},
-	{0x00009a1c, 0x00000168, 0x00000041},
-	{0x00009a20, 0x000001a8, 0x000001a8},
-	{0x00009a24, 0x000001e8, 0x000001e8},
-	{0x00009a28, 0x00000028, 0x00000028},
-	{0x00009a2c, 0x00000068, 0x00000068},
-	{0x00009a30, 0x00000189, 0x000000a8},
-	{0x00009a34, 0x000001c9, 0x00000169},
-	{0x00009a38, 0x00000009, 0x000001a9},
-	{0x00009a3c, 0x00000049, 0x000001e9},
-	{0x00009a40, 0x00000089, 0x00000029},
-	{0x00009a44, 0x00000170, 0x00000069},
-	{0x00009a48, 0x000001b0, 0x00000190},
-	{0x00009a4c, 0x000001f0, 0x000001d0},
-	{0x00009a50, 0x00000030, 0x00000010},
-	{0x00009a54, 0x00000070, 0x00000050},
-	{0x00009a58, 0x00000191, 0x00000090},
-	{0x00009a5c, 0x000001d1, 0x00000151},
-	{0x00009a60, 0x00000011, 0x00000191},
-	{0x00009a64, 0x00000051, 0x000001d1},
-	{0x00009a68, 0x00000091, 0x00000011},
-	{0x00009a6c, 0x000001b8, 0x00000051},
-	{0x00009a70, 0x000001f8, 0x00000198},
-	{0x00009a74, 0x00000038, 0x000001d8},
-	{0x00009a78, 0x00000078, 0x00000018},
-	{0x00009a7c, 0x00000199, 0x00000058},
-	{0x00009a80, 0x000001d9, 0x00000098},
-	{0x00009a84, 0x00000019, 0x00000159},
-	{0x00009a88, 0x00000059, 0x00000199},
-	{0x00009a8c, 0x00000099, 0x000001d9},
-	{0x00009a90, 0x000000d9, 0x00000019},
-	{0x00009a94, 0x000000f9, 0x00000059},
-	{0x00009a98, 0x000000f9, 0x00000099},
-	{0x00009a9c, 0x000000f9, 0x000000d9},
-	{0x00009aa0, 0x000000f9, 0x000000f9},
-	{0x00009aa4, 0x000000f9, 0x000000f9},
-	{0x00009aa8, 0x000000f9, 0x000000f9},
-	{0x00009aac, 0x000000f9, 0x000000f9},
-	{0x00009ab0, 0x000000f9, 0x000000f9},
-	{0x00009ab4, 0x000000f9, 0x000000f9},
-	{0x00009ab8, 0x000000f9, 0x000000f9},
-	{0x00009abc, 0x000000f9, 0x000000f9},
-	{0x00009ac0, 0x000000f9, 0x000000f9},
-	{0x00009ac4, 0x000000f9, 0x000000f9},
-	{0x00009ac8, 0x000000f9, 0x000000f9},
-	{0x00009acc, 0x000000f9, 0x000000f9},
-	{0x00009ad0, 0x000000f9, 0x000000f9},
-	{0x00009ad4, 0x000000f9, 0x000000f9},
-	{0x00009ad8, 0x000000f9, 0x000000f9},
-	{0x00009adc, 0x000000f9, 0x000000f9},
-	{0x00009ae0, 0x000000f9, 0x000000f9},
-	{0x00009ae4, 0x000000f9, 0x000000f9},
-	{0x00009ae8, 0x000000f9, 0x000000f9},
-	{0x00009aec, 0x000000f9, 0x000000f9},
-	{0x00009af0, 0x000000f9, 0x000000f9},
-	{0x00009af4, 0x000000f9, 0x000000f9},
-	{0x00009af8, 0x000000f9, 0x000000f9},
-	{0x00009afc, 0x000000f9, 0x000000f9},
-};
-
-static const u32 ar5416Bank1_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x02108421},
-	{0x000098ec, 0x00000008},
-};
-
-static const u32 ar5416Bank2_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x0e73ff17},
-	{0x000098e0, 0x00000420},
-};
-
-static const u32 ar5416Bank3_9100[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
-	{0x000098f0, 0x01400018, 0x01c00018},
-};
-
 static const u32 ar5416Bank6_9100[][3] = {
 	/* Addr      5G_HT20     5G_HT40   */
 	{0x0000989c, 0x00000000, 0x00000000},
@@ -624,13 +533,6 @@ static const u32 ar5416Bank6TPC_9100[][3] = {
 	{0x000098d0, 0x0000000f, 0x0010000f},
 };
 
-static const u32 ar5416Bank7_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x0000989c, 0x00000500},
-	{0x0000989c, 0x00000800},
-	{0x000098cc, 0x0000000e},
-};
-
 static const u32 ar5416Addac_9100[][2] = {
 	/* Addr      allmodes  */
 	{0x0000989c, 0x00000000},
@@ -1113,178 +1015,6 @@ static const u32 ar5416Common_9160[][2] = {
 	{0x0000a3e0, 0x000001ce},
 };
 
-static const u32 ar5416Bank0_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x1e5795e5},
-	{0x000098e0, 0x02008020},
-};
-
-static const u32 ar5416BB_RfGain_9160[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
-	{0x00009a00, 0x00000000, 0x00000000},
-	{0x00009a04, 0x00000040, 0x00000040},
-	{0x00009a08, 0x00000080, 0x00000080},
-	{0x00009a0c, 0x000001a1, 0x00000141},
-	{0x00009a10, 0x000001e1, 0x00000181},
-	{0x00009a14, 0x00000021, 0x000001c1},
-	{0x00009a18, 0x00000061, 0x00000001},
-	{0x00009a1c, 0x00000168, 0x00000041},
-	{0x00009a20, 0x000001a8, 0x000001a8},
-	{0x00009a24, 0x000001e8, 0x000001e8},
-	{0x00009a28, 0x00000028, 0x00000028},
-	{0x00009a2c, 0x00000068, 0x00000068},
-	{0x00009a30, 0x00000189, 0x000000a8},
-	{0x00009a34, 0x000001c9, 0x00000169},
-	{0x00009a38, 0x00000009, 0x000001a9},
-	{0x00009a3c, 0x00000049, 0x000001e9},
-	{0x00009a40, 0x00000089, 0x00000029},
-	{0x00009a44, 0x00000170, 0x00000069},
-	{0x00009a48, 0x000001b0, 0x00000190},
-	{0x00009a4c, 0x000001f0, 0x000001d0},
-	{0x00009a50, 0x00000030, 0x00000010},
-	{0x00009a54, 0x00000070, 0x00000050},
-	{0x00009a58, 0x00000191, 0x00000090},
-	{0x00009a5c, 0x000001d1, 0x00000151},
-	{0x00009a60, 0x00000011, 0x00000191},
-	{0x00009a64, 0x00000051, 0x000001d1},
-	{0x00009a68, 0x00000091, 0x00000011},
-	{0x00009a6c, 0x000001b8, 0x00000051},
-	{0x00009a70, 0x000001f8, 0x00000198},
-	{0x00009a74, 0x00000038, 0x000001d8},
-	{0x00009a78, 0x00000078, 0x00000018},
-	{0x00009a7c, 0x00000199, 0x00000058},
-	{0x00009a80, 0x000001d9, 0x00000098},
-	{0x00009a84, 0x00000019, 0x00000159},
-	{0x00009a88, 0x00000059, 0x00000199},
-	{0x00009a8c, 0x00000099, 0x000001d9},
-	{0x00009a90, 0x000000d9, 0x00000019},
-	{0x00009a94, 0x000000f9, 0x00000059},
-	{0x00009a98, 0x000000f9, 0x00000099},
-	{0x00009a9c, 0x000000f9, 0x000000d9},
-	{0x00009aa0, 0x000000f9, 0x000000f9},
-	{0x00009aa4, 0x000000f9, 0x000000f9},
-	{0x00009aa8, 0x000000f9, 0x000000f9},
-	{0x00009aac, 0x000000f9, 0x000000f9},
-	{0x00009ab0, 0x000000f9, 0x000000f9},
-	{0x00009ab4, 0x000000f9, 0x000000f9},
-	{0x00009ab8, 0x000000f9, 0x000000f9},
-	{0x00009abc, 0x000000f9, 0x000000f9},
-	{0x00009ac0, 0x000000f9, 0x000000f9},
-	{0x00009ac4, 0x000000f9, 0x000000f9},
-	{0x00009ac8, 0x000000f9, 0x000000f9},
-	{0x00009acc, 0x000000f9, 0x000000f9},
-	{0x00009ad0, 0x000000f9, 0x000000f9},
-	{0x00009ad4, 0x000000f9, 0x000000f9},
-	{0x00009ad8, 0x000000f9, 0x000000f9},
-	{0x00009adc, 0x000000f9, 0x000000f9},
-	{0x00009ae0, 0x000000f9, 0x000000f9},
-	{0x00009ae4, 0x000000f9, 0x000000f9},
-	{0x00009ae8, 0x000000f9, 0x000000f9},
-	{0x00009aec, 0x000000f9, 0x000000f9},
-	{0x00009af0, 0x000000f9, 0x000000f9},
-	{0x00009af4, 0x000000f9, 0x000000f9},
-	{0x00009af8, 0x000000f9, 0x000000f9},
-	{0x00009afc, 0x000000f9, 0x000000f9},
-};
-
-static const u32 ar5416Bank1_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x02108421},
-	{0x000098ec, 0x00000008},
-};
-
-static const u32 ar5416Bank2_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x0e73ff17},
-	{0x000098e0, 0x00000420},
-};
-
-static const u32 ar5416Bank3_9160[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
-	{0x000098f0, 0x01400018, 0x01c00018},
-};
-
-static const u32 ar5416Bank6_9160[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00e00000, 0x00e00000},
-	{0x0000989c, 0x005e0000, 0x005e0000},
-	{0x0000989c, 0x00120000, 0x00120000},
-	{0x0000989c, 0x00620000, 0x00620000},
-	{0x0000989c, 0x00020000, 0x00020000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x40ff0000, 0x40ff0000},
-	{0x0000989c, 0x005f0000, 0x005f0000},
-	{0x0000989c, 0x00870000, 0x00870000},
-	{0x0000989c, 0x00f90000, 0x00f90000},
-	{0x0000989c, 0x007b0000, 0x007b0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00f50000, 0x00f50000},
-	{0x0000989c, 0x00dc0000, 0x00dc0000},
-	{0x0000989c, 0x00110000, 0x00110000},
-	{0x0000989c, 0x006100a8, 0x006100a8},
-	{0x0000989c, 0x004210a2, 0x004210a2},
-	{0x0000989c, 0x0014008f, 0x0014008f},
-	{0x0000989c, 0x00c40003, 0x00c40003},
-	{0x0000989c, 0x003000f2, 0x003000f2},
-	{0x0000989c, 0x00440016, 0x00440016},
-	{0x0000989c, 0x00410040, 0x00410040},
-	{0x0000989c, 0x0001805e, 0x0001805e},
-	{0x0000989c, 0x0000c0ab, 0x0000c0ab},
-	{0x0000989c, 0x000000f1, 0x000000f1},
-	{0x0000989c, 0x00002081, 0x00002081},
-	{0x0000989c, 0x000000d4, 0x000000d4},
-	{0x000098d0, 0x0000000f, 0x0010000f},
-};
-
-static const u32 ar5416Bank6TPC_9160[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00e00000, 0x00e00000},
-	{0x0000989c, 0x005e0000, 0x005e0000},
-	{0x0000989c, 0x00120000, 0x00120000},
-	{0x0000989c, 0x00620000, 0x00620000},
-	{0x0000989c, 0x00020000, 0x00020000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x40ff0000, 0x40ff0000},
-	{0x0000989c, 0x005f0000, 0x005f0000},
-	{0x0000989c, 0x00870000, 0x00870000},
-	{0x0000989c, 0x00f90000, 0x00f90000},
-	{0x0000989c, 0x007b0000, 0x007b0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00f50000, 0x00f50000},
-	{0x0000989c, 0x00dc0000, 0x00dc0000},
-	{0x0000989c, 0x00110000, 0x00110000},
-	{0x0000989c, 0x006100a8, 0x006100a8},
-	{0x0000989c, 0x00423022, 0x00423022},
-	{0x0000989c, 0x2014008f, 0x2014008f},
-	{0x0000989c, 0x00c40002, 0x00c40002},
-	{0x0000989c, 0x003000f2, 0x003000f2},
-	{0x0000989c, 0x00440016, 0x00440016},
-	{0x0000989c, 0x00410040, 0x00410040},
-	{0x0000989c, 0x0001805e, 0x0001805e},
-	{0x0000989c, 0x0000c0ab, 0x0000c0ab},
-	{0x0000989c, 0x000000e1, 0x000000e1},
-	{0x0000989c, 0x00007080, 0x00007080},
-	{0x0000989c, 0x000000d4, 0x000000d4},
-	{0x000098d0, 0x0000000f, 0x0010000f},
-};
-
-static const u32 ar5416Bank7_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x0000989c, 0x00000500},
-	{0x0000989c, 0x00000800},
-	{0x000098cc, 0x0000000e},
-};
-
 static const u32 ar5416Addac_9160[][2] = {
 	/* Addr      allmodes  */
 	{0x0000989c, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 11f192a..d48f5fe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -35,11 +35,11 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271,
 			       ARRAY_SIZE(ar9271Common_9271), 2);
 		INIT_INI_ARRAY(&ah->iniCommon_normal_cck_fir_coeff_9271,
-			       ar9271Common_normal_cck_fir_coeff_9271,
-			       ARRAY_SIZE(ar9271Common_normal_cck_fir_coeff_9271), 2);
+			       ar9287Common_normal_cck_fir_coeff_9287_1_1,
+			       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_9287_1_1), 2);
 		INIT_INI_ARRAY(&ah->iniCommon_japan_2484_cck_fir_coeff_9271,
-			       ar9271Common_japan_2484_cck_fir_coeff_9271,
-			       ARRAY_SIZE(ar9271Common_japan_2484_cck_fir_coeff_9271), 2);
+			       ar9287Common_japan_2484_cck_fir_coeff_9287_1_1,
+			       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_9287_1_1), 2);
 		INIT_INI_ARRAY(&ah->iniModes_9271_1_0_only,
 			       ar9271Modes_9271_1_0_only,
 			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 5);
@@ -54,53 +54,31 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		return;
 	}
 
+	if (ah->config.pcie_clock_req)
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			   ar9280PciePhy_clkreq_off_L1_9280,
+			   ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280), 2);
+	else
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			   ar9280PciePhy_clkreq_always_on_L1_9280,
+			   ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
+
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
 				ARRAY_SIZE(ar9287Modes_9287_1_1), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_1,
 				ARRAY_SIZE(ar9287Common_9287_1_1), 2);
-		if (ah->config.pcie_clock_req)
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_off_L1_9287_1_1,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_1), 2);
-		else
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_always_on_L1_9287_1_1,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_1),
-					2);
 	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
-
-
 		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
 			       ARRAY_SIZE(ar9285Modes_9285_1_2), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285_1_2,
 			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
-
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_off_L1_9285_1_2,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
-				  2);
-		}
 	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280_2,
 			       ARRAY_SIZE(ar9280Modes_9280_2), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280_2,
 			       ARRAY_SIZE(ar9280Common_9280_2), 2);
 
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9280PciePhy_clkreq_off_L1_9280,
-			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9280PciePhy_clkreq_always_on_L1_9280,
-			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
-		}
 		INIT_INI_ARRAY(&ah->iniModesAdditional,
 			       ar9280Modes_fast_clock_9280_2,
 			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
@@ -109,22 +87,6 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar5416Modes_9160), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9160,
 			       ARRAY_SIZE(ar5416Common_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9160,
-			       ARRAY_SIZE(ar5416Bank0_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9160,
-			       ARRAY_SIZE(ar5416BB_RfGain_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9160,
-			       ARRAY_SIZE(ar5416Bank1_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9160,
-			       ARRAY_SIZE(ar5416Bank2_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9160,
-			       ARRAY_SIZE(ar5416Bank3_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9160,
-			       ARRAY_SIZE(ar5416Bank6_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9160,
-			       ARRAY_SIZE(ar5416Bank6TPC_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9160,
-			       ARRAY_SIZE(ar5416Bank7_9160), 2);
 		if (AR_SREV_9160_11(ah)) {
 			INIT_INI_ARRAY(&ah->iniAddac,
 				       ar5416Addac_9160_1_1,
@@ -138,22 +100,8 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar5416Modes_9100), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9100,
 			       ARRAY_SIZE(ar5416Common_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9100,
-			       ARRAY_SIZE(ar5416Bank0_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9100,
-			       ARRAY_SIZE(ar5416BB_RfGain_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9100,
-			       ARRAY_SIZE(ar5416Bank1_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9100,
-			       ARRAY_SIZE(ar5416Bank2_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9100,
-			       ARRAY_SIZE(ar5416Bank3_9100), 3);
 		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9100,
 			       ARRAY_SIZE(ar5416Bank6_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9100,
-			       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9100,
-			       ARRAY_SIZE(ar5416Bank7_9100), 2);
 		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9100,
 			       ARRAY_SIZE(ar5416Addac_9100), 2);
 	} else {
@@ -161,24 +109,37 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar5416Modes), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common,
 			       ARRAY_SIZE(ar5416Common), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0,
-			       ARRAY_SIZE(ar5416Bank0), 2);
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC,
+			       ARRAY_SIZE(ar5416Bank6TPC), 3);
+		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
+			       ARRAY_SIZE(ar5416Addac), 2);
+	}
+
+	if (!AR_SREV_9280_20_OR_LATER(ah)) {
+		/* Common for AR5416, AR913x, AR9160 */
 		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain,
 			       ARRAY_SIZE(ar5416BB_RfGain), 3);
+
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0,
+			       ARRAY_SIZE(ar5416Bank0), 2);
 		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1,
 			       ARRAY_SIZE(ar5416Bank1), 2);
 		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2,
 			       ARRAY_SIZE(ar5416Bank2), 2);
 		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3,
 			       ARRAY_SIZE(ar5416Bank3), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6,
-			       ARRAY_SIZE(ar5416Bank6), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC,
-			       ARRAY_SIZE(ar5416Bank6TPC), 3);
 		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7,
 			       ARRAY_SIZE(ar5416Bank7), 2);
-		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
-			       ARRAY_SIZE(ar5416Addac), 2);
+
+		/* Common for AR5416, AR9160 */
+		if (!AR_SREV_9100(ah))
+			INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6,
+				       ARRAY_SIZE(ar5416Bank6), 3);
+
+		/* Common for AR913x, AR9160 */
+		if (!AR_SREV_5416(ah))
+			INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9100,
+				       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index 863db32..d571c32 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -925,34 +925,6 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
 	{0x00004044, 0x00000000},
 };
 
-static const u32 ar9285PciePhy_clkreq_always_on_L1_9285[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffd},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9285PciePhy_clkreq_off_L1_9285[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffc},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9285Modes_9285_1_2[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
@@ -1743,34 +1715,6 @@ static const u32 ar9285Modes_XE2_0_high_power[][5] = {
 	{0x0000a3e0, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7},
 };
 
-static const u32 ar9285PciePhy_clkreq_always_on_L1_9285_1_2[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffd},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9285PciePhy_clkreq_off_L1_9285_1_2[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffc},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9287Modes_9287_1_1[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000000, 0x00000000, 0x000002c0, 0x00000160},
@@ -2512,34 +2456,6 @@ static const u32 ar9287Modes_rx_gain_9287_1_1[][5] = {
 	{0x0000a848, 0x00000000, 0x00000000, 0x00001067, 0x00001067},
 };
 
-static const u32 ar9287PciePhy_clkreq_always_on_L1_9287_1_1[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffd},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9287PciePhy_clkreq_off_L1_9287_1_1[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffc},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9271Modes_9271[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
@@ -3176,20 +3092,6 @@ static const u32 ar9271Common_9271[][2] = {
 	{0x0000d384, 0xf3307ff0},
 };
 
-static const u32 ar9271Common_normal_cck_fir_coeff_9271[][2] = {
-	/* Addr      allmodes  */
-	{0x0000a1f4, 0x00fffeff},
-	{0x0000a1f8, 0x00f5f9ff},
-	{0x0000a1fc, 0xb79f6427},
-};
-
-static const u32 ar9271Common_japan_2484_cck_fir_coeff_9271[][2] = {
-	/* Addr      allmodes  */
-	{0x0000a1f4, 0x00000000},
-	{0x0000a1f8, 0xefff0301},
-	{0x0000a1fc, 0xca9228ee},
-};
-
 static const u32 ar9271Modes_9271_1_0_only[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009910, 0x30002311, 0x30002311, 0x30002311, 0x30002311},
-- 
1.7.3.2

