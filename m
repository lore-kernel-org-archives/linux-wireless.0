Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37114 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3BDRor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:44:47 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so2880126bkc.11
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 09:44:46 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual interface
Date: Mon, 4 Feb 2013 18:44:44 +0100
Cc: Amit Shakya <amit.shakya@stericsson.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com> <201302041814.11894.chunkeey@googlemail.com> <1359999018.17993.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359999018.17993.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302041844.44436.chunkeey@googlemail.com> (sfid-20130204_184451_157654_38F66EFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 04, 2013 06:30:18 PM Johannes Berg wrote:
> On Mon, 2013-02-04 at 18:14 +0100, Christian Lamparter wrote:
> > On Monday, February 04, 2013 04:28:28 PM Johannes Berg wrote:
> > > On Mon, 2013-02-04 at 16:48 +0530, Amit Shakya wrote:
> > > > @@ -2790,7 +2791,20 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
> > > >  
> > > >     rx->local->running_rx_handler = true;
> > > >  
> > > > -   while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
> > > > +   skb_queue_walk_safe(&rx->local->rx_skb_queue, skb, tmp) {
> > > > +           if (!skb)
> > > > +                   break;
> > > > +           hdr = (struct ieee80211_hdr *) skb->data;
> > > > +           /*
> > > > +           * Additional check to ensure that the packets corresponding
> > > > +           * to same sta entry as in rx->sta are de-queued. The queue
> > > > +           * can have different interface packets in case of multiple vifs
> > > > +           */
> > > > +           if ((rx->sta && hdr) && (ieee80211_is_data(hdr->frame_control))
> > > > +                   && (memcmp(rx->sta->sta.addr, hdr->addr2, ETH_ALEN)))
> > > > +                                   continue;
> > > > +           __skb_unlink(skb, &rx->local->rx_skb_queue);
> > > 
> > > Christian, is there any reason to not just have the queue be on the
> > > stack, and use a separate spinlock in the local struct to lock out the
> > > unwanted concurrency?
> 
> > Let's see.
> > 
> > The original "AMPDU rx reorder timeout timer" had the rx_skb_queue (frames)
> > on the stack. But that didn't work because the rx-path isn't thread-safe. This
> > issue was addressed by "mac80211: serialize rx path workers" (24a8fda). 
> 
> It seems this actually caused the problem, because this part:
> 
>     Only one active rx handler worker [ieee80211_rx_handlers]
>     is needed. All other threads which have lost the race of
>     "runnning_rx_handler" can now simply "return", knowing that
>     the thread who had the "edge" will also take care of their
>     workload.
> 
> forgot to account for the fact that the on-stack versions of "struct
> ieee80211_rx_data" can be different. Right?
Yes, sdata and sta can be different.

> > Interestingly, the RFC [1] of this patch mentioned the reason why I/we didn't
> > go for a rx-path lock:
> > "       1. Locking is easy to implement but hard to maintain.
> >            Furthermore, Johannes worked very hard to get rid
> >            of as many as possible."
> > 
> > > It seems to me that should work just as well, since there are never frames
> > > on the rx_skb_queue for very long, right?
> > Yes it should. At least we didn't find anything wrong with it back then.
> 
> But ... that doesn't necessarily mean an RX path lock, does it? 
> 
> I mean, in order to fix the above, we *do* have to make the RX
> tasklet/timer wait for each other. So it's not really a big difference
> between what we do now and having one of them block, is it? I guess that
> they can still do all the local work, and then call the RX handlers with
> the lock held? Hmm. That does kinda mean an RX path lock :-)

See the attached patch. It compiles, but I can't test it right now.

Regards,
	Christian

---
mac80211: protect rx-path with spinlock

(Text is from "Fix PN corruption in case of multiple virtual interface"
with a little modification => "same sdata and sta")

In case, ieee80211_rx_handlers processing is going on for skbs received on
one vif and at the same time, rx aggregation reorder timer expires on
another vif then sta_rx_agg_reorder_timer_expired is invoked and it will
push skbs into the single queue (local->rx_skb_queue).
ieee80211_rx_handlers in the while loop assumes that the skbs are for the
same sdata and sta. This assumption doesn't hold good in this scenario
and the PN gets corrupted by PN received in other vif's skb, causing
traffic to stop due to PN mismatch.

---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5fba867..11a520b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -986,14 +986,7 @@ struct ieee80211_local {
 	struct sk_buff_head skb_queue;
 	struct sk_buff_head skb_queue_unreliable;
 
-	/*
-	 * Internal FIFO queue which is shared between multiple rx path
-	 * stages. Its main task is to provide a serialization mechanism,
-	 * so all rx handlers can enjoy having exclusive access to their
-	 * private data structures.
-	 */
-	struct sk_buff_head rx_skb_queue;
-	bool running_rx_handler;	/* protected by rx_skb_queue.lock */
+	spinlock_t rx_handler;
 
 	/* Station data */
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2bdd454..6517dd5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -34,8 +34,6 @@
 #include "cfg.h"
 #include "debugfs.h"
 
-static struct lock_class_key ieee80211_rx_skb_queue_class;
-
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	u64 mc;
@@ -613,21 +611,12 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	mutex_init(&local->key_mtx);
 	spin_lock_init(&local->filter_lock);
+	spin_lock_init(&local->rx_handler);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
 
-	/*
-	 * The rx_skb_queue is only accessed from tasklets,
-	 * but other SKB queues are used from within IRQ
-	 * context. Therefore, this one needs a different
-	 * locking class so our direct, non-irq-safe use of
-	 * the queue's lock doesn't throw lockdep warnings.
-	 */
-	skb_queue_head_init_class(&local->rx_skb_queue,
-				  &ieee80211_rx_skb_queue_class);
-
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
@@ -1089,7 +1078,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 		wiphy_warn(local->hw.wiphy, "skb_queue not empty\n");
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
-	skb_queue_purge(&local->rx_skb_queue);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a190895..c52b15d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -668,9 +668,9 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
 
 static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 					    struct tid_ampdu_rx *tid_agg_rx,
-					    int index)
+					    int index,
+					    struct sk_buff_head *frames)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
 	struct ieee80211_rx_status *status;
 
@@ -684,7 +684,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 	tid_agg_rx->reorder_buf[index] = NULL;
 	status = IEEE80211_SKB_RXCB(skb);
 	status->rx_flags |= IEEE80211_RX_DEFERRED_RELEASE;
-	skb_queue_tail(&local->rx_skb_queue, skb);
+	__skb_queue_tail(frames, skb);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
@@ -692,7 +692,8 @@ no_frame:
 
 static void ieee80211_release_reorder_frames(struct ieee80211_sub_if_data *sdata,
 					     struct tid_ampdu_rx *tid_agg_rx,
-					     u16 head_seq_num)
+					     u16 head_seq_num,
+					     struct sk_buff_head *frames)
 {
 	int index;
 
@@ -701,7 +702,8 @@ static void ieee80211_release_reorder_frames(struct ieee80211_sub_if_data *sdata
 	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
 		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
-		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index);
+		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index,
+						frames);
 	}
 }
 
@@ -717,7 +719,8 @@ static void ieee80211_release_reorder_frames(struct ieee80211_sub_if_data *sdata
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
 static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
-					  struct tid_ampdu_rx *tid_agg_rx)
+					  struct tid_ampdu_rx *tid_agg_rx,
+					  struct sk_buff_head *frames)
 {
 	int index, j;
 
@@ -746,7 +749,8 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 
 			ht_dbg_ratelimited(sdata,
 					   "release an RX reorder frame due to timeout on earlier frames\n");
-			ieee80211_release_reorder_frame(sdata, tid_agg_rx, j);
+			ieee80211_release_reorder_frame(sdata, tid_agg_rx, j,
+							frames);
 
 			/*
 			 * Increment the head seq# also for the skipped slots.
@@ -756,7 +760,8 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 			skipped = 0;
 		}
 	} else while (tid_agg_rx->reorder_buf[index]) {
-		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index);
+		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index,
+						frames);
 		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
@@ -788,7 +793,8 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
  */
 static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata,
 					     struct tid_ampdu_rx *tid_agg_rx,
-					     struct sk_buff *skb)
+					     struct sk_buff *skb,
+					     struct sk_buff_head *frames)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 sc = le16_to_cpu(hdr->seq_ctrl);
@@ -816,7 +822,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
 		/* release stored frames up to new head to stack */
 		ieee80211_release_reorder_frames(sdata, tid_agg_rx,
-						 head_seq_num);
+						 head_seq_num, frames);
 	}
 
 	/* Now the new frame is always in the range of the reordering buffer */
@@ -846,7 +852,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 	tid_agg_rx->reorder_buf[index] = skb;
 	tid_agg_rx->reorder_time[index] = jiffies;
 	tid_agg_rx->stored_mpdu_num++;
-	ieee80211_sta_reorder_release(sdata, tid_agg_rx);
+	ieee80211_sta_reorder_release(sdata, tid_agg_rx, frames);
 
  out:
 	spin_unlock(&tid_agg_rx->reorder_lock);
@@ -857,7 +863,8 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
  * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
  * true if the MPDU was buffered, false if it should be processed.
  */
-static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
+static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
+				       struct sk_buff_head *frames)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_local *local = rx->local;
@@ -922,11 +929,12 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	 * sure that we cannot get to it any more before doing
 	 * anything with it.
 	 */
-	if (ieee80211_sta_manage_reorder_buf(rx->sdata, tid_agg_rx, skb))
+	if (ieee80211_sta_manage_reorder_buf(rx->sdata, tid_agg_rx, skb,
+					     frames))
 		return;
 
  dont_reorder:
-	skb_queue_tail(&local->rx_skb_queue, skb);
+	__skb_queue_tail(frames, skb);
 }
 
 static ieee80211_rx_result debug_noinline
@@ -2177,7 +2185,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_bar *bar = (struct ieee80211_bar *)skb->data;
@@ -2216,7 +2224,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
 		ieee80211_release_reorder_frames(rx->sdata, tid_agg_rx,
-						 start_seq_num);
+						 start_seq_num, frames);
 		spin_unlock(&tid_agg_rx->reorder_lock);
 
 		kfree_skb(skb);
@@ -2801,7 +2809,8 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	}
 }
 
-static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
+static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
+				  struct sk_buff_head *frames)
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 	struct sk_buff *skb;
@@ -2813,15 +2822,9 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 			goto rxh_next;  \
 	} while (0);
 
-	spin_lock(&rx->local->rx_skb_queue.lock);
-	if (rx->local->running_rx_handler)
-		goto unlock;
-
-	rx->local->running_rx_handler = true;
-
-	while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
-		spin_unlock(&rx->local->rx_skb_queue.lock);
+	spin_lock_bh(&rx->local->rx_handler);
 
+	while ((skb = __skb_dequeue(frames))) {
 		/*
 		 * all the other fields are valid across frames
 		 * that belong to an aMPDU since they are on the
@@ -2842,7 +2845,12 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 #endif
 		CALL_RXH(ieee80211_rx_h_amsdu)
 		CALL_RXH(ieee80211_rx_h_data)
-		CALL_RXH(ieee80211_rx_h_ctrl);
+
+		/* special treatment -- needs the queue */
+		res = ieee80211_rx_h_ctrl(rx, frames);
+		if (res != RX_CONTINUE)
+			goto rxh_next;
+
 		CALL_RXH(ieee80211_rx_h_mgmt_check)
 		CALL_RXH(ieee80211_rx_h_action)
 		CALL_RXH(ieee80211_rx_h_userspace_mgmt)
@@ -2851,20 +2859,20 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 
  rxh_next:
 		ieee80211_rx_handlers_result(rx, res);
-		spin_lock(&rx->local->rx_skb_queue.lock);
+
 #undef CALL_RXH
 	}
 
-	rx->local->running_rx_handler = false;
-
- unlock:
-	spin_unlock(&rx->local->rx_skb_queue.lock);
+	spin_unlock_bh(&rx->local->rx_handler);
 }
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 {
+	struct sk_buff_head reorder_release;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
+	__skb_queue_head_init(&reorder_release);
+
 #define CALL_RXH(rxh)			\
 	do {				\
 		res = rxh(rx);		\
@@ -2874,9 +2882,9 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 
 	CALL_RXH(ieee80211_rx_h_check)
 
-	ieee80211_rx_reorder_ampdu(rx);
+	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
 
-	ieee80211_rx_handlers(rx);
+	ieee80211_rx_handlers(rx, &reorder_release);
 	return;
 
  rxh_next:
@@ -2891,6 +2899,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
  */
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 {
+	struct sk_buff_head frames;
 	struct ieee80211_rx_data rx = {
 		.sta = sta,
 		.sdata = sta->sdata,
@@ -2906,11 +2915,13 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	if (!tid_agg_rx)
 		return;
 
+	__skb_queue_head_init(&frames);
+
 	spin_lock(&tid_agg_rx->reorder_lock);
-	ieee80211_sta_reorder_release(sta->sdata, tid_agg_rx);
+	ieee80211_sta_reorder_release(sta->sdata, tid_agg_rx, &frames);
 	spin_unlock(&tid_agg_rx->reorder_lock);
 
-	ieee80211_rx_handlers(&rx);
+	ieee80211_rx_handlers(&rx, &frames);
 }
 
 /* main receive path */

