Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638Ab1D1Jw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/10] iwlegacy: fix enqueue hcmd race conditions
Date: Thu, 28 Apr 2011 11:51:31 +0200
Message-Id: <1303984293-6601-8-git-send-email-sgruszka@redhat.com> (sfid-20110428_115302_541907_9F8827F2)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We mark command as huge by using meta->flags from other (non huge) command,
but flags can be possibly overridden, when non huge command is enqueued,
what can lead to:

WARNING: at lib/dma-debug.c:696 dma_debug_device_change+0x1a3/0x1f0()
DMA-API: device driver has pending DMA allocations while released from device [count=1]

To fix introduce additional CMD_MAPPED to mark command as mapped and
serialize iwl_enqueue_hcmd() with iwl_tx_cmd_complete() using
hcmd_lock. Serialization will also fix possible race conditions,
because q->read_ptr, q->write_ptr are modified/used in parallel.

Do not change callback, I did (and fixed) that mistake in iwlagn.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-dev.h |    1 +
 drivers/net/wireless/iwlegacy/iwl-tx.c  |   52 ++++++++++++++----------------
 2 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 36c01aa..df19d5c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -290,6 +290,7 @@ enum {
 	CMD_SIZE_HUGE = (1 << 0),
 	CMD_ASYNC = (1 << 1),
 	CMD_WANT_SKB = (1 << 2),
+	CMD_MAPPED = (1 << 3),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index a227773..4fff995 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -146,33 +146,32 @@ void iwl_legacy_cmd_queue_unmap(struct iwl_priv *priv)
 {
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 	struct iwl_queue *q = &txq->q;
-	bool huge = false;
 	int i;
 
 	if (q->n_bd == 0)
 		return;
 
 	while (q->read_ptr != q->write_ptr) {
-		/* we have no way to tell if it is a huge cmd ATM */
 		i = iwl_legacy_get_cmd_index(q, q->read_ptr, 0);
 
-		if (txq->meta[i].flags & CMD_SIZE_HUGE)
-			huge = true;
-		else
+		if (txq->meta[i].flags & CMD_MAPPED) {
 			pci_unmap_single(priv->pci_dev,
 					 dma_unmap_addr(&txq->meta[i], mapping),
 					 dma_unmap_len(&txq->meta[i], len),
 					 PCI_DMA_BIDIRECTIONAL);
+			txq->meta[i].flags = 0;
+		}
 
 		q->read_ptr = iwl_legacy_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 
-	if (huge) {
-		i = q->n_window;
+	i = q->n_window;
+	if (txq->meta[i].flags & CMD_MAPPED) {
 		pci_unmap_single(priv->pci_dev,
 				 dma_unmap_addr(&txq->meta[i], mapping),
 				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
+		txq->meta[i].flags = 0;
 	}
 }
 EXPORT_SYMBOL(iwl_legacy_cmd_queue_unmap);
@@ -467,29 +466,27 @@ int iwl_legacy_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
+	spin_lock_irqsave(&priv->hcmd_lock, flags);
+
 	if (iwl_legacy_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		IWL_ERR(priv, "No space in command queue\n");
-		IWL_ERR(priv, "Restarting adapter due to queue full\n");
+		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
+
+		IWL_ERR(priv, "Restarting adapter due to command queue full\n");
 		queue_work(priv->workqueue, &priv->restart);
 		return -ENOSPC;
 	}
 
-	spin_lock_irqsave(&priv->hcmd_lock, flags);
-
-	/* If this is a huge cmd, mark the huge flag also on the meta.flags
-	 * of the _original_ cmd. This is used for DMA mapping clean up.
-	 */
-	if (cmd->flags & CMD_SIZE_HUGE) {
-		idx = iwl_legacy_get_cmd_index(q, q->write_ptr, 0);
-		txq->meta[idx].flags = CMD_SIZE_HUGE;
-	}
-
 	idx = iwl_legacy_get_cmd_index(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
 
+	if (WARN_ON(out_meta->flags & CMD_MAPPED)) {
+		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
+		return -ENOSPC;
+	}
+
 	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
-	out_meta->flags = cmd->flags;
+	out_meta->flags = cmd->flags | CMD_MAPPED;
 	if (cmd->flags & CMD_WANT_SKB)
 		out_meta->source = cmd;
 	if (cmd->flags & CMD_ASYNC)
@@ -610,6 +607,7 @@ iwl_legacy_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
+	unsigned long flags;
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
@@ -623,14 +621,6 @@ iwl_legacy_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		return;
 	}
 
-	/* If this is a huge cmd, clear the huge flag on the meta.flags
-	 * of the _original_ cmd. So that iwl_legacy_cmd_queue_free won't unmap
-	 * the DMA buffer for the scan (huge) command.
-	 */
-	if (huge) {
-		cmd_index = iwl_legacy_get_cmd_index(&txq->q, index, 0);
-		txq->meta[cmd_index].flags = 0;
-	}
 	cmd_index = iwl_legacy_get_cmd_index(&txq->q, index, huge);
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
@@ -647,6 +637,8 @@ iwl_legacy_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	} else if (meta->callback)
 		meta->callback(priv, cmd, pkt);
 
+	spin_lock_irqsave(&priv->hcmd_lock, flags);
+
 	iwl_legacy_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
@@ -655,6 +647,10 @@ iwl_legacy_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 			       iwl_legacy_get_cmd_string(cmd->hdr.cmd));
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
+
+	/* Mark as unmapped */
 	meta->flags = 0;
+
+	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 }
 EXPORT_SYMBOL(iwl_legacy_tx_cmd_complete);
-- 
1.7.1

