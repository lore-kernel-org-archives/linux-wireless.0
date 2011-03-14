Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20491 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040Ab1CNR7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 17/38] ath6kl: remove-typedef HTC_ENDPOINT
Date: Mon, 14 Mar 2011 10:58:51 -0700
Message-ID: <1300125552-24422-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_ENDPOINT \
	"struct htc_endpoint" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/htc.c          |    2 +-
 drivers/staging/ath6kl/htc2/htc_internal.h |    6 ++--
 drivers/staging/ath6kl/htc2/htc_recv.c     |   24 ++++++++++----------
 drivers/staging/ath6kl/htc2/htc_send.c     |   34 ++++++++++++++--------------
 drivers/staging/ath6kl/htc2/htc_services.c |    2 +-
 5 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index bb999b6..e897c0c 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -438,7 +438,7 @@ int HTCStart(HTC_HANDLE HTCHandle)
 
 static void ResetEndpointStates(HTC_TARGET *target)
 {
-    HTC_ENDPOINT        *pEndpoint;
+    struct htc_endpoint        *pEndpoint;
     int                  i;
 
     for (i = ENDPOINT_0; i < ENDPOINT_MAX; i++) {
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index e3857cf..a6eaa1b 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -65,7 +65,7 @@ extern "C" {
 
 #define HTC_SCATTER_REQ_FLAGS_PARTIAL_BUNDLE  (1 << 0)
 
-typedef struct _HTC_ENDPOINT {
+struct htc_endpoint {
     HTC_ENDPOINT_ID             Id;
     HTC_SERVICE_ID              ServiceID;      /* service ID this endpoint is bound to
                                                    non-zero value means this endpoint is in use */
@@ -85,7 +85,7 @@ typedef struct _HTC_ENDPOINT {
 #ifdef HTC_EP_STAT_PROFILING
     HTC_ENDPOINT_STATS          EndPointStats;          /* endpoint statistics */
 #endif
-} HTC_ENDPOINT;
+};
 
 #ifdef HTC_EP_STAT_PROFILING
 #define INC_HTC_EP_STAT(p,stat,count) (p)->EndPointStats.stat += (count);
@@ -109,7 +109,7 @@ struct htc_control_buffer {
 
 /* our HTC target state */
 typedef struct _HTC_TARGET {
-    HTC_ENDPOINT                EndPoint[ENDPOINT_MAX];
+    struct htc_endpoint                EndPoint[ENDPOINT_MAX];
     struct htc_control_buffer          HTCControlBuffers[NUM_CONTROL_BUFFERS];
     HTC_ENDPOINT_CREDIT_DIST   *EpCreditDistributionListHead;
     HTC_PACKET_QUEUE            ControlBufferTXFreeList;
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index 7a333ed..4095f8e 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -50,7 +50,7 @@
 #define HTC_RX_STAT_PROFILE(t,ep,lookAhead)
 #endif
 
-static void DoRecvCompletion(HTC_ENDPOINT     *pEndpoint,
+static void DoRecvCompletion(struct htc_endpoint     *pEndpoint,
                              HTC_PACKET_QUEUE *pQueueToIndicate)
 {           
     
@@ -432,7 +432,7 @@ static INLINE void HTCAsyncRecvCheckMorePackets(HTC_TARGET  *target,
 }      
 
     /* unload the recv completion queue */
-static INLINE void DrainRecvIndicationQueue(HTC_TARGET *target, HTC_ENDPOINT *pEndpoint)
+static INLINE void DrainRecvIndicationQueue(HTC_TARGET *target, struct htc_endpoint *pEndpoint)
 {
     HTC_PACKET_QUEUE     recvCompletions;
     
@@ -497,7 +497,7 @@ static INLINE void DrainRecvIndicationQueue(HTC_TARGET *target, HTC_ENDPOINT *pE
    
    /* note: this function can be called with the RX lock held */     
 static INLINE void SetRxPacketIndicationFlags(u32 LookAhead,
-                                              HTC_ENDPOINT  *pEndpoint, 
+                                              struct htc_endpoint  *pEndpoint, 
                                               HTC_PACKET    *pPacket)
 {
     HTC_FRAME_HDR *pHdr = (HTC_FRAME_HDR *)&LookAhead;
@@ -518,7 +518,7 @@ static INLINE void SetRxPacketIndicationFlags(u32 LookAhead,
 void HTCRecvCompleteHandler(void *Context, HTC_PACKET *pPacket)
 {
     HTC_TARGET      *target = (HTC_TARGET *)Context;
-    HTC_ENDPOINT    *pEndpoint;
+    struct htc_endpoint    *pEndpoint;
     u32 nextLookAheads[HTC_HOST_MAX_MSG_PER_BUNDLE];
     int             numLookAheads = 0;
     int        status;
@@ -689,7 +689,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
 static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
                                          u32 LookAheads[],
                                          int              Messages,                                        
-                                         HTC_ENDPOINT     *pEndpoint, 
+                                         struct htc_endpoint     *pEndpoint, 
                                          HTC_PACKET_QUEUE *pQueue)
 {
     int         status = 0;
@@ -883,7 +883,7 @@ static void HTCAsyncRecvScatterCompletion(struct hif_scatter_req *pScatterReq)
 {
     int                 i;    
     HTC_PACKET          *pPacket;
-    HTC_ENDPOINT        *pEndpoint;
+    struct htc_endpoint        *pEndpoint;
     u32 lookAheads[HTC_HOST_MAX_MSG_PER_BUNDLE];
     int                 numLookAheads = 0;
     HTC_TARGET          *target = (HTC_TARGET *)pScatterReq->Context;
@@ -1102,7 +1102,7 @@ static int HTCIssueRecvPacketBundle(HTC_TARGET        *target,
     return status;
 }
 
-static INLINE void CheckRecvWaterMark(HTC_ENDPOINT    *pEndpoint)
+static INLINE void CheckRecvWaterMark(struct htc_endpoint    *pEndpoint)
 {  
         /* see if endpoint is using a refill watermark 
          * ** no need to use a lock here, since we are only inspecting...
@@ -1122,7 +1122,7 @@ int HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLook
     HTC_TARGET      *target = (HTC_TARGET *)Context;
     int         status = 0;
     HTC_PACKET      *pPacket;
-    HTC_ENDPOINT    *pEndpoint;
+    struct htc_endpoint    *pEndpoint;
     bool          asyncProc = false;
     u32 lookAheads[HTC_HOST_MAX_MSG_PER_BUNDLE];
     int             pktsFetched;
@@ -1388,7 +1388,7 @@ int HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLook
 int HTCAddReceivePktMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
-    HTC_ENDPOINT    *pEndpoint;
+    struct htc_endpoint    *pEndpoint;
     bool          unblockRecv = false;
     int        status = 0;
     HTC_PACKET      *pFirstPacket;
@@ -1486,7 +1486,7 @@ void HTCUnblockRecv(HTC_HANDLE HTCHandle)
     }
 }
 
-static void HTCFlushRxQueue(HTC_TARGET *target, HTC_ENDPOINT *pEndpoint, HTC_PACKET_QUEUE *pQueue)
+static void HTCFlushRxQueue(HTC_TARGET *target, struct htc_endpoint *pEndpoint, HTC_PACKET_QUEUE *pQueue)
 {
     HTC_PACKET  *pPacket;
     HTC_PACKET_QUEUE container;
@@ -1512,7 +1512,7 @@ static void HTCFlushRxQueue(HTC_TARGET *target, HTC_ENDPOINT *pEndpoint, HTC_PAC
     UNLOCK_HTC_RX(target);
 }
 
-static void HTCFlushEndpointRX(HTC_TARGET *target, HTC_ENDPOINT *pEndpoint)
+static void HTCFlushEndpointRX(HTC_TARGET *target, struct htc_endpoint *pEndpoint)
 {
         /* flush any recv indications not already made */
     HTCFlushRxQueue(target,pEndpoint,&pEndpoint->RecvIndicationQueue);
@@ -1522,7 +1522,7 @@ static void HTCFlushEndpointRX(HTC_TARGET *target, HTC_ENDPOINT *pEndpoint)
 
 void HTCFlushRecvBuffers(HTC_TARGET *target)
 {
-    HTC_ENDPOINT    *pEndpoint;
+    struct htc_endpoint    *pEndpoint;
     int             i;
 
     for (i = ENDPOINT_0; i < ENDPOINT_MAX; i++) {
diff --git a/drivers/staging/ath6kl/htc2/htc_send.c b/drivers/staging/ath6kl/htc2/htc_send.c
index f133d93..4e1d9bc7 100644
--- a/drivers/staging/ath6kl/htc2/htc_send.c
+++ b/drivers/staging/ath6kl/htc2/htc_send.c
@@ -43,7 +43,7 @@ typedef enum _HTC_SEND_QUEUE_RESULT {
                            (reason));                                    \
 }
 
-static void DoSendCompletion(HTC_ENDPOINT       *pEndpoint,
+static void DoSendCompletion(struct htc_endpoint       *pEndpoint,
                              HTC_PACKET_QUEUE   *pQueueToIndicate)
 {           
     do {
@@ -77,7 +77,7 @@ static void DoSendCompletion(HTC_ENDPOINT       *pEndpoint,
 }
 
 /* do final completion on sent packet */
-static INLINE void CompleteSentPacket(HTC_TARGET *target, HTC_ENDPOINT *pEndpoint, HTC_PACKET *pPacket)
+static INLINE void CompleteSentPacket(HTC_TARGET *target, struct htc_endpoint *pEndpoint, HTC_PACKET *pPacket)
 {
     pPacket->Completion = NULL;  
     
@@ -104,7 +104,7 @@ static INLINE void CompleteSentPacket(HTC_TARGET *target, HTC_ENDPOINT *pEndpoin
 static void HTCSendPktCompletionHandler(void *Context, HTC_PACKET *pPacket)
 {
     HTC_TARGET      *target = (HTC_TARGET *)Context;
-    HTC_ENDPOINT    *pEndpoint = &target->EndPoint[pPacket->Endpoint];
+    struct htc_endpoint    *pEndpoint = &target->EndPoint[pPacket->Endpoint];
     HTC_PACKET_QUEUE container;
     
     CompleteSentPacket(target,pEndpoint,pPacket);
@@ -147,7 +147,7 @@ int HTCIssueSend(HTC_TARGET *target, HTC_PACKET *pPacket)
 
     /* get HTC send packets from the TX queue on an endpoint */
 static INLINE void GetHTCSendPackets(HTC_TARGET        *target, 
-                                     HTC_ENDPOINT      *pEndpoint, 
+                                     struct htc_endpoint      *pEndpoint, 
                                      HTC_PACKET_QUEUE  *pQueue)
 {
     int          creditsRequired;
@@ -268,7 +268,7 @@ static void HTCAsyncSendScatterCompletion(struct hif_scatter_req *pScatterReq)
 {
     int                 i;    
     HTC_PACKET          *pPacket;
-    HTC_ENDPOINT        *pEndpoint = (HTC_ENDPOINT *)pScatterReq->Context;
+    struct htc_endpoint        *pEndpoint = (struct htc_endpoint *)pScatterReq->Context;
     HTC_TARGET          *target = (HTC_TARGET *)pEndpoint->target;
     int            status = 0;
     HTC_PACKET_QUEUE    sendCompletes;
@@ -309,7 +309,7 @@ static void HTCAsyncSendScatterCompletion(struct hif_scatter_req *pScatterReq)
      *    - a message that will consume a partial credit will stop the bundling process early 
      *    - we drop below the minimum number of messages for a bundle 
      * */
-static void HTCIssueSendBundle(HTC_ENDPOINT      *pEndpoint, 
+static void HTCIssueSendBundle(struct htc_endpoint      *pEndpoint, 
                                HTC_PACKET_QUEUE  *pQueue, 
                                int               *pBundlesSent, 
                                int               *pTotalBundlesPkts)
@@ -478,7 +478,7 @@ static void HTCIssueSendBundle(HTC_ENDPOINT      *pEndpoint,
  * if there are no credits, the packet(s) remains in the queue.
  * this function returns the result of the attempt to send a queue of HTC packets */
 static HTC_SEND_QUEUE_RESULT HTCTrySend(HTC_TARGET       *target,
-                                        HTC_ENDPOINT     *pEndpoint,
+                                        struct htc_endpoint     *pEndpoint,
                                         HTC_PACKET_QUEUE *pCallersSendQueue)
 {
     HTC_PACKET_QUEUE      sendQueue; /* temp queue to hold packets at various stages */
@@ -671,7 +671,7 @@ static HTC_SEND_QUEUE_RESULT HTCTrySend(HTC_TARGET       *target,
 int  HTCSendPktsMultiple(HTC_HANDLE HTCHandle, HTC_PACKET_QUEUE *pPktQueue)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
-    HTC_ENDPOINT    *pEndpoint;
+    struct htc_endpoint    *pEndpoint;
     HTC_PACKET      *pPacket;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND, ("+HTCSendPktsMultiple: Queue: 0x%lX, Pkts %d \n",
@@ -723,7 +723,7 @@ int HTCSendPkt(HTC_HANDLE HTCHandle, HTC_PACKET *pPacket)
 /* check TX queues to drain because of credit distribution update */
 static INLINE void HTCCheckEndpointTxQueues(HTC_TARGET *target)
 {
-    HTC_ENDPOINT                *pEndpoint;
+    struct htc_endpoint                *pEndpoint;
     HTC_ENDPOINT_CREDIT_DIST    *pDistItem;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND, ("+HTCCheckEndpointTxQueues \n"));
@@ -734,7 +734,7 @@ static INLINE void HTCCheckEndpointTxQueues(HTC_TARGET *target)
          * NOTE: no locks need to be taken since the distribution list
          * is not dynamic (cannot be re-ordered) and we are not modifying any state */
     while (pDistItem != NULL) {
-        pEndpoint = (HTC_ENDPOINT *)pDistItem->pHTCReserved;
+        pEndpoint = (struct htc_endpoint *)pDistItem->pHTCReserved;
 
         if (HTC_PACKET_QUEUE_DEPTH(&pEndpoint->TxQueue) > 0) {
             AR_DEBUG_PRINTF(ATH_DEBUG_SEND, (" Ep %d has %d credits and %d Packets in TX Queue \n",
@@ -756,7 +756,7 @@ static INLINE void HTCCheckEndpointTxQueues(HTC_TARGET *target)
 void HTCProcessCreditRpt(HTC_TARGET *target, HTC_CREDIT_REPORT *pRpt, int NumEntries, HTC_ENDPOINT_ID FromEndpoint)
 {
     int             i;
-    HTC_ENDPOINT    *pEndpoint;
+    struct htc_endpoint    *pEndpoint;
     int             totalCredits = 0;
     bool          doDist = false;
 
@@ -838,7 +838,7 @@ void HTCProcessCreditRpt(HTC_TARGET *target, HTC_CREDIT_REPORT *pRpt, int NumEnt
 }
 
 /* flush endpoint TX queue */
-static void HTCFlushEndpointTX(HTC_TARGET *target, HTC_ENDPOINT *pEndpoint, HTC_TX_TAG Tag)
+static void HTCFlushEndpointTX(HTC_TARGET *target, struct htc_endpoint *pEndpoint, HTC_TX_TAG Tag)
 {
     HTC_PACKET          *pPacket;
     HTC_PACKET_QUEUE    discardQueue;
@@ -895,7 +895,7 @@ void DumpCreditDist(HTC_ENDPOINT_CREDIT_DIST *pEPDist)
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY, (" TxCreditsPerMaxMsg : %d \n", pEPDist->TxCreditsPerMaxMsg));
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY, (" TxCreditsToDist    : %d \n", pEPDist->TxCreditsToDist));
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY, (" TxQueueDepth       : %d \n", 
-                    HTC_PACKET_QUEUE_DEPTH(&((HTC_ENDPOINT *)pEPDist->pHTCReserved)->TxQueue)));                                      
+                    HTC_PACKET_QUEUE_DEPTH(&((struct htc_endpoint *)pEPDist->pHTCReserved)->TxQueue)));                                      
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY, ("----------------------------------------------------\n"));
 }
 
@@ -919,7 +919,7 @@ void DumpCreditDistStates(HTC_TARGET *target)
 /* flush all send packets from all endpoint queues */
 void HTCFlushSendPkts(HTC_TARGET *target)
 {
-    HTC_ENDPOINT    *pEndpoint;
+    struct htc_endpoint    *pEndpoint;
     int             i;
 
     if (AR_DEBUG_LVL_CHECK(ATH_DEBUG_TRC)) {
@@ -942,7 +942,7 @@ void HTCFlushSendPkts(HTC_TARGET *target)
 void HTCFlushEndpoint(HTC_HANDLE HTCHandle, HTC_ENDPOINT_ID Endpoint, HTC_TX_TAG Tag)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
-    HTC_ENDPOINT    *pEndpoint = &target->EndPoint[Endpoint];
+    struct htc_endpoint    *pEndpoint = &target->EndPoint[Endpoint];
 
     if (pEndpoint->ServiceID == 0) {
         AR_DEBUG_ASSERT(false);
@@ -959,7 +959,7 @@ void HTCIndicateActivityChange(HTC_HANDLE      HTCHandle,
                                bool          Active)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
-    HTC_ENDPOINT    *pEndpoint = &target->EndPoint[Endpoint];
+    struct htc_endpoint    *pEndpoint = &target->EndPoint[Endpoint];
     bool          doDist = false;
 
     if (pEndpoint->ServiceID == 0) {
@@ -1009,7 +1009,7 @@ bool HTCIsEndpointActive(HTC_HANDLE      HTCHandle,
                            HTC_ENDPOINT_ID Endpoint)
 {
     HTC_TARGET      *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
-    HTC_ENDPOINT    *pEndpoint = &target->EndPoint[Endpoint];
+    struct htc_endpoint    *pEndpoint = &target->EndPoint[Endpoint];
 
     if (pEndpoint->ServiceID == 0) {
         return false;
diff --git a/drivers/staging/ath6kl/htc2/htc_services.c b/drivers/staging/ath6kl/htc2/htc_services.c
index 61a332e..2f99989 100644
--- a/drivers/staging/ath6kl/htc2/htc_services.c
+++ b/drivers/staging/ath6kl/htc2/htc_services.c
@@ -132,7 +132,7 @@ int HTCConnectService(HTC_HANDLE               HTCHandle,
     HTC_CONNECT_SERVICE_RESPONSE_MSG    *pResponseMsg;
     HTC_CONNECT_SERVICE_MSG             *pConnectMsg;
     HTC_ENDPOINT_ID                     assignedEndpoint = ENDPOINT_MAX;
-    HTC_ENDPOINT                        *pEndpoint;
+    struct htc_endpoint                        *pEndpoint;
     unsigned int                        maxMsgSize = 0;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC, ("+HTCConnectService, target:0x%lX SvcID:0x%X \n",
-- 
1.7.4.15.g7811d

