Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:42671 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaBQVQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 16:16:33 -0500
Received: by mail-we0-f169.google.com with SMTP id t61so11188964wes.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 13:16:32 -0800 (PST)
Message-ID: <1392671780.11154.6.camel@canaries64-MCP7A> (sfid-20140217_221639_754953_47F44D96)
Subject: [PATCH 2/5] staging: vt6656: s_nsInterruptUsbIoCompleteRead add urb
 status returns
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Feb 2014 21:16:20 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop out of urb return on usb errors and set intBuf.bInUse to false.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 258eec1..d18cb2f 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -364,6 +364,19 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
     //      4) The irp was cancelled.
     //      5) Some other failure from the USB device object.
     //
+	switch (urb->status) {
+	case 0:
+	case -ETIMEDOUT:
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		pDevice->intBuf.bInUse = false;
+		return;
+	default:
+		break;
+	}
+
     ntStatus = urb->status;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsInterruptUsbIoCompleteRead Status %d\n", ntStatus);
-- 
1.9.rc1


