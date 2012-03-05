Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201Ab2CEUiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:12 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 29/33] iwlwifi: fix station HT parameters
Date: Mon,  5 Mar 2012 11:24:47 -0800
Message-Id: <1330975491-19680-30-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213844_110694_AC12AA1F)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My patch "iwlwifi: simplify auth/assoc flow"
caused a serious throughput degradation due
to me forgetting that there are HT settings
in the station table. To restore throughput,
set these parameters correctly when the sta
moves to assoc state.

This patch should probably be merged with
the auth/assoc redesign patch for upstream.
In that case, this paragraph should be added
to the commit log as the third paragraph
(before talking about RXON):

However, as we only get the station HT data
when the station moves into assoc state, we
also need to program this into the device
(and copy it into our database) then.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   81 +++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   18 +++++-
 3 files changed, 75 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 736f8dc..ca08026 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -169,34 +169,38 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	return cmd.handler_status;
 }
 
-static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
-				   struct ieee80211_sta *sta,
-				   struct iwl_rxon_context *ctx)
+static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
+				  struct ieee80211_sta *sta,
+				  struct iwl_rxon_context *ctx,
+				  __le32 *flags, __le32 *mask)
 {
 	struct ieee80211_sta_ht_cap *sta_ht_inf = &sta->ht_cap;
-	__le32 sta_flags;
 	u8 mimo_ps_mode;
 
+	*mask = STA_FLG_RTS_MIMO_PROT_MSK |
+		STA_FLG_MIMO_DIS_MSK |
+		STA_FLG_HT40_EN_MSK |
+		STA_FLG_MAX_AGG_SIZE_MSK |
+		STA_FLG_AGG_MPDU_DENSITY_MSK;
+	*flags = 0;
+
 	if (!sta || !sta_ht_inf->ht_supported)
-		goto done;
+		return;
 
 	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
-	IWL_DEBUG_ASSOC(priv, "spatial multiplexing power save mode: %s\n",
+
+	IWL_DEBUG_INFO(priv, "STA %pM SM PS mode: %s\n",
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_STATIC) ?
 			"static" :
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ?
 			"dynamic" : "disabled");
 
-	sta_flags = priv->stations[index].sta.station_flags;
-
-	sta_flags &= ~(STA_FLG_RTS_MIMO_PROT_MSK | STA_FLG_MIMO_DIS_MSK);
-
 	switch (mimo_ps_mode) {
 	case WLAN_HT_CAP_SM_PS_STATIC:
-		sta_flags |= STA_FLG_MIMO_DIS_MSK;
+		*flags |= STA_FLG_MIMO_DIS_MSK;
 		break;
 	case WLAN_HT_CAP_SM_PS_DYNAMIC:
-		sta_flags |= STA_FLG_RTS_MIMO_PROT_MSK;
+		*flags |= STA_FLG_RTS_MIMO_PROT_MSK;
 		break;
 	case WLAN_HT_CAP_SM_PS_DISABLED:
 		break;
@@ -205,20 +209,53 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 		break;
 	}
 
-	sta_flags |= cpu_to_le32(
-	      (u32)sta_ht_inf->ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
+	*flags |= cpu_to_le32(
+		(u32)sta_ht_inf->ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
 
-	sta_flags |= cpu_to_le32(
-	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
+	*flags |= cpu_to_le32(
+		(u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
 	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
-		sta_flags |= STA_FLG_HT40_EN_MSK;
-	else
-		sta_flags &= ~STA_FLG_HT40_EN_MSK;
+		*flags |= STA_FLG_HT40_EN_MSK;
+}
+
+int iwl_sta_update_ht(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+		      struct ieee80211_sta *sta)
+{
+	u8 sta_id = iwl_sta_id(sta);
+	__le32 flags, mask;
+	struct iwl_addsta_cmd cmd;
+
+	if (WARN_ON_ONCE(sta_id == IWL_INVALID_STATION))
+		return -EINVAL;
 
-	priv->stations[index].sta.station_flags = sta_flags;
- done:
-	return;
+	iwl_sta_calc_ht_flags(priv, sta, ctx, &flags, &mask);
+
+	spin_lock_bh(&priv->sta_lock);
+	priv->stations[sta_id].sta.station_flags &= ~mask;
+	priv->stations[sta_id].sta.station_flags |= flags;
+	spin_unlock_bh(&priv->sta_lock);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.mode = STA_CONTROL_MODIFY_MSK;
+	cmd.station_flags_msk = mask;
+	cmd.station_flags = flags;
+	cmd.sta.sta_id = sta_id;
+
+	return iwl_send_add_sta(priv, &cmd, CMD_SYNC);
+}
+
+static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
+				   struct ieee80211_sta *sta,
+				   struct iwl_rxon_context *ctx)
+{
+	__le32 flags, mask;
+
+	iwl_sta_calc_ht_flags(priv, sta, ctx, &flags, &mask);
+
+	lockdep_assert_held(&priv->sta_lock);
+	priv->stations[index].sta.station_flags &= ~mask;
+	priv->stations[index].sta.station_flags |= flags;
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a9c018a..70100f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -229,6 +229,8 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd);
+int iwl_sta_update_ht(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+		      struct ieee80211_sta *sta);
 
 
 static inline int iwl_sta_id(struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 8160f61..7f93715 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -740,8 +740,9 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 				enum ieee80211_sta_state new_state)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	enum {
-		NONE, ADD, REMOVE, RATE_INIT, ADD_RATE_INIT,
+		NONE, ADD, REMOVE, HT_RATE_INIT, ADD_RATE_INIT,
 	} op = NONE;
 	int ret;
 
@@ -758,7 +759,7 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 			op = REMOVE;
 		else if (old_state == IEEE80211_STA_AUTH &&
 			 new_state == IEEE80211_STA_ASSOC)
-			op = RATE_INIT;
+			op = HT_RATE_INIT;
 	} else {
 		if (old_state == IEEE80211_STA_AUTH &&
 		    new_state == IEEE80211_STA_ASSOC)
@@ -779,8 +780,6 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 		ret = iwlagn_mac_sta_add(hw, vif, sta);
 		if (ret)
 			break;
-		/* fall through */
-	case RATE_INIT:
 		/* Initialize rate scaling */
 		IWL_DEBUG_INFO(priv,
 			       "Initializing rate scaling for station %pM\n",
@@ -788,6 +787,17 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 		iwl_rs_rate_init(priv, sta, iwl_sta_id(sta));
 		ret = 0;
 		break;
+	case HT_RATE_INIT:
+		/* Initialize rate scaling */
+		ret = iwl_sta_update_ht(priv, vif_priv->ctx, sta);
+		if (ret)
+			break;
+		IWL_DEBUG_INFO(priv,
+			       "Initializing rate scaling for station %pM\n",
+			       sta->addr);
+		iwl_rs_rate_init(priv, sta, iwl_sta_id(sta));
+		ret = 0;
+		break;
 	default:
 		ret = 0;
 		break;
-- 
1.7.0.4

