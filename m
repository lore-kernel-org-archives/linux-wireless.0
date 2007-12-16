Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761671AbXLPW6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:45 -0500
Subject: [PATCH 111/48] libertas: add __lbs_cmd_async() for asynchronous command submission
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42SB-00038k-VE@shinybook.infradead.org> (sfid-20071216_232746_597896_28EDFB0C)
Date: Sun, 16 Dec 2007 17:59:23 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 03:09:33 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |   60 +++++++++++++++++-----------------
 drivers/net/wireless/libertas/cmd.h |    6 +++
 2 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c8f1bd5..3079b3f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -2139,42 +2139,18 @@ int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
 }
 EXPORT_SYMBOL_GPL(lbs_cmd_copyback);
 
-/**
- *  @brief Simple way to call firmware functions
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param psmode  	one of the many CMD_802_11_xxxx
- *  @param cmd          pointer to the parameters structure for above command
- *                      (this should not include the command, size, sequence
- *                      and result fields from struct cmd_ds_gen)
- *  @param cmd_size     size structure pointed to by cmd
- *  @param rsp          pointer to an area where the result should be placed
- *  @param rsp_size     pointer to the size of the rsp area. If the firmware
- *                      returns fewer bytes, then this *rsp_size will be
- *                      changed to the actual size.
- *  @return 	   	-1 in case of a higher level error, otherwise
- *                      the result code from the firmware
- */
-int __lbs_cmd(struct lbs_private *priv, uint16_t command,
-	      struct cmd_header *in_cmd, int in_cmd_size,
-	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
-	      unsigned long callback_arg)
+struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv, uint16_t command,
+				      struct cmd_header *in_cmd, int in_cmd_size,
+				      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
+				      unsigned long callback_arg)
 {
 	struct cmd_ctrl_node *cmdnode;
-	unsigned long flags;
-	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!priv) {
-		lbs_deb_host("PREP_CMD: priv is NULL\n");
-		ret = -1;
-		goto done;
-	}
-
 	if (priv->surpriseremoved) {
 		lbs_deb_host("PREP_CMD: card removed\n");
-		ret = -1;
+		cmdnode = ERR_PTR(-ENOENT);
 		goto done;
 	}
 
@@ -2184,7 +2160,7 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 
 		/* Wake up main thread to execute next command */
 		wake_up_interruptible(&priv->waitq);
-		ret = -1;
+		cmdnode = ERR_PTR(-ENOBUFS);
 		goto done;
 	}
 
@@ -2210,6 +2186,29 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	lbs_queue_cmd(priv, cmdnode, 1);
 	wake_up_interruptible(&priv->waitq);
 
+ done:
+	lbs_deb_leave_args(LBS_DEB_HOST, "ret %p", cmdnode);
+	return cmdnode;
+}
+
+int __lbs_cmd(struct lbs_private *priv, uint16_t command,
+	      struct cmd_header *in_cmd, int in_cmd_size,
+	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
+	      unsigned long callback_arg)
+{
+	struct cmd_ctrl_node *cmdnode;
+	unsigned long flags;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_HOST);
+
+	cmdnode = __lbs_cmd_async(priv, command, in_cmd, in_cmd_size,
+				  callback, callback_arg);
+	if (IS_ERR(cmdnode)) {
+		ret = PTR_ERR(cmdnode);
+		goto done;
+	}
+
 	might_sleep();
 	wait_event_interruptible(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);
 
@@ -2218,6 +2217,7 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	if (ret)
 		lbs_pr_info("PREP_CMD: command 0x%04x failed: %d\n",
 			    command, ret);
+
 	__lbs_cleanup_and_insert_cmd(priv, cmdnode);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 999fabe..2f4c1ec 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -12,6 +12,12 @@
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
 
+/* __lbs_cmd() will free the cmdnode and return success/failure.
+   __lbs_cmd_async() requires that the callback free the cmdnode */
+struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv, uint16_t command,
+				      struct cmd_header *in_cmd, int in_cmd_size,
+				      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
+				      unsigned long callback_arg);
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      struct cmd_header *in_cmd, int in_cmd_size,
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
-- 
1.5.3.4

