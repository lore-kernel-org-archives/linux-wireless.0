Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759778Ab0GWQN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/10] iwlwifi: make iwl_mac_beacon_update static
Date: Fri, 23 Jul 2010 09:15:36 -0700
Message-Id: <1279901739-10541-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function is only needed in the same
file it is defined in, i.e. iwl-core.c

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   63 +++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 2 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 676d49d..cb2d48a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1748,6 +1748,37 @@ static inline void iwl_set_no_assoc(struct iwl_priv *priv)
 	iwlcore_commit_rxon(priv);
 }
 
+static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+	__le64 timestamp;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
+		return -EIO;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (priv->ibss_beacon)
+		dev_kfree_skb(priv->ibss_beacon);
+
+	priv->ibss_beacon = skb;
+
+	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
+	priv->timestamp = le64_to_cpu(timestamp);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	priv->cfg->ops->lib->post_associate(priv, priv->vif);
+
+	return 0;
+}
+
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf,
@@ -1914,38 +1945,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_bss_info_changed);
 
-int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-	__le64 timestamp;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
-
-	priv->ibss_beacon = skb;
-
-	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	priv->timestamp = le64_to_cpu(timestamp);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	priv->cfg->ops->lib->post_associate(priv, priv->vif);
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_mac_beacon_update);
-
 static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	iwl_connection_init_rx_config(priv, vif);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b60cf45..e9d23f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -380,7 +380,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes);
-int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
 int iwl_commit_rxon(struct iwl_priv *priv);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
-- 
1.7.0.4

