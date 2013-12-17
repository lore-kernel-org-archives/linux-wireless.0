Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56275 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3LQUpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:22 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so3124074eek.36
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/36] iwlwifi: mvm: rs: refactor building the LQ command
Date: Tue, 17 Dec 2013 22:44:29 +0200
Message-Id: <1387313079-28123-26-git-send-email-egrumbach@gmail.com> (sfid-20131217_214617_937473_6221950A)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Simplify the code a bit more by extracting the rates table
building logic into a separate function and handle setting
a fixed rate for debug in a separate flow.
Also avoid using and saving ucode rate format in different
places. Instead use rs_rate struct and convert to ucode format
only when filling the rates table in the LQ command.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |  185 +++++++++++++++------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |    1 -
 2 files changed, 82 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 83306a0..eee3381 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -351,20 +351,12 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 				   struct sk_buff *skb,
 				   struct ieee80211_sta *sta,
 				   struct iwl_lq_sta *lq_sta);
-static void rs_fill_link_cmd(struct iwl_mvm *mvm,
-			     struct ieee80211_sta *sta,
-			     struct iwl_lq_sta *lq_sta, u32 rate_n_flags);
+static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
+			   struct ieee80211_sta *sta,
+			   struct iwl_lq_sta *lq_sta,
+			   const struct rs_rate *initial_rate);
 static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
-			     u32 *rate_n_flags);
-#else
-static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
-			     u32 *rate_n_flags)
-{}
-#endif
-
 /**
  * The following tables contain the expected throughput metrics for all rates
  *
@@ -634,7 +626,7 @@ static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 
 /* Convert rs_rate object into ucode rate bitmask */
 static u32 ucode_rate_from_rs_rate(struct iwl_mvm *mvm,
-				   struct rs_rate *rate)
+				  struct rs_rate *rate)
 {
 	u32 ucode_rate = 0;
 	int index = rate->index;
@@ -761,8 +753,7 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 
 /* switch to another antenna/antennas and return 1 */
 /* if no other valid antenna found, return 0 */
-static int rs_toggle_antenna(u32 valid_ant, u32 *ucode_rate,
-			     struct rs_rate *rate)
+static int rs_toggle_antenna(u32 valid_ant, struct rs_rate *rate)
 {
 	u8 new_ant_type;
 
@@ -783,9 +774,6 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *ucode_rate,
 
 	rate->ant = new_ant_type;
 
-	/* TODO: get rid of ucode_rate here. This should handle only rs_rate */
-	*ucode_rate &= ~RATE_MCS_ANT_ABC_MSK;
-	*ucode_rate |= new_ant_type << RATE_MCS_ANT_POS;
 	return 1;
 }
 
@@ -859,9 +847,9 @@ static u16 rs_get_adjacent_rate(struct iwl_mvm *mvm, u8 index, u16 rate_mask,
 	return (high << 8) | low;
 }
 
-static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
-			     struct rs_rate *rate,
-			     u8 scale_index, u8 ht_possible)
+static void rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
+			      struct rs_rate *rate,
+			      u8 scale_index, u8 ht_possible)
 {
 	s32 low;
 	u16 rate_mask;
@@ -917,7 +905,6 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 
 out:
 	rate->index = low;
-	return ucode_rate_from_rs_rate(lq_sta->drv, rate);
 }
 
 /* Simple function to compare two rate scale table types */
@@ -1447,10 +1434,7 @@ static void rs_update_rate_tbl(struct iwl_mvm *mvm,
 			       struct iwl_lq_sta *lq_sta,
 			       struct rs_rate *rate)
 {
-	u32 ucode_rate;
-
-	ucode_rate = ucode_rate_from_rs_rate(mvm, rate);
-	rs_fill_link_cmd(mvm, sta, lq_sta, ucode_rate);
+	rs_fill_lq_cmd(mvm, sta, lq_sta, rate);
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 }
 
@@ -1610,10 +1594,6 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 		rate->index = rate_idx;
 	}
 
-	/* TODO: remove current_rate and keep using rs_rate all the way until
-	 * we need to fill in the rs_table in the LQ command
-	 */
-	search_tbl->current_rate = ucode_rate_from_rs_rate(mvm, rate);
 	IWL_DEBUG_RATE(mvm, "Switched to column %d: Index %d\n",
 		       col_id, rate->index);
 
@@ -1730,9 +1710,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			rate->type = LQ_NONE;
 			lq_sta->search_better_tbl = 0;
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-			/* get "active" rate info */
-			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
-			tbl->rate.index = index;
 			rs_update_rate_tbl(mvm, sta, lq_sta, &tbl->rate);
 		}
 		return;
@@ -1823,7 +1800,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			tbl = &(lq_sta->lq_info[active_tbl]);
 
 			/* Revert to "active" rate and throughput info */
-			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
+			index = tbl->rate.index;
 			current_tpt = lq_sta->last_tpt;
 
 			/* Need to set up a new rate table in uCode */
@@ -2029,11 +2006,11 @@ lq_update:
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 
 			/* Use new "search" start rate */
-			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
+			index = tbl->rate.index;
 
 			rs_dump_rate(mvm, &tbl->rate,
 				     "Switch to SEARCH TABLE:");
-			rs_fill_link_cmd(mvm, sta, lq_sta, tbl->current_rate);
+			rs_fill_lq_cmd(mvm, sta, lq_sta, &tbl->rate);
 			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 		} else {
 			done_search = 1;
@@ -2071,8 +2048,6 @@ lq_update:
 	}
 
 out:
-	tbl->rate.index = index;
-	tbl->current_rate = ucode_rate_from_rs_rate(mvm, &tbl->rate);
 	lq_sta->last_txrate_idx = index;
 }
 
@@ -2099,7 +2074,6 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	struct iwl_scale_tbl_info *tbl;
 	struct rs_rate *rate;
 	int i;
-	u32 ucode_rate;
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
 
@@ -2130,9 +2104,6 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	else
 		rate->type = LQ_LEGACY_G;
 
-	ucode_rate = ucode_rate_from_rs_rate(mvm, rate);
-	tbl->current_rate = ucode_rate;
-
 	WARN_ON_ONCE(rate->ant != ANT_A && rate->ant != ANT_B);
 	if (rate->ant == ANT_A)
 		tbl->column = RS_COLUMN_LEGACY_ANT_A;
@@ -2140,7 +2111,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 		tbl->column = RS_COLUMN_LEGACY_ANT_B;
 
 	rs_set_expected_tpt_table(lq_sta, tbl);
-	rs_fill_link_cmd(NULL, NULL, lq_sta, ucode_rate);
+	rs_fill_lq_cmd(NULL, NULL, lq_sta, rate);
 	/* TODO restore station should remember the lq cmd */
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, init);
 }
@@ -2371,9 +2342,32 @@ static void rs_rate_update(void *mvm_r,
 	iwl_mvm_rs_rate_init(mvm, sta, sband->band, false);
 }
 
-static void rs_fill_link_cmd(struct iwl_mvm *mvm,
-			     struct ieee80211_sta *sta,
-			     struct iwl_lq_sta *lq_sta, u32 new_rate)
+#ifdef CONFIG_MAC80211_DEBUGFS
+static void rs_build_rates_table_from_fixed(struct iwl_mvm *mvm,
+					    struct iwl_lq_cmd *lq_cmd,
+					    enum ieee80211_band band,
+					    u32 ucode_rate)
+{
+	struct rs_rate rate;
+	int i;
+	int num_rates = ARRAY_SIZE(lq_cmd->rs_table);
+	__le32 ucode_rate_le32 = cpu_to_le32(ucode_rate);
+
+	for (i = 0; i < num_rates; i++)
+		lq_cmd->rs_table[i] = ucode_rate_le32;
+
+	rs_rate_from_ucode_rate(ucode_rate, band, &rate);
+
+	if (is_mimo(&rate))
+		lq_cmd->mimo_delim = num_rates - 1;
+	else
+		lq_cmd->mimo_delim = 0;
+}
+#endif /* CONFIG_MAC80211_DEBUGFS */
+
+static void rs_build_rates_table(struct iwl_mvm *mvm,
+				 struct iwl_lq_sta *lq_sta,
+				 const struct rs_rate *initial_rate)
 {
 	struct rs_rate rate;
 	int index = 0;
@@ -2383,10 +2377,13 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 	u8 valid_tx_ant = 0;
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
 
-	/* Override starting rate (index 0) if needed for debug purposes */
-	rs_dbgfs_set_mcs(lq_sta, &new_rate);
+	memcpy(&rate, initial_rate, sizeof(struct rs_rate));
+
+	lq_cmd->mimo_delim = is_mimo(&rate) ? 1 : 0;
 
-	rs_rate_from_ucode_rate(new_rate, lq_sta->band, &rate);
+	/* Fill 1st table entry (index 0) */
+	lq_cmd->rs_table[index] = cpu_to_le32(
+		ucode_rate_from_rs_rate(mvm, &rate));
 
 	/* How many times should we repeat the initial rate? */
 	if (is_legacy(&rate)) {
@@ -2397,15 +2394,6 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 				  LINK_QUAL_AGG_DISABLE_START_DEF - 1);
 	}
 
-	lq_cmd->mimo_delim = is_mimo(&rate) ? 1 : 0;
-
-	/* Fill 1st table entry (index 0) */
-	lq_cmd->rs_table[index] = cpu_to_le32(new_rate);
-
-	if (num_of_ant(rate.ant) == 1)
-		lq_cmd->single_stream_ant_msk = rate.ant;
-	/* otherwise we don't modify the existing value */
-
 	index++;
 	repeat_rate--;
 	if (mvm)
@@ -2421,23 +2409,17 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
 				else if (mvm &&
-					 rs_toggle_antenna(valid_tx_ant,
-							&new_rate, &rate))
+					 rs_toggle_antenna(valid_tx_ant, &rate))
 					ant_toggle_cnt = 1;
 			}
 
-			/* Override next rate if needed for debug purposes */
-			rs_dbgfs_set_mcs(lq_sta, &new_rate);
-
 			/* Fill next table entry */
-			lq_cmd->rs_table[index] =
-					cpu_to_le32(new_rate);
+			lq_cmd->rs_table[index] = cpu_to_le32(
+				ucode_rate_from_rs_rate(mvm, &rate));
 			repeat_rate--;
 			index++;
 		}
 
-		rs_rate_from_ucode_rate(new_rate, lq_sta->band, &rate);
-
 		/* Indicate to uCode which entries might be MIMO.
 		 * If initial rate was MIMO, this will finally end up
 		 * as (IWL_HT_NUMBER_TRY * 2), after 2nd pass, otherwise 0. */
@@ -2445,16 +2427,14 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 			lq_cmd->mimo_delim = index;
 
 		/* Get next rate */
-		new_rate = rs_get_lower_rate(lq_sta, &rate, rate.index,
-					     use_ht_possible);
+		rs_get_lower_rate(lq_sta, &rate, rate.index, use_ht_possible);
 
 		/* How many times should we repeat the next rate? */
 		if (is_legacy(&rate)) {
 			if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 				ant_toggle_cnt++;
 			else if (mvm &&
-				 rs_toggle_antenna(valid_tx_ant,
-						   &new_rate, &rate))
+				 rs_toggle_antenna(valid_tx_ant, &rate))
 				ant_toggle_cnt = 1;
 
 			repeat_rate = IWL_NUMBER_TRY;
@@ -2468,15 +2448,36 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 		 */
 		use_ht_possible = 0;
 
-		/* Override next rate if needed for debug purposes */
-		rs_dbgfs_set_mcs(lq_sta, &new_rate);
-
 		/* Fill next table entry */
-		lq_cmd->rs_table[index] = cpu_to_le32(new_rate);
+		lq_cmd->rs_table[index] = cpu_to_le32(
+			ucode_rate_from_rs_rate(mvm, &rate));
 
 		index++;
 		repeat_rate--;
 	}
+}
+
+static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
+			   struct ieee80211_sta *sta,
+			   struct iwl_lq_sta *lq_sta,
+			   const struct rs_rate *initial_rate)
+{
+	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
+	u8 ant = initial_rate->ant;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (lq_sta->dbg_fixed_rate) {
+		rs_build_rates_table_from_fixed(mvm, lq_cmd,
+						lq_sta->band,
+						lq_sta->dbg_fixed_rate);
+		ant = (lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK) >>
+			RATE_MCS_ANT_POS;
+	} else
+#endif
+		rs_build_rates_table(mvm, lq_sta, initial_rate);
+
+	if (num_of_ant(ant) == 1)
+		lq_cmd->single_stream_ant_msk = ant;
 
 	lq_cmd->agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_disable_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
@@ -2510,31 +2511,6 @@ static void rs_free_sta(void *mvm_r, struct ieee80211_sta *sta,
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
-			     u32 *rate_n_flags)
-{
-	struct iwl_mvm *mvm;
-	u8 valid_tx_ant;
-	u8 ant_sel_tx;
-
-	mvm = lq_sta->drv;
-	valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
-	if (lq_sta->dbg_fixed_rate) {
-		ant_sel_tx =
-		  ((lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK)
-		  >> RATE_MCS_ANT_POS);
-		if ((valid_tx_ant & ant_sel_tx) == ant_sel_tx) {
-			*rate_n_flags = lq_sta->dbg_fixed_rate;
-		} else {
-			lq_sta->dbg_fixed_rate = 0;
-			IWL_ERR(mvm,
-				"Invalid antenna selection 0x%X, Valid is 0x%X\n",
-				ant_sel_tx, valid_tx_ant);
-			IWL_DEBUG_RATE(mvm, "Fixed rate OFF\n");
-		}
-	}
-}
-
 static int rs_pretty_print_rate(char *buf, const u32 rate)
 {
 
@@ -2605,7 +2581,10 @@ static void rs_program_fix_rate(struct iwl_mvm *mvm,
 		       lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
 
 	if (lq_sta->dbg_fixed_rate) {
-		rs_fill_link_cmd(NULL, NULL, lq_sta, lq_sta->dbg_fixed_rate);
+		struct rs_rate rate;
+		rs_rate_from_ucode_rate(lq_sta->dbg_fixed_rate,
+					lq_sta->band, &rate);
+		rs_fill_lq_cmd(NULL, NULL, lq_sta, &rate);
 		iwl_mvm_send_lq_cmd(lq_sta->drv, &lq_sta->lq, false);
 	}
 }
@@ -2739,14 +2718,14 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 		rate = &tbl->rate;
 		desc += sprintf(buff+desc,
 				"%s type=%d SGI=%d BW=%s DUP=0\n"
-				"rate=0x%X\n",
+				"index=%d\n",
 				lq_sta->active_tbl == i ? "*" : "x",
 				rate->type,
 				rate->sgi,
 				is_ht20(rate) ? "20Mhz" :
 				is_ht40(rate) ? "40Mhz" :
 				is_ht80(rate) ? "80Mhz" : "ERR",
-				tbl->current_rate);
+				rate->index);
 		for (j = 0; j < IWL_RATE_COUNT; j++) {
 			desc += sprintf(buff+desc,
 				"counter=%d success=%d %%=%d\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index b329607..7b26e65 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -278,7 +278,6 @@ struct iwl_scale_tbl_info {
 	struct rs_rate rate;
 	enum rs_column column;
 	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
-	u32 current_rate;  /* rate_n_flags, uCode API format */
 	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
 
-- 
1.7.9.5

