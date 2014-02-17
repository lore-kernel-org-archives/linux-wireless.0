Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:54760 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaBQVSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 16:18:53 -0500
Received: by mail-wg0-f54.google.com with SMTP id l18so2625966wgh.33
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 13:18:52 -0800 (PST)
Message-ID: <1392671920.11154.8.camel@canaries64-MCP7A> (sfid-20140217_221901_956475_0DF73B3F)
Subject: [PATCH 3/5] staging: vt6656: s_nsInterruptUsbIoCompleteRead remove
 usb_fill_bulk_urb
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Feb 2014 21:18:40 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to fill urb in again, just resubmit it.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index d18cb2f..1ab1bbc 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -404,14 +404,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
     }
 
     if (pDevice->fKillEventPollingThread != true) {
-       usb_fill_bulk_urb(pDevice->pInterruptURB,
-		      pDevice->usb,
-		      usb_rcvbulkpipe(pDevice->usb, 1),
-		     (void *) pDevice->intBuf.pDataBuf,
-		     MAX_INTERRUPT_SIZE,
-		     s_nsInterruptUsbIoCompleteRead,
-		     pDevice);
-
 	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
 	if (ntStatus) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-- 
1.9.rc1

