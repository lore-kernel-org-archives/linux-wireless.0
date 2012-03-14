Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55442 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab2CNPkr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 12/14] ath9k_hw: remove iniModes_*_tx_gain_9271
Date: Wed, 14 Mar 2012 16:40:32 +0100
Message-Id: <1331739634-22318-12-git-send-email-nbd@openwrt.org> (sfid-20120314_164107_969913_7C82BE04)
In-Reply-To: <1331739634-22318-11-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
 <1331739634-22318-6-git-send-email-nbd@openwrt.org>
 <1331739634-22318-7-git-send-email-nbd@openwrt.org>
 <1331739634-22318-8-git-send-email-nbd@openwrt.org>
 <1331739634-22318-9-git-send-email-nbd@openwrt.org>
 <1331739634-22318-10-git-send-email-nbd@openwrt.org>
 <1331739634-22318-11-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Program tx gain through iniModesTxGain like on AR9287

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |    9 -------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |   34 +++++++++++++++------------
 drivers/net/wireless/ath/ath9k/hw.h         |    2 -
 3 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 5d34e57..3e108c8 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -858,15 +858,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-	if (AR_SREV_9271(ah)) {
-		if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)
-			REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
-					modesIndex, regWrites);
-		else
-			REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
-					modesIndex, regWrites);
-	}
-
 	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 
 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 7098cd8..99d2dd9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -39,12 +39,6 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 5);
 		INIT_INI_ARRAY(&ah->iniModes_9271_ANI_reg, ar9271Modes_9271_ANI_reg,
 			       ARRAY_SIZE(ar9271Modes_9271_ANI_reg), 5);
-		INIT_INI_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
-			       ar9271Modes_high_power_tx_gain_9271,
-			       ARRAY_SIZE(ar9271Modes_high_power_tx_gain_9271), 5);
-		INIT_INI_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
-			       ar9271Modes_normal_power_tx_gain_9271,
-			       ARRAY_SIZE(ar9271Modes_normal_power_tx_gain_9271), 5);
 		return;
 	}
 
@@ -193,14 +187,10 @@ static void ar9280_20_hw_init_rxgain_ini(struct ath_hw *ah)
 	}
 }
 
-static void ar9280_20_hw_init_txgain_ini(struct ath_hw *ah)
+static void ar9280_20_hw_init_txgain_ini(struct ath_hw *ah, u32 txgain_type)
 {
-	u32 txgain_type;
-
 	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >=
 	    AR5416_EEP_MINOR_VER_19) {
-		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
 		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9280Modes_high_power_tx_gain_9280_2,
@@ -216,8 +206,22 @@ static void ar9280_20_hw_init_txgain_ini(struct ath_hw *ah)
 	}
 }
 
+static void ar9271_hw_init_txgain_ini(struct ath_hw *ah, u32 txgain_type)
+{
+	if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9271Modes_high_power_tx_gain_9271,
+			       ARRAY_SIZE(ar9271Modes_high_power_tx_gain_9271), 5);
+	else
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9271Modes_normal_power_tx_gain_9271,
+			       ARRAY_SIZE(ar9271Modes_normal_power_tx_gain_9271), 5);
+}
+
 static void ar9002_hw_init_mode_gain_regs(struct ath_hw *ah)
 {
+	u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
 	if (AR_SREV_9287_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 		ar9287Modes_rx_gain_9287_1_1,
@@ -225,15 +229,15 @@ static void ar9002_hw_init_mode_gain_regs(struct ath_hw *ah)
 	else if (AR_SREV_9280_20(ah))
 		ar9280_20_hw_init_rxgain_ini(ah);
 
-	if (AR_SREV_9287_11_OR_LATER(ah)) {
+	if (AR_SREV_9271(ah)) {
+		ar9271_hw_init_txgain_ini(ah, txgain_type);
+	} else if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 		ar9287Modes_tx_gain_9287_1_1,
 		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 5);
 	} else if (AR_SREV_9280_20(ah)) {
-		ar9280_20_hw_init_txgain_ini(ah);
+		ar9280_20_hw_init_txgain_ini(ah, txgain_type);
 	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
-		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
 		/* txgain table */
 		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
 			if (AR_SREV_9285E_20(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e6a358e..489477c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -836,8 +836,6 @@ struct ath_hw {
 	struct ar5416IniArray iniCckfirJapan2484;
 	struct ar5416IniArray ini_japan2484;
 	struct ar5416IniArray iniModes_9271_ANI_reg;
-	struct ar5416IniArray iniModes_high_power_tx_gain_9271;
-	struct ar5416IniArray iniModes_normal_power_tx_gain_9271;
 	struct ar5416IniArray ini_radio_post_sys2ant;
 	struct ar5416IniArray ini_BTCOEX_MAX_TXPWR;
 
-- 
1.7.3.2

