Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22358 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYCRKWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 06:22:17 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: make a handy lbs_cmd_async() command
Date: Tue, 18 Mar 2008 11:19:22 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803181119.22293.hs4233@mail.mn-solutions.de> (sfid-20080318_102222_765464_FBA259A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-18 10:07:11.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-18 10:14:23.000000000 +0100
@@ -2040,10 +2040,27 @@ int lbs_cmd_copyback(struct lbs_private 
 }
 EXPORT_SYMBOL_GPL(lbs_cmd_copyback);
 
-struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv, uint16_t command,
-				      struct cmd_header *in_cmd, int in_cmd_size,
-				      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
-				      unsigned long callback_arg)
+/**
+ *  @brief Simple callback that ignores the result. Used if
+ *  we just want to send a command to the hardware, but don't
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
+static struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
+	uint16_t command, struct cmd_header *in_cmd, int in_cmd_size,
+	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
+	unsigned long callback_arg)
 {
 	struct cmd_ctrl_node *cmdnode;
 
@@ -2080,9 +2097,6 @@ struct cmd_ctrl_node *__lbs_cmd_async(st
 
 	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);
 
-	/* here was the big old switch() statement, which is now obsolete,
-	 * because the caller of lbs_cmd() sets up all of *cmd for us. */
-
 	cmdnode->cmdwaitqwoken = 0;
 	lbs_queue_cmd(priv, cmdnode);
 	wake_up_interruptible(&priv->waitq);
@@ -2092,6 +2106,15 @@ struct cmd_ctrl_node *__lbs_cmd_async(st
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
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-03-18 10:07:11.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-03-18 10:09:21.000000000 +0100
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
