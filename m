Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYDXAPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/16] iwlwifi: add apm init handler
Date: Wed, 23 Apr 2008 17:14:53 -0700
Message-Id: <1208996108-15326-2-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021604_932357_26B26889)
In-Reply-To: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch add apm init handler to iwlcore handler

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   93 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   18 ++----
 3 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2c5bfa4..b8c7215 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -694,62 +694,71 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
  error_kw:
 	return rc;
 }
-
-int iwl4965_hw_nic_init(struct iwl_priv *priv)
+static int iwl4965_apm_init(struct iwl_priv *priv)
 {
-	int rc;
 	unsigned long flags;
-	struct iwl4965_rx_queue *rxq = &priv->rxq;
-	u8 rev_id;
-	u8 val_link;
-	u16 sku_cap;
-	u32 val;
+	int ret = 0;
 
-	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
-
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-		    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
+	/* set "initialization complete" bit to move adapter
+	 * D0U* --> D0A* state */
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (rc < 0) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		IWL_DEBUG_INFO("Failed to init the card\n");
-		return rc;
-	}
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
+	/* wait for clock stabilization */
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (ret < 0) {
+		IWL_DEBUG_INFO("Failed to init the card\n");
+		goto out;
 	}
 
-	iwl_read_prph(priv, APMG_CLK_CTRL_REG);
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		goto out;
 
+	/* enable DMA */
 	iwl_write_prph(priv, APMG_CLK_CTRL_REG,
 			APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
-	iwl_read_prph(priv, APMG_CLK_CTRL_REG);
 
 	udelay(20);
 
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-				APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
 	iwl_release_nic_access(priv);
+out:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+
+int iwl4965_hw_nic_init(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	struct iwl4965_rx_queue *rxq = &priv->rxq;
+	u8 rev_id;
+	u8 val_link;
+	u32 val;
+	int ret;
+
+	/* nic_init */
+	priv->cfg->ops->lib->apm_ops.init(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
 	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Determine HW type */
-	rc = pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
-	if (rc)
-		return rc;
+	ret = pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
+	if (ret)
+		return ret;
 
 	IWL_DEBUG_INFO("HW Revision ID = 0x%X\n", rev_id);
 
-	rc = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
+	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -782,11 +791,11 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 		    CSR49_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR49_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc < 0) {
+	ret = iwl_grab_nic_access(priv);
+	if (ret < 0) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		IWL_DEBUG_INFO("Failed to init the card\n");
-		return rc;
+		return ret;
 	}
 
 	iwl_read_prph(priv, APMG_PS_CTRL_REG);
@@ -803,8 +812,8 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
-		rc = iwl4965_rx_queue_alloc(priv);
-		if (rc) {
+		ret = iwl4965_rx_queue_alloc(priv);
+		if (ret) {
 			IWL_ERROR("Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
@@ -827,16 +836,9 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Allocate and init all Tx and Command queues */
-	rc = iwl4965_txq_ctx_reset(priv);
-	if (rc)
-		return rc;
-
-	sku_cap = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
-	if (sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
-		IWL_DEBUG_RF_KILL("SW RF KILL supported in EEPROM.\n");
-
-	if (sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
-		IWL_DEBUG_RF_KILL("HW RF KILL supported in EEPROM.\n");
+	ret = iwl4965_txq_ctx_reset(priv);
+	if (ret)
+		return ret;
 
 	set_bit(STATUS_INIT, &priv->status);
 
@@ -4344,6 +4346,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.alive_notify = iwl4965_alive_notify,
 	.load_ucode = iwl4965_load_bsm,
 	.apm_ops = {
+		.init = iwl4965_apm_init,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 79e9793..edda2ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -115,7 +115,9 @@ struct iwl_lib_ops {
 	int (*load_ucode)(struct iwl_priv *priv);
 	/* rfkill */
 	void (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
+	 /* power management */
 	struct {
+		int (*init)(struct iwl_priv *priv);
 		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
 	} apm_ops;
 	/* power */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6842de8..3953527 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7463,21 +7463,15 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	printk(KERN_INFO DRV_NAME
 		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
 
-	/*****************
-	 * 4. Read EEPROM
-	 *****************/
-	/* nic init */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-		CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	err = iwl_poll_bit(priv, CSR_GP_CNTRL,
-		CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-		CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	/* amp init */
+	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
-		IWL_DEBUG_INFO("Failed to init the card\n");
+		IWL_DEBUG_INFO("Failed to init APMG\n");
 		goto out_iounmap;
 	}
+	/*****************
+	 * 4. Read EEPROM
+	 *****************/
 	/* Read the EEPROM */
 	err = iwl_eeprom_init(priv);
 	if (err) {
-- 
1.5.3.4

