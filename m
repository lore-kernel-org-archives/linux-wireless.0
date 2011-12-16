Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759786Ab1LPQhk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/24] iwlwifi: don't count the tfds in HW queue any more
Date: Fri, 16 Dec 2011 07:37:09 -0800
Message-Id: <1324049849-831-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173750_090055_257DC96B)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since packets sent to an RA / TID in AGG are sent from a
separate HW Tx queue, we may get into a race:
the regular queue isn't empty while we already begin to
send packets from the AGG queue. This would result in sending
packets out of order.

In order to cope with this, mac80211 waits until the driver
reports that the legacy queue is drained before it can send
packets to the AGG queue. During that time, mac80211 buffers
packets for the driver. These packets will be sent in order
after the driver reports it is ready.

The way this was implemented in the driver is as follows:
We held a counter that monitors the number of packets for
an RA / TID in the HW queues. When this counter reached 0,
we knew that the HW queues were drained and we reported to
mac80211 that were ready to proceed.

This patch changes the implementation described above. We
now remember what is the wifi sequence number of the first
packet that will be sent in the AGG queue (lets' call it
ssn). When we reclaim the packet before ssn, we know that
the queue is drained, and we are ready to proceed.

This will allow us to move this logic in the upper layer and
eventually remove the tid_data from the shared area.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |   28 ++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    5 +--
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   11 +++++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   17 ++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   31 +++++-----------------
 5 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 1cac701..69d0f99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -772,7 +772,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	struct ieee80211_hdr *hdr;
 	u32 status = le16_to_cpu(tx_resp->status.status);
-	u32 ssn = iwlagn_get_scd_ssn(tx_resp);
+	u16 ssn = iwlagn_get_scd_ssn(tx_resp);
 	int tid;
 	int sta_id;
 	int freed;
@@ -794,8 +794,31 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 		iwl_rx_reply_tx_agg(priv, tx_resp);
 
 	if (tx_resp->frame_count == 1) {
-		IWL_DEBUG_TX_REPLY(priv, "Q %d, ssn %d", txq_id, ssn);
+		u16 next_reclaimed = le16_to_cpu(tx_resp->seq_ctl);
+		next_reclaimed = SEQ_TO_SN(next_reclaimed + 0x10);
+
+		if (is_agg) {
+			/* If this is an aggregation queue, we can rely on the
+			 * ssn since the wifi sequence number corresponds to
+			 * the index in the TFD ring (%256).
+			 * The seq_ctl is the sequence control of the packet
+			 * to which this Tx response relates. But if there is a
+			 * hole in the bitmap of the BA we received, this Tx
+			 * response may allow to reclaim the hole and all the
+			 * subsequent packets that were already acked.
+			 * In that case, seq_ctl != ssn, and the next packet
+			 * to be reclaimed will be ssn and not seq_ctl.
+			 */
+			next_reclaimed = ssn;
+		}
+
 		__skb_queue_head_init(&skbs);
+		priv->shrd->tid_data[sta_id][tid].next_reclaimed =
+			next_reclaimed;
+
+		IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d",
+					  next_reclaimed);
+
 		/*we can free until ssn % q.n_bd not inclusive */
 		iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
 				  ssn, status, &skbs);
@@ -951,6 +974,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
+	priv->shrd->tid_data[sta_id][tid].next_reclaimed = ba_resp_scd_ssn;
 	iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow, ba_resp_scd_ssn,
 			  0, &reclaimed_skbs);
 	freed = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 074068e..7c5114d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -372,15 +372,14 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				 i, station->sta.sta.addr,
 				 station->sta.station_flags_msk);
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"TID\tseq_num\ttxq_id\ttfds\trate_n_flags\n");
+				"TID\tseq_num\ttxq_id\trate_n_flags\n");
 
 		for (j = 0; j < IWL_MAX_TID_COUNT; j++) {
 			tid_data = &priv->shrd->tid_data[i][j];
 			pos += scnprintf(buf + pos, bufsz - pos,
-				"%d:\t%#x\t%#x\t%u\t%#x",
+				"%d:\t%#x\t%#x\t%#x",
 				j, tid_data->seq_number,
 				tid_data->agg.txq_id,
-				tid_data->tfds_in_queue,
 				tid_data->agg.rate_n_flags);
 
 			if (tid_data->agg.wait_for_ba)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index df6d212..8a96907 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -231,12 +231,17 @@ enum iwl_agg_state {
  * @state: state of the BA agreement establishment / tear down.
  * @txq_id: Tx queue used by the BA session - used by the transport layer.
  *	Needed by the upper layer for debugfs only.
+ * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
+ *	the first packet to be sent in legacy HW queue in Tx AGG stop flow.
+ *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
+ *	we are ready to finish the Tx AGG stop / start flow.
  * @wait_for_ba: Expect block-ack before next Tx reply
  */
 struct iwl_ht_agg {
 	u32 rate_n_flags;
 	enum iwl_agg_state state;
 	u16 txq_id;
+	u16 ssn;
 	bool wait_for_ba;
 };
 
@@ -246,13 +251,13 @@ struct iwl_ht_agg {
  * This structs holds the states for each RA / TID.
 
  * @seq_number: the next WiFi sequence number to use
- * @tfds_in_queue: number of packets sent to the HW queues.
- *	Exported for debugfs only
+ * @next_reclaimed: the WiFi sequence number of the next packet to be acked.
+ *	This is basically (last acked packet++).
  * @agg: aggregation state machine
  */
 struct iwl_tid_data {
 	u16 seq_number;
-	u16 tfds_in_queue;
+	u16 next_reclaimed;
 	struct iwl_ht_agg agg;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 79331fb..1b1077c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -555,18 +555,22 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 
 	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
 	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
+	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
+
+	*ssn = tid_data->agg.ssn;
 	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
 
-	if (tid_data->tfds_in_queue == 0) {
-		IWL_DEBUG_TX_QUEUES(trans, "HW queue is empty\n");
+	if (*ssn == tid_data->next_reclaimed) {
+		IWL_DEBUG_TX_QUEUES(trans, "Proceed: ssn = next_recl = %d",
+				    tid_data->agg.ssn);
 		tid_data->agg.state = IWL_AGG_ON;
 		iwl_start_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
 	} else {
-		IWL_DEBUG_TX_QUEUES(trans,
-				    "HW queue is NOT empty: %d packets in HW"
-				    " queue\n", tid_data->tfds_in_queue);
+		IWL_DEBUG_TX_QUEUES(trans, "Can't proceed: ssn %d, "
+				    "next_recl = %d",
+				    tid_data->agg.ssn,
+				    tid_data->next_reclaimed);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
 	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
@@ -647,6 +651,7 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 				    "Stopping a non empty AGG HW QUEUE\n");
 		trans->shrd->tid_data[sta_id][tid].agg.state =
 			IWL_EMPTYING_HW_QUEUE_DELBA;
+		tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
 		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 66e1b9f..4d31843 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1109,7 +1109,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 				IWL_ERR(trans, "sta_id = %d, tid = %d "
 					"txq_id = %d, seq_num = %d", sta_id,
 					tid, tid_data->agg.txq_id,
-					seq_number >> 4);
+					SEQ_TO_SN(seq_number));
 			}
 			txq_id = tid_data->agg.txq_id;
 			is_agg = true;
@@ -1222,12 +1222,10 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_txq_update_write_ptr(trans, txq);
 
-	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
-		trans->shrd->tid_data[sta_id][tid].tfds_in_queue++;
-		if (!ieee80211_has_morefrags(fc))
+	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc) &&
+	    !ieee80211_has_morefrags(fc))
 			trans->shrd->tid_data[sta_id][tid].seq_number =
 				seq_number;
-	}
 
 	/*
 	 * At this point the frame is "transmitted" successfully
@@ -1304,10 +1302,11 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/* We are reclaiming the last packet of the queue */
-		if (tid_data->tfds_in_queue == 0) {
+		/* There are no packets for this RA / TID in the HW any more */
+		if (tid_data->agg.ssn == tid_data->next_reclaimed) {
 			IWL_DEBUG_TX_QUEUES(trans,
-				"HW queue empty: continue ADDBA flow\n");
+				"Can continue ADDBA flow ssn = next_recl ="
+				" %d", tid_data->next_reclaimed);
 			tid_data->agg.state = IWL_AGG_ON;
 			iwl_start_tx_ba_trans_ready(priv(trans),
 						    NUM_IWL_RXON_CTX,
@@ -1321,21 +1320,6 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 	return 0;
 }
 
-static void iwl_free_tfds_in_queue(struct iwl_trans *trans,
-			    int sta_id, int tid, int freed)
-{
-	lockdep_assert_held(&trans->shrd->sta_lock);
-
-	if (trans->shrd->tid_data[sta_id][tid].tfds_in_queue >= freed)
-		trans->shrd->tid_data[sta_id][tid].tfds_in_queue -= freed;
-	else {
-		IWL_DEBUG_TX(trans, "free more than tfds_in_queue (%u:%d)\n",
-			trans->shrd->tid_data[sta_id][tid].tfds_in_queue,
-			freed);
-		trans->shrd->tid_data[sta_id][tid].tfds_in_queue = 0;
-	}
-}
-
 static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		      int txq_id, int ssn, u32 status,
 		      struct sk_buff_head *skbs)
@@ -1367,7 +1351,6 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 			iwl_wake_queue(trans, txq, "Packets reclaimed");
 	}
 
-	iwl_free_tfds_in_queue(trans, sta_id, tid, freed);
 	iwlagn_txq_check_empty(trans, sta_id, tid, txq_id);
 }
 
-- 
1.7.0.4

