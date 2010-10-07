Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab0JGXIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/22] iwl3945: use iwl3945_commit_rxon
Date: Thu,  7 Oct 2010 16:07:42 -0700
Message-Id: <1286492881-15743-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to go via the indirect function
call from within the 3945 subdriver.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 ++++++++--------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 87943a8..ef67087 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1763,8 +1763,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv,
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-static int iwl3945_commit_rxon(struct iwl_priv *priv,
-			       struct iwl_rxon_context *ctx)
+int iwl3945_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	/* cast away the const for active_rxon in this function */
 	struct iwl3945_rxon_cmd *active_rxon = (void *)&ctx->active;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 7ad4aff..77e8e19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -271,6 +271,9 @@ extern void iwl3945_post_associate(struct iwl_priv *priv,
 extern void iwl3945_config_ap(struct iwl_priv *priv,
 			      struct ieee80211_vif *vif);
 
+extern int iwl3945_commit_rxon(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx);
+
 /**
  * iwl3945_hw_find_station - Find station id for a given BSSID
  * @bssid: MAC address of station ID to find
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index db148d0..64eb049 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2547,7 +2547,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	priv->cfg->ops->hcmd->send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
-	iwlcore_commit_rxon(priv, ctx);
+	iwl3945_commit_rxon(priv, ctx);
 
 	iwl3945_reg_txpower_periodic(priv);
 
@@ -2992,7 +2992,7 @@ void iwl3945_post_scan(struct iwl_priv *priv)
 	 * performing the scan, fire one off if needed
 	 */
 	if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
-		iwlcore_commit_rxon(priv, ctx);
+		iwl3945_commit_rxon(priv, ctx);
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
@@ -3061,7 +3061,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv, ctx);
+	iwl3945_commit_rxon(priv, ctx);
 
 	rc = iwl_send_rxon_timing(priv, ctx);
 	if (rc)
@@ -3087,7 +3087,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
-	iwlcore_commit_rxon(priv, ctx);
+	iwl3945_commit_rxon(priv, ctx);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -3226,7 +3226,7 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		/* RXON - unassoc (to set timing command) */
 		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv, ctx);
+		iwl3945_commit_rxon(priv, ctx);
 
 		/* RXON Timing */
 		rc = iwl_send_rxon_timing(priv, ctx);
@@ -3253,7 +3253,7 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		}
 		/* restore RXON assoc */
 		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv, ctx);
+		iwl3945_commit_rxon(priv, ctx);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
@@ -3519,7 +3519,7 @@ static ssize_t store_flags(struct device *d,
 			IWL_DEBUG_INFO(priv, "Committing rxon.flags = 0x%04X\n",
 				       flags);
 			ctx->staging.flags = cpu_to_le32(flags);
-			iwlcore_commit_rxon(priv, ctx);
+			iwl3945_commit_rxon(priv, ctx);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -3557,7 +3557,7 @@ static ssize_t store_filter_flags(struct device *d,
 				       "0x%04X\n", filter_flags);
 			ctx->staging.filter_flags =
 				cpu_to_le32(filter_flags);
-			iwlcore_commit_rxon(priv, ctx);
+			iwl3945_commit_rxon(priv, ctx);
 		}
 	}
 	mutex_unlock(&priv->mutex);
-- 
1.7.0.4

