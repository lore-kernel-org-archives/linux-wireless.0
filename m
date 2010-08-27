Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab0H0Q4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/27] iwlwifi: move HT configuration data into context
Date: Fri, 27 Aug 2010 09:59:43 -0700
Message-Id: <1282928395-32762-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot of HT configuration semantically belongs into
the context, even if right now it will never be
different between contexts. Move it so we're better
prepared for future changes in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   66 +++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   26 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.c   |  113 +++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   23 +++----
 6 files changed, 134 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index e78f3f0..57629fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -602,11 +602,13 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
  * Green-field mode is valid if the station supports it and
  * there are no non-GF stations present in the BSS.
  */
-static inline u8 rs_use_green(struct ieee80211_sta *sta,
-			      struct iwl_ht_config *ht_conf)
+static bool rs_use_green(struct ieee80211_sta *sta)
 {
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+
 	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
-		!(ht_conf->non_GF_STA_present);
+		!(ctx->ht.non_gf_sta_present);
 }
 
 /**
@@ -758,8 +760,8 @@ static bool table_type_matches(struct iwl_scale_tbl_info *a,
 		(a->is_SGI == b->is_SGI);
 }
 
-static void rs_bt_update_lq(struct iwl_priv *priv,
-			       struct iwl_lq_sta *lq_sta)
+static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			    struct iwl_lq_sta *lq_sta)
 {
 	struct iwl_scale_tbl_info *tbl;
 	bool full_concurrent;
@@ -778,7 +780,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv,
 		/* Update uCode's rate table. */
 		tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
-		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
+		iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_ASYNC, false);
 
 		queue_work(priv->workqueue, &priv->bt_full_concurrency);
 	}
@@ -803,6 +805,8 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	u32 tx_rate;
 	struct iwl_scale_tbl_info tbl_type;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
 
 	IWL_DEBUG_RATE_LIMIT(priv, "get frame ack response, update rate scale window\n");
 
@@ -869,7 +873,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		lq_sta->missed_rate_counter++;
 		if (lq_sta->missed_rate_counter > IWL_MISSED_RATE_MAX) {
 			lq_sta->missed_rate_counter = 0;
-			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
+			iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_ASYNC, false);
 		}
 		/* Regardless, ignore this status info for outdated rate */
 		return;
@@ -969,7 +973,7 @@ done:
 
 	/* Is there a need to switch between full concurrency and 3-wire? */
 	if (priv->bt_ant_couple_ok)
-		rs_bt_update_lq(priv, lq_sta);
+		rs_bt_update_lq(priv, ctx, lq_sta);
 }
 
 /*
@@ -1163,6 +1167,8 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	u16 rate_mask;
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -1183,7 +1189,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_mimo2_rate;
 
-	if (iwl_is_ht40_tx_allowed(priv, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1217,6 +1223,8 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	u16 rate_mask;
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -1237,7 +1245,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
 	rate_mask = lq_sta->active_mimo3_rate;
 
-	if (iwl_is_ht40_tx_allowed(priv, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1272,6 +1280,8 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	u16 rate_mask;
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -1284,7 +1294,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_siso_rate;
 
-	if (iwl_is_ht40_tx_allowed(priv, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -2086,6 +2096,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
  * return rate_n_flags as used in the table
  */
 static u32 rs_update_rate_tbl(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx,
 				struct iwl_lq_sta *lq_sta,
 				struct iwl_scale_tbl_info *tbl,
 				int index, u8 is_green)
@@ -2095,7 +2106,7 @@ static u32 rs_update_rate_tbl(struct iwl_priv *priv,
 	/* Update uCode's rate table. */
 	rate = rate_n_flags_from_tbl(priv, tbl, index, is_green);
 	rs_fill_link_cmd(priv, lq_sta, rate);
-	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
+	iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_ASYNC, false);
 
 	return rate;
 }
@@ -2134,6 +2145,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	s32 sr;
 	u8 tid = MAX_TID_COUNT;
 	struct iwl_tid_data *tid_data;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
 
 	IWL_DEBUG_RATE(priv, "rate scale calculate new rate for skb\n");
 
@@ -2172,7 +2185,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (is_legacy(tbl->lq_type))
 		lq_sta->is_green = 0;
 	else
-		lq_sta->is_green = rs_use_green(sta, &priv->current_ht_config);
+		lq_sta->is_green = rs_use_green(sta);
 	is_green = lq_sta->is_green;
 
 	/* current tx rate */
@@ -2211,7 +2224,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 			/* get "active" rate info */
 			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
-			rate = rs_update_rate_tbl(priv, lq_sta,
+			rate = rs_update_rate_tbl(priv, ctx, lq_sta,
 						  tbl, index, is_green);
 		}
 		return;
@@ -2453,7 +2466,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq)
-		rate = rs_update_rate_tbl(priv, lq_sta,
+		rate = rs_update_rate_tbl(priv, ctx, lq_sta,
 					  tbl, index, is_green);
 
 	if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_MULTI) {
@@ -2495,7 +2508,7 @@ lq_update:
 			IWL_DEBUG_RATE(priv, "Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate, index);
 			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
-			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
+			iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_ASYNC, false);
 		} else
 			done_search = 1;
 	}
@@ -2565,12 +2578,17 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	int rate_idx;
 	int i;
 	u32 rate;
-	u8 use_green = rs_use_green(sta, &priv->current_ht_config);
+	u8 use_green = rs_use_green(sta);
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
+	struct iwl_station_priv *sta_priv;
+	struct iwl_rxon_context *ctx;
 
 	if (!sta || !lq_sta)
-		goto out;
+		return;
+
+	sta_priv = (void *)sta->drv_priv;
+	ctx = sta_priv->common.ctx;
 
 	i = lq_sta->last_txrate_idx;
 
@@ -2602,9 +2620,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, lq_sta, rate);
 	priv->stations[lq_sta->lq.sta_id].lq = &lq_sta->lq;
-	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_SYNC, true);
- out:
-	return;
+	iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_SYNC, true);
 }
 
 static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
@@ -2732,7 +2748,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 	lq_sta->is_dup = 0;
 	lq_sta->max_rate_idx = -1;
 	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
-	lq_sta->is_green = rs_use_green(sta, &priv->current_ht_config);
+	lq_sta->is_green = rs_use_green(sta);
 	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
 	lq_sta->band = priv->band;
 	/*
@@ -2992,6 +3008,9 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	char buf[64];
 	int buf_size;
 	u32 parsed_rate;
+	struct iwl_station_priv *sta_priv =
+		container_of(lq_sta, struct iwl_station_priv, lq_sta);
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
 
 	priv = lq_sta->drv;
 	memset(buf, 0, sizeof(buf));
@@ -3014,7 +3033,8 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 
 	if (lq_sta->dbg_fixed_rate) {
 		rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate);
-		iwl_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC, false);
+		iwl_send_lq_cmd(lq_sta->drv, ctx, &lq_sta->lq, CMD_ASYNC,
+				false);
 	}
 
 	return count;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index de8db3a..4efca99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3671,8 +3671,8 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 
 			sta_priv->lq_sta.lq.general_params.flags &=
 				~LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
-			iwl_send_lq_cmd(priv, &sta_priv->lq_sta.lq,
-				CMD_ASYNC, false);
+			iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
+					&sta_priv->lq_sta.lq, CMD_ASYNC, false);
 		}
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
@@ -3687,8 +3687,8 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 
 			sta_priv->lq_sta.lq.general_params.flags |=
 				LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
-			iwl_send_lq_cmd(priv, &sta_priv->lq_sta.lq,
-				CMD_ASYNC, false);
+			iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
+					&sta_priv->lq_sta.lq, CMD_ASYNC, false);
 		}
 		ret = 0;
 		break;
@@ -3824,23 +3824,23 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 			priv->current_ht_config.smps = conf->smps_mode;
 
 			/* Configure HT40 channels */
-			ht_conf->is_ht = conf_is_ht(conf);
-			if (ht_conf->is_ht) {
+			ctx->ht.enabled = conf_is_ht(conf);
+			if (ctx->ht.enabled) {
 				if (conf_is_ht40_minus(conf)) {
-					ht_conf->extension_chan_offset =
+					ctx->ht.extension_chan_offset =
 						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-					ht_conf->is_40mhz = true;
+					ctx->ht.is_40mhz = true;
 				} else if (conf_is_ht40_plus(conf)) {
-					ht_conf->extension_chan_offset =
+					ctx->ht.extension_chan_offset =
 						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-					ht_conf->is_40mhz = true;
+					ctx->ht.is_40mhz = true;
 				} else {
-					ht_conf->extension_chan_offset =
+					ctx->ht.extension_chan_offset =
 						IEEE80211_HT_PARAM_CHA_SEC_NONE;
-					ht_conf->is_40mhz = false;
+					ctx->ht.is_40mhz = false;
 				}
 			} else
-				ht_conf->is_40mhz = false;
+				ctx->ht.is_40mhz = false;
 
 			if ((le16_to_cpu(ctx->staging.channel) != ch))
 				ctx->staging.flags = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f9abcd8..8ec042d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -202,7 +202,7 @@ static void iwl_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		ctx->qos_data.def_qos_parm.qos_flags |=
 			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
-	if (priv->current_ht_config.is_ht)
+	if (ctx->ht.enabled)
 		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
 	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
@@ -441,15 +441,15 @@ static bool is_single_rx_stream(struct iwl_priv *priv)
 	       priv->current_ht_config.single_chain_sufficient;
 }
 
-static u8 iwl_is_channel_extension(struct iwl_priv *priv,
-				   enum ieee80211_band band,
-				   u16 channel, u8 extension_chan_offset)
+static bool iwl_is_channel_extension(struct iwl_priv *priv,
+				     enum ieee80211_band band,
+				     u16 channel, u8 extension_chan_offset)
 {
 	const struct iwl_channel_info *ch_info;
 
 	ch_info = iwl_get_channel_info(priv, band, channel);
 	if (!is_channel_valid(ch_info))
-		return 0;
+		return false;
 
 	if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
 		return !(ch_info->ht40_extension_channel &
@@ -458,34 +458,31 @@ static u8 iwl_is_channel_extension(struct iwl_priv *priv,
 		return !(ch_info->ht40_extension_channel &
 					IEEE80211_CHAN_NO_HT40MINUS);
 
-	return 0;
+	return false;
 }
 
-u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
-			 struct ieee80211_sta_ht_cap *sta_ht_inf)
+bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    struct ieee80211_sta_ht_cap *ht_cap)
 {
-	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
-#if !TODO
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-#endif
+	if (!ctx->ht.enabled || !ctx->ht.is_40mhz)
+		return false;
 
-	if (!ht_conf->is_ht || !ht_conf->is_40mhz)
-		return 0;
-
-	/* We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
+	/*
+	 * We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
 	 * the bit will not set if it is pure 40MHz case
 	 */
-	if (sta_ht_inf) {
-		if (!sta_ht_inf->ht_supported)
-			return 0;
-	}
+	if (ht_cap && !ht_cap->ht_supported)
+		return false;
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (priv->disable_ht40)
-		return 0;
+		return false;
 #endif
+
 	return iwl_is_channel_extension(priv, priv->band,
 			le16_to_cpu(ctx->staging.channel),
-			ht_conf->extension_chan_offset);
+			ctx->ht.extension_chan_offset);
 }
 EXPORT_SYMBOL(iwl_is_ht40_tx_allowed);
 
@@ -724,7 +721,7 @@ static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 {
 	struct iwl_rxon_cmd *rxon = &ctx->staging;
 
-	if (!ht_conf->is_ht) {
+	if (!ctx->ht.enabled) {
 		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
 			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
 			RXON_FLG_HT40_PROT_MSK |
@@ -732,22 +729,22 @@ static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 		return;
 	}
 
-	/* FIXME: if the definition of ht_protection changed, the "translation"
+	/* FIXME: if the definition of ht.protection changed, the "translation"
 	 * will be needed for rxon->flags
 	 */
-	rxon->flags |= cpu_to_le32(ht_conf->ht_protection << RXON_FLG_HT_OPERATING_MODE_POS);
+	rxon->flags |= cpu_to_le32(ctx->ht.protection << RXON_FLG_HT_OPERATING_MODE_POS);
 
 	/* Set up channel bandwidth:
 	 * 20 MHz only, 20/40 mixed or pure 40 if ht40 ok */
 	/* clear the HT channel mode before set the mode */
 	rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
 			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
-	if (iwl_is_ht40_tx_allowed(priv, NULL)) {
+	if (iwl_is_ht40_tx_allowed(priv, ctx, NULL)) {
 		/* pure ht40 */
-		if (ht_conf->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
+		if (ctx->ht.protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
 			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
 			/* Note: control channel is opposite of extension channel */
-			switch (ht_conf->extension_chan_offset) {
+			switch (ctx->ht.extension_chan_offset) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				rxon->flags &= ~RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
 				break;
@@ -757,7 +754,7 @@ static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 			}
 		} else {
 			/* Note: control channel is opposite of extension channel */
-			switch (ht_conf->extension_chan_offset) {
+			switch (ctx->ht.extension_chan_offset) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
 				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
@@ -782,8 +779,8 @@ static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 
 	IWL_DEBUG_ASSOC(priv, "rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x\n",
-			le32_to_cpu(rxon->flags), ht_conf->ht_protection,
-			ht_conf->extension_chan_offset);
+			le32_to_cpu(rxon->flags), ctx->ht.protection,
+			ctx->ht.extension_chan_offset);
 }
 
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
@@ -1649,15 +1646,16 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 	struct ieee80211_sta *sta;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
 	IWL_DEBUG_MAC80211(priv, "enter:\n");
 
-	if (!ht_conf->is_ht)
+	if (!ctx->ht.enabled)
 		return;
 
-	ht_conf->ht_protection =
+	ctx->ht.protection =
 		bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
-	ht_conf->non_GF_STA_present =
+	ctx->ht.non_gf_sta_present =
 		!!(bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 
 	ht_conf->single_chain_sufficient = false;
@@ -2098,29 +2096,32 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		spin_lock_irqsave(&priv->lock, flags);
 
-		/* Configure HT40 channels */
-		ht_conf->is_ht = conf_is_ht(conf);
-		if (ht_conf->is_ht) {
-			if (conf_is_ht40_minus(conf)) {
-				ht_conf->extension_chan_offset =
-					IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-				ht_conf->is_40mhz = true;
-			} else if (conf_is_ht40_plus(conf)) {
-				ht_conf->extension_chan_offset =
-					IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-				ht_conf->is_40mhz = true;
-			} else {
-				ht_conf->extension_chan_offset =
-					IEEE80211_HT_PARAM_CHA_SEC_NONE;
-				ht_conf->is_40mhz = false;
-			}
-		} else
-			ht_conf->is_40mhz = false;
-		/* Default to no protection. Protection mode will later be set
-		 * from BSS config in iwl_ht_conf */
-		ht_conf->ht_protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
-
 		for_each_context(priv, ctx) {
+			/* Configure HT40 channels */
+			ctx->ht.enabled = conf_is_ht(conf);
+			if (ctx->ht.enabled) {
+				if (conf_is_ht40_minus(conf)) {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+					ctx->ht.is_40mhz = true;
+				} else if (conf_is_ht40_plus(conf)) {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+					ctx->ht.is_40mhz = true;
+				} else {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_NONE;
+					ctx->ht.is_40mhz = false;
+				}
+			} else
+				ctx->ht.is_40mhz = false;
+
+			/*
+			 * Default to no protection. Protection mode will
+			 * later be set from BSS config in iwl_ht_conf
+			 */
+			ctx->ht.protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
+
 			/* if we are switching from ht to 2.4 clear flags
 			 * from any ht related info since 2.4 does not
 			 * support ht */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7aa9c6c..289fef8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -389,8 +389,9 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 u8 iwl_get_single_channel_number(struct iwl_priv *priv,
 				  enum ieee80211_band band);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
-u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
-			 struct ieee80211_sta_ht_cap *sta_ht_inf);
+bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    struct ieee80211_sta_ht_cap *ht_cap);
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct ieee80211_vif *vif);
 void iwl_set_rate(struct iwl_priv *priv);
@@ -720,7 +721,7 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
-extern int iwl_send_lq_cmd(struct iwl_priv *priv,
+extern int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9364768..c17c67f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -470,15 +470,8 @@ union iwl_ht_rate_supp {
 #define CFG_HT_MPDU_DENSITY_MIN     (0x1)
 
 struct iwl_ht_config {
-	/* self configuration data */
-	bool is_ht;
-	bool is_40mhz;
 	bool single_chain_sufficient;
 	enum ieee80211_smps_mode smps; /* current smps mode */
-	/* BSS related data */
-	u8 extension_chan_offset;
-	u8 ht_protection;
-	u8 non_GF_STA_present;
 };
 
 /* QoS structures */
@@ -1140,6 +1133,13 @@ struct iwl_rxon_context {
 	u8 key_mapping_keys;
 
 	__le32 station_flags;
+
+	struct {
+		bool non_gf_sta_present;
+		u8 protection;
+		bool enabled, is_40mhz;
+		u8 extension_chan_offset;
+	} ht;
 };
 
 struct iwl_priv {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c18eb89..ccd0902 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -172,7 +172,8 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_send_add_sta);
 
 static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
-				   struct ieee80211_sta *sta)
+				   struct ieee80211_sta *sta,
+				   struct iwl_rxon_context *ctx)
 {
 	struct ieee80211_sta_ht_cap *sta_ht_inf = &sta->ht_cap;
 	__le32 sta_flags;
@@ -212,7 +213,7 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	sta_flags |= cpu_to_le32(
 	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
-	if (iwl_is_ht40_tx_allowed(priv, sta_ht_inf))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
 		sta_flags |= STA_FLG_HT40_EN_MSK;
 	else
 		sta_flags &= ~STA_FLG_HT40_EN_MSK;
@@ -305,7 +306,7 @@ static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	 * STA and broadcast STA) pass in a NULL sta, and mac80211
 	 * doesn't allow HT IBSS.
 	 */
-	iwl_set_ht_add_station(priv, sta_id, sta);
+	iwl_set_ht_add_station(priv, sta_id, sta, ctx);
 
 	/* 3945 only */
 	rate = (priv->band == IEEE80211_BAND_5GHZ) ?
@@ -472,7 +473,7 @@ int iwl_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			return -ENOMEM;
 		}
 
-		ret = iwl_send_lq_cmd(priv, link_cmd, CMD_SYNC, true);
+		ret = iwl_send_lq_cmd(priv, ctx, link_cmd, CMD_SYNC, true);
 		if (ret)
 			IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
 
@@ -714,7 +715,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			 * current LQ command
 			 */
 			if (send_lq)
-				iwl_send_lq_cmd(priv, &lq, CMD_SYNC, true);
+				iwl_send_lq_cmd(priv, ctx, &lq, CMD_SYNC, true);
 			spin_lock_irqsave(&priv->sta_lock, flags_spin);
 			priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
 		}
@@ -1173,16 +1174,12 @@ static inline void iwl_dump_lq_cmd(struct iwl_priv *priv,
  * RXON flags are updated and when LQ command is updated.
  */
 static bool is_lq_table_valid(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx,
 			      struct iwl_link_quality_cmd *lq)
 {
 	int i;
-	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
-#if !TODO
-	struct iwl_rxon_context *ctx =
-			&priv->contexts[IWL_RXON_CTX_BSS];
-#endif
 
-	if (ht_conf->is_ht)
+	if (ctx->ht.enabled)
 		return true;
 
 	IWL_DEBUG_INFO(priv, "Channel %u is not an HT channel\n",
@@ -1208,7 +1205,7 @@ static bool is_lq_table_valid(struct iwl_priv *priv,
  * this case to clear the state indicating that station creation is in
  * progress.
  */
-int iwl_send_lq_cmd(struct iwl_priv *priv,
+int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init)
 {
 	int ret = 0;
@@ -1227,7 +1224,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 	iwl_dump_lq_cmd(priv, lq);
 	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
-	if (is_lq_table_valid(priv, lq))
+	if (is_lq_table_valid(priv, ctx, lq))
 		ret = iwl_send_cmd(priv, &cmd);
 	else
 		ret = -EINVAL;
-- 
1.7.0.4

