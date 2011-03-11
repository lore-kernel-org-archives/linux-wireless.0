Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29961 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab1CKC4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:22 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:59 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 09/20] ath6kl: remove-typedef AR6K_DEVICE
Date: Thu, 10 Mar 2011 18:55:36 -0800
Message-ID: <1299812147-12069-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6K_DEVICE \
	"struct ar6k_device" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |   64 +++++++++---------
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |   74 ++++++++++----------
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |   28 ++++----
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |   32 ++++----
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |   10 ++--
 drivers/staging/ath6kl/htc2/htc.c                  |    2 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |    2 +-
 7 files changed, 106 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 9090a39..85d45a7 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -35,19 +35,19 @@
 
 #define MAILBOX_FOR_BLOCK_SIZE          1
 
-int DevEnableInterrupts(AR6K_DEVICE *pDev);
-int DevDisableInterrupts(AR6K_DEVICE *pDev);
+int DevEnableInterrupts(struct ar6k_device *pDev);
+int DevDisableInterrupts(struct ar6k_device *pDev);
 
-static void DevCleanupVirtualScatterSupport(AR6K_DEVICE *pDev);
+static void DevCleanupVirtualScatterSupport(struct ar6k_device *pDev);
 
-void AR6KFreeIOPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket)
+void AR6KFreeIOPacket(struct ar6k_device *pDev, HTC_PACKET *pPacket)
 {
     LOCK_AR6K(pDev);
     HTC_PACKET_ENQUEUE(&pDev->RegisterIOList,pPacket);
     UNLOCK_AR6K(pDev);
 }
 
-HTC_PACKET *AR6KAllocIOPacket(AR6K_DEVICE *pDev)
+HTC_PACKET *AR6KAllocIOPacket(struct ar6k_device *pDev)
 {
     HTC_PACKET *pPacket;
 
@@ -58,7 +58,7 @@ HTC_PACKET *AR6KAllocIOPacket(AR6K_DEVICE *pDev)
     return pPacket;
 }
 
-void DevCleanup(AR6K_DEVICE *pDev)
+void DevCleanup(struct ar6k_device *pDev)
 {
     DevCleanupGMbox(pDev);
 
@@ -74,7 +74,7 @@ void DevCleanup(AR6K_DEVICE *pDev)
     }
 }
 
-int DevSetup(AR6K_DEVICE *pDev)
+int DevSetup(struct ar6k_device *pDev)
 {
     u32 blocksizes[AR6K_MAILBOXES];
     int status = 0;
@@ -216,7 +216,7 @@ int DevSetup(AR6K_DEVICE *pDev)
 
 }
 
-int DevEnableInterrupts(AR6K_DEVICE *pDev)
+int DevEnableInterrupts(struct ar6k_device *pDev)
 {
     int                  status;
     AR6K_IRQ_ENABLE_REGISTERS regs;
@@ -276,7 +276,7 @@ int DevEnableInterrupts(AR6K_DEVICE *pDev)
     return status;
 }
 
-int DevDisableInterrupts(AR6K_DEVICE *pDev)
+int DevDisableInterrupts(struct ar6k_device *pDev)
 {
     AR6K_IRQ_ENABLE_REGISTERS regs;
 
@@ -301,7 +301,7 @@ int DevDisableInterrupts(AR6K_DEVICE *pDev)
 }
 
 /* enable device interrupts */
-int DevUnmaskInterrupts(AR6K_DEVICE *pDev)
+int DevUnmaskInterrupts(struct ar6k_device *pDev)
 {
     /* for good measure, make sure interrupt are disabled before unmasking at the HIF
      * layer.
@@ -327,7 +327,7 @@ int DevUnmaskInterrupts(AR6K_DEVICE *pDev)
 }
 
 /* disable all device interrupts */
-int DevMaskInterrupts(AR6K_DEVICE *pDev)
+int DevMaskInterrupts(struct ar6k_device *pDev)
 {
         /* mask the interrupt at the HIF layer, we don't want a stray interrupt taken while
          * we zero out our shadow registers in DevDisableInterrupts()*/
@@ -339,7 +339,7 @@ int DevMaskInterrupts(AR6K_DEVICE *pDev)
 /* callback when our fetch to enable/disable completes */
 static void DevDoEnableDisableRecvAsyncHandler(void *Context, HTC_PACKET *pPacket)
 {
-    AR6K_DEVICE *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device *pDev = (struct ar6k_device *)Context;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("+DevDoEnableDisableRecvAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
 
@@ -355,7 +355,7 @@ static void DevDoEnableDisableRecvAsyncHandler(void *Context, HTC_PACKET *pPacke
 /* disable packet reception (used in case the host runs out of buffers)
  * this is the "override" method when the HIF reports another methods to
  * disable recv events */
-static int DevDoEnableDisableRecvOverride(AR6K_DEVICE *pDev, bool EnableRecv, bool AsyncMode)
+static int DevDoEnableDisableRecvOverride(struct ar6k_device *pDev, bool EnableRecv, bool AsyncMode)
 {
     int                  status = 0;
     HTC_PACKET                *pIOPacket = NULL;
@@ -403,7 +403,7 @@ static int DevDoEnableDisableRecvOverride(AR6K_DEVICE *pDev, bool EnableRecv, bo
 /* disable packet reception (used in case the host runs out of buffers)
  * this is the "normal" method using the interrupt enable registers through
  * the host I/F */
-static int DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, bool EnableRecv, bool AsyncMode)
+static int DevDoEnableDisableRecvNormal(struct ar6k_device *pDev, bool EnableRecv, bool AsyncMode)
 {
     int                  status = 0;
     HTC_PACKET                *pIOPacket = NULL;
@@ -470,7 +470,7 @@ static int DevDoEnableDisableRecvNormal(AR6K_DEVICE *pDev, bool EnableRecv, bool
 }
 
 
-int DevStopRecv(AR6K_DEVICE *pDev, bool AsyncMode)
+int DevStopRecv(struct ar6k_device *pDev, bool AsyncMode)
 {
     if (NULL == pDev->HifMaskUmaskRecvEvent) {
         return DevDoEnableDisableRecvNormal(pDev,false,AsyncMode);
@@ -479,7 +479,7 @@ int DevStopRecv(AR6K_DEVICE *pDev, bool AsyncMode)
     }
 }
 
-int DevEnableRecv(AR6K_DEVICE *pDev, bool AsyncMode)
+int DevEnableRecv(struct ar6k_device *pDev, bool AsyncMode)
 {
     if (NULL == pDev->HifMaskUmaskRecvEvent) {
         return DevDoEnableDisableRecvNormal(pDev,true,AsyncMode);
@@ -488,7 +488,7 @@ int DevEnableRecv(AR6K_DEVICE *pDev, bool AsyncMode)
     }
 }
 
-int DevWaitForPendingRecv(AR6K_DEVICE *pDev,u32 TimeoutInMs,bool *pbIsRecvPending)
+int DevWaitForPendingRecv(struct ar6k_device *pDev,u32 TimeoutInMs,bool *pbIsRecvPending)
 {
     int    status          = 0;
     u8     host_int_status = 0x0;
@@ -536,7 +536,7 @@ int DevWaitForPendingRecv(AR6K_DEVICE *pDev,u32 TimeoutInMs,bool *pbIsRecvPendin
     return status;
 }
 
-void DevDumpRegisters(AR6K_DEVICE               *pDev,
+void DevDumpRegisters(struct ar6k_device               *pDev,
                       AR6K_IRQ_PROC_REGISTERS   *pIrqProcRegs,
                       AR6K_IRQ_ENABLE_REGISTERS *pIrqEnableRegs)
 {
@@ -590,7 +590,7 @@ void DevDumpRegisters(AR6K_DEVICE               *pDev,
 static HIF_SCATTER_REQ *DevAllocScatterReq(HIF_DEVICE *Context)
 {
     DL_LIST *pItem;
-    AR6K_DEVICE *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device *pDev = (struct ar6k_device *)Context;
     LOCK_AR6K(pDev);
     pItem = DL_ListRemoveItemFromHead(&pDev->ScatterReqHead);
     UNLOCK_AR6K(pDev);
@@ -602,7 +602,7 @@ static HIF_SCATTER_REQ *DevAllocScatterReq(HIF_DEVICE *Context)
 
 static void DevFreeScatterReq(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
 {
-    AR6K_DEVICE *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device *pDev = (struct ar6k_device *)Context;
     LOCK_AR6K(pDev);
     DL_ListInsertTail(&pDev->ScatterReqHead, &pReq->ListLink);
     UNLOCK_AR6K(pDev);
@@ -650,7 +650,7 @@ int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, bool FromDMA)
 
 static void DevReadWriteScatterAsyncHandler(void *Context, HTC_PACKET *pPacket)
 {
-    AR6K_DEVICE     *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device     *pDev = (struct ar6k_device *)Context;
     HIF_SCATTER_REQ *pReq = (HIF_SCATTER_REQ *)pPacket->pPktContext;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("+DevReadWriteScatterAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
@@ -666,7 +666,7 @@ static void DevReadWriteScatterAsyncHandler(void *Context, HTC_PACKET *pPacket)
 
 static int DevReadWriteScatter(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
 {
-    AR6K_DEVICE     *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device     *pDev = (struct ar6k_device *)Context;
     int        status = 0;
     HTC_PACKET      *pIOPacket = NULL;
     u32 request = pReq->Request;
@@ -734,7 +734,7 @@ static int DevReadWriteScatter(HIF_DEVICE *Context, HIF_SCATTER_REQ *pReq)
 }
 
 
-static void DevCleanupVirtualScatterSupport(AR6K_DEVICE *pDev)
+static void DevCleanupVirtualScatterSupport(struct ar6k_device *pDev)
 {
     HIF_SCATTER_REQ *pReq;
 
@@ -749,7 +749,7 @@ static void DevCleanupVirtualScatterSupport(AR6K_DEVICE *pDev)
 }
 
     /* function to set up virtual scatter support if HIF layer has not implemented the interface */
-static int DevSetupVirtualScatterSupport(AR6K_DEVICE *pDev)
+static int DevSetupVirtualScatterSupport(struct ar6k_device *pDev)
 {
     int                     status = 0;
     int                          bufferSize, sgreqSize;
@@ -810,7 +810,7 @@ static int DevSetupVirtualScatterSupport(AR6K_DEVICE *pDev)
     return status;
 }
 
-int DevCleanupMsgBundling(AR6K_DEVICE *pDev)
+int DevCleanupMsgBundling(struct ar6k_device *pDev)
 {
     if(NULL != pDev)
     {
@@ -820,7 +820,7 @@ int DevCleanupMsgBundling(AR6K_DEVICE *pDev)
     return 0;
 }
 
-int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
+int DevSetupMsgBundling(struct ar6k_device *pDev, int MaxMsgsPerTransfer)
 {
     int status;
 
@@ -885,7 +885,7 @@ int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
     return status;
 }
 
-int DevSubmitScatterRequest(AR6K_DEVICE *pDev, HIF_SCATTER_REQ *pScatterReq, bool Read, bool Async)
+int DevSubmitScatterRequest(struct ar6k_device *pDev, HIF_SCATTER_REQ *pScatterReq, bool Read, bool Async)
 {
     int status;
 
@@ -1134,7 +1134,7 @@ static u16 GetEndMarker(void)
 #define ATH_PRINT_OUT_ZONE ATH_DEBUG_ERR
 
 /* send the ordered buffers to the target */
-static int SendBuffers(AR6K_DEVICE *pDev, int mbox)
+static int SendBuffers(struct ar6k_device *pDev, int mbox)
 {
     int         status = 0;
     u32 request = HIF_WR_SYNC_BLOCK_INC;
@@ -1178,7 +1178,7 @@ static int SendBuffers(AR6K_DEVICE *pDev, int mbox)
 }
 
 /* poll the mailbox credit counter until we get a credit or timeout */
-static int GetCredits(AR6K_DEVICE *pDev, int mbox, int *pCredits)
+static int GetCredits(struct ar6k_device *pDev, int mbox, int *pCredits)
 {
     int status = 0;
     int      timeout = TEST_CREDITS_RECV_TIMEOUT;
@@ -1225,7 +1225,7 @@ static int GetCredits(AR6K_DEVICE *pDev, int mbox, int *pCredits)
 
 
 /* wait for the buffers to come back */
-static int RecvBuffers(AR6K_DEVICE *pDev, int mbox)
+static int RecvBuffers(struct ar6k_device *pDev, int mbox)
 {
     int         status = 0;
     u32 request = HIF_RD_SYNC_BLOCK_INC;
@@ -1303,7 +1303,7 @@ static int RecvBuffers(AR6K_DEVICE *pDev, int mbox)
 
 }
 
-static int DoOneMboxHWTest(AR6K_DEVICE *pDev, int mbox)
+static int DoOneMboxHWTest(struct ar6k_device *pDev, int mbox)
 {
     int status;
 
@@ -1339,7 +1339,7 @@ static int DoOneMboxHWTest(AR6K_DEVICE *pDev, int mbox)
 }
 
 /* here is where the test starts */
-int DoMboxHWTest(AR6K_DEVICE *pDev)
+int DoMboxHWTest(struct ar6k_device *pDev)
 {
     int      i;
     int status;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index e0c3926..ebcc82b 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -105,7 +105,7 @@ typedef struct _AR6K_GMBOX_INFO {
     bool      CreditCountIRQEnabled;
 } AR6K_GMBOX_INFO; 
 
-typedef struct _AR6K_DEVICE {
+struct ar6k_device {
     A_MUTEX_T                   Lock;
     u8 _Pad1[A_CACHE_LINE_PAD];
     AR6K_IRQ_PROC_REGISTERS     IrqProcRegisters;   /* cache-line safe with pads around */
@@ -141,24 +141,24 @@ typedef struct _AR6K_DEVICE {
     bool                          GMboxEnabled;
     AR6K_GMBOX_CTRL_REGISTERS       GMboxControlRegisters;
     int                             RecheckIRQStatusCnt;
-} AR6K_DEVICE;
+};
 
 #define LOCK_AR6K(p)      A_MUTEX_LOCK(&(p)->Lock);
 #define UNLOCK_AR6K(p)    A_MUTEX_UNLOCK(&(p)->Lock);
 #define REF_IRQ_STATUS_RECHECK(p) (p)->RecheckIRQStatusCnt = 1  /* note: no need to lock this, it only gets set */
 
-int DevSetup(AR6K_DEVICE *pDev);
-void     DevCleanup(AR6K_DEVICE *pDev);
-int DevUnmaskInterrupts(AR6K_DEVICE *pDev);
-int DevMaskInterrupts(AR6K_DEVICE *pDev);
-int DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
+int DevSetup(struct ar6k_device *pDev);
+void     DevCleanup(struct ar6k_device *pDev);
+int DevUnmaskInterrupts(struct ar6k_device *pDev);
+int DevMaskInterrupts(struct ar6k_device *pDev);
+int DevPollMboxMsgRecv(struct ar6k_device *pDev,
                             u32 *pLookAhead,
                             int          TimeoutMS);
 int DevRWCompletionHandler(void *context, int status);
 int DevDsrHandler(void *context);
 int DevCheckPendingRecvMsgsAsync(void *context);
-void     DevAsyncIrqProcessComplete(AR6K_DEVICE *pDev);
-void     DevDumpRegisters(AR6K_DEVICE               *pDev,
+void     DevAsyncIrqProcessComplete(struct ar6k_device *pDev);
+void     DevDumpRegisters(struct ar6k_device               *pDev,
                           AR6K_IRQ_PROC_REGISTERS   *pIrqProcRegs,
                           AR6K_IRQ_ENABLE_REGISTERS *pIrqEnableRegs);
 
@@ -166,17 +166,17 @@ void     DevDumpRegisters(AR6K_DEVICE               *pDev,
 #define DEV_STOP_RECV_SYNC  false
 #define DEV_ENABLE_RECV_ASYNC true
 #define DEV_ENABLE_RECV_SYNC  false
-int DevStopRecv(AR6K_DEVICE *pDev, bool ASyncMode);
-int DevEnableRecv(AR6K_DEVICE *pDev, bool ASyncMode);
-int DevEnableInterrupts(AR6K_DEVICE *pDev);
-int DevDisableInterrupts(AR6K_DEVICE *pDev);
-int DevWaitForPendingRecv(AR6K_DEVICE *pDev,u32 TimeoutInMs,bool *pbIsRecvPending);
+int DevStopRecv(struct ar6k_device *pDev, bool ASyncMode);
+int DevEnableRecv(struct ar6k_device *pDev, bool ASyncMode);
+int DevEnableInterrupts(struct ar6k_device *pDev);
+int DevDisableInterrupts(struct ar6k_device *pDev);
+int DevWaitForPendingRecv(struct ar6k_device *pDev,u32 TimeoutInMs,bool *pbIsRecvPending);
 
 #define DEV_CALC_RECV_PADDED_LEN(pDev, length) (((length) + (pDev)->BlockMask) & (~((pDev)->BlockMask)))
 #define DEV_CALC_SEND_PADDED_LEN(pDev, length) DEV_CALC_RECV_PADDED_LEN(pDev,length)
 #define DEV_IS_LEN_BLOCK_ALIGNED(pDev, length) (((length) % (pDev)->BlockSize) == 0)
 
-static INLINE int DevSendPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 SendLength) {
+static INLINE int DevSendPacket(struct ar6k_device *pDev, HTC_PACKET *pPacket, u32 SendLength) {
     u32 paddedLength;
     bool   sync = (pPacket->Completion == NULL) ? true : false;
     int status;
@@ -219,7 +219,7 @@ static INLINE int DevSendPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 Send
     return status;
 }
                     
-static INLINE int DevRecvPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 RecvLength) {
+static INLINE int DevRecvPacket(struct ar6k_device *pDev, HTC_PACKET *pPacket, u32 RecvLength) {
     u32 paddedLength;
     int status;
     bool   sync = (pPacket->Completion == NULL) ? true : false;
@@ -296,9 +296,9 @@ static INLINE int DEV_PREPARE_SCATTER_OPERATION(HIF_SCATTER_REQ *pReq)  {
 }
         
     
-int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer);
+int DevSetupMsgBundling(struct ar6k_device *pDev, int MaxMsgsPerTransfer);
 
-int DevCleanupMsgBundling(AR6K_DEVICE *pDev);
+int DevCleanupMsgBundling(struct ar6k_device *pDev);
                                   
 #define DEV_GET_MAX_MSG_PER_BUNDLE(pDev)        (pDev)->HifScatterInfo.MaxScatterEntries
 #define DEV_GET_MAX_BUNDLE_LENGTH(pDev)         (pDev)->HifScatterInfo.MaxTransferSizePerScatterReq
@@ -315,10 +315,10 @@ int DevCleanupMsgBundling(AR6K_DEVICE *pDev);
 #define DEV_SCATTER_WRITE false
 #define DEV_SCATTER_ASYNC true
 #define DEV_SCATTER_SYNC  false
-int DevSubmitScatterRequest(AR6K_DEVICE *pDev, HIF_SCATTER_REQ *pScatterReq, bool Read, bool Async);
+int DevSubmitScatterRequest(struct ar6k_device *pDev, HIF_SCATTER_REQ *pScatterReq, bool Read, bool Async);
 
 #ifdef MBOXHW_UNIT_TEST
-int DoMboxHWTest(AR6K_DEVICE *pDev);
+int DoMboxHWTest(struct ar6k_device *pDev);
 #endif
 
     /* completely virtual */
@@ -329,7 +329,7 @@ typedef struct _DEV_SCATTER_DMA_VIRTUAL_INFO {
 
 
 
-void     DumpAR6KDevState(AR6K_DEVICE *pDev);
+void     DumpAR6KDevState(struct ar6k_device *pDev);
 
 /**************************************************/
 /****** GMBOX functions and definitions
@@ -339,10 +339,10 @@ void     DumpAR6KDevState(AR6K_DEVICE *pDev);
 
 #ifdef ATH_AR6K_ENABLE_GMBOX
 
-void     DevCleanupGMbox(AR6K_DEVICE *pDev);
-int DevSetupGMbox(AR6K_DEVICE *pDev);
-int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev);
-void     DevNotifyGMboxTargetFailure(AR6K_DEVICE *pDev);
+void     DevCleanupGMbox(struct ar6k_device *pDev);
+int DevSetupGMbox(struct ar6k_device *pDev);
+int DevCheckGMboxInterrupts(struct ar6k_device *pDev);
+void     DevNotifyGMboxTargetFailure(struct ar6k_device *pDev);
 
 #else
 
@@ -351,7 +351,7 @@ void     DevNotifyGMboxTargetFailure(AR6K_DEVICE *pDev);
 #define DevCheckGMboxInterrupts(p) 0
 #define DevNotifyGMboxTargetFailure(p)
 
-static INLINE int DevSetupGMbox(AR6K_DEVICE *pDev) {
+static INLINE int DevSetupGMbox(struct ar6k_device *pDev) {
     pDev->GMboxEnabled = false;
     return 0;
 }
@@ -361,12 +361,12 @@ static INLINE int DevSetupGMbox(AR6K_DEVICE *pDev) {
 #ifdef ATH_AR6K_ENABLE_GMBOX
 
     /* GMBOX protocol modules must expose each of these internal APIs */
-HCI_TRANSPORT_HANDLE GMboxAttachProtocol(AR6K_DEVICE *pDev, HCI_TRANSPORT_CONFIG_INFO *pInfo);
-int             GMboxProtocolInstall(AR6K_DEVICE *pDev);
-void                 GMboxProtocolUninstall(AR6K_DEVICE *pDev);
+HCI_TRANSPORT_HANDLE GMboxAttachProtocol(struct ar6k_device *pDev, HCI_TRANSPORT_CONFIG_INFO *pInfo);
+int             GMboxProtocolInstall(struct ar6k_device *pDev);
+void                 GMboxProtocolUninstall(struct ar6k_device *pDev);
 
     /* API used by GMBOX protocol modules */
-AR6K_DEVICE  *HTCGetAR6KDevice(void *HTCHandle);
+struct ar6k_device  *HTCGetAR6KDevice(void *HTCHandle);
 #define DEV_GMBOX_SET_PROTOCOL(pDev,recv_callback,credits_pending,failure,statedump,context) \
 {                                                                  \
     (pDev)->GMboxInfo.pProtocolContext = (context);                \
@@ -378,8 +378,8 @@ AR6K_DEVICE  *HTCGetAR6KDevice(void *HTCHandle);
 
 #define DEV_GMBOX_GET_PROTOCOL(pDev)  (pDev)->GMboxInfo.pProtocolContext
 
-int DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 WriteLength);
-int DevGMboxRead(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 ReadLength);
+int DevGMboxWrite(struct ar6k_device *pDev, HTC_PACKET *pPacket, u32 WriteLength);
+int DevGMboxRead(struct ar6k_device *pDev, HTC_PACKET *pPacket, u32 ReadLength);
 
 #define PROC_IO_ASYNC true
 #define PROC_IO_SYNC  false
@@ -393,11 +393,11 @@ typedef enum GMBOX_IRQ_ACTION_TYPE {
     GMBOX_CREDIT_IRQ_DISABLE,
 } GMBOX_IRQ_ACTION_TYPE;
 
-int DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE, bool AsyncMode);
-int DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, bool AsyncMode, int *pCredits);
-int DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize);
-int DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, u8 *pLookAheadBuffer, int *pLookAheadBytes);
-int DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int SignalNumber, int AckTimeoutMS);
+int DevGMboxIRQAction(struct ar6k_device *pDev, GMBOX_IRQ_ACTION_TYPE, bool AsyncMode);
+int DevGMboxReadCreditCounter(struct ar6k_device *pDev, bool AsyncMode, int *pCredits);
+int DevGMboxReadCreditSize(struct ar6k_device *pDev, int *pCreditSize);
+int DevGMboxRecvLookAheadPeek(struct ar6k_device *pDev, u8 *pLookAheadBuffer, int *pLookAheadBytes);
+int DevGMboxSetTargetInterrupt(struct ar6k_device *pDev, int SignalNumber, int AckTimeoutMS);
 
 #endif
 
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index bee4850..aa45590 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -33,10 +33,10 @@
 #include "htc_packet.h"
 #include "ar6k.h"
 
-extern void AR6KFreeIOPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket);
-extern HTC_PACKET *AR6KAllocIOPacket(AR6K_DEVICE *pDev);
+extern void AR6KFreeIOPacket(struct ar6k_device *pDev, HTC_PACKET *pPacket);
+extern HTC_PACKET *AR6KAllocIOPacket(struct ar6k_device *pDev);
 
-static int DevServiceDebugInterrupt(AR6K_DEVICE *pDev);
+static int DevServiceDebugInterrupt(struct ar6k_device *pDev);
 
 #define DELAY_PER_INTERVAL_MS 10  /* 10 MS delay per polling interval */
 
@@ -59,7 +59,7 @@ int DevRWCompletionHandler(void *context, int status)
 }
 
 /* mailbox recv message polling */
-int DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
+int DevPollMboxMsgRecv(struct ar6k_device *pDev,
                             u32 *pLookAhead,
                             int          TimeoutMS)
 {
@@ -152,7 +152,7 @@ int DevPollMboxMsgRecv(AR6K_DEVICE *pDev,
     return status;
 }
 
-static int DevServiceCPUInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceCPUInterrupt(struct ar6k_device *pDev)
 {
     int status;
     u8 cpu_int_status;
@@ -192,7 +192,7 @@ static int DevServiceCPUInterrupt(AR6K_DEVICE *pDev)
 }
 
 
-static int DevServiceErrorInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceErrorInterrupt(struct ar6k_device *pDev)
 {
     int status;
     u8 error_int_status;
@@ -245,7 +245,7 @@ static int DevServiceErrorInterrupt(AR6K_DEVICE *pDev)
     return status;
 }
 
-static int DevServiceDebugInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceDebugInterrupt(struct ar6k_device *pDev)
 {
     u32 dummy;
     int status;
@@ -275,7 +275,7 @@ static int DevServiceDebugInterrupt(AR6K_DEVICE *pDev)
     return status;
 }
 
-static int DevServiceCounterInterrupt(AR6K_DEVICE *pDev)
+static int DevServiceCounterInterrupt(struct ar6k_device *pDev)
 {
     u8 counter_int_status;
 
@@ -302,7 +302,7 @@ static int DevServiceCounterInterrupt(AR6K_DEVICE *pDev)
 /* callback when our fetch to get interrupt status registers completes */
 static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
 {
-    AR6K_DEVICE *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device *pDev = (struct ar6k_device *)Context;
     u32 lookAhead = 0;
     bool      otherInts = false;
 
@@ -390,7 +390,7 @@ static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
  * recv messages, this starts off a series of async requests to read interrupt registers  */
 int DevCheckPendingRecvMsgsAsync(void *context)
 {
-    AR6K_DEVICE  *pDev = (AR6K_DEVICE *)context;
+    struct ar6k_device  *pDev = (struct ar6k_device *)context;
     int      status = 0;
     HTC_PACKET   *pIOPacket;
 
@@ -460,14 +460,14 @@ int DevCheckPendingRecvMsgsAsync(void *context)
    return status;
 }
 
-void DevAsyncIrqProcessComplete(AR6K_DEVICE *pDev)
+void DevAsyncIrqProcessComplete(struct ar6k_device *pDev)
 {
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("DevAsyncIrqProcessComplete - forcing HIF IRQ ACK \n"));
     HIFAckInterrupt(pDev->HIFDevice);
 }
 
 /* process pending interrupts synchronously */
-static int ProcessPendingIRQs(AR6K_DEVICE *pDev, bool *pDone, bool *pASyncProcessing)
+static int ProcessPendingIRQs(struct ar6k_device *pDev, bool *pDone, bool *pASyncProcessing)
 {
     int    status = 0;
     u8 host_int_status = 0;
@@ -683,7 +683,7 @@ static int ProcessPendingIRQs(AR6K_DEVICE *pDev, bool *pDone, bool *pASyncProces
 /* Synchronousinterrupt handler, this handler kicks off all interrupt processing.*/
 int DevDsrHandler(void *context)
 {
-    AR6K_DEVICE *pDev = (AR6K_DEVICE *)context;
+    struct ar6k_device *pDev = (struct ar6k_device *)context;
     int    status = 0;
     bool      done = false;
     bool      asyncProc = false;
@@ -744,7 +744,7 @@ int DevDsrHandler(void *context)
 }
 
 #ifdef ATH_DEBUG_MODULE
-void DumpAR6KDevState(AR6K_DEVICE *pDev)
+void DumpAR6KDevState(struct ar6k_device *pDev)
 {
     int                    status;
     AR6K_IRQ_ENABLE_REGISTERS   regs;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
index 46bcb27..cbfbdea 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
@@ -54,14 +54,14 @@
 
 
     /* external APIs for allocating and freeing internal I/O packets to handle ASYNC I/O */ 
-extern void AR6KFreeIOPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket);
-extern HTC_PACKET *AR6KAllocIOPacket(AR6K_DEVICE *pDev);
+extern void AR6KFreeIOPacket(struct ar6k_device *pDev, HTC_PACKET *pPacket);
+extern HTC_PACKET *AR6KAllocIOPacket(struct ar6k_device *pDev);
 
 
 /* callback when our fetch to enable/disable completes */
 static void DevGMboxIRQActionAsyncHandler(void *Context, HTC_PACKET *pPacket)
 {
-    AR6K_DEVICE *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device *pDev = (struct ar6k_device *)Context;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("+DevGMboxIRQActionAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
 
@@ -74,7 +74,7 @@ static void DevGMboxIRQActionAsyncHandler(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("-DevGMboxIRQActionAsyncHandler \n"));
 }
 
-static int DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, bool AsyncMode)
+static int DevGMboxCounterEnableDisable(struct ar6k_device *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, bool AsyncMode)
 {
     int                  status = 0;
     AR6K_IRQ_ENABLE_REGISTERS regs;
@@ -155,7 +155,7 @@ static int DevGMboxCounterEnableDisable(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE
 }
 
 
-int DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, bool AsyncMode)
+int DevGMboxIRQAction(struct ar6k_device *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, bool AsyncMode)
 {
     int      status = 0;
     HTC_PACKET    *pIOPacket = NULL;   
@@ -261,7 +261,7 @@ int DevGMboxIRQAction(AR6K_DEVICE *pDev, GMBOX_IRQ_ACTION_TYPE IrqAction, bool A
     return status;
 }
 
-void DevCleanupGMbox(AR6K_DEVICE *pDev)
+void DevCleanupGMbox(struct ar6k_device *pDev)
 {
     if (pDev->GMboxEnabled) {
         pDev->GMboxEnabled = false;
@@ -269,7 +269,7 @@ void DevCleanupGMbox(AR6K_DEVICE *pDev)
     }
 }
 
-int DevSetupGMbox(AR6K_DEVICE *pDev)
+int DevSetupGMbox(struct ar6k_device *pDev)
 {
     int    status = 0;
     u8 muxControl[4];
@@ -322,7 +322,7 @@ int DevSetupGMbox(AR6K_DEVICE *pDev)
     return status;
 }
 
-int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
+int DevCheckGMboxInterrupts(struct ar6k_device *pDev)
 {
     int status = 0;
     u8 counter_int_status;
@@ -396,7 +396,7 @@ int DevCheckGMboxInterrupts(AR6K_DEVICE *pDev)
 }
 
 
-int DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 WriteLength)
+int DevGMboxWrite(struct ar6k_device *pDev, HTC_PACKET *pPacket, u32 WriteLength)
 {
     u32 paddedLength;
     bool   sync = (pPacket->Completion == NULL) ? true : false;
@@ -433,7 +433,7 @@ int DevGMboxWrite(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 WriteLength)
     return status;
 }
 
-int DevGMboxRead(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, u32 ReadLength)
+int DevGMboxRead(struct ar6k_device *pDev, HTC_PACKET *pPacket, u32 ReadLength)
 {
     
     u32 paddedLength;
@@ -518,7 +518,7 @@ static int ProcessCreditCounterReadBuffer(u8 *pBuffer, int Length)
 /* callback when our fetch to enable/disable completes */
 static void DevGMboxReadCreditsAsyncHandler(void *Context, HTC_PACKET *pPacket)
 {
-    AR6K_DEVICE *pDev = (AR6K_DEVICE *)Context;
+    struct ar6k_device *pDev = (struct ar6k_device *)Context;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("+DevGMboxReadCreditsAsyncHandler: (dev: 0x%lX)\n", (unsigned long)pDev));
 
@@ -539,7 +539,7 @@ static void DevGMboxReadCreditsAsyncHandler(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("-DevGMboxReadCreditsAsyncHandler \n"));
 }
 
-int DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, bool AsyncMode, int *pCredits)
+int DevGMboxReadCreditCounter(struct ar6k_device *pDev, bool AsyncMode, int *pCredits)
 {
     int    status = 0;
     HTC_PACKET  *pIOPacket = NULL;  
@@ -602,7 +602,7 @@ int DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, bool AsyncMode, int *pCredits)
     return status;
 }
 
-int DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize)
+int DevGMboxReadCreditSize(struct ar6k_device *pDev, int *pCreditSize)
 {
     int    status;
     u8 buffer[4];
@@ -626,7 +626,7 @@ int DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize)
     return status;
 }
 
-void DevNotifyGMboxTargetFailure(AR6K_DEVICE *pDev)
+void DevNotifyGMboxTargetFailure(struct ar6k_device *pDev)
 {
         /* Target ASSERTED!!! */
     if (pDev->GMboxInfo.pTargetFailureCallback != NULL) {
@@ -634,7 +634,7 @@ void DevNotifyGMboxTargetFailure(AR6K_DEVICE *pDev)
     }
 }
 
-int DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, u8 *pLookAheadBuffer, int *pLookAheadBytes)
+int DevGMboxRecvLookAheadPeek(struct ar6k_device *pDev, u8 *pLookAheadBuffer, int *pLookAheadBytes)
 {
 
     int                    status = 0;
@@ -676,7 +676,7 @@ int DevGMboxRecvLookAheadPeek(AR6K_DEVICE *pDev, u8 *pLookAheadBuffer, int *pLoo
     return status; 
 }
 
-int DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int Signal, int AckTimeoutMS)
+int DevGMboxSetTargetInterrupt(struct ar6k_device *pDev, int Signal, int AckTimeoutMS)
 {
     int status = 0;
     int      i;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 177f04d..3ee3d40 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -66,7 +66,7 @@ typedef struct {
     HTC_PACKET_QUEUE            SendQueue;         /* write queue holding HCI Command and ACL packets */
     HTC_PACKET_QUEUE            HCIACLRecvBuffers;  /* recv queue holding buffers for incomming ACL packets */
     HTC_PACKET_QUEUE            HCIEventBuffers;    /* recv queue holding buffers for incomming event packets */
-    AR6K_DEVICE                 *pDev;
+    struct ar6k_device                 *pDev;
     A_MUTEX_T                   HCIRxLock;
     A_MUTEX_T                   HCITxLock;
     int                         CreditsMax;
@@ -846,7 +846,7 @@ static void FlushRecvBuffers(GMBOX_PROTO_HCI_UART *pProt)
 
 /*** protocol module install entry point ***/
 
-int GMboxProtocolInstall(AR6K_DEVICE *pDev)
+int GMboxProtocolInstall(struct ar6k_device *pDev)
 {
     int                status = 0;
     GMBOX_PROTO_HCI_UART    *pProtocol = NULL;
@@ -889,7 +889,7 @@ int GMboxProtocolInstall(AR6K_DEVICE *pDev)
 }
 
 /*** protocol module uninstall entry point ***/
-void GMboxProtocolUninstall(AR6K_DEVICE *pDev)
+void GMboxProtocolUninstall(struct ar6k_device *pDev)
 {
     GMBOX_PROTO_HCI_UART *pProtocol = (GMBOX_PROTO_HCI_UART *)DEV_GMBOX_GET_PROTOCOL(pDev);
     
@@ -939,7 +939,7 @@ static int NotifyTransportReady(GMBOX_PROTO_HCI_UART  *pProt)
 HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo)
 {
     GMBOX_PROTO_HCI_UART  *pProtocol = NULL; 
-    AR6K_DEVICE           *pDev;
+    struct ar6k_device           *pDev;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("+HCI_TransportAttach \n"));
     
@@ -984,7 +984,7 @@ HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_I
 void HCI_TransportDetach(HCI_TRANSPORT_HANDLE HciTrans)
 {
     GMBOX_PROTO_HCI_UART  *pProtocol = (GMBOX_PROTO_HCI_UART *)HciTrans; 
-    AR6K_DEVICE           *pDev = pProtocol->pDev;
+    struct ar6k_device           *pDev = pProtocol->pDev;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("+HCI_TransportDetach \n"));
     
diff --git a/drivers/staging/ath6kl/htc2/htc.c b/drivers/staging/ath6kl/htc2/htc.c
index c200cfd..8bde7bf 100644
--- a/drivers/staging/ath6kl/htc2/htc.c
+++ b/drivers/staging/ath6kl/htc2/htc.c
@@ -573,7 +573,7 @@ bool HTCGetEndpointStatistics(HTC_HANDLE               HTCHandle,
 #endif
 }
 
-AR6K_DEVICE  *HTCGetAR6KDevice(void *HTCHandle)
+struct ar6k_device  *HTCGetAR6KDevice(void *HTCHandle)
 {
     HTC_TARGET *target = GET_HTC_TARGET_FROM_HANDLE(HTCHandle);
     return &target->Device;
diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index 73f6ed9..8bc3162 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -122,7 +122,7 @@ typedef struct _HTC_TARGET {
     A_MUTEX_T                   HTCLock;
     A_MUTEX_T                   HTCRxLock;
     A_MUTEX_T                   HTCTxLock;
-    AR6K_DEVICE                 Device;         /* AR6K - specific state */
+    struct ar6k_device                 Device;         /* AR6K - specific state */
     u32 OpStateFlags;
     u32 RecvStateFlags;
     HTC_ENDPOINT_ID             EpWaitingForBuffers;
-- 
1.7.4.15.g7811d

