Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47715 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbaBYUxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:53:53 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so891476wgh.15
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:52 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/10] staging: vt6656: s_nsBulkInUsbIoCompleteRead Replace error handling.
Date: Tue, 25 Feb 2014 20:51:48 +0000
Message-Id: <1393361512-13805-6-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215357_701994_D972056F)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use switch on urb->status

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 87601b7..1cab7a3 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -473,21 +473,22 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
 
-    if (urb->status) {
-        pDevice->ulBulkInError++;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK In failed %d\n", urb->status);
-//todo...xxxxxx
-//        if (status == USBD_STATUS_CRC) {
-//            pDevice->ulBulkInContCRCError++;
-//        }
-//        if (status == STATUS_DEVICE_NOT_CONNECTED )
-//        {
-//            MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
-//        }
-    } else {
-        pDevice->ulBulkInContCRCError = 0;
-	pDevice->ulBulkInBytesRead += urb->actual_length;
-    }
+	switch (urb->status) {
+	case 0:
+		pDevice->ulBulkInContCRCError = 0;
+		pDevice->ulBulkInBytesRead += urb->actual_length;
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		return;
+	case -ETIMEDOUT:
+	default:
+		pDevice->ulBulkInError++;
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"BULK In failed %d\n", urb->status);
+		break;
+	}
 
     if (urb->actual_length) {
         spin_lock(&pDevice->lock);
-- 
1.9.0

