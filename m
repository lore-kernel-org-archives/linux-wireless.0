Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:47158 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaB0XHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 18:07:21 -0500
Received: by mail-we0-f180.google.com with SMTP id u57so3500082wes.11
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 15:07:20 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/7] staging: vt6656: s_nsBulkOutIoCompleteWrite remove buf_len.
Date: Thu, 27 Feb 2014 23:06:14 +0000
Message-Id: <1393542375-13110-6-git-send-email-tvboxspy@gmail.com> (sfid-20140228_000732_117148_0ED3B87D)
In-Reply-To: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
References: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use context->uBufLen directly which is unsigned int.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index fb9200e..57efb7f 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -584,7 +584,6 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	struct vnt_usb_send_context *context = urb->context;
 	struct vnt_private *priv = context->pDevice;
 	u8 context_type = context->type;
-	unsigned long buf_len = context->uBufLen;
 	int status;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
@@ -610,7 +609,7 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 
 	if (status == STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Write %d bytes\n", (int)buf_len);
+			"Write %d bytes\n", context->uBufLen);
 	} else {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"BULK Out failed %d\n", status);
@@ -622,7 +621,7 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 			dev_kfree_skb_irq(context->pPacket);
 			context->pPacket = NULL;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"tx  %d bytes\n", (int)buf_len);
+				"tx  %d bytes\n", context->uBufLen);
 		}
 
 		priv->dev->trans_start = jiffies;
-- 
1.9.0

