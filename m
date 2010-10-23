Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15024 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab0JWQSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/8] iwlwifi: fix IBSS beaconing
Date: Sat, 23 Oct 2010 09:15:42 -0700
Message-Id: <1287850546-23500-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My previous patch to clean up all RXON handling
inadvertently broke IBSS because it failed to
take into account that unlike in AP mode, IBSS
requires beacons to be sent only after setting
the RXON assoc.

Fix this, clean up the code a bit, improve the
error checking around this, and also react to
beacon changes in IBSS mode from mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   47 ++++++++++++++++++++------
 1 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 5860245..11b3d88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -72,6 +72,18 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	return ret;
 }
 
+static int iwlagn_update_beacon(struct iwl_priv *priv,
+				struct ieee80211_vif *vif)
+{
+	lockdep_assert_held(&priv->mutex);
+
+	dev_kfree_skb(priv->beacon_skb);
+	priv->beacon_skb = ieee80211_beacon_get(priv->hw, vif);
+	if (!priv->beacon_skb)
+		return -ENOMEM;
+	return iwlagn_send_beacon_cmd(priv);
+}
+
 /**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
@@ -201,17 +213,19 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	}
 
 	if (new_assoc) {
-		if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_AP ||
-				 ctx->vif->type == NL80211_IFTYPE_ADHOC)) {
-			/*
-			 * We'll run into this code path when beaconing is
-			 * enabled, but then we also need to send the beacon
-			 * to the device.
-			 */
-			dev_kfree_skb(priv->beacon_skb);
-			priv->beacon_skb = ieee80211_beacon_get(priv->hw,
-								ctx->vif);
-			iwlagn_send_beacon_cmd(priv);
+		/*
+		 * We'll run into this code path when beaconing is
+		 * enabled, but then we also need to send the beacon
+		 * to the device.
+		 */
+		if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_AP)) {
+			ret = iwlagn_update_beacon(priv, ctx->vif);
+			if (ret) {
+				IWL_ERR(priv,
+					"Error sending required beacon (%d)!\n",
+					ret);
+				return ret;
+			}
 		}
 
 		priv->start_calib = 0;
@@ -228,6 +242,11 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			return ret;
 		}
 		memcpy(active, &ctx->staging, sizeof(*active));
+
+		/* IBSS beacon needs to be sent after setting assoc */
+		if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_ADHOC))
+			if (iwlagn_update_beacon(priv, ctx->vif))
+				IWL_ERR(priv, "Error sending IBSS beacon\n");
 	}
 
 	iwl_print_rx_config_cmd(priv, ctx);
@@ -558,5 +577,11 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 				bss_conf->bssid);
 	}
 
+	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_ADHOC &&
+	    priv->beacon_ctx) {
+		if (iwlagn_update_beacon(priv, vif))
+			IWL_ERR(priv, "Error sending IBSS beacon\n");
+	}
+
 	mutex_unlock(&priv->mutex);
 }
-- 
1.7.0.4

