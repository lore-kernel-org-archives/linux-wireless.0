Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYE2Ihs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 31/43] iwlwifi: move aggregation code to iwl-tx.c
Date: Thu, 29 May 2008 16:35:16 +0800
Message-Id: <1212050128-17132-32-git-send-email-yi.zhu@intel.com> (sfid-20080529_110548_275883_704DEEC9)
In-Reply-To: <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves aggregation action code to iwl-tx.c in iwlcore.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |  224 +++----------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |   14 ++-
 drivers/net/wireless/iwlwifi/iwl-prph.h |    6 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |  190 ++++++++++++++++++++++++++
 5 files changed, 228 insertions(+), 210 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b719d19..556e59e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -55,30 +55,6 @@ static struct iwl_mod_params iwl4965_mod_params = {
 	/* the rest are 0 by default */
 };
 
-#ifdef CONFIG_IWL4965_HT
-
-static const u16 default_tid_to_tx_fifo[] = {
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC0,
-	IWL_TX_FIFO_AC0,
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_AC3
-};
-
-#endif	/*CONFIG_IWL4965_HT */
-
 /* check contents of special bootstrap uCode SRAM */
 static int iwl4965_verify_bsm(struct iwl_priv *priv)
 {
@@ -2986,8 +2962,8 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
  * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
  * priv->lock must be held by the caller
  */
-static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
-					u16 ssn_idx, u8 tx_fifo)
+static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+				   u16 ssn_idx, u8 tx_fifo)
 {
 	int ret = 0;
 
@@ -3019,39 +2995,6 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	return 0;
 }
 
-int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
-					 u8 tid, int txq_id)
-{
-	struct iwl_queue *q = &priv->txq[txq_id].q;
-	u8 *addr = priv->stations[sta_id].sta.sta.addr;
-	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
-
-	switch (priv->stations[sta_id].tid[tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_DELBA:
-		/* We are reclaiming the last packet of the */
-		/* aggregated HW queue */
-		if (txq_id  == tid_data->agg.txq_id &&
-		    q->read_ptr == q->write_ptr) {
-			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
-			int tx_fifo = default_tid_to_tx_fifo[tid];
-			IWL_DEBUG_HT("HW queue empty: continue DELBA flow\n");
-			iwl4965_tx_queue_agg_disable(priv, txq_id,
-						     ssn, tx_fifo);
-			tid_data->agg.state = IWL_AGG_OFF;
-			ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, addr, tid);
-		}
-		break;
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/* We are reclaiming the last packet of the queue */
-		if (tid_data->tfds_in_queue == 0) {
-			IWL_DEBUG_HT("HW queue empty: continue ADDBA flow\n");
-			tid_data->agg.state = IWL_AGG_ON;
-			ieee80211_start_tx_ba_cb_irqsafe(priv->hw, addr, tid);
-		}
-		break;
-	}
-	return 0;
-}
 
 /**
  * iwl4965_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
@@ -3122,8 +3065,9 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 			priv->mac80211_registered &&
 			agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
 			ieee80211_wake_queue(priv->hw, ampdu_q);
-		iwl4965_check_empty_hw_queue(priv, ba_resp->sta_id,
-			ba_resp->tid, scd_flow);
+
+		iwl_txq_check_empty(priv, ba_resp->sta_id,
+				    ba_resp->tid, scd_flow);
 	}
 }
 
@@ -3137,7 +3081,7 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	u32 tbl_dw;
 	u16 scd_q2ratid;
 
-	scd_q2ratid = ra_tid & IWL49_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
+	scd_q2ratid = ra_tid & IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
 
 	tbl_dw_addr = priv->scd_base_addr +
 			IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
@@ -3161,12 +3105,11 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
  * NOTE:  txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID,
  *        i.e. it must be one of the higher queues used for aggregation
  */
-static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
-				       int tx_fifo, int sta_id, int tid,
-				       u16 ssn_idx)
+static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+				  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
 {
 	unsigned long flags;
-	int rc;
+	int ret;
 	u16 ra_tid;
 
 	if (IWL_BACK_QUEUE_FIRST_ID > txq_id)
@@ -3179,10 +3122,10 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl_sta_modify_enable_tid_tx(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
+		return ret;
 	}
 
 	/* Stop this Tx queue before configuring it */
@@ -3269,137 +3212,6 @@ static int iwl4965_rx_agg_stop(struct iwl_priv *priv,
 					CMD_ASYNC);
 }
 
-/*
- * Find first available (lowest unused) Tx Queue, mark it "active".
- * Called only when finding queue for aggregation.
- * Should never return anything < 7, because they should already
- * be in use as EDCA AC (0-3), Command (4), HCCA (5, 6).
- */
-static int iwl4965_txq_ctx_activate_free(struct iwl_priv *priv)
-{
-	int txq_id;
-
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
-			return txq_id;
-	return -1;
-}
-
-static int iwl4965_tx_agg_start(struct ieee80211_hw *hw, const u8 *ra,
-				u16 tid, u16 *start_seq_num)
-{
-	struct iwl_priv *priv = hw->priv;
-	int sta_id;
-	int tx_fifo;
-	int txq_id;
-	int ssn = -1;
-	int ret = 0;
-	unsigned long flags;
-	struct iwl_tid_data *tid_data;
-	DECLARE_MAC_BUF(mac);
-
-	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
-		tx_fifo = default_tid_to_tx_fifo[tid];
-	else
-		return -EINVAL;
-
-	IWL_WARNING("%s on ra = %s tid = %d\n",
-			__func__, print_mac(mac, ra), tid);
-
-	sta_id = iwl_find_station(priv, ra);
-	if (sta_id == IWL_INVALID_STATION)
-		return -ENXIO;
-
-	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
-		IWL_ERROR("Start AGG when state is not IWL_AGG_OFF !\n");
-		return -ENXIO;
-	}
-
-	txq_id = iwl4965_txq_ctx_activate_free(priv);
-	if (txq_id == -1)
-		return -ENXIO;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	tid_data = &priv->stations[sta_id].tid[tid];
-	ssn = SEQ_TO_SN(tid_data->seq_number);
-	tid_data->agg.txq_id = txq_id;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	*start_seq_num = ssn;
-	ret = iwl4965_tx_queue_agg_enable(priv, txq_id, tx_fifo,
-					  sta_id, tid, ssn);
-	if (ret)
-		return ret;
-
-	ret = 0;
-	if (tid_data->tfds_in_queue == 0) {
-		printk(KERN_ERR "HW queue is empty\n");
-		tid_data->agg.state = IWL_AGG_ON;
-		ieee80211_start_tx_ba_cb_irqsafe(hw, ra, tid);
-	} else {
-		IWL_DEBUG_HT("HW queue is NOT empty: %d packets in HW queue\n",
-				tid_data->tfds_in_queue);
-		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
-	}
-	return ret;
-}
-
-static int iwl4965_tx_agg_stop(struct ieee80211_hw *hw, const u8 *ra, u16 tid)
-{
-	struct iwl_priv *priv = hw->priv;
-	int tx_fifo_id, txq_id, sta_id, ssn = -1;
-	struct iwl_tid_data *tid_data;
-	int ret, write_ptr, read_ptr;
-	unsigned long flags;
-	DECLARE_MAC_BUF(mac);
-
-	if (!ra) {
-		IWL_ERROR("ra = NULL\n");
-		return -EINVAL;
-	}
-
-	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
-		tx_fifo_id = default_tid_to_tx_fifo[tid];
-	else
-		return -EINVAL;
-
-	sta_id = iwl_find_station(priv, ra);
-
-	if (sta_id == IWL_INVALID_STATION)
-		return -ENXIO;
-
-	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
-		IWL_WARNING("Stopping AGG while state not IWL_AGG_ON\n");
-
-	tid_data = &priv->stations[sta_id].tid[tid];
-	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
-	txq_id = tid_data->agg.txq_id;
-	write_ptr = priv->txq[txq_id].q.write_ptr;
-	read_ptr = priv->txq[txq_id].q.read_ptr;
-
-	/* The queue is not empty */
-	if (write_ptr != read_ptr) {
-		IWL_DEBUG_HT("Stopping a non empty AGG HW QUEUE\n");
-		priv->stations[sta_id].tid[tid].agg.state =
-				IWL_EMPTYING_HW_QUEUE_DELBA;
-		return 0;
-	}
-
-	IWL_DEBUG_HT("HW queue is empty\n");
-	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl4965_tx_queue_agg_disable(priv, txq_id, ssn, tx_fifo_id);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (ret)
-		return ret;
-
-	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
-
-	return 0;
-}
-
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
 			     const u8 *addr, u16 tid, u16 *ssn)
@@ -3419,10 +3231,10 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 		return iwl4965_rx_agg_stop(priv, addr, tid);
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT("start Tx\n");
-		return iwl4965_tx_agg_start(hw, addr, tid, ssn);
+		return iwl_tx_agg_start(priv, addr, tid, ssn);
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT("stop Tx\n");
-		return iwl4965_tx_agg_stop(hw, addr, tid);
+		return iwl_tx_agg_stop(priv, addr, tid);
 	default:
 		IWL_DEBUG_HT("unknown\n");
 		return -EINVAL;
@@ -3670,7 +3482,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				else
 					ieee80211_wake_queue(priv->hw, ampdu_q);
 			}
-			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
+			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 		}
 	} else {
 #endif /* CONFIG_IWL4965_HT */
@@ -3695,7 +3507,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			(txq_id >= 0) && priv->mac80211_registered)
 			ieee80211_wake_queue(priv->hw, txq_id);
 		if (tid != MAX_TID_COUNT)
-			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
+			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 	}
 	}
 #endif /* CONFIG_IWL4965_HT */
@@ -3761,6 +3573,10 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.shared_mem_rx_idx = iwl4965_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.txq_set_sched = iwl4965_txq_set_sched,
+#ifdef CONFIG_IWL4965_HT
+	.txq_agg_enable = iwl4965_txq_agg_enable,
+	.txq_agg_disable = iwl4965_txq_agg_disable,
+#endif
 	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 217c6a9..9ef4468 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1193,7 +1193,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 				else
 					ieee80211_wake_queue(priv->hw, ampdu_q);
 			}
-			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
+			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 		}
 	} else {
 #endif /* CONFIG_IWL4965_HT */
@@ -1218,7 +1218,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 			(txq_id >= 0) && priv->mac80211_registered)
 			ieee80211_wake_queue(priv->hw, txq_id);
 		if (tid != MAX_TID_COUNT)
-			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
+			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 	}
 	}
 #endif /* CONFIG_IWL4965_HT */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1941a91..004c684 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -104,15 +104,22 @@ struct iwl_lib_ops {
 	int (*alloc_shared_mem)(struct iwl_priv *priv);
 	void (*free_shared_mem)(struct iwl_priv *priv);
 	int (*shared_mem_rx_idx)(struct iwl_priv *priv);
+	/* Handling TX */
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl_tx_queue *txq,
 					u16 byte_cnt);
 	void (*txq_inval_byte_cnt_tbl)(struct iwl_priv *priv,
 				       struct iwl_tx_queue *txq);
 	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
+#ifdef CONFIG_IWL4965_HT
+	/* aggregations */
+	int (*txq_agg_enable)(struct iwl_priv *priv, int txq_id, int tx_fifo,
+			      int sta_id, int tid, u16 ssn_idx);
+	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id, u16 ssn_idx,
+			       u8 tx_fifo);
+#endif /* CONFIG_IWL4965_HT */
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
-	/* nic Tx fifo handling */
 	/* alive notification after init uCode load */
 	void (*init_alive_start)(struct iwl_priv *priv);
 	/* alive notification */
@@ -226,6 +233,11 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
 int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+#ifdef CONFIG_IWL4965_HT
+int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn);
+int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
+int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
+#endif
 
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 15cb7ff..70d9c75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -507,9 +507,9 @@
 #define IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
 	((IWL49_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffffffc)
 
-#define IWL49_SCD_TXFIFO_POS_TID		(0)
-#define IWL49_SCD_TXFIFO_POS_RA			(4)
-#define IWL49_SCD_QUEUE_RA_TID_MAP_RATID_MSK	(0x01FF)
+#define IWL_SCD_TXFIFO_POS_TID			(0)
+#define IWL_SCD_TXFIFO_POS_RA			(4)
+#define IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK	(0x01FF)
 
 /* 5000 SCD */
 #define IWL50_SCD_QUEUE_STTS_REG_POS_TXF	(0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 224bcec..cfe6f4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -36,6 +36,32 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
+#ifdef CONFIG_IWL4965_HT
+
+static const u16 default_tid_to_tx_fifo[] = {
+	IWL_TX_FIFO_AC1,
+	IWL_TX_FIFO_AC0,
+	IWL_TX_FIFO_AC0,
+	IWL_TX_FIFO_AC1,
+	IWL_TX_FIFO_AC2,
+	IWL_TX_FIFO_AC2,
+	IWL_TX_FIFO_AC3,
+	IWL_TX_FIFO_AC3,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_AC3
+};
+
+#endif	/*CONFIG_IWL4965_HT */
+
+
+
 /**
  * iwl_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
  *
@@ -1171,6 +1197,170 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 EXPORT_SYMBOL(iwl_tx_cmd_complete);
 
 
+#ifdef CONFIG_IWL4965_HT
+/*
+ * Find first available (lowest unused) Tx Queue, mark it "active".
+ * Called only when finding queue for aggregation.
+ * Should never return anything < 7, because they should already
+ * be in use as EDCA AC (0-3), Command (4), HCCA (5, 6).
+ */
+static int iwl_txq_ctx_activate_free(struct iwl_priv *priv)
+{
+	int txq_id;
+
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
+			return txq_id;
+	return -1;
+}
+
+int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
+{
+	int sta_id;
+	int tx_fifo;
+	int txq_id;
+	int ret;
+	unsigned long flags;
+	struct iwl_tid_data *tid_data;
+	DECLARE_MAC_BUF(mac);
+
+	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
+		tx_fifo = default_tid_to_tx_fifo[tid];
+	else
+		return -EINVAL;
+
+	IWL_WARNING("%s on ra = %s tid = %d\n",
+			__func__, print_mac(mac, ra), tid);
+
+	sta_id = iwl_find_station(priv, ra);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
+
+	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
+		IWL_ERROR("Start AGG when state is not IWL_AGG_OFF !\n");
+		return -ENXIO;
+	}
+
+	txq_id = iwl_txq_ctx_activate_free(priv);
+	if (txq_id == -1)
+		return -ENXIO;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	tid_data = &priv->stations[sta_id].tid[tid];
+	*ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->agg.txq_id = txq_id;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
+						  sta_id, tid, *ssn);
+	if (ret)
+		return ret;
+
+	if (tid_data->tfds_in_queue == 0) {
+		printk(KERN_ERR "HW queue is empty\n");
+		tid_data->agg.state = IWL_AGG_ON;
+		ieee80211_start_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+	} else {
+		IWL_DEBUG_HT("HW queue is NOT empty: %d packets in HW queue\n",
+			     tid_data->tfds_in_queue);
+		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(iwl_tx_agg_start);
+
+int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
+{
+	int tx_fifo_id, txq_id, sta_id, ssn = -1;
+	struct iwl_tid_data *tid_data;
+	int ret, write_ptr, read_ptr;
+	unsigned long flags;
+	DECLARE_MAC_BUF(mac);
+
+	if (!ra) {
+		IWL_ERROR("ra = NULL\n");
+		return -EINVAL;
+	}
+
+	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
+		tx_fifo_id = default_tid_to_tx_fifo[tid];
+	else
+		return -EINVAL;
+
+	sta_id = iwl_find_station(priv, ra);
+
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
+
+	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
+		IWL_WARNING("Stopping AGG while state not IWL_AGG_ON\n");
+
+	tid_data = &priv->stations[sta_id].tid[tid];
+	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
+	txq_id = tid_data->agg.txq_id;
+	write_ptr = priv->txq[txq_id].q.write_ptr;
+	read_ptr = priv->txq[txq_id].q.read_ptr;
+
+	/* The queue is not empty */
+	if (write_ptr != read_ptr) {
+		IWL_DEBUG_HT("Stopping a non empty AGG HW QUEUE\n");
+		priv->stations[sta_id].tid[tid].agg.state =
+				IWL_EMPTYING_HW_QUEUE_DELBA;
+		return 0;
+	}
+
+	IWL_DEBUG_HT("HW queue is empty\n");
+	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
+						   tx_fifo_id);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (ret)
+		return ret;
+
+	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_tx_agg_stop);
+
+int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
+{
+	struct iwl_queue *q = &priv->txq[txq_id].q;
+	u8 *addr = priv->stations[sta_id].sta.sta.addr;
+	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
+
+	switch (priv->stations[sta_id].tid[tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_DELBA:
+		/* We are reclaiming the last packet of the */
+		/* aggregated HW queue */
+		if (txq_id  == tid_data->agg.txq_id &&
+		    q->read_ptr == q->write_ptr) {
+			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
+			int tx_fifo = default_tid_to_tx_fifo[tid];
+			IWL_DEBUG_HT("HW queue empty: continue DELBA flow\n");
+			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
+							     ssn, tx_fifo);
+			tid_data->agg.state = IWL_AGG_OFF;
+			ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, addr, tid);
+		}
+		break;
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/* We are reclaiming the last packet of the queue */
+		if (tid_data->tfds_in_queue == 0) {
+			IWL_DEBUG_HT("HW queue empty: continue ADDBA flow\n");
+			tid_data->agg.state = IWL_AGG_ON;
+			ieee80211_start_tx_ba_cb_irqsafe(priv->hw, addr, tid);
+		}
+		break;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iwl_txq_check_empty);
+#endif /* CONFIG_IWL4965_HT */
+
 #ifdef CONFIG_IWLWIF_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-- 
1.5.3.6

