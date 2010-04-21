Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47029 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0DUWku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 18:40:50 -0400
Received: by vws18 with SMTP id 18so405218vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 15:40:49 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, Steve deRosier <steve@cozybit.com>
Subject: [PATCH] Added configurable debug messages to libertastf
Date: Wed, 21 Apr 2010 15:39:41 -0700
Message-Id: <1271889581-21352-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the same type of configurable debug messages to libertas_tf as
already exist in the libertas driver.  This has facilitated creation of a interface
specification and will facilitate future development of this driver.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/Kconfig                |    6 +
 drivers/net/wireless/libertas_tf/cmd.c      |  203 +++++++++++++++++++----
 drivers/net/wireless/libertas_tf/deb_defs.h |  120 +++++++++++++
 drivers/net/wireless/libertas_tf/if_usb.c   |  242 +++++++++++++++++++++++----
 drivers/net/wireless/libertas_tf/main.c     |   87 +++++++++-
 5 files changed, 583 insertions(+), 75 deletions(-)
 create mode 100644 drivers/net/wireless/libertas_tf/deb_defs.h

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 77500cb..2fbe9b4 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -38,6 +38,12 @@ config LIBERTAS_THINFIRM
 	---help---
 	  A library for Marvell Libertas 8xxx devices using thinfirm.
 
+config LIBERTAS_THINFIRM_DEBUG
+	bool "Enable full debugging output in the Libertas thin firmware module."
+	depends on LIBERTAS_THINFIRM
+	---help---
+	  Debugging support.
+
 config LIBERTAS_THINFIRM_USB
 	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
 	depends on LIBERTAS_THINFIRM && USB
diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index b620daf..7c9dbae 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -11,6 +11,8 @@
 
 #include "libertas_tf.h"
 
+#include "deb_defs.h"
+
 static const struct channel_range channel_ranges[] = {
 	{ LBTF_REGDOMAIN_US,		1, 12 },
 	{ LBTF_REGDOMAIN_CA,		1, 12 },
@@ -82,6 +84,8 @@ int lbtf_update_hw_spec(struct lbtf_private *priv)
 	int ret = -1;
 	u32 i;
 
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	memcpy(cmd.permanentaddr, priv->current_addr, ETH_ALEN);
@@ -104,6 +108,8 @@ int lbtf_update_hw_spec(struct lbtf_private *priv)
 		priv->fwrelease >>  8 & 0xff,
 		priv->fwrelease       & 0xff,
 		priv->fwcapinfo);
+	lbtf_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
+		    cmd.hwifversion, cmd.version);
 
 	/* Clamp region code to 8-bit since FW spec indicates that it should
 	 * only ever be 8-bit, even though the field size is 16-bit.  Some
@@ -118,8 +124,10 @@ int lbtf_update_hw_spec(struct lbtf_private *priv)
 	}
 
 	/* if it's unidentified region code, use the default (USA) */
-	if (i >= MRVDRV_MAX_REGION_CODE)
+	if (i >= MRVDRV_MAX_REGION_CODE) {
 		priv->regioncode = 0x10;
+		lbtf_pr_info("unidentified region code; using the default (USA)\n");
+	}
 
 	if (priv->current_addr[0] == 0xff)
 		memmove(priv->current_addr, cmd.permanentaddr, ETH_ALEN);
@@ -128,6 +136,7 @@ int lbtf_update_hw_spec(struct lbtf_private *priv)
 
 	lbtf_geo_init(priv);
 out:
+	lbtf_deb_leave(LBTF_DEB_CMD);
 	return ret;
 }
 
@@ -141,13 +150,18 @@ out:
  */
 int lbtf_set_channel(struct lbtf_private *priv, u8 channel)
 {
+	int ret = 0;
 	struct cmd_ds_802_11_rf_channel cmd;
 
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_SET);
 	cmd.channel = cpu_to_le16(channel);
 
-	return lbtf_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, &cmd);
+	ret = lbtf_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, &cmd);
+	lbtf_deb_leave_args(LBTF_DEB_CMD, "ret %d", ret);
+	return ret;
 }
 
 int lbtf_beacon_set(struct lbtf_private *priv, struct sk_buff *beacon)
@@ -155,20 +169,28 @@ int lbtf_beacon_set(struct lbtf_private *priv, struct sk_buff *beacon)
 	struct cmd_ds_802_11_beacon_set cmd;
 	int size;
 
-	if (beacon->len > MRVL_MAX_BCN_SIZE)
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
+	if (beacon->len > MRVL_MAX_BCN_SIZE) {
+		lbtf_deb_leave_args(LBTF_DEB_CMD, "ret %d", -1);
 		return -1;
+	}
 	size =  sizeof(cmd) - sizeof(cmd.beacon) + beacon->len;
 	cmd.hdr.size = cpu_to_le16(size);
 	cmd.len = cpu_to_le16(beacon->len);
 	memcpy(cmd.beacon, (u8 *) beacon->data, beacon->len);
 
 	lbtf_cmd_async(priv, CMD_802_11_BEACON_SET, &cmd.hdr, size);
+
+	lbtf_deb_leave_args(LBTF_DEB_CMD, "ret %d", 0);
 	return 0;
 }
 
 int lbtf_beacon_ctrl(struct lbtf_private *priv, bool beacon_enable,
-		     int beacon_int) {
+		     int beacon_int)
+{
 	struct cmd_ds_802_11_beacon_control cmd;
+	lbtf_deb_enter(LBTF_DEB_CMD);
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
@@ -176,6 +198,8 @@ int lbtf_beacon_ctrl(struct lbtf_private *priv, bool beacon_enable,
 	cmd.beacon_period = cpu_to_le16(beacon_int);
 
 	lbtf_cmd_async(priv, CMD_802_11_BEACON_CTRL, &cmd.hdr, sizeof(cmd));
+
+	lbtf_deb_leave(LBTF_DEB_CMD);
 	return 0;
 }
 
@@ -183,17 +207,28 @@ static void lbtf_queue_cmd(struct lbtf_private *priv,
 			  struct cmd_ctrl_node *cmdnode)
 {
 	unsigned long flags;
+	lbtf_deb_enter(LBTF_DEB_HOST);
 
-	if (!cmdnode)
-		return;
+	if (!cmdnode) {
+		lbtf_deb_host("QUEUE_CMD: cmdnode is NULL\n");
+		goto qcmd_done;
+	}
 
-	if (!cmdnode->cmdbuf->size)
-		return;
+	if (!cmdnode->cmdbuf->size) {
+		lbtf_deb_host("DNLD_CMD: cmd size is zero\n");
+		goto qcmd_done;
+	}
 
 	cmdnode->result = 0;
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	list_add_tail(&cmdnode->list, &priv->cmdpendingq);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
+
+	lbtf_deb_host("QUEUE_CMD: inserted command 0x%04x into cmdpendingq\n",
+		     le16_to_cpu(cmdnode->cmdbuf->command));
+
+qcmd_done:
+	lbtf_deb_leave(LBTF_DEB_HOST);
 }
 
 static void lbtf_submit_command(struct lbtf_private *priv,
@@ -206,22 +241,33 @@ static void lbtf_submit_command(struct lbtf_private *priv,
 	int timeo = 5 * HZ;
 	int ret;
 
+	lbtf_deb_enter(LBTF_DEB_HOST);
+
 	cmd = cmdnode->cmdbuf;
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	priv->cur_cmd = cmdnode;
 	cmdsize = le16_to_cpu(cmd->size);
 	command = le16_to_cpu(cmd->command);
+
+	lbtf_deb_cmd("DNLD_CMD: command 0x%04x, seq %d, size %d\n",
+		     command, le16_to_cpu(cmd->seqnum), cmdsize);
+	lbtf_deb_hex(LBTF_DEB_CMD, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
+
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
-	if (ret)
+	if (ret) {
+		lbtf_pr_info("DNLD_CMD: hw_host_to_card failed: %d\n", ret);
 		/* Let the timer kick in and retry, and potentially reset
 		   the whole thing if the condition persists */
 		timeo = HZ;
+	}
 
 	/* Setup the timer after transmit command */
 	mod_timer(&priv->command_timer, jiffies + timeo);
+
+	lbtf_deb_leave(LBTF_DEB_HOST);
 }
 
 /**
@@ -231,8 +277,10 @@ static void lbtf_submit_command(struct lbtf_private *priv,
 static void __lbtf_cleanup_and_insert_cmd(struct lbtf_private *priv,
 					 struct cmd_ctrl_node *cmdnode)
 {
+	lbtf_deb_enter(LBTF_DEB_HOST);
+
 	if (!cmdnode)
-		return;
+		goto cl_ins_out;
 
 	cmdnode->callback = NULL;
 	cmdnode->callback_arg = 0;
@@ -240,6 +288,9 @@ static void __lbtf_cleanup_and_insert_cmd(struct lbtf_private *priv,
 	memset(cmdnode->cmdbuf, 0, LBS_CMD_BUFFER_SIZE);
 
 	list_add_tail(&cmdnode->list, &priv->cmdfreeq);
+
+cl_ins_out:
+	lbtf_deb_leave(LBTF_DEB_HOST);
 }
 
 static void lbtf_cleanup_and_insert_cmd(struct lbtf_private *priv,
@@ -268,29 +319,41 @@ int lbtf_cmd_set_mac_multicast_addr(struct lbtf_private *priv)
 {
 	struct cmd_ds_mac_multicast_addr cmd;
 
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
 
 	cmd.nr_of_adrs = cpu_to_le16((u16) priv->nr_of_multicastmacaddr);
+
+	lbtf_deb_cmd("MULTICAST_ADR: setting %d addresses\n", cmd.nr_of_adrs);
+
 	memcpy(cmd.maclist, priv->multicastlist,
 	       priv->nr_of_multicastmacaddr * ETH_ALEN);
 
 	lbtf_cmd_async(priv, CMD_MAC_MULTICAST_ADR, &cmd.hdr, sizeof(cmd));
+
+	lbtf_deb_leave(LBTF_DEB_CMD);
 	return 0;
 }
 
 void lbtf_set_mode(struct lbtf_private *priv, enum lbtf_mode mode)
 {
 	struct cmd_ds_set_mode cmd;
+	lbtf_deb_enter(LBTF_DEB_WEXT);
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.mode = cpu_to_le16(mode);
+	lbtf_deb_wext("Switching to mode: 0x%x\n", mode);
 	lbtf_cmd_async(priv, CMD_802_11_SET_MODE, &cmd.hdr, sizeof(cmd));
+
+	lbtf_deb_leave(LBTF_DEB_WEXT);
 }
 
 void lbtf_set_bssid(struct lbtf_private *priv, bool activate, const u8 *bssid)
 {
 	struct cmd_ds_set_bssid cmd;
+	lbtf_deb_enter(LBTF_DEB_CMD);
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.activate = activate ? 1 : 0;
@@ -298,11 +361,13 @@ void lbtf_set_bssid(struct lbtf_private *priv, bool activate, const u8 *bssid)
 		memcpy(cmd.bssid, bssid, ETH_ALEN);
 
 	lbtf_cmd_async(priv, CMD_802_11_SET_BSSID, &cmd.hdr, sizeof(cmd));
+	lbtf_deb_leave(LBTF_DEB_CMD);
 }
 
 int lbtf_set_mac_address(struct lbtf_private *priv, uint8_t *mac_addr)
 {
 	struct cmd_ds_802_11_mac_address cmd;
+	lbtf_deb_enter(LBTF_DEB_CMD);
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
@@ -310,6 +375,7 @@ int lbtf_set_mac_address(struct lbtf_private *priv, uint8_t *mac_addr)
 	memcpy(cmd.macadd, mac_addr, ETH_ALEN);
 
 	lbtf_cmd_async(priv, CMD_802_11_MAC_ADDRESS, &cmd.hdr, sizeof(cmd));
+	lbtf_deb_leave(LBTF_DEB_CMD);
 	return 0;
 }
 
@@ -318,6 +384,8 @@ int lbtf_set_radio_control(struct lbtf_private *priv)
 	int ret = 0;
 	struct cmd_ds_802_11_radio_control cmd;
 
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
 
@@ -341,19 +409,28 @@ int lbtf_set_radio_control(struct lbtf_private *priv)
 	else
 		cmd.control &= cpu_to_le16(~TURN_ON_RF);
 
+	lbtf_deb_cmd("RADIO_SET: radio %d, preamble %d\n", priv->radioon,
+		    priv->preamble);
+
 	ret = lbtf_cmd_with_response(priv, CMD_802_11_RADIO_CONTROL, &cmd);
+
+	lbtf_deb_leave_args(LBTF_DEB_CMD, "ret %d", ret);
 	return ret;
 }
 
 void lbtf_set_mac_control(struct lbtf_private *priv)
 {
 	struct cmd_ds_mac_control cmd;
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(priv->mac_control);
 	cmd.reserved = 0;
 
 	lbtf_cmd_async(priv, CMD_MAC_CONTROL,
 		&cmd.hdr, sizeof(cmd));
+
+	lbtf_deb_leave(LBTF_DEB_CMD);
 }
 
 /**
@@ -365,29 +442,43 @@ void lbtf_set_mac_control(struct lbtf_private *priv)
  */
 int lbtf_allocate_cmd_buffer(struct lbtf_private *priv)
 {
+	int ret = 0;
 	u32 bufsize;
 	u32 i;
 	struct cmd_ctrl_node *cmdarray;
 
+	lbtf_deb_enter(LBTF_DEB_HOST);
+
 	/* Allocate and initialize the command array */
 	bufsize = sizeof(struct cmd_ctrl_node) * LBS_NUM_CMD_BUFFERS;
 	cmdarray = kzalloc(bufsize, GFP_KERNEL);
-	if (!cmdarray)
-		return -1;
+	if (!cmdarray) {
+		lbtf_deb_host("ALLOC_CMD_BUF: tempcmd_array is NULL\n");
+		ret = -1;
+		goto done;
+	}
 	priv->cmd_array = cmdarray;
 
 	/* Allocate and initialize each command buffer in the command array */
 	for (i = 0; i < LBS_NUM_CMD_BUFFERS; i++) {
 		cmdarray[i].cmdbuf = kzalloc(LBS_CMD_BUFFER_SIZE, GFP_KERNEL);
-		if (!cmdarray[i].cmdbuf)
-			return -1;
+		if (!cmdarray[i].cmdbuf) {
+			lbtf_deb_host("ALLOC_CMD_BUF: ptempvirtualaddr is NULL\n");
+			ret = -1;
+			goto done;
+		}
 	}
 
 	for (i = 0; i < LBS_NUM_CMD_BUFFERS; i++) {
 		init_waitqueue_head(&cmdarray[i].cmdwait_q);
 		lbtf_cleanup_and_insert_cmd(priv, &cmdarray[i]);
 	}
-	return 0;
+
+	ret = 0;
+
+done:
+	lbtf_deb_leave_args(LBTF_DEB_HOST, "ret %d", ret);
+	return ret;
 }
 
 /**
@@ -402,9 +493,13 @@ int lbtf_free_cmd_buffer(struct lbtf_private *priv)
 	struct cmd_ctrl_node *cmdarray;
 	unsigned int i;
 
+	lbtf_deb_enter(LBTF_DEB_HOST);
+
 	/* need to check if cmd array is allocated or not */
-	if (priv->cmd_array == NULL)
-		return 0;
+	if (priv->cmd_array == NULL) {
+		lbtf_deb_host("FREE_CMD_BUF: cmd_array is NULL\n");
+		goto done;
+	}
 
 	cmdarray = priv->cmd_array;
 
@@ -418,6 +513,8 @@ int lbtf_free_cmd_buffer(struct lbtf_private *priv)
 	kfree(priv->cmd_array);
 	priv->cmd_array = NULL;
 
+done:
+	lbtf_deb_leave(LBTF_DEB_HOST);
 	return 0;
 }
 
@@ -433,6 +530,8 @@ static struct cmd_ctrl_node *lbtf_get_cmd_ctrl_node(struct lbtf_private *priv)
 	struct cmd_ctrl_node *tempnode;
 	unsigned long flags;
 
+	lbtf_deb_enter(LBTF_DEB_HOST);
+
 	if (!priv)
 		return NULL;
 
@@ -442,11 +541,14 @@ static struct cmd_ctrl_node *lbtf_get_cmd_ctrl_node(struct lbtf_private *priv)
 		tempnode = list_first_entry(&priv->cmdfreeq,
 					    struct cmd_ctrl_node, list);
 		list_del(&tempnode->list);
-	} else
+	} else {
+		lbtf_deb_host("GET_CMD_NODE: cmd_ctrl_node is not available\n");
 		tempnode = NULL;
+	}
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
+	lbtf_deb_leave(LBTF_DEB_HOST);
 	return tempnode;
 }
 
@@ -462,16 +564,20 @@ int lbtf_execute_next_command(struct lbtf_private *priv)
 	struct cmd_ctrl_node *cmdnode = NULL;
 	struct cmd_header *cmd;
 	unsigned long flags;
+	int ret = 0;
 
-	/* Debug group is LBS_DEB_THREAD and not LBS_DEB_HOST, because the
+	/* Debug group is lbtf_deb_THREAD and not lbtf_deb_HOST, because the
 	 * only caller to us is lbtf_thread() and we get even when a
 	 * data packet is received */
+	lbtf_deb_enter(LBTF_DEB_THREAD);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	if (priv->cur_cmd) {
+		lbtf_pr_alert("EXEC_NEXT_CMD: already processing command!\n");
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		return -1;
+		ret = -1;
+		goto done;
 	}
 
 	if (!list_empty(&priv->cmdpendingq)) {
@@ -483,11 +589,17 @@ int lbtf_execute_next_command(struct lbtf_private *priv)
 		cmd = cmdnode->cmdbuf;
 
 		list_del(&cmdnode->list);
+		lbtf_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
+			    le16_to_cpu(cmd->command));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		lbtf_submit_command(priv, cmdnode);
 	} else
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
-	return 0;
+
+	ret = 0;
+done:
+	lbtf_deb_leave(LBTF_DEB_THREAD);
+	return ret;
 }
 
 static struct cmd_ctrl_node *__lbtf_cmd_async(struct lbtf_private *priv,
@@ -498,14 +610,22 @@ static struct cmd_ctrl_node *__lbtf_cmd_async(struct lbtf_private *priv,
 {
 	struct cmd_ctrl_node *cmdnode;
 
-	if (priv->surpriseremoved)
-		return ERR_PTR(-ENOENT);
+	lbtf_deb_enter(LBTF_DEB_HOST);
+
+	if (priv->surpriseremoved) {
+		lbtf_deb_host("PREP_CMD: card removed\n");
+		cmdnode = ERR_PTR(-ENOENT);
+		goto done;
+	}
 
 	cmdnode = lbtf_get_cmd_ctrl_node(priv);
 	if (cmdnode == NULL) {
+		lbtf_deb_host("PREP_CMD: cmdnode is NULL\n");
+
 		/* Wake up main thread to execute next command */
 		queue_work(lbtf_wq, &priv->cmd_work);
-		return ERR_PTR(-ENOBUFS);
+		cmdnode = ERR_PTR(-ENOBUFS);
+		goto done;
 	}
 
 	cmdnode->callback = callback;
@@ -520,17 +640,24 @@ static struct cmd_ctrl_node *__lbtf_cmd_async(struct lbtf_private *priv,
 	cmdnode->cmdbuf->size    = cpu_to_le16(in_cmd_size);
 	cmdnode->cmdbuf->seqnum  = cpu_to_le16(priv->seqnum);
 	cmdnode->cmdbuf->result  = 0;
+
+	lbtf_deb_host("PREP_CMD: command 0x%04x\n", command);
+
 	cmdnode->cmdwaitqwoken = 0;
 	lbtf_queue_cmd(priv, cmdnode);
 	queue_work(lbtf_wq, &priv->cmd_work);
 
+ done:
+	lbtf_deb_leave_args(LBTF_DEB_HOST, "ret %p", cmdnode);
 	return cmdnode;
 }
 
 void lbtf_cmd_async(struct lbtf_private *priv, uint16_t command,
 	struct cmd_header *in_cmd, int in_cmd_size)
 {
+	lbtf_deb_enter(LBTF_DEB_CMD);
 	__lbtf_cmd_async(priv, command, in_cmd, in_cmd_size, NULL, 0);
+	lbtf_deb_leave(LBTF_DEB_CMD);
 }
 
 int __lbtf_cmd(struct lbtf_private *priv, uint16_t command,
@@ -543,30 +670,35 @@ int __lbtf_cmd(struct lbtf_private *priv, uint16_t command,
 	unsigned long flags;
 	int ret = 0;
 
+	lbtf_deb_enter(LBTF_DEB_HOST);
+
 	cmdnode = __lbtf_cmd_async(priv, command, in_cmd, in_cmd_size,
 				  callback, callback_arg);
-	if (IS_ERR(cmdnode))
-		return PTR_ERR(cmdnode);
+	if (IS_ERR(cmdnode)) {
+		ret = PTR_ERR(cmdnode);
+		goto done;
+	}
 
 	might_sleep();
 	ret = wait_event_interruptible(cmdnode->cmdwait_q,
 				       cmdnode->cmdwaitqwoken);
-       if (ret)	{
-		printk(KERN_DEBUG
-		       "libertastf: command 0x%04x interrupted by signal",
-		       command);
-		return ret;
+	if (ret) {
+		lbtf_pr_info("PREP_CMD: command 0x%04x interrupted by signal: %d\n",
+			    command, ret);
+		goto done;
 	}
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	ret = cmdnode->result;
 	if (ret)
-		printk(KERN_DEBUG "libertastf: command 0x%04x failed: %d\n",
+		lbtf_pr_info("PREP_CMD: command 0x%04x failed: %d\n",
 			    command, ret);
 
 	__lbtf_cleanup_and_insert_cmd(priv, cmdnode);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
+done:
+	lbtf_deb_leave_args(LBTF_DEB_HOST, "ret %d", ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__lbtf_cmd);
@@ -587,6 +719,8 @@ int lbtf_process_rx_command(struct lbtf_private *priv)
 	unsigned long flags;
 	uint16_t result;
 
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
 	mutex_lock(&priv->lock);
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
@@ -602,7 +736,7 @@ int lbtf_process_rx_command(struct lbtf_private *priv)
 	result = le16_to_cpu(resp->result);
 
 	if (net_ratelimit())
-		printk(KERN_DEBUG "libertastf: cmd response 0x%04x, seq %d, size %d\n",
+		lbtf_pr_info("libertastf: cmd response 0x%04x, seq %d, size %d\n",
 			respcmd, le16_to_cpu(resp->seqnum),
 			le16_to_cpu(resp->size));
 
@@ -639,7 +773,7 @@ int lbtf_process_rx_command(struct lbtf_private *priv)
 		switch (respcmd) {
 		case CMD_RET(CMD_GET_HW_SPEC):
 		case CMD_RET(CMD_802_11_RESET):
-			printk(KERN_DEBUG "libertastf: reset failed\n");
+			lbtf_pr_info("libertastf: reset failed\n");
 			break;
 
 		}
@@ -666,5 +800,6 @@ int lbtf_process_rx_command(struct lbtf_private *priv)
 
 done:
 	mutex_unlock(&priv->lock);
+	lbtf_deb_leave_args(LBTF_DEB_CMD, "ret %d", ret);
 	return ret;
 }
diff --git a/drivers/net/wireless/libertas_tf/deb_defs.h b/drivers/net/wireless/libertas_tf/deb_defs.h
new file mode 100644
index 0000000..0123d31
--- /dev/null
+++ b/drivers/net/wireless/libertas_tf/deb_defs.h
@@ -0,0 +1,120 @@
+/**
+  * This header file contains global constant/enum definitions,
+  * global variable declaration.
+  */
+#ifndef _LBS_DEB_DEFS_H_
+#define _LBS_DEB_EFS_H_
+
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_LIBERTAS_THINFIRM_DEBUG
+#define DEBUG
+#define PROC_DEBUG
+#endif
+
+#ifndef DRV_NAME
+#define DRV_NAME "libertas_tf"
+#endif
+
+#define LBTF_DEB_ENTER	0x00000001
+#define LBTF_DEB_LEAVE	0x00000002
+#define LBTF_DEB_MAIN	0x00000004
+#define LBTF_DEB_NET	0x00000008
+#define LBTF_DEB_MESH	0x00000010
+#define LBTF_DEB_WEXT	0x00000020
+#define LBTF_DEB_IOCTL	0x00000040
+#define LBTF_DEB_SCAN	0x00000080
+#define LBTF_DEB_ASSOC	0x00000100
+#define LBTF_DEB_JOIN	0x00000200
+#define LBTF_DEB_11D	0x00000400
+#define LBTF_DEB_DEBUGFS	0x00000800
+#define LBTF_DEB_ETHTOOL	0x00001000
+#define LBTF_DEB_HOST	0x00002000
+#define LBTF_DEB_CMD	0x00004000
+#define LBTF_DEB_RX	0x00008000
+#define LBTF_DEB_TX	0x00010000
+#define LBTF_DEB_USB	0x00020000
+#define LBTF_DEB_CS	0x00040000
+#define LBTF_DEB_FW	0x00080000
+#define LBTF_DEB_THREAD	0x00100000
+#define LBTF_DEB_HEX	0x00200000
+#define LBTF_DEB_SDIO	0x00400000
+#define LBTF_DEB_MACOPS	0x00800000
+
+extern unsigned int lbtf_debug;
+
+#ifdef DEBUG
+#define LBTF_DEB_LL(grp, grpnam, fmt, args...) \
+do { if ((lbtf_debug & (grp)) == (grp)) \
+  printk(KERN_DEBUG DRV_NAME grpnam "%s: " fmt, \
+         in_interrupt() ? " (INT)" : "", ## args); } while (0)
+#else
+#define LBTF_DEB_LL(grp, grpnam, fmt, args...) do {} while (0)
+#endif
+
+#define lbtf_deb_enter(grp) \
+  LBTF_DEB_LL(grp | LBTF_DEB_ENTER, " enter", "%s()\n", __func__);
+#define lbtf_deb_enter_args(grp, fmt, args...) \
+  LBTF_DEB_LL(grp | LBTF_DEB_ENTER, " enter", "%s(" fmt ")\n", __func__, ## args);
+#define lbtf_deb_leave(grp) \
+  LBTF_DEB_LL(grp | LBTF_DEB_LEAVE, " leave", "%s()\n", __func__);
+#define lbtf_deb_leave_args(grp, fmt, args...) \
+  LBTF_DEB_LL(grp | LBTF_DEB_LEAVE, " leave", "%s(), " fmt "\n", \
+  __func__, ##args);
+#define lbtf_deb_main(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_MAIN, " main", fmt, ##args)
+#define lbtf_deb_net(fmt, args...)       LBTF_DEB_LL(LBTF_DEB_NET, " net", fmt, ##args)
+#define lbtf_deb_mesh(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_MESH, " mesh", fmt, ##args)
+#define lbtf_deb_wext(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_WEXT, " wext", fmt, ##args)
+#define lbtf_deb_ioctl(fmt, args...)     LBTF_DEB_LL(LBTF_DEB_IOCTL, " ioctl", fmt, ##args)
+#define lbtf_deb_scan(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_SCAN, " scan", fmt, ##args)
+#define lbtf_deb_assoc(fmt, args...)     LBTF_DEB_LL(LBTF_DEB_ASSOC, " assoc", fmt, ##args)
+#define lbtf_deb_join(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_JOIN, " join", fmt, ##args)
+#define lbtf_deb_11d(fmt, args...)       LBTF_DEB_LL(LBTF_DEB_11D, " 11d", fmt, ##args)
+#define lbtf_deb_debugfs(fmt, args...)   LBTF_DEB_LL(LBTF_DEB_DEBUGFS, " debugfs", fmt, ##args)
+#define lbtf_deb_ethtool(fmt, args...)   LBTF_DEB_LL(LBTF_DEB_ETHTOOL, " ethtool", fmt, ##args)
+#define lbtf_deb_host(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_HOST, " host", fmt, ##args)
+#define lbtf_deb_cmd(fmt, args...)       LBTF_DEB_LL(LBTF_DEB_CMD, " cmd", fmt, ##args)
+#define lbtf_deb_rx(fmt, args...)        LBTF_DEB_LL(LBTF_DEB_RX, " rx", fmt, ##args)
+#define lbtf_deb_tx(fmt, args...)        LBTF_DEB_LL(LBTF_DEB_TX, " tx", fmt, ##args)
+#define lbtf_deb_fw(fmt, args...)        LBTF_DEB_LL(LBTF_DEB_FW, " fw", fmt, ##args)
+#define lbtf_deb_usb(fmt, args...)       LBTF_DEB_LL(LBTF_DEB_USB, " usb", fmt, ##args)
+#define lbtf_deb_usbd(dev, fmt, args...) LBTF_DEB_LL(LBTF_DEB_USB, " usbd", "%s:" fmt, dev_name(dev), ##args)
+#define lbtf_deb_cs(fmt, args...)        LBTF_DEB_LL(LBTF_DEB_CS, " cs", fmt, ##args)
+#define lbtf_deb_thread(fmt, args...)    LBTF_DEB_LL(LBTF_DEB_THREAD, " thread", fmt, ##args)
+#define lbtf_deb_sdio(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_SDIO, " thread", fmt, ##args)
+#define lbtf_deb_macops(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_MACOPS, " thread", fmt, ##args)
+
+#define lbtf_pr_info(format, args...) \
+	printk(KERN_INFO DRV_NAME": " format, ## args)
+#define lbtf_pr_err(format, args...) \
+	printk(KERN_ERR DRV_NAME": " format, ## args)
+#define lbtf_pr_alert(format, args...) \
+	printk(KERN_ALERT DRV_NAME": " format, ## args)
+
+#ifdef DEBUG
+static inline void lbtf_deb_hex(unsigned int grp, const char *prompt, u8 *buf, int len)
+{
+	int i = 0;
+
+	if (len &&
+	    (lbtf_debug & LBTF_DEB_HEX) &&
+	    (lbtf_debug & grp))	{
+		for (i = 1; i <= len; i++) {
+			if ((i & 0xf) == 1) {
+				if (i != 1)
+					printk("\n");
+				printk(DRV_NAME " %s: ", prompt);
+			}
+			printk("%02x ", (u8) *buf);
+			buf++;
+		}
+		printk("\n");
+	}
+}
+#else
+#define lbtf_deb_hex(grp, prompt, buf, len)	do {} while (0)
+#endif
+
+
+
+#endif
diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wireless/libertas_tf/if_usb.c
index 8cc9db6..289cba0 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -18,6 +18,10 @@
 
 #include "libertas_tf.h"
 #include "if_usb.h"
+#include "deb_defs.h"
+
+#define INSANEDEBUG	0
+#define lbtf_deb_usb2(...) do { if (INSANEDEBUG) lbtf_deb_usbd(__VA_ARGS__); } while (0)
 
 #define MESSAGE_HEADER_LEN	4
 
@@ -53,9 +57,14 @@ static int if_usb_reset_device(struct if_usb_card *cardp);
  */
 static void if_usb_write_bulk_callback(struct urb *urb)
 {
-	if (urb->status != 0)
-		printk(KERN_INFO "libertastf: URB in failure status: %d\n",
-		       urb->status);
+	if (urb->status != 0) {
+		/* print the failure status number for debug */
+		lbtf_pr_info("URB in failure status: %d\n", urb->status);
+	} else {
+		lbtf_deb_usb2(&urb->dev->dev, "URB status is successful\n");
+		lbtf_deb_usb2(&urb->dev->dev, "Actual length transmitted %d\n",
+			     urb->actual_length);
+	}
 }
 
 /**
@@ -65,6 +74,8 @@ static void if_usb_write_bulk_callback(struct urb *urb)
  */
 static void if_usb_free(struct if_usb_card *cardp)
 {
+	lbtf_deb_enter(LBTF_DEB_USB);
+
 	/* Unlink tx & rx urb */
 	usb_kill_urb(cardp->tx_urb);
 	usb_kill_urb(cardp->rx_urb);
@@ -81,6 +92,8 @@ static void if_usb_free(struct if_usb_card *cardp)
 
 	kfree(cardp->ep_out_buf);
 	cardp->ep_out_buf = NULL;
+
+	lbtf_deb_leave(LBTF_DEB_USB);
 }
 
 static void if_usb_setup_firmware(struct lbtf_private *priv)
@@ -88,23 +101,33 @@ static void if_usb_setup_firmware(struct lbtf_private *priv)
 	struct if_usb_card *cardp = priv->card;
 	struct cmd_ds_set_boot2_ver b2_cmd;
 
+	lbtf_deb_enter(LBTF_DEB_USB);
+
 	if_usb_submit_rx_urb(cardp);
 	b2_cmd.hdr.size = cpu_to_le16(sizeof(b2_cmd));
 	b2_cmd.action = 0;
 	b2_cmd.version = cardp->boot2_version;
 
 	if (lbtf_cmd_with_response(priv, CMD_SET_BOOT2_VER, &b2_cmd))
-		printk(KERN_INFO "libertastf: setting boot2 version failed\n");
+		lbtf_deb_usb("Setting boot2 version failed\n");
+
+	lbtf_deb_leave(LBTF_DEB_USB);
 }
 
 static void if_usb_fw_timeo(unsigned long priv)
 {
 	struct if_usb_card *cardp = (void *)priv;
 
-	if (!cardp->fwdnldover)
+	lbtf_deb_enter(LBTF_DEB_USB);
+	if (!cardp->fwdnldover) {
 		/* Download timed out */
 		cardp->priv->surpriseremoved = 1;
+		lbtf_pr_err("Download timed out\n");
+	} else {
+		lbtf_deb_usb("Download complete, no event. Assuming success\n");
+	}
 	wake_up(&cardp->fw_wq);
+	lbtf_deb_leave(LBTF_DEB_USB);
 }
 
 /**
@@ -125,11 +148,14 @@ static int if_usb_probe(struct usb_interface *intf,
 	struct if_usb_card *cardp;
 	int i;
 
+	lbtf_deb_enter(LBTF_DEB_USB);
 	udev = interface_to_usbdev(intf);
 
 	cardp = kzalloc(sizeof(struct if_usb_card), GFP_KERNEL);
-	if (!cardp)
+	if (!cardp) {
+		lbtf_pr_err("Out of memory allocating private data.\n");
 		goto error;
+	}
 
 	setup_timer(&cardp->fw_timeout, if_usb_fw_timeo, (unsigned long)cardp);
 	init_waitqueue_head(&cardp->fw_wq);
@@ -137,38 +163,62 @@ static int if_usb_probe(struct usb_interface *intf,
 	cardp->udev = udev;
 	iface_desc = intf->cur_altsetting;
 
+	lbtf_deb_usbd(&udev->dev, "bcdUSB = 0x%X bDeviceClass = 0x%X"
+		     " bDeviceSubClass = 0x%X, bDeviceProtocol = 0x%X\n",
+		     le16_to_cpu(udev->descriptor.bcdUSB),
+		     udev->descriptor.bDeviceClass,
+		     udev->descriptor.bDeviceSubClass,
+		     udev->descriptor.bDeviceProtocol);
+
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
 		if (usb_endpoint_is_bulk_in(endpoint)) {
 			cardp->ep_in_size =
 				le16_to_cpu(endpoint->wMaxPacketSize);
 			cardp->ep_in = usb_endpoint_num(endpoint);
+
+			lbtf_deb_usbd(&udev->dev, "in_endpoint = %d\n", cardp->ep_in);
+			lbtf_deb_usbd(&udev->dev, "Bulk in size is %d\n", cardp->ep_in_size);
 		} else if (usb_endpoint_is_bulk_out(endpoint)) {
 			cardp->ep_out_size =
 				le16_to_cpu(endpoint->wMaxPacketSize);
 			cardp->ep_out = usb_endpoint_num(endpoint);
+
+			lbtf_deb_usbd(&udev->dev, "out_endpoint = %d\n", cardp->ep_out);
+			lbtf_deb_usbd(&udev->dev, "Bulk out size is %d\n",
+			              cardp->ep_out_size);
 		}
 	}
-	if (!cardp->ep_out_size || !cardp->ep_in_size)
+	if (!cardp->ep_out_size || !cardp->ep_in_size) {
+		lbtf_deb_usbd(&udev->dev, "Endpoints not found\n");
 		/* Endpoints not found */
 		goto dealloc;
+	}
 
 	cardp->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!cardp->rx_urb)
+	if (!cardp->rx_urb) {
+		lbtf_deb_usbd(&udev->dev, "Rx URB allocation failed\n");
 		goto dealloc;
+	}
 
 	cardp->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!cardp->tx_urb)
+	if (!cardp->tx_urb) {
+		lbtf_deb_usbd(&udev->dev, "Tx URB allocation failed\n");
 		goto dealloc;
+	}
 
 	cardp->cmd_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!cardp->cmd_urb)
+	if (!cardp->cmd_urb) {
+		lbtf_deb_usbd(&udev->dev, "Cmd URB allocation failed\n");
 		goto dealloc;
+	}
 
 	cardp->ep_out_buf = kmalloc(MRVDRV_ETH_TX_PACKET_BUFFER_SIZE,
 				    GFP_KERNEL);
-	if (!cardp->ep_out_buf)
+	if (!cardp->ep_out_buf) {
+		lbtf_deb_usbd(&udev->dev, "Could not allocate buffer\n");
 		goto dealloc;
+	}
 
 	priv = lbtf_add_card(cardp, &udev->dev);
 	if (!priv)
@@ -189,6 +239,7 @@ static int if_usb_probe(struct usb_interface *intf,
 dealloc:
 	if_usb_free(cardp);
 error:
+lbtf_deb_leave(LBTF_DEB_MAIN);
 	return -ENOMEM;
 }
 
@@ -202,6 +253,8 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	struct if_usb_card *cardp = usb_get_intfdata(intf);
 	struct lbtf_private *priv = (struct lbtf_private *) cardp->priv;
 
+	lbtf_deb_enter(LBTF_DEB_MAIN);
+
 	if_usb_reset_device(cardp);
 
 	if (priv)
@@ -212,6 +265,8 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
+
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 
 /**
@@ -226,6 +281,8 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 	struct fwdata *fwdata = cardp->ep_out_buf;
 	u8 *firmware = (u8 *) cardp->fw->data;
 
+	lbtf_deb_enter(LBTF_DEB_FW);
+
 	/* If we got a CRC failure on the last block, back
 	   up and retry it */
 	if (!cardp->CRC_OK) {
@@ -233,6 +290,9 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 		cardp->fwseqnum--;
 	}
 
+	lbtf_deb_usb2(&cardp->udev->dev, "totalbytes = %d\n",
+		     cardp->totalbytes);
+
 	/* struct fwdata (which we sent to the card) has an
 	   extra __le32 field in between the header and the data,
 	   which is not in the struct fwheader in the actual
@@ -246,18 +306,33 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 	memcpy(fwdata->data, &firmware[cardp->totalbytes],
 	       le32_to_cpu(fwdata->hdr.datalength));
 
+	lbtf_deb_usb2(&cardp->udev->dev, "Data length = %d\n",
+		     le32_to_cpu(fwdata->hdr.datalength));
+
 	fwdata->seqnum = cpu_to_le32(++cardp->fwseqnum);
 	cardp->totalbytes += le32_to_cpu(fwdata->hdr.datalength);
 
 	usb_tx_block(cardp, cardp->ep_out_buf, sizeof(struct fwdata) +
 		     le32_to_cpu(fwdata->hdr.datalength), 0);
 
-	if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK))
+	if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_DATA_TO_RECV)) {
+		lbtf_deb_usb2(&cardp->udev->dev, "There are data to follow\n");
+		lbtf_deb_usb2(&cardp->udev->dev, "seqnum = %d totalbytes = %d\n",
+			     cardp->fwseqnum, cardp->totalbytes);
+	} else if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
+		lbtf_deb_usb2(&cardp->udev->dev, "Host has finished FW downloading\n");
+		lbtf_deb_usb2(&cardp->udev->dev, "Donwloading FW JUMP BLOCK\n");
+
 		/* Host has finished FW downloading
 		 * Donwloading FW JUMP BLOCK
 		 */
 		cardp->fwfinalblk = 1;
+	}
+
+	lbtf_deb_usb2(&cardp->udev->dev, "Firmware download done; size %d\n",
+		     cardp->totalbytes);
 
+	lbtf_deb_leave(LBTF_DEB_FW);
 	return 0;
 }
 
@@ -266,6 +341,8 @@ static int if_usb_reset_device(struct if_usb_card *cardp)
 	struct cmd_ds_802_11_reset *cmd = cardp->ep_out_buf + 4;
 	int ret;
 
+	lbtf_deb_enter(LBTF_DEB_USB);
+
 	*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_REQUEST);
 
 	cmd->hdr.command = cpu_to_le16(CMD_802_11_RESET);
@@ -280,6 +357,8 @@ static int if_usb_reset_device(struct if_usb_card *cardp)
 	ret = usb_reset_device(cardp->udev);
 	msleep(100);
 
+	lbtf_deb_leave_args(LBTF_DEB_USB, "ret %d", ret);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(if_usb_reset_device);
@@ -297,11 +376,15 @@ EXPORT_SYMBOL_GPL(if_usb_reset_device);
 static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
 			uint16_t nb, u8 data)
 {
+	int ret = -1;
 	struct urb *urb;
 
+	lbtf_deb_enter(LBTF_DEB_USB);
 	/* check if device is removed */
-	if (cardp->priv->surpriseremoved)
-		return -1;
+	if (cardp->priv->surpriseremoved) {
+		lbtf_deb_usbd(&cardp->udev->dev, "Device removed\n");
+		goto tx_ret;
+	}
 
 	if (data)
 		urb = cardp->tx_urb;
@@ -315,19 +398,34 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
 
 	urb->transfer_flags |= URB_ZERO_PACKET;
 
-	if (usb_submit_urb(urb, GFP_ATOMIC))
-		return -1;
-	return 0;
+	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+		lbtf_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed: %d\n", ret);
+		goto tx_ret;
+	}
+
+	lbtf_deb_usb2(&cardp->udev->dev, "usb_submit_urb success\n");
+
+	ret = 0;
+
+tx_ret:
+	lbtf_deb_leave(LBTF_DEB_USB);
+	return ret;
 }
 
 static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 				  void (*callbackfn)(struct urb *urb))
 {
 	struct sk_buff *skb;
+	int ret = -1;
+
+	lbtf_deb_enter(LBTF_DEB_USB);
 
 	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
-	if (!skb)
+	if (!skb) {
+		lbtf_pr_err("No free skb\n");
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return -1;
+	}
 
 	cardp->rx_skb = skb;
 
@@ -339,12 +437,19 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 
 	cardp->rx_urb->transfer_flags |= URB_ZERO_PACKET;
 
-	if (usb_submit_urb(cardp->rx_urb, GFP_ATOMIC)) {
+	lbtf_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb);
+	ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC);
+	if (ret) {
+		lbtf_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
 		kfree_skb(skb);
 		cardp->rx_skb = NULL;
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return -1;
-	} else
+	} else {
+		lbtf_deb_usb2(&cardp->udev->dev, "Submit Rx URB success\n");
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return 0;
+	}
 }
 
 static int if_usb_submit_rx_urb_fwload(struct if_usb_card *cardp)
@@ -364,8 +469,12 @@ static void if_usb_receive_fwload(struct urb *urb)
 	struct fwsyncheader *syncfwheader;
 	struct bootcmdresp bcmdresp;
 
+	lbtf_deb_enter(LBTF_DEB_USB);
 	if (urb->status) {
+		lbtf_deb_usbd(&cardp->udev->dev,
+			     "URB status is failed during fw load\n");
 		kfree_skb(skb);
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return;
 	}
 
@@ -373,12 +482,17 @@ static void if_usb_receive_fwload(struct urb *urb)
 		__le32 *tmp = (__le32 *)(skb->data);
 
 		if (tmp[0] == cpu_to_le32(CMD_TYPE_INDICATION) &&
-		    tmp[1] == cpu_to_le32(MACREG_INT_CODE_FIRMWARE_READY))
+		    tmp[1] == cpu_to_le32(MACREG_INT_CODE_FIRMWARE_READY)) {
 			/* Firmware ready event received */
+			lbtf_pr_info("Firmware ready event received\n");
 			wake_up(&cardp->fw_wq);
-		else
+		} else {
+			lbtf_deb_usb("Waiting for confirmation; got %x %x\n",
+				    le32_to_cpu(tmp[0]), le32_to_cpu(tmp[1]));
 			if_usb_submit_rx_urb_fwload(cardp);
+		}
 		kfree_skb(skb);
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return;
 	}
 	if (cardp->bootcmdresp <= 0) {
@@ -389,34 +503,60 @@ static void if_usb_receive_fwload(struct urb *urb)
 			if_usb_submit_rx_urb_fwload(cardp);
 			cardp->bootcmdresp = 1;
 			/* Received valid boot command response */
+			lbtf_deb_usbd(&cardp->udev->dev,
+				     "Received valid boot command response\n");
+			lbtf_deb_leave(LBTF_DEB_USB);
 			return;
 		}
 		if (bcmdresp.magic != cpu_to_le32(BOOT_CMD_MAGIC_NUMBER)) {
 			if (bcmdresp.magic == cpu_to_le32(CMD_TYPE_REQUEST) ||
 			    bcmdresp.magic == cpu_to_le32(CMD_TYPE_DATA) ||
-			    bcmdresp.magic == cpu_to_le32(CMD_TYPE_INDICATION))
+			    bcmdresp.magic == cpu_to_le32(CMD_TYPE_INDICATION)) {
+				if (!cardp->bootcmdresp)
+					lbtf_pr_info("Firmware already seems alive; resetting\n");
 				cardp->bootcmdresp = -1;
-		} else if (bcmdresp.cmd == BOOT_CMD_FW_BY_USB &&
-			   bcmdresp.result == BOOT_CMD_RESP_OK)
+			} else {
+				lbtf_pr_info("boot cmd response wrong magic number (0x%x)\n",
+					    le32_to_cpu(bcmdresp.magic));
+			}
+		} else if (bcmdresp.cmd != BOOT_CMD_FW_BY_USB) {
+			lbtf_pr_info("boot cmd response cmd_tag error (%d)\n",
+				    bcmdresp.cmd);
+		} else if (bcmdresp.result != BOOT_CMD_RESP_OK) {
+			lbtf_pr_info("boot cmd response result error (%d)\n",
+				    bcmdresp.result);
+		} else {
 			cardp->bootcmdresp = 1;
+			lbtf_deb_usbd(&cardp->udev->dev,
+				     "Received valid boot command response\n");
+		}
 
 		kfree_skb(skb);
 		if_usb_submit_rx_urb_fwload(cardp);
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return;
 	}
 
 	syncfwheader = kmalloc(sizeof(struct fwsyncheader), GFP_ATOMIC);
 	if (!syncfwheader) {
+		lbtf_deb_usbd(&cardp->udev->dev, "Failure to allocate syncfwheader\n");
 		kfree_skb(skb);
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return;
 	}
 
 	memcpy(syncfwheader, skb->data, sizeof(struct fwsyncheader));
 
-	if (!syncfwheader->cmd)
+	if (!syncfwheader->cmd) {
+		lbtf_deb_usb2(&cardp->udev->dev, "FW received Blk with correct CRC\n");
+		lbtf_deb_usb2(&cardp->udev->dev, "FW received Blk seqnum = %d\n",
+			     le32_to_cpu(syncfwheader->seqnum));
 		cardp->CRC_OK = 1;
-	else
+	} else {
+		lbtf_deb_usbd(&cardp->udev->dev, "FW received Blk with CRC error\n");
 		cardp->CRC_OK = 0;
+	}
+
 	kfree_skb(skb);
 
 	/* reschedule timer for 200ms hence */
@@ -434,6 +574,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 
 	kfree(syncfwheader);
 
+	lbtf_deb_leave(LBTF_DEB_USB);
 	return;
 }
 
@@ -445,6 +586,7 @@ static inline void process_cmdtypedata(int recvlength, struct sk_buff *skb,
 {
 	if (recvlength > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + MESSAGE_HEADER_LEN
 	    || recvlength < MRVDRV_MIN_PKT_LEN) {
+		lbtf_deb_usbd(&cardp->udev->dev, "Packet length is Invalid\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -460,6 +602,8 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 				      struct lbtf_private *priv)
 {
 	if (recvlength > LBS_CMD_BUFFER_SIZE) {
+		lbtf_deb_usbd(&cardp->udev->dev,
+			     "The receive buffer is too large\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -489,16 +633,24 @@ static void if_usb_receive(struct urb *urb)
 	uint32_t recvtype = 0;
 	__le32 *pkt = (__le32 *) skb->data;
 
+	lbtf_deb_enter(LBTF_DEB_USB);
+
 	if (recvlength) {
 		if (urb->status) {
+			lbtf_deb_usbd(&cardp->udev->dev, "RX URB failed: %d\n",
+				     urb->status);
 			kfree_skb(skb);
 			goto setup_for_next;
 		}
 
 		recvbuff = skb->data;
 		recvtype = le32_to_cpu(pkt[0]);
+		lbtf_deb_usbd(&cardp->udev->dev,
+			    "Recv length = 0x%x, Recv type = 0x%X\n",
+			    recvlength, recvtype);
 	} else if (urb->status) {
 		kfree_skb(skb);
+		lbtf_deb_leave(LBTF_DEB_USB);
 		return;
 	}
 
@@ -515,6 +667,7 @@ static void if_usb_receive(struct urb *urb)
 	{
 		/* Event cause handling */
 		u32 event_cause = le32_to_cpu(pkt[1]);
+		lbtf_deb_usbd(&cardp->udev->dev, "**EVENT** 0x%X\n", event_cause);
 
 		/* Icky undocumented magic special case */
 		if (event_cause & 0xffff0000) {
@@ -529,21 +682,22 @@ static void if_usb_receive(struct urb *urb)
 		} else if (event_cause == LBTF_EVENT_BCN_SENT)
 			lbtf_bcn_sent(priv);
 		else
-			printk(KERN_DEBUG
+			lbtf_deb_usbd(&cardp->udev->dev,
 			       "Unsupported notification %d received\n",
 			       event_cause);
 		kfree_skb(skb);
 		break;
 	}
 	default:
-		printk(KERN_DEBUG "libertastf: unknown command type 0x%X\n",
-			     recvtype);
+		lbtf_deb_usbd(&cardp->udev->dev,
+		         "libertastf: unknown command type 0x%X\n", recvtype);
 		kfree_skb(skb);
 		break;
 	}
 
 setup_for_next:
 	if_usb_submit_rx_urb(cardp);
+	lbtf_deb_leave(LBTF_DEB_USB);
 }
 
 /**
@@ -562,6 +716,9 @@ static int if_usb_host_to_card(struct lbtf_private *priv, uint8_t type,
 	struct if_usb_card *cardp = priv->card;
 	u8 data = 0;
 
+	lbtf_deb_usbd(&cardp->udev->dev, "*** type = %u\n", type);
+	lbtf_deb_usbd(&cardp->udev->dev, "size after = %d\n", nb);
+
 	if (type == MVMS_CMD) {
 		*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_REQUEST);
 	} else {
@@ -639,8 +796,10 @@ static int check_fwfile_format(const u8 *data, u32 totlen)
 	} while (!exit);
 
 	if (ret)
-		printk(KERN_INFO
-		       "libertastf: firmware file format check failed\n");
+		lbtf_pr_err("firmware file format check FAIL\n");
+	else
+		lbtf_deb_fw("firmware file format check PASS\n");
+
 	return ret;
 }
 
@@ -651,10 +810,12 @@ static int if_usb_prog_firmware(struct if_usb_card *cardp)
 	static int reset_count = 10;
 	int ret = 0;
 
+	lbtf_deb_enter(LBTF_DEB_USB);
+
 	ret = request_firmware(&cardp->fw, lbtf_fw_name, &cardp->udev->dev);
 	if (ret < 0) {
-		printk(KERN_INFO "libertastf: firmware %s not found\n",
-		       lbtf_fw_name);
+		lbtf_pr_err("request_firmware() failed with %#x\n", ret);
+		lbtf_pr_err("firmware %s not found\n", lbtf_fw_name);
 		goto done;
 	}
 
@@ -663,6 +824,7 @@ static int if_usb_prog_firmware(struct if_usb_card *cardp)
 
 restart:
 	if (if_usb_submit_rx_urb_fwload(cardp) < 0) {
+		lbtf_deb_usbd(&cardp->udev->dev, "URB submission is failed\n");
 		ret = -1;
 		goto release_fw;
 	}
@@ -709,14 +871,13 @@ restart:
 	usb_kill_urb(cardp->rx_urb);
 
 	if (!cardp->fwdnldover) {
-		printk(KERN_INFO "libertastf: failed to load fw,"
-				 " resetting device!\n");
+		lbtf_pr_info("failed to load fw, resetting device!\n");
 		if (--reset_count >= 0) {
 			if_usb_reset_device(cardp);
 			goto restart;
 		}
 
-		printk(KERN_INFO "libertastf: fw download failure\n");
+		lbtf_pr_info("FW download failure, time = %d ms\n", i * 100);
 		ret = -1;
 		goto release_fw;
 	}
@@ -730,6 +891,7 @@ restart:
 	if_usb_setup_firmware(cardp->priv);
 
  done:
+	lbtf_deb_leave_args(LBTF_DEB_USB, "ret %d", ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(if_usb_prog_firmware);
@@ -751,13 +913,19 @@ static int __init if_usb_init_module(void)
 {
 	int ret = 0;
 
+	lbtf_deb_enter(LBTF_DEB_MAIN);
+
 	ret = usb_register(&if_usb_driver);
+
+	lbtf_deb_leave_args(LBTF_DEB_MAIN, "ret %d", ret);
 	return ret;
 }
 
 static void __exit if_usb_exit_module(void)
 {
+	lbtf_deb_enter(LBTF_DEB_MAIN);
 	usb_deregister(&if_usb_driver);
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 
 module_init(if_usb_init_module);
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 7945ff5..abc4afd 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -11,6 +11,7 @@
 
 #include "libertas_tf.h"
 #include "linux/etherdevice.h"
+#include "deb_defs.h"
 
 #define DRIVER_RELEASE_VERSION "004.p0"
 /* thinfirm version: 5.132.X.pX */
@@ -18,7 +19,17 @@
 #define LBTF_FW_VER_MAX		0x0584ffff
 #define QOS_CONTROL_LEN		2
 
-static const char lbtf_driver_version[] = "THINFIRM-USB8388-" DRIVER_RELEASE_VERSION;
+/* Module parameters */
+unsigned int lbtf_debug;
+EXPORT_SYMBOL_GPL(lbtf_debug);
+module_param_named(libertas_tf_debug, lbtf_debug, int, 0644);
+
+static const char lbtf_driver_version[] = "THINFIRM-USB8388-" DRIVER_RELEASE_VERSION
+#ifdef DEBUG
+	"-dbg"
+#endif
+	"";
+
 struct workqueue_struct *lbtf_wq;
 
 static const struct ieee80211_channel lbtf_channels[] = {
@@ -81,6 +92,9 @@ static void lbtf_cmd_work(struct work_struct *work)
 {
 	struct lbtf_private *priv = container_of(work, struct lbtf_private,
 					 cmd_work);
+
+	lbtf_deb_enter(LBTF_DEB_CMD);
+
 	spin_lock_irq(&priv->driver_lock);
 	/* command response? */
 	if (priv->cmd_response_rxed) {
@@ -108,11 +122,16 @@ static void lbtf_cmd_work(struct work_struct *work)
 	priv->cmd_timed_out = 0;
 	spin_unlock_irq(&priv->driver_lock);
 
-	if (!priv->fw_ready)
+	if (!priv->fw_ready) {
+		lbtf_deb_leave_args(LBTF_DEB_CMD, "fw not ready");
 		return;
+	}
+
 	/* Execute the next command */
 	if (!priv->cur_cmd)
 		lbtf_execute_next_command(priv);
+
+	lbtf_deb_leave(LBTF_DEB_CMD);
 }
 
 /**
@@ -126,6 +145,7 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
 {
 	int ret = -1;
 
+	lbtf_deb_enter(LBTF_DEB_FW);
 	/*
 	 * Read priv address from HW
 	 */
@@ -141,6 +161,7 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
 
 	ret = 0;
 done:
+	lbtf_deb_leave_args(LBTF_DEB_FW, "ret: %d", ret);
 	return ret;
 }
 
@@ -152,6 +173,7 @@ static void command_timer_fn(unsigned long data)
 {
 	struct lbtf_private *priv = (struct lbtf_private *)data;
 	unsigned long flags;
+	lbtf_deb_enter(LBTF_DEB_CMD);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
@@ -168,10 +190,12 @@ static void command_timer_fn(unsigned long data)
 	queue_work(lbtf_wq, &priv->cmd_work);
 out:
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
+	lbtf_deb_leave(LBTF_DEB_CMD);
 }
 
 static int lbtf_init_adapter(struct lbtf_private *priv)
 {
+	lbtf_deb_enter(LBTF_DEB_MAIN);
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 	mutex_init(&priv->lock);
 
@@ -188,13 +212,16 @@ static int lbtf_init_adapter(struct lbtf_private *priv)
 	if (lbtf_allocate_cmd_buffer(priv))
 		return -1;
 
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 	return 0;
 }
 
 static void lbtf_free_adapter(struct lbtf_private *priv)
 {
+	lbtf_deb_enter(LBTF_DEB_MAIN);
 	lbtf_free_cmd_buffer(priv);
 	del_timer(&priv->command_timer);
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 
 static int lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -221,14 +248,18 @@ static void lbtf_tx_work(struct work_struct *work)
 	struct sk_buff *skb = NULL;
 	int err;
 
+	lbtf_deb_enter(LBTF_DEB_MACOPS | LBTF_DEB_TX);
+
 	if ((priv->vif->type == NL80211_IFTYPE_AP) &&
 	    (!skb_queue_empty(&priv->bc_ps_buf)))
 		skb = skb_dequeue(&priv->bc_ps_buf);
 	else if (priv->skb_to_tx) {
 		skb = priv->skb_to_tx;
 		priv->skb_to_tx = NULL;
-	} else
+	} else {
+		lbtf_deb_leave(LBTF_DEB_MACOPS | LBTF_DEB_TX);
 		return;
+	}
 
 	len = skb->len;
 	info  = IEEE80211_SKB_CB(skb);
@@ -236,6 +267,7 @@ static void lbtf_tx_work(struct work_struct *work)
 
 	if (priv->surpriseremoved) {
 		dev_kfree_skb_any(skb);
+		lbtf_deb_leave(LBTF_DEB_MACOPS | LBTF_DEB_TX);
 		return;
 	}
 
@@ -249,6 +281,7 @@ static void lbtf_tx_work(struct work_struct *work)
 		ETH_ALEN);
 	txpd->tx_packet_length = cpu_to_le16(len);
 	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
+	lbtf_deb_hex(LBTF_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
 	BUG_ON(priv->tx_skb);
 	spin_lock_irq(&priv->driver_lock);
 	priv->tx_skb = skb;
@@ -257,7 +290,9 @@ static void lbtf_tx_work(struct work_struct *work)
 	if (err) {
 		dev_kfree_skb_any(skb);
 		priv->tx_skb = NULL;
+		lbtf_pr_err("TX error: %d", err);
 	}
+	lbtf_deb_leave(LBTF_DEB_MACOPS | LBTF_DEB_TX);
 }
 
 static int lbtf_op_start(struct ieee80211_hw *hw)
@@ -266,6 +301,8 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 	void *card = priv->card;
 	int ret = -1;
 
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
+
 	if (!priv->fw_ready)
 		/* Upload firmware */
 		if (priv->hw_prog_firmware(card))
@@ -286,10 +323,12 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 	}
 
 	printk(KERN_INFO "libertastf: Marvell WLAN 802.11 thinfirm adapter\n");
+	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
 
 err_prog_firmware:
 	priv->hw_reset_device(card);
+	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programing fw; ret=%d", ret);
 	return ret;
 }
 
@@ -300,6 +339,9 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
 	struct sk_buff *skb;
 
 	struct cmd_ctrl_node *cmdnode;
+
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
+
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
@@ -316,6 +358,7 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
 	priv->radioon = RADIO_OFF;
 	lbtf_set_radio_control(priv);
 
+	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return;
 }
 
@@ -323,6 +366,7 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif)
 {
 	struct lbtf_private *priv = hw->priv;
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
 	if (priv->vif != NULL)
 		return -EOPNOTSUPP;
 
@@ -340,6 +384,7 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 	}
 	lbtf_set_mac_address(priv, (u8 *) vif->addr);
+	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
 }
 
@@ -347,6 +392,7 @@ static void lbtf_op_remove_interface(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif)
 {
 	struct lbtf_private *priv = hw->priv;
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
 	if (priv->vif->type == NL80211_IFTYPE_AP ||
 	    priv->vif->type == NL80211_IFTYPE_MESH_POINT)
@@ -354,17 +400,20 @@ static void lbtf_op_remove_interface(struct ieee80211_hw *hw,
 	lbtf_set_mode(priv, LBTF_PASSIVE_MODE);
 	lbtf_set_bssid(priv, 0, NULL);
 	priv->vif = NULL;
+	lbtf_deb_leave(LBTF_DEB_MACOPS);
 }
 
 static int lbtf_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct lbtf_private *priv = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
 	if (conf->channel->center_freq != priv->cur_freq) {
 		priv->cur_freq = conf->channel->center_freq;
 		lbtf_set_channel(priv, conf->channel->hw_value);
 	}
+	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
 }
 
@@ -397,11 +446,16 @@ static void lbtf_op_configure_filter(struct ieee80211_hw *hw,
 {
 	struct lbtf_private *priv = hw->priv;
 	int old_mac_control = priv->mac_control;
+
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
+
 	changed_flags &= SUPPORTED_FIF_FLAGS;
 	*new_flags &= SUPPORTED_FIF_FLAGS;
 
-	if (!changed_flags)
+	if (!changed_flags) {
+		lbtf_deb_leave(LBTF_DEB_MACOPS);
 		return;
+	}
 
 	if (*new_flags & (FIF_PROMISC_IN_BSS))
 		priv->mac_control |= CMD_ACT_MAC_PROMISCUOUS_ENABLE;
@@ -427,6 +481,8 @@ static void lbtf_op_configure_filter(struct ieee80211_hw *hw,
 
 	if (priv->mac_control != old_mac_control)
 		lbtf_set_mac_control(priv);
+
+	lbtf_deb_leave(LBTF_DEB_MACOPS);
 }
 
 static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
@@ -436,6 +492,7 @@ static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct lbtf_private *priv = hw->priv;
 	struct sk_buff *beacon;
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
 	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_INT)) {
 		switch (priv->vif->type) {
@@ -466,6 +523,8 @@ static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
 			priv->preamble = CMD_TYPE_LONG_PREAMBLE;
 		lbtf_set_radio_control(priv);
 	}
+
+	lbtf_deb_leave(LBTF_DEB_MACOPS);
 }
 
 static const struct ieee80211_ops lbtf_ops = {
@@ -488,6 +547,8 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	unsigned int flags;
 	struct ieee80211_hdr *hdr;
 
+	lbtf_deb_enter(LBTF_DEB_RX);
+
 	prxpd = (struct rxpd *) skb->data;
 
 	stats.flag = 0;
@@ -518,7 +579,15 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
+
+	lbtf_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
+	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
+	lbtf_deb_hex(LBTF_DEB_RX, "RX Data", skb->data,
+	             min_t(unsigned int, skb->len, 100));
+
 	ieee80211_rx_irqsafe(priv->hw, skb);
+
+	lbtf_deb_leave(LBTF_DEB_RX);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lbtf_rx);
@@ -535,6 +604,8 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
 	struct ieee80211_hw *hw;
 	struct lbtf_private *priv = NULL;
 
+	lbtf_deb_enter(LBTF_DEB_MAIN);
+
 	hw = ieee80211_alloc_hw(sizeof(struct lbtf_private), &lbtf_ops);
 	if (!hw)
 		goto done;
@@ -577,6 +648,7 @@ err_init_adapter:
 	priv = NULL;
 
 done:
+	lbtf_deb_leave_args(LBTF_DEB_MAIN, "priv %p", priv);
 	return priv;
 }
 EXPORT_SYMBOL_GPL(lbtf_add_card);
@@ -586,6 +658,8 @@ int lbtf_remove_card(struct lbtf_private *priv)
 {
 	struct ieee80211_hw *hw = priv->hw;
 
+	lbtf_deb_enter(LBTF_DEB_MAIN);
+
 	priv->surpriseremoved = 1;
 	del_timer(&priv->command_timer);
 	lbtf_free_adapter(priv);
@@ -593,6 +667,7 @@ int lbtf_remove_card(struct lbtf_private *priv)
 	ieee80211_unregister_hw(hw);
 	ieee80211_free_hw(hw);
 
+    lbtf_deb_leave(LBTF_DEB_MAIN);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lbtf_remove_card);
@@ -651,17 +726,21 @@ EXPORT_SYMBOL_GPL(lbtf_bcn_sent);
 
 static int __init lbtf_init_module(void)
 {
+	lbtf_deb_enter(LBTF_DEB_MAIN);
 	lbtf_wq = create_workqueue("libertastf");
 	if (lbtf_wq == NULL) {
 		printk(KERN_ERR "libertastf: couldn't create workqueue\n");
 		return -ENOMEM;
 	}
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 	return 0;
 }
 
 static void __exit lbtf_exit_module(void)
 {
+	lbtf_deb_enter(LBTF_DEB_MAIN);
 	destroy_workqueue(lbtf_wq);
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 
 module_init(lbtf_init_module);
-- 
1.7.0

