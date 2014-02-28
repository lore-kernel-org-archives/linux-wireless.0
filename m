Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36540 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaB1X74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 18:59:56 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so1148458wgh.30
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 15:59:55 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/9] staging: vt6656: Clean up device_alloc_bufs
Date: Fri, 28 Feb 2014 23:58:34 +0000
Message-Id: <1393631919-16182-4-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010002_576502_4A40F57C)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up white space, comments and camel case.

pDevice -> priv
pTxContext -> tx_context
pRCB -> rcb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 138 +++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index bb1b4e9..e991618 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -804,88 +804,102 @@ static void device_free_int_bufs(struct vnt_private *pDevice)
 	return;
 }
 
-static bool device_alloc_bufs(struct vnt_private *pDevice)
+static bool device_alloc_bufs(struct vnt_private *priv)
 {
-	struct vnt_usb_send_context *pTxContext;
-	struct vnt_rcb *pRCB;
+	struct vnt_usb_send_context *tx_context;
+	struct vnt_rcb *rcb;
 	int ii;
 
-    for (ii = 0; ii < pDevice->cbTD; ii++) {
+	for (ii = 0; ii < priv->cbTD; ii++) {
+		tx_context = kmalloc(sizeof(struct vnt_usb_send_context),
+								GFP_KERNEL);
+		if (tx_context == NULL) {
+			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
+				"%s : allocate tx usb context failed\n",
+					priv->dev->name);
+			goto free_tx;
+		}
 
-	pTxContext = kmalloc(sizeof(struct vnt_usb_send_context), GFP_KERNEL);
-        if (pTxContext == NULL) {
-            DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s : allocate tx usb context failed\n", pDevice->dev->name);
-            goto free_tx;
-        }
-        pDevice->apTD[ii] = pTxContext;
-	pTxContext->pDevice = (void *) pDevice;
-	/* allocate URBs */
-        pTxContext->pUrb = usb_alloc_urb(0, GFP_ATOMIC);
-        if (pTxContext->pUrb == NULL) {
-            DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "alloc tx urb failed\n");
-            goto free_tx;
-        }
-        pTxContext->bBoolInUse = false;
-    }
+		priv->apTD[ii] = tx_context;
+		tx_context->pDevice = priv;
+
+		/* allocate URBs */
+		tx_context->pUrb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (tx_context->pUrb == NULL) {
+			DBG_PRT(MSG_LEVEL_ERR,
+				KERN_ERR "alloc tx urb failed\n");
+			goto free_tx;
+		}
 
-    /* allocate RCB mem */
-	pDevice->pRCBMem = kzalloc((sizeof(struct vnt_rcb) * pDevice->cbRD),
+		tx_context->bBoolInUse = false;
+	}
+
+	/* allocate RCB mem */
+	priv->pRCBMem = kzalloc((sizeof(struct vnt_rcb) * priv->cbRD),
 								GFP_KERNEL);
-    if (pDevice->pRCBMem == NULL) {
-        DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s : alloc rx usb context failed\n", pDevice->dev->name);
-        goto free_tx;
-    }
+	if (priv->pRCBMem == NULL) {
+		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
+			"%s : alloc rx usb context failed\n",
+				priv->dev->name);
+		goto free_tx;
+	}
 
-    pDevice->FirstRecvFreeList = NULL;
-    pDevice->LastRecvFreeList = NULL;
-    pDevice->FirstRecvMngList = NULL;
-    pDevice->LastRecvMngList = NULL;
-    pDevice->NumRecvFreeList = 0;
+	priv->FirstRecvFreeList = NULL;
+	priv->LastRecvFreeList = NULL;
+	priv->FirstRecvMngList = NULL;
+	priv->LastRecvMngList = NULL;
+	priv->NumRecvFreeList = 0;
 
-	pRCB = (struct vnt_rcb *)pDevice->pRCBMem;
+	rcb = (struct vnt_rcb *)priv->pRCBMem;
 
-    for (ii = 0; ii < pDevice->cbRD; ii++) {
+	for (ii = 0; ii < priv->cbRD; ii++) {
+		priv->apRCB[ii] = rcb;
+		rcb->pDevice = priv;
 
-        pDevice->apRCB[ii] = pRCB;
-	pRCB->pDevice = (void *) pDevice;
-	/* allocate URBs */
-        pRCB->pUrb = usb_alloc_urb(0, GFP_ATOMIC);
+		/* allocate URBs */
+		rcb->pUrb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (rcb->pUrb == NULL) {
+			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
+				" Failed to alloc rx urb\n");
+			goto free_rx_tx;
+		}
 
-        if (pRCB->pUrb == NULL) {
-            DBG_PRT(MSG_LEVEL_ERR,KERN_ERR" Failed to alloc rx urb\n");
-            goto free_rx_tx;
-        }
-	pRCB->skb = netdev_alloc_skb(pDevice->dev, pDevice->rx_buf_sz);
-        if (pRCB->skb == NULL) {
-            DBG_PRT(MSG_LEVEL_ERR,KERN_ERR" Failed to alloc rx skb\n");
-            goto free_rx_tx;
-        }
-        pRCB->bBoolInUse = false;
-        EnqueueRCB(pDevice->FirstRecvFreeList, pDevice->LastRecvFreeList, pRCB);
-        pDevice->NumRecvFreeList++;
-        pRCB++;
-    }
+		rcb->skb = netdev_alloc_skb(priv->dev, priv->rx_buf_sz);
+		if (rcb->skb == NULL) {
+			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
+						" Failed to alloc rx skb\n");
+			goto free_rx_tx;
+		}
+
+		rcb->bBoolInUse = false;
 
-	pDevice->pInterruptURB = usb_alloc_urb(0, GFP_ATOMIC);
-	if (pDevice->pInterruptURB == NULL) {
-	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc int urb\n");
-	    goto free_rx_tx;
+		EnqueueRCB(priv->FirstRecvFreeList,
+						priv->LastRecvFreeList, rcb);
+
+		priv->NumRecvFreeList++;
+		rcb++;
 	}
 
-    pDevice->int_buf.data_buf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
-	if (pDevice->int_buf.data_buf == NULL) {
-	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc int buf\n");
-	    usb_free_urb(pDevice->pInterruptURB);
-	    goto free_rx_tx;
+	priv->pInterruptURB = usb_alloc_urb(0, GFP_ATOMIC);
+	if (priv->pInterruptURB == NULL) {
+		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR"Failed to alloc int urb\n");
+		goto free_rx_tx;
 	}
 
-    return true;
+	priv->int_buf.data_buf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
+	if (priv->int_buf.data_buf == NULL) {
+		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR"Failed to alloc int buf\n");
+		usb_free_urb(priv->pInterruptURB);
+		goto free_rx_tx;
+	}
+
+	return true;
 
 free_rx_tx:
-    device_free_rx_bufs(pDevice);
+	device_free_rx_bufs(priv);
 
 free_tx:
-    device_free_tx_bufs(pDevice);
+	device_free_tx_bufs(priv);
 
 	return false;
 }
-- 
1.9.0

