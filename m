Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbXIAEfC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:02 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id E445A618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:00 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 08/35] Merge at76_download_external_fw() into  at76_load_external_fw()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:00 -0400
Message-ID: <20070901043500.2498.52295.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify logic to ensure that the last block is empty.  Unify
DFU_PACKETSIZE and EXT_FW_BLOCK_SIZE into FW_BLOCK_SIZE.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   98 ++++++++++++++++-----------------------
 1 files changed, 39 insertions(+), 59 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 8994b70..544b1ad 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -232,7 +232,7 @@ static const char *const mac_states[] = {
 #define DFU_GETSTATE			5
 #define DFU_ABORT			6
 
-#define DFU_PACKETSIZE 1024
+#define FW_BLOCK_SIZE 1024
 
 struct dfu_status {
 	unsigned char status;
@@ -312,7 +312,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *dfu_buffer,
 		return -EINVAL;
 	}
 
-	block = kmalloc(DFU_PACKETSIZE, GFP_KERNEL);
+	block = kmalloc(FW_BLOCK_SIZE, GFP_KERNEL);
 	if (!block)
 		return -ENOMEM;
 
@@ -353,7 +353,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *dfu_buffer,
 		case STATE_DFU_IDLE:
 			at76_dbg(DBG_DFU, "DFU IDLE");
 
-			dfu_block_bytes = min(dfu_bytes_left, DFU_PACKETSIZE);
+			dfu_block_bytes = min(dfu_bytes_left, FW_BLOCK_SIZE);
 			dfu_bytes_left -= dfu_block_bytes;
 			memcpy(block, dfu_buffer + dfu_buffer_offset,
 			       dfu_block_bytes);
@@ -725,54 +725,6 @@ static inline int at76_get_cmd_status(struct usb_device *udev, u8 cmd)
 	return stat_buf[5];
 }
 
-#define EXT_FW_BLOCK_SIZE 1024
-static int at76_download_external_fw(struct usb_device *udev, u8 *buf, int size)
-{
-	int i = 0;
-	int ret;
-	u8 *block;
-
-	if (size < 0)
-		return -EINVAL;
-	if (size > 0 && !buf)
-		return -EFAULT;
-
-	block = kmalloc(EXT_FW_BLOCK_SIZE, GFP_KERNEL);
-	if (!block)
-		return -ENOMEM;
-
-	at76_dbg(DBG_DEVSTART, "downloading external firmware");
-
-	while (size > 0) {
-		int bsize = size > EXT_FW_BLOCK_SIZE ? EXT_FW_BLOCK_SIZE : size;
-
-		memcpy(block, buf, bsize);
-		at76_dbg(DBG_DEVSTART,
-			 "ext fw, size left = %5d, bsize = %4d, i = %2d",
-			 size, bsize, i);
-		ret = at76_load_ext_fw_block(udev, i, block, bsize);
-		if (ret < 0) {
-			err("loading %dth firmware block failed: %d", i, ret);
-			goto exit;
-		}
-		buf += bsize;
-		size -= bsize;
-		i++;
-	}
-
-	/* for fw >= 0.100, the device needs
-	   an extra empty block: */
-	ret = at76_load_ext_fw_block(udev, i, block, 0);
-	if (ret < 0) {
-		err("loading %dth firmware block failed: %d", ret, i);
-		goto exit;
-	}
-
-exit:
-	kfree(block);
-	return ret;
-}
-
 static int at76_set_card_command(struct usb_device *udev, int cmd, void *buf,
 				 int buf_size)
 {
@@ -3609,6 +3561,14 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 {
 	int ret;
 	int op_mode;
+	int blockno = 0;
+	int bsize;
+	u8 *block;
+	u8 *buf = fwe->extfw;
+	int size = fwe->extfw_size;
+
+	if (!buf || !size)
+		return -ENOENT;
 
 	op_mode = at76_get_op_mode(udev);
 	at76_dbg(DBG_DEVSTART, "opmode %d", op_mode);
@@ -3618,20 +3578,40 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 		return -EINVAL;
 	}
 
-	if (!fwe->extfw || !fwe->extfw_size)
-		return -ENOENT;
+	block = kmalloc(FW_BLOCK_SIZE, GFP_KERNEL);
+	if (!block)
+		return -ENOMEM;
 
-	ret = at76_download_external_fw(udev, fwe->extfw, fwe->extfw_size);
-	if (ret < 0) {
-		err("Downloading external firmware failed: %d", ret);
-		return ret;
-	}
+	at76_dbg(DBG_DEVSTART, "downloading external firmware");
+
+	/* for fw >= 0.100, the device needs an extra empty block */
+	do {
+		bsize = min_t(int, size, FW_BLOCK_SIZE);
+		memcpy(block, buf, bsize);
+		at76_dbg(DBG_DEVSTART,
+			 "ext fw, size left = %5d, bsize = %4d, blockno = %2d",
+			 size, bsize, blockno);
+		ret = at76_load_ext_fw_block(udev, blockno, block, bsize);
+		if (ret != bsize) {
+			err("loading %dth firmware block failed: %d", blockno,
+			    ret);
+			goto exit;
+		}
+		buf += bsize;
+		size -= bsize;
+		blockno++;
+	} while (bsize > 0);
 
 	if (fwe->board_type == BOARD_505A_2958) {
 		at76_dbg(DBG_DEVSTART, "200 ms delay for board type 7");
 		schedule_timeout_interruptible(HZ / 5 + 1);
 	}
-	return 0;
+
+exit:
+	kfree(block);
+	if (ret < 0)
+		err("Downloading external firmware failed: %d", ret);
+	return ret;
 }
 
 /* Download internal firmware */
