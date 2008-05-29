Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYE2IhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:23 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 13/43] iwlwifi: implement apm stop function
Date: Thu, 29 May 2008 16:34:58 +0800
Message-Id: <1212050128-17132-14-git-send-email-yi.zhu@intel.com> (sfid-20080529_110545_463864_1955BD4F)
In-Reply-To: <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds apm stop function for 4965 and 5000.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   19 ++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c |   20 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 646c589..080fc54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -642,6 +642,22 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl_hw_txq_ctx_free(priv);
 }
 
+static void iwl4965_apm_stop(struct iwl_priv *priv)
+{
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
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
 static int iwl4965_apm_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -658,6 +674,7 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
 	/* FIXME: put here L1A -L0S w/a */
 
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
 	ret = iwl_poll_bit(priv, CSR_RESET,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25);
@@ -689,7 +706,6 @@ out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
-
 }
 
 #define REG_RECALIB_PERIOD (60)
@@ -3625,6 +3641,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.apm_ops = {
 		.init = iwl4965_apm_init,
 		.reset = iwl4965_apm_reset,
+		.stop = iwl4965_apm_stop,
 		.config = iwl4965_nic_config,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 10054bd..27cfe3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -100,6 +100,25 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
+/* FIXME: this is indentical to 4965 */
+static void iwl5000_apm_stop(struct iwl_priv *priv)
+{
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
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+
 static int iwl5000_apm_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -859,6 +878,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
+		.stop = iwl5000_apm_stop,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d82660c..d6e6985 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -125,6 +125,7 @@ struct iwl_lib_ops {
 	struct {
 		int (*init)(struct iwl_priv *priv);
 		int (*reset)(struct iwl_priv *priv);
+		void (*stop)(struct iwl_priv *priv);
 		void (*config)(struct iwl_priv *priv);
 		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
 	} apm_ops;
-- 
1.5.3.6

