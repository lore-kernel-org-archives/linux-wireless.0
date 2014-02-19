Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46097 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaBSSfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 13:35:44 -0500
Received: by mail-wg0-f49.google.com with SMTP id y10so640632wgg.28
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 10:35:43 -0800 (PST)
Message-ID: <1392834922.8766.8.camel@canaries64-MCP7A> (sfid-20140219_193602_329926_66B8C408)
Subject: [PATCH 1/4] staging: vt6656: PIPEnsInterruptRead use
 usb_fill_int_urb
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 18:35:22 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change to usb_fill_int_urb which has int_interval.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 119f656..845a8a1 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -312,15 +312,15 @@ int PIPEnsInterruptRead(struct vnt_private *pDevice)
     // Now that we have created the urb, we will send a
     // request to the USB device object.
     //
-    pDevice->pInterruptURB->interval = pDevice->int_interval;
 
-usb_fill_bulk_urb(pDevice->pInterruptURB,
+	usb_fill_int_urb(pDevice->pInterruptURB,
 		pDevice->usb,
 		usb_rcvbulkpipe(pDevice->usb, 1),
-		(void *) pDevice->intBuf.pDataBuf,
+		pDevice->intBuf.pDataBuf,
 		MAX_INTERRUPT_SIZE,
 		s_nsInterruptUsbIoCompleteRead,
-		pDevice);
+		pDevice,
+		pDevice->int_interval);
 
 	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
 	if (ntStatus != 0) {
-- 
1.9.rc1


