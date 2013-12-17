Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38580 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3LQUp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:28 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so3137373eek.11
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:27 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/36] iwlwifi: mvm: rs: refactor rate scale action decision
Date: Tue, 17 Dec 2013 22:44:33 +0200
Message-Id: <1387313079-28123-30-git-send-email-egrumbach@gmail.com> (sfid-20131217_215149_925510_2556B0C3)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Extract the scale action decision to a different function
in preparation of modifying it. While at it also convert
the scale action values from hardcoded values to a clear enum.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |  186 ++++++++++++++++++---------------
 1 file changed, 103 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 6d0bd45..62b29d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -130,6 +130,12 @@ static const struct iwl_rs_rate_info iwl_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_MCS_RATE(9),                 /* MCS 9 */
 };
 
+enum rs_action {
+	RS_ACTION_STAY = 0,
+	RS_ACTION_DOWNSCALE = -1,
+	RS_ACTION_UPSCALE = 1,
+};
+
 enum rs_column_mode {
 	RS_INVALID = 0,
 	RS_LEGACY,
@@ -1616,6 +1622,97 @@ err:
 	return -1;
 }
 
+static enum rs_action rs_get_rate_action(struct iwl_mvm *mvm,
+					 struct iwl_scale_tbl_info *tbl,
+					 s32 sr, int low, int high,
+					 int current_tpt,
+					 int low_tpt, int high_tpt)
+{
+	enum rs_action action = RS_ACTION_STAY;
+
+	/* Too many failures, decrease rate */
+	if ((sr <= RS_SR_FORCE_DECREASE) || (current_tpt == 0)) {
+		IWL_DEBUG_RATE(mvm,
+			       "decrease rate because of low SR\n");
+		action = RS_ACTION_DOWNSCALE;
+	/* No throughput measured yet for adjacent rates; try increase. */
+	} else if ((low_tpt == IWL_INVALID_VALUE) &&
+		   (high_tpt == IWL_INVALID_VALUE)) {
+		if (high != IWL_RATE_INVALID && sr >= IWL_RATE_INCREASE_TH) {
+			IWL_DEBUG_RATE(mvm,
+				       "Good SR and no high rate measurement. "
+				       "Increase rate\n");
+			action = RS_ACTION_UPSCALE;
+		} else if (low != IWL_RATE_INVALID) {
+			IWL_DEBUG_RATE(mvm,
+				       "Remain in current rate\n");
+			action = RS_ACTION_STAY;
+		}
+	}
+
+	/* Both adjacent throughputs are measured, but neither one has better
+	 * throughput; we're using the best rate, don't change it!
+	 */
+	else if ((low_tpt != IWL_INVALID_VALUE) &&
+		 (high_tpt != IWL_INVALID_VALUE) &&
+		 (low_tpt < current_tpt) &&
+		 (high_tpt < current_tpt)) {
+		IWL_DEBUG_RATE(mvm,
+			       "Both high and low are worse. "
+			       "Maintain rate\n");
+		action = RS_ACTION_STAY;
+	}
+
+	/* At least one adjacent rate's throughput is measured,
+	 * and may have better performance.
+	 */
+	else {
+		/* Higher adjacent rate's throughput is measured */
+		if (high_tpt != IWL_INVALID_VALUE) {
+			/* Higher rate has better throughput */
+			if (high_tpt > current_tpt &&
+			    sr >= IWL_RATE_INCREASE_TH) {
+				IWL_DEBUG_RATE(mvm,
+					       "Higher rate is better and good "
+					       "SR. Increate rate\n");
+				action = RS_ACTION_UPSCALE;
+			} else {
+				IWL_DEBUG_RATE(mvm,
+					       "Higher rate isn't better OR "
+					       "no good SR. Maintain rate\n");
+				action = RS_ACTION_STAY;
+			}
+
+		/* Lower adjacent rate's throughput is measured */
+		} else if (low_tpt != IWL_INVALID_VALUE) {
+			/* Lower rate has better throughput */
+			if (low_tpt > current_tpt) {
+				IWL_DEBUG_RATE(mvm,
+					       "Lower rate is better. "
+					       "Decrease rate\n");
+				action = RS_ACTION_DOWNSCALE;
+			} else if (sr >= IWL_RATE_INCREASE_TH) {
+				IWL_DEBUG_RATE(mvm,
+					       "Lower rate isn't better and "
+					       "good SR. Increase rate\n");
+				action = RS_ACTION_UPSCALE;
+			}
+		}
+	}
+
+	/* Sanity check; asked for decrease, but success rate or throughput
+	 * has been good at old rate.  Don't change it.
+	 */
+	if ((action == RS_ACTION_DOWNSCALE) && (low != IWL_RATE_INVALID) &&
+	    ((sr > IWL_RATE_HIGH_TH) ||
+	     (current_tpt > (100 * tbl->expected_tpt[low])))) {
+		IWL_DEBUG_RATE(mvm,
+			       "Sanity check failed. Maintain rate\n");
+		action = RS_ACTION_STAY;
+	}
+
+	return action;
+}
 
 /*
  * Do rate scaling and search for new modulation mode.
@@ -1636,7 +1733,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	int low_tpt = IWL_INVALID_VALUE;
 	int high_tpt = IWL_INVALID_VALUE;
 	u32 fail_count;
-	s8 scale_action = 0;
+	enum rs_action scale_action = RS_ACTION_STAY;
 	u16 rate_mask;
 	u8 update_lq = 0;
 	struct iwl_scale_tbl_info *tbl, *tbl1;
@@ -1830,85 +1927,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		       rs_pretty_lq_type(rate->type), index, current_tpt, sr,
 		       low, high, low_tpt, high_tpt);
 
-	scale_action = 0;
-
-	/* Too many failures, decrease rate */
-	if ((sr <= RS_SR_FORCE_DECREASE) || (current_tpt == 0)) {
-		IWL_DEBUG_RATE(mvm,
-			       "decrease rate because of low SR\n");
-		scale_action = -1;
-	/* No throughput measured yet for adjacent rates; try increase. */
-	} else if ((low_tpt == IWL_INVALID_VALUE) &&
-		   (high_tpt == IWL_INVALID_VALUE)) {
-		if (high != IWL_RATE_INVALID && sr >= IWL_RATE_INCREASE_TH) {
-			IWL_DEBUG_RATE(mvm,
-				       "Good SR and no high rate measurement. "
-				       "Increase rate\n");
-			scale_action = 1;
-		} else if (low != IWL_RATE_INVALID) {
-			IWL_DEBUG_RATE(mvm,
-				       "Remain in current rate\n");
-			scale_action = 0;
-		}
-	}
-
-	/* Both adjacent throughputs are measured, but neither one has better
-	 * throughput; we're using the best rate, don't change it! */
-	else if ((low_tpt != IWL_INVALID_VALUE) &&
-		 (high_tpt != IWL_INVALID_VALUE) &&
-		 (low_tpt < current_tpt) &&
-		 (high_tpt < current_tpt)) {
-		IWL_DEBUG_RATE(mvm,
-			       "Both high and low are worse. "
-			       "Maintain rate\n");
-		scale_action = 0;
-	}
-
-	/* At least one adjacent rate's throughput is measured,
-	 * and may have better performance. */
-	else {
-		/* Higher adjacent rate's throughput is measured */
-		if (high_tpt != IWL_INVALID_VALUE) {
-			/* Higher rate has better throughput */
-			if (high_tpt > current_tpt &&
-			    sr >= IWL_RATE_INCREASE_TH) {
-				IWL_DEBUG_RATE(mvm,
-					       "Higher rate is better and good "
-					       "SR. Increate rate\n");
-				scale_action = 1;
-			} else {
-				IWL_DEBUG_RATE(mvm,
-					       "Higher rate isn't better OR "
-					       "no good SR. Maintain rate\n");
-				scale_action = 0;
-			}
-
-		/* Lower adjacent rate's throughput is measured */
-		} else if (low_tpt != IWL_INVALID_VALUE) {
-			/* Lower rate has better throughput */
-			if (low_tpt > current_tpt) {
-				IWL_DEBUG_RATE(mvm,
-					       "Lower rate is better. "
-					       "Decrease rate\n");
-				scale_action = -1;
-			} else if (sr >= IWL_RATE_INCREASE_TH) {
-				IWL_DEBUG_RATE(mvm,
-					       "Lower rate isn't better and "
-					       "good SR. Increase rate\n");
-				scale_action = 1;
-			}
-		}
-	}
-
-	/* Sanity check; asked for decrease, but success rate or throughput
-	 * has been good at old rate.  Don't change it. */
-	if ((scale_action == -1) && (low != IWL_RATE_INVALID) &&
-	    ((sr > IWL_RATE_HIGH_TH) ||
-	     (current_tpt > (100 * tbl->expected_tpt[low])))) {
-		IWL_DEBUG_RATE(mvm,
-			       "Sanity check failed. Maintain rate\n");
-		scale_action = 0;
-	}
+	scale_action = rs_get_rate_action(mvm, tbl, sr, low, high,
+					  current_tpt, low_tpt, high_tpt);
 
 	/* Force a search in case BT doesn't like us being in MIMO */
 	if (is_mimo(rate) &&
@@ -1920,7 +1940,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	}
 
 	switch (scale_action) {
-	case -1:
+	case RS_ACTION_DOWNSCALE:
 		/* Decrease starting rate, update uCode's rate table */
 		if (low != IWL_RATE_INVALID) {
 			update_lq = 1;
@@ -1931,7 +1951,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		}
 
 		break;
-	case 1:
+	case RS_ACTION_UPSCALE:
 		/* Increase starting rate, update uCode's rate table */
 		if (high != IWL_RATE_INVALID) {
 			update_lq = 1;
@@ -1942,7 +1962,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		}
 
 		break;
-	case 0:
+	case RS_ACTION_STAY:
 		/* No change */
 	default:
 		break;
-- 
1.7.9.5

