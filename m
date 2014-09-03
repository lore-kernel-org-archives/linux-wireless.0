Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:47214 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:07 -0400
Received: by mail-we0-f172.google.com with SMTP id q59so9134150wes.17
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/36] iwlwifi: trans: allow skipping scheduler hardware config
Date: Wed,  3 Sep 2014 22:56:13 +0300
Message-Id: <1409774184-24665-25-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_044272_A0A3B1B8)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In a later patch, the hardware configuration will be moved to
firmware. Prepare for this by allowing hardware configuration
in the transport to be skipped by not passing a configuration
on enable and passing configure_scd=false on disable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c        |  6 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 47 +++++++++----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c  |  8 ++-
 drivers/net/wireless/iwlwifi/mvm/sta.c       |  4 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c        |  2 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h |  3 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 99 ++++++++++++++++------------
 7 files changed, 104 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 3255a17..d1ce3ce 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -580,7 +580,7 @@ turn_off:
 		 * time, or we hadn't time to drain the AC queues.
 		 */
 		if (agg_state == IWL_AGG_ON)
-			iwl_trans_txq_disable(priv->trans, txq_id);
+			iwl_trans_txq_disable(priv->trans, txq_id, true);
 		else
 			IWL_DEBUG_TX_QUEUES(priv, "Don't disable tx agg: %d\n",
 					    agg_state);
@@ -686,7 +686,7 @@ int iwlagn_tx_agg_flush(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		 * time, or we hadn't time to drain the AC queues.
 		 */
 		if (agg_state == IWL_AGG_ON)
-			iwl_trans_txq_disable(priv->trans, txq_id);
+			iwl_trans_txq_disable(priv->trans, txq_id, true);
 		else
 			IWL_DEBUG_TX_QUEUES(priv, "Don't disable tx agg: %d\n",
 					    agg_state);
@@ -781,7 +781,7 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 				"Can continue DELBA flow ssn = next_recl = %d\n",
 				tid_data->next_reclaimed);
 			iwl_trans_txq_disable(priv->trans,
-					      tid_data->agg.txq_id);
+					      tid_data->agg.txq_id, true);
 			iwlagn_dealloc_agg_txq(priv, tid_data->agg.txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c198dde..dd3aefc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -444,7 +444,9 @@ struct iwl_trans_txq_scd_cfg {
  *	Must be atomic
  * @txq_enable: setup a queue. To setup an AC queue, use the
  *	iwl_trans_ac_txq_enable wrapper. fw_alive must have been called before
- *	this one. The op_mode must not configure the HCMD queue. May sleep.
+ *	this one. The op_mode must not configure the HCMD queue. The scheduler
+ *	configuration may be %NULL, in which case the hardware will not be
+ *	configured. May sleep.
  * @txq_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
  * @wait_tx_queue_empty: wait until tx queues are empty. May sleep.
@@ -501,7 +503,8 @@ struct iwl_trans_ops {
 
 	void (*txq_enable)(struct iwl_trans *trans, int queue, u16 ssn,
 			   const struct iwl_trans_txq_scd_cfg *cfg);
-	void (*txq_disable)(struct iwl_trans *trans, int queue);
+	void (*txq_disable)(struct iwl_trans *trans, int queue,
+			    bool configure_scd);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
@@ -773,9 +776,22 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 	trans->ops->reclaim(trans, queue, ssn, skbs);
 }
 
-static inline void iwl_trans_txq_disable(struct iwl_trans *trans, int queue)
+static inline void iwl_trans_txq_disable(struct iwl_trans *trans, int queue,
+					 bool configure_scd)
 {
-	trans->ops->txq_disable(trans, queue);
+	trans->ops->txq_disable(trans, queue, configure_scd);
+}
+
+static inline void
+iwl_trans_txq_enable_cfg(struct iwl_trans *trans, int queue, u16 ssn,
+			 const struct iwl_trans_txq_scd_cfg *cfg)
+{
+	might_sleep();
+
+	if (unlikely((trans->state != IWL_TRANS_FW_ALIVE)))
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+
+	trans->ops->txq_enable(trans, queue, ssn, cfg);
 }
 
 static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
@@ -789,19 +805,26 @@ static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 		.frame_limit = frame_limit,
 	};
 
-	might_sleep();
-
-	if (unlikely((trans->state != IWL_TRANS_FW_ALIVE)))
-		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
-
-	trans->ops->txq_enable(trans, queue, ssn, &cfg);
+	iwl_trans_txq_enable_cfg(trans, queue, ssn, &cfg);
 }
 
 static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
 					   int fifo)
 {
-	iwl_trans_txq_enable(trans, queue, fifo, -1,
-			     IWL_MAX_TID_COUNT, IWL_FRAME_LIMIT, 0);
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = fifo,
+		.sta_id = -1,
+		.tid = IWL_MAX_TID_COUNT,
+		.frame_limit = IWL_FRAME_LIMIT,
+	};
+
+	iwl_trans_txq_enable_cfg(trans, queue, 0, &cfg);
+}
+
+static inline void
+iwl_trans_txq_enable_no_scd(struct iwl_trans *trans, int queue, u16 ssn)
+{
+	iwl_trans_txq_enable_cfg(trans, queue, ssn, NULL);
 }
 
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 0e523e2..0816204 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -452,14 +452,16 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		iwl_trans_txq_disable(mvm->trans, IWL_MVM_OFFCHANNEL_QUEUE);
+		iwl_trans_txq_disable(mvm->trans, IWL_MVM_OFFCHANNEL_QUEUE,
+				      true);
 		break;
 	case NL80211_IFTYPE_AP:
-		iwl_trans_txq_disable(mvm->trans, vif->cab_queue);
+		iwl_trans_txq_disable(mvm->trans, vif->cab_queue, true);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			iwl_trans_txq_disable(mvm->trans, vif->hw_queue[ac]);
+			iwl_trans_txq_disable(mvm->trans, vif->hw_queue[ac],
+					      true);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 7635488..863a536 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -910,7 +910,7 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		}
 
 		tid_data->ssn = 0xffff;
-		iwl_trans_txq_disable(mvm->trans, txq_id);
+		iwl_trans_txq_disable(mvm->trans, txq_id, true);
 		/* fall through */
 	case IWL_AGG_STARTING:
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -965,7 +965,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
 			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
 
-		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id);
+		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id, true);
 	}
 
 	mvm->queue_to_mac80211[tid_data->txq_id] =
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index dbc8707..748b169 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -482,7 +482,7 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Can continue DELBA flow ssn = next_recl = %d\n",
 				    tid_data->next_reclaimed);
-		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id);
+		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id, true);
 		tid_data->state = IWL_AGG_OFF;
 		/*
 		 * we can't hold the mutex - but since we are after a sequence
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 5760405..163aac5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -366,7 +366,8 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans);
 void iwl_pcie_tx_free(struct iwl_trans *trans);
 void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int queue, u16 ssn,
 			       const struct iwl_trans_txq_scd_cfg *cfg);
-void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue);
+void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue,
+				bool configure_scd);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id);
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 5c95386..eb39e58 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1070,37 +1070,41 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			       const struct iwl_trans_txq_scd_cfg *cfg)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u8 frame_limit = cfg->frame_limit;
+	int fifo = -1;
 
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
-	/* Stop this Tx queue before configuring it */
-	iwl_scd_txq_set_inactive(trans, txq_id);
+	if (cfg) {
+		fifo = cfg->fifo;
 
-	/* Set this queue as a chain-building queue unless it is CMD queue */
-	if (txq_id != trans_pcie->cmd_queue)
-		iwl_scd_txq_set_chain(trans, txq_id);
+		/* Stop this Tx queue before configuring it */
+		iwl_scd_txq_set_inactive(trans, txq_id);
 
-	/* If this queue is mapped to a certain station: it is an AGG queue */
-	if (cfg->sta_id >= 0) {
-		u16 ra_tid = BUILD_RAxTID(cfg->sta_id, cfg->tid);
+		/* Set this queue as a chain-building queue unless it is CMD */
+		if (txq_id != trans_pcie->cmd_queue)
+			iwl_scd_txq_set_chain(trans, txq_id);
 
-		/* Map receiver-address / traffic-ID to this queue */
-		iwl_pcie_txq_set_ratid_map(trans, ra_tid, txq_id);
+		/* If this queue is mapped to a certain station: it is an AGG */
+		if (cfg->sta_id >= 0) {
+			u16 ra_tid = BUILD_RAxTID(cfg->sta_id, cfg->tid);
 
-		/* enable aggregations for the queue */
-		iwl_scd_txq_enable_agg(trans, txq_id);
-		trans_pcie->txq[txq_id].ampdu = true;
-	} else {
-		/*
-		 * disable aggregations for the queue, this will also make the
-		 * ra_tid mapping configuration irrelevant since it is now a
-		 * non-AGG queue.
-		 */
-		iwl_scd_txq_disable_agg(trans, txq_id);
+			/* Map receiver-address / traffic-ID to this queue */
+			iwl_pcie_txq_set_ratid_map(trans, ra_tid, txq_id);
+
+			/* enable aggregations for the queue */
+			iwl_scd_txq_enable_agg(trans, txq_id);
+			trans_pcie->txq[txq_id].ampdu = true;
+		} else {
+			/*
+			 * disable aggregations for the queue, this will also
+			 * make the ra_tid mapping configuration irrelevant
+			 * since it is now a non-AGG queue.
+			 */
+			iwl_scd_txq_disable_agg(trans, txq_id);
 
-		ssn = trans_pcie->txq[txq_id].q.read_ptr;
+			ssn = trans_pcie->txq[txq_id].q.read_ptr;
+		}
 	}
 
 	/* Place first TFD at index corresponding to start sequence number.
@@ -1108,32 +1112,39 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 	trans_pcie->txq[txq_id].q.read_ptr = (ssn & 0xff);
 	trans_pcie->txq[txq_id].q.write_ptr = (ssn & 0xff);
 
-	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-			   (ssn & 0xff) | (txq_id << 8));
-	iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), ssn);
+	if (cfg) {
+		u8 frame_limit = cfg->frame_limit;
+
+		iwl_write_direct32(trans, HBUS_TARG_WRPTR,
+				   (ssn & 0xff) | (txq_id << 8));
+		iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), ssn);
 
-	/* Set up Tx window size and frame limit for this queue */
-	iwl_trans_write_mem32(trans, trans_pcie->scd_base_addr +
-			SCD_CONTEXT_QUEUE_OFFSET(txq_id), 0);
-	iwl_trans_write_mem32(trans, trans_pcie->scd_base_addr +
+		/* Set up Tx window size and frame limit for this queue */
+		iwl_trans_write_mem32(trans, trans_pcie->scd_base_addr +
+				SCD_CONTEXT_QUEUE_OFFSET(txq_id), 0);
+		iwl_trans_write_mem32(trans,
+			trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
 			((frame_limit << SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+					SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
 			((frame_limit << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-
-	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
-	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
-		       (1 << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-		       (cfg->fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
-		       (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
-		       SCD_QUEUE_STTS_REG_MSK);
+					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+
+		/* Set up status area in SRAM, map to Tx DMA/FIFO, activate */
+		iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
+			       (1 << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			       (cfg->fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
+			       (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
+			       SCD_QUEUE_STTS_REG_MSK);
+	}
+
 	trans_pcie->txq[txq_id].active = true;
 	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d on FIFO %d WrPtr: %d\n",
-			    txq_id, cfg->fifo, ssn & 0xff);
+			    txq_id, fifo, ssn & 0xff);
 }
 
-void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
+void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
+				bool configure_scd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 stts_addr = trans_pcie->scd_base_addr +
@@ -1152,10 +1163,12 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 		return;
 	}
 
-	iwl_scd_txq_set_inactive(trans, txq_id);
+	if (configure_scd) {
+		iwl_scd_txq_set_inactive(trans, txq_id);
 
-	iwl_trans_write_mem(trans, stts_addr, (void *)zero_val,
-			    ARRAY_SIZE(zero_val));
+		iwl_trans_write_mem(trans, stts_addr, (void *)zero_val,
+				    ARRAY_SIZE(zero_val));
+	}
 
 	iwl_pcie_txq_unmap(trans, txq_id);
 	trans_pcie->txq[txq_id].ampdu = false;
-- 
1.9.1

