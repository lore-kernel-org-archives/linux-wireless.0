Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39912 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab3GWWHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 18:07:09 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so2209719wgh.5
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 15:07:07 -0700 (PDT)
Message-ID: <1374617222.2750.7.camel@canaries64> (sfid-20130724_000714_228812_9F60AD0B)
Subject: [PATCH 1/2] staging: vt6656: Remove dead code macro ASSERT
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Jul 2013 23:07:02 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ASSERT is always defined as empty macro
because VIAWET_DEBUG is never defined.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c   | 1 -
 drivers/staging/vt6656/device_cfg.h | 8 --------
 drivers/staging/vt6656/dpc.c        | 6 ------
 drivers/staging/vt6656/main_usb.c   | 1 -
 drivers/staging/vt6656/rxtx.c       | 3 ---
 drivers/staging/vt6656/usbpipe.c    | 1 -
 6 files changed, 20 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 33fa767..a14a6a0 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -680,7 +680,6 @@ BBuGetFrameTime(
     unsigned int uRate = 0;
 
     if (uRateIdx > RATE_54M) {
-        ASSERT(0);
         return 0;
     }
 
diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/device_cfg.h
index ea66b97..ad1fbf6 100644
--- a/drivers/staging/vt6656/device_cfg.h
+++ b/drivers/staging/vt6656/device_cfg.h
@@ -83,16 +83,8 @@ typedef enum  _chip_type {
 } CHIP_TYPE, *PCHIP_TYPE;
 
 #ifdef VIAWET_DEBUG
-#define ASSERT(x) { \
-    if (!(x)) { \
-	printk(KERN_ERR "assertion %s failed: file %s line %d\n", #x, \
-        __FUNCTION__, __LINE__);\
-	*(int *) 0 = 0;		\
-    } \
-}
 #define DBG_PORT80(value)                   outb(value, 0x80)
 #else
-#define ASSERT(x)
 #define DBG_PORT80(value)
 #endif
 
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 7ec166a..4bc362f 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -314,7 +314,6 @@ int RXbBulkInProcessData(struct vnt_private *pDevice, PRCB pRCB,
          (BytesToIndicate < (*pwPLCP_Length)) ) {
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Wrong PLCP Length %x\n", (int) *pwPLCP_Length);
-        ASSERT(0);
         return false;
     }
     for ( ii=RATE_1M;ii<MAX_RATE;ii++) {
@@ -1347,7 +1346,6 @@ void RXvWorkItem(struct vnt_private *pDevice)
             (pDevice->NumRecvFreeList != 0) ) {
         pRCB = pDevice->FirstRecvFreeList;
         pDevice->NumRecvFreeList--;
-        ASSERT(pRCB);// cannot be NULL
         DequeueRCB(pDevice->FirstRecvFreeList, pDevice->LastRecvFreeList);
         ntStatus = PIPEnsBulkInUsbRead(pDevice, pRCB);
     }
@@ -1362,9 +1360,6 @@ void RXvFreeRCB(PRCB pRCB, int bReAllocSkb)
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->RXvFreeRCB\n");
 
-    ASSERT(!pRCB->Ref);     // should be 0
-    ASSERT(pRCB->pDevice);  // shouldn't be NULL
-
 	if (bReAllocSkb == false) {
 		kfree_skb(pRCB->skb);
 		bReAllocSkb = true;
@@ -1411,7 +1406,6 @@ void RXvMngWorkItem(struct vnt_private *pDevice)
         if(!pRCB){
             break;
         }
-        ASSERT(pRCB);// cannot be NULL
         pRxPacket = &(pRCB->sMngPacket);
 	vMgrRxManagePacket(pDevice, &pDevice->vnt_mgmt, pRxPacket);
         pRCB->Ref--;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3a3fdc5..0c9e60f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -925,7 +925,6 @@ int device_alloc_frag_buf(struct vnt_private *pDevice,
     pDeF->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
     if (pDeF->skb == NULL)
         return false;
-    ASSERT(pDeF->skb);
     pDeF->skb->dev = pDevice->dev;
 
     return true;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1879b39..6e5e2b7 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -545,7 +545,6 @@ static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
         break;
     }
 
-	ASSERT(false);
 	return 0;
 }
 
@@ -1482,8 +1481,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         memcpy((pbyPayloadHead + cb802_1_H_len), ((u8 *)psEthHeader) + ETH_HLEN, uSkbPacketLen - ETH_HLEN);
     }
 
-    ASSERT(uLength == cbNdisBodySize);
-
     if ((bNeedEncryption == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
 
         ///////////////////////////////////////////////////////////////////
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index a9d50ba..8cd5685 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -638,7 +638,6 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
     // The context given to IoSetCompletionRoutine is an USB_CONTEXT struct
     //
     pContext = (PUSB_SEND_CONTEXT) urb->context;
-    ASSERT( NULL != pContext );
 
     pDevice = pContext->pDevice;
     ContextType = pContext->Type;
-- 
1.8.1.2




