Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYE2IhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:24 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 14/43] iwlwifi: refactor stop master function
Date: Thu, 29 May 2008 16:34:59 +0800
Message-Id: <1212050128-17132-15-git-send-email-yi.zhu@intel.com> (sfid-20080529_110546_819556_22EE33E6)
In-Reply-To: <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
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
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch refactors stop master function for 4965 and 5000.
Currently it duplicates the function.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   60 +++++++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c |   29 ++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 3 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 080fc54..c586490 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -579,39 +579,6 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-int iwl4965_hw_nic_stop_master(struct iwl_priv *priv)
-{
-	int rc = 0;
-	u32 reg_val;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* set stop master bit */
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
-
-	reg_val = iwl_read32(priv, CSR_GP_CNTRL);
-
-	if (CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE ==
-	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE))
-		IWL_DEBUG_INFO("Card in power save, master is already "
-			       "stopped\n");
-	else {
-		rc = iwl_poll_bit(priv, CSR_RESET,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-		if (rc < 0) {
-			spin_unlock_irqrestore(&priv->lock, flags);
-			return rc;
-		}
-	}
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_INFO("stop master\n");
-
-	return rc;
-}
-
 /**
  * iwl4965_hw_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
  */
@@ -642,11 +609,34 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl_hw_txq_ctx_free(priv);
 }
 
+static int iwl4965_apm_stop_master(struct iwl_priv *priv)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* set stop master bit */
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+
+	ret = iwl_poll_bit(priv, CSR_RESET,
+				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
+				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+	if (ret < 0)
+		goto out;
+
+out:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	IWL_DEBUG_INFO("stop master\n");
+
+	return ret;
+}
+
 static void iwl4965_apm_stop(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
-	iwl4965_hw_nic_stop_master(priv);
+	iwl4965_apm_stop_master(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -663,7 +653,7 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
 	int ret = 0;
 	unsigned long flags;
 
-	iwl4965_hw_nic_stop_master(priv);
+	iwl4965_apm_stop_master(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 27cfe3c..d607452 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -56,6 +56,31 @@ static const u16 iwl5000_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_HCCA_2
 };
 
+/* FIXME: same implementation as 4965 */
+static int iwl5000_apm_stop_master(struct iwl_priv *priv)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* set stop master bit */
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+
+	ret = iwl_poll_bit(priv, CSR_RESET,
+				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
+				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+	if (ret < 0)
+		goto out;
+
+out:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	IWL_DEBUG_INFO("stop master\n");
+
+	return ret;
+}
+
+
 static int iwl5000_apm_init(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -105,7 +130,7 @@ static void iwl5000_apm_stop(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
-	iwl4965_hw_nic_stop_master(priv);
+	iwl5000_apm_stop_master(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -124,7 +149,7 @@ static int iwl5000_apm_reset(struct iwl_priv *priv)
 	int ret = 0;
 	unsigned long flags;
 
-	iwl4965_hw_nic_stop_master(priv);
+	iwl5000_apm_stop_master(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d193da3..44bd827 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -686,7 +686,6 @@ extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
 extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
-extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
-- 
1.5.3.6

