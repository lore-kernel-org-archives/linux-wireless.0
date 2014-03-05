Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbaCEMK5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:10:57 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 1/9] iwlegacy: add pkt pointer to command
Date: Wed,  5 Mar 2014 13:13:26 +0100
Message-Id: <1394021614-11514-2-git-send-email-sgruszka@redhat.com> (sfid-20140305_131059_622992_053933B6)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is preparation for further changes, replacing CMD_WANT_SKB and
reply_patch from command to make RX memory management simpler.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |  8 +++++---
 drivers/net/wireless/iwlegacy/common.h | 16 +++++++++-------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 4f42174..31b9623 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -372,14 +372,14 @@ il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 	goto out;
 
 cancel:
-	if (cmd->flags & CMD_WANT_SKB) {
+	if (cmd->flags & (CMD_WANT_SKB | CMD_COPY_PKT)) {
 		/*
 		 * Cancel the CMD_WANT_SKB flag for the cmd in the
 		 * TX cmd queue. Otherwise in case the cmd comes
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		il->txq[il->cmd_queue].meta[cmd_idx].flags &= ~CMD_WANT_SKB;
+		il->txq[il->cmd_queue].meta[cmd_idx].flags &= ~(CMD_WANT_SKB | CMD_COPY_PKT);
 	}
 fail:
 	if (cmd->reply_page) {
@@ -3172,7 +3172,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 
 	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
 	out_meta->flags = cmd->flags | CMD_MAPPED;
-	if (cmd->flags & CMD_WANT_SKB)
+	if (cmd->flags & (CMD_WANT_SKB | CMD_COPY_PKT))
 		out_meta->source = cmd;
 	if (cmd->flags & CMD_ASYNC)
 		out_meta->callback = cmd->callback;
@@ -3319,6 +3319,8 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 	if (meta->flags & CMD_WANT_SKB) {
 		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
 		rxb->page = NULL;
+	} else if (meta->flags & CMD_COPY_PKT) {
+		memcpy(meta->source->pkt_ptr, pkt, sizeof(*pkt));
 	} else if (meta->callback)
 		meta->callback(il, cmd, pkt);
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index dfb13c7..51f0100 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -542,13 +542,14 @@ struct il_frame {
 };
 
 enum {
-	CMD_SYNC = 0,
-	CMD_SIZE_NORMAL = 0,
-	CMD_NO_SKB = 0,
-	CMD_SIZE_HUGE = (1 << 0),
-	CMD_ASYNC = (1 << 1),
-	CMD_WANT_SKB = (1 << 2),
-	CMD_MAPPED = (1 << 3),
+	CMD_SYNC =		0,
+	CMD_SIZE_NORMAL =	0,
+	CMD_NO_SKB =		0,
+	CMD_SIZE_HUGE =		(1 << 0),
+	CMD_ASYNC =		(1 << 1),
+	CMD_WANT_SKB =		(1 << 2),
+	CMD_MAPPED =		(1 << 3),
+	CMD_COPY_PKT =		(1 << 4),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
@@ -577,6 +578,7 @@ struct il_device_cmd {
 struct il_host_cmd {
 	const void *data;
 	unsigned long reply_page;
+	struct il_rx_pkt *pkt_ptr;
 	void (*callback) (struct il_priv *il, struct il_device_cmd *cmd,
 			  struct il_rx_pkt *pkt);
 	u32 flags;
-- 
1.7.11.7

