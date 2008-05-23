Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:28939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760306AbYEWCML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:12:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH] iwlwifi: impelemnt 5000 tx response path
Date: Fri, 23 May 2008 10:09:28 +0800
Message-Id: <1211508569-3163-51-git-send-email-yi.zhu@intel.com> (sfid-20080523_042833_163956_9B79E3CF)
In-Reply-To: <1211508569-3163-50-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-39-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-41-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-42-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-43-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-44-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-46-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-47-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-48-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-49-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-50-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch implements 5000 HW tx response path

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |  235 +++++++++++++++++++++++++++++++
 net/mac80211/mlme.c                     |   10 +-
 2 files changed, 240 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 685a84e..5d6a28c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -972,6 +972,240 @@ static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
 	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
 }
 
+
+static inline u32 iwl5000_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
+{
+	__le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
+				tx_resp->frame_count);
+	return le32_to_cpu(*scd_ssn) & MAX_SN;
+
+}
+
+static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
+				      struct iwl_ht_agg *agg,
+				      struct iwl5000_tx_resp *tx_resp,
+				      u16 start_idx)
+{
+	u16 status;
+	struct agg_tx_status *frame_status = &tx_resp->status;
+	struct ieee80211_tx_status *tx_status = NULL;
+	struct ieee80211_hdr *hdr = NULL;
+	int i, sh;
+	int txq_id, idx;
+	u16 seq;
+
+	if (agg->wait_for_ba)
+		IWL_DEBUG_TX_REPLY("got tx response w/o block-ack\n");
+
+	agg->frame_count = tx_resp->frame_count;
+	agg->start_idx = start_idx;
+	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
+	agg->bitmap = 0;
+
+	/* # frames attempted by Tx command */
+	if (agg->frame_count == 1) {
+		/* Only one frame was attempted; no block-ack will arrive */
+		status = le16_to_cpu(frame_status[0].status);
+		seq  = le16_to_cpu(frame_status[0].sequence);
+		idx = SEQ_TO_INDEX(seq);
+		txq_id = SEQ_TO_QUEUE(seq);
+
+		/* FIXME: code repetition */
+		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
+				   agg->frame_count, agg->start_idx, idx);
+
+		tx_status = &(priv->txq[txq_id].txb[idx].status);
+		tx_status->retry_count = tx_resp->failure_frame;
+		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
+		tx_status->flags = iwl_is_tx_success(status)?
+			IEEE80211_TX_STATUS_ACK : 0;
+		iwl4965_hwrate_to_tx_control(priv,
+					     le32_to_cpu(tx_resp->rate_n_flags),
+					     &tx_status->control);
+		/* FIXME: code repetition end */
+
+		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
+				    status & 0xff, tx_resp->failure_frame);
+		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n",
+			iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags));
+
+		agg->wait_for_ba = 0;
+	} else {
+		/* Two or more frames were attempted; expect block-ack */
+		u64 bitmap = 0;
+		int start = agg->start_idx;
+
+		/* Construct bit-map of pending frames within Tx window */
+		for (i = 0; i < agg->frame_count; i++) {
+			u16 sc;
+			status = le16_to_cpu(frame_status[i].status);
+			seq  = le16_to_cpu(frame_status[i].sequence);
+			idx = SEQ_TO_INDEX(seq);
+			txq_id = SEQ_TO_QUEUE(seq);
+
+			if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
+				      AGG_TX_STATE_ABORT_MSK))
+				continue;
+
+			IWL_DEBUG_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
+					   agg->frame_count, txq_id, idx);
+
+			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
+
+			sc = le16_to_cpu(hdr->seq_ctrl);
+			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
+				IWL_ERROR("BUG_ON idx doesn't match seq control"
+					  " idx=%d, seq_idx=%d, seq=%d\n",
+					  idx, SEQ_TO_SN(sc),
+					  hdr->seq_ctrl);
+				return -1;
+			}
+
+			IWL_DEBUG_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n",
+					   i, idx, SEQ_TO_SN(sc));
+
+			sh = idx - start;
+			if (sh > 64) {
+				sh = (start - idx) + 0xff;
+				bitmap = bitmap << sh;
+				sh = 0;
+				start = idx;
+			} else if (sh < -64)
+				sh  = 0xff - (start - idx);
+			else if (sh < 0) {
+				sh = start - idx;
+				start = idx;
+				bitmap = bitmap << sh;
+				sh = 0;
+			}
+			bitmap |= (1 << sh);
+			IWL_DEBUG_TX_REPLY("start=%d bitmap=0x%x\n",
+					   start, (u32)(bitmap & 0xFFFFFFFF));
+		}
+
+		agg->bitmap = bitmap;
+		agg->start_idx = start;
+		agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
+		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
+				   agg->frame_count, agg->start_idx,
+				   (unsigned long long)agg->bitmap);
+
+		if (bitmap)
+			agg->wait_for_ba = 1;
+	}
+	return 0;
+}
+
+static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int index = SEQ_TO_INDEX(sequence);
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct ieee80211_tx_status *tx_status;
+	struct iwl5000_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	u32  status = le16_to_cpu(tx_resp->status.status);
+#ifdef CONFIG_IWL4965_HT
+	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
+	u16 fc;
+	struct ieee80211_hdr *hdr;
+	u8 *qc = NULL;
+#endif
+
+	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
+		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
+			  "is out of range [0-%d] %d %d\n", txq_id,
+			  index, txq->q.n_bd, txq->q.write_ptr,
+			  txq->q.read_ptr);
+		return;
+	}
+
+#ifdef CONFIG_IWL4965_HT
+	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
+	fc = le16_to_cpu(hdr->frame_control);
+	if (ieee80211_is_qos_data(fc)) {
+		qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+		tid = qc[0] & 0xf;
+	}
+
+	sta_id = iwl_get_ra_sta_id(priv, hdr);
+	if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
+		IWL_ERROR("Station not known\n");
+		return;
+	}
+
+	if (txq->sched_retry) {
+		const u32 scd_ssn = iwl5000_get_scd_ssn(tx_resp);
+		struct iwl_ht_agg *agg = NULL;
+
+		if (!qc)
+			return;
+
+		agg = &priv->stations[sta_id].tid[tid].agg;
+
+		iwl5000_tx_status_reply_tx(priv, agg, tx_resp, index);
+
+		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status)) {
+			/* TODO: send BAR */
+		}
+
+		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
+			int freed, ampdu_q;
+			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
+			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
+					   "%d index %d\n", scd_ssn , index);
+			freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+
+			if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
+			    txq_id >= 0 && priv->mac80211_registered &&
+			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA) {
+				/* calculate mac80211 ampdu sw queue to wake */
+				ampdu_q = txq_id - IWL_BACK_QUEUE_FIRST_ID +
+					  priv->hw->queues;
+				if (agg->state == IWL_AGG_OFF)
+					ieee80211_wake_queue(priv->hw, txq_id);
+				else
+					ieee80211_wake_queue(priv->hw, ampdu_q);
+			}
+			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
+		}
+	} else {
+#endif /* CONFIG_IWL4965_HT */
+	tx_status = &(txq->txb[txq->q.read_ptr].status);
+
+	tx_status->retry_count = tx_resp->failure_frame;
+	tx_status->flags =
+	    iwl_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
+	iwl4965_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
+				     &tx_status->control);
+
+	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
+		     "retries %d\n", txq_id, iwl_get_tx_fail_reason(status),
+		     status, le32_to_cpu(tx_resp->rate_n_flags),
+		     tx_resp->failure_frame);
+
+	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+#ifdef CONFIG_IWL4965_HT
+	if (index != -1) {
+		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+		if (tid != MAX_TID_COUNT)
+			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
+			(txq_id >= 0) && priv->mac80211_registered)
+			ieee80211_wake_queue(priv->hw, txq_id);
+		if (tid != MAX_TID_COUNT)
+			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
+	}
+	}
+#endif /* CONFIG_IWL4965_HT */
+
+	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
+		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
+}
+
 /* Currently 5000 is the supperset of everything */
 static u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
 {
@@ -985,6 +1219,7 @@ static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 					iwl5000_rx_calib_result;
 	priv->rx_handlers[CALIBRATION_COMPLETE_NOTIFICATION] =
 					iwl5000_rx_calib_complete;
+	priv->rx_handlers[REPLY_TX] = iwl5000_rx_reply_tx;
 }
 
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3f7f92a..fd42ffd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4083,17 +4083,17 @@ ieee80211_sta_scan_result(struct net_device *dev,
 						  IW_EV_UINT_LEN);
 	}
 
+
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->freq;
-	iwe.u.freq.e = 6;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
+	iwe.u.freq.e = 0;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
-
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
-	iwe.u.freq.e = 0;
+	iwe.u.freq.m = bss->freq;
+	iwe.u.freq.e = 6;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 
-- 
1.5.3.6

