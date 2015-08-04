Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbbHDU7B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/37] iwlwifi: remove command and return value from opmode RX
Date: Tue,  4 Aug 2015 23:43:02 +0300
Message-Id: <1438721007-23283-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230051_964972_5D0581A1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the previous patch series, no opmode continues using the
command or handler_status (i.e. the return value from the RX)
so it can be removed now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h       |  5 ++---
 drivers/net/wireless/iwlwifi/dvm/rx.c        |  5 +----
 drivers/net/wireless/iwlwifi/iwl-op-mode.h   | 10 ++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h     |  3 ---
 drivers/net/wireless/iwlwifi/mvm/ops.c       | 13 +++++--------
 drivers/net/wireless/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 12 +++---------
 drivers/net/wireless/iwlwifi/pcie/tx.c       |  5 +----
 8 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index f549dc3..101ef31 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -122,9 +122,8 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 void iwl_down(struct iwl_priv *priv);
 void iwl_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_prepare_restart(struct iwl_priv *priv);
-int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
-				 struct iwl_rx_cmd_buffer *rxb,
-				 struct iwl_device_cmd *cmd);
+void iwl_rx_dispatch(struct iwl_op_mode *op_mode,
+		     struct iwl_rx_cmd_buffer *rxb);
 
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index ca270a6..c91374f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -1073,8 +1073,7 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 		iwlagn_bt_rx_handler_setup(priv);
 }
 
-int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
-		    struct iwl_device_cmd *cmd)
+void iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
@@ -1098,6 +1097,4 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 			     iwl_dvm_get_cmd_string(pkt->hdr.cmd),
 			     pkt->hdr.cmd);
 	}
-
-	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index ce1cdd7..71b450a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -148,8 +148,7 @@ struct iwl_op_mode_ops {
 				     const struct iwl_fw *fw,
 				     struct dentry *dbgfs_dir);
 	void (*stop)(struct iwl_op_mode *op_mode);
-	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
-		  struct iwl_device_cmd *cmd);
+	void (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb);
 	void (*napi_add)(struct iwl_op_mode *op_mode,
 			 struct napi_struct *napi,
 			 struct net_device *napi_dev,
@@ -188,11 +187,10 @@ static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
 	op_mode->ops->stop(op_mode);
 }
 
-static inline int iwl_op_mode_rx(struct iwl_op_mode *op_mode,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *cmd)
+static inline void iwl_op_mode_rx(struct iwl_op_mode *op_mode,
+				  struct iwl_rx_cmd_buffer *rxb)
 {
-	return op_mode->ops->rx(op_mode, rxb, cmd);
+	return op_mode->ops->rx(op_mode, rxb);
 }
 
 static inline void iwl_op_mode_queue_full(struct iwl_op_mode *op_mode,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 87a230a..7b6f095 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -261,8 +261,6 @@ enum iwl_hcmd_dataflag {
  * @resp_pkt: response packet, if %CMD_WANT_SKB was set
  * @_rx_page_order: (internally used to free response packet)
  * @_rx_page_addr: (internally used to free response packet)
- * @handler_status: return value of the handler of the command
- *	(put in setup_rx_handlers) - valid for SYNC mode only
  * @flags: can be CMD_*
  * @len: array of the lengths of the chunks in data
  * @dataflags: IWL_HCMD_DFL_*
@@ -273,7 +271,6 @@ struct iwl_host_cmd {
 	struct iwl_rx_packet *resp_pkt;
 	unsigned long _rx_page_addr;
 	u32 _rx_page_order;
-	int handler_status;
 
 	u32 flags;
 	u16 len[IWL_MAX_CMD_TBS_PER_TFD];
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 00ca240..51c2fd0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -703,9 +703,8 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 	}
 }
 
-static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
-			       struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd)
+static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
+				struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
@@ -713,7 +712,7 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 
 	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD)) {
 		iwl_mvm_rx_rx_mpdu(mvm, rxb);
-		return 0;
+		return;
 	}
 
 	iwl_mvm_rx_check_trigger(mvm, pkt);
@@ -734,13 +733,13 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 
 		if (!rx_h->async) {
 			rx_h->fn(mvm, rxb);
-			return 0;
+			return;
 		}
 
 		entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 		/* we can't do much... */
 		if (!entry)
-			return 0;
+			return;
 
 		entry->rxb._page = rxb_steal_page(rxb);
 		entry->rxb._offset = rxb->_offset;
@@ -752,8 +751,6 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 		schedule_work(&mvm->async_handlers_wk);
 		break;
 	}
-
-	return 0;
 }
 
 static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 4f06407..e27d5a3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -423,7 +423,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans);
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
-			    struct iwl_rx_cmd_buffer *rxb, int handler_status);
+			    struct iwl_rx_cmd_buffer *rxb);
 void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 93062f2..32ec95b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -823,10 +823,9 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 
 	while (offset + sizeof(u32) + sizeof(struct iwl_cmd_header) < max_len) {
 		struct iwl_rx_packet *pkt;
-		struct iwl_device_cmd *cmd;
 		u16 sequence;
 		bool reclaim;
-		int index, cmd_index, err, len;
+		int index, cmd_index, len;
 		struct iwl_rx_cmd_buffer rxcb = {
 			._offset = offset,
 			._rx_page_order = trans_pcie->rx_page_order,
@@ -874,12 +873,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		index = SEQ_TO_INDEX(sequence);
 		cmd_index = get_cmd_index(&txq->q, index);
 
-		if (reclaim)
-			cmd = txq->entries[cmd_index].cmd;
-		else
-			cmd = NULL;
-
-		err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
+		iwl_op_mode_rx(trans->op_mode, &rxcb);
 
 		if (reclaim) {
 			kzfree(txq->entries[cmd_index].free_buf);
@@ -897,7 +891,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			 * iwl_trans_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (!rxcb._page_stolen)
-				iwl_pcie_hcmd_complete(trans, &rxcb, err);
+				iwl_pcie_hcmd_complete(trans, &rxcb);
 			else
 				IWL_WARN(trans, "Claim null rxb?\n");
 		}
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index d711f0b..c6572ff 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1553,15 +1553,13 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 /*
  * iwl_pcie_hcmd_complete - Pull unused buffers off the queue and reclaim them
  * @rxb: Rx buffer to reclaim
- * @handler_status: return value of the handler of the command
- *	(put in setup_rx_handlers)
  *
  * If an Rx buffer has an async callback associated with it the callback
  * will be executed.  The attached skb (if present) will only be freed
  * if the callback returns 1
  */
 void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
-			    struct iwl_rx_cmd_buffer *rxb, int handler_status)
+			    struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -1600,7 +1598,6 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 		meta->source->resp_pkt = pkt;
 		meta->source->_rx_page_addr = (unsigned long)page_address(p);
 		meta->source->_rx_page_order = trans_pcie->rx_page_order;
-		meta->source->handler_status = handler_status;
 	}
 
 	iwl_pcie_cmdq_reclaim(trans, txq_id, index);
-- 
2.1.4

