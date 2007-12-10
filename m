Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55249 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXLJPpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:41 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 08/48] libertas: handy function to call firmware commands
Message-Id: <E1J1kpC-0006kl-Gd@shinybook.infradead.org> (sfid-20071210_154545_989995_3DBA5DCE)
Date: Mon, 10 Dec 2007 10:45:42 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <h.schurig@mn-solutions.de>
Date: Wed, 5 Dec 2007 17:58:11 +0100

Using an arbitrary firmware command was actually very painful. One
had to change big switch() statements in cmd.c, cmdresp.c, add
structs to the big union in "struct cmd_ds_command" and add the
define for the CMD_802_11_xxx to the proper place.

With this function, this is now much easier. For now, it implements
a blocking (a.k.a. CMD_OPTION_WAITFORRSP) way where one deals directly
with command requests and response buffers. You can do everything in
one place:

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   96 +++++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/cmdresp.c |   23 ++++++--
 drivers/net/wireless/libertas/decl.h    |    6 ++
 drivers/net/wireless/libertas/hostcmd.h |   11 ++-
 4 files changed, 126 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 54ef990..9064513 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -2007,3 +2007,99 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
+
+
+/**
+ *  @brief Simple way to call firmware functions
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param psmode  	one of the many CMD_802_11_xxxx
+ *  @param cmd          pointer to the parameters structure for above command
+ *                      (this should not include the command, size, sequence
+ *                      and result fields from struct cmd_ds_gen)
+ *  @param cmd_size     size structure pointed to by cmd
+ *  @param rsp          pointer to an area where the result should be placed
+ *  @param rsp_size     pointer to the size of the rsp area. If the firmware
+ *                      returns fewer bytes, then this *rsp_size will be
+ *                      changed to the actual size.
+ *  @return 	   	-1 in case of a higher level error, otherwise
+ *                      the result code from the firmware
+ */
+int lbs_cmd(struct lbs_private *priv,
+	u16 command,
+	void *cmd, int cmd_size,
+	void *rsp, int *rsp_size)
+{
+	struct lbs_adapter *adapter = priv->adapter;
+	struct cmd_ctrl_node *cmdnode;
+	struct cmd_ds_gen *cmdptr;
+	unsigned long flags;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_HOST);
+	lbs_deb_host("rsp at %p, rsp_size at %p\n", rsp, rsp_size);
+
+	if (!adapter || !rsp_size) {
+		lbs_deb_host("PREP_CMD: adapter is NULL\n");
+		ret = -1;
+		goto done;
+	}
+
+	if (adapter->surpriseremoved) {
+		lbs_deb_host("PREP_CMD: card removed\n");
+		ret = -1;
+		goto done;
+	}
+
+	cmdnode = lbs_get_cmd_ctrl_node(priv);
+
+	if (cmdnode == NULL) {
+		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
+
+		/* Wake up main thread to execute next command */
+		wake_up_interruptible(&priv->waitq);
+		ret = -1;
+		goto done;
+	}
+
+	cmdptr = (struct cmd_ds_gen *)cmdnode->bufvirtualaddr;
+	cmdnode->wait_option = CMD_OPTION_WAITFORRSP;
+	cmdnode->pdata_buf = rsp;
+	cmdnode->pdata_size = rsp_size;
+
+	/* Set sequence number, clean result, move to buffer */
+	adapter->seqnum++;
+	cmdptr->command = cpu_to_le16(command);
+	cmdptr->size    = cmd_size + S_DS_GEN;
+	cmdptr->seqnum = cpu_to_le16(adapter->seqnum);
+	cmdptr->result = 0;
+	memcpy(cmdptr->cmdresp, cmd, cmd_size);
+
+	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);
+
+	/* here was the big old switch() statement, which is now obsolete,
+	 * because the caller of lbs_cmd() sets up all of *cmd for us. */
+
+	cmdnode->cmdwaitqwoken = 0;
+	lbs_queue_cmd(adapter, cmdnode, 1);
+	wake_up_interruptible(&priv->waitq);
+
+	might_sleep();
+	wait_event_interruptible(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);
+
+	spin_lock_irqsave(&adapter->driver_lock, flags);
+	if (adapter->cur_cmd_retcode) {
+		lbs_deb_host("PREP_CMD: command failed with return code %d\n",
+		       adapter->cur_cmd_retcode);
+		adapter->cur_cmd_retcode = 0;
+		ret = -1;
+	}
+	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+
+done:
+	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lbs_cmd);
+
+
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index cbd28ee..6a43de7 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -799,7 +799,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 	}
 
 	/* Store the response code to cur_cmd_retcode. */
-	adapter->cur_cmd_retcode = result;;
+	adapter->cur_cmd_retcode = result;
 
 	if (respcmd == CMD_RET(CMD_802_11_PS_MODE)) {
 		struct cmd_ds_802_11_ps_mode *psmode = &resp->params.psmode;
@@ -880,11 +880,22 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		goto done;
 	}
 
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
-
-	ret = handle_cmd_response(respcmd, resp, priv);
-
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	if (adapter->cur_cmd->pdata_size) {
+		struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
+		u16 sz = cpu_to_le16(resp->size);
+		if (sz > *adapter->cur_cmd->pdata_size) {
+			lbs_pr_err("response 0x%04x doesn't fit into "
+				"buffer (%d > %d)\n", respcmd,
+				sz, *adapter->cur_cmd->pdata_size);
+			sz = *adapter->cur_cmd->pdata_size;
+		}
+		memcpy(adapter->cur_cmd->pdata_buf, r->cmdresp, sz);
+		*adapter->cur_cmd->pdata_size = sz;
+	} else {
+		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		ret = handle_cmd_response(respcmd, resp, priv);
+		spin_lock_irqsave(&adapter->driver_lock, flags);
+	}
 	if (adapter->cur_cmd) {
 		/* Clean up and Put current command back to cmdfreeq */
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 0856cc9..6f47ff0 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -16,6 +16,7 @@ struct lbs_adapter;
 struct sk_buff;
 struct net_device;
 struct cmd_ctrl_node;
+struct cmd_ds_command;
 
 int lbs_set_mac_packet_filter(struct lbs_private *priv);
 
@@ -23,6 +24,11 @@ void lbs_send_tx_feedback(struct lbs_private *priv);
 
 int lbs_free_cmd_buffer(struct lbs_private *priv);
 
+int lbs_cmd(struct lbs_private *priv,
+	u16 command,
+	void *cmd, int cmd_size,
+	void *resp, int *resp_size);
+
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
 	u16 cmd_action,
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index f096d99..be69ae6 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -66,13 +66,13 @@ struct rxpd {
 };
 
 struct cmd_ctrl_node {
-	/* CMD link list */
 	struct list_head list;
-	/*CMD wait option: wait for finish or no wait */
+	/* wait for finish or not */
 	u16 wait_option;
-	/* command parameter */
+	/* command response */
 	void *pdata_buf;
-	/*command data */
+	int *pdata_size;
+	/* command data */
 	u8 *bufvirtualaddr;
 	/* wait queue */
 	u16 cmdwaitqwoken;
@@ -100,9 +100,12 @@ struct cmd_ds_gen {
 	__le16 size;
 	__le16 seqnum;
 	__le16 result;
+	void *cmdresp[0];
 };
 
 #define S_DS_GEN sizeof(struct cmd_ds_gen)
+
+
 /*
  * Define data structure for CMD_GET_HW_SPEC
  * This structure defines the response for the GET_HW_SPEC command
-- 
1.5.3.4

