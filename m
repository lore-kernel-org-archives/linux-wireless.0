Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22571 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0KSLQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 06:16:03 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 03:15:49 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/4] ath9k_htc: Add driver_info in usb device list
Date: Fri, 19 Nov 2010 16:53:20 +0530
Message-ID: <1290165802-3566-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
References: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added driver_info to identify AR7010, R9287 HTC devices.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index dfb6560..6a0dbd1 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -28,10 +28,16 @@ MODULE_FIRMWARE(FIRMWARE_AR9271);
 static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
 	{ USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
-	{ USB_DEVICE(0x0cf3, 0x7010) }, /* Atheros */
-	{ USB_DEVICE(0x0cf3, 0x7015) }, /* Atheros */
+	{ USB_DEVICE(0x0cf3, 0x7010),
+		.driver_info = AR7010_DEVICE },
+					/* Atheros */
+	{ USB_DEVICE(0x0cf3, 0x7015),
+		.driver_info = AR7010_DEVICE | AR9287_DEVICE },
+					/* Atheros */
 	{ USB_DEVICE(0x0846, 0x9030) }, /* Netgear N150 */
-	{ USB_DEVICE(0x0846, 0x9018) }, /* Netgear WNDA3200 */
+	{ USB_DEVICE(0x0846, 0x9018),
+		.driver_info = AR7010_DEVICE },
+					/* Netgear WNDA3200 */
 	{ USB_DEVICE(0x07D1, 0x3A10) }, /* Dlink Wireless 150 */
 	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
@@ -40,9 +46,13 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x13D3, 0x3349) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3350) }, /* Azurewave */
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
-	{ USB_DEVICE(0x083A, 0xA704) }, /* SMC Networks */
+	{ USB_DEVICE(0x083A, 0xA704),
+		.driver_info = AR7010_DEVICE },
+					/* SMC Networks */
 	{ USB_DEVICE(0x040D, 0x3801) }, /* VIA */
-	{ USB_DEVICE(0x1668, 0x1200) }, /* Verizon */
+	{ USB_DEVICE(0x1668, 0x1200),
+		.driver_info = AR7010_DEVICE | AR9287_DEVICE },
+					/* Verizon */
 	{ },
 };
 
-- 
1.7.3.2

