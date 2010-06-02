Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57542 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0FBKWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:22:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:22:20 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12582.151315.715@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:53:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/8] ath9k_htc: Add support for AR7010
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the USB device IDs for AR7010 and handle
firmware loading properly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   15 ++++++++++++++-
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 7da55eb..1b75b1b 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -19,6 +19,7 @@
 static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9271) },
 	{ USB_DEVICE(0x0cf3, 0x1006) },
+	{ USB_DEVICE(0x0cf3, 0x7010) },
 	{ },
 };
 
@@ -753,6 +754,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	size_t len = hif_dev->firmware->size;
 	u32 addr = AR9271_FIRMWARE;
 	u8 *buf = kzalloc(4096, GFP_KERNEL);
+	u32 firm_offset;
 
 	if (!buf)
 		return -ENOMEM;
@@ -776,13 +778,18 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	}
 	kfree(buf);
 
+	if (hif_dev->device_id == 0x7010)
+		firm_offset = AR7010_FIRMWARE_TEXT;
+	else
+		firm_offset = AR9271_FIRMWARE_TEXT;
+
 	/*
 	 * Issue FW download complete command to firmware.
 	 */
 	err = usb_control_msg(hif_dev->udev, usb_sndctrlpipe(hif_dev->udev, 0),
 			      FIRMWARE_DOWNLOAD_COMP,
 			      0x40 | USB_DIR_OUT,
-			      AR9271_FIRMWARE_TEXT >> 8, 0, NULL, 0, HZ);
+			      firm_offset >> 8, 0, NULL, 0, HZ);
 	if (err)
 		return -EIO;
 
@@ -876,6 +883,12 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	case 0x1006:
 		hif_dev->fw_name = "ar9271.fw";
 		break;
+	case 0x7010:
+		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
+			hif_dev->fw_name = "ar7010_1_1.fw";
+		else
+			hif_dev->fw_name = "ar7010.fw";
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index b2647e8..2daf97b 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -19,6 +19,7 @@
 
 #define AR9271_FIRMWARE       0x501000
 #define AR9271_FIRMWARE_TEXT  0x903000
+#define AR7010_FIRMWARE_TEXT  0x906000
 
 #define FIRMWARE_DOWNLOAD       0x30
 #define FIRMWARE_DOWNLOAD_COMP  0x31
-- 
1.7.1

