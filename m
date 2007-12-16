Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761533AbXLPW6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:30 -0500
Subject: [PATCH 104/48] libertas: remove some pointless checks for cmdnode buffer being present
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Rx-00038B-7V@shinybook.infradead.org> (sfid-20071216_225843_136025_87793516)
Date: Sun, 16 Dec 2007 17:59:09 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 00:41:51 -0500

We allocate them all at the same time, at startup. If they go missing,
we have more serious things to worry about, and the resulting oops will
be a perfectly acceptable result.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4dc6bbe..4ffb84a 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1166,8 +1166,8 @@ void lbs_queue_cmd(struct lbs_private *priv,
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!cmdnode || !cmdnode->cmdbuf) {
-		lbs_deb_host("QUEUE_CMD: cmdnode or cmdbuf is NULL\n");
+	if (!cmdnode) {
+		lbs_deb_host("QUEUE_CMD: cmdnode is NULL\n");
 		goto done;
 	}
 	if (!cmdnode->cmdbuf->size) {
@@ -1195,7 +1195,7 @@ void lbs_queue_cmd(struct lbs_private *priv,
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	lbs_deb_host("QUEUE_CMD: inserted command 0x%04x into cmdpendingq\n",
-	       le16_to_cpu(cmdnode->cmdbuf->command));
+		     le16_to_cpu(cmdnode->cmdbuf->command));
 
 done:
 	lbs_deb_leave(LBS_DEB_HOST);
@@ -1380,13 +1380,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 
 	lbs_deb_host("PREP_CMD: command 0x%04x\n", cmd_no);
 
-	if (!cmdptr) {
-		lbs_deb_host("PREP_CMD: cmdptr is NULL\n");
-		lbs_cleanup_and_insert_cmd(priv, cmdnode);
-		ret = -1;
-		goto done;
-	}
-
 	/* Set sequence number, command and INT option */
 	priv->seqnum++;
 	cmdptr->seqnum = cpu_to_le16(priv->seqnum);
@@ -1786,8 +1779,7 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *cmdnode)
 	cmdnode->callback = NULL;
 	cmdnode->callback_arg = 0;
 
-	if (cmdnode->cmdbuf != NULL)
-		memset(cmdnode->cmdbuf, 0, LBS_CMD_BUFFER_SIZE);
+	memset(cmdnode->cmdbuf, 0, LBS_CMD_BUFFER_SIZE);
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
-- 
1.5.3.4

