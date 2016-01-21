Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35116 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965327AbcAUNpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:45:55 -0500
Received: by mail-lf0-f51.google.com with SMTP id c192so26821412lfe.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:45:54 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 13/13] ath10k: implement push-pull tx
Date: Thu, 21 Jan 2016 14:46:46 +0100
Message-Id: <1453384006-31907-14-git-send-email-michal.kazior@tieto.com> (sfid-20160121_150653_562343_767CE609)
In-Reply-To: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current/old tx path design was that host, at
its own leisure, pushed tx frames to the device.
For HTT there was ~1000-1400 msdu queue depth.

After reaching that limit the driver would request
mac80211 to stop queues. There was little control
over what packets got in there as far as
DA/RA was considered so it was rather easy to
starve per-station traffic flows.

With MU-MIMO this became a significant problem
because the queue depth was insufficient to buffer
frames from multiple clients (which could have
different signal quality and capabilities) in an
efficient fashion.

Hence the new tx path in 10.4 was introduced: a
pull-push mode.

Firmware and host can share tx queue state via
DMA. The state is logically a 2 dimensional array
addressed via peer_id+tid pair. Each entry is a
counter (either number of bytes or packets. Host
keeps it updated and firmware uses it for
scheduling Tx pull requests to host.

This allows MU-MIMO to become a lot more effective
with 10+ clients.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |   1 +
 drivers/net/wireless/ath/ath10k/htt.h    |   6 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 117 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/htt_tx.c |  39 ++++++++---
 drivers/net/wireless/ath/ath10k/mac.c    |  48 +++++++++++--
 drivers/net/wireless/ath/ath10k/mac.h    |   5 ++
 6 files changed, 192 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f51887c6be74..ab8cbccc0f4b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -307,6 +307,7 @@ struct ath10k_peer {
 
 struct ath10k_txq {
 	unsigned long num_fw_queued;
+	unsigned long num_push_allowed;
 };
 
 struct ath10k_sta {
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index b1e40f44e76b..02cf55d306e8 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1652,6 +1652,7 @@ struct ath10k_htt {
 	struct sk_buff_head tx_compl_q;
 	struct sk_buff_head rx_compl_q;
 	struct sk_buff_head rx_in_ord_compl_q;
+	struct sk_buff_head tx_fetch_ind_q;
 
 	/* rx_status template */
 	struct ieee80211_rx_status rx_status;
@@ -1670,8 +1671,10 @@ struct ath10k_htt {
 		bool enabled;
 		struct htt_q_state *vaddr;
 		dma_addr_t paddr;
+		u16 num_push_allowed;
 		u16 num_peers;
 		u16 num_tids;
+		enum htt_tx_mode_switch_mode mode;
 		enum htt_q_depth_type type;
 	} tx_q_state;
 };
@@ -1761,6 +1764,9 @@ int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 
 void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
+void ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq);
+void ath10k_htt_tx_txq_sync(struct ath10k *ar);
 void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt,
 			       bool is_mgmt);
 int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6e3d95c95568..827c8369b589 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -229,6 +229,7 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 	skb_queue_purge(&htt->tx_compl_q);
 	skb_queue_purge(&htt->rx_compl_q);
 	skb_queue_purge(&htt->rx_in_ord_compl_q);
+	skb_queue_purge(&htt->tx_fetch_ind_q);
 
 	ath10k_htt_rx_ring_free(htt);
 
@@ -569,6 +570,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	skb_queue_head_init(&htt->tx_compl_q);
 	skb_queue_head_init(&htt->rx_compl_q);
 	skb_queue_head_init(&htt->rx_in_ord_compl_q);
+	skb_queue_head_init(&htt->tx_fetch_ind_q);
 
 	tasklet_init(&htt->txrx_compl_task, ath10k_htt_txrx_compl_task,
 		     (unsigned long)htt);
@@ -2004,16 +2006,21 @@ static void ath10k_htt_rx_tx_fetch_resp_id_confirm(struct ath10k *ar,
 
 static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 {
+	struct ieee80211_hw *hw = ar->hw;
+	struct ieee80211_txq *txq;
 	struct htt_resp *resp = (struct htt_resp *)skb->data;
 	struct htt_tx_fetch_record *record;
 	size_t len;
 	size_t max_num_bytes;
 	size_t max_num_msdus;
+	size_t num_bytes;
+	size_t num_msdus;
 	const __le32 *resp_ids;
 	u16 num_records;
 	u16 num_resp_ids;
 	u16 peer_id;
 	u8 tid;
+	int ret;
 	int i;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch ind\n");
@@ -2039,7 +2046,17 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 		   num_records, num_resp_ids,
 		   le16_to_cpu(resp->tx_fetch_ind.fetch_seq_num));
 
-	/* TODO: runtime sanity checks */
+	if (!ar->htt.tx_q_state.enabled) {
+		ath10k_warn(ar, "received unexpected tx_fetch_ind event: not enabled\n");
+		return;
+	}
+
+	if (ar->htt.tx_q_state.mode == HTT_TX_MODE_SWITCH_PUSH) {
+		ath10k_warn(ar, "received unexpected tx_fetch_ind event: in push mode\n");
+		return;
+	}
+
+	rcu_read_lock();
 
 	for (i = 0; i < num_records; i++) {
 		record = &resp->tx_fetch_ind.records[i];
@@ -2060,13 +2077,56 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 			continue;
 		}
 
-		/* TODO: dequeue and submit tx to device */
+		spin_lock_bh(&ar->data_lock);
+		txq = ath10k_mac_txq_lookup(ar, peer_id, tid);
+		spin_unlock_bh(&ar->data_lock);
+
+		/* It is okay to release the lock and use txq because RCU read
+		 * lock is held.
+		 */
+
+		if (unlikely(!txq)) {
+			ath10k_warn(ar, "failed to lookup txq for peer_id %hu tid %hhu\n",
+				    peer_id, tid);
+			continue;
+		}
+
+		num_msdus = 0;
+		num_bytes = 0;
+
+		while (num_msdus < max_num_msdus &&
+		       num_bytes < max_num_bytes) {
+			ret = ath10k_mac_tx_push_txq(hw, txq);
+			if (ret < 0)
+				break;
+
+			num_msdus++;
+			num_bytes += ret;
+		}
+
+		record->num_msdus = cpu_to_le16(num_msdus);
+		record->num_bytes = cpu_to_le32(num_bytes);
+
+		ath10k_htt_tx_txq_recalc(hw, txq);
 	}
 
+	rcu_read_unlock();
+
 	resp_ids = ath10k_htt_get_tx_fetch_ind_resp_ids(&resp->tx_fetch_ind);
 	ath10k_htt_rx_tx_fetch_resp_id_confirm(ar, resp_ids, num_resp_ids);
 
-	/* TODO: generate and send fetch response to device */
+	ret = ath10k_htt_tx_fetch_resp(ar,
+				       resp->tx_fetch_ind.token,
+				       resp->tx_fetch_ind.fetch_seq_num,
+				       resp->tx_fetch_ind.records,
+				       num_records);
+	if (unlikely(ret)) {
+		ath10k_warn(ar, "failed to submit tx fetch resp for token 0x%08x: %d\n",
+			    le32_to_cpu(resp->tx_fetch_ind.token), ret);
+		/* FIXME: request fw restart */
+	}
+
+	ath10k_htt_tx_txq_sync(ar);
 }
 
 static void ath10k_htt_rx_tx_fetch_confirm(struct ath10k *ar,
@@ -2102,6 +2162,8 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 {
 	const struct htt_resp *resp = (void *)skb->data;
 	const struct htt_tx_mode_switch_record *record;
+	struct ieee80211_txq *txq;
+	struct ath10k_txq *artxq;
 	size_t len;
 	size_t num_records;
 	enum htt_tx_mode_switch_mode mode;
@@ -2153,7 +2215,11 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 	if (!enable)
 		return;
 
-	/* TODO: apply configuration */
+	ar->htt.tx_q_state.enabled = enable;
+	ar->htt.tx_q_state.mode = mode;
+	ar->htt.tx_q_state.num_push_allowed = threshold;
+
+	rcu_read_lock();
 
 	for (i = 0; i < num_records; i++) {
 		record = &resp->tx_mode_switch_ind.records[i];
@@ -2168,10 +2234,33 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 			continue;
 		}
 
-		/* TODO: apply configuration */
+		spin_lock_bh(&ar->data_lock);
+		txq = ath10k_mac_txq_lookup(ar, peer_id, tid);
+		spin_unlock_bh(&ar->data_lock);
+
+		/* It is okay to release the lock and use txq because RCU read
+		 * lock is held.
+		 */
+
+		if (unlikely(!txq)) {
+			ath10k_warn(ar, "failed to lookup txq for peer_id %hu tid %hhu\n",
+				    peer_id, tid);
+			continue;
+		}
+
+		spin_lock_bh(&ar->htt.tx_lock);
+		artxq = (void *)txq->drv_priv;
+		artxq->num_push_allowed = le16_to_cpu(record->num_max_msdus);
+		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	/* TODO: apply configuration */
+	rcu_read_unlock();
+
+	spin_lock_bh(&ar->htt.tx_lock);
+	ath10k_mac_tx_lock(ar, ATH10K_TX_PAUSE_Q_FLUSH_PENDING);
+	spin_unlock_bh(&ar->htt.tx_lock);
+
+	ath10k_mac_tx_push_pending(ar);
 }
 
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
@@ -2317,8 +2406,9 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_AGGR_CONF:
 		break;
 	case HTT_T2H_MSG_TYPE_TX_FETCH_IND:
-		ath10k_htt_rx_tx_fetch_ind(ar, skb);
-		break;
+		skb_queue_tail(&htt->tx_fetch_ind_q, skb);
+		tasklet_schedule(&htt->txrx_compl_task);
+		return;
 	case HTT_T2H_MSG_TYPE_TX_FETCH_CONFIRM:
 		ath10k_htt_rx_tx_fetch_confirm(ar, skb);
 		break;
@@ -2356,21 +2446,32 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
 	struct ath10k *ar = htt->ar;
 	struct sk_buff_head tx_q;
+	struct sk_buff_head tx_ind_q;
 	struct htt_resp *resp;
 	struct sk_buff *skb;
 	unsigned long flags;
 
 	__skb_queue_head_init(&tx_q);
+	__skb_queue_head_init(&tx_ind_q);
 
 	spin_lock_irqsave(&htt->tx_compl_q.lock, flags);
 	skb_queue_splice_init(&htt->tx_compl_q, &tx_q);
 	spin_unlock_irqrestore(&htt->tx_compl_q.lock, flags);
 
+	spin_lock_irqsave(&htt->tx_fetch_ind_q.lock, flags);
+	skb_queue_splice_init(&htt->tx_fetch_ind_q, &tx_ind_q);
+	spin_unlock_irqrestore(&htt->tx_fetch_ind_q.lock, flags);
+
 	while ((skb = __skb_dequeue(&tx_q))) {
 		ath10k_htt_rx_frm_tx_compl(htt->ar, skb);
 		dev_kfree_skb_any(skb);
 	}
 
+	while ((skb = __skb_dequeue(&tx_ind_q))) {
+		ath10k_htt_rx_tx_fetch_ind(ar, skb);
+		dev_kfree_skb_any(skb);
+	}
+
 	ath10k_mac_tx_push_pending(ar);
 
 	spin_lock_bh(&htt->rx_ring.lock);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 5ef0a1b3773c..00877ff6861e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -62,6 +62,9 @@ static void __ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
 	if (!ar->htt.tx_q_state.enabled)
 		return;
 
+	if (ar->htt.tx_q_state.mode != HTT_TX_MODE_SWITCH_PUSH_PULL)
+		return;
+
 	if (txq->sta)
 		peer_id = arsta->peer_id;
 	else
@@ -97,6 +100,9 @@ static void __ath10k_htt_tx_txq_sync(struct ath10k *ar)
 	if (!ar->htt.tx_q_state.enabled)
 		return;
 
+	if (ar->htt.tx_q_state.mode != HTT_TX_MODE_SWITCH_PUSH_PULL)
+		return;
+
 	seq = le32_to_cpu(ar->htt.tx_q_state.vaddr->seq);
 	seq++;
 	ar->htt.tx_q_state.vaddr->seq = cpu_to_le32(seq);
@@ -111,6 +117,23 @@ static void __ath10k_htt_tx_txq_sync(struct ath10k *ar)
 				   DMA_TO_DEVICE);
 }
 
+void ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq)
+{
+	struct ath10k *ar = hw->priv;
+
+	spin_lock_bh(&ar->htt.tx_lock);
+	__ath10k_htt_tx_txq_recalc(hw, txq);
+	spin_unlock_bh(&ar->htt.tx_lock);
+}
+
+void ath10k_htt_tx_txq_sync(struct ath10k *ar)
+{
+	spin_lock_bh(&ar->htt.tx_lock);
+	__ath10k_htt_tx_txq_sync(ar);
+	spin_unlock_bh(&ar->htt.tx_lock);
+}
+
 void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq)
 {
@@ -634,10 +657,14 @@ int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 {
 	struct sk_buff *skb;
 	struct htt_cmd *cmd;
-	u16 resp_id;
+	const u16 resp_id = 0;
 	int len = 0;
 	int ret;
 
+	/* Response IDs are echo-ed back only for host driver convienence
+	 * purposes. They aren't used for anything in the driver yet so use 0.
+	 */
+
 	len += sizeof(cmd->hdr);
 	len += sizeof(cmd->tx_fetch_resp);
 	len += sizeof(cmd->tx_fetch_resp.records[0]) * num_records;
@@ -646,11 +673,6 @@ int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 	if (!skb)
 		return -ENOMEM;
 
-	resp_id = 0; /* TODO: allocate resp_id */
-	ret = 0;
-	if (ret)
-		goto err_free_skb;
-
 	skb_put(skb, len);
 	cmd = (struct htt_cmd *)skb->data;
 	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_TX_FETCH_RESP;
@@ -665,14 +687,11 @@ int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 	ret = ath10k_htc_send(&ar->htc, ar->htt.eid, skb);
 	if (ret) {
 		ath10k_warn(ar, "failed to submit htc command: %d\n", ret);
-		goto err_free_resp_id;
+		goto err_free_skb;
 	}
 
 	return 0;
 
-err_free_resp_id:
-	(void)resp_id; /* TODO: free resp_id */
-
 err_free_skb:
 	dev_kfree_skb_any(skb);
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0dc16de1d9fb..ee94c83b5128 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3629,11 +3629,25 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
 				   struct ieee80211_txq *txq)
 {
-	return 1; /* TBD */
+	struct ath10k *ar = hw->priv;
+	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+
+	/* No need to get locks */
+
+	if (ar->htt.tx_q_state.mode == HTT_TX_MODE_SWITCH_PUSH)
+		return true;
+
+	if (ar->htt.num_pending_tx < ar->htt.tx_q_state.num_push_allowed)
+		return true;
+
+	if (artxq->num_fw_queued < artxq->num_push_allowed)
+		return true;
+
+	return false;
 }
 
-static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
-				  struct ieee80211_txq *txq)
+int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
+			   struct ieee80211_txq *txq)
 {
 	const bool is_mgmt = false;
 	const bool is_presp = false;
@@ -3645,6 +3659,7 @@ static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	enum ath10k_hw_txrx_mode txmode;
 	enum ath10k_mac_tx_path txpath;
 	struct sk_buff *skb;
+	size_t skb_len;
 	int ret;
 
 	spin_lock_bh(&ar->htt.tx_lock);
@@ -3665,6 +3680,7 @@ static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 
 	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
 
+	skb_len = skb->len;
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
 
@@ -3683,7 +3699,7 @@ static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	artxq->num_fw_queued++;
 	spin_unlock_bh(&ar->htt.tx_lock);
 
-	return 0;
+	return skb_len;
 }
 
 static void ath10k_mac_tx_push(struct ieee80211_hw *hw,
@@ -3693,7 +3709,7 @@ static void ath10k_mac_tx_push(struct ieee80211_hw *hw,
 	int ret;
 
 	ret = ath10k_mac_tx_push_txq(hw, txq);
-	if (unlikely(ret)) {
+	if (unlikely(ret < 0)) {
 		if (txq->sta)
 			ath10k_warn(ar, "failed to push tx to station %pM tid %hhu: %d\n",
 				    txq->sta->addr, txq->tid, ret);
@@ -3738,7 +3754,7 @@ static void ath10k_mac_tx_push_pending_txq(struct ieee80211_hw *hw,
 			break;
 
 		ret = ath10k_mac_tx_push_txq(hw, txq);
-		if (ret)
+		if (ret < 0)
 			break;
 	}
 
@@ -3820,6 +3836,26 @@ static void ath10k_mac_txq_unref(struct ath10k *ar,
 	spin_unlock_bh(&ar->htt.tx_lock);
 }
 
+struct ieee80211_txq *ath10k_mac_txq_lookup(struct ath10k *ar,
+					    u16 peer_id,
+					    u8 tid)
+{
+	struct ath10k_peer *peer;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	peer = ar->peer_map[peer_id];
+	if (!peer)
+		return NULL;
+
+	if (peer->sta)
+		return peer->sta->txq[tid];
+	else if (peer->vif)
+		return peer->vif->txq;
+	else
+		return NULL;
+}
+
 /************/
 /* Scanning */
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 453f606a250e..2c3327beb445 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -76,6 +76,11 @@ void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason);
 void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason);
 bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar);
 void ath10k_mac_tx_push_pending(struct ath10k *ar);
+int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
+			   struct ieee80211_txq *txq);
+struct ieee80211_txq *ath10k_mac_txq_lookup(struct ath10k *ar,
+					    u16 peer_id,
+					    u8 tid);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
-- 
2.1.4

