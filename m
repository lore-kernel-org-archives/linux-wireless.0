Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32479 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYJTIZm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:25:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 01:25:42 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18684.16351.638713.791015@gargle.gargle.HOWL> (sfid-20081020_102559_596887_A3902E3F)
Date: Mon, 20 Oct 2008 13:52:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@Atheros.com>,
	<johannes@sipsolutions.net>, <tomasw@gmail.com>
Subject: [RFC] mac80211: Re-enable aggregation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

So I really don't see a clean solution for fixing aggregation to allow
ath9k to work. Atheros HW don't have separate queues for managing
aggregation traffic, and right now, we set hw->ampdu_queues to 1, to just
allow aggregation to work at all.

IMHO, mac80211 should handle HW with no aggr. queues too. With this patch,
aggregation works in ath9k. iwlwifi is still broken though, I leave the rtnl
issue to Intel.

Please review.

Sujith

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
---
 drivers/net/wireless/ath9k/main.c         |    2 +-
 drivers/net/wireless/ath9k/xmit.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c     |    4 +-
 include/linux/skbuff.h                    |    7 ++++
 include/net/mac80211.h                    |    5 +--
 net/mac80211/ht.c                         |   57 +++++++++++++++++------------
 net/mac80211/main.c                       |    7 +---
 net/mac80211/rx.c                         |    7 +---
 net/mac80211/tx.c                         |   20 +++++++---
 net/mac80211/wme.c                        |   24 +++++-------
 13 files changed, 77 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 56552a9..1f37f80 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -965,7 +965,7 @@ static int ath_attach(u16 devid,
 	/* FIXME: Have to figure out proper hw init values later */
 
 	hw->queues = 4;
-	hw->ampdu_queues = 1;
+	hw->ampdu_queues = 0;
 
 	/* Register rate control */
 	hw->rate_control_algorithm = "ath9k_rate_control";
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 1afca79..be7533a 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -301,7 +301,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 
 		/* Enable HT only for DATA frames and not for EAPOL */
 		txctl->ht = (hw->conf.ht_cap.ht_supported &&
-			    (tx_info->flags & IEEE80211_TX_CTL_AMPDU));
+			     skb->is_part_ampdu);
 
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			rcs[0].rix = (u8)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9838de5..7059ff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2071,7 +2071,6 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
 		info->status.retry_count = tx_resp->failure_frame;
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_is_tx_success(status)?
 			IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 56a3f0c..9eb09dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1155,7 +1155,6 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
 		info->status.retry_count = tx_resp->failure_frame;
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_is_tx_success(status)?
 			IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index aa300e1..f29562b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -796,7 +796,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		return;
 
 	/* This packet was aggregated but doesn't carry rate scale info */
-	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	if (skb->is_part_ampdu &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
@@ -910,7 +910,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 			tpt = search_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (skb->is_part_ampdu)
 			rs_collect_tx_data(search_win, rs_index, tpt,
 					   info->status.ampdu_ack_len,
 					   info->status.ampdu_ack_map);
@@ -926,7 +926,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 			tpt = curr_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (skb->is_part_ampdu)
 			rs_collect_tx_data(window, rs_index, tpt,
 					   info->status.ampdu_ack_len,
 					   info->status.ampdu_ack_map);
@@ -938,7 +938,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	/* If not searching for new mode, increment success/failed counter
 	 * ... these help determine when to start searching again */
 	if (lq_sta->stay_in_tbl) {
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		if (skb->is_part_ampdu) {
 			lq_sta->total_success += info->status.ampdu_ack_map;
 			lq_sta->total_failed +=
 			     (info->status.ampdu_ack_len - info->status.ampdu_ack_map);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 907a53e..62c6f78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -721,7 +721,7 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 	case ALG_CCMP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (skb_frag->is_part_ampdu)
 			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
 		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
 		break;
@@ -851,7 +851,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (skb->is_part_ampdu)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 	}
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9099237..8c4650e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -244,6 +244,11 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_verd: traffic control verdict
  *	@ndisc_nodetype: router type (from link layer)
  *	@do_not_encrypt: set to prevent encryption of this frame
+ *	@requeue: set to indicate that the wireless core should attempt
+ *		a software retry on this frame if we failed to
+ *		receive an ACK for it
+ *	@is_part_ampdu: set to indicate that the wireless core should should
+ *		treat this frame as part of an AMPDU
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
@@ -319,6 +324,8 @@ struct sk_buff {
 #endif
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
 	__u8			do_not_encrypt:1;
+	__u8			is_part_ampdu:1;
+	__u8			requeue:1;
 #endif
 	/* 0/13/14 bit hole */
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index afcdfaa..2cc3b7c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -229,13 +229,11 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: TBD
  * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
  *	station
- * @IEEE80211_TX_CTL_REQUEUE: TBD
  * @IEEE80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
  * @IEEE80211_TX_CTL_SHORT_PREAMBLE: TBD
  * @IEEE80211_TX_CTL_LONG_RETRY_LIMIT: this frame should be send using the
  *	through set_retry_limit configured long retry value
  * @IEEE80211_TX_CTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
- * @IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
  * @IEEE80211_TX_CTL_OFDM_HT: this frame can be sent in HT OFDM rates. number
  *	of streams when this flag is on can be extracted from antenna_sel_tx,
  *	so if 1 antenna is marked use SISO, 2 antennas marked use MIMO, n
@@ -250,6 +248,7 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
  * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
  * 	is for the whole aggregation.
+
  * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
  * 	so consider using block ack request (BAR).
  * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
@@ -271,12 +270,10 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_NO_ACK			= BIT(4),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(5),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(6),
-	IEEE80211_TX_CTL_REQUEUE		= BIT(7),
 	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(8),
 	IEEE80211_TX_CTL_SHORT_PREAMBLE		= BIT(9),
 	IEEE80211_TX_CTL_LONG_RETRY_LIMIT	= BIT(10),
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(12),
-	IEEE80211_TX_CTL_AMPDU			= BIT(13),
 	IEEE80211_TX_CTL_OFDM_HT		= BIT(14),
 	IEEE80211_TX_CTL_GREEN_FIELD		= BIT(15),
 	IEEE80211_TX_CTL_40_MHZ_WIDTH		= BIT(16),
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index d09e8bf..d85953e 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -549,17 +549,19 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
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
 
@@ -578,7 +580,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		/* No need to requeue the packets in the agg queue, since we
 		 * held the tx lock: no packet could be enqueued to the newly
 		 * allocated queue */
-		ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
+		if (hw->ampdu_queues)
+			ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
 					" tid %d\n", tid);
@@ -588,7 +591,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	}
 
 	/* Will put all the packets in the new SW queue */
-	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
+	if (hw->ampdu_queues)
+		ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&sta->lock);
 
 	/* send an addBA request */
@@ -657,7 +661,8 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 				print_mac(mac, ra), tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
+	if (hw->ampdu_queues)
+		ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
 
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
@@ -670,7 +675,8 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 	if (ret) {
 		WARN_ON(ret != -EBUSY);
 		*state = HT_AGG_STATE_OPERATIONAL;
-		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		if (hw->ampdu_queues)
+			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 		goto stop_BA_exit;
 	}
 
@@ -728,7 +734,8 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
 #endif
-		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		if (hw->ampdu_queues)
+			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 	}
 	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
@@ -784,16 +791,18 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
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
@@ -1050,7 +1059,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		*state |= HT_ADDBA_RECEIVED_MSK;
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
-		if (*state == HT_AGG_STATE_OPERATIONAL)
+		if (*state == HT_AGG_STATE_OPERATIONAL && local->hw.ampdu_queues)
 			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 
 		spin_unlock_bh(&sta->lock);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c936017..4883aa9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -382,8 +382,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 					    struct sta_info *sta,
 					    struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	sta->tx_filtered_count++;
 
 	/*
@@ -430,10 +428,9 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
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
index cdedd37..2d7cab9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -658,9 +658,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	 * This scenario is handled in __ieee80211_tx_prepare but extra
 	 * caution taken here as fragmented ampdu may cause Tx stop.
 	 */
-	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
-		    skb_get_queue_mapping(tx->skb) >=
-			ieee80211_num_regular_queues(&tx->local->hw)))
+	if (WARN_ON(tx->skb->is_part_ampdu))
 		return TX_DROP;
 
 	first = tx->skb;
@@ -943,7 +941,8 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	int hdrlen;
+	int hdrlen, tid;
+	u8 *qc, *state;
 
 	memset(tx, 0, sizeof(*tx));
 	tx->skb = skb;
@@ -976,6 +975,15 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 
 	tx->sta = sta_info_get(local, hdr->addr1);
 
+	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+
+		state = &tx->sta->ampdu_mlme.tid_state_tx[tid];
+		if (*state == HT_AGG_STATE_OPERATIONAL)
+			skb->is_part_ampdu = 1;
+	}
+
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		tx->flags &= ~IEEE80211_TX_UNICAST;
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
@@ -988,7 +996,7 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 		if ((tx->flags & IEEE80211_TX_UNICAST) &&
 		    skb->len + FCS_LEN > local->fragmentation_threshold &&
 		    !local->ops->set_frag_threshold &&
-		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
+		    !skb->is_part_ampdu)
 			tx->flags |= IEEE80211_TX_FRAGMENTED;
 		else
 			tx->flags &= ~IEEE80211_TX_FRAGMENTED;
@@ -1178,7 +1186,7 @@ retry:
 		 * queues, there's no reason for a driver to reject
 		 * a frame there, warn and drop it.
 		 */
-		if (WARN_ON(queue >= ieee80211_num_regular_queues(&local->hw)))
+		if (WARN_ON(skb->is_part_ampdu))
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

