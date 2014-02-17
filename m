Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:38160 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaBQVNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 16:13:35 -0500
Received: by mail-we0-f182.google.com with SMTP id u57so10880816wes.41
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 13:13:34 -0800 (PST)
Message-ID: <1392671571.11154.2.camel@canaries64-MCP7A> (sfid-20140217_221339_063395_70EF65E5)
Subject: [PATCH 1/5] staging: vt6656: s_nsInterruptUsbIoCompleteRead set
 intBuf.bInUse to true
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Feb 2014 21:12:51 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

intBuf.bInUse is set to false set back to true on successful usb_submit_urb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 01cf099..258eec1 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -400,9 +400,12 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 		     pDevice);
 
 	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
-	if (ntStatus != 0) {
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
-           }
+	if (ntStatus) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Submit int URB failed %d\n", ntStatus);
+	} else {
+		pDevice->intBuf.bInUse = true;
+	}
     }
     //
     // We return STATUS_MORE_PROCESSING_REQUIRED so that the completion
-- 
1.9.rc1

