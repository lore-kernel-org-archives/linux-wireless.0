Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39498 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaBSVuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 16:50:32 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so838012wgh.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 13:50:31 -0800 (PST)
Message-ID: <1392846614.20211.10.camel@canaries64-MCP7A> (sfid-20140219_225035_414131_6C09C3F2)
Subject: [PATCH 1/4] staging: vt6656: s_nsBulkOutIoCompleteWrite reorganise
 variable order.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 21:50:14 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare in order of pointer use.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 79e38b7..16acc9a 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -607,21 +607,14 @@ int PIPEnsSendBulkOut(struct vnt_private *pDevice,
 
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 {
-	struct vnt_private *pDevice;
+	struct vnt_usb_send_context *pContext =
+			(struct vnt_usb_send_context *)urb->context;
+	struct vnt_private *pDevice = pContext->pDevice;
+	CONTEXT_TYPE ContextType = pContext->Type;
+	unsigned long ulBufLen = pContext->uBufLen;
 	int status;
-	CONTEXT_TYPE ContextType;
-	unsigned long ulBufLen;
-	struct vnt_usb_send_context *pContext;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
-    //
-    // The context given to IoSetCompletionRoutine is an USB_CONTEXT struct
-    //
-	pContext = (struct vnt_usb_send_context *)urb->context;
-
-    pDevice = pContext->pDevice;
-    ContextType = pContext->Type;
-    ulBufLen = pContext->uBufLen;
 
     if (!netif_device_present(pDevice->dev))
 	    return;
-- 
1.9.rc1



