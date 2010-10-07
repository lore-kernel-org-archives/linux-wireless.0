Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab0JGXIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/22] iwlwifi: rename iwl_mac_beacon_update
Date: Thu,  7 Oct 2010 16:07:44 -0700
Message-Id: <1286492881-15743-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Rename iwl_mac_beacon_update to iwlcore_beacon_update
and make the calling convention a bit different. The
old name with _mac_ indicated that it was a mac80211
callback, but that's no longer true.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   35 +++++++++++++++----------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index dd7c3cb..71f245f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1617,25 +1617,25 @@ static inline void iwl_set_no_assoc(struct iwl_priv *priv,
 	iwlcore_commit_rxon(priv, ctx);
 }
 
-static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void iwlcore_beacon_update(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 	__le64 timestamp;
+	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
 
-	IWL_DEBUG_MAC80211(priv, "enter\n");
+	if (!skb)
+		return;
+
+	IWL_DEBUG_ASSOC(priv, "enter\n");
 
 	lockdep_assert_held(&priv->mutex);
 
 	if (!priv->beacon_ctx) {
 		IWL_ERR(priv, "update beacon but no beacon context!\n");
 		dev_kfree_skb(skb);
-		return -EINVAL;
-	}
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
+		return;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1648,12 +1648,16 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
 	priv->timestamp = le64_to_cpu(timestamp);
 
-	IWL_DEBUG_MAC80211(priv, "leave\n");
+	IWL_DEBUG_ASSOC(priv, "leave\n");
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	priv->cfg->ops->lib->post_associate(priv, priv->beacon_ctx->vif);
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
+		return;
+	}
 
-	return 0;
+	priv->cfg->ops->lib->post_associate(priv, priv->beacon_ctx->vif);
 }
 
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
@@ -1735,13 +1739,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	 * mac80211 decides to do both changes at once because
 	 * it will invoke post_associate.
 	 */
-	if (vif->type == NL80211_IFTYPE_ADHOC &&
-	    changes & BSS_CHANGED_BEACON) {
-		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
-
-		if (beacon)
-			iwl_mac_beacon_update(hw, beacon);
-	}
+	if (vif->type == NL80211_IFTYPE_ADHOC && changes & BSS_CHANGED_BEACON)
+		iwlcore_beacon_update(hw, vif);
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
-- 
1.7.0.4

