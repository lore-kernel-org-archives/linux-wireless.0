Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYKGR6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/13] iwlwifi: don't fail power set when calibration is not done yet
Date: Fri,  7 Nov 2008 09:58:37 -0800
Message-Id: <1226080726-24860-5-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185822_149287_C9A71E4A)
In-Reply-To: <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch doesn't fail power save setting when calibration is
not done yet. The new power index is registered and will
be evaluated again anyway upon calibration completion.

This patch also eliminates WARN_ON in mac80211 hw_config during
initialization

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 07a5f60..b429daa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -257,15 +257,11 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 	struct iwl_power_mgr *setting = &(priv->power_data);
 	int ret = 0;
 	u16 uninitialized_var(final_mode);
+	bool update_chains;
 
 	/* Don't update the RX chain when chain noise calibration is running */
-	if (priv->chain_noise_data.state != IWL_CHAIN_NOISE_DONE &&
-	    priv->chain_noise_data.state != IWL_CHAIN_NOISE_ALIVE) {
-		IWL_DEBUG_POWER("Cannot update the power, chain noise "
-			"calibration running: %d\n",
-			priv->chain_noise_data.state);
-		return -EAGAIN;
-	}
+	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
+			priv->chain_noise_data.state == IWL_CHAIN_NOISE_ALIVE;
 
 	/* If on battery, set to 3,
 	 * if plugged into AC power, set to CAM ("continuously aware mode"),
@@ -313,9 +309,12 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 		else
 			set_bit(STATUS_POWER_PMI, &priv->status);
 
-		if (priv->cfg->ops->lib->update_chain_flags)
+		if (priv->cfg->ops->lib->update_chain_flags && update_chains)
 			priv->cfg->ops->lib->update_chain_flags(priv);
-
+		else
+			IWL_DEBUG_POWER("Cannot update the power, chain noise "
+					"calibration running: %d\n",
+					priv->chain_noise_data.state);
 		if (!ret)
 			setting->power_mode = final_mode;
 	}
-- 
1.5.4.3

