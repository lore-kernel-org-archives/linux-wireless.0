Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:36003 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaCPMfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 08:35:10 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so3660828wes.34
        for <linux-wireless@vger.kernel.org>; Sun, 16 Mar 2014 05:35:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6656: [BUG] Fix Warning BOGUS urb xfer, pipe 3 != type 1
Date: Sun, 16 Mar 2014 12:34:11 +0000
Message-Id: <1394973251-3055-1-git-send-email-tvboxspy@gmail.com> (sfid-20140316_133514_668548_A4443DDC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stable kernels will need patches
staging: vt6656: s_nsInterruptUsbIoCompleteRead remove usb_fill_bulk_urb
staging: vt6656: PIPEnsInterruptRead use usb_fill_int_urb

and a backported version of this patch.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index a4a4bf2..9381654d 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -309,7 +309,7 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 
 	usb_fill_int_urb(priv->pInterruptURB,
 		priv->usb,
-		usb_rcvbulkpipe(priv->usb, 1),
+		usb_rcvintpipe(priv->usb, 1),
 		priv->int_buf.data_buf,
 		MAX_INTERRUPT_SIZE,
 		s_nsInterruptUsbIoCompleteRead,
-- 
1.9.0

