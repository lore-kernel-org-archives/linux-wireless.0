Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYDXAPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/16] iwlwifi: rate scale restructure toggle_antenna functions
Date: Wed, 23 Apr 2008 17:14:59 -0700
Message-Id: <1208996108-15326-8-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021607_403910_ABDB2133)
In-Reply-To: <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

This patch add support for toggeling of A/B/C and AB/BC/AC
antennas

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |  172 +++++++++++++++-------------
 1 files changed, 91 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 4063534..1ad6256 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -43,7 +43,7 @@
 
 #define RS_NAME "iwl-4965-rs"
 
-#define NUM_TRY_BEFORE_ANTENNA_TOGGLE 1
+#define NUM_TRY_BEFORE_ANT_TOGGLE 1
 #define IWL_NUMBER_TRY      1
 #define IWL_HT_NUMBER_TRY   3
 
@@ -64,6 +64,17 @@ static u8 rs_ht_to_legacy[] = {
 	IWL_RATE_48M_INDEX, IWL_RATE_54M_INDEX
 };
 
+static const u8 ant_toggle_lookup[] = {
+	/*ANT_NONE -> */ ANT_NONE,
+	/*ANT_A    -> */ ANT_B,
+	/*ANT_B    -> */ ANT_C,
+	/*ANT_AB   -> */ ANT_BC,
+	/*ANT_C    -> */ ANT_A,
+	/*ANT_AC   -> */ ANT_AB,
+	/*ANT_BC   -> */ ANT_AC,
+	/*ANT_ABC  -> */ ANT_ABC,
+};
+
 /**
  * struct iwl4965_rate_scale_data -- tx success history for one rate
  */
@@ -131,8 +142,6 @@ struct iwl4965_lq_sta {
 	u32 flush_timer;	/* time staying in mode before new search */
 
 	u8 action_counter;	/* # mode-switch actions tried */
-	u8 antenna;
-	u8 valid_antenna;
 	u8 is_green;
 	u8 is_dup;
 	enum ieee80211_band band;
@@ -243,6 +252,11 @@ static void rs_rate_scale_clear_window(struct iwl4965_rate_scale_data *window)
 	window->stamp = 0;
 }
 
+static inline u8 rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
+{
+	return ((ant_type & valid_antenna) == ant_type);
+}
+
 #ifdef CONFIG_IWL4965_HT
 /*
  *	removes the old data from the statistics. All data that is older than
@@ -576,12 +590,33 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	}
 	return 0;
 }
-/* FIXME:RS: need to toggle also ANT_C, and also AB,AC,BC */
-static inline void rs_toggle_antenna(u32 *rate_n_flags,
-				     struct iwl4965_scale_tbl_info *tbl)
+
+/* switch to another antenna/antennas and return 1 */
+/* if no other valid antenna found, return 0 */
+static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
+			      struct iwl4965_scale_tbl_info *tbl)
 {
-	tbl->ant_type ^= ANT_AB;
-	*rate_n_flags ^= (RATE_MCS_ANT_A_MSK|RATE_MCS_ANT_B_MSK);
+	u8 new_ant_type;
+
+	if (!tbl->ant_type || tbl->ant_type > ANT_ABC)
+		return 0;
+
+	if (!rs_is_valid_ant(valid_ant, tbl->ant_type))
+		return 0;
+
+	new_ant_type = ant_toggle_lookup[tbl->ant_type];
+
+	while ((new_ant_type != tbl->ant_type) &&
+	       !rs_is_valid_ant(valid_ant, new_ant_type))
+		new_ant_type = ant_toggle_lookup[new_ant_type];
+
+	if (new_ant_type == tbl->ant_type)
+		return 0;
+
+	tbl->ant_type = new_ant_type;
+	*rate_n_flags &= ~RATE_MCS_ANT_ABC_MSK;
+	*rate_n_flags |= new_ant_type << RATE_MCS_ANT_POS;
+	return 1;
 }
 
 /* FIXME:RS: in 4965 we don't use greenfield at all */
@@ -796,8 +831,6 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	table = &lq_sta->lq;
 	active_index = lq_sta->active_tbl;
 
-	lq_sta->antenna = lq_sta->valid_antenna;
-
 	curr_tbl = &(lq_sta->lq_info[active_index]);
 	search_tbl = &(lq_sta->lq_info[(1 - active_index)]);
 	window = (struct iwl4965_rate_scale_data *)
@@ -946,22 +979,6 @@ out:
 	return;
 }
 
-static inline u8 rs_is_ant_connected(u8 valid_antenna, u8 ant_type)
-{
-	return ((ant_type & valid_antenna) == ant_type);
-}
-
-/*FIXME:RS: this function should be replaced*/
-static u8 rs_is_other_ant_connected(u8 valid_antenna, u8 ant_type)
-{
-	if (ant_type == ANT_B)
-		return rs_is_ant_connected(valid_antenna, ANT_A);
-	else
-		return rs_is_ant_connected(valid_antenna, ANT_B);
-
-	return 0;
-}
-
 /*
  * Begin a period of staying with a selected modulation mode.
  * Set "stay_in_tbl" flag to prevent any mode switches.
@@ -1128,12 +1145,6 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 }
 #endif				/* CONFIG_IWL4965_HT */
 
-/*FIXME:RS:this function should be replaced*/
-static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
-{
-	return (rs_is_ant_connected(valid_antenna, ANT_AB));
-}
-
 /*
  * Set up search table for MIMO
  */
@@ -1156,7 +1167,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
-	if (!rs_is_both_ant_supp(priv->hw_params.valid_tx_ant))
+	if (priv->hw_params.tx_chains_num < 2)
 		return -1;
 
 	IWL_DEBUG_RATE("LQ: try to switch to MIMO2\n");
@@ -1302,7 +1313,6 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		case IWL_LEGACY_SWITCH_ANTENNA:
 			IWL_DEBUG_RATE("LQ Legacy toggle Antenna\n");
 
-			search_tbl->lq_type = LQ_NONE;
 			lq_sta->action_counter++;
 
 			/* Don't change antenna if success has been great */
@@ -1310,19 +1320,15 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
 
-			/* Don't change antenna if other one is not connected */
-			if (!rs_is_other_ant_connected(valid_tx_ant,
-							tbl->ant_type))
-				break;
-
 			/* Set up search table to try other antenna */
 			memcpy(search_tbl, tbl, sz);
 
-			rs_toggle_antenna(&search_tbl->current_rate,
-					   search_tbl);
-			rs_set_expected_tpt_table(lq_sta, search_tbl);
-			lq_sta->search_better_tbl = 1;
-			goto out;
+			if (rs_toggle_antenna(valid_tx_ant,
+				&search_tbl->current_rate, search_tbl)) {
+				rs_set_expected_tpt_table(lq_sta, search_tbl);
+				lq_sta->search_better_tbl = 1;
+				goto out;
+			}
 
 		case IWL_LEGACY_SWITCH_SISO:
 			IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
@@ -1403,16 +1409,13 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			/*FIXME:RS: is this really needed for SISO?*/
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
-			if (!rs_is_other_ant_connected(valid_tx_ant,
-						       tbl->ant_type))
-				break;
 
 			memcpy(search_tbl, tbl, sz);
-			rs_toggle_antenna(&search_tbl->current_rate,
-					   search_tbl);
-			lq_sta->search_better_tbl = 1;
-
-			goto out;
+			if (rs_toggle_antenna(valid_tx_ant,
+				       &search_tbl->current_rate, search_tbl)) {
+				lq_sta->search_better_tbl = 1;
+				goto out;
+			}
 
 		case IWL_SISO_SWITCH_MIMO2:
 			IWL_DEBUG_RATE("LQ: SISO switch to MIMO\n");
@@ -1473,7 +1476,6 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 				 struct sta_info *sta,
 				 int index)
 {
-	int ret;
 	s8 is_green = lq_sta->is_green;
 	struct iwl4965_scale_tbl_info *tbl =
 	    &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -1482,6 +1484,8 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl4965_scale_tbl_info) -
 		  (sizeof(struct iwl4965_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
+	/*u8 valid_tx_ant = priv->hw_params.valid_tx_ant;*/
+	int ret;
 
 	for (;;) {
 		lq_sta->action_counter++;
@@ -2057,13 +2061,14 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 			     struct ieee80211_conf *conf,
 			     struct sta_info *sta)
 {
-	int i;
 	struct iwl4965_lq_sta *lq_sta;
 	struct iwl4965_scale_tbl_info *tbl;
-	u8 active_tbl = 0;
 	int rate_idx;
-	u8 use_green = rs_use_green(priv, conf);
+	int i;
 	u32 rate;
+	u8 use_green = rs_use_green(priv, conf);
+	u8 active_tbl = 0;
+	u8 valid_tx_ant;
 
 	if (!sta || !sta->rate_ctrl_priv)
 		goto out;
@@ -2075,6 +2080,8 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
 		goto out;
 
+	valid_tx_ant = priv->hw_params.valid_tx_ant;
+
 	if (!lq_sta->search_better_tbl)
 		active_tbl = lq_sta->active_tbl;
 	else
@@ -2095,8 +2102,8 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 
 	tbl->ant_type = ANT_B;
 	rs_get_tbl_info_from_mcs(rate, priv->band, tbl, &rate_idx);
-	if (!rs_is_ant_connected(priv->hw_params.valid_tx_ant, tbl->ant_type))
-	    rs_toggle_antenna(&rate, tbl);
+	if (!rs_is_valid_ant(valid_tx_ant, tbl->ant_type))
+	    rs_toggle_antenna(valid_tx_ant, &rate, tbl);
 
 	rate = rate_n_flags_from_tbl(tbl, rate_idx, use_green);
 	tbl->current_rate = rate;
@@ -2307,26 +2314,29 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			     u32 new_rate,
 			     struct iwl_link_quality_cmd *lq_cmd)
 {
+	struct iwl4965_scale_tbl_info tbl_type;
 	int index = 0;
 	int rate_idx;
 	int repeat_rate = 0;
-	u8 ant_toggle_count = 0;
+	u8 ant_toggle_cnt = 0;
 	u8 use_ht_possible = 1;
-	struct iwl4965_scale_tbl_info tbl_type = { 0 };
+	u8 valid_tx_ant = 0;
 
 	/* Override starting rate (index 0) if needed for debug purposes */
 	rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
 
 	/* Interpret new_rate (rate_n_flags) */
+	memset(&tbl_type, 0, sizeof(tbl_type));
 	rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
 				  &tbl_type, &rate_idx);
 
 	/* How many times should we repeat the initial rate? */
 	if (is_legacy(tbl_type.lq_type)) {
-		ant_toggle_count = 1;
+		ant_toggle_cnt = 1;
 		repeat_rate = IWL_NUMBER_TRY;
-	} else
+	} else {
 		repeat_rate = IWL_HT_NUMBER_TRY;
+	}
 
 	lq_cmd->general_params.mimo_delimiter =
 			is_mimo(tbl_type.lq_type) ? 1 : 0;
@@ -2345,6 +2355,9 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 	index++;
 	repeat_rate--;
 
+	if (priv)
+		valid_tx_ant = priv->hw_params.valid_tx_ant;
+
 	/* Fill rest of rate table */
 	while (index < LINK_QUAL_MAX_RETRY_NUM) {
 		/* Repeat initial/next rate.
@@ -2352,16 +2365,13 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 		 * For HT IWL_HT_NUMBER_TRY == 3, this executes twice. */
 		while (repeat_rate > 0 && (index < LINK_QUAL_MAX_RETRY_NUM)) {
 			if (is_legacy(tbl_type.lq_type)) {
-				if (ant_toggle_count <
-				    NUM_TRY_BEFORE_ANTENNA_TOGGLE)
-					ant_toggle_count++;
-				else if (priv && rs_is_other_ant_connected(
-						priv->hw_params.valid_tx_ant,
-						tbl_type.ant_type)) {
-					rs_toggle_antenna(&new_rate, &tbl_type);
-					ant_toggle_count = 1;
-				}
-			}
+				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
+					ant_toggle_cnt++;
+				else if (priv &&
+					 rs_toggle_antenna(valid_tx_ant,
+							&new_rate, &tbl_type))
+					ant_toggle_cnt = 1;
+}
 
 			/* Override next rate if needed for debug purposes */
 			rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
@@ -2388,17 +2398,17 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 
 		/* How many times should we repeat the next rate? */
 		if (is_legacy(tbl_type.lq_type)) {
-			if (ant_toggle_count < NUM_TRY_BEFORE_ANTENNA_TOGGLE)
-				ant_toggle_count++;
-			else if (priv && rs_is_other_ant_connected(
-						priv->hw_params.valid_tx_ant,
-						tbl_type.ant_type)) {
-				rs_toggle_antenna(&new_rate, &tbl_type);
-				ant_toggle_count = 1;
-			}
+			if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
+				ant_toggle_cnt++;
+			else if (priv &&
+				 rs_toggle_antenna(valid_tx_ant,
+						   &new_rate, &tbl_type))
+				ant_toggle_cnt = 1;
+
 			repeat_rate = IWL_NUMBER_TRY;
-		} else
+		} else {
 			repeat_rate = IWL_HT_NUMBER_TRY;
+		}
 
 		/* Don't allow HT rates after next pass.
 		 * rs_get_lower_rate() will change type to LQ_A or LQ_G. */
-- 
1.5.3.4

