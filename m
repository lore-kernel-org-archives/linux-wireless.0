Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:33123 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaF1W43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:29 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so6715231wes.0
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/8] staging: vt6656: dead code remove RXvWorkItem and RXvFreeRCB
Date: Sat, 28 Jun 2014 23:55:43 +0100
Message-Id: <1403996146-4082-5-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005638_936227_F87AC554)
In-Reply-To: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
References: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove work_struct and queue variables

Remove EnqueueRCB and DequeueRCB macros

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 29 -----------------
 drivers/staging/vt6656/dpc.c      | 68 ---------------------------------------
 drivers/staging/vt6656/main_usb.c |  1 -
 3 files changed, 98 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 0bba96f..f1ed43e 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -289,8 +289,6 @@ struct vnt_private {
 	struct usb_device *usb;
 	struct net_device_stats stats;
 
-	struct work_struct read_work_item;
-
 	u64 tsf_time;
 	u8 rx_rate;
 
@@ -308,14 +306,8 @@ struct vnt_private {
 	u32 int_interval;
 
 	/* Variables to track resources for the BULK In Pipe */
-	struct vnt_rcb *pRCBMem;
 	struct vnt_rcb *apRCB[CB_MAX_RX_DESC];
 	u32 cbRD;
-	struct vnt_rcb *FirstRecvFreeList;
-	struct vnt_rcb *LastRecvFreeList;
-	u32 NumRecvFreeList;
-
-	int bIsRxWorkItemQueued;
 
 	/* Variables to track resources for the BULK Out Pipe */
 	struct vnt_usb_send_context *apTD[CB_MAX_TX_DESC];
@@ -448,27 +440,6 @@ struct vnt_private {
 	struct iw_statistics wstats; /* wireless stats */
 };
 
-#define EnqueueRCB(_Head, _Tail, _RCB)                  \
-{                                                       \
-    if (!_Head) {                                       \
-        _Head = _RCB;                                   \
-    }                                                   \
-    else {                                              \
-        _Tail->Next = _RCB;                             \
-    }                                                   \
-    _RCB->Next = NULL;                                  \
-    _Tail = _RCB;                                       \
-}
-
-#define DequeueRCB(Head, Tail)                          \
-{                                                       \
-    struct vnt_rcb *RCB = Head;                         \
-    if (!RCB->Next) {                                   \
-        Tail = NULL;                                    \
-    }                                                   \
-    Head = RCB->Next;                                   \
-}
-
 #define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo) {   \
     if ((uVar) >= ((uModulo) - 1))                  \
         (uVar) = 0;                                 \
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 5ac5bcd..ca55554 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -44,74 +44,6 @@
 #include "rf.h"
 #include "usbpipe.h"
 
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-static int          msglevel                =MSG_LEVEL_INFO;
-
-void RXvWorkItem(struct work_struct *work)
-{
-	struct vnt_private *priv =
-		container_of(work, struct vnt_private, read_work_item);
-	int status;
-	struct vnt_rcb *rcb = NULL;
-	unsigned long flags;
-
-	if (priv->Flags & fMP_DISCONNECTED)
-		return;
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Polling Thread\n");
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	while ((priv->Flags & fMP_POST_READS) && MP_IS_READY(priv) &&
-			(priv->NumRecvFreeList != 0)) {
-		rcb = priv->FirstRecvFreeList;
-
-		priv->NumRecvFreeList--;
-
-		DequeueRCB(priv->FirstRecvFreeList, priv->LastRecvFreeList);
-
-		status = PIPEnsBulkInUsbRead(priv, rcb);
-	}
-
-	priv->bIsRxWorkItemQueued = false;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
-void RXvFreeRCB(struct vnt_rcb *rcb, int re_alloc_skb)
-{
-	struct vnt_private *priv = rcb->pDevice;
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->RXvFreeRCB\n");
-
-	if (re_alloc_skb == false) {
-		kfree_skb(rcb->skb);
-		re_alloc_skb = true;
-	}
-
-	if (re_alloc_skb == true) {
-		rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
-		/* TODO error handling */
-		if (!rcb->skb) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
-				" Failed to re-alloc rx skb\n");
-		}
-	}
-
-	/* Insert the RCB back in the Recv free list */
-	EnqueueRCB(priv->FirstRecvFreeList, priv->LastRecvFreeList, rcb);
-	priv->NumRecvFreeList++;
-
-	if ((priv->Flags & fMP_POST_READS) && MP_IS_READY(priv) &&
-			(priv->bIsRxWorkItemQueued == false)) {
-		priv->bIsRxWorkItemQueued = true;
-		schedule_work(&priv->read_work_item);
-	}
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d\n",
-			priv->NumRecvFreeList);
-}
-
 int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 	unsigned long bytes_received)
 {
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 19d42ce..a1d0c98 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1104,7 +1104,6 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	mutex_init(&priv->usb_lock);
 
 	INIT_DELAYED_WORK(&priv->run_command_work, vRunCommand);
-	INIT_WORK(&priv->read_work_item, RXvWorkItem);
 
 	usb_set_intfdata(intf, priv);
 
-- 
1.9.1

