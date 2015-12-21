Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbbLUUvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/45] iwlwifi: trans: support a callback for ASYNC commands
Date: Mon, 21 Dec 2015 22:50:13 +0200
Message-Id: <1450731046-2796-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215128_390724_6BE7FDDF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the op_mode to request from the transport to
call a callback when an ASYNC commands is completed by
the firmware. The same callback will be called for all the
commands. Pass the command whose response triggers the
callback as a parameter to the callback itself.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h | 11 +++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h   |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c     |  7 +++----
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
index 2a58d68..ffff31c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
@@ -123,6 +123,8 @@ struct iwl_cfg;
  *	received on the RSS queue(s). The queue parameter indicates which of the
  *	RSS queues received this frame; it will always be non-zero.
  *	This method must not sleep.
+ * @async_cb: called when an ASYNC command with CMD_WANT_ASYNC_CALLBACK set
+ *	completes. Must be atomic.
  * @queue_full: notifies that a HW queue is full.
  *	Must be atomic and called with BH disabled.
  * @queue_not_full: notifies that a HW queue is not full any more.
@@ -155,6 +157,8 @@ struct iwl_op_mode_ops {
 		   struct iwl_rx_cmd_buffer *rxb);
 	void (*rx_rss)(struct iwl_op_mode *op_mode, struct napi_struct *napi,
 		       struct iwl_rx_cmd_buffer *rxb, unsigned int queue);
+	void (*async_cb)(struct iwl_op_mode *op_mode,
+			 const struct iwl_device_cmd *cmd);
 	void (*queue_full)(struct iwl_op_mode *op_mode, int queue);
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, int queue);
 	bool (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
@@ -203,6 +207,13 @@ static inline void iwl_op_mode_rx_rss(struct iwl_op_mode *op_mode,
 	op_mode->ops->rx_rss(op_mode, napi, rxb, queue);
 }
 
+static inline void iwl_op_mode_async_cb(struct iwl_op_mode *op_mode,
+					const struct iwl_device_cmd *cmd)
+{
+	if (op_mode->ops->async_cb)
+		op_mode->ops->async_cb(op_mode, cmd);
+}
+
 static inline void iwl_op_mode_queue_full(struct iwl_op_mode *op_mode,
 					  int queue)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0cd69cd..77ae7fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -248,6 +248,8 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
  * @CMD_MAKE_TRANS_IDLE: The command response should mark the trans as idle.
  * @CMD_WAKE_UP_TRANS: The command response should wake up the trans
  *	(i.e. mark it as non-idle).
+ * @CMD_WANT_ASYNC_CALLBACK: the op_mode's async callback function must be
+ *	called after this command completes. Valid only with CMD_ASYNC.
  * @CMD_TB_BITMAP_POS: Position of the first bit for the TB bitmap. We need to
  *	check that we leave enough room for the TBs bitmap which needs 20 bits.
  */
@@ -259,6 +261,7 @@ enum CMD_MODE {
 	CMD_SEND_IN_IDLE	= BIT(4),
 	CMD_MAKE_TRANS_IDLE	= BIT(5),
 	CMD_WAKE_UP_TRANS	= BIT(6),
+	CMD_WANT_ASYNC_CALLBACK	= BIT(7),
 
 	CMD_TB_BITMAP_POS	= 11,
 };
@@ -903,6 +906,10 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 		return -EIO;
 	}
 
+	if (WARN_ON((cmd->flags & CMD_WANT_ASYNC_CALLBACK) &&
+		    !(cmd->flags & CMD_ASYNC)))
+		return -EINVAL;
+
 	if (!(cmd->flags & CMD_ASYNC))
 		lock_map_acquire_read(&trans->sync_cmd_lockdep_map);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 95ba920..fe8241f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1593,10 +1593,6 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 /*
  * iwl_pcie_hcmd_complete - Pull unused buffers off the queue and reclaim them
  * @rxb: Rx buffer to reclaim
- *
- * If an Rx buffer has an async callback associated with it the callback
- * will be executed.  The attached skb (if present) will only be freed
- * if the callback returns 1
  */
 void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 			    struct iwl_rx_cmd_buffer *rxb)
@@ -1640,6 +1636,9 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 		meta->source->_rx_page_order = trans_pcie->rx_page_order;
 	}
 
+	if (meta->flags & CMD_WANT_ASYNC_CALLBACK)
+		iwl_op_mode_async_cb(trans->op_mode, cmd);
+
 	iwl_pcie_cmdq_reclaim(trans, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
-- 
2.5.0

