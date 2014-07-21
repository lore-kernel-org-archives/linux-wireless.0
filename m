Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64972 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaGUVlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:25 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so4867468wiw.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 14:41:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6656: Remove static declaration vnt_start_interrupt_urb_complete
Date: Mon, 21 Jul 2014 22:40:42 +0100
Message-Id: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com> (sfid-20140721_234129_911577_E6EE5657)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving vnt_start_interrupt_urb in visibility of vnt_start_interrupt_urb_complete

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 55 ++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 9a88749..8bd776e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -57,7 +57,6 @@
 #define URB_ASYNC_UNLINK    0
 #endif
 
-static void vnt_start_interrupt_urb_complete(struct urb *urb);
 static void vnt_submit_rx_urb_complete(struct urb *urb);
 static void vnt_tx_context_complete(struct urb *urb);
 
@@ -117,33 +116,6 @@ void vnt_control_in_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 *data)
 			reg_off, reg, sizeof(u8), data);
 }
 
-int vnt_start_interrupt_urb(struct vnt_private *priv)
-{
-	int status = STATUS_FAILURE;
-
-	if (priv->int_buf.in_use == true)
-		return STATUS_FAILURE;
-
-	priv->int_buf.in_use = true;
-
-	usb_fill_int_urb(priv->interrupt_urb,
-		priv->usb,
-		usb_rcvintpipe(priv->usb, 1),
-		priv->int_buf.data_buf,
-		MAX_INTERRUPT_SIZE,
-		vnt_start_interrupt_urb_complete,
-		priv,
-		priv->int_interval);
-
-	status = usb_submit_urb(priv->interrupt_urb, GFP_ATOMIC);
-	if (status) {
-		dev_dbg(&priv->usb->dev, "Submit int URB failed %d\n", status);
-		priv->int_buf.in_use = false;
-	}
-
-	return status;
-}
-
 static void vnt_start_interrupt_urb_complete(struct urb *urb)
 {
 	struct vnt_private *priv = urb->context;
@@ -182,6 +154,33 @@ static void vnt_start_interrupt_urb_complete(struct urb *urb)
 	return;
 }
 
+int vnt_start_interrupt_urb(struct vnt_private *priv)
+{
+	int status = STATUS_FAILURE;
+
+	if (priv->int_buf.in_use == true)
+		return STATUS_FAILURE;
+
+	priv->int_buf.in_use = true;
+
+	usb_fill_int_urb(priv->interrupt_urb,
+			 priv->usb,
+			 usb_rcvintpipe(priv->usb, 1),
+			 priv->int_buf.data_buf,
+			 MAX_INTERRUPT_SIZE,
+			 vnt_start_interrupt_urb_complete,
+			 priv,
+			 priv->int_interval);
+
+	status = usb_submit_urb(priv->interrupt_urb, GFP_ATOMIC);
+	if (status) {
+		dev_dbg(&priv->usb->dev, "Submit int URB failed %d\n", status);
+		priv->int_buf.in_use = false;
+	}
+
+	return status;
+}
+
 int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 {
 	int status = 0;
-- 
2.0.1

