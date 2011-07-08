Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab1GHQUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/21] iwlagn: remove the CMD_MAPPED flag
Date: Fri,  8 Jul 2011 08:46:09 -0700
Message-Id: <1310139989-27661-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182113_421354_94F85FB8)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is uneeded since Johannes removed the HUGE flag. The DMA mapping is always held in the same index as the command.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-tx.c  |   16 ++++------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f4501f8..e429e32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -263,7 +263,6 @@ enum {
 	CMD_NO_SKB = 0,
 	CMD_ASYNC = (1 << 1),
 	CMD_WANT_SKB = (1 << 2),
-	CMD_MAPPED = (1 << 3),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index db5abaa..dc8f63f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -291,11 +291,9 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 	while (q->read_ptr != q->write_ptr) {
 		i = get_cmd_index(q, q->read_ptr);
 
-		if (txq->meta[i].flags & CMD_MAPPED) {
-			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i],
-					 DMA_BIDIRECTIONAL);
-			txq->meta[i].flags = 0;
-		}
+		iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i],
+				 DMA_BIDIRECTIONAL);
+		txq->meta[i].flags = 0;
 
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
@@ -496,11 +494,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
 
-	if (WARN_ON(out_meta->flags & CMD_MAPPED)) {
-		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
-		return -ENOSPC;
-	}
-
 	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
 	if (cmd->flags & CMD_WANT_SKB)
 		out_meta->source = cmd;
@@ -574,7 +567,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 #endif
 	}
 
-	out_meta->flags = cmd->flags | CMD_MAPPED;
+	out_meta->flags = cmd->flags;
 
 	txq->need_update = 1;
 
@@ -684,7 +677,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
 
-	/* Mark as unmapped */
 	meta->flags = 0;
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
-- 
1.7.0.4

