Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64498 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaBYUxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:53:51 -0500
Received: by mail-wi0-f176.google.com with SMTP id hi5so5069243wib.9
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:50 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/10] staging: vt6656: s_nsBulkInUsbIoCompleteRead Remove bytesRead/bIndicateReceive.
Date: Tue, 25 Feb 2014 20:51:47 +0000
Message-Id: <1393361512-13805-5-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215354_231319_3399492B)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with urb->actual_length.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 2f8e8e6..87601b7 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -469,14 +469,10 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 {
 	struct vnt_rcb *pRCB = (struct vnt_rcb *)urb->context;
 	struct vnt_private *pDevice = pRCB->pDevice;
-	unsigned long   bytesRead;
-	int bIndicateReceive = false;
 	int bReAllocSkb = false;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
 
-    bytesRead = urb->actual_length;
-
     if (urb->status) {
         pDevice->ulBulkInError++;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK In failed %d\n", urb->status);
@@ -489,15 +485,13 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 //            MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
 //        }
     } else {
-	if (bytesRead)
-		bIndicateReceive = true;
         pDevice->ulBulkInContCRCError = 0;
-        pDevice->ulBulkInBytesRead += bytesRead;
+	pDevice->ulBulkInBytesRead += urb->actual_length;
     }
 
-    if (bIndicateReceive) {
+    if (urb->actual_length) {
         spin_lock(&pDevice->lock);
-        if (RXbBulkInProcessData(pDevice, pRCB, bytesRead) == true)
+	if (RXbBulkInProcessData(pDevice, pRCB, urb->actual_length) == true)
             bReAllocSkb = true;
         spin_unlock(&pDevice->lock);
     }
-- 
1.9.0

