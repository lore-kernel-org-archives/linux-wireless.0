Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965036Ab2CEUiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 11/33] iwlwifi: simplify auth/assoc flow
Date: Mon,  5 Mar 2012 11:24:29 -0800
Message-Id: <1330975491-19680-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213913_499934_DCA2F96C)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With mac80211 now giving us station information
(via the sta_state callback) before auth/assoc
we can get rid of tx_sync by adding the station
early for the case of managed interfaces. Keep
AP mode actions the same for now.

As we now get the BSSID early, we can also get
rid of iwl_reprogram_ap_sta().

We can still optimise the number of RXONs we
send to the device, but that can be done later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    7 -
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   45 ------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |  207 ++++++++++++---------------
 5 files changed, 90 insertions(+), 173 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 7a86a35..e806ad8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -274,8 +274,6 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	}
 	memcpy(active, &ctx->staging, sizeof(*active));
 
-	iwl_reprogram_ap_sta(priv, ctx);
-
 	/* IBSS beacon needs to be sent after setting assoc */
 	if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_ADHOC))
 		if (iwlagn_update_beacon(priv, ctx->vif))
@@ -431,10 +429,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (!ctx->is_active)
 		return 0;
 
-	/* override BSSID if necessary due to preauth */
-	if (ctx->preauth_bssid)
-		memcpy(ctx->staging.bssid_addr, ctx->bssid, ETH_ALEN);
-
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
@@ -920,7 +914,6 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 		if (!priv->disable_chain_noise_cal)
 			iwlagn_chain_noise_reset(priv);
 		priv->start_calib = 1;
-		WARN_ON(ctx->preauth_bssid);
 	}
 
 	if (changes & BSS_CHANGED_IBSS) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 4bd50da..222a8f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -626,51 +626,6 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			"complete.\n");
 }
 
-void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	int sta_id = ctx->ap_sta_id;
-	int ret;
-	struct iwl_addsta_cmd sta_cmd;
-	struct iwl_link_quality_cmd lq;
-	bool active, have_lq = false;
-
-	spin_lock_bh(&priv->sta_lock);
-	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
-		spin_unlock_bh(&priv->sta_lock);
-		return;
-	}
-
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
-	sta_cmd.mode = 0;
-	if (priv->stations[sta_id].lq) {
-		memcpy(&lq, priv->stations[sta_id].lq, sizeof(lq));
-		have_lq = true;
-	}
-
-	active = priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE;
-	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
-	spin_unlock_bh(&priv->sta_lock);
-
-	if (active) {
-		ret = iwl_send_remove_station(
-			priv, priv->stations[sta_id].sta.sta.addr,
-			sta_id, true);
-		if (ret)
-			IWL_ERR(priv, "failed to remove STA %pM (%d)\n",
-				priv->stations[sta_id].sta.sta.addr, ret);
-	}
-	spin_lock_bh(&priv->sta_lock);
-	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
-	spin_unlock_bh(&priv->sta_lock);
-
-	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-	if (ret)
-		IWL_ERR(priv, "failed to re-add STA %pM (%d)\n",
-			priv->stations[sta_id].sta.sta.addr, ret);
-	if (have_lq)
-		iwl_send_lq_cmd(priv, ctx, &lq, CMD_SYNC, true);
-}
-
 int iwl_get_free_ucode_key_offset(struct iwl_priv *priv)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ef0cdf5..a142a19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -227,7 +227,6 @@ void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		     u8 sta_id, struct iwl_link_quality_cmd *link_cmd);
 int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
-void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 			       struct iwl_device_cmd *cmd);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5b537db..9ea9002 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -671,9 +671,6 @@ struct iwl_rxon_context {
 		u8 extension_chan_offset;
 	} ht;
 
-	u8 bssid[ETH_ALEN];
-	bool preauth_bssid;
-
 	bool last_tx_rejected;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 7f63ba9..005763f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -692,12 +692,9 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
-	int ret = 0;
+	int ret;
 	u8 sta_id;
 
-	IWL_DEBUG_MAC80211(priv, "received request to add station %pM\n",
-			sta->addr);
-	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_INFO(priv, "proceeding to add station %pM\n",
 			sta->addr);
 	sta_priv->sta_id = IWL_INVALID_STATION;
@@ -712,16 +709,98 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
-		goto out;
+		return ret;
 	}
 
 	sta_priv->sta_id = sta_id;
 
-	/* Initialize rate scaling */
-	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
-		       sta->addr);
-	iwl_rs_rate_init(priv, sta, sta_id);
- out:
+	return 0;
+}
+
+static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta)
+{
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	int ret;
+
+	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
+			sta->addr);
+	ret = iwl_remove_station(priv, sta_priv->sta_id, sta->addr);
+	if (ret)
+		IWL_DEBUG_QUIET_RFKILL(priv, "Error removing station %pM\n",
+			sta->addr);
+	return ret;
+}
+
+static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				enum ieee80211_sta_state old_state,
+				enum ieee80211_sta_state new_state)
+{
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
+	enum {
+		NONE, ADD, REMOVE, RATE_INIT, ADD_RATE_INIT,
+	} op = NONE;
+	int ret;
+
+	IWL_DEBUG_MAC80211(priv, "station %pM state change %d->%d\n",
+			   sta->addr, old_state, new_state);
+
+	mutex_lock(&priv->shrd->mutex);
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (old_state == IEEE80211_STA_NOTEXIST &&
+		    new_state == IEEE80211_STA_NONE)
+			op = ADD;
+		else if (old_state == IEEE80211_STA_NONE &&
+			 new_state == IEEE80211_STA_NOTEXIST)
+			op = REMOVE;
+		else if (old_state == IEEE80211_STA_AUTH &&
+			 new_state == IEEE80211_STA_ASSOC)
+			op = RATE_INIT;
+	} else {
+		if (old_state == IEEE80211_STA_AUTH &&
+		    new_state == IEEE80211_STA_ASSOC)
+			op = ADD_RATE_INIT;
+		else if (old_state == IEEE80211_STA_ASSOC &&
+			 new_state == IEEE80211_STA_AUTH)
+			op = REMOVE;
+	}
+
+	switch (op) {
+	case ADD:
+		ret = iwlagn_mac_sta_add(hw, vif, sta);
+		break;
+	case REMOVE:
+		ret = iwlagn_mac_sta_remove(hw, vif, sta);
+		break;
+	case ADD_RATE_INIT:
+		ret = iwlagn_mac_sta_add(hw, vif, sta);
+		if (ret)
+			break;
+		/* fall through */
+	case RATE_INIT:
+		/* Initialize rate scaling */
+		IWL_DEBUG_INFO(priv,
+			       "Initializing rate scaling for station %pM\n",
+			       sta->addr);
+		iwl_rs_rate_init(priv, sta, iwl_sta_id(sta));
+		ret = 0;
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	/*
+	 * mac80211 might WARN if we fail, but due the way we
+	 * (badly) handle hard rfkill, we might fail here
+	 */
+	if (iwl_is_rfkill(priv->shrd))
+		ret = 0;
+
 	mutex_unlock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
@@ -1003,86 +1082,6 @@ static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static int iwlagn_mac_tx_sync(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      const u8 *bssid,
-			      enum ieee80211_tx_sync_type type)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *ctx = vif_priv->ctx;
-	int ret;
-	u8 sta_id;
-
-	if (ctx->ctxid != IWL_RXON_CTX_PAN)
-		return 0;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	if (iwl_is_associated_ctx(ctx)) {
-		ret = 0;
-		goto out;
-	}
-
-	if (ctx->preauth_bssid || test_bit(STATUS_SCAN_HW,
-	    &priv->shrd->status)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	ret = iwl_add_station_common(priv, ctx, bssid, true, NULL, &sta_id);
-	if (ret)
-		goto out;
-
-	if (WARN_ON(sta_id != ctx->ap_sta_id)) {
-		ret = -EIO;
-		goto out_remove_sta;
-	}
-
-	memcpy(ctx->bssid, bssid, ETH_ALEN);
-	ctx->preauth_bssid = true;
-
-	ret = iwlagn_commit_rxon(priv, ctx);
-
-	if (ret == 0)
-		goto out;
-
- out_remove_sta:
-	iwl_remove_station(priv, sta_id, bssid);
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return ret;
-}
-
-static void iwlagn_mac_finish_tx_sync(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   const u8 *bssid,
-				   enum ieee80211_tx_sync_type type)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *ctx = vif_priv->ctx;
-
-	if (ctx->ctxid != IWL_RXON_CTX_PAN)
-		return;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	if (iwl_is_associated_ctx(ctx))
-		goto out;
-
-	iwl_remove_station(priv, ctx->ap_sta_id, bssid);
-	ctx->preauth_bssid = false;
-	/* no need to commit */
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
 static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 			   enum ieee80211_rssi_event rssi_event)
 {
@@ -1471,29 +1470,6 @@ static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
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
-
 static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
 	struct iwl_addsta_cmd cmd = {
@@ -1559,8 +1535,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.ampdu_action = iwlagn_mac_ampdu_action,
 	.hw_scan = iwlagn_mac_hw_scan,
 	.sta_notify = iwlagn_mac_sta_notify,
-	.sta_add = iwlagn_mac_sta_add,
-	.sta_remove = iwlagn_mac_sta_remove,
+	.sta_state = iwlagn_mac_sta_state,
 	.channel_switch = iwlagn_mac_channel_switch,
 	.flush = iwlagn_mac_flush,
 	.tx_last_beacon = iwlagn_mac_tx_last_beacon,
@@ -1569,8 +1544,6 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.rssi_callback = iwlagn_mac_rssi_callback,
 	CFG80211_TESTMODE_CMD(iwlagn_mac_testmode_cmd)
 	CFG80211_TESTMODE_DUMP(iwlagn_mac_testmode_dump)
-	.tx_sync = iwlagn_mac_tx_sync,
-	.finish_tx_sync = iwlagn_mac_finish_tx_sync,
 	.set_tim = iwlagn_mac_set_tim,
 };
 
-- 
1.7.0.4

