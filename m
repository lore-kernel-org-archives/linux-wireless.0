Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbXLPW60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:26 -0500
Subject: [PATCH 102/48] libertas: rename and clean up DownloadcommandToStation
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Rt-000381-0F@shinybook.infradead.org> (sfid-20071216_225834_471081_6F39E024)
Date: Sun, 16 Dec 2007 17:59:05 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 00:09:25 -0500

Call it lbs_submit_command(), remove a bunch of things which can be (or,
in the case of zeroing ->cmdwaitqwoken, already are) done elsewhere.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   36 ++++++++--------------------------
 1 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 5ceb331..4dc6bbe 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1170,6 +1170,10 @@ void lbs_queue_cmd(struct lbs_private *priv,
 		lbs_deb_host("QUEUE_CMD: cmdnode or cmdbuf is NULL\n");
 		goto done;
 	}
+	if (!cmdnode->cmdbuf->size) {
+		lbs_deb_host("DNLD_CMD: cmd size is zero\n");
+		goto done;
+	}
 
 	/* Exit_PS command needs to be queued in the header always. */
 	if (le16_to_cpu(cmdnode->cmdbuf->command) == CMD_802_11_PS_MODE) {
@@ -1197,15 +1201,8 @@ done:
 	lbs_deb_leave(LBS_DEB_HOST);
 }
 
-/*
- * TODO: Fix the issue when DownloadcommandToStation is being called the
- * second time when the command times out. All the cmdptr->xxx are in little
- * endian and therefore all the comparissions will fail.
- * For now - we are not performing the endian conversion the second time - but
- * for PS and DEEP_SLEEP we need to worry
- */
-static int DownloadcommandToStation(struct lbs_private *priv,
-				    struct cmd_ctrl_node *cmdnode)
+static int lbs_submit_command(struct lbs_private *priv,
+			      struct cmd_ctrl_node *cmdnode)
 {
 	unsigned long flags;
 	struct cmd_header *cmd;
@@ -1215,21 +1212,9 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!priv || !cmdnode) {
-		lbs_deb_host("DNLD_CMD: priv or cmdmode is NULL\n");
-		goto done;
-	}
-
 	cmd = cmdnode->cmdbuf;
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
-	if (!cmd || !cmd->size) {
-		lbs_deb_host("DNLD_CMD: cmdptr is NULL or zero\n");
-		__lbs_cleanup_and_insert_cmd(priv, cmdnode);
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		goto done;
-	}
-
 	priv->cur_cmd = cmdnode;
 	priv->cur_cmd_retcode = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -1241,12 +1226,9 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 		     command, le16_to_cpu(cmd->seqnum), cmdsize, jiffies);
 	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
 
-	cmdnode->cmdwaitqwoken = 0;
-
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
-
-	if (ret != 0) {
-		lbs_deb_host("DNLD_CMD: hw_host_to_card failed\n");
+	if (ret) {
+		lbs_pr_info("DNLD_CMD: hw_host_to_card failed: %d\n", ret);
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		priv->cur_cmd_retcode = ret;
 		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
@@ -1952,7 +1934,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 		list_del(&cmdnode->list);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmd->command));
-		DownloadcommandToStation(priv, cmdnode);
+		lbs_submit_command(priv, cmdnode);
 	} else {
 		/*
 		 * check if in power save mode, if yes, put the device back
-- 
1.5.3.4

