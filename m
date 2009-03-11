Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZCKSNB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:01 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8] iwl3945: use iwl_tx_cmd_complete
Date: Wed, 11 Mar 2009 11:17:57 -0700
Message-Id: <1236795481-12757-5-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191313_772383_C0EDDD70)
In-Reply-To: <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

iwl3945 uses iwl_tx_cmd_complete to reclaim the unused buffers of the queue.
iwl_tx_cmd_complete in turn call the iwl_hcmd_queue_reclaim which will
unmap the dma mapping to tx_cmd and frees the memory.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   81 +--------------------------
 1 files changed, 1 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index fd3a529..93f70df 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1479,85 +1479,6 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	iwl3945_hw_rx_handler_setup(priv);
 }
 
-/**
- * iwl3945_cmd_queue_reclaim - Reclaim CMD queue entries
- * When FW advances 'R' index, all entries between old and new 'R' index
- * need to be reclaimed.
- */
-static void iwl3945_cmd_queue_reclaim(struct iwl_priv *priv,
-				      int txq_id, int index)
-{
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	int nfreed = 0;
-
-	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
-		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
-			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->write_ptr, q->read_ptr);
-		return;
-	}
-
-	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
-		if (nfreed > 1) {
-			IWL_ERR(priv, "HCMD skipped: index (%d) %d %d\n", index,
-					q->write_ptr, q->read_ptr);
-			queue_work(priv->workqueue, &priv->restart);
-			break;
-		}
-		nfreed++;
-	}
-}
-
-
-/**
- * iwl3945_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
- * @rxb: Rx buffer to reclaim
- *
- * If an Rx buffer has an async callback associated with it the callback
- * will be executed.  The attached skb (if present) will only be freed
- * if the callback returns 1
- */
-static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
-	int huge =  !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
-	int cmd_index;
-	struct iwl_cmd *cmd;
-
-	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
-		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, sequence,
-		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
-		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
-		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
-		return;
-	}
-
-	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
-
-	/* Input error checking is done when commands are added to queue. */
-	if (cmd->meta.flags & CMD_WANT_SKB) {
-		cmd->meta.source->u.skb = rxb->skb;
-		rxb->skb = NULL;
-	} else if (cmd->meta.u.callback &&
-		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
-		rxb->skb = NULL;
-
-	iwl3945_cmd_queue_reclaim(priv, txq_id, index);
-
-	if (!(cmd->meta.flags & CMD_ASYNC)) {
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
-	}
-}
-
 /************************** RX-FUNCTIONS ****************************/
 /*
  * Rx theory of operation
@@ -1917,7 +1838,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			 * fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
-				iwl3945_tx_cmd_complete(priv, rxb);
+				iwl_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARN(priv, "Claim null rxb?\n");
 		}
-- 
1.5.6.3

