Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762763AbXLMG7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:17 -0500
Subject: [PATCH 50/48] libertas: add opaque extra argument to cmd callback function
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2R-0005qs-9z@shinybook.infradead.org> (sfid-20071213_065939_401295_BA17FB37)
Date: Thu, 13 Dec 2007 01:59:19 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 13:36:10 -0500

This will be useful for letting callbacks do stuff like copying the
response into a buffer provided by the caller of lbs_cmd()

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    6 +++++-
 drivers/net/wireless/libertas/cmdresp.c |   11 ++++++-----
 drivers/net/wireless/libertas/decl.h    |    3 ++-
 drivers/net/wireless/libertas/hostcmd.h |    3 ++-
 drivers/net/wireless/libertas/if_usb.c  |    2 +-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 49a9aee..228e3fe 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1642,6 +1642,7 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
 	ptempnode->wait_option = 0;
 	ptempnode->pdata_buf = NULL;
 	ptempnode->callback = NULL;
+	ptempnode->callback_arg = 0;
 
 	if (ptempnode->bufvirtualaddr != NULL)
 		memset(ptempnode->bufvirtualaddr, 0, MRVDRV_SIZE_OF_CMD_BUFFER);
@@ -1670,6 +1671,7 @@ void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 	ptempnode->wait_option = wait_option;
 	ptempnode->pdata_buf = pdata_buf;
 	ptempnode->callback = NULL;
+	ptempnode->callback_arg = 0;
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
@@ -1993,7 +1995,8 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
  */
 
 int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
-	    int (*callback)(uint16_t, struct cmd_ds_command *, struct lbs_private *))
+	    int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
+	    unsigned long callback_arg)
 {
 	struct cmd_ctrl_node *cmdnode;
 	struct cmd_ds_gen *cmdptr;
@@ -2028,6 +2031,7 @@ int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
 	cmdptr = (struct cmd_ds_gen *)cmdnode->bufvirtualaddr;
 	cmdnode->wait_option = CMD_OPTION_WAITFORRSP;
 	cmdnode->callback = callback;
+	cmdnode->callback_arg = callback_arg;
 
 	/* Set sequence number, clean result, move to buffer */
 	priv->seqnum++;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index ab6e729..7bad257 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -552,12 +552,13 @@ static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
 	return 0;
 }
 
-static inline int handle_cmd_response(u16 respcmd,
-				      struct cmd_ds_command *resp,
-				      struct lbs_private *priv)
+static inline int handle_cmd_response(struct lbs_private *priv,
+				      unsigned long dummy,
+				      struct cmd_ds_command *resp)
 {
 	int ret = 0;
 	unsigned long flags;
+	uint16_t respcmd = le16_to_cpu(resp->command);
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -861,9 +862,9 @@ int lbs_process_rx_command(struct lbs_private *priv)
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	if (priv->cur_cmd && priv->cur_cmd->callback)
-		ret = priv->cur_cmd->callback(respcmd, resp, priv);
+		ret = priv->cur_cmd->callback(priv, priv->cur_cmd->callback_arg, resp);
 	else
-		ret = handle_cmd_response(respcmd, resp, priv);
+		ret = handle_cmd_response(priv, 0, resp);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index e8387c7..a086d0c 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -24,7 +24,8 @@ void lbs_send_tx_feedback(struct lbs_private *priv);
 int lbs_free_cmd_buffer(struct lbs_private *priv);
 
 int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size, 
-	    int (*callback)(uint16_t, struct cmd_ds_command *, struct lbs_private *));
+	    int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
+	    unsigned long callback_arg);
 
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index f1c1d3f..ed502b7 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -71,7 +71,8 @@ struct cmd_ctrl_node {
 	u16 wait_option;
 	/* command response */
 	void *pdata_buf;
-	int (*callback)(uint16_t respcmd, struct cmd_ds_command *resp, struct lbs_private *priv);
+	int (*callback)(struct lbs_private *priv, unsigned long arg, struct cmd_ds_command *resp);
+	unsigned long callback_arg;
 	/* command data */
 	u8 *bufvirtualaddr;
 	/* wait queue */
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 141d185..f59fd73 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -108,7 +108,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 	b2_cmd.action = 0;
 	b2_cmd.version = priv->boot2_version;
 
-	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd), NULL))
+	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd), NULL, 0))
 		lbs_deb_usb("Setting boot2 version failed\n");
 }
 
-- 
1.5.3.4

