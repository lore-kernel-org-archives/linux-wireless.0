Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab0DODaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 60/97] ath9k_hw: move TX/RX gain INI stuff to its own hardware family code
Date: Wed, 14 Apr 2010 23:30:14 -0400
Message-Id: <1271302251-9075-61-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR9003 TX/RX gain is currently initialized with the other
components, so for now AR9003 does not implment this callback,
after hardware bring up  we can test moving the TX/RX gain there
as well and if it works well move them to its own callback as
well.

Since all INI stuff is now moved out hw.c no longer needs to
include and touch any original INI headers/structs.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |  106 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    4 +
 drivers/net/wireless/ath/ath9k/hw.c        |  112 ++--------------------------
 drivers/net/wireless/ath/ath9k/hw.h        |    2 +
 4 files changed, 120 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index ff81efa..eeaea26 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -244,6 +244,111 @@ void ar9002_hw_cck_chan14_spread(struct ath_hw *ah)
 	}
 }
 
+static void ar9280_20_hw_init_rxgain_ini(struct ath_hw *ah)
+{
+	u32 rxgain_type;
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >=
+	    AR5416_EEP_MINOR_VER_17) {
+		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
+
+		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_backoff_13db_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
+		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_backoff_23db_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
+		else
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_original_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_original_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
+	}
+}
+
+static void ar9280_20_hw_init_txgain_ini(struct ath_hw *ah)
+{
+	u32 txgain_type;
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >=
+	    AR5416_EEP_MINOR_VER_19) {
+		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
+		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9280Modes_high_power_tx_gain_9280_2,
+			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9280Modes_original_tx_gain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9280Modes_original_tx_gain_9280_2,
+		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
+	}
+}
+
+static void ar9002_hw_init_mode_gain_regs(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_11_OR_LATER(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
+	else if (AR_SREV_9287_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_0), 6);
+	else if (AR_SREV_9280_20(ah))
+		ar9280_20_hw_init_rxgain_ini(ah);
+
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
+	} else if (AR_SREV_9287_10(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_0), 6);
+	} else if (AR_SREV_9280_20(ah)) {
+		ar9280_20_hw_init_txgain_ini(ah);
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
+		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
+		/* txgain table */
+		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
+			if (AR_SREV_9285E_20(ah)) {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_XE2_0_high_power,
+				ARRAY_SIZE(
+				  ar9285Modes_XE2_0_high_power), 6);
+			} else {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_high_power_tx_gain_9285_1_2,
+				ARRAY_SIZE(
+				  ar9285Modes_high_power_tx_gain_9285_1_2), 6);
+			}
+		} else {
+			if (AR_SREV_9285E_20(ah)) {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_XE2_0_normal_power,
+				ARRAY_SIZE(
+				  ar9285Modes_XE2_0_normal_power), 6);
+			} else {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_original_tx_gain_9285_1_2,
+				ARRAY_SIZE(
+				  ar9285Modes_original_tx_gain_9285_1_2), 6);
+			}
+		}
+	}
+}
+
 /*
  * Helper for ASPM support.
  *
@@ -385,6 +490,7 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
 	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
+	priv_ops->init_mode_gain_regs = ar9002_hw_init_mode_gain_regs;
 	priv_ops->macversion_supported = ar9002_hw_macversion_supported;
 
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 6111bdb..1984b4f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -31,6 +31,10 @@ static bool ar9003_hw_macversion_supported(u32 macversion)
 }
 
 /* AR9003 2.0 - new INI format (pre, core, post arrays per subsystem) */
+/*
+ * XXX: move TX/RX gain INI to its own init_mode_gain_regs after
+ * ensuring it does not affect hardware bring up
+ */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
 	/* mac */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a43e587..5d6df49 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -21,7 +21,6 @@
 #include "hw.h"
 #include "hw-ops.h"
 #include "rc.h"
-#include "ar9002_initvals.h"
 
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
@@ -71,6 +70,14 @@ static u32 ath9k_hw_compute_pll_control(struct ath_hw *ah,
 	return ath9k_hw_private_ops(ah)->compute_pll_control(ah, chan);
 }
 
+static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->init_mode_gain_regs)
+		return;
+
+	ath9k_hw_private_ops(ah)->init_mode_gain_regs(ah);
+}
+
 /********************/
 /* Helper Functions */
 /********************/
@@ -480,54 +487,6 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 	return 0;
 }
 
-static void ath9k_hw_init_rxgain_ini(struct ath_hw *ah)
-{
-	u32 rxgain_type;
-
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
-		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
-
-		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_backoff_13db_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
-		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_backoff_23db_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
-		else
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_original_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_original_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
-	}
-}
-
-static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
-{
-	u32 txgain_type;
-
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
-		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
-		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9280Modes_high_power_tx_gain_9280_2,
-			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
-		else
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9280Modes_original_tx_gain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9280Modes_original_tx_gain_9280_2,
-		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
-	}
-}
-
 static int ath9k_hw_post_init(struct ath_hw *ah)
 {
 	int ecode;
@@ -566,61 +525,6 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	return 0;
 }
 
-static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
-{
-	if (AR_SREV_9287_11_OR_LATER(ah))
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-		ar9287Modes_rx_gain_9287_1_1,
-		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
-	else if (AR_SREV_9287_10(ah))
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-		ar9287Modes_rx_gain_9287_1_0,
-		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_0), 6);
-	else if (AR_SREV_9280_20(ah))
-		ath9k_hw_init_rxgain_ini(ah);
-
-	if (AR_SREV_9287_11_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9287Modes_tx_gain_9287_1_1,
-		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
-	} else if (AR_SREV_9287_10(ah)) {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9287Modes_tx_gain_9287_1_0,
-		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_0), 6);
-	} else if (AR_SREV_9280_20(ah)) {
-		ath9k_hw_init_txgain_ini(ah);
-	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
-		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
-		/* txgain table */
-		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
-			if (AR_SREV_9285E_20(ah)) {
-				INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9285Modes_XE2_0_high_power,
-				ARRAY_SIZE(
-				  ar9285Modes_XE2_0_high_power), 6);
-			} else {
-				INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9285Modes_high_power_tx_gain_9285_1_2,
-				ARRAY_SIZE(
-				  ar9285Modes_high_power_tx_gain_9285_1_2), 6);
-			}
-		} else {
-			if (AR_SREV_9285E_20(ah)) {
-				INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9285Modes_XE2_0_normal_power,
-				ARRAY_SIZE(
-				  ar9285Modes_XE2_0_normal_power), 6);
-			} else {
-				INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9285Modes_original_tx_gain_9285_1_2,
-				ARRAY_SIZE(
-				  ar9285Modes_original_tx_gain_9285_1_2), 6);
-			}
-		}
-	}
-}
-
 static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 {
 	struct base_eep_header *pBase = &(ah->eeprom.def.baseEepHeader);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e49f001..3129afa 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -467,6 +467,7 @@ struct ath_gen_timer_table {
  * @init_cal: starts actual calibration
  *
  * @init_mode_regs: Initializes mode registers
+ * @init_mode_gain_regs: Initialize TX/RX gain registers
  * @macversion_supported: If this specific mac revision is supported
  *
  * @rf_set_freq: change frequency
@@ -485,6 +486,7 @@ struct ath_hw_private_ops {
 	bool (*init_cal)(struct ath_hw *ah, struct ath9k_channel *chan);
 
 	void (*init_mode_regs)(struct ath_hw *ah);
+	void (*init_mode_gain_regs)(struct ath_hw *ah);
 	bool (*macversion_supported)(u32 macversion);
 	void (*setup_calibration)(struct ath_hw *ah,
 				  struct ath9k_cal_list *currCal);
-- 
1.6.3.3

