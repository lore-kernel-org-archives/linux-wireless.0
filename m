Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab0KPQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/18] iwlagn: reprogram AP STA after assoc
Date: Tue, 16 Nov 2010 08:01:46 -0800
Message-Id: <1289923311-14920-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of unconditionally sending unassoc RXON,
before any assoc RXON, re-send only the AP STA
entry which is required after the BSSID has been
programmed into the device to set up internal
filters in the microcode properly.

This fixes some issues that we correlated with
sending a lot of RXON commands to the device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   39 +++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   51 ++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 3 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index fbaa8d2..9db3924 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -97,6 +97,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* cast away the const for active_rxon in this function */
 	struct iwl_rxon_cmd *active = (void *)&ctx->active;
 	bool new_assoc = !!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
+	bool old_assoc = !!(ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK);
 	int ret;
 
 	lockdep_assert_held(&priv->mutex);
@@ -176,25 +177,27 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * AP station must be done after the BSSID is set to correctly
 	 * set up filters in the device.
 	 */
-	if (ctx->ctxid == IWL_RXON_CTX_BSS)
-		ret = iwlagn_disable_bss(priv, ctx, &ctx->staging);
-	else
-		ret = iwlagn_disable_pan(priv, ctx, &ctx->staging);
-	if (ret)
-		return ret;
+	if ((old_assoc && new_assoc) || !new_assoc) {
+		if (ctx->ctxid == IWL_RXON_CTX_BSS)
+			ret = iwlagn_disable_bss(priv, ctx, &ctx->staging);
+		else
+			ret = iwlagn_disable_pan(priv, ctx, &ctx->staging);
+		if (ret)
+			return ret;
 
-	memcpy(active, &ctx->staging, sizeof(*active));
+		memcpy(active, &ctx->staging, sizeof(*active));
 
-	/*
-	 * Un-assoc RXON clears the station table and WEP
-	 * keys, so we have to restore those afterwards.
-	 */
-	iwl_clear_ucode_stations(priv, ctx);
-	iwl_restore_stations(priv, ctx);
-	ret = iwl_restore_default_wep_keys(priv, ctx);
-	if (ret) {
-		IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
-		return ret;
+		/*
+		 * Un-assoc RXON clears the station table and WEP
+		 * keys, so we have to restore those afterwards.
+		 */
+		iwl_clear_ucode_stations(priv, ctx);
+		iwl_restore_stations(priv, ctx);
+		ret = iwl_restore_default_wep_keys(priv, ctx);
+		if (ret) {
+			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
+			return ret;
+		}
 	}
 
 	/* RXON timing must be before associated RXON */
@@ -235,6 +238,8 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 		memcpy(active, &ctx->staging, sizeof(*active));
 
+		iwl_reprogram_ap_sta(priv, ctx);
+
 		/* IBSS beacon needs to be sent after setting assoc */
 		if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_ADHOC))
 			if (iwlagn_update_beacon(priv, ctx->vif))
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 7c7f7dc..0a67b2f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -400,7 +400,8 @@ static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, u8 sta_id)
 }
 
 static int iwl_send_remove_station(struct iwl_priv *priv,
-				   const u8 *addr, int sta_id)
+				   const u8 *addr, int sta_id,
+				   bool temporary)
 {
 	struct iwl_rx_packet *pkt;
 	int ret;
@@ -436,9 +437,11 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 	if (!ret) {
 		switch (pkt->u.rem_sta.status) {
 		case REM_STA_SUCCESS_MSK:
-			spin_lock_irqsave(&priv->sta_lock, flags_spin);
-			iwl_sta_ucode_deactivate(priv, sta_id);
-			spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+			if (!temporary) {
+				spin_lock_irqsave(&priv->sta_lock, flags_spin);
+				iwl_sta_ucode_deactivate(priv, sta_id);
+				spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+			}
 			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
 			break;
 		default:
@@ -505,7 +508,7 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return iwl_send_remove_station(priv, addr, sta_id);
+	return iwl_send_remove_station(priv, addr, sta_id, false);
 out_err:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return -EINVAL;
@@ -624,6 +627,44 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 }
 EXPORT_SYMBOL(iwl_restore_stations);
 
+void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+{
+	unsigned long flags;
+	int sta_id = ctx->ap_sta_id;
+	int ret;
+	struct iwl_addsta_cmd sta_cmd;
+	struct iwl_link_quality_cmd lq;
+	bool active;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return;
+	}
+
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
+	sta_cmd.mode = 0;
+	memcpy(&lq, priv->stations[sta_id].lq, sizeof(lq));
+
+	active = priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	if (active) {
+		ret = iwl_send_remove_station(
+			priv, priv->stations[sta_id].sta.sta.addr,
+			sta_id, true);
+		if (ret)
+			IWL_ERR(priv, "failed to remove STA %pM (%d)\n",
+				priv->stations[sta_id].sta.sta.addr, ret);
+	}
+	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+	if (ret)
+		IWL_ERR(priv, "failed to re-add STA %pM (%d)\n",
+			priv->stations[sta_id].sta.sta.addr, ret);
+	iwl_send_lq_cmd(priv, ctx, &lq, CMD_SYNC, true);
+}
+EXPORT_SYMBOL(iwl_reprogram_ap_sta);
+
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 0647587..206f1e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -63,6 +63,7 @@ u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
+void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 
 /**
  * iwl_clear_driver_stations - clear knowledge of all stations from driver
-- 
1.7.0.4

