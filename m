Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYDXAPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/16] iwlwifi: add iwl_hw_detect function to iwl core
Date: Wed, 23 Apr 2008 17:14:54 -0700
Message-Id: <1208996108-15326-3-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021605_135085_394B1948)
In-Reply-To: <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch add iwl_hw_detect function to iwl core

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   10 +---------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    3 +++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    5 +++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 +++-
 6 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b8c7215..d1ddbf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -739,7 +739,6 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	struct iwl4965_rx_queue *rxq = &priv->rxq;
-	u8 rev_id;
 	u8 val_link;
 	u32 val;
 	int ret;
@@ -751,18 +750,11 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Determine HW type */
-	ret = pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
-	if (ret)
-		return ret;
-
-	IWL_DEBUG_INFO("HW Revision ID = 0x%X\n", rev_id);
-
 	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if ((rev_id & 0x80) == 0x80 && (rev_id & 0x7f) < 8) {
+	if ((priv->rev_id & 0x80) == 0x80 && (priv->rev_id & 0x7f) < 8) {
 		pci_read_config_dword(priv->pci_dev, PCI_REG_WUM8, &val);
 		/* Enable No Snoop field */
 		pci_write_config_dword(priv->pci_dev, PCI_REG_WUM8,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 6df51cc..1ab4e2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1003,6 +1003,9 @@ struct iwl_priv {
 
 	/* pci hardware address support */
 	void __iomem *hw_base;
+	u32  hw_rev;
+	u32  hw_wa_rev;
+	u8   rev_id;
 
 	/* uCode images, save to reload in case of failure */
 	struct fw_desc ucode_code;	/* runtime inst */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c336b19..68de1a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -36,6 +36,7 @@ struct iwl_priv; /* FIXME: remove */
 #include "iwl-eeprom.h"
 #include "iwl-4965.h" /* FIXME: remove */
 #include "iwl-core.h"
+#include "iwl-io.h"
 #include "iwl-rfkill.h"
 #include "iwl-power.h"
 
@@ -73,6 +74,14 @@ out:
 }
 EXPORT_SYMBOL(iwl_alloc_all);
 
+void iwl_hw_detect(struct iwl_priv *priv)
+{
+	priv->hw_rev = _iwl_read32(priv, CSR_HW_REV);
+	priv->hw_wa_rev = _iwl_read32(priv, CSR_HW_REV_WA_REG);
+	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &priv->rev_id);
+}
+EXPORT_SYMBOL(iwl_hw_detect);
+
 /**
  * iwlcore_clear_stations_table - Clear the driver's station table
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index edda2ff..eff076e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -159,6 +159,7 @@ struct iwl_cfg {
 
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
+void iwl_hw_detect(struct iwl_priv *priv);
 
 void iwlcore_clear_stations_table(struct iwl_priv *priv);
 void iwlcore_reset_qos(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 82c7445..df9949a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -194,6 +194,11 @@
 #define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
 
 
+/* HW REV */
+#define CSR_HW_REV_TYPE_MSK            (0x00000F0)
+#define CSR_HW_REV_TYPE_3945           (0x00000D0)
+#define CSR_HW_REV_TYPE_4965           (0x0000000)
+
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
 #define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3953527..7957270 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7460,8 +7460,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		(unsigned long long) pci_resource_len(pdev, 0));
 	IWL_DEBUG_INFO("pci_resource_base = %p\n", priv->hw_base);
 
+	iwl_hw_detect(priv);
 	printk(KERN_INFO DRV_NAME
-		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
+		": Detected Intel Wireless WiFi Link %s REV=0x%X\n",
+		priv->cfg->name, priv->hw_rev);
 
 	/* amp init */
 	err = priv->cfg->ops->lib->apm_ops.init(priv);
-- 
1.5.3.4

