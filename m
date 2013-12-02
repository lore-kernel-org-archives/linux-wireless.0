Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60756 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3LBHte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 02:49:34 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix initvals for freq 2484
Date: Mon,  2 Dec 2013 13:14:50 +0530
Message-Id: <1385970290-30587-1-git-send-email-sujith@msujith.org> (sfid-20131202_084936_850826_54C3F013)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This is missing for AR9300, AR9580 and AR9340.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |  7 +++++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c           | 12 +++++++++---
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h     |  2 ++
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h |  2 +-
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 1553395..e7cdf11 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1738,4 +1738,11 @@ static const u32 ar9300PciePhy_clkreq_disable_L1_2p2[][2] = {
 	{0x00004044, 0x00000000},
 };
 
+static const u32 ar9300_2p2_baseband_core_txfir_coeff_japan_2484[][2] = {
+	/* Addr      allmodes  */
+	{0x0000a398, 0x00000000},
+	{0x0000a39c, 0x6f7f0301},
+	{0x0000a3a0, 0xca9228ee},
+};
+
 #endif /* INITVALS_9003_2P2_H */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index d3eca0c..d8c1eee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -149,7 +149,9 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9340Modes_high_ob_db_tx_gain_table_1p0);
 
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
-				ar9340Modes_fast_clock_1p0);
+			       ar9340Modes_fast_clock_1p0);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9340_1p0_baseband_core_txfir_coeff_japan_2484);
 
 		if (!ah->is_clk_25mhz)
 			INIT_INI_ARRAY(&ah->iniAdditional,
@@ -335,7 +337,9 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9580_1p0_low_ob_db_tx_gain_table);
 
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
-				ar9580_1p0_modes_fast_clock);
+			       ar9580_1p0_modes_fast_clock);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9580_1p0_baseband_core_txfir_coeff_japan_2484);
 	} else if (AR_SREV_9565_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
 			       ar9565_1p1_mac_core);
@@ -451,7 +455,9 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		/* Fast clock modal settings */
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
-				ar9300Modes_fast_clock_2p2);
+			       ar9300Modes_fast_clock_2p2);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9300_2p2_baseband_core_txfir_coeff_japan_2484);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
index d2d789bd..7f22cb2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
@@ -28,6 +28,8 @@
 
 #define ar9340Common_wo_xlna_rx_gain_table_1p0 ar9300Common_wo_xlna_rx_gain_table_2p2
 
+#define ar9340_1p0_baseband_core_txfir_coeff_japan_2484 ar9300_2p2_baseband_core_txfir_coeff_japan_2484
+
 static const u32 ar9340_1p0_radio_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000160ac, 0xa4646800, 0xa4646800, 0xa4646800, 0xa4646800},
diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index 2ae380b..75bef11 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -36,7 +36,7 @@
 
 #define ar9580_1p0_modes_fast_clock ar9300Modes_fast_clock_2p2
 
-#define ar9580_1p0_baseband_core_txfir_coeff_japan_2484 ar9462_2p0_baseband_core_txfir_coeff_japan_2484
+#define ar9580_1p0_baseband_core_txfir_coeff_japan_2484 ar9300_2p2_baseband_core_txfir_coeff_japan_2484
 
 static const u32 ar9580_1p0_radio_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-- 
1.8.4.2

