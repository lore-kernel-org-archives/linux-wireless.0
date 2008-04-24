Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbYDXAPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 11/16] iwlwifi: more RS improvements
Date: Wed, 23 Apr 2008 17:15:03 -0700
Message-Id: <1208996108-15326-12-git-send-email-reinette.chatre@intel.com> (sfid-20080424_023545_550160_65F5E30C)
In-Reply-To: <1208996108-15326-11-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-10-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

Main changes:
1. no need to re-calculate expected_tpt when only toggling antenna
2. changing the code to be more strict on input and status of variables
3. enhanced debug prints
4. move to search table only if improving tpt
       (don't move if SR is improved but tpt is not)

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |  121 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 5129d57..c8c54b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -178,8 +178,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct sta_info *sta);
 static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
-			     u32 rate_n_flags,
-			     struct iwl_link_quality_cmd *tbl);
+			     u32 rate_n_flags);
 
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -1320,7 +1319,6 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			lq_sta->action_counter++;
 
 			/* Don't change antenna if success has been great */
-			/*FIXME:RS:not sure this is really needed*/
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
 
@@ -1329,7 +1327,6 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 			if (rs_toggle_antenna(valid_tx_ant,
 				&search_tbl->current_rate, search_tbl)) {
-				rs_set_expected_tpt_table(lq_sta, search_tbl);
 				lq_sta->search_better_tbl = 1;
 				goto out;
 			}
@@ -1410,7 +1407,6 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		switch (tbl->action) {
 		case IWL_SISO_SWITCH_ANTENNA:
 			IWL_DEBUG_RATE("LQ: SISO toggle Antenna\n");
-			/*FIXME:RS: is this really needed for SISO?*/
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
 
@@ -1738,27 +1734,16 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (!rate_scale_index_msk)
 		rate_scale_index_msk = rate_mask;
 
-	/* If current rate is no longer supported on current association,
-	 * or user changed preferences for rates, find a new supported rate. */
-	if (index < 0 || !((1 << index) & rate_scale_index_msk)) {
-		index = IWL_INVALID_VALUE;
-		update_lq = 1;
-
-		/* get the highest available rate */
-		for (i = 0; i <= IWL_RATE_COUNT; i++) {
-			if ((1 << i) & rate_scale_index_msk)
-				index = i;
-		}
-
-		if (index == IWL_INVALID_VALUE) {
-			IWL_WARNING("Can not find a suitable rate\n");
-			return;
-		}
+	if (!((1 << index) & rate_scale_index_msk)) {
+		IWL_ERROR("Current Rate is not valid\n");
+		return;
 	}
 
 	/* Get expected throughput table and history window for current rate */
-	if (!tbl->expected_tpt)
-		rs_set_expected_tpt_table(lq_sta, tbl);
+	if (!tbl->expected_tpt) {
+		IWL_ERROR("tbl->expected_tpt is NULL\n");
+		return;
+	}
 
 	window = &(tbl->win[index]);
 
@@ -1770,10 +1755,9 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	 * in current association (use new rate found above).
 	 */
 	fail_count = window->counter - window->success_counter;
-	if (((fail_count < IWL_RATE_MIN_FAILURE_TH) &&
-	     (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))
-	    || (tbl->expected_tpt == NULL)) {
-		IWL_DEBUG_RATE("LQ: still below TH succ %d total %d "
+	if ((fail_count < IWL_RATE_MIN_FAILURE_TH) &&
+			(window->success_counter < IWL_RATE_MIN_SUCCESS_TH)) {
+		IWL_DEBUG_RATE("LQ: still below TH. succ=%d total=%d "
 			       "for index %d\n",
 			       window->success_counter, window->counter, index);
 
@@ -1784,44 +1768,51 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		 * or search for a new one? */
 		rs_stay_in_table(lq_sta);
 
-		/* Set up new rate table in uCode, if needed */
-		if (update_lq) {
-			rate = rate_n_flags_from_tbl(tbl, index, is_green);
-			rs_fill_link_cmd(priv, lq_sta, rate, &lq_sta->lq);
-			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
-		}
 		goto out;
 
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
-	} else
-		window->average_tpt = ((window->success_ratio *
+	} else {
+		/*FIXME:RS remove this else if we don't get this error*/
+		if (window->average_tpt != ((window->success_ratio *
+				tbl->expected_tpt[index] + 64) / 128)) {
+			IWL_ERROR("expected_tpt should have been calculated"
+								" by now\n");
+			window->average_tpt = ((window->success_ratio *
 					tbl->expected_tpt[index] + 64) / 128);
+		}
+	}
 
 	/* If we are searching for better modulation mode, check success. */
 	if (lq_sta->search_better_tbl) {
-		int success_limit = IWL_RATE_SCALE_SWITCH;
 
 		/* If good success, continue using the "search" mode;
 		 * no need to send new link quality command, since we're
 		 * continuing to use the setup that we've been trying. */
-		if ((window->success_ratio > success_limit) ||
-		    (window->average_tpt > lq_sta->last_tpt)) {
-			if (!is_legacy(tbl->lq_type)) {
-				IWL_DEBUG_RATE("LQ: we are switching to HT"
-					     " rate suc %d current tpt %d"
-					     " old tpt %d\n",
-					     window->success_ratio,
-					     window->average_tpt,
-					     lq_sta->last_tpt);
+		if (window->average_tpt > lq_sta->last_tpt) {
+
+			IWL_DEBUG_RATE("LQ: SWITCHING TO CURRENT TABLE "
+					"suc=%d cur-tpt=%d old-tpt=%d\n",
+					window->success_ratio,
+					window->average_tpt,
+					lq_sta->last_tpt);
+
+			if (!is_legacy(tbl->lq_type))
 				lq_sta->enable_counter = 1;
-			}
+
 			/* Swap tables; "search" becomes "active" */
 			lq_sta->active_tbl = active_tbl;
 			current_tpt = window->average_tpt;
 
 		/* Else poor success; go back to mode in "active" table */
 		} else {
+
+			IWL_DEBUG_RATE("LQ: GOING BACK TO THE OLD TABLE "
+					"suc=%d cur-tpt=%d old-tpt=%d\n",
+					window->success_ratio,
+					window->average_tpt,
+					lq_sta->last_tpt);
+
 			/* Nullify "search" table */
 			tbl->lq_type = LQ_NONE;
 
@@ -1836,7 +1827,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 			/* Need to set up a new rate table in uCode */
 			update_lq = 1;
-			IWL_DEBUG_RATE("XXY GO BACK TO OLD TABLE\n");
 		}
 
 		/* Either way, we've made a decision; modulation mode
@@ -1952,7 +1942,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
 		rate = rate_n_flags_from_tbl(tbl, index, is_green);
-		rs_fill_link_cmd(priv, lq_sta, rate, &lq_sta->lq);
+		rs_fill_link_cmd(priv, lq_sta, rate);
 		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 	}
 
@@ -1991,8 +1981,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 			IWL_DEBUG_RATE("Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate, index);
-			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate,
-					 &lq_sta->lq);
+			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
 
@@ -2109,7 +2098,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	rate = rate_n_flags_from_tbl(tbl, rate_idx, use_green);
 	tbl->current_rate = rate;
 	rs_set_expected_tpt_table(lq_sta, tbl);
-	rs_fill_link_cmd(NULL, lq_sta, rate, &lq_sta->lq);
+	rs_fill_link_cmd(NULL, lq_sta, rate);
 	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
  out:
 	return;
@@ -2220,7 +2209,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&(lq_sta->lq_info[j].win[i]));
 
-	IWL_DEBUG_RATE("rate scale global init\n");
+	IWL_DEBUG_RATE("LQ: *** rate scale global init ***\n");
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
@@ -2292,11 +2281,15 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	lq_sta->active_mimo3_rate &= ~((u16)0x2);
 	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
 
-	IWL_DEBUG_RATE("SISO RATE %X MIMO2 RATE %X MIMO3 RATE %X\n",
+	IWL_DEBUG_RATE("SISO-RATE=%X MIMO2-RATE=%X MIMO3-RATE=%X\n",
 		     lq_sta->active_siso_rate,
 		     lq_sta->active_mimo2_rate,
 		     lq_sta->active_mimo3_rate);
 
+	/* These values will be overriden later */
+	lq_sta->lq.general_params.single_stream_ant_msk = ANT_A;
+	lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
+
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
 #endif /*CONFIG_IWL4965_HT*/
@@ -2312,8 +2305,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
-			     u32 new_rate,
-			     struct iwl_link_quality_cmd *lq_cmd)
+			     u32 new_rate)
 {
 	struct iwl4965_scale_tbl_info tbl_type;
 	int index = 0;
@@ -2322,6 +2314,7 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 	u8 ant_toggle_cnt = 0;
 	u8 use_ht_possible = 1;
 	u8 valid_tx_ant = 0;
+	struct iwl_link_quality_cmd *lq_cmd = &lq_sta->lq;
 
 	/* Override starting rate (index 0) if needed for debug purposes */
 	rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
@@ -2345,13 +2338,13 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 	/* Fill 1st table entry (index 0) */
 	lq_cmd->rs_table[index].rate_n_flags = cpu_to_le32(new_rate);
 
-	/*FIXME:RS*/
-	if (is_mimo(tbl_type.lq_type) || (tbl_type.ant_type == ANT_A))
-		lq_cmd->general_params.single_stream_ant_msk
-			= LINK_QUAL_ANT_A_MSK;
-	else
-		lq_cmd->general_params.single_stream_ant_msk
-			= LINK_QUAL_ANT_B_MSK;
+	if (num_of_ant(tbl_type.ant_type) == 1) {
+		lq_cmd->general_params.single_stream_ant_msk =
+						tbl_type.ant_type;
+	} else if (num_of_ant(tbl_type.ant_type) == 2) {
+		lq_cmd->general_params.dual_stream_ant_msk =
+						tbl_type.ant_type;
+	} /* otherwise we don't modify the existing value */
 
 	index++;
 	repeat_rate--;
@@ -2425,7 +2418,6 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 		repeat_rate--;
 	}
 
-	lq_cmd->general_params.dual_stream_ant_msk = 3;
 	lq_cmd->agg_params.agg_dis_start_th = 3;
 	lq_cmd->agg_params.agg_time_limit = cpu_to_le16(4000);
 }
@@ -2512,8 +2504,7 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 		lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
 
 	if (lq_sta->dbg_fixed_rate) {
-		rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate,
-								&lq_sta->lq);
+		rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate);
 		iwl_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8403e9b..9b137d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2047,7 +2047,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 		goto drop;
 	}
 
-	IWL_DEBUG_RATE("station Id %d\n", sta_id);
+	IWL_DEBUG_TX("station Id %d\n", sta_id);
 
 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc) {
-- 
1.5.3.4

