Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:44306 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaB1X7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 18:59:53 -0500
Received: by mail-we0-f175.google.com with SMTP id q59so1106323wes.6
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 15:59:52 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/9] staging: vt6656: Replace dev_alloc_skb with netdev_alloc_skb.
Date: Fri, 28 Feb 2014 23:58:33 +0000
Message-Id: <1393631919-16182-3-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010009_414297_C839C955)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove code that points to netdev (pDevice/priv->dev)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c      |  9 +++------
 drivers/staging/vt6656/main_usb.c | 13 +++++--------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 18ad3e6..4ccaa7e 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1227,14 +1227,13 @@ static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
     if (is_multicast_ether_addr((u8 *)(skb->data+cbHeaderOffset))) {
        if (pMgmt->sNodeDBTable[0].bPSEnable) {
 
-           skbcpy = dev_alloc_skb((int)pDevice->rx_buf_sz);
+	    skbcpy = netdev_alloc_skb(pDevice->dev, pDevice->rx_buf_sz);
 
         // if any node in PS mode, buffer packet until DTIM.
            if (skbcpy == NULL) {
                DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "relay multicast no skb available \n");
            }
            else {
-               skbcpy->dev = pDevice->dev;
                skbcpy->len = FrameSize;
                memcpy(skbcpy->data, skb->data+cbHeaderOffset, FrameSize);
                skb_queue_tail(&(pMgmt->sNodeDBTable[0].sTxPSQueue), skbcpy);
@@ -1335,13 +1334,11 @@ void RXvFreeRCB(struct vnt_rcb *rcb, int re_alloc_skb)
 	}
 
 	if (re_alloc_skb == true) {
-		rcb->skb = dev_alloc_skb((int)priv->rx_buf_sz);
+		rcb->skb = netdev_alloc_skb(priv->dev, priv->rx_buf_sz);
 		/* TODO error handling */
-		if (rcb->skb == NULL) {
+		if (!rcb->skb) {
 			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
 				" Failed to re-alloc rx skb\n");
-		} else {
-			rcb->skb->dev = priv->dev;
 		}
 	}
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e1d90c5..bb1b4e9 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -855,12 +855,11 @@ static bool device_alloc_bufs(struct vnt_private *pDevice)
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR" Failed to alloc rx urb\n");
             goto free_rx_tx;
         }
-        pRCB->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
+	pRCB->skb = netdev_alloc_skb(pDevice->dev, pDevice->rx_buf_sz);
         if (pRCB->skb == NULL) {
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR" Failed to alloc rx skb\n");
             goto free_rx_tx;
         }
-        pRCB->skb->dev = pDevice->dev;
         pRCB->bBoolInUse = false;
         EnqueueRCB(pDevice->FirstRecvFreeList, pDevice->LastRecvFreeList, pRCB);
         pDevice->NumRecvFreeList++;
@@ -931,13 +930,11 @@ static void device_free_frag_bufs(struct vnt_private *pDevice)
 int device_alloc_frag_buf(struct vnt_private *pDevice,
 		PSDeFragControlBlock pDeF)
 {
+	pDeF->skb = netdev_alloc_skb(pDevice->dev, pDevice->rx_buf_sz);
+	if (!pDeF->skb)
+		return false;
 
-    pDeF->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-    if (pDeF->skb == NULL)
-        return false;
-    pDeF->skb->dev = pDevice->dev;
-
-    return true;
+	return true;
 }
 
 static int  device_open(struct net_device *dev)
-- 
1.9.0

