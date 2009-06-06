Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:53033 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZFFDHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 23:07:36 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [WIP][RFT][RFC] ar9170: aggregation xmit (aka the _other_ part)
Date: Sat, 6 Jun 2009 05:07:36 +0200
Cc: Jon Loeliger <jdl@bigfootnetworks.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_41dKKE/W3mDVE+H"
Message-Id: <200906060507.36464.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_41dKKE/W3mDVE+H
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is a first shot at HT xmit aggregation.

This code is experimental.
So, you better know what you're doing!

So far I managed to continuously send with up to 60mbits (iperf tcp),
Which is - i hope - good enough to get other people, with spare time,
more devices and/or access to the specs, in the boat.

--- content (patches)
7-txagg-v06-rfc-2.diff adds A-MPDU _feature_ to ar9170,

IMPORTANT:
Since 11n isn't stable, so that's why it must be enabled with
the ht=1 module parameter.

8-fake-mcs-rate.diff - literally maps 802.11b/g rates to HT MCS indexes.
This is just a quick hack (until minstrel supports HT MCS indexes).
(Note: the rate can also be set with iwconfig wlanX rate ${802.11b/g rate})

--- requirements
 - wireless-testing [with [PATCH] ar9170: xmit code revamp (or better)]
 - better be close (but not too close!) to the 11n AP.
 - as always: luck.
 - ...

--- missing, or untested 
 - all marvell / broadcom (etc...) workarounds
 - mimo powersave?
 - ANI/calibration (for better range and throughput)
 - encryption (only tested with a unencrypted network)
 - spec conformance (I don't have them... 
   And this is always a good source for bugs!)
 - only tested with the old PHASE_2 firmware
 - extended testing in crowed areas, roaming,
   really big transfer volumes (e.g up to 100GB), etc.
   
Regards,
	Chr
---

--Boundary-00=_41dKKE/W3mDVE+H
Content-Type: text/x-patch;
  charset="us-ascii";
  name="7-txagg-v06-rfc-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="7-txagg-v06-rfc-2.diff"

diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index bb97981..47c1630 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -109,11 +109,53 @@ struct ar9170_rxstream_mpdu_merge {
 	bool has_plcp;
 };
 
+#define AR9170_NUM_MAX_BA_RETRY	5
+#define AR9170_NUM_TID	16
+#define WME_BA_BMP_SIZE         64
+#define AR9170_NUM_MAX_AGG_LEN	(2 * WME_BA_BMP_SIZE)
+
+#define WME_AC_BE   2
+#define WME_AC_BK   3
+#define WME_AC_VI   1
+#define WME_AC_VO   0
+
+#define TID_TO_WME_AC(_tid)				\
+	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
+	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
+	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
+	 WME_AC_VO)
+
+#define BAW_WITHIN(_start, _bawsz, _seqno) \
+	((((_seqno) - (_start)) & 0xfff) < (_bawsz))
+
+enum ar9170_tid_state {
+	AR9170_TID_STATE_INVALID,
+	AR9170_TID_STATE_SHUTDOWN,
+	AR9170_TID_STATE_STARTING,
+	AR9170_TID_STATE_PROGRESS,
+	AR9170_TID_STATE_COMPLETE,
+};
+
+struct ar9170_sta_tid {
+	struct list_head list;
+	struct sk_buff_head queue;
+	u8 addr[ETH_ALEN];
+	u16 ssn;
+	u16 tid;
+	enum ar9170_tid_state state;
+	bool active;
+	u8 retry;
+};
+
 #define AR9170_QUEUE_TIMEOUT		64
 #define AR9170_TX_TIMEOUT		8
+#define AR9170_BA_TIMEOUT		4
 #define AR9170_JANITOR_DELAY		128
 #define AR9170_TX_INVALID_RATE		0xffffffff
 
+#define AR9170_NUM_TX_STATUS		128
+#define AR9170_NUM_TX_AGG_MAX		30
+
 struct ar9170 {
 	struct ieee80211_hw *hw;
 	struct mutex mutex;
@@ -187,14 +229,30 @@ struct ar9170 {
 	struct sk_buff_head tx_pending[__AR9170_NUM_TXQ];
 	struct sk_buff_head tx_status[__AR9170_NUM_TXQ];
 	struct delayed_work tx_janitor;
+	/* tx ampdu */
+	struct sk_buff_head tx_status_ampdu;
+
+	spinlock_t tx_ampdu_list_lock;
+	struct list_head tx_ampdu_list;
+	unsigned int tx_ampdu_pending;
+
+	spinlock_t addba_list_lock;
+	struct list_head addba_list;
+	struct work_struct start_tx_ba_work;
 
 	/* rxstream mpdu merge */
 	struct ar9170_rxstream_mpdu_merge rx_mpdu;
 	struct sk_buff *rx_failover;
 	int rx_failover_missing;
+
+	/* (cached) HW A-MPDU settings */
+	u8 global_ampdu_density;
+	u8 global_ampdu_factor;
 };
 
 struct ar9170_sta_info {
+	struct ar9170_sta_tid agg[AR9170_NUM_TID];
+	unsigned int ampdu_max_len;
 };
 
 #define AR9170_TX_FLAG_WAIT_FOR_ACK	BIT(0)
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index b0dc645..59f303b 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -49,6 +49,10 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
+static int modparam_ht;
+module_param_named(ht, modparam_ht, bool, S_IRUGO);
+MODULE_PARM_DESC(ht, "enable 11n.");
+
 #define RATE(_bitrate, _hw_rate, _txpidx, _flags) {	\
 	.bitrate	= (_bitrate),			\
 	.flags		= (_flags),			\
@@ -148,12 +152,15 @@ static struct ieee80211_channel ar9170_5ghz_chantable[] = {
 	.cap		= IEEE80211_HT_CAP_MAX_AMSDU |			\
 			  IEEE80211_HT_CAP_SUP_WIDTH_20_40 |		\
 			  IEEE80211_HT_CAP_SGI_40 |			\
+			  IEEE80211_HT_CAP_GRN_FLD |			\
 			  IEEE80211_HT_CAP_DSSSCCK40 |			\
 			  IEEE80211_HT_CAP_SM_PS,			\
 	.ampdu_factor	= 3,						\
 	.ampdu_density	= 6,						\
 	.mcs		= {						\
-		.rx_mask = { 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, },	\
+		.rx_mask = { 0xFF, 0xFF, 0, 0, 0x01, 0, 0, 0, 0, 0, },	\
+		.rx_highest = cpu_to_le16(300),				\
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,		\
 	},								\
 }
 
@@ -174,8 +181,31 @@ static struct ieee80211_supported_band ar9170_band_5GHz = {
 };
 
 static void ar9170_tx(struct ar9170 *ar);
+static bool ar9170_tx_ampdu(struct ar9170 *ar);
 
-#ifdef AR9170_QUEUE_DEBUG
+static inline u16 ar9170_get_seq_h(struct ieee80211_hdr *hdr)
+{
+	return le16_to_cpu(hdr->seq_ctrl) >> 4;
+}
+
+static inline u16 ar9170_get_seq(struct sk_buff *skb)
+{
+	struct ar9170_tx_control *txc = (void *) skb->data;
+	return ar9170_get_seq_h((void *) txc->frame_data);
+}
+
+static inline u16 ar9170_get_tid(struct sk_buff *skb)
+{
+	struct ar9170_tx_control *txc = (void *) skb->data;
+	struct ieee80211_hdr *hdr = (void *) txc->frame_data;
+
+	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
+}
+
+#define GET_NEXT_SEQ(seq)	((seq + 1) & 0x0fff)
+#define GET_NEXT_SEQ_FROM_SKB(skb)	(GET_NEXT_SEQ(ar9170_get_seq(skb)))
+
+#if (defined AR9170_QUEUE_DEBUG) || (defined AR9170_TXAGG_DEBUG)
 static void ar9170_print_txheader(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ar9170_tx_control *txc = (void *) skb->data;
@@ -183,10 +213,10 @@ static void ar9170_print_txheader(struct ar9170 *ar, struct sk_buff *skb)
 	struct ar9170_tx_info *arinfo = (void *) txinfo->rate_driver_data;
 	struct ieee80211_hdr *hdr = (void *) txc->frame_data;
 
-	printk(KERN_DEBUG "%s: => FRAME [skb:%p, q:%d, DA:[%pM] flags:%x "
+	printk(KERN_DEBUG "%s: => FRAME [skb:%p, q:%d, DA:[%pM] flags:%x s:%d "
 			  "mac_ctrl:%04x, phy_ctrl:%08x, timeout:[%d ms]]\n",
 	       wiphy_name(ar->hw->wiphy), skb, skb_get_queue_mapping(skb),
-	       ieee80211_get_DA(hdr), arinfo->flags,
+	       ieee80211_get_DA(hdr), arinfo->flags, ar9170_get_seq_h(hdr),
 	       le16_to_cpu(txc->mac_control), le32_to_cpu(txc->phy_control),
 	       jiffies_to_msecs(arinfo->timeout - jiffies));
 }
@@ -210,7 +240,9 @@ static void __ar9170_dump_txqueue(struct ar9170 *ar,
 		       "mismatch %d != %d\n", skb_queue_len(queue), i);
 	printk(KERN_DEBUG "---[ end ]---\n");
 }
+#endif /* AR9170_QUEUE_DEBUG || AR9170_TXAGG_DEBUG */
 
+#ifdef AR9170_QUEUE_DEBUG
 static void ar9170_dump_txqueue(struct ar9170 *ar,
 				struct sk_buff_head *queue)
 {
@@ -220,7 +252,9 @@ static void ar9170_dump_txqueue(struct ar9170 *ar,
 	__ar9170_dump_txqueue(ar, queue);
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
+#endif /* AR9170_QUEUE_DEBUG */
 
+#ifdef AR9170_QUEUE_STOP_DEBUG
 static void __ar9170_dump_txstats(struct ar9170 *ar)
 {
 	int i;
@@ -229,20 +263,86 @@ static void __ar9170_dump_txstats(struct ar9170 *ar)
 	       wiphy_name(ar->hw->wiphy));
 
 	for (i = 0; i < __AR9170_NUM_TXQ; i++)
-		printk(KERN_DEBUG "%s: queue:%d limit:%d len:%d waitack:%d\n",
-		       wiphy_name(ar->hw->wiphy), i, ar->tx_stats[i].limit,
-		       ar->tx_stats[i].len, skb_queue_len(&ar->tx_status[i]));
+		printk(KERN_DEBUG "%s: queue:%d limit:%d len:%d waitack:%d "
+		       " stopped:%d\n", wiphy_name(ar->hw->wiphy), i,
+		       ar->tx_stats[i].limit, ar->tx_stats[i].len,
+		       skb_queue_len(&ar->tx_status[i]),
+		       ieee80211_queue_stopped(ar->hw, i));
 }
+#endif /* AR9170_QUEUE_STOP_DEBUG */
 
-static void ar9170_dump_txstats(struct ar9170 *ar)
+#ifdef AR9170_TXAGG_DEBUG
+static void ar9170_dump_tx_status_ampdu(struct ar9170 *ar)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ar->tx_stats_lock, flags);
-	__ar9170_dump_txstats(ar);
-	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
+	spin_lock_irqsave(&ar->tx_status_ampdu.lock, flags);
+	printk(KERN_DEBUG "%s: A-MPDU tx_status queue => \n",
+	       wiphy_name(ar->hw->wiphy));
+	__ar9170_dump_txqueue(ar, &ar->tx_status_ampdu);
+	spin_unlock_irqrestore(&ar->tx_status_ampdu.lock, flags);
+}
+
+#endif /* AR9170_TXAGG_DEBUG */
+
+static void ar9170_setup_aggregation(struct ar9170 *ar, struct sk_buff *skb)
+{
+	unsigned long flags;
+	struct ieee80211_sta *sta;
+	struct ieee80211_hdr *hdr = (void *) skb->data;
+	struct ar9170_sta_tid *tid_info;
+	u16 tid = ar9170_get_tid(skb);
+
+	if (!conf_is_ht(&ar->hw->conf))
+		return ;
+
+	/* don't start aggregation for non-qos / WPA handshake */
+	if ((skb->protocol == cpu_to_le16(ETH_P_PAE)) ||
+	    !ieee80211_is_data_qos(hdr->frame_control))
+		return ;
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(ar->hw, ieee80211_get_DA(hdr));
+	if (!sta)
+		goto out_unlock;
+
+	if (!sta->ht_cap.ht_supported)
+		goto out_unlock;
+
+	tid_info = &((struct ar9170_sta_info *) sta->drv_priv)->agg[tid];
+
+	if (tid_info->retry++ > AR9170_NUM_MAX_BA_RETRY) {
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_DEBUG "%s: too many addba retries for "
+		       "ESS:[%pM], tid:%d.\n", wiphy_name(ar->hw->wiphy),
+		       sta->addr, tid);
+#endif /* AR9170_TXAGG_DEBUG */
+		goto out_unlock;
+	}
+
+	if (tid_info->state == AR9170_TID_STATE_SHUTDOWN) {
+		if (!list_empty(&tid_info->list)) {
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_DEBUG "%s: addba already queued.\n",
+			       wiphy_name(ar->hw->wiphy));
+#endif /* AR9170_TXAGG_DEBUG */
+			goto out_unlock;
+		}
+
+		/* FIXME: no idea if this is right... */
+		tid_info->ssn = GET_NEXT_SEQ_FROM_SKB(skb);
+
+		spin_lock_irqsave(&ar->addba_list_lock, flags);
+		memcpy(tid_info->addr, sta->addr, ETH_ALEN);
+		tid_info->state = AR9170_TID_STATE_STARTING;
+		list_add_tail(&tid_info->list, &ar->addba_list);
+		spin_unlock_irqrestore(&ar->addba_list_lock, flags);
+		queue_work(ar->hw->workqueue, &ar->start_tx_ba_work);
+	}
+
+out_unlock:
+	rcu_read_unlock();
 }
-#endif /* AR9170_QUEUE_DEBUG */
 
 /* caller must guarantee exclusive access for _bin_ queue. */
 static void ar9170_recycle_expired(struct ar9170 *ar,
@@ -312,9 +412,76 @@ static void ar9170_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 
 	txinfo->status.rates[0].count = retries + 1;
 	skb_pull(skb, sizeof(struct ar9170_tx_control));
+	if (tx_status != AR9170_TX_STATUS_FAILED)
+		ar9170_setup_aggregation(ar, skb);
+
 	ieee80211_tx_status_irqsafe(ar->hw, skb);
 }
 
+static void ar9170_tx_fake_ampdu_status(struct ar9170 *ar)
+{
+	struct sk_buff_head success;
+	struct sk_buff *skb;
+	unsigned int i;
+	unsigned long queue_bitmap = 0;
+
+	skb_queue_head_init(&success);
+
+	while (skb_queue_len(&ar->tx_status_ampdu) > AR9170_NUM_TX_STATUS)
+		__skb_queue_tail(&success, skb_dequeue(&ar->tx_status_ampdu));
+
+	ar9170_recycle_expired(ar, &ar->tx_status_ampdu, &success);
+
+#ifdef AR9170_TXAGG_DEBUG
+	printk(KERN_DEBUG "%s: collected %d A-MPDU frames.\n",
+	       wiphy_name(ar->hw->wiphy), skb_queue_len(&success));
+	__ar9170_dump_txqueue(ar, &success);
+#endif /* AR9170_TXAGG_DEBUG */
+
+	while ((skb = __skb_dequeue(&success))) {
+		struct ieee80211_tx_info *txinfo;
+
+		queue_bitmap |= BIT(skb_get_queue_mapping(skb));
+
+		txinfo = IEEE80211_SKB_CB(skb);
+		ieee80211_tx_info_clear_status(txinfo);
+
+		txinfo->flags |= IEEE80211_TX_STAT_ACK;
+		txinfo->status.rates[0].count = 1;
+
+		skb_pull(skb, sizeof(struct ar9170_tx_control));
+		ieee80211_tx_status_irqsafe(ar->hw, skb);
+	}
+
+	for_each_bit(i, &queue_bitmap, BITS_PER_BYTE) {
+#ifdef AR9170_QUEUE_STOP_DEBUG
+		printk(KERN_DEBUG "%s: wake queue %d\n",
+		       wiphy_name(ar->hw->wiphy), i);
+		__ar9170_dump_txstats(ar);
+#endif /* AR9170_QUEUE_STOP_DEBUG */
+		ieee80211_wake_queue(ar->hw, i);
+	}
+
+	if (queue_bitmap)
+		ar9170_tx(ar);
+}
+
+static void ar9170_tx_ampdu_callback(struct ar9170 *ar, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
+	struct ar9170_tx_info *arinfo = (void *) txinfo->rate_driver_data;
+
+	arinfo->timeout = jiffies +
+			  msecs_to_jiffies(AR9170_BA_TIMEOUT);
+
+	skb_queue_tail(&ar->tx_status_ampdu, skb);
+	ar9170_tx_fake_ampdu_status(ar);
+	ar->tx_ampdu_pending--;
+
+	if (!list_empty(&ar->tx_ampdu_list) && !ar->tx_ampdu_pending)
+		ar9170_tx_ampdu(ar);
+}
+
 void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -336,7 +503,7 @@ void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb)
 	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
 
 	if (arinfo->flags & AR9170_TX_FLAG_BLOCK_ACK) {
-		dev_kfree_skb_any(skb);
+		ar9170_tx_ampdu_callback(ar, skb);
 	} else if (arinfo->flags & AR9170_TX_FLAG_WAIT_FOR_ACK) {
 		arinfo->timeout = jiffies +
 				  msecs_to_jiffies(AR9170_TX_TIMEOUT);
@@ -420,6 +587,38 @@ static struct sk_buff *ar9170_get_queued_skb(struct ar9170 *ar,
 	return NULL;
 }
 
+static void ar9170_handle_block_ack(struct ar9170 *ar, u16 count, u16 r)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *txinfo;
+
+	while (count) {
+		skb = ar9170_get_queued_skb(ar, NULL, &ar->tx_status_ampdu, r);
+		if (!skb)
+			break;
+
+		txinfo = IEEE80211_SKB_CB(skb);
+		ieee80211_tx_info_clear_status(txinfo);
+
+		/* FIXME: maybe more ? */
+		txinfo->status.rates[0].count = 1;
+
+		skb_pull(skb, sizeof(struct ar9170_tx_control));
+		ieee80211_tx_status_irqsafe(ar->hw, skb);
+		count--;
+	}
+
+#ifdef AR9170_TXAGG_DEBUG
+	if (count) {
+		printk(KERN_DEBUG "%s: got %d more failed mpdus, but no more "
+		       "suitable frames left in tx_status queue.\n",
+		       wiphy_name(ar->hw->wiphy), count);
+
+		ar9170_dump_tx_status_ampdu(ar);
+	}
+#endif /* AR9170_TXAGG_DEBUG */
+}
+
 /*
  * This worker tries to keeps an maintain tx_status queues.
  * So we can guarantee that incoming tx_status reports are
@@ -456,6 +655,8 @@ static void ar9170_tx_janitor(struct work_struct *work)
 			resched = true;
 	}
 
+	ar9170_tx_fake_ampdu_status(ar);
+
 	if (resched)
 		queue_delayed_work(ar->hw->workqueue,
 				   &ar->tx_janitor,
@@ -528,8 +729,15 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 		break;
 
 	case 0xc4:
+		/* BlockACK bitmap */
+		break;
+
 	case 0xc5:
 		/* BlockACK events */
+		ar9170_handle_block_ack(ar,
+					le16_to_cpu(cmd->ba_fail_cnt.failed),
+					le16_to_cpu(cmd->ba_fail_cnt.rate));
+		ar9170_tx_fake_ampdu_status(ar);
 		break;
 
 	case 0xc6:
@@ -1064,6 +1272,10 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 	AR9170_FILL_QUEUE(ar->edcf[3], 2, 3,     7, 47); /* VOICE */
 	AR9170_FILL_QUEUE(ar->edcf[4], 2, 3,     7,  0); /* SPECIAL */
 
+	/* set sane AMPDU defaults */
+	ar->global_ampdu_density = 6;
+	ar->global_ampdu_factor = 3;
+
 	ar->bad_hw_nagger = jiffies;
 
 	err = ar->open(ar);
@@ -1109,8 +1321,10 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 	flush_workqueue(ar->hw->workqueue);
 
 	cancel_delayed_work_sync(&ar->tx_janitor);
+	cancel_delayed_work_sync(&ar->led_work);
 	cancel_work_sync(&ar->filter_config_work);
 	cancel_work_sync(&ar->beacon_work);
+	cancel_work_sync(&ar->start_tx_ba_work);
 	mutex_lock(&ar->mutex);
 
 	if (IS_ACCEPTING_CMD(ar)) {
@@ -1125,9 +1339,40 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 		skb_queue_purge(&ar->tx_pending[i]);
 		skb_queue_purge(&ar->tx_status[i]);
 	}
+	skb_queue_purge(&ar->tx_status_ampdu);
+
 	mutex_unlock(&ar->mutex);
 }
 
+static void ar9170_tx_indicate_immba(struct ar9170 *ar, struct sk_buff *skb)
+{
+	struct ar9170_tx_control *txc = (void *) skb->data;
+
+	txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_IMM_AMPDU);
+}
+
+static void ar9170_tx_copy_phy(struct ar9170 *ar, struct sk_buff *dst,
+			       struct sk_buff *src)
+{
+	struct ar9170_tx_control *dst_txc, *src_txc;
+	struct ieee80211_tx_info *dst_info, *src_info;
+	struct ar9170_tx_info *dst_arinfo, *src_arinfo;
+
+	src_txc = (void *) src->data;
+	src_info = IEEE80211_SKB_CB(src);
+	src_arinfo = (void *) src_info->rate_driver_data;
+
+	dst_txc = (void *) dst->data;
+	dst_info = IEEE80211_SKB_CB(dst);
+	dst_arinfo = (void *) dst_info->rate_driver_data;
+
+	dst_txc->phy_control = src_txc->phy_control;
+
+	/* same MCS for the whole aggregate */
+	memcpy(dst_info->driver_rates, src_info->driver_rates,
+	       sizeof(dst_info->driver_rates));
+}
+
 static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
@@ -1196,6 +1441,7 @@ static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
 			arinfo->flags = AR9170_TX_FLAG_BLOCK_ACK;
+
 			goto out;
 		}
 
@@ -1326,6 +1572,159 @@ static void ar9170_tx_prepare_phy(struct ar9170 *ar, struct sk_buff *skb)
 	txc->phy_control |= cpu_to_le32(chains << AR9170_TX_PHY_TXCHAIN_SHIFT);
 }
 
+static bool ar9170_tx_ampdu(struct ar9170 *ar)
+{
+	struct sk_buff_head agg;
+	struct ar9170_sta_tid *tid_info = NULL, *tmp;
+	struct sk_buff *skb, *first = NULL;
+	unsigned long flags, f2;
+	unsigned int i = 0;
+	u16 seq, queue, tmpssn;
+	bool run = false;
+
+	skb_queue_head_init(&agg);
+
+	spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
+	if (list_empty(&ar->tx_ampdu_list)) {
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_DEBUG "%s: aggregation list is empty.\n",
+		       wiphy_name(ar->hw->wiphy));
+#endif /* AR9170_TXAGG_DEBUG */
+		goto out_unlock;
+	}
+
+	list_for_each_entry_safe(tid_info, tmp, &ar->tx_ampdu_list, list) {
+		if (tid_info->state != AR9170_TID_STATE_COMPLETE) {
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_DEBUG "%s: dangling aggregation entry!\n",
+			       wiphy_name(ar->hw->wiphy));
+#endif /* AR9170_TXAGG_DEBUG */
+			continue;
+		}
+
+		if (++i > 64) {
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_DEBUG "%s: enough frames aggregated.\n",
+			       wiphy_name(ar->hw->wiphy));
+#endif /* AR9170_TXAGG_DEBUG */
+			break;
+		}
+
+		queue = TID_TO_WME_AC(tid_info->tid);
+
+		if (skb_queue_len(&ar->tx_pending[queue]) >=
+		    AR9170_NUM_TX_AGG_MAX) {
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_DEBUG "%s: queue %d full.\n",
+			       wiphy_name(ar->hw->wiphy), queue);
+#endif /* AR9170_TXAGG_DEBUG */
+			continue;
+		}
+
+		list_del_init(&tid_info->list);
+
+		spin_lock_irqsave(&tid_info->queue.lock, f2);
+		tmpssn = seq = tid_info->ssn;
+		first = skb_peek(&tid_info->queue);
+
+		if (likely(first))
+			tmpssn = ar9170_get_seq(first);
+
+		if (unlikely(tmpssn != seq)) {
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_DEBUG "%s: ssn mismatch [%d != %d]\n.",
+			       wiphy_name(ar->hw->wiphy), seq, tmpssn);
+#endif /* AR9170_TXAGG_DEBUG */
+			tid_info->ssn = tmpssn;
+		}
+
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_DEBUG "%s: generate A-MPDU for tid:%d ssn:%d with "
+		       "%d queued frames.\n", wiphy_name(ar->hw->wiphy),
+		       tid_info->tid, tid_info->ssn,
+		       skb_queue_len(&tid_info->queue));
+		__ar9170_dump_txqueue(ar, &tid_info->queue);
+#endif /* AR9170_TXAGG_DEBUG */
+
+		while ((skb = skb_peek(&tid_info->queue))) {
+			if (unlikely(ar9170_get_seq(skb) != seq))
+				break;
+
+			__skb_unlink(skb, &tid_info->queue);
+			tid_info->ssn = seq = GET_NEXT_SEQ(seq);
+
+			if (unlikely(skb_get_queue_mapping(skb) != queue)) {
+#ifdef AR9170_TXAGG_DEBUG
+				printk(KERN_DEBUG "%s: tid:%d(q:%d) queue:%d "
+				       "!match.\n", wiphy_name(ar->hw->wiphy),
+				       tid_info->tid,
+				       TID_TO_WME_AC(tid_info->tid),
+				       skb_get_queue_mapping(skb));
+#endif /* AR9170_TXAGG_DEBUG */
+					dev_kfree_skb_any(skb);
+					continue;
+			}
+
+			if (unlikely(first == skb)) {
+				ar9170_tx_prepare_phy(ar, skb);
+				__skb_queue_tail(&agg, skb);
+				first = skb;
+			} else {
+				ar9170_tx_copy_phy(ar, skb, first);
+				__skb_queue_tail(&agg, skb);
+			}
+
+			if (unlikely(skb_queue_len(&agg) ==
+			    AR9170_NUM_TX_AGG_MAX))
+				break;
+		}
+
+		if (skb_queue_empty(&tid_info->queue))
+			tid_info->active = false;
+		else
+			list_add_tail(&tid_info->list,
+				      &ar->tx_ampdu_list);
+
+		spin_unlock_irqrestore(&tid_info->queue.lock, f2);
+
+		if (unlikely(skb_queue_empty(&agg))) {
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_DEBUG "%s: queued empty list!\n",
+			       wiphy_name(ar->hw->wiphy));
+#endif /* AR9170_TXAGG_DEBUG */
+			continue;
+		}
+
+		/*
+		 * tell the FW/HW that this is the last frame,
+		 * that way it will wait for the immediate block ack.
+		 */
+		if (likely(skb_peek_tail(&agg)))
+			ar9170_tx_indicate_immba(ar, skb_peek_tail(&agg));
+
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_DEBUG "%s: generated A-MPDU looks like this:\n",
+		       wiphy_name(ar->hw->wiphy));
+		__ar9170_dump_txqueue(ar, &agg);
+#endif /* AR9170_TXAGG_DEBUG */
+
+		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+
+		spin_lock_irqsave(&ar->tx_pending[queue].lock, flags);
+		skb_queue_splice_tail_init(&agg, &ar->tx_pending[queue]);
+		spin_unlock_irqrestore(&ar->tx_pending[queue].lock, flags);
+		run = true;
+
+		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
+	}
+
+out_unlock:
+	spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+	__skb_queue_purge(&agg);
+
+	return run;
+}
+
 static void ar9170_tx(struct ar9170 *ar)
 {
 	struct sk_buff *skb;
@@ -1350,11 +1749,17 @@ static void ar9170_tx(struct ar9170 *ar)
 			printk(KERN_DEBUG "%s: queue %d full\n",
 			       wiphy_name(ar->hw->wiphy), i);
 
-			__ar9170_dump_txstats(ar);
-			printk(KERN_DEBUG "stuck frames: ===> \n");
+			printk(KERN_DEBUG "%s: stuck frames: ===> \n",
+			       wiphy_name(ar->hw->wiphy));
 			ar9170_dump_txqueue(ar, &ar->tx_pending[i]);
 			ar9170_dump_txqueue(ar, &ar->tx_status[i]);
 #endif /* AR9170_QUEUE_DEBUG */
+
+#ifdef AR9170_QUEUE_STOP_DEBUG
+			printk(KERN_DEBUG "%s: stop queue %d\n",
+			       wiphy_name(ar->hw->wiphy), i);
+			__ar9170_dump_txstats(ar);
+#endif /* AR9170_QUEUE_STOP_DEBUG */
 			ieee80211_stop_queue(ar->hw, i);
 			spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
 			continue;
@@ -1369,8 +1774,6 @@ static void ar9170_tx(struct ar9170 *ar)
 			       "remaining slots:%d, needed:%d\n",
 			       wiphy_name(ar->hw->wiphy), i, remaining_space,
 			       frames);
-
-			ar9170_dump_txstats(ar);
 #endif /* AR9170_QUEUE_DEBUG */
 			frames = remaining_space;
 		}
@@ -1398,6 +1801,9 @@ static void ar9170_tx(struct ar9170 *ar)
 			arinfo->timeout = jiffies +
 					  msecs_to_jiffies(AR9170_TX_TIMEOUT);
 
+			if (arinfo->flags == AR9170_TX_FLAG_BLOCK_ACK)
+				ar->tx_ampdu_pending++;
+
 #ifdef AR9170_QUEUE_DEBUG
 			printk(KERN_DEBUG "%s: send frame q:%d =>\n",
 			       wiphy_name(ar->hw->wiphy), i);
@@ -1406,6 +1812,9 @@ static void ar9170_tx(struct ar9170 *ar)
 
 			err = ar->tx(ar, skb);
 			if (unlikely(err)) {
+				if (arinfo->flags == AR9170_TX_FLAG_BLOCK_ACK)
+					ar->tx_ampdu_pending--;
+
 				frames_failed++;
 				dev_kfree_skb_any(skb);
 			} else {
@@ -1427,13 +1836,18 @@ static void ar9170_tx(struct ar9170 *ar)
 
 		if (unlikely(frames_failed)) {
 #ifdef AR9170_QUEUE_DEBUG
-			printk(KERN_DEBUG "%s: frames failed =>\n",
+			printk(KERN_DEBUG "%s: frames failed %d =>\n",
 			       wiphy_name(ar->hw->wiphy), frames_failed);
 #endif /* AR9170_QUEUE_DEBUG */
 
 			spin_lock_irqsave(&ar->tx_stats_lock, flags);
 			ar->tx_stats[i].len -= frames_failed;
 			ar->tx_stats[i].count -= frames_failed;
+#ifdef AR9170_QUEUE_STOP_DEBUG
+			printk(KERN_DEBUG "%s: wake queue %d\n",
+			       wiphy_name(ar->hw->wiphy), i);
+			__ar9170_dump_txstats(ar);
+#endif /* AR9170_QUEUE_STOP_DEBUG */
 			ieee80211_wake_queue(ar->hw, i);
 			spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
 		}
@@ -1445,6 +1859,90 @@ static void ar9170_tx(struct ar9170 *ar)
 				   msecs_to_jiffies(AR9170_JANITOR_DELAY));
 }
 
+static bool ar9170_tx_ampdu_queue(struct ar9170 *ar, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *txinfo;
+	struct ar9170_sta_info *sta_info;
+	struct ar9170_sta_tid *agg;
+	struct sk_buff *iter;
+	unsigned long flags, f2;
+	unsigned int max;
+	u16 tid, seq, qseq;
+	bool run = false, queue = false;
+
+	tid = ar9170_get_tid(skb);
+	seq = ar9170_get_seq(skb);
+	txinfo = IEEE80211_SKB_CB(skb);
+	sta_info = (void *) txinfo->control.sta->drv_priv;
+	agg = &sta_info->agg[tid];
+	max = sta_info->ampdu_max_len;
+
+	spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
+
+	if (unlikely(agg->state != AR9170_TID_STATE_COMPLETE)) {
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_DEBUG "%s: BlockACK session not fully initialized "
+		       "for ESS:%pM tid:%d state:%d.\n",
+		       wiphy_name(ar->hw->wiphy), agg->addr, agg->tid,
+		       agg->state);
+#endif /* AR9170_TXAGG_DEBUG */
+		goto err_unlock;
+	}
+
+	if (!agg->active) {
+		agg->active = true;
+		agg->ssn = seq;
+		queue = true;
+	}
+
+	/* check if seq is within the BA window */
+	if (unlikely(!BAW_WITHIN(agg->ssn, max, seq))) {
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_DEBUG "%s: frame with tid:%d seq:%d does not "
+		       "fit into BA window (%d - %d)\n",
+		       wiphy_name(ar->hw->wiphy), tid, seq, agg->ssn,
+		       (agg->ssn + max) & 0xfff);
+#endif /* AR9170_TXAGG_DEBUG */
+		goto err_unlock;
+	}
+
+	spin_lock_irqsave(&agg->queue.lock, f2);
+
+	skb_queue_reverse_walk(&agg->queue, iter) {
+		qseq = ar9170_get_seq(iter);
+
+		if (GET_NEXT_SEQ(qseq) == seq) {
+			__skb_queue_after(&agg->queue, iter, skb);
+			goto queued;
+		}
+	}
+
+	__skb_queue_head(&agg->queue, skb);
+
+queued:
+	spin_unlock_irqrestore(&agg->queue.lock, f2);
+
+#ifdef AR9170_TXAGG_DEBUG
+	printk(KERN_DEBUG "%s: new aggregate %p queued.\n",
+	       wiphy_name(ar->hw->wiphy), skb);
+	__ar9170_dump_txqueue(ar, &agg->queue);
+#endif /* AR9170_TXAGG_DEBUG */
+
+	if (skb_queue_len(&agg->queue) >= AR9170_NUM_TX_AGG_MAX)
+		run = true;
+
+	if (queue)
+		list_add_tail(&agg->list, &ar->tx_ampdu_list);
+
+	spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+	return run;
+
+err_unlock:
+	spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+	dev_kfree_skb_irq(skb);
+	return false;
+}
+
 int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ar9170 *ar = hw->priv;
@@ -1458,8 +1956,10 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	info = IEEE80211_SKB_CB(skb);
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		/* drop frame, we do not allow TX A-MPDU aggregation yet. */
-		goto err_free;
+		bool run = ar9170_tx_ampdu_queue(ar, skb);
+
+		if (run || !ar->tx_ampdu_pending)
+			ar9170_tx_ampdu(ar);
 	} else {
 		unsigned int queue = skb_get_queue_mapping(skb);
 
@@ -1897,6 +2397,53 @@ static void ar9170_sta_notify(struct ieee80211_hw *hw,
 			      enum sta_notify_cmd cmd,
 			      struct ieee80211_sta *sta)
 {
+	struct ar9170 *ar = hw->priv;
+	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
+	unsigned int i;
+
+	switch (cmd) {
+	case STA_NOTIFY_ADD:
+		memset(sta_info, 0, sizeof(*sta_info));
+
+		if (!sta->ht_cap.ht_supported)
+			break;
+
+		if (sta->ht_cap.ampdu_density > ar->global_ampdu_density)
+			ar->global_ampdu_density = sta->ht_cap.ampdu_density;
+
+		if (sta->ht_cap.ampdu_factor < ar->global_ampdu_factor)
+			ar->global_ampdu_factor = sta->ht_cap.ampdu_factor;
+
+		for (i = 0; i < AR9170_NUM_TID; i++) {
+			sta_info->agg[i].state = AR9170_TID_STATE_SHUTDOWN;
+			sta_info->agg[i].active = false;
+			sta_info->agg[i].ssn = 0;
+			sta_info->agg[i].retry = 0;
+			sta_info->agg[i].tid = i;
+			INIT_LIST_HEAD(&sta_info->agg[i].list);
+			skb_queue_head_init(&sta_info->agg[i].queue);
+		}
+
+		sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
+		break;
+
+	case STA_NOTIFY_REMOVE:
+		if (!sta->ht_cap.ht_supported)
+			break;
+
+		for (i = 0; i < AR9170_NUM_TID; i++) {
+			sta_info->agg[i].state = AR9170_TID_STATE_INVALID;
+			skb_queue_purge(&sta_info->agg[i].queue);
+		}
+
+		break;
+
+	default:
+		break;
+	}
+
+	if (IS_STARTED(ar) && ar->filter_changed)
+		queue_work(ar->hw->workqueue, &ar->filter_config_work);
 }
 
 static int ar9170_get_stats(struct ieee80211_hw *hw,
@@ -1951,18 +2498,65 @@ static int ar9170_ampdu_action(struct ieee80211_hw *hw,
 			       enum ieee80211_ampdu_mlme_action action,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
+	struct ar9170 *ar = hw->priv;
+	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
+	struct ar9170_sta_tid *tid_info = &sta_info->agg[tid];
+	unsigned long flags;
+
+	if (!modparam_ht)
+		return -EOPNOTSUPP;
+
 	switch (action) {
+	case IEEE80211_AMPDU_TX_START:
+		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
+		if (tid_info->state != AR9170_TID_STATE_STARTING ||
+		    !list_empty(&tid_info->list)) {
+			spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_INFO "%s: A-MPDU [ESS:[%pM] tid:[%d]] "
+			       "is in a very bad state!\n",
+			       wiphy_name(hw->wiphy), sta->addr, tid);
+#endif /* AR9170_TXAGG_DEBUG */
+			return -EBUSY;
+		}
+
+		*ssn = tid_info->ssn;
+		tid_info->state = AR9170_TID_STATE_PROGRESS;
+		tid_info->active = false;
+		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+		ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		break;
+
+	case IEEE80211_AMPDU_TX_STOP:
+		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
+		tid_info->state = AR9170_TID_STATE_SHUTDOWN;
+		list_del_init(&tid_info->list);
+		tid_info->active = false;
+		skb_queue_purge(&tid_info->queue);
+		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		break;
+
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_INFO "%s: A-MPDU for %pM [tid:%d] Operational.\n",
+		       wiphy_name(hw->wiphy), sta->addr, tid);
+#endif /* AR9170_TXAGG_DEBUG */
+		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
+		sta_info->agg[tid].state = AR9170_TID_STATE_COMPLETE;
+		spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
+		break;
+
 	case IEEE80211_AMPDU_RX_START:
 	case IEEE80211_AMPDU_RX_STOP:
-		/*
-		 * Something goes wrong -- RX locks up
-		 * after a while of receiving aggregated
-		 * frames -- not enabling for now.
-		 */
-		return -EOPNOTSUPP;
+		/* Handled by firmware */
+		break;
+
 	default:
 		return -EOPNOTSUPP;
 	}
+
+	return 0;
 }
 
 static const struct ieee80211_ops ar9170_ops = {
@@ -1983,6 +2577,35 @@ static const struct ieee80211_ops ar9170_ops = {
 	.ampdu_action		= ar9170_ampdu_action,
 };
 
+static void ar9170_start_tx_ba(struct work_struct *work)
+{
+	struct ar9170 *ar = container_of(work, struct ar9170,
+					 start_tx_ba_work);
+	unsigned long flags;
+
+	while (!list_empty(&ar->addba_list)) {
+		struct ar9170_sta_tid *tid_info;
+
+		spin_lock_irqsave(&ar->addba_list_lock, flags);
+		tid_info = list_first_entry(&ar->addba_list,
+					    struct ar9170_sta_tid, list);
+		if (tid_info) {
+			tid_info->retry = 0;
+			list_del_init(&tid_info->list);
+
+			if (tid_info->state != AR9170_TID_STATE_STARTING) {
+				WARN_ON(1);
+				tid_info = NULL;
+			}
+		}
+		spin_unlock_irqrestore(&ar->addba_list_lock, flags);
+
+		if (tid_info)
+			ieee80211_start_tx_ba_session(ar->hw, tid_info->addr,
+						      tid_info->tid);
+	}
+}
+
 void *ar9170_alloc(size_t priv_size)
 {
 	struct ieee80211_hw *hw;
@@ -2011,6 +2634,9 @@ void *ar9170_alloc(size_t priv_size)
 	mutex_init(&ar->mutex);
 	spin_lock_init(&ar->cmdlock);
 	spin_lock_init(&ar->tx_stats_lock);
+	spin_lock_init(&ar->addba_list_lock);
+	spin_lock_init(&ar->tx_ampdu_list_lock);
+	skb_queue_head_init(&ar->tx_status_ampdu);
 	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
 		skb_queue_head_init(&ar->tx_status[i]);
 		skb_queue_head_init(&ar->tx_pending[i]);
@@ -2018,7 +2644,10 @@ void *ar9170_alloc(size_t priv_size)
 	ar9170_rx_reset_rx_mpdu(ar);
 	INIT_WORK(&ar->filter_config_work, ar9170_set_filters);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
+	INIT_WORK(&ar->start_tx_ba_work, ar9170_start_tx_ba);
 	INIT_DELAYED_WORK(&ar->tx_janitor, ar9170_tx_janitor);
+	INIT_LIST_HEAD(&ar->tx_ampdu_list);
+	INIT_LIST_HEAD(&ar->addba_list);
 
 	/* all hw supports 2.4 GHz, so set channel to 1 by default */
 	ar->channel = &ar9170_2ghz_chantable[0];
@@ -2032,6 +2661,13 @@ void *ar9170_alloc(size_t priv_size)
 			 IEEE80211_HW_SIGNAL_DBM |
 			 IEEE80211_HW_NOISE_DBM;
 
+	if (modparam_ht) {
+		ar->hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+	} else {
+		ar9170_band_2GHz.ht_cap.ht_supported = false;
+		ar9170_band_5GHz.ht_cap.ht_supported = false;
+	}
+
 	ar->hw->queues = __AR9170_NUM_TXQ;
 	ar->hw->extra_tx_headroom = 8;
 	ar->hw->sta_data_size = sizeof(struct ar9170_sta_info);
@@ -2057,7 +2693,7 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 	u8 *eeprom = (void *)&ar->eeprom;
 	u8 *addr = ar->eeprom.mac_address;
 	__le32 offsets[RW];
-	int i, j, err, bands = 0;
+	int i, j, err, bands = 0, tx_params;
 
 	BUILD_BUG_ON(sizeof(ar->eeprom) & 3);
 
@@ -2093,6 +2729,20 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &ar9170_band_5GHz;
 		bands++;
 	}
+
+	if (ar->eeprom.tx_mask == 1) {
+		/*
+		 * This is presumably a 1x2 device, so the TX/RX mcs sets
+		 * are different.
+		 */
+		tx_params = IEEE80211_HT_MCS_TX_RX_DIFF;
+	} else {
+		tx_params = (1 << IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
+	}
+
+	ar9170_band_2GHz.ht_cap.mcs.tx_params |= tx_params;
+	ar9170_band_5GHz.ht_cap.mcs.tx_params |= tx_params;
+
 	/*
 	 * I measured this, a bandswitch takes roughly
 	 * 135 ms and a frequency switch about 80.

--Boundary-00=_41dKKE/W3mDVE+H
Content-Type: text/x-patch;
  charset="us-ascii";
  name="8-fake-mcs-rate.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8-fake-mcs-rate.diff"

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index e7d4a98..c781980 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1452,6 +1452,11 @@ static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
 			arinfo->flags = AR9170_TX_FLAG_BLOCK_ACK;
 
+#ifndef AR9170_MAC80211_RC_MCS
+			txrate->flags &= ~IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
+			txrate->flags |= IEEE80211_TX_RC_MCS;
+#endif /* AR9170_MAC80211_RC_MCS */
+
 			goto out;
 		}
 
@@ -1513,6 +1518,15 @@ static void ar9170_tx_prepare_phy(struct ar9170 *ar, struct sk_buff *skb)
 		u32 r = txrate->idx;
 		u8 *txpower;
 
+#ifndef AR9170_MAC80211_RC_MCS
+		txrate->flags &= ~IEEE80211_TX_RC_MCS;
+
+		if (ar->eeprom.tx_mask == 1)
+			txrate->idx = r = min_t(s8, txrate->idx, 7);
+		else
+			txrate->idx = r = min_t(s8, txrate->idx, 15);
+#endif /* AR9170_MAC80211_RC_MCS */
+
 		/* heavy clip control */
 		txc->phy_control |= cpu_to_le32((r & 0x7) << 7);
 
@@ -1576,8 +1590,12 @@ static void ar9170_tx_prepare_phy(struct ar9170 *ar, struct sk_buff *skb)
 		chains = AR9170_TX_PHY_TXCHAIN_2;
 
 		/* >= 36M legacy OFDM - use only one chain */
-		if (rate && rate->bitrate >= 360)
-			chains = AR9170_TX_PHY_TXCHAIN_1;
+		if (rate && rate->bitrate >= 360) {
+#ifndef AR9170_MAC80211_RC_MCS
+			if (!(txrate->flags & IEEE80211_TX_RC_MCS))
+#endif /* AR9170_MAC80211_RC_MCS */
+				chains = AR9170_TX_PHY_TXCHAIN_1;
+		}
 	}
 	txc->phy_control |= cpu_to_le32(chains << AR9170_TX_PHY_TXCHAIN_SHIFT);
 }

--Boundary-00=_41dKKE/W3mDVE+H--
