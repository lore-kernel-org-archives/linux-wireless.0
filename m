Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57541 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125Ab0FBKWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:22:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:22:19 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12578.143627.398866@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:53:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/8] ath9k: Determine Firmware on probe
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not assign the FW name to driver_info but determine
it dynamically on device probe. This facilitates adding new
firmware.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   39 ++++++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 77b3591..7da55eb 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -16,12 +16,9 @@
 
 #include "htc.h"
 
-#define ATH9K_FW_USB_DEV(devid, fw)					\
-	{ USB_DEVICE(0x0cf3, devid), .driver_info = (unsigned long) fw }
-
 static struct usb_device_id ath9k_hif_usb_ids[] = {
-	ATH9K_FW_USB_DEV(0x9271, "ar9271.fw"),
-	ATH9K_FW_USB_DEV(0x1006, "ar9271.fw"),
+	{ USB_DEVICE(0x0cf3, 0x9271) },
+	{ USB_DEVICE(0x0cf3, 0x1006) },
 	{ },
 };
 
@@ -790,21 +787,21 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 		return -EIO;
 
 	dev_info(&hif_dev->udev->dev, "ath9k_htc: Transferred FW: %s, size: %ld\n",
-		 "ar9271.fw", (unsigned long) hif_dev->firmware->size);
+		 hif_dev->fw_name, (unsigned long) hif_dev->firmware->size);
 
 	return 0;
 }
 
-static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev,
-				  const char *fw_name)
+static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 {
 	int ret;
 
 	/* Request firmware */
-	ret = request_firmware(&hif_dev->firmware, fw_name, &hif_dev->udev->dev);
+	ret = request_firmware(&hif_dev->firmware, hif_dev->fw_name,
+			       &hif_dev->udev->dev);
 	if (ret) {
 		dev_err(&hif_dev->udev->dev,
-			"ath9k_htc: Firmware - %s not found\n", fw_name);
+			"ath9k_htc: Firmware - %s not found\n", hif_dev->fw_name);
 		goto err_fw_req;
 	}
 
@@ -820,7 +817,8 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev,
 	ret = ath9k_hif_usb_download_fw(hif_dev);
 	if (ret) {
 		dev_err(&hif_dev->udev->dev,
-			"ath9k_htc: Firmware - %s download failed\n", fw_name);
+			"ath9k_htc: Firmware - %s download failed\n",
+			hif_dev->fw_name);
 		goto err_fw_download;
 	}
 
@@ -847,7 +845,6 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct hif_device_usb *hif_dev;
-	const char *fw_name = (const char *) id->driver_info;
 	int ret = 0;
 
 	hif_dev = kzalloc(sizeof(struct hif_device_usb), GFP_KERNEL);
@@ -872,7 +869,23 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 		goto err_htc_hw_alloc;
 	}
 
-	ret = ath9k_hif_usb_dev_init(hif_dev, fw_name);
+	/* Find out which firmware to load */
+
+	switch(hif_dev->device_id) {
+	case 0x9271:
+	case 0x1006:
+		hif_dev->fw_name = "ar9271.fw";
+		break;
+	default:
+		break;
+	}
+
+	if (!hif_dev->fw_name) {
+		dev_err(&udev->dev, "Can't determine firmware !\n");
+		goto err_htc_hw_alloc;
+	}
+
+	ret = ath9k_hif_usb_dev_init(hif_dev);
 	if (ret) {
 		ret = -EINVAL;
 		goto err_hif_init_usb;
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 0aca49b..b2647e8 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -90,6 +90,7 @@ struct hif_device_usb {
 	struct usb_anchor regout_submitted;
 	struct usb_anchor rx_submitted;
 	struct sk_buff *remain_skb;
+	const char *fw_name;
 	int rx_remain_len;
 	int rx_pkt_len;
 	int rx_transfer_len;
-- 
1.7.1

