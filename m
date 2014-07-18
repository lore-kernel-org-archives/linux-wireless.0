Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47379 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaGRFh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:28 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so221945wib.14
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/9] staging: vt6656: struct vnt_private pInterruptURB rename to interrupt_urb
Date: Fri, 18 Jul 2014 06:36:14 +0100
Message-Id: <1405661776-3345-7-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073737_520573_D696BA63)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c | 14 +++++++-------
 drivers/staging/vt6656/usbpipe.c  |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 8257a64..22554af 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -284,7 +284,7 @@ struct vnt_private {
 	unsigned long Flags;
 
 	/* USB */
-	struct urb *pInterruptURB;
+	struct urb *interrupt_urb;
 	u32 int_interval;
 
 	/* Variables to track resources for the BULK In Pipe */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index be498bc..fe2f0bc 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -517,8 +517,8 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 			goto free_rx_tx;
 	}
 
-	priv->pInterruptURB = usb_alloc_urb(0, GFP_ATOMIC);
-	if (priv->pInterruptURB == NULL) {
+	priv->interrupt_urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (priv->interrupt_urb == NULL) {
 		dev_err(&priv->usb->dev, "Failed to alloc int urb\n");
 		goto free_rx_tx;
 	}
@@ -526,7 +526,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 	priv->int_buf.data_buf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
 	if (priv->int_buf.data_buf == NULL) {
 		dev_err(&priv->usb->dev, "Failed to alloc int buf\n");
-		usb_free_urb(priv->pInterruptURB);
+		usb_free_urb(priv->interrupt_urb);
 		goto free_rx_tx;
 	}
 
@@ -590,8 +590,8 @@ free_all:
 	device_free_tx_bufs(priv);
 	device_free_int_bufs(priv);
 
-	usb_kill_urb(priv->pInterruptURB);
-	usb_free_urb(priv->pInterruptURB);
+	usb_kill_urb(priv->interrupt_urb);
+	usb_free_urb(priv->interrupt_urb);
 
 	return -ENOMEM;
 }
@@ -629,8 +629,8 @@ static void vnt_stop(struct ieee80211_hw *hw)
 	device_free_rx_bufs(priv);
 	device_free_int_bufs(priv);
 
-	usb_kill_urb(priv->pInterruptURB);
-	usb_free_urb(priv->pInterruptURB);
+	usb_kill_urb(priv->interrupt_urb);
+	usb_free_urb(priv->interrupt_urb);
 
 	return;
 }
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 126294d..9a88749 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -126,7 +126,7 @@ int vnt_start_interrupt_urb(struct vnt_private *priv)
 
 	priv->int_buf.in_use = true;
 
-	usb_fill_int_urb(priv->pInterruptURB,
+	usb_fill_int_urb(priv->interrupt_urb,
 		priv->usb,
 		usb_rcvintpipe(priv->usb, 1),
 		priv->int_buf.data_buf,
@@ -135,7 +135,7 @@ int vnt_start_interrupt_urb(struct vnt_private *priv)
 		priv,
 		priv->int_interval);
 
-	status = usb_submit_urb(priv->pInterruptURB, GFP_ATOMIC);
+	status = usb_submit_urb(priv->interrupt_urb, GFP_ATOMIC);
 	if (status) {
 		dev_dbg(&priv->usb->dev, "Submit int URB failed %d\n", status);
 		priv->int_buf.in_use = false;
@@ -172,7 +172,7 @@ static void vnt_start_interrupt_urb_complete(struct urb *urb)
 		vnt_int_process_data(priv);
 	}
 
-	status = usb_submit_urb(priv->pInterruptURB, GFP_ATOMIC);
+	status = usb_submit_urb(priv->interrupt_urb, GFP_ATOMIC);
 	if (status) {
 		dev_dbg(&priv->usb->dev, "Submit int URB failed %d\n", status);
 	} else {
-- 
2.0.1

