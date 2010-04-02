Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0DBUjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:39:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Henry Zhang <hongx.c.zhang@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: use consistent table for tx data collect
Date: Fri,  2 Apr 2010 13:39:07 -0700
Message-Id: <1270240748-12865-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240748-12865-1-git-send-email-reinette.chatre@intel.com>
References: <1270240748-12865-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

When collecting tx data for non-aggregation packets in rate scaling, if
the tx data matches "other table", it still uses current table to update
the stats and calculate average throughput in function rs_collect_tx_data().
This can mess up the rate scaling data structure and cause a kernel panic
in a BUG_ON statement in rs_rate_scale_perform().

To fix this bug, we pass table pointer instead of window pointer (pointed
to by table pointer) to function rs_collect_tx_data() so that the table
being used is consistent.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Henry Zhang <hongx.c.zhang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   55 ++++++++++++----------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 8bf7c20..be00cb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -345,6 +345,17 @@ static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
 	       !!(rate_n_flags & RATE_MCS_ANT_C_MSK);
 }
 
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
 /**
  * rs_collect_tx_data - Update the success/failure sliding window
  *
@@ -352,19 +363,21 @@ static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
  * at this rate.  window->data contains the bitmask of successful
  * packets.
  */
-static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
-			      int scale_index, s32 tpt, int attempts,
-			      int successes)
+static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
+			      int scale_index, int attempts, int successes)
 {
 	struct iwl_rate_scale_data *window = NULL;
 	static const u64 mask = (((u64)1) << (IWL_RATE_MAX_WINDOW - 1));
-	s32 fail_count;
+	s32 fail_count, tpt;
 
 	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
 		return -EINVAL;
 
 	/* Select window for current tx bit rate */
-	window = &(windows[scale_index]);
+	window = &(tbl->win[scale_index]);
+
+	/* Get expected throughput */
+	tpt = get_expected_tpt(tbl, scale_index);
 
 	/*
 	 * Keep track of only the latest 62 tx frame attempts in this rate's
@@ -738,16 +751,6 @@ static bool table_type_matches(struct iwl_scale_tbl_info *a,
 	return (a->lq_type == b->lq_type) && (a->ant_type == b->ant_type) &&
 		(a->is_SGI == b->is_SGI);
 }
-/*
- * Static function to get the expected throughput from an iwl_scale_tbl_info
- * that wraps a NULL pointer check
- */
-static s32 get_expected_tpt(struct iwl_scale_tbl_info *tbl, int rs_index)
-{
-	if (tbl->expected_tpt)
-		return tbl->expected_tpt[rs_index];
-	return 0;
-}
 
 /*
  * mac80211 sends us Tx status
@@ -764,12 +767,10 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl_rate_scale_data *window = NULL;
 	enum mac80211_rate_control_flags mac_flags;
 	u32 tx_rate;
 	struct iwl_scale_tbl_info tbl_type;
-	struct iwl_scale_tbl_info *curr_tbl, *other_tbl;
-	s32 tpt = 0;
+	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
 
 	IWL_DEBUG_RATE_LIMIT(priv, "get frame ack response, update rate scale window\n");
 
@@ -852,7 +853,6 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		IWL_DEBUG_RATE(priv, "Neither active nor search matches tx rate\n");
 		return;
 	}
-	window = (struct iwl_rate_scale_data *)&(curr_tbl->win[0]);
 
 	/*
 	 * Updating the frame history depends on whether packets were
@@ -865,8 +865,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
 		rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type,
 				&rs_index);
-		tpt = get_expected_tpt(curr_tbl, rs_index);
-		rs_collect_tx_data(window, rs_index, tpt,
+		rs_collect_tx_data(curr_tbl, rs_index,
 				   info->status.ampdu_ack_len,
 				   info->status.ampdu_ack_map);
 
@@ -896,19 +895,13 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 			 * table as active/search.
 			 */
 			if (table_type_matches(&tbl_type, curr_tbl))
-				tpt = get_expected_tpt(curr_tbl, rs_index);
+				tmp_tbl = curr_tbl;
 			else if (table_type_matches(&tbl_type, other_tbl))
-				tpt = get_expected_tpt(other_tbl, rs_index);
+				tmp_tbl = other_tbl;
 			else
 				continue;
-
-			/* Constants mean 1 transmission, 0 successes */
-			if (i < retries)
-				rs_collect_tx_data(window, rs_index, tpt, 1,
-						0);
-			else
-				rs_collect_tx_data(window, rs_index, tpt, 1,
-						legacy_success);
+			rs_collect_tx_data(tmp_tbl, rs_index, 1,
+					   i < retries ? 0 : legacy_success);
 		}
 
 		/* Update success/fail counts if not searching for new mode */
-- 
1.6.3.3

