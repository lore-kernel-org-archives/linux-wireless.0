Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759730AbYEWCLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:53 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: implement apm reset flow
Date: Fri, 23 May 2008 10:09:16 +0800
Message-Id: <1211508569-3163-39-git-send-email-yi.zhu@intel.com> (sfid-20080523_042835_581129_B4B60DAF)
In-Reply-To: <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch implements apm reset flow for 4965 and 5000.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   36 +++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   54 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +-
 5 files changed, 79 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 02d3dc0..639ad50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -646,9 +646,9 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl_hw_txq_ctx_free(priv);
 }
 
-int iwl4965_hw_nic_reset(struct iwl_priv *priv)
+static int iwl4965_apm_reset(struct iwl_priv *priv)
 {
-	int rc = 0;
+	int ret = 0;
 	unsigned long flags;
 
 	iwl4965_hw_nic_stop_master(priv);
@@ -659,33 +659,40 @@ int iwl4965_hw_nic_reset(struct iwl_priv *priv)
 
 	udelay(10);
 
+	/* FIXME: put here L1A -L0S w/a */
+
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl_poll_bit(priv, CSR_RESET,
+	ret = iwl_poll_bit(priv, CSR_RESET,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25);
 
+	if (ret)
+		goto out;
+
 	udelay(10);
 
-	rc = iwl_grab_nic_access(priv);
-	if (!rc) {
-		iwl_write_prph(priv, APMG_CLK_EN_REG,
-				APMG_CLK_VAL_DMA_CLK_RQT |
-				APMG_CLK_VAL_BSM_CLK_RQT);
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		goto out;
+	/* Enable DMA and BSM Clock */
+	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT |
+					      APMG_CLK_VAL_BSM_CLK_RQT);
 
-		udelay(10);
+	udelay(10);
 
-		iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-					APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+	/* disable L1A */
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-		iwl_release_nic_access(priv);
-	}
+	iwl_release_nic_access(priv);
 
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
+out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return rc;
+	return ret;
 
 }
 
@@ -3621,6 +3628,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.load_ucode = iwl4965_load_bsm,
 	.apm_ops = {
 		.init = iwl4965_apm_init,
+		.reset = iwl4965_apm_reset,
 		.config = iwl4965_nic_config,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b1c5045..10054bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -100,6 +100,59 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
+static int iwl5000_apm_reset(struct iwl_priv *priv)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	iwl4965_hw_nic_stop_master(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+	udelay(10);
+
+
+	/* FIXME: put here L1A -L0S w/a */
+
+	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
+
+	/* set "initialization complete" bit to move adapter
+	 * D0U* --> D0A* state */
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/* wait for clock stabilization */
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (ret < 0) {
+		IWL_DEBUG_INFO("Failed to init the card\n");
+		goto out;
+	}
+
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		goto out;
+
+	/* enable DMA */
+	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+
+	udelay(20);
+
+	/* disable L1-Active */
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+
+	iwl_release_nic_access(priv);
+
+out:
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return ret;
+}
+
+
 static void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -805,6 +858,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.alive_notify = iwl5000_alive_notify,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
+		.reset = iwl5000_apm_reset,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e75bf34..70cc9d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -124,6 +124,7 @@ struct iwl_lib_ops {
 	 /* power management */
 	struct {
 		int (*init)(struct iwl_priv *priv);
+		int (*reset)(struct iwl_priv *priv);
 		void (*config)(struct iwl_priv *priv);
 		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
 	} apm_ops;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4c31164..38bd497 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -689,7 +689,6 @@ extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
-extern int iwl4965_hw_nic_reset(struct iwl_priv *priv);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 857ec37..3cc55ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3425,9 +3425,8 @@ static void __iwl4965_down(struct iwl_priv *priv)
 
 	udelay(5);
 
-	iwl4965_hw_nic_stop_master(priv);
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	iwl4965_hw_nic_reset(priv);
+	/* FIXME: apm_ops.suspend(priv) */
+	priv->cfg->ops->lib->apm_ops.reset(priv);
 	priv->cfg->ops->lib->free_shared_mem(priv);
 
  exit:
-- 
1.5.3.6

