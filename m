Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbYDXAPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/16] iwlwifi: rate scale module cleanups
Date: Wed, 23 Apr 2008 17:14:58 -0700
Message-Id: <1208996108-15326-7-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021609_454581_585EAEE7)
In-Reply-To: <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

This patch does following changes
1. rs_get_expected_tpt_table: changed get to set
2. changed IWL_DEBUG_HT to IWL_DEBUG_RATE as appropriate
3. changed rs_get_supported_rates to be returning value function

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |  101 +++++++++++++--------------
 1 files changed, 49 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 7c55aa9..4063534 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -604,25 +604,23 @@ static inline u8 rs_use_green(struct iwl_priv *priv,
  * basic available rates.
  *
  */
-static void rs_get_supported_rates(struct iwl4965_lq_sta *lq_sta,
+static u16 rs_get_supported_rates(struct iwl4965_lq_sta *lq_sta,
 				   struct ieee80211_hdr *hdr,
-				   enum iwl_table_type rate_type,
-				   u16 *data_rate)
+				   enum iwl_table_type rate_type)
 {
-	if (is_legacy(rate_type))
-		*data_rate = lq_sta->active_legacy_rate;
-	else {
+	if (hdr && is_multicast_ether_addr(hdr->addr1) &&
+	    lq_sta->active_rate_basic)
+		return lq_sta->active_rate_basic;
+
+	if (is_legacy(rate_type)) {
+		return lq_sta->active_legacy_rate;
+	} else {
 		if (is_siso(rate_type))
-			*data_rate = lq_sta->active_siso_rate;
+			return lq_sta->active_siso_rate;
 		else if (is_mimo2(rate_type))
-			*data_rate = lq_sta->active_mimo2_rate;
+			return lq_sta->active_mimo2_rate;
 		else
-			*data_rate = lq_sta->active_mimo3_rate;
-	}
-
-	if (hdr && is_multicast_ether_addr(hdr->addr1) &&
-	    lq_sta->active_rate_basic) {
-		*data_rate = lq_sta->active_rate_basic;
+			return lq_sta->active_mimo3_rate;
 	}
 }
 
@@ -709,7 +707,7 @@ static u32 rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
 		tbl->is_SGI = 0;
 	}
 
-	rs_get_supported_rates(lq_sta, NULL, tbl->lq_type, &rate_mask);
+	rate_mask = rs_get_supported_rates(lq_sta, NULL, tbl->lq_type);
 
 	/* Mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
@@ -975,7 +973,7 @@ static u8 rs_is_other_ant_connected(u8 valid_antenna, u8 ant_type)
 static void rs_set_stay_in_table(u8 is_legacy,
 				 struct iwl4965_lq_sta *lq_sta)
 {
-	IWL_DEBUG_HT("we are staying in the same table\n");
+	IWL_DEBUG_RATE("we are staying in the same table\n");
 	lq_sta->stay_in_tbl = 1;	/* only place this gets set */
 	if (is_legacy) {
 		lq_sta->table_count_limit = IWL_LEGACY_TABLE_COUNT;
@@ -994,7 +992,7 @@ static void rs_set_stay_in_table(u8 is_legacy,
 /*
  * Find correct throughput table for given mode of modulation
  */
-static void rs_get_expected_tpt_table(struct iwl4965_lq_sta *lq_sta,
+static void rs_set_expected_tpt_table(struct iwl4965_lq_sta *lq_sta,
 				      struct iwl4965_scale_tbl_info *tbl)
 {
 	if (is_legacy(tbl->lq_type)) {
@@ -1161,7 +1159,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	if (!rs_is_both_ant_supp(priv->hw_params.valid_tx_ant))
 		return -1;
 
-	IWL_DEBUG_HT("LQ: try to switch to MIMO2\n");
+	IWL_DEBUG_RATE("LQ: try to switch to MIMO2\n");
 
 	tbl->lq_type = LQ_MIMO2;
 	tbl->is_dup = lq_sta->is_dup;
@@ -1186,20 +1184,20 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 		tbl->is_SGI = 0;
 	*/
 
-	rs_get_expected_tpt_table(lq_sta, tbl);
+	rs_set_expected_tpt_table(lq_sta, tbl);
 
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
 
-	IWL_DEBUG_HT("LQ: MIMO2 best rate %d mask %X\n", rate, rate_mask);
+	IWL_DEBUG_RATE("LQ: MIMO2 best rate %d mask %X\n", rate, rate_mask);
 
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
-		IWL_DEBUG_HT("Can't switch with index %d rate mask %x\n",
+		IWL_DEBUG_RATE("Can't switch with index %d rate mask %x\n",
 						rate, rate_mask);
 		return -1;
 	}
 	tbl->current_rate = rate_n_flags_from_tbl(tbl, rate, is_green);
 
-	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
+	IWL_DEBUG_RATE("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 }
@@ -1232,7 +1230,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	    !sta->ht_info.ht_supported)
 		return -1;
 
-	IWL_DEBUG_HT("LQ: try to switch to SISO\n");
+	IWL_DEBUG_RATE("LQ: try to switch to SISO\n");
 
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->lq_type = LQ_SISO;
@@ -1260,17 +1258,17 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	if (is_green)
 		tbl->is_SGI = 0; /*11n spec: no SGI in SISO+Greenfield*/
 
-	rs_get_expected_tpt_table(lq_sta, tbl);
+	rs_set_expected_tpt_table(lq_sta, tbl);
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
 
-	IWL_DEBUG_HT("LQ: get best rate %d mask %X\n", rate, rate_mask);
+	IWL_DEBUG_RATE("LQ: get best rate %d mask %X\n", rate, rate_mask);
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
-		IWL_DEBUG_HT("can not switch with index %d rate mask %x\n",
+		IWL_DEBUG_RATE("can not switch with index %d rate mask %x\n",
 			     rate, rate_mask);
 		return -1;
 	}
 	tbl->current_rate = rate_n_flags_from_tbl(tbl, rate, is_green);
-	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
+	IWL_DEBUG_RATE("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 #else
@@ -1302,7 +1300,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	for (; ;) {
 		switch (tbl->action) {
 		case IWL_LEGACY_SWITCH_ANTENNA:
-			IWL_DEBUG_HT("LQ Legacy toggle Antenna\n");
+			IWL_DEBUG_RATE("LQ Legacy toggle Antenna\n");
 
 			search_tbl->lq_type = LQ_NONE;
 			lq_sta->action_counter++;
@@ -1322,12 +1320,12 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 			rs_toggle_antenna(&search_tbl->current_rate,
 					   search_tbl);
-			rs_get_expected_tpt_table(lq_sta, search_tbl);
+			rs_set_expected_tpt_table(lq_sta, search_tbl);
 			lq_sta->search_better_tbl = 1;
 			goto out;
 
 		case IWL_LEGACY_SWITCH_SISO:
-			IWL_DEBUG_HT("LQ: Legacy switch to SISO\n");
+			IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
 
 			/* Set up search table to try SISO */
 			memcpy(search_tbl, tbl, sz);
@@ -1342,7 +1340,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 			break;
 		case IWL_LEGACY_SWITCH_MIMO2:
-			IWL_DEBUG_HT("LQ: Legacy switch to MIMO2\n");
+			IWL_DEBUG_RATE("LQ: Legacy switch to MIMO2\n");
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
@@ -1401,7 +1399,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		lq_sta->action_counter++;
 		switch (tbl->action) {
 		case IWL_SISO_SWITCH_ANTENNA:
-			IWL_DEBUG_HT("LQ: SISO toggle Antenna\n");
+			IWL_DEBUG_RATE("LQ: SISO toggle Antenna\n");
 			/*FIXME:RS: is this really needed for SISO?*/
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
@@ -1417,7 +1415,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			goto out;
 
 		case IWL_SISO_SWITCH_MIMO2:
-			IWL_DEBUG_HT("LQ: SISO switch to MIMO\n");
+			IWL_DEBUG_RATE("LQ: SISO switch to MIMO\n");
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
 			search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
@@ -1429,7 +1427,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			}
 			break;
 		case IWL_SISO_SWITCH_GI:
-			IWL_DEBUG_HT("LQ: SISO toggle SGI/NGI\n");
+			IWL_DEBUG_RATE("LQ: SISO toggle SGI/NGI\n");
 
 			memcpy(search_tbl, tbl, sz);
 			if (is_green) {
@@ -1439,7 +1437,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 					IWL_ERROR("SGI was set in GF+SISO\n");
 			}
 			search_tbl->is_SGI = !tbl->is_SGI;
-			rs_get_expected_tpt_table(lq_sta, search_tbl);
+			rs_set_expected_tpt_table(lq_sta, search_tbl);
 			if (tbl->is_SGI) {
 				s32 tpt = lq_sta->last_tpt / 100;
 				if (tpt >= search_tbl->expected_tpt[index])
@@ -1490,7 +1488,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 		switch (tbl->action) {
 		case IWL_MIMO_SWITCH_ANTENNA_A:
 		case IWL_MIMO_SWITCH_ANTENNA_B:
-			IWL_DEBUG_HT("LQ: MIMO2 switch to SISO\n");
+			IWL_DEBUG_RATE("LQ: MIMO2 switch to SISO\n");
 
 			/* Set up new search table for SISO */
 			memcpy(search_tbl, tbl, sz);
@@ -1510,12 +1508,12 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 			break;
 
 		case IWL_MIMO_SWITCH_GI:
-			IWL_DEBUG_HT("LQ: MIMO toggle SGI/NGI\n");
+			IWL_DEBUG_RATE("LQ: MIMO toggle SGI/NGI\n");
 
 			/* Set up new search table for MIMO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = !tbl->is_SGI;
-			rs_get_expected_tpt_table(lq_sta, search_tbl);
+			rs_set_expected_tpt_table(lq_sta, search_tbl);
 			/*
 			 * If active table already uses the fastest possible
 			 * modulation (dual stream with short guard interval),
@@ -1593,7 +1591,7 @@ static void rs_stay_in_table(struct iwl4965_lq_sta *lq_sta)
 		    (lq_sta->total_success > lq_sta->max_success_limit) ||
 		    ((!lq_sta->search_better_tbl) && (lq_sta->flush_timer)
 		     && (flush_interval_passed))) {
-			IWL_DEBUG_HT("LQ: stay is expired %d %d %d\n:",
+			IWL_DEBUG_RATE("LQ: stay is expired %d %d %d\n:",
 				     lq_sta->total_failed,
 				     lq_sta->total_success,
 				     flush_interval_passed);
@@ -1616,7 +1614,7 @@ static void rs_stay_in_table(struct iwl4965_lq_sta *lq_sta)
 			    lq_sta->table_count_limit) {
 				lq_sta->table_count = 0;
 
-				IWL_DEBUG_HT("LQ: stay in table clear win\n");
+				IWL_DEBUG_RATE("LQ: stay in table clear win\n");
 				for (i = 0; i < IWL_RATE_COUNT; i++)
 					rs_rate_scale_clear_window(
 						&(tbl->win[i]));
@@ -1715,8 +1713,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		       tbl->lq_type);
 
 	/* rates available for this association, and for modulation mode */
-	rs_get_supported_rates(lq_sta, hdr, tbl->lq_type,
-				&rate_mask);
+	rate_mask = rs_get_supported_rates(lq_sta, hdr, tbl->lq_type);
 
 	IWL_DEBUG_RATE("mask 0x%04X \n", rate_mask);
 
@@ -1756,7 +1753,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	/* Get expected throughput table and history window for current rate */
 	if (!tbl->expected_tpt)
-		rs_get_expected_tpt_table(lq_sta, tbl);
+		rs_set_expected_tpt_table(lq_sta, tbl);
 
 	window = &(tbl->win[index]);
 
@@ -1806,7 +1803,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		if ((window->success_ratio > success_limit) ||
 		    (window->average_tpt > lq_sta->last_tpt)) {
 			if (!is_legacy(tbl->lq_type)) {
-				IWL_DEBUG_HT("LQ: we are switching to HT"
+				IWL_DEBUG_RATE("LQ: we are switching to HT"
 					     " rate suc %d current tpt %d"
 					     " old tpt %d\n",
 					     window->success_ratio,
@@ -1834,7 +1831,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 			/* Need to set up a new rate table in uCode */
 			update_lq = 1;
-			IWL_DEBUG_HT("XXY GO BACK TO OLD TABLE\n");
+			IWL_DEBUG_RATE("XXY GO BACK TO OLD TABLE\n");
 		}
 
 		/* Either way, we've made a decision; modulation mode
@@ -1942,7 +1939,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		break;
 	}
 
-	IWL_DEBUG_HT("choose rate scale index %d action %d low %d "
+	IWL_DEBUG_RATE("choose rate scale index %d action %d low %d "
 		    "high %d type %d\n",
 		     index, scale_action, low, high, tbl->lq_type);
 
@@ -1987,7 +1984,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			index = iwl4965_hwrate_to_plcp_idx(
 							tbl->current_rate);
 
-			IWL_DEBUG_HT("Switch current  mcs: %X index: %d\n",
+			IWL_DEBUG_RATE("Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate, index);
 			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate,
 					 &lq_sta->lq);
@@ -2006,7 +2003,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 #endif
 		    (lq_sta->action_counter >= 1)) {
 			lq_sta->action_counter = 0;
-			IWL_DEBUG_HT("LQ: STAY in legacy table\n");
+			IWL_DEBUG_RATE("LQ: STAY in legacy table\n");
 			rs_set_stay_in_table(1, lq_sta);
 		}
 
@@ -2019,7 +2016,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != MAX_TID_COUNT)) {
-				IWL_DEBUG_HT("try to aggregate tid %d\n", tid);
+				IWL_DEBUG_RATE("try to aggregate tid %d\n", tid);
 				rs_tl_turn_on_agg(priv, tid, lq_sta, sta);
 			}
 #endif /*CONFIG_IWL4965_HT */
@@ -2103,7 +2100,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 
 	rate = rate_n_flags_from_tbl(tbl, rate_idx, use_green);
 	tbl->current_rate = rate;
-	rs_get_expected_tpt_table(lq_sta, tbl);
+	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, lq_sta, rate, &lq_sta->lq);
 	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
  out:
@@ -2227,7 +2224,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		DECLARE_MAC_BUF(mac);
 
 		/* for IBSS the call are from tasklet */
-		IWL_DEBUG_HT("LQ: ADD station %s\n",
+		IWL_DEBUG_RATE("LQ: ADD station %s\n",
 			     print_mac(mac, sta->addr));
 
 		if (sta_id == IWL_INVALID_STATION) {
@@ -2287,7 +2284,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	lq_sta->active_mimo3_rate &= ~((u16)0x2);
 	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
 
-	IWL_DEBUG_HT("SISO RATE %X MIMO2 RATE %X MIMO3 RATE %X\n",
+	IWL_DEBUG_RATE("SISO RATE %X MIMO2 RATE %X MIMO3 RATE %X\n",
 		     lq_sta->active_siso_rate,
 		     lq_sta->active_mimo2_rate,
 		     lq_sta->active_mimo3_rate);
-- 
1.5.3.4

