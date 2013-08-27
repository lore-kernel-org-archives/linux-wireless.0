Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49682 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3H0Ll5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 07:41:57 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so1600118bkb.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 04:41:56 -0700 (PDT)
Message-ID: <1377603710.3320.91.camel@canaries32-MCP7A> (sfid-20130827_134201_327889_8EEBA893)
Subject: [PATCH 1/2] staging: vt6656: device.h replace typedef struct
 _USB_SEND_CONTEXT.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 12:41:50 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_usb_send_context.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 24 ++++++++++++------------
 drivers/staging/vt6656/main_usb.c |  7 +++----
 drivers/staging/vt6656/rxtx.c     | 24 ++++++++++++------------
 drivers/staging/vt6656/usbpipe.c  |  7 ++++---
 drivers/staging/vt6656/usbpipe.h  |  3 ++-
 5 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index e8f4b19..3151c8f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -179,17 +179,17 @@ typedef struct _RCB
 } RCB, *PRCB;
 
 /* used to track bulk out irps */
-typedef struct _USB_SEND_CONTEXT {
-    void *pDevice;
-    struct sk_buff *pPacket;
-    struct urb      *pUrb;
-    unsigned int            uBufLen;
-    CONTEXT_TYPE    Type;
-    struct ethhdr sEthHeader;
-    void *Next;
-    bool            bBoolInUse;
-    unsigned char           Data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
-} USB_SEND_CONTEXT, *PUSB_SEND_CONTEXT;
+struct vnt_usb_send_context {
+	void *pDevice;
+	struct sk_buff *pPacket;
+	struct urb *pUrb;
+	unsigned int uBufLen;
+	CONTEXT_TYPE Type;
+	struct ethhdr sEthHeader;
+	void *Next;
+	bool bBoolInUse;
+	unsigned char Data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
+};
 
 /* structure got from configuration file as user-desired default settings */
 typedef struct _DEFAULT_CONFIG {
@@ -430,7 +430,7 @@ struct vnt_private {
 	unsigned long ulRcvRefCount; /* packets that have not returned back */
 
 	/* Variables to track resources for the BULK Out Pipe */
-	PUSB_SEND_CONTEXT apTD[CB_MAX_TX_DESC];
+	struct vnt_usb_send_context *apTD[CB_MAX_TX_DESC];
 	u32 cbTD;
 
 	/* Variables to track resources for the Interrupt In Pipe */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3bc5834..37d66a3 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -733,7 +733,7 @@ err_nomem:
 
 static void device_free_tx_bufs(struct vnt_private *pDevice)
 {
-    PUSB_SEND_CONTEXT pTxContext;
+	struct vnt_usb_send_context *pTxContext;
     int ii;
 
     for (ii = 0; ii < pDevice->cbTD; ii++) {
@@ -788,14 +788,13 @@ static void device_free_int_bufs(struct vnt_private *pDevice)
 
 static bool device_alloc_bufs(struct vnt_private *pDevice)
 {
-
-    PUSB_SEND_CONTEXT pTxContext;
+	struct vnt_usb_send_context *pTxContext;
     PRCB pRCB;
     int ii;
 
     for (ii = 0; ii < pDevice->cbTD; ii++) {
 
-        pTxContext = kmalloc(sizeof(USB_SEND_CONTEXT), GFP_KERNEL);
+	pTxContext = kmalloc(sizeof(struct vnt_usb_send_context), GFP_KERNEL);
         if (pTxContext == NULL) {
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s : allocate tx usb context failed\n", pDevice->dev->name);
             goto free_tx;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 411189d..08ce64e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -141,8 +141,8 @@ static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
 
 static void *s_vGetFreeContext(struct vnt_private *pDevice)
 {
-	PUSB_SEND_CONTEXT pContext = NULL;
-	PUSB_SEND_CONTEXT pReturnContext = NULL;
+	struct vnt_usb_send_context *pContext = NULL;
+	struct vnt_usb_send_context *pReturnContext = NULL;
 	int ii;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GetFreeContext()\n");
@@ -1467,7 +1467,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct vnt_tx_buffer *pTX_Buffer;
 	PSTxBufHead pTxBufHead;
-	PUSB_SEND_CONTEXT pContext;
+	struct vnt_usb_send_context *pContext;
 	struct ieee80211_hdr *pMACHeader;
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
@@ -1481,7 +1481,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	u32 cbMacHdLen;
 	u16 wCurrentRate = RATE_1M;
 
-    pContext = (PUSB_SEND_CONTEXT)s_vGetFreeContext(pDevice);
+	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
 
     if (NULL == pContext) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ManagementSend TX...NO CONTEXT!\n");
@@ -1748,10 +1748,10 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	u32 cbFrameBodySize;
 	u32 cbReqCount;
 	u8 *pbyTxBufferAddr;
-	PUSB_SEND_CONTEXT pContext;
+	struct vnt_usb_send_context *pContext;
 	CMD_STATUS status;
 
-    pContext = (PUSB_SEND_CONTEXT)s_vGetFreeContext(pDevice);
+	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
     if (NULL == pContext) {
         status = CMD_STATUS_RESOURCES;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ManagementSend TX...NO CONTEXT!\n");
@@ -1850,7 +1850,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	PSKeyItem pTransmitKey = NULL;
 	u8 *pbyIVHead, *pbyPayloadHead, *pbyMacHdr;
 	u32 cbExtSuppRate = 0;
-	PUSB_SEND_CONTEXT pContext;
+	struct vnt_usb_send_context *pContext;
 
 	pvRrvTime = pMICHDR = pvTxDataHd = NULL;
 
@@ -1862,7 +1862,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     }
     p80211Header = (PUWLAN_80211HDR)skb->data;
 
-    pContext = (PUSB_SEND_CONTEXT)s_vGetFreeContext(pDevice);
+	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
 
     if (NULL == pContext) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0 TX...NO CONTEXT!\n");
@@ -2224,7 +2224,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
 	int bNeedDeAuth = false;
 	u8 *pbyBSSID;
 	int bNodeExist = false;
-	PUSB_SEND_CONTEXT pContext;
+	struct vnt_usb_send_context *pContext;
 	bool fConvertedPacket;
 	u32 status;
 	u16 wKeepRate = pDevice->wCurrentRate;
@@ -2295,7 +2295,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
         }
     }
 
-    pContext = (PUSB_SEND_CONTEXT)s_vGetFreeContext(pDevice);
+	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
 
     if (pContext == NULL) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG" pContext == NULL\n");
@@ -2611,13 +2611,13 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
 	SKeyItem STempKey;
 	PSKeyItem pTransmitKey = NULL;
 	u8 *pbyBSSID;
-	PUSB_SEND_CONTEXT pContext;
+	struct vnt_usb_send_context *pContext;
 	u8 byPktTyp;
 	int fConvertedPacket;
 	u32 status;
 	u16 wKeepRate = pDevice->wCurrentRate;
 
-    pContext = (PUSB_SEND_CONTEXT)s_vGetFreeContext(pDevice);
+	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
 
     if (NULL == pContext) {
         return false;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 9b9122d..78749ef 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -546,7 +546,8 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
  *
  */
 
-int PIPEnsSendBulkOut(struct vnt_private *pDevice, PUSB_SEND_CONTEXT pContext)
+int PIPEnsSendBulkOut(struct vnt_private *pDevice,
+				struct vnt_usb_send_context *pContext)
 {
 	int status;
 	struct urb          *pUrb;
@@ -628,13 +629,13 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	int status;
 	CONTEXT_TYPE ContextType;
 	unsigned long ulBufLen;
-	PUSB_SEND_CONTEXT pContext;
+	struct vnt_usb_send_context *pContext;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
     //
     // The context given to IoSetCompletionRoutine is an USB_CONTEXT struct
     //
-    pContext = (PUSB_SEND_CONTEXT) urb->context;
+	pContext = (struct vnt_usb_send_context *)urb->context;
 
     pDevice = pContext->pDevice;
     ContextType = pContext->Type;
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index bb7a611..e2a2bce 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -41,6 +41,7 @@ int PIPEnsControlIn(struct vnt_private *, u8 byRequest, u16 wValue,
 
 int PIPEnsInterruptRead(struct vnt_private *);
 int PIPEnsBulkInUsbRead(struct vnt_private *, PRCB pRCB);
-int PIPEnsSendBulkOut(struct vnt_private *, PUSB_SEND_CONTEXT pContext);
+int PIPEnsSendBulkOut(struct vnt_private *,
+				struct vnt_usb_send_context *pContext);
 
 #endif /* __USBPIPE_H__ */
-- 
1.8.1.2

