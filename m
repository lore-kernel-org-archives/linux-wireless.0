Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34636 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaC2QQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2014 12:16:06 -0400
Received: by mail-pa0-f51.google.com with SMTP id kq14so6353666pab.10
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2014 09:16:05 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH] rsi: Fixes relating to issues reported by static code analyzers
Date: Sat, 29 Mar 2014 21:45:43 +0530
Message-Id: <1396109743-3352-1-git-send-email-fariyaf@gmail.com> (sfid-20140329_171612_023866_9EDA1F68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

This patch contains fixes relating to the issues reported by static code analyzers.

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     |    6 +++-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   35 ++++++++++++--------------
 drivers/net/wireless/rsi/rsi_91x_main.c     |    2 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   11 +++++---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |    5 ++-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    6 +---
 drivers/net/wireless/rsi/rsi_91x_usb.c      |   26 ++++++++++++++-----
 7 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index e89535e..1a8d321 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -102,10 +102,10 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 	}
 
 get_queue_num:
-	q_num = 0;
 	recontend_queue = false;
 
 	q_num = rsi_determine_min_weight_queue(common);
+
 	q_len = skb_queue_len(&common->tx_queue[ii]);
 	ii = q_num;
 
@@ -118,7 +118,9 @@ get_queue_num:
 		}
 	}
 
-	common->tx_qinfo[q_num].pkt_contended = 0;
+	if (q_num < NUM_EDCA_QUEUES)
+		common->tx_qinfo[q_num].pkt_contended = 0;
+
 	/* Adjust the back off values for all queues again */
 	recontend_queue = rsi_recalculate_weights(common);
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index 7e4ef45..c466246 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -289,32 +289,29 @@ int rsi_init_dbgfs(struct rsi_hw *adapter)
 	const struct rsi_dbg_files *files;
 
 	dev_dbgfs = kzalloc(sizeof(*dev_dbgfs), GFP_KERNEL);
+	if (!dev_dbgfs)
+		return -ENOMEM;
+
 	adapter->dfsentry = dev_dbgfs;
 
 	snprintf(devdir, sizeof(devdir), "%s",
 		 wiphy_name(adapter->hw->wiphy));
-	dev_dbgfs->subdir = debugfs_create_dir(devdir, NULL);
 
-	if (IS_ERR(dev_dbgfs->subdir)) {
-		if (dev_dbgfs->subdir == ERR_PTR(-ENODEV))
-			rsi_dbg(ERR_ZONE,
-				"%s:Debugfs has not been mounted\n", __func__);
-		else
-			rsi_dbg(ERR_ZONE, "debugfs:%s not created\n", devdir);
+	dev_dbgfs->subdir = debugfs_create_dir(devdir, NULL);
 
-		adapter->dfsentry = NULL;
+	if (!dev_dbgfs->subdir) {
 		kfree(dev_dbgfs);
-		return (int)PTR_ERR(dev_dbgfs->subdir);
-	} else {
-		for (ii = 0; ii < adapter->num_debugfs_entries; ii++) {
-			files = &dev_debugfs_files[ii];
-			dev_dbgfs->rsi_files[ii] =
-			debugfs_create_file(files->name,
-					    files->perms,
-					    dev_dbgfs->subdir,
-					    common,
-					    &files->fops);
-		}
+		return -ENOMEM;
+	}
+
+	for (ii = 0; ii < adapter->num_debugfs_entries; ii++) {
+		files = &dev_debugfs_files[ii];
+		dev_dbgfs->rsi_files[ii] =
+		debugfs_create_file(files->name,
+				    files->perms,
+				    dev_dbgfs->subdir,
+				    common,
+				    &files->fops);
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 8810862..e491f38 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -51,7 +51,7 @@ void rsi_dbg(u32 zone, const char *fmt, ...)
 	vaf.va = &args;
 
 	if (zone & rsi_zone_enabled)
-		pr_info("%pV", &vaf);
+		pr_debug("%pV", &vaf);
 	va_end(args);
 }
 EXPORT_SYMBOL_GPL(rsi_dbg);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index ef37d4b..7369429 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -738,7 +738,7 @@ int rsi_hal_load_key(struct rsi_common *common,
  *
  * Return: 0 on success, corresponding error code on failure.
  */
-static u8 rsi_load_bootup_params(struct rsi_common *common)
+static int rsi_load_bootup_params(struct rsi_common *common)
 {
 	struct sk_buff *skb;
 	struct rsi_boot_params *boot_params;
@@ -1272,6 +1272,7 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 {
 	s32 msg_len = (le16_to_cpu(*(__le16 *)&msg[0]) & 0x0fff);
 	u16 msg_type = (msg[2]);
+	int ret;
 
 	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
 		__func__, msg_len, msg_type);
@@ -1284,18 +1285,20 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 		if (common->fsm_state == FSM_CARD_NOT_READY) {
 			rsi_set_default_parameters(common);
 
-			if (rsi_load_bootup_params(common))
-				return -ENOMEM;
+			ret = rsi_load_bootup_params(common);
+			if (ret)
+				return ret;
 			else
 				common->fsm_state = FSM_BOOT_PARAMS_SENT;
 		} else {
 			return -EINVAL;
 		}
 	} else if (msg_type == TX_STATUS_IND) {
-		if (msg[15] == PROBEREQ_CONFIRM)
+		if (msg[15] == PROBEREQ_CONFIRM) {
 			common->mgmt_q_block = false;
 			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
 				__func__);
+		}
 	} else {
 		return rsi_mgmt_pkt_to_core(common, msg, msg_len, msg_type);
 	}
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 852453f..2e39d38 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -756,12 +756,13 @@ fail:
 static void rsi_disconnect(struct sdio_func *pfunction)
 {
 	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev;
 
 	if (!adapter)
 		return;
 
+	dev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
+
 	dev->write_fail = 2;
 	rsi_mac80211_detach(adapter);
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index f1cb99c..20d11cc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -247,7 +247,7 @@ static int rsi_process_pkt(struct rsi_common *common)
 	if (!common->rx_data_pkt) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in memory allocation\n",
 			__func__);
-		return -1;
+		return -ENOMEM;
 	}
 
 	status = rsi_sdio_host_intf_read_pkt(adapter,
@@ -260,12 +260,10 @@ static int rsi_process_pkt(struct rsi_common *common)
 	}
 
 	status = rsi_read_pkt(common, rcv_pkt_len);
-	kfree(common->rx_data_pkt);
-	return status;
 
 fail:
 	kfree(common->rx_data_pkt);
-	return -1;
+	return status;
 }
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index bb1bf96..4c46e56 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -154,24 +154,30 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 			    u16 *value,
 			    u16 len)
 {
-	u8 temp_buf[4];
-	int status = 0;
+	u8 *buf;
+	int status = -ENOMEM;
+
+	buf  = kmalloc(0x04, GFP_KERNEL);
+	if (!buf)
+		return status;
 
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_READ,
 				 USB_TYPE_VENDOR,
 				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
-				 (void *)temp_buf,
+				 (void *)buf,
 				 len,
 				 HZ * 5);
 
-	*value = (temp_buf[0] | (temp_buf[1] << 8));
+	*value = (buf[0] | (buf[1] << 8));
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Reg read failed with error code :%d\n",
 			__func__, status);
 	}
+	kfree(buf);
+
 	return status;
 }
 
@@ -190,8 +196,12 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 			     u16 value,
 			     u16 len)
 {
-	u8 usb_reg_buf[4];
-	int status = 0;
+	u8 *usb_reg_buf;
+	int status = -ENOMEM;
+
+	usb_reg_buf  = kmalloc(0x04, GFP_KERNEL);
+	if (!usb_reg_buf)
+		return status;
 
 	usb_reg_buf[0] = (value & 0x00ff);
 	usb_reg_buf[1] = (value & 0xff00) >> 8;
@@ -212,6 +222,8 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 			"%s: Reg write failed with error code :%d\n",
 			__func__, status);
 	}
+	kfree(usb_reg_buf);
+
 	return status;
 }
 
@@ -286,7 +298,7 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 		return -ENOMEM;
 
 	while (count) {
-		transfer = min_t(int, count, 4096);
+		transfer = (u8)(min_t(u32, count, 4096));
 		memcpy(buf, data, transfer);
 		status = usb_control_msg(dev->usbdev,
 					 usb_sndctrlpipe(dev->usbdev, 0),
-- 
1.7.5.4

