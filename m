Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab1KJBde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/28] iwlwifi: move station functions to mac80211
Date: Wed,  9 Nov 2011 16:39:19 -0800
Message-Id: <1320885571-19122-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023427_676764_DE82239C)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The station related mac80211 callback functions should belong to _mac80211

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   68 -------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    7 ---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   71 +++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 1b112df..901fd94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -829,28 +829,6 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	return ret;
 }
 
-int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	int ret;
-
-	IWL_DEBUG_MAC80211(priv, "enter: received request to remove "
-			   "station %pM\n", sta->addr);
-	mutex_lock(&priv->shrd->mutex);
-	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
-			sta->addr);
-	ret = iwl_remove_station(priv, sta_priv->sta_id, sta->addr);
-	if (ret)
-		IWL_DEBUG_QUIET_RFKILL(priv, "Error removing station %pM\n",
-			sta->addr);
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return ret;
-}
 
 void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		     u8 sta_id, struct iwl_link_quality_cmd *link_cmd)
@@ -1468,20 +1446,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 
-static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.sta.modify_mask = 0;
-	priv->stations[sta_id].sta.sleep_tx_count = 0;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
-}
 
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 {
@@ -1498,36 +1463,3 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 }
-
-void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
-			   struct ieee80211_vif *vif,
-			   enum sta_notify_cmd cmd,
-			   struct ieee80211_sta *sta)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	int sta_id;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	switch (cmd) {
-	case STA_NOTIFY_SLEEP:
-		WARN_ON(!sta_priv->client);
-		sta_priv->asleep = true;
-		if (atomic_read(&sta_priv->pending_frames) > 0)
-			ieee80211_sta_block_awake(hw, sta, true);
-		break;
-	case STA_NOTIFY_AWAKE:
-		WARN_ON(!sta_priv->client);
-		if (!sta_priv->asleep)
-			break;
-		sta_priv->asleep = false;
-		sta_id = iwl_sta_id(sta);
-		if (sta_id != IWL_INVALID_STATION)
-			iwl_sta_modify_ps_wake(priv, sta_id);
-		break;
-	default:
-		break;
-	}
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 72af933..d325132 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -210,9 +210,6 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   struct ieee80211_sta *sta, u8 *sta_id_r);
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr);
-int iwlagn_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta);
-
 u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    const u8 *addr, bool is_ap, struct ieee80211_sta *sta);
 
@@ -330,10 +327,6 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
 int iwl_update_bcast_station(struct iwl_priv *priv,
 			     struct iwl_rxon_context *ctx);
 int iwl_update_bcast_stations(struct iwl_priv *priv);
-void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
-			   struct ieee80211_vif *vif,
-			   enum sta_notify_cmd cmd,
-			   struct ieee80211_sta *sta);
 
 /* rate */
 static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 6df08bb..b46702c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1847,6 +1847,77 @@ static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	int ret;
+
+	IWL_DEBUG_MAC80211(priv, "enter: received request to remove "
+			   "station %pM\n", sta->addr);
+	mutex_lock(&priv->shrd->mutex);
+	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
+			sta->addr);
+	ret = iwl_remove_station(priv, sta_priv->sta_id, sta->addr);
+	if (ret)
+		IWL_DEBUG_QUIET_RFKILL(priv, "Error removing station %pM\n",
+			sta->addr);
+	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
+	return ret;
+}
+
+static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.sta.modify_mask = 0;
+	priv->stations[sta_id].sta.sleep_tx_count = 0;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+
+}
+
+static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   enum sta_notify_cmd cmd,
+			   struct ieee80211_sta *sta)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	int sta_id;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	switch (cmd) {
+	case STA_NOTIFY_SLEEP:
+		WARN_ON(!sta_priv->client);
+		sta_priv->asleep = true;
+		if (atomic_read(&sta_priv->pending_frames) > 0)
+			ieee80211_sta_block_awake(hw, sta, true);
+		break;
+	case STA_NOTIFY_AWAKE:
+		WARN_ON(!sta_priv->client);
+		if (!sta_priv->asleep)
+			break;
+		sta_priv->asleep = false;
+		sta_id = iwl_sta_id(sta);
+		if (sta_id != IWL_INVALID_STATION)
+			iwl_sta_modify_ps_wake(priv, sta_id);
+		break;
+	default:
+		break;
+	}
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+}
+
 struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
-- 
1.7.0.4

