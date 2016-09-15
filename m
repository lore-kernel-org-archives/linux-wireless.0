Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54864 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753409AbcIOSMj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:17 +0300
Message-Id: <20160915181131.32213-11-luca@coelho.fi> (sfid-20160915_201246_701548_CDA34BE3)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: mvm: support new BA notification response
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Support new format. TX response will not be sent anymore,
so all needed data is in the BA response.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  79 ++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 159 ++++++++++++++-------
 2 files changed, 184 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 6b4c63a..0055a96 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -578,6 +578,85 @@ struct iwl_mvm_ba_notif {
 } __packed;
 
 /**
+ * struct iwl_mvm_compressed_ba_tfd - progress of a TFD queue
+ * @q_num: TFD queue number
+ * @tfd_index: Index of first un-acked frame in the  TFD queue
+ */
+struct iwl_mvm_compressed_ba_tfd {
+	u8 q_num;
+	u8 reserved;
+	__le16 tfd_index;
+} __packed; /* COMPRESSED_BA_TFD_API_S_VER_1 */
+
+/**
+ * struct iwl_mvm_compressed_ba_ratid - progress of a RA TID queue
+ * @q_num: RA TID queue number
+ * @tid: TID of the queue
+ * @ssn: BA window current SSN
+ */
+struct iwl_mvm_compressed_ba_ratid {
+	u8 q_num;
+	u8 tid;
+	__le16 ssn;
+} __packed; /* COMPRESSED_BA_RATID_API_S_VER_1 */
+
+/*
+ * enum iwl_mvm_ba_resp_flags - TX aggregation status
+ * @IWL_MVM_BA_RESP_TX_AGG: generated due to BA
+ * @IWL_MVM_BA_RESP_TX_BAR: generated due to BA after BAR
+ * @IWL_MVM_BA_RESP_TX_AGG_FAIL: aggregation didn't receive BA
+ * @IWL_MVM_BA_RESP_TX_UNDERRUN: aggregation got underrun
+ * @IWL_MVM_BA_RESP_TX_BT_KILL: aggregation got BT-kill
+ * @IWL_MVM_BA_RESP_TX_DSP_TIMEOUT: aggregation didn't finish within the
+ *	expected time
+ */
+enum iwl_mvm_ba_resp_flags {
+	IWL_MVM_BA_RESP_TX_AGG,
+	IWL_MVM_BA_RESP_TX_BAR,
+	IWL_MVM_BA_RESP_TX_AGG_FAIL,
+	IWL_MVM_BA_RESP_TX_UNDERRUN,
+	IWL_MVM_BA_RESP_TX_BT_KILL,
+	IWL_MVM_BA_RESP_TX_DSP_TIMEOUT
+};
+
+/**
+ * struct iwl_mvm_compressed_ba_notif - notifies about reception of BA
+ * ( BA_NOTIF = 0xc5 )
+ * @flags: status flag, see the &iwl_mvm_ba_resp_flags
+ * @sta_id: Index of recipient (BA-sending) station in fw's station table
+ * @reduced_txp: power reduced according to TPC. This is the actual value and
+ *	not a copy from the LQ command. Thus, if not the first rate was used
+ *	for Tx-ing then this value will be set to 0 by FW.
+ * @initial_rate: TLC rate info, initial rate index, TLC table color
+ * @retry_cnt: retry count
+ * @query_byte_cnt: SCD query byte count
+ * @query_frame_cnt: SCD query frame count
+ * @txed: number of frames sent in the aggregation (all-TIDs)
+ * @done: number of frames that were Acked by the BA (all-TIDs)
+ * @wireless_time: Wireless-media time
+ * @tx_rate: the rate the aggregation was sent at
+ * @tfd_cnt: number of TFD-Q elements
+ * @ra_tid_cnt: number of RATID-Q elements
+ */
+struct iwl_mvm_compressed_ba_notif {
+	__le32 flags;
+	u8 sta_id;
+	u8 reduced_txp;
+	u8 initial_rate;
+	u8 retry_cnt;
+	__le32 query_byte_cnt;
+	__le16 query_frame_cnt;
+	__le16 txed;
+	__le16 done;
+	__le32 wireless_time;
+	__le32 tx_rate;
+	__le16 tfd_cnt;
+	__le16 ra_tid_cnt;
+	struct iwl_mvm_compressed_ba_tfd tfd[1];
+	struct iwl_mvm_compressed_ba_ratid ra_tid[0];
+} __packed; /* COMPRESSED_BA_RES_API_S_VER_4 */
+
+/**
  * struct iwl_mac_beacon_cmd_v6 - beacon template command
  * @tx: the tx commands associated with the beacon frame
  * @template_id: currently equal to the mac context id of the coresponding
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 6271470..96482a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1584,41 +1584,16 @@ void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		iwl_mvm_rx_tx_cmd_agg(mvm, pkt);
 }
 
-static void iwl_mvm_tx_info_from_ba_notif(struct ieee80211_tx_info *info,
-					  struct iwl_mvm_ba_notif *ba_notif,
-					  struct iwl_mvm_tid_data *tid_data)
+static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
+			       int txq, int index,
+			       struct ieee80211_tx_info *ba_info, u32 rate)
 {
-	info->flags |= IEEE80211_TX_STAT_AMPDU;
-	info->status.ampdu_ack_len = ba_notif->txed_2_done;
-	info->status.ampdu_len = ba_notif->txed;
-	iwl_mvm_hwrate_to_tx_status(tid_data->rate_n_flags,
-				    info);
-	/* TODO: not accounted if the whole A-MPDU failed */
-	info->status.tx_time = tid_data->tx_time;
-	info->status.status_driver_data[0] =
-		(void *)(uintptr_t)ba_notif->reduced_txp;
-	info->status.status_driver_data[1] =
-		(void *)(uintptr_t)tid_data->rate_n_flags;
-}
-
-void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_mvm_ba_notif *ba_notif = (void *)pkt->data;
 	struct sk_buff_head reclaimed_skbs;
 	struct iwl_mvm_tid_data *tid_data;
 	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
 	struct sk_buff *skb;
-	int sta_id, tid, freed;
-	/* "flow" corresponds to Tx queue */
-	u16 scd_flow = le16_to_cpu(ba_notif->scd_flow);
-	/* "ssn" is start of block-ack Tx window, corresponds to index
-	 * (in Tx queue's circular buffer) of first TFD/frame in window */
-	u16 ba_resp_scd_ssn = le16_to_cpu(ba_notif->scd_ssn);
-
-	sta_id = ba_notif->sta_id;
-	tid = ba_notif->tid;
+	int freed;
 
 	if (WARN_ONCE(sta_id >= IWL_MVM_STATION_COUNT ||
 		      tid >= IWL_MAX_TID_COUNT,
@@ -1638,10 +1613,10 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	tid_data = &mvmsta->tid_data[tid];
 
-	if (tid_data->txq_id != scd_flow) {
+	if (tid_data->txq_id != txq) {
 		IWL_ERR(mvm,
-			"invalid BA notification: Q %d, tid %d, flow %d\n",
-			tid_data->txq_id, tid, scd_flow);
+			"invalid BA notification: Q %d, tid %d\n",
+			tid_data->txq_id, tid);
 		rcu_read_unlock();
 		return;
 	}
@@ -1655,27 +1630,14 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway).
 	 */
-	iwl_trans_reclaim(mvm->trans, scd_flow, ba_resp_scd_ssn,
-			  &reclaimed_skbs);
+	iwl_trans_reclaim(mvm->trans, txq, index, &reclaimed_skbs);
 
-	IWL_DEBUG_TX_REPLY(mvm,
-			   "BA_NOTIFICATION Received from %pM, sta_id = %d\n",
-			   (u8 *)&ba_notif->sta_addr_lo32,
-			   ba_notif->sta_id);
-	IWL_DEBUG_TX_REPLY(mvm,
-			   "TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = %d, scd_ssn = %d sent:%d, acked:%d\n",
-			   ba_notif->tid, le16_to_cpu(ba_notif->seq_ctl),
-			   (unsigned long long)le64_to_cpu(ba_notif->bitmap),
-			   scd_flow, ba_resp_scd_ssn, ba_notif->txed,
-			   ba_notif->txed_2_done);
-
-	IWL_DEBUG_TX_REPLY(mvm, "reduced txp from ba notif %d\n",
-			   ba_notif->reduced_txp);
-	tid_data->next_reclaimed = ba_resp_scd_ssn;
+	tid_data->next_reclaimed = index;
 
 	iwl_mvm_check_ratid_empty(mvm, sta, tid);
 
 	freed = 0;
+	ba_info->status.status_driver_data[1] = (void *)(uintptr_t)rate;
 
 	skb_queue_walk(&reclaimed_skbs, skb) {
 		struct ieee80211_hdr *hdr = (void *)skb->data;
@@ -1697,8 +1659,12 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 
 		/* this is the first skb we deliver in this batch */
 		/* put the rate scaling data there */
-		if (freed == 1)
-			iwl_mvm_tx_info_from_ba_notif(info, ba_notif, tid_data);
+		if (freed == 1) {
+			info->flags |= IEEE80211_TX_STAT_AMPDU;
+			memcpy(&info->status, &ba_info->status,
+			       sizeof(ba_info->status));
+			iwl_mvm_hwrate_to_tx_status(rate, info);
+		}
 	}
 
 	spin_unlock_bh(&mvmsta->lock);
@@ -1708,7 +1674,6 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	 * Still it's important to update RS about sent vs. acked.
 	 */
 	if (skb_queue_empty(&reclaimed_skbs)) {
-		struct ieee80211_tx_info ba_info = {};
 		struct ieee80211_chanctx_conf *chanctx_conf = NULL;
 
 		if (mvmsta->vif)
@@ -1718,11 +1683,11 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		if (WARN_ON_ONCE(!chanctx_conf))
 			goto out;
 
-		ba_info.band = chanctx_conf->def.chan->band;
-		iwl_mvm_tx_info_from_ba_notif(&ba_info, ba_notif, tid_data);
+		ba_info->band = chanctx_conf->def.chan->band;
+		iwl_mvm_hwrate_to_tx_status(rate, ba_info);
 
 		IWL_DEBUG_TX_REPLY(mvm, "No reclaim. Update rs directly\n");
-		iwl_mvm_rs_tx_status(mvm, sta, tid, &ba_info, false);
+		iwl_mvm_rs_tx_status(mvm, sta, tid, ba_info, false);
 	}
 
 out:
@@ -1734,6 +1699,92 @@ out:
 	}
 }
 
+void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	int sta_id, tid, txq, index;
+	struct ieee80211_tx_info ba_info = {};
+	struct iwl_mvm_ba_notif *ba_notif;
+	struct iwl_mvm_tid_data *tid_data;
+	struct iwl_mvm_sta *mvmsta;
+
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		struct iwl_mvm_compressed_ba_notif *ba_res =
+			(void *)pkt->data;
+
+		sta_id = ba_res->sta_id;
+		ba_info.status.ampdu_ack_len = (u8)le16_to_cpu(ba_res->done);
+		ba_info.status.ampdu_len = (u8)le16_to_cpu(ba_res->txed);
+		ba_info.status.tx_time =
+			(u16)le32_to_cpu(ba_res->wireless_time);
+		ba_info.status.status_driver_data[0] =
+			(void *)(uintptr_t)ba_res->reduced_txp;
+
+		/*
+		 * TODO:
+		 * When supporting multi TID aggregations - we need to move
+		 * next_reclaimed to be per TXQ and not per TID or handle it
+		 * in a different way.
+		 * This will go together with SN and AddBA offload and cannot
+		 * be handled properly for now.
+		 */
+		WARN_ON(le16_to_cpu(ba_res->tfd_cnt) != 1);
+		iwl_mvm_tx_reclaim(mvm, sta_id, ba_res->ra_tid[0].tid,
+				   (int)ba_res->tfd[0].q_num,
+				   le16_to_cpu(ba_res->tfd[0].tfd_index),
+				   &ba_info, le32_to_cpu(ba_res->tx_rate));
+
+		IWL_DEBUG_TX_REPLY(mvm,
+				   "BA_NOTIFICATION Received from sta_id = %d, flags %x, sent:%d, acked:%d\n",
+				   sta_id, le32_to_cpu(ba_res->flags),
+				   le16_to_cpu(ba_res->txed),
+				   le16_to_cpu(ba_res->done));
+		return;
+	}
+
+	ba_notif = (void *)pkt->data;
+	sta_id = ba_notif->sta_id;
+	tid = ba_notif->tid;
+	/* "flow" corresponds to Tx queue */
+	txq = le16_to_cpu(ba_notif->scd_flow);
+	/* "ssn" is start of block-ack Tx window, corresponds to index
+	 * (in Tx queue's circular buffer) of first TFD/frame in window */
+	index = le16_to_cpu(ba_notif->scd_ssn);
+
+	rcu_read_lock();
+	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, sta_id);
+	if (WARN_ON_ONCE(!mvmsta)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	tid_data = &mvmsta->tid_data[tid];
+
+	ba_info.status.ampdu_ack_len = ba_notif->txed_2_done;
+	ba_info.status.ampdu_len = ba_notif->txed;
+	ba_info.status.tx_time = tid_data->tx_time;
+	ba_info.status.status_driver_data[0] =
+		(void *)(uintptr_t)ba_notif->reduced_txp;
+
+	rcu_read_unlock();
+
+	iwl_mvm_tx_reclaim(mvm, sta_id, tid, txq, index, &ba_info,
+			   tid_data->rate_n_flags);
+
+	IWL_DEBUG_TX_REPLY(mvm,
+			   "BA_NOTIFICATION Received from %pM, sta_id = %d\n",
+			   (u8 *)&ba_notif->sta_addr_lo32, ba_notif->sta_id);
+
+	IWL_DEBUG_TX_REPLY(mvm,
+			   "TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = %d, scd_ssn = %d sent:%d, acked:%d\n",
+			   ba_notif->tid, le16_to_cpu(ba_notif->seq_ctl),
+			   le64_to_cpu(ba_notif->bitmap), txq, index,
+			   ba_notif->txed, ba_notif->txed_2_done);
+
+	IWL_DEBUG_TX_REPLY(mvm, "reduced txp from ba notif %d\n",
+			   ba_notif->reduced_txp);
+}
+
 /*
  * Note that there are transports that buffer frames before they reach
  * the firmware. This means that after flush_tx_path is called, the
-- 
2.9.3
