Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63014 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaBSVxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 16:53:46 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so846888wgh.7
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 13:53:45 -0800 (PST)
Message-ID: <1392846815.20211.12.camel@canaries64-MCP7A> (sfid-20140219_225349_596544_9A8E9CF7)
Subject: [PATCH 2/4] staging: vt6656: s_nsBulkOutIoCompleteWrite add error
 handling,
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 21:53:35 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

change pContext->bBoolInUse to false on connection errors.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 16acc9a..61d8220 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -616,6 +616,19 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
 
+	switch (urb->status) {
+	case 0:
+	case -ETIMEDOUT:
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		pContext->bBoolInUse = false;
+		return;
+	default:
+		break;
+	}
+
     if (!netif_device_present(pDevice->dev))
 	    return;
 
-- 
1.9.rc1



