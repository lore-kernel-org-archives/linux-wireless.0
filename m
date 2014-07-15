Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:35893 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854AbaGOS4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:56:00 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so5785196wes.29
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:55:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/12] staging: vt6656: rename s_nsInterruptUsbIoCompleteRead to vnt_start_interrupt_urb_complete
Date: Tue, 15 Jul 2014 19:54:38 +0100
Message-Id: <1405450483-2875-7-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205607_896737_F88EFE8F)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index a5c55f7..e7239d6 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -57,7 +57,7 @@
 #define URB_ASYNC_UNLINK    0
 #endif
 
-static void s_nsInterruptUsbIoCompleteRead(struct urb *urb);
+static void vnt_start_interrupt_urb_complete(struct urb *urb);
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
 
@@ -145,7 +145,7 @@ int vnt_start_interrupt_urb(struct vnt_private *priv)
 		usb_rcvintpipe(priv->usb, 1),
 		priv->int_buf.data_buf,
 		MAX_INTERRUPT_SIZE,
-		s_nsInterruptUsbIoCompleteRead,
+		vnt_start_interrupt_urb_complete,
 		priv,
 		priv->int_interval);
 
@@ -173,7 +173,7 @@ int vnt_start_interrupt_urb(struct vnt_private *priv)
  *
  */
 
-static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
+static void vnt_start_interrupt_urb_complete(struct urb *urb)
 {
 	struct vnt_private *priv = urb->context;
 	int status;
-- 
2.0.1

