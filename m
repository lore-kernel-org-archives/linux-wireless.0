Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab1HMSSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 46/60] iwlagn: iwl_tid_data moves to iwl-shared
Date: Sat, 13 Aug 2011 10:38:22 -0700
Message-Id: <1313257116-2697-47-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201847_760170_0F36CCF8)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The rate scaling and the transport need to access the data in
iwl_tid_data, hence the move.

Note that the only component in the upper layer that needs this data
is the rate scaling. Refactoring the rate scaling may help to move
iwl_tid_data from the shared area to the transport area.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |   18 +++++----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |   47 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   25 +++++------
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   39 ------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   32 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c         |    2 +-
 9 files changed, 83 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 8fc68e7..f979cf2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -298,10 +298,10 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
 	} else
-		return MAX_TID_COUNT;
+		return IWL_MAX_TID_COUNT;
 
 	if (unlikely(tid >= TID_MAX_LOAD_COUNT))
-		return MAX_TID_COUNT;
+		return IWL_MAX_TID_COUNT;
 
 	tl = &lq_data->load[tid];
 
@@ -314,7 +314,7 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 		tl->queue_count = 1;
 		tl->head = 0;
 		tl->packet_count[0] = 1;
-		return MAX_TID_COUNT;
+		return IWL_MAX_TID_COUNT;
 	}
 
 	time_diff = TIME_WRAP_AROUND(tl->time_stamp, curr_time);
@@ -2262,7 +2262,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	u8 done_search = 0;
 	u16 high_low;
 	s32 sr;
-	u8 tid = MAX_TID_COUNT;
+	u8 tid = IWL_MAX_TID_COUNT;
 	struct iwl_tid_data *tid_data;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
@@ -2281,8 +2281,9 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
-	if ((tid != MAX_TID_COUNT) && (lq_sta->tx_agg_tid_en & (1 << tid))) {
-		tid_data = &priv->stations[lq_sta->lq.sta_id].tid[tid];
+	if ((tid != IWL_MAX_TID_COUNT) &&
+	    (lq_sta->tx_agg_tid_en & (1 << tid))) {
+		tid_data = &priv->shrd->tid_data[lq_sta->lq.sta_id][tid];
 		if (tid_data->agg.state == IWL_AGG_OFF)
 			lq_sta->is_agg = 0;
 		else
@@ -2652,9 +2653,10 @@ lq_update:
 		    iwl_ht_enabled(priv)) {
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
-			    (tid != MAX_TID_COUNT)) {
+			    (tid != IWL_MAX_TID_COUNT)) {
+				u8 sta_id = lq_sta->lq.sta_id;
 				tid_data =
-				   &priv->stations[lq_sta->lq.sta_id].tid[tid];
+				   &priv->shrd->tid_data[sta_id][tid];
 				if (tid_data->agg.state == IWL_AGG_OFF) {
 					IWL_DEBUG_RATE(priv,
 						       "try to aggregate tid %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f863a61..f63c379 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -410,13 +410,15 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	if (ieee80211_is_data_qos(fc)) {
 		u8 *qc = NULL;
+		struct iwl_tid_data *tid_data;
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		tid_data = &priv->shrd->tid_data[sta_id][tid];
 
-		if (WARN_ON_ONCE(tid >= MAX_TID_COUNT))
+		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 			goto drop_unlock_sta;
 
-		seq_number = priv->stations[sta_id].tid[tid].seq_number;
+		seq_number = tid_data->seq_number;
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = hdr->seq_ctrl &
 				cpu_to_le16(IEEE80211_SCTL_FRAG);
@@ -424,8 +426,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-		    priv->stations[sta_id].tid[tid].agg.state == IWL_AGG_ON) {
-			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
+		    tid_data->agg.state == IWL_AGG_ON) {
+			txq_id = tid_data->agg.txq_id;
 			is_agg = true;
 		}
 	}
@@ -456,9 +458,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc)) {
-		priv->stations[sta_id].tid[tid].tfds_in_queue++;
+		priv->shrd->tid_data[sta_id][tid].tfds_in_queue++;
 		if (!ieee80211_has_morefrags(fc))
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
+			priv->shrd->tid_data[sta_id][tid].seq_number =
+				seq_number;
 	}
 
 	spin_unlock(&priv->shrd->sta_lock);
@@ -521,10 +524,10 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		IWL_ERR(priv, "Start AGG on invalid station\n");
 		return -ENXIO;
 	}
-	if (unlikely(tid >= MAX_TID_COUNT))
+	if (unlikely(tid >= IWL_MAX_TID_COUNT))
 		return -EINVAL;
 
-	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
+	if (priv->shrd->tid_data[sta_id][tid].agg.state != IWL_AGG_OFF) {
 		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !\n");
 		return -ENXIO;
 	}
@@ -536,7 +539,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	}
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	tid_data = &priv->stations[sta_id].tid[tid];
+	tid_data = &priv->shrd->tid_data[sta_id][tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
 	tid_data->agg.tx_fifo = tx_fifo;
@@ -548,7 +551,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return ret;
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	tid_data = &priv->stations[sta_id].tid[tid];
+	tid_data = &priv->shrd->tid_data[sta_id][tid];
 	if (tid_data->tfds_in_queue == 0) {
 		IWL_DEBUG_HT(priv, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
@@ -583,11 +586,11 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
-	tid_data = &priv->stations[sta_id].tid[tid];
+	tid_data = &priv->shrd->tid_data[sta_id][tid];
 	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
 	txq_id = tid_data->agg.txq_id;
 
-	switch (priv->stations[sta_id].tid[tid].agg.state) {
+	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
 		/*
 		 * This can happen if the peer stops aggregation
@@ -609,7 +612,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	/* The queue is not empty */
 	if (write_ptr != read_ptr) {
 		IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
-		priv->stations[sta_id].tid[tid].agg.state =
+		priv->shrd->tid_data[sta_id][tid].agg.state =
 				IWL_EMPTYING_HW_QUEUE_DELBA;
 		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return 0;
@@ -617,7 +620,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	IWL_DEBUG_HT(priv, "HW queue is empty\n");
  turn_off:
-	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
+	priv->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
 
 	/* do not restore/save irqs */
 	spin_unlock(&priv->shrd->sta_lock);
@@ -643,14 +646,14 @@ static int iwlagn_txq_check_empty(struct iwl_priv *priv,
 {
 	struct iwl_queue *q = &priv->txq[txq_id].q;
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
-	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
+	struct iwl_tid_data *tid_data = &priv->shrd->tid_data[sta_id][tid];
 	struct iwl_rxon_context *ctx;
 
 	ctx = &priv->contexts[priv->stations[sta_id].ctxid];
 
 	lockdep_assert_held(&priv->shrd->sta_lock);
 
-	switch (priv->stations[sta_id].tid[tid].agg.state) {
+	switch (priv->shrd->tid_data[sta_id][tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
 		/* We are reclaiming the last packet of the */
 		/* aggregated HW queue */
@@ -815,7 +818,7 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 		IWLAGN_TX_RES_TID_POS;
 	int sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
 		IWLAGN_TX_RES_RA_POS;
-	struct iwl_ht_agg *agg = &priv->stations[sta_id].tid[tid].agg;
+	struct iwl_ht_agg *agg = &priv->shrd->tid_data[sta_id][tid].agg;
 	u32 status = le16_to_cpu(tx_resp->status.status);
 	int i;
 
@@ -893,13 +896,13 @@ static void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 {
 	lockdep_assert_held(&priv->shrd->sta_lock);
 
-	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
-		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+	if (priv->shrd->tid_data[sta_id][tid].tfds_in_queue >= freed)
+		priv->shrd->tid_data[sta_id][tid].tfds_in_queue -= freed;
 	else {
 		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
-			priv->stations[sta_id].tid[tid].tfds_in_queue,
+			priv->shrd->tid_data[sta_id][tid].tfds_in_queue,
 			freed);
-		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
+		priv->shrd->tid_data[sta_id][tid].tfds_in_queue = 0;
 	}
 }
 
@@ -1149,7 +1152,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	txq = &priv->txq[scd_flow];
 	sta_id = ba_resp->sta_id;
 	tid = ba_resp->tid;
-	agg = &priv->stations[sta_id].tid[tid].agg;
+	agg = &priv->shrd->tid_data[sta_id][tid].agg;
 
 	/* Find index of block-ack window */
 	index = ba_resp_scd_ssn & (txq->q.n_bd - 1);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dd306fd..191e1b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2201,7 +2201,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	 * since the uCode will add 0x10 before using the value.
 	 */
 	for (i = 0; i < 8; i++) {
-		seq = priv->stations[IWL_AP_ID].tid[i].seq_number;
+		seq = priv->shrd->tid_data[IWL_AP_ID][i].seq_number;
 		seq -= 0x10;
 		wakeup_filter_cmd.qos_seq[i] = cpu_to_le16(seq);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 20b4b39..dd7c29f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -808,6 +808,7 @@ struct iwl_qosparam_cmd {
 #define	IWLAGN_STATION_COUNT	16
 
 #define	IWL_INVALID_STATION 	255
+#define IWL_MAX_TID_COUNT	9
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a01beb3..e320cc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -340,6 +340,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 {
 	struct iwl_priv *priv = file->private_data;
 	struct iwl_station_entry *station;
+	struct iwl_tid_data *tid_data;
 	int max_sta = hw_params(priv).max_stations;
 	char *buf;
 	int i, j, pos = 0;
@@ -363,22 +364,18 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				 i, station->sta.sta.addr,
 				 station->sta.station_flags_msk);
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"TID\tseq_num\ttxq_id\tframes\ttfds\t");
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"start_idx\tbitmap\t\t\trate_n_flags\n");
+				"TID\tseq_num\ttxq_id\ttfds\trate_n_flags\n");
 
-		for (j = 0; j < MAX_TID_COUNT; j++) {
+		for (j = 0; j < IWL_MAX_TID_COUNT; j++) {
+			tid_data = &priv->shrd->tid_data[i][j];
 			pos += scnprintf(buf + pos, bufsz - pos,
-				"%d:\t%#x\t%#x\t%u\t%u\t%u\t\t%#.16llx\t%#x",
-				j, station->tid[j].seq_number,
-				station->tid[j].agg.txq_id,
-				station->tid[j].agg.frame_count,
-				station->tid[j].tfds_in_queue,
-				station->tid[j].agg.start_idx,
-				station->tid[j].agg.bitmap,
-				station->tid[j].agg.rate_n_flags);
-
-			if (station->tid[j].agg.wait_for_ba)
+				"%d:\t%#x\t%#x\t%u\t%#x",
+				j, tid_data->seq_number,
+				tid_data->agg.txq_id,
+				tid_data->tfds_in_queue,
+				tid_data->agg.rate_n_flags);
+
+			if (tid_data->agg.wait_for_ba)
 				pos += scnprintf(buf + pos, bufsz - pos,
 						 " - waitforba");
 			pos += scnprintf(buf + pos, bufsz - pos, "\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 032e536..23972f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -330,47 +330,9 @@ struct iwl_host_cmd {
 
 #define IWL_SUPPORTED_RATES_IE_LEN         8
 
-#define MAX_TID_COUNT        9
-
 #define IWL_INVALID_RATE     0xFF
 #define IWL_INVALID_VALUE    -1
 
-/**
- * struct iwl_ht_agg -- aggregation status while waiting for block-ack
- * @txq_id: Tx queue used for Tx attempt
- * @frame_count: # frames attempted by Tx command
- * @wait_for_ba: Expect block-ack before next Tx reply
- * @start_idx: Index of 1st Transmit Frame Descriptor (TFD) in Tx window
- * @bitmap0: Low order bitmap, one bit for each frame pending ACK in Tx window
- * @bitmap1: High order, one bit for each frame pending ACK in Tx window
- * @rate_n_flags: Rate at which Tx was attempted
- *
- * If REPLY_TX indicates that aggregation was attempted, driver must wait
- * for block ack (REPLY_COMPRESSED_BA).  This struct stores tx reply info
- * until block ack arrives.
- */
-struct iwl_ht_agg {
-	u16 txq_id;
-	u16 frame_count;
-	u16 wait_for_ba;
-	u16 start_idx;
-	u64 bitmap;
-	u32 rate_n_flags;
-#define IWL_AGG_OFF 0
-#define IWL_AGG_ON 1
-#define IWL_EMPTYING_HW_QUEUE_ADDBA 2
-#define IWL_EMPTYING_HW_QUEUE_DELBA 3
-	u8 state;
-	u8 tx_fifo;
-};
-
-
-struct iwl_tid_data {
-	u16 seq_number; /* agn only */
-	u16 tfds_in_queue;
-	struct iwl_ht_agg agg;
-};
-
 union iwl_ht_rate_supp {
 	u16 rates;
 	struct {
@@ -421,7 +383,6 @@ struct iwl_qos_info {
  */
 struct iwl_station_entry {
 	struct iwl_addsta_cmd sta;
-	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used, ctxid;
 	struct iwl_link_quality_cmd *lq;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 27aee52..bb61c13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -68,6 +68,8 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 
+#include "iwl-commands.h"
+
 /*This files includes all the types / functions that are exported by the
  * upper layer to the bus and transport layer */
 
@@ -167,6 +169,34 @@ struct iwl_hw_params {
 };
 
 /**
+ * struct iwl_ht_agg - aggregation status while waiting for block-ack
+ * @txq_id: Tx queue used for Tx attempt
+ * @wait_for_ba: Expect block-ack before next Tx reply
+ * @rate_n_flags: Rate at which Tx was attempted
+ *
+ * If REPLY_TX indicates that aggregation was attempted, driver must wait
+ * for block ack (REPLY_COMPRESSED_BA).  This struct stores tx reply info
+ * until block ack arrives.
+ */
+struct iwl_ht_agg {
+	u16 txq_id;
+	u16 wait_for_ba;
+	u32 rate_n_flags;
+#define IWL_AGG_OFF 0
+#define IWL_AGG_ON 1
+#define IWL_EMPTYING_HW_QUEUE_ADDBA 2
+#define IWL_EMPTYING_HW_QUEUE_DELBA 3
+	u8 state;
+	u8 tx_fifo;
+};
+
+struct iwl_tid_data {
+	u16 seq_number; /* agn only */
+	u16 tfds_in_queue;
+	struct iwl_ht_agg agg;
+};
+
+/**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
  * @dbg_level_dev: dbg level set per device. Prevails on
@@ -200,6 +230,8 @@ struct iwl_shared {
 	spinlock_t lock;
 	spinlock_t sta_lock;
 	struct mutex mutex;
+
+	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 7ca54eb..15bca8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -438,11 +438,11 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 
 	if (WARN_ON(sta_id == IWL_INVALID_STATION))
 		return;
-	if (WARN_ON(tid >= MAX_TID_COUNT))
+	if (WARN_ON(tid >= IWL_MAX_TID_COUNT))
 		return;
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	tid_data = &priv->stations[sta_id].tid[tid];
+	tid_data = &priv->shrd->tid_data[sta_id][tid];
 	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
 	txq_id = tid_data->agg.txq_id;
 	tx_fifo = tid_data->agg.tx_fifo;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index b95e713..a18ed42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1193,7 +1193,7 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id,
 
 	if (txq->sched_retry) {
 		agg_state =
-			priv->stations[txq->sta_id].tid[txq->tid].agg.state;
+			priv->shrd->tid_data[txq->sta_id][txq->tid].agg.state;
 		cond = (agg_state != IWL_EMPTYING_HW_QUEUE_DELBA);
 	} else {
 		cond = (status != TX_STATUS_FAIL_PASSIVE_NO_RX);
-- 
1.7.0.4

