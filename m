Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54561 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625AbZEERf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 13:35:57 -0400
Message-Id: <20090505173550.273830766@atheros.com>
References: <20090505173512.349795688@atheros.com>
Date: Tue, 05 May 2009 20:35:14 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/3] mac80211: Add a timeout for frames in the RX reorder buffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows skbs to be released from the RX reorder buffer in
case they have been there for an unexpectedly long time without us
having received the missing frames before them. Previously, these
frames were only released when the reorder window moved and that could
take very long time unless new frames were received constantly (e.g.,
TCP connections could be killed more or less indefinitely).

This situation should not happen very frequently, but it looks like
there are some scenarious that trigger it for some reason. As such,
this should be considered mostly a workaround to speed up recovery
from unexpected siutation that could result in connections hanging for
long periods of time.

The changes here will only check for timeout situation when adding new
RX frames to the reorder buffer. It does not handle all possible
cases, but seems to help for most cases that could result from common
network usage (e.g., TCP retrying at least couple of times). For more
completely coverage, a timer could be used to periodically check
whether there are any frames remaining in the reorder buffer if no new
frames are received.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/agg-rx.c   |    8 +++++++-
 net/mac80211/rx.c       |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |    2 ++
 3 files changed, 55 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-04-29 17:10:10.000000000 +0300
+++ wireless-testing/net/mac80211/agg-rx.c	2009-05-05 20:21:33.000000000 +0300
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
 
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-04-21 15:34:55.000000000 +0300
+++ wireless-testing/net/mac80211/sta_info.h	2009-05-05 20:21:33.000000000 +0300
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
--- wireless-testing.orig/net/mac80211/rx.c	2009-05-05 20:21:24.000000000 +0300
+++ wireless-testing/net/mac80211/rx.c	2009-05-05 20:26:31.000000000 +0300
@@ -2313,6 +2313,15 @@ no_frame:
 
 
 /*
+ * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
+ * the skb was added to the buffer longer than this time ago, the earlier
+ * frames that have not yet been received are assumed to be lost and the skb
+ * can be released for processing. This may also release other skb's from the
+ * reorder buffer if there are no additional gaps between the frames.
+ */
+#define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
+
+/*
  * As it function blongs to Rx path it must be called with
  * the proper rcu_read_lock protection for its flow.
  */
@@ -2377,13 +2386,49 @@ static u8 ieee80211_sta_manage_reorder_b
 
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
+				printk(KERN_DEBUG "%s: release an RX reorder "
+				       "frame due to timeout on earlier "
+				       "frames\n",
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
 		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
 		index =	seq_sub(tid_agg_rx->head_seq_num,
 			tid_agg_rx->ssn) % tid_agg_rx->buf_size;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
