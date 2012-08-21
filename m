Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab2HURCK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/8] iwlwifi: get the correct HCMD in the response handler
Date: Tue, 21 Aug 2012 19:01:53 +0200
Message-Id: <1345568516-20822-5-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190225_642841_5804964A)
In-Reply-To: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
 <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Until now, the response handler of a Host Command got the
exact same pointer that was also given to the DMA engine.
We almost never need to the Host Command that was sent while
handling its response, but when we do need it, we see that
the command has been modified.

This mystery has been elucidated. The FH (our DMA engine)
writes its meta data on the buffer in the DRAM. Of course it
copies the buffer to the NIC first. This was known to happen
for Tx command, but as a matter of fact, it happens to all
TFD brought by the FH which doesn't care much about what it
brings from DRAM to internal SRAM.

So copy the Host Command to yet another buffer so that we
can properly pass the buffer that was sent originally to the
fw. Do that only if it was request by the user since very
few flows need to get the HCMD sent in the response handler.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   10 ++++++++--
 drivers/net/wireless/iwlwifi/pcie/internal.h |    1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   16 +++++++++++++---
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    5 +++--
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   26 +++++++++++++++++++++-----
 6 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index b29b798..fe36a38 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -150,7 +150,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		       sta_id, sta->sta.addr, flags & CMD_ASYNC ?  "a" : "");
 
 	if (!(flags & CMD_ASYNC)) {
-		cmd.flags |= CMD_WANT_SKB;
+		cmd.flags |= CMD_WANT_SKB | CMD_WANT_HCMD;
 		might_sleep();
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8ac72a6..ff11542 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -184,14 +184,20 @@ struct iwl_rx_packet {
  * @CMD_SYNC: The caller will be stalled until the fw responds to the command
  * @CMD_ASYNC: Return right away and don't want for the response
  * @CMD_WANT_SKB: valid only with CMD_SYNC. The caller needs the buffer of the
- *	response.
+ *	response. The caller needs to call iwl_free_resp when done.
+ * @CMD_WANT_HCMD: The caller needs to get the HCMD that was sent in the
+ *	response handler. Chunks flagged by %IWL_HCMD_DFL_NOCOPY won't be
+ *	copied. The pointer passed to the response handler is in the transport
+ *	ownership and don't need to be freed by the op_mode. This also means
+ *	that the pointer is invalidated after the op_mode's handler returns.
  * @CMD_ON_DEMAND: This command is sent by the test mode pipe.
  */
 enum CMD_MODE {
 	CMD_SYNC = 0,
 	CMD_ASYNC = BIT(0),
 	CMD_WANT_SKB = BIT(1),
-	CMD_ON_DEMAND = BIT(2),
+	CMD_WANT_HCMD = BIT(2),
+	CMD_ON_DEMAND = BIT(3),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index d9694c5..3ef8d5a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -184,6 +184,7 @@ struct iwl_queue {
 
 struct iwl_pcie_tx_queue_entry {
 	struct iwl_device_cmd *cmd;
+	struct iwl_device_cmd *copy_cmd;
 	struct sk_buff *skb;
 	struct iwl_cmd_meta meta;
 };
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 39a6ca1..d80604a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -421,13 +421,23 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 		index = SEQ_TO_INDEX(sequence);
 		cmd_index = get_cmd_index(&txq->q, index);
 
-		if (reclaim)
-			cmd = txq->entries[cmd_index].cmd;
-		else
+		if (reclaim) {
+			struct iwl_pcie_tx_queue_entry *ent;
+			ent = &txq->entries[cmd_index];
+			cmd = ent->copy_cmd;
+			WARN_ON_ONCE(!cmd && ent->meta.flags & CMD_WANT_HCMD);
+		} else {
 			cmd = NULL;
+		}
 
 		err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
 
+		if (reclaim) {
+			/* The original command isn't needed any more */
+			kfree(txq->entries[cmd_index].copy_cmd);
+			txq->entries[cmd_index].copy_cmd = NULL;
+		}
+
 		/*
 		 * After here, we should always check rxcb._page_stolen,
 		 * if it is true then one of the handlers took the page.
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 0232628..f981b73 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -492,10 +492,11 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 	iwl_tx_queue_unmap(trans, txq_id);
 
 	/* De-alloc array of command/tx buffers */
-
 	if (txq_id == trans_pcie->cmd_queue)
-		for (i = 0; i < txq->q.n_window; i++)
+		for (i = 0; i < txq->q.n_window; i++) {
 			kfree(txq->entries[i].cmd);
+			kfree(txq->entries[i].copy_cmd);
+		}
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd) {
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 6baf8de..392d2bc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -521,7 +521,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	u16 copy_size, cmd_size;
 	bool had_nocopy = false;
 	int i;
-	u8 *cmd_dest;
+	u32 cmd_pos;
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 	const void *trace_bufs[IWL_MAX_CMD_TFDS + 1] = {};
 	int trace_lens[IWL_MAX_CMD_TFDS + 1] = {};
@@ -584,15 +584,31 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 					 INDEX_TO_SEQ(q->write_ptr));
 
 	/* and copy the data that needs to be copied */
-
-	cmd_dest = out_cmd->payload;
+	cmd_pos = offsetof(struct iwl_device_cmd, payload);
 	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
 		if (!cmd->len[i])
 			continue;
 		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY)
 			break;
-		memcpy(cmd_dest, cmd->data[i], cmd->len[i]);
-		cmd_dest += cmd->len[i];
+		memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], cmd->len[i]);
+		cmd_pos += cmd->len[i];
+	}
+
+	WARN_ON_ONCE(txq->entries[idx].copy_cmd);
+
+	/*
+	 * since out_cmd will be the source address of the FH, it will write
+	 * the retry count there. So when the user needs to receivce the HCMD
+	 * that corresponds to the response in the response handler, it needs
+	 * to set CMD_WANT_HCMD.
+	 */
+	if (cmd->flags & CMD_WANT_HCMD) {
+		txq->entries[idx].copy_cmd =
+			kmemdup(out_cmd, cmd_pos, GFP_ATOMIC);
+		if (unlikely(!txq->entries[idx].copy_cmd)) {
+			idx = -ENOMEM;
+			goto out;
+		}
 	}
 
 	IWL_DEBUG_HC(trans,
-- 
1.7.10.4

