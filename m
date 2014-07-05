Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44419 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154AbaGESZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:25:00 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so963436wgh.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:24:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/8] staging: vt6656: Include re_alloc_skb within lock.
Date: Sat,  5 Jul 2014 19:24:26 +0100
Message-Id: <1404584667-3582-7-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202507_601978_09772D63)
In-Reply-To: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
References: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove variable re_alloc_skb and merge code within urb->actual_length.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index c5d4047..a7af4f58 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -276,7 +276,6 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 	struct vnt_rcb *rcb = urb->context;
 	struct vnt_private *priv = rcb->pDevice;
 	unsigned long flags;
-	int re_alloc_skb = false;
 
 	switch (urb->status) {
 	case 0:
@@ -294,24 +293,22 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 	if (urb->actual_length) {
 		spin_lock_irqsave(&priv->lock, flags);
 
-		if (vnt_rx_data(priv, rcb, urb->actual_length))
-			re_alloc_skb = true;
+		if (vnt_rx_data(priv, rcb, urb->actual_length)) {
+			rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
+			if (!rcb->skb) {
+				dev_dbg(&priv->usb->dev,
+					"Failed to re-alloc rx skb\n");
 
-		spin_unlock_irqrestore(&priv->lock, flags);
-	}
-
-	if (re_alloc_skb) {
-		rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
-		if (!rcb->skb) {
-			dev_dbg(&priv->usb->dev, "Failed to re-alloc rx skb\n");
-
-			rcb->bBoolInUse = false;
-
-			return;
+				rcb->bBoolInUse = false;
+				spin_unlock_irqrestore(&priv->lock, flags);
+				return;
+			}
 		}
 
 		urb->transfer_buffer = skb_put(rcb->skb,
 						skb_tailroom(rcb->skb));
+
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 	if (usb_submit_urb(urb, GFP_ATOMIC)) {
-- 
1.9.1

