Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZCKSNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8] iwl3945 : fix rate scaling
Date: Wed, 11 Mar 2009 11:17:56 -0700
Message-Id: <1236795481-12757-4-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191315_191445_9B5A4F98)
In-Reply-To: <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch fixes the bug 1900 at
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1900

Issues:
Throughput and success ratio calculations were not done properly.
Number of retries were exceeding 16.

Fix:
Patch fixes above issues by doing window calculations inline with iwlwifi
Patch adds sanity check to limit number of retries to 16.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |  127 +++++++++++++++++++---------
 1 files changed, 88 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index a266458..f65c308 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -127,6 +127,7 @@ static struct iwl3945_tpt_entry iwl3945_tpt_table_g[] = {
 #define IWL_RATE_MIN_FAILURE_TH       8
 #define IWL_RATE_MIN_SUCCESS_TH       8
 #define IWL_RATE_DECREASE_TH       1920
+#define IWL_RATE_RETRY_TH	     15
 
 static u8 iwl3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
 {
@@ -298,37 +299,53 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 	}
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
-	while (retries--) {
 
-		/* If we have filled up the window then subtract one from the
-		 * success counter if the high-bit is counting toward
-		 * success */
-		if (window->counter == IWL_RATE_MAX_WINDOW) {
-			if (window->data & (1ULL << (IWL_RATE_MAX_WINDOW - 1)))
+	/*
+	 * Keep track of only the latest 62 tx frame attempts in this rate's
+	 * history window; anything older isn't really relevant any more.
+	 * If we have filled up the sliding window, drop the oldest attempt;
+	 * if the oldest attempt (highest bit in bitmap) shows "success",
+	 * subtract "1" from the success counter (this is the main reason
+	 * we keep these bitmaps!).
+	 * */
+	while (retries > 0) {
+		if (window->counter >= IWL_RATE_MAX_WINDOW) {
+
+			/* remove earliest */
+			window->counter = IWL_RATE_MAX_WINDOW - 1;
+
+			if (window->data & (1ULL << (IWL_RATE_MAX_WINDOW - 1))) {
+				window->data &= ~(1ULL << (IWL_RATE_MAX_WINDOW - 1));
 				window->success_counter--;
-		} else
-			window->counter++;
+			}
+		}
 
-		/* Slide the window to the left one bit */
-		window->data = (window->data << 1);
+		/* Increment frames-attempted counter */
+		window->counter++;
 
-		/* If this packet was a success then set the low bit high */
-		if (success) {
+		/* Shift bitmap by one frame (throw away oldest history),
+		 * OR in "1", and increment "success" if this
+		 * frame was successful. */
+		window->data <<= 1;
+		if (success > 0) {
 			window->success_counter++;
-			window->data |= 1;
+			window->data |= 0x1;
+			success--;
 		}
 
-		/* window->counter can't be 0 -- it is either >0 or
-		 * IWL_RATE_MAX_WINDOW */
-		window->success_ratio = 12800 * window->success_counter /
-		    window->counter;
-
-		/* Tag this window as having been updated */
-		window->stamp = jiffies;
-
+		retries--;
 	}
 
+	/* Calculate current success ratio, avoid divide-by-0! */
+	if (window->counter > 0)
+		window->success_ratio = 128 * (100 * window->success_counter)
+					/ window->counter;
+	else
+		window->success_ratio = IWL_INVALID_VALUE;
+
 	fail_count = window->counter - window->success_counter;
+
+	/* Calculate average throughput, if we have enough history. */
 	if ((fail_count >= IWL_RATE_MIN_FAILURE_TH) ||
 	    (window->success_counter >= IWL_RATE_MIN_SUCCESS_TH))
 		window->average_tpt = ((window->success_ratio *
@@ -336,6 +353,9 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 	else
 		window->average_tpt = IWL_INVALID_VALUE;
 
+	/* Tag this window as having been updated */
+	window->stamp = jiffies;
+
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 }
@@ -468,7 +488,10 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 
-	retries = info->status.rates[0].count;
+	retries = info->status.rates[0].count - 1;
+	/* Sanity Check for retries */
+	if (retries > IWL_RATE_RETRY_TH)
+		retries = IWL_RATE_RETRY_TH;
 
 	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT_3945)) {
@@ -724,7 +747,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	fail_count = window->counter - window->success_counter;
 
-	if (((fail_count <= IWL_RATE_MIN_FAILURE_TH) &&
+	if (((fail_count < IWL_RATE_MIN_FAILURE_TH) &&
 	     (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))) {
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
@@ -735,6 +758,9 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 			       window->counter,
 			       window->success_counter,
 			       rs_sta->expected_tpt ? "not " : "");
+
+	   /* Can't calculate this yet; not enough history */
+		window->average_tpt = IWL_INVALID_VALUE;
 		goto out;
 
 	}
@@ -750,6 +776,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	if ((max_rate_idx != -1) && (max_rate_idx < high))
 		high = IWL_RATE_INVALID;
 
+	/* Collect Measured throughputs of adjacent rates */
 	if (low != IWL_RATE_INVALID)
 		low_tpt = rs_sta->win[low].average_tpt;
 
@@ -758,24 +785,43 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	scale_action = 1;
+	scale_action = 0;
 
+	/* Low success ratio , need to drop the rate */
 	if ((window->success_ratio < IWL_RATE_DECREASE_TH) || !current_tpt) {
 		IWL_DEBUG_RATE(priv, "decrease rate because of low success_ratio\n");
 		scale_action = -1;
+
+	/* No throughput measured yet for adjacent rates,
+	 * try increase */
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
-		   (high_tpt == IWL_INVALID_VALUE))
-		scale_action = 1;
-	else if ((low_tpt != IWL_INVALID_VALUE) &&
+		   (high_tpt == IWL_INVALID_VALUE)) {
+
+		if (high != IWL_RATE_INVALID && window->success_counter >= IWL_RATE_INCREASE_TH)
+			scale_action = 1;
+		else if (low != IWL_RATE_INVALID)
+			scale_action = -1;
+
+	/* Both adjacent throughputs are measured, but neither one has
+	 * better throughput; we're using the best rate, don't change
+	 * it! */
+	} else if ((low_tpt != IWL_INVALID_VALUE) &&
 		 (high_tpt != IWL_INVALID_VALUE) &&
 		 (low_tpt < current_tpt) && (high_tpt < current_tpt)) {
+
 		IWL_DEBUG_RATE(priv, "No action -- low [%d] & high [%d] < "
 			       "current_tpt [%d]\n",
 			       low_tpt, high_tpt, current_tpt);
 		scale_action = 0;
+
+	/* At least one of the rates has better throughput */
 	} else {
 		if (high_tpt != IWL_INVALID_VALUE) {
-			if (high_tpt > current_tpt)
+
+			/* High rate has better throughput, Increase
+			 * rate */
+			if (high_tpt > current_tpt &&
+				window->success_ratio >= IWL_RATE_INCREASE_TH)
 				scale_action = 1;
 			else {
 				IWL_DEBUG_RATE(priv,
@@ -787,29 +833,31 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 				IWL_DEBUG_RATE(priv,
 				    "decrease rate because of low tpt\n");
 				scale_action = -1;
-			} else
+			} else if (window->success_counter >= IWL_RATE_INCREASE_TH) {
+				/* Lower rate has better
+				 * throughput,decrease rate */
 				scale_action = 1;
+			}
 		}
 	}
 
-	if (scale_action == -1) {
-		if (window->success_ratio > IWL_SUCCESS_DOWN_TH)
-			scale_action = 0;
-	} else if (scale_action == 1) {
-		if (window->success_ratio < IWL_SUCCESS_UP_TH) {
-			IWL_DEBUG_RATE(priv, "No action -- success_ratio [%d] < "
-			       "SUCCESS UP\n", window->success_ratio);
-			scale_action = 0;
-		}
-	}
+	/* Sanity check; asked for decrease, but success rate or throughput
+	 * has been good at old rate.  Don't change it. */
+	if ((scale_action == -1) && (low != IWL_RATE_INVALID) &&
+		    ((window->success_ratio > IWL_RATE_HIGH_TH) ||
+		     (current_tpt > (100 * rs_sta->expected_tpt[low]))))
+		scale_action = 0;
 
 	switch (scale_action) {
 	case -1:
+
+		/* Decrese rate */
 		if (low != IWL_RATE_INVALID)
 			index = low;
 		break;
 
 	case 1:
+		/* Increase rate */
 		if (high != IWL_RATE_INVALID)
 			index = high;
 
@@ -817,6 +865,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	case 0:
 	default:
+		/* No change */
 		break;
 	}
 
-- 
1.5.6.3

