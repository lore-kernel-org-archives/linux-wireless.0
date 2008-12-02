Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9103 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYLBUNO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/11] iwl3945: Fix iwl3945 rate scaling.
Date: Tue,  2 Dec 2008 12:14:03 -0800
Message-Id: <1228248847-10424-8-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211326_432190_42DCB4C1)
In-Reply-To: <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abbas, Mohamed <mohamed.abbas@intel.com>

3945 rate scaling was broken in recent tree. This patch fix the following:
	1- Get TX response info and update rates window.
	2- Rate scaling selection.
	3- Flush window timer.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   83 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-3945.c    |   26 +-------
 2 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index e5f4b71..06d97b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -117,9 +117,11 @@ static struct iwl3945_tpt_entry iwl3945_tpt_table_g[] = {
 };
 
 #define IWL_RATE_MAX_WINDOW          62
-#define IWL_RATE_FLUSH        (3*HZ/10)
+#define IWL_RATE_FLUSH       	 (3*HZ)
 #define IWL_RATE_WIN_FLUSH       (HZ/2)
 #define IWL_RATE_HIGH_TH          11520
+#define IWL_SUCCESS_UP_TH	   8960
+#define IWL_SUCCESS_DOWN_TH	  10880
 #define IWL_RATE_MIN_FAILURE_TH       8
 #define IWL_RATE_MIN_SUCCESS_TH       8
 #define IWL_RATE_DECREASE_TH       1920
@@ -206,6 +208,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 
 #define IWL_RATE_FLUSH_MAX              5000	/* msec */
 #define IWL_RATE_FLUSH_MIN              50	/* msec */
+#define IWL_AVERAGE_PACKETS             1500
 
 static void iwl3945_bg_rate_scale_flush(unsigned long data)
 {
@@ -220,8 +223,6 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
-	rs_sta->flush_pending = 0;
-
 	/* Number of packets Rx'd since last time this timer ran */
 	packet_count = (rs_sta->tx_packets - rs_sta->last_tx_packets) + 1;
 
@@ -230,7 +231,6 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 	if (unflushed) {
 		duration =
 		    jiffies_to_msecs(jiffies - rs_sta->last_partial_flush);
-/*              duration = jiffies_to_msecs(rs_sta->flush_time); */
 
 		IWL_DEBUG_RATE("Tx'd %d packets in %dms\n",
 			       packet_count, duration);
@@ -242,9 +242,11 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 			pps = 0;
 
 		if (pps) {
-			duration = IWL_RATE_FLUSH_MAX / pps;
+			duration = (IWL_AVERAGE_PACKETS * 1000) / pps;
 			if (duration < IWL_RATE_FLUSH_MIN)
 				duration = IWL_RATE_FLUSH_MIN;
+			else if (duration > IWL_RATE_FLUSH_MAX)
+				duration = IWL_RATE_FLUSH_MAX;
 		} else
 			duration = IWL_RATE_FLUSH_MAX;
 
@@ -257,8 +259,10 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 			  rs_sta->flush_time);
 
 		rs_sta->last_partial_flush = jiffies;
+	} else {
+		rs_sta->flush_time = IWL_RATE_FLUSH;
+		rs_sta->flush_pending = 0;
 	}
-
 	/* If there weren't any unflushed entries, we don't schedule the timer
 	 * to run again */
 
@@ -278,17 +282,18 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
  */
 static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 				struct iwl3945_rate_scale_data *window,
-				int success, int retries)
+				int success, int retries, int index)
 {
 	unsigned long flags;
+	s32 fail_count;
 
 	if (!retries) {
 		IWL_DEBUG_RATE("leave: retries == 0 -- should be at least 1\n");
 		return;
 	}
 
+	spin_lock_irqsave(&rs_sta->lock, flags);
 	while (retries--) {
-		spin_lock_irqsave(&rs_sta->lock, flags);
 
 		/* If we have filled up the window then subtract one from the
 		 * success counter if the high-bit is counting toward
@@ -316,8 +321,18 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 		/* Tag this window as having been updated */
 		window->stamp = jiffies;
 
-		spin_unlock_irqrestore(&rs_sta->lock, flags);
 	}
+
+	fail_count = window->counter - window->success_counter;
+	if ((fail_count >= IWL_RATE_MIN_FAILURE_TH) ||
+	    (window->success_counter >= IWL_RATE_MIN_SUCCESS_TH))
+		window->average_tpt = ((window->success_ratio *
+				rs_sta->expected_tpt[index] + 64) / 128);
+	else
+		window->average_tpt = IWL_INV_TPT;
+
+	spin_unlock_irqrestore(&rs_sta->lock, flags);
+
 }
 
 static void rs_rate_init(void *priv, struct ieee80211_supported_band *sband,
@@ -429,19 +444,16 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 			 struct ieee80211_sta *sta, void *priv_sta,
 			 struct sk_buff *skb)
 {
-	u8 retries = 0, current_count;
+	s8 retries = 0, current_count;
 	int scale_rate_index, first_index, last_index;
 	unsigned long flags;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int i;
 
 	IWL_DEBUG_RATE("enter\n");
 
-	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
-		retries += info->status.rates[i].count;
-	retries--;
+	retries = info->status.rates[0].count;
 
 	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
@@ -469,9 +481,9 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 	 * at which the frame was finally transmitted (or failed if no
 	 * ACK)
 	 */
-	while (retries > 0) {
-		if (retries < priv->retry_rate) {
-			current_count = retries;
+	while (retries > 1) {
+		if ((retries - 1) < priv->retry_rate) {
+			current_count = (retries - 1);
 			last_index = scale_rate_index;
 		} else {
 			current_count = priv->retry_rate;
@@ -483,15 +495,13 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 		 * as was used for it (per current_count) */
 		iwl3945_collect_tx_data(rs_sta,
 				    &rs_sta->win[scale_rate_index],
-				    0, current_count);
+				    0, current_count, scale_rate_index);
 		IWL_DEBUG_RATE("Update rate %d for %d retries.\n",
 			       scale_rate_index, current_count);
 
 		retries -= current_count;
 
-		if (retries)
-			scale_rate_index =
-			    iwl3945_rs_next_rate(priv, scale_rate_index);
+		scale_rate_index = last_index;
 	}
 
 
@@ -502,7 +512,7 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 		       "success" : "failure");
 	iwl3945_collect_tx_data(rs_sta,
 			    &rs_sta->win[last_index],
-			    info->flags & IEEE80211_TX_STAT_ACK, 1);
+			    info->flags & IEEE80211_TX_STAT_ACK, 1, last_index);
 
 	/* We updated the rate scale window -- if its been more than
 	 * flush_time since the last run, schedule the flush
@@ -510,9 +520,10 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
 	if (!rs_sta->flush_pending &&
-	    time_after(jiffies, rs_sta->last_partial_flush +
+	    time_after(jiffies, rs_sta->last_flush +
 		       rs_sta->flush_time)) {
 
+		rs_sta->last_partial_flush = jiffies;
 		rs_sta->flush_pending = 1;
 		mod_timer(&rs_sta->rate_scale_flush,
 			  jiffies + rs_sta->flush_time);
@@ -661,8 +672,13 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
+	/* for recent assoc, choose best rate regarding
+	 * to rssi value
+	 */
 	if (rs_sta->start_rate != IWL_RATE_INVALID) {
-		index = rs_sta->start_rate;
+		if (rs_sta->start_rate < index &&
+		   (rate_mask & (1 << rs_sta->start_rate)))
+			index = rs_sta->start_rate;
 		rs_sta->start_rate = IWL_RATE_INVALID;
 	}
 
@@ -672,7 +688,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	if (((fail_count <= IWL_RATE_MIN_FAILURE_TH) &&
 	     (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))) {
-		window->average_tpt = IWL_INV_TPT;
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 		IWL_DEBUG_RATE("Invalid average_tpt on rate %d: "
@@ -686,8 +701,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	}
 
-	window->average_tpt = ((window->success_ratio *
-				rs_sta->expected_tpt[index] + 64) / 128);
 	current_tpt = window->average_tpt;
 
 	high_low = iwl3945_get_adjacent_rate(rs_sta, index, rate_mask,
@@ -735,13 +748,15 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		}
 	}
 
-	if ((window->success_ratio > IWL_RATE_HIGH_TH) ||
-	    (current_tpt > window->average_tpt)) {
-		IWL_DEBUG_RATE("No action -- success_ratio [%d] > HIGH_TH or "
-			       "current_tpt [%d] > average_tpt [%d]\n",
-			       window->success_ratio,
-			       current_tpt, window->average_tpt);
-		scale_action = 0;
+	if (scale_action == -1) {
+		if (window->success_ratio > IWL_SUCCESS_DOWN_TH)
+			scale_action = 0;
+	} else if (scale_action == 1) {
+		if (window->success_ratio < IWL_SUCCESS_UP_TH) {
+			IWL_DEBUG_RATE("No action -- success_ratio [%d] < "
+			       "SUCCESS UP\n", window->success_ratio);
+			scale_action = 0;
+		}
 	}
 
 	switch (scale_action) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 96824e8..d422600 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -337,7 +337,7 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
 	int rate_idx;
-	int fail, i;
+	int fail;
 
 	if ((index >= txq->q.n_bd) || (iwl3945_x2_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
@@ -356,27 +356,9 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 		rate_idx -= IWL_FIRST_OFDM_RATE;
 
 	fail = tx_resp->failure_frame;
-	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-		int next = iwl3945_rs_next_rate(priv, rate_idx);
 
-		info->status.rates[i].idx = rate_idx;
-
-		/*
-		 * Put remaining into the last count as best approximation
-		 * of saying exactly what the hardware would have done...
-		 */
-		if ((rate_idx == next) || (i == IEEE80211_TX_MAX_RATES - 1)) {
-			info->status.rates[i].count = fail;
-			break;
-		}
-
-		info->status.rates[i].count = priv->retry_rate;
-		fail -= priv->retry_rate;
-		rate_idx = next;
-		if (fail <= 0)
-			break;
-	}
-	info->status.rates[i].count++; /* add final attempt */
+	info->status.rates[0].idx = rate_idx;
+	info->status.rates[0].count = fail + 1; /* add final attempt */
 
 	/* tx_status->rts_retry_count = tx_resp->failure_rts; */
 	info->flags |= ((status & TX_STATUS_MSK) == TX_STATUS_SUCCESS) ?
-- 
1.5.4.3

