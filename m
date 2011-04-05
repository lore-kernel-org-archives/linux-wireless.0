Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab1DERBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/25] iwlagn: remove ISR ops
Date: Tue,  5 Apr 2011 09:42:11 -0700
Message-Id: <1302021732-21250-25-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ISR (interrupt service routine) ops are now
no longer necessary since they are the same for
all devices this driver now handles.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    7 -------
 drivers/net/wireless/iwlwifi/iwl-2000.c |    7 -------
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 --------------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   14 --------------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   17 ++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.h |   11 -----------
 6 files changed, 6 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index de5b287..1b27992 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -209,13 +209,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.isr_ops = {
-		.isr = iwl_isr_ict,
-		.free = iwl_free_isr_ict,
-		.alloc = iwl_alloc_isr_ict,
-		.reset = iwl_reset_ict,
-		.disable = iwl_disable_ict,
-	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index d22e006..f602af4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -292,13 +292,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.isr_ops = {
-		.isr = iwl_isr_ict,
-		.free = iwl_free_isr_ict,
-		.alloc = iwl_alloc_isr_ict,
-		.reset = iwl_reset_ict,
-		.disable = iwl_disable_ict,
-	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index de0e86a..fb00464 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -378,13 +378,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.isr_ops = {
-		.isr = iwl_isr_ict,
-		.free = iwl_free_isr_ict,
-		.alloc = iwl_alloc_isr_ict,
-		.reset = iwl_reset_ict,
-		.disable = iwl_disable_ict,
-	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
@@ -440,13 +433,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.isr_ops = {
-		.isr = iwl_isr_ict,
-		.free = iwl_free_isr_ict,
-		.alloc = iwl_alloc_isr_ict,
-		.reset = iwl_reset_ict,
-		.disable = iwl_disable_ict,
-	},
 	.temp_ops = {
 		.temperature = iwl5150_temperature,
 	 },
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index be2dbf7..24d105b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -320,13 +320,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.isr_ops = {
-		.isr = iwl_isr_ict,
-		.free = iwl_free_isr_ict,
-		.alloc = iwl_alloc_isr_ict,
-		.reset = iwl_reset_ict,
-		.disable = iwl_disable_ict,
-	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
@@ -385,13 +378,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.isr_ops = {
-		.isr = iwl_isr_ict,
-		.free = iwl_free_isr_ict,
-		.alloc = iwl_alloc_isr_ict,
-		.reset = iwl_reset_ict,
-		.disable = iwl_disable_ict,
-	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a2f9237..761e60c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2398,8 +2398,7 @@ static void __iwl_down(struct iwl_priv *priv)
 				STATUS_EXIT_PENDING;
 
 	/* device going down, Stop using ICT table */
-	if (priv->cfg->ops->lib->isr_ops.disable)
-		priv->cfg->ops->lib->isr_ops.disable(priv);
+	iwl_disable_ict(priv);
 
 	iwlagn_txq_ctx_stop(priv);
 	iwlagn_rxq_stop(priv);
@@ -2603,8 +2602,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
 		return;
 
 	/* enable dram interrupt */
-	if (priv->cfg->ops->lib->isr_ops.reset)
-		priv->cfg->ops->lib->isr_ops.reset(priv);
+	iwl_reset_ict(priv);
 
 	mutex_lock(&priv->mutex);
 	iwl_alive_start(priv);
@@ -3956,10 +3954,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_enable_msi(priv->pci_dev);
 
-	if (priv->cfg->ops->lib->isr_ops.alloc)
-		priv->cfg->ops->lib->isr_ops.alloc(priv);
+	iwl_alloc_isr_ict(priv);
 
-	err = request_irq(priv->pci_dev->irq, priv->cfg->ops->lib->isr_ops.isr,
+	err = request_irq(priv->pci_dev->irq, iwl_isr_ict,
 			  IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
@@ -4006,8 +4003,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	free_irq(priv->pci_dev->irq, priv);
-	if (priv->cfg->ops->lib->isr_ops.free)
-		priv->cfg->ops->lib->isr_ops.free(priv);
+	iwl_free_isr_ict(priv);
  out_disable_msi:
 	pci_disable_msi(priv->pci_dev);
 	iwl_uninit_drv(priv);
@@ -4105,8 +4101,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 
 	iwl_uninit_drv(priv);
 
-	if (priv->cfg->ops->lib->isr_ops.free)
-		priv->cfg->ops->lib->isr_ops.free(priv);
+	iwl_free_isr_ict(priv);
 
 	dev_kfree_skb(priv->beacon_skb);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ada76af..82939f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -122,14 +122,6 @@ struct iwl_apm_ops {
 	void (*config)(struct iwl_priv *priv);
 };
 
-struct iwl_isr_ops {
-	irqreturn_t (*isr) (int irq, void *data);
-	void (*free)(struct iwl_priv *priv);
-	int (*alloc)(struct iwl_priv *priv);
-	int (*reset)(struct iwl_priv *priv);
-	void (*disable)(struct iwl_priv *priv);
-};
-
 struct iwl_debugfs_ops {
 	ssize_t (*rx_stats_read)(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos);
@@ -194,9 +186,6 @@ struct iwl_lib_ops {
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
 
-	/* isr */
-	struct iwl_isr_ops isr_ops;
-
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 
-- 
1.7.0.4

