Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65015 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab0DWE6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:58:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 21:58:38 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19409.10472.450708.915467@gargle.gargle.HOWL>
Date: Fri, 23 Apr 2010 10:28:16 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/11] ath9k_htc: Use USB reboot
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, apparently there is a USB reboot command
that the target accepts. Using this instead of
usb_reset_device() fixes the issue of "descriptor read error"
that pops up on repeated load/unload.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index cee5feb..31665c5 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -889,6 +889,26 @@ err_alloc:
 	return ret;
 }
 
+static void ath9k_hif_usb_reboot(struct usb_device *udev)
+{
+	u32 reboot_cmd = 0xffffffff;
+	void *buf;
+	int ret;
+
+	buf = kmalloc(4, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	memcpy(buf, &reboot_cmd, 4);
+
+	ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, USB_REG_OUT_PIPE),
+			   buf, 4, NULL, HZ);
+	if (ret)
+		dev_err(&udev->dev, "ath9k_htc: USB reboot failed\n");
+
+	kfree(buf);
+}
+
 static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
@@ -903,7 +923,7 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 	}
 
 	if (hif_dev->flags & HIF_USB_START)
-		usb_reset_device(udev);
+		ath9k_hif_usb_reboot(udev);
 
 	kfree(hif_dev);
 	dev_info(&udev->dev, "ath9k_htc: USB layer deinitialized\n");
-- 
1.7.0.5

