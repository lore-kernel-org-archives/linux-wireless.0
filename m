Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:36149 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbcK1EZg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Nov 2016 23:25:36 -0500
Received: by mail-pg0-f42.google.com with SMTP id f188so52179014pgc.3
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2016 20:25:35 -0800 (PST)
From: Anthony Romano <anthony.romano@coreos.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k_htc: don't use HZ for usb msg timeouts
Date: Sun, 27 Nov 2016 20:27:57 -0800
Message-Id: <20161128042757.8609-1-anthony.romano@coreos.com> (sfid-20161128_052539_532508_33E84644)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The usb_*_msg() functions expect a timeout in msecs but are given HZ,
which is ticks per second. If HZ=100, firmware download often times out
when there is modest USB utilization and the device fails to initialize.

Replaces HZ in usb_*_msg timeouts with 1000 msec since HZ is one second
for timeouts in jiffies.

Signed-off-by: Anthony Romano <anthony.romano@coreos.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 9 +++++----
 drivers/net/wireless/ath/ath9k/hif_usb.h | 2 ++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e1c338cb9cb5..de2d212f39ec 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -997,7 +997,8 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 		err = usb_control_msg(hif_dev->udev,
 				      usb_sndctrlpipe(hif_dev->udev, 0),
 				      FIRMWARE_DOWNLOAD, 0x40 | USB_DIR_OUT,
-				      addr >> 8, 0, buf, transfer, HZ);
+				      addr >> 8, 0, buf, transfer,
+				      USB_MSG_TIMEOUT);
 		if (err < 0) {
 			kfree(buf);
 			return err;
@@ -1020,7 +1021,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	err = usb_control_msg(hif_dev->udev, usb_sndctrlpipe(hif_dev->udev, 0),
 			      FIRMWARE_DOWNLOAD_COMP,
 			      0x40 | USB_DIR_OUT,
-			      firm_offset >> 8, 0, NULL, 0, HZ);
+			      firm_offset >> 8, 0, NULL, 0, USB_MSG_TIMEOUT);
 	if (err)
 		return -EIO;
 
@@ -1249,7 +1250,7 @@ static int send_eject_command(struct usb_interface *interface)
 
 	dev_info(&udev->dev, "Ejecting storage device...\n");
 	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, bulk_out_ep),
-		cmd, 31, NULL, 2000);
+		cmd, 31, NULL, 2 * USB_MSG_TIMEOUT);
 	kfree(cmd);
 	if (r)
 		return r;
@@ -1314,7 +1315,7 @@ static void ath9k_hif_usb_reboot(struct usb_device *udev)
 		return;
 
 	ret = usb_interrupt_msg(udev, usb_sndintpipe(udev, USB_REG_OUT_PIPE),
-			   buf, 4, NULL, HZ);
+			   buf, 4, NULL, USB_MSG_TIMEOUT);
 	if (ret)
 		dev_err(&udev->dev, "ath9k_htc: USB reboot failed\n");
 
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 7c2ef7ecd98b..7846916aa01d 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -71,6 +71,8 @@ extern int htc_use_dev_fw;
 #define USB_REG_IN_PIPE   3
 #define USB_REG_OUT_PIPE  4
 
+#define USB_MSG_TIMEOUT 1000 /* (ms) */
+
 #define HIF_USB_MAX_RXPIPES 2
 #define HIF_USB_MAX_TXPIPES 4
 
-- 
2.11.0.rc2
