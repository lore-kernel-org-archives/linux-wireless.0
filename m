Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57662 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBQV1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 16:27:38 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so2798321wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 13:27:37 -0800 (PST)
Message-ID: <1392672450.11154.15.camel@canaries64-MCP7A> (sfid-20140217_222745_504182_2D68125F)
Subject: [PATCH 5/5] staging: vt6656: clean up
 s_nsInterruptUsbIoCompleteRead
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Feb 2014 21:27:30 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove comments, white space and camel case

Camel Case changes
pDevice -> priv
ntStatus -> status

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 69 ++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 3721937..119f656 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -348,22 +348,12 @@ usb_fill_bulk_urb(pDevice->pInterruptURB,
 
 static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 {
-	struct vnt_private *pDevice = (struct vnt_private *)urb->context;
-	int ntStatus;
+	struct vnt_private *priv = (struct vnt_private *)urb->context;
+	int status;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptUsbIoCompleteRead\n");
-    //
-    // The context given to IoSetCompletionRoutine is the receive buffer object
-    //
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"---->s_nsInterruptUsbIoCompleteRead\n");
 
-    //
-    // We have a number of cases:
-    //      1) The USB read timed out and we received no data.
-    //      2) The USB read timed out and we received some data.
-    //      3) The USB read was successful and fully filled our irp buffer.
-    //      4) The irp was cancelled.
-    //      5) Some other failure from the USB device object.
-    //
 	switch (urb->status) {
 	case 0:
 	case -ETIMEDOUT:
@@ -371,50 +361,39 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		pDevice->intBuf.bInUse = false;
+		priv->intBuf.bInUse = false;
 		return;
 	default:
 		break;
 	}
 
-    ntStatus = urb->status;
+	status = urb->status;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsInterruptUsbIoCompleteRead Status %d\n", ntStatus);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"s_nsInterruptUsbIoCompleteRead Status %d\n", status);
 
-    // if we were not successful, we need to free the int buffer for future use right here
-    // otherwise interrupt data handler will free int buffer after it handle it.
-    if (( ntStatus != STATUS_SUCCESS )) {
-        pDevice->ulBulkInError++;
-        pDevice->intBuf.bInUse = false;
-
-//        if (ntStatus == USBD_STATUS_CRC) {
-//            pDevice->ulIntInContCRCError++;
-//        }
+	if (status != STATUS_SUCCESS) {
+		priv->ulBulkInError++;
+		priv->intBuf.bInUse = false;
 
-//        if (ntStatus == STATUS_NOT_CONNECTED )
-//        {
-//        }
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"IntUSBIoCompleteControl STATUS = %d\n", ntStatus );
-    } else {
-	    pDevice->ulIntInBytesRead += (unsigned long) urb->actual_length;
-	    pDevice->ulIntInContCRCError = 0;
-	    pDevice->bEventAvailable = true;
-	    INTnsProcessData(pDevice);
-    }
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"IntUSBIoCompleteControl STATUS = %d\n", status);
+	} else {
+		priv->ulIntInBytesRead += (unsigned long)urb->actual_length;
+		priv->ulIntInContCRCError = 0;
+		priv->bEventAvailable = true;
+		INTnsProcessData(priv);
+	}
 
-	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
-	if (ntStatus) {
+	status = usb_submit_urb(priv->pInterruptURB, GFP_ATOMIC);
+	if (status) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Submit int URB failed %d\n", ntStatus);
+			"Submit int URB failed %d\n", status);
 	} else {
-		pDevice->intBuf.bInUse = true;
+		priv->intBuf.bInUse = true;
 	}
 
-    //
-    // We return STATUS_MORE_PROCESSING_REQUIRED so that the completion
-    // routine (IofCompleteRequest) will stop working on the irp.
-    //
-    return ;
+	return;
 }
 
 /*
-- 
1.9.rc1

