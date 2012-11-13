Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:42463
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2KMGEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 01:04:11 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k_hw: Program filter coefficients correctly
Date: Tue, 13 Nov 2012 11:33:53 +0530
Message-Id: <1352786633-4284-1-git-send-email-sujith@msujith.org> (sfid-20121113_070415_303615_61991988)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

2484 Mhz (Japan) usage requires filter coefficients to
be programmed in the CCK TX FIR registers. This is required
for AR9331, AR9485 and AR9462. Fix this and also remove
a few useless macros and a duplicate variable.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       | 22 +++++++++++++---------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      |  2 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |  2 ++
 drivers/net/wireless/ath/ath9k/hw.h              |  1 -
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 0693cd9..74fd397 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -35,12 +35,6 @@
  */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
-#define AR9462_BB_CTX_COEFJ(x)	\
-		ar9462_##x##_baseband_core_txfir_coeff_japan_2484
-
-#define AR9462_BBC_TXIFR_COEFFJ \
-		ar9462_2p0_baseband_core_txfir_coeff_japan_2484
-
 	if (AR_SREV_9330_11(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
@@ -70,6 +64,10 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 				ar9331_modes_lowest_ob_db_tx_gain_1p1);
 
+		/* Japan 2484 Mhz CCK */
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9331_1p1_baseband_core_txfir_coeff_japan_2484);
+
 		/* additional clock settings */
 		if (ah->is_clk_25mhz)
 			INIT_INI_ARRAY(&ah->iniAdditional,
@@ -106,6 +104,10 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 				ar9331_modes_lowest_ob_db_tx_gain_1p2);
 
+		/* Japan 2484 Mhz CCK */
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9331_1p2_baseband_core_txfir_coeff_japan_2484);
+
 		/* additional clock settings */
 		if (ah->is_clk_25mhz)
 			INIT_INI_ARRAY(&ah->iniAdditional,
@@ -180,6 +182,10 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 				ar9485_modes_lowest_ob_db_tx_gain_1_1);
 
+		/* Japan 2484 Mhz CCK */
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9485_1_1_baseband_core_txfir_coeff_japan_2484);
+
 		/* Load PCIE SERDES settings from INI */
 
 		/* Awake Setting */
@@ -229,9 +235,7 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9462_modes_fast_clock_2p0);
 
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
-				AR9462_BB_CTX_COEFJ(2p0));
-
-		INIT_INI_ARRAY(&ah->ini_japan2484, AR9462_BBC_TXIFR_COEFFJ);
+			       ar9462_2p0_baseband_core_txfir_coeff_japan_2484);
 	} else if (AR_SREV_9550(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 759f5f5..ce19c09 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -784,7 +784,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	REG_WRITE_ARRAY(&ah->iniAdditional, 1, regWrites);
 
 	if (chan->channel == 2484)
-		ar9003_hw_prog_ini(ah, &ah->ini_japan2484, 1);
+		ar9003_hw_prog_ini(ah, &ah->iniCckfirJapan2484, 1);
 
 	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
 		REG_WRITE(ah, AR_GLB_SWREG_DISCONT_MODE,
diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index 02e4d97..a3710f3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -1060,4 +1060,6 @@ static const u32 ar9485_1_1_mac_core[][2] = {
 	{0x000083d0, 0x000301ff},
 };
 
+#define ar9485_1_1_baseband_core_txfir_coeff_japan_2484 ar9462_2p0_baseband_core_txfir_coeff_japan_2484
+
 #endif /* INITVALS_9485_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index bdabbda..3636dab 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -875,7 +875,6 @@ struct ath_hw {
 	struct ar5416IniArray iniModesTxGain;
 	struct ar5416IniArray iniCckfirNormal;
 	struct ar5416IniArray iniCckfirJapan2484;
-	struct ar5416IniArray ini_japan2484;
 	struct ar5416IniArray iniModes_9271_ANI_reg;
 	struct ar5416IniArray ini_radio_post_sys2ant;
 
-- 
1.8.0

