Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51312 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaDMNCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:55 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so2922249wiv.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 06:02:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/13] iwlwifi: mvm: rs: use correct max expected throughput figures
Date: Sun, 13 Apr 2014 16:01:57 +0300
Message-Id: <1397394123-25102-7-git-send-email-egrumbach@gmail.com> (sfid-20140413_150301_487465_78AD506C)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The selection of the max expected throughput for a column
didn't take into account the maximal allowed rate for the current
peer. This can cause unnecessary switches during the search cycle
to columns which have no chance of beating the current throughput.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 55 ++++++++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/rs.h | 12 ++++++--
 2 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index dd13629..cd32ad5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1186,9 +1186,26 @@ static void rs_set_stay_in_table(struct iwl_mvm *mvm, u8 is_legacy,
 	lq_sta->visited_columns = 0;
 }
 
+static int rs_get_max_allowed_rate(struct iwl_lq_sta *lq_sta,
+				   const struct rs_tx_column *column)
+{
+	switch (column->mode) {
+	case RS_LEGACY:
+		return lq_sta->max_legacy_rate_idx;
+	case RS_SISO:
+		return lq_sta->max_siso_rate_idx;
+	case RS_MIMO2:
+		return lq_sta->max_mimo2_rate_idx;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	return lq_sta->max_legacy_rate_idx;
+}
+
 static const u16 *rs_get_expected_tpt_table(struct iwl_lq_sta *lq_sta,
-				      const struct rs_tx_column *column,
-				      u32 bw)
+					    const struct rs_tx_column *column,
+					    u32 bw)
 {
 	/* Used to choose among HT tables */
 	const u16 (*ht_tbl_pointer)[IWL_RATE_COUNT];
@@ -1485,14 +1502,14 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 					 struct ieee80211_sta *sta,
 					 struct iwl_scale_tbl_info *tbl)
 {
-	int i, j, n;
+	int i, j, max_rate;
 	enum rs_column next_col_id;
 	const struct rs_tx_column *curr_col = &rs_tx_columns[tbl->column];
 	const struct rs_tx_column *next_col;
 	allow_column_func_t allow_func;
 	u8 valid_ants = mvm->fw->valid_tx_ant;
 	const u16 *expected_tpt_tbl;
-	s32 tpt, max_expected_tpt;
+	u16 tpt, max_expected_tpt;
 
 	for (i = 0; i < MAX_NEXT_COLUMNS; i++) {
 		next_col_id = curr_col->next_columns[i];
@@ -1535,11 +1552,11 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 		if (WARN_ON_ONCE(!expected_tpt_tbl))
 			continue;
 
-		max_expected_tpt = 0;
-		for (n = 0; n < IWL_RATE_COUNT; n++)
-			if (expected_tpt_tbl[n] > max_expected_tpt)
-				max_expected_tpt = expected_tpt_tbl[n];
+		max_rate = rs_get_max_allowed_rate(lq_sta, next_col);
+		if (WARN_ON_ONCE(max_rate == IWL_RATE_INVALID))
+			continue;
 
+		max_expected_tpt = expected_tpt_tbl[max_rate];
 		if (tpt >= max_expected_tpt) {
 			IWL_DEBUG_RATE(mvm,
 				       "Skip column %d: can't beat current TPT. Max expected %d current %d\n",
@@ -1547,14 +1564,15 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 			continue;
 		}
 
+		IWL_DEBUG_RATE(mvm,
+			       "Found potential column %d. Max expected %d current %d\n",
+			       next_col_id, max_expected_tpt, tpt);
 		break;
 	}
 
 	if (i == MAX_NEXT_COLUMNS)
 		return RS_COLUMN_INVALID;
 
-	IWL_DEBUG_RATE(mvm, "Found potential column %d\n", next_col_id);
-
 	return next_col_id;
 }
 
@@ -2388,11 +2406,22 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		lq_sta->is_vht = true;
 	}
 
-	IWL_DEBUG_RATE(mvm,
-		       "SISO-RATE=%X MIMO2-RATE=%X VHT=%d\n",
+	lq_sta->max_legacy_rate_idx = find_last_bit(&lq_sta->active_legacy_rate,
+						    BITS_PER_LONG);
+	lq_sta->max_siso_rate_idx = find_last_bit(&lq_sta->active_siso_rate,
+						  BITS_PER_LONG);
+	lq_sta->max_mimo2_rate_idx = find_last_bit(&lq_sta->active_mimo2_rate,
+						   BITS_PER_LONG);
+
+	IWL_DEBUG_RATE(mvm, "RATE MASK: LEGACY=%lX SISO=%lX MIMO2=%lX VHT=%d\n",
+		       lq_sta->active_legacy_rate,
 		       lq_sta->active_siso_rate,
 		       lq_sta->active_mimo2_rate,
 		       lq_sta->is_vht);
+	IWL_DEBUG_RATE(mvm, "MAX RATE: LEGACY=%d SISO=%d MIMO2=%d\n",
+		       lq_sta->max_legacy_rate_idx,
+		       lq_sta->max_siso_rate_idx,
+		       lq_sta->max_mimo2_rate_idx);
 
 	/* These values will be overridden later */
 	lq_sta->lq.single_stream_ant_msk =
@@ -2750,7 +2779,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 		return -ENOMEM;
 
 	desc += sprintf(buff+desc, "sta_id %d\n", lq_sta->lq.sta_id);
-	desc += sprintf(buff+desc, "failed=%d success=%d rate=0%X\n",
+	desc += sprintf(buff+desc, "failed=%d success=%d rate=0%lX\n",
 			lq_sta->total_failed, lq_sta->total_success,
 			lq_sta->active_legacy_rate);
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 3332b39..9892d92 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -314,9 +314,15 @@ struct iwl_lq_sta {
 	enum ieee80211_band band;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
-	u16 active_legacy_rate;
-	u16 active_siso_rate;
-	u16 active_mimo2_rate;
+	unsigned long active_legacy_rate;
+	unsigned long active_siso_rate;
+	unsigned long active_mimo2_rate;
+
+	/* Highest rate per Tx mode */
+	u8 max_legacy_rate_idx;
+	u8 max_siso_rate_idx;
+	u8 max_mimo2_rate_idx;
+
 	s8 max_rate_idx;     /* Max rate set by user */
 	u8 missed_rate_counter;
 
-- 
1.8.3.2

