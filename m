Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab1FRQFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/25] iwlagn: merge duplicate code into single function
Date: Sat, 18 Jun 2011 08:34:30 -0700
Message-Id: <1308411271-26093-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180554_325932_38C643AB)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same operation needed by multiple devices, move to single function.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c   |   16 +---------------
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   17 ++---------------
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   16 +---------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 +
 5 files changed, 30 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 56a22de..1c13300 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -74,21 +74,7 @@ static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 2000 series */
 static void iwl2000_nic_config(struct iwl_priv *priv)
 {
-	u16 radio_cfg;
-
-	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
-
-	/* write radio config values to register */
-	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX)
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
-
-	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+	iwl_rf_config(priv);
 
 	if (priv->cfg->iq_invert)
 		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 06fe9ad..937a8f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -64,23 +64,10 @@
 static void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	u16 radio_cfg;
 
-	spin_lock_irqsave(&priv->lock, flags);
-
-	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+	iwl_rf_config(priv);
 
-	/* write radio config values to register */
-	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) < EEPROM_RF_CONFIG_TYPE_MAX)
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
-
-	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	/* W/A : NIC is stuck in a reset state after Early PCIe power off
 	 * (PCIe power is lost before PERST# is asserted),
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c66bbc6..3fcc092 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -95,21 +95,7 @@ static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 /* NIC configuration for 6000 series */
 static void iwl6000_nic_config(struct iwl_priv *priv)
 {
-	u16 radio_cfg;
-
-	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
-
-	/* write radio config values to register */
-	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX)
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
-			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
-
-	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+	iwl_rf_config(priv);
 
 	/* no locking required for register write */
 	if (priv->cfg->pa_type == IWL_PA_INTERNAL) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 47a56bc..768d0ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -834,3 +834,28 @@ const struct iwl_channel_info *iwl_get_channel_info(const struct iwl_priv *priv,
 
 	return NULL;
 }
+
+void iwl_rf_config(struct iwl_priv *priv)
+{
+	u16 radio_cfg;
+
+	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+
+	/* write radio config values to register */
+	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
+			 EEPROM_RF_CFG_TYPE_MSK(radio_cfg),
+			 EEPROM_RF_CFG_STEP_MSK(radio_cfg),
+			 EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+	} else
+		WARN_ON(1);
+
+	/* set CSR_HW_CONFIG_REG for uCode use */
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index c1a17f9..c6f370f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -310,5 +310,6 @@ void iwl_free_channel_map(struct iwl_priv *priv);
 const struct iwl_channel_info *iwl_get_channel_info(
 		const struct iwl_priv *priv,
 		enum ieee80211_band band, u16 channel);
+void iwl_rf_config(struct iwl_priv *priv);
 
 #endif  /* __iwl_eeprom_h__ */
-- 
1.7.0.4

