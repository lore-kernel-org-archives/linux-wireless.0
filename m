Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42213 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab1BUCUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:20:52 -0500
Received: by ywj3 with SMTP id 3so599782ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:20:51 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52214.224881.939816@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:50:38 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 23/23] ath9k_htc: Fix error path in URB allocation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

ath9k_hif_usb_alloc_urbs() takes care of freeing
all the allocated URBs for the various endpoints when
an error occurs. Calling ath9k_hif_usb_dealloc_urbs() would
cause a panic since the URBs have already been freed.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index fde5444..7dc2048 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -916,13 +916,11 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev, u32 drv_info)
 	if (ret) {
 		dev_err(&hif_dev->udev->dev,
 			"ath9k_htc: Unable to allocate URBs\n");
-		goto err_urb;
+		goto err_fw_download;
 	}
 
 	return 0;
 
-err_urb:
-	ath9k_hif_usb_dealloc_urbs(hif_dev);
 err_fw_download:
 	release_firmware(hif_dev->firmware);
 err_fw_req:
-- 
1.7.4.1

