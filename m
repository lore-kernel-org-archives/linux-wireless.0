Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZHGWl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/16] iwlwifi: handle the case when set power fail
Date: Fri,  7 Aug 2009 15:41:47 -0700
Message-Id: <1249684912-22936-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Modify the power update function, when driver fail to set the power, it
should not continue move forward and try to change the rx chain
configuration.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index bd97a0d..9e8916d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -282,18 +282,21 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 			cmd.flags |= IWL_POWER_FAST_PD;
 
 		ret = iwl_set_power(priv, &cmd);
-
-		if (final_mode == IWL_POWER_MODE_CAM)
-			clear_bit(STATUS_POWER_PMI, &priv->status);
-
-		if (priv->cfg->ops->lib->update_chain_flags && update_chains)
-			priv->cfg->ops->lib->update_chain_flags(priv);
-		else
-			IWL_DEBUG_POWER(priv, "Cannot update the power, chain noise "
+		if (!ret) {
+			if (final_mode == IWL_POWER_MODE_CAM)
+				clear_bit(STATUS_POWER_PMI, &priv->status);
+
+			if (priv->cfg->ops->lib->update_chain_flags &&
+			    update_chains)
+				priv->cfg->ops->lib->update_chain_flags(priv);
+			else
+				IWL_DEBUG_POWER(priv,
+					"Cannot update the power, chain noise "
 					"calibration running: %d\n",
 					priv->chain_noise_data.state);
-		if (!ret)
 			setting->power_mode = final_mode;
+		} else
+			IWL_ERR(priv, "set power fail, ret = %d", ret);
 	}
 
 	return ret;
-- 
1.5.6.3

