Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32355 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0FQE5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 00:57:15 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 21:57:15 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19481.43925.555454.801544@gargle.gargle.HOWL>
Date: Thu, 17 Jun 2010 10:29:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Update supported product list
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds USB IDs for some more supported
devices.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |   20 +++++++++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    9 ++-------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 5f3ea70..74bc80f 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -17,9 +17,17 @@
 #include "htc.h"
 
 static struct usb_device_id ath9k_hif_usb_ids[] = {
-	{ USB_DEVICE(0x0cf3, 0x9271) },
-	{ USB_DEVICE(0x0cf3, 0x1006) },
-	{ USB_DEVICE(0x0cf3, 0x7010) },
+	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
+	{ USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
+	{ USB_DEVICE(0x0cf3, 0x7010) }, /* Atheros */
+	{ USB_DEVICE(0x0cf3, 0x7015) }, /* Atheros */
+	{ USB_DEVICE(0x0846, 0x9030) }, /* Netgear N150 */
+	{ USB_DEVICE(0x0846, 0x9018) }, /* Netgear WNDA3200 */
+	{ USB_DEVICE(0x07D1, 0x3A10) }, /* Dlink Wireless 150 */
+	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
+	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
+	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
+	{ USB_DEVICE(0x083A, 0xA704) }, /* SMC Networks */
 	{ },
 };
 
@@ -879,17 +887,15 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	/* Find out which firmware to load */
 
 	switch(hif_dev->device_id) {
-	case 0x9271:
-	case 0x1006:
-		hif_dev->fw_name = "ar9271.fw";
-		break;
 	case 0x7010:
+	case 0x9018:
 		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
 			hif_dev->fw_name = "ar7010_1_1.fw";
 		else
 			hif_dev->fw_name = "ar7010.fw";
 		break;
 	default:
+		hif_dev->fw_name = "ar9271.fw";
 		break;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a63ae88..148b433 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -244,17 +244,12 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid)
 	 */
 
 	switch(devid) {
-	case 0x9271:
-	case 0x1006:
-		priv->htc->credits = 33;
-		break;
 	case 0x7010:
+	case 0x9018:
 		priv->htc->credits = 45;
 		break;
 	default:
-		dev_err(priv->dev, "ath9k_htc: Unsupported device id: 0x%x\n",
-			devid);
-		goto err;
+		priv->htc->credits = 33;
 	}
 
 	ret = htc_init(priv->htc);
-- 
1.7.1

