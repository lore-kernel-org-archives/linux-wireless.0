Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYLSCpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:40 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 38/43] iwl3945: add apm ops
Date: Fri, 19 Dec 2008 10:37:38 +0800
Message-Id: <1229654263-21454-39-git-send-email-yi.zhu@intel.com> (sfid-20081219_034631_445721_28010517)
In-Reply-To: <1229654263-21454-38-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-35-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-36-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-37-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-38-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch adds 3945 iwl_lib_ops->apm_ops to the driver.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  134 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +-
 2 files changed, 88 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 433be63..3ea36f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1078,50 +1078,54 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 	return rc;
 }
 
-int iwl3945_hw_nic_init(struct iwl_priv *priv)
+static int iwl3945_apm_init(struct iwl_priv *priv)
 {
-	u8 rev_id;
-	int rc;
-	unsigned long flags;
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	int ret = 0;
 
 	iwl3945_power_init_handle(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR39_ANA_PLL_CFG_VAL);
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+	/* disable L0s without affecting L1 :don't wait for ICH L0s bug W/A) */
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
+	/* set "initialization complete" bit to move adapter
+	* D0U* --> D0A* state */
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (rc < 0) {
-		spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+			    CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (ret < 0) {
 		IWL_DEBUG_INFO("Failed to init the card\n");
-		return rc;
+		goto out;
 	}
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-	iwl_write_prph(priv, APMG_CLK_EN_REG,
-				 APMG_CLK_VAL_DMA_CLK_RQT |
-				 APMG_CLK_VAL_BSM_CLK_RQT);
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		goto out;
+
+	/* enable DMA */
+	iwl_write_prph(priv, APMG_CLK_CTRL_REG, APMG_CLK_VAL_DMA_CLK_RQT |
+						APMG_CLK_VAL_BSM_CLK_RQT);
+
 	udelay(20);
+
+	/* disable L1-Active */
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+
 	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
+out:
+	return ret;
+}
 
-	/* Determine HW type */
-	rc = pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
-	if (rc)
-		return rc;
-	IWL_DEBUG_INFO("HW Revision ID = 0x%X\n", rev_id);
+static void iwl3945_nic_config(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	u8 rev_id = 0;
 
-	iwl3945_nic_set_pwr_src(priv, 1);
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (rev_id & PCI_CFG_REV_ID_BIT_RTP)
@@ -1173,6 +1177,27 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 
 	if (priv->eeprom39.sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
 		IWL_DEBUG_RF_KILL("HW RF KILL supported in EEPROM.\n");
+}
+
+int iwl3945_hw_nic_init(struct iwl_priv *priv)
+{
+	u8 rev_id;
+	int rc;
+	unsigned long flags;
+	struct iwl_rx_queue *rxq = &priv->rxq;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->cfg->ops->lib->apm_ops.init(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Determine HW type */
+	rc = pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
+	if (rc)
+		return rc;
+	IWL_DEBUG_INFO("HW Revision ID = 0x%X\n", rev_id);
+
+	iwl3945_nic_set_pwr_src(priv, 1);
+	priv->cfg->ops->lib->apm_ops.config(priv);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
@@ -1257,10 +1282,9 @@ void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl3945_hw_txq_ctx_free(priv);
 }
 
-int iwl3945_hw_nic_stop_master(struct iwl_priv *priv)
+static int iwl3945_apm_stop_master(struct iwl_priv *priv)
 {
-	int rc = 0;
-	u32 reg_val;
+	int ret = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1268,33 +1292,41 @@ int iwl3945_hw_nic_stop_master(struct iwl_priv *priv)
 	/* set stop master bit */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	reg_val = iwl_read32(priv, CSR_GP_CNTRL);
+	iwl_poll_direct_bit(priv, CSR_RESET,
+			    CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 
-	if (CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE ==
-	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE))
-		IWL_DEBUG_INFO("Card in power save, master is already "
-			       "stopped\n");
-	else {
-		rc = iwl_poll_direct_bit(priv, CSR_RESET,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-		if (rc < 0) {
-			spin_unlock_irqrestore(&priv->lock, flags);
-			return rc;
-		}
-	}
+	if (ret < 0)
+		goto out;
 
+out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	IWL_DEBUG_INFO("stop master\n");
 
-	return rc;
+	return ret;
+}
+
+static void iwl3945_apm_stop(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	iwl3945_apm_stop_master(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+	udelay(10);
+	/* clear "init complete"  move adapter D0A* --> D0U state */
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-int iwl3945_hw_nic_reset(struct iwl_priv *priv)
+int iwl3945_apm_reset(struct iwl_priv *priv)
 {
 	int rc;
 	unsigned long flags;
 
-	iwl3945_hw_nic_stop_master(priv);
+	iwl3945_apm_stop_master(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -2658,6 +2690,12 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl3945_lib = {
 	.load_ucode = iwl3945_load_bsm,
+	.apm_ops = {
+		.init = iwl3945_apm_init,
+		.reset = iwl3945_apm_reset,
+		.stop = iwl3945_apm_stop,
+		.config = iwl3945_nic_config,
+	},
 };
 
 static struct iwl_ops iwl3945_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9b7fe5d..1446fa6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5478,10 +5478,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	udelay(5);
 
-	iwl3945_hw_nic_stop_master(priv);
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	iwl3945_hw_nic_reset(priv);
-
+	priv->cfg->ops->lib->apm_ops.reset(priv);
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
@@ -7559,7 +7556,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 				CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (err < 0) {
-		IWL_DEBUG_INFO("Failed to init the card\n");
+		IWL_DEBUG_INFO("Failed to init the APMG\n");
 		goto out_remove_sysfs;
 	}
 
-- 
1.5.3.6

