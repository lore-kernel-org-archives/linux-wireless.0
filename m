Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43950 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOEz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:16 +0300
Message-Id: <20180824103018.15011-15-luca@coelho.fi> (sfid-20180824_123106_313021_675D8DA7)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 14/16] iwlwifi: refactor txq_alloc for supporting more command type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Support more txq_alloc command types by moving the command declaration
to the gen specific area.  While at it, move some of the code segments
to a common place for re-use.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  7 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 14 +--
 .../wireless/intel/iwlwifi/pcie/internal.h    | 10 +-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 91 +++++++++++++------
 4 files changed, 82 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0a6c8759b911..388793b89856 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -562,7 +562,7 @@ struct iwl_trans_ops {
 			    bool configure_scd);
 	/* 22000 functions */
 	int (*txq_alloc)(struct iwl_trans *trans,
-			 struct iwl_tx_queue_cfg_cmd *cmd,
+			 __le16 flags, u8 sta_id, u8 tid,
 			 int cmd_id, int size,
 			 unsigned int queue_wdg_timeout);
 	void (*txq_free)(struct iwl_trans *trans, int queue);
@@ -970,7 +970,7 @@ iwl_trans_txq_free(struct iwl_trans *trans, int queue)
 
 static inline int
 iwl_trans_txq_alloc(struct iwl_trans *trans,
-		    struct iwl_tx_queue_cfg_cmd *cmd,
+		    __le16 flags, u8 sta_id, u8 tid,
 		    int cmd_id, int size,
 		    unsigned int wdg_timeout)
 {
@@ -984,7 +984,8 @@ iwl_trans_txq_alloc(struct iwl_trans *trans,
 		return -EIO;
 	}
 
-	return trans->ops->txq_alloc(trans, cmd, cmd_id, size, wdg_timeout);
+	return trans->ops->txq_alloc(trans, flags, sta_id, tid,
+				     cmd_id, size, wdg_timeout);
 }
 
 static inline void iwl_trans_txq_set_shared_mode(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index f5a9e4026094..99a872769e90 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -720,19 +720,15 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
 			    u8 sta_id, u8 tid, unsigned int timeout)
 {
-	struct iwl_tx_queue_cfg_cmd cmd = {
-		.flags = cpu_to_le16(TX_QUEUE_CFG_ENABLE_QUEUE),
-		.sta_id = sta_id,
-		.tid = tid,
-	};
 	int queue, size = IWL_DEFAULT_QUEUE_SIZE;
 
-	if (cmd.tid == IWL_MAX_TID_COUNT) {
-		cmd.tid = IWL_MGMT_TID;
+	if (tid == IWL_MAX_TID_COUNT) {
+		tid = IWL_MGMT_TID;
 		size = IWL_MGMT_QUEUE_SIZE;
 	}
-	queue = iwl_trans_txq_alloc(mvm->trans, (void *)&cmd,
-				    SCD_QUEUE_CFG, size, timeout);
+	queue = iwl_trans_txq_alloc(mvm->trans,
+				    cpu_to_le16(TX_QUEUE_CFG_ENABLE_QUEUE),
+				    sta_id, tid, SCD_QUEUE_CFG, size, timeout);
 
 	if (queue < 0) {
 		IWL_DEBUG_TX_QUEUES(mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 98d8da03ccfc..769b7354fabe 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1036,8 +1036,16 @@ void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power);
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 				 const struct fw_img *fw, bool run_in_rfkill);
 void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans, u32 scd_addr);
+void iwl_pcie_gen2_txq_free_memory(struct iwl_trans *trans,
+				   struct iwl_txq *txq);
+int iwl_trans_pcie_dyn_txq_alloc_dma(struct iwl_trans *trans,
+				     struct iwl_txq **intxq, int size,
+				     unsigned int timeout);
+int iwl_trans_pcie_txq_alloc_response(struct iwl_trans *trans,
+				      struct iwl_txq *txq,
+				      struct iwl_host_cmd *hcmd);
 int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
-				 struct iwl_tx_queue_cfg_cmd *cmd,
+				 __le16 flags, u8 sta_id, u8 tid,
 				 int cmd_id, int size,
 				 unsigned int timeout);
 void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 4a08f4eab1a5..a33fb335849e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1065,8 +1065,8 @@ void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id)
 	iwl_wake_queue(trans, txq);
 }
 
-static void iwl_pcie_gen2_txq_free_memory(struct iwl_trans *trans,
-					  struct iwl_txq *txq)
+void iwl_pcie_gen2_txq_free_memory(struct iwl_trans *trans,
+				   struct iwl_txq *txq)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct device *dev = trans->dev;
@@ -1120,23 +1120,13 @@ static void iwl_pcie_gen2_txq_free(struct iwl_trans *trans, int txq_id)
 	clear_bit(txq_id, trans_pcie->queue_used);
 }
 
-int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
-				 struct iwl_tx_queue_cfg_cmd *cmd,
-				 int cmd_id, int size,
-				 unsigned int timeout)
+int iwl_trans_pcie_dyn_txq_alloc_dma(struct iwl_trans *trans,
+				     struct iwl_txq **intxq, int size,
+				     unsigned int timeout)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue_cfg_rsp *rsp;
-	struct iwl_txq *txq;
-	struct iwl_host_cmd hcmd = {
-		.id = cmd_id,
-		.len = { sizeof(*cmd) },
-		.data = { cmd, },
-		.flags = CMD_WANT_SKB,
-	};
-	int ret, qid;
-	u32 wr_ptr;
+	int ret;
 
+	struct iwl_txq *txq;
 	txq = kzalloc(sizeof(*txq), GFP_KERNEL);
 	if (!txq)
 		return -ENOMEM;
@@ -1164,20 +1154,30 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 
 	txq->wd_timeout = msecs_to_jiffies(timeout);
 
-	cmd->tfdq_addr = cpu_to_le64(txq->dma_addr);
-	cmd->byte_cnt_addr = cpu_to_le64(txq->bc_tbl.dma);
-	cmd->cb_size = cpu_to_le32(TFD_QUEUE_CB_SIZE(size));
+	*intxq = txq;
+	return 0;
 
-	ret = iwl_trans_send_cmd(trans, &hcmd);
-	if (ret)
-		goto error;
+error:
+	iwl_pcie_gen2_txq_free_memory(trans, txq);
+	return ret;
+}
+
+int iwl_trans_pcie_txq_alloc_response(struct iwl_trans *trans,
+				      struct iwl_txq *txq,
+				      struct iwl_host_cmd *hcmd)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue_cfg_rsp *rsp;
+	int ret, qid;
+	u32 wr_ptr;
 
-	if (WARN_ON(iwl_rx_packet_payload_len(hcmd.resp_pkt) != sizeof(*rsp))) {
+	if (WARN_ON(iwl_rx_packet_payload_len(hcmd->resp_pkt) !=
+		    sizeof(*rsp))) {
 		ret = -EINVAL;
 		goto error_free_resp;
 	}
 
-	rsp = (void *)hcmd.resp_pkt->data;
+	rsp = (void *)hcmd->resp_pkt->data;
 	qid = le16_to_cpu(rsp->queue_number);
 	wr_ptr = le16_to_cpu(rsp->write_pointer);
 
@@ -1204,11 +1204,48 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 			   (txq->write_ptr) | (qid << 16));
 	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d\n", qid);
 
-	iwl_free_resp(&hcmd);
+	iwl_free_resp(hcmd);
 	return qid;
 
 error_free_resp:
-	iwl_free_resp(&hcmd);
+	iwl_free_resp(hcmd);
+	iwl_pcie_gen2_txq_free_memory(trans, txq);
+	return ret;
+}
+
+int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
+				 __le16 flags, u8 sta_id, u8 tid,
+				 int cmd_id, int size,
+				 unsigned int timeout)
+{
+	struct iwl_txq *txq = NULL;
+	struct iwl_tx_queue_cfg_cmd cmd = {
+		.flags = flags,
+		.sta_id = sta_id,
+		.tid = tid,
+	};
+	struct iwl_host_cmd hcmd = {
+		.id = cmd_id,
+		.len = { sizeof(cmd) },
+		.data = { &cmd, },
+		.flags = CMD_WANT_SKB,
+	};
+	int ret;
+
+	ret = iwl_trans_pcie_dyn_txq_alloc_dma(trans, &txq, size, timeout);
+	if (ret)
+		return ret;
+
+	cmd.tfdq_addr = cpu_to_le64(txq->dma_addr);
+	cmd.byte_cnt_addr = cpu_to_le64(txq->bc_tbl.dma);
+	cmd.cb_size = cpu_to_le32(TFD_QUEUE_CB_SIZE(size));
+
+	ret = iwl_trans_send_cmd(trans, &hcmd);
+	if (ret)
+		goto error;
+
+	return iwl_trans_pcie_txq_alloc_response(trans, txq, &hcmd);
+
 error:
 	iwl_pcie_gen2_txq_free_memory(trans, txq);
 	return ret;
-- 
2.18.0
