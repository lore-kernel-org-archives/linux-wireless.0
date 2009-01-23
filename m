Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbZAWVmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/15] iwl3945: Define send_tx_power
Date: Fri, 23 Jan 2009 13:45:11 -0800
Message-Id: <1232747123-7261-4-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224257_832812_C779910F)
In-Reply-To: <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

We can define this iwl_lib ops for 3945, as this would help us cleaning the
scanning code.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4aeb101..602a3a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1705,12 +1705,12 @@ static void iwl3945_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_in
 }
 
 /**
- * iwl3945_hw_reg_send_txpower - fill in Tx Power command with gain settings
+ * iwl3945_send_tx_power - fill in Tx Power command with gain settings
  *
  * Configures power settings for all rates for the current channel,
  * using values from channel info struct, and send to NIC
  */
-int iwl3945_hw_reg_send_txpower(struct iwl_priv *priv)
+int iwl3945_send_tx_power(struct iwl_priv *priv)
 {
 	int rate_idx, i;
 	const struct iwl_channel_info *ch_info = NULL;
@@ -1935,7 +1935,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 	}
 
 	/* send Txpower command for current channel to ucode */
-	return iwl3945_hw_reg_send_txpower(priv);
+	return priv->cfg->ops->lib->send_tx_power(priv);
 }
 
 int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
@@ -2712,6 +2712,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 		.config = iwl3945_nic_config,
 		.set_pwr_src = iwl3945_set_pwr_src,
 	},
+	.send_tx_power	= iwl3945_send_tx_power,
 };
 
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index de8c8d7..997ac33 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -744,7 +744,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	rc = iwl3945_hw_reg_send_txpower(priv);
+	rc = priv->cfg->ops->lib->send_tx_power(priv);
 	if (rc) {
 		IWL_ERR(priv, "Error setting Tx power (%d).\n", rc);
 		return rc;
@@ -5517,7 +5517,7 @@ static void iwl3945_bg_scan_completed(struct work_struct *work)
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	mutex_lock(&priv->mutex);
-	iwl3945_hw_reg_send_txpower(priv);
+	priv->cfg->ops->lib->send_tx_power(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.5.4.3

