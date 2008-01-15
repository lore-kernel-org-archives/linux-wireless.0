Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbYAOC1C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:27:02 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/12] iwlwifi: 4965 unify rate scale variable names for station data
Date: Mon, 14 Jan 2008 17:46:21 -0800
Message-Id: <1200361585-31801-9-git-send-email-reinette.chatre@intel.com> (sfid-20080115_024516_196091_39EF3275)
In-Reply-To: <1200361585-31801-8-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-7-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

1, This patch renames iwl4965_rate_scale_priv to iwl4965_lq_sta.
   This type represents a station's link quality.
2. The names of the variables of this type were rs_priv, lq_data, lq, crl
   across the file. All are now unified under the name lq_sta.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |  609 ++++++++++++++--------------
 1 files changed, 308 insertions(+), 301 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 5081e28..d064622 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -103,7 +103,7 @@ struct iwl4965_scale_tbl_info {
  *
  * Pointer to this gets passed back and forth between driver and mac80211.
  */
-struct iwl4965_rate_scale_priv {
+struct iwl4965_lq_sta {
 	u8 active_tbl;		/* index of active table, range 0-1 */
 	u8 enable_counter;	/* indicates HT mode */
 	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
@@ -148,16 +148,16 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 				   struct net_device *dev,
 				   struct ieee80211_hdr *hdr,
 				   struct sta_info *sta);
-static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
+static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
 			     struct iwl4965_rate *tx_mcs,
 			     struct iwl4965_link_quality_cmd *tbl);
 
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static void rs_dbgfs_set_mcs(struct iwl4965_rate_scale_priv *rs_priv,
+static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
 				struct iwl4965_rate *mcs, int index);
 #else
-static void rs_dbgfs_set_mcs(struct iwl4965_rate_scale_priv *rs_priv,
+static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
 				struct iwl4965_rate *mcs, int index)
 {}
 #endif
@@ -516,23 +516,24 @@ static inline u8 rs_use_green(struct iwl4965_priv *priv,
  * basic available rates.
  *
  */
-static void rs_get_supported_rates(struct iwl4965_rate_scale_priv *lq_data,
+static void rs_get_supported_rates(struct iwl4965_lq_sta *lq_sta,
 				   struct ieee80211_hdr *hdr,
 				   enum iwl4965_table_type rate_type,
 				   u16 *data_rate)
 {
 	if (is_legacy(rate_type))
-		*data_rate = lq_data->active_rate;
+		*data_rate = lq_sta->active_rate;
 	else {
 		if (is_siso(rate_type))
-			*data_rate = lq_data->active_siso_rate;
+			*data_rate = lq_sta->active_siso_rate;
 		else
-			*data_rate = lq_data->active_mimo_rate;
+			*data_rate = lq_sta->active_mimo_rate;
 	}
 
 	if (hdr && is_multicast_ether_addr(hdr->addr1) &&
-	    lq_data->active_rate_basic)
-		*data_rate = lq_data->active_rate_basic;
+	    lq_sta->active_rate_basic) {
+		*data_rate = lq_sta->active_rate_basic;
+	}
 }
 
 static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
@@ -590,7 +591,7 @@ static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
 	return (high << 8) | low;
 }
 
-static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
+static void rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
 			     struct iwl4965_scale_tbl_info *tbl, u8 scale_index,
 			     u8 ht_possible, struct iwl4965_rate *mcs_rate)
 {
@@ -598,7 +599,7 @@ static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
 	u16 rate_mask;
 	u16 high_low;
 	u8 switch_to_legacy = 0;
-	u8 is_green = lq_data->is_green;
+	u8 is_green = lq_sta->is_green;
 
 	/* check if we need to switch from HT to legacy rates.
 	 * assumption is that mandatory rates (1Mbps or 6Mbps)
@@ -606,7 +607,7 @@ static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
 	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_index)) {
 		switch_to_legacy = 1;
 		scale_index = rs_ht_to_legacy[scale_index];
-		if (lq_data->phymode == MODE_IEEE80211A)
+		if (lq_sta->phymode == MODE_IEEE80211A)
 			tbl->lq_type = LQ_A;
 		else
 			tbl->lq_type = LQ_G;
@@ -619,16 +620,16 @@ static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
 		tbl->is_SGI = 0;
 	}
 
-	rs_get_supported_rates(lq_data, NULL, tbl->lq_type, &rate_mask);
+	rs_get_supported_rates(lq_sta, NULL, tbl->lq_type, &rate_mask);
 
 	/* Mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
 		/* supp_rates has no CCK bits in A mode */
-		if (lq_data->phymode == (u8) MODE_IEEE80211A)
+		if (lq_sta->phymode == (u8) MODE_IEEE80211A)
 			rate_mask  = (u16)(rate_mask &
-			   (lq_data->supp_rates << IWL_FIRST_OFDM_RATE));
+			   (lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
-			rate_mask = (u16)(rate_mask & lq_data->supp_rates);
+			rate_mask = (u16)(rate_mask & lq_sta->supp_rates);
 	}
 
 	/* If we switched from HT to legacy, check current rate */
@@ -649,15 +650,14 @@ static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
 /*
  * mac80211 sends us Tx status
  */
-static void rs_tx_status(void *priv_rate,
-			 struct net_device *dev,
+static void rs_tx_status(void *priv_rate, struct net_device *dev,
 			 struct sk_buff *skb,
 			 struct ieee80211_tx_status *tx_resp)
 {
 	int status;
 	u8 retries;
 	int rs_index, index = 0;
-	struct iwl4965_rate_scale_priv *lq;
+	struct iwl4965_lq_sta *lq_sta;
 	struct iwl4965_link_quality_cmd *table;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -691,27 +691,29 @@ static void rs_tx_status(void *priv_rate,
 		return;
 	}
 
-	lq = (struct iwl4965_rate_scale_priv *)sta->rate_ctrl_priv;
+	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
 	if (!priv->lq_mngr.lq_ready)
 		return;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) && !lq->ibss_sta_added)
+	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	    !lq_sta->ibss_sta_added)
 		return;
 
-	table = &lq->lq;
-	active_index = lq->active_tbl;
+	table = &lq_sta->lq;
+	active_index = lq_sta->active_tbl;
 
 	/* Get mac80211 antenna info */
-	lq->antenna = (lq->valid_antenna & local->hw.conf.antenna_sel_tx);
-	if (!lq->antenna)
-		lq->antenna = lq->valid_antenna;
+	lq_sta->antenna =
+		(lq_sta->valid_antenna & local->hw.conf.antenna_sel_tx);
+	if (!lq_sta->antenna)
+		lq_sta->antenna = lq_sta->valid_antenna;
 
 	/* Ignore mac80211 antenna info for now */
-	lq->antenna = lq->valid_antenna;
+	lq_sta->antenna = lq_sta->valid_antenna;
 
-	curr_tbl = &(lq->lq_info[active_index]);
-	search_tbl = &(lq->lq_info[(1 - active_index)]);
+	curr_tbl = &(lq_sta->lq_info[active_index]);
+	search_tbl = &(lq_sta->lq_info[(1 - active_index)]);
 	window = (struct iwl4965_rate_scale_data *)
 	    &(curr_tbl->win[0]);
 	search_win = (struct iwl4965_rate_scale_data *)
@@ -780,8 +782,8 @@ static void rs_tx_status(void *priv_rate,
 
 		/* If not searching for a new mode, increment failed counter
 		 * ... this helps determine when to start searching again */
-		if (lq->stay_in_tbl)
-			lq->total_failed++;
+		if (lq_sta->stay_in_tbl)
+			lq_sta->total_failed++;
 		--retries;
 		index++;
 
@@ -833,11 +835,11 @@ static void rs_tx_status(void *priv_rate,
 
 	/* If not searching for new mode, increment success/failed counter
 	 * ... these help determine when to start searching again */
-	if (lq->stay_in_tbl) {
+	if (lq_sta->stay_in_tbl) {
 		if (status)
-			lq->total_success++;
+			lq_sta->total_success++;
 		else
-			lq->total_failed++;
+			lq_sta->total_failed++;
 	}
 
 	/* See if there's a better rate or modulation mode to try. */
@@ -879,28 +881,28 @@ static u8 rs_is_other_ant_connected(u8 valid_antenna,
  * searching for a new mode.
  */
 static void rs_set_stay_in_table(u8 is_legacy,
-				 struct iwl4965_rate_scale_priv *lq_data)
+				 struct iwl4965_lq_sta *lq_sta)
 {
 	IWL_DEBUG_HT("we are staying in the same table\n");
-	lq_data->stay_in_tbl = 1;	/* only place this gets set */
+	lq_sta->stay_in_tbl = 1;	/* only place this gets set */
 	if (is_legacy) {
-		lq_data->table_count_limit = IWL_LEGACY_TABLE_COUNT;
-		lq_data->max_failure_limit = IWL_LEGACY_FAILURE_LIMIT;
-		lq_data->max_success_limit = IWL_LEGACY_SUCCESS_LIMIT;
+		lq_sta->table_count_limit = IWL_LEGACY_TABLE_COUNT;
+		lq_sta->max_failure_limit = IWL_LEGACY_FAILURE_LIMIT;
+		lq_sta->max_success_limit = IWL_LEGACY_SUCCESS_LIMIT;
 	} else {
-		lq_data->table_count_limit = IWL_NONE_LEGACY_TABLE_COUNT;
-		lq_data->max_failure_limit = IWL_NONE_LEGACY_FAILURE_LIMIT;
-		lq_data->max_success_limit = IWL_NONE_LEGACY_SUCCESS_LIMIT;
+		lq_sta->table_count_limit = IWL_NONE_LEGACY_TABLE_COUNT;
+		lq_sta->max_failure_limit = IWL_NONE_LEGACY_FAILURE_LIMIT;
+		lq_sta->max_success_limit = IWL_NONE_LEGACY_SUCCESS_LIMIT;
 	}
-	lq_data->table_count = 0;
-	lq_data->total_failed = 0;
-	lq_data->total_success = 0;
+	lq_sta->table_count = 0;
+	lq_sta->total_failed = 0;
+	lq_sta->total_success = 0;
 }
 
 /*
  * Find correct throughput table for given mode of modulation
  */
-static void rs_get_expected_tpt_table(struct iwl4965_rate_scale_priv *lq_data,
+static void rs_get_expected_tpt_table(struct iwl4965_lq_sta *lq_sta,
 				      struct iwl4965_scale_tbl_info *tbl)
 {
 	if (is_legacy(tbl->lq_type)) {
@@ -909,7 +911,7 @@ static void rs_get_expected_tpt_table(struct iwl4965_rate_scale_priv *lq_data,
 		else
 			tbl->expected_tpt = expected_tpt_A;
 	} else if (is_siso(tbl->lq_type)) {
-		if (tbl->is_fat && !lq_data->is_dup)
+		if (tbl->is_fat && !lq_sta->is_dup)
 			if (tbl->is_SGI)
 				tbl->expected_tpt = expected_tpt_siso40MHzSGI;
 			else
@@ -920,7 +922,7 @@ static void rs_get_expected_tpt_table(struct iwl4965_rate_scale_priv *lq_data,
 			tbl->expected_tpt = expected_tpt_siso20MHz;
 
 	} else if (is_mimo(tbl->lq_type)) {
-		if (tbl->is_fat && !lq_data->is_dup)
+		if (tbl->is_fat && !lq_sta->is_dup)
 			if (tbl->is_SGI)
 				tbl->expected_tpt = expected_tpt_mimo40MHzSGI;
 			else
@@ -947,13 +949,13 @@ static void rs_get_expected_tpt_table(struct iwl4965_rate_scale_priv *lq_data,
  * bit rate will typically need to increase, but not if performance was bad.
  */
 static s32 rs_get_best_rate(struct iwl4965_priv *priv,
-			    struct iwl4965_rate_scale_priv *lq_data,
+			    struct iwl4965_lq_sta *lq_sta,
 			    struct iwl4965_scale_tbl_info *tbl,	/* "search" */
 			    u16 rate_mask, s8 index, s8 rate)
 {
 	/* "active" values */
 	struct iwl4965_scale_tbl_info *active_tbl =
-	    &(lq_data->lq_info[lq_data->active_tbl]);
+	    &(lq_sta->lq_info[lq_sta->active_tbl]);
 	s32 active_sr = active_tbl->win[index].success_ratio;
 	s32 active_tpt = active_tbl->expected_tpt[index];
 
@@ -986,7 +988,7 @@ static s32 rs_get_best_rate(struct iwl4965_priv *priv,
 		 *    conditions) at candidate rate is above expected
 		 *    "active" throughput (under perfect conditions).
 		 */
-		if ((((100 * tpt_tbl[rate]) > lq_data->last_tpt) &&
+		if ((((100 * tpt_tbl[rate]) > lq_sta->last_tpt) &&
 		     ((active_sr > IWL_RATE_DECREASE_TH) &&
 		      (active_sr <= IWL_RATE_HIGH_TH) &&
 		      (tpt_tbl[rate] <= active_tpt))) ||
@@ -1045,7 +1047,7 @@ static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
  * Set up search table for MIMO
  */
 static int rs_switch_to_mimo(struct iwl4965_priv *priv,
-			     struct iwl4965_rate_scale_priv *lq_data,
+			     struct iwl4965_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
 			     struct sta_info *sta,
 			     struct iwl4965_scale_tbl_info *tbl, int index)
@@ -1053,7 +1055,7 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 #ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
 	s32 rate;
-	s8 is_green = lq_data->is_green;
+	s8 is_green = lq_sta->is_green;
 
 	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
 	    !sta->ht_info.ht_supported)
@@ -1061,17 +1063,17 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 
 	IWL_DEBUG_HT("LQ: try to switch to MIMO\n");
 	tbl->lq_type = LQ_MIMO;
-	rs_get_supported_rates(lq_data, NULL, tbl->lq_type,
+	rs_get_supported_rates(lq_sta, NULL, tbl->lq_type,
 				&rate_mask);
 
 	if (priv->current_ht_config.tx_mimo_ps_mode == IWL_MIMO_PS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
-	if (!rs_is_both_ant_supp(lq_data->antenna))
+	if (!rs_is_both_ant_supp(lq_sta->antenna))
 		return -1;
 
-	tbl->is_dup = lq_data->is_dup;
+	tbl->is_dup = lq_sta->is_dup;
 	tbl->action = 0;
 	if (priv->current_ht_config.supported_chan_width
 	    == IWL_CHANNEL_WIDTH_40MHZ)
@@ -1089,9 +1091,9 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 	else
 		tbl->is_SGI = 0;
 
-	rs_get_expected_tpt_table(lq_data, tbl);
+	rs_get_expected_tpt_table(lq_sta, tbl);
 
-	rate = rs_get_best_rate(priv, lq_data, tbl, rate_mask, index, index);
+	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
 
 	IWL_DEBUG_HT("LQ: MIMO best rate %d mask %X\n", rate, rate_mask);
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask))
@@ -1110,14 +1112,14 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
  * Set up search table for SISO
  */
 static int rs_switch_to_siso(struct iwl4965_priv *priv,
-			     struct iwl4965_rate_scale_priv *lq_data,
+			     struct iwl4965_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
 			     struct sta_info *sta,
 			     struct iwl4965_scale_tbl_info *tbl, int index)
 {
 #ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
-	u8 is_green = lq_data->is_green;
+	u8 is_green = lq_sta->is_green;
 	s32 rate;
 
 	IWL_DEBUG_HT("LQ: try to switch to SISO\n");
@@ -1125,10 +1127,10 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 	    !sta->ht_info.ht_supported)
 		return -1;
 
-	tbl->is_dup = lq_data->is_dup;
+	tbl->is_dup = lq_sta->is_dup;
 	tbl->lq_type = LQ_SISO;
 	tbl->action = 0;
-	rs_get_supported_rates(lq_data, NULL, tbl->lq_type,
+	rs_get_supported_rates(lq_sta, NULL, tbl->lq_type,
 				&rate_mask);
 
 	if (priv->current_ht_config.supported_chan_width
@@ -1150,8 +1152,8 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 	if (is_green)
 		tbl->is_SGI = 0;
 
-	rs_get_expected_tpt_table(lq_data, tbl);
-	rate = rs_get_best_rate(priv, lq_data, tbl, rate_mask, index, index);
+	rs_get_expected_tpt_table(lq_sta, tbl);
+	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
 
 	IWL_DEBUG_HT("LQ: get best rate %d mask %X\n", rate, rate_mask);
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
@@ -1173,16 +1175,16 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
  * Try to switch to new modulation mode from legacy
  */
 static int rs_move_legacy_other(struct iwl4965_priv *priv,
-				struct iwl4965_rate_scale_priv *lq_data,
+				struct iwl4965_lq_sta *lq_sta,
 				struct ieee80211_conf *conf,
 				struct sta_info *sta,
 				int index)
 {
 	int ret = 0;
 	struct iwl4965_scale_tbl_info *tbl =
-	    &(lq_data->lq_info[lq_data->active_tbl]);
+	    &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl4965_scale_tbl_info *search_tbl =
-	    &(lq_data->lq_info[(1 - lq_data->active_tbl)]);
+	    &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 	struct iwl4965_rate_scale_data *window = &(tbl->win[index]);
 	u32 sz = (sizeof(struct iwl4965_scale_tbl_info) -
 		  (sizeof(struct iwl4965_rate_scale_data) * IWL_RATE_COUNT));
@@ -1194,14 +1196,14 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 			IWL_DEBUG_HT("LQ Legacy switch Antenna\n");
 
 			search_tbl->lq_type = LQ_NONE;
-			lq_data->action_counter++;
+			lq_sta->action_counter++;
 
 			/* Don't change antenna if success has been great */
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
 
 			/* Don't change antenna if other one is not connected */
-			if (!rs_is_other_ant_connected(lq_data->antenna,
+			if (!rs_is_other_ant_connected(lq_sta->antenna,
 							tbl->antenna_type))
 				break;
 
@@ -1210,8 +1212,8 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 
 			rs_toggle_antenna(&(search_tbl->current_rate),
 					   search_tbl);
-			rs_get_expected_tpt_table(lq_data, search_tbl);
-			lq_data->search_better_tbl = 1;
+			rs_get_expected_tpt_table(lq_sta, search_tbl);
+			lq_sta->search_better_tbl = 1;
 			goto out;
 
 		case IWL_LEGACY_SWITCH_SISO:
@@ -1222,11 +1224,11 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 			search_tbl->lq_type = LQ_SISO;
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
-			ret = rs_switch_to_siso(priv, lq_data, conf, sta,
+			ret = rs_switch_to_siso(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
-				lq_data->search_better_tbl = 1;
-				lq_data->action_counter = 0;
+				lq_sta->search_better_tbl = 1;
+				lq_sta->action_counter = 0;
 				goto out;
 			}
 
@@ -1240,11 +1242,11 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
 			search_tbl->antenna_type = ANT_BOTH;
-			ret = rs_switch_to_mimo(priv, lq_data, conf, sta,
+			ret = rs_switch_to_mimo(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
-				lq_data->search_better_tbl = 1;
-				lq_data->action_counter = 0;
+				lq_sta->search_better_tbl = 1;
+				lq_sta->action_counter = 0;
 				goto out;
 			}
 			break;
@@ -1271,31 +1273,31 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
  * Try to switch to new modulation mode from SISO
  */
 static int rs_move_siso_to_other(struct iwl4965_priv *priv,
-				 struct iwl4965_rate_scale_priv *lq_data,
+				 struct iwl4965_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
 				 struct sta_info *sta,
 				 int index)
 {
 	int ret;
-	u8 is_green = lq_data->is_green;
+	u8 is_green = lq_sta->is_green;
 	struct iwl4965_scale_tbl_info *tbl =
-	    &(lq_data->lq_info[lq_data->active_tbl]);
+	    &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl4965_scale_tbl_info *search_tbl =
-	    &(lq_data->lq_info[(1 - lq_data->active_tbl)]);
+	    &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 	struct iwl4965_rate_scale_data *window = &(tbl->win[index]);
 	u32 sz = (sizeof(struct iwl4965_scale_tbl_info) -
 		  (sizeof(struct iwl4965_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
 
 	for (;;) {
-		lq_data->action_counter++;
+		lq_sta->action_counter++;
 		switch (tbl->action) {
 		case IWL_SISO_SWITCH_ANTENNA:
 			IWL_DEBUG_HT("LQ: SISO SWITCH ANTENNA SISO\n");
 			search_tbl->lq_type = LQ_NONE;
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
-			if (!rs_is_other_ant_connected(lq_data->antenna,
+			if (!rs_is_other_ant_connected(lq_sta->antenna,
 						       tbl->antenna_type))
 				break;
 
@@ -1303,7 +1305,7 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 			search_tbl->action = IWL_SISO_SWITCH_MIMO;
 			rs_toggle_antenna(&(search_tbl->current_rate),
 					   search_tbl);
-			lq_data->search_better_tbl = 1;
+			lq_sta->search_better_tbl = 1;
 
 			goto out;
 
@@ -1314,10 +1316,10 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
 			search_tbl->antenna_type = ANT_BOTH;
-			ret = rs_switch_to_mimo(priv, lq_data, conf, sta,
+			ret = rs_switch_to_mimo(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
-				lq_data->search_better_tbl = 1;
+				lq_sta->search_better_tbl = 1;
 				goto out;
 			}
 			break;
@@ -1331,17 +1333,17 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 				search_tbl->is_SGI = 1;
 			else
 				break;
-			lq_data->search_better_tbl = 1;
+			lq_sta->search_better_tbl = 1;
 			if ((tbl->lq_type == LQ_SISO) &&
 			    (tbl->is_SGI)) {
-				s32 tpt = lq_data->last_tpt / 100;
+				s32 tpt = lq_sta->last_tpt / 100;
 				if (((!tbl->is_fat) &&
 				     (tpt >= expected_tpt_siso20MHz[index])) ||
 				    ((tbl->is_fat) &&
 				     (tpt >= expected_tpt_siso40MHz[index])))
-					lq_data->search_better_tbl = 0;
+					lq_sta->search_better_tbl = 0;
 			}
-			rs_get_expected_tpt_table(lq_data, search_tbl);
+			rs_get_expected_tpt_table(lq_sta, search_tbl);
 			rs_mcs_from_tbl(&search_tbl->current_rate,
 					     search_tbl, index, is_green);
 			goto out;
@@ -1366,23 +1368,23 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
  * Try to switch to new modulation mode from MIMO
  */
 static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
-				 struct iwl4965_rate_scale_priv *lq_data,
+				 struct iwl4965_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
 				 struct sta_info *sta,
 				 int index)
 {
 	int ret;
-	s8 is_green = lq_data->is_green;
+	s8 is_green = lq_sta->is_green;
 	struct iwl4965_scale_tbl_info *tbl =
-	    &(lq_data->lq_info[lq_data->active_tbl]);
+	    &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl4965_scale_tbl_info *search_tbl =
-	    &(lq_data->lq_info[(1 - lq_data->active_tbl)]);
+	    &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 	u32 sz = (sizeof(struct iwl4965_scale_tbl_info) -
 		  (sizeof(struct iwl4965_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
 
 	for (;;) {
-		lq_data->action_counter++;
+		lq_sta->action_counter++;
 		switch (tbl->action) {
 		case IWL_MIMO_SWITCH_ANTENNA_A:
 		case IWL_MIMO_SWITCH_ANTENNA_B:
@@ -1398,10 +1400,10 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 			else
 				search_tbl->antenna_type = ANT_AUX;
 
-			ret = rs_switch_to_siso(priv, lq_data, conf, sta,
+			ret = rs_switch_to_siso(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
-				lq_data->search_better_tbl = 1;
+				lq_sta->search_better_tbl = 1;
 				goto out;
 			}
 			break;
@@ -1418,7 +1420,7 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 				search_tbl->is_SGI = 0;
 			else
 				search_tbl->is_SGI = 1;
-			lq_data->search_better_tbl = 1;
+			lq_sta->search_better_tbl = 1;
 
 			/*
 			 * If active table already uses the fastest possible
@@ -1428,14 +1430,14 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 			 */
 			if ((tbl->lq_type == LQ_MIMO) &&
 			    (tbl->is_SGI)) {
-				s32 tpt = lq_data->last_tpt / 100;
+				s32 tpt = lq_sta->last_tpt / 100;
 				if (((!tbl->is_fat) &&
 				     (tpt >= expected_tpt_mimo20MHz[index])) ||
 				    ((tbl->is_fat) &&
 				     (tpt >= expected_tpt_mimo40MHz[index])))
-					lq_data->search_better_tbl = 0;
+					lq_sta->search_better_tbl = 0;
 			}
-			rs_get_expected_tpt_table(lq_data, search_tbl);
+			rs_get_expected_tpt_table(lq_sta, search_tbl);
 			rs_mcs_from_tbl(&search_tbl->current_rate,
 					     search_tbl, index, is_green);
 			goto out;
@@ -1465,25 +1467,25 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
  * 2) # times calling this function
  * 3) elapsed time in this mode (not used, for now)
  */
-static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
+static void rs_stay_in_table(struct iwl4965_lq_sta *lq_sta)
 {
 	struct iwl4965_scale_tbl_info *tbl;
 	int i;
 	int active_tbl;
 	int flush_interval_passed = 0;
 
-	active_tbl = lq_data->active_tbl;
+	active_tbl = lq_sta->active_tbl;
 
-	tbl = &(lq_data->lq_info[active_tbl]);
+	tbl = &(lq_sta->lq_info[active_tbl]);
 
 	/* If we've been disallowing search, see if we should now allow it */
-	if (lq_data->stay_in_tbl) {
+	if (lq_sta->stay_in_tbl) {
 
 		/* Elapsed time using current modulation mode */
-		if (lq_data->flush_timer)
+		if (lq_sta->flush_timer)
 			flush_interval_passed =
 			    time_after(jiffies,
-				       (unsigned long)(lq_data->flush_timer +
+				       (unsigned long)(lq_sta->flush_timer +
 					IWL_RATE_SCALE_FLUSH_INTVL));
 
 		/* For now, disable the elapsed time criterion */
@@ -1497,20 +1499,20 @@ static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 		 * allow a new search.  Also (below) reset all bitmaps and
 		 * stats in active history.
 		 */
-		if ((lq_data->total_failed > lq_data->max_failure_limit) ||
-		    (lq_data->total_success > lq_data->max_success_limit) ||
-		    ((!lq_data->search_better_tbl) && (lq_data->flush_timer)
+		if ((lq_sta->total_failed > lq_sta->max_failure_limit) ||
+		    (lq_sta->total_success > lq_sta->max_success_limit) ||
+		    ((!lq_sta->search_better_tbl) && (lq_sta->flush_timer)
 		     && (flush_interval_passed))) {
 			IWL_DEBUG_HT("LQ: stay is expired %d %d %d\n:",
-				     lq_data->total_failed,
-				     lq_data->total_success,
+				     lq_sta->total_failed,
+				     lq_sta->total_success,
 				     flush_interval_passed);
 
 			/* Allow search for new mode */
-			lq_data->stay_in_tbl = 0;	/* only place reset */
-			lq_data->total_failed = 0;
-			lq_data->total_success = 0;
-			lq_data->flush_timer = 0;
+			lq_sta->stay_in_tbl = 0;	/* only place reset */
+			lq_sta->total_failed = 0;
+			lq_sta->total_success = 0;
+			lq_sta->flush_timer = 0;
 
 		/*
 		 * Else if we've used this modulation mode enough repetitions
@@ -1519,10 +1521,10 @@ static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 		 * active table.
 		 */
 		} else {
-			lq_data->table_count++;
-			if (lq_data->table_count >=
-			    lq_data->table_count_limit) {
-				lq_data->table_count = 0;
+			lq_sta->table_count++;
+			if (lq_sta->table_count >=
+			    lq_sta->table_count_limit) {
+				lq_sta->table_count = 0;
 
 				IWL_DEBUG_HT("LQ: stay in table clear win\n");
 				for (i = 0; i < IWL_RATE_COUNT; i++)
@@ -1534,7 +1536,7 @@ static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 		/* If transitioning to allow "search", reset all history
 		 * bitmaps and stats in active table (this will become the new
 		 * "search" table). */
-		if (!lq_data->stay_in_tbl) {
+		if (!lq_sta->stay_in_tbl) {
 			for (i = 0; i < IWL_RATE_COUNT; i++)
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 		}
@@ -1564,7 +1566,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	s8 scale_action = 0;
 	u16 fc, rate_mask;
 	u8 update_lq = 0;
-	struct iwl4965_rate_scale_priv *lq_data;
+	struct iwl4965_lq_sta *lq_sta;
 	struct iwl4965_scale_tbl_info *tbl, *tbl1;
 	u16 rate_scale_index_msk = 0;
 	struct iwl4965_rate mcs_rate;
@@ -1590,20 +1592,20 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		IWL_DEBUG_RATE("still rate scaling not ready\n");
 		return;
 	}
-	lq_data = (struct iwl4965_rate_scale_priv *)sta->rate_ctrl_priv;
+	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
 	 * the rest of this function:  "search" if searching for better
 	 * modulation mode, or "active" if doing rate scaling within a mode.
 	 */
-	if (!lq_data->search_better_tbl)
-		active_tbl = lq_data->active_tbl;
+	if (!lq_sta->search_better_tbl)
+		active_tbl = lq_sta->active_tbl;
 	else
-		active_tbl = 1 - lq_data->active_tbl;
+		active_tbl = 1 - lq_sta->active_tbl;
 
-	tbl = &(lq_data->lq_info[active_tbl]);
-	is_green = lq_data->is_green;
+	tbl = &(lq_sta->lq_info[active_tbl]);
+	is_green = lq_sta->is_green;
 
 	/* current tx rate */
 	index = sta->last_txrate;
@@ -1612,20 +1614,20 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		       tbl->lq_type);
 
 	/* rates available for this association, and for modulation mode */
-	rs_get_supported_rates(lq_data, hdr, tbl->lq_type,
+	rs_get_supported_rates(lq_sta, hdr, tbl->lq_type,
 				&rate_mask);
 
 	IWL_DEBUG_RATE("mask 0x%04X \n", rate_mask);
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
-		if (lq_data->phymode == (u8) MODE_IEEE80211A)
+		if (lq_sta->phymode == (u8) MODE_IEEE80211A)
 			/* supp_rates has no CCK bits in A mode */
 			rate_scale_index_msk = (u16) (rate_mask &
-				(lq_data->supp_rates << IWL_FIRST_OFDM_RATE));
+				(lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
 			rate_scale_index_msk = (u16) (rate_mask &
-						      lq_data->supp_rates);
+						      lq_sta->supp_rates);
 
 	} else
 		rate_scale_index_msk = rate_mask;
@@ -1653,7 +1655,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 
 	/* Get expected throughput table and history window for current rate */
 	if (!tbl->expected_tpt)
-		rs_get_expected_tpt_table(lq_data, tbl);
+		rs_get_expected_tpt_table(lq_sta, tbl);
 
 	window = &(tbl->win[index]);
 
@@ -1677,13 +1679,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 
 		/* Should we stay with this modulation mode,
 		 * or search for a new one? */
-		rs_stay_in_table(lq_data);
+		rs_stay_in_table(lq_sta);
 
 		/* Set up new rate table in uCode, if needed */
 		if (update_lq) {
 			rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-			rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq);
-			rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
+			rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
+			rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
 		goto out;
 
@@ -1694,25 +1696,25 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 					tbl->expected_tpt[index] + 64) / 128);
 
 	/* If we are searching for better modulation mode, check success. */
-	if (lq_data->search_better_tbl) {
+	if (lq_sta->search_better_tbl) {
 		int success_limit = IWL_RATE_SCALE_SWITCH;
 
 		/* If good success, continue using the "search" mode;
 		 * no need to send new link quality command, since we're
 		 * continuing to use the setup that we've been trying. */
 		if ((window->success_ratio > success_limit) ||
-		    (window->average_tpt > lq_data->last_tpt)) {
+		    (window->average_tpt > lq_sta->last_tpt)) {
 			if (!is_legacy(tbl->lq_type)) {
 				IWL_DEBUG_HT("LQ: we are switching to HT"
 					     " rate suc %d current tpt %d"
 					     " old tpt %d\n",
 					     window->success_ratio,
 					     window->average_tpt,
-					     lq_data->last_tpt);
-				lq_data->enable_counter = 1;
+					     lq_sta->last_tpt);
+				lq_sta->enable_counter = 1;
 			}
 			/* Swap tables; "search" becomes "active" */
-			lq_data->active_tbl = active_tbl;
+			lq_sta->active_tbl = active_tbl;
 			current_tpt = window->average_tpt;
 
 		/* Else poor success; go back to mode in "active" table */
@@ -1721,13 +1723,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 			tbl->lq_type = LQ_NONE;
 
 			/* Revert to "active" table */
-			active_tbl = lq_data->active_tbl;
-			tbl = &(lq_data->lq_info[active_tbl]);
+			active_tbl = lq_sta->active_tbl;
+			tbl = &(lq_sta->lq_info[active_tbl]);
 
 			/* Revert to "active" rate and throughput info */
 			index = iwl4965_rate_index_from_plcp(
 				tbl->current_rate.rate_n_flags);
-			current_tpt = lq_data->last_tpt;
+			current_tpt = lq_sta->last_tpt;
 
 			/* Need to set up a new rate table in uCode */
 			update_lq = 1;
@@ -1736,7 +1738,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 
 		/* Either way, we've made a decision; modulation mode
 		 * search is done, allow rate adjustment next time. */
-		lq_data->search_better_tbl = 0;
+		lq_sta->search_better_tbl = 0;
 		done_search = 1;	/* Don't switch modes below! */
 		goto lq_update;
 	}
@@ -1847,12 +1849,12 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
 		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-		rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq);
-		rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
+		rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
+		rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 	}
 
 	/* Should we stay with this modulation mode, or search for a new one? */
-	rs_stay_in_table(lq_data);
+	rs_stay_in_table(lq_sta);
 
 	/*
 	 * Search for new modulation mode if we're:
@@ -1860,23 +1862,23 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	 * 2)  Not just finishing up a search
 	 * 3)  Allowing a new search
 	 */
-	if (!update_lq && !done_search && !lq_data->stay_in_tbl) {
+	if (!update_lq && !done_search && !lq_sta->stay_in_tbl) {
 		/* Save current throughput to compare with "search" throughput*/
-		lq_data->last_tpt = current_tpt;
+		lq_sta->last_tpt = current_tpt;
 
 		/* Select a new "search" modulation mode to try.
 		 * If one is found, set up the new "search" table. */
 		if (is_legacy(tbl->lq_type))
-			rs_move_legacy_other(priv, lq_data, conf, sta, index);
+			rs_move_legacy_other(priv, lq_sta, conf, sta, index);
 		else if (is_siso(tbl->lq_type))
-			rs_move_siso_to_other(priv, lq_data, conf, sta, index);
+			rs_move_siso_to_other(priv, lq_sta, conf, sta, index);
 		else
-			rs_move_mimo_to_other(priv, lq_data, conf, sta, index);
+			rs_move_mimo_to_other(priv, lq_sta, conf, sta, index);
 
 		/* If new "search" mode was selected, set up in uCode table */
-		if (lq_data->search_better_tbl) {
+		if (lq_sta->search_better_tbl) {
 			/* Access the "search" table, clear its history. */
-			tbl = &(lq_data->lq_info[(1 - lq_data->active_tbl)]);
+			tbl = &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 			for (i = 0; i < IWL_RATE_COUNT; i++)
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 
@@ -1886,9 +1888,9 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 
 			IWL_DEBUG_HT("Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate.rate_n_flags, index);
-			rs_fill_link_cmd(lq_data, &tbl->current_rate,
-					 &lq_data->lq);
-			rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
+			rs_fill_link_cmd(lq_sta, &tbl->current_rate,
+					 &lq_sta->lq);
+			rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
 
 		/* If the "active" (non-search) mode was legacy,
@@ -1896,33 +1898,33 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		 * but we haven't been able to try HT modes (not available),
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
-		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
+		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		if (is_legacy(tbl1->lq_type) &&
 #ifdef CONFIG_IWL4965_HT
 		   (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)) &&
 #endif
-		    (lq_data->action_counter >= 1)) {
-			lq_data->action_counter = 0;
+		    (lq_sta->action_counter >= 1)) {
+			lq_sta->action_counter = 0;
 			IWL_DEBUG_HT("LQ: STAY in legacy table\n");
-			rs_set_stay_in_table(1, lq_data);
+			rs_set_stay_in_table(1, lq_sta);
 		}
 
 		/* If we're in an HT mode, and all 3 mode switch actions
 		 * have been tried and compared, stay in this best modulation
 		 * mode for a while before next round of mode comparisons. */
-		if (lq_data->enable_counter &&
-		    (lq_data->action_counter >= IWL_ACTION_LIMIT)) {
+		if (lq_sta->enable_counter &&
+		    (lq_sta->action_counter >= IWL_ACTION_LIMIT)) {
 #ifdef CONFIG_IWL4965_HT_AGG
 			/* If appropriate, set up aggregation! */
-			if ((lq_data->last_tpt > TID_AGG_TPT_THREHOLD) &&
+			if ((lq_sta->last_tpt > TID_AGG_TPT_THREHOLD) &&
 			    (priv->lq_mngr.agg_ctrl.auto_agg)) {
 				priv->lq_mngr.agg_ctrl.tid_retry =
 				    TID_ALL_SPECIFIED;
 				schedule_work(&priv->agg_work);
 			}
 #endif /*CONFIG_IWL4965_HT_AGG */
-			lq_data->action_counter = 0;
-			rs_set_stay_in_table(0, lq_data);
+			lq_sta->action_counter = 0;
+			rs_set_stay_in_table(0, lq_sta);
 		}
 
 	/*
@@ -1933,8 +1935,8 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	 * 3)  flush timer is empty
 	 */
 	} else {
-		if ((!update_lq) && (!done_search) && (!lq_data->flush_timer))
-			lq_data->flush_timer = jiffies;
+		if ((!update_lq) && (!done_search) && (!lq_sta->flush_timer))
+			lq_sta->flush_timer = jiffies;
 	}
 
 out:
@@ -1945,7 +1947,7 @@ out:
 	/* sta->txrate is an index to A mode rates which start
 	 * at IWL_FIRST_OFDM_RATE
 	 */
-	if (lq_data->phymode == (u8) MODE_IEEE80211A)
+	if (lq_sta->phymode == (u8) MODE_IEEE80211A)
 		sta->txrate = i - IWL_FIRST_OFDM_RATE;
 	else
 		sta->txrate = i;
@@ -1959,7 +1961,7 @@ static void rs_initialize_lq(struct iwl4965_priv *priv,
 			     struct sta_info *sta)
 {
 	int i;
-	struct iwl4965_rate_scale_priv *lq;
+	struct iwl4965_lq_sta *lq_sta;
 	struct iwl4965_scale_tbl_info *tbl;
 	u8 active_tbl = 0;
 	int rate_idx;
@@ -1969,19 +1971,19 @@ static void rs_initialize_lq(struct iwl4965_priv *priv,
 	if (!sta || !sta->rate_ctrl_priv)
 		goto out;
 
-	lq = (struct iwl4965_rate_scale_priv *)sta->rate_ctrl_priv;
+	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 	i = sta->last_txrate;
 
-	if ((lq->lq.sta_id == 0xff) &&
+	if ((lq_sta->lq.sta_id == 0xff) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
 		goto out;
 
-	if (!lq->search_better_tbl)
-		active_tbl = lq->active_tbl;
+	if (!lq_sta->search_better_tbl)
+		active_tbl = lq_sta->active_tbl;
 	else
-		active_tbl = 1 - lq->active_tbl;
+		active_tbl = 1 - lq_sta->active_tbl;
 
-	tbl = &(lq->lq_info[active_tbl]);
+	tbl = &(lq_sta->lq_info[active_tbl]);
 
 	if ((i < 0) || (i >= IWL_RATE_COUNT))
 		i = 0;
@@ -2000,9 +2002,9 @@ static void rs_initialize_lq(struct iwl4965_priv *priv,
 
 	rs_mcs_from_tbl(&mcs_rate, tbl, rate_idx, use_green);
 	tbl->current_rate.rate_n_flags = mcs_rate.rate_n_flags;
-	rs_get_expected_tpt_table(lq, tbl);
-	rs_fill_link_cmd(lq, &mcs_rate, &lq->lq);
-	rs_send_lq_cmd(priv, &lq->lq, CMD_ASYNC);
+	rs_get_expected_tpt_table(lq_sta, tbl);
+	rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
+	rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
  out:
 	return;
 }
@@ -2019,7 +2021,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	struct sta_info *sta;
 	u16 fc;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
-	struct iwl4965_rate_scale_priv *lq;
+	struct iwl4965_lq_sta *lq_sta;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
@@ -2036,10 +2038,11 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 		return;
 	}
 
-	lq = (struct iwl4965_rate_scale_priv *)sta->rate_ctrl_priv;
+	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 	i = sta->last_txrate;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) && !lq->ibss_sta_added) {
+	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	    !lq_sta->ibss_sta_added) {
 		u8 sta_id = iwl4965_hw_find_station(priv, hdr->addr1);
 		DECLARE_MAC_BUF(mac);
 
@@ -2050,12 +2053,12 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
-			lq->lq.sta_id = sta_id;
-			lq->lq.rs_table[0].rate_n_flags = 0;
-			lq->ibss_sta_added = 1;
+			lq_sta->lq.sta_id = sta_id;
+			lq_sta->lq.rs_table[0].rate_n_flags = 0;
+			lq_sta->ibss_sta_added = 1;
 			rs_initialize_lq(priv, conf, sta);
 		}
-		if (!lq->ibss_sta_added)
+		if (!lq_sta->ibss_sta_added)
 			goto done;
 	}
 
@@ -2071,23 +2074,23 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 
 static void *rs_alloc_sta(void *priv, gfp_t gfp)
 {
-	struct iwl4965_rate_scale_priv *crl;
+	struct iwl4965_lq_sta *lq_sta;
 	int i, j;
 
 	IWL_DEBUG_RATE("create station rate scale window\n");
 
-	crl = kzalloc(sizeof(struct iwl4965_rate_scale_priv), gfp);
+	lq_sta = kzalloc(sizeof(struct iwl4965_lq_sta), gfp);
 
-	if (crl == NULL)
+	if (lq_sta == NULL)
 		return NULL;
-	crl->lq.sta_id = 0xff;
+	lq_sta->lq.sta_id = 0xff;
 
 
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&(crl->lq_info[j].win[i]));
+			rs_rate_scale_clear_window(&(lq_sta->lq_info[j].win[i]));
 
-	return crl;
+	return lq_sta;
 }
 
 static void rs_rate_init(void *priv_rate, void *priv_sta,
@@ -2098,14 +2101,14 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
-	struct iwl4965_rate_scale_priv *crl = priv_sta;
+	struct iwl4965_lq_sta *lq_sta = priv_sta;
 
-	crl->flush_timer = 0;
-	crl->supp_rates = sta->supp_rates;
+	lq_sta->flush_timer = 0;
+	lq_sta->supp_rates = sta->supp_rates;
 	sta->txrate = 3;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&(crl->lq_info[j].win[i]));
+			rs_rate_scale_clear_window(&(lq_sta->lq_info[j].win[i]));
 
 	IWL_DEBUG_RATE("rate scale global init\n");
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
@@ -2113,7 +2116,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
 
-	crl->ibss_sta_added = 0;
+	lq_sta->ibss_sta_added = 0;
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
 		u8 sta_id = iwl4965_hw_find_station(priv, sta->addr);
 		DECLARE_MAC_BUF(mac);
@@ -2129,8 +2132,8 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
-			crl->lq.sta_id = sta_id;
-			crl->lq.rs_table[0].rate_n_flags = 0;
+			lq_sta->lq.sta_id = sta_id;
+			lq_sta->lq.rs_table[0].rate_n_flags = 0;
 		}
 		/* FIXME: this is w/a remove it later */
 		priv->assoc_station_added = 1;
@@ -2147,36 +2150,39 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	if (local->hw.conf.phymode == MODE_IEEE80211A)
 		sta->last_txrate += IWL_FIRST_OFDM_RATE;
 
-	crl->is_dup = 0;
-	crl->valid_antenna = priv->valid_antenna;
-	crl->antenna = priv->antenna;
-	crl->is_green = rs_use_green(priv, conf);
-	crl->active_rate = priv->active_rate;
-	crl->active_rate &= ~(0x1000);
-	crl->active_rate_basic = priv->active_rate_basic;
-	crl->phymode = priv->phymode;
+	lq_sta->is_dup = 0;
+	lq_sta->valid_antenna = priv->valid_antenna;
+	lq_sta->antenna = priv->antenna;
+	lq_sta->is_green = rs_use_green(priv, conf);
+	lq_sta->active_rate = priv->active_rate;
+	lq_sta->active_rate &= ~(0x1000);
+	lq_sta->active_rate_basic = priv->active_rate_basic;
+	lq_sta->phymode = priv->phymode;
 #ifdef CONFIG_IWL4965_HT
 	/*
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
 	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
 	 */
-	crl->active_siso_rate = (priv->current_ht_config.supp_mcs_set[0] << 1);
-	crl->active_siso_rate |=
+	lq_sta->active_siso_rate = (priv->current_ht_config.supp_mcs_set[0] << 1);
+	lq_sta->active_siso_rate |=
 			(priv->current_ht_config.supp_mcs_set[0] & 0x1);
-	crl->active_siso_rate &= ~((u16)0x2);
-	crl->active_siso_rate = crl->active_siso_rate << IWL_FIRST_OFDM_RATE;
+	lq_sta->active_siso_rate &= ~((u16)0x2);
+	lq_sta->active_siso_rate =
+			lq_sta->active_siso_rate << IWL_FIRST_OFDM_RATE;
 
 	/* Same here */
-	crl->active_mimo_rate = (priv->current_ht_config.supp_mcs_set[1] << 1);
-	crl->active_mimo_rate |=
+	lq_sta->active_mimo_rate = (priv->current_ht_config.supp_mcs_set[1] << 1);
+	lq_sta->active_mimo_rate |=
 			(priv->current_ht_config.supp_mcs_set[1] & 0x1);
-	crl->active_mimo_rate &= ~((u16)0x2);
-	crl->active_mimo_rate = crl->active_mimo_rate << IWL_FIRST_OFDM_RATE;
-	IWL_DEBUG_HT("MIMO RATE 0x%X SISO MASK 0x%X\n", crl->active_siso_rate,
-		     crl->active_mimo_rate);
+	lq_sta->active_mimo_rate &= ~((u16)0x2);
+	lq_sta->active_mimo_rate =
+			lq_sta->active_mimo_rate << IWL_FIRST_OFDM_RATE;
+	IWL_DEBUG_HT("SISO RATE 0x%X MIMO RATE 0x%X\n",
+		     lq_sta->active_siso_rate,
+		     lq_sta->active_mimo_rate);
 #endif /*CONFIG_IWL4965_HT*/
 #ifdef CONFIG_MAC80211_DEBUGFS
-	crl->drv = priv;
+	lq_sta->drv = priv;
 #endif
 
 	if (priv->assoc_station_added)
@@ -2185,7 +2191,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	rs_initialize_lq(priv, conf, sta);
 }
 
-static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
+static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
 			    struct iwl4965_rate *tx_mcs,
 			    struct iwl4965_link_quality_cmd *lq_cmd)
 {
@@ -2198,10 +2204,10 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 	struct iwl4965_scale_tbl_info tbl_type = { 0 };
 
 	/* Override starting rate (index 0) if needed for debug purposes */
-	rs_dbgfs_set_mcs(lq_data, tx_mcs, index);
+	rs_dbgfs_set_mcs(lq_sta, tx_mcs, index);
 
 	/* Interpret rate_n_flags */
-	rs_get_tbl_info_from_mcs(tx_mcs, lq_data->phymode,
+	rs_get_tbl_info_from_mcs(tx_mcs, lq_sta->phymode,
 				  &tbl_type, &rate_idx);
 
 	/* How many times should we repeat the initial rate? */
@@ -2246,7 +2252,7 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 			}
 
 			/* Override next rate if needed for debug purposes */
-			rs_dbgfs_set_mcs(lq_data, &new_rate, index);
+			rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
 
 			/* Fill next table entry */
 			lq_cmd->rs_table[index].rate_n_flags =
@@ -2255,7 +2261,7 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 			index++;
 		}
 
-		rs_get_tbl_info_from_mcs(&new_rate, lq_data->phymode, &tbl_type,
+		rs_get_tbl_info_from_mcs(&new_rate, lq_sta->phymode, &tbl_type,
 						&rate_idx);
 
 		/* Indicate to uCode which entries might be MIMO.
@@ -2265,7 +2271,7 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 			lq_cmd->general_params.mimo_delimiter = index;
 
 		/* Get next rate */
-		rs_get_lower_rate(lq_data, &tbl_type, rate_idx,
+		rs_get_lower_rate(lq_sta, &tbl_type, rate_idx,
 				  use_ht_possible, &new_rate);
 
 		/* How many times should we repeat the next rate? */
@@ -2285,7 +2291,7 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 		use_ht_possible = 0;
 
 		/* Override next rate if needed for debug purposes */
-		rs_dbgfs_set_mcs(lq_data, &new_rate, index);
+		rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
 
 		/* Fill next table entry */
 		lq_cmd->rs_table[index].rate_n_flags =
@@ -2329,10 +2335,10 @@ static void rs_clear(void *priv_rate)
 
 static void rs_free_sta(void *priv, void *priv_sta)
 {
-	struct iwl4965_rate_scale_priv *rs_priv = priv_sta;
+	struct iwl4965_lq_sta *lq_sta = priv_sta;
 
 	IWL_DEBUG_RATE("enter\n");
-	kfree(rs_priv);
+	kfree(lq_sta);
 	IWL_DEBUG_RATE("leave\n");
 }
 
@@ -2343,19 +2349,19 @@ static int open_file_generic(struct inode *inode, struct file *file)
 	file->private_data = inode->i_private;
 	return 0;
 }
-static void rs_dbgfs_set_mcs(struct iwl4965_rate_scale_priv *rs_priv,
+static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
 				struct iwl4965_rate *mcs, int index)
 {
 	u32 base_rate;
 
-	if (rs_priv->phymode == (u8) MODE_IEEE80211A)
+	if (lq_sta->phymode == (u8) MODE_IEEE80211A)
 		base_rate = 0x800D;
 	else
 		base_rate = 0x820A;
 
-	if (rs_priv->dbg_fixed.rate_n_flags) {
+	if (lq_sta->dbg_fixed.rate_n_flags) {
 		if (index < 12)
-			mcs->rate_n_flags = rs_priv->dbg_fixed.rate_n_flags;
+			mcs->rate_n_flags = lq_sta->dbg_fixed.rate_n_flags;
 		else
 			mcs->rate_n_flags = base_rate;
 		IWL_DEBUG_RATE("Fixed rate ON\n");
@@ -2368,7 +2374,7 @@ static void rs_dbgfs_set_mcs(struct iwl4965_rate_scale_priv *rs_priv,
 static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 			const char __user *user_buf, size_t count, loff_t *ppos)
 {
-	struct iwl4965_rate_scale_priv *rs_priv = file->private_data;
+	struct iwl4965_lq_sta *lq_sta = file->private_data;
 	char buf[64];
 	int buf_size;
 	u32 parsed_rate;
@@ -2379,20 +2385,20 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 		return -EFAULT;
 
 	if (sscanf(buf, "%x", &parsed_rate) == 1)
-		rs_priv->dbg_fixed.rate_n_flags = parsed_rate;
+		lq_sta->dbg_fixed.rate_n_flags = parsed_rate;
 	else
-		rs_priv->dbg_fixed.rate_n_flags = 0;
+		lq_sta->dbg_fixed.rate_n_flags = 0;
 
-	rs_priv->active_rate = 0x0FFF;		/* 1 - 54 MBits, includes CCK */
-	rs_priv->active_siso_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	rs_priv->active_mimo_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
+	lq_sta->active_siso_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
 	IWL_DEBUG_RATE("sta_id %d rate 0x%X\n",
-		rs_priv->lq.sta_id, rs_priv->dbg_fixed.rate_n_flags);
+		lq_sta->lq.sta_id, lq_sta->dbg_fixed.rate_n_flags);
 
-	if (rs_priv->dbg_fixed.rate_n_flags) {
-		rs_fill_link_cmd(rs_priv, &rs_priv->dbg_fixed, &rs_priv->lq);
-		rs_send_lq_cmd(rs_priv->drv, &rs_priv->lq, CMD_ASYNC);
+	if (lq_sta->dbg_fixed.rate_n_flags) {
+		rs_fill_link_cmd(lq_sta, &lq_sta->dbg_fixed, &lq_sta->lq);
+		rs_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC);
 	}
 
 	return count;
@@ -2405,38 +2411,38 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	int desc = 0;
 	int i = 0;
 
-	struct iwl4965_rate_scale_priv *rs_priv = file->private_data;
+	struct iwl4965_lq_sta *lq_sta = file->private_data;
 
-	desc += sprintf(buff+desc, "sta_id %d\n", rs_priv->lq.sta_id);
+	desc += sprintf(buff+desc, "sta_id %d\n", lq_sta->lq.sta_id);
 	desc += sprintf(buff+desc, "failed=%d success=%d rate=0%X\n",
-			rs_priv->total_failed, rs_priv->total_success,
-			rs_priv->active_rate);
+			lq_sta->total_failed, lq_sta->total_success,
+			lq_sta->active_rate);
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
-			rs_priv->dbg_fixed.rate_n_flags);
+			lq_sta->dbg_fixed.rate_n_flags);
 	desc += sprintf(buff+desc, "general:"
 		"flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
-		rs_priv->lq.general_params.flags,
-		rs_priv->lq.general_params.mimo_delimiter,
-		rs_priv->lq.general_params.single_stream_ant_msk,
-		rs_priv->lq.general_params.dual_stream_ant_msk);
+		lq_sta->lq.general_params.flags,
+		lq_sta->lq.general_params.mimo_delimiter,
+		lq_sta->lq.general_params.single_stream_ant_msk,
+		lq_sta->lq.general_params.dual_stream_ant_msk);
 
 	desc += sprintf(buff+desc, "agg:"
 			"time_limit=%d dist_start_th=%d frame_cnt_limit=%d\n",
-			le16_to_cpu(rs_priv->lq.agg_params.agg_time_limit),
-			rs_priv->lq.agg_params.agg_dis_start_th,
-			rs_priv->lq.agg_params.agg_frame_cnt_limit);
+			le16_to_cpu(lq_sta->lq.agg_params.agg_time_limit),
+			lq_sta->lq.agg_params.agg_dis_start_th,
+			lq_sta->lq.agg_params.agg_frame_cnt_limit);
 
 	desc += sprintf(buff+desc,
 			"Start idx [0]=0x%x [1]=0x%x [2]=0x%x [3]=0x%x\n",
-			rs_priv->lq.general_params.start_rate_index[0],
-			rs_priv->lq.general_params.start_rate_index[1],
-			rs_priv->lq.general_params.start_rate_index[2],
-			rs_priv->lq.general_params.start_rate_index[3]);
+			lq_sta->lq.general_params.start_rate_index[0],
+			lq_sta->lq.general_params.start_rate_index[1],
+			lq_sta->lq.general_params.start_rate_index[2],
+			lq_sta->lq.general_params.start_rate_index[3]);
 
 
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		desc += sprintf(buff+desc, " rate[%d] 0x%X\n",
-			i, le32_to_cpu(rs_priv->lq.rs_table[i].rate_n_flags));
+			i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
 
 	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 }
@@ -2453,22 +2459,22 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 	int desc = 0;
 	int i, j;
 
-	struct iwl4965_rate_scale_priv *rs_priv = file->private_data;
+	struct iwl4965_lq_sta *lq_sta = file->private_data;
 	for (i = 0; i < LQ_SIZE; i++) {
 		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d\n"
 				"rate=0x%X\n",
-				rs_priv->active_tbl == i?"*":"x",
-				rs_priv->lq_info[i].lq_type,
-				rs_priv->lq_info[i].is_SGI,
-				rs_priv->lq_info[i].is_fat,
-				rs_priv->lq_info[i].is_dup,
-				rs_priv->lq_info[i].current_rate.rate_n_flags);
+				lq_sta->active_tbl == i?"*":"x",
+				lq_sta->lq_info[i].lq_type,
+				lq_sta->lq_info[i].is_SGI,
+				lq_sta->lq_info[i].is_fat,
+				lq_sta->lq_info[i].is_dup,
+				lq_sta->lq_info[i].current_rate.rate_n_flags);
 		for (j = 0; j < IWL_RATE_COUNT; j++) {
 			desc += sprintf(buff+desc,
-					"counter=%d success=%d %%=%d\n",
-					rs_priv->lq_info[i].win[j].counter,
-					rs_priv->lq_info[i].win[j].success_counter,
-					rs_priv->lq_info[i].win[j].success_ratio);
+				"counter=%d success=%d %%=%d\n",
+				lq_sta->lq_info[i].win[j].counter,
+				lq_sta->lq_info[i].win[j].success_counter,
+				lq_sta->lq_info[i].win[j].success_ratio);
 		}
 	}
 	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
@@ -2482,20 +2488,20 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 static void rs_add_debugfs(void *priv, void *priv_sta,
 					struct dentry *dir)
 {
-	struct iwl4965_rate_scale_priv *rs_priv = priv_sta;
-	rs_priv->rs_sta_dbgfs_scale_table_file =
+	struct iwl4965_lq_sta *lq_sta = priv_sta;
+	lq_sta->rs_sta_dbgfs_scale_table_file =
 		debugfs_create_file("rate_scale_table", 0600, dir,
-				rs_priv, &rs_sta_dbgfs_scale_table_ops);
-	rs_priv->rs_sta_dbgfs_stats_table_file =
+				lq_sta, &rs_sta_dbgfs_scale_table_ops);
+	lq_sta->rs_sta_dbgfs_stats_table_file =
 		debugfs_create_file("rate_stats_table", 0600, dir,
-			rs_priv, &rs_sta_dbgfs_stats_table_ops);
+			lq_sta, &rs_sta_dbgfs_stats_table_ops);
 }
 
 static void rs_remove_debugfs(void *priv, void *priv_sta)
 {
-	struct iwl4965_rate_scale_priv *rs_priv = priv_sta;
-	debugfs_remove(rs_priv->rs_sta_dbgfs_scale_table_file);
-	debugfs_remove(rs_priv->rs_sta_dbgfs_stats_table_file);
+	struct iwl4965_lq_sta *lq_sta = priv_sta;
+	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
+	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
 }
 #endif
 
@@ -2520,9 +2526,9 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct iwl4965_priv *priv = hw->priv;
-	struct iwl4965_rate_scale_priv *rs_priv;
+	struct iwl4965_lq_sta *lq_sta;
 	struct sta_info *sta;
-	int count = 0, i;
+	int cnt = 0, i;
 	u32 samples = 0, success = 0, good = 0;
 	unsigned long now = jiffies;
 	u32 max_time = 0;
@@ -2538,10 +2544,10 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 		return sprintf(buf, "station %d not found\n", sta_id);
 	}
 
-	rs_priv = (void *)sta->rate_ctrl_priv;
+	lq_sta = (void *)sta->rate_ctrl_priv;
 
-	lq_type = rs_priv->lq_info[rs_priv->active_tbl].lq_type;
-	antenna = rs_priv->lq_info[rs_priv->active_tbl].antenna_type;
+	lq_type = lq_sta->lq_info[lq_sta->active_tbl].lq_type;
+	antenna = lq_sta->lq_info[lq_sta->active_tbl].antenna_type;
 
 	if (is_legacy(lq_type))
 		i = IWL_RATE_54M_INDEX;
@@ -2550,33 +2556,33 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 	while (1) {
 		u64 mask;
 		int j;
-		int active = rs_priv->active_tbl;
+		int active = lq_sta->active_tbl;
 
-		count +=
-		    sprintf(&buf[count], " %2dMbs: ", iwl4965_rates[i].ieee / 2);
+		cnt +=
+		    sprintf(&buf[cnt], " %2dMbs: ", iwl4965_rates[i].ieee / 2);
 
 		mask = (1ULL << (IWL_RATE_MAX_WINDOW - 1));
 		for (j = 0; j < IWL_RATE_MAX_WINDOW; j++, mask >>= 1)
-			buf[count++] =
-				(rs_priv->lq_info[active].win[i].data & mask)
+			buf[cnt++] =
+				(lq_sta->lq_info[active].win[i].data & mask)
 				? '1' : '0';
 
-		samples += rs_priv->lq_info[active].win[i].counter;
-		good += rs_priv->lq_info[active].win[i].success_counter;
-		success += rs_priv->lq_info[active].win[i].success_counter *
+		samples += lq_sta->lq_info[active].win[i].counter;
+		good += lq_sta->lq_info[active].win[i].success_counter;
+		success += lq_sta->lq_info[active].win[i].success_counter *
 			   iwl4965_rates[i].ieee;
 
-		if (rs_priv->lq_info[active].win[i].stamp) {
+		if (lq_sta->lq_info[active].win[i].stamp) {
 			int delta =
 				   jiffies_to_msecs(now -
-				   rs_priv->lq_info[active].win[i].stamp);
+				   lq_sta->lq_info[active].win[i].stamp);
 
 			if (delta > max_time)
 				max_time = delta;
 
-			count += sprintf(&buf[count], "%5dms\n", delta);
+			cnt += sprintf(&buf[cnt], "%5dms\n", delta);
 		} else
-			buf[count++] = '\n';
+			buf[cnt++] = '\n';
 
 		j = iwl4965_get_prev_ieee_rate(i);
 		if (j == i)
@@ -2589,19 +2595,20 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 	 * NOTE:  We multiply # of samples by 2 since the IEEE measurement
 	 * added from iwl4965_rates is actually 2X the rate */
 	if (samples)
-		count += sprintf(&buf[count],
+		cnt += sprintf(&buf[cnt],
 			 "\nAverage rate is %3d.%02dMbs over last %4dms\n"
 			 "%3d%% success (%d good packets over %d tries)\n",
 			 success / (2 * samples), (success * 5 / samples) % 10,
 			 max_time, good * 100 / samples, good, samples);
 	else
-		count += sprintf(&buf[count], "\nAverage rate: 0Mbs\n");
-	count += sprintf(&buf[count], "\nrate scale type %d antenna %d "
+		cnt += sprintf(&buf[cnt], "\nAverage rate: 0Mbs\n");
+
+	cnt += sprintf(&buf[cnt], "\nrate scale type %d antenna %d "
 			 "active_search %d rate index %d\n", lq_type, antenna,
-			 rs_priv->search_better_tbl, sta->last_txrate);
+			 lq_sta->search_better_tbl, sta->last_txrate);
 
 	sta_info_put(sta);
-	return count;
+	return cnt;
 }
 
 void iwl4965_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
-- 
1.5.3.4

