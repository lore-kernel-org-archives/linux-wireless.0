Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:49964 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaBYUxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:53:48 -0500
Received: by mail-we0-f180.google.com with SMTP id u57so892866wes.39
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:47 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/10] staging: vt6656: s_nsBulkInUsbIoCompleteRead get rid of status.
Date: Tue, 25 Feb 2014 20:51:46 +0000
Message-Id: <1393361512-13805-4-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215351_436395_89F6904B)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just use urb->status directly.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 9a922b4..2f8e8e6 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -472,15 +472,14 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 	unsigned long   bytesRead;
 	int bIndicateReceive = false;
 	int bReAllocSkb = false;
-	int status;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
-    status = urb->status;
+
     bytesRead = urb->actual_length;
 
-    if (status) {
+    if (urb->status) {
         pDevice->ulBulkInError++;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK In failed %d\n", status);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK In failed %d\n", urb->status);
 //todo...xxxxxx
 //        if (status == USBD_STATUS_CRC) {
 //            pDevice->ulBulkInContCRCError++;
-- 
1.9.0

