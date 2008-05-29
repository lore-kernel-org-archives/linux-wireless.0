Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52696 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYE2IhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:23 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 12/43] iwlwifi: implement apm reset flow
Date: Thu, 29 May 2008 16:34:57 +0800
Message-Id: <1212050128-17132-13-git-send-email-yi.zhu@intel.com> (sfid-20080529_110547_005465_789BC292)
In-Reply-To: <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
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
index bf0bd4a..646c589 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -642,9 +642,9 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl_hw_txq_ctx_free(priv);
 }
 
-int iwl4965_hw_nic_reset(struct iwl_priv *priv)
+static int iwl4965_apm_reset(struct iwl_priv *priv)
 {
-	int rc = 0;
+	int ret = 0;
 	unsigned long flags;
 
 	iwl4965_hw_nic_stop_master(priv);
@@ -655,33 +655,40 @@ int iwl4965_hw_nic_reset(struct iwl_priv *priv)
 
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
 
@@ -3617,6 +3624,7 @@ static struct iwl_lib_ops iwl4965_lib = {
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
index 9392fcf..d82660c 100644
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
index da4d606..d193da3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -688,7 +688,6 @@ extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
-extern int iwl4965_hw_nic_reset(struct iwl_priv *priv);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ee9fe56..af0ffd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3417,9 +3417,8 @@ static void __iwl4965_down(struct iwl_priv *priv)
 
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

