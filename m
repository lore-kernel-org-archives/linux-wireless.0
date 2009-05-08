Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645AbZEHUiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/11] iwlagn: improve rate scale table search
Date: Fri,  8 May 2009 13:44:39 -0700
Message-Id: <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

iwlagn rate scaling will periodically search other rate scale
tables to switch to the best table regarding performance. In the past
the number of search tables were 3. Every time the rate scale algorithm
goes through these available tables in will stay in current table for
some time before start searching again. Recent driver support more
feature and antenna, so we have more tables to search. This patch make
sure we go through all available tables.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   47 +++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    2 +
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 0a71bb5..3fa06af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -100,6 +100,7 @@ struct iwl_scale_tbl_info {
 	u8 is_fat;	/* 1 = 40 MHz channel width */
 	u8 is_dup;	/* 1 = duplicated data streams */
 	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
+	u8 max_search;	/* maximun number of tables we can search */
 	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
 	u32 current_rate;  /* rate_n_flags, uCode API format */
 	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
@@ -579,6 +580,7 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	tbl->is_dup = 0;
 	tbl->ant_type = (ant_msk >> RATE_MCS_ANT_POS);
 	tbl->lq_type = LQ_NONE;
+	tbl->max_search = IWL_MAX_SEARCH;
 
 	/* legacy rate format */
 	if (!(rate_n_flags & RATE_MCS_HT_MSK)) {
@@ -612,8 +614,10 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 				tbl->lq_type = LQ_MIMO2;
 		/* MIMO3 */
 		} else {
-			if (num_of_ant == 3)
+			if (num_of_ant == 3) {
+				tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
 				tbl->lq_type = LQ_MIMO3;
+			}
 		}
 	}
 	return 0;
@@ -771,6 +775,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 
 		tbl->is_fat = 0;
 		tbl->is_SGI = 0;
+		tbl->max_search = IWL_MAX_SEARCH;
 	}
 
 	rate_mask = rs_get_supported_rates(lq_sta, NULL, tbl->lq_type);
@@ -1026,6 +1031,7 @@ static void rs_set_stay_in_table(struct iwl_priv *priv, u8 is_legacy,
 	lq_sta->total_failed = 0;
 	lq_sta->total_success = 0;
 	lq_sta->flush_timer = jiffies;
+	lq_sta->action_counter = 0;
 }
 
 /*
@@ -1205,6 +1211,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	tbl->lq_type = LQ_MIMO2;
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->action = 0;
+	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_mimo2_rate;
 
 	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
@@ -1270,6 +1277,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	tbl->lq_type = LQ_MIMO3;
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->action = 0;
+	tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
 	rate_mask = lq_sta->active_mimo3_rate;
 
 	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
@@ -1328,6 +1336,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->lq_type = LQ_SISO;
 	tbl->action = 0;
+	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_siso_rate;
 
 	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
@@ -1384,15 +1393,15 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret = 0;
+	u8 update_search_tbl_counter = 0;
 
 	for (; ;) {
+		lq_sta->action_counter++;
 		switch (tbl->action) {
 		case IWL_LEGACY_SWITCH_ANTENNA1:
 		case IWL_LEGACY_SWITCH_ANTENNA2:
 			IWL_DEBUG_RATE(priv, "LQ: Legacy toggle Antenna\n");
 
-			lq_sta->action_counter++;
-
 			if ((tbl->action == IWL_LEGACY_SWITCH_ANTENNA1 &&
 							tx_chains_num <= 1) ||
 			    (tbl->action == IWL_LEGACY_SWITCH_ANTENNA2 &&
@@ -1408,6 +1417,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 			if (rs_toggle_antenna(valid_tx_ant,
 				&search_tbl->current_rate, search_tbl)) {
+				update_search_tbl_counter = 1;
 				rs_set_expected_tpt_table(lq_sta, search_tbl);
 				goto out;
 			}
@@ -1489,6 +1499,8 @@ out:
 	tbl->action++;
 	if (tbl->action > IWL_LEGACY_SWITCH_MIMO3_ABC)
 		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
+	if (update_search_tbl_counter)
+		search_tbl->action = tbl->action;
 	return 0;
 
 }
@@ -1511,6 +1523,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u8 start_action = tbl->action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	u8 update_search_tbl_counter = 0;
 	int ret;
 
 	for (;;) {
@@ -1531,8 +1544,10 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 
 			memcpy(search_tbl, tbl, sz);
 			if (rs_toggle_antenna(valid_tx_ant,
-				       &search_tbl->current_rate, search_tbl))
+				       &search_tbl->current_rate, search_tbl)) {
+				update_search_tbl_counter = 1;
 				goto out;
+			}
 			break;
 		case IWL_SISO_SWITCH_MIMO2_AB:
 		case IWL_SISO_SWITCH_MIMO2_AC:
@@ -1586,6 +1601,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			search_tbl->current_rate =
 				rate_n_flags_from_tbl(priv, search_tbl,
 						      index, is_green);
+			update_search_tbl_counter = 1;
 			goto out;
 		case IWL_SISO_SWITCH_MIMO3_ABC:
 			IWL_DEBUG_RATE(priv, "LQ: SISO switch to MIMO3\n");
@@ -1617,6 +1633,9 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	tbl->action++;
 	if (tbl->action > IWL_SISO_SWITCH_MIMO3_ABC)
 		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+	if (update_search_tbl_counter)
+		search_tbl->action = tbl->action;
+
 	return 0;
 }
 
@@ -1638,6 +1657,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u8 start_action = tbl->action;
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+	u8 update_search_tbl_counter = 0;
 	int ret;
 
 	for (;;) {
@@ -1655,8 +1675,10 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 
 			memcpy(search_tbl, tbl, sz);
 			if (rs_toggle_antenna(valid_tx_ant,
-				       &search_tbl->current_rate, search_tbl))
+				       &search_tbl->current_rate, search_tbl)) {
+				update_search_tbl_counter = 1;
 				goto out;
+			}
 			break;
 		case IWL_MIMO2_SWITCH_SISO_A:
 		case IWL_MIMO2_SWITCH_SISO_B:
@@ -1713,6 +1735,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 			search_tbl->current_rate =
 				rate_n_flags_from_tbl(priv, search_tbl,
 						      index, is_green);
+			update_search_tbl_counter = 1;
 			goto out;
 
 		case IWL_MIMO2_SWITCH_MIMO3_ABC:
@@ -1745,6 +1768,9 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	tbl->action++;
 	if (tbl->action > IWL_MIMO2_SWITCH_MIMO3_ABC)
 		tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
+	if (update_search_tbl_counter)
+		search_tbl->action = tbl->action;
+
 	return 0;
 
 }
@@ -1768,6 +1794,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret;
+	u8 update_search_tbl_counter = 0;
 
 	for (;;) {
 		lq_sta->action_counter++;
@@ -1866,6 +1893,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 			search_tbl->current_rate =
 				rate_n_flags_from_tbl(priv, search_tbl,
 						      index, is_green);
+			update_search_tbl_counter = 1;
 			goto out;
 		}
 		tbl->action++;
@@ -1882,6 +1910,9 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	tbl->action++;
 	if (tbl->action > IWL_MIMO3_SWITCH_GI)
 		tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
+	if (update_search_tbl_counter)
+		search_tbl->action = tbl->action;
+
 	return 0;
 
 }
@@ -2326,8 +2357,7 @@ lq_update:
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf) &&
-		    lq_sta->action_counter >= 1) {
-			lq_sta->action_counter = 0;
+		    lq_sta->action_counter > tbl1->max_search) {
 			IWL_DEBUG_RATE(priv, "LQ: STAY in legacy table\n");
 			rs_set_stay_in_table(priv, 1, lq_sta);
 		}
@@ -2336,7 +2366,7 @@ lq_update:
 		 * have been tried and compared, stay in this best modulation
 		 * mode for a while before next round of mode comparisons. */
 		if (lq_sta->enable_counter &&
-		    (lq_sta->action_counter >= IWL_ACTION_LIMIT)) {
+		    (lq_sta->action_counter >= tbl1->max_search)) {
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != MAX_TID_COUNT)) {
@@ -2350,7 +2380,6 @@ lq_update:
 							  lq_sta, sta);
 				}
 			}
-			lq_sta->action_counter = 0;
 			rs_set_stay_in_table(priv, 0, lq_sta);
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index f875136..25050bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -275,6 +275,8 @@ enum {
 #define IWL_MIMO3_SWITCH_GI             8
 
 
+#define IWL_MAX_11N_MIMO3_SEARCH IWL_MIMO3_SWITCH_GI
+#define IWL_MAX_SEARCH IWL_MIMO2_SWITCH_MIMO3_ABC
 
 /*FIXME:RS:add possible actions for MIMO3*/
 
-- 
1.5.6.3

