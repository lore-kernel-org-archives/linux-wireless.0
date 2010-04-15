Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab0DODa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 76/97] ath9k_hw: add TX/RX gain register initialization for AR9003
Date: Wed, 14 Apr 2010 23:30:30 -0400
Message-Id: <1271302251-9075-77-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is done depending on what the EEPROM settings indicates.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    4 ++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c     |   51 ++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index fb39e39..5d92be4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -1827,6 +1827,20 @@ static u16 ath9k_hw_ar9300_get_spur_channel(struct ath_hw *ah,
 	return AR_NO_SPUR;
 }
 
+s32 ar9003_hw_get_tx_gain_idx(struct ath_hw *ah)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	return (eep->baseEepHeader.txrxgain >> 4) & 0xf; /* bits 7:4 */
+}
+
+s32 ar9003_hw_get_rx_gain_idx(struct ath_hw *ah)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	return (eep->baseEepHeader.txrxgain) & 0xf; /* bits 3:0 */
+}
+
 const struct eeprom_ops eep_ar9300_ops = {
 	.check_eeprom = ath9k_hw_ar9300_check_eeprom,
 	.get_eeprom = ath9k_hw_ar9300_get_eeprom,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 3ca520c..5fe335e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -316,4 +316,8 @@ struct ar9300_eeprom {
 	u8 ctl_freqbin_5G[AR9300_NUM_CTLS_5G][AR9300_NUM_BAND_EDGES_5G];
 	struct cal_ctl_data_5g ctlPowerData_5G[AR9300_NUM_CTLS_5G];
 } __packed;
+
+s32 ar9003_hw_get_tx_gain_idx(struct ath_hw *ah);
+s32 ar9003_hw_get_rx_gain_idx(struct ath_hw *ah);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 1984b4f..f32665d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -105,6 +105,56 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		       3);
 }
 
+static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
+{
+	switch (ar9003_hw_get_tx_gain_idx(ah)) {
+	case 0:
+	default:
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9300Modes_lowest_ob_db_tx_gain_table_2p0,
+			       ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p0),
+			       5);
+		break;
+	case 1:
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9300Modes_high_ob_db_tx_gain_table_2p0,
+			       ARRAY_SIZE(ar9300Modes_high_ob_db_tx_gain_table_2p0),
+			       5);
+		break;
+	case 2:
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9300Modes_low_ob_db_tx_gain_table_2p0,
+			       ARRAY_SIZE(ar9300Modes_low_ob_db_tx_gain_table_2p0),
+			       5);
+		break;
+	}
+}
+
+static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
+{
+	switch (ar9003_hw_get_rx_gain_idx(ah)) {
+	case 0:
+	default:
+		INIT_INI_ARRAY(&ah->iniModesRxGain, ar9300Common_rx_gain_table_2p0,
+			       ARRAY_SIZE(ar9300Common_rx_gain_table_2p0),
+			       2);
+		break;
+	case 1:
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9300Common_wo_xlna_rx_gain_table_2p0,
+			       ARRAY_SIZE(ar9300Common_wo_xlna_rx_gain_table_2p0),
+			       2);
+		break;
+	}
+}
+
+/* set gain table pointers according to values read from the eeprom */
+static void ar9003_hw_init_mode_gain_regs(struct ath_hw *ah)
+{
+	ar9003_tx_gain_table_apply(ah);
+	ar9003_rx_gain_table_apply(ah);
+}
+
 /*
  * Helper for ASPM support.
  *
@@ -143,6 +193,7 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
 	priv_ops->init_mode_regs = ar9003_hw_init_mode_regs;
+	priv_ops->init_mode_gain_regs = ar9003_hw_init_mode_gain_regs;
 	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
 
 	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
-- 
1.6.3.3

