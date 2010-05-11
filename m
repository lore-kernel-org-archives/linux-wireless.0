Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47725 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab0EKKyV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 06:54:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 03:54:21 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19433.14192.60615.129429@gargle.gargle.HOWL>
Date: Tue, 11 May 2010 16:24:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/5] ath9k_htc: Allocate URBs properly
From: <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The URBs have to be allocated before uploading
the firmware to the target. This is needed to process
the target ready message properly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   36 +++++++++++++++---------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 74872ca..453cf56 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -735,6 +735,14 @@ err:
 	return -ENOMEM;
 }
 
+static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
+{
+	usb_kill_anchored_urbs(&hif_dev->regout_submitted);
+	ath9k_hif_usb_dealloc_reg_in_urb(hif_dev);
+	ath9k_hif_usb_dealloc_tx_urbs(hif_dev);
+	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
+}
+
 static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 {
 	int transfer, err;
@@ -794,14 +802,6 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev,
 		goto err_fw_req;
 	}
 
-	/* Download firmware */
-	ret = ath9k_hif_usb_download_fw(hif_dev);
-	if (ret) {
-		dev_err(&hif_dev->udev->dev,
-			"ath9k_htc: Firmware - %s download failed\n", fw_name);
-		goto err_fw_download;
-	}
-
 	/* Alloc URBs */
 	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
 	if (ret) {
@@ -810,25 +810,25 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev,
 		goto err_urb;
 	}
 
+	/* Download firmware */
+	ret = ath9k_hif_usb_download_fw(hif_dev);
+	if (ret) {
+		dev_err(&hif_dev->udev->dev,
+			"ath9k_htc: Firmware - %s download failed\n", fw_name);
+		goto err_fw_download;
+	}
+
 	return 0;
 
-err_urb:
-	/* Nothing */
 err_fw_download:
+	ath9k_hif_usb_dealloc_urbs(hif_dev);
+err_urb:
 	release_firmware(hif_dev->firmware);
 err_fw_req:
 	hif_dev->firmware = NULL;
 	return ret;
 }
 
-static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
-{
-	usb_kill_anchored_urbs(&hif_dev->regout_submitted);
-	ath9k_hif_usb_dealloc_reg_in_urb(hif_dev);
-	ath9k_hif_usb_dealloc_tx_urbs(hif_dev);
-	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
-}
-
 static void ath9k_hif_usb_dev_deinit(struct hif_device_usb *hif_dev)
 {
 	ath9k_hif_usb_dealloc_urbs(hif_dev);
-- 
1.7.1


-- 
