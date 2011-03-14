Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23151 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab1CNSQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:16:52 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:16:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/38] ath6kl: remove-typedef GMBOX_PROTO_HCI_UART
Date: Mon, 14 Mar 2011 11:03:15 -0700
Message-ID: <1300125795-24499-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s GMBOX_PROTO_HCI_UART \
	"struct gmbox_proto_hci_uart" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |   60 ++++++++++----------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 3ee3d40..78da8a1 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -56,7 +56,7 @@
 #define BAUD_TIMEOUT_MS           1
 #define BTPWRSAV_TIMEOUT_MS       1  
 
-typedef struct {
+struct gmbox_proto_hci_uart {
     HCI_TRANSPORT_CONFIG_INFO   HCIConfig;
     bool                      HCIAttached;
     bool                      HCIStopped;
@@ -75,7 +75,7 @@ typedef struct {
     int                         CreditSize;
     int                         CreditsCurrentSeek;
     int                         SendProcessCount;
-} GMBOX_PROTO_HCI_UART;
+};
 
 #define LOCK_HCI_RX(t)   A_MUTEX_LOCK(&(t)->HCIRxLock);
 #define UNLOCK_HCI_RX(t) A_MUTEX_UNLOCK(&(t)->HCIRxLock);
@@ -99,9 +99,9 @@ do {								\
     (p)->HCIConfig.pHCISendComplete((p)->HCIConfig.pContext, (pt));                            \
 }
     
-static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, bool Synchronous);
+static int HCITrySend(struct gmbox_proto_hci_uart *pProt, HTC_PACKET *pPacket, bool Synchronous);
 
-static void HCIUartCleanup(GMBOX_PROTO_HCI_UART *pProtocol)
+static void HCIUartCleanup(struct gmbox_proto_hci_uart *pProtocol)
 {
     A_ASSERT(pProtocol != NULL);
     
@@ -111,7 +111,7 @@ static void HCIUartCleanup(GMBOX_PROTO_HCI_UART *pProtocol)
     A_FREE(pProtocol);    
 }
 
-static int InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
+static int InitTxCreditState(struct gmbox_proto_hci_uart *pProt)
 {
     int    status;
     int         credits;
@@ -191,7 +191,7 @@ static int InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
 
 static int CreditsAvailableCallback(void *pContext, int Credits, bool CreditIRQEnabled)
 {
-    GMBOX_PROTO_HCI_UART *pProt = (GMBOX_PROTO_HCI_UART *)pContext;    
+    struct gmbox_proto_hci_uart *pProt = (struct gmbox_proto_hci_uart *)pContext;    
     bool               enableCreditIrq = false;
     bool               disableCreditIrq = false;
     bool               doPendingSends = false;
@@ -274,7 +274,7 @@ static int CreditsAvailableCallback(void *pContext, int Credits, bool CreditIRQE
     return status;
 }
 
-static INLINE void NotifyTransportFailure(GMBOX_PROTO_HCI_UART  *pProt, int status)
+static INLINE void NotifyTransportFailure(struct gmbox_proto_hci_uart  *pProt, int status)
 {
     if (pProt->HCIConfig.TransportFailure != NULL) {
         pProt->HCIConfig.TransportFailure(pProt->HCIConfig.pContext, status);
@@ -283,7 +283,7 @@ static INLINE void NotifyTransportFailure(GMBOX_PROTO_HCI_UART  *pProt, int stat
 
 static void FailureCallback(void *pContext, int Status)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)pContext; 
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)pContext; 
     
         /* target assertion occured */           
     NotifyTransportFailure(pProt, Status);  
@@ -291,7 +291,7 @@ static void FailureCallback(void *pContext, int Status)
 
 static void StateDumpCallback(void *pContext)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)pContext;
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)pContext;
    
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY,("============ HCIUart State ======================\n"));    
     AR_DEBUG_PRINTF(ATH_DEBUG_ANY,("RecvStateFlags   :  0x%X \n",pProt->RecvStateFlags));
@@ -306,7 +306,7 @@ static void StateDumpCallback(void *pContext)
 
 static int HCIUartMessagePending(void *pContext, u8 LookAheadBytes[], int ValidBytes)
 {
-    GMBOX_PROTO_HCI_UART        *pProt = (GMBOX_PROTO_HCI_UART *)pContext;
+    struct gmbox_proto_hci_uart        *pProt = (struct gmbox_proto_hci_uart *)pContext;
     int                    status = 0;
     int                         totalRecvLength = 0;
     HCI_TRANSPORT_PACKET_TYPE   pktType = HCI_PACKET_INVALID;
@@ -534,7 +534,7 @@ static int HCIUartMessagePending(void *pContext, u8 LookAheadBytes[], int ValidB
 
 static void HCISendPacketCompletion(void *Context, HTC_PACKET *pPacket)
 {
-    GMBOX_PROTO_HCI_UART *pProt = (GMBOX_PROTO_HCI_UART *)Context;
+    struct gmbox_proto_hci_uart *pProt = (struct gmbox_proto_hci_uart *)Context;
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND,("+HCISendPacketCompletion (pPacket:0x%lX) \n",(unsigned long)pPacket));
     
     if (pPacket->Status) {
@@ -547,7 +547,7 @@ static void HCISendPacketCompletion(void *Context, HTC_PACKET *pPacket)
     AR_DEBUG_PRINTF(ATH_DEBUG_SEND,("+HCISendPacketCompletion \n"));
 }
 
-static int SeekCreditsSynch(GMBOX_PROTO_HCI_UART *pProt)
+static int SeekCreditsSynch(struct gmbox_proto_hci_uart *pProt)
 {
     int status = 0;
     int      credits;
@@ -579,7 +579,7 @@ static int SeekCreditsSynch(GMBOX_PROTO_HCI_UART *pProt)
     return status;
 }
 
-static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, bool Synchronous)
+static int HCITrySend(struct gmbox_proto_hci_uart *pProt, HTC_PACKET *pPacket, bool Synchronous)
 {   
     int    status = 0;
     int         transferLength;
@@ -794,7 +794,7 @@ static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, bool Syn
     return status;    
 }
 
-static void FlushSendQueue(GMBOX_PROTO_HCI_UART *pProt)
+static void FlushSendQueue(struct gmbox_proto_hci_uart *pProt)
 {
     HTC_PACKET          *pPacket;
     HTC_PACKET_QUEUE    discardQueue;
@@ -818,7 +818,7 @@ static void FlushSendQueue(GMBOX_PROTO_HCI_UART *pProt)
     
 }
 
-static void FlushRecvBuffers(GMBOX_PROTO_HCI_UART *pProt)
+static void FlushRecvBuffers(struct gmbox_proto_hci_uart *pProt)
 {
     HTC_PACKET_QUEUE discardQueue;
     HTC_PACKET *pPacket;
@@ -849,11 +849,11 @@ static void FlushRecvBuffers(GMBOX_PROTO_HCI_UART *pProt)
 int GMboxProtocolInstall(struct ar6k_device *pDev)
 {
     int                status = 0;
-    GMBOX_PROTO_HCI_UART    *pProtocol = NULL;
+    struct gmbox_proto_hci_uart    *pProtocol = NULL;
         
     do {
         
-        pProtocol = A_MALLOC(sizeof(GMBOX_PROTO_HCI_UART));
+        pProtocol = A_MALLOC(sizeof(struct gmbox_proto_hci_uart));
         
         if (NULL == pProtocol) {
             status = A_NO_MEMORY;
@@ -891,7 +891,7 @@ int GMboxProtocolInstall(struct ar6k_device *pDev)
 /*** protocol module uninstall entry point ***/
 void GMboxProtocolUninstall(struct ar6k_device *pDev)
 {
-    GMBOX_PROTO_HCI_UART *pProtocol = (GMBOX_PROTO_HCI_UART *)DEV_GMBOX_GET_PROTOCOL(pDev);
+    struct gmbox_proto_hci_uart *pProtocol = (struct gmbox_proto_hci_uart *)DEV_GMBOX_GET_PROTOCOL(pDev);
     
     if (pProtocol != NULL) {
         
@@ -908,7 +908,7 @@ void GMboxProtocolUninstall(struct ar6k_device *pDev)
     
 }
 
-static int NotifyTransportReady(GMBOX_PROTO_HCI_UART  *pProt)
+static int NotifyTransportReady(struct gmbox_proto_hci_uart  *pProt)
 {
     HCI_TRANSPORT_PROPERTIES props;
     int                 status = 0;
@@ -938,7 +938,7 @@ static int NotifyTransportReady(GMBOX_PROTO_HCI_UART  *pProt)
 
 HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo)
 {
-    GMBOX_PROTO_HCI_UART  *pProtocol = NULL; 
+    struct gmbox_proto_hci_uart  *pProtocol = NULL; 
     struct ar6k_device           *pDev;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("+HCI_TransportAttach \n"));
@@ -949,7 +949,7 @@ HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_I
     
     do {
         
-        pProtocol = (GMBOX_PROTO_HCI_UART *)DEV_GMBOX_GET_PROTOCOL(pDev);
+        pProtocol = (struct gmbox_proto_hci_uart *)DEV_GMBOX_GET_PROTOCOL(pDev);
         
         if (NULL == pProtocol) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("GMBOX protocol not installed! \n"));
@@ -983,7 +983,7 @@ HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_I
 
 void HCI_TransportDetach(HCI_TRANSPORT_HANDLE HciTrans)
 {
-    GMBOX_PROTO_HCI_UART  *pProtocol = (GMBOX_PROTO_HCI_UART *)HciTrans; 
+    struct gmbox_proto_hci_uart  *pProtocol = (struct gmbox_proto_hci_uart *)HciTrans; 
     struct ar6k_device           *pDev = pProtocol->pDev;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("+HCI_TransportDetach \n"));
@@ -1003,7 +1003,7 @@ void HCI_TransportDetach(HCI_TRANSPORT_HANDLE HciTrans)
 
 int HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans; 
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans; 
     int              status = 0;
     bool                unblockRecv = false;
     HTC_PACKET            *pPacket;
@@ -1071,14 +1071,14 @@ int HCI_TransportAddReceivePkts(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE
 
 int HCI_TransportSendPkt(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, bool Synchronous)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;  
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans;  
     
     return HCITrySend(pProt,pPacket,Synchronous);
 }
 
 void HCI_TransportStop(HCI_TRANSPORT_HANDLE HciTrans)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans; 
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans; 
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("+HCI_TransportStop \n"));
      
@@ -1105,7 +1105,7 @@ void HCI_TransportStop(HCI_TRANSPORT_HANDLE HciTrans)
 int HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans)
 {
     int              status;
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC,("+HCI_TransportStart \n"));
     
@@ -1151,7 +1151,7 @@ int HCI_TransportStart(HCI_TRANSPORT_HANDLE HciTrans)
 
 int HCI_TransportEnableDisableAsyncRecv(HCI_TRANSPORT_HANDLE HciTrans, bool Enable)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans;
     return DevGMboxIRQAction(pProt->pDev, 
                              Enable ? GMBOX_RECV_IRQ_ENABLE : GMBOX_RECV_IRQ_DISABLE, 
                              PROC_IO_SYNC);
@@ -1162,7 +1162,7 @@ int HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
                                        HTC_PACKET           *pPacket,
                                        int                  MaxPollMS)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans;
     int              status = 0;
     u8 lookAhead[8];
     int                   bytes;
@@ -1232,7 +1232,7 @@ int HCI_TransportRecvHCIEventSync(HCI_TRANSPORT_HANDLE HciTrans,
 #define MSB_SCRATCH_IDX     5
 int HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, u32 Baud)
 {
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans;
     HIF_DEVICE *pHIFDevice = (HIF_DEVICE *)(pProt->pDev->HIFDevice);
     u32 scaledBaud, scratchAddr;
     int status = 0;
@@ -1264,7 +1264,7 @@ int HCI_TransportSetBaudRate(HCI_TRANSPORT_HANDLE HciTrans, u32 Baud)
 int HCI_TransportEnablePowerMgmt(HCI_TRANSPORT_HANDLE HciTrans, bool Enable)
 {
     int status;
-    GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)HciTrans;
+    struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)HciTrans;
                              
     if (Enable) {
         status = DevGMboxSetTargetInterrupt(pProt->pDev, MBOX_SIG_HCI_BRIDGE_PWR_SAV_ON, BTPWRSAV_TIMEOUT_MS);
-- 
1.7.4.15.g7811d

