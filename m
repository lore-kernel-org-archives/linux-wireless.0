Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45690 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbaGOS4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:56:03 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so4017156wiw.12
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:56:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/12] staging: vt6656: rename s_nsBulkOutIoCompleteWrite to vnt_tx_context_complete
Date: Tue, 15 Jul 2014 19:54:40 +0100
Message-Id: <1405450483-2875-9-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205609_250135_8A0BD70C)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index db1bc1a..54badfe 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -59,7 +59,7 @@
 
 static void vnt_start_interrupt_urb_complete(struct urb *urb);
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
-static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
+static void vnt_tx_context_complete(struct urb *urb);
 
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		u16 index, u16 length, u8 *buffer)
@@ -355,7 +355,7 @@ int vnt_tx_context(struct vnt_private *priv,
 			usb_sndbulkpipe(priv->usb, 3),
 			context->data,
 			context->buf_len,
-			s_nsBulkOutIoCompleteWrite,
+			vnt_tx_context_complete,
 			context);
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
@@ -370,7 +370,7 @@ int vnt_tx_context(struct vnt_private *priv,
 }
 
 /*
- * Description: s_nsBulkOutIoCompleteWrite
+ * Description: vnt_tx_context_complete
  *     1a) Indicate to the protocol the status of the write.
  *     1b) Return ownership of the packet to the protocol.
  *
@@ -397,7 +397,7 @@ int vnt_tx_context(struct vnt_private *priv,
  *
  */
 
-static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
+static void vnt_tx_context_complete(struct urb *urb)
 {
 	struct vnt_usb_send_context *context = urb->context;
 	struct vnt_private *priv = context->priv;
-- 
2.0.1

