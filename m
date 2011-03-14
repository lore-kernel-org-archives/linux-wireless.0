Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20454 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982Ab1CNR7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:58:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/38] ath6kl: remove-tyepdef DL_LIST and PDL_LIST pointer
Date: Mon, 14 Mar 2011 10:58:35 -0700
Message-ID: <1300125552-24422-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This required two passes:

remove-typedef -s DL_LIST "struct dl_list" \
	drivers/staging/ath6kl/
remove-typedef -s PDL_LIST "struct dl_list *" \
	drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../hif/sdio/linux_sdio/include/hif_internal.h     |    2 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |    2 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    2 +-
 drivers/staging/ath6kl/include/dl_list.h           |   26 ++++++++++----------
 drivers/staging/ath6kl/include/hif.h               |    2 +-
 drivers/staging/ath6kl/include/htc_packet.h        |    8 +++---
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
index 87057e3..b5d1ad4 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
@@ -77,7 +77,7 @@ struct hif_device {
     void     *claimedContext;
     HTC_CALLBACKS htcCallbacks;
     u8 *dma_buffer;
-    DL_LIST      ScatterReqHead;                /* scatter request list head */
+    struct dl_list      ScatterReqHead;                /* scatter request list head */
     bool       scatter_enabled;               /* scatter enabled flag */
     bool   is_suspend;
     bool   is_disabled;
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index 78cbbb1..2a56a50 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -62,7 +62,7 @@ static void FreeScatterReq(HIF_DEVICE *device, HIF_SCATTER_REQ *pReq)
 
 static HIF_SCATTER_REQ *AllocScatterReq(HIF_DEVICE *device) 
 {
-    DL_LIST       *pItem; 
+    struct dl_list       *pItem; 
     unsigned long flag;
 
     spin_lock_irqsave(&device->lock, flag);
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index a41ed12..f9f411a 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -589,7 +589,7 @@ void DevDumpRegisters(struct ar6k_device               *pDev,
 
 static HIF_SCATTER_REQ *DevAllocScatterReq(HIF_DEVICE *Context)
 {
-    DL_LIST *pItem;
+    struct dl_list *pItem;
     struct ar6k_device *pDev = (struct ar6k_device *)Context;
     LOCK_AR6K(pDev);
     pItem = DL_ListRemoveItemFromHead(&pDev->ScatterReqHead);
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 3e4ece8..88ef25a 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -133,7 +133,7 @@ struct ar6k_device {
     bool                          DSRCanYield;
     int                             CurrentDSRRecvCount;
     HIF_DEVICE_SCATTER_SUPPORT_INFO HifScatterInfo;
-    DL_LIST                         ScatterReqHead; 
+    struct dl_list                         ScatterReqHead; 
     bool                          ScatterIsVirtual;
     int                             MaxRecvBundleSize;
     int                             MaxSendBundleSize;
diff --git a/drivers/staging/ath6kl/include/dl_list.h b/drivers/staging/ath6kl/include/dl_list.h
index 110e1d8..13b1e69 100644
--- a/drivers/staging/ath6kl/include/dl_list.h
+++ b/drivers/staging/ath6kl/include/dl_list.h
@@ -32,10 +32,10 @@
          
 /* list functions */
 /* pointers for the list */
-typedef struct _DL_LIST {
-    struct _DL_LIST *pPrev;
-    struct _DL_LIST *pNext;
-}DL_LIST, *PDL_LIST;
+struct dl_list {
+	struct dl_list *pPrev;
+	struct dl_list *pNext;
+};
 /*
  * DL_LIST_INIT , initialize doubly linked list
 */
@@ -67,7 +67,7 @@ typedef struct _DL_LIST {
  */
 #define ITERATE_OVER_LIST_ALLOW_REMOVE(pStart,pItem,st,offset)  \
 {                                                       \
-    PDL_LIST  pTemp;                                     \
+    struct dl_list *  pTemp;                                     \
     pTemp = (pStart)->pNext;                            \
     while (pTemp != (pStart)) {                         \
         (pItem) = A_CONTAINING_STRUCT(pTemp,st,offset);   \
@@ -78,7 +78,7 @@ typedef struct _DL_LIST {
 /*
  * DL_ListInsertTail - insert pAdd to the end of the list
 */
-static INLINE PDL_LIST DL_ListInsertTail(PDL_LIST pList, PDL_LIST pAdd) {
+static INLINE struct dl_list *DL_ListInsertTail(struct dl_list *pList, struct dl_list *pAdd) {
         /* insert at tail */
     pAdd->pPrev = pList->pPrev;
     pAdd->pNext = pList;
@@ -90,7 +90,7 @@ static INLINE PDL_LIST DL_ListInsertTail(PDL_LIST pList, PDL_LIST pAdd) {
 /*
  * DL_ListInsertHead - insert pAdd into the head of the list
 */
-static INLINE PDL_LIST DL_ListInsertHead(PDL_LIST pList, PDL_LIST pAdd) {
+static INLINE struct dl_list * DL_ListInsertHead(struct dl_list * pList, struct dl_list * pAdd) {
         /* insert at head */
     pAdd->pPrev = pList;
     pAdd->pNext = pList->pNext;
@@ -103,7 +103,7 @@ static INLINE PDL_LIST DL_ListInsertHead(PDL_LIST pList, PDL_LIST pAdd) {
 /*
  * DL_ListRemove - remove pDel from list
 */
-static INLINE PDL_LIST DL_ListRemove(PDL_LIST pDel) {
+static INLINE struct dl_list * DL_ListRemove(struct dl_list * pDel) {
     pDel->pNext->pPrev = pDel->pPrev;
     pDel->pPrev->pNext = pDel->pNext;
         /* point back to itself just to be safe, incase remove is called again */
@@ -115,8 +115,8 @@ static INLINE PDL_LIST DL_ListRemove(PDL_LIST pDel) {
 /*
  * DL_ListRemoveItemFromHead - get a list item from the head
 */
-static INLINE PDL_LIST DL_ListRemoveItemFromHead(PDL_LIST pList) {
-    PDL_LIST pItem = NULL;
+static INLINE struct dl_list * DL_ListRemoveItemFromHead(struct dl_list * pList) {
+    struct dl_list * pItem = NULL;
     if (pList->pNext != pList) {
         pItem = pList->pNext;
             /* remove the first item from head */
@@ -125,8 +125,8 @@ static INLINE PDL_LIST DL_ListRemoveItemFromHead(PDL_LIST pList) {
     return pItem;
 }
 
-static INLINE PDL_LIST DL_ListRemoveItemFromTail(PDL_LIST pList) {
-    PDL_LIST pItem = NULL;
+static INLINE struct dl_list * DL_ListRemoveItemFromTail(struct dl_list * pList) {
+    struct dl_list * pItem = NULL;
     if (pList->pPrev != pList) {
         pItem = pList->pPrev;
             /* remove the item from tail */
@@ -136,7 +136,7 @@ static INLINE PDL_LIST DL_ListRemoveItemFromTail(PDL_LIST pList) {
 }
 
 /* transfer src list items to the tail of the destination list */
-static INLINE void DL_ListTransferItemsToTail(PDL_LIST pDest, PDL_LIST pSrc) {
+static INLINE void DL_ListTransferItemsToTail(struct dl_list * pDest, struct dl_list * pSrc) {
         /* only concatenate if src is not empty */
     if (!DL_LIST_IS_EMPTY(pSrc)) {
             /* cut out circular list in src and re-attach to end of dest */
diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index ab1f4c1..3421a59 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -287,7 +287,7 @@ typedef enum _HIF_SCATTER_METHOD {
 } HIF_SCATTER_METHOD;
 
 typedef struct _HIF_SCATTER_REQ {
-    DL_LIST             ListLink;           /* link management */
+    struct dl_list             ListLink;           /* link management */
     u32 Address;            /* address for the read/write operation */
     u32 Request;            /* request flags */
     u32 TotalLength;        /* total length of entire transfer */
diff --git a/drivers/staging/ath6kl/include/htc_packet.h b/drivers/staging/ath6kl/include/htc_packet.h
index fcf0a0c..9282e90 100644
--- a/drivers/staging/ath6kl/include/htc_packet.h
+++ b/drivers/staging/ath6kl/include/htc_packet.h
@@ -69,7 +69,7 @@ typedef struct _HTC_RX_PACKET_INFO {
 
 /* wrapper around endpoint-specific packets */
 typedef struct _HTC_PACKET {
-    DL_LIST         ListLink;       /* double link */
+    struct dl_list         ListLink;       /* double link */
     void            *pPktContext;   /* caller's per packet specific context */
 
     u8 *pBufferStart;  /* the true buffer start , the caller can
@@ -140,7 +140,7 @@ typedef struct _HTC_PACKET {
 
 /* HTC Packet Queueing Macros */
 typedef struct _HTC_PACKET_QUEUE {
-    DL_LIST     QueueHead;
+    struct dl_list     QueueHead;
     int         Depth;    
 } HTC_PACKET_QUEUE;
  
@@ -180,7 +180,7 @@ static INLINE HTC_PACKET *HTC_GET_PKT_AT_HEAD(HTC_PACKET_QUEUE *queue)   {
 
 /* dequeue an HTC packet from the head of the queue */
 static INLINE HTC_PACKET *HTC_PACKET_DEQUEUE(HTC_PACKET_QUEUE *queue) {
-    DL_LIST    *pItem = DL_ListRemoveItemFromHead(&queue->QueueHead);
+    struct dl_list    *pItem = DL_ListRemoveItemFromHead(&queue->QueueHead);
     if (pItem != NULL) {
         queue->Depth--;
         return A_CONTAINING_STRUCT(pItem, HTC_PACKET, ListLink);
@@ -190,7 +190,7 @@ static INLINE HTC_PACKET *HTC_PACKET_DEQUEUE(HTC_PACKET_QUEUE *queue) {
 
 /* dequeue an HTC packet from the tail of the queue */
 static INLINE HTC_PACKET *HTC_PACKET_DEQUEUE_TAIL(HTC_PACKET_QUEUE *queue) {
-    DL_LIST    *pItem = DL_ListRemoveItemFromTail(&queue->QueueHead);
+    struct dl_list    *pItem = DL_ListRemoveItemFromTail(&queue->QueueHead);
     if (pItem != NULL) {
         queue->Depth--;
         return A_CONTAINING_STRUCT(pItem, HTC_PACKET, ListLink);
-- 
1.7.4.15.g7811d

