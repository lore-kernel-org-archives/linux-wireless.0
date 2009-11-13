Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbZKMT4r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/16] iwlwifi: make iwlwifi send beacons
Date: Fri, 13 Nov 2009 11:56:34 -0800
Message-Id: <1258142198-3223-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Handle BSS_CHANGED_BEACON_ENABLED to enable the sending
of beacons. Also set the correct HT RXON and QoS config.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 ++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 24f3192..6db7447 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2564,6 +2564,10 @@ void iwl_config_ap(struct iwl_priv *priv)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
+		/* AP has all antennas */
+		priv->chain_noise_data.active_chains =
+			priv->hw_params.valid_rx_ant;
+		iwl_set_rxon_ht(priv, &priv->current_ht_config);
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
@@ -2592,6 +2596,7 @@ void iwl_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
+		iwl_reset_qos(priv);
 		spin_lock_irqsave(&priv->lock, flags);
 		iwl_activate_qos(priv, 1);
 		spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 294d50c..3d49a65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2498,6 +2498,14 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if ((changes & BSS_CHANGED_BEACON_ENABLED) &&
+	    vif->bss_conf.enable_beacon) {
+		memcpy(priv->staging_rxon.bssid_addr,
+		       bss_conf->bssid, ETH_ALEN);
+		memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
+		iwlcore_config_ap(priv);
+	}
+
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-- 
1.5.6.3

