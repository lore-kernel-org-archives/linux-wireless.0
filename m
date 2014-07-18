Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64732 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbaGRFhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:23 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so228288wib.10
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/9] staging: vt6656: struct vnt_rcb remove camel case
Date: Fri, 18 Jul 2014 06:36:11 +0100
Message-Id: <1405661776-3345-4-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073741_351928_4FA34170)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
pUrb -> urb
bBoolInUse -> in_use

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  6 +++---
 drivers/staging/vt6656/main_usb.c | 14 +++++++-------
 drivers/staging/vt6656/usbpipe.c  | 10 +++++-----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ad43c6f..8f318a9 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -219,10 +219,10 @@ enum {
 
 /* RCB (Receive Control Block) */
 struct vnt_rcb {
-	void *pDevice;
-	struct urb *pUrb;
+	void *priv;
+	struct urb *urb;
 	struct sk_buff *skb;
-	int bBoolInUse;
+	int in_use;
 };
 
 /* used to track bulk out irps */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 06e4861..be498bc 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -423,9 +423,9 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 			continue;
 
 		/* deallocate URBs */
-		if (rcb->pUrb) {
-			usb_kill_urb(rcb->pUrb);
-			usb_free_urb(rcb->pUrb);
+		if (rcb->urb) {
+			usb_kill_urb(rcb->urb);
+			usb_free_urb(rcb->urb);
 		}
 
 		/* deallocate skb */
@@ -495,11 +495,11 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 
 		rcb = priv->apRCB[ii];
 
-		rcb->pDevice = priv;
+		rcb->priv = priv;
 
 		/* allocate URBs */
-		rcb->pUrb = usb_alloc_urb(0, GFP_ATOMIC);
-		if (rcb->pUrb == NULL) {
+		rcb->urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (rcb->urb == NULL) {
 			dev_err(&priv->usb->dev, "Failed to alloc rx urb\n");
 			goto free_rx_tx;
 		}
@@ -510,7 +510,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 			goto free_rx_tx;
 		}
 
-		rcb->bBoolInUse = false;
+		rcb->in_use = false;
 
 		/* submit rx urb */
 		if (vnt_submit_rx_urb(priv, rcb))
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index d994b1b..126294d 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -187,7 +187,7 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 	int status = 0;
 	struct urb *urb;
 
-	urb = rcb->pUrb;
+	urb = rcb->urb;
 	if (rcb->skb == NULL) {
 		dev_dbg(&priv->usb->dev, "rcb->skb is null\n");
 		return status;
@@ -207,7 +207,7 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 		return STATUS_FAILURE ;
 	}
 
-	rcb->bBoolInUse = true;
+	rcb->in_use = true;
 
 	return status;
 }
@@ -215,7 +215,7 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 static void vnt_submit_rx_urb_complete(struct urb *urb)
 {
 	struct vnt_rcb *rcb = urb->context;
-	struct vnt_private *priv = rcb->pDevice;
+	struct vnt_private *priv = rcb->priv;
 	unsigned long flags;
 
 	switch (urb->status) {
@@ -240,7 +240,7 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 				dev_dbg(&priv->usb->dev,
 					"Failed to re-alloc rx skb\n");
 
-				rcb->bBoolInUse = false;
+				rcb->in_use = false;
 				spin_unlock_irqrestore(&priv->lock, flags);
 				return;
 			}
@@ -258,7 +258,7 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 	if (usb_submit_urb(urb, GFP_ATOMIC)) {
 		dev_dbg(&priv->usb->dev, "Failed to re submit rx skb\n");
 
-		rcb->bBoolInUse = false;
+		rcb->in_use = false;
 	}
 
 	return;
-- 
2.0.1

