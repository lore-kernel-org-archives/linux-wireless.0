Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43133 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab0DVDn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 23:43:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 20:43:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19407.50660.739033.942199@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 09:13:32 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/9] ath9k_htc: Use USB reboot
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, apparently there is a USB reboot command
that the target accepts. Using this instead of
usb_reset_device() fixes the issue of "descriptor read error"
that pops up on repeated load/unload.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index cee5feb..ce13e08 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -889,6 +889,17 @@ err_alloc:
 	return ret;
 }
 
+static void ath9k_hif_usb_reboot(struct usb_device *udev)
+{
+	u32 cmd = 0xffffffff;
+	int ret;
+
+	ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, USB_REG_OUT_PIPE),
+			   &cmd, sizeof(cmd), NULL, HZ);
+	if (ret)
+		dev_err(&udev->dev, "ath9k_htc: USB reboot failed\n");
+}
+
 static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
@@ -903,7 +914,7 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 	}
 
 	if (hif_dev->flags & HIF_USB_START)
-		usb_reset_device(udev);
+		ath9k_hif_usb_reboot(udev);
 
 	kfree(hif_dev);
 	dev_info(&udev->dev, "ath9k_htc: USB layer deinitialized\n");
-- 
1.7.0.5

