Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6913 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227AbYDXSzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/21] iwlwifi: wrapping nic configuration in iwl core handler
Date: Thu, 24 Apr 2008 11:55:22 -0700
Message-Id: <1209063338-6572-6-git-send-email-reinette.chatre@intel.com> (sfid-20080424_210547_933155_F3689F35)
In-Reply-To: <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch wraps nic hw configuration in a iwl core handler

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c   |   57 ++++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   12 ++++++
 3 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a98f00f..8aaac16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -579,22 +579,13 @@ out:
 	return ret;
 }
 
-int iwl4965_hw_nic_init(struct iwl_priv *priv)
+
+static void iwl4965_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	struct iwl4965_rx_queue *rxq = &priv->rxq;
-	u8 val_link;
 	u32 val;
-	int ret;
-
-	/* nic_init */
-	priv->cfg->ops->lib->apm_ops.init(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
+	u16 radio_cfg;
+	u8 val_link;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -605,24 +596,49 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 				       val & ~(1 << 11));
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	pci_read_config_byte(priv->pci_dev, PCI_LINK_CTRL, &val_link);
 
 	/* disable L1 entry -- workaround for pre-B1 */
 	pci_write_config_byte(priv->pci_dev, PCI_LINK_CTRL, val_link & ~0x02);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
-	/* set CSR_HW_CONFIG_REG for uCode use */
+	/* write radio config values to register */
+	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) == EEPROM_4965_RF_CFG_TYPE_MAX)
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
 
+	/* set CSR_HW_CONFIG_REG for uCode use */
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-		    CSR49_HW_IF_CONFIG_REG_BIT_4965_R |
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
+	priv->calib_info = (struct iwl_eeprom_calib_info *)
+		iwl_eeprom_query_addr(priv, EEPROM_4965_CALIB_TXPOWER_OFFSET);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+
+int iwl4965_hw_nic_init(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	struct iwl4965_rx_queue *rxq = &priv->rxq;
+	int ret;
+
+	/* nic_init */
+	priv->cfg->ops->lib->apm_ops.init(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
+
+	priv->cfg->ops->lib->apm_ops.config(priv);
+
 	iwl4965_hw_card_show_info(priv);
 
 	/* end nic_init */
@@ -646,10 +662,6 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	rxq->need_update = 1;
 	iwl4965_rx_queue_update_write_ptr(priv, rxq);
 
-	/* init the txpower calibration pointer */
-	priv->calib_info = (struct iwl_eeprom_calib_info *)
-		iwl_eeprom_query_addr(priv, EEPROM_4965_CALIB_TXPOWER_OFFSET);
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Allocate and init all Tx and Command queues */
@@ -4112,6 +4124,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.load_ucode = iwl4965_load_bsm,
 	.apm_ops = {
 		.init = iwl4965_apm_init,
+		.config = iwl4965_nic_config,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fc0c276..369f182 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -120,6 +120,7 @@ struct iwl_lib_ops {
 	 /* power management */
 	struct {
 		int (*init)(struct iwl_priv *priv);
+		void (*config)(struct iwl_priv *priv);
 		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
 	} apm_ops;
 	/* power */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 57fb89d..0c42e5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -247,9 +247,21 @@ struct iwl_eeprom_calib_info {
 #define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
 #define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
 #define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
+#define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
 #define EEPROM_3945_M_VERSION               (2*0x4A)	/* 1  bytes */
 #define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
 
+/* The following masks are to be applied on EEPROM_RADIO_CONFIG */
+#define EEPROM_RF_CFG_TYPE_MSK(x)   (x & 0x3)         /* bits 0-1   */
+#define EEPROM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
+#define EEPROM_RF_CFG_DASH_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
+#define EEPROM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
+#define EEPROM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
+#define EEPROM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
+
+#define EEPROM_3945_RF_CFG_TYPE_MAX  0x0
+#define EEPROM_4965_RF_CFG_TYPE_MAX  0x1
+
 /*
  * Per-channel regulatory data.
  *
-- 
1.5.3.4

