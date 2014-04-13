Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37905 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaDMNDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:03:05 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>, <stable@vger.kernel.org>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/13] iwlwifi: mvm: rs: clear per rate stats when aggregation changes
Date: Sun, 13 Apr 2014 16:02:02 +0300
Message-Id: <1397394123-25102-12-git-send-email-egrumbach@gmail.com> (sfid-20140413_150350_561370_7196258A)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The per rate stats should be cleared when aggregation state changes
to avoid making rate scale decisions based on throughput figures which
were collected prior to the aggregation state change and are now stale.
While at it make sure any clearing of the per rate stats will get logged.

Cc: <stable@vger.kernel.org> [3.14]
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 5cab26e..9f52c5b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -519,10 +519,12 @@ static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 	window->average_tpt = IWL_INVALID_VALUE;
 }
 
-static void rs_rate_scale_clear_tbl_windows(struct iwl_scale_tbl_info *tbl)
+static void rs_rate_scale_clear_tbl_windows(struct iwl_mvm *mvm,
+					    struct iwl_scale_tbl_info *tbl)
 {
 	int i;
 
+	IWL_DEBUG_RATE(mvm, "Clearing up window stats\n");
 	for (i = 0; i < IWL_RATE_COUNT; i++)
 		rs_rate_scale_clear_window(&tbl->win[i]);
 }
@@ -1490,7 +1492,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 
 				IWL_DEBUG_RATE(mvm,
 					       "LQ: stay in table clear win\n");
-				rs_rate_scale_clear_tbl_windows(tbl);
+				rs_rate_scale_clear_tbl_windows(mvm, tbl);
 			}
 		}
 
@@ -1498,8 +1500,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 		 * bitmaps and stats in active table (this will become the new
 		 * "search" table). */
 		if (lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_STARTED) {
-			IWL_DEBUG_RATE(mvm, "Clearing up window stats\n");
-			rs_rate_scale_clear_tbl_windows(tbl);
+			rs_rate_scale_clear_tbl_windows(mvm, tbl);
 		}
 	}
 }
@@ -1836,6 +1837,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			       "Aggregation changed: prev %d current %d. Update expected TPT table\n",
 			       prev_agg, lq_sta->is_agg);
 		rs_set_expected_tpt_table(lq_sta, tbl);
+		rs_rate_scale_clear_tbl_windows(mvm, tbl);
 	}
 
 	/* current tx rate */
@@ -2065,7 +2067,7 @@ lq_update:
 		if (lq_sta->search_better_tbl) {
 			/* Access the "search" table, clear its history. */
 			tbl = &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-			rs_rate_scale_clear_tbl_windows(tbl);
+			rs_rate_scale_clear_tbl_windows(mvm, tbl);
 
 			/* Use new "search" start rate */
 			index = tbl->rate.index;
@@ -2396,7 +2398,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lq_sta->lq.sta_id = sta_priv->sta_id;
 
 	for (j = 0; j < LQ_SIZE; j++)
-		rs_rate_scale_clear_tbl_windows(&lq_sta->lq_info[j]);
+		rs_rate_scale_clear_tbl_windows(mvm, &lq_sta->lq_info[j]);
 
 	lq_sta->flush_timer = 0;
 	lq_sta->last_tx = jiffies;
-- 
1.8.3.2

