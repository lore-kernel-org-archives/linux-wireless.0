Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39217 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaGUVl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:28 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so8235316wes.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 14:41:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6656: remove static declaration vnt_tx_context_complete
Date: Mon, 21 Jul 2014 22:40:44 +0100
Message-Id: <1405978847-2750-3-git-send-email-tvboxspy@gmail.com> (sfid-20140721_234143_117168_4E46A686)
In-Reply-To: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
References: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving vnt_tx_context in visibility of vnt_tx_context_complete

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 67 +++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 7444bba..acb0608 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -57,8 +57,6 @@
 #define URB_ASYNC_UNLINK    0
 #endif
 
-static void vnt_tx_context_complete(struct urb *urb);
-
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		u16 index, u16 length, u8 *buffer)
 {
@@ -262,39 +260,6 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 	return status;
 }
 
-
-int vnt_tx_context(struct vnt_private *priv,
-				struct vnt_usb_send_context *context)
-{
-	int status;
-	struct urb *urb;
-
-	if (!(MP_IS_READY(priv) && priv->Flags & fMP_POST_WRITES)) {
-		context->in_use = false;
-		return STATUS_RESOURCES;
-	}
-
-	urb = context->urb;
-
-	usb_fill_bulk_urb(urb,
-			priv->usb,
-			usb_sndbulkpipe(priv->usb, 3),
-			context->data,
-			context->buf_len,
-			vnt_tx_context_complete,
-			context);
-
-	status = usb_submit_urb(urb, GFP_ATOMIC);
-	if (status != 0) {
-		dev_dbg(&priv->usb->dev, "Submit Tx URB failed %d\n", status);
-
-		context->in_use = false;
-		return STATUS_FAILURE;
-	}
-
-	return STATUS_PENDING;
-}
-
 static void vnt_tx_context_complete(struct urb *urb)
 {
 	struct vnt_usb_send_context *context = urb->context;
@@ -327,3 +292,35 @@ static void vnt_tx_context_complete(struct urb *urb)
 
 	return;
 }
+
+int vnt_tx_context(struct vnt_private *priv,
+		   struct vnt_usb_send_context *context)
+{
+	int status;
+	struct urb *urb;
+
+	if (!(MP_IS_READY(priv) && priv->Flags & fMP_POST_WRITES)) {
+		context->in_use = false;
+		return STATUS_RESOURCES;
+	}
+
+	urb = context->urb;
+
+	usb_fill_bulk_urb(urb,
+			  priv->usb,
+			  usb_sndbulkpipe(priv->usb, 3),
+			  context->data,
+			  context->buf_len,
+			  vnt_tx_context_complete,
+			  context);
+
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status != 0) {
+		dev_dbg(&priv->usb->dev, "Submit Tx URB failed %d\n", status);
+
+		context->in_use = false;
+		return STATUS_FAILURE;
+	}
+
+	return STATUS_PENDING;
+}
-- 
2.0.1

