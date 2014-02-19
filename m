Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35175 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaBSShx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 13:37:53 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so638841wgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 10:37:50 -0800 (PST)
Message-ID: <1392835052.8766.10.camel@canaries64-MCP7A> (sfid-20140219_193804_014789_4967B007)
Subject: [PATCH 3/4] staging: vt6656: clean up PIPEnsInterruptRead.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 18:37:32 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove comments, white space and camel case.

Camel case changes
pDevice -> priv
ntStatus -> status

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 47 +++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 1a0b436..9f4d1a2 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -295,42 +295,39 @@ static void s_nsControlInUsbIoCompleteRead(struct urb *urb)
  *
  */
 
-int PIPEnsInterruptRead(struct vnt_private *pDevice)
+int PIPEnsInterruptRead(struct vnt_private *priv)
 {
-	int ntStatus = STATUS_FAILURE;
+	int status = STATUS_FAILURE;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsStartInterruptUsbRead()\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"---->s_nsStartInterruptUsbRead()\n");
 
-    if(pDevice->intBuf.bInUse == true){
-        return (STATUS_FAILURE);
-    }
-    pDevice->intBuf.bInUse = true;
-//    pDevice->bEventAvailable = false;
-    pDevice->ulIntInPosted++;
+	if (priv->intBuf.bInUse == true)
+		return STATUS_FAILURE;
 
-    //
-    // Now that we have created the urb, we will send a
-    // request to the USB device object.
-    //
+	priv->intBuf.bInUse = true;
+	priv->ulIntInPosted++;
 
-	usb_fill_int_urb(pDevice->pInterruptURB,
-		pDevice->usb,
-		usb_rcvbulkpipe(pDevice->usb, 1),
-		pDevice->intBuf.pDataBuf,
+	usb_fill_int_urb(priv->pInterruptURB,
+		priv->usb,
+		usb_rcvbulkpipe(priv->usb, 1),
+		priv->intBuf.pDataBuf,
 		MAX_INTERRUPT_SIZE,
 		s_nsInterruptUsbIoCompleteRead,
-		pDevice,
-		pDevice->int_interval);
+		priv,
+		priv->int_interval);
 
-	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
-	if (ntStatus) {
+	status = usb_submit_urb(priv->pInterruptURB, GFP_ATOMIC);
+	if (status) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Submit int URB failed %d\n", ntStatus);
-		pDevice->intBuf.bInUse = false;
+			"Submit int URB failed %d\n", status);
+		priv->intBuf.bInUse = false;
 	}
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----s_nsStartInterruptUsbRead Return(%x)\n",ntStatus);
-    return ntStatus;
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"<----s_nsStartInterruptUsbRead Return(%x)\n", status);
+
+	return status;
 }
 
 /*
-- 
1.9.rc1


