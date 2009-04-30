Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52689 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbZD3JlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 05:41:08 -0400
Date: Thu, 30 Apr 2009 12:41:00 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Add a timeout for frames in the RX reorder buffer
Message-ID: <20090430094100.GA23131@jm.kir.nu> (sfid-20090430_114114_869966_AD8F1551)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows skbs to be released from the RX reorder buffer in
case they have been there for an unexpectedly long time without us
having received the missing frames before them. Previously, these
frames were only released when the reorder window moved and that could
take very long time unless new frames were received constantly (e.g.,
TCP connections could be killed more or less indefinitely).

This situation should not happen very frequently, but it looks like
there are some scenarious that trigger for some reason. As such, this
should be considered mostly a workaround to speed up recovery from
unexpected siutation that could result in connections hanging for long
periods of time.

The changes here will only check for timeout situation when adding new
RX frames to the reorder buffer. It does not handle all possible
cases, but seems to help for most cases that could result from common
network usage (e.g., TCP retrying at least couple of times). For more
completely coverage, a timer could be used to periodically check
whether there are any frames remaining in the reorder buffer if no new
frames are received.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/agg-rx.c   |    8 +++
 net/mac80211/rx.c       |  107 ++++++++++++++++++++++++++++++------------------
 net/mac80211/sta_info.h |    2 
 3 files changed, 76 insertions(+), 41 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-04-29 18:38:29.000000000 +0300
+++ wireless-testing/net/mac80211/agg-rx.c	2009-04-29 18:40:42.000000000 +0300
@@ -68,6 +68,7 @@ void __ieee80211_stop_rx_ba_session(stru
 	spin_lock_bh(&sta->lock);
 	/* free resources */
 	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_buf);
+	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_time);
 
 	if (!sta->ampdu_mlme.tid_rx[tid]->shutdown) {
 		kfree(sta->ampdu_mlme.tid_rx[tid]);
@@ -268,13 +269,18 @@ void ieee80211_process_addba_request(str
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
 		kcalloc(buf_size, sizeof(struct sk_buff *), GFP_ATOMIC);
-	if (!tid_agg_rx->reorder_buf) {
+	tid_agg_rx->reorder_time =
+		kcalloc(buf_size, sizeof(unsigned long), GFP_ATOMIC);
+	if (!tid_agg_rx->reorder_buf || !tid_agg_rx->reorder_time) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_ERR "can not allocate reordering buffer "
 			       "to tid %d\n", tid);
 #endif
+		kfree(tid_agg_rx->reorder_buf);
+		kfree(tid_agg_rx->reorder_time);
 		kfree(sta->ampdu_mlme.tid_rx[tid]);
+		sta->ampdu_mlme.tid_rx[tid] = NULL;
 		goto end;
 	}
 
--- wireless-testing.orig/net/mac80211/rx.c	2009-04-29 18:38:26.000000000 +0300
+++ wireless-testing/net/mac80211/rx.c	2009-04-30 12:30:11.000000000 +0300
@@ -2284,6 +2284,34 @@ static inline u16 seq_sub(u16 sq1, u16 s
 }
 
 
+static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
+					    struct tid_ampdu_rx *tid_agg_rx,
+					    int index)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *rate;
+	struct ieee80211_rx_status status;
+
+	if (!tid_agg_rx->reorder_buf[index])
+		goto no_frame;
+
+	/* release the reordered frames to stack */
+	memcpy(&status, tid_agg_rx->reorder_buf[index]->cb, sizeof(status));
+	sband = hw->wiphy->bands[status.band];
+	if (status.flag & RX_FLAG_HT)
+		rate = sband->bitrates; /* TODO: HT rates */
+	else
+		rate = &sband->bitrates[status.rate_idx];
+	__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
+				     &status, rate);
+	tid_agg_rx->stored_mpdu_num--;
+	tid_agg_rx->reorder_buf[index] = NULL;
+
+no_frame:
+	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+}
+
+
 /*
  * As it function blongs to Rx path it must be called with
  * the proper rcu_read_lock protection for its flow.
@@ -2295,12 +2323,8 @@ static u8 ieee80211_sta_manage_reorder_b
 					   u16 mpdu_seq_num,
 					   int bar_req)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rx_status status;
 	u16 head_seq_num, buf_size;
 	int index;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate;
 
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
@@ -2325,28 +2349,8 @@ static u8 ieee80211_sta_manage_reorder_b
 			index = seq_sub(tid_agg_rx->head_seq_num,
 				tid_agg_rx->ssn)
 				% tid_agg_rx->buf_size;
-
-			if (tid_agg_rx->reorder_buf[index]) {
-				/* release the reordered frames to stack */
-				memcpy(&status,
-					tid_agg_rx->reorder_buf[index]->cb,
-					sizeof(status));
-				sband = local->hw.wiphy->bands[status.band];
-				if (status.flag & RX_FLAG_HT) {
-					/* TODO: HT rates */
-					rate = sband->bitrates;
-				} else {
-					rate = &sband->bitrates
-						[status.rate_idx];
-				}
-				__ieee80211_rx_handle_packet(hw,
-					tid_agg_rx->reorder_buf[index],
-					&status, rate);
-				tid_agg_rx->stored_mpdu_num--;
-				tid_agg_rx->reorder_buf[index] = NULL;
-			}
-			tid_agg_rx->head_seq_num =
-				seq_inc(tid_agg_rx->head_seq_num);
+			ieee80211_release_reorder_frame(hw, tid_agg_rx,
+							index);
 		}
 		if (bar_req)
 			return 1;
@@ -2373,26 +2377,49 @@ static u8 ieee80211_sta_manage_reorder_b
 
 	/* put the frame in the reordering buffer */
 	tid_agg_rx->reorder_buf[index] = skb;
+	tid_agg_rx->reorder_time[index] = jiffies;
 	memcpy(tid_agg_rx->reorder_buf[index]->cb, rxstatus,
 	       sizeof(*rxstatus));
 	tid_agg_rx->stored_mpdu_num++;
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
 						% tid_agg_rx->buf_size;
-	while (tid_agg_rx->reorder_buf[index]) {
-		/* release the reordered frame back to stack */
-		memcpy(&status, tid_agg_rx->reorder_buf[index]->cb,
-			sizeof(status));
-		sband = local->hw.wiphy->bands[status.band];
-		if (status.flag & RX_FLAG_HT)
-			rate = sband->bitrates; /* TODO: HT rates */
-		else
-			rate = &sband->bitrates[status.rate_idx];
-		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
-					     &status, rate);
-		tid_agg_rx->stored_mpdu_num--;
-		tid_agg_rx->reorder_buf[index] = NULL;
-		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+	if (!tid_agg_rx->reorder_buf[index] &&
+	    tid_agg_rx->stored_mpdu_num > 1) {
+		/*
+		 * No buffers ready to be released, but check whether any
+		 * frames in the reorder buffer have timed out.
+		 */
+		int j;
+		int skipped = 1;
+		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
+		     j = (j + 1) % tid_agg_rx->buf_size) {
+			if (tid_agg_rx->reorder_buf[j] == NULL) {
+				skipped++;
+				continue;
+			}
+			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
+					HZ / 10))
+				break;
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: release timed "
+				       "out RX reorder frame\n",
+				       wiphy_name(hw->wiphy));
+#endif
+			ieee80211_release_reorder_frame(hw, tid_agg_rx, j);
+
+			/*
+			 * Increment the head seq# also for the skipped slots.
+			 */
+			tid_agg_rx->head_seq_num =
+				(tid_agg_rx->head_seq_num + skipped) &
+				SEQ_MASK;
+			skipped = 0;
+		}
+	} else while (tid_agg_rx->reorder_buf[index]) {
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
 		index =	seq_sub(tid_agg_rx->head_seq_num,
 			tid_agg_rx->ssn) % tid_agg_rx->buf_size;
 	}
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-04-29 18:37:26.000000000 +0300
+++ wireless-testing/net/mac80211/sta_info.h	2009-04-29 18:38:06.000000000 +0300
@@ -88,6 +88,7 @@ struct tid_ampdu_tx {
  * struct tid_ampdu_rx - TID aggregation information (Rx).
  *
  * @reorder_buf: buffer to reorder incoming aggregated MPDUs
+ * @reorder_time: jiffies when skb was added
  * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
  * @head_seq_num: head sequence number in reordering buffer.
  * @stored_mpdu_num: number of MPDUs in reordering buffer
@@ -99,6 +100,7 @@ struct tid_ampdu_tx {
  */
 struct tid_ampdu_rx {
 	struct sk_buff **reorder_buf;
+	unsigned long *reorder_time;
 	struct timer_list session_timer;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;

-- 
Jouni Malinen                                            PGP id EFC895FA
