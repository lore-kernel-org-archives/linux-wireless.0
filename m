Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab2BMKYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:01 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/24] iwlegacy: gather all 4965 handlers in one place
Date: Mon, 13 Feb 2012 11:23:13 +0100
Message-Id: <1329128611-6815-7-git-send-email-sgruszka@redhat.com> (sfid-20120213_112453_944357_7C83C199)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handers belongs logically into 4965-mac.c file.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |  307 +++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlegacy/4965.c     |  312 ------------------------------
 drivers/net/wireless/iwlegacy/4965.h     |    9 -
 drivers/net/wireless/iwlegacy/common.h   |    2 -
 4 files changed, 305 insertions(+), 325 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 7bf78bf..4560021 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2548,6 +2548,308 @@ il4965_tx_status_reply_compressed_ba(struct il_priv *il, struct il_ht_agg *agg,
 	return 0;
 }
 
+static inline bool
+il4965_is_tx_success(u32 status)
+{
+	status &= TX_STATUS_MSK;
+	return (status == TX_STATUS_SUCCESS || status == TX_STATUS_DIRECT_DONE);
+}
+
+static u8
+il4965_find_station(struct il_priv *il, const u8 *addr)
+{
+	int i;
+	int start = 0;
+	int ret = IL_INVALID_STATION;
+	unsigned long flags;
+
+	if (il->iw_mode == NL80211_IFTYPE_ADHOC)
+		start = IL_STA_ID;
+
+	if (is_broadcast_ether_addr(addr))
+		return il->hw_params.bcast_id;
+
+	spin_lock_irqsave(&il->sta_lock, flags);
+	for (i = start; i < il->hw_params.max_stations; i++)
+		if (il->stations[i].used &&
+		    (!compare_ether_addr(il->stations[i].sta.sta.addr, addr))) {
+			ret = i;
+			goto out;
+		}
+
+	D_ASSOC("can not find STA %pM total %d\n", addr, il->num_stations);
+
+out:
+	/*
+	 * It may be possible that more commands interacting with stations
+	 * arrive before we completed processing the adding of
+	 * station
+	 */
+	if (ret != IL_INVALID_STATION &&
+	    (!(il->stations[ret].used & IL_STA_UCODE_ACTIVE) ||
+	     ((il->stations[ret].used & IL_STA_UCODE_ACTIVE) &&
+	      (il->stations[ret].used & IL_STA_UCODE_INPROGRESS)))) {
+		IL_ERR("Requested station info for sta %d before ready.\n",
+		       ret);
+		ret = IL_INVALID_STATION;
+	}
+	spin_unlock_irqrestore(&il->sta_lock, flags);
+	return ret;
+}
+
+static int
+il4965_get_ra_sta_id(struct il_priv *il, struct ieee80211_hdr *hdr)
+{
+	if (il->iw_mode == NL80211_IFTYPE_STATION)
+		return IL_AP_ID;
+	else {
+		u8 *da = ieee80211_get_DA(hdr);
+
+		return il4965_find_station(il, da);
+	}
+}
+
+static inline u32
+il4965_get_scd_ssn(struct il4965_tx_resp *tx_resp)
+{
+	return le32_to_cpup(&tx_resp->u.status + tx_resp->frame_count) & MAX_SN;
+}
+
+static inline u32
+il4965_tx_status_to_mac80211(u32 status)
+{
+	status &= TX_STATUS_MSK;
+
+	switch (status) {
+	case TX_STATUS_SUCCESS:
+	case TX_STATUS_DIRECT_DONE:
+		return IEEE80211_TX_STAT_ACK;
+	case TX_STATUS_FAIL_DEST_PS:
+		return IEEE80211_TX_STAT_TX_FILTERED;
+	default:
+		return 0;
+	}
+}
+
+/**
+ * il4965_tx_status_reply_tx - Handle Tx response for frames in aggregation queue
+ */
+static int
+il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
+			  struct il4965_tx_resp *tx_resp, int txq_id,
+			  u16 start_idx)
+{
+	u16 status;
+	struct agg_tx_status *frame_status = tx_resp->u.agg_status;
+	struct ieee80211_tx_info *info = NULL;
+	struct ieee80211_hdr *hdr = NULL;
+	u32 rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
+	int i, sh, idx;
+	u16 seq;
+	if (agg->wait_for_ba)
+		D_TX_REPLY("got tx response w/o block-ack\n");
+
+	agg->frame_count = tx_resp->frame_count;
+	agg->start_idx = start_idx;
+	agg->rate_n_flags = rate_n_flags;
+	agg->bitmap = 0;
+
+	/* num frames attempted by Tx command */
+	if (agg->frame_count == 1) {
+		/* Only one frame was attempted; no block-ack will arrive */
+		status = le16_to_cpu(frame_status[0].status);
+		idx = start_idx;
+
+		D_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
+			   agg->frame_count, agg->start_idx, idx);
+
+		info = IEEE80211_SKB_CB(il->txq[txq_id].skbs[idx]);
+		info->status.rates[0].count = tx_resp->failure_frame + 1;
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+		info->flags |= il4965_tx_status_to_mac80211(status);
+		il4965_hwrate_to_tx_control(il, rate_n_flags, info);
+
+		D_TX_REPLY("1 Frame 0x%x failure :%d\n", status & 0xff,
+			   tx_resp->failure_frame);
+		D_TX_REPLY("Rate Info rate_n_flags=%x\n", rate_n_flags);
+
+		agg->wait_for_ba = 0;
+	} else {
+		/* Two or more frames were attempted; expect block-ack */
+		u64 bitmap = 0;
+		int start = agg->start_idx;
+		struct sk_buff *skb;
+
+		/* Construct bit-map of pending frames within Tx win */
+		for (i = 0; i < agg->frame_count; i++) {
+			u16 sc;
+			status = le16_to_cpu(frame_status[i].status);
+			seq = le16_to_cpu(frame_status[i].sequence);
+			idx = SEQ_TO_IDX(seq);
+			txq_id = SEQ_TO_QUEUE(seq);
+
+			if (status &
+			    (AGG_TX_STATE_FEW_BYTES_MSK |
+			     AGG_TX_STATE_ABORT_MSK))
+				continue;
+
+			D_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
+				   agg->frame_count, txq_id, idx);
+
+			skb = il->txq[txq_id].skbs[idx];
+			if (WARN_ON_ONCE(skb == NULL))
+				return -1;
+			hdr = (struct ieee80211_hdr *) skb->data;
+
+			sc = le16_to_cpu(hdr->seq_ctrl);
+			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
+				IL_ERR("BUG_ON idx doesn't match seq control"
+				       " idx=%d, seq_idx=%d, seq=%d\n", idx,
+				       SEQ_TO_SN(sc), hdr->seq_ctrl);
+				return -1;
+			}
+
+			D_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n", i, idx,
+				   SEQ_TO_SN(sc));
+
+			sh = idx - start;
+			if (sh > 64) {
+				sh = (start - idx) + 0xff;
+				bitmap = bitmap << sh;
+				sh = 0;
+				start = idx;
+			} else if (sh < -64)
+				sh = 0xff - (start - idx);
+			else if (sh < 0) {
+				sh = start - idx;
+				start = idx;
+				bitmap = bitmap << sh;
+				sh = 0;
+			}
+			bitmap |= 1ULL << sh;
+			D_TX_REPLY("start=%d bitmap=0x%llx\n", start,
+				   (unsigned long long)bitmap);
+		}
+
+		agg->bitmap = bitmap;
+		agg->start_idx = start;
+		D_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
+			   agg->frame_count, agg->start_idx,
+			   (unsigned long long)agg->bitmap);
+
+		if (bitmap)
+			agg->wait_for_ba = 1;
+	}
+	return 0;
+}
+
+/**
+ * il4965_hdl_tx - Handle standard (non-aggregation) Tx response
+ */
+static void
+il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
+{
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int idx = SEQ_TO_IDX(sequence);
+	struct il_tx_queue *txq = &il->txq[txq_id];
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *info;
+	struct il4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	u32 status = le32_to_cpu(tx_resp->u.status);
+	int uninitialized_var(tid);
+	int sta_id;
+	int freed;
+	u8 *qc = NULL;
+	unsigned long flags;
+
+	if (idx >= txq->q.n_bd || il_queue_used(&txq->q, idx) == 0) {
+		IL_ERR("Read idx for DMA queue txq_id (%d) idx %d "
+		       "is out of range [0-%d] %d %d\n", txq_id, idx,
+		       txq->q.n_bd, txq->q.write_ptr, txq->q.read_ptr);
+		return;
+	}
+
+	txq->time_stamp = jiffies;
+
+	skb = txq->skbs[txq->q.read_ptr];
+	info = IEEE80211_SKB_CB(skb);
+	memset(&info->status, 0, sizeof(info->status));
+
+	hdr = (struct ieee80211_hdr *) skb->data;
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = qc[0] & 0xf;
+	}
+
+	sta_id = il4965_get_ra_sta_id(il, hdr);
+	if (txq->sched_retry && unlikely(sta_id == IL_INVALID_STATION)) {
+		IL_ERR("Station not known\n");
+		return;
+	}
+
+	spin_lock_irqsave(&il->sta_lock, flags);
+	if (txq->sched_retry) {
+		const u32 scd_ssn = il4965_get_scd_ssn(tx_resp);
+		struct il_ht_agg *agg = NULL;
+		WARN_ON(!qc);
+
+		agg = &il->stations[sta_id].tid[tid].agg;
+
+		il4965_tx_status_reply_tx(il, agg, tx_resp, txq_id, idx);
+
+		/* check if BAR is needed */
+		if (tx_resp->frame_count == 1 &&
+		    !il4965_is_tx_success(status))
+			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+
+		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
+			idx = il_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
+			D_TX_REPLY("Retry scheduler reclaim scd_ssn "
+				   "%d idx %d\n", scd_ssn, idx);
+			freed = il4965_tx_queue_reclaim(il, txq_id, idx);
+			if (qc)
+				il4965_free_tfds_in_queue(il, sta_id, tid,
+							  freed);
+
+			if (il->mac80211_registered &&
+			    il_queue_space(&txq->q) > txq->q.low_mark &&
+			    agg->state != IL_EMPTYING_HW_QUEUE_DELBA)
+				il_wake_queue(il, txq);
+		}
+	} else {
+		info->status.rates[0].count = tx_resp->failure_frame + 1;
+		info->flags |= il4965_tx_status_to_mac80211(status);
+		il4965_hwrate_to_tx_control(il,
+					    le32_to_cpu(tx_resp->rate_n_flags),
+					    info);
+
+		D_TX_REPLY("TXQ %d status %s (0x%08x) "
+			   "rate_n_flags 0x%x retries %d\n", txq_id,
+			   il4965_get_tx_fail_reason(status), status,
+			   le32_to_cpu(tx_resp->rate_n_flags),
+			   tx_resp->failure_frame);
+
+		freed = il4965_tx_queue_reclaim(il, txq_id, idx);
+		if (qc && likely(sta_id != IL_INVALID_STATION))
+			il4965_free_tfds_in_queue(il, sta_id, tid, freed);
+		else if (sta_id == IL_INVALID_STATION)
+			D_TX_REPLY("Station not known\n");
+
+		if (il->mac80211_registered &&
+		    il_queue_space(&txq->q) > txq->q.low_mark)
+			il_wake_queue(il, txq);
+	}
+	if (qc && likely(sta_id != IL_INVALID_STATION))
+		il4965_txq_check_empty(il, sta_id, tid, txq_id);
+
+	il4965_check_abort_status(il, tx_resp->frame_count, status);
+
+	spin_unlock_irqrestore(&il->sta_lock, flags);
+}
+
 /**
  * translate ucode response to mac80211 tx status control values
  */
@@ -3868,10 +4170,11 @@ il4965_setup_handlers(struct il_priv *il)
 	/* Rx handlers */
 	il->handlers[N_RX_PHY] = il4965_hdl_rx_phy;
 	il->handlers[N_RX_MPDU] = il4965_hdl_rx;
+	il->handlers[N_RX] = il4965_hdl_rx;
 	/* block ack */
 	il->handlers[N_COMPRESSED_BA] = il4965_hdl_compressed_ba;
-	/* Set up hardware specific Rx handlers */
-	il->ops->lib->handler_setup(il);
+	/* Tx response */
+	il->handlers[C_TX] = il4965_hdl_tx;
 }
 
 /**
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index aea84bf..cf49a7a 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1737,317 +1737,6 @@ il4965_build_addsta_hcmd(const struct il_addsta_cmd *cmd, u8 * data)
 	return (u16) sizeof(struct il4965_addsta_cmd);
 }
 
-static inline u32
-il4965_get_scd_ssn(struct il4965_tx_resp *tx_resp)
-{
-	return le32_to_cpup(&tx_resp->u.status + tx_resp->frame_count) & MAX_SN;
-}
-
-static inline u32
-il4965_tx_status_to_mac80211(u32 status)
-{
-	status &= TX_STATUS_MSK;
-
-	switch (status) {
-	case TX_STATUS_SUCCESS:
-	case TX_STATUS_DIRECT_DONE:
-		return IEEE80211_TX_STAT_ACK;
-	case TX_STATUS_FAIL_DEST_PS:
-		return IEEE80211_TX_STAT_TX_FILTERED;
-	default:
-		return 0;
-	}
-}
-
-static inline bool
-il4965_is_tx_success(u32 status)
-{
-	status &= TX_STATUS_MSK;
-	return (status == TX_STATUS_SUCCESS || status == TX_STATUS_DIRECT_DONE);
-}
-
-/**
- * il4965_tx_status_reply_tx - Handle Tx response for frames in aggregation queue
- */
-static int
-il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
-			  struct il4965_tx_resp *tx_resp, int txq_id,
-			  u16 start_idx)
-{
-	u16 status;
-	struct agg_tx_status *frame_status = tx_resp->u.agg_status;
-	struct ieee80211_tx_info *info = NULL;
-	struct ieee80211_hdr *hdr = NULL;
-	u32 rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
-	int i, sh, idx;
-	u16 seq;
-	if (agg->wait_for_ba)
-		D_TX_REPLY("got tx response w/o block-ack\n");
-
-	agg->frame_count = tx_resp->frame_count;
-	agg->start_idx = start_idx;
-	agg->rate_n_flags = rate_n_flags;
-	agg->bitmap = 0;
-
-	/* num frames attempted by Tx command */
-	if (agg->frame_count == 1) {
-		/* Only one frame was attempted; no block-ack will arrive */
-		status = le16_to_cpu(frame_status[0].status);
-		idx = start_idx;
-
-		D_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
-			   agg->frame_count, agg->start_idx, idx);
-
-		info = IEEE80211_SKB_CB(il->txq[txq_id].skbs[idx]);
-		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= il4965_tx_status_to_mac80211(status);
-		il4965_hwrate_to_tx_control(il, rate_n_flags, info);
-
-		D_TX_REPLY("1 Frame 0x%x failure :%d\n", status & 0xff,
-			   tx_resp->failure_frame);
-		D_TX_REPLY("Rate Info rate_n_flags=%x\n", rate_n_flags);
-
-		agg->wait_for_ba = 0;
-	} else {
-		/* Two or more frames were attempted; expect block-ack */
-		u64 bitmap = 0;
-		int start = agg->start_idx;
-		struct sk_buff *skb;
-
-		/* Construct bit-map of pending frames within Tx win */
-		for (i = 0; i < agg->frame_count; i++) {
-			u16 sc;
-			status = le16_to_cpu(frame_status[i].status);
-			seq = le16_to_cpu(frame_status[i].sequence);
-			idx = SEQ_TO_IDX(seq);
-			txq_id = SEQ_TO_QUEUE(seq);
-
-			if (status &
-			    (AGG_TX_STATE_FEW_BYTES_MSK |
-			     AGG_TX_STATE_ABORT_MSK))
-				continue;
-
-			D_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
-				   agg->frame_count, txq_id, idx);
-
-			skb = il->txq[txq_id].skbs[idx];
-			if (WARN_ON_ONCE(skb == NULL))
-				return -1;
-			hdr = (struct ieee80211_hdr *) skb->data;
-
-			sc = le16_to_cpu(hdr->seq_ctrl);
-			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
-				IL_ERR("BUG_ON idx doesn't match seq control"
-				       " idx=%d, seq_idx=%d, seq=%d\n", idx,
-				       SEQ_TO_SN(sc), hdr->seq_ctrl);
-				return -1;
-			}
-
-			D_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n", i, idx,
-				   SEQ_TO_SN(sc));
-
-			sh = idx - start;
-			if (sh > 64) {
-				sh = (start - idx) + 0xff;
-				bitmap = bitmap << sh;
-				sh = 0;
-				start = idx;
-			} else if (sh < -64)
-				sh = 0xff - (start - idx);
-			else if (sh < 0) {
-				sh = start - idx;
-				start = idx;
-				bitmap = bitmap << sh;
-				sh = 0;
-			}
-			bitmap |= 1ULL << sh;
-			D_TX_REPLY("start=%d bitmap=0x%llx\n", start,
-				   (unsigned long long)bitmap);
-		}
-
-		agg->bitmap = bitmap;
-		agg->start_idx = start;
-		D_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
-			   agg->frame_count, agg->start_idx,
-			   (unsigned long long)agg->bitmap);
-
-		if (bitmap)
-			agg->wait_for_ba = 1;
-	}
-	return 0;
-}
-
-static u8
-il4965_find_station(struct il_priv *il, const u8 * addr)
-{
-	int i;
-	int start = 0;
-	int ret = IL_INVALID_STATION;
-	unsigned long flags;
-
-	if ((il->iw_mode == NL80211_IFTYPE_ADHOC))
-		start = IL_STA_ID;
-
-	if (is_broadcast_ether_addr(addr))
-		return il->hw_params.bcast_id;
-
-	spin_lock_irqsave(&il->sta_lock, flags);
-	for (i = start; i < il->hw_params.max_stations; i++)
-		if (il->stations[i].used &&
-		    (!compare_ether_addr(il->stations[i].sta.sta.addr, addr))) {
-			ret = i;
-			goto out;
-		}
-
-	D_ASSOC("can not find STA %pM total %d\n", addr, il->num_stations);
-
-out:
-	/*
-	 * It may be possible that more commands interacting with stations
-	 * arrive before we completed processing the adding of
-	 * station
-	 */
-	if (ret != IL_INVALID_STATION &&
-	    (!(il->stations[ret].used & IL_STA_UCODE_ACTIVE) ||
-	     ((il->stations[ret].used & IL_STA_UCODE_ACTIVE) &&
-	      (il->stations[ret].used & IL_STA_UCODE_INPROGRESS)))) {
-		IL_ERR("Requested station info for sta %d before ready.\n",
-		       ret);
-		ret = IL_INVALID_STATION;
-	}
-	spin_unlock_irqrestore(&il->sta_lock, flags);
-	return ret;
-}
-
-static int
-il4965_get_ra_sta_id(struct il_priv *il, struct ieee80211_hdr *hdr)
-{
-	if (il->iw_mode == NL80211_IFTYPE_STATION) {
-		return IL_AP_ID;
-	} else {
-		u8 *da = ieee80211_get_DA(hdr);
-		return il4965_find_station(il, da);
-	}
-}
-
-/**
- * il4965_hdl_tx - Handle standard (non-aggregation) Tx response
- */
-static void
-il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
-{
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int idx = SEQ_TO_IDX(sequence);
-	struct il_tx_queue *txq = &il->txq[txq_id];
-	struct sk_buff *skb;
-	struct ieee80211_hdr *hdr;
-	struct ieee80211_tx_info *info;
-	struct il4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
-	u32 status = le32_to_cpu(tx_resp->u.status);
-	int uninitialized_var(tid);
-	int sta_id;
-	int freed;
-	u8 *qc = NULL;
-	unsigned long flags;
-
-	if (idx >= txq->q.n_bd || il_queue_used(&txq->q, idx) == 0) {
-		IL_ERR("Read idx for DMA queue txq_id (%d) idx %d "
-		       "is out of range [0-%d] %d %d\n", txq_id, idx,
-		       txq->q.n_bd, txq->q.write_ptr, txq->q.read_ptr);
-		return;
-	}
-
-	txq->time_stamp = jiffies;
-
-	skb = txq->skbs[txq->q.read_ptr];
-	info = IEEE80211_SKB_CB(skb);
-	memset(&info->status, 0, sizeof(info->status));
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & 0xf;
-	}
-
-	sta_id = il4965_get_ra_sta_id(il, hdr);
-	if (txq->sched_retry && unlikely(sta_id == IL_INVALID_STATION)) {
-		IL_ERR("Station not known\n");
-		return;
-	}
-
-	spin_lock_irqsave(&il->sta_lock, flags);
-	if (txq->sched_retry) {
-		const u32 scd_ssn = il4965_get_scd_ssn(tx_resp);
-		struct il_ht_agg *agg = NULL;
-		WARN_ON(!qc);
-
-		agg = &il->stations[sta_id].tid[tid].agg;
-
-		il4965_tx_status_reply_tx(il, agg, tx_resp, txq_id, idx);
-
-		/* check if BAR is needed */
-		if ((tx_resp->frame_count == 1) &&
-		    !il4965_is_tx_success(status))
-			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-
-		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			idx = il_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			D_TX_REPLY("Retry scheduler reclaim scd_ssn "
-				   "%d idx %d\n", scd_ssn, idx);
-			freed = il4965_tx_queue_reclaim(il, txq_id, idx);
-			if (qc)
-				il4965_free_tfds_in_queue(il, sta_id, tid,
-							  freed);
-
-			if (il->mac80211_registered &&
-			    il_queue_space(&txq->q) > txq->q.low_mark &&
-			    agg->state != IL_EMPTYING_HW_QUEUE_DELBA)
-				il_wake_queue(il, txq);
-		}
-	} else {
-		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags |= il4965_tx_status_to_mac80211(status);
-		il4965_hwrate_to_tx_control(il,
-					    le32_to_cpu(tx_resp->rate_n_flags),
-					    info);
-
-		D_TX_REPLY("TXQ %d status %s (0x%08x) "
-			   "rate_n_flags 0x%x retries %d\n", txq_id,
-			   il4965_get_tx_fail_reason(status), status,
-			   le32_to_cpu(tx_resp->rate_n_flags),
-			   tx_resp->failure_frame);
-
-		freed = il4965_tx_queue_reclaim(il, txq_id, idx);
-		if (qc && likely(sta_id != IL_INVALID_STATION))
-			il4965_free_tfds_in_queue(il, sta_id, tid, freed);
-		else if (sta_id == IL_INVALID_STATION)
-			D_TX_REPLY("Station not known\n");
-
-		if (il->mac80211_registered &&
-		    il_queue_space(&txq->q) > txq->q.low_mark)
-			il_wake_queue(il, txq);
-	}
-	if (qc && likely(sta_id != IL_INVALID_STATION))
-		il4965_txq_check_empty(il, sta_id, tid, txq_id);
-
-	il4965_check_abort_status(il, tx_resp->frame_count, status);
-
-	spin_unlock_irqrestore(&il->sta_lock, flags);
-}
-
-/* Set up 4965-specific Rx frame reply handlers */
-static void
-il4965_handler_setup(struct il_priv *il)
-{
-	/* Legacy Rx frames */
-	il->handlers[N_RX] = il4965_hdl_rx;
-	/* Tx response */
-	il->handlers[C_TX] = il4965_hdl_tx;
-}
-
 static struct il_hcmd_ops il4965_hcmd = {
 	.rxon_assoc = il4965_send_rxon_assoc,
 	.commit_rxon = il4965_commit_rxon,
@@ -2205,7 +1894,6 @@ static struct il_lib_ops il4965_lib = {
 	.txq_attach_buf_to_tfd = il4965_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = il4965_hw_txq_free_tfd,
 	.txq_init = il4965_hw_tx_queue_init,
-	.handler_setup = il4965_handler_setup,
 	.is_valid_rtc_data_addr = il4965_hw_valid_rtc_data_addr,
 	.init_alive_start = il4965_init_alive_start,
 	.load_ucode = il4965_load_bsm,
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 83ab604..befa7e6 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -67,8 +67,6 @@ void il4965_rx_replenish_now(struct il_priv *il);
 void il4965_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq);
 int il4965_rxq_stop(struct il_priv *il);
 int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
-void il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb);
-void il4965_hdl_rx_phy(struct il_priv *il, struct il_rx_buf *rxb);
 void il4965_rx_handle(struct il_priv *il);
 
 /* tx */
@@ -84,7 +82,6 @@ int il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
 int il4965_txq_check_empty(struct il_priv *il, int sta_id, u8 tid, int txq_id);
-void il4965_hdl_compressed_ba(struct il_priv *il, struct il_rx_buf *rxb);
 int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx);
 void il4965_hw_txq_ctx_free(struct il_priv *il);
 int il4965_txq_ctx_alloc(struct il_priv *il);
@@ -106,12 +103,6 @@ void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 idx);
 void il4965_tx_queue_set_status(struct il_priv *il, struct il_tx_queue *txq,
 				int tx_fifo_id, int scd_retry);
 
-/* rx */
-void il4965_hdl_missed_beacon(struct il_priv *il, struct il_rx_buf *rxb);
-bool il4965_good_plcp_health(struct il_priv *il, struct il_rx_pkt *pkt);
-void il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb);
-void il4965_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb);
-
 /* scan */
 int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 37bc406..1c0d969 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1600,8 +1600,6 @@ struct il_lib_ops {
 				      u16 len, u8 reset, u8 pad);
 	void (*txq_free_tfd) (struct il_priv *il, struct il_tx_queue *txq);
 	int (*txq_init) (struct il_priv *il, struct il_tx_queue *txq);
-	/* setup Rx handler */
-	void (*handler_setup) (struct il_priv *il);
 	/* alive notification after init uCode load */
 	void (*init_alive_start) (struct il_priv *il);
 	/* check validity of rtc data address */
-- 
1.7.1

