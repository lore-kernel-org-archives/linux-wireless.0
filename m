Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760164Ab1LPQhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:47 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/24] iwlwifi: tid_data moves to iwl_priv
Date: Fri, 16 Dec 2011 07:37:19 -0800
Message-Id: <1324049849-831-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173807_981934_49298A35)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The transport doesn't need to access it any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   34 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   64 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h  |   62 ---------------------------
 6 files changed, 84 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 1c945fb..cf22f48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1158,7 +1158,7 @@ int iwlagn_suspend(struct iwl_priv *priv,
 	 * since the uCode will add 0x10 before using the value.
 	 */
 	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
-		seq = priv->shrd->tid_data[IWL_AP_ID][i].seq_number;
+		seq = priv->tid_data[IWL_AP_ID][i].seq_number;
 		seq -= 0x10;
 		wakeup_filter_cmd.qos_seq[i] = cpu_to_le16(seq);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index bc0c924..334b5ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2273,7 +2273,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	tid = rs_tl_add_packet(lq_sta, hdr);
 	if ((tid != IWL_MAX_TID_COUNT) &&
 	    (lq_sta->tx_agg_tid_en & (1 << tid))) {
-		tid_data = &priv->shrd->tid_data[lq_sta->lq.sta_id][tid];
+		tid_data = &priv->tid_data[lq_sta->lq.sta_id][tid];
 		if (tid_data->agg.state == IWL_AGG_OFF)
 			lq_sta->is_agg = 0;
 		else
@@ -2645,8 +2645,7 @@ lq_update:
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != IWL_MAX_TID_COUNT)) {
 				u8 sta_id = lq_sta->lq.sta_id;
-				tid_data =
-				   &priv->shrd->tid_data[sta_id][tid];
+				tid_data = &priv->tid_data[sta_id][tid];
 				if (tid_data->agg.state == IWL_AGG_OFF) {
 					IWL_DEBUG_RATE(priv,
 						       "try to aggregate tid %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 88ee557..b4f3c08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -375,7 +375,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 			goto drop_unlock_sta;
-		tid_data = &priv->shrd->tid_data[sta_id][tid];
+		tid_data = &priv->tid_data[sta_id][tid];
 
 		/* aggregation is on for this <sta,tid> */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
@@ -403,8 +403,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc) &&
 	    !ieee80211_has_morefrags(fc))
-		priv->shrd->tid_data[sta_id][tid].seq_number =
-				seq_number;
+		priv->tid_data[sta_id][tid].seq_number = seq_number;
 
 	spin_unlock(&priv->shrd->sta_lock);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
@@ -447,9 +446,9 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
-	tid_data = &priv->shrd->tid_data[sta_id][tid];
+	tid_data = &priv->tid_data[sta_id][tid];
 
-	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
+	switch (priv->tid_data[sta_id][tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
 		/*
 		* This can happen if the peer stops aggregation
@@ -464,7 +463,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	default:
 		IWL_WARN(priv, "Stopping AGG while state not ON "
 			 "or starting for %d on %d (%d)\n", sta_id, tid,
-			 priv->shrd->tid_data[sta_id][tid].agg.state);
+			 priv->tid_data[sta_id][tid].agg.state);
 		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return 0;
 	}
@@ -477,7 +476,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 				    "next_recl = %d",
 				    tid_data->agg.ssn,
 				    tid_data->next_reclaimed);
-		priv->shrd->tid_data[sta_id][tid].agg.state =
+		priv->tid_data[sta_id][tid].agg.state =
 			IWL_EMPTYING_HW_QUEUE_DELBA;
 		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return 0;
@@ -486,7 +485,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d",
 			    tid_data->agg.ssn);
 turn_off:
-	priv->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
+	priv->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
 
 	/* do not restore/save irqs */
 	spin_unlock(&priv->shrd->sta_lock);
@@ -521,7 +520,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (unlikely(tid >= IWL_MAX_TID_COUNT))
 		return -EINVAL;
 
-	if (priv->shrd->tid_data[sta_id][tid].agg.state != IWL_AGG_OFF) {
+	if (priv->tid_data[sta_id][tid].agg.state != IWL_AGG_OFF) {
 		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !\n");
 		return -ENXIO;
 	}
@@ -532,7 +531,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
-	tid_data = &priv->shrd->tid_data[sta_id][tid];
+	tid_data = &priv->tid_data[sta_id][tid];
 	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
 
 	*ssn = tid_data->agg.ssn;
@@ -573,7 +572,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	ssn = priv->shrd->tid_data[sta_priv->sta_id][tid].agg.ssn;
+	ssn = priv->tid_data[sta_priv->sta_id][tid].agg.ssn;
 	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 
 	iwl_trans_tx_agg_setup(trans(priv), ctx->ctxid, sta_priv->sta_id, tid,
@@ -625,11 +624,11 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 {
-	struct iwl_tid_data *tid_data = &priv->shrd->tid_data[sta_id][tid];
+	struct iwl_tid_data *tid_data = &priv->tid_data[sta_id][tid];
 
 	lockdep_assert_held(&priv->shrd->sta_lock);
 
-	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
+	switch (priv->tid_data[sta_id][tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
 		/* There are no packets for this RA / TID in the HW any more */
 		if (tid_data->agg.ssn == tid_data->next_reclaimed) {
@@ -797,7 +796,7 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 		IWLAGN_TX_RES_TID_POS;
 	int sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
 		IWLAGN_TX_RES_RA_POS;
-	struct iwl_ht_agg *agg = &priv->shrd->tid_data[sta_id][tid].agg;
+	struct iwl_ht_agg *agg = &priv->tid_data[sta_id][tid].agg;
 	u32 status = le16_to_cpu(tx_resp->status.status);
 	int i;
 
@@ -1028,8 +1027,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 		}
 
 		__skb_queue_head_init(&skbs);
-		priv->shrd->tid_data[sta_id][tid].next_reclaimed =
-			next_reclaimed;
+		priv->tid_data[sta_id][tid].next_reclaimed = next_reclaimed;
 
 		IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d",
 					  next_reclaimed);
@@ -1132,7 +1130,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 	sta_id = ba_resp->sta_id;
 	tid = ba_resp->tid;
-	agg = &priv->shrd->tid_data[sta_id][tid].agg;
+	agg = &priv->tid_data[sta_id][tid].agg;
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
@@ -1182,7 +1180,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
 			ba_resp->txed, ba_resp->txed_2_done);
 
-	priv->shrd->tid_data[sta_id][tid].next_reclaimed = ba_resp_scd_ssn;
+	priv->tid_data[sta_id][tid].next_reclaimed = ba_resp_scd_ssn;
 
 	iwlagn_check_ratid_empty(priv, sta_id, tid);
 	freed = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 05edbc1..04a3343 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -375,7 +375,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				"TID\tseq_num\trate_n_flags\n");
 
 		for (j = 0; j < IWL_MAX_TID_COUNT; j++) {
-			tid_data = &priv->shrd->tid_data[i][j];
+			tid_data = &priv->tid_data[i][j];
 			pos += scnprintf(buf + pos, bufsz - pos,
 				"%d:\t%#x\t%#x",
 				j, tid_data->seq_number,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f1317a6..e54a4d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -189,6 +189,69 @@ struct iwl_qos_info {
 	struct iwl_qosparam_cmd def_qos_parm;
 };
 
+/**
+ * enum iwl_agg_state
+ *
+ * The state machine of the BA agreement establishment / tear down.
+ * These states relate to a specific RA / TID.
+ *
+ * @IWL_AGG_OFF: aggregation is not used
+ * @IWL_AGG_ON: aggregation session is up
+ * @IWL_EMPTYING_HW_QUEUE_ADDBA: establishing a BA session - waiting for the
+ *	HW queue to be empty from packets for this RA /TID.
+ * @IWL_EMPTYING_HW_QUEUE_DELBA: tearing down a BA session - waiting for the
+ *	HW queue to be empty from packets for this RA /TID.
+ */
+enum iwl_agg_state {
+	IWL_AGG_OFF = 0,
+	IWL_AGG_ON,
+	IWL_EMPTYING_HW_QUEUE_ADDBA,
+	IWL_EMPTYING_HW_QUEUE_DELBA,
+};
+
+/**
+ * struct iwl_ht_agg - aggregation state machine
+
+ * This structs holds the states for the BA agreement establishment and tear
+ * down. It also holds the state during the BA session itself. This struct is
+ * duplicated for each RA / TID.
+
+ * @rate_n_flags: Rate at which Tx was attempted. Holds the data between the
+ *	Tx response (REPLY_TX), and the block ack notification
+ *	(REPLY_COMPRESSED_BA).
+ * @state: state of the BA agreement establishment / tear down.
+ * @txq_id: Tx queue used by the BA session - used by the transport layer.
+ *	Needed by the upper layer for debugfs only.
+ * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
+ *	the first packet to be sent in legacy HW queue in Tx AGG stop flow.
+ *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
+ *	we are ready to finish the Tx AGG stop / start flow.
+ * @wait_for_ba: Expect block-ack before next Tx reply
+ */
+struct iwl_ht_agg {
+	u32 rate_n_flags;
+	enum iwl_agg_state state;
+	u16 txq_id;
+	u16 ssn;
+	bool wait_for_ba;
+};
+
+/**
+ * struct iwl_tid_data - one for each RA / TID
+
+ * This structs holds the states for each RA / TID.
+
+ * @seq_number: the next WiFi sequence number to use
+ * @next_reclaimed: the WiFi sequence number of the next packet to be acked.
+ *	This is basically (last acked packet++).
+ * @agg: aggregation state machine
+ */
+struct iwl_tid_data {
+	u16 seq_number;
+	u16 next_reclaimed;
+	struct iwl_ht_agg agg;
+};
+
 /*
  * Structure should be accessed with sta_lock held. When station addition
  * is in progress (IWL_STA_UCODE_INPROGRESS) it is possible to access only
@@ -869,6 +932,7 @@ struct iwl_priv {
 	int num_stations;
 	struct iwl_station_entry stations[IWLAGN_STATION_COUNT];
 	unsigned long ucode_key_table;
+	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
 
 	u8 mac80211_registered;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 9b11c74..c458137 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -199,66 +199,6 @@ struct iwl_hw_params {
 };
 
 /**
- * enum iwl_agg_state
- *
- * The state machine of the BA agreement establishment / tear down.
- * These states relate to a specific RA / TID.
- *
- * @IWL_AGG_OFF: aggregation is not used
- * @IWL_AGG_ON: aggregation session is up
- * @IWL_EMPTYING_HW_QUEUE_ADDBA: establishing a BA session - waiting for the
- *	HW queue to be empty from packets for this RA /TID.
- * @IWL_EMPTYING_HW_QUEUE_DELBA: tearing down a BA session - waiting for the
- *	HW queue to be empty from packets for this RA /TID.
- */
-enum iwl_agg_state {
-	IWL_AGG_OFF = 0,
-	IWL_AGG_ON,
-	IWL_EMPTYING_HW_QUEUE_ADDBA,
-	IWL_EMPTYING_HW_QUEUE_DELBA,
-};
-
-/**
- * struct iwl_ht_agg - aggregation state machine
-
- * This structs holds the states for the BA agreement establishment and tear
- * down. It also holds the state during the BA session itself. This struct is
- * duplicated for each RA / TID.
-
- * @rate_n_flags: Rate at which Tx was attempted. Holds the data between the
- *	Tx response (REPLY_TX), and the block ack notification
- *	(REPLY_COMPRESSED_BA).
- * @state: state of the BA agreement establishment / tear down.
- * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
- *	the first packet to be sent in legacy HW queue in Tx AGG stop flow.
- *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
- *	we are ready to finish the Tx AGG stop / start flow.
- * @wait_for_ba: Expect block-ack before next Tx reply
- */
-struct iwl_ht_agg {
-	u32 rate_n_flags;
-	enum iwl_agg_state state;
-	u16 ssn;
-	bool wait_for_ba;
-};
-
-/**
- * struct iwl_tid_data - one for each RA / TID
-
- * This structs holds the states for each RA / TID.
-
- * @seq_number: the next WiFi sequence number to use
- * @next_reclaimed: the WiFi sequence number of the next packet to be acked.
- *	This is basically (last acked packet++).
- * @agg: aggregation state machine
- */
-struct iwl_tid_data {
-	u16 seq_number;
-	u16 next_reclaimed;
-	struct iwl_ht_agg agg;
-};
-
-/**
  * enum iwl_ucode_type
  *
  * The type of ucode currently loaded on the hardware.
@@ -448,8 +388,6 @@ struct iwl_shared {
 	spinlock_t sta_lock;
 	struct mutex mutex;
 
-	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
-
 	wait_queue_head_t wait_command_queue;
 
 	/* eeprom -- this is in the card's little endian byte order */
-- 
1.7.0.4

