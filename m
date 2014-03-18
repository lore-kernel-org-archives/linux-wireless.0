Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57715 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaCROqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:22 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so5344741eek.25
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:21 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/35] iwlwifi: add rs_rate_scale_clear_tbl_windows helper function
Date: Tue, 18 Mar 2014 16:45:25 +0200
Message-Id: <1395153939-23897-21-git-send-email-egrumbach@gmail.com> (sfid-20140318_154636_474210_27DACDBF)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

instead of duplicating the same loop multiple times,
use a new function for it.

this will be later used also for clearing other
windows in the table.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 953c33f..568abd6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -503,6 +503,14 @@ static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 	window->average_tpt = IWL_INVALID_VALUE;
 }
 
+static void rs_rate_scale_clear_tbl_windows(struct iwl_scale_tbl_info *tbl)
+{
+	int i;
+
+	for (i = 0; i < IWL_RATE_COUNT; i++)
+		rs_rate_scale_clear_window(&tbl->win[i]);
+}
+
 static inline u8 rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
 {
 	return (ant_type & valid_antenna) == ant_type;
@@ -1370,7 +1378,6 @@ static u32 rs_bw_from_sta_bw(struct ieee80211_sta *sta)
 static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 {
 	struct iwl_scale_tbl_info *tbl;
-	int i;
 	int active_tbl;
 	int flush_interval_passed = 0;
 	struct iwl_mvm *mvm;
@@ -1431,9 +1438,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 
 				IWL_DEBUG_RATE(mvm,
 					       "LQ: stay in table clear win\n");
-				for (i = 0; i < IWL_RATE_COUNT; i++)
-					rs_rate_scale_clear_window(
-						&(tbl->win[i]));
+				rs_rate_scale_clear_tbl_windows(tbl);
 			}
 		}
 
@@ -1442,8 +1447,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 		 * "search" table). */
 		if (lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_STARTED) {
 			IWL_DEBUG_RATE(mvm, "Clearing up window stats\n");
-			for (i = 0; i < IWL_RATE_COUNT; i++)
-				rs_rate_scale_clear_window(&(tbl->win[i]));
+			rs_rate_scale_clear_tbl_windows(tbl);
 		}
 	}
 }
@@ -1733,7 +1737,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	int low = IWL_RATE_INVALID;
 	int high = IWL_RATE_INVALID;
 	int index;
-	int i;
 	struct iwl_rate_scale_data *window = NULL;
 	int current_tpt = IWL_INVALID_VALUE;
 	int low_tpt = IWL_INVALID_VALUE;
@@ -2018,8 +2021,7 @@ lq_update:
 		if (lq_sta->search_better_tbl) {
 			/* Access the "search" table, clear its history. */
 			tbl = &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-			for (i = 0; i < IWL_RATE_COUNT; i++)
-				rs_rate_scale_clear_window(&(tbl->win[i]));
+			rs_rate_scale_clear_tbl_windows(tbl);
 
 			/* Use new "search" start rate */
 			index = tbl->rate.index;
@@ -2340,8 +2342,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lq_sta->lq.sta_id = sta_priv->sta_id;
 
 	for (j = 0; j < LQ_SIZE; j++)
-		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
+		rs_rate_scale_clear_tbl_windows(&lq_sta->lq_info[j]);
 
 	lq_sta->flush_timer = 0;
 
-- 
1.8.3.2

