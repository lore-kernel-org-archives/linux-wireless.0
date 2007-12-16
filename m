Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49282 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761394AbXLPW6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:55 -0500
Subject: [PATCH 114/48] libertas: kill 'addtail' argument to lbs_queue_cmd() and make it static
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42SI-00038z-96@shinybook.infradead.org> (sfid-20071216_232050_447979_B5F3277B)
Date: Sun, 16 Dec 2007 17:59:30 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 20:04:54 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c  |   14 +++++---------
 drivers/net/wireless/libertas/decl.h |    4 ----
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c3d7f60..7682b9d 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1155,15 +1155,11 @@ static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
 	return 0;
 }
 
-/*
- * Note: NEVER use lbs_queue_cmd() with addtail==0 other than for
- * the command timer, because it does not account for queued commands.
- */
-void lbs_queue_cmd(struct lbs_private *priv,
-	struct cmd_ctrl_node *cmdnode,
-	u8 addtail)
+static void lbs_queue_cmd(struct lbs_private *priv,
+			  struct cmd_ctrl_node *cmdnode)
 {
 	unsigned long flags;
+	int addtail = 1;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -1635,7 +1631,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 
 	cmdnode->cmdwaitqwoken = 0;
 
-	lbs_queue_cmd(priv, cmdnode, 1);
+	lbs_queue_cmd(priv, cmdnode);
 	wake_up_interruptible(&priv->waitq);
 
 	if (wait_option & CMD_OPTION_WAITFORRSP) {
@@ -2185,7 +2181,7 @@ struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv, uint16_t command
 	 * because the caller of lbs_cmd() sets up all of *cmd for us. */
 
 	cmdnode->cmdwaitqwoken = 0;
-	lbs_queue_cmd(priv, cmdnode, 1);
+	lbs_queue_cmd(priv, cmdnode);
 	wake_up_interruptible(&priv->waitq);
 
  done:
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 5dd5c9e..aaacd9b 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -28,10 +28,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_action,
 	u16 wait_option, u32 cmd_oid, void *pdata_buf);
 
-void lbs_queue_cmd(struct lbs_private *priv,
-	struct cmd_ctrl_node *cmdnode,
-	u8 addtail);
-
 int lbs_allocate_cmd_buffer(struct lbs_private *priv);
 int lbs_execute_next_command(struct lbs_private *priv);
 int lbs_process_event(struct lbs_private *priv);
-- 
1.5.3.4

