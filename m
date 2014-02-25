Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:61736 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaBYUx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:53:57 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so906980wes.16
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:56 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/10] staging: vt6656: Cleanup PIPEnsBulkInUsbRead
Date: Tue, 25 Feb 2014 20:51:50 +0000
Message-Id: <1393361512-13805-8-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215404_215097_269709F7)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove camel case and white space.

Camel case changes
pDevice -> priv
pRCB -> rcb
ntStatus -> status
pUrb -> urb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 52 +++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 8092c9a..1477def 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -409,45 +409,43 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
  *
  */
 
-int PIPEnsBulkInUsbRead(struct vnt_private *pDevice, struct vnt_rcb *pRCB)
+int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 {
-	int ntStatus = 0;
-	struct urb *pUrb;
+	int status = 0;
+	struct urb *urb;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsStartBulkInUsbRead\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsStartBulkInUsbRead\n");
 
-    if (pDevice->Flags & fMP_DISCONNECTED)
-        return STATUS_FAILURE;
+	if (priv->Flags & fMP_DISCONNECTED)
+		return STATUS_FAILURE;
 
-    pDevice->ulBulkInPosted++;
+	priv->ulBulkInPosted++;
 
-	pUrb = pRCB->pUrb;
-    //
-    // Now that we have created the urb, we will send a
-    // request to the USB device object.
-    //
-    if (pRCB->skb == NULL) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pRCB->skb is null \n");
-        return ntStatus;
-    }
+	urb = rcb->pUrb;
+	if (rcb->skb == NULL) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"rcb->skb is null\n");
+		return status;
+	}
 
-	usb_fill_bulk_urb(pUrb,
-		pDevice->usb,
-		usb_rcvbulkpipe(pDevice->usb, 2),
-		(void *) (pRCB->skb->data),
+	usb_fill_bulk_urb(urb,
+		priv->usb,
+		usb_rcvbulkpipe(priv->usb, 2),
+		(void *) (rcb->skb->data),
 		MAX_TOTAL_SIZE_WITH_ALL_HEADERS,
 		s_nsBulkInUsbIoCompleteRead,
-		pRCB);
+		rcb);
 
-	ntStatus = usb_submit_urb(pUrb, GFP_ATOMIC);
-	if (ntStatus != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit Rx URB failed %d\n", ntStatus);
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status != 0) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Submit Rx URB failed %d\n", status);
 		return STATUS_FAILURE ;
 	}
-    pRCB->Ref = 1;
-    pRCB->bBoolInUse= true;
 
-    return ntStatus;
+	rcb->Ref = 1;
+	rcb->bBoolInUse = true;
+
+	return status;
 }
 
 /*
-- 
1.9.0

