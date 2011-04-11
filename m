Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44820 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1DKRYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 13:24:34 -0400
Received: by iwn34 with SMTP id 34so5822607iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 10:24:33 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19875.14815.278751.401499@gargle.gargle.HOWL>
Date: Mon, 11 Apr 2011 22:56:55 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>, sidhayn@gmail.com
Subject: [PATCH] ath9k_htc: Fix ethtool reporting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Pass the correct module name and device interface so that
ethtool can display the proper values.

The firmware version will be fixed later on when the FW
can actually report a version. :)

Reported-by: Richard Farina <sidhayn@gmail.com>
Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f1b8af6..2d10239 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1040,7 +1040,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	}
 
 	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
-				&hif_dev->udev->dev, hif_dev->device_id,
+				&interface->dev, hif_dev->device_id,
 				hif_dev->udev->product, id->driver_info);
 	if (ret) {
 		ret = -EINVAL;
@@ -1158,7 +1158,7 @@ fail_resume:
 #endif
 
 static struct usb_driver ath9k_hif_usb_driver = {
-	.name = "ath9k_hif_usb",
+	.name = KBUILD_MODNAME,
 	.probe = ath9k_hif_usb_probe,
 	.disconnect = ath9k_hif_usb_disconnect,
 #ifdef CONFIG_PM
-- 
1.7.4.4

