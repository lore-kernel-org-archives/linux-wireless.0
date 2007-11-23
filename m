Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:4183 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbXKWOlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 09:41:52 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: rework event subscription
Date: Fri, 23 Nov 2007 15:42:02 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711231542.03028.hs4233@mail.mn-solutions.de> (sfid-20071123_144156_646056_5A7A9536)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the implementation of event subscription via debugfs:

* tell cmd.c and cmdresp.c about CMD_802_11_SUBSCRIBE_EVENT
* remove lots of low-level cmd stuff from debugfs.c
* create unified functions to read/write snr, rssi, bcnmiss and
  failcount
* introduces #define's for subscription event bitmask values
* adds a function to search for a specific element in an IE
  (a.k.a. TLV)
* adds a function to find out the size of the TLV. This is needed
  because lbs_prepare_and_send_command() has an argument for a
  data buffer, but not for it's lengths and TLVs can be, by
  definition, vary in size.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---
As a side effect, the size of libertas.ko went down:

 131653    3980       8  135641   211d9 libertas-orig.ko
 126284    3980       8  130272   1fce0 libertas.ko

Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2007-11-23 16:32:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2007-11-23 16:37:20.000000000 +0100
@@ -246,6 +246,52 @@ static int lbs_cmd_802_11_enable_rsn(str
 }
 
 
+static ssize_t lbs_tlv_size(const u8 *tlv, u16 size)
+{
+	ssize_t pos = 0;
+	struct mrvlietypesheader *tlv_h;
+	while (pos < size) {
+		u16 length;
+		tlv_h = (struct mrvlietypesheader *) tlv;
+		if (tlv_h->len == 0)
+			return pos;
+		length = le16_to_cpu(tlv_h->len) +
+			sizeof(struct mrvlietypesheader);
+		pos += length;
+		tlv += length;
+	}
+	return pos;
+}
+
+
+static void lbs_cmd_802_11_subscribe_event(struct lbs_private *priv,
+	struct cmd_ds_command *cmd, u16 cmd_action,
+	void *pdata_buf)
+{
+	struct cmd_ds_802_11_subscribe_event *events =
+		(struct cmd_ds_802_11_subscribe_event *) pdata_buf;
+
+	/* pdata_buf points to a struct cmd_ds_802_11_subscribe_event and room
+	 * for various Marvell TLVs */
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	cmd->size = cpu_to_le16(sizeof(*events)
+			- sizeof(events->tlv)
+			+ S_DS_GEN);
+	cmd->params.subscribe_event.action = cpu_to_le16(cmd_action);
+	if (cmd_action == CMD_ACT_GET) {
+		cmd->params.subscribe_event.events = 0;
+	} else {
+		ssize_t sz = lbs_tlv_size(events->tlv, sizeof(events->tlv));
+		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) + sz);
+		cmd->params.subscribe_event.events = events->events;
+		memcpy(cmd->params.subscribe_event.tlv, events->tlv, sz);
+	}
+
+	lbs_deb_leave(LBS_DEB_CMD);
+}
+
 static void set_one_wpa_key(struct MrvlIEtype_keyParamSet * pkeyparamset,
                             struct enc_key * pkey)
 {
@@ -1372,6 +1418,10 @@ int lbs_prepare_and_send_command(struct 
 			ret = 0;
 			break;
 		}
+	case CMD_802_11_SUBSCRIBE_EVENT:
+		lbs_cmd_802_11_subscribe_event(priv, cmdptr,
+			cmd_action, pdata_buf);
+		break;
 	case CMD_802_11_PWR_CFG:
 		cmdptr->command = cpu_to_le16(CMD_802_11_PWR_CFG);
 		cmdptr->size =
Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2007-11-23 16:32:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2007-11-23 16:37:44.000000000 +0100
@@ -545,6 +545,26 @@ static int lbs_ret_802_11_enable_rsn(str
 	return 0;
 }
 
+static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
+	struct cmd_ds_command *resp)
+{
+	struct lbs_adapter *adapter = priv->adapter;
+	struct cmd_ds_802_11_subscribe_event *cmd_event =
+		&resp->params.subscribe_event;
+	struct cmd_ds_802_11_subscribe_event *dst_event =
+		adapter->cur_cmd->pdata_buf;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (dst_event->action == cpu_to_le16(CMD_ACT_GET)) {
+		dst_event->events = le16_to_cpu(cmd_event->events);
+		memcpy(dst_event->tlv, cmd_event->tlv, sizeof(dst_event->tlv));
+	}
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
 static inline int handle_cmd_response(u16 respcmd,
 				      struct cmd_ds_command *resp,
 				      struct lbs_private *priv)
@@ -680,6 +700,10 @@ static inline int handle_cmd_response(u1
 			sizeof(struct cmd_ds_802_11_led_ctrl));
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
 		break;
+	case CMD_RET(CMD_802_11_SUBSCRIBE_EVENT):
+		ret = lbs_ret_802_11_subscribe_event(priv, resp);
+		break;
+
 	case CMD_RET(CMD_802_11_PWR_CFG):
 		spin_lock_irqsave(&adapter->driver_lock, flags);
 		memmove(adapter->cur_cmd->pdata_buf, &resp->params.pwrcfg,
Index: wireless-2.6/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/debugfs.c	2007-11-23 16:32:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/debugfs.c	2007-11-23 16:38:37.000000000 +0100
@@ -383,524 +383,162 @@ out_unlock:
 	return count;
 }
 
-static int lbs_event_initcmd(struct lbs_private *priv, void **response_buf,
-			struct cmd_ctrl_node **cmdnode,
-			struct cmd_ds_command **cmd)
-{
-	u16 wait_option = CMD_OPTION_WAITFORRSP;
-
-	if (!(*cmdnode = lbs_get_free_cmd_ctrl_node(priv))) {
-		lbs_deb_debugfs("failed lbs_get_free_cmd_ctrl_node\n");
-		return -ENOMEM;
-	}
-	if (!(*response_buf = kmalloc(3000, GFP_KERNEL))) {
-		lbs_deb_debugfs("failed to allocate response buffer!\n");
-		return -ENOMEM;
-	}
-	lbs_set_cmd_ctrl_node(priv, *cmdnode, 0, wait_option, NULL);
-	init_waitqueue_head(&(*cmdnode)->cmdwait_q);
-	(*cmdnode)->pdata_buf = *response_buf;
-	(*cmdnode)->cmdflags |= CMD_F_HOSTCMD;
-	(*cmdnode)->cmdwaitqwoken = 0;
-	*cmd = (struct cmd_ds_command *)(*cmdnode)->bufvirtualaddr;
-	(*cmd)->command = cpu_to_le16(CMD_802_11_SUBSCRIBE_EVENT);
-	(*cmd)->seqnum = cpu_to_le16(++priv->adapter->seqnum);
-	(*cmd)->result = 0;
-	return 0;
-}
 
-static ssize_t lbs_lowrssi_read(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
+/*
+ * When calling CMD_802_11_SUBSCRIBE_EVENT with CMD_ACT_GET, me might
+ * get a bunch of vendor-specific TLVs (a.k.a. IEs) back from the
+ * firmware. Here's an example:
+ *	04 01 02 00 00 00 05 01 02 00 00 00 06 01 02 00
+ *	00 00 07 01 02 00 3c 00 00 00 00 00 00 00 03 03
+ *	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+ *
+ * The 04 01 is the TLV type (here TLV_TYPE_RSSI_LOW), 02 00 is the length,
+ * 00 00 are the data bytes of this TLV. For this TLV, their meaning is
+ * defined in mrvlietypes_thresholds
+ *
+ * This function searches in this TLV data chunk for a given TLV type
+ * and returns a pointer to the first data byte of the TLV, or to NULL
+ * if the TLV hasn't been found.
+ */
+static void *lbs_tlv_find(u16 tlv_type, const u8 *tlv, u16 size)
 {
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	void *response_buf;
-	int res, cmd_len;
+	__le16 le_type = cpu_to_le16(tlv_type);
 	ssize_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0) {
-		free_page(addr);
-		return res;
-	}
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_GET);
-	pcmdptr->size = cpu_to_le16(sizeof(*event) + S_DS_GEN);
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	event = (void *)(response_buf + S_DS_GEN);
-	while (cmd_len < le16_to_cpu(pcmdptr->size)) {
-		struct mrvlietypesheader *header = (void *)(response_buf + cmd_len);
-		switch (header->type) {
-		struct mrvlietypes_rssithreshold  *Lowrssi;
-		case __constant_cpu_to_le16(TLV_TYPE_RSSI_LOW):
-			Lowrssi = (void *)(response_buf + cmd_len);
-			pos += snprintf(buf+pos, len-pos, "%d %d %d\n",
-					Lowrssi->rssivalue,
-					Lowrssi->rssifreq,
-					(event->events & cpu_to_le16(0x0001))?1:0);
-		default:
-			cmd_len += sizeof(struct mrvlietypes_snrthreshold);
-			break;
-		}
+	struct mrvlietypesheader *tlv_h;
+	while (pos < size) {
+		u16 length;
+		tlv_h = (struct mrvlietypesheader *) tlv;
+		if (tlv_h->type == le_type)
+			return tlv_h;
+		if (tlv_h->len == 0)
+			return NULL;
+		length = le16_to_cpu(tlv_h->len) +
+			sizeof(struct mrvlietypesheader);
+		pos += length;
+		tlv += length;
 	}
-
-	kfree(response_buf);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	free_page(addr);
-	return res;
+	return NULL;
 }
 
+
+/*
+ * This just gets the bitmap of currently subscribed events. Used when
+ * adding an additonal event subscription.
+ */
 static u16 lbs_get_events_bitmap(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	void *response_buf;
-	int res;
-	u16 event_bitmap;
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0)
-		return res;
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_GET);
-	pcmdptr->size = cpu_to_le16(sizeof(*event) + S_DS_GEN);
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
+	ssize_t res;
 
-	pcmdptr = response_buf;
+	struct cmd_ds_802_11_subscribe_event *events = kzalloc(
+		sizeof(struct cmd_ds_802_11_subscribe_event),
+		GFP_KERNEL);
 
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		return 0;
-	}
+	res = lbs_prepare_and_send_command(priv,
+			CMD_802_11_SUBSCRIBE_EVENT, CMD_ACT_GET,
+			CMD_OPTION_WAITFORRSP, 0, events);
 
-	if (le16_to_cpu(pcmdptr->command) != CMD_RET(CMD_802_11_SUBSCRIBE_EVENT)) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
+	if (res) {
+		kfree(events);
 		return 0;
 	}
-
-	event = (struct cmd_ds_802_11_subscribe_event *)(response_buf + S_DS_GEN);
-	event_bitmap = le16_to_cpu(event->events);
-	kfree(response_buf);
-	return event_bitmap;
+	return le16_to_cpu(events->events);
 }
 
-static ssize_t lbs_lowrssi_write(struct file *file,
-				    const char __user *userbuf,
-				    size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	ssize_t res, buf_size;
-	int value, freq, subscribed, cmd_len;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	struct mrvlietypes_rssithreshold *rssi_threshold;
-	void *response_buf;
-	u16 event_bitmap;
-	u8 *ptr;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	buf_size = min(count, len - 1);
-	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	res = sscanf(buf, "%d %d %d", &value, &freq, &subscribed);
-	if (res != 3) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
 
-	event_bitmap = lbs_get_events_bitmap(priv);
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0)
-		goto out_unlock;
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_SET);
-	pcmdptr->size = cpu_to_le16(S_DS_GEN +
-		sizeof(struct cmd_ds_802_11_subscribe_event) +
-		sizeof(struct mrvlietypes_rssithreshold));
-
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	ptr = (u8*) pcmdptr+cmd_len;
-	rssi_threshold = (struct mrvlietypes_rssithreshold *)(ptr);
-	rssi_threshold->header.type = cpu_to_le16(0x0104);
-	rssi_threshold->header.len = cpu_to_le16(2);
-	rssi_threshold->rssivalue = value;
-	rssi_threshold->rssifreq = freq;
-	event_bitmap |= subscribed ? 0x0001 : 0x0;
-	event->events = cpu_to_le16(event_bitmap);
-
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	res = count;
-out_unlock:
-	free_page(addr);
-	return res;
-}
-
-static ssize_t lbs_lowsnr_read(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
+static ssize_t lbs_threshold_read(
+	u16 tlv_type, u16 event_mask,
+	struct file *file, char __user *userbuf,
+	size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	void *response_buf;
-	int res, cmd_len;
-	ssize_t pos = 0;
+	ssize_t res = 0;
+	size_t pos = 0;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
+	u8 freq;
+	u8 value;
 
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0) {
-		free_page(addr);
-		return res;
-	}
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_GET);
-	pcmdptr->size = cpu_to_le16(sizeof(*event) + S_DS_GEN);
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
+	struct cmd_ds_802_11_subscribe_event *events = kzalloc(
+		sizeof(struct cmd_ds_802_11_subscribe_event),
+		GFP_KERNEL);
+	struct mrvlietypes_thresholds *got;
 
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
+	res = lbs_prepare_and_send_command(priv,
+			CMD_802_11_SUBSCRIBE_EVENT, CMD_ACT_GET,
+			CMD_OPTION_WAITFORRSP, 0, events);
+	if (res) {
+		kfree(events);
+		return res;
 	}
 
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	event = (void *)(response_buf + S_DS_GEN);
-	while (cmd_len < le16_to_cpu(pcmdptr->size)) {
-		struct mrvlietypesheader *header = (void *)(response_buf + cmd_len);
-		switch (header->type) {
-		struct mrvlietypes_snrthreshold *LowSnr;
-		case __constant_cpu_to_le16(TLV_TYPE_SNR_LOW):
-			LowSnr = (void *)(response_buf + cmd_len);
-			pos += snprintf(buf+pos, len-pos, "%d %d %d\n",
-					LowSnr->snrvalue,
-					LowSnr->snrfreq,
-					(event->events & cpu_to_le16(0x0002))?1:0);
-		default:
-			cmd_len += sizeof(struct mrvlietypes_snrthreshold);
-			break;
-		}
+	got = lbs_tlv_find(tlv_type, events->tlv, sizeof(events->tlv));
+	if (got) {
+		value = got->value;
+		freq  = got->freq;
 	}
+	kfree(events);
 
-	kfree(response_buf);
+	if (got)
+		pos += snprintf(buf, len, "%d %d %d\n", freq, value,
+			!!(le16_to_cpu(events->events) & event_mask));
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	free_page(addr);
-	return res;
-}
-
-static ssize_t lbs_lowsnr_write(struct file *file,
-				    const char __user *userbuf,
-				    size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	ssize_t res, buf_size;
-	int value, freq, subscribed, cmd_len;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	struct mrvlietypes_snrthreshold *snr_threshold;
-	void *response_buf;
-	u16 event_bitmap;
-	u8 *ptr;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	buf_size = min(count, len - 1);
-	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	res = sscanf(buf, "%d %d %d", &value, &freq, &subscribed);
-	if (res != 3) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-
-	event_bitmap = lbs_get_events_bitmap(priv);
 
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0)
-		goto out_unlock;
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_SET);
-	pcmdptr->size = cpu_to_le16(S_DS_GEN +
-		sizeof(struct cmd_ds_802_11_subscribe_event) +
-		sizeof(struct mrvlietypes_snrthreshold));
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	ptr = (u8*) pcmdptr+cmd_len;
-	snr_threshold = (struct mrvlietypes_snrthreshold *)(ptr);
-	snr_threshold->header.type = cpu_to_le16(TLV_TYPE_SNR_LOW);
-	snr_threshold->header.len = cpu_to_le16(2);
-	snr_threshold->snrvalue = value;
-	snr_threshold->snrfreq = freq;
-	event_bitmap |= subscribed ? 0x0002 : 0x0;
-	event->events = cpu_to_le16(event_bitmap);
-
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	res = count;
-
-out_unlock:
 	free_page(addr);
 	return res;
 }
 
-static ssize_t lbs_failcount_read(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	void *response_buf;
-	int res, cmd_len;
-	ssize_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0) {
-		free_page(addr);
-		return res;
-	}
 
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_GET);
-	pcmdptr->size =	cpu_to_le16(sizeof(*event) + S_DS_GEN);
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	event = (void *)(response_buf + S_DS_GEN);
-	while (cmd_len < le16_to_cpu(pcmdptr->size)) {
-		struct mrvlietypesheader *header = (void *)(response_buf + cmd_len);
-		switch (header->type) {
-		struct mrvlietypes_failurecount *failcount;
-		case __constant_cpu_to_le16(TLV_TYPE_FAILCOUNT):
-			failcount = (void *)(response_buf + cmd_len);
-			pos += snprintf(buf+pos, len-pos, "%d %d %d\n",
-					failcount->failvalue,
-					failcount->Failfreq,
-					(event->events & cpu_to_le16(0x0004))?1:0);
-		default:
-			cmd_len += sizeof(struct mrvlietypes_failurecount);
-			break;
-		}
-	}
-
-	kfree(response_buf);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	free_page(addr);
-	return res;
-}
-
-static ssize_t lbs_failcount_write(struct file *file,
-				    const char __user *userbuf,
-				    size_t count, loff_t *ppos)
+static ssize_t lbs_threshold_write(
+	u16 tlv_type, u16 event_mask,
+	struct file *file,
+	const char __user *userbuf,
+	size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res, buf_size;
-	int value, freq, subscribed, cmd_len;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	struct mrvlietypes_failurecount *failcount;
-	void *response_buf;
-	u16 event_bitmap;
-	u8 *ptr;
+	int value, freq, curr_mask, new_mask;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
+	struct cmd_ds_802_11_subscribe_event *events;
 
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
 		goto out_unlock;
 	}
-	res = sscanf(buf, "%d %d %d", &value, &freq, &subscribed);
+	res = sscanf(buf, "%d %d %d", &value, &freq, &new_mask);
 	if (res != 3) {
 		res = -EFAULT;
 		goto out_unlock;
 	}
+	curr_mask = lbs_get_events_bitmap(priv);
 
-	event_bitmap = lbs_get_events_bitmap(priv);
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0)
-		goto out_unlock;
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_SET);
-	pcmdptr->size = cpu_to_le16(S_DS_GEN +
-		sizeof(struct cmd_ds_802_11_subscribe_event) +
-		sizeof(struct mrvlietypes_failurecount));
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	ptr = (u8*) pcmdptr+cmd_len;
-	failcount = (struct mrvlietypes_failurecount *)(ptr);
-	failcount->header.type = cpu_to_le16(TLV_TYPE_FAILCOUNT);
-	failcount->header.len = cpu_to_le16(2);
-	failcount->failvalue = value;
-	failcount->Failfreq = freq;
-	event_bitmap |= subscribed ? 0x0004 : 0x0;
-	event->events = cpu_to_le16(event_bitmap);
-
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = (struct cmd_ds_command *)response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
+	if (new_mask)
+		new_mask = curr_mask | event_mask;
+	else
+		new_mask = curr_mask & ~event_mask;
 
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
+	/* Now everything is set and we can send stuff down to the firmware */
+	events = kzalloc(
+		sizeof(struct cmd_ds_802_11_subscribe_event),
+		GFP_KERNEL);
+	if (events) {
+		struct mrvlietypes_thresholds *tlv =
+			(struct mrvlietypes_thresholds *) events->tlv;
+		events->action = cpu_to_le16(CMD_ACT_SET);
+		events->events = cpu_to_le16(new_mask);
+		tlv->header.type = cpu_to_le16(tlv_type);
+		tlv->header.len = cpu_to_le16(
+			sizeof(struct mrvlietypes_thresholds) -
+			sizeof(struct mrvlietypesheader));
+		tlv->value = value;
+		if (tlv_type != TLV_TYPE_BCNMISS)
+			tlv->freq = freq;
+		lbs_prepare_and_send_command(priv,
+			CMD_802_11_SUBSCRIBE_EVENT, CMD_ACT_SET,
+			CMD_OPTION_WAITFORRSP, 0, events);
+		kfree(events);
 	}
 
 	res = count;
@@ -909,457 +547,119 @@ out_unlock:
 	return res;
 }
 
-static ssize_t lbs_bcnmiss_read(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	void *response_buf;
-	int res, cmd_len;
-	ssize_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0) {
-		free_page(addr);
-		return res;
-	}
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_GET);
-	pcmdptr->size = cpu_to_le16(sizeof(*event) + S_DS_GEN);
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		free_page(addr);
-		kfree(response_buf);
-		return 0;
-	}
-
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		free_page(addr);
-		kfree(response_buf);
-		return 0;
-	}
-
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	event = (void *)(response_buf + S_DS_GEN);
-	while (cmd_len < le16_to_cpu(pcmdptr->size)) {
-		struct mrvlietypesheader *header = (void *)(response_buf + cmd_len);
-		switch (header->type) {
-		struct mrvlietypes_beaconsmissed *bcnmiss;
-		case __constant_cpu_to_le16(TLV_TYPE_BCNMISS):
-			bcnmiss = (void *)(response_buf + cmd_len);
-			pos += snprintf(buf+pos, len-pos, "%d N/A %d\n",
-					bcnmiss->beaconmissed,
-					(event->events & cpu_to_le16(0x0008))?1:0);
-		default:
-			cmd_len += sizeof(struct mrvlietypes_beaconsmissed);
-			break;
-		}
-	}
 
-	kfree(response_buf);
-
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	free_page(addr);
-	return res;
-}
-
-static ssize_t lbs_bcnmiss_write(struct file *file,
-				    const char __user *userbuf,
-				    size_t count, loff_t *ppos)
+static ssize_t lbs_lowrssi_read(
+	struct file *file, char __user *userbuf,
+	size_t count, loff_t *ppos)
 {
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	ssize_t res, buf_size;
-	int value, freq, subscribed, cmd_len;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	struct mrvlietypes_beaconsmissed *bcnmiss;
-	void *response_buf;
-	u16 event_bitmap;
-	u8 *ptr;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	buf_size = min(count, len - 1);
-	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	res = sscanf(buf, "%d %d %d", &value, &freq, &subscribed);
-	if (res != 3) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-
-	event_bitmap = lbs_get_events_bitmap(priv);
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0)
-		goto out_unlock;
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_SET);
-	pcmdptr->size = cpu_to_le16(S_DS_GEN +
-		sizeof(struct cmd_ds_802_11_subscribe_event) +
-		sizeof(struct mrvlietypes_beaconsmissed));
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	ptr = (u8*) pcmdptr+cmd_len;
-	bcnmiss = (struct mrvlietypes_beaconsmissed *)(ptr);
-	bcnmiss->header.type = cpu_to_le16(TLV_TYPE_BCNMISS);
-	bcnmiss->header.len = cpu_to_le16(2);
-	bcnmiss->beaconmissed = value;
-	event_bitmap |= subscribed ? 0x0008 : 0x0;
-	event->events = cpu_to_le16(event_bitmap);
-
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		free_page(addr);
-		kfree(response_buf);
-		return 0;
-	}
-
-	res = count;
-out_unlock:
-	free_page(addr);
-	return res;
+	return lbs_threshold_read(TLV_TYPE_RSSI_LOW, CMD_SUBSCRIBE_RSSI_LOW,
+		file, userbuf, count, ppos);
 }
 
-static ssize_t lbs_highrssi_read(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	void *response_buf;
-	int res, cmd_len;
-	ssize_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0) {
-		free_page(addr);
-		return res;
-	}
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_GET);
-	pcmdptr->size = cpu_to_le16(sizeof(*event) + S_DS_GEN);
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
-
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
-
-	pcmdptr = response_buf;
-
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
-
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
 
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	event = (void *)(response_buf + S_DS_GEN);
-	while (cmd_len < le16_to_cpu(pcmdptr->size)) {
-		struct mrvlietypesheader *header = (void *)(response_buf + cmd_len);
-		switch (header->type) {
-		struct mrvlietypes_rssithreshold  *Highrssi;
-		case __constant_cpu_to_le16(TLV_TYPE_RSSI_HIGH):
-			Highrssi = (void *)(response_buf + cmd_len);
-			pos += snprintf(buf+pos, len-pos, "%d %d %d\n",
-					Highrssi->rssivalue,
-					Highrssi->rssifreq,
-					(event->events & cpu_to_le16(0x0010))?1:0);
-		default:
-			cmd_len += sizeof(struct mrvlietypes_snrthreshold);
-			break;
-		}
-	}
-
-	kfree(response_buf);
-
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	free_page(addr);
-	return res;
-}
-
-static ssize_t lbs_highrssi_write(struct file *file,
-				    const char __user *userbuf,
-				    size_t count, loff_t *ppos)
+static ssize_t lbs_lowrssi_write(
+	struct file *file, const char __user *userbuf,
+	size_t count, loff_t *ppos)
 {
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	ssize_t res, buf_size;
-	int value, freq, subscribed, cmd_len;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	struct mrvlietypes_rssithreshold *rssi_threshold;
-	void *response_buf;
-	u16 event_bitmap;
-	u8 *ptr;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	buf_size = min(count, len - 1);
-	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	res = sscanf(buf, "%d %d %d", &value, &freq, &subscribed);
-	if (res != 3) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-
-	event_bitmap = lbs_get_events_bitmap(priv);
-
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0)
-		goto out_unlock;
-
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_SET);
-	pcmdptr->size = cpu_to_le16(S_DS_GEN +
-		sizeof(struct cmd_ds_802_11_subscribe_event) +
-		sizeof(struct mrvlietypes_rssithreshold));
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	ptr = (u8*) pcmdptr+cmd_len;
-	rssi_threshold = (struct mrvlietypes_rssithreshold *)(ptr);
-	rssi_threshold->header.type = cpu_to_le16(TLV_TYPE_RSSI_HIGH);
-	rssi_threshold->header.len = cpu_to_le16(2);
-	rssi_threshold->rssivalue = value;
-	rssi_threshold->rssifreq = freq;
-	event_bitmap |= subscribed ? 0x0010 : 0x0;
-	event->events = cpu_to_le16(event_bitmap);
+	return lbs_threshold_write(TLV_TYPE_RSSI_LOW, CMD_SUBSCRIBE_RSSI_LOW,
+		file, userbuf, count, ppos);
+}
 
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
 
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
+static ssize_t lbs_lowsnr_read(
+	struct file *file, char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_read(TLV_TYPE_SNR_LOW, CMD_SUBSCRIBE_SNR_LOW,
+		file, userbuf, count, ppos);
+}
 
-	pcmdptr = response_buf;
 
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		return 0;
-	}
+static ssize_t lbs_lowsnr_write(
+	struct file *file, const char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_write(TLV_TYPE_SNR_LOW, CMD_SUBSCRIBE_SNR_LOW,
+		file, userbuf, count, ppos);
+}
 
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		return 0;
-	}
 
-	res = count;
-out_unlock:
-	free_page(addr);
-	return res;
+static ssize_t lbs_failcount_read(
+	struct file *file, char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_read(TLV_TYPE_FAILCOUNT, CMD_SUBSCRIBE_FAILCOUNT,
+		file, userbuf, count, ppos);
 }
 
-static ssize_t lbs_highsnr_read(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	void *response_buf;
-	int res, cmd_len;
-	ssize_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
 
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0) {
-		free_page(addr);
-		return res;
-	}
+static ssize_t lbs_failcount_write(
+	struct file *file, const char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_write(TLV_TYPE_FAILCOUNT, CMD_SUBSCRIBE_FAILCOUNT,
+		file, userbuf, count, ppos);
+}
 
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_GET);
-	pcmdptr->size = cpu_to_le16(sizeof(*event) + S_DS_GEN);
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
 
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
+static ssize_t lbs_highrssi_read(
+	struct file *file, char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_read(TLV_TYPE_RSSI_HIGH, CMD_SUBSCRIBE_RSSI_HIGH,
+		file, userbuf, count, ppos);
+}
 
-	pcmdptr = response_buf;
 
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
+static ssize_t lbs_highrssi_write(
+	struct file *file, const char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_write(TLV_TYPE_RSSI_HIGH, CMD_SUBSCRIBE_RSSI_HIGH,
+		file, userbuf, count, ppos);
+}
 
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
 
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	event = (void *)(response_buf + S_DS_GEN);
-	while (cmd_len < le16_to_cpu(pcmdptr->size)) {
-		struct mrvlietypesheader *header = (void *)(response_buf + cmd_len);
-		switch (header->type) {
-		struct mrvlietypes_snrthreshold *HighSnr;
-		case __constant_cpu_to_le16(TLV_TYPE_SNR_HIGH):
-			HighSnr = (void *)(response_buf + cmd_len);
-			pos += snprintf(buf+pos, len-pos, "%d %d %d\n",
-					HighSnr->snrvalue,
-					HighSnr->snrfreq,
-					(event->events & cpu_to_le16(0x0020))?1:0);
-		default:
-			cmd_len += sizeof(struct mrvlietypes_snrthreshold);
-			break;
-		}
-	}
+static ssize_t lbs_highsnr_read(
+	struct file *file, char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_read(TLV_TYPE_SNR_HIGH, CMD_SUBSCRIBE_SNR_HIGH,
+		file, userbuf, count, ppos);
+}
 
-	kfree(response_buf);
 
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	free_page(addr);
-	return res;
+static ssize_t lbs_highsnr_write(
+	struct file *file, const char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_write(TLV_TYPE_SNR_HIGH, CMD_SUBSCRIBE_SNR_HIGH,
+		file, userbuf, count, ppos);
 }
 
-static ssize_t lbs_highsnr_write(struct file *file,
-				    const char __user *userbuf,
-				    size_t count, loff_t *ppos)
+static ssize_t lbs_bcnmiss_read(
+	struct file *file, char __user *userbuf,
+	size_t count, loff_t *ppos)
 {
-	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
-	ssize_t res, buf_size;
-	int value, freq, subscribed, cmd_len;
-	struct cmd_ctrl_node *pcmdnode;
-	struct cmd_ds_command *pcmdptr;
-	struct cmd_ds_802_11_subscribe_event *event;
-	struct mrvlietypes_snrthreshold *snr_threshold;
-	void *response_buf;
-	u16 event_bitmap;
-	u8 *ptr;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	buf_size = min(count, len - 1);
-	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	res = sscanf(buf, "%d %d %d", &value, &freq, &subscribed);
-	if (res != 3) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
+	return lbs_threshold_read(TLV_TYPE_BCNMISS, CMD_SUBSCRIBE_BCNMISS,
+		file, userbuf, count, ppos);
+}
 
-	event_bitmap = lbs_get_events_bitmap(priv);
 
-	res = lbs_event_initcmd(priv, &response_buf, &pcmdnode, &pcmdptr);
-	if (res < 0)
-		goto out_unlock;
+static ssize_t lbs_bcnmiss_write(
+	struct file *file, const char __user *userbuf,
+	size_t count, loff_t *ppos)
+{
+	return lbs_threshold_write(TLV_TYPE_BCNMISS, CMD_SUBSCRIBE_BCNMISS,
+		file, userbuf, count, ppos);
+}
 
-	event = &pcmdptr->params.subscribe_event;
-	event->action = cpu_to_le16(CMD_ACT_SET);
-	pcmdptr->size = cpu_to_le16(S_DS_GEN +
-		sizeof(struct cmd_ds_802_11_subscribe_event) +
-		sizeof(struct mrvlietypes_snrthreshold));
-	cmd_len = S_DS_GEN + sizeof(struct cmd_ds_802_11_subscribe_event);
-	ptr = (u8*) pcmdptr+cmd_len;
-	snr_threshold = (struct mrvlietypes_snrthreshold *)(ptr);
-	snr_threshold->header.type = cpu_to_le16(TLV_TYPE_SNR_HIGH);
-	snr_threshold->header.len = cpu_to_le16(2);
-	snr_threshold->snrvalue = value;
-	snr_threshold->snrfreq = freq;
-	event_bitmap |= subscribed ? 0x0020 : 0x0;
-	event->events = cpu_to_le16(event_bitmap);
 
-	lbs_queue_cmd(adapter, pcmdnode, 1);
-	wake_up_interruptible(&priv->waitq);
 
-	/* Sleep until response is generated by FW */
-	wait_event_interruptible(pcmdnode->cmdwait_q,
-				 pcmdnode->cmdwaitqwoken);
 
-	pcmdptr = response_buf;
 
-	if (pcmdptr->result) {
-		lbs_pr_err("%s: fail, result=%d\n", __func__,
-			   le16_to_cpu(pcmdptr->result));
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
 
-	if (pcmdptr->command != cpu_to_le16(CMD_RET(CMD_802_11_SUBSCRIBE_EVENT))) {
-		lbs_pr_err("command response incorrect!\n");
-		kfree(response_buf);
-		free_page(addr);
-		return 0;
-	}
 
-	res = count;
-out_unlock:
-	free_page(addr);
-	return res;
-}
 
 static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
@@ -1910,4 +1210,3 @@ static void lbs_debug_init(struct lbs_pr
 						  &lbs_debug_fops);
 }
 #endif
-
Index: wireless-2.6/drivers/net/wireless/libertas/hostcmd.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/hostcmd.h	2007-11-23 16:32:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/hostcmd.h	2007-11-23 16:39:04.000000000 +0100
@@ -151,6 +151,13 @@ struct cmd_ds_802_11_reset {
 struct cmd_ds_802_11_subscribe_event {
 	__le16 action;
 	__le16 events;
+
+	/* A TLV to the CMD_802_11_SUBSCRIBE_EVENT command can contain a
+	 * number of TLVs. From the v5.1 manual, those TLVs would add up to
+	 * 40 bytes. However, future firmware might add additional TLVs, so I
+	 * bump this up a bit.
+	 */
+	u8 tlv[128];
 };
 
 /*
Index: wireless-2.6/drivers/net/wireless/libertas/host.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/host.h	2007-11-23 16:32:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/host.h	2007-11-23 16:32:18.000000000 +0100
@@ -178,6 +178,14 @@
 #define CMD_TYPE_SHORT_PREAMBLE             0x0002
 #define CMD_TYPE_LONG_PREAMBLE              0x0003
 
+/* Event flags for CMD_802_11_SUBSCRIBE_EVENT */
+#define CMD_SUBSCRIBE_RSSI_LOW              0x0001
+#define CMD_SUBSCRIBE_SNR_LOW               0x0002
+#define CMD_SUBSCRIBE_FAILCOUNT             0x0004
+#define CMD_SUBSCRIBE_BCNMISS               0x0008
+#define CMD_SUBSCRIBE_RSSI_HIGH             0x0010
+#define CMD_SUBSCRIBE_SNR_HIGH              0x0020
+
 #define TURN_ON_RF                              0x01
 #define RADIO_ON                                0x01
 #define RADIO_OFF                               0x00
Index: wireless-2.6/drivers/net/wireless/libertas/types.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/types.h	2007-11-23 16:32:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/types.h	2007-11-23 16:32:18.000000000 +0100
@@ -201,22 +201,11 @@ struct mrvlietypes_powercapability {
 	s8 maxpower;
 } __attribute__ ((packed));
 
-struct mrvlietypes_rssithreshold {
-	struct mrvlietypesheader header;
-	u8 rssivalue;
-	u8 rssifreq;
-} __attribute__ ((packed));
-
-struct mrvlietypes_snrthreshold {
-	struct mrvlietypesheader header;
-	u8 snrvalue;
-	u8 snrfreq;
-} __attribute__ ((packed));
-
-struct mrvlietypes_failurecount {
+/* used in CMD_802_11_SUBSCRIBE_EVENT for SNR, RSSI and Failure */
+struct mrvlietypes_thresholds {
 	struct mrvlietypesheader header;
-	u8 failvalue;
-	u8 Failfreq;
+	u8 value;
+	u8 freq;
 } __attribute__ ((packed));
 
 struct mrvlietypes_beaconsmissed {
