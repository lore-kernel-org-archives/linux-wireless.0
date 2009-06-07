Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbZFGT6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 15:58:37 -0400
Subject: [PATCH] mac80211: do not pass PS frames out of mac80211 again
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 21:58:37 +0200
Message-Id: <1244404717.12956.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to handle powersave frames properly we had needed
to pass these out to the device queues again, and introduce
the skb->requeue bit. This, however, also has unnecessary
overhead by needing to 'clean up' already tried frames, and
this clean-up code is also buggy when software encryption
is used.

Instead of sending the frames via the master netdev queue
again, simply put them into the pending queue. This also
fixes a problem where frames for that particular station
could be reordered when some were still on the software
queues and older ones are re-injected into the software
queue after them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
In a sense this is a fix for code in .31, but we've had the
problem for a long time and nobody really noticed or cared.

 include/linux/skbuff.h     |    4 --
 include/net/mac80211.h     |    3 ++
 net/core/skbuff.c          |    1 
 net/mac80211/ieee80211_i.h |    5 +++
 net/mac80211/main.c        |   61 ++++-----------------------------------------
 net/mac80211/rx.c          |   25 ++++++------------
 net/mac80211/tx.c          |    3 +-
 net/mac80211/util.c        |   46 +++++++++++++++++++++++++++++++++
 net/mac80211/wme.c         |    2 -
 9 files changed, 72 insertions(+), 78 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-06-06 19:47:19.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-06-07 21:49:55.000000000 +0200
@@ -239,6 +239,8 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_NEED_TXPROCESSING: completely internal to mac80211,
  *	used to indicate that a pending frame requires TX processing before
  *	it can be sent out.
+ * @IEEE80211_TX_INTFL_RETRIED: completely internal to mac80211,
+ *	used to indicate that a frame was already retried due to PS
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -256,6 +258,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
 	IEEE80211_TX_INTFL_RCALGO		= BIT(13),
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
+	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-06-06 19:47:19.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-06-07 21:49:55.000000000 +0200
@@ -589,6 +589,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_PENDING,
+	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 };
 
 struct ieee80211_master_priv {
@@ -1121,6 +1122,10 @@ void ieee80211_wake_queue_by_reason(stru
 				    enum queue_stop_reason reason);
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
+void ieee80211_add_pending_skb(struct ieee80211_local *local,
+			       struct sk_buff *skb);
+int ieee80211_add_pending_skbs(struct ieee80211_local *local,
+			       struct sk_buff_head *skbs);
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
--- wireless-testing.orig/net/mac80211/main.c	2009-06-06 19:47:19.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-06-07 21:49:55.000000000 +0200
@@ -369,60 +369,12 @@ static void ieee80211_tasklet_handler(un
 	}
 }
 
-/* Remove added headers (e.g., QoS control), encryption header/MIC, etc. to
- * make a prepared TX frame (one that has been given to hw) to look like brand
- * new IEEE 802.11 frame that is ready to go through TX processing again.
- */
-static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
-				      struct ieee80211_key *key,
-				      struct sk_buff *skb)
-{
-	unsigned int hdrlen, iv_len, mic_len;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
-	if (!key)
-		goto no_key;
-
-	switch (key->conf.alg) {
-	case ALG_WEP:
-		iv_len = WEP_IV_LEN;
-		mic_len = WEP_ICV_LEN;
-		break;
-	case ALG_TKIP:
-		iv_len = TKIP_IV_LEN;
-		mic_len = TKIP_ICV_LEN;
-		break;
-	case ALG_CCMP:
-		iv_len = CCMP_HDR_LEN;
-		mic_len = CCMP_MIC_LEN;
-		break;
-	default:
-		goto no_key;
-	}
-
-	if (skb->len >= hdrlen + mic_len &&
-	    !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		skb_trim(skb, skb->len - mic_len);
-	if (skb->len >= hdrlen + iv_len) {
-		memmove(skb->data + iv_len, skb->data, hdrlen);
-		hdr = (struct ieee80211_hdr *)skb_pull(skb, iv_len);
-	}
-
-no_key:
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
-		memmove(skb->data + IEEE80211_QOS_CTL_LEN, skb->data,
-			hdrlen - IEEE80211_QOS_CTL_LEN);
-		skb_pull(skb, IEEE80211_QOS_CTL_LEN);
-	}
-}
-
 static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 					    struct sta_info *sta,
 					    struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
 	sta->tx_filtered_count++;
 
 	/*
@@ -464,16 +416,15 @@ static void ieee80211_handle_filtered_fr
 	 */
 	if (test_sta_flags(sta, WLAN_STA_PS) &&
 	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
-		ieee80211_remove_tx_extra(local, sta->key, skb);
 		skb_queue_tail(&sta->tx_filtered, skb);
 		return;
 	}
 
-	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
+	if (!test_sta_flags(sta, WLAN_STA_PS) &&
+	    !(info->flags & IEEE80211_TX_INTFL_RETRIED)) {
 		/* Software retry the packet once */
-		skb->requeue = 1;
-		ieee80211_remove_tx_extra(local, sta->key, skb);
-		dev_queue_xmit(skb);
+		info->flags |= IEEE80211_TX_INTFL_RETRIED;
+		ieee80211_add_pending_skb(local, skb);
 		return;
 	}
 
--- wireless-testing.orig/net/mac80211/rx.c	2009-06-07 21:32:35.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-06-07 21:49:55.000000000 +0200
@@ -797,8 +797,7 @@ static int ap_sta_ps_end(struct sta_info
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	int sent = 0;
+	int sent, buffered;
 
 	atomic_dec(&sdata->bss->num_sta_ps);
 
@@ -814,22 +813,16 @@ static int ap_sta_ps_end(struct sta_info
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
 	/* Send all buffered frames to the station */
-	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-		sent++;
-		skb->requeue = 1;
-		dev_queue_xmit(skb);
-	}
-	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		local->total_ps_buffered--;
-		sent++;
+	sent = ieee80211_add_pending_skbs(local, &sta->tx_filtered);
+	buffered = ieee80211_add_pending_skbs(local, &sta->ps_tx_buf);
+	sent += buffered;
+	local->total_ps_buffered -= buffered;
+
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		printk(KERN_DEBUG "%s: STA %pM aid %d send PS frame "
-		       "since STA not sleeping anymore\n", sdata->dev->name,
-		       sta->sta.addr, sta->sta.aid);
+	printk(KERN_DEBUG "%s: STA %pM aid %d sending %d filtered/%d PS frames "
+	       "since STA not sleeping anymore\n", sdata->dev->name,
+	       sta->sta.addr, sta->sta.aid, sent - buffered, buffered);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-		skb->requeue = 1;
-		dev_queue_xmit(skb);
-	}
 
 	return sent;
 }
--- wireless-testing.orig/net/mac80211/tx.c	2009-06-07 21:32:35.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-06-07 21:49:55.000000000 +0200
@@ -400,6 +400,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 			sta_info_set_tim_bit(sta);
 
 		info->control.jiffies = jiffies;
+		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
 		return TX_QUEUED;
 	}
@@ -420,7 +421,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		 * frame filtering and keeps a station  blacklist on its own
 		 * (e.g: p54), so that frames can be delivered unimpeded.
 		 *
-		 * Note: It should be save to disable the filter now.
+		 * Note: It should be safe to disable the filter now.
 		 * As, it is really unlikely that we still have any pending
 		 * frame for this station in the hw's buffers/fifos left,
 		 * that is not rejected with a unsuccessful tx_status yet.
--- wireless-testing.orig/net/mac80211/util.c	2009-06-06 19:47:19.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-06-07 21:49:55.000000000 +0200
@@ -341,6 +341,52 @@ void ieee80211_stop_queue(struct ieee802
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
+void ieee80211_add_pending_skb(struct ieee80211_local *local,
+			       struct sk_buff *skb)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	unsigned long flags;
+	int queue = skb_get_queue_mapping(skb);
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_PENDING);
+	skb_queue_tail(&local->pending[queue], skb);
+	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+int ieee80211_add_pending_skbs(struct ieee80211_local *local,
+			       struct sk_buff_head *skbs)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct sk_buff *skb;
+	unsigned long flags;
+	int queue, ret = 0, i;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	for (i = 0; i < hw->queues; i++)
+		__ieee80211_stop_queue(hw, i,
+			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+
+	while ((skb = skb_dequeue(skbs))) {
+		ret++;
+		queue = skb_get_queue_mapping(skb);
+		skb_queue_tail(&local->pending[queue], skb);
+	}
+
+	for (i = 0; i < hw->queues; i++) {
+		if (ret)
+			__ieee80211_stop_queue(hw, i,
+				IEEE80211_QUEUE_STOP_REASON_PENDING);
+		__ieee80211_wake_queue(hw, i,
+			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+	}
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
+	return ret;
+}
+
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				    enum queue_stop_reason reason)
 {
--- wireless-testing.orig/net/mac80211/wme.c	2009-06-06 19:47:19.000000000 +0200
+++ wireless-testing/net/mac80211/wme.c	2009-06-07 21:49:55.000000000 +0200
@@ -101,7 +101,7 @@ u16 ieee80211_select_queue(struct net_de
 	 * Now we know the 1d priority, fill in the QoS header if
 	 * there is one (and we haven't done this before).
 	 */
-	if (!skb->requeue && ieee80211_is_data_qos(hdr->frame_control)) {
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
 		u8 ack_policy = 0;
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
--- wireless-testing.orig/include/linux/skbuff.h	2009-06-06 19:47:19.000000000 +0200
+++ wireless-testing/include/linux/skbuff.h	2009-06-07 21:49:55.000000000 +0200
@@ -301,9 +301,6 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_verd: traffic control verdict
  *	@ndisc_nodetype: router type (from link layer)
  *	@do_not_encrypt: set to prevent encryption of this frame
- *	@requeue: set to indicate that the wireless core should attempt
- *		a software retry on this frame if we failed to
- *		receive an ACK for it
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
@@ -380,7 +377,6 @@ struct sk_buff {
 #endif
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
 	__u8			do_not_encrypt:1;
-	__u8			requeue:1;
 #endif
 	/* 0/13/14 bit hole */
 
--- wireless-testing.orig/net/core/skbuff.c	2009-06-06 19:47:19.000000000 +0200
+++ wireless-testing/net/core/skbuff.c	2009-06-07 21:49:55.000000000 +0200
@@ -577,7 +577,6 @@ static struct sk_buff *__skb_clone(struc
 	C(truesize);
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
 	C(do_not_encrypt);
-	C(requeue);
 #endif
 	atomic_set(&n->users, 1);
 


