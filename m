Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19598 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbYCSTxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 2] libertas: make a handy lbs_cmd_async() command
Date: Wed, 19 Mar 2008 10:11:00 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803181119.22293.hs4233@mail.mn-solutions.de>
In-Reply-To: <200803181119.22293.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803191011.00430.hs4233@mail.mn-solutions.de> (sfid-20080319_195417_653773_E09CF586)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This uses a static lbs_cmd_async_callback function, which is a
noop. Just setting the callback argument to __lbs_cmd_async()
to NULL won't work, because then the cmdnode wouldn't be
released.

This also makes __lbs_cmd_async() a static method, which is
now only used by lbs_cmd() and lbs_cmd_async().

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


---

This patch is needed to fix the CMD_MAC_CONTROL bug correcly.

Compared with "take 1", this patch doesn't leak cmd_ctrl_node's
anymore.


[PATCH] libertas: make a handy lbs_cmd_async() command

This uses a static lbs_cmd_async_callback function, which is a noop. Just
setting the callback argument to __lbs_cmd_async() to NULL won't work,
because then the cmdnode wouldn't be released.

This also makes __lbs_cmd_async() a static method, which is now only used by
lbs_cmd() and lbs_cmd_async().

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

This patch is needed to fix the CMD_MAC_CONTROL bug correcly. Patch for this
follows in the next mail.

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-19 09:04:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-19 09:05:25.000000000 +0100
@@ -20,6 +20,46 @@ static void lbs_set_cmd_ctrl_node(struct
 
 
 /**
+ *  @brief Simple callback that copies response back into command
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param extra  	A pointer to the original command structure for which
+ *                      'resp' is a response
+ *  @param resp         A pointer to the command response
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
+		     struct cmd_header *resp)
+{
+	struct cmd_header *buf = (void *)extra;
+	uint16_t copy_len;
+
+	copy_len = min(le16_to_cpu(buf->size), le16_to_cpu(resp->size));
+	memcpy(buf, resp, copy_len);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lbs_cmd_copyback);
+
+/**
+ *  @brief Simple callback that ignores the result. Use this if
+ *  you just want to send a command to the hardware, but don't
+ *  care for the result.
+ *
+ *  @param priv         ignored
+ *  @param extra        ignored
+ *  @param resp         ignored
+ *
+ *  @return 	   	0 for success
+ */
+static int lbs_cmd_async_callback(struct lbs_private *priv, unsigned long extra,
+		     struct cmd_header *resp)
+{
+	return 0;
+}
+
+
+/**
  *  @brief Checks whether a command is allowed in Power Save mode
  *
  *  @param command the command ID
@@ -1242,7 +1282,7 @@ void lbs_complete_command(struct lbs_pri
 	cmd->cmdwaitqwoken = 1;
 	wake_up_interruptible(&cmd->cmdwait_q);
 
-	if (!cmd->callback)
+	if (!cmd->callback || cmd->callback == lbs_cmd_async_callback)
 		__lbs_cleanup_and_insert_cmd(priv, cmd);
 	priv->cur_cmd = NULL;
 }
@@ -2018,32 +2058,10 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 }
 
 
-/**
- *  @brief Simple callback that copies response back into command
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param extra  	A pointer to the original command structure for which
- *                      'resp' is a response
- *  @param resp         A pointer to the command response
- *
- *  @return 	   	0 on success, error on failure
- */
-int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
-		     struct cmd_header *resp)
-{
-	struct cmd_header *buf = (void *)extra;
-	uint16_t copy_len;
-
-	copy_len = min(le16_to_cpu(buf->size), le16_to_cpu(resp->size));
-	memcpy(buf, resp, copy_len);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(lbs_cmd_copyback);
-
-struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv, uint16_t command,
-				      struct cmd_header *in_cmd, int in_cmd_size,
-				      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
-				      unsigned long callback_arg)
+static struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
+	uint16_t command, struct cmd_header *in_cmd, int in_cmd_size,
+	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
+	unsigned long callback_arg)
 {
 	struct cmd_ctrl_node *cmdnode;
 
@@ -2080,9 +2098,6 @@ struct cmd_ctrl_node *__lbs_cmd_async(st
 
 	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);
 
-	/* here was the big old switch() statement, which is now obsolete,
-	 * because the caller of lbs_cmd() sets up all of *cmd for us. */
-
 	cmdnode->cmdwaitqwoken = 0;
 	lbs_queue_cmd(priv, cmdnode);
 	wake_up_interruptible(&priv->waitq);
@@ -2092,6 +2107,15 @@ struct cmd_ctrl_node *__lbs_cmd_async(st
 	return cmdnode;
 }
 
+void lbs_cmd_async(struct lbs_private *priv, uint16_t command,
+	struct cmd_header *in_cmd, int in_cmd_size)
+{
+	lbs_deb_enter(LBS_DEB_CMD);
+	__lbs_cmd_async(priv, command, in_cmd, in_cmd_size,
+		lbs_cmd_async_callback, 0);
+	lbs_deb_leave(LBS_DEB_CMD);
+}
+
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      struct cmd_header *in_cmd, int in_cmd_size,
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
Index: wireless-testing/drivers/net/wireless/libertas/cmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-03-19 09:04:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-03-19 09:04:46.000000000 +0100
@@ -18,12 +18,9 @@
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
 
-/* __lbs_cmd() will free the cmdnode and return success/failure.
-   __lbs_cmd_async() requires that the callback free the cmdnode */
-struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv, uint16_t command,
-				      struct cmd_header *in_cmd, int in_cmd_size,
-				      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
-				      unsigned long callback_arg);
+void lbs_cmd_async(struct lbs_private *priv, uint16_t command,
+	struct cmd_header *in_cmd, int in_cmd_size);
+
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      struct cmd_header *in_cmd, int in_cmd_size,
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
