Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:56131 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaGUVl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:27 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so8197973wes.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 14:41:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6656: Remove static declaration vnt_submit_rx_urb_complete
Date: Mon, 21 Jul 2014 22:40:43 +0100
Message-Id: <1405978847-2750-2-git-send-email-tvboxspy@gmail.com> (sfid-20140721_234150_538657_60AACC37)
In-Reply-To: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
References: <1405978847-2750-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving vnt_submit_rx_urb in visibility of vnt_submit_rx_urb_complete

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 62 ++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 8bd776e..7444bba 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -57,7 +57,6 @@
 #define URB_ASYNC_UNLINK    0
 #endif
 
-static void vnt_submit_rx_urb_complete(struct urb *urb);
 static void vnt_tx_context_complete(struct urb *urb);
 
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
@@ -181,36 +180,6 @@ int vnt_start_interrupt_urb(struct vnt_private *priv)
 	return status;
 }
 
-int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
-{
-	int status = 0;
-	struct urb *urb;
-
-	urb = rcb->urb;
-	if (rcb->skb == NULL) {
-		dev_dbg(&priv->usb->dev, "rcb->skb is null\n");
-		return status;
-	}
-
-	usb_fill_bulk_urb(urb,
-		priv->usb,
-		usb_rcvbulkpipe(priv->usb, 2),
-		skb_put(rcb->skb, skb_tailroom(rcb->skb)),
-		MAX_TOTAL_SIZE_WITH_ALL_HEADERS,
-		vnt_submit_rx_urb_complete,
-		rcb);
-
-	status = usb_submit_urb(urb, GFP_ATOMIC);
-	if (status != 0) {
-		dev_dbg(&priv->usb->dev, "Submit Rx URB failed %d\n", status);
-		return STATUS_FAILURE ;
-	}
-
-	rcb->in_use = true;
-
-	return status;
-}
-
 static void vnt_submit_rx_urb_complete(struct urb *urb)
 {
 	struct vnt_rcb *rcb = urb->context;
@@ -263,6 +232,37 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 	return;
 }
 
+int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
+{
+	int status = 0;
+	struct urb *urb;
+
+	urb = rcb->urb;
+	if (rcb->skb == NULL) {
+		dev_dbg(&priv->usb->dev, "rcb->skb is null\n");
+		return status;
+	}
+
+	usb_fill_bulk_urb(urb,
+			  priv->usb,
+			  usb_rcvbulkpipe(priv->usb, 2),
+			  skb_put(rcb->skb, skb_tailroom(rcb->skb)),
+			  MAX_TOTAL_SIZE_WITH_ALL_HEADERS,
+			  vnt_submit_rx_urb_complete,
+			  rcb);
+
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status != 0) {
+		dev_dbg(&priv->usb->dev, "Submit Rx URB failed %d\n", status);
+		return STATUS_FAILURE;
+	}
+
+	rcb->in_use = true;
+
+	return status;
+}
+
+
 int vnt_tx_context(struct vnt_private *priv,
 				struct vnt_usb_send_context *context)
 {
-- 
2.0.1

