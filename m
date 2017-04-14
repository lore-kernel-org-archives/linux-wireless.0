Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51860 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754058AbdDNJE4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:04:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:02:05 +0300
Message-Id: <20170414090210.31397-22-luca@coelho.fi> (sfid-20170414_110514_163375_6A145A7F)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 21/26] iwlwifi: pcie: support host commands in new transport
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Code is basically the same, with a cleanups of old narrow host
command, ampg workarounds, some cosmetic stuff, and usage of
TFH functions when accessing TFD queues.
This enables also the cleanup of iwl_pcie_tfd_set_tb() since
now it won't be called anywhere in the a000 data path

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 386 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  24 +-
 4 files changed, 396 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 912d475ed292..2266f3aa67aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -778,5 +778,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue);
 int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			   struct iwl_device_cmd *dev_cmd, int txq_id);
+int iwl_trans_pcie_gen2_send_hcmd(struct iwl_trans *trans,
+				  struct iwl_host_cmd *cmd);
 
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e1610241be07..16a057398de2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2918,7 +2918,7 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 	.start_fw = iwl_trans_pcie_gen2_start_fw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
-	.send_cmd = iwl_trans_pcie_send_hcmd,
+	.send_cmd = iwl_trans_pcie_gen2_send_hcmd,
 
 	.tx = iwl_trans_pcie_gen2_tx,
 	.reclaim = iwl_trans_pcie_reclaim,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 4717440bc7f9..af5b97c82c5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -48,6 +48,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+#include <linux/pm_runtime.h>
 
 #include "iwl-debug.h"
 #include "iwl-csr.h"
@@ -371,6 +372,391 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	return 0;
 }
 
+/*************** HOST COMMAND QUEUE FUNCTIONS   *****/
+
+/*
+ * iwl_pcie_gen2_enqueue_hcmd - enqueue a uCode command
+ * @priv: device private data point
+ * @cmd: a pointer to the ucode command structure
+ *
+ * The function returns < 0 values to indicate the operation
+ * failed. On success, it returns the index (>= 0) of command in the
+ * command queue.
+ */
+static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
+				      struct iwl_host_cmd *cmd)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_device_cmd *out_cmd;
+	struct iwl_cmd_meta *out_meta;
+	unsigned long flags;
+	void *dup_buf = NULL;
+	dma_addr_t phys_addr;
+	int idx, i, cmd_pos;
+	u16 copy_size, cmd_size, tb0_size;
+	bool had_nocopy = false;
+	u8 group_id = iwl_cmd_groupid(cmd->id);
+	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
+	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
+	struct iwl_tfh_tfd *tfd =
+		iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr);
+
+	memset(tfd, 0, sizeof(*tfd));
+
+	copy_size = sizeof(struct iwl_cmd_header_wide);
+	cmd_size = sizeof(struct iwl_cmd_header_wide);
+
+	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
+		cmddata[i] = cmd->data[i];
+		cmdlen[i] = cmd->len[i];
+
+		if (!cmd->len[i])
+			continue;
+
+		/* need at least IWL_FIRST_TB_SIZE copied */
+		if (copy_size < IWL_FIRST_TB_SIZE) {
+			int copy = IWL_FIRST_TB_SIZE - copy_size;
+
+			if (copy > cmdlen[i])
+				copy = cmdlen[i];
+			cmdlen[i] -= copy;
+			cmddata[i] += copy;
+			copy_size += copy;
+		}
+
+		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY) {
+			had_nocopy = true;
+			if (WARN_ON(cmd->dataflags[i] & IWL_HCMD_DFL_DUP)) {
+				idx = -EINVAL;
+				goto free_dup_buf;
+			}
+		} else if (cmd->dataflags[i] & IWL_HCMD_DFL_DUP) {
+			/*
+			 * This is also a chunk that isn't copied
+			 * to the static buffer so set had_nocopy.
+			 */
+			had_nocopy = true;
+
+			/* only allowed once */
+			if (WARN_ON(dup_buf)) {
+				idx = -EINVAL;
+				goto free_dup_buf;
+			}
+
+			dup_buf = kmemdup(cmddata[i], cmdlen[i],
+					  GFP_ATOMIC);
+			if (!dup_buf)
+				return -ENOMEM;
+		} else {
+			/* NOCOPY must not be followed by normal! */
+			if (WARN_ON(had_nocopy)) {
+				idx = -EINVAL;
+				goto free_dup_buf;
+			}
+			copy_size += cmdlen[i];
+		}
+		cmd_size += cmd->len[i];
+	}
+
+	/*
+	 * If any of the command structures end up being larger than the
+	 * TFD_MAX_PAYLOAD_SIZE and they aren't dynamically allocated into
+	 * separate TFDs, then we will need to increase the size of the buffers
+	 */
+	if (WARN(copy_size > TFD_MAX_PAYLOAD_SIZE,
+		 "Command %s (%#x) is too large (%d bytes)\n",
+		 iwl_get_cmd_string(trans, cmd->id), cmd->id, copy_size)) {
+		idx = -EINVAL;
+		goto free_dup_buf;
+	}
+
+	spin_lock_bh(&txq->lock);
+
+	if (iwl_queue_space(txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
+		spin_unlock_bh(&txq->lock);
+
+		IWL_ERR(trans, "No space in command queue\n");
+		iwl_op_mode_cmd_queue_full(trans->op_mode);
+		idx = -ENOSPC;
+		goto free_dup_buf;
+	}
+
+	idx = get_cmd_index(txq, txq->write_ptr);
+	out_cmd = txq->entries[idx].cmd;
+	out_meta = &txq->entries[idx].meta;
+
+	/* re-initialize to NULL */
+	memset(out_meta, 0, sizeof(*out_meta));
+	if (cmd->flags & CMD_WANT_SKB)
+		out_meta->source = cmd;
+
+	/* set up the header */
+	out_cmd->hdr_wide.cmd = iwl_cmd_opcode(cmd->id);
+	out_cmd->hdr_wide.group_id = group_id;
+	out_cmd->hdr_wide.version = iwl_cmd_version(cmd->id);
+	out_cmd->hdr_wide.length =
+		cpu_to_le16(cmd_size - sizeof(struct iwl_cmd_header_wide));
+	out_cmd->hdr_wide.reserved = 0;
+	out_cmd->hdr_wide.sequence =
+		cpu_to_le16(QUEUE_TO_SEQ(trans_pcie->cmd_queue) |
+					 INDEX_TO_SEQ(txq->write_ptr));
+
+	cmd_pos = sizeof(struct iwl_cmd_header_wide);
+	copy_size = sizeof(struct iwl_cmd_header_wide);
+
+	/* and copy the data that needs to be copied */
+	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
+		int copy;
+
+		if (!cmd->len[i])
+			continue;
+
+		/* copy everything if not nocopy/dup */
+		if (!(cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
+					   IWL_HCMD_DFL_DUP))) {
+			copy = cmd->len[i];
+
+			memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], copy);
+			cmd_pos += copy;
+			copy_size += copy;
+			continue;
+		}
+
+		/*
+		 * Otherwise we need at least IWL_FIRST_TB_SIZE copied
+		 * in total (for bi-directional DMA), but copy up to what
+		 * we can fit into the payload for debug dump purposes.
+		 */
+		copy = min_t(int, TFD_MAX_PAYLOAD_SIZE - cmd_pos, cmd->len[i]);
+
+		memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], copy);
+		cmd_pos += copy;
+
+		/* However, treat copy_size the proper way, we need it below */
+		if (copy_size < IWL_FIRST_TB_SIZE) {
+			copy = IWL_FIRST_TB_SIZE - copy_size;
+
+			if (copy > cmd->len[i])
+				copy = cmd->len[i];
+			copy_size += copy;
+		}
+	}
+
+	IWL_DEBUG_HC(trans,
+		     "Sending command %s (%.2x.%.2x), seq: 0x%04X, %d bytes at %d[%d]:%d\n",
+		     iwl_get_cmd_string(trans, cmd->id), group_id,
+		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
+		     cmd_size, txq->write_ptr, idx, trans_pcie->cmd_queue);
+
+	/* start the TFD with the minimum copy bytes */
+	tb0_size = min_t(int, copy_size, IWL_FIRST_TB_SIZE);
+	memcpy(&txq->first_tb_bufs[idx], &out_cmd->hdr, tb0_size);
+	iwl_pcie_gen2_set_tb(trans, tfd, iwl_pcie_get_first_tb_dma(txq, idx),
+			     tb0_size);
+
+	/* map first command fragment, if any remains */
+	if (copy_size > tb0_size) {
+		phys_addr = dma_map_single(trans->dev,
+					   ((u8 *)&out_cmd->hdr) + tb0_size,
+					   copy_size - tb0_size,
+					   DMA_TO_DEVICE);
+		if (dma_mapping_error(trans->dev, phys_addr)) {
+			idx = -ENOMEM;
+			iwl_pcie_gen2_tfd_unmap(trans, out_meta, tfd);
+			goto out;
+		}
+		iwl_pcie_gen2_set_tb(trans, tfd, phys_addr,
+				     copy_size - tb0_size);
+	}
+
+	/* map the remaining (adjusted) nocopy/dup fragments */
+	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
+		const void *data = cmddata[i];
+
+		if (!cmdlen[i])
+			continue;
+		if (!(cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
+					   IWL_HCMD_DFL_DUP)))
+			continue;
+		if (cmd->dataflags[i] & IWL_HCMD_DFL_DUP)
+			data = dup_buf;
+		phys_addr = dma_map_single(trans->dev, (void *)data,
+					   cmdlen[i], DMA_TO_DEVICE);
+		if (dma_mapping_error(trans->dev, phys_addr)) {
+			idx = -ENOMEM;
+			iwl_pcie_gen2_tfd_unmap(trans, out_meta, tfd);
+			goto out;
+		}
+		iwl_pcie_gen2_set_tb(trans, tfd, phys_addr, cmdlen[i]);
+	}
+
+	BUILD_BUG_ON(IWL_TFH_NUM_TBS > sizeof(out_meta->tbs) * BITS_PER_BYTE);
+	out_meta->flags = cmd->flags;
+	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
+		kzfree(txq->entries[idx].free_buf);
+	txq->entries[idx].free_buf = dup_buf;
+
+	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr_wide);
+
+	/* start timer if queue currently empty */
+	if (txq->read_ptr == txq->write_ptr && txq->wd_timeout)
+		mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
+
+	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+	if (!(cmd->flags & CMD_SEND_IN_IDLE) &&
+	    !trans_pcie->ref_cmd_in_flight) {
+		trans_pcie->ref_cmd_in_flight = true;
+		IWL_DEBUG_RPM(trans, "set ref_cmd_in_flight - ref\n");
+		iwl_trans_ref(trans);
+	}
+	/* Increment and update queue's write index */
+	txq->write_ptr = iwl_queue_inc_wrap(txq->write_ptr);
+	iwl_pcie_gen2_txq_inc_wr_ptr(trans, txq);
+	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+
+out:
+	spin_unlock_bh(&txq->lock);
+free_dup_buf:
+	if (idx < 0)
+		kfree(dup_buf);
+	return idx;
+}
+
+#define HOST_COMPLETE_TIMEOUT	(2 * HZ)
+
+static int iwl_pcie_gen2_send_hcmd_sync(struct iwl_trans *trans,
+					struct iwl_host_cmd *cmd)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	const char *cmd_str = iwl_get_cmd_string(trans, cmd->id);
+	int cmd_idx;
+	int ret;
+
+	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n", cmd_str);
+
+	if (WARN(test_and_set_bit(STATUS_SYNC_HCMD_ACTIVE,
+				  &trans->status),
+		 "Command %s: a command is already active!\n", cmd_str))
+		return -EIO;
+
+	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n", cmd_str);
+
+	if (pm_runtime_suspended(&trans_pcie->pci_dev->dev)) {
+		ret = wait_event_timeout(trans_pcie->d0i3_waitq,
+				 pm_runtime_active(&trans_pcie->pci_dev->dev),
+				 msecs_to_jiffies(IWL_TRANS_IDLE_TIMEOUT));
+		if (!ret) {
+			IWL_ERR(trans, "Timeout exiting D0i3 before hcmd\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	cmd_idx = iwl_pcie_gen2_enqueue_hcmd(trans, cmd);
+	if (cmd_idx < 0) {
+		ret = cmd_idx;
+		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
+		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
+			cmd_str, ret);
+		return ret;
+	}
+
+	ret = wait_event_timeout(trans_pcie->wait_command_queue,
+				 !test_bit(STATUS_SYNC_HCMD_ACTIVE,
+					   &trans->status),
+				 HOST_COMPLETE_TIMEOUT);
+	if (!ret) {
+		struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
+
+		IWL_ERR(trans, "Error sending %s: time out after %dms.\n",
+			cmd_str, jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
+
+		IWL_ERR(trans, "Current CMD queue read_ptr %d write_ptr %d\n",
+			txq->read_ptr, txq->write_ptr);
+
+		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
+		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
+			       cmd_str);
+		ret = -ETIMEDOUT;
+
+		iwl_force_nmi(trans);
+		iwl_trans_fw_error(trans);
+
+		goto cancel;
+	}
+
+	if (test_bit(STATUS_FW_ERROR, &trans->status)) {
+		IWL_ERR(trans, "FW error in SYNC CMD %s\n", cmd_str);
+		dump_stack();
+		ret = -EIO;
+		goto cancel;
+	}
+
+	if (!(cmd->flags & CMD_SEND_IN_RFKILL) &&
+	    test_bit(STATUS_RFKILL, &trans->status)) {
+		IWL_DEBUG_RF_KILL(trans, "RFKILL in SYNC CMD... no rsp\n");
+		ret = -ERFKILL;
+		goto cancel;
+	}
+
+	if ((cmd->flags & CMD_WANT_SKB) && !cmd->resp_pkt) {
+		IWL_ERR(trans, "Error: Response NULL in '%s'\n", cmd_str);
+		ret = -EIO;
+		goto cancel;
+	}
+
+	return 0;
+
+cancel:
+	if (cmd->flags & CMD_WANT_SKB) {
+		/*
+		 * Cancel the CMD_WANT_SKB flag for the cmd in the
+		 * TX cmd queue. Otherwise in case the cmd comes
+		 * in later, it will possibly set an invalid
+		 * address (cmd->meta.source).
+		 */
+		trans_pcie->txq[trans_pcie->cmd_queue].
+			entries[cmd_idx].meta.flags &= ~CMD_WANT_SKB;
+	}
+
+	if (cmd->resp_pkt) {
+		iwl_free_resp(cmd);
+		cmd->resp_pkt = NULL;
+	}
+
+	return ret;
+}
+
+int iwl_trans_pcie_gen2_send_hcmd(struct iwl_trans *trans,
+				  struct iwl_host_cmd *cmd)
+{
+	if (!(cmd->flags & CMD_SEND_IN_RFKILL) &&
+	    test_bit(STATUS_RFKILL, &trans->status)) {
+		IWL_DEBUG_RF_KILL(trans, "Dropping CMD 0x%x: RF KILL\n",
+				  cmd->id);
+		return -ERFKILL;
+	}
+
+	if (cmd->flags & CMD_ASYNC) {
+		int ret;
+
+		/* An asynchronous command can not expect an SKB to be set. */
+		if (WARN_ON(cmd->flags & CMD_WANT_SKB))
+			return -EINVAL;
+
+		ret = iwl_pcie_gen2_enqueue_hcmd(trans, cmd);
+		if (ret < 0) {
+			IWL_ERR(trans,
+				"Error sending %s: enqueue_hcmd failed: %d\n",
+				iwl_get_cmd_string(trans, cmd->id), ret);
+			return ret;
+		}
+		return 0;
+	}
+
+	return iwl_pcie_gen2_send_hcmd_sync(trans, cmd);
+}
+
 /*
  * iwl_pcie_gen2_txq_unmap -  Unmap any remaining DMA mappings and free skb's
  */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index d57310eaaef7..5af6eb98eb43 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -341,27 +341,17 @@ static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_trans *trans,
 static inline void iwl_pcie_tfd_set_tb(struct iwl_trans *trans, void *tfd,
 				       u8 idx, dma_addr_t addr, u16 len)
 {
-	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
-		struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
+	struct iwl_tfd *tfd_fh = (void *)tfd;
+	struct iwl_tfd_tb *tb = &tfd_fh->tbs[idx];
 
-		put_unaligned_le64(addr, &tb->addr);
-		tb->tb_len = cpu_to_le16(len);
+	u16 hi_n_len = len << 4;
 
-		tfd_fh->num_tbs = cpu_to_le16(idx + 1);
-	} else {
-		struct iwl_tfd *tfd_fh = (void *)tfd;
-		struct iwl_tfd_tb *tb = &tfd_fh->tbs[idx];
+	put_unaligned_le32(addr, &tb->lo);
+	hi_n_len |= iwl_get_dma_hi_addr(addr);
 
-		u16 hi_n_len = len << 4;
+	tb->hi_n_len = cpu_to_le16(hi_n_len);
 
-		put_unaligned_le32(addr, &tb->lo);
-		hi_n_len |= iwl_get_dma_hi_addr(addr);
-
-		tb->hi_n_len = cpu_to_le16(hi_n_len);
-
-		tfd_fh->num_tbs = idx + 1;
-	}
+	tfd_fh->num_tbs = idx + 1;
 }
 
 static inline u8 iwl_pcie_tfd_get_num_tbs(struct iwl_trans *trans, void *_tfd)
-- 
2.11.0
