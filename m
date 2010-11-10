Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab0KJSBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/16] iwlwifi: put all the isr related function under ops
Date: Wed, 10 Nov 2010 09:56:40 -0800
Message-Id: <1289411810-23093-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were two type of isr supported by iwlwifi devices.
  legacy isr - only used by legacy devices (3945 & 4965)
  ict isr - used by all new generation of iwlwifi devices

Move all the isr related functions into ops, the ict type of isr
supports only needed for newer devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    8 +++++++-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   16 ++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   16 ++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   18 ++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   12 +++++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 9 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index b85a9c8..01aa246 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -11,14 +11,14 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
-iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
+iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
 iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx.o iwl-agn-calib.o
 iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
-iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o
+iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o iwl-agn-ict.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index baedea8..068f1e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -211,7 +211,13 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.isr = iwl_isr_ict,
+	.isr_ops = {
+		.isr = iwl_isr_ict,
+		.free = iwl_free_isr_ict,
+		.alloc = iwl_alloc_isr_ict,
+		.reset = iwl_reset_ict,
+		.disable = iwl_disable_ict,
+	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 3854d5c..7d3e414 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2723,7 +2723,9 @@ static struct iwl_lib_ops iwl3945_lib = {
 	},
 	.send_tx_power	= iwl3945_send_tx_power,
 	.is_valid_rtc_data_addr = iwl3945_hw_valid_rtc_data_addr,
-	.isr = iwl_isr_legacy,
+	.isr_ops = {
+		.isr = iwl_isr_legacy,
+	},
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl3945_good_plcp_health,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6a3c0ce..c515671 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2565,7 +2565,9 @@ static struct iwl_lib_ops iwl4965_lib = {
 	},
 	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
-	.isr = iwl_isr_legacy,
+	.isr_ops = {
+		.isr = iwl_isr_legacy,
+	},
 	.temp_ops = {
 		.temperature = iwl4965_temperature_calib,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e1f412f..ad43f0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -385,7 +385,13 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.isr = iwl_isr_ict,
+	.isr_ops = {
+		.isr = iwl_isr_ict,
+		.free = iwl_free_isr_ict,
+		.alloc = iwl_alloc_isr_ict,
+		.reset = iwl_reset_ict,
+		.disable = iwl_disable_ict,
+	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
@@ -449,7 +455,13 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.isr = iwl_isr_ict,
+	.isr_ops = {
+		.isr = iwl_isr_ict,
+		.free = iwl_free_isr_ict,
+		.alloc = iwl_alloc_isr_ict,
+		.reset = iwl_reset_ict,
+		.disable = iwl_disable_ict,
+	},
 	.temp_ops = {
 		.temperature = iwl5150_temperature,
 	 },
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b181690..21ac281 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -322,7 +322,13 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.isr = iwl_isr_ict,
+	.isr_ops = {
+		.isr = iwl_isr_ict,
+		.free = iwl_free_isr_ict,
+		.alloc = iwl_alloc_isr_ict,
+		.reset = iwl_reset_ict,
+		.disable = iwl_disable_ict,
+	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
@@ -389,7 +395,13 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.isr = iwl_isr_ict,
+	.isr_ops = {
+		.isr = iwl_isr_ict,
+		.free = iwl_free_isr_ict,
+		.alloc = iwl_alloc_isr_ict,
+		.reset = iwl_reset_ict,
+		.disable = iwl_disable_ict,
+	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4d7eb0e..c6ed141 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2815,7 +2815,8 @@ static void __iwl_down(struct iwl_priv *priv)
 				STATUS_EXIT_PENDING;
 
 	/* device going down, Stop using ICT table */
-	iwl_disable_ict(priv);
+	if (priv->cfg->ops->lib->isr_ops.disable)
+		priv->cfg->ops->lib->isr_ops.disable(priv);
 
 	iwlagn_txq_ctx_stop(priv);
 	iwlagn_rxq_stop(priv);
@@ -3038,7 +3039,8 @@ static void iwl_bg_alive_start(struct work_struct *data)
 		return;
 
 	/* enable dram interrupt */
-	iwl_reset_ict(priv);
+	if (priv->cfg->ops->lib->isr_ops.reset)
+		priv->cfg->ops->lib->isr_ops.reset(priv);
 
 	mutex_lock(&priv->mutex);
 	iwl_alive_start(priv);
@@ -4167,8 +4169,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_enable_msi(priv->pci_dev);
 
-	iwl_alloc_isr_ict(priv);
-	err = request_irq(priv->pci_dev->irq, priv->cfg->ops->lib->isr,
+	if (priv->cfg->ops->lib->isr_ops.alloc)
+		priv->cfg->ops->lib->isr_ops.alloc(priv);
+
+	err = request_irq(priv->pci_dev->irq, priv->cfg->ops->lib->isr_ops.isr,
 			  IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
@@ -4215,7 +4219,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	free_irq(priv->pci_dev->irq, priv);
-	iwl_free_isr_ict(priv);
+	if (priv->cfg->ops->lib->isr_ops.free)
+		priv->cfg->ops->lib->isr_ops.free(priv);
  out_disable_msi:
 	pci_disable_msi(priv->pci_dev);
 	iwl_uninit_drv(priv);
@@ -4310,7 +4315,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 
 	iwl_uninit_drv(priv);
 
-	iwl_free_isr_ict(priv);
+	if (priv->cfg->ops->lib->isr_ops.free)
+		priv->cfg->ops->lib->isr_ops.free(priv);
 
 	dev_kfree_skb(priv->beacon_skb);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 81f2740..6275c05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -120,6 +120,14 @@ struct iwl_apm_ops {
 	void (*config)(struct iwl_priv *priv);
 };
 
+struct iwl_isr_ops {
+	irqreturn_t (*isr) (int irq, void *data);
+	void (*free)(struct iwl_priv *priv);
+	int (*alloc)(struct iwl_priv *priv);
+	int (*reset)(struct iwl_priv *priv);
+	void (*disable)(struct iwl_priv *priv);
+};
+
 struct iwl_debugfs_ops {
 	ssize_t (*rx_stats_read)(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos);
@@ -193,7 +201,9 @@ struct iwl_lib_ops {
 	/* power */
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
-	irqreturn_t (*isr) (int irq, void *data);
+
+	/* isr */
+	struct iwl_isr_ops isr_ops;
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 43ff17a..db11c54 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4120,7 +4120,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_enable_msi(priv->pci_dev);
 
-	err = request_irq(priv->pci_dev->irq, priv->cfg->ops->lib->isr,
+	err = request_irq(priv->pci_dev->irq, priv->cfg->ops->lib->isr_ops.isr,
 			  IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
-- 
1.7.0.4

