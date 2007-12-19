Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40767 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXLSQKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:12 -0500
Subject: [PATCH 133/48] libertas: convert SUBSCRIBE_EVENT to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50vL-000226-4g@pmac.infradead.org> (sfid-20071219_161018_069795_6606C2A5)
Date: Wed, 19 Dec 2007 15:33:31 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 18 Dec 2007 02:01:37 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   52 +------
 drivers/net/wireless/libertas/cmdresp.c |   22 ---
 drivers/net/wireless/libertas/debugfs.c |  282 ++++++++++++++-----------------
 drivers/net/wireless/libertas/hostcmd.h |    5 +-
 4 files changed, 135 insertions(+), 226 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 5d2c928..4d06dec 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -327,53 +327,6 @@ int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
 	return ret;
 }
 
-
-static ssize_t lbs_tlv_size(const u8 *tlv, u16 size)
-{
-	ssize_t pos = 0;
-	struct mrvlietypesheader *tlv_h;
-	while (pos < size) {
-		u16 length;
-		tlv_h = (struct mrvlietypesheader *) tlv;
-		if (tlv_h->len == 0)
-			return pos;
-		length = le16_to_cpu(tlv_h->len) +
-			sizeof(struct mrvlietypesheader);
-		pos += length;
-		tlv += length;
-	}
-	return pos;
-}
-
-
-static void lbs_cmd_802_11_subscribe_event(struct lbs_private *priv,
-	struct cmd_ds_command *cmd, u16 cmd_action,
-	void *pdata_buf)
-{
-	struct cmd_ds_802_11_subscribe_event *events =
-		(struct cmd_ds_802_11_subscribe_event *) pdata_buf;
-
-	/* pdata_buf points to a struct cmd_ds_802_11_subscribe_event and room
-	 * for various Marvell TLVs */
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd->size = cpu_to_le16(sizeof(*events)
-			- sizeof(events->tlv)
-			+ S_DS_GEN);
-	cmd->params.subscribe_event.action = cpu_to_le16(cmd_action);
-	if (cmd_action == CMD_ACT_GET) {
-		cmd->params.subscribe_event.events = 0;
-	} else {
-		ssize_t sz = lbs_tlv_size(events->tlv, sizeof(events->tlv));
-		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) + sz);
-		cmd->params.subscribe_event.events = events->events;
-		memcpy(cmd->params.subscribe_event.tlv, events->tlv, sz);
-	}
-
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
 static void set_one_wpa_key(struct MrvlIEtype_keyParamSet * pkeyparamset,
                             struct enc_key * pkey)
 {
@@ -1545,10 +1498,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 			ret = 0;
 			break;
 		}
-	case CMD_802_11_SUBSCRIBE_EVENT:
-		lbs_cmd_802_11_subscribe_event(priv, cmdptr,
-			cmd_action, pdata_buf);
-		break;
+
 	case CMD_802_11_PWR_CFG:
 		cmdptr->command = cpu_to_le16(CMD_802_11_PWR_CFG);
 		cmdptr->size =
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 8b71926..159216a 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -389,25 +389,6 @@ static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
 	return 0;
 }
 
-static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
-	struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_subscribe_event *cmd_event =
-		&resp->params.subscribe_event;
-	struct cmd_ds_802_11_subscribe_event *dst_event =
-		(void *)priv->cur_cmd->callback_arg;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (dst_event->action == cpu_to_le16(CMD_ACT_GET)) {
-		dst_event->events = cmd_event->events;
-		memcpy(dst_event->tlv, cmd_event->tlv, sizeof(dst_event->tlv));
-	}
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static inline int handle_cmd_response(struct lbs_private *priv,
 				      unsigned long dummy,
 				      struct cmd_header *cmd_response)
@@ -518,9 +499,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 			sizeof(struct cmd_ds_802_11_led_ctrl));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
-	case CMD_RET(CMD_802_11_SUBSCRIBE_EVENT):
-		ret = lbs_ret_802_11_subscribe_event(priv, resp);
-		break;
 
 	case CMD_RET(CMD_802_11_PWR_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index fa6c594..2174717 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -346,20 +346,19 @@ static ssize_t lbs_setuserscan(struct file *file,
  * and returns a pointer to the first data byte of the TLV, or to NULL
  * if the TLV hasn't been found.
  */
-static void *lbs_tlv_find(u16 tlv_type, const u8 *tlv, u16 size)
+static void *lbs_tlv_find(uint16_t tlv_type, const uint8_t *tlv, uint16_t size)
 {
-	__le16 le_type = cpu_to_le16(tlv_type);
-	ssize_t pos = 0;
 	struct mrvlietypesheader *tlv_h;
+	uint16_t length;
+	ssize_t pos = 0;
+
 	while (pos < size) {
-		u16 length;
 		tlv_h = (struct mrvlietypesheader *) tlv;
-		if (tlv_h->type == le_type)
-			return tlv_h;
-		if (tlv_h->len == 0)
+		if (!tlv_h->len)
 			return NULL;
-		length = le16_to_cpu(tlv_h->len) +
-			sizeof(struct mrvlietypesheader);
+		if (tlv_h->type == cpu_to_le16(tlv_type))
+			return tlv_h;
+		length = le16_to_cpu(tlv_h->len) + sizeof(*tlv_h);
 		pos += length;
 		tlv += length;
 	}
@@ -367,100 +366,100 @@ static void *lbs_tlv_find(u16 tlv_type, const u8 *tlv, u16 size)
 }
 
 
-/*
- * This just gets the bitmap of currently subscribed events. Used when
- * adding an additonal event subscription.
- */
-static u16 lbs_get_events_bitmap(struct lbs_private *priv)
-{
-	ssize_t res;
-
-	struct cmd_ds_802_11_subscribe_event *events = kzalloc(
-		sizeof(struct cmd_ds_802_11_subscribe_event),
-		GFP_KERNEL);
-
-	res = lbs_prepare_and_send_command(priv,
-			CMD_802_11_SUBSCRIBE_EVENT, CMD_ACT_GET,
-			CMD_OPTION_WAITFORRSP, 0, events);
-
-	if (res) {
-		kfree(events);
-		return 0;
-	}
-	return le16_to_cpu(events->events);
-}
-
-
-static ssize_t lbs_threshold_read(
-	u16 tlv_type, u16 event_mask,
-	struct file *file, char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
+				  struct file *file, char __user *userbuf,
+				  size_t count, loff_t *ppos)
 {
+	struct cmd_ds_802_11_subscribe_event *subscribed;
+	struct mrvlietypes_thresholds *got;
 	struct lbs_private *priv = file->private_data;
-	ssize_t res = 0;
+	ssize_t ret = 0;
 	size_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf;
 	u8 value;
 	u8 freq;
 	int events = 0;
 
-	struct cmd_ds_802_11_subscribe_event *subscribed = kzalloc(
-		sizeof(struct cmd_ds_802_11_subscribe_event),
-		GFP_KERNEL);
-	struct mrvlietypes_thresholds *got;
+	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	res = lbs_prepare_and_send_command(priv,
-			CMD_802_11_SUBSCRIBE_EVENT, CMD_ACT_GET,
-			CMD_OPTION_WAITFORRSP, 0, subscribed);
-	if (res) {
-		kfree(subscribed);
-		return res;
+	subscribed = kzalloc(sizeof(*subscribed), GFP_KERNEL);
+	if (!subscribed) {
+		ret = -ENOMEM;
+		goto out_page;
 	}
 
+	subscribed->hdr.size = cpu_to_le16(sizeof(*subscribed));
+	subscribed->action = cpu_to_le16(CMD_ACT_GET);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SUBSCRIBE_EVENT, subscribed);
+	if (ret)
+		goto out_cmd;
+
 	got = lbs_tlv_find(tlv_type, subscribed->tlv, sizeof(subscribed->tlv));
 	if (got) {
 		value = got->value;
 		freq  = got->freq;
 		events = le16_to_cpu(subscribed->events);
-	}
-	kfree(subscribed);
 
-	if (got)
 		pos += snprintf(buf, len, "%d %d %d\n", value, freq,
-			!!(events & event_mask));
+				!!(events & event_mask));
+	}
 
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
-	free_page(addr);
-	return res;
+ out_cmd:
+	kfree(subscribed);
+
+ out_page:
+	free_page((unsigned long)buf);
+	return ret;
 }
 
 
-static ssize_t lbs_threshold_write(
-	u16 tlv_type, u16 event_mask,
-	struct file *file,
-	const char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_threshold_write(uint16_t tlv_type, uint16_t event_mask,
+				   struct file *file,
+				   const char __user *userbuf, size_t count,
+				   loff_t *ppos)
 {
-	struct lbs_private *priv = file->private_data;
-	ssize_t res, buf_size;
-	int value, freq, curr_mask, new_mask;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
 	struct cmd_ds_802_11_subscribe_event *events;
+	struct mrvlietypes_thresholds *tlv;
+	struct lbs_private *priv = file->private_data;
+	ssize_t buf_size;
+	int value, freq, new_mask;
+	uint16_t curr_mask;
+	char *buf;
+	int ret;
+
+	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock;
+		ret = -EFAULT;
+		goto out_page;
 	}
-	res = sscanf(buf, "%d %d %d", &value, &freq, &new_mask);
-	if (res != 3) {
-		res = -EFAULT;
-		goto out_unlock;
+	ret = sscanf(buf, "%d %d %d", &value, &freq, &new_mask);
+	if (ret != 3) {
+		ret = -EINVAL;
+		goto out_page;
 	}
-	curr_mask = lbs_get_events_bitmap(priv);
+	events = kzalloc(sizeof(*events), GFP_KERNEL);
+	if (!events) {
+		ret = -ENOMEM;
+		goto out_page;
+	}
+
+	events->hdr.size = cpu_to_le16(sizeof(*events));
+	events->action = cpu_to_le16(CMD_ACT_GET);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SUBSCRIBE_EVENT, events);
+	if (ret)
+		goto out_events;
+
+	curr_mask = le16_to_cpu(events->events);
 
 	if (new_mask)
 		new_mask = curr_mask | event_mask;
@@ -468,147 +467,128 @@ static ssize_t lbs_threshold_write(
 		new_mask = curr_mask & ~event_mask;
 
 	/* Now everything is set and we can send stuff down to the firmware */
-	events = kzalloc(
-		sizeof(struct cmd_ds_802_11_subscribe_event),
-		GFP_KERNEL);
-	if (events) {
-		struct mrvlietypes_thresholds *tlv =
-			(struct mrvlietypes_thresholds *) events->tlv;
-		events->action = cpu_to_le16(CMD_ACT_SET);
-		events->events = cpu_to_le16(new_mask);
-		tlv->header.type = cpu_to_le16(tlv_type);
-		tlv->header.len = cpu_to_le16(
-			sizeof(struct mrvlietypes_thresholds) -
-			sizeof(struct mrvlietypesheader));
-		tlv->value = value;
-		if (tlv_type != TLV_TYPE_BCNMISS)
-			tlv->freq = freq;
-		lbs_prepare_and_send_command(priv,
-			CMD_802_11_SUBSCRIBE_EVENT, CMD_ACT_SET,
-			CMD_OPTION_WAITFORRSP, 0, events);
-		kfree(events);
-	}
 
-	res = count;
-out_unlock:
-	free_page(addr);
-	return res;
+	tlv = (void *)events->tlv;
+
+	events->action = cpu_to_le16(CMD_ACT_SET);
+	events->events = cpu_to_le16(new_mask);
+	tlv->header.type = cpu_to_le16(tlv_type);
+	tlv->header.len = cpu_to_le16(sizeof(*tlv) - sizeof(tlv->header));
+	tlv->value = value;
+	if (tlv_type != TLV_TYPE_BCNMISS)
+		tlv->freq = freq;
+
+	/* The command header, the event mask, and the one TLV */
+	events->hdr.size = cpu_to_le16(sizeof(events->hdr) + 2 + sizeof(*tlv));
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SUBSCRIBE_EVENT, events);
+
+	if (!ret)
+		ret = count;
+ out_events:
+	kfree(events);
+ out_page:
+	free_page((unsigned long)buf);
+	return ret;
 }
 
 
-static ssize_t lbs_lowrssi_read(
-	struct file *file, char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_lowrssi_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
 {
 	return lbs_threshold_read(TLV_TYPE_RSSI_LOW, CMD_SUBSCRIBE_RSSI_LOW,
-		file, userbuf, count, ppos);
+				  file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_lowrssi_write(
-	struct file *file, const char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_lowrssi_write(struct file *file, const char __user *userbuf,
+				 size_t count, loff_t *ppos)
 {
 	return lbs_threshold_write(TLV_TYPE_RSSI_LOW, CMD_SUBSCRIBE_RSSI_LOW,
-		file, userbuf, count, ppos);
+				   file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_lowsnr_read(
-	struct file *file, char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_lowsnr_read(struct file *file, char __user *userbuf,
+			       size_t count, loff_t *ppos)
 {
 	return lbs_threshold_read(TLV_TYPE_SNR_LOW, CMD_SUBSCRIBE_SNR_LOW,
-		file, userbuf, count, ppos);
+				  file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_lowsnr_write(
-	struct file *file, const char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_lowsnr_write(struct file *file, const char __user *userbuf,
+				size_t count, loff_t *ppos)
 {
 	return lbs_threshold_write(TLV_TYPE_SNR_LOW, CMD_SUBSCRIBE_SNR_LOW,
-		file, userbuf, count, ppos);
+				   file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_failcount_read(
-	struct file *file, char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_failcount_read(struct file *file, char __user *userbuf,
+				  size_t count, loff_t *ppos)
 {
 	return lbs_threshold_read(TLV_TYPE_FAILCOUNT, CMD_SUBSCRIBE_FAILCOUNT,
-		file, userbuf, count, ppos);
+				  file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_failcount_write(
-	struct file *file, const char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_failcount_write(struct file *file, const char __user *userbuf,
+				   size_t count, loff_t *ppos)
 {
 	return lbs_threshold_write(TLV_TYPE_FAILCOUNT, CMD_SUBSCRIBE_FAILCOUNT,
-		file, userbuf, count, ppos);
+				   file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_highrssi_read(
-	struct file *file, char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_highrssi_read(struct file *file, char __user *userbuf,
+				 size_t count, loff_t *ppos)
 {
 	return lbs_threshold_read(TLV_TYPE_RSSI_HIGH, CMD_SUBSCRIBE_RSSI_HIGH,
-		file, userbuf, count, ppos);
+				  file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_highrssi_write(
-	struct file *file, const char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_highrssi_write(struct file *file, const char __user *userbuf,
+				  size_t count, loff_t *ppos)
 {
 	return lbs_threshold_write(TLV_TYPE_RSSI_HIGH, CMD_SUBSCRIBE_RSSI_HIGH,
-		file, userbuf, count, ppos);
+				   file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_highsnr_read(
-	struct file *file, char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_highsnr_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
 {
 	return lbs_threshold_read(TLV_TYPE_SNR_HIGH, CMD_SUBSCRIBE_SNR_HIGH,
-		file, userbuf, count, ppos);
+				  file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_highsnr_write(
-	struct file *file, const char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_highsnr_write(struct file *file, const char __user *userbuf,
+				 size_t count, loff_t *ppos)
 {
 	return lbs_threshold_write(TLV_TYPE_SNR_HIGH, CMD_SUBSCRIBE_SNR_HIGH,
-		file, userbuf, count, ppos);
+				   file, userbuf, count, ppos);
 }
 
-static ssize_t lbs_bcnmiss_read(
-	struct file *file, char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_bcnmiss_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
 {
 	return lbs_threshold_read(TLV_TYPE_BCNMISS, CMD_SUBSCRIBE_BCNMISS,
-		file, userbuf, count, ppos);
+				  file, userbuf, count, ppos);
 }
 
 
-static ssize_t lbs_bcnmiss_write(
-	struct file *file, const char __user *userbuf,
-	size_t count, loff_t *ppos)
+static ssize_t lbs_bcnmiss_write(struct file *file, const char __user *userbuf,
+				 size_t count, loff_t *ppos)
 {
 	return lbs_threshold_write(TLV_TYPE_BCNMISS, CMD_SUBSCRIBE_BCNMISS,
-		file, userbuf, count, ppos);
+				   file, userbuf, count, ppos);
 }
 
 
 
-
-
-
-
-
 static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index fffec11..be325ed 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -156,6 +156,8 @@ struct cmd_ds_802_11_reset {
 };
 
 struct cmd_ds_802_11_subscribe_event {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le16 events;
 
@@ -164,7 +166,7 @@ struct cmd_ds_802_11_subscribe_event {
 	 * 40 bytes. However, future firmware might add additional TLVs, so I
 	 * bump this up a bit.
 	 */
-	u8 tlv[128];
+	uint8_t tlv[128];
 };
 
 /*
@@ -728,7 +730,6 @@ struct cmd_ds_command {
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
 		struct cmd_ds_get_tsf gettsf;
-		struct cmd_ds_802_11_subscribe_event subscribe_event;
 		struct cmd_ds_802_11_beacon_control bcn_ctrl;
 	} params;
 } __attribute__ ((packed));
-- 
1.5.3.4

