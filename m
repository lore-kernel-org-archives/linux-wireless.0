Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2FFNX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 28/29] iwlwifi: move RF config into NIC config
Date: Wed,  6 Jun 2012 15:22:09 +0200
Message-Id: <1338988930-11561-28-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152401_942732_E05431DB)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the RF config is done for all devices,
there's no need to keep a separate function
that is called for all devices, move it into
the general NIC config function.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/devices.c |   43 ----------------------------
 drivers/net/wireless/iwlwifi/dvm/main.c    |   31 ++++++++++++++++++++
 2 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index d12f063..0521a6b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -36,41 +36,6 @@
 #include "commands.h"
 
 
-#define EEPROM_RF_CONFIG_TYPE_MAX      0x3
-
-static void iwl_rf_config(struct iwl_priv *priv)
-{
-	u16 radio_cfg = priv->eeprom_data->radio_cfg;
-
-	/* write radio config values to register */
-	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
-		u32 reg_val =
-			EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <<
-				CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE |
-			EEPROM_RF_CFG_STEP_MSK(radio_cfg) <<
-				CSR_HW_IF_CONFIG_REG_POS_PHY_STEP |
-			EEPROM_RF_CFG_DASH_MSK(radio_cfg) <<
-				CSR_HW_IF_CONFIG_REG_POS_PHY_DASH;
-
-		iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH, reg_val);
-
-		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
-			 EEPROM_RF_CFG_TYPE_MSK(radio_cfg),
-			 EEPROM_RF_CFG_STEP_MSK(radio_cfg),
-			 EEPROM_RF_CFG_DASH_MSK(radio_cfg));
-	} else {
-		WARN_ON(1);
-	}
-
-	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
-}
-
 /*
  * 1000 series
  * ===========
@@ -96,8 +61,6 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 1000 series */
 static void iwl1000_nic_config(struct iwl_priv *priv)
 {
-	iwl_rf_config(priv);
-
 	/* Setting digital SVR for 1000 card to 1.32V */
 	/* locking is acquired in iwl_set_bits_mask_prph() function */
 	iwl_set_bits_mask_prph(priv->trans, APMG_DIGITAL_SVR_REG,
@@ -233,8 +196,6 @@ static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 2000 series */
 static void iwl2000_nic_config(struct iwl_priv *priv)
 {
-	iwl_rf_config(priv);
-
 	iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 		    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
@@ -291,8 +252,6 @@ struct iwl_lib_ops iwl2030_lib = {
 /* NIC configuration for 5000 series */
 static void iwl5000_nic_config(struct iwl_priv *priv)
 {
-	iwl_rf_config(priv);
-
 	/* W/A : NIC is stuck in a reset state after Early PCIe power off
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
@@ -502,8 +461,6 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 6000 series */
 static void iwl6000_nic_config(struct iwl_priv *priv)
 {
-	iwl_rf_config(priv);
-
 	switch (priv->cfg->device_family) {
 	case IWL_DEVICE_FAMILY_6005:
 	case IWL_DEVICE_FAMILY_6030:
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index c91b66c..ec0b77b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2027,9 +2027,12 @@ static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 	}
 }
 
+#define EEPROM_RF_CONFIG_TYPE_MAX      0x3
+
 static void iwl_nic_config(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	u16 radio_cfg = priv->eeprom_data->radio_cfg;
 
 	/* SKU Control */
 	iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
@@ -2040,6 +2043,34 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 			  (CSR_HW_REV_DASH(priv->trans->hw_rev) <<
 				CSR_HW_IF_CONFIG_REG_POS_MAC_DASH));
 
+	/* write radio config values to register */
+	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
+		u32 reg_val =
+			EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE |
+			EEPROM_RF_CFG_STEP_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_STEP |
+			EEPROM_RF_CFG_DASH_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_DASH;
+
+		iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH, reg_val);
+
+		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
+			 EEPROM_RF_CFG_TYPE_MSK(radio_cfg),
+			 EEPROM_RF_CFG_STEP_MSK(radio_cfg),
+			 EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+	} else {
+		WARN_ON(1);
+	}
+
+	/* set CSR_HW_CONFIG_REG for uCode use */
+	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+
 	priv->lib->nic_config(priv);
 }
 
-- 
1.7.10

