Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55265 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbXLJPpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:49 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 20/48] libertas: Switch to using a callback function pointer for commands
Message-Id: <E1J1kpP-0006lj-35@shinybook.infradead.org> (sfid-20071210_154553_599966_33DB00C6)
Date: Mon, 10 Dec 2007 10:45:55 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Fri, 7 Dec 2007 15:13:05 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   31 +++++++++++++++++++++++++------
 drivers/net/wireless/libertas/cmdresp.c |   23 ++++++++---------------
 drivers/net/wireless/libertas/hostcmd.h |    1 +
 3 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index b1ea878..ebfcb7b 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1659,7 +1659,8 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
 	wake_up_interruptible(&ptempnode->cmdwait_q);
 	ptempnode->wait_option = 0;
 	ptempnode->pdata_buf = NULL;
-	ptempnode->pdata_size = 0;
+	ptempnode->pdata_size = NULL;
+	ptempnode->callback = NULL;
 
 	if (ptempnode->bufvirtualaddr != NULL)
 		memset(ptempnode->bufvirtualaddr, 0, MRVDRV_SIZE_OF_CMD_BUFFER);
@@ -1687,7 +1688,8 @@ void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 
 	ptempnode->wait_option = wait_option;
 	ptempnode->pdata_buf = pdata_buf;
-	ptempnode->pdata_size = 0;
+	ptempnode->pdata_size = NULL;
+	ptempnode->callback = NULL;
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
@@ -2012,10 +2014,26 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
  *  @return 	   	-1 in case of a higher level error, otherwise
  *                      the result code from the firmware
  */
-int lbs_cmd(struct lbs_private *priv,
-	u16 command,
-	void *cmd, int cmd_size,
-	void *rsp, int *rsp_size)
+
+static int lbs_cmd_callback(uint16_t respcmd, struct cmd_ds_command *resp, struct lbs_private *priv)
+{ 
+	struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
+	struct lbs_adapter *adapter = priv->adapter;
+	u16 sz = cpu_to_le16(resp->size) - S_DS_GEN;
+
+	if (sz > *adapter->cur_cmd->pdata_size) {
+		lbs_pr_err("response 0x%04x doesn't fit into buffer (%d > %d)\n",
+			   respcmd, sz, *adapter->cur_cmd->pdata_size);
+		sz = *adapter->cur_cmd->pdata_size;
+	}
+	memcpy(adapter->cur_cmd->pdata_buf, r->cmdresp, sz);
+	*adapter->cur_cmd->pdata_size = sz;
+
+	return 0;
+}
+
+int lbs_cmd(struct lbs_private *priv, u16 command, void *cmd, int cmd_size,
+	    void *rsp, int *rsp_size)
 {
 	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmdnode;
@@ -2053,6 +2071,7 @@ int lbs_cmd(struct lbs_private *priv,
 	cmdnode->wait_option = CMD_OPTION_WAITFORRSP;
 	cmdnode->pdata_buf = rsp;
 	cmdnode->pdata_size = rsp_size;
+	cmdnode->callback = lbs_cmd_callback;
 
 	/* Set sequence number, clean result, move to buffer */
 	adapter->seqnum++;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 22a6973..20ca38c 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -880,22 +880,15 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		goto done;
 	}
 
-	if (adapter->cur_cmd->pdata_size) {
-		struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
-		u16 sz = cpu_to_le16(resp->size) - S_DS_GEN;
-		if (sz > *adapter->cur_cmd->pdata_size) {
-			lbs_pr_err("response 0x%04x doesn't fit into "
-				"buffer (%d > %d)\n", respcmd,
-				sz, *adapter->cur_cmd->pdata_size);
-			sz = *adapter->cur_cmd->pdata_size;
-		}
-		memcpy(adapter->cur_cmd->pdata_buf, r->cmdresp, sz);
-		*adapter->cur_cmd->pdata_size = sz;
-	} else {
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+
+	if (adapter->cur_cmd && adapter->cur_cmd->callback)
+		ret = adapter->cur_cmd->callback(respcmd, resp, priv);
+	else
 		ret = handle_cmd_response(respcmd, resp, priv);
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-	}
+
+	spin_lock_irqsave(&adapter->driver_lock, flags);
+
 	if (adapter->cur_cmd) {
 		/* Clean up and Put current command back to cmdfreeq */
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index be69ae6..5ef65ae 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -72,6 +72,7 @@ struct cmd_ctrl_node {
 	/* command response */
 	void *pdata_buf;
 	int *pdata_size;
+	int (*callback)(uint16_t respcmd, struct cmd_ds_command *resp, struct lbs_private *priv);
 	/* command data */
 	u8 *bufvirtualaddr;
 	/* wait queue */
-- 
1.5.3.4

