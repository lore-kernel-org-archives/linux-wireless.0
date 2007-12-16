Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49266 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761598AbXLPW6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:40 -0500
Subject: [PATCH 107/48] libertas: kill cleanup_cmdnode()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42S3-00038Q-I7@shinybook.infradead.org> (sfid-20071216_232738_547524_D3A70181)
Date: Sun, 16 Dec 2007 17:59:15 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 02:02:56 -0500

Move the wakeup into lbs_complete_command(), and leave the other bits
in __lbs_cleanup_and_insert_cmd() which was the only caller now anyway.

There are two remaining direct callers of lbs_cleanup_and_insert_cmd(),
and they are both fine without the wakeup.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   39 +++++++++++++++-------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index fd321dd..4c0bd9f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -13,7 +13,6 @@
 #include "wext.h"
 #include "cmd.h"
 
-static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode);
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
 static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 		    struct cmd_ctrl_node *ptempnode,
@@ -1274,14 +1273,22 @@ static int lbs_cmd_mac_control(struct lbs_private *priv,
  *  after cleans it. Requires priv->driver_lock held.
  */
 static void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
-					 struct cmd_ctrl_node *ptempcmd)
+					 struct cmd_ctrl_node *cmdnode)
 {
+	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!ptempcmd)
-		return;
+	if (!cmdnode)
+		goto out;
 
-	cleanup_cmdnode(ptempcmd);
-	list_add_tail(&ptempcmd->list, &priv->cmdfreeq);
+	cmdnode->pdata_buf = NULL;
+	cmdnode->callback = NULL;
+	cmdnode->callback_arg = 0;
+
+	memset(cmdnode->cmdbuf, 0, LBS_CMD_BUFFER_SIZE);
+
+	list_add_tail(&cmdnode->list, &priv->cmdfreeq);
+ out:
+	lbs_deb_leave(LBS_DEB_HOST);
 }
 
 static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
@@ -1299,6 +1306,10 @@ void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 {
 	if (cmd == priv->cur_cmd)
 		priv->cur_cmd_retcode = result;
+
+	cmd->cmdwaitqwoken = 1;
+	wake_up_interruptible(&cmd->cmdwait_q);
+
 	__lbs_cleanup_and_insert_cmd(priv, cmd);
 	priv->cur_cmd = NULL;
 }
@@ -1771,22 +1782,6 @@ static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
  *  @param ptempnode	A pointer to cmdCtrlNode structure
  *  @return 		n/a
  */
-static void cleanup_cmdnode(struct cmd_ctrl_node *cmdnode)
-{
-	lbs_deb_enter(LBS_DEB_HOST);
-
-	if (!cmdnode)
-		return;
-	cmdnode->cmdwaitqwoken = 1;
-	wake_up_interruptible(&cmdnode->cmdwait_q);
-	cmdnode->pdata_buf = NULL;
-	cmdnode->callback = NULL;
-	cmdnode->callback_arg = 0;
-
-	memset(cmdnode->cmdbuf, 0, LBS_CMD_BUFFER_SIZE);
-
-	lbs_deb_leave(LBS_DEB_HOST);
-}
 
 /**
  *  @brief This function initializes the command node.
-- 
1.5.3.4

