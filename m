Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33252 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBYUxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:53:18 -0500
Received: by mail-wg0-f48.google.com with SMTP id b13so919774wgh.7
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:16 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/10] staging: vt6656: usb_fill_bulk_urb get rid of void* cast.
Date: Tue, 25 Feb 2014 20:51:44 +0000
Message-Id: <1393361512-13805-2-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215322_647507_6969C400)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index a93d0ff..706c163 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -556,14 +556,13 @@ int PIPEnsSendBulkOut(struct vnt_private *pDevice,
         pUrb = pContext->pUrb;
         pDevice->ulBulkOutPosted++;
 //        pDevice->pPendingBulkOutContext = pContext;
-        usb_fill_bulk_urb(
-        	    pUrb,
-        		pDevice->usb,
-		    usb_sndbulkpipe(pDevice->usb, 3),
-		    (void *) &(pContext->Data[0]),
-        		pContext->uBufLen,
-        		s_nsBulkOutIoCompleteWrite,
-        		pContext);
+	usb_fill_bulk_urb(pUrb,
+			pDevice->usb,
+			usb_sndbulkpipe(pDevice->usb, 3),
+			pContext->Data,
+			pContext->uBufLen,
+			s_nsBulkOutIoCompleteWrite,
+			pContext);
 
     	status = usb_submit_urb(pUrb, GFP_ATOMIC);
     	if (status != 0)
-- 
1.9.0

