Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3889 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2A3Irg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 03:47:36 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20262.22806.801654.769078@gargle.gargle.HOWL> (sfid-20120130_094740_385815_E3DED595)
Date: Mon, 30 Jan 2012 14:17:18 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k_htc: Load firmware asynchronously
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch modifies ath9k_htc to load the needed
firmware in an asynchronous manner, fixing timeouts
that were introduced with the new udev changes.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |  154 +++++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hif_usb.h |    3 +-
 2 files changed, 101 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 77c8ded..f317515 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -968,8 +968,7 @@ static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 }
 
-static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev,
-				     u32 drv_info)
+static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 {
 	int transfer, err;
 	const void *data = hif_dev->firmware->data;
@@ -1000,7 +999,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev,
 	}
 	kfree(buf);
 
-	if (IS_AR7010_DEVICE(drv_info))
+	if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
 		firm_offset = AR7010_FIRMWARE_TEXT;
 	else
 		firm_offset = AR9271_FIRMWARE_TEXT;
@@ -1021,28 +1020,18 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev,
 	return 0;
 }
 
-static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev, u32 drv_info)
+static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 {
-	int ret, idx;
 	struct usb_host_interface *alt = &hif_dev->interface->altsetting[0];
 	struct usb_endpoint_descriptor *endp;
+	int ret, idx;
 
-	/* Request firmware */
-	ret = request_firmware(&hif_dev->firmware, hif_dev->fw_name,
-			       &hif_dev->udev->dev);
-	if (ret) {
-		dev_err(&hif_dev->udev->dev,
-			"ath9k_htc: Firmware - %s not found\n", hif_dev->fw_name);
-		goto err_fw_req;
-	}
-
-	/* Download firmware */
-	ret = ath9k_hif_usb_download_fw(hif_dev, drv_info);
+	ret = ath9k_hif_usb_download_fw(hif_dev);
 	if (ret) {
 		dev_err(&hif_dev->udev->dev,
 			"ath9k_htc: Firmware - %s download failed\n",
 			hif_dev->fw_name);
-		goto err_fw_download;
+		return ret;
 	}
 
 	/* On downloading the firmware to the target, the USB descriptor of EP4
@@ -1064,23 +1053,84 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev, u32 drv_info)
 	if (ret) {
 		dev_err(&hif_dev->udev->dev,
 			"ath9k_htc: Unable to allocate URBs\n");
-		goto err_fw_download;
+		return ret;
 	}
 
 	return 0;
-
-err_fw_download:
-	release_firmware(hif_dev->firmware);
-err_fw_req:
-	hif_dev->firmware = NULL;
-	return ret;
 }
 
 static void ath9k_hif_usb_dev_deinit(struct hif_device_usb *hif_dev)
 {
 	ath9k_hif_usb_dealloc_urbs(hif_dev);
-	if (hif_dev->firmware)
-		release_firmware(hif_dev->firmware);
+}
+
+/*
+ * If initialization fails or the FW cannot be retrieved,
+ * detach the device.
+ */
+static void ath9k_hif_usb_firmware_fail(struct hif_device_usb *hif_dev)
+{
+	struct device *parent = hif_dev->udev->dev.parent;
+
+	complete(&hif_dev->fw_done);
+
+	if (parent)
+		device_lock(parent);
+
+	device_release_driver(&hif_dev->udev->dev);
+
+	if (parent)
+		device_unlock(parent);
+}
+
+static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
+{
+	struct hif_device_usb *hif_dev = context;
+	int ret;
+
+	if (!fw) {
+		dev_err(&hif_dev->udev->dev,
+			"ath9k_htc: Failed to get firmware %s\n",
+			hif_dev->fw_name);
+		goto err_fw;
+	}
+
+	hif_dev->htc_handle = ath9k_htc_hw_alloc(hif_dev, &hif_usb,
+						 &hif_dev->udev->dev);
+	if (hif_dev->htc_handle == NULL) {
+		goto err_fw;
+	}
+
+	hif_dev->firmware = fw;
+
+	/* Proceed with initialization */
+
+	ret = ath9k_hif_usb_dev_init(hif_dev);
+	if (ret)
+		goto err_dev_init;
+
+	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
+				&hif_dev->interface->dev,
+				hif_dev->usb_device_id->idProduct,
+				hif_dev->udev->product,
+				hif_dev->usb_device_id->driver_info);
+	if (ret) {
+		ret = -EINVAL;
+		goto err_htc_hw_init;
+	}
+
+	complete(&hif_dev->fw_done);
+
+	return;
+
+err_htc_hw_init:
+	ath9k_hif_usb_dev_deinit(hif_dev);
+err_dev_init:
+	ath9k_htc_hw_free(hif_dev->htc_handle);
+	release_firmware(fw);
+	hif_dev->firmware = NULL;
+err_fw:
+	ath9k_hif_usb_firmware_fail(hif_dev);
 }
 
 /*
@@ -1155,20 +1205,16 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	}
 
 	usb_get_dev(udev);
+
 	hif_dev->udev = udev;
 	hif_dev->interface = interface;
-	hif_dev->device_id = id->idProduct;
+	hif_dev->usb_device_id = id;
 #ifdef CONFIG_PM
 	udev->reset_resume = 1;
 #endif
 	usb_set_intfdata(interface, hif_dev);
 
-	hif_dev->htc_handle = ath9k_htc_hw_alloc(hif_dev, &hif_usb,
-						 &hif_dev->udev->dev);
-	if (hif_dev->htc_handle == NULL) {
-		ret = -ENOMEM;
-		goto err_htc_hw_alloc;
-	}
+	init_completion(&hif_dev->fw_done);
 
 	/* Find out which firmware to load */
 
@@ -1177,29 +1223,22 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	else
 		hif_dev->fw_name = FIRMWARE_AR9271;
 
-	ret = ath9k_hif_usb_dev_init(hif_dev, id->driver_info);
-	if (ret) {
-		ret = -EINVAL;
-		goto err_hif_init_usb;
-	}
-
-	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
-				&interface->dev, hif_dev->device_id,
-				hif_dev->udev->product, id->driver_info);
+	ret = request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
+				      &hif_dev->udev->dev, GFP_KERNEL,
+				      hif_dev, ath9k_hif_usb_firmware_cb);
 	if (ret) {
-		ret = -EINVAL;
-		goto err_htc_hw_init;
+		dev_err(&hif_dev->udev->dev,
+			"ath9k_htc: Async request for firmware %s failed\n",
+			hif_dev->fw_name);
+		goto err_fw_req;
 	}
 
-	dev_info(&hif_dev->udev->dev, "ath9k_htc: USB layer initialized\n");
+	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
+		 hif_dev->fw_name);
 
 	return 0;
 
-err_htc_hw_init:
-	ath9k_hif_usb_dev_deinit(hif_dev);
-err_hif_init_usb:
-	ath9k_htc_hw_free(hif_dev->htc_handle);
-err_htc_hw_alloc:
+err_fw_req:
 	usb_set_intfdata(interface, NULL);
 	kfree(hif_dev);
 	usb_put_dev(udev);
@@ -1234,9 +1273,15 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 	if (!hif_dev)
 		return;
 
-	ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
-	ath9k_htc_hw_free(hif_dev->htc_handle);
-	ath9k_hif_usb_dev_deinit(hif_dev);
+	wait_for_completion(&hif_dev->fw_done);
+
+	if (hif_dev->firmware) {
+		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
+		ath9k_htc_hw_free(hif_dev->htc_handle);
+		ath9k_hif_usb_dev_deinit(hif_dev);
+		release_firmware(hif_dev->firmware);
+	}
+
 	usb_set_intfdata(interface, NULL);
 
 	if (!unplugged && (hif_dev->flags & HIF_USB_START))
@@ -1276,8 +1321,7 @@ static int ath9k_hif_usb_resume(struct usb_interface *interface)
 		return ret;
 
 	if (hif_dev->firmware) {
-		ret = ath9k_hif_usb_download_fw(hif_dev,
-				htc_handle->drv_priv->ah->hw_version.usbdev);
+		ret = ath9k_hif_usb_download_fw(hif_dev);
 		if (ret)
 			goto fail_resume;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 794f630..487ff65 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -87,10 +87,11 @@ struct cmd_buf {
 #define HIF_USB_START BIT(0)
 
 struct hif_device_usb {
-	u16 device_id;
 	struct usb_device *udev;
 	struct usb_interface *interface;
+	const struct usb_device_id *usb_device_id;
 	const struct firmware *firmware;
+	struct completion fw_done;
 	struct htc_target *htc_handle;
 	struct hif_usb_tx tx;
 	struct usb_anchor regout_submitted;
-- 
1.7.9

