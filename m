Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52750 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757606AbdDRWRu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:09 +0300
Message-Id: <20170418221729.28372-6-luca@coelho.fi> (sfid-20170419_001802_064992_FD51DF8F)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: move to TVQM mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In TVQM firmware returns the value of the queue ID and code
should accept it.
The TX queue config API was changed. Move to new API.
This has to be done in parallel in mvm and pcie.
Do not move yet to 512 queues since there are some opens
with enabling it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h    |  38 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 124 ++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  63 +++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  70 +++++++-----
 5 files changed, 202 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index c87a58ee012a..626e2703a57f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -531,37 +531,43 @@ struct iwl_trans_txq_scd_cfg {
 	int frame_limit;
 };
 
+/* Available options for &struct iwl_tx_queue_cfg_cmd */
+enum iwl_tx_queue_cfg_actions {
+	TX_QUEUE_CFG_ENABLE_QUEUE		= BIT(0),
+	TX_QUEUE_CFG_TFD_SHORT_FORMAT		= BIT(1),
+};
+
 /**
  * struct iwl_tx_queue_cfg_cmd - txq hw scheduler config command
- * @token: token of the command
  * @sta_id: station id
  * @tid: tid of the queue
- * @scd_queue: scheduler queue to config
- * @action: 1 queue enable, 0 queue disable
- * @aggregate: 1 aggregated queue, 0 otherwise
- * @tx_fifo: TX fifo
- * @window: BA window size
- * @ssn: SSN for the BA agreement
+ * @flags: Bit 0 - on enable, off - disable, Bit 1 - short TFD format
  * @cb_size: size of TFD cyclic buffer. Value is exponent - 3.
  *	Minimum value 0 (8 TFDs), maximum value 5 (256 TFDs)
  * @byte_cnt_addr: address of byte count table
  * @tfdq_addr: address of TFD circular buffer
  */
 struct iwl_tx_queue_cfg_cmd {
-	u8 token;
 	u8 sta_id;
 	u8 tid;
-	u8 scd_queue;
-	u8 action;
-	u8 aggregate;
-	u8 tx_fifo;
-	u8 window;
-	__le16 ssn;
-	__le16 reserved;
+	__le16 flags;
 	__le32 cb_size;
 	__le64 byte_cnt_addr;
 	__le64 tfdq_addr;
-} __packed; /* TX_QUEUE_CFG_CMD_API_S_VER_1 */
+} __packed; /* TX_QUEUE_CFG_CMD_API_S_VER_2 */
+
+/**
+ * struct iwl_tx_queue_cfg_rsp - response to txq hw scheduler config
+ * @queue_number: queue number assigned to this RA -TID
+ * @flags: set on failure
+ * @write_pointer: initial value for write pointer
+ */
+struct iwl_tx_queue_cfg_rsp {
+	__le16 queue_number;
+	__le16 flags;
+	__le16 write_pointer;
+	__le16 reserved;
+} __packed; /* TX_QUEUE_CFG_RSP_API_S_VER_2 */
 
 /**
  * struct iwl_trans_ops - transport specific operations
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 70abc6cd3b47..a22fe45eecc4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1699,6 +1699,9 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
 			unsigned int wdg_timeout);
+int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
+			    u8 sta_id, u8 tid, unsigned int timeout);
+
 /*
  * Disable a TXQ.
  * Note that in non-DQA mode the %mac80211_queue and %tid params are ignored.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 20a8f529760f..a58f0cb291bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -702,6 +702,41 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	return ret;
 }
 
+static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
+					struct ieee80211_sta *sta, u8 ac,
+					int tid)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	unsigned int wdg_timeout =
+		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
+	u8 mac_queue = mvmsta->vif->hw_queue[ac];
+	int queue = -1;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Allocating queue for sta %d on tid %d\n",
+			    mvmsta->sta_id, tid);
+	queue = iwl_mvm_tvqm_enable_txq(mvm, mac_queue, mvmsta->sta_id, tid,
+					wdg_timeout);
+	if (queue < 0)
+		return queue;
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Allocated queue is %d\n", queue);
+
+	spin_lock_bh(&mvmsta->lock);
+	mvmsta->tid_data[tid].txq_id = queue;
+	mvmsta->tid_data[tid].is_tid_active = true;
+	mvmsta->tfd_queue_msk |= BIT(queue);
+	spin_unlock_bh(&mvmsta->lock);
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	return 0;
+}
+
 static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta, u8 ac, int tid,
 				   struct ieee80211_hdr *hdr)
@@ -727,6 +762,9 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return iwl_mvm_sta_alloc_queue_tvqm(mvm, sta, ac, tid);
+
 	spin_lock_bh(&mvmsta->lock);
 	tfd_queue_mask = mvmsta->tfd_queue_msk;
 	spin_unlock_bh(&mvmsta->lock);
@@ -782,15 +820,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 
 	/* No free queue - we'll have to share */
 	if (queue <= 0) {
-		/* This shouldn't happen in new HW - we have 512 queues */
-		if (WARN(iwl_mvm_has_new_tx_api(mvm),
-			 "No available queues for tid %d on sta_id %d\n",
-			 tid, cfg.sta_id)) {
-			spin_unlock_bh(&mvm->queue_info_lock);
-
-			return queue;
-		}
-
 		queue = iwl_mvm_get_shared_queue(mvm, tfd_queue_mask, ac);
 		if (queue > 0) {
 			shared_queue = true;
@@ -875,9 +904,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		mvmsta->reserved_queue = IEEE80211_INVAL_HW_QUEUE;
 	spin_unlock_bh(&mvmsta->lock);
 
-	if (iwl_mvm_has_new_tx_api(mvm))
-		return 0;
-
 	if (!shared_queue) {
 		ret = iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
 		if (ret)
@@ -1243,18 +1269,30 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 		ac = tid_to_mac80211_ac[i];
 		mac_queue = mvm_sta->vif->hw_queue[ac];
 
-		cfg.tid = i;
-		cfg.fifo = iwl_mvm_ac_to_tx_fifo[ac];
-		cfg.aggregate = (txq_id >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
-				 txq_id == IWL_MVM_DQA_BSS_CLIENT_QUEUE);
+		if (iwl_mvm_has_new_tx_api(mvm)) {
+			IWL_DEBUG_TX_QUEUES(mvm,
+					    "Re-mapping sta %d tid %d\n",
+					    mvm_sta->sta_id, i);
+			txq_id = iwl_mvm_tvqm_enable_txq(mvm, mac_queue,
+							 mvm_sta->sta_id,
+							 i, wdg_timeout);
+			tid_data->txq_id = txq_id;
+		} else {
+			u16 seq = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 
-		IWL_DEBUG_TX_QUEUES(mvm,
-				    "Re-mapping sta %d tid %d to queue %d\n",
-				    mvm_sta->sta_id, i, txq_id);
+			cfg.tid = i;
+			cfg.fifo = iwl_mvm_ac_to_tx_fifo[ac];
+			cfg.aggregate = (txq_id >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
+					 txq_id ==
+					 IWL_MVM_DQA_BSS_CLIENT_QUEUE);
 
-		iwl_mvm_enable_txq(mvm, txq_id, mac_queue,
-				   IEEE80211_SEQ_TO_SN(tid_data->seq_number),
-				   &cfg, wdg_timeout);
+			IWL_DEBUG_TX_QUEUES(mvm,
+					    "Re-mapping sta %d tid %d to queue %d\n",
+					    mvm_sta->sta_id, i, txq_id);
+
+			iwl_mvm_enable_txq(mvm, txq_id, mac_queue, seq, &cfg,
+					   wdg_timeout);
+		}
 
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_READY;
 	}
@@ -1751,7 +1789,13 @@ static void iwl_mvm_enable_aux_queue(struct iwl_mvm *mvm)
 					mvm->cfg->base_params->wd_timeout :
 					IWL_WATCHDOG_DISABLED;
 
-	if (iwl_mvm_is_dqa_supported(mvm)) {
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		int queue = iwl_mvm_tvqm_enable_txq(mvm, mvm->aux_queue,
+						    mvm->aux_sta.sta_id,
+						    IWL_MAX_TID_COUNT,
+						    wdg_timeout);
+		mvm->aux_queue = queue;
+	} else if (iwl_mvm_is_dqa_supported(mvm)) {
 		struct iwl_trans_txq_scd_cfg cfg = {
 			.fifo = IWL_MVM_TX_FIFO_MCAST,
 			.sta_id = mvm->aux_sta.sta_id,
@@ -1863,7 +1907,7 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (iwl_mvm_is_dqa_supported(mvm)) {
+	if (iwl_mvm_is_dqa_supported(mvm) && !iwl_mvm_has_new_tx_api(mvm)) {
 		if (vif->type == NL80211_IFTYPE_AP)
 			queue = mvm->probe_queue;
 		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
@@ -1873,9 +1917,8 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 		bsta->tfd_queue_msk |= BIT(queue);
 
-		if (!iwl_mvm_has_new_tx_api(mvm))
-			iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0,
-					   &cfg, wdg_timeout);
+		iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0,
+				   &cfg, wdg_timeout);
 	}
 
 	if (vif->type == NL80211_IFTYPE_ADHOC)
@@ -1893,9 +1936,18 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * For a000 firmware and on we cannot add queue to a station unknown
 	 * to firmware so enable queue here - after the station was added
 	 */
-	if (iwl_mvm_has_new_tx_api(mvm))
-		iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0, &cfg,
-				   wdg_timeout);
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		int queue = iwl_mvm_tvqm_enable_txq(mvm, vif->hw_queue[0],
+						    bsta->sta_id,
+						    IWL_MAX_TID_COUNT,
+						    wdg_timeout);
+		if (vif->type == NL80211_IFTYPE_AP)
+			mvm->probe_queue = queue;
+		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			mvm->p2p_dev_queue = queue;
+
+		bsta->tfd_queue_msk |= BIT(queue);
+	}
 
 	return 0;
 }
@@ -2058,8 +2110,16 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * This is needed for a000 firmware which won't accept SCD_QUEUE_CFG
 	 * command with unknown station id.
 	 */
-	iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0, &cfg,
-			   timeout);
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		int queue = iwl_mvm_tvqm_enable_txq(mvm, vif->cab_queue,
+						    msta->sta_id,
+						    IWL_MAX_TID_COUNT,
+						    timeout);
+		vif->cab_queue = queue;
+	} else {
+		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
+				   &cfg, timeout);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 70ec048ac152..1dde05697c29 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -695,14 +695,47 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 	return enable_queue;
 }
 
+int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
+			    u8 sta_id, u8 tid, unsigned int timeout)
+{
+	struct iwl_tx_queue_cfg_cmd cmd = {
+		.flags = cpu_to_le16(TX_QUEUE_CFG_ENABLE_QUEUE),
+		.sta_id = sta_id,
+		.tid = tid,
+	};
+	int queue;
+
+	if (cmd.tid == IWL_MAX_TID_COUNT)
+		cmd.tid = IWL_MGMT_TID;
+	queue = iwl_trans_txq_alloc(mvm->trans, (void *)&cmd,
+				    SCD_QUEUE_CFG, timeout);
+
+	if (queue < 0) {
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "Failed allocating TXQ for sta %d tid %d, ret: %d\n",
+				    sta_id, tid, queue);
+		return queue;
+	}
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Enabling TXQ #%d for sta %d tid %d\n",
+			    queue, sta_id, tid);
+
+	iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue, sta_id, tid);
+
+	return queue;
+}
+
 void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
 			unsigned int wdg_timeout)
 {
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	/* Send the enabling command if we need to */
 	if (iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue,
 				       cfg->sta_id, cfg->tid)) {
-		struct iwl_tx_queue_cfg_cmd cmd = {
+		struct iwl_scd_txq_cfg_cmd cmd = {
 			.scd_queue = queue,
 			.action = SCD_CFG_ENABLE_QUEUE,
 			.window = cfg->frame_limit,
@@ -713,14 +746,6 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			.tid = cfg->tid,
 		};
 
-		if (iwl_mvm_has_new_tx_api(mvm)) {
-			if (cmd.tid == IWL_MAX_TID_COUNT)
-				cmd.tid = IWL_MGMT_TID;
-			iwl_trans_txq_alloc(mvm->trans, (void *)&cmd,
-					    SCD_QUEUE_CFG, wdg_timeout);
-			return;
-		}
-
 		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL,
 					 wdg_timeout);
 		WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0,
@@ -734,12 +759,11 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			u8 tid, u8 flags)
 {
-	struct iwl_tx_queue_cfg_cmd cmd = {
+	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
 	};
 	bool remove_mac_queue = true;
-	int ret;
 
 	spin_lock_bh(&mvm->queue_info_lock);
 
@@ -812,22 +836,21 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		iwl_trans_txq_free(mvm->trans, queue);
-		if (cmd.tid == IWL_MAX_TID_COUNT)
-			cmd.tid = IWL_MGMT_TID;
-		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
-					   sizeof(cmd), &cmd);
 	} else {
+		int ret;
+
 		iwl_trans_txq_disable(mvm->trans, queue, false);
 		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
 					   sizeof(struct iwl_scd_txq_cfg_cmd),
 					   &cmd);
-	}
 
-	if (ret)
-		IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
-			queue, ret);
+		if (ret)
+			IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
+				queue, ret);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 0bc9522cf364..9fb46a6f47cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -862,15 +862,15 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 				 unsigned int timeout)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue_cfg_rsp *rsp;
 	struct iwl_txq *txq;
 	struct iwl_host_cmd hcmd = {
 		.id = cmd_id,
 		.len = { sizeof(*cmd) },
 		.data = { cmd, },
-		.flags = 0,
+		.flags = CMD_WANT_SKB,
 	};
-	int ret, qid = cmd->scd_queue;
-	u16 ssn = le16_to_cpu(cmd->ssn);
+	int ret, qid;
 
 	txq = kzalloc(sizeof(*txq), GFP_KERNEL);
 	if (!txq)
@@ -883,48 +883,62 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 		return -ENOMEM;
 	}
 
-	if (test_and_set_bit(cmd->scd_queue, trans_pcie->queue_used)) {
-		WARN_ONCE(1, "queue %d already used", cmd->scd_queue);
-		return -EINVAL;
-	}
-
-	trans_pcie->txq[qid] = txq;
-	trans_pcie->txq[qid]->id = qid;
-
 	ret = iwl_pcie_txq_alloc(trans, txq, TFD_TX_CMD_SLOTS, false);
 	if (ret) {
-		IWL_ERR(trans, "Tx %d queue init failed\n", qid);
+		IWL_ERR(trans, "Tx queue alloc failed\n");
 		goto error;
 	}
 	ret = iwl_pcie_txq_init(trans, txq, TFD_TX_CMD_SLOTS, false);
 	if (ret) {
-		IWL_ERR(trans, "Tx %d queue alloc failed\n", qid);
+		IWL_ERR(trans, "Tx queue init failed\n");
 		goto error;
 	}
 
 	txq->wd_timeout = msecs_to_jiffies(timeout);
 
-	/*
-	 * Place first TFD at index corresponding to start sequence number.
-	 * Assumes that ssn_idx is valid (!= 0xFFF)
-	 */
-	txq->read_ptr = (ssn & 0xff);
-	txq->write_ptr = (ssn & 0xff);
-	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-			   (ssn & 0xff) | (cmd->scd_queue << 16));
-
-	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d WrPtr: %d\n",
-			    cmd->scd_queue, ssn & 0xff);
-
 	cmd->tfdq_addr = cpu_to_le64(txq->dma_addr);
 	cmd->byte_cnt_addr = cpu_to_le64(txq->bc_tbl.dma);
 	cmd->cb_size = cpu_to_le32(TFD_QUEUE_CB_SIZE(TFD_QUEUE_SIZE_MAX));
 
-	return iwl_trans_send_cmd(trans, &hcmd);
+	ret = iwl_trans_send_cmd(trans, &hcmd);
+	if (ret)
+		goto error;
+
+	if (WARN_ON(iwl_rx_packet_payload_len(hcmd.resp_pkt) != sizeof(*rsp))) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	rsp = (void *)hcmd.resp_pkt->data;
+	qid = le16_to_cpu(rsp->queue_number);
+
+	if (qid > ARRAY_SIZE(trans_pcie->txq)) {
+		WARN_ONCE(1, "queue index %d unsupported", qid);
+		ret = -EIO;
+		goto error;
+	}
+
+	if (test_and_set_bit(qid, trans_pcie->queue_used)) {
+		WARN_ONCE(1, "queue %d already used", qid);
+		ret = -EIO;
+		goto error;
+	}
+
+	txq->id = qid;
+	trans_pcie->txq[qid] = txq;
+
+	/* Place first TFD at index corresponding to start sequence number */
+	txq->read_ptr = le16_to_cpu(rsp->write_pointer);
+	txq->write_ptr = le16_to_cpu(rsp->write_pointer);
+	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
+			   (txq->write_ptr) | (qid << 16));
+	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d\n", qid);
+
+	return qid;
 
 error:
-	iwl_pcie_gen2_txq_free(trans, cmd->scd_queue);
-	return -ENOMEM;
+	iwl_pcie_gen2_txq_free_memory(trans, txq);
+	return ret;
 }
 
 void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue)
-- 
2.11.0
