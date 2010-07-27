Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0G0SOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 14:14:16 -0400
Subject: [wt PATCH 14/16] libertas: kill unused
 lbs_prepare_and_send_command()
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:15:45 -0700
Message-ID: <1280261745.19686.39.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove last bits of indirect command code.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c     |  146 ++-----------------------------
 drivers/net/wireless/libertas/cmd.h     |    5 -
 drivers/net/wireless/libertas/cmdresp.c |    3 -
 drivers/net/wireless/libertas/dev.h     |    1 -
 4 files changed, 9 insertions(+), 146 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index f19a36f..4946bce 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -77,30 +77,6 @@ static u8 is_command_allowed_in_ps(u16 cmd)
 }
 
 /**
- *  @brief This function checks if the command is allowed.
- *
- *  @param priv         A pointer to lbs_private structure
- *  @return             allowed or not allowed.
- */
-
-static int lbs_is_cmd_allowed(struct lbs_private *priv)
-{
-	int ret = 1;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (!priv->is_auto_deep_sleep_enabled) {
-		if (priv->is_deep_sleep) {
-			lbs_deb_cmd("command not allowed in deep sleep\n");
-			ret = 0;
-		}
-	}
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return ret;
-}
-
-/**
  *  @brief Updates the hardware details like MAC address and regulatory region
  *
  *  @param priv    	A pointer to struct lbs_private structure
@@ -1000,7 +976,6 @@ static void lbs_submit_command(struct lbs_private *priv,
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	priv->cur_cmd = cmdnode;
-	priv->cur_cmd_retcode = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	cmdsize = le16_to_cpu(cmd->size);
@@ -1073,9 +1048,6 @@ static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 			  int result)
 {
-	if (cmd == priv->cur_cmd)
-		priv->cur_cmd_retcode = result;
-
 	cmd->result = result;
 	cmd->cmdwaitqwoken = 1;
 	wake_up_interruptible(&cmd->cmdwait_q);
@@ -1143,112 +1115,6 @@ void lbs_set_mac_control(struct lbs_private *priv)
 }
 
 /**
- *  @brief This function prepare the command before send to firmware.
- *
- *  @param priv		A pointer to struct lbs_private structure
- *  @param cmd_no	command number
- *  @param cmd_action	command action: GET or SET
- *  @param wait_option	wait option: wait response or not
- *  @param cmd_oid	cmd oid: treated as sub command
- *  @param pdata_buf	A pointer to informaion buffer
- *  @return 		0 or -1
- */
-int lbs_prepare_and_send_command(struct lbs_private *priv,
-			  u16 cmd_no,
-			  u16 cmd_action,
-			  u16 wait_option, u32 cmd_oid, void *pdata_buf)
-{
-	int ret = 0;
-	struct cmd_ctrl_node *cmdnode;
-	struct cmd_header *cmdptr;
-	unsigned long flags;
-
-	lbs_deb_enter(LBS_DEB_HOST);
-
-	if (!priv) {
-		lbs_deb_host("PREP_CMD: priv is NULL\n");
-		ret = -1;
-		goto done;
-	}
-
-	if (priv->surpriseremoved) {
-		lbs_deb_host("PREP_CMD: card removed\n");
-		ret = -1;
-		goto done;
-	}
-
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto done;
-	}
-
-	cmdnode = lbs_get_cmd_ctrl_node(priv);
-
-	if (cmdnode == NULL) {
-		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
-
-		/* Wake up main thread to execute next command */
-		wake_up_interruptible(&priv->waitq);
-		ret = -1;
-		goto done;
-	}
-
-	cmdnode->callback = NULL;
-	cmdnode->callback_arg = (unsigned long)pdata_buf;
-
-	cmdptr = (struct cmd_header *)cmdnode->cmdbuf;
-
-	lbs_deb_host("PREP_CMD: command 0x%04x\n", cmd_no);
-
-	/* Set sequence number, command and INT option */
-	priv->seqnum++;
-	cmdptr->seqnum = cpu_to_le16(priv->seqnum);
-
-	cmdptr->command = cpu_to_le16(cmd_no);
-	cmdptr->result = 0;
-
-	switch (cmd_no) {
-	default:
-		lbs_pr_err("PREP_CMD: unknown command 0x%04x\n", cmd_no);
-		ret = -1;
-		break;
-	}
-
-	/* return error, since the command preparation failed */
-	if (ret != 0) {
-		lbs_deb_host("PREP_CMD: command preparation failed\n");
-		lbs_cleanup_and_insert_cmd(priv, cmdnode);
-		ret = -1;
-		goto done;
-	}
-
-	cmdnode->cmdwaitqwoken = 0;
-
-	lbs_queue_cmd(priv, cmdnode);
-	wake_up_interruptible(&priv->waitq);
-
-	if (wait_option & CMD_OPTION_WAITFORRSP) {
-		lbs_deb_host("PREP_CMD: wait for response\n");
-		might_sleep();
-		wait_event_interruptible(cmdnode->cmdwait_q,
-					 cmdnode->cmdwaitqwoken);
-	}
-
-	spin_lock_irqsave(&priv->driver_lock, flags);
-	if (priv->cur_cmd_retcode) {
-		lbs_deb_host("PREP_CMD: command failed with return code %d\n",
-		       priv->cur_cmd_retcode);
-		priv->cur_cmd_retcode = 0;
-		ret = -1;
-	}
-	spin_unlock_irqrestore(&priv->driver_lock, flags);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
-	return ret;
-}
-
-/**
  *  @brief This function allocates the command buffer and link
  *  it to command free queue.
  *
@@ -1701,9 +1567,15 @@ struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 		goto done;
 	}
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		cmdnode = ERR_PTR(-EBUSY);
-		goto done;
+	/* No commands are allowed in Deep Sleep until we toggle the GPIO
+	 * to wake up the card and it has signaled that it's ready.
+	 */
+	if (!priv->is_auto_deep_sleep_enabled) {
+		if (priv->is_deep_sleep) {
+			lbs_deb_cmd("command not allowed in deep sleep\n");
+			cmdnode = ERR_PTR(-EBUSY);
+			goto done;
+		}
 	}
 
 	cmdnode = lbs_get_cmd_ctrl_node(priv);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 19b1f21..7109d6b 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -39,11 +39,6 @@ struct cmd_ctrl_node {
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
 
-int lbs_prepare_and_send_command(struct lbs_private *priv,
-	u16 cmd_no,
-	u16 cmd_action,
-	u16 wait_option, u32 cmd_oid, void *pdata_buf);
-
 void lbs_cmd_async(struct lbs_private *priv, uint16_t command,
 	struct cmd_header *in_cmd, int in_cmd_size);
 
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 83283b8..5e95da9 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -112,9 +112,6 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 	del_timer(&priv->command_timer);
 	priv->cmd_timed_out = 0;
 
-	/* Store the response code to cur_cmd_retcode. */
-	priv->cur_cmd_retcode = result;
-
 	if (respcmd == CMD_RET(CMD_802_11_PS_MODE)) {
 		struct cmd_ds_802_11_ps_mode *psmode = (void *) &resp[1];
 		u16 action = le16_to_cpu(psmode->action);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 556a9c3..85cdc9a 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -116,7 +116,6 @@ struct lbs_private {
 	int cmd_timed_out;
 
 	/* Command responses sent from the hardware to the driver */
-	int cur_cmd_retcode;
 	u8 resp_idx;
 	u8 resp_buf[2][LBS_UPLD_SIZE];
 	u32 resp_len[2];
-- 
1.7.1.1


