Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52490 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069AbcARSB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 13:01:58 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k_hw: add low power tx gain table for AR953x
Date: Thu, 14 Jan 2016 03:15:13 +0100
Message-Id: <1452737713-9891-1-git-send-email-nbd@openwrt.org> (sfid-20160118_190201_555147_1F5904EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used in some newer TP-Link AR9533 devices.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  3 ++
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 65 ++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 8b238c1..2fe12b0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -698,6 +698,9 @@ static void ar9003_tx_gain_table_mode2(struct ath_hw *ah)
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9340Modes_low_ob_db_tx_gain_table_1p0);
+	else if (AR_SREV_9531_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       qca953x_1p1_modes_no_xpa_low_power_tx_gain_table);
 	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485Modes_low_ob_db_tx_gain_1_1);
diff --git a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
index 6fc0d07..c0b90da 100644
--- a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
@@ -757,6 +757,71 @@ static const u32 qca953x_1p1_modes_xpa_tx_gain_table[][2] = {
 	{0x00016448, 0x6c927a70},
 };
 
+static const u32 qca953x_1p1_modes_no_xpa_low_power_tx_gain_table[][2] = {
+	/* Addr      allmodes  */
+	{0x0000a2dc, 0xfff55592},
+	{0x0000a2e0, 0xfff99924},
+	{0x0000a2e4, 0xfffe1e00},
+	{0x0000a2e8, 0xffffe000},
+	{0x0000a410, 0x000050d6},
+	{0x0000a500, 0x00000069},
+	{0x0000a504, 0x0400006b},
+	{0x0000a508, 0x0800006d},
+	{0x0000a50c, 0x0c000269},
+	{0x0000a510, 0x1000026b},
+	{0x0000a514, 0x1400026d},
+	{0x0000a518, 0x18000669},
+	{0x0000a51c, 0x1c00066b},
+	{0x0000a520, 0x1d000a68},
+	{0x0000a524, 0x21000a6a},
+	{0x0000a528, 0x25000a6c},
+	{0x0000a52c, 0x29000a6e},
+	{0x0000a530, 0x2d0012a9},
+	{0x0000a534, 0x310012ab},
+	{0x0000a538, 0x350012ad},
+	{0x0000a53c, 0x39001b0a},
+	{0x0000a540, 0x3d001b0c},
+	{0x0000a544, 0x41001b0e},
+	{0x0000a548, 0x43001bae},
+	{0x0000a54c, 0x45001914},
+	{0x0000a550, 0x47001916},
+	{0x0000a554, 0x49001b96},
+	{0x0000a558, 0x49001b96},
+	{0x0000a55c, 0x49001b96},
+	{0x0000a560, 0x49001b96},
+	{0x0000a564, 0x49001b96},
+	{0x0000a568, 0x49001b96},
+	{0x0000a56c, 0x49001b96},
+	{0x0000a570, 0x49001b96},
+	{0x0000a574, 0x49001b96},
+	{0x0000a578, 0x49001b96},
+	{0x0000a57c, 0x49001b96},
+	{0x0000a600, 0x00000000},
+	{0x0000a604, 0x00000000},
+	{0x0000a608, 0x00000000},
+	{0x0000a60c, 0x00000000},
+	{0x0000a610, 0x00000000},
+	{0x0000a614, 0x00000000},
+	{0x0000a618, 0x00804201},
+	{0x0000a61c, 0x01408201},
+	{0x0000a620, 0x01408502},
+	{0x0000a624, 0x01408502},
+	{0x0000a628, 0x01408502},
+	{0x0000a62c, 0x01408502},
+	{0x0000a630, 0x01408502},
+	{0x0000a634, 0x01408502},
+	{0x0000a638, 0x01408502},
+	{0x0000a63c, 0x01408502},
+	{0x0000b2dc, 0xfff55592},
+	{0x0000b2e0, 0xfff99924},
+	{0x0000b2e4, 0xfffe1e00},
+	{0x0000b2e8, 0xffffe000},
+	{0x00016044, 0x044922db},
+	{0x00016048, 0x6c927a70},
+	{0x00016444, 0x044922db},
+	{0x00016448, 0x6c927a70},
+};
+
 static const u32 qca953x_2p0_baseband_core[][2] = {
 	/* Addr      allmodes  */
 	{0x00009800, 0xafe68e30},
-- 
2.2.2

