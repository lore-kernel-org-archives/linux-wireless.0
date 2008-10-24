Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42314 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYJXE2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 00:28:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 21:28:07 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18689.20023.569015.421389@gargle.gargle.HOWL> (sfid-20081024_062822_930289_69E6BA0F)
Date: Fri, 24 Oct 2008 09:55:27 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>, <johannes@sipsolutions.net>,
	<tomasw@gmail.com>
Subject: [PATCH v4] mac80211: Re-enable aggregation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless HW without any dedicated queues for aggregation
do not need the ampdu_queues mechanism present right now
in mac80211. Since mac80211 is still incomplete wrt TX MQ
changes, do not allow aggregation sessions for drivers that
set ampdu_queues.

This is only an interim hack until Intel fixes the requeue issue.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
---
V2:

Remove is_part_ampdu from struct sk_buff, and set IEEE80211_TX_CTL_AMPDU
in __ieee80211_tx_prepare() - which I think is a better place than ieee80211_tx_h_sequence().

Also, add requeue to __skb_clone() - pointed out by Jouni.

V3:

Add a HW flag IEEE80211_HW_AMPDU_AGGREGATION and check in
ieee80211_start_tx_ba_session().
Remove ampdu_queues initialization in ath9k.

Tomas - can you verify if hw->flags in iwl-core.c is the only place that needs
to be set ?

v4:

Rebased against current wireless-testing.

 drivers/net/wireless/ath9k/main.c       |    6 +--
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +-
 include/linux/skbuff.h                  |    4 ++
 include/net/mac80211.h                  |    8 ++--
 net/core/skbuff.c                       |    1 +
 net/mac80211/ht.c                       |   60 ++++++++++++++++++-------------
 net/mac80211/main.c                     |    7 +---
 net/mac80211/rx.c                       |    7 +---
 net/mac80211/tx.c                       |   19 +++++++---
 net/mac80211/wme.c                      |   24 +++++-------
 10 files changed, 76 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 5b49552..34a7443 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -954,10 +954,7 @@ static int ath_attach(u16 devid,
 			&sc->sbands[IEEE80211_BAND_5GHZ];
 	}
 
-	/* FIXME: Have to figure out proper hw init values later */
-
 	hw->queues = 4;
-	hw->ampdu_queues = 1;
 
 	/* Register rate control */
 	hw->rate_control_algorithm = "ath9k_rate_control";
@@ -1747,7 +1744,8 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM;
+		IEEE80211_HW_NOISE_DBM |
+		IEEE80211_HW_AMPDU_AGGREGATION;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 20c7ff3..ba05f5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -871,7 +871,8 @@ int iwl_setup_mac(struct iwl_priv *priv)
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM;
+		    IEEE80211_HW_NOISE_DBM |
+		    IEEE80211_HW_AMPDU_AGGREGATION;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9099237..4724211 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -244,6 +244,9 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_verd: traffic control verdict
  *	@ndisc_nodetype: router type (from link layer)
  *	@do_not_encrypt: set to prevent encryption of this frame
+ *	@requeue: set to indicate that the wireless core should attempt
+ *		a software retry on this frame if we failed to
+ *		receive an ACK for it
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
@@ -319,6 +322,7 @@ struct sk_buff {
 #endif
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
 	__u8			do_not_encrypt:1;
+	__u8			requeue:1;
 #endif
 	/* 0/13/14 bit hole */
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 11df487..7b0d46b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -242,7 +242,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: internal to mac80211, can be
  *	set by rate control algorithms to indicate probe rate, will
  *	be cleared for fragmented frames (except on the last fragment)
- * @IEEE80211_TX_CTL_REQUEUE: REMOVE THIS
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -258,9 +257,6 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU			= BIT(10),
 	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
-
-	/* XXX: remove this */
-	IEEE80211_TX_CTL_REQUEUE		= BIT(13),
 };
 
 enum mac80211_rate_control_flags {
@@ -847,6 +843,9 @@ enum ieee80211_tkip_key_type {
  * @IEEE80211_HW_SPECTRUM_MGMT:
  * 	Hardware supports spectrum management defined in 802.11h
  * 	Measurement, Channel Switch, Quieting, TPC
+ *
+ * @IEEE80211_HW_AMPDU_AGGREGATION:
+ *	Hardware supports 11n A-MPDU aggregation.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -858,6 +857,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SIGNAL_DBM				= 1<<7,
 	IEEE80211_HW_NOISE_DBM				= 1<<8,
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
+	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
 };
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ca1ccdf..b0acc86 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -487,6 +487,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	C(truesize);
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
 	C(do_not_encrypt);
+	C(requeue);
 #endif
 	atomic_set(&n->users, 1);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index b3f9e9d..1453cb5 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -460,7 +460,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	int ret;
 	DECLARE_MAC_BUF(mac);
 
-	if (tid >= STA_TID_NUM)
+	if ((tid >= STA_TID_NUM) || !(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
 		return -EINVAL;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -517,17 +517,19 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 			(unsigned long)&sta->timer_to_tid[tid];
 	init_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 
-	/* create a new queue for this aggregation */
-	ret = ieee80211_ht_agg_queue_add(local, sta, tid);
+	if (hw->ampdu_queues) {
+		/* create a new queue for this aggregation */
+		ret = ieee80211_ht_agg_queue_add(local, sta, tid);
 
-	/* case no queue is available to aggregation
-	 * don't switch to aggregation */
-	if (ret) {
+		/* case no queue is available to aggregation
+		 * don't switch to aggregation */
+		if (ret) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - queue unavailable for"
-					" tid %d\n", tid);
+			printk(KERN_DEBUG "BA request denied - "
+			       "queue unavailable for tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto err_unlock_queue;
+			goto err_unlock_queue;
+		}
 	}
 	sdata = sta->sdata;
 
@@ -546,7 +548,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		/* No need to requeue the packets in the agg queue, since we
 		 * held the tx lock: no packet could be enqueued to the newly
 		 * allocated queue */
-		ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
+		if (hw->ampdu_queues)
+			ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
 					" tid %d\n", tid);
@@ -556,7 +559,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	}
 
 	/* Will put all the packets in the new SW queue */
-	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
+	if (hw->ampdu_queues)
+		ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&sta->lock);
 
 	/* send an addBA request */
@@ -625,7 +629,8 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 				print_mac(mac, ra), tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
+	if (hw->ampdu_queues)
+		ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
 
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
@@ -638,7 +643,8 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 	if (ret) {
 		WARN_ON(ret != -EBUSY);
 		*state = HT_AGG_STATE_OPERATIONAL;
-		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		if (hw->ampdu_queues)
+			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 		goto stop_BA_exit;
 	}
 
@@ -696,7 +702,8 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
 #endif
-		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		if (hw->ampdu_queues)
+			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 	}
 	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
@@ -752,16 +759,18 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 		ieee80211_send_delba(sta->sdata, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
-	agg_queue = sta->tid_to_tx_q[tid];
-
-	ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
-
-	/* We just requeued the all the frames that were in the
-	 * removed queue, and since we might miss a softirq we do
-	 * netif_schedule_queue.  ieee80211_wake_queue is not used
-	 * here as this queue is not necessarily stopped
-	 */
-	netif_schedule_queue(netdev_get_tx_queue(local->mdev, agg_queue));
+	if (hw->ampdu_queues) {
+		agg_queue = sta->tid_to_tx_q[tid];
+		ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
+
+		/* We just requeued the all the frames that were in the
+		 * removed queue, and since we might miss a softirq we do
+		 * netif_schedule_queue.  ieee80211_wake_queue is not used
+		 * here as this queue is not necessarily stopped
+		 */
+		netif_schedule_queue(netdev_get_tx_queue(local->mdev,
+							 agg_queue));
+	}
 	spin_lock_bh(&sta->lock);
 	*state = HT_AGG_STATE_IDLE;
 	sta->ampdu_mlme.addba_req_num[tid] = 0;
@@ -1019,7 +1028,8 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		*state |= HT_ADDBA_RECEIVED_MSK;
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
-		if (*state == HT_AGG_STATE_OPERATIONAL)
+		if (*state == HT_AGG_STATE_OPERATIONAL &&
+		    local->hw.ampdu_queues)
 			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 
 		spin_unlock_bh(&sta->lock);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 88c1975..fa0cc7a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -386,8 +386,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 					    struct sta_info *sta,
 					    struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	sta->tx_filtered_count++;
 
 	/*
@@ -434,10 +432,9 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
-	if (!test_sta_flags(sta, WLAN_STA_PS) &&
-	    !(info->flags & IEEE80211_TX_CTL_REQUEUE)) {
+	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
 		/* Software retry the packet once */
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		ieee80211_remove_tx_extra(local, sta->key, skb);
 		dev_queue_xmit(skb);
 		return;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a0db162..7c3702c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -670,7 +670,6 @@ static int ap_sta_ps_end(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	int sent = 0;
-	struct ieee80211_tx_info *info;
 	DECLARE_MAC_BUF(mac);
 
 	atomic_dec(&sdata->bss->num_sta_ps);
@@ -687,13 +686,11 @@ static int ap_sta_ps_end(struct sta_info *sta)
 
 	/* Send all buffered frames to the station */
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-		info = IEEE80211_SKB_CB(skb);
 		sent++;
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		dev_queue_xmit(skb);
 	}
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		info = IEEE80211_SKB_CB(skb);
 		local->total_ps_buffered--;
 		sent++;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -701,7 +698,7 @@ static int ap_sta_ps_end(struct sta_info *sta)
 		       "since STA not sleeping anymore\n", sdata->dev->name,
 		       print_mac(mac, sta->sta.addr), sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		dev_queue_xmit(skb);
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8b56048..f006e84 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -663,6 +663,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
 	struct sk_buff **frags, *first, *frag;
@@ -679,9 +680,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	 * This scenario is handled in __ieee80211_tx_prepare but extra
 	 * caution taken here as fragmented ampdu may cause Tx stop.
 	 */
-	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
-		    skb_get_queue_mapping(tx->skb) >=
-			ieee80211_num_regular_queues(&tx->local->hw)))
+	if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
 		return TX_DROP;
 
 	first = tx->skb;
@@ -953,7 +952,8 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	int hdrlen;
+	int hdrlen, tid;
+	u8 *qc, *state;
 
 	memset(tx, 0, sizeof(*tx));
 	tx->skb = skb;
@@ -984,6 +984,15 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 
 	tx->sta = sta_info_get(local, hdr->addr1);
 
+	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+
+		state = &tx->sta->ampdu_mlme.tid_state_tx[tid];
+		if (*state == HT_AGG_STATE_OPERATIONAL)
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
+	}
+
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		tx->flags &= ~IEEE80211_TX_UNICAST;
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
@@ -1174,7 +1183,7 @@ retry:
 		 * queues, there's no reason for a driver to reject
 		 * a frame there, warn and drop it.
 		 */
-		if (WARN_ON(queue >= ieee80211_num_regular_queues(&local->hw)))
+		if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
 			goto drop;
 
 		store = &local->pending_packet[queue];
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index f10f770..3247312 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -114,8 +114,8 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
 	struct ieee80211_local *local = mpriv->local;
+	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
@@ -124,21 +124,19 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;
 
-	if (info->flags & IEEE80211_TX_CTL_REQUEUE) {
+	if (skb->requeue) {
+		if (!hw->ampdu_queues)
+			return queue;
+
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		if (sta) {
-			struct ieee80211_hw *hw = &local->hw;
 			int ampdu_queue = sta->tid_to_tx_q[tid];
 
 			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool)) {
+			    test_bit(ampdu_queue, local->queue_pool))
 				queue = ampdu_queue;
-				info->flags |= IEEE80211_TX_CTL_AMPDU;
-			} else {
-				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-			}
 		}
 		rcu_read_unlock();
 
@@ -159,20 +157,18 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 		*p++ = ack_policy | tid;
 		*p = 0;
 
+		if (!hw->ampdu_queues)
+			return queue;
+
 		rcu_read_lock();
 
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
-			struct ieee80211_hw *hw = &local->hw;
 
 			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool)) {
+			    test_bit(ampdu_queue, local->queue_pool))
 				queue = ampdu_queue;
-				info->flags |= IEEE80211_TX_CTL_AMPDU;
-			} else {
-				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-			}
 		}
 
 		rcu_read_unlock();
-- 
1.6.0.2

