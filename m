Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20831 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082Ab1CNSCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:02:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:02:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 24/38] ath6kl: remove-typedef HTC_PACKET_QUEUE
Date: Mon, 14 Mar 2011 10:58:58 -0700
Message-ID: <1300125552-24422-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_PACKET_QUEUE \
	"struct htc_packet_queue" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    2 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |   18 +++++++-------
 drivers/staging/ath6kl/htc2/htc.c                  |    4 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |   14 +++++-----
 drivers/staging/ath6kl/htc2/htc_recv.c             |   24 ++++++++++----------
 drivers/staging/ath6kl/htc2/htc_send.c             |   22 +++++++++---------
 drivers/staging/ath6kl/include/hci_transport_api.h |    2 +-
 drivers/staging/ath6kl/include/htc_api.h           |   16 ++++++------
 drivers/staging/ath6kl/include/htc_packet.h        |   10 ++++----
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    8 +++---
 .../staging/ath6kl/os/linux/export_hci_transport.c |    2 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    4 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    2 +-
 .../ath6kl/os/linux/include/export_hci_transport.h |    2 +-
 14 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index b01542e..1ff2218 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -118,7 +118,7 @@ struct ar6k_device {
     struct hif_device_mbox_info        MailBoxInfo;
     HIF_PENDING_EVENTS_FUNC     GetPendingEventsFunc;
     void                        *HTCContext;
-    HTC_PACKET_QUEUE            RegisterIOList;
+    struct htc_packet_queue            RegisterIOList;
     struct ar6k_async_reg_io_buffer    RegIOBuffers[AR6K_MAX_REG_IO_BUFFERS];
     void                        (*TargetFailureCallback)(void *Context);
     int                    (*MessagePendingCallback)(void *Context,
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 90e303f..8cf46b1 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -63,9 +63,9 @@ struct gmbox_proto_hci_uart {
     u32 RecvStateFlags;
     u32 SendStateFlags;
     HCI_TRANSPORT_PACKET_TYPE   WaitBufferType;
-    HTC_PACKET_QUEUE            SendQueue;         /* write queue holding HCI Command and ACL packets */
-    HTC_PACKET_QUEUE            HCIACLRecvBuffers;  /* recv queue holding buffers for incomming ACL packets */
-    HTC_PACKET_QUEUE            HCIEventBuffers;    /* recv queue holding buffers for incomming event packets */
+    struct htc_packet_queue            SendQueue;         /* write queue holding HCI Command and ACL packets */
+    struct htc_packet_queue            HCIACLRecvBuffers;  /* recv queue holding buffers for incomming ACL packets */
+    struct htc_packet_queue            HCIEventBuffers;    /* recv queue holding buffers for incomming event packets */
     struct ar6k_device                 *pDev;
     A_MUTEX_T                   HCIRxLock;
     A_MUTEX_T                   HCITxLock;
@@ -366,7 +366,7 @@ static int HCIUartMessagePending(void *pContext, u8 LookAheadBytes[], int ValidB
             LOCK_HCI_RX(pProt);
     
         } else {
-            HTC_PACKET_QUEUE *pQueue;
+            struct htc_packet_queue *pQueue;
                 /* user is using a refill handler that can refill multiple HTC buffers */
             
                 /* select buffer queue */
@@ -483,7 +483,7 @@ static int HCIUartMessagePending(void *pContext, u8 LookAheadBytes[], int ValidB
         
             /* check if we need to refill recv buffers */        
         if ((pProt->HCIConfig.pHCIPktRecvRefill != NULL) && !recvRefillCalled) {           
-            HTC_PACKET_QUEUE *pQueue;
+            struct htc_packet_queue *pQueue;
             int              watermark;
 
             if (pktType == HCI_ACL_TYPE) {
@@ -514,7 +514,7 @@ static int HCIUartMessagePending(void *pContext, u8 LookAheadBytes[], int ValidB
     
         /* see if we need to recycle the recv buffer */    
     if (status && (pPacket != NULL)) {
-        HTC_PACKET_QUEUE queue;
+        struct htc_packet_queue queue;
         
         if (A_EPROTO == status) {
             DebugDumpBytes(pPacket->pBuffer, totalRecvLength, "Bad HCI-UART Recv packet");    
@@ -797,7 +797,7 @@ static int HCITrySend(struct gmbox_proto_hci_uart *pProt, struct htc_packet *pPa
 static void FlushSendQueue(struct gmbox_proto_hci_uart *pProt)
 {
     struct htc_packet          *pPacket;
-    HTC_PACKET_QUEUE    discardQueue;
+    struct htc_packet_queue    discardQueue;
     
     INIT_HTC_PACKET_QUEUE(&discardQueue);
     
@@ -820,7 +820,7 @@ static void FlushSendQueue(struct gmbox_proto_hci_uart *pProt)
 
 static void FlushRecvBuffers(struct gmbox_proto_hci_uart *pProt)
 {
-    HTC_PACKET_QUEUE discardQueue;
+    struct htc_packet_queue discardQueue;
     struct htc_packet *pPacket;
     
     INIT_HTC_PACKET_QUEUE(&discardQueue);
@@ -1001,7 +1001,7 @@ void HCI_TransportDetach(HCI_TRANSPORT_HANDLE HciTrans)
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("-HCI_TransportAttach \n"));
 }
 
-int HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue)
+int HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet_queue *pQueue)
 {
     struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans; 
     int              status = 0;
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index 04ba80e..bf4fdb3 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -43,14 +43,14 @@ ATH_DEBUG_INSTANTIATE_MODULE_VAR(htc,
 static void HTCReportFailure(void *Context);
 static void ResetEndpointStates(HTC_TARGET *target);
 
-void HTCFreeControlBuffer(HTC_TARGET *target, struct htc_packet *pPacket, HTC_PACKET_QUEUE *pList)
+void HTCFreeControlBuffer(HTC_TARGET *target, struct htc_packet *pPacket, struct htc_packet_queue *pList)
 {
     LOCK_HTC(target);
     HTC_PACKET_ENQUEUE(pList,pPacket);
     UNLOCK_HTC(target);
 }
 
-struct htc_packet *HTCAllocControlBuffer(HTC_TARGET *target,  HTC_PACKET_QUEUE *pList)
+struct htc_packet *HTCAllocControlBuffer(HTC_TARGET *target,  struct htc_packet_queue *pList)
 {
     struct htc_packet *pPacket;
 
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index 5f85350..67de917 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -69,15 +69,15 @@ struct htc_endpoint {
     HTC_ENDPOINT_ID             Id;
     HTC_SERVICE_ID              ServiceID;      /* service ID this endpoint is bound to
                                                    non-zero value means this endpoint is in use */
-    HTC_PACKET_QUEUE            TxQueue;        /* HTC frame buffer TX queue */
-    HTC_PACKET_QUEUE            RxBuffers;      /* HTC frame buffer RX list */
+    struct htc_packet_queue            TxQueue;        /* HTC frame buffer TX queue */
+    struct htc_packet_queue            RxBuffers;      /* HTC frame buffer RX list */
     struct htc_endpoint_credit_dist    CreditDist;     /* credit distribution structure (exposed to driver layer) */
     struct htc_ep_callbacks            EpCallBacks;    /* callbacks associated with this endpoint */
     int                         MaxTxQueueDepth;   /* max depth of the TX queue before we need to
                                                       call driver's full handler */
     int                         MaxMsgLength;        /* max length of endpoint message */
     int                         TxProcessCount;  /* reference count to continue tx processing */
-    HTC_PACKET_QUEUE            RecvIndicationQueue;    /* recv packets ready to be indicated */
+    struct htc_packet_queue            RecvIndicationQueue;    /* recv packets ready to be indicated */
     int                         RxProcessCount;         /* reference count to allow single processing context */
     struct  _HTC_TARGET         *target;                /* back pointer to target */
     u8 SeqNo;                  /* TX seq no (helpful) for debugging */
@@ -112,8 +112,8 @@ typedef struct _HTC_TARGET {
     struct htc_endpoint                EndPoint[ENDPOINT_MAX];
     struct htc_control_buffer          HTCControlBuffers[NUM_CONTROL_BUFFERS];
     struct htc_endpoint_credit_dist   *EpCreditDistributionListHead;
-    HTC_PACKET_QUEUE            ControlBufferTXFreeList;
-    HTC_PACKET_QUEUE            ControlBufferRXFreeList;
+    struct htc_packet_queue            ControlBufferTXFreeList;
+    struct htc_packet_queue            ControlBufferRXFreeList;
     HTC_CREDIT_DIST_CALLBACK    DistributeCredits;
     HTC_CREDIT_INIT_CALLBACK    InitCredits;
     void                       *pCredDistContext;
@@ -165,8 +165,8 @@ typedef struct _HTC_TARGET {
 void        HTCControlTxComplete(void *Context, struct htc_packet *pPacket);
 void        HTCControlRecv(void *Context, struct htc_packet *pPacket);
 int    HTCWaitforControlMessage(HTC_TARGET *target, struct htc_packet **ppControlPacket);
-struct htc_packet *HTCAllocControlBuffer(HTC_TARGET *target, HTC_PACKET_QUEUE *pList);
-void        HTCFreeControlBuffer(HTC_TARGET *target, struct htc_packet *pPacket, HTC_PACKET_QUEUE *pList);
+struct htc_packet *HTCAllocControlBuffer(HTC_TARGET *target, struct htc_packet_queue *pList);
+void        HTCFreeControlBuffer(HTC_TARGET *target, struct htc_packet *pPacket, struct htc_packet_queue *pList);
 int    HTCIssueSend(HTC_TARGET *target, struct htc_packet *pPacket);
 void        HTCRecvCompleteHandler(void *Context, struct htc_packet *pPacket);
 int    HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLookAheads, bool *pAsyncProc, int *pNumPktsFetched);
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index f702963..8ad1d03 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -51,7 +51,7 @@
 #endif
 
 static void DoRecvCompletion(struct htc_endpoint     *pEndpoint,
-                             HTC_PACKET_QUEUE *pQueueToIndicate)
+                             struct htc_packet_queue *pQueueToIndicate)
 {           
     
     do {
@@ -434,7 +434,7 @@ static INLINE void HTCAsyncRecvCheckMorePackets(HTC_TARGET  *target,
     /* unload the recv completion queue */
 static INLINE void DrainRecvIndicationQueue(HTC_TARGET *target, struct htc_endpoint *pEndpoint)
 {
-    HTC_PACKET_QUEUE     recvCompletions;
+    struct htc_packet_queue     recvCompletions;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV, ("+DrainRecvIndicationQueue \n"));
                 
@@ -690,7 +690,7 @@ static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
                                          u32 LookAheads[],
                                          int              Messages,                                        
                                          struct htc_endpoint     *pEndpoint, 
-                                         HTC_PACKET_QUEUE *pQueue)
+                                         struct htc_packet_queue *pQueue)
 {
     int         status = 0;
     struct htc_packet      *pPacket;
@@ -889,7 +889,7 @@ static void HTCAsyncRecvScatterCompletion(struct hif_scatter_req *pScatterReq)
     HTC_TARGET          *target = (HTC_TARGET *)pScatterReq->Context;
     int            status;
     bool              partialBundle = false;
-    HTC_PACKET_QUEUE    localRecvQueue;
+    struct htc_packet_queue    localRecvQueue;
     bool              procError = false;
            
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("+HTCAsyncRecvScatterCompletion  TotLen: %d  Entries: %d\n",
@@ -985,8 +985,8 @@ static void HTCAsyncRecvScatterCompletion(struct hif_scatter_req *pScatterReq)
 }
 
 static int HTCIssueRecvPacketBundle(HTC_TARGET        *target,
-                                         HTC_PACKET_QUEUE  *pRecvPktQueue, 
-                                         HTC_PACKET_QUEUE  *pSyncCompletionQueue,
+                                         struct htc_packet_queue  *pRecvPktQueue, 
+                                         struct htc_packet_queue  *pSyncCompletionQueue,
                                          int               *pNumPacketsFetched,
                                          bool             PartialBundle)
 {
@@ -1126,7 +1126,7 @@ int HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLook
     bool          asyncProc = false;
     u32 lookAheads[HTC_HOST_MAX_MSG_PER_BUNDLE];
     int             pktsFetched;
-    HTC_PACKET_QUEUE recvPktQueue, syncCompletedPktsQueue;
+    struct htc_packet_queue recvPktQueue, syncCompletedPktsQueue;
     bool          partialBundle;
     HTC_ENDPOINT_ID id;
     int             totalFetched = 0;
@@ -1283,7 +1283,7 @@ int HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLook
              
              /* unload sync completion queue */      
         while (!HTC_QUEUE_EMPTY(&syncCompletedPktsQueue)) {
-            HTC_PACKET_QUEUE    container;
+            struct htc_packet_queue    container;
            
             pPacket = HTC_PACKET_DEQUEUE(&syncCompletedPktsQueue);
             A_ASSERT(pPacket != NULL);
@@ -1385,7 +1385,7 @@ int HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLook
     return status;
 }
 
-int HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
+int HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, struct htc_packet_queue *pPktQueue)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
     struct htc_endpoint    *pEndpoint;
@@ -1457,7 +1457,7 @@ int HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
 /* Makes a buffer available to the HTC module */
 int HTCAddReceivePkt(HTC_HANDLE HTCHandle, struct htc_packet *pPacket)
 {
-    HTC_PACKET_QUEUE queue;
+    struct htc_packet_queue queue;
     INIT_HTC_PACKET_QUEUE_AND_ADD(&queue,pPacket); 
     return HTCAddReceivePktMultiple(HTCHandle, &queue);       
 }
@@ -1486,10 +1486,10 @@ void HTCUnblockRecv(HTC_HANDLE HTCHandle)
     }
 }
 
-static void HTCFlushRxQueue(HTC_TARGET *target, struct htc_endpoint *pEndpoint, HTC_PACKET_QUEUE *pQueue)
+static void HTCFlushRxQueue(HTC_TARGET *target, struct htc_endpoint *pEndpoint, struct htc_packet_queue *pQueue)
 {
     struct htc_packet  *pPacket;
-    HTC_PACKET_QUEUE container;
+    struct htc_packet_queue container;
     
     LOCK_HTC_RX(target);
 
diff --git a/drivers/staging/ath6kl/htc2/htc_send.c b/drivers/staging/ath6kl/htc2/htc_send.c
index 8fb05d9..8052658 100644
--- a/drivers/staging/ath6kl/htc2/htc_send.c
+++ b/drivers/staging/ath6kl/htc2/htc_send.c
@@ -44,7 +44,7 @@ typedef enum _HTC_SEND_QUEUE_RESULT {
 }
 
 static void DoSendCompletion(struct htc_endpoint       *pEndpoint,
-                             HTC_PACKET_QUEUE   *pQueueToIndicate)
+                             struct htc_packet_queue   *pQueueToIndicate)
 {           
     do {
                 
@@ -105,7 +105,7 @@ static void HTCSendPktCompletionHandler(void *Context, struct htc_packet *pPacke
 {
     HTC_TARGET      *target = (HTC_TARGET *)Context;
     struct htc_endpoint    *pEndpoint = &target->EndPoint[pPacket->Endpoint];
-    HTC_PACKET_QUEUE container;
+    struct htc_packet_queue container;
     
     CompleteSentPacket(target,pEndpoint,pPacket);
     INIT_HTC_PACKET_QUEUE_AND_ADD(&container,pPacket);
@@ -148,7 +148,7 @@ int HTCIssueSend(HTC_TARGET *target, struct htc_packet *pPacket)
     /* get HTC send packets from the TX queue on an endpoint */
 static INLINE void GetHTCSendPackets(HTC_TARGET        *target, 
                                      struct htc_endpoint      *pEndpoint, 
-                                     HTC_PACKET_QUEUE  *pQueue)
+                                     struct htc_packet_queue  *pQueue)
 {
     int          creditsRequired;
     int          remainder;
@@ -271,7 +271,7 @@ static void HTCAsyncSendScatterCompletion(struct hif_scatter_req *pScatterReq)
     struct htc_endpoint        *pEndpoint = (struct htc_endpoint *)pScatterReq->Context;
     HTC_TARGET          *target = (HTC_TARGET *)pEndpoint->target;
     int            status = 0;
-    HTC_PACKET_QUEUE    sendCompletes;
+    struct htc_packet_queue    sendCompletes;
     
     INIT_HTC_PACKET_QUEUE(&sendCompletes);
           
@@ -310,7 +310,7 @@ static void HTCAsyncSendScatterCompletion(struct hif_scatter_req *pScatterReq)
      *    - we drop below the minimum number of messages for a bundle 
      * */
 static void HTCIssueSendBundle(struct htc_endpoint      *pEndpoint, 
-                               HTC_PACKET_QUEUE  *pQueue, 
+                               struct htc_packet_queue  *pQueue, 
                                int               *pBundlesSent, 
                                int               *pTotalBundlesPkts)
 {
@@ -479,9 +479,9 @@ static void HTCIssueSendBundle(struct htc_endpoint      *pEndpoint,
  * this function returns the result of the attempt to send a queue of HTC packets */
 static HTC_SEND_QUEUE_RESULT HTCTrySend(HTC_TARGET       *target,
                                         struct htc_endpoint     *pEndpoint,
-                                        HTC_PACKET_QUEUE *pCallersSendQueue)
+                                        struct htc_packet_queue *pCallersSendQueue)
 {
-    HTC_PACKET_QUEUE      sendQueue; /* temp queue to hold packets at various stages */
+    struct htc_packet_queue      sendQueue; /* temp queue to hold packets at various stages */
     struct htc_packet            *pPacket;
     int                   bundlesSent;
     int                   pktsInBundles;
@@ -668,7 +668,7 @@ static HTC_SEND_QUEUE_RESULT HTCTrySend(HTC_TARGET       *target,
     return HTC_SEND_QUEUE_OK;
 }
 
-int  HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
+int  HTCSendPktsMultiple(HTC_HANDLE HTCHandle, struct htc_packet_queue *pPktQueue)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
     struct htc_endpoint    *pEndpoint;
@@ -711,7 +711,7 @@ int  HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
 /* HTC API - HTCSendPkt */
 int HTCSendPkt(HTC_HANDLE HTCHandle, struct htc_packet *pPacket)
 {
-    HTC_PACKET_QUEUE queue;
+    struct htc_packet_queue queue;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND,
                     ("+-HTCSendPkt: Enter endPointId: %d, buffer: 0x%lX, length: %d \n",
@@ -841,8 +841,8 @@ void HTCProcessCreditRpt(HTC_TARGET *target, HTC_CREDIT_REPORT *pRpt, int NumEnt
 static void HTCFlushEndpointTX(HTC_TARGET *target, struct htc_endpoint *pEndpoint, HTC_TX_TAG Tag)
 {
     struct htc_packet          *pPacket;
-    HTC_PACKET_QUEUE    discardQueue;
-    HTC_PACKET_QUEUE    container;
+    struct htc_packet_queue    discardQueue;
+    struct htc_packet_queue    container;
 
         /* initialize the discard queue */
     INIT_HTC_PACKET_QUEUE(&discardQueue);
diff --git a/drivers/staging/ath6kl/include/hci_transport_api.h b/drivers/staging/ath6kl/include/hci_transport_api.h
index 3eac192..5e903fa 100644
--- a/drivers/staging/ath6kl/include/hci_transport_api.h
+++ b/drivers/staging/ath6kl/include/hci_transport_api.h
@@ -141,7 +141,7 @@ void HCI_TransportDetach(HCI_TRANSPORT_HANDLE HciTrans);
   @example:
   @see also:
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-int    HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
+int    HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet_queue *pQueue);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Send an HCI packet packet
diff --git a/drivers/staging/ath6kl/include/htc_api.h b/drivers/staging/ath6kl/include/htc_api.h
index ca85bad..ae41f98 100644
--- a/drivers/staging/ath6kl/include/htc_api.h
+++ b/drivers/staging/ath6kl/include/htc_api.h
@@ -51,21 +51,21 @@ struct htc_init_info {
 /* per service connection send completion */
 typedef void   (*HTC_EP_SEND_PKT_COMPLETE)(void *,struct htc_packet *);
 /* per service connection callback when a plurality of packets have been sent
- * The HTC_PACKET_QUEUE is a temporary queue object (e.g. freed on return from the callback)
+ * The struct htc_packet_queue is a temporary queue object (e.g. freed on return from the callback)
  * to hold a list of completed send packets.
  * If the handler cannot fully traverse the packet queue before returning, it should
  * transfer the items of the queue into the caller's private queue using:
  *   HTC_PACKET_ENQUEUE() */
-typedef void   (*HTC_EP_SEND_PKT_COMP_MULTIPLE)(void *,HTC_PACKET_QUEUE *);
+typedef void   (*HTC_EP_SEND_PKT_COMP_MULTIPLE)(void *,struct htc_packet_queue *);
 /* per service connection pkt received */
 typedef void   (*HTC_EP_RECV_PKT)(void *,struct htc_packet *);
 /* per service connection callback when a plurality of packets are received
- * The HTC_PACKET_QUEUE is a temporary queue object (e.g. freed on return from the callback)
+ * The struct htc_packet_queue is a temporary queue object (e.g. freed on return from the callback)
  * to hold a list of recv packets.
  * If the handler cannot fully traverse the packet queue before returning, it should
  * transfer the items of the queue into the caller's private queue using:
  *   HTC_PACKET_ENQUEUE() */
-typedef void   (*HTC_EP_RECV_PKT_MULTIPLE)(void *,HTC_PACKET_QUEUE *);
+typedef void   (*HTC_EP_RECV_PKT_MULTIPLE)(void *,struct htc_packet_queue *);
 
 /* Optional per service connection receive buffer re-fill callback,
  * On some OSes (like Linux) packets are allocated from a global pool and indicated up
@@ -502,7 +502,7 @@ void HTCUnblockRecv(HTC_HANDLE HTCHandle);
   @return: 0
   @notes:  Caller must initialize each packet using SET_HTC_PACKET_INFO_TX() macro.
            The queue must only contain packets directed at the same endpoint.
-           Caller supplies a pointer to an HTC_PACKET_QUEUE structure holding the TX packets in FIFO order.
+           Caller supplies a pointer to an struct htc_packet_queue structure holding the TX packets in FIFO order.
            This API will remove the packets from the pkt queue and place them into the HTC Tx Queue
            and bundle messages where possible.
            The caller may allocate the pkt queue on the stack to hold the packets.           
@@ -511,7 +511,7 @@ void HTCUnblockRecv(HTC_HANDLE HTCHandle);
   @example:
   @see also: HTCFlushEndpoint
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-int    HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue);
+int    HTCSendPktsMultiple(HTC_HANDLE HTCHandle, struct htc_packet_queue *pPktQueue);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Add multiple receive packets to HTC
@@ -523,14 +523,14 @@ int    HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue);
   @notes:  user must supply HTC packets for capturing incomming HTC frames.  The caller
            must initialize each HTC packet using the SET_HTC_PACKET_INFO_RX_REFILL()
            macro. The queue must only contain recv packets for the same endpoint.
-           Caller supplies a pointer to an HTC_PACKET_QUEUE structure holding the recv packet.
+           Caller supplies a pointer to an struct htc_packet_queue structure holding the recv packet.
            This API will remove the packets from the pkt queue and place them into internal
            recv packet list.
            The caller may allocate the pkt queue on the stack to hold the packets.           
   @example:
   @see also:
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-int    HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue);
+int    HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, struct htc_packet_queue *pPktQueue);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Check if an endpoint is marked active
diff --git a/drivers/staging/ath6kl/include/htc_packet.h b/drivers/staging/ath6kl/include/htc_packet.h
index 4311c93..ca23efd 100644
--- a/drivers/staging/ath6kl/include/htc_packet.h
+++ b/drivers/staging/ath6kl/include/htc_packet.h
@@ -139,10 +139,10 @@ struct htc_packet {
 }
 
 /* HTC Packet Queueing Macros */
-typedef struct _HTC_PACKET_QUEUE {
+struct htc_packet_queue {
     struct dl_list     QueueHead;
     int         Depth;    
-} HTC_PACKET_QUEUE;
+};
  
 /* initialize queue */
 #define INIT_HTC_PACKET_QUEUE(pQ)   \
@@ -165,7 +165,7 @@ typedef struct _HTC_PACKET_QUEUE {
 /* test if a queue is empty */
 #define HTC_QUEUE_EMPTY(pQ)       ((pQ)->Depth == 0)
 /* get packet at head without removing it */
-static INLINE struct htc_packet *HTC_GET_PKT_AT_HEAD(HTC_PACKET_QUEUE *queue)   {
+static INLINE struct htc_packet *HTC_GET_PKT_AT_HEAD(struct htc_packet_queue *queue)   {
     if (queue->Depth == 0) {
         return NULL; 
     }  
@@ -179,7 +179,7 @@ static INLINE struct htc_packet *HTC_GET_PKT_AT_HEAD(HTC_PACKET_QUEUE *queue)
 }
 
 /* dequeue an HTC packet from the head of the queue */
-static INLINE struct htc_packet *HTC_PACKET_DEQUEUE(HTC_PACKET_QUEUE *queue) {
+static INLINE struct htc_packet *HTC_PACKET_DEQUEUE(struct htc_packet_queue *queue) {
     struct dl_list    *pItem = DL_ListRemoveItemFromHead(&queue->QueueHead);
     if (pItem != NULL) {
         queue->Depth--;
@@ -189,7 +189,7 @@ static INLINE struct htc_packet *HTC_PACKET_DEQUEUE(HTC_PACKET_QUEUE *queue) {
 }
 
 /* dequeue an HTC packet from the tail of the queue */
-static INLINE struct htc_packet *HTC_PACKET_DEQUEUE_TAIL(HTC_PACKET_QUEUE *queue) {
+static INLINE struct htc_packet *HTC_PACKET_DEQUEUE_TAIL(struct htc_packet_queue *queue) {
     struct dl_list    *pItem = DL_ListRemoveItemFromTail(&queue->QueueHead);
     if (pItem != NULL) {
         queue->Depth--;
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index ebfc7fd..fab1e02 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -317,7 +317,7 @@ static void ar6000_rx(void *Context, struct htc_packet *pPacket);
 
 static void ar6000_rx_refill(void *Context,HTC_ENDPOINT_ID Endpoint);
 
-static void ar6000_tx_complete(void *Context, HTC_PACKET_QUEUE *pPackets);
+static void ar6000_tx_complete(void *Context, struct htc_packet_queue *pPackets);
 
 static HTC_SEND_FULL_ACTION ar6000_tx_queue_full(void *Context, struct htc_packet *pPacket);
 
@@ -3461,7 +3461,7 @@ static HTC_SEND_FULL_ACTION ar6000_tx_queue_full(void *Context, struct htc_packe
 
 
 static void
-ar6000_tx_complete(void *Context, HTC_PACKET_QUEUE *pPacketQueue)
+ar6000_tx_complete(void *Context, struct htc_packet_queue *pPacketQueue)
 {
     AR_SOFTC_T     *ar = (AR_SOFTC_T *)Context;
     u32 mapNo = 0;
@@ -3992,7 +3992,7 @@ ar6000_rx_refill(void *Context, HTC_ENDPOINT_ID Endpoint)
     int         RxBuffers;
     int         buffersToRefill;
     struct htc_packet  *pPacket;
-    HTC_PACKET_QUEUE queue;
+    struct htc_packet_queue queue;
 
     buffersToRefill = (int)AR6000_MAX_RX_BUFFERS -
                                     HTCGetNumRecvBuffers(ar->arHtcTarget, Endpoint);
@@ -6323,7 +6323,7 @@ static void DoHTCSendPktsTest(AR_SOFTC_T *ar, int MapNo, HTC_ENDPOINT_ID eid, st
     struct sk_buff   *new_skb;
     int    i;
     int    pkts = 0;
-    HTC_PACKET_QUEUE pktQueue;
+    struct htc_packet_queue pktQueue;
     EPPING_HEADER    *eppingHdr;
 
     eppingHdr = A_NETBUF_DATA(dupskb);
diff --git a/drivers/staging/ath6kl/os/linux/export_hci_transport.c b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
index 319dc2e..787a8bd 100644
--- a/drivers/staging/ath6kl/os/linux/export_hci_transport.c
+++ b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
@@ -38,7 +38,7 @@
 
 HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, struct hci_transport_config_info *pInfo);
 void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
-int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
+int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet_queue *pQueue);
 int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet *pPacket, bool Synchronous);
 void        (*_HCI_TransportStop)(HCI_TRANSPORT_HANDLE HciTrans);
 int    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index 4324a9d..4b7f5a8 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -79,7 +79,7 @@ struct ar6k_hci_bridge_info {
     struct hci_dev          *pBtStackHCIDev;   /* BT Stack HCI dev */
     bool                  HciNormalMode;     /* Actual HCI mode enabled (non-TEST)*/
     bool                  HciRegistered;     /* HCI device registered with stack */
-    HTC_PACKET_QUEUE        HTCPacketStructHead;
+    struct htc_packet_queue        HTCPacketStructHead;
     u8 *pHTCStructAlloc;
     spinlock_t              BridgeLock;
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
@@ -163,7 +163,7 @@ static void RefillRecvBuffers(struct ar6k_hci_bridge_info      *pHcidevInfo,
 {
     int                 length, i;
     void                *osBuf = NULL;
-    HTC_PACKET_QUEUE    queue;
+    struct htc_packet_queue    queue;
     struct htc_packet          *pPacket;
 
     INIT_HTC_PACKET_QUEUE(&queue);
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 29ac830..8d8a964 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -586,7 +586,7 @@ typedef struct ar6_softc {
     u16 ap_beacon_interval;
     u16 arRTS;
     u16 arACS; /* AP mode - Auto Channel Selection */
-    HTC_PACKET_QUEUE        amsdu_rx_buffer_queue;
+    struct htc_packet_queue        amsdu_rx_buffer_queue;
     bool                  bIsDestroyProgress; /* flag to indicate ar6k destroy is in progress */
     A_TIMER                 disconnect_timer;
     u8 rxMetaVersion;
diff --git a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
index 8e52de7..31f4f78 100644
--- a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
+++ b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
@@ -27,7 +27,7 @@
 
 extern HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, struct hci_transport_config_info *pInfo);
 extern void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
-extern int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
+extern int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet_queue *pQueue);
 extern int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet *pPacket, bool Synchronous);
 extern void        (*_HCI_TransportStop)(HCI_TRANSPORT_HANDLE HciTrans);
 extern int    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
-- 
1.7.4.15.g7811d

