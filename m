Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbYE0DbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 23:31:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2.6.26 1/3] iwlwifi: fix in-column rate scaling
Date: Tue, 27 May 2008 11:29:33 +0800
Message-Id: <1211858975-21424-1-git-send-email-yi.zhu@intel.com> (sfid-20080527_053114_948616_BC35A467)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

This patch fixes cases that the code raised or didn't decrease
the rate although the success ratio was not good.

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   45 ++++++++++++++-------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 2adc228..fa41ed1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1339,7 +1339,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 				lq_sta->search_better_tbl = 1;
 				goto out;
 			}
-
+			break;
 		case IWL_LEGACY_SWITCH_SISO:
 			IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
 
@@ -1425,9 +1425,9 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				lq_sta->search_better_tbl = 1;
 				goto out;
 			}
-
+			break;
 		case IWL_SISO_SWITCH_MIMO2:
-			IWL_DEBUG_RATE("LQ: SISO switch to MIMO\n");
+			IWL_DEBUG_RATE("LQ: SISO switch to MIMO2\n");
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
 			search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
@@ -1692,6 +1692,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	u8 active_tbl = 0;
 	u8 done_search = 0;
 	u16 high_low;
+	s32 sr;
 #ifdef CONFIG_IWL4965_HT
 	u8 tid = MAX_TID_COUNT;
 #endif
@@ -1867,6 +1868,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
+	sr = window->success_ratio;
+
 	/* Collect measured throughputs for current and adjacent rates */
 	current_tpt = window->average_tpt;
 	if (low != IWL_RATE_INVALID)
@@ -1874,19 +1877,22 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (high != IWL_RATE_INVALID)
 		high_tpt = tbl->win[high].average_tpt;
 
-	/* Assume rate increase */
-	scale_action = 1;
+	scale_action = 0;
 
 	/* Too many failures, decrease rate */
-	if ((window->success_ratio <= IWL_RATE_DECREASE_TH) ||
-	    (current_tpt == 0)) {
+	if ((sr <= IWL_RATE_DECREASE_TH) || (current_tpt == 0)) {
 		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
 
 	/* No throughput measured yet for adjacent rates; try increase. */
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
-		   (high_tpt == IWL_INVALID_VALUE))
-		scale_action = 1;
+		   (high_tpt == IWL_INVALID_VALUE)) {
+
+		if (high != IWL_RATE_INVALID && sr >= IWL_RATE_INCREASE_TH)
+			scale_action = 1;
+		else if (low != IWL_RATE_INVALID)
+			scale_action = -1;
+	}
 
 	/* Both adjacent throughputs are measured, but neither one has better
 	 * throughput; we're using the best rate, don't change it! */
@@ -1902,9 +1908,10 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		/* Higher adjacent rate's throughput is measured */
 		if (high_tpt != IWL_INVALID_VALUE) {
 			/* Higher rate has better throughput */
-			if (high_tpt > current_tpt)
+			if (high_tpt > current_tpt &&
+					sr >= IWL_RATE_INCREASE_TH) {
 				scale_action = 1;
-			else {
+			} else {
 				IWL_DEBUG_RATE
 				    ("decrease rate because of high tpt\n");
 				scale_action = -1;
@@ -1917,23 +1924,17 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				IWL_DEBUG_RATE
 				    ("decrease rate because of low tpt\n");
 				scale_action = -1;
-			} else
+			} else if (sr >= IWL_RATE_INCREASE_TH) {
 				scale_action = 1;
+			}
 		}
 	}
 
 	/* Sanity check; asked for decrease, but success rate or throughput
 	 * has been good at old rate.  Don't change it. */
-	if (scale_action == -1) {
-		if ((low != IWL_RATE_INVALID) &&
-		    ((window->success_ratio > IWL_RATE_HIGH_TH) ||
+	if ((scale_action == -1) && (low != IWL_RATE_INVALID) &&
+		    ((sr > IWL_RATE_HIGH_TH) ||
 		     (current_tpt > (100 * tbl->expected_tpt[low]))))
-			scale_action = 0;
-
-	/* Sanity check; asked for increase, but success rate has not been great
-	 * even at old rate, higher rate will be worse.  Don't change it. */
-	} else if ((scale_action == 1) &&
-		   (window->success_ratio < IWL_RATE_INCREASE_TH))
 		scale_action = 0;
 
 	switch (scale_action) {
@@ -1962,7 +1963,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		    "high %d type %d\n",
 		     index, scale_action, low, high, tbl->lq_type);
 
- lq_update:
+lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
 		rate = rate_n_flags_from_tbl(tbl, index, is_green);
-- 
1.5.3.6

