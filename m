Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab1DERB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/25] iwlagn: make mac80211 handlers static
Date: Tue,  5 Apr 2011 09:41:50 -0700
Message-Id: <1302021732-21250-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that these handlers are no longer shared
between 4965 and agn, they can be static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   53 ++++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-agn.h |   28 -----------------
 2 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 28ac0d4..a437d91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2918,7 +2918,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 }
 
 
-int iwlagn_mac_start(struct ieee80211_hw *hw)
+static int iwlagn_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
@@ -2959,7 +2959,7 @@ out:
 	return 0;
 }
 
-void iwlagn_mac_stop(struct ieee80211_hw *hw)
+static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -2982,7 +2982,7 @@ void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -2997,11 +2997,11 @@ void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	IWL_DEBUG_MACDUMP(priv, "leave\n");
 }
 
-void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_key_conf *keyconf,
-				struct ieee80211_sta *sta,
-				u32 iv32, u16 *phase1key)
+static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_key_conf *keyconf,
+				       struct ieee80211_sta *sta,
+				       u32 iv32, u16 *phase1key)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -3014,9 +3014,10 @@ void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-		       struct ieee80211_key_conf *key)
+static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -3091,11 +3092,11 @@ int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
-			    struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size)
+static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   enum ieee80211_ampdu_mlme_action action,
+				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+				   u8 buf_size)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret = -EINVAL;
@@ -3202,9 +3203,9 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	return ret;
 }
 
-int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta)
+static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
@@ -3245,8 +3246,8 @@ int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	return 0;
 }
 
-void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
-			       struct ieee80211_channel_switch *ch_switch)
+static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
+				struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
@@ -3343,10 +3344,10 @@ out_exit:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-void iwlagn_configure_filter(struct ieee80211_hw *hw,
-			     unsigned int changed_flags,
-			     unsigned int *total_flags,
-			     u64 multicast)
+static void iwlagn_configure_filter(struct ieee80211_hw *hw,
+				    unsigned int changed_flags,
+				    unsigned int *total_flags,
+				    u64 multicast)
 {
 	struct iwl_priv *priv = hw->priv;
 	__le32 filter_or = 0, filter_nand = 0;
@@ -3393,7 +3394,7 @@ void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
+static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 80de8a1..4a0a46e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -337,32 +337,4 @@ void __releases(wait_entry)
 iwlagn_remove_notification(struct iwl_priv *priv,
 			   struct iwl_notification_wait *wait_entry);
 
-/* mac80211 handlers (for 4965) */
-void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
-int iwlagn_mac_start(struct ieee80211_hw *hw);
-void iwlagn_mac_stop(struct ieee80211_hw *hw);
-void iwlagn_configure_filter(struct ieee80211_hw *hw,
-			     unsigned int changed_flags,
-			     unsigned int *total_flags,
-			     u64 multicast);
-int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-		       struct ieee80211_key_conf *key);
-void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_key_conf *keyconf,
-				struct ieee80211_sta *sta,
-				u32 iv32, u16 *phase1key);
-int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
-			    struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size);
-int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta);
-void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
-			       struct ieee80211_channel_switch *ch_switch);
-void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop);
-
 #endif /* __iwl_agn_h__ */
-- 
1.7.0.4

