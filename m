Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47142 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1C3A5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 15/34] ath6kl: remove define HTC_EP_STAT_PROFILING
Date: Tue, 29 Mar 2011 17:56:12 -0700
Message-ID: <1301446591-15236-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is always set so just keep the code it idefs around.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile            |    1 -
 drivers/staging/ath6kl/htc2/htc.c          |    6 ------
 drivers/staging/ath6kl/htc2/htc_internal.h |    8 --------
 drivers/staging/ath6kl/htc2/htc_recv.c     |    6 ------
 drivers/staging/ath6kl/htc2/htc_send.c     |    5 -----
 5 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index 50f9be3..d79f862 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -110,7 +110,6 @@ ifeq ($(CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK),y)
 ccflags-y += -DATH6KL_SKIP_ABI_VERSION_CHECK
 endif
 
-ccflags-y += -DHTC_EP_STAT_PROFILING
 ccflags-y += -DWAPI_ENABLE
 ccflags-y += -DCHECKSUM_OFFLOAD
 ccflags-y += -DWLAN_HEADERS
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index f308655..ae54e64 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -448,9 +448,7 @@ static void ResetEndpointStates(struct htc_target *target)
         pEndpoint->ServiceID = 0;
         pEndpoint->MaxMsgLength = 0;
         pEndpoint->MaxTxQueueDepth = 0;
-#ifdef HTC_EP_STAT_PROFILING
         A_MEMZERO(&pEndpoint->EndPointStats,sizeof(pEndpoint->EndPointStats));
-#endif
         INIT_HTC_PACKET_QUEUE(&pEndpoint->RxBuffers);
         INIT_HTC_PACKET_QUEUE(&pEndpoint->TxQueue);
         INIT_HTC_PACKET_QUEUE(&pEndpoint->RecvIndicationQueue);
@@ -527,7 +525,6 @@ bool HTCGetEndpointStatistics(HTC_HANDLE               HTCHandle,
                                 struct htc_endpoint_stats       *pStats)
 {
 
-#ifdef HTC_EP_STAT_PROFILING
     struct htc_target *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
     bool     clearStats = false;
     bool     sample = false;
@@ -568,9 +565,6 @@ bool HTCGetEndpointStatistics(HTC_HANDLE               HTCHandle,
     UNLOCK_HTC_TX(target);
 
     return true;
-#else
-    return false;
-#endif
 }
 
 struct ar6k_device  *HTCGetAR6KDevice(void *HTCHandle)
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index 9425ed9..1c9aeca 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -27,7 +27,6 @@
  * processing errors, the last frame header is dump for comparison */
 //#define HTC_CAPTURE_LAST_FRAME
 
-//#define HTC_EP_STAT_PROFILING
 
 #ifdef __cplusplus
 extern "C" {
@@ -82,17 +81,10 @@ struct htc_endpoint {
     struct htc_target           *target;                /* back pointer to target */
     u8 SeqNo;                  /* TX seq no (helpful) for debugging */
     u32 LocalConnectionFlags;   /* local connection flags */
-#ifdef HTC_EP_STAT_PROFILING
     struct htc_endpoint_stats          EndPointStats;          /* endpoint statistics */
-#endif
 };
 
-#ifdef HTC_EP_STAT_PROFILING
 #define INC_HTC_EP_STAT(p,stat,count) (p)->EndPointStats.stat += (count);
-#else
-#define INC_HTC_EP_STAT(p,stat,count)
-#endif
-
 #define HTC_SERVICE_TX_PACKET_TAG  HTC_TX_PACKET_TAG_INTERNAL
 
 #define NUM_CONTROL_BUFFERS     8
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index c208801..974cc8c 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -36,7 +36,6 @@
                         (pP)->PktInfo.AsRx.ExpectedHdr,        \
                         (pP)->Endpoint))                         
                         
-#ifdef HTC_EP_STAT_PROFILING
 #define HTC_RX_STAT_PROFILE(t,ep,numLookAheads)        \
 {                                                      \
     INC_HTC_EP_STAT((ep), RxReceived, 1);              \
@@ -46,9 +45,6 @@
         INC_HTC_EP_STAT((ep), RxBundleLookAheads, 1);  \
     }                                                  \
 }
-#else
-#define HTC_RX_STAT_PROFILE(t,ep,lookAhead)
-#endif
 
 static void DoRecvCompletion(struct htc_endpoint     *pEndpoint,
                              struct htc_packet_queue *pQueueToIndicate)
@@ -931,12 +927,10 @@ static void HTCAsyncRecvScatterCompletion(struct hif_scatter_req *pScatterReq)
         }
         
         if (!status) {
-#ifdef HTC_EP_STAT_PROFILING
             LOCK_HTC_RX(target);              
             HTC_RX_STAT_PROFILE(target,pEndpoint,numLookAheads);
             INC_HTC_EP_STAT(pEndpoint, RxPacketsBundled, 1);
             UNLOCK_HTC_RX(target);
-#endif      
             if (i == (pScatterReq->ValidScatterEntries - 1)) {
                     /* last packet's more packets flag is set based on the lookahead */
                 SET_MORE_RX_PACKET_INDICATION_FLAG(lookAheads,numLookAheads,pEndpoint,pPacket);
diff --git a/drivers/staging/ath6kl/htc2/htc_send.c b/drivers/staging/ath6kl/htc2/htc_send.c
index 6f4050a..9310d4d 100644
--- a/drivers/staging/ath6kl/htc2/htc_send.c
+++ b/drivers/staging/ath6kl/htc2/htc_send.c
@@ -776,9 +776,6 @@ void HTCProcessCreditRpt(struct htc_target *target, HTC_CREDIT_REPORT *pRpt, int
         AR_DEBUG_PRINTF(ATH_DEBUG_SEND, ("  Endpoint %d got %d credits \n",
                 pRpt->EndpointID, pRpt->Credits));
 
-
-#ifdef HTC_EP_STAT_PROFILING
-
         INC_HTC_EP_STAT(pEndpoint, TxCreditRpts, 1);
         INC_HTC_EP_STAT(pEndpoint, TxCreditsReturned, pRpt->Credits);
 
@@ -797,8 +794,6 @@ void HTCProcessCreditRpt(struct htc_target *target, HTC_CREDIT_REPORT *pRpt, int
             INC_HTC_EP_STAT(pEndpoint, TxCreditRptsFromOther, 1);
         }
 
-#endif
-
         if (ENDPOINT_0 == pRpt->EndpointID) {
                 /* always give endpoint 0 credits back */
             pEndpoint->CreditDist.TxCredits += pRpt->Credits;
-- 
1.7.0.4

