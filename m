Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbaCEMLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:16 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 7/9] iwlegacy: get rit of CMD_WANT_SKB
Date: Wed,  5 Mar 2014 13:13:32 +0100
Message-Id: <1394021614-11514-8-git-send-email-sgruszka@redhat.com> (sfid-20140305_131120_697967_CBE03633)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c | 34 ++++++++--------------------------
 drivers/net/wireless/iwlegacy/common.h |  6 ++----
 2 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 92979e0..f938641 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -285,9 +285,6 @@ il_send_cmd_async(struct il_priv *il, struct il_host_cmd *cmd)
 
 	BUG_ON(!(cmd->flags & CMD_ASYNC));
 
-	/* An asynchronous command can not expect an SKB to be set. */
-	BUG_ON(cmd->flags & CMD_WANT_SKB);
-
 	/* Assign a generic callback if one is not provided */
 	if (!cmd->callback)
 		cmd->callback = il_generic_cmd_callback;
@@ -353,38 +350,27 @@ il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 		IL_ERR("Command %s aborted: RF KILL Switch\n",
 		       il_get_cmd_string(cmd->id));
 		ret = -ECANCELED;
-		goto fail;
+		goto out;
 	}
 	if (test_bit(S_FW_ERROR, &il->status)) {
 		IL_ERR("Command %s failed: FW Error\n",
 		       il_get_cmd_string(cmd->id));
 		ret = -EIO;
-		goto fail;
-	}
-	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
-		IL_ERR("Error: Response NULL in '%s'\n",
-		       il_get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto cancel;
+		goto out;
 	}
 
 	ret = 0;
 	goto out;
 
 cancel:
-	if (cmd->flags & (CMD_WANT_SKB | CMD_COPY_PKT)) {
+	if (cmd->flags & CMD_COPY_PKT) {
 		/*
-		 * Cancel the CMD_WANT_SKB flag for the cmd in the
+		 * Cancel the CMD_COPY_PKT flag for the cmd in the
 		 * TX cmd queue. Otherwise in case the cmd comes
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		il->txq[il->cmd_queue].meta[cmd_idx].flags &= ~(CMD_WANT_SKB | CMD_COPY_PKT);
-	}
-fail:
-	if (cmd->reply_page) {
-		il_free_pages(il, cmd->reply_page);
-		cmd->reply_page = 0;
+		il->txq[il->cmd_queue].meta[cmd_idx].flags &= ~CMD_COPY_PKT;
 	}
 out:
 	return ret;
@@ -3179,7 +3165,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 
 	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
 	out_meta->flags = cmd->flags | CMD_MAPPED;
-	if (cmd->flags & (CMD_WANT_SKB | CMD_COPY_PKT))
+	if (cmd->flags & CMD_COPY_PKT)
 		out_meta->source = cmd;
 	if (cmd->flags & CMD_ASYNC)
 		out_meta->callback = cmd->callback;
@@ -3322,13 +3308,9 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 	pci_unmap_single(il->pci_dev, dma_unmap_addr(meta, mapping),
 			 dma_unmap_len(meta, len), PCI_DMA_BIDIRECTIONAL);
 
-	/* Input error checking is done when commands are added to queue. */
-	if (meta->flags & CMD_WANT_SKB) {
-		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
-		rxb->page = NULL;
-	} else if (meta->flags & CMD_COPY_PKT) {
+	if (meta->flags & CMD_COPY_PKT)
 		memcpy(meta->source->pkt_ptr, pkt, sizeof(*pkt));
-	} else if (meta->callback)
+	else if (meta->callback)
 		meta->callback(il, cmd, pkt);
 
 	spin_lock_irqsave(&il->hcmd_lock, flags);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 51f0100..41996e9 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -547,9 +547,8 @@ enum {
 	CMD_NO_SKB =		0,
 	CMD_SIZE_HUGE =		(1 << 0),
 	CMD_ASYNC =		(1 << 1),
-	CMD_WANT_SKB =		(1 << 2),
-	CMD_MAPPED =		(1 << 3),
-	CMD_COPY_PKT =		(1 << 4),
+	CMD_MAPPED =		(1 << 2),
+	CMD_COPY_PKT =		(1 << 3),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
@@ -577,7 +576,6 @@ struct il_device_cmd {
 
 struct il_host_cmd {
 	const void *data;
-	unsigned long reply_page;
 	struct il_rx_pkt *pkt_ptr;
 	void (*callback) (struct il_priv *il, struct il_device_cmd *cmd,
 			  struct il_rx_pkt *pkt);
-- 
1.7.11.7

