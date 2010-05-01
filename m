Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59270 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab0EAQS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 12:18:27 -0400
Received: by fxm10 with SMTP id 10so1032867fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 09:18:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170usb: remove deprecated aggregation code
Date: Sat, 1 May 2010 18:18:18 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005011818.19205.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the incomplete AMPDU implementation in ar9170usb.

The code in question is:
 * too big and complex (more than 550 SLOC.)
   This is enough to qualify for a new separate code file!

 * unbalanced quantity & quality
	over-engineered areas like:
		* xmit scheduling and queuing frames for multiple HT peers
		* redundant frame sorting
	are confronted by gaping holes:
		* accurate transmission feedback
		* firmware error-handling and device reset
		* HT rate control algorithm
		  
 * error-prone
	Since its inclusion, hardly anything was done to fix 
	any of the outlined flaws from the initial commit message.

   => This also indicates poor maintainability.

 * relies heavily on several spinlocks.

As a result of this shortcomings, the code is slow and does not
even support the most basic 11n requirement: HT station mode.

Therefore, I request to purge my heap of **** from the kernel:
"ar9170: implement transmit aggregation".

The next item on the agenda is: (re-)start from scratch with
an adequate design to accommodate the special requirements
and features of the available frameworks and tools.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Note:

While this 'generic' ampdu implementation has failed to deliver
for ar9170usb, it is performing rather well in a different project
called" carl9170". Don't confuse these two.
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index dc662b7..4f845f8 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -109,41 +109,6 @@ struct ar9170_rxstream_mpdu_merge {
 	bool has_plcp;
 };
 
-#define AR9170_NUM_TID	16
-#define WME_BA_BMP_SIZE         64
-#define AR9170_NUM_MAX_AGG_LEN	(2 * WME_BA_BMP_SIZE)
-
-#define WME_AC_BE   2
-#define WME_AC_BK   3
-#define WME_AC_VI   1
-#define WME_AC_VO   0
-
-#define TID_TO_WME_AC(_tid)				\
-	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
-	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
-	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
-	 WME_AC_VO)
-
-#define BAW_WITHIN(_start, _bawsz, _seqno) \
-	((((_seqno) - (_start)) & 0xfff) < (_bawsz))
-
-enum ar9170_tid_state {
-	AR9170_TID_STATE_INVALID,
-	AR9170_TID_STATE_SHUTDOWN,
-	AR9170_TID_STATE_PROGRESS,
-	AR9170_TID_STATE_COMPLETE,
-};
-
-struct ar9170_sta_tid {
-	struct list_head list;
-	struct sk_buff_head queue;
-	u8 addr[ETH_ALEN];
-	u16 ssn;
-	u16 tid;
-	enum ar9170_tid_state state;
-	bool active;
-};
-
 struct ar9170_tx_queue_stats {
 	unsigned int len;
 	unsigned int limit;
@@ -152,14 +117,11 @@ struct ar9170_tx_queue_stats {
 
 #define AR9170_QUEUE_TIMEOUT		64
 #define AR9170_TX_TIMEOUT		8
-#define AR9170_BA_TIMEOUT		4
 #define AR9170_JANITOR_DELAY		128
 #define AR9170_TX_INVALID_RATE		0xffffffff
 
-#define AR9170_NUM_TX_STATUS		128
-#define AR9170_NUM_TX_AGG_MAX		30
-#define AR9170_NUM_TX_LIMIT_HARD       AR9170_TXQ_DEPTH
-#define AR9170_NUM_TX_LIMIT_SOFT       (AR9170_TXQ_DEPTH - 10)
+#define AR9170_NUM_TX_LIMIT_HARD	AR9170_TXQ_DEPTH
+#define AR9170_NUM_TX_LIMIT_SOFT	(AR9170_TXQ_DEPTH - 10)
 
 struct ar9170 {
 	struct ieee80211_hw *hw;
@@ -234,11 +196,6 @@ struct ar9170 {
 	struct sk_buff_head tx_pending[__AR9170_NUM_TXQ];
 	struct sk_buff_head tx_status[__AR9170_NUM_TXQ];
 	struct delayed_work tx_janitor;
-	/* tx ampdu */
-	struct sk_buff_head tx_status_ampdu;
-	spinlock_t tx_ampdu_list_lock;
-	struct list_head tx_ampdu_list;
-	atomic_t tx_ampdu_pending;
 
 	/* rxstream mpdu merge */
 	struct ar9170_rxstream_mpdu_merge rx_mpdu;
@@ -250,11 +207,6 @@ struct ar9170 {
 	u8 global_ampdu_factor;
 };
 
-struct ar9170_sta_info {
-	struct ar9170_sta_tid agg[AR9170_NUM_TID];
-	unsigned int ampdu_max_len;
-};
-
 struct ar9170_tx_info {
 	unsigned long timeout;
 };
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index f57e7c6..b68f317 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -50,10 +50,6 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-static int modparam_ht;
-module_param_named(ht, modparam_ht, bool, S_IRUGO);
-MODULE_PARM_DESC(ht, "enable MPDU aggregation.");
-
 #define RATE(_bitrate, _hw_rate, _txpidx, _flags) {	\
 	.bitrate	= (_bitrate),			\
 	.flags		= (_flags),			\
@@ -182,7 +178,6 @@ static struct ieee80211_supported_band ar9170_band_5GHz = {
 };
 
 static void ar9170_tx(struct ar9170 *ar);
-static bool ar9170_tx_ampdu(struct ar9170 *ar);
 
 static inline u16 ar9170_get_seq_h(struct ieee80211_hdr *hdr)
 {
@@ -195,21 +190,7 @@ static inline u16 ar9170_get_seq(struct sk_buff *skb)
 	return ar9170_get_seq_h((void *) txc->frame_data);
 }
 
-static inline u16 ar9170_get_tid_h(struct ieee80211_hdr *hdr)
-{
-	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
-}
-
-static inline u16 ar9170_get_tid(struct sk_buff *skb)
-{
-	struct ar9170_tx_control *txc = (void *) skb->data;
-	return ar9170_get_tid_h((struct ieee80211_hdr *) txc->frame_data);
-}
-
-#define GET_NEXT_SEQ(seq)	((seq + 1) & 0x0fff)
-#define GET_NEXT_SEQ_FROM_SKB(skb)	(GET_NEXT_SEQ(ar9170_get_seq(skb)))
-
-#if (defined AR9170_QUEUE_DEBUG) || (defined AR9170_TXAGG_DEBUG)
+#ifdef AR9170_QUEUE_DEBUG
 static void ar9170_print_txheader(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ar9170_tx_control *txc = (void *) skb->data;
@@ -244,7 +225,7 @@ static void __ar9170_dump_txqueue(struct ar9170 *ar,
 		       "mismatch %d != %d\n", skb_queue_len(queue), i);
 	printk(KERN_DEBUG "---[ end ]---\n");
 }
-#endif /* AR9170_QUEUE_DEBUG || AR9170_TXAGG_DEBUG */
+#endif /* AR9170_QUEUE_DEBUG */
 
 #ifdef AR9170_QUEUE_DEBUG
 static void ar9170_dump_txqueue(struct ar9170 *ar,
@@ -275,20 +256,6 @@ static void __ar9170_dump_txstats(struct ar9170 *ar)
 }
 #endif /* AR9170_QUEUE_STOP_DEBUG */
 
-#ifdef AR9170_TXAGG_DEBUG
-static void ar9170_dump_tx_status_ampdu(struct ar9170 *ar)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ar->tx_status_ampdu.lock, flags);
-	printk(KERN_DEBUG "%s: A-MPDU tx_status queue =>\n",
-	       wiphy_name(ar->hw->wiphy));
-	__ar9170_dump_txqueue(ar, &ar->tx_status_ampdu);
-	spin_unlock_irqrestore(&ar->tx_status_ampdu.lock, flags);
-}
-
-#endif /* AR9170_TXAGG_DEBUG */
-
 /* caller must guarantee exclusive access for _bin_ queue. */
 static void ar9170_recycle_expired(struct ar9170 *ar,
 				   struct sk_buff_head *queue,
@@ -360,70 +327,6 @@ static void ar9170_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 	ieee80211_tx_status_irqsafe(ar->hw, skb);
 }
 
-static void ar9170_tx_fake_ampdu_status(struct ar9170 *ar)
-{
-	struct sk_buff_head success;
-	struct sk_buff *skb;
-	unsigned int i;
-	unsigned long queue_bitmap = 0;
-
-	skb_queue_head_init(&success);
-
-	while (skb_queue_len(&ar->tx_status_ampdu) > AR9170_NUM_TX_STATUS)
-		__skb_queue_tail(&success, skb_dequeue(&ar->tx_status_ampdu));
-
-	ar9170_recycle_expired(ar, &ar->tx_status_ampdu, &success);
-
-#ifdef AR9170_TXAGG_DEBUG
-	printk(KERN_DEBUG "%s: collected %d A-MPDU frames.\n",
-	       wiphy_name(ar->hw->wiphy), skb_queue_len(&success));
-	__ar9170_dump_txqueue(ar, &success);
-#endif /* AR9170_TXAGG_DEBUG */
-
-	while ((skb = __skb_dequeue(&success))) {
-		struct ieee80211_tx_info *txinfo;
-
-		queue_bitmap |= BIT(skb_get_queue_mapping(skb));
-
-		txinfo = IEEE80211_SKB_CB(skb);
-		ieee80211_tx_info_clear_status(txinfo);
-
-		txinfo->flags |= IEEE80211_TX_STAT_ACK;
-		txinfo->status.rates[0].count = 1;
-
-		skb_pull(skb, sizeof(struct ar9170_tx_control));
-		ieee80211_tx_status_irqsafe(ar->hw, skb);
-	}
-
-	for_each_set_bit(i, &queue_bitmap, BITS_PER_BYTE) {
-#ifdef AR9170_QUEUE_STOP_DEBUG
-		printk(KERN_DEBUG "%s: wake queue %d\n",
-		       wiphy_name(ar->hw->wiphy), i);
-		__ar9170_dump_txstats(ar);
-#endif /* AR9170_QUEUE_STOP_DEBUG */
-		ieee80211_wake_queue(ar->hw, i);
-	}
-
-	if (queue_bitmap)
-		ar9170_tx(ar);
-}
-
-static void ar9170_tx_ampdu_callback(struct ar9170 *ar, struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
-	struct ar9170_tx_info *arinfo = (void *) txinfo->rate_driver_data;
-
-	arinfo->timeout = jiffies +
-			  msecs_to_jiffies(AR9170_BA_TIMEOUT);
-
-	skb_queue_tail(&ar->tx_status_ampdu, skb);
-	ar9170_tx_fake_ampdu_status(ar);
-
-	if (atomic_dec_and_test(&ar->tx_ampdu_pending) &&
-	    !list_empty(&ar->tx_ampdu_list))
-		ar9170_tx_ampdu(ar);
-}
-
 void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -447,14 +350,10 @@ void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK) {
 		ar9170_tx_status(ar, skb, AR9170_TX_STATUS_FAILED);
 	} else {
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-			ar9170_tx_ampdu_callback(ar, skb);
-		} else {
-			arinfo->timeout = jiffies +
-				  msecs_to_jiffies(AR9170_TX_TIMEOUT);
+		arinfo->timeout = jiffies +
+			  msecs_to_jiffies(AR9170_TX_TIMEOUT);
 
-			skb_queue_tail(&ar->tx_status[queue], skb);
-		}
+		skb_queue_tail(&ar->tx_status[queue], skb);
 	}
 
 	if (!ar->tx_stats[queue].len &&
@@ -524,38 +423,6 @@ static struct sk_buff *ar9170_get_queued_skb(struct ar9170 *ar,
 	return NULL;
 }
 
-static void ar9170_handle_block_ack(struct ar9170 *ar, u16 count, u16 r)
-{
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *txinfo;
-
-	while (count) {
-		skb = ar9170_get_queued_skb(ar, NULL, &ar->tx_status_ampdu, r);
-		if (!skb)
-			break;
-
-		txinfo = IEEE80211_SKB_CB(skb);
-		ieee80211_tx_info_clear_status(txinfo);
-
-		/* FIXME: maybe more ? */
-		txinfo->status.rates[0].count = 1;
-
-		skb_pull(skb, sizeof(struct ar9170_tx_control));
-		ieee80211_tx_status_irqsafe(ar->hw, skb);
-		count--;
-	}
-
-#ifdef AR9170_TXAGG_DEBUG
-	if (count) {
-		printk(KERN_DEBUG "%s: got %d more failed mpdus, but no more "
-		       "suitable frames left in tx_status queue.\n",
-		       wiphy_name(ar->hw->wiphy), count);
-
-		ar9170_dump_tx_status_ampdu(ar);
-	}
-#endif /* AR9170_TXAGG_DEBUG */
-}
-
 /*
  * This worker tries to keeps an maintain tx_status queues.
  * So we can guarantee that incoming tx_status reports are
@@ -592,8 +459,6 @@ static void ar9170_tx_janitor(struct work_struct *work)
 			resched = true;
 	}
 
-	ar9170_tx_fake_ampdu_status(ar);
-
 	if (!resched)
 		return;
 
@@ -673,10 +538,6 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 
 	case 0xc5:
 		/* BlockACK events */
-		ar9170_handle_block_ack(ar,
-					le16_to_cpu(cmd->ba_fail_cnt.failed),
-					le16_to_cpu(cmd->ba_fail_cnt.rate));
-		ar9170_tx_fake_ampdu_status(ar);
 		break;
 
 	case 0xc6:
@@ -1247,7 +1108,6 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 	ar->global_ampdu_density = 6;
 	ar->global_ampdu_factor = 3;
 
-	atomic_set(&ar->tx_ampdu_pending, 0);
 	ar->bad_hw_nagger = jiffies;
 
 	err = ar->open(ar);
@@ -1310,40 +1170,10 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 		skb_queue_purge(&ar->tx_pending[i]);
 		skb_queue_purge(&ar->tx_status[i]);
 	}
-	skb_queue_purge(&ar->tx_status_ampdu);
 
 	mutex_unlock(&ar->mutex);
 }
 
-static void ar9170_tx_indicate_immba(struct ar9170 *ar, struct sk_buff *skb)
-{
-	struct ar9170_tx_control *txc = (void *) skb->data;
-
-	txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_IMM_AMPDU);
-}
-
-static void ar9170_tx_copy_phy(struct ar9170 *ar, struct sk_buff *dst,
-			       struct sk_buff *src)
-{
-	struct ar9170_tx_control *dst_txc, *src_txc;
-	struct ieee80211_tx_info *dst_info, *src_info;
-	struct ar9170_tx_info *dst_arinfo, *src_arinfo;
-
-	src_txc = (void *) src->data;
-	src_info = IEEE80211_SKB_CB(src);
-	src_arinfo = (void *) src_info->rate_driver_data;
-
-	dst_txc = (void *) dst->data;
-	dst_info = IEEE80211_SKB_CB(dst);
-	dst_arinfo = (void *) dst_info->rate_driver_data;
-
-	dst_txc->phy_control = src_txc->phy_control;
-
-	/* same MCS for the whole aggregate */
-	memcpy(dst_info->driver_rates, src_info->driver_rates,
-	       sizeof(dst_info->driver_rates));
-}
-
 static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
@@ -1420,14 +1250,7 @@ static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 		txc->phy_control |=
 			cpu_to_le32(queue << AR9170_TX_PHY_QOS_SHIFT);
 
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-			if (unlikely(!info->control.sta))
-				goto err_out;
-
-			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
-		} else {
-			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_RATE_PROBE);
-		}
+		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_RATE_PROBE);
 	}
 
 	return 0;
@@ -1537,158 +1360,6 @@ static void ar9170_tx_prepare_phy(struct ar9170 *ar, struct sk_buff *skb)
 	txc->phy_control |= cpu_to_le32(chains << AR9170_TX_PHY_TXCHAIN_SHIFT);
 }
 
-static bool ar9170_tx_ampdu(struct ar9170 *ar)
-{
-	struct sk_buff_head agg;
-	struct ar9170_sta_tid *tid_info = NULL, *tmp;
-	struct sk_buff *skb, *first = NULL;
-	unsigned long flags, f2;
-	unsigned int i = 0;
-	u16 seq, queue, tmpssn;
-	bool run = false;
-
-	skb_queue_head_init(&agg);
-
-	spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
-	if (list_empty(&ar->tx_ampdu_list)) {
-#ifdef AR9170_TXAGG_DEBUG
-		printk(KERN_DEBUG "%s: aggregation list is empty.\n",
-		       wiphy_name(ar->hw->wiphy));
-#endif /* AR9170_TXAGG_DEBUG */
-		goto out_unlock;
-	}
-
-	list_for_each_entry_safe(tid_info, tmp, &ar->tx_ampdu_list, list) {
-		if (tid_info->state != AR9170_TID_STATE_COMPLETE) {
-#ifdef AR9170_TXAGG_DEBUG
-			printk(KERN_DEBUG "%s: dangling aggregation entry!\n",
-			       wiphy_name(ar->hw->wiphy));
-#endif /* AR9170_TXAGG_DEBUG */
-			continue;
-		}
-
-		if (++i > 64) {
-#ifdef AR9170_TXAGG_DEBUG
-			printk(KERN_DEBUG "%s: enough frames aggregated.\n",
-			       wiphy_name(ar->hw->wiphy));
-#endif /* AR9170_TXAGG_DEBUG */
-			break;
-		}
-
-		queue = TID_TO_WME_AC(tid_info->tid);
-
-		if (skb_queue_len(&ar->tx_pending[queue]) >=
-		    AR9170_NUM_TX_AGG_MAX) {
-#ifdef AR9170_TXAGG_DEBUG
-			printk(KERN_DEBUG "%s: queue %d full.\n",
-			       wiphy_name(ar->hw->wiphy), queue);
-#endif /* AR9170_TXAGG_DEBUG */
-			continue;
-		}
-
-		list_del_init(&tid_info->list);
-
-		spin_lock_irqsave(&tid_info->queue.lock, f2);
-		tmpssn = seq = tid_info->ssn;
-		first = skb_peek(&tid_info->queue);
-
-		if (likely(first))
-			tmpssn = ar9170_get_seq(first);
-
-		if (unlikely(tmpssn != seq)) {
-#ifdef AR9170_TXAGG_DEBUG
-			printk(KERN_DEBUG "%s: ssn mismatch [%d != %d]\n.",
-			       wiphy_name(ar->hw->wiphy), seq, tmpssn);
-#endif /* AR9170_TXAGG_DEBUG */
-			tid_info->ssn = tmpssn;
-		}
-
-#ifdef AR9170_TXAGG_DEBUG
-		printk(KERN_DEBUG "%s: generate A-MPDU for tid:%d ssn:%d with "
-		       "%d queued frames.\n", wiphy_name(ar->hw->wiphy),
-		       tid_info->tid, tid_info->ssn,
-		       skb_queue_len(&tid_info->queue));
-		__ar9170_dump_txqueue(ar, &tid_info->queue);
-#endif /* AR9170_TXAGG_DEBUG */
-
-		while ((skb = skb_peek(&tid_info->queue))) {
-			if (unlikely(ar9170_get_seq(skb) != seq))
-				break;
-
-			__skb_unlink(skb, &tid_info->queue);
-			tid_info->ssn = seq = GET_NEXT_SEQ(seq);
-
-			if (unlikely(skb_get_queue_mapping(skb) != queue)) {
-#ifdef AR9170_TXAGG_DEBUG
-				printk(KERN_DEBUG "%s: tid:%d(q:%d) queue:%d "
-				       "!match.\n", wiphy_name(ar->hw->wiphy),
-				       tid_info->tid,
-				       TID_TO_WME_AC(tid_info->tid),
-				       skb_get_queue_mapping(skb));
-#endif /* AR9170_TXAGG_DEBUG */
-					dev_kfree_skb_any(skb);
-					continue;
-			}
-
-			if (unlikely(first == skb)) {
-				ar9170_tx_prepare_phy(ar, skb);
-				__skb_queue_tail(&agg, skb);
-				first = skb;
-			} else {
-				ar9170_tx_copy_phy(ar, skb, first);
-				__skb_queue_tail(&agg, skb);
-			}
-
-			if (unlikely(skb_queue_len(&agg) ==
-			    AR9170_NUM_TX_AGG_MAX))
-				break;
-		}
-
-		if (skb_queue_empty(&tid_info->queue))
-			tid_info->active = false;
-		else
-			list_add_tail(&tid_info->list,
-				      &ar->tx_ampdu_list);
-
-		spin_unlock_irqrestore(&tid_info->queue.lock, f2);
-
-		if (unlikely(skb_queue_empty(&agg))) {
-#ifdef AR9170_TXAGG_DEBUG
-			printk(KERN_DEBUG "%s: queued empty list!\n",
-			       wiphy_name(ar->hw->wiphy));
-#endif /* AR9170_TXAGG_DEBUG */
-			continue;
-		}
-
-		/*
-		 * tell the FW/HW that this is the last frame,
-		 * that way it will wait for the immediate block ack.
-		 */
-		ar9170_tx_indicate_immba(ar, skb_peek_tail(&agg));
-
-#ifdef AR9170_TXAGG_DEBUG
-		printk(KERN_DEBUG "%s: generated A-MPDU looks like this:\n",
-		       wiphy_name(ar->hw->wiphy));
-		__ar9170_dump_txqueue(ar, &agg);
-#endif /* AR9170_TXAGG_DEBUG */
-
-		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-
-		spin_lock_irqsave(&ar->tx_pending[queue].lock, flags);
-		skb_queue_splice_tail_init(&agg, &ar->tx_pending[queue]);
-		spin_unlock_irqrestore(&ar->tx_pending[queue].lock, flags);
-		run = true;
-
-		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
-	}
-
-out_unlock:
-	spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-	__skb_queue_purge(&agg);
-
-	return run;
-}
-
 static void ar9170_tx(struct ar9170 *ar)
 {
 	struct sk_buff *skb;
@@ -1763,9 +1434,6 @@ static void ar9170_tx(struct ar9170 *ar)
 			arinfo->timeout = jiffies +
 					  msecs_to_jiffies(AR9170_TX_TIMEOUT);
 
-			if (info->flags & IEEE80211_TX_CTL_AMPDU)
-				atomic_inc(&ar->tx_ampdu_pending);
-
 #ifdef AR9170_QUEUE_DEBUG
 			printk(KERN_DEBUG "%s: send frame q:%d =>\n",
 			       wiphy_name(ar->hw->wiphy), i);
@@ -1774,9 +1442,6 @@ static void ar9170_tx(struct ar9170 *ar)
 
 			err = ar->tx(ar, skb);
 			if (unlikely(err)) {
-				if (info->flags & IEEE80211_TX_CTL_AMPDU)
-					atomic_dec(&ar->tx_ampdu_pending);
-
 				frames_failed++;
 				dev_kfree_skb_any(skb);
 			} else {
@@ -1823,94 +1488,11 @@ static void ar9170_tx(struct ar9170 *ar)
 				     msecs_to_jiffies(AR9170_JANITOR_DELAY));
 }
 
-static bool ar9170_tx_ampdu_queue(struct ar9170 *ar, struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *txinfo;
-	struct ar9170_sta_info *sta_info;
-	struct ar9170_sta_tid *agg;
-	struct sk_buff *iter;
-	unsigned long flags, f2;
-	unsigned int max;
-	u16 tid, seq, qseq;
-	bool run = false, queue = false;
-
-	tid = ar9170_get_tid(skb);
-	seq = ar9170_get_seq(skb);
-	txinfo = IEEE80211_SKB_CB(skb);
-	sta_info = (void *) txinfo->control.sta->drv_priv;
-	agg = &sta_info->agg[tid];
-	max = sta_info->ampdu_max_len;
-
-	spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
-
-	if (unlikely(agg->state != AR9170_TID_STATE_COMPLETE)) {
-#ifdef AR9170_TXAGG_DEBUG
-		printk(KERN_DEBUG "%s: BlockACK session not fully initialized "
-		       "for ESS:%pM tid:%d state:%d.\n",
-		       wiphy_name(ar->hw->wiphy), agg->addr, agg->tid,
-		       agg->state);
-#endif /* AR9170_TXAGG_DEBUG */
-		goto err_unlock;
-	}
-
-	if (!agg->active) {
-		agg->active = true;
-		agg->ssn = seq;
-		queue = true;
-	}
-
-	/* check if seq is within the BA window */
-	if (unlikely(!BAW_WITHIN(agg->ssn, max, seq))) {
-#ifdef AR9170_TXAGG_DEBUG
-		printk(KERN_DEBUG "%s: frame with tid:%d seq:%d does not "
-		       "fit into BA window (%d - %d)\n",
-		       wiphy_name(ar->hw->wiphy), tid, seq, agg->ssn,
-		       (agg->ssn + max) & 0xfff);
-#endif /* AR9170_TXAGG_DEBUG */
-		goto err_unlock;
-	}
-
-	spin_lock_irqsave(&agg->queue.lock, f2);
-
-	skb_queue_reverse_walk(&agg->queue, iter) {
-		qseq = ar9170_get_seq(iter);
-
-		if (GET_NEXT_SEQ(qseq) == seq) {
-			__skb_queue_after(&agg->queue, iter, skb);
-			goto queued;
-		}
-	}
-
-	__skb_queue_head(&agg->queue, skb);
-
-queued:
-	spin_unlock_irqrestore(&agg->queue.lock, f2);
-
-#ifdef AR9170_TXAGG_DEBUG
-	printk(KERN_DEBUG "%s: new aggregate %p queued.\n",
-	       wiphy_name(ar->hw->wiphy), skb);
-	__ar9170_dump_txqueue(ar, &agg->queue);
-#endif /* AR9170_TXAGG_DEBUG */
-
-	if (skb_queue_len(&agg->queue) >= AR9170_NUM_TX_AGG_MAX)
-		run = true;
-
-	if (queue)
-		list_add_tail(&agg->list, &ar->tx_ampdu_list);
-
-	spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-	return run;
-
-err_unlock:
-	spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-	dev_kfree_skb_irq(skb);
-	return false;
-}
-
 int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
+	unsigned int queue;
 
 	if (unlikely(!IS_STARTED(ar)))
 		goto err_free;
@@ -1918,18 +1500,10 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (unlikely(ar9170_tx_prepare(ar, skb)))
 		goto err_free;
 
+	queue = skb_get_queue_mapping(skb);
 	info = IEEE80211_SKB_CB(skb);
-	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		bool run = ar9170_tx_ampdu_queue(ar, skb);
-
-		if (run || !atomic_read(&ar->tx_ampdu_pending))
-			ar9170_tx_ampdu(ar);
-	} else {
-		unsigned int queue = skb_get_queue_mapping(skb);
-
-		ar9170_tx_prepare_phy(ar, skb);
-		skb_queue_tail(&ar->tx_pending[queue], skb);
-	}
+	ar9170_tx_prepare_phy(ar, skb);
+	skb_queue_tail(&ar->tx_pending[queue], skb);
 
 	ar9170_tx(ar);
 	return NETDEV_TX_OK;
@@ -2330,57 +1904,6 @@ out:
 	return err;
 }
 
-static int ar9170_sta_add(struct ieee80211_hw *hw,
-			  struct ieee80211_vif *vif,
-			  struct ieee80211_sta *sta)
-{
-	struct ar9170 *ar = hw->priv;
-	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
-	unsigned int i;
-
-	memset(sta_info, 0, sizeof(*sta_info));
-
-	if (!sta->ht_cap.ht_supported)
-		return 0;
-
-	if (sta->ht_cap.ampdu_density > ar->global_ampdu_density)
-		ar->global_ampdu_density = sta->ht_cap.ampdu_density;
-
-	if (sta->ht_cap.ampdu_factor < ar->global_ampdu_factor)
-		ar->global_ampdu_factor = sta->ht_cap.ampdu_factor;
-
-	for (i = 0; i < AR9170_NUM_TID; i++) {
-		sta_info->agg[i].state = AR9170_TID_STATE_SHUTDOWN;
-		sta_info->agg[i].active = false;
-		sta_info->agg[i].ssn = 0;
-		sta_info->agg[i].tid = i;
-		INIT_LIST_HEAD(&sta_info->agg[i].list);
-		skb_queue_head_init(&sta_info->agg[i].queue);
-	}
-
-	sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
-
-	return 0;
-}
-
-static int ar9170_sta_remove(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_sta *sta)
-{
-	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
-	unsigned int i;
-
-	if (!sta->ht_cap.ht_supported)
-		return 0;
-
-	for (i = 0; i < AR9170_NUM_TID; i++) {
-		sta_info->agg[i].state = AR9170_TID_STATE_INVALID;
-		skb_queue_purge(&sta_info->agg[i].queue);
-	}
-
-	return 0;
-}
-
 static int ar9170_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats)
 {
@@ -2423,55 +1946,7 @@ static int ar9170_ampdu_action(struct ieee80211_hw *hw,
 			       enum ieee80211_ampdu_mlme_action action,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
-	struct ar9170 *ar = hw->priv;
-	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
-	struct ar9170_sta_tid *tid_info = &sta_info->agg[tid];
-	unsigned long flags;
-
-	if (!modparam_ht)
-		return -EOPNOTSUPP;
-
 	switch (action) {
-	case IEEE80211_AMPDU_TX_START:
-		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
-		if (tid_info->state != AR9170_TID_STATE_SHUTDOWN ||
-		    !list_empty(&tid_info->list)) {
-			spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-#ifdef AR9170_TXAGG_DEBUG
-			printk(KERN_INFO "%s: A-MPDU [ESS:[%pM] tid:[%d]] "
-			       "is in a very bad state!\n",
-			       wiphy_name(hw->wiphy), sta->addr, tid);
-#endif /* AR9170_TXAGG_DEBUG */
-			return -EBUSY;
-		}
-
-		*ssn = tid_info->ssn;
-		tid_info->state = AR9170_TID_STATE_PROGRESS;
-		tid_info->active = false;
-		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-
-	case IEEE80211_AMPDU_TX_STOP:
-		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
-		tid_info->state = AR9170_TID_STATE_SHUTDOWN;
-		list_del_init(&tid_info->list);
-		tid_info->active = false;
-		skb_queue_purge(&tid_info->queue);
-		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-
-	case IEEE80211_AMPDU_TX_OPERATIONAL:
-#ifdef AR9170_TXAGG_DEBUG
-		printk(KERN_INFO "%s: A-MPDU for %pM [tid:%d] Operational.\n",
-		       wiphy_name(hw->wiphy), sta->addr, tid);
-#endif /* AR9170_TXAGG_DEBUG */
-		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
-		sta_info->agg[tid].state = AR9170_TID_STATE_COMPLETE;
-		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
-		break;
-
 	case IEEE80211_AMPDU_RX_START:
 	case IEEE80211_AMPDU_RX_STOP:
 		/* Handled by firmware */
@@ -2497,8 +1972,6 @@ static const struct ieee80211_ops ar9170_ops = {
 	.bss_info_changed	= ar9170_op_bss_info_changed,
 	.get_tsf		= ar9170_op_get_tsf,
 	.set_key		= ar9170_set_key,
-	.sta_add		= ar9170_sta_add,
-	.sta_remove		= ar9170_sta_remove,
 	.get_stats		= ar9170_get_stats,
 	.ampdu_action		= ar9170_ampdu_action,
 };
@@ -2531,8 +2004,6 @@ void *ar9170_alloc(size_t priv_size)
 	mutex_init(&ar->mutex);
 	spin_lock_init(&ar->cmdlock);
 	spin_lock_init(&ar->tx_stats_lock);
-	spin_lock_init(&ar->tx_ampdu_list_lock);
-	skb_queue_head_init(&ar->tx_status_ampdu);
 	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
 		skb_queue_head_init(&ar->tx_status[i]);
 		skb_queue_head_init(&ar->tx_pending[i]);
@@ -2540,7 +2011,6 @@ void *ar9170_alloc(size_t priv_size)
 	ar9170_rx_reset_rx_mpdu(ar);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
 	INIT_DELAYED_WORK(&ar->tx_janitor, ar9170_tx_janitor);
-	INIT_LIST_HEAD(&ar->tx_ampdu_list);
 
 	/* all hw supports 2.4 GHz, so set channel to 1 by default */
 	ar->channel = &ar9170_2ghz_chantable[0];
@@ -2554,16 +2024,8 @@ void *ar9170_alloc(size_t priv_size)
 			 IEEE80211_HW_SIGNAL_DBM |
 			 IEEE80211_HW_NOISE_DBM;
 
-	if (modparam_ht) {
-		ar->hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
-	} else {
-		ar9170_band_2GHz.ht_cap.ht_supported = false;
-		ar9170_band_5GHz.ht_cap.ht_supported = false;
-	}
-
 	ar->hw->queues = __AR9170_NUM_TXQ;
 	ar->hw->extra_tx_headroom = 8;
-	ar->hw->sta_data_size = sizeof(struct ar9170_sta_info);
 
 	ar->hw->max_rates = 1;
 	ar->hw->max_rate_tries = 3;
