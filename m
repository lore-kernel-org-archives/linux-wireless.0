Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbCATbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:31:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/31] iwlwifi: mvm: rs: better match tx response rate to the LQ table
Date: Sun,  1 Mar 2015 21:31:14 +0200
Message-Id: <1425238304-498-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203154_520169_FB8ECF56)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Currently rs uses the info in mac80211 tx status which is
a translation of the actual rate coming up from the FW in
the tx response. This is matched up against the LQ table first
rate to make sure this tx frame used the current LQ table.
Instead of using the translated mac80211 info it's easier and
cleaner to just pass the actual tx response rate in the driver
private data and use that for matching.
This becomes even more important once the FW begins to
decide on its own whether to use STBC/BFER/SISO.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 119 ++++++++++++----------------------
 drivers/net/wireless/iwlwifi/mvm/tx.c |   4 ++
 2 files changed, 47 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 194bd1f..1e82434 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1001,10 +1001,19 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 		rs_get_lower_rate_in_column(lq_sta, rate);
 }
 
-/* Simple function to compare two rate scale table types */
-static inline bool rs_rate_match(struct rs_rate *a,
+/* Check if both rates are identical */
+static inline bool rs_rate_equal(struct rs_rate *a,
 				 struct rs_rate *b)
 {
+	return (a->type == b->type) && (a->bw == b->bw) && (a->sgi == b->sgi) &&
+		(a->ldpc == b->ldpc) && (a->index == b->index) &&
+		(a->ant == b->ant);
+}
+
+/* Check if both rates share the same column */
+static inline bool rs_rate_column_match(struct rs_rate *a,
+					struct rs_rate *b)
+{
 	bool ant_match;
 
 	if (a->stbc)
@@ -1016,18 +1025,6 @@ static inline bool rs_rate_match(struct rs_rate *a,
 		&& ant_match;
 }
 
-static u32 rs_ch_width_from_mac_flags(enum mac80211_rate_control_flags flags)
-{
-	if (flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-		return RATE_MCS_CHAN_WIDTH_40;
-	else if (flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
-		return RATE_MCS_CHAN_WIDTH_80;
-	else if (flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
-		return RATE_MCS_CHAN_WIDTH_160;
-
-	return RATE_MCS_CHAN_WIDTH_20;
-}
-
 static u8 rs_get_tid(struct ieee80211_hdr *hdr)
 {
 	u8 tid = IWL_MAX_TID_COUNT;
@@ -1048,13 +1045,13 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 {
 	int legacy_success;
 	int retries;
-	int mac_index, i;
+	int i;
 	struct iwl_lq_cmd *table;
-	enum mac80211_rate_control_flags mac_flags;
-	u32 ucode_rate;
-	struct rs_rate rate;
+	u32 lq_hwrate;
+	struct rs_rate lq_rate, tx_resp_rate;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
 	u8 reduced_txp = (uintptr_t)info->status.status_driver_data[0];
+	u32 tx_resp_hwrate = (uintptr_t)info->status.status_driver_data[1];
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
 
@@ -1079,39 +1076,6 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	/*
-	 * Ignore this Tx frame response if its initial rate doesn't match
-	 * that of latest Link Quality command.  There may be stragglers
-	 * from a previous Link Quality command, but we're no longer interested
-	 * in those; they're either from the "active" mode while we're trying
-	 * to check "search" mode, or a prior "search" mode after we've moved
-	 * to a new "search" mode (which might become the new "active" mode).
-	 */
-	table = &lq_sta->lq;
-	ucode_rate = le32_to_cpu(table->rs_table[0]);
-	rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
-	if (info->band == IEEE80211_BAND_5GHZ)
-		rate.index -= IWL_FIRST_OFDM_RATE;
-	mac_flags = info->status.rates[0].flags;
-	mac_index = info->status.rates[0].idx;
-	/* For HT packets, map MCS to PLCP */
-	if (mac_flags & IEEE80211_TX_RC_MCS) {
-		/* Remove # of streams */
-		mac_index &= RATE_HT_MCS_RATE_CODE_MSK;
-		if (mac_index >= (IWL_RATE_9M_INDEX - IWL_FIRST_OFDM_RATE))
-			mac_index++;
-		/*
-		 * mac80211 HT index is always zero-indexed; we need to move
-		 * HT OFDM rates after CCK rates in 2.4 GHz band
-		 */
-		if (info->band == IEEE80211_BAND_2GHZ)
-			mac_index += IWL_FIRST_OFDM_RATE;
-	} else if (mac_flags & IEEE80211_TX_RC_VHT_MCS) {
-		mac_index &= RATE_VHT_MCS_RATE_CODE_MSK;
-		if (mac_index >= (IWL_RATE_9M_INDEX - IWL_FIRST_OFDM_RATE))
-			mac_index++;
-	}
-
 	if (time_after(jiffies,
 		       (unsigned long)(lq_sta->last_tx +
 				       (IWL_MVM_RS_IDLE_TIMEOUT * HZ)))) {
@@ -1126,21 +1090,24 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	}
 	lq_sta->last_tx = jiffies;
 
+	/* Ignore this Tx frame response if its initial rate doesn't match
+	 * that of latest Link Quality command.  There may be stragglers
+	 * from a previous Link Quality command, but we're no longer interested
+	 * in those; they're either from the "active" mode while we're trying
+	 * to check "search" mode, or a prior "search" mode after we've moved
+	 * to a new "search" mode (which might become the new "active" mode).
+	 */
+	table = &lq_sta->lq;
+	lq_hwrate = le32_to_cpu(table->rs_table[0]);
+	rs_rate_from_ucode_rate(lq_hwrate, info->band, &lq_rate);
+	rs_rate_from_ucode_rate(tx_resp_hwrate, info->band, &tx_resp_rate);
+
 	/* Here we actually compare this rate to the latest LQ command */
-	if ((mac_index < 0) ||
-	    (rate.sgi != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
-	    (rate.bw != rs_ch_width_from_mac_flags(mac_flags)) ||
-	    (rate.ant != info->status.antenna) ||
-	    (!!(ucode_rate & RATE_MCS_HT_MSK) !=
-	     !!(mac_flags & IEEE80211_TX_RC_MCS)) ||
-	    (!!(ucode_rate & RATE_MCS_VHT_MSK) !=
-	     !!(mac_flags & IEEE80211_TX_RC_VHT_MCS)) ||
-	    (!!(ucode_rate & RATE_HT_MCS_GF_MSK) !=
-	     !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
-	    (rate.index != mac_index)) {
+	if (!rs_rate_equal(&tx_resp_rate, &lq_rate)) {
 		IWL_DEBUG_RATE(mvm,
-			       "initial rate %d does not match %d (0x%x)\n",
-			       mac_index, rate.index, ucode_rate);
+			       "initial tx resp rate 0x%x does not match 0x%x\n",
+			       tx_resp_hwrate, lq_hwrate);
+
 		/*
 		 * Since rates mis-match, the last LQ command may have failed.
 		 * After IWL_MISSED_RATE_MAX mis-matches, resync the uCode with
@@ -1168,14 +1135,14 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		other_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	}
 
-	if (WARN_ON_ONCE(!rs_rate_match(&rate, &curr_tbl->rate))) {
+	if (WARN_ON_ONCE(!rs_rate_column_match(&lq_rate, &curr_tbl->rate))) {
 		IWL_DEBUG_RATE(mvm,
 			       "Neither active nor search matches tx rate\n");
 		tmp_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		rs_dump_rate(mvm, &tmp_tbl->rate, "ACTIVE");
 		tmp_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
 		rs_dump_rate(mvm, &tmp_tbl->rate, "SEARCH");
-		rs_dump_rate(mvm, &rate, "ACTUAL");
+		rs_dump_rate(mvm, &lq_rate, "ACTUAL");
 
 		/*
 		 * no matching table found, let's by-pass the data collection
@@ -1200,9 +1167,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		if (info->status.ampdu_ack_len == 0)
 			info->status.ampdu_len = 1;
 
-		ucode_rate = le32_to_cpu(table->rs_table[0]);
-		rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
-		rs_collect_tx_data(mvm, lq_sta, curr_tbl, rate.index,
+		rs_collect_tx_data(mvm, lq_sta, curr_tbl, lq_rate.index,
 				   info->status.ampdu_len,
 				   info->status.ampdu_ack_len,
 				   reduced_txp);
@@ -1225,21 +1190,23 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		legacy_success = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		/* Collect data for each rate used during failed TX attempts */
 		for (i = 0; i <= retries; ++i) {
-			ucode_rate = le32_to_cpu(table->rs_table[i]);
-			rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
+			lq_hwrate = le32_to_cpu(table->rs_table[i]);
+			rs_rate_from_ucode_rate(lq_hwrate, info->band,
+						&lq_rate);
 			/*
 			 * Only collect stats if retried rate is in the same RS
 			 * table as active/search.
 			 */
-			if (rs_rate_match(&rate, &curr_tbl->rate))
+			if (rs_rate_column_match(&lq_rate, &curr_tbl->rate))
 				tmp_tbl = curr_tbl;
-			else if (rs_rate_match(&rate, &other_tbl->rate))
+			else if (rs_rate_column_match(&lq_rate,
+						      &other_tbl->rate))
 				tmp_tbl = other_tbl;
 			else
 				continue;
 
-			rs_collect_tx_data(mvm, lq_sta, tmp_tbl, rate.index, 1,
-					   i < retries ? 0 : legacy_success,
+			rs_collect_tx_data(mvm, lq_sta, tmp_tbl, lq_rate.index,
+					   1, i < retries ? 0 : legacy_success,
 					   reduced_txp);
 		}
 
@@ -1250,7 +1217,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		}
 	}
 	/* The last TX rate is cached in lq_sta; it's set in if/else above */
-	lq_sta->last_rate_n_flags = ucode_rate;
+	lq_sta->last_rate_n_flags = lq_hwrate;
 	IWL_DEBUG_RATE(mvm, "reduced txpower: %d\n", reduced_txp);
 done:
 	/* See if there's a better rate or modulation mode to try. */
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 07304e1..7906b97 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -664,6 +664,8 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		iwl_mvm_hwrate_to_tx_status(le32_to_cpu(tx_resp->initial_rate),
 					    info);
+		info->status.status_driver_data[1] =
+			(void *)(uintptr_t)le32_to_cpu(tx_resp->initial_rate);
 
 		/* Single frame failure in an AMPDU queue => send BAR */
 		if (txq_id >= mvm->first_agg_queue &&
@@ -909,6 +911,8 @@ static void iwl_mvm_tx_info_from_ba_notif(struct ieee80211_tx_info *info,
 	info->status.tx_time = tid_data->tx_time;
 	info->status.status_driver_data[0] =
 		(void *)(uintptr_t)tid_data->reduced_tpc;
+	info->status.status_driver_data[1] =
+		(void *)(uintptr_t)tid_data->rate_n_flags;
 }
 
 int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-- 
1.9.1

