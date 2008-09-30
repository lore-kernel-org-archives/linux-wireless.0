Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26452 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbYI3QCl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 12:02:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 09:02:41 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [RFC v4] mac80211: re-enable aggregation on 2.6.27
Date: Tue, 30 Sep 2008 09:02:28 -0700
Message-ID: <1222790548-7391-1-git-send-email-lrodriguez@atheros.com> (sfid-20080930_180246_718906_39D858D3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-enable aggregation by addressing skb->cb overwrites
after insertion into the qdisc. Aggregation was disabled
after the new TX multiqueue changes were introduced
as it made a bug apparent in mac80211.

Two flags (IEEE80211_TX_CTL_REQUEUE and IEEE80211_TX_CTL_AMPDU)
required for proper aggregation control cannot be relied on
after the new TX multiqueue changes went in due to the fact
that after an skb is insterted into the qdisc the skb->cb is
cleared.

We deal with IEEE80211_TX_CTL_REQUEUE by moving this flag
directly into the skb. We deal with IEEE80211_TX_CTL_AMPDU
by setting this flag again later during the the TX sequence
handler, ieee80211_tx_h_sequence(), by checking if the tid
for the skb for the destination sta is in an active
High Throughput (HT) state.

To properly correct aggregation under the new TX MQ work
we also have to use rtnl_lock() when starting starting
an aggregation session to prevent a possible race against
the skb's queue's removal.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This guy uses list_for_each_entry() and shuffles locking
handling a bit. It leaves locking as it used to for our
driver amdpu handler. I'm about to test it.

 include/linux/skbuff.h     |    4 +
 include/net/mac80211.h     |    4 +-
 net/mac80211/ieee80211_i.h |    7 ++
 net/mac80211/main.c        |  144 +++++++++++++++++++++++++++-----------------
 net/mac80211/rx.c          |    7 +--
 net/mac80211/sta_info.c    |   42 +++++++++++++
 net/mac80211/sta_info.h    |    3 +
 net/mac80211/tx.c          |    3 +
 net/mac80211/wme.c         |   19 +-----
 9 files changed, 155 insertions(+), 78 deletions(-)

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
index ff137fd..f1b5fcf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -215,7 +215,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: TBD
  * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
  *	station
- * @IEEE80211_TX_CTL_REQUEUE: TBD
  * @IEEE80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
  * @IEEE80211_TX_CTL_SHORT_PREAMBLE: TBD
  * @IEEE80211_TX_CTL_LONG_RETRY_LIMIT: this frame should be send using the
@@ -257,12 +256,11 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_NO_ACK			= BIT(4),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(5),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(6),
-	IEEE80211_TX_CTL_REQUEUE		= BIT(7),
 	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(8),
 	IEEE80211_TX_CTL_SHORT_PREAMBLE		= BIT(9),
 	IEEE80211_TX_CTL_LONG_RETRY_LIMIT	= BIT(10),
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(12),
-	IEEE80211_TX_CTL_AMPDU			= BIT(13),
+	IEEE80211_TX_CTL_AMPDU                  = BIT(13),
 	IEEE80211_TX_CTL_OFDM_HT		= BIT(14),
 	IEEE80211_TX_CTL_GREEN_FIELD		= BIT(15),
 	IEEE80211_TX_CTL_40_MHZ_WIDTH		= BIT(16),
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4498d87..549610c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -594,6 +594,10 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
+	spinlock_t sta_ba_lock;
+	struct list_head sta_ba_session_list;
+	struct work_struct sta_ba_session_work;
+
 	unsigned long queues_pending[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
 	unsigned long queues_pending_run[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
 	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES];
@@ -912,6 +916,9 @@ void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16 ssn);
 
 void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
+void initiate_aggr_and_timer(struct sta_info *sta, u16 tid, u16 start_seq_num);
+int __ieee80211_start_tx_ba_session(struct ieee80211_local *local,
+		    struct sta_info *sta, u16 tid, u16 *start_seq_num);
 void sta_addba_resp_timer_expired(unsigned long data);
 void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8 *addr);
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index aa5a191..7acb3de 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -557,12 +557,35 @@ static int ieee80211_stop(struct net_device *dev)
 	return 0;
 }
 
-int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
+/* send an addBA request and set timer for it */
+void initiate_aggr_and_timer(struct sta_info *sta, u16 tid,
+	u16 start_seq_num)
+{
+	sta->ampdu_mlme.dialog_token_allocator++;
+	sta->ampdu_mlme.tid_tx[tid]->dialog_token =
+			sta->ampdu_mlme.dialog_token_allocator;
+	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
+
+
+
+	ieee80211_send_addba_request(sta->sdata->dev, sta->addr, tid,
+			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
+			 sta->ampdu_mlme.tid_tx[tid]->ssn,
+			 0x40, 5000);
+
+	/* activate the timer for the recipient's addBA response */
+	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
+				jiffies + ADDBA_RESP_INTERVAL;
+	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+#endif
+}
+
+int __ieee80211_start_tx_ba_session(struct ieee80211_local *local,
+	   struct sta_info *sta, u16 tid, u16 *start_seq_num)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
-	u16 start_seq_num = 0;
 	u8 *state;
 	int ret;
 	DECLARE_MAC_BUF(mac);
@@ -572,26 +595,13 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Open BA session requested for %s tid %u\n",
-				print_mac(mac, ra), tid);
+				print_mac(mac, sta->addr), tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Could not find the station\n");
-#endif
-		ret = -ENOENT;
-		goto exit;
-	}
-
-	spin_lock_bh(&sta->lock);
-
 	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
-		ret = -EBUSY;
-		goto err_unlock_sta;
+		printk(KERN_DEBUG "BA too many retries tid %u\n", tid);
+		return -EBUSY;
 	}
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
@@ -601,8 +611,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		printk(KERN_DEBUG "BA request denied - session is not "
 				 "idle on tid %u\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		ret = -EAGAIN;
-		goto err_unlock_sta;
+		return -EAGAIN;
 	}
 
 	/* prepare A-MPDU MLME for Tx aggregation */
@@ -614,8 +623,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 			printk(KERN_ERR "allocate tx mlme to tid %d failed\n",
 					tid);
 #endif
-		ret = -ENOMEM;
-		goto err_unlock_sta;
+		return -ENOMEM;
 	}
 	/* Tx timer */
 	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
@@ -634,7 +642,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		printk(KERN_DEBUG "BA request denied - queue unavailable for"
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto err_unlock_queue;
+		goto err;
 	}
 	sdata = sta->sdata;
 
@@ -642,9 +650,11 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	 * call back right away, it must see that the flow has begun */
 	*state |= HT_ADDBA_REQUESTED_MSK;
 
+
 	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
-						ra, tid, &start_seq_num);
+		ret = local->ops->ampdu_action(local_to_hw(local),
+						IEEE80211_AMPDU_TX_START,
+						sta->addr, tid, start_seq_num);
 
 	if (ret) {
 		/* No need to requeue the packets in the agg queue, since we
@@ -656,40 +666,65 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 		*state = HT_AGG_STATE_IDLE;
-		goto err_unlock_queue;
+		goto err;
 	}
 
 	/* Will put all the packets in the new SW queue */
 	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
-	spin_unlock_bh(&sta->lock);
 
-	/* send an addBA request */
-	sta->ampdu_mlme.dialog_token_allocator++;
-	sta->ampdu_mlme.tid_tx[tid]->dialog_token =
-			sta->ampdu_mlme.dialog_token_allocator;
-	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
+	return 0;
 
+err:
+	kfree(sta->ampdu_mlme.tid_tx[tid]);
+	sta->ampdu_mlme.tid_tx[tid] = NULL;
+	return ret;
+}
 
-	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
-			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
-			 sta->ampdu_mlme.tid_tx[tid]->ssn,
-			 0x40, 5000);
-	/* activate the timer for the recipient's addBA response */
-	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
-				jiffies + ADDBA_RESP_INTERVAL;
-	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+	u8 *state;
+	int ret;
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, ra);
+	if (!sta) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+		printk(KERN_DEBUG "Could not find the station\n");
 #endif
-	goto exit;
+		ret = -ENOENT;
+		goto err;
+	}
 
-err_unlock_queue:
-	kfree(sta->ampdu_mlme.tid_tx[tid]);
-	sta->ampdu_mlme.tid_tx[tid] = NULL;
-	ret = -EBUSY;
-err_unlock_sta:
+	spin_lock_bh(&sta->lock);
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	if (*state != HT_AGG_STATE_IDLE) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - session is not "
+				  "idle on tid %u\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		ret = -EAGAIN;
+		spin_unlock_bh(&sta->lock);
+		goto err;
+	}
+
+	*state = HT_AGG_START_PEND_REQ;
 	spin_unlock_bh(&sta->lock);
-exit:
+
+	spin_lock_bh(&local->sta_ba_lock);
+	list_add_tail(&sta->ba_list, &local->sta_ba_session_list);
+	spin_unlock_bh(&local->sta_ba_lock);
+
+	rcu_read_unlock();
+
+	schedule_work(&local->sta_ba_session_work);
+
+	return 0;
+
+err:
 	rcu_read_unlock();
 	return ret;
 }
@@ -858,7 +893,9 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 
 	agg_queue = sta->tid_to_tx_q[tid];
 
+	rtnl_lock();
 	ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
+	rtnl_unlock();
 
 	/* We just requeued the all the frames that were in the
 	 * removed queue, and since we might miss a softirq we do
@@ -1293,8 +1330,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 					    struct sta_info *sta,
 					    struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	sta->tx_filtered_count++;
 
 	/*
@@ -1341,10 +1376,9 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
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
index 6db8545..3e3c870 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -666,7 +666,6 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 	struct sk_buff *skb;
 	int sent = 0;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_info *info;
 	DECLARE_MAC_BUF(mac);
 
 	sdata = sta->sdata;
@@ -685,13 +684,11 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 
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
@@ -699,7 +696,7 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 		       "since STA not sleeping anymore\n", dev->name,
 		       print_mac(mac, sta->addr), sta->aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		dev_queue_xmit(skb);
 	}
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f2ba653..b8dbbb7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -690,12 +690,53 @@ static void ieee80211_sta_flush_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void __ieee80211_run_ba_session(struct ieee80211_local *local)
+{
+	struct sta_info *sta, *sta_tmp;
+	u8 *state;
+	u16 start_seq_num = 0;
+	int tid, r = -EINVAL;
+
+	ASSERT_RTNL();
+
+	spin_lock_bh(&local->sta_ba_lock);
+	list_for_each_entry_safe(sta, sta_tmp,
+			&local->sta_ba_session_list, ba_list) {
+		list_del(&sta->ba_list);
+		spin_lock_bh(&sta->lock);
+		for (tid = 0; tid < STA_TID_NUM; tid++) {
+			state = &sta->ampdu_mlme.tid_state_tx[tid];
+			r = -EINVAL;
+			if (*state & HT_AGG_START_PEND_REQ) {
+				*state &= ~HT_AGG_START_PEND_REQ;
+				r = __ieee80211_start_tx_ba_session(local,
+					sta, tid, &start_seq_num);
+			}
+			if (!r)
+				initiate_aggr_and_timer(sta, tid, start_seq_num);
+		}
+		spin_unlock_bh(&sta->lock);
+	}
+	spin_unlock_bh(&local->sta_ba_lock);
+}
+
+static void ieee80211_sta_ba_session_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, sta_ba_session_work);
+
+	rtnl_lock();
+	__ieee80211_run_ba_session(local);
+	rtnl_unlock();
+}
 void sta_info_init(struct ieee80211_local *local)
 {
 	spin_lock_init(&local->sta_lock);
 	INIT_LIST_HEAD(&local->sta_list);
 	INIT_LIST_HEAD(&local->sta_flush_list);
+	INIT_LIST_HEAD(&local->sta_ba_session_list);
 	INIT_WORK(&local->sta_flush_work, ieee80211_sta_flush_work);
+	INIT_WORK(&local->sta_ba_session_work, ieee80211_sta_ba_session_work);
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
 		    (unsigned long)local);
@@ -717,6 +758,7 @@ void sta_info_stop(struct ieee80211_local *local)
 {
 	del_timer(&local->sta_cleanup);
 	cancel_work_sync(&local->sta_flush_work);
+	cancel_work_sync(&local->sta_ba_session_work);
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/*
 	 * Make sure the debugfs adding work isn't pending after this
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 109db78..cd8626c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -63,6 +63,8 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_OPERATIONAL	(HT_ADDBA_REQUESTED_MSK |	\
 					 HT_ADDBA_DRV_READY_MSK |	\
 					 HT_ADDBA_RECEIVED_MSK)
+#define	HT_AGG_START_PEND_REQ		BIT(5)
+#define	HT_AGG_STOP_PEND_REQ		BIT(6)
 #define HT_AGG_STATE_DEBUGFS_CTL	BIT(7)
 
 /**
@@ -223,6 +225,7 @@ struct sta_info {
 	struct list_head list;
 	struct sta_info *hnext;
 	struct ieee80211_local *local;
+	struct list_head ba_list;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key *key;
 	struct rate_control_ref *rate_ctrl;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4788f7b..b25113f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -655,6 +655,9 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 	seq = &tx->sta->tid_seq[tid];
 
+	if (tx->sta->ampdu_mlme.tid_state_tx[tid] == HT_AGG_STATE_OPERATIONAL)
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
+
 	hdr->seq_ctrl = cpu_to_le16(*seq);
 
 	/* Increase the sequence number. */
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4310e2f..c53bd56 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -113,11 +113,11 @@ static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
 	return ieee802_1d_to_ac[skb->priority];
 }
 
+/* XXX: Remove usage of tid_to_tx_q and only map frames to an AC */
 u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
@@ -126,7 +126,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;
 
-	if (info->flags & IEEE80211_TX_CTL_REQUEUE) {
+	if (skb->requeue) {
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
@@ -135,12 +135,8 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
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
 
@@ -169,12 +165,8 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 			struct ieee80211_hw *hw = &local->hw;
 
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
@@ -188,9 +180,6 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 {
 	int i;
 
-	/* XXX: currently broken due to cb/requeue use */
-	return -EPERM;
-
 	/* prepare the filter and save it for the SW queue
 	 * matching the received HW queue */
 
-- 
1.5.6.3

