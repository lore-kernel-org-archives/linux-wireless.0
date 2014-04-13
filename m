Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59670 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaDMNC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:57 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>, <stable@vger.kernel.org>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/13] iwlwifi: mvm: rs: fix and cleanup rs_get_rate_action
Date: Sun, 13 Apr 2014 16:01:58 +0300
Message-Id: <1397394123-25102-8-git-send-email-egrumbach@gmail.com> (sfid-20140413_150305_848656_D0F6772C)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Change the down/upscale decision logic a bit to be based
on different success ratio thresholds. This fixes the implementation
compared to the rate scale algorithm which was planned to yield
optimal results. Also fix a case where a lower rate wasn't explored
despite being a potential for better throughput.
While at it rewrite rs_get_rate_action to be more clear and clean.

Cc: <stable@vger.kernel.org> [3.14]
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 127 ++++++++++++++++------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |   1 +
 2 files changed, 60 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index cd32ad5..97b8fac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1658,85 +1658,76 @@ static enum rs_action rs_get_rate_action(struct iwl_mvm *mvm,
 {
 	enum rs_action action = RS_ACTION_STAY;
 
-	/* Too many failures, decrease rate */
 	if ((sr <= RS_SR_FORCE_DECREASE) || (current_tpt == 0)) {
 		IWL_DEBUG_RATE(mvm,
-			       "decrease rate because of low SR\n");
-		action = RS_ACTION_DOWNSCALE;
-	/* No throughput measured yet for adjacent rates; try increase. */
-	} else if ((low_tpt == IWL_INVALID_VALUE) &&
-		   (high_tpt == IWL_INVALID_VALUE)) {
-		if (high != IWL_RATE_INVALID && sr >= IWL_RATE_INCREASE_TH) {
-			IWL_DEBUG_RATE(mvm,
-				       "Good SR and no high rate measurement. "
-				       "Increase rate\n");
-			action = RS_ACTION_UPSCALE;
-		} else if (low != IWL_RATE_INVALID) {
-			IWL_DEBUG_RATE(mvm,
-				       "Remain in current rate\n");
-			action = RS_ACTION_STAY;
-		}
+			       "Decrease rate because of low SR\n");
+		return RS_ACTION_DOWNSCALE;
 	}
 
-	/* Both adjacent throughputs are measured, but neither one has better
-	 * throughput; we're using the best rate, don't change it!
-	 */
-	else if ((low_tpt != IWL_INVALID_VALUE) &&
-		 (high_tpt != IWL_INVALID_VALUE) &&
-		 (low_tpt < current_tpt) &&
-		 (high_tpt < current_tpt)) {
+	if ((low_tpt == IWL_INVALID_VALUE) &&
+	    (high_tpt == IWL_INVALID_VALUE) &&
+	    (high != IWL_RATE_INVALID)) {
 		IWL_DEBUG_RATE(mvm,
-			       "Both high and low are worse. "
-			       "Maintain rate\n");
-		action = RS_ACTION_STAY;
+			       "No data about high/low rates. Increase rate\n");
+		return RS_ACTION_UPSCALE;
 	}
 
-	/* At least one adjacent rate's throughput is measured,
-	 * and may have better performance.
-	 */
-	else {
-		/* Higher adjacent rate's throughput is measured */
-		if (high_tpt != IWL_INVALID_VALUE) {
-			/* Higher rate has better throughput */
-			if (high_tpt > current_tpt &&
-			    sr >= IWL_RATE_INCREASE_TH) {
-				IWL_DEBUG_RATE(mvm,
-					       "Higher rate is better and good "
-					       "SR. Increate rate\n");
-				action = RS_ACTION_UPSCALE;
-			} else {
-				IWL_DEBUG_RATE(mvm,
-					       "Higher rate isn't better OR "
-					       "no good SR. Maintain rate\n");
-				action = RS_ACTION_STAY;
-			}
+	if ((high_tpt == IWL_INVALID_VALUE) &&
+	    (high != IWL_RATE_INVALID) &&
+	    (low_tpt != IWL_INVALID_VALUE) &&
+	    (low_tpt < current_tpt)) {
+		IWL_DEBUG_RATE(mvm,
+			       "No data about high rate and low rate is worse. Increase rate\n");
+		return RS_ACTION_UPSCALE;
+	}
 
-		/* Lower adjacent rate's throughput is measured */
-		} else if (low_tpt != IWL_INVALID_VALUE) {
-			/* Lower rate has better throughput */
-			if (low_tpt > current_tpt) {
-				IWL_DEBUG_RATE(mvm,
-					       "Lower rate is better. "
-					       "Decrease rate\n");
-				action = RS_ACTION_DOWNSCALE;
-			} else if (sr >= IWL_RATE_INCREASE_TH) {
-				IWL_DEBUG_RATE(mvm,
-					       "Lower rate isn't better and "
-					       "good SR. Increase rate\n");
-				action = RS_ACTION_UPSCALE;
-			}
-		}
+	if ((high_tpt != IWL_INVALID_VALUE) &&
+	    (high_tpt > current_tpt)) {
+		IWL_DEBUG_RATE(mvm,
+			       "Higher rate is better. Increate rate\n");
+		return RS_ACTION_UPSCALE;
 	}
 
-	/* Sanity check; asked for decrease, but success rate or throughput
-	 * has been good at old rate.  Don't change it.
-	 */
-	if ((action == RS_ACTION_DOWNSCALE) && (low != IWL_RATE_INVALID) &&
-	    ((sr > IWL_RATE_HIGH_TH) ||
-	     (current_tpt > (100 * tbl->expected_tpt[low])))) {
+	if ((low_tpt != IWL_INVALID_VALUE) &&
+	    (high_tpt != IWL_INVALID_VALUE) &&
+	    (low_tpt < current_tpt) &&
+	    (high_tpt < current_tpt)) {
 		IWL_DEBUG_RATE(mvm,
-			       "Sanity check failed. Maintain rate\n");
-		action = RS_ACTION_STAY;
+			       "Both high and low are worse. Maintain rate\n");
+		return RS_ACTION_STAY;
+	}
+
+	if ((low_tpt != IWL_INVALID_VALUE) &&
+	    (low_tpt > current_tpt)) {
+		IWL_DEBUG_RATE(mvm,
+			       "Lower rate is better\n");
+		action = RS_ACTION_DOWNSCALE;
+		goto out;
+	}
+
+	if ((low_tpt == IWL_INVALID_VALUE) &&
+	    (low != IWL_RATE_INVALID)) {
+		IWL_DEBUG_RATE(mvm,
+			       "No data about lower rate\n");
+		action = RS_ACTION_DOWNSCALE;
+		goto out;
+	}
+
+	IWL_DEBUG_RATE(mvm, "Maintain rate\n");
+
+out:
+	if ((action == RS_ACTION_DOWNSCALE) && (low != IWL_RATE_INVALID)) {
+		if (sr >= RS_SR_NO_DECREASE) {
+			IWL_DEBUG_RATE(mvm,
+				       "SR is above NO DECREASE. Avoid downscale\n");
+			action = RS_ACTION_STAY;
+		} else if (current_tpt > (100 * tbl->expected_tpt[low])) {
+			IWL_DEBUG_RATE(mvm,
+				       "Current TPT is higher than max expected in low rate. Avoid downscale\n");
+			action = RS_ACTION_STAY;
+		} else {
+			IWL_DEBUG_RATE(mvm, "Decrease rate\n");
+		}
 	}
 
 	return action;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 9892d92..fbb476a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -156,6 +156,7 @@ enum {
 #define IWL_RATE_HIGH_TH		10880	/*  85% */
 #define IWL_RATE_INCREASE_TH		6400	/*  50% */
 #define RS_SR_FORCE_DECREASE		1920	/*  15% */
+#define RS_SR_NO_DECREASE		10880	/*  85% */
 
 #define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000) /* 4 milliseconds */
 #define LINK_QUAL_AGG_TIME_LIMIT_MAX	(8000)
-- 
1.8.3.2

