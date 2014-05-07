Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:34623 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEGTxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:41 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so1500479wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:40 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/23] iwlwifi: mvm: rs: overhaul rs_get_best_rate
Date: Wed,  7 May 2014 22:52:42 +0300
Message-Id: <1399492380-12050-5-git-send-email-egrumbach@gmail.com> (sfid-20140507_215403_461013_81A2583F)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

rs_get_best_rate determines the optimal rate to try in a
new Tx column. Currently we were sometimes trying a too high
rate which would lead us to fail and avoid switching to the
new column despite it having a potential to be better.
Change the logic to try and find the first rate which would
exceed the current actual throughput or be more aggressive
if the success ratio is good.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 117 +++++++++-------------------------
 1 file changed, 31 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index f9aab15..a7ad532 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1335,105 +1335,50 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 	tbl->expected_tpt = rs_get_expected_tpt_table(lq_sta, column, rate->bw);
 }
 
-/*
- * Find starting rate for new "search" high-throughput mode of modulation.
- * Goal is to find lowest expected rate (under perfect conditions) that is
- * above the current measured throughput of "active" mode, to give new mode
- * a fair chance to prove itself without too many challenges.
- *
- * This gets called when transitioning to more aggressive modulation
- * (i.e. legacy to SISO or MIMO, or SISO to MIMO), as well as less aggressive
- * (i.e. MIMO to SISO).  When moving to MIMO, bit rate will typically need
- * to decrease to match "active" throughput.  When moving from MIMO to SISO,
- * bit rate will typically need to increase, but not if performance was bad.
- */
 static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 			    struct iwl_lq_sta *lq_sta,
 			    struct iwl_scale_tbl_info *tbl,	/* "search" */
-			    u16 rate_mask, s8 index)
+			    unsigned long rate_mask, s8 index)
 {
-	/* "active" values */
 	struct iwl_scale_tbl_info *active_tbl =
 	    &(lq_sta->lq_info[lq_sta->active_tbl]);
-	s32 active_sr = active_tbl->win[index].success_ratio;
-	s32 active_tpt = active_tbl->expected_tpt[index];
-	/* expected "search" throughput */
+	s32 success_ratio = active_tbl->win[index].success_ratio;
+	u16 expected_current_tpt = active_tbl->expected_tpt[index];
 	const u16 *tpt_tbl = tbl->expected_tpt;
-
-	s32 new_rate, high, low, start_hi;
 	u16 high_low;
-	s8 rate = index;
-
-	new_rate = high = low = start_hi = IWL_RATE_INVALID;
-
-	while (1) {
-		high_low = rs_get_adjacent_rate(mvm, rate, rate_mask,
-						tbl->rate.type);
-
-		low = high_low & 0xff;
-		high = (high_low >> 8) & 0xff;
-
-		/*
-		 * Lower the "search" bit rate, to give new "search" mode
-		 * approximately the same throughput as "active" if:
-		 *
-		 * 1) "Active" mode has been working modestly well (but not
-		 *    great), and expected "search" throughput (under perfect
-		 *    conditions) at candidate rate is above the actual
-		 *    measured "active" throughput (but less than expected
-		 *    "active" throughput under perfect conditions).
-		 * OR
-		 * 2) "Active" mode has been working perfectly or very well
-		 *    and expected "search" throughput (under perfect
-		 *    conditions) at candidate rate is above expected
-		 *    "active" throughput (under perfect conditions).
-		 */
-		if ((((100 * tpt_tbl[rate]) > lq_sta->last_tpt) &&
-		     ((active_sr > RS_SR_FORCE_DECREASE) &&
-		      (active_sr <= IWL_RATE_HIGH_TH) &&
-		      (tpt_tbl[rate] <= active_tpt))) ||
-		    ((active_sr >= IWL_RATE_SCALE_SWITCH) &&
-		     (tpt_tbl[rate] > active_tpt))) {
-			/* (2nd or later pass)
-			 * If we've already tried to raise the rate, and are
-			 * now trying to lower it, use the higher rate. */
-			if (start_hi != IWL_RATE_INVALID) {
-				new_rate = start_hi;
-				break;
-			}
-
-			new_rate = rate;
+	u32 target_tpt;
+	int rate_idx;
 
-			/* Loop again with lower rate */
-			if (low != IWL_RATE_INVALID)
-				rate = low;
+	if (success_ratio > RS_SR_NO_DECREASE) {
+		target_tpt = 100 * expected_current_tpt;
+		IWL_DEBUG_RATE(mvm,
+			       "SR %d high. Find rate exceeding EXPECTED_CURRENT %d\n",
+			       success_ratio, target_tpt);
+	} else {
+		target_tpt = lq_sta->last_tpt;
+		IWL_DEBUG_RATE(mvm,
+			       "SR %d not thag good. Find rate exceeding ACTUAL_TPT %d\n",
+			       success_ratio, target_tpt);
+	}
 
-			/* Lower rate not available, use the original */
-			else
-				break;
+	rate_idx = find_first_bit(&rate_mask, BITS_PER_LONG);
 
-		/* Else try to raise the "search" rate to match "active" */
-		} else {
-			/* (2nd or later pass)
-			 * If we've already tried to lower the rate, and are
-			 * now trying to raise it, use the lower rate. */
-			if (new_rate != IWL_RATE_INVALID)
-				break;
+	while (rate_idx != IWL_RATE_INVALID) {
+		if (target_tpt < (100 * tpt_tbl[rate_idx]))
+			break;
 
-			/* Loop again with higher rate */
-			else if (high != IWL_RATE_INVALID) {
-				start_hi = high;
-				rate = high;
+		high_low = rs_get_adjacent_rate(mvm, rate_idx, rate_mask,
+						tbl->rate.type);
 
-			/* Higher rate not available, use the original */
-			} else {
-				new_rate = rate;
-				break;
-			}
-		}
+		rate_idx = (high_low >> 8) & 0xff;
 	}
 
-	return new_rate;
+	IWL_DEBUG_RATE(mvm, "Best rate found %d target_tp %d expected_new %d\n",
+		       rate_idx, target_tpt,
+		       rate_idx != IWL_RATE_INVALID ?
+		       100 * tpt_tbl[rate_idx] : IWL_INVALID_VALUE);
+
+	return rate_idx;
 }
 
 static u32 rs_bw_from_sta_bw(struct ieee80211_sta *sta)
@@ -1649,7 +1594,7 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 	const struct rs_tx_column *curr_column = &rs_tx_columns[tbl->column];
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u16 rate_mask = 0;
+	unsigned long rate_mask = 0;
 	u32 rate_idx = 0;
 
 	memcpy(search_tbl, tbl, sz);
@@ -1691,7 +1636,7 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 		    !(BIT(rate_idx) & rate_mask)) {
 			IWL_DEBUG_RATE(mvm,
 				       "can not switch with index %d"
-				       " rate mask %x\n",
+				       " rate mask %lx\n",
 				       rate_idx, rate_mask);
 
 			goto err;
-- 
1.8.3.2

