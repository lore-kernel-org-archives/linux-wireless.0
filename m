Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:34077 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZHHPJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 11:09:49 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170usb: fix spurious firmware related message
Date: Sat, 8 Aug 2009 17:09:48 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200908081709.48599.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ar9170-2.fw was missing, the driver erroneously complained
about missing the initialization values file ar9170-1.fw...

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 1aec7af..e0138ac 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -598,11 +598,15 @@ static int ar9170_usb_request_firmware(struct ar9170_usb *aru)
 
 	err = request_firmware(&aru->init_values, "ar9170-1.fw",
 			       &aru->udev->dev);
+	if (err) {
+		dev_err(&aru->udev->dev, "file with init values not found.\n");
+		return err;
+	}
 
 	err = request_firmware(&aru->firmware, "ar9170-2.fw", &aru->udev->dev);
 	if (err) {
 		release_firmware(aru->init_values);
-		dev_err(&aru->udev->dev, "file with init values not found.\n");
+		dev_err(&aru->udev->dev, "firmware file not found.\n");
 		return err;
 	}
 
