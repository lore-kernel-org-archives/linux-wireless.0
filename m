Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761613AbXLPW6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:43 -0500
Subject: [PATCH 110/48] libertas: store command result in cmdnode instead of priv->cur_cmd_retcode
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42S9-00038f-Ru@shinybook.infradead.org> (sfid-20071216_232427_757428_005341AB)
Date: Sun, 16 Dec 2007 17:59:21 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 04:22:52 -0500

... at least for users of __lbs_cmd().

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   12 ++++++------
 drivers/net/wireless/libertas/hostcmd.h |    1 +
 drivers/net/wireless/libertas/main.c    |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index f2e027b..c8f1bd5 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1173,6 +1173,7 @@ void lbs_queue_cmd(struct lbs_private *priv,
 		lbs_deb_host("DNLD_CMD: cmd size is zero\n");
 		goto done;
 	}
+	cmdnode->result = 0;
 
 	/* Exit_PS command needs to be queued in the header always. */
 	if (le16_to_cpu(cmdnode->cmdbuf->command) == CMD_802_11_PS_MODE) {
@@ -1306,6 +1307,7 @@ void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 	if (cmd == priv->cur_cmd)
 		priv->cur_cmd_retcode = result;
 
+	cmd->result = result;
 	cmd->cmdwaitqwoken = 1;
 	wake_up_interruptible(&cmd->cmdwait_q);
 
@@ -2212,12 +2214,10 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	wait_event_interruptible(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
-	if (priv->cur_cmd_retcode) {
-		lbs_deb_host("PREP_CMD: command failed with return code %d\n",
-		       priv->cur_cmd_retcode);
-		priv->cur_cmd_retcode = 0;
-		ret = -1;
-	}
+	ret = cmdnode->result;
+	if (ret)
+		lbs_pr_info("PREP_CMD: command 0x%04x failed: %d\n",
+			    command, ret);
 	__lbs_cleanup_and_insert_cmd(priv, cmdnode);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 719da73..ea4d484 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -74,6 +74,7 @@ struct cmd_header {
 
 struct cmd_ctrl_node {
 	struct list_head list;
+	int result;
 	/* command response */
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *);
 	unsigned long callback_arg;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 0dc7de6..839ffe8 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1237,6 +1237,7 @@ int lbs_stop_card(struct lbs_private *priv)
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
+		cmdnode->result = -ENOENT;
 		cmdnode->cmdwaitqwoken = 1;
 		wake_up_interruptible(&cmdnode->cmdwait_q);
 	}
-- 
1.5.3.4

