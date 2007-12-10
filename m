Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55279 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXLJPp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:59 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 25/48] libertas: switch lbs_cmd() to take a callback function pointer
Message-Id: <E1J1kpU-0006m8-BU@shinybook.infradead.org> (sfid-20071210_154602_369758_0FA87665)
Date: Mon, 10 Dec 2007 10:46:00 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 00:59:54 +0000

All existing code which sends commands is set up to have some function
called with the results, not to get data back. It's more versatile this
way, and providing it with a callback function which involves memcpy()
is hardly difficult.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   30 ++++--------------------------
 drivers/net/wireless/libertas/decl.h    |    6 ++----
 drivers/net/wireless/libertas/hostcmd.h |    1 -
 drivers/net/wireless/libertas/if_usb.c  |    5 +----
 4 files changed, 7 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 092c295..6838c9c 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1657,7 +1657,6 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
 	wake_up_interruptible(&ptempnode->cmdwait_q);
 	ptempnode->wait_option = 0;
 	ptempnode->pdata_buf = NULL;
-	ptempnode->pdata_size = NULL;
 	ptempnode->callback = NULL;
 
 	if (ptempnode->bufvirtualaddr != NULL)
@@ -1686,7 +1685,6 @@ void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 
 	ptempnode->wait_option = wait_option;
 	ptempnode->pdata_buf = pdata_buf;
-	ptempnode->pdata_size = NULL;
 	ptempnode->callback = NULL;
 
 	lbs_deb_leave(LBS_DEB_HOST);
@@ -2013,25 +2011,8 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
  *                      the result code from the firmware
  */
 
-static int lbs_cmd_callback(uint16_t respcmd, struct cmd_ds_command *resp, struct lbs_private *priv)
-{ 
-	struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
-	struct lbs_adapter *adapter = priv->adapter;
-	u16 sz = le16_to_cpu(resp->size) - S_DS_GEN;
-
-	if (sz > *adapter->cur_cmd->pdata_size) {
-		lbs_pr_err("response 0x%04x doesn't fit into buffer (%d > %d)\n",
-			   respcmd, sz, *adapter->cur_cmd->pdata_size);
-		sz = *adapter->cur_cmd->pdata_size;
-	}
-	memcpy(adapter->cur_cmd->pdata_buf, r->cmdresp, sz);
-	*adapter->cur_cmd->pdata_size = sz;
-
-	return 0;
-}
-
-int lbs_cmd(struct lbs_private *priv, u16 command, void *cmd, int cmd_size,
-	    void *rsp, int *rsp_size)
+int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
+	    int (*callback)(uint16_t, struct cmd_ds_command *, struct lbs_private *))
 {
 	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmdnode;
@@ -2040,9 +2021,8 @@ int lbs_cmd(struct lbs_private *priv, u16 command, void *cmd, int cmd_size,
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_HOST);
-	lbs_deb_host("rsp at %p, rsp_size at %p\n", rsp, rsp_size);
 
-	if (!adapter || !rsp_size) {
+	if (!adapter) {
 		lbs_deb_host("PREP_CMD: adapter is NULL\n");
 		ret = -1;
 		goto done;
@@ -2067,9 +2047,7 @@ int lbs_cmd(struct lbs_private *priv, u16 command, void *cmd, int cmd_size,
 
 	cmdptr = (struct cmd_ds_gen *)cmdnode->bufvirtualaddr;
 	cmdnode->wait_option = CMD_OPTION_WAITFORRSP;
-	cmdnode->pdata_buf = rsp;
-	cmdnode->pdata_size = rsp_size;
-	cmdnode->callback = lbs_cmd_callback;
+	cmdnode->callback = callback;
 
 	/* Set sequence number, clean result, move to buffer */
 	adapter->seqnum++;
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 6f47ff0..1a8fdaa 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -24,10 +24,8 @@ void lbs_send_tx_feedback(struct lbs_private *priv);
 
 int lbs_free_cmd_buffer(struct lbs_private *priv);
 
-int lbs_cmd(struct lbs_private *priv,
-	u16 command,
-	void *cmd, int cmd_size,
-	void *resp, int *resp_size);
+int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size, 
+	    int (*callback)(uint16_t, struct cmd_ds_command *, struct lbs_private *));
 
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index efdb720..f1c1d3f 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -71,7 +71,6 @@ struct cmd_ctrl_node {
 	u16 wait_option;
 	/* command response */
 	void *pdata_buf;
-	int *pdata_size;
 	int (*callback)(uint16_t respcmd, struct cmd_ds_command *resp, struct lbs_private *priv);
 	/* command data */
 	u8 *bufvirtualaddr;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index a17371f..7c4bd8d 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -104,15 +104,12 @@ static void if_usb_free(struct usb_card_rec *cardp)
 static void if_usb_set_boot2_ver(struct lbs_private *priv)
 {
 	struct cmd_ds_set_boot2_ver b2_cmd;
-	int rsp_len = sizeof(b2_cmd);
 
 	b2_cmd.action = 0;
 	b2_cmd.version = priv->boot2_version;
 
-	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd),
-		    &b2_cmd, &rsp_len)) {
+	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd), NULL))
 		lbs_deb_usb("Setting boot2 version failed\n");
-	}
 }
 
 
-- 
1.5.3.4

