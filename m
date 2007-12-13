Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55870 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762758AbXLMG7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:14 -0500
Subject: [PATCH 52/48] libertas: make lbs_cmd() usage nicer
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2T-0005r2-Eb@shinybook.infradead.org> (sfid-20071213_065938_031220_95FCFF96)
Date: Thu, 13 Dec 2007 01:59:21 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Mon, 10 Dec 2007 15:11:23 -0500

Define a macro that relieves the caller from having to use sizeof on
the command structure when calling lbs_cmd(), and move the prototype
of __lbs_cmd() to a new cmd.h file.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c    |    8 ++++----
 drivers/net/wireless/libertas/cmd.h    |   16 ++++++++++++++++
 drivers/net/wireless/libertas/decl.h   |    4 ----
 drivers/net/wireless/libertas/if_usb.c |    3 ++-
 4 files changed, 22 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/wireless/libertas/cmd.h

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 228e3fe..c7c226c 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1994,9 +1994,9 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
  *                      the result code from the firmware
  */
 
-int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
-	    int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
-	    unsigned long callback_arg)
+int __lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
+	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
+	      unsigned long callback_arg)
 {
 	struct cmd_ctrl_node *cmdnode;
 	struct cmd_ds_gen *cmdptr;
@@ -2066,6 +2066,6 @@ done:
 	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lbs_cmd);
+EXPORT_SYMBOL_GPL(__lbs_cmd);
 
 
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
new file mode 100644
index 0000000..546db49
--- /dev/null
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -0,0 +1,16 @@
+/* Copyright (C) 2007, Red Hat, Inc. */
+
+#ifndef _LBS_CMD_H_
+#define _LBS_CMD_H_
+
+#include "hostcmd.h"
+#include "dev.h"
+
+#define lbs_cmd(priv, cmdnr, cmd, callback, callback_arg) \
+	__lbs_cmd(priv, cmdnr, &cmd, sizeof(cmd), callback, callback_arg)
+
+int __lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size, 
+	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
+	      unsigned long callback_arg);
+
+#endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 82727a8..33c8305 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -23,10 +23,6 @@ void lbs_send_tx_feedback(struct lbs_private *priv);
 
 int lbs_free_cmd_buffer(struct lbs_private *priv);
 
-int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size, 
-	    int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
-	    unsigned long callback_arg);
-
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
 	u16 cmd_action,
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 1c23166..8ff57a6 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -13,6 +13,7 @@
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
+#include "cmd.h"
 #include "if_usb.h"
 
 #define MESSAGE_HEADER_LEN	4
@@ -108,7 +109,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 	b2_cmd.action = 0;
 	b2_cmd.version = priv->boot2_version;
 
-	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd), NULL, 0))
+	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, b2_cmd, NULL, 0))
 		lbs_deb_usb("Setting boot2 version failed\n");
 }
 
-- 
1.5.3.4

