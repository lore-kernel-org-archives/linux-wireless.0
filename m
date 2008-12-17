Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbYLQI7q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:46 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wu Fengguang <fengguang.wu@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/8] iwlwifi: remove useless goto
Date: Wed, 17 Dec 2008 16:52:31 +0800
Message-Id: <1229503954-30347-6-git-send-email-yi.zhu@intel.com> (sfid-20081217_095950_206467_6BE68708)
In-Reply-To: <1229503954-30347-5-git-send-email-yi.zhu@intel.com>
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-2-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-3-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-4-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wu Fengguang <fengguang.wu@intel.com>

The patch removes some useless goto in code cleanup.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3a78d86..5a72bc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -426,7 +426,6 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 
 static int iwl4965_apm_stop_master(struct iwl_priv *priv)
 {
-	int ret = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -434,16 +433,13 @@ static int iwl4965_apm_stop_master(struct iwl_priv *priv)
 	/* set stop master bit */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	ret = iwl_poll_direct_bit(priv, CSR_RESET,
+	iwl_poll_direct_bit(priv, CSR_RESET,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-	if (ret < 0)
-		goto out;
 
-out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	IWL_DEBUG_INFO("stop master\n");
 
-	return ret;
+	return 0;
 }
 
 static void iwl4965_apm_stop(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7f3a921..66d053d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -73,7 +73,6 @@ static const u16 iwl5000_default_queue_to_tx_fifo[] = {
 /* FIXME: same implementation as 4965 */
 static int iwl5000_apm_stop_master(struct iwl_priv *priv)
 {
-	int ret = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -81,16 +80,13 @@ static int iwl5000_apm_stop_master(struct iwl_priv *priv)
 	/* set stop master bit */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	ret = iwl_poll_direct_bit(priv, CSR_RESET,
+	iwl_poll_direct_bit(priv, CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-	if (ret < 0)
-		goto out;
 
-out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	IWL_DEBUG_INFO("stop master\n");
 
-	return ret;
+	return 0;
 }
 
 
-- 
1.5.3.6

