Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759975AbYEWCL4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:56 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: refactor stop master function
Date: Fri, 23 May 2008 10:09:18 +0800
Message-Id: <1211508569-3163-41-git-send-email-yi.zhu@intel.com> (sfid-20080523_042833_639020_CC2067DD)
In-Reply-To: <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
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
 <1211508569-3163-39-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
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
index 378fd83..c10ac72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -583,39 +583,6 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
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
@@ -646,11 +613,34 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
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
 
@@ -667,7 +657,7 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
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
index 38bd497..dfbf728 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -687,7 +687,6 @@ extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
 extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
-extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
-- 
1.5.3.6

