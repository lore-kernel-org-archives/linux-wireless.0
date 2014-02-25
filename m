Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65402 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaBYUyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:54:00 -0500
Received: by mail-wg0-f41.google.com with SMTP id l18so920158wgh.12
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:53:58 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/10] staging: vt6656: Remove pointer cast to urb->context.
Date: Tue, 25 Feb 2014 20:51:51 +0000
Message-Id: <1393361512-13805-9-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215408_778190_0B122CEB)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary cast to void * urb->context

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 1477def..54c68a5 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -347,7 +347,7 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 
 static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 {
-	struct vnt_private *priv = (struct vnt_private *)urb->context;
+	struct vnt_private *priv = urb->context;
 	int status;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
@@ -465,7 +465,7 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 {
-	struct vnt_rcb *rcb = (struct vnt_rcb *)urb->context;
+	struct vnt_rcb *rcb = urb->context;
 	struct vnt_private *priv = rcb->pDevice;
 	int re_alloc_skb = false;
 
@@ -592,8 +592,7 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 {
-	struct vnt_usb_send_context *context =
-			(struct vnt_usb_send_context *)urb->context;
+	struct vnt_usb_send_context *context = urb->context;
 	struct vnt_private *priv = context->pDevice;
 	u8 context_type = context->type;
 	unsigned long buf_len = context->uBufLen;
-- 
1.9.0

