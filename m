Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbXIAEfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:07 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 9FF38618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:06 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 09/35] Simplify at76_usbdfu_download()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:06 -0400
Message-ID: <20070901043506.2498.54946.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it look similar to at76_load_external_fw()

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   52 +++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 29 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 544b1ad..41f28dc 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -245,16 +245,10 @@ struct dfu_status {
 static int at76_load_int_fw_block(struct usb_device *udev, int blockno,
 				  void *block, int size)
 {
-	int ret;
-
-	at76_dbg(DBG_DFU, "%s(): block=%p, size=%d, blockno=%d", __func__,
-		 block, size, blockno);
-
-	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), DFU_DNLOAD,
-			      USB_TYPE_CLASS | USB_DIR_OUT |
-			      USB_RECIP_INTERFACE, blockno, 0, block, size,
-			      USB_CTRL_GET_TIMEOUT);
-	return ret;
+	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0), DFU_DNLOAD,
+			       USB_TYPE_CLASS | USB_DIR_OUT |
+			       USB_RECIP_INTERFACE, blockno, 0, block, size,
+			       USB_CTRL_GET_TIMEOUT);
 }
 
 static int at76_dfu_get_status(struct usb_device *udev,
@@ -289,8 +283,8 @@ static inline u32 at76_get_timeout(struct dfu_status *s)
 
 /* Load internal firmware from the buffer.  If manifest_sync_timeout > 0, use
  * its value in msec in the MANIFEST_SYNC state.  */
-static int at76_usbdfu_download(struct usb_device *udev, u8 *dfu_buffer,
-				u32 dfu_len, int manifest_sync_timeout)
+static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
+				int manifest_sync_timeout)
 {
 	u8 *block;
 	struct dfu_status dfu_stat_buf;
@@ -299,15 +293,13 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *dfu_buffer,
 	int is_done = 0;
 	u8 dfu_state = 0;
 	u32 dfu_timeout = 0;
-	int dfu_block_bytes = 0;
-	int dfu_bytes_left = dfu_len;
-	int dfu_buffer_offset = 0;
-	int dfu_block_cnt = 0;
+	int bsize = 0;
+	int blockno = 0;
 
-	at76_dbg(DBG_DFU, "%s( %p, %u, %d)", __func__, dfu_buffer,
-		 dfu_len, manifest_sync_timeout);
+	at76_dbg(DBG_DFU, "%s( %p, %u, %d)", __func__, buf, size,
+		 manifest_sync_timeout);
 
-	if (dfu_len == 0) {
+	if (!size) {
 		err("FW Buffer length invalid!");
 		return -EINVAL;
 	}
@@ -353,16 +345,18 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *dfu_buffer,
 		case STATE_DFU_IDLE:
 			at76_dbg(DBG_DFU, "DFU IDLE");
 
-			dfu_block_bytes = min(dfu_bytes_left, FW_BLOCK_SIZE);
-			dfu_bytes_left -= dfu_block_bytes;
-			memcpy(block, dfu_buffer + dfu_buffer_offset,
-			       dfu_block_bytes);
-			ret = at76_load_int_fw_block(udev, dfu_block_cnt, block,
-						     dfu_block_bytes);
-			dfu_buffer_offset += dfu_block_bytes;
-			dfu_block_cnt++;
-
-			if (ret < 0)
+			bsize = min_t(int, size, FW_BLOCK_SIZE);
+			memcpy(block, buf, bsize);
+			at76_dbg(DBG_DFU, "int fw, size left = %5d, "
+				 "bsize = %4d, blockno = %2d", size, bsize,
+				 blockno);
+			ret =
+			    at76_load_int_fw_block(udev, blockno, block, bsize);
+			buf += bsize;
+			size -= bsize;
+			blockno++;
+
+			if (ret != bsize)
 				err("dfu_download_block failed with %d", ret);
 			need_dfu_state = 1;
 			break;
