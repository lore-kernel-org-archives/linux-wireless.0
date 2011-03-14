Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20485 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab1CNR7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 15/38] ath6kl: remove-typedef HIF_SCATTER_REQ
Date: Mon, 14 Mar 2011 10:58:49 -0700
Message-ID: <1300125552-24422-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This requird two passes:

remove-typedef -s HIF_SCATTER_REQ \
	"struct hif_scatter_req" drivers/staging/ath6kl/

remove-typedef -s _HIF_SCATTER_REQ \
	"struct hif_scatter_req" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../hif/sdio/linux_sdio/include/hif_internal.h     |    2 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   16 +++++++-------
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |   22 ++++++++++----------
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    6 ++--
 drivers/staging/ath6kl/htc2/htc_recv.c             |    4 +-
 drivers/staging/ath6kl/htc2/htc_send.c             |    4 +-
 drivers/staging/ath6kl/include/hif.h               |   15 ++++++-------
 7 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
index 99885e3..04fc284 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
@@ -99,7 +99,7 @@ void AddToAsyncList(HIF_DEVICE *device, BUS_REQUEST *busrequest);
 #define MAX_SCATTER_REQ_TRANSFER_SIZE    32*1024
 
 struct hif_scatter_req_priv {
-    HIF_SCATTER_REQ     *pHifScatterReq;  /* HIF scatter request with allocated entries */   
+    struct hif_scatter_req     *pHifScatterReq;  /* HIF scatter request with allocated entries */   
     HIF_DEVICE          *device;          /* this device */
     BUS_REQUEST         *busrequest;      /* request associated with request */
         /* scatter list for linux */    
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index 9f07040..2c64abe 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -48,7 +48,7 @@
             (((address) & 0x1FFFF) << 9)        | \
             ((bytes_blocks) & 0x1FF)
             
-static void FreeScatterReq(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
+static void FreeScatterReq(HIF_DEVICE *device, struct hif_scatter_req *pReq)
 {   
     unsigned long flag;
 
@@ -60,7 +60,7 @@ static void FreeScatterReq(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
         
 }
 
-static HIF_SCATTER_REQ *AllocScatterReq(HIF_DEVICE *device) 
+static struct hif_scatter_req *AllocScatterReq(HIF_DEVICE *device) 
 {
     struct dl_list       *pItem; 
     unsigned long flag;
@@ -72,7 +72,7 @@ static HIF_SCATTER_REQ *AllocScatterReq(HIF_DEVICE *device)
     spin_unlock_irqrestore(&device->lock, flag);
     
     if (pItem != NULL) {
-        return A_CONTAINING_STRUCT(pItem, HIF_SCATTER_REQ, ListLink);
+        return A_CONTAINING_STRUCT(pItem, struct hif_scatter_req, ListLink);
     }
     
     return NULL;   
@@ -88,7 +88,7 @@ int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
     struct mmc_command      cmd;
     struct mmc_data         data;
     struct hif_scatter_req_priv   *pReqPriv;   
-    HIF_SCATTER_REQ        *pReq;       
+    struct hif_scatter_req        *pReq;       
     int                status = 0;
     struct                  scatterlist *pSg;
     
@@ -199,7 +199,7 @@ int DoHifReadWriteScatter(HIF_DEVICE *device, BUS_REQUEST *busrequest)
 }
 
     /* callback to issue a read-write scatter request */
-static int HifReadWriteScatter(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
+static int HifReadWriteScatter(HIF_DEVICE *device, struct hif_scatter_req *pReq)
 {
     int             status = A_EINVAL;
     u32 request = pReq->Request;
@@ -305,7 +305,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
                 /* save the device instance*/
             pReqPriv->device = device;      
                 /* allocate the scatter request */
-            pReqPriv->pHifScatterReq = (HIF_SCATTER_REQ *)A_MALLOC(sizeof(HIF_SCATTER_REQ) + 
+            pReqPriv->pHifScatterReq = (struct hif_scatter_req *)A_MALLOC(sizeof(struct hif_scatter_req) + 
                                          (MAX_SCATTER_ENTRIES_PER_REQ - 1) * (sizeof(struct hif_scatter_item))); 
            
             if (NULL == pReqPriv->pHifScatterReq) {
@@ -313,7 +313,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
                 break;      
             }           
                 /* just zero the main part of the scatter request */
-            A_MEMZERO(pReqPriv->pHifScatterReq, sizeof(HIF_SCATTER_REQ));
+            A_MEMZERO(pReqPriv->pHifScatterReq, sizeof(struct hif_scatter_req));
                 /* back pointer to the private struct */
             pReqPriv->pHifScatterReq->HIFPrivate[0] = pReqPriv;
                 /* allocate a bus request for this scatter request */
@@ -359,7 +359,7 @@ int SetupHIFScatterSupport(HIF_DEVICE *device, struct hif_device_scatter_support
 void CleanupHIFScatterResources(HIF_DEVICE *device)
 {
     struct hif_scatter_req_priv    *pReqPriv;
-    HIF_SCATTER_REQ         *pReq;
+    struct hif_scatter_req         *pReq;
     
         /* empty the free list */
         
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 3ebf630..c780e4f 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -587,7 +587,7 @@ void DevDumpRegisters(struct ar6k_device               *pDev,
 
 #define DEV_GET_VIRT_DMA_INFO(p)  ((struct dev_scatter_dma_virtual_info *)((p)->HIFPrivate[0]))
 
-static HIF_SCATTER_REQ *DevAllocScatterReq(HIF_DEVICE *Context)
+static struct hif_scatter_req *DevAllocScatterReq(HIF_DEVICE *Context)
 {
     struct dl_list *pItem;
     struct ar6k_device *pDev = (struct ar6k_device *)Context;
@@ -595,12 +595,12 @@ static HIF_SCATTER_REQ *DevAllocScatterReq(HIF_DEVICE *Context)
     pItem = DL_ListRemoveItemFromHead(&pDev->ScatterReqHead);
     UNLOCK_AR6K(pDev);
     if (pItem != NULL) {
-        return A_CONTAINING_STRUCT(pItem, HIF_SCATTER_REQ, ListLink);
+        return A_CONTAINING_STRUCT(pItem, struct hif_scatter_req, ListLink);
     }
     return NULL;
 }
 
-static void DevFreeScatterReq(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
+static void DevFreeScatterReq(HIF_DEVICE *Context, struct hif_scatter_req *pReq)
 {
     struct ar6k_device *pDev = (struct ar6k_device *)Context;
     LOCK_AR6K(pDev);
@@ -608,7 +608,7 @@ static void DevFreeScatterReq(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
     UNLOCK_AR6K(pDev);
 }
 
-int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, bool FromDMA)
+int DevCopyScatterListToFromDMABuffer(struct hif_scatter_req *pReq, bool FromDMA)
 {
     u8 *pDMABuffer = NULL;
     int             i, remaining;
@@ -651,7 +651,7 @@ int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, bool FromDMA)
 static void DevReadWriteScatterAsyncHandler(void *Context, HTC_PACKET *pPacket)
 {
     struct ar6k_device     *pDev = (struct ar6k_device *)Context;
-    HIF_SCATTER_REQ *pReq = (HIF_SCATTER_REQ *)pPacket->pPktContext;
+    struct hif_scatter_req *pReq = (struct hif_scatter_req *)pPacket->pPktContext;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("+DevReadWriteScatterAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
     
@@ -664,7 +664,7 @@ static void DevReadWriteScatterAsyncHandler(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("-DevReadWriteScatterAsyncHandler \n"));
 }
 
-static int DevReadWriteScatter(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
+static int DevReadWriteScatter(HIF_DEVICE *Context, struct hif_scatter_req *pReq)
 {
     struct ar6k_device     *pDev = (struct ar6k_device *)Context;
     int        status = 0;
@@ -736,7 +736,7 @@ static int DevReadWriteScatter(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
 
 static void DevCleanupVirtualScatterSupport(struct ar6k_device *pDev)
 {
-    HIF_SCATTER_REQ *pReq;
+    struct hif_scatter_req *pReq;
 
     while (1) {
         pReq = DevAllocScatterReq((HIF_DEVICE *)pDev);
@@ -755,17 +755,17 @@ static int DevSetupVirtualScatterSupport(struct ar6k_device *pDev)
     int                          bufferSize, sgreqSize;
     int                          i;
     struct dev_scatter_dma_virtual_info *pVirtualInfo;
-    HIF_SCATTER_REQ              *pReq;
+    struct hif_scatter_req              *pReq;
 
     bufferSize = sizeof(struct dev_scatter_dma_virtual_info) +
                 2 * (A_GET_CACHE_LINE_BYTES()) + AR6K_MAX_TRANSFER_SIZE_PER_SCATTER;
 
-    sgreqSize = sizeof(HIF_SCATTER_REQ) +
+    sgreqSize = sizeof(struct hif_scatter_req) +
                     (AR6K_SCATTER_ENTRIES_PER_REQ - 1) * (sizeof(struct hif_scatter_item));
 
     for (i = 0; i < AR6K_SCATTER_REQS; i++) {
             /* allocate the scatter request, buffer info and the actual virtual buffer itself */
-        pReq = (HIF_SCATTER_REQ *)A_MALLOC(sgreqSize + bufferSize);
+        pReq = (struct hif_scatter_req *)A_MALLOC(sgreqSize + bufferSize);
 
         if (NULL == pReq) {
             status = A_NO_MEMORY;
@@ -885,7 +885,7 @@ int DevSetupMsgBundling(struct ar6k_device *pDev, int MaxMsgsPerTransfer)
     return status;
 }
 
-int DevSubmitScatterRequest(struct ar6k_device *pDev, HIF_SCATTER_REQ *pScatterReq, bool Read, bool Async)
+int DevSubmitScatterRequest(struct ar6k_device *pDev, struct hif_scatter_req *pScatterReq, bool Read, bool Async)
 {
     int status;
 
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 08e9ef2..baad0bf 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -272,7 +272,7 @@ static INLINE int DevRecvPacket(struct ar6k_device *pDev, HTC_PACKET *pPacket, u
  *  
  */
   
-int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, bool FromDMA);
+int DevCopyScatterListToFromDMABuffer(struct hif_scatter_req *pReq, bool FromDMA);
     
     /* copy any READ data back into scatter list */        
 #define DEV_FINISH_SCATTER_OPERATION(pR)				\
@@ -287,7 +287,7 @@ do {									\
 } while (0)
     
     /* copy any WRITE data to bounce buffer */
-static INLINE int DEV_PREPARE_SCATTER_OPERATION(HIF_SCATTER_REQ *pReq)  {
+static INLINE int DEV_PREPARE_SCATTER_OPERATION(struct hif_scatter_req *pReq)  {
     if ((pReq->Request & HIF_WRITE) && (pReq->ScatterMethod == HIF_SCATTER_DMA_BOUNCE)) {
         return DevCopyScatterListToFromDMABuffer(pReq,TO_DMA_BUFFER);    
     } else {
@@ -315,7 +315,7 @@ int DevCleanupMsgBundling(struct ar6k_device *pDev);
 #define DEV_SCATTER_WRITE false
 #define DEV_SCATTER_ASYNC true
 #define DEV_SCATTER_SYNC  false
-int DevSubmitScatterRequest(struct ar6k_device *pDev, HIF_SCATTER_REQ *pScatterReq, bool Read, bool Async);
+int DevSubmitScatterRequest(struct ar6k_device *pDev, struct hif_scatter_req *pScatterReq, bool Read, bool Async);
 
 #ifdef MBOXHW_UNIT_TEST
 int DoMboxHWTest(struct ar6k_device *pDev);
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index daa6efc..7a333ed 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -879,7 +879,7 @@ static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
     return status; 
 }
 
-static void HTCAsyncRecvScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
+static void HTCAsyncRecvScatterCompletion(struct hif_scatter_req *pScatterReq)
 {
     int                 i;    
     HTC_PACKET          *pPacket;
@@ -991,7 +991,7 @@ static int HTCIssueRecvPacketBundle(HTC_TARGET        *target,
                                          bool             PartialBundle)
 {
     int        status = 0;
-    HIF_SCATTER_REQ *pScatterReq;
+    struct hif_scatter_req *pScatterReq;
     int             i, totalLength;
     int             pktsToScatter;
     HTC_PACKET      *pPacket;
diff --git a/drivers/staging/ath6kl/htc2/htc_send.c b/drivers/staging/ath6kl/htc2/htc_send.c
index a31acae..f133d93 100644
--- a/drivers/staging/ath6kl/htc2/htc_send.c
+++ b/drivers/staging/ath6kl/htc2/htc_send.c
@@ -264,7 +264,7 @@ static INLINE void GetHTCSendPackets(HTC_TARGET        *target,
      
 }
 
-static void HTCAsyncSendScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
+static void HTCAsyncSendScatterCompletion(struct hif_scatter_req *pScatterReq)
 {
     int                 i;    
     HTC_PACKET          *pPacket;
@@ -316,7 +316,7 @@ static void HTCIssueSendBundle(HTC_ENDPOINT      *pEndpoint,
 {
     int                 pktsToScatter;
     unsigned int        scatterSpaceRemaining;
-    HIF_SCATTER_REQ     *pScatterReq = NULL;
+    struct hif_scatter_req     *pScatterReq = NULL;
     int                 i, packetsInScatterReq;
     unsigned int        transferLength;
     HTC_PACKET          *pPacket;
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 427e7b8..3dcb787 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -276,9 +276,8 @@ struct hif_scatter_item {
     void        *pCallerContexts[2];  /* space for caller to insert a context associated with this item */
 };
 
-struct _HIF_SCATTER_REQ;
-
-typedef void ( *HIF_SCATTER_COMP_CB)(struct _HIF_SCATTER_REQ *);
+struct hif_scatter_req;
+typedef void ( *HIF_SCATTER_COMP_CB)(struct hif_scatter_req *);
 
 typedef enum _HIF_SCATTER_METHOD {
     HIF_SCATTER_NONE = 0,
@@ -286,7 +285,7 @@ typedef enum _HIF_SCATTER_METHOD {
     HIF_SCATTER_DMA_BOUNCE,            /* Uses SG DMA but HIF layer uses an internal bounce buffer */    
 } HIF_SCATTER_METHOD;
 
-typedef struct _HIF_SCATTER_REQ {
+struct hif_scatter_req {
     struct dl_list             ListLink;           /* link management */
     u32 Address;            /* address for the read/write operation */
     u32 Request;            /* request flags */
@@ -300,11 +299,11 @@ typedef struct _HIF_SCATTER_REQ {
     void                *HIFPrivate[4];     /* HIF private area */
     u8 *pScatterBounceBuffer;  /* bounce buffer for upper layers to copy to/from */
     struct hif_scatter_item    ScatterList[1];     /* start of scatter list */
-} HIF_SCATTER_REQ;
+};
 
-typedef HIF_SCATTER_REQ * ( *HIF_ALLOCATE_SCATTER_REQUEST)(HIF_DEVICE *device);
-typedef void ( *HIF_FREE_SCATTER_REQUEST)(HIF_DEVICE *device, HIF_SCATTER_REQ *request);
-typedef int ( *HIF_READWRITE_SCATTER)(HIF_DEVICE *device, HIF_SCATTER_REQ *request);
+typedef struct hif_scatter_req * ( *HIF_ALLOCATE_SCATTER_REQUEST)(HIF_DEVICE *device);
+typedef void ( *HIF_FREE_SCATTER_REQUEST)(HIF_DEVICE *device, struct hif_scatter_req *request);
+typedef int ( *HIF_READWRITE_SCATTER)(HIF_DEVICE *device, struct hif_scatter_req *request);
 
 struct hif_device_scatter_support_info {
         /* information returned from HIF layer */
-- 
1.7.4.15.g7811d

