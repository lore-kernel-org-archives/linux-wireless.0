Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4785 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYJNTfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:21 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/9] iwlwifi: refactor TX response flow
Date: Tue, 14 Oct 2008 12:32:46 -0700
Message-Id: <1224012769-8920-7-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213530_021253_CD59C1DF)
In-Reply-To: <1224012769-8920-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch utilize 5000 new TX response command
which contains all necessary information and avoids
back referencing to the original TX frame.
It also change handling of software queue tracking
4965 flow is aligned with changes as much as possible.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   63 +++++++++------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   81 +++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   50 ++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 +--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   41 +++++++-------
 6 files changed, 126 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9838de5..7cf5e2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -822,7 +822,6 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
-	priv->hw_params.first_ampdu_q = IWL49_FIRST_AMPDU_QUEUE;
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
@@ -2059,7 +2058,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	agg->rate_n_flags = rate_n_flags;
 	agg->bitmap = 0;
 
-	/* # frames attempted by Tx command */
+	/* num frames attempted by Tx command */
 	if (agg->frame_count == 1) {
 		/* Only one frame was attempted; no block-ack will arrive */
 		status = le16_to_cpu(frame_status[0].status);
@@ -2158,12 +2157,13 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info;
 	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->u.status);
-	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
-	__le16 fc;
-	struct ieee80211_hdr *hdr;
+	int tid = MAX_TID_COUNT;
+	int sta_id;
+	int freed;
 	u8 *qc = NULL;
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
@@ -2178,8 +2178,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	memset(&info->status, 0, sizeof(info->status));
 
 	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
-	fc = hdr->frame_control;
-	if (ieee80211_is_data_qos(fc)) {
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
 	}
@@ -2194,8 +2193,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		const u32 scd_ssn = iwl4965_get_scd_ssn(tx_resp);
 		struct iwl_ht_agg *agg = NULL;
 
-		if (!qc)
-			return;
+		WARN_ON(!qc);
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
 
@@ -2206,54 +2204,49 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			int freed, ampdu_q;
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 
-			if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
-			    txq_id >= 0 && priv->mac80211_registered &&
-			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA) {
-				/* calculate mac80211 ampdu sw queue to wake */
-				ampdu_q = txq_id - IWL49_FIRST_AMPDU_QUEUE +
-					  priv->hw->queues;
+			if (priv->mac80211_registered &&
+			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
 				if (agg->state == IWL_AGG_OFF)
 					ieee80211_wake_queue(priv->hw, txq_id);
 				else
-					ieee80211_wake_queue(priv->hw, ampdu_q);
+					ieee80211_wake_queue(priv->hw,
+							     txq->swq_id);
 			}
-			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 		}
 	} else {
 		info->status.retry_count = tx_resp->failure_frame;
-		info->flags |=
-			iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
+		info->flags |= iwl_is_tx_success(status) ?
+					IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
-		IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags "
-			     "0x%x retries %d\n", txq_id,
-				iwl_get_tx_fail_reason(status),
-				status, le32_to_cpu(tx_resp->rate_n_flags),
-				tx_resp->failure_frame);
-
-		IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+		IWL_DEBUG_TX_REPLY("TXQ %d status %s (0x%08x) "
+				   "rate_n_flags 0x%x retries %d\n",
+				   txq_id,
+				   iwl_get_tx_fail_reason(status), status,
+				   le32_to_cpu(tx_resp->rate_n_flags),
+				   tx_resp->failure_frame);
 
-		if (index != -1) {
-		    int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		    if (tid != MAX_TID_COUNT)
+		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+		if (qc)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
-		    if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
-			(txq_id >= 0) && priv->mac80211_registered)
+
+		if (priv->mac80211_registered &&
+		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
 			ieee80211_wake_queue(priv->hw, txq_id);
-		    if (tid != MAX_TID_COUNT)
-			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
-		}
 	}
 
+	if (qc)
+		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 35e1f6a..0290c03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -683,7 +683,7 @@ static void iwl5000_tx_queue_set_status(struct iwl_priv *priv,
 					int tx_fifo_id, int scd_retry)
 {
 	int txq_id = txq->q.id;
-	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
+	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
 
 	iwl_write_prph(priv, IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
 			(active << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
@@ -801,7 +801,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
-	priv->hw_params.first_ampdu_q = IWL50_FIRST_AMPDU_QUEUE;
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
@@ -1159,7 +1158,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 		info->status.retry_count = tx_resp->failure_frame;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_is_tx_success(status)?
-			IEEE80211_TX_STAT_ACK : 0;
+					IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
 
 		/* FIXME: code repetition end */
@@ -1245,9 +1244,9 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 	struct ieee80211_tx_info *info;
 	struct iwl5000_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le16_to_cpu(tx_resp->status.status);
-	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
-	struct ieee80211_hdr *hdr;
-	u8 *qc = NULL;
+	int tid;
+	int sta_id;
+	int freed;
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
@@ -1260,25 +1259,13 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
 	memset(&info->status, 0, sizeof(info->status));
 
-	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & 0xf;
-	}
-
-	sta_id = iwl_get_ra_sta_id(priv, hdr);
-	if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
-		IWL_ERROR("Station not known\n");
-		return;
-	}
+	tid = (tx_resp->ra_tid & IWL50_TX_RES_TID_MSK) >> IWL50_TX_RES_TID_POS;
+	sta_id = (tx_resp->ra_tid & IWL50_TX_RES_RA_MSK) >> IWL50_TX_RES_RA_POS;
 
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwl5000_get_scd_ssn(tx_resp);
 		struct iwl_ht_agg *agg = NULL;
 
-		if (!qc)
-			return;
-
 		agg = &priv->stations[sta_id].tid[tid].agg;
 
 		iwl5000_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
@@ -1288,53 +1275,53 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			int freed, ampdu_q;
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
-					   "%d index %d\n", scd_ssn , index);
+			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim "
+					"scd_ssn=%d idx=%d txq=%d swq=%d\n",
+					scd_ssn , index, txq_id, txq->swq_id);
+
 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 
-			if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
-			    txq_id >= 0 && priv->mac80211_registered &&
-			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA) {
-				/* calculate mac80211 ampdu sw queue to wake */
-				ampdu_q = txq_id - IWL50_FIRST_AMPDU_QUEUE +
-					  priv->hw->queues;
+			if (priv->mac80211_registered &&
+			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
 				if (agg->state == IWL_AGG_OFF)
 					ieee80211_wake_queue(priv->hw, txq_id);
 				else
-					ieee80211_wake_queue(priv->hw, ampdu_q);
+					ieee80211_wake_queue(priv->hw,
+							     txq->swq_id);
 			}
-			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 		}
 	} else {
+		BUG_ON(txq_id != txq->swq_id);
+
 		info->status.retry_count = tx_resp->failure_frame;
-		info->flags =
-			iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
+		info->flags |= iwl_is_tx_success(status) ?
+					IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
-		IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags "
-			     "0x%x retries %d\n", txq_id,
-				iwl_get_tx_fail_reason(status),
-				status, le32_to_cpu(tx_resp->rate_n_flags),
-				tx_resp->failure_frame);
+		IWL_DEBUG_TX_REPLY("TXQ %d status %s (0x%08x) rate_n_flags "
+				   "0x%x retries %d\n",
+				   txq_id,
+				   iwl_get_tx_fail_reason(status), status,
+				   le32_to_cpu(tx_resp->rate_n_flags),
+				   tx_resp->failure_frame);
 
-		IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
-		if (index != -1) {
-		    int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		    if (tid != MAX_TID_COUNT)
+		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+		if (ieee80211_is_data_qos(tx_resp->frame_ctrl))
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
-		    if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
-			(txq_id >= 0) && priv->mac80211_registered)
+
+		if (priv->mac80211_registered &&
+		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
 			ieee80211_wake_queue(priv->hw, txq_id);
-		    if (tid != MAX_TID_COUNT)
-			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
-		}
 	}
 
+	if (ieee80211_is_data_qos(tx_resp->frame_ctrl))
+		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 67680a7..8f8734f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1413,21 +1413,21 @@ enum {
 };
 
 enum {
-	TX_STATUS_MSK = 0x000000ff,	/* bits 0:7 */
+	TX_STATUS_MSK = 0x000000ff,		/* bits 0:7 */
 	TX_STATUS_DELAY_MSK = 0x00000040,
 	TX_STATUS_ABORT_MSK = 0x00000080,
 	TX_PACKET_MODE_MSK = 0x0000ff00,	/* bits 8:15 */
 	TX_FIFO_NUMBER_MSK = 0x00070000,	/* bits 16:18 */
-	TX_RESERVED = 0x00780000,	/* bits 19:22 */
+	TX_RESERVED = 0x00780000,		/* bits 19:22 */
 	TX_POWER_PA_DETECT_MSK = 0x7f800000,	/* bits 23:30 */
 	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
 };
 
-static inline int iwl_is_tx_success(u32 status)
+static inline bool iwl_is_tx_success(u32 status)
 {
 	status &= TX_STATUS_MSK;
-	return (status == TX_STATUS_SUCCESS)
-	    || (status == TX_STATUS_DIRECT_DONE);
+	return (status == TX_STATUS_SUCCESS) ||
+	       (status == TX_STATUS_DIRECT_DONE);
 }
 
 
@@ -1452,10 +1452,9 @@ enum {
 	AGG_TX_STATE_DELAY_TX_MSK = 0x400
 };
 
-#define AGG_TX_STATE_LAST_SENT_MSK \
-(AGG_TX_STATE_LAST_SENT_TTL_MSK | \
- AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
- AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
+#define AGG_TX_STATE_LAST_SENT_MSK  (AGG_TX_STATE_LAST_SENT_TTL_MSK | \
+				     AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
+				     AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
 
 /* # tx attempts for first frame in aggregation */
 #define AGG_TX_STATE_TRY_CNT_POS 12
@@ -1528,6 +1527,28 @@ struct iwl4965_tx_resp {
 	} u;
 } __attribute__ ((packed));
 
+/*
+ * definitions for initial rate index field
+ * bits [3:0] inital rate index
+ * bits [6:4] rate table color, used for the initial rate
+ * bit-7 invalid rate indication
+ *   i.e. rate was not chosen from rate table
+ *   or rate table color was changed during frame retries
+ * refer tlc rate info
+ */
+
+#define IWL50_TX_RES_INIT_RATE_INDEX_POS	0
+#define IWL50_TX_RES_INIT_RATE_INDEX_MSK	0x0f
+#define IWL50_TX_RES_RATE_TABLE_COLOR_POS	4
+#define IWL50_TX_RES_RATE_TABLE_COLOR_MSK	0x70
+#define IWL50_TX_RES_INV_RATE_INDEX_MSK	0x80
+
+/* refer to ra_tid */
+#define IWL50_TX_RES_TID_POS	0
+#define IWL50_TX_RES_TID_MSK	0x0f
+#define IWL50_TX_RES_RA_POS	4
+#define IWL50_TX_RES_RA_MSK	0xf0
+
 struct iwl5000_tx_resp {
 	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
 	u8 bt_kill_count;	/* # blocked by bluetooth (unused for agg) */
@@ -1542,14 +1563,17 @@ struct iwl5000_tx_resp {
 	 * For agg:  RTS + CTS + aggregation tx time + block-ack time. */
 	__le16 wireless_media_time;	/* uSecs */
 
-	__le16 reserved;
-	__le32 pa_power1;	/* RF power amplifier measurement (not used) */
-	__le32 pa_power2;
+	u8 pa_status;		/* RF power amplifier measurement (not used) */
+	u8 pa_integ_res_a[3];
+	u8 pa_integ_res_b[3];
+	u8 pa_integ_res_C[3];
 
 	__le32 tfd_info;
 	__le16 seq_ctl;
 	__le16 byte_cnt;
-	__le32 tlc_info;
+	u8 tlc_info;
+	u8 ra_tid;		/* tid (0:3), sta_id (4:7) */
+	__le16 frame_ctrl;
 	/*
 	 * For non-agg:  frame status TX_STATUS_*
 	 * For agg:  status of 1st frame, AGG_TX_STATE_*; other frame status
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index e548d67..2b48a4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -183,6 +183,8 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
 #define IWL_DEBUG_STATS_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
 #define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DEBUG_TX_REPLY_LIMIT(f, a...) \
+	IWL_DEBUG_LIMIT(IWL_DL_TX_REPLY, f, ## a)
 #define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
 #define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
 #define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bdca174..8f1e37a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -137,9 +137,10 @@ struct iwl_tx_queue {
 	struct iwl_tfd_frame *bd;
 	struct iwl_cmd *cmd[TFD_TX_CMD_SLOTS];
 	struct iwl_tx_info *txb;
-	int need_update;
-	int sched_retry;
-	int active;
+	u8 need_update;
+	u8 sched_retry;
+	u8 active;
+	u8 swq_id;
 };
 
 #define IWL_NUM_SCAN_RATES         (2)
@@ -521,7 +522,6 @@ struct iwl_sensitivity_ranges {
  * @ct_kill_threshold: temperature threshold
  * @calib_init_cfg: setup initial claibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
- * @first_ampdu_q: first HW queue available for ampdu
  */
 struct iwl_hw_params {
 	u16 max_txq_num;
@@ -543,7 +543,6 @@ struct iwl_hw_params {
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	u32 calib_init_cfg;
 	const struct iwl_sensitivity_ranges *sens;
-	u8 first_ampdu_q;
 };
 
 #define HT_SHORT_GI_20MHZ	(1 << 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 9ee2897..61e8e12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -877,9 +877,9 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 	}
 
-	/* Descriptor for chosen Tx queue */
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
+	txq->swq_id = swq_id;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -1004,7 +1004,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			iwl_txq_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		} else {
-			ieee80211_stop_queue(priv->hw, swq_id);
+			ieee80211_stop_queue(priv->hw, txq->swq_id);
 		}
 	}
 
@@ -1383,8 +1383,8 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
 		/* We are reclaiming the last packet of the */
 		/* aggregated HW queue */
-		if (txq_id  == tid_data->agg.txq_id &&
-		    q->read_ptr == q->write_ptr) {
+		if ((txq_id  == tid_data->agg.txq_id) &&
+		    (q->read_ptr == q->write_ptr)) {
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = default_tid_to_tx_fifo[tid];
 			IWL_DEBUG_HT("HW queue empty: continue DELBA flow\n");
@@ -1435,7 +1435,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
 
 	/* Calculate shift to align block-ack bits with our Tx window bits */
-	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl>>4);
+	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
 	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
 
@@ -1485,9 +1485,11 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
-	int index;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_ht_agg *agg;
+	int index;
+	int sta_id;
+	int tid;
 	DECLARE_MAC_BUF(mac);
 
 	/* "flow" corresponds to Tx queue */
@@ -1503,17 +1505,19 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 	}
 
 	txq = &priv->txq[scd_flow];
-	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
+	sta_id = ba_resp->sta_id;
+	tid = ba_resp->tid;
+	agg = &priv->stations[sta_id].tid[tid].agg;
 
 	/* Find index just before block-ack window */
 	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
 	/* TODO: Need to get this copy more safely - now good for debug */
 
-	IWL_DEBUG_TX_REPLY("REPLY_COMPRESSED_BA [%d]Received from %s, "
+	IWL_DEBUG_TX_REPLY("REPLY_COMPRESSED_BA [%d] Received from %s, "
 			   "sta_id = %d\n",
 			   agg->wait_for_ba,
-			   print_mac(mac, (u8 *) &ba_resp->sta_addr_lo32),
+			   print_mac(mac, (u8 *)&ba_resp->sta_addr_lo32),
 			   ba_resp->sta_id);
 	IWL_DEBUG_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
 			   "%d, scd_ssn = %d\n",
@@ -1534,18 +1538,15 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * transmitted ... if not, it's too late anyway). */
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
 		/* calculate mac80211 ampdu sw queue to wake */
-		int ampdu_q =
-		   scd_flow - priv->hw_params.first_ampdu_q + priv->hw->queues;
 		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
-		priv->stations[ba_resp->sta_id].
-			tid[ba_resp->tid].tfds_in_queue -= freed;
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
-			priv->mac80211_registered &&
-			agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
-			ieee80211_wake_queue(priv->hw, ampdu_q);
-
-		iwl_txq_check_empty(priv, ba_resp->sta_id,
-				    ba_resp->tid, scd_flow);
+		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+
+		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+		    priv->mac80211_registered &&
+		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
+			ieee80211_wake_queue(priv->hw, txq->swq_id);
+
+		iwl_txq_check_empty(priv, sta_id, tid, scd_flow);
 	}
 }
 EXPORT_SYMBOL(iwl_rx_reply_compressed_ba);
-- 
1.5.4.3

