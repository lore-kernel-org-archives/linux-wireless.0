Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1DTODk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 10:03:40 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: fix possible data overwrite in hcmd callback
Date: Wed, 20 Apr 2011 16:02:58 +0200
Message-Id: <1303308178-5297-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My commit 3598e1774c94e55c71b585340e7dc4538f310e3f
"iwlwifi: fix enqueue hcmd race conditions" move hcmd callback after
command queue reclaim, to avoid call it with hcmd_lock. But since
queue read index was updated, cmd data can be overwritten. Fix problem
by calling callback before taking hcmd_lock and queue reclaim.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3732380..efff189 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -607,9 +607,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_cmd_meta *meta;
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 	unsigned long flags;
-	void (*callback) (struct iwl_priv *priv, struct iwl_device_cmd *cmd,
-			  struct iwl_rx_packet *pkt);
-
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
@@ -623,8 +620,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		return;
 	}
 
-	spin_lock_irqsave(&priv->hcmd_lock, flags);
-
 	cmd_index = get_cmd_index(&txq->q, index, huge);
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
@@ -634,13 +629,14 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 			 dma_unmap_len(meta, len),
 			 PCI_DMA_BIDIRECTIONAL);
 
-	callback = NULL;
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
 		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
 		rxb->page = NULL;
-	} else
-		callback = meta->callback;
+	} else if (meta->callback)
+		meta->callback(priv, cmd, pkt);
+
+	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
 	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
 
@@ -655,7 +651,4 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	meta->flags = 0;
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
-
-	if (callback)
-		callback(priv, cmd, pkt);
 }
-- 
1.7.1

