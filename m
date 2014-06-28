Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39102 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaF1W41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:27 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so4293605wib.9
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/8] staging: vt6656: Remove rx handing from RXvWorkItem
Date: Sat, 28 Jun 2014 23:55:42 +0100
Message-Id: <1403996146-4082-4-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005638_359444_2F662D75)
In-Reply-To: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
References: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In s_nsBulkInUsbIoCompleteRead reuse or reallocate sb_buff and resubmit
urb.

In device_alloc_bufs allocate memory to rcb individually and
call PIPEnsBulkInUsbRead to submit the urbs

Change handling to free rcb in device_free_rx_bufs

Remove calls to workqueue.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 38 +++++++++++++++-----------------------
 drivers/staging/vt6656/usbpipe.c  | 25 +++++++++++++++----------
 2 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 86d9470..19d42ce 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -514,6 +514,8 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 
 	for (ii = 0; ii < priv->cbRD; ii++) {
 		rcb = priv->apRCB[ii];
+		if (!rcb)
+			continue;
 
 		/* deallocate URBs */
 		if (rcb->pUrb) {
@@ -524,9 +526,9 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 		/* deallocate skb */
 		if (rcb->skb)
 			dev_kfree_skb(rcb->skb);
-	}
 
-	kfree(priv->pRCBMem);
+		kfree(rcb);
+	}
 
 	return;
 }
@@ -576,22 +578,16 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 		tx_context->in_use = false;
 	}
 
-	/* allocate RCB mem */
-	priv->pRCBMem = kzalloc((sizeof(struct vnt_rcb) * priv->cbRD),
-								GFP_KERNEL);
-	if (priv->pRCBMem == NULL) {
-		dev_err(&priv->usb->dev, "alloc rx usb context failed\n");
-		goto free_tx;
-	}
-
-	priv->FirstRecvFreeList = NULL;
-	priv->LastRecvFreeList = NULL;
-	priv->NumRecvFreeList = 0;
+	for (ii = 0; ii < priv->cbRD; ii++) {
+		priv->apRCB[ii] = kzalloc(sizeof(struct vnt_rcb), GFP_KERNEL);
+		if (!priv->apRCB[ii]) {
+			dev_err(&priv->usb->dev,
+					"failed to allocate rcb no %d\n", ii);
+			goto free_rx_tx;
+		}
 
-	rcb = (struct vnt_rcb *)priv->pRCBMem;
+		rcb = priv->apRCB[ii];
 
-	for (ii = 0; ii < priv->cbRD; ii++) {
-		priv->apRCB[ii] = rcb;
 		rcb->pDevice = priv;
 
 		/* allocate URBs */
@@ -611,11 +607,9 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 
 		rcb->bBoolInUse = false;
 
-		EnqueueRCB(priv->FirstRecvFreeList,
-						priv->LastRecvFreeList, rcb);
-
-		priv->NumRecvFreeList++;
-		rcb++;
+		/* submit rx urb */
+		if (PIPEnsBulkInUsbRead(priv, rcb))
+			goto free_rx_tx;
 	}
 
 	priv->pInterruptURB = usb_alloc_urb(0, GFP_ATOMIC);
@@ -678,7 +672,6 @@ static int vnt_start(struct ieee80211_hw *hw)
 
 	priv->int_interval = 1;  /* bInterval is set to 1 */
 
-	schedule_work(&priv->read_work_item);
 	INTvWorkItem(priv);
 
 	priv->flags |= DEVICE_FLAGS_OPENED;
@@ -722,7 +715,6 @@ static void vnt_stop(struct ieee80211_hw *hw)
 	MP_CLEAR_FLAG(priv, fMP_POST_READS);
 
 	cancel_delayed_work_sync(&priv->run_command_work);
-	cancel_work_sync(&priv->read_work_item);
 
 	priv->bCmdRunning = false;
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 6a7e692..428193e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -230,9 +230,6 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 	int status = 0;
 	struct urb *urb;
 
-	if (priv->Flags & fMP_DISCONNECTED)
-		return STATUS_FAILURE;
-
 	urb = rcb->pUrb;
 	if (rcb->skb == NULL) {
 		dev_dbg(&priv->usb->dev, "rcb->skb is null\n");
@@ -303,16 +300,24 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	rcb->Ref--;
-	if (rcb->Ref == 0) {
-		dev_dbg(&priv->usb->dev,
-				"RxvFreeNormal %d\n", priv->NumRecvFreeList);
+	if (re_alloc_skb) {
+		rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
+		if (!rcb->skb) {
+			dev_dbg(&priv->usb->dev, "Failed to re-alloc rx skb\n");
 
-		spin_lock_irqsave(&priv->lock, flags);
+			rcb->bBoolInUse = false;
 
-		RXvFreeRCB(rcb, re_alloc_skb);
+			return;
+		}
 
-		spin_unlock_irqrestore(&priv->lock, flags);
+		urb->transfer_buffer = skb_put(rcb->skb,
+						skb_tailroom(rcb->skb));
+	}
+
+	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+		dev_dbg(&priv->usb->dev, "Failed to re submit rx skb\n");
+
+		rcb->bBoolInUse = false;
 	}
 
 	return;
-- 
1.9.1

