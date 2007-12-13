Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762776AbXLMG7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:31 -0500
Subject: [PATCH 65/48] libertas: rename and re-type bufvirtualaddr to cmdbuf
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2l-0005sD-0h@shinybook.infradead.org> (sfid-20071213_070017_951344_A9D892A2)
Date: Thu, 13 Dec 2007 01:59:39 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 13:49:39 -0500

Make it a struct cmd_header, since that's what it is, and clean up
the places that it's used.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |  133 +++++++++++++------------------
 drivers/net/wireless/libertas/cmdresp.c |   14 ++--
 drivers/net/wireless/libertas/defs.h    |    4 +-
 drivers/net/wireless/libertas/hostcmd.h |    2 +-
 drivers/net/wireless/libertas/if_cs.c   |    4 +-
 drivers/net/wireless/libertas/if_sdio.c |    4 +-
 drivers/net/wireless/libertas/if_usb.c  |    4 +-
 drivers/net/wireless/libertas/main.c    |   14 ++--
 8 files changed, 79 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index bb940cc..79a8d0d 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1028,24 +1028,18 @@ void lbs_queue_cmd(struct lbs_private *priv,
 	u8 addtail)
 {
 	unsigned long flags;
-	struct cmd_ds_command *cmdptr;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!cmdnode) {
-		lbs_deb_host("QUEUE_CMD: cmdnode is NULL\n");
-		goto done;
-	}
-
-	cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
-	if (!cmdptr) {
-		lbs_deb_host("QUEUE_CMD: cmdptr is NULL\n");
+	if (!cmdnode || !cmdnode->cmdbuf) {
+		lbs_deb_host("QUEUE_CMD: cmdnode or cmdbuf is NULL\n");
 		goto done;
 	}
 
 	/* Exit_PS command needs to be queued in the header always. */
-	if (le16_to_cpu(cmdptr->command) == CMD_802_11_PS_MODE) {
-		struct cmd_ds_802_11_ps_mode *psm = &cmdptr->params.psmode;
+	if (le16_to_cpu(cmdnode->cmdbuf->command) == CMD_802_11_PS_MODE) {
+		struct cmd_ds_802_11_ps_mode *psm = (void *) cmdnode->cmdbuf;
+
 		if (psm->action == cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 			if (priv->psstate != PS_STATE_FULL_POWER)
 				addtail = 0;
@@ -1062,7 +1056,7 @@ void lbs_queue_cmd(struct lbs_private *priv,
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	lbs_deb_host("QUEUE_CMD: inserted command 0x%04x into cmdpendingq\n",
-	       le16_to_cpu(((struct cmd_ds_gen*)cmdnode->bufvirtualaddr)->command));
+	       le16_to_cpu(cmdnode->cmdbuf->command));
 
 done:
 	lbs_deb_leave(LBS_DEB_HOST);
@@ -1079,7 +1073,7 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 				    struct cmd_ctrl_node *cmdnode)
 {
 	unsigned long flags;
-	struct cmd_ds_command *cmdptr;
+	struct cmd_header *cmd;
 	int ret = -1;
 	u16 cmdsize;
 	u16 command;
@@ -1091,10 +1085,10 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 		goto done;
 	}
 
-	cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
+	cmd = cmdnode->cmdbuf;
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
-	if (!cmdptr || !cmdptr->size) {
+	if (!cmd || !cmd->size) {
 		lbs_deb_host("DNLD_CMD: cmdptr is NULL or zero\n");
 		__lbs_cleanup_and_insert_cmd(priv, cmdnode);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -1105,16 +1099,16 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 	priv->cur_cmd_retcode = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
-	cmdsize = le16_to_cpu(cmdptr->size);
-	command = le16_to_cpu(cmdptr->command);
+	cmdsize = le16_to_cpu(cmd->size);
+	command = le16_to_cpu(cmd->command);
 
 	lbs_deb_host("DNLD_CMD: command 0x%04x, size %d, jiffies %lu\n",
 		    command, cmdsize, jiffies);
-	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", cmdnode->bufvirtualaddr, cmdsize);
+	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
 
 	cmdnode->cmdwaitqwoken = 0;
 
-	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmdptr, cmdsize);
+	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
 
 	if (ret != 0) {
 		lbs_deb_host("DNLD_CMD: hw_host_to_card failed\n");
@@ -1265,7 +1259,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 
 	lbs_set_cmd_ctrl_node(priv, cmdnode, wait_option, pdata_buf);
 
-	cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
+	cmdptr = (struct cmd_ds_command *)cmdnode->cmdbuf;
 
 	lbs_deb_host("PREP_CMD: command 0x%04x\n", cmd_no);
 
@@ -1556,41 +1550,35 @@ EXPORT_SYMBOL_GPL(lbs_prepare_and_send_command);
 int lbs_allocate_cmd_buffer(struct lbs_private *priv)
 {
 	int ret = 0;
-	u32 ulbufsize;
+	u32 bufsize;
 	u32 i;
-	struct cmd_ctrl_node *tempcmd_array;
-	u8 *ptempvirtualaddr;
+	struct cmd_ctrl_node *cmdarray;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	/* Allocate and initialize cmdCtrlNode */
-	ulbufsize = sizeof(struct cmd_ctrl_node) * MRVDRV_NUM_OF_CMD_BUFFER;
-
-	if (!(tempcmd_array = kzalloc(ulbufsize, GFP_KERNEL))) {
+	/* Allocate and initialize the command array */
+	bufsize = sizeof(struct cmd_ctrl_node) * LBS_NUM_CMD_BUFFERS;
+	if (!(cmdarray = kzalloc(bufsize, GFP_KERNEL))) {
 		lbs_deb_host("ALLOC_CMD_BUF: tempcmd_array is NULL\n");
 		ret = -1;
 		goto done;
 	}
-	priv->cmd_array = tempcmd_array;
+	priv->cmd_array = cmdarray;
 
-	/* Allocate and initialize command buffers */
-	ulbufsize = MRVDRV_SIZE_OF_CMD_BUFFER;
-	for (i = 0; i < MRVDRV_NUM_OF_CMD_BUFFER; i++) {
-		if (!(ptempvirtualaddr = kzalloc(ulbufsize, GFP_KERNEL))) {
+	/* Allocate and initialize each command buffer in the command array */
+	for (i = 0; i < LBS_NUM_CMD_BUFFERS; i++) {
+		cmdarray[i].cmdbuf = kzalloc(LBS_CMD_BUFFER_SIZE, GFP_KERNEL);
+		if (!cmdarray[i].cmdbuf) {
 			lbs_deb_host("ALLOC_CMD_BUF: ptempvirtualaddr is NULL\n");
 			ret = -1;
 			goto done;
 		}
-
-		/* Update command buffer virtual */
-		tempcmd_array[i].bufvirtualaddr = ptempvirtualaddr;
 	}
 
-	for (i = 0; i < MRVDRV_NUM_OF_CMD_BUFFER; i++) {
-		init_waitqueue_head(&tempcmd_array[i].cmdwait_q);
-		lbs_cleanup_and_insert_cmd(priv, &tempcmd_array[i]);
+	for (i = 0; i < LBS_NUM_CMD_BUFFERS; i++) {
+		init_waitqueue_head(&cmdarray[i].cmdwait_q);
+		lbs_cleanup_and_insert_cmd(priv, &cmdarray[i]);
 	}
-
 	ret = 0;
 
 done:
@@ -1606,9 +1594,8 @@ done:
  */
 int lbs_free_cmd_buffer(struct lbs_private *priv)
 {
-	u32 ulbufsize; /* Someone needs to die for this. Slowly and painfully */
+	struct cmd_ctrl_node *cmdarray;
 	unsigned int i;
-	struct cmd_ctrl_node *tempcmd_array;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -1618,14 +1605,13 @@ int lbs_free_cmd_buffer(struct lbs_private *priv)
 		goto done;
 	}
 
-	tempcmd_array = priv->cmd_array;
+	cmdarray = priv->cmd_array;
 
 	/* Release shared memory buffers */
-	ulbufsize = MRVDRV_SIZE_OF_CMD_BUFFER;
-	for (i = 0; i < MRVDRV_NUM_OF_CMD_BUFFER; i++) {
-		if (tempcmd_array[i].bufvirtualaddr) {
-			kfree(tempcmd_array[i].bufvirtualaddr);
-			tempcmd_array[i].bufvirtualaddr = NULL;
+	for (i = 0; i < LBS_NUM_CMD_BUFFERS; i++) {
+		if (cmdarray[i].cmdbuf) {
+			kfree(cmdarray[i].cmdbuf);
+			cmdarray[i].cmdbuf = NULL;
 		}
 	}
 
@@ -1683,21 +1669,21 @@ struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
  *  @param ptempnode	A pointer to cmdCtrlNode structure
  *  @return 		n/a
  */
-static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
+static void cleanup_cmdnode(struct cmd_ctrl_node *cmdnode)
 {
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!ptempnode)
+	if (!cmdnode)
 		return;
-	ptempnode->cmdwaitqwoken = 1;
-	wake_up_interruptible(&ptempnode->cmdwait_q);
-	ptempnode->wait_option = 0;
-	ptempnode->pdata_buf = NULL;
-	ptempnode->callback = NULL;
-	ptempnode->callback_arg = 0;
+	cmdnode->cmdwaitqwoken = 1;
+	wake_up_interruptible(&cmdnode->cmdwait_q);
+	cmdnode->wait_option = 0;
+	cmdnode->pdata_buf = NULL;
+	cmdnode->callback = NULL;
+	cmdnode->callback_arg = 0;
 
-	if (ptempnode->bufvirtualaddr != NULL)
-		memset(ptempnode->bufvirtualaddr, 0, MRVDRV_SIZE_OF_CMD_BUFFER);
+	if (cmdnode->cmdbuf != NULL)
+		memset(cmdnode->cmdbuf, 0, LBS_CMD_BUFFER_SIZE);
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
@@ -1739,7 +1725,7 @@ void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 int lbs_execute_next_command(struct lbs_private *priv)
 {
 	struct cmd_ctrl_node *cmdnode = NULL;
-	struct cmd_ds_command *cmdptr;
+	struct cmd_header *cmd;
 	unsigned long flags;
 	int ret = 0;
 
@@ -1765,22 +1751,21 @@ int lbs_execute_next_command(struct lbs_private *priv)
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	if (cmdnode) {
-		cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
+		cmd = cmdnode->cmdbuf;
 
-		if (is_command_allowed_in_ps(le16_to_cpu(cmdptr->command))) {
+		if (is_command_allowed_in_ps(le16_to_cpu(cmd->command))) {
 			if ((priv->psstate == PS_STATE_SLEEP) ||
 			    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 				lbs_deb_host(
 				       "EXEC_NEXT_CMD: cannot send cmd 0x%04x in psstate %d\n",
-				       le16_to_cpu(cmdptr->command),
+				       le16_to_cpu(cmd->command),
 				       priv->psstate);
 				ret = -1;
 				goto done;
 			}
 			lbs_deb_host("EXEC_NEXT_CMD: OK to send command "
-			       "0x%04x in psstate %d\n",
-				    le16_to_cpu(cmdptr->command),
-				    priv->psstate);
+				     "0x%04x in psstate %d\n",
+				     le16_to_cpu(cmd->command), priv->psstate);
 		} else if (priv->psstate != PS_STATE_FULL_POWER) {
 			/*
 			 * 1. Non-PS command:
@@ -1793,8 +1778,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 			 * otherwise send this command down to firmware
 			 * immediately.
 			 */
-			if (cmdptr->command !=
-			    cpu_to_le16(CMD_802_11_PS_MODE)) {
+			if (cmd->command != cpu_to_le16(CMD_802_11_PS_MODE)) {
 				/*  Prepare to send Exit PS,
 				 *  this non PS command will be sent later */
 				if ((priv->psstate == PS_STATE_SLEEP)
@@ -1813,8 +1797,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				 * PS command. Ignore it if it is not Exit_PS.
 				 * otherwise send it down immediately.
 				 */
-				struct cmd_ds_802_11_ps_mode *psm =
-				    &cmdptr->params.psmode;
+				struct cmd_ds_802_11_ps_mode *psm = (void *)cmd;
 
 				lbs_deb_host(
 				       "EXEC_NEXT_CMD: PS cmd, action 0x%02x\n",
@@ -1848,7 +1831,7 @@ int lbs_execute_next_command(struct lbs_private *priv)
 		}
 		list_del(&cmdnode->list);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
-			    le16_to_cpu(cmdptr->command));
+			    le16_to_cpu(cmd->command));
 		DownloadcommandToStation(priv, cmdnode);
 	} else {
 		/*
@@ -2079,7 +2062,6 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      unsigned long callback_arg)
 {
 	struct cmd_ctrl_node *cmdnode;
-	struct cmd_header *send_cmd;
 	unsigned long flags;
 	int ret = 0;
 
@@ -2107,20 +2089,19 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 		goto done;
 	}
 
-	send_cmd = (struct cmd_header *) cmdnode->bufvirtualaddr;
 	cmdnode->wait_option = CMD_OPTION_WAITFORRSP;
 	cmdnode->callback = callback;
 	cmdnode->callback_arg = callback_arg;
 
 	/* Copy the incoming command to the buffer */
-	memcpy(send_cmd, in_cmd, in_cmd_size);
+	memcpy(cmdnode->cmdbuf, in_cmd, in_cmd_size);
 
 	/* Set sequence number, clean result, move to buffer */
 	priv->seqnum++;
-	send_cmd->command = cpu_to_le16(command);
-	send_cmd->size    = cpu_to_le16(in_cmd_size);
-	send_cmd->seqnum  = cpu_to_le16(priv->seqnum);
-	send_cmd->result  = 0;
+	cmdnode->cmdbuf->command = cpu_to_le16(command);
+	cmdnode->cmdbuf->size    = cpu_to_le16(in_cmd_size);
+	cmdnode->cmdbuf->seqnum  = cpu_to_le16(priv->seqnum);
+	cmdnode->cmdbuf->result  = 0;
 
 	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);
 
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 671e323..b4cd7b7 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -491,8 +491,9 @@ static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
 
 static inline int handle_cmd_response(struct lbs_private *priv,
 				      unsigned long dummy,
-				      struct cmd_ds_command *resp)
+				      struct cmd_header *cmd_response)
 {
+	struct cmd_ds_command *resp = (struct cmd_ds_command *) cmd_response;
 	int ret = 0;
 	unsigned long flags;
 	uint16_t respcmd = le16_to_cpu(resp->command);
@@ -673,7 +674,7 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 int lbs_process_rx_command(struct lbs_private *priv)
 {
 	u16 respcmd;
-	struct cmd_ds_command *resp;
+	struct cmd_header *resp;
 	int ret = 0;
 	ulong flags;
 	u16 result;
@@ -692,15 +693,14 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		goto done;
 	}
-	resp = (struct cmd_ds_command *)(priv->cur_cmd->bufvirtualaddr);
+	resp = priv->cur_cmd->cmdbuf;
 
 	respcmd = le16_to_cpu(resp->command);
 	result = le16_to_cpu(resp->result);
 
 	lbs_deb_host("CMD_RESP: response 0x%04x, size %d, jiffies %lu\n",
 		respcmd, priv->upld_len, jiffies);
-	lbs_deb_hex(LBS_DEB_HOST, "CMD_RESP", priv->cur_cmd->bufvirtualaddr,
-		    priv->upld_len);
+	lbs_deb_hex(LBS_DEB_HOST, "CMD_RESP", (void *) resp, priv->upld_len);
 
 	if (!(respcmd & 0x8000)) {
 		lbs_deb_host("invalid response!\n");
@@ -716,7 +716,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 	priv->cur_cmd_retcode = result;
 
 	if (respcmd == CMD_RET(CMD_802_11_PS_MODE)) {
-		struct cmd_ds_802_11_ps_mode *psmode = &resp->params.psmode;
+		struct cmd_ds_802_11_ps_mode *psmode = (void *) resp;
 		u16 action = le16_to_cpu(psmode->action);
 
 		lbs_deb_host(
@@ -796,7 +796,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 
 	if (priv->cur_cmd && priv->cur_cmd->callback) {
 		ret = priv->cur_cmd->callback(priv, priv->cur_cmd->callback_arg,
-				(struct cmd_header *) resp);
+				resp);
 	} else
 		ret = handle_cmd_response(priv, 0, resp);
 
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 04db6af..9b98ae7 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -132,8 +132,8 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 */
 
 #define MRVDRV_MAX_MULTICAST_LIST_SIZE	32
-#define MRVDRV_NUM_OF_CMD_BUFFER        10
-#define MRVDRV_SIZE_OF_CMD_BUFFER       (2 * 1024)
+#define LBS_NUM_CMD_BUFFERS             10
+#define LBS_CMD_BUFFER_SIZE             (2 * 1024)
 #define MRVDRV_MAX_CHANNEL_SIZE		14
 #define MRVDRV_ASSOCIATION_TIME_OUT	255
 #define MRVDRV_SNAP_HEADER_LEN          8
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index a87c217..e5e2106 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -81,7 +81,7 @@ struct cmd_ctrl_node {
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *);
 	unsigned long callback_arg;
 	/* command data */
-	u8 *bufvirtualaddr;
+	struct cmd_header *cmdbuf;
 	/* wait queue */
 	u16 cmdwaitqwoken;
 	wait_queue_head_t cmdwait_q;
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 2acbe5d..5814363 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -364,7 +364,7 @@ static int if_cs_receive_cmdres(struct lbs_private *priv, u8 *data, u32 *len)
 	}
 
 	*len = if_cs_read16(priv->card, IF_CS_C_CMD_LEN);
-	if ((*len == 0) || (*len > MRVDRV_SIZE_OF_CMD_BUFFER)) {
+	if ((*len == 0) || (*len > LBS_CMD_BUFFER_SIZE)) {
 		lbs_pr_err("card cmd buffer has invalid # of bytes (%d)\n", *len);
 		goto out;
 	}
@@ -683,7 +683,7 @@ sbi_get_int_status_exit:
 			cmdbuf = priv->upld_buf;
 			priv->hisregcpy &= ~IF_CS_C_S_RX_UPLD_RDY;
 		} else {
-			cmdbuf = priv->cur_cmd->bufvirtualaddr;
+			cmdbuf = (u8 *) priv->cur_cmd->cmdbuf;
 		}
 
 		ret = if_cs_receive_cmdres(priv, cmdbuf, &priv->upld_len);
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 94060da..85675c5 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -142,14 +142,14 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 		goto out;
 	}
 
-	if (size > MRVDRV_SIZE_OF_CMD_BUFFER) {
+	if (size > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_sdio("response packet too large (%d bytes)\n",
 			(int)size);
 		ret = -E2BIG;
 		goto out;
 	}
 
-	memcpy(card->priv->cur_cmd->bufvirtualaddr, buffer, size);
+	memcpy(card->priv->cur_cmd->cmdbuf, buffer, size);
 	card->priv->upld_len = size;
 
 	card->int_cause |= MRVDRV_CMD_UPLD_RDY;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index c94b6df..5f2d944 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -639,7 +639,7 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 				      struct lbs_private *priv)
 {
 	u8 *cmdbuf;
-	if (recvlength > MRVDRV_SIZE_OF_CMD_BUFFER) {
+	if (recvlength > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_usbd(&cardp->udev->dev,
 			    "The receive buffer is too large\n");
 		kfree_skb(skb);
@@ -656,7 +656,7 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 		cmdbuf = priv->upld_buf;
 		priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
 	} else
-		cmdbuf = priv->cur_cmd->bufvirtualaddr;
+		cmdbuf = (u8 *) priv->cur_cmd->cmdbuf;
 
 	cardp->usb_int_cause |= MRVDRV_CMD_UPLD_RDY;
 	priv->upld_len = (recvlength - MESSAGE_HEADER_LEN);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 212cce3..a081b91 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -890,23 +890,21 @@ done:
 static void command_timer_fn(unsigned long data)
 {
 	struct lbs_private *priv = (struct lbs_private *)data;
-	struct cmd_ctrl_node *ptempnode;
-	struct cmd_ds_command *cmd;
+	struct cmd_ctrl_node *node;
 	unsigned long flags;
 
-	ptempnode = priv->cur_cmd;
-	if (ptempnode == NULL) {
+	node = priv->cur_cmd;
+	if (node == NULL) {
 		lbs_deb_fw("ptempnode empty\n");
 		return;
 	}
 
-	cmd = (struct cmd_ds_command *)ptempnode->bufvirtualaddr;
-	if (!cmd) {
+	if (!node->cmdbuf) {
 		lbs_deb_fw("cmd is NULL\n");
 		return;
 	}
 
-	lbs_deb_fw("command_timer_fn fired, cmd %x\n", cmd->command);
+	lbs_deb_fw("command_timer_fn fired, cmd %x\n", node->cmdbuf->command);
 
 	if (!priv->fw_ready)
 		return;
@@ -916,7 +914,7 @@ static void command_timer_fn(unsigned long data)
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	lbs_deb_fw("re-sending same command because of timeout\n");
-	lbs_queue_cmd(priv, ptempnode, 0);
+	lbs_queue_cmd(priv, node, 0);
 
 	wake_up_interruptible(&priv->waitq);
 
-- 
1.5.3.4

