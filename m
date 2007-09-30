Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64294 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXI3SlC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:41:02 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 22/26] at76_usb: Use dev_printk() where possible
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:59 -0400
Message-ID: <20070930184059.23921.61653.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_printk() prints the USB device name in addition to the driver name,
which makes it easier to understand the diagnostics in case of multiple
devices.

Use &interface->dev, as it's more specific and includes the driver name,
but use &udev->dev if interface is not available.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   87 ++++++++++++++++++++-------------------
 1 files changed, 44 insertions(+), 43 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index ce74e03..1849b94 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -366,7 +366,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 		 manifest_sync_timeout);
 
 	if (!size) {
-		printk(KERN_ERR DRIVER_NAME ": FW buffer length invalid!\n");
+		dev_printk(KERN_ERR, &udev->dev, "FW buffer length invalid!\n");
 		return -EINVAL;
 	}
 
@@ -378,8 +378,8 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 		if (need_dfu_state) {
 			ret = at76_dfu_get_state(udev, &dfu_state);
 			if (ret < 0) {
-				printk(KERN_ERR DRIVER_NAME
-				       ": cannot get DFU state: %d\n", ret);
+				dev_printk(KERN_ERR, &udev->dev,
+					   "cannot get DFU state: %d\n", ret);
 				goto exit;
 			}
 			need_dfu_state = 0;
@@ -394,9 +394,9 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 				dfu_timeout = at76_get_timeout(&dfu_stat_buf);
 				need_dfu_state = 0;
 			} else
-				printk(KERN_ERR DRIVER_NAME
-				       ": at76_dfu_get_status failed with %d\n",
-				       ret);
+				dev_printk(KERN_ERR, &udev->dev,
+					   "at76_dfu_get_status returned %d\n",
+					   ret);
 			break;
 
 		case STATE_DFU_DOWNLOAD_BUSY:
@@ -425,9 +425,9 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 			blockno++;
 
 			if (ret != bsize)
-				printk(KERN_ERR DRIVER_NAME
-				       ": dfu_download_block failed with %d\n",
-				       ret);
+				dev_printk(KERN_ERR, &udev->dev,
+					   "at76_load_int_fw_block "
+					   "returned %d\n", ret);
 			need_dfu_state = 1;
 			break;
 
@@ -3399,8 +3399,8 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 	at76_dbg(DBG_DEVSTART, "opmode %d", op_mode);
 
 	if (op_mode != OPMODE_NORMAL_NIC_WITHOUT_FLASH) {
-		printk(KERN_ERR DRIVER_NAME ": unexpected opmode %d\n",
-		       op_mode);
+		dev_printk(KERN_ERR, &udev->dev, "unexpected opmode %d\n",
+			   op_mode);
 		return -EINVAL;
 	}
 
@@ -3419,9 +3419,9 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 			 size, bsize, blockno);
 		ret = at76_load_ext_fw_block(udev, blockno, block, bsize);
 		if (ret != bsize) {
-			printk(KERN_ERR DRIVER_NAME
-			       ": loading %dth firmware block failed: %d\n",
-			       blockno, ret);
+			dev_printk(KERN_ERR, &udev->dev,
+				   "loading %dth firmware block failed: %d\n",
+				   blockno, ret);
 			goto exit;
 		}
 		buf += bsize;
@@ -3437,8 +3437,8 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 exit:
 	kfree(block);
 	if (ret < 0)
-		printk(KERN_ERR DRIVER_NAME
-		       ": downloading external firmware failed: %d\n", ret);
+		dev_printk(KERN_ERR, &udev->dev,
+			   "downloading external firmware failed: %d\n", ret);
 	return ret;
 }
 
@@ -3452,8 +3452,8 @@ static int at76_load_internal_fw(struct usb_device *udev, struct fwentry *fwe)
 				   need_remap ? 0 : 2 * HZ);
 
 	if (ret < 0) {
-		printk(KERN_ERR DRIVER_NAME
-		       ": downloading internal fw failed with %d\n", ret);
+		dev_printk(KERN_ERR, &udev->dev,
+			   "downloading internal fw failed with %d\n", ret);
 		goto exit;
 	}
 
@@ -3463,8 +3463,8 @@ static int at76_load_internal_fw(struct usb_device *udev, struct fwentry *fwe)
 	if (need_remap) {
 		ret = at76_remap(udev);
 		if (ret < 0) {
-			printk(KERN_ERR DRIVER_NAME
-			       ": sending REMAP failed with %d\n", ret);
+			dev_printk(KERN_ERR, &udev->dev,
+				   "sending REMAP failed with %d\n", ret);
 			goto exit;
 		}
 	}
@@ -5062,11 +5062,11 @@ static struct fwentry *at76_load_firmware(struct usb_device *udev,
 	at76_dbg(DBG_FW, "downloading firmware %s", fwe->fwname);
 	ret = request_firmware(&fwe->fw, fwe->fwname, &udev->dev);
 	if (ret < 0) {
-		printk(KERN_ERR DRIVER_NAME ": firmware %s not found!\n",
-		       fwe->fwname);
-		printk(KERN_ERR DRIVER_NAME
-		       ": you may need to download the firmware from "
-		       "http://developer.berlios.de/projects/at76c503a/");
+		dev_printk(KERN_ERR, &udev->dev, "firmware %s not found!\n",
+			   fwe->fwname);
+		dev_printk(KERN_ERR, &udev->dev,
+			   "you may need to download the firmware from "
+			   "http://developer.berlios.de/projects/at76c503a/");
 		goto exit;
 	}
 
@@ -5074,17 +5074,17 @@ static struct fwentry *at76_load_firmware(struct usb_device *udev,
 	fwh = (struct at76_fw_header *)(fwe->fw->data);
 
 	if (fwe->fw->size <= sizeof(*fwh)) {
-		printk(KERN_ERR DRIVER_NAME ": firmware is too short (0x%zx)\n",
-		       fwe->fw->size);
+		dev_printk(KERN_ERR, &udev->dev,
+			   "firmware is too short (0x%zx)\n", fwe->fw->size);
 		goto exit;
 	}
 
 	/* CRC currently not checked */
 	fwe->board_type = le32_to_cpu(fwh->board_type);
 	if (fwe->board_type != board_type) {
-		printk(KERN_ERR DRIVER_NAME
-		       ": board type mismatch, requested %u, got %u\n",
-		       board_type, fwe->board_type);
+		dev_printk(KERN_ERR, &udev->dev,
+			   "board type mismatch, requested %u, got %u\n",
+			   board_type, fwe->board_type);
 		goto exit;
 	}
 
@@ -5127,7 +5127,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	/* allocate memory for our device state and initialize it */
 	netdev = alloc_etherdev(sizeof(struct at76_priv));
 	if (!netdev) {
-		printk(KERN_ERR DRIVER_NAME ": out of memory\n");
+		dev_printk(KERN_ERR, &udev->dev, "out of memory\n");
 		return NULL;
 	}
 
@@ -5208,7 +5208,8 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 	}
 
 	if (!ep_in || !ep_out) {
-		printk(KERN_ERR DRIVER_NAME ": bulk endpoints missing\n");
+		dev_printk(KERN_ERR, &interface->dev,
+			   "bulk endpoints missing\n");
 		return -ENXIO;
 	}
 
@@ -5218,15 +5219,15 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 	priv->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	priv->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!priv->rx_urb || !priv->tx_urb) {
-		printk(KERN_ERR DRIVER_NAME ": cannot allocate URB\n");
+		dev_printk(KERN_ERR, &interface->dev, "cannot allocate URB\n");
 		return -ENOMEM;
 	}
 
 	buffer_size = sizeof(struct at76_tx_buffer) + MAX_PADDING_SIZE;
 	priv->bulk_out_buffer = kmalloc(buffer_size, GFP_KERNEL);
 	if (!priv->bulk_out_buffer) {
-		printk(KERN_ERR DRIVER_NAME
-		       ": cannot allocate output buffer\n");
+		dev_printk(KERN_ERR, &interface->dev,
+			   "cannot allocate output buffer\n");
 		return -ENOMEM;
 	}
 
@@ -5402,8 +5403,8 @@ static int at76_probe(struct usb_interface *interface,
 	   we get 204 with 2.4.23, Fiberline FL-WL240u (505A+RFMD2958) ??? */
 
 	if (op_mode == OPMODE_HW_CONFIG_MODE) {
-		printk(KERN_ERR DRIVER_NAME
-		       ": cannot handle a device in HW_CONFIG_MODE\n");
+		dev_printk(KERN_ERR, &interface->dev,
+			   "cannot handle a device in HW_CONFIG_MODE\n");
 		ret = -EBUSY;
 		goto error;
 	}
@@ -5414,9 +5415,9 @@ static int at76_probe(struct usb_interface *interface,
 		at76_dbg(DBG_DEVSTART, "downloading internal firmware");
 		ret = at76_load_internal_fw(udev, fwe);
 		if (ret < 0) {
-			printk(KERN_ERR DRIVER_NAME
-			       ": error %d downloading internal firmware\n",
-			       ret);
+			dev_printk(KERN_ERR, &interface->dev,
+				   "error %d downloading internal firmware\n",
+				   ret);
 			goto error;
 		}
 		usb_put_dev(udev);
@@ -5450,8 +5451,8 @@ static int at76_probe(struct usb_interface *interface,
 		/* Re-check firmware version */
 		ret = at76_get_mib(udev, MIB_FW_VERSION, &fwv, sizeof(fwv));
 		if (ret < 0) {
-			printk(KERN_ERR DRIVER_NAME
-			       ": error %d getting firmware version\n", ret);
+			dev_printk(KERN_ERR, &interface->dev,
+				   "error %d getting firmware version\n", ret);
 			goto error;
 		}
 	}
@@ -5492,7 +5493,7 @@ static void at76_disconnect(struct usb_interface *interface)
 
 	printk(KERN_INFO "%s: disconnecting\n", priv->netdev->name);
 	at76_delete_device(priv);
-	printk(KERN_INFO DRIVER_NAME ": disconnected\n");
+	dev_printk(KERN_INFO, &interface->dev, "disconnected\n");
 }
 
 /* Structure for registering this driver with the USB subsystem */
