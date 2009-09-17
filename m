Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbZIQRnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/13] iwlwifi: clean up rs_tx_status
Date: Thu, 17 Sep 2009 10:43:48 -0700
Message-Id: <1253209436-2309-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Cut down on redundant code, reorganize structure, and add/improve comments.
Should contain no functional changes.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  230 ++++++++++++++---------------
 1 files changed, 108 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 469d563..cd24763 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -821,27 +821,45 @@ out:
 }
 
 /*
+ * Simple function to compare two rate scale table types
+ */
+static bool table_type_matches(struct iwl_scale_tbl_info *a,
+			       struct iwl_scale_tbl_info *b)
+{
+	return (a->lq_type == b->lq_type) && (a->ant_type == b->ant_type) &&
+		(a->is_SGI == b->is_SGI);
+}
+/*
+ * Static function to get the expected throughput from an iwl_scale_tbl_info
+ * that wraps a NULL pointer check
+ */
+static s32 get_expected_tpt(struct iwl_scale_tbl_info *tbl, int rs_index)
+{
+	if (tbl->expected_tpt)
+		return tbl->expected_tpt[rs_index];
+	return 0;
+}
+
+/*
  * mac80211 sends us Tx status
  */
 static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 			 struct ieee80211_sta *sta, void *priv_sta,
 			 struct sk_buff *skb)
 {
-	int status;
-	u8 retries;
-	int rs_index, mac_index, index = 0;
+	int legacy_success;
+	int retries;
+	int rs_index, mac_index, i;
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_link_quality_cmd *table;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_rate_scale_data *window = NULL;
-	struct iwl_rate_scale_data *search_win = NULL;
 	enum mac80211_rate_control_flags mac_flags;
 	u32 tx_rate;
 	struct iwl_scale_tbl_info tbl_type;
-	struct iwl_scale_tbl_info *curr_tbl, *search_tbl;
-	u8 active_index = 0;
+	struct iwl_scale_tbl_info *curr_tbl, *other_tbl;
 	s32 tpt = 0;
 
 	IWL_DEBUG_RATE_LIMIT(priv, "get frame ack response, update rate scale window\n");
@@ -855,25 +873,10 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	if (info->flags & IEEE80211_TX_STAT_AMPDU)
-		retries = 0;
-	else
-		retries = info->status.rates[0].count - 1;
-
-	if (retries > 15)
-		retries = 15;
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added)
-		goto out;
-
-	table = &lq_sta->lq;
-	active_index = lq_sta->active_tbl;
-
-	curr_tbl = &(lq_sta->lq_info[active_index]);
-	search_tbl = &(lq_sta->lq_info[(1 - active_index)]);
-	window = (struct iwl_rate_scale_data *)&(curr_tbl->win[0]);
-	search_win = (struct iwl_rate_scale_data *)&(search_tbl->win[0]);
+		return;
 
 	/*
 	 * Ignore this Tx frame response if its initial rate doesn't match
@@ -883,6 +886,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	 * to check "search" mode, or a prior "search" mode after we've moved
 	 * to a new "search" mode (which might become the new "active" mode).
 	 */
+	table = &lq_sta->lq;
 	tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
 	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
 	if (priv->band == IEEE80211_BAND_5GHZ)
@@ -901,7 +905,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		if (priv->band == IEEE80211_BAND_2GHZ)
 			mac_index += IWL_FIRST_OFDM_RATE;
 	}
-
+	/* Here we actually compare this rate to the latest LQ command */
 	if ((mac_index < 0) ||
 	    (tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
 	    (tbl_type.is_ht40 != !!(mac_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) ||
@@ -911,124 +915,106 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    (!!(tx_rate & RATE_MCS_GF_MSK) != !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
 	    (rs_index != mac_index)) {
 		IWL_DEBUG_RATE(priv, "initial rate %d does not match %d (0x%x)\n", mac_index, rs_index, tx_rate);
-		/* the last LQ command could failed so the LQ in ucode not
-		 * the same in driver sync up
+		/*
+		 * Since rates mis-match, the last LQ command may have failed.
+		 * After IWL_MISSED_RATE_MAX mis-matches, resync the uCode with
+		 * ... driver.
 		 */
 		lq_sta->missed_rate_counter++;
 		if (lq_sta->missed_rate_counter > IWL_MISSED_RATE_MAX) {
 			lq_sta->missed_rate_counter = 0;
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
-		goto out;
+		/* Regardless, ignore this status info for outdated rate */
+		return;
+	} else
+		/* Rate did match, so reset the missed_rate_counter */
+		lq_sta->missed_rate_counter = 0;
+
+	/* Figure out if rate scale algorithm is in active or search table */
+	if (table_type_matches(&tbl_type,
+				&(lq_sta->lq_info[lq_sta->active_tbl]))) {
+		curr_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
+		other_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
+	} else if (table_type_matches(&tbl_type,
+				&lq_sta->lq_info[1 - lq_sta->active_tbl])) {
+		curr_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
+		other_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
+	} else {
+		IWL_DEBUG_RATE(priv, "Neither active nor search matches tx rate\n");
+		return;
 	}
+	window = (struct iwl_rate_scale_data *)&(curr_tbl->win[0]);
 
-	lq_sta->missed_rate_counter = 0;
-	/* Update frame history window with "failure" for each Tx retry. */
-	while (retries) {
-		/* Look up the rate and other info used for each tx attempt.
-		 * Each tx attempt steps one entry deeper in the rate table. */
-		tx_rate = le32_to_cpu(table->rs_table[index].rate_n_flags);
-		rs_get_tbl_info_from_mcs(tx_rate, priv->band,
-					  &tbl_type, &rs_index);
-
-		/* If type matches "search" table,
-		 * add failure to "search" history */
-		if ((tbl_type.lq_type == search_tbl->lq_type) &&
-		    (tbl_type.ant_type == search_tbl->ant_type) &&
-		    (tbl_type.is_SGI == search_tbl->is_SGI)) {
-			if (search_tbl->expected_tpt)
-				tpt = search_tbl->expected_tpt[rs_index];
-			else
-				tpt = 0;
-			rs_collect_tx_data(search_win, rs_index, tpt, 1, 0);
-
-		/* Else if type matches "current/active" table,
-		 * add failure to "current/active" history */
-		} else if ((tbl_type.lq_type == curr_tbl->lq_type) &&
-			   (tbl_type.ant_type == curr_tbl->ant_type) &&
-			   (tbl_type.is_SGI == curr_tbl->is_SGI)) {
-			if (curr_tbl->expected_tpt)
-				tpt = curr_tbl->expected_tpt[rs_index];
-			else
-				tpt = 0;
-			rs_collect_tx_data(window, rs_index, tpt, 1, 0);
+	/*
+	 * Updating the frame history depends on whether packets were
+	 * aggregated.
+	 *
+	 * For aggregation, all packets were transmitted at the same rate, the
+	 * first index into rate scale table.
+	 */
+	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
+		tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
+		rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type,
+				&rs_index);
+		tpt = get_expected_tpt(curr_tbl, rs_index);
+		rs_collect_tx_data(window, rs_index, tpt,
+				   info->status.ampdu_ack_len,
+				   info->status.ampdu_ack_map);
+
+		/* Update success/fail counts if not searching for new mode */
+		if (lq_sta->stay_in_tbl) {
+			lq_sta->total_success += info->status.ampdu_ack_map;
+			lq_sta->total_failed += (info->status.ampdu_ack_len -
+					info->status.ampdu_ack_map);
 		}
-
-		/* If not searching for a new mode, increment failed counter
-		 * ... this helps determine when to start searching again */
-		if (lq_sta->stay_in_tbl)
-			lq_sta->total_failed++;
-		--retries;
-		index++;
-
-	}
-
+	} else {
 	/*
-	 * Find (by rate) the history window to update with final Tx attempt;
-	 * if Tx was successful first try, use original rate,
-	 * else look up the rate that was, finally, successful.
+	 * For legacy, update frame history with for each Tx retry.
 	 */
-	tx_rate = le32_to_cpu(table->rs_table[index].rate_n_flags);
-	lq_sta->last_rate_n_flags = tx_rate;
-	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
-
-	/* Update frame history window with "success" if Tx got ACKed ... */
-	status = !!(info->flags & IEEE80211_TX_STAT_ACK);
-
-	/* If type matches "search" table,
-	 * add final tx status to "search" history */
-	if ((tbl_type.lq_type == search_tbl->lq_type) &&
-	    (tbl_type.ant_type == search_tbl->ant_type) &&
-	    (tbl_type.is_SGI == search_tbl->is_SGI)) {
-		if (search_tbl->expected_tpt)
-			tpt = search_tbl->expected_tpt[rs_index];
-		else
-			tpt = 0;
-		if (info->flags & IEEE80211_TX_STAT_AMPDU)
-			rs_collect_tx_data(search_win, rs_index, tpt,
-					   info->status.ampdu_ack_len,
-					   info->status.ampdu_ack_map);
-		else
-			rs_collect_tx_data(search_win, rs_index, tpt,
-					   1, status);
-	/* Else if type matches "current/active" table,
-	 * add final tx status to "current/active" history */
-	} else if ((tbl_type.lq_type == curr_tbl->lq_type) &&
-		   (tbl_type.ant_type == curr_tbl->ant_type) &&
-		   (tbl_type.is_SGI == curr_tbl->is_SGI)) {
-		if (curr_tbl->expected_tpt)
-			tpt = curr_tbl->expected_tpt[rs_index];
-		else
-			tpt = 0;
-		if (info->flags & IEEE80211_TX_STAT_AMPDU)
-			rs_collect_tx_data(window, rs_index, tpt,
-					   info->status.ampdu_ack_len,
-					   info->status.ampdu_ack_map);
-		else
-			rs_collect_tx_data(window, rs_index, tpt,
-					   1, status);
-	}
+		retries = info->status.rates[0].count - 1;
+		/* HW doesn't send more than 15 retries */
+		retries = min(retries, 15);
+
+		/* The last transmission may have been successful */
+		legacy_success = !!(info->flags & IEEE80211_TX_STAT_ACK);
+		/* Collect data for each rate used during failed TX attempts */
+		for (i = 0; i <= retries; ++i) {
+			tx_rate = le32_to_cpu(table->rs_table[i].rate_n_flags);
+			rs_get_tbl_info_from_mcs(tx_rate, priv->band,
+					&tbl_type, &rs_index);
+			/*
+			 * Only collect stats if retried rate is in the same RS
+			 * table as active/search.
+			 */
+			if (table_type_matches(&tbl_type, curr_tbl))
+				tpt = get_expected_tpt(curr_tbl, rs_index);
+			else if (table_type_matches(&tbl_type, other_tbl))
+				tpt = get_expected_tpt(other_tbl, rs_index);
+			else
+				continue;
 
-	/* If not searching for new mode, increment success/failed counter
-	 * ... these help determine when to start searching again */
-	if (lq_sta->stay_in_tbl) {
-		if (info->flags & IEEE80211_TX_STAT_AMPDU) {
-			lq_sta->total_success += info->status.ampdu_ack_map;
-			lq_sta->total_failed +=
-			     (info->status.ampdu_ack_len - info->status.ampdu_ack_map);
-		} else {
-			if (status)
-				lq_sta->total_success++;
+			/* Constants mean 1 transmission, 0 successes */
+			if (i < retries)
+				rs_collect_tx_data(window, rs_index, tpt, 1,
+						0);
 			else
-				lq_sta->total_failed++;
+				rs_collect_tx_data(window, rs_index, tpt, 1,
+						legacy_success);
+		}
+
+		/* Update success/fail counts if not searching for new mode */
+		if (lq_sta->stay_in_tbl) {
+			lq_sta->total_success += legacy_success;
+			lq_sta->total_failed += retries + (1 - legacy_success);
 		}
 	}
+	/* The last TX rate is cached in lq_sta; it's set in if/else above */
+	lq_sta->last_rate_n_flags = tx_rate;
 
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
-out:
-	return;
 }
 
 /*
-- 
1.5.6.3

