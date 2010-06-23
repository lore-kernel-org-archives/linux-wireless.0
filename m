Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39625 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0FWTAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 15:00:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@atheros.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] ath9k: declare MODULE_FIRMWARE for ath9k_htc
Date: Wed, 23 Jun 2010 14:50:39 -0400
Message-Id: <1277319039-20837-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1277317393-20245-1-git-send-email-linville@tuxdriver.com>
References: <1277317393-20245-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 -> avoid duplicate strings for firmware names and simultaneously
	attract attention to MODULE_FIRMWARE section in the even of
	any updates

 drivers/net/wireless/ath/ath9k/hif_usb.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 74bc80f..ad9134b 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -16,6 +16,15 @@
 
 #include "htc.h"
 
+/* identify firmware images */
+#define FIRMWARE_AR7010		"ar7010.fw"
+#define FIRMWARE_AR7010_1_1	"ar7010_1_1.fw"
+#define FIRMWARE_AR9271		"ar9271.fw"
+
+MODULE_FIRMWARE(FIRMWARE_AR7010);
+MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
+MODULE_FIRMWARE(FIRMWARE_AR9271);
+
 static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
 	{ USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
@@ -890,12 +899,12 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	case 0x7010:
 	case 0x9018:
 		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
-			hif_dev->fw_name = "ar7010_1_1.fw";
+			hif_dev->fw_name = FIRMWARE_AR7010_1_1;
 		else
-			hif_dev->fw_name = "ar7010.fw";
+			hif_dev->fw_name = FIRMWARE_AR7010;
 		break;
 	default:
-		hif_dev->fw_name = "ar9271.fw";
+		hif_dev->fw_name = FIRMWARE_AR9271;
 		break;
 	}
 
-- 
1.7.0.1

