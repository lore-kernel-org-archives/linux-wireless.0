Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62221 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2JGKlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2012 06:41:40 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2212311eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2012 03:41:39 -0700 (PDT)
Message-ID: <1349606491.2433.6.camel@Route3278> (sfid-20121007_124146_114584_22074E7A)
Subject: [PATCH] staging: vt6656: Keep firmware loading local and release
 firware.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 07 Oct 2012 11:41:31 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware is retained unreleased for the entire duration of the
driver.

When done release firmware and if the need be request firmware again.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |    1 -
 drivers/staging/vt6656/firmware.c |   22 ++++++++++------------
 drivers/staging/vt6656/main_usb.c |    1 -
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 171dd68..2abba75 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -418,7 +418,6 @@ typedef struct __device_info {
     struct net_device*          dev;
     struct net_device_stats     stats;
 
-    const struct firmware	*firmware;
 
     OPTIONS                     sOpts;
 
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 8c8126a..8831ea0 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -61,28 +61,24 @@ FIRMWAREbDownload(
      PSDevice pDevice
     )
 {
+	struct device *dev = &pDevice->usb->dev;
 	const struct firmware *fw;
 	int NdisStatus;
 	void *pBuffer = NULL;
 	BOOL result = FALSE;
 	u16 wLength;
-	int ii;
+	int ii, rc;
+
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Download firmware\n");
 	spin_unlock_irq(&pDevice->lock);
 
-	if (!pDevice->firmware) {
-		struct device *dev = &pDevice->usb->dev;
-		int rc;
-
-		rc = request_firmware(&pDevice->firmware, FIRMWARE_NAME, dev);
-		if (rc) {
-			dev_err(dev, "firmware file %s request failed (%d)\n",
-				FIRMWARE_NAME, rc);
+	rc = request_firmware(&fw, FIRMWARE_NAME, dev);
+	if (rc) {
+		dev_err(dev, "firmware file %s request failed (%d)\n",
+			FIRMWARE_NAME, rc);
 			goto out;
-		}
 	}
-	fw = pDevice->firmware;
 
 	pBuffer = kmalloc(FIRMWARE_CHUNK_SIZE, GFP_KERNEL);
 	if (!pBuffer)
@@ -103,10 +99,12 @@ FIRMWAREbDownload(
 		DBG_PRT(MSG_LEVEL_DEBUG,
 			KERN_INFO"Download firmware...%d %zu\n", ii, fw->size);
 		if (NdisStatus != STATUS_SUCCESS)
-			goto out;
+			goto free_fw;
         }
 
 	result = TRUE;
+free_fw:
+	release_firmware(fw);
 
 out:
 	kfree(pBuffer);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d536756..511558b 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1219,7 +1219,6 @@ static void __devexit vt6656_disconnect(struct usb_interface *intf)
 	}
 
 	device_release_WPADEV(device);
-	release_firmware(device->firmware);
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
-- 
1.7.10.4


