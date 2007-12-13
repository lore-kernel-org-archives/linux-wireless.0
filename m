Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762772AbXLMG7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:20 -0500
Subject: [PATCH 59/48] libertas: clean up direct command handling
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2b-0005rj-0Q@shinybook.infradead.org> (sfid-20071213_065941_851164_87CEA08A)
Date: Thu, 13 Dec 2007 01:59:29 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 12:33:30 -0500

Move direct command handling through __lbs_cmd() over to using the
header as the first member of the command structure, and only define
the __lbs_cmd() callback in one place rather than 3.  Convert boot2
version command to new usage.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   22 ++++++++++++----------
 drivers/net/wireless/libertas/cmd.h     |    8 +++++---
 drivers/net/wireless/libertas/cmdresp.c |    7 ++++---
 drivers/net/wireless/libertas/hostcmd.h |   12 ++++++++++--
 4 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 2efba57..78870c7 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1988,12 +1988,13 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
  *                      the result code from the firmware
  */
 
-int __lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
-	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
+int __lbs_cmd(struct lbs_private *priv, uint16_t command,
+	      struct cmd_header *in_cmd, int in_cmd_size,
+	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	      unsigned long callback_arg)
 {
 	struct cmd_ctrl_node *cmdnode;
-	struct cmd_ds_gen *cmdptr;
+	struct cmd_header *send_cmd;
 	unsigned long flags;
 	int ret = 0;
 
@@ -2012,7 +2013,6 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_siz
 	}
 
 	cmdnode = lbs_get_cmd_ctrl_node(priv);
-
 	if (cmdnode == NULL) {
 		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
 
@@ -2022,18 +2022,20 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_siz
 		goto done;
 	}
 
-	cmdptr = (struct cmd_ds_gen *)cmdnode->bufvirtualaddr;
+	send_cmd = (struct cmd_header *) cmdnode->bufvirtualaddr;
 	cmdnode->wait_option = CMD_OPTION_WAITFORRSP;
 	cmdnode->callback = callback;
 	cmdnode->callback_arg = callback_arg;
 
+	/* Copy the incoming command to the buffer */
+	memcpy(send_cmd, in_cmd, in_cmd_size);
+
 	/* Set sequence number, clean result, move to buffer */
 	priv->seqnum++;
-	cmdptr->command = cpu_to_le16(command);
-	cmdptr->size    = cpu_to_le16(cmd_size + S_DS_GEN);
-	cmdptr->seqnum = cpu_to_le16(priv->seqnum);
-	cmdptr->result = 0;
-	memcpy(cmdptr->cmdresp, cmd, cmd_size);
+	send_cmd->command = cpu_to_le16(command);
+	send_cmd->size    = cpu_to_le16(in_cmd_size);
+	send_cmd->seqnum  = cpu_to_le16(priv->seqnum);
+	send_cmd->result  = 0;
 
 	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);
 
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 546db49..259d3e8 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -7,10 +7,12 @@
 #include "dev.h"
 
 #define lbs_cmd(priv, cmdnr, cmd, callback, callback_arg) \
-	__lbs_cmd(priv, cmdnr, &cmd, sizeof(cmd), callback, callback_arg)
+	__lbs_cmd(priv, cmdnr, (struct cmd_header *) &cmd, sizeof(cmd), \
+			callback, callback_arg)
 
-int __lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size, 
-	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_ds_command *),
+int __lbs_cmd(struct lbs_private *priv, uint16_t command,
+	      struct cmd_header *in_cmd, int in_cmd_size, 
+	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	      unsigned long callback_arg);
 
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 7bad257..9113669 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -861,9 +861,10 @@ int lbs_process_rx_command(struct lbs_private *priv)
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
-	if (priv->cur_cmd && priv->cur_cmd->callback)
-		ret = priv->cur_cmd->callback(priv, priv->cur_cmd->callback_arg, resp);
-	else
+	if (priv->cur_cmd && priv->cur_cmd->callback) {
+		ret = priv->cur_cmd->callback(priv, priv->cur_cmd->callback_arg,
+				(struct cmd_header *) resp);
+	} else
 		ret = handle_cmd_response(priv, 0, resp);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index ed502b7..93ac46a 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -65,13 +65,20 @@ struct rxpd {
 	u8 reserved[3];
 };
 
+struct cmd_header {
+	__le16 command;
+	__le16 size;
+	__le16 seqnum;
+	__le16 result;
+} __attribute__ ((packed));
+
 struct cmd_ctrl_node {
 	struct list_head list;
 	/* wait for finish or not */
 	u16 wait_option;
 	/* command response */
 	void *pdata_buf;
-	int (*callback)(struct lbs_private *priv, unsigned long arg, struct cmd_ds_command *resp);
+	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *);
 	unsigned long callback_arg;
 	/* command data */
 	u8 *bufvirtualaddr;
@@ -424,6 +431,8 @@ struct cmd_ds_802_11_monitor_mode {
 };
 
 struct cmd_ds_set_boot2_ver {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le16 version;
 };
@@ -678,7 +687,6 @@ struct cmd_ds_command {
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
 		struct cmd_ds_mesh_access mesh;
-		struct cmd_ds_set_boot2_ver boot2_ver;
 		struct cmd_ds_get_tsf gettsf;
 		struct cmd_ds_802_11_subscribe_event subscribe_event;
 		struct cmd_ds_802_11_beacon_control bcn_ctrl;
-- 
1.5.3.4

