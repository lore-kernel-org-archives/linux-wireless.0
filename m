Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbZIKRiS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/13] iwlwifi: separate nic_config for different NIC
Date: Fri, 11 Sep 2009 10:38:10 -0700
Message-Id: <1252690699-25796-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Different NIC has different requirements for configuration. Currently all
5000 series hardware and later share the same configuration function even
though they do not need the same configurations. Fix this by separating the
needed configuration actions for each hardware model.

.5000 series: L1-ASPM H/W bug work-around
              configure radio
              write CSR_HW_IF_CONFIG_REG for uCode use
              work-around for NIC get stuck after early PCIe power off

.1000 series: write CSR_HW_IF_CONFIG_REG for uCode use
              setting digital SVR for 1000 card to 1.32V

.6000 series: configure radio
              write CSR_HW_IF_CONFIG_REG for uCode use
              write CSR_GP_DRIVER_REG to indicate radio sku

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   16 +++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    7 ++++++-
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a95caa0..b6d2abe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -76,7 +76,10 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 1000 series */
 static void iwl1000_nic_config(struct iwl_priv *priv)
 {
-	iwl5000_nic_config(priv);
+	/* set CSR_HW_CONFIG_REG for uCode use */
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	/* Setting digital SVR for 1000 card to 1.32V */
 	/* locking is acquired in iwl_set_bits_mask_prph() function */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1d539e3..ea215bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -198,7 +198,7 @@ out:
 }
 
 
-/* NIC configuration for 5000 series and up */
+/* NIC configuration for 5000 series */
 void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -221,7 +221,7 @@ void iwl5000_nic_config(struct iwl_priv *priv)
 	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
 	/* write radio config values to register */
-	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) < EEPROM_5000_RF_CFG_TYPE_MAX)
+	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) < EEPROM_RF_CONFIG_TYPE_MAX)
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
 			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 82b9c93..36655c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -71,7 +71,21 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 6000 series */
 static void iwl6000_nic_config(struct iwl_priv *priv)
 {
-	iwl5000_nic_config(priv);
+	u16 radio_cfg;
+
+	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+
+	/* write radio config values to register */
+	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX)
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+
+	/* set CSR_HW_CONFIG_REG for uCode use */
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	/* no locking required for register write */
 	if (priv->cfg->pa_type == IWL_PA_HYBRID) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 90e2b4e..61794eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -385,7 +385,12 @@ struct iwl_eeprom_calib_info {
 
 #define EEPROM_3945_RF_CFG_TYPE_MAX  0x0
 #define EEPROM_4965_RF_CFG_TYPE_MAX  0x1
-#define EEPROM_5000_RF_CFG_TYPE_MAX  0x3
+
+/* Radio Config for 5000 and up */
+#define EEPROM_RF_CONFIG_TYPE_R3x3	0x0
+#define EEPROM_RF_CONFIG_TYPE_R2x2	0x1
+#define EEPROM_RF_CONFIG_TYPE_R1x2	0x2
+#define EEPROM_RF_CONFIG_TYPE_MAX	0x3
 
 /*
  * Per-channel regulatory data.
-- 
1.5.6.3

