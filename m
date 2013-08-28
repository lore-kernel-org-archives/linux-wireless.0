Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35291 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3H1UMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 16:12:45 -0400
Received: by mail-wg0-f48.google.com with SMTP id y10so2144164wgg.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 13:12:44 -0700 (PDT)
Message-ID: <1377720755.8439.3.camel@canaries32-MCP7A> (sfid-20130828_221249_476826_0A7F4A55)
Subject: [PATCH v2 rebased] staging: vt6656: device.h Replace typedef struct
 _RCB
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Aug 2013 21:12:35 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_rcb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 20 +++++++++-----------
 drivers/staging/vt6656/dpc.c      | 10 +++++-----
 drivers/staging/vt6656/dpc.h      |  4 ++--
 drivers/staging/vt6656/main_usb.c | 14 ++++++++------
 drivers/staging/vt6656/usbpipe.c  |  4 ++--
 drivers/staging/vt6656/usbpipe.h  |  2 +-
 6 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 3151c8f..8e39634 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -166,8 +166,7 @@ typedef enum _CONTEXT_TYPE {
 } CONTEXT_TYPE;
 
 /* RCB (Receive Control Block) */
-typedef struct _RCB
-{
+struct vnt_rcb {
 	void *Next;
 	signed long Ref;
 	void *pDevice;
@@ -175,8 +174,7 @@ typedef struct _RCB
 	struct vnt_rx_mgmt sMngPacket;
 	struct sk_buff *skb;
 	int bBoolInUse;
-
-} RCB, *PRCB;
+};
 
 /* used to track bulk out irps */
 struct vnt_usb_send_context {
@@ -416,14 +414,14 @@ struct vnt_private {
 	u32 int_interval;
 
 	/* Variables to track resources for the BULK In Pipe */
-	PRCB pRCBMem;
-	PRCB apRCB[CB_MAX_RX_DESC];
+	struct vnt_rcb *pRCBMem;
+	struct vnt_rcb *apRCB[CB_MAX_RX_DESC];
 	u32 cbRD;
-	PRCB FirstRecvFreeList;
-	PRCB LastRecvFreeList;
+	struct vnt_rcb *FirstRecvFreeList;
+	struct vnt_rcb *LastRecvFreeList;
 	u32 NumRecvFreeList;
-	PRCB FirstRecvMngList;
-	PRCB LastRecvMngList;
+	struct vnt_rcb *FirstRecvMngList;
+	struct vnt_rcb *LastRecvMngList;
 	u32 NumRecvMngList;
 	int bIsRxWorkItemQueued;
 	int bIsRxMngWorkItemQueued;
@@ -774,7 +772,7 @@ struct vnt_private {
 
 #define DequeueRCB(Head, Tail)                          \
 {                                                       \
-    PRCB   RCB = Head;                                  \
+    struct vnt_rcb *RCB = Head;                         \
     if (!RCB->Next) {                                   \
         Tail = NULL;                                    \
     }                                                   \
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 4bc362f..ea7d443 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -246,7 +246,7 @@ s_vGetDASA (
     *pcbHeaderSize = cbHeaderSize;
 }
 
-int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
+int RXbBulkInProcessData(struct vnt_private *pDevice, struct vnt_rcb *pRCB,
 	unsigned long BytesToIndicate)
 {
 	struct net_device_stats *pStats = &pDevice->stats;
@@ -271,7 +271,7 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
 	/* signed long ldBm = 0; */
 	int bIsWEP = false; int bExtIV = false;
 	u32 dwWbkStatus;
-	PRCB pRCBIndicate = pRCB;
+	struct vnt_rcb *pRCBIndicate = pRCB;
 	u8 *pbyDAddress;
 	u16 *pwPLCP_Length;
 	u8 abyVaildRate[MAX_RATE]
@@ -1336,7 +1336,7 @@ static int s_bAPModeRxData(struct vnt_private *pDevice, struct sk_buff *skb,
 void RXvWorkItem(struct vnt_private *pDevice)
 {
 	int ntStatus;
-	PRCB pRCB = NULL;
+	struct vnt_rcb *pRCB = NULL;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Polling Thread\n");
     spin_lock_irq(&pDevice->lock);
@@ -1354,7 +1354,7 @@ void RXvWorkItem(struct vnt_private *pDevice)
 
 }
 
-void RXvFreeRCB(PRCB pRCB, int bReAllocSkb)
+void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb)
 {
 	struct vnt_private *pDevice = pRCB->pDevice;
 
@@ -1391,7 +1391,7 @@ void RXvFreeRCB(PRCB pRCB, int bReAllocSkb)
 
 void RXvMngWorkItem(struct vnt_private *pDevice)
 {
-	PRCB pRCB = NULL;
+	struct vnt_rcb *pRCB = NULL;
 	struct vnt_rx_mgmt *pRxPacket;
 	int bReAllocSkb = false;
 
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index 876468f..95388dc 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -36,9 +36,9 @@ void RXvWorkItem(void *Context);
 
 void RXvMngWorkItem(void *Context);
 
-void RXvFreeRCB(PRCB pRCB, int bReAllocSkb);
+void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb);
 
-int RXbBulkInProcessData(struct vnt_private *, PRCB pRCB,
+int RXbBulkInProcessData(struct vnt_private *, struct vnt_rcb *pRCB,
 	unsigned long BytesToIndicate);
 
 #endif /* __RXTX_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 37d66a3..5369717 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -751,8 +751,8 @@ static void device_free_tx_bufs(struct vnt_private *pDevice)
 
 static void device_free_rx_bufs(struct vnt_private *pDevice)
 {
-    PRCB pRCB;
-    int ii;
+	struct vnt_rcb *pRCB;
+	int ii;
 
     for (ii = 0; ii < pDevice->cbRD; ii++) {
 
@@ -789,8 +789,8 @@ static void device_free_int_bufs(struct vnt_private *pDevice)
 static bool device_alloc_bufs(struct vnt_private *pDevice)
 {
 	struct vnt_usb_send_context *pTxContext;
-    PRCB pRCB;
-    int ii;
+	struct vnt_rcb *pRCB;
+	int ii;
 
     for (ii = 0; ii < pDevice->cbTD; ii++) {
 
@@ -811,7 +811,8 @@ static bool device_alloc_bufs(struct vnt_private *pDevice)
     }
 
     /* allocate RCB mem */
-	pDevice->pRCBMem = kzalloc((sizeof(RCB) * pDevice->cbRD), GFP_KERNEL);
+	pDevice->pRCBMem = kzalloc((sizeof(struct vnt_rcb) * pDevice->cbRD),
+								GFP_KERNEL);
     if (pDevice->pRCBMem == NULL) {
         DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s : alloc rx usb context failed\n", pDevice->dev->name);
         goto free_tx;
@@ -822,7 +823,8 @@ static bool device_alloc_bufs(struct vnt_private *pDevice)
     pDevice->FirstRecvMngList = NULL;
     pDevice->LastRecvMngList = NULL;
     pDevice->NumRecvFreeList = 0;
-    pRCB = (PRCB) pDevice->pRCBMem;
+
+	pRCB = (struct vnt_rcb *)pDevice->pRCBMem;
 
     for (ii = 0; ii < pDevice->cbRD; ii++) {
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 78749ef..3a03f1d 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -421,7 +421,7 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
  *
  */
 
-int PIPEnsBulkInUsbRead(struct vnt_private *pDevice, PRCB pRCB)
+int PIPEnsBulkInUsbRead(struct vnt_private *pDevice, struct vnt_rcb *pRCB)
 {
 	int ntStatus = 0;
 	struct urb *pUrb;
@@ -479,7 +479,7 @@ int PIPEnsBulkInUsbRead(struct vnt_private *pDevice, PRCB pRCB)
 
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 {
-	PRCB pRCB = (PRCB)urb->context;
+	struct vnt_rcb *pRCB = (struct vnt_rcb *)urb->context;
 	struct vnt_private *pDevice = pRCB->pDevice;
 	unsigned long   bytesRead;
 	int bIndicateReceive = false;
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index e2a2bce..f537703 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -40,7 +40,7 @@ int PIPEnsControlIn(struct vnt_private *, u8 byRequest, u16 wValue,
 	u16 wIndex, u16 wLength,  u8 *pbyBuffer);
 
 int PIPEnsInterruptRead(struct vnt_private *);
-int PIPEnsBulkInUsbRead(struct vnt_private *, PRCB pRCB);
+int PIPEnsBulkInUsbRead(struct vnt_private *, struct vnt_rcb *pRCB);
 int PIPEnsSendBulkOut(struct vnt_private *,
 				struct vnt_usb_send_context *pContext);
 
-- 
1.8.1.2

