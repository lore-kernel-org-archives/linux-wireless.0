Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759863Ab1LPQhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/24] iwlwifi: tid_data logic move to upper layer - txqid
Date: Fri, 16 Dec 2011 07:37:16 -0800
Message-Id: <1324049849-831-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173755_708739_EB6A1436)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tid_data is not related to the transport layer, so move
the logic that depends on it to the upper layer.
This patch deals with the mapping of RA / TID to HW queues in AGG.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   35 ++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    5 +--
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    3 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   28 ++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   21 +++++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    7 ++--
 7 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 6321ea2..a76799d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1000,8 +1000,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 					  next_reclaimed);
 
 		/*we can free until ssn % q.n_bd not inclusive */
-		iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
-				  ssn, status, &skbs);
+		WARN_ON(iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
+				  ssn, status, &skbs));
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
 		while (!skb_queue_empty(&skbs)) {
@@ -1101,23 +1101,20 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
-	if (unlikely(agg->txq_id != scd_flow)) {
-		/*
-		 * FIXME: this is a uCode bug which need to be addressed,
-		 * log the information and return for now!
-		 * since it is possible happen very often and in order
-		 * not to fill the syslog, don't enable the logging by default
-		 */
-		IWL_DEBUG_TX_REPLY(priv,
-			"BA scd_flow %d does not match txq_id %d\n",
-			scd_flow, agg->txq_id);
+	if (unlikely(!agg->wait_for_ba)) {
+		if (unlikely(ba_resp->bitmap))
+			IWL_ERR(priv, "Received BA when not expected\n");
 		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return 0;
 	}
 
-	if (unlikely(!agg->wait_for_ba)) {
-		if (unlikely(ba_resp->bitmap))
-			IWL_ERR(priv, "Received BA when not expected\n");
+	__skb_queue_head_init(&reclaimed_skbs);
+
+	/* Release all TFDs before the SSN, i.e. all TFDs in front of
+	 * block-ack window (we assume that they've been successfully
+	 * transmitted ... if not, it's too late anyway). */
+	if (iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow,
+			      ba_resp_scd_ssn, 0, &reclaimed_skbs)) {
 		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return 0;
 	}
@@ -1150,14 +1147,8 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
 			ba_resp->txed, ba_resp->txed_2_done);
 
-	__skb_queue_head_init(&reclaimed_skbs);
-
-	/* Release all TFDs before the SSN, i.e. all TFDs in front of
-	 * block-ack window (we assume that they've been successfully
-	 * transmitted ... if not, it's too late anyway). */
 	priv->shrd->tid_data[sta_id][tid].next_reclaimed = ba_resp_scd_ssn;
-	iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow, ba_resp_scd_ssn,
-			  0, &reclaimed_skbs);
+
 	iwlagn_check_ratid_empty(priv, sta_id, tid);
 	freed = 0;
 	while (!skb_queue_empty(&reclaimed_skbs)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 7c5114d..05edbc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -372,14 +372,13 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				 i, station->sta.sta.addr,
 				 station->sta.station_flags_msk);
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"TID\tseq_num\ttxq_id\trate_n_flags\n");
+				"TID\tseq_num\trate_n_flags\n");
 
 		for (j = 0; j < IWL_MAX_TID_COUNT; j++) {
 			tid_data = &priv->shrd->tid_data[i][j];
 			pos += scnprintf(buf + pos, bufsz - pos,
-				"%d:\t%#x\t%#x\t%#x",
+				"%d:\t%#x\t%#x",
 				j, tid_data->seq_number,
-				tid_data->agg.txq_id,
 				tid_data->agg.rate_n_flags);
 
 			if (tid_data->agg.wait_for_ba)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8a96907..9b11c74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -229,8 +229,6 @@ enum iwl_agg_state {
  *	Tx response (REPLY_TX), and the block ack notification
  *	(REPLY_COMPRESSED_BA).
  * @state: state of the BA agreement establishment / tear down.
- * @txq_id: Tx queue used by the BA session - used by the transport layer.
- *	Needed by the upper layer for debugfs only.
  * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
  *	the first packet to be sent in legacy HW queue in Tx AGG stop flow.
  *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
@@ -240,7 +238,6 @@ enum iwl_agg_state {
 struct iwl_ht_agg {
 	u32 rate_n_flags;
 	enum iwl_agg_state state;
-	u16 txq_id;
 	u16 ssn;
 	bool wait_for_ba;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 49ff85f..63a2eb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -236,6 +236,7 @@ struct iwl_trans_pcie {
 	const u8 *ac_to_fifo[NUM_IWL_RXON_CTX];
 	const u8 *ac_to_queue[NUM_IWL_RXON_CTX];
 	u8 mcast_queue[NUM_IWL_RXON_CTX];
+	u8 agg_txq[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
 
 	struct iwl_tx_queue *txq;
 	unsigned long txq_ctx_active_msk;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index d9d4221..5085dae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -446,6 +446,14 @@ static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
 	return -EINVAL;
 }
 
+static inline bool is_agg_txqid_valid(struct iwl_trans *trans, int txq_id)
+{
+	if (txq_id < IWLAGN_FIRST_AMPDU_QUEUE)
+		return false;
+	return txq_id < (IWLAGN_FIRST_AMPDU_QUEUE +
+		hw_params(trans).num_ampdu_queues);
+}
+
 void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 				 enum iwl_rxon_context_id ctx, int sta_id,
 				 int tid, int frame_limit, u16 ssn)
@@ -468,7 +476,15 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 		return;
 	}
 
-	txq_id = trans->shrd->tid_data[sta_id][tid].agg.txq_id;
+	txq_id = trans_pcie->agg_txq[sta_id][tid];
+	if (WARN_ON_ONCE(is_agg_txqid_valid(trans, txq_id) == false)) {
+		IWL_ERR(trans,
+			"queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
+			IWLAGN_FIRST_AMPDU_QUEUE +
+			hw_params(trans).num_ampdu_queues - 1);
+		return;
+	}
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
@@ -545,7 +561,7 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 		return -ENXIO;
 	}
 
-	trans->shrd->tid_data[sta_id][tid].agg.txq_id = txq_id;
+	trans_pcie->agg_txq[sta_id][tid] = txq_id;
 	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
 
 	return 0;
@@ -554,12 +570,9 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int sta_id, int tid)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	/* TODO: the transport layer shouldn't access the tid_data */
-	int txq_id = trans->shrd->tid_data[sta_id][tid].agg.txq_id;
+	u8 txq_id = trans_pcie->agg_txq[sta_id][tid];
 
-	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWLAGN_FIRST_AMPDU_QUEUE +
-		hw_params(trans).num_ampdu_queues <= txq_id)) {
+	if (WARN_ON_ONCE(is_agg_txqid_valid(trans, txq_id) == false)) {
 		IWL_ERR(trans,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
@@ -572,6 +585,7 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int sta_id, int tid)
 
 	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
 
+	trans_pcie->agg_txq[sta_id][tid] = 0;
 	trans_pcie->txq[txq_id].q.read_ptr = 0;
 	trans_pcie->txq[txq_id].q.write_ptr = 0;
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 5d44ec5..801e0c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1108,10 +1108,10 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 					info->flags, tid_data->agg.state);
 				IWL_ERR(trans, "sta_id = %d, tid = %d "
 					"txq_id = %d, seq_num = %d", sta_id,
-					tid, tid_data->agg.txq_id,
+					tid, trans_pcie->agg_txq[sta_id][tid],
 					SEQ_TO_SN(seq_number));
 			}
-			txq_id = tid_data->agg.txq_id;
+			txq_id = trans_pcie->agg_txq[sta_id][tid];
 			is_agg = true;
 		}
 		seq_number += 0x10;
@@ -1275,7 +1275,7 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 	return 0;
 }
 
-static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
+static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		      int txq_id, int ssn, u32 status,
 		      struct sk_buff_head *skbs)
 {
@@ -1287,6 +1287,20 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 
 	txq->time_stamp = jiffies;
 
+	if (unlikely(txq_id >= IWLAGN_FIRST_AMPDU_QUEUE &&
+		     txq_id != trans_pcie->agg_txq[sta_id][tid])) {
+		/*
+		 * FIXME: this is a uCode bug which need to be addressed,
+		 * log the information and return for now.
+		 * Since it is can possibly happen very often and in order
+		 * not to fill the syslog, don't use IWL_ERR or IWL_WARN
+		 */
+		IWL_DEBUG_TX_QUEUES(trans, "Bad queue mapping txq_id %d, "
+			"agg_txq[sta_id[tid] %d", txq_id,
+			trans_pcie->agg_txq[sta_id][tid]);
+		return 1;
+	}
+
 	if (txq->q.read_ptr != tfd_num) {
 		IWL_DEBUG_TX_REPLY(trans, "[Q %d | AC %d] %d -> %d (%d)\n",
 				txq_id, iwl_get_queue_ac(txq), txq->q.read_ptr,
@@ -1297,6 +1311,7 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		   status != TX_STATUS_FAIL_PASSIVE_NO_RX))
 			iwl_wake_queue(trans, txq, "Packets reclaimed");
 	}
+	return 0;
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index f8d27a7..8658ce2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -179,7 +179,7 @@ struct iwl_trans_ops {
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
 		u8 sta_id);
-	void (*reclaim)(struct iwl_trans *trans, int sta_id, int tid,
+	int (*reclaim)(struct iwl_trans *trans, int sta_id, int tid,
 			int txq_id, int ssn, u32 status,
 			struct sk_buff_head *skbs);
 
@@ -308,11 +308,12 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id);
 }
 
-static inline void iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
+static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
 				 int tid, int txq_id, int ssn, u32 status,
 				 struct sk_buff_head *skbs)
 {
-	trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn, status, skbs);
+	return trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn,
+				   status, skbs);
 }
 
 static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
-- 
1.7.0.4

