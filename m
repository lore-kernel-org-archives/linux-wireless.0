Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:52322 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaGFJgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:50 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so3149727wes.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:49 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/40] iwlwifi: mvm: rs: don't clear persistent fields
Date: Sun,  6 Jul 2014 12:35:54 +0300
Message-Id: <1404639376-3792-18-git-send-email-egrumbach@gmail.com> (sfid-20140706_115955_934360_471829BC)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

iwl_mvm_rs_rate_init() is called multiple times to re-init
the rate scaling statistics (e.g. after some idle time).

It clears all the lq_sta sta, including some fields that
shouldn't be cleared (e.g. debugfs pointers). Fix it
by adding a new 'persistent' sub-struct, and
avoid clearing it on (re-)init.

Move the initialization of the persistent fields to
rs_alloc_sta instead.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 87 ++++++++++++++++++-----------------
 drivers/net/wireless/iwlwifi/mvm/rs.h | 24 ++++++----
 2 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 306a6ca..67bd8d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -927,7 +927,7 @@ static bool rs_get_lower_rate_in_column(struct iwl_lq_sta *lq_sta,
 	u8 low;
 	u16 high_low;
 	u16 rate_mask;
-	struct iwl_mvm *mvm = lq_sta->drv;
+	struct iwl_mvm *mvm = lq_sta->pers.drv;
 
 	rate_mask = rs_get_supported_rates(lq_sta, rate);
 	high_low = rs_get_adjacent_rate(mvm, rate->index, rate_mask,
@@ -946,7 +946,7 @@ static bool rs_get_lower_rate_in_column(struct iwl_lq_sta *lq_sta,
 static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 					  struct rs_rate *rate)
 {
-	struct iwl_mvm *mvm = lq_sta->drv;
+	struct iwl_mvm *mvm = lq_sta->pers.drv;
 
 	if (is_legacy(rate)) {
 		/* No column to downgrade from Legacy */
@@ -1026,14 +1026,14 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	if (!lq_sta) {
 		IWL_DEBUG_RATE(mvm, "Station rate scaling not created yet.\n");
 		return;
-	} else if (!lq_sta->drv) {
+	} else if (!lq_sta->pers.drv) {
 		IWL_DEBUG_RATE(mvm, "Rate scaling not initialized yet.\n");
 		return;
 	}
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* Disable last tx check if we are debugging with fixed rate */
-	if (lq_sta->dbg_fixed_rate) {
+	if (lq_sta->pers.dbg_fixed_rate) {
 		IWL_DEBUG_RATE(mvm, "Fixed rate. avoid rate scaling\n");
 		return;
 	}
@@ -1405,7 +1405,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 	int flush_interval_passed = 0;
 	struct iwl_mvm *mvm;
 
-	mvm = lq_sta->drv;
+	mvm = lq_sta->pers.drv;
 	active_tbl = lq_sta->active_tbl;
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
@@ -1865,11 +1865,11 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 	int weak_tpt = IWL_INVALID_VALUE, strong_tpt = IWL_INVALID_VALUE;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	if (lq_sta->dbg_fixed_txp_reduction <= TPC_MAX_REDUCTION) {
+	if (lq_sta->pers.dbg_fixed_txp_reduction <= TPC_MAX_REDUCTION) {
 		IWL_DEBUG_RATE(mvm, "fixed tpc: %d\n",
-			       lq_sta->dbg_fixed_txp_reduction);
-		lq_sta->lq.reduced_tpc = lq_sta->dbg_fixed_txp_reduction;
-		return cur != lq_sta->dbg_fixed_txp_reduction;
+			       lq_sta->pers.dbg_fixed_txp_reduction);
+		lq_sta->lq.reduced_tpc = lq_sta->pers.dbg_fixed_txp_reduction;
+		return cur != lq_sta->pers.dbg_fixed_txp_reduction;
 	}
 #endif
 
@@ -2382,7 +2382,7 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 	}
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
-	if (lq_sta && !lq_sta->drv) {
+	if (lq_sta && !lq_sta->pers.drv) {
 		IWL_DEBUG_RATE(mvm, "Rate scaling not initialized yet.\n");
 		mvm_sta = NULL;
 	}
@@ -2401,12 +2401,18 @@ static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
 			  gfp_t gfp)
 {
 	struct iwl_mvm_sta *sta_priv = (struct iwl_mvm_sta *)sta->drv_priv;
-	struct iwl_op_mode *op_mode __maybe_unused =
-			(struct iwl_op_mode *)mvm_rate;
-	struct iwl_mvm *mvm __maybe_unused = IWL_OP_MODE_GET_MVM(op_mode);
+	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)mvm_rate;
+	struct iwl_mvm *mvm  = IWL_OP_MODE_GET_MVM(op_mode);
+	struct iwl_lq_sta *lq_sta = &sta_priv->lq_sta;
 
 	IWL_DEBUG_RATE(mvm, "create station rate scale window\n");
 
+	lq_sta->pers.drv = mvm;
+#ifdef CONFIG_MAC80211_DEBUGFS
+	lq_sta->pers.dbg_fixed_rate = 0;
+	lq_sta->pers.dbg_fixed_txp_reduction = TPC_INVALID;
+#endif
+
 	return &sta_priv->lq_sta;
 }
 
@@ -2552,7 +2558,9 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	sta_priv = (struct iwl_mvm_sta *)sta->drv_priv;
 	lq_sta = &sta_priv->lq_sta;
-	memset(lq_sta, 0, sizeof(*lq_sta));
+
+	/* clear all non-persistent lq data */
+	memset(lq_sta, 0, offsetof(typeof(*lq_sta), pers));
 
 	sband = hw->wiphy->bands[band];
 
@@ -2630,17 +2638,12 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
-	lq_sta->drv = mvm;
 
 	/* Set last_txrate_idx to lowest rate */
 	lq_sta->last_txrate_idx = rate_lowest_index(sband, sta);
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
-#ifdef CONFIG_MAC80211_DEBUGFS
-	lq_sta->dbg_fixed_rate = 0;
-	lq_sta->dbg_fixed_txp_reduction = TPC_INVALID;
-#endif
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_mvm_reset_frame_stats(mvm, &mvm->drv_rx_stats);
 #endif
@@ -2811,12 +2814,12 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	u8 ant = initial_rate->ant;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	if (lq_sta->dbg_fixed_rate) {
+	if (lq_sta->pers.dbg_fixed_rate) {
 		rs_build_rates_table_from_fixed(mvm, lq_cmd,
 						lq_sta->band,
-						lq_sta->dbg_fixed_rate);
+						lq_sta->pers.dbg_fixed_rate);
 		lq_cmd->reduced_tpc = 0;
-		ant = (lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK) >>
+		ant = (lq_sta->pers.dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK) >>
 			RATE_MCS_ANT_POS;
 	} else
 #endif
@@ -2926,14 +2929,14 @@ static void rs_program_fix_rate(struct iwl_mvm *mvm,
 	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
 	IWL_DEBUG_RATE(mvm, "sta_id %d rate 0x%X\n",
-		       lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
+		       lq_sta->lq.sta_id, lq_sta->pers.dbg_fixed_rate);
 
-	if (lq_sta->dbg_fixed_rate) {
+	if (lq_sta->pers.dbg_fixed_rate) {
 		struct rs_rate rate;
-		rs_rate_from_ucode_rate(lq_sta->dbg_fixed_rate,
+		rs_rate_from_ucode_rate(lq_sta->pers.dbg_fixed_rate,
 					lq_sta->band, &rate);
 		rs_fill_lq_cmd(mvm, NULL, lq_sta, &rate);
-		iwl_mvm_send_lq_cmd(lq_sta->drv, &lq_sta->lq, false);
+		iwl_mvm_send_lq_cmd(lq_sta->pers.drv, &lq_sta->lq, false);
 	}
 }
 
@@ -2946,16 +2949,16 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	size_t buf_size;
 	u32 parsed_rate;
 
-	mvm = lq_sta->drv;
+	mvm = lq_sta->pers.drv;
 	memset(buf, 0, sizeof(buf));
 	buf_size = min(count, sizeof(buf) -  1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
 	if (sscanf(buf, "%x", &parsed_rate) == 1)
-		lq_sta->dbg_fixed_rate = parsed_rate;
+		lq_sta->pers.dbg_fixed_rate = parsed_rate;
 	else
-		lq_sta->dbg_fixed_rate = 0;
+		lq_sta->pers.dbg_fixed_rate = 0;
 
 	rs_program_fix_rate(mvm, lq_sta);
 
@@ -2974,7 +2977,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	struct iwl_mvm *mvm;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct rs_rate *rate = &tbl->rate;
-	mvm = lq_sta->drv;
+	mvm = lq_sta->pers.drv;
 	buff = kmalloc(2048, GFP_KERNEL);
 	if (!buff)
 		return -ENOMEM;
@@ -2984,7 +2987,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->total_failed, lq_sta->total_success,
 			lq_sta->active_legacy_rate);
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
-			lq_sta->dbg_fixed_rate);
+			lq_sta->pers.dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
 	    (mvm->fw->valid_tx_ant & ANT_A) ? "ANT_A," : "",
 	    (mvm->fw->valid_tx_ant & ANT_B) ? "ANT_B," : "",
@@ -3182,31 +3185,31 @@ static const struct file_operations rs_sta_dbgfs_drv_tx_stats_ops = {
 static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 {
 	struct iwl_lq_sta *lq_sta = mvm_sta;
-	lq_sta->rs_sta_dbgfs_scale_table_file =
+	lq_sta->pers.rs_sta_dbgfs_scale_table_file =
 		debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
 				    lq_sta, &rs_sta_dbgfs_scale_table_ops);
-	lq_sta->rs_sta_dbgfs_stats_table_file =
+	lq_sta->pers.rs_sta_dbgfs_stats_table_file =
 		debugfs_create_file("rate_stats_table", S_IRUSR, dir,
 				    lq_sta, &rs_sta_dbgfs_stats_table_ops);
-	lq_sta->rs_sta_dbgfs_drv_tx_stats_file =
+	lq_sta->pers.rs_sta_dbgfs_drv_tx_stats_file =
 		debugfs_create_file("drv_tx_stats", S_IRUSR | S_IWUSR, dir,
 				    lq_sta, &rs_sta_dbgfs_drv_tx_stats_ops);
-	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
+	lq_sta->pers.rs_sta_dbgfs_tx_agg_tid_en_file =
 		debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
 				  &lq_sta->tx_agg_tid_en);
-	lq_sta->rs_sta_dbgfs_reduced_txp_file =
+	lq_sta->pers.rs_sta_dbgfs_reduced_txp_file =
 		debugfs_create_u8("reduced_tpc", S_IRUSR | S_IWUSR, dir,
-				  &lq_sta->dbg_fixed_txp_reduction);
+				  &lq_sta->pers.dbg_fixed_txp_reduction);
 }
 
 static void rs_remove_debugfs(void *mvm, void *mvm_sta)
 {
 	struct iwl_lq_sta *lq_sta = mvm_sta;
-	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_drv_tx_stats_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_reduced_txp_file);
+	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_scale_table_file);
+	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_stats_table_file);
+	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_drv_tx_stats_file);
+	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_tx_agg_tid_en_file);
+	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_reduced_txp_file);
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 374a83d..2e1a683 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -349,16 +349,6 @@ struct iwl_lq_sta {
 	struct iwl_lq_cmd lq;
 	struct iwl_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
 	u8 tx_agg_tid_en;
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *rs_sta_dbgfs_scale_table_file;
-	struct dentry *rs_sta_dbgfs_stats_table_file;
-	struct dentry *rs_sta_dbgfs_drv_tx_stats_file;
-	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
-	struct dentry *rs_sta_dbgfs_reduced_txp_file;
-	u32 dbg_fixed_rate;
-	u8 dbg_fixed_txp_reduction;
-#endif
-	struct iwl_mvm *drv;
 
 	/* used to be in sta_info */
 	int last_txrate_idx;
@@ -369,6 +359,20 @@ struct iwl_lq_sta {
 
 	/* tx power reduce for this sta */
 	int tpc_reduce;
+
+	/* persistent fields - initialized only once - keep last! */
+	struct {
+#ifdef CONFIG_MAC80211_DEBUGFS
+		struct dentry *rs_sta_dbgfs_scale_table_file;
+		struct dentry *rs_sta_dbgfs_stats_table_file;
+		struct dentry *rs_sta_dbgfs_drv_tx_stats_file;
+		struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
+		struct dentry *rs_sta_dbgfs_reduced_txp_file;
+		u32 dbg_fixed_rate;
+		u8 dbg_fixed_txp_reduction;
+#endif
+		struct iwl_mvm *drv;
+	} pers;
 };
 
 /* Initialize station's rate scaling information after adding station */
-- 
1.8.3.2

