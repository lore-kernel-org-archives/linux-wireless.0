Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62248 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaEXPH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 11:07:27 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so2192776wib.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 08:07:25 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: oku@masqmail.cx, joerg.albert@gmx.de, alex@foogod.com,
	n0_5p4m_p13453@hotmail.com, proski@gnu.org, agx@sigxcpu.org,
	kalle.valo@iki.fi, sesmo@gmx.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 1/2] at76c50x-usb: Don't perform DMA from stack memory
Date: Sat, 24 May 2014 17:07:12 +0200
Message-Id: <1400944032-14541-1-git-send-email-andrea.merello@gmail.com> (sfid-20140524_171025_540808_1E1341E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loading the driver with DMA debugging enabled makes the kernel to complain
about the ehci driver trying to perform DMA from memory from the stack.

[ 9848.229514] WARNING: CPU: 1 PID: 627 at lib/dma-debug.c:1153 check_for_stack+0xa4/0xf0()
[ 9848.237678] ehci-pci 0000:00:04.1: DMA-API: device driver maps memory fromstack [addr=ffff88006c80da01]

This is due to at76c50x-usb driver passing buffers allocated on the stack to
the USB layer, that attempts DMA. This occurs is several places.

This patch fixes the problem by allocating those buffers via kmalloc.

Since this adds some kfree() before leaving a couple of functions, I caught the
occasion to clean-up the exit path on error.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/at76c50x-usb.c | 87 ++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 99b3bfa..9e6e9fc 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -365,15 +365,15 @@ static inline unsigned long at76_get_timeout(struct dfu_status *s)
 static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 				int manifest_sync_timeout)
 {
-	u8 *block;
-	struct dfu_status dfu_stat_buf;
 	int ret = 0;
 	int need_dfu_state = 1;
 	int is_done = 0;
-	u8 dfu_state = 0;
 	u32 dfu_timeout = 0;
 	int bsize = 0;
 	int blockno = 0;
+	struct dfu_status *dfu_stat_buf = NULL;
+	u8 *dfu_state = NULL;
+	u8 *block = NULL;
 
 	at76_dbg(DBG_DFU, "%s( %p, %u, %d)", __func__, buf, size,
 		 manifest_sync_timeout);
@@ -383,13 +383,28 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 		return -EINVAL;
 	}
 
+	dfu_stat_buf = kmalloc(sizeof(struct dfu_status), GFP_KERNEL);
+	if (!dfu_stat_buf) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
 	block = kmalloc(FW_BLOCK_SIZE, GFP_KERNEL);
-	if (!block)
-		return -ENOMEM;
+	if (!block) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	dfu_state = kmalloc(sizeof(u8), GFP_KERNEL);
+	if (!dfu_state) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+	*dfu_state = 0;
 
 	do {
 		if (need_dfu_state) {
-			ret = at76_dfu_get_state(udev, &dfu_state);
+			ret = at76_dfu_get_state(udev, dfu_state);
 			if (ret < 0) {
 				dev_err(&udev->dev,
 					"cannot get DFU state: %d\n", ret);
@@ -398,13 +413,13 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 			need_dfu_state = 0;
 		}
 
-		switch (dfu_state) {
+		switch (*dfu_state) {
 		case STATE_DFU_DOWNLOAD_SYNC:
 			at76_dbg(DBG_DFU, "STATE_DFU_DOWNLOAD_SYNC");
-			ret = at76_dfu_get_status(udev, &dfu_stat_buf);
+			ret = at76_dfu_get_status(udev, dfu_stat_buf);
 			if (ret >= 0) {
-				dfu_state = dfu_stat_buf.state;
-				dfu_timeout = at76_get_timeout(&dfu_stat_buf);
+				*dfu_state = dfu_stat_buf->state;
+				dfu_timeout = at76_get_timeout(dfu_stat_buf);
 				need_dfu_state = 0;
 			} else
 				dev_err(&udev->dev,
@@ -447,12 +462,12 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 		case STATE_DFU_MANIFEST_SYNC:
 			at76_dbg(DBG_DFU, "STATE_DFU_MANIFEST_SYNC");
 
-			ret = at76_dfu_get_status(udev, &dfu_stat_buf);
+			ret = at76_dfu_get_status(udev, dfu_stat_buf);
 			if (ret < 0)
 				break;
 
-			dfu_state = dfu_stat_buf.state;
-			dfu_timeout = at76_get_timeout(&dfu_stat_buf);
+			*dfu_state = dfu_stat_buf->state;
+			dfu_timeout = at76_get_timeout(dfu_stat_buf);
 			need_dfu_state = 0;
 
 			/* override the timeout from the status response,
@@ -484,14 +499,17 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 			break;
 
 		default:
-			at76_dbg(DBG_DFU, "DFU UNKNOWN STATE (%d)", dfu_state);
+			at76_dbg(DBG_DFU, "DFU UNKNOWN STATE (%d)", *dfu_state);
 			ret = -EINVAL;
 			break;
 		}
 	} while (!is_done && (ret >= 0));
 
 exit:
+	kfree(dfu_state);
 	kfree(block);
+	kfree(dfu_stat_buf);
+
 	if (ret >= 0)
 		ret = 0;
 
@@ -1277,6 +1295,7 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 			dev_err(&udev->dev,
 				"loading %dth firmware block failed: %d\n",
 				blockno, ret);
+			ret = -EIO;
 			goto exit;
 		}
 		buf += bsize;
@@ -2330,16 +2349,22 @@ static int at76_probe(struct usb_interface *interface,
 	struct usb_device *udev;
 	int op_mode;
 	int need_ext_fw = 0;
-	struct mib_fw_version fwv;
+	struct mib_fw_version *fwv = NULL;
 	int board_type = (int)id->driver_info;
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
 
+	fwv = kmalloc(sizeof(*fwv), GFP_KERNEL);
+	if (!fwv) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
 	/* Load firmware into kernel memory */
 	fwe = at76_load_firmware(udev, board_type);
 	if (!fwe) {
 		ret = -ENOENT;
-		goto error;
+		goto exit;
 	}
 
 	op_mode = at76_get_op_mode(udev);
@@ -2353,7 +2378,7 @@ static int at76_probe(struct usb_interface *interface,
 		dev_err(&interface->dev,
 			"cannot handle a device in HW_CONFIG_MODE\n");
 		ret = -EBUSY;
-		goto error;
+		goto exit;
 	}
 
 	if (op_mode != OPMODE_NORMAL_NIC_WITH_FLASH
@@ -2366,10 +2391,10 @@ static int at76_probe(struct usb_interface *interface,
 			dev_err(&interface->dev,
 				"error %d downloading internal firmware\n",
 				ret);
-			goto error;
+			goto exit;
 		}
 		usb_put_dev(udev);
-		return ret;
+		goto exit;
 	}
 
 	/* Internal firmware already inside the device.  Get firmware
@@ -2382,8 +2407,8 @@ static int at76_probe(struct usb_interface *interface,
 	 * query the device for the fw version */
 	if ((fwe->fw_version.major > 0 || fwe->fw_version.minor >= 100)
 	    || (op_mode == OPMODE_NORMAL_NIC_WITH_FLASH)) {
-		ret = at76_get_mib(udev, MIB_FW_VERSION, &fwv, sizeof(fwv));
-		if (ret < 0 || (fwv.major | fwv.minor) == 0)
+		ret = at76_get_mib(udev, MIB_FW_VERSION, fwv, sizeof(*fwv));
+		if (ret < 0 || (fwv->major | fwv->minor) == 0)
 			need_ext_fw = 1;
 	} else
 		/* No way to check firmware version, reload to be sure */
@@ -2394,37 +2419,37 @@ static int at76_probe(struct usb_interface *interface,
 			   "downloading external firmware\n");
 
 		ret = at76_load_external_fw(udev, fwe);
-		if (ret)
-			goto error;
+		if (ret < 0)
+			goto exit;
 
 		/* Re-check firmware version */
-		ret = at76_get_mib(udev, MIB_FW_VERSION, &fwv, sizeof(fwv));
+		ret = at76_get_mib(udev, MIB_FW_VERSION, fwv, sizeof(*fwv));
 		if (ret < 0) {
 			dev_err(&interface->dev,
 				"error %d getting firmware version\n", ret);
-			goto error;
+			goto exit;
 		}
 	}
 
 	priv = at76_alloc_new_device(udev);
 	if (!priv) {
 		ret = -ENOMEM;
-		goto error;
+		goto exit;
 	}
 
 	usb_set_intfdata(interface, priv);
 
-	memcpy(&priv->fw_version, &fwv, sizeof(struct mib_fw_version));
+	memcpy(&priv->fw_version, fwv, sizeof(struct mib_fw_version));
 	priv->board_type = board_type;
 
 	ret = at76_init_new_device(priv, interface);
 	if (ret < 0)
 		at76_delete_device(priv);
 
-	return ret;
-
-error:
-	usb_put_dev(udev);
+exit:
+	kfree(fwv);
+	if (ret < 0)
+		usb_put_dev(udev);
 	return ret;
 }
 
-- 
1.9.1

