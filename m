Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20456 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab1CNR7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:58:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/38] ath6kl: remove-typedef HCI_TRANSPORT_CONFIG_INFO
Date: Mon, 14 Mar 2011 10:58:38 -0700
Message-ID: <1300125552-24422-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HCI_TRANSPORT_CONFIG_INFO \
	"struct hci_transport_config_info" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    2 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    6 +++---
 drivers/staging/ath6kl/include/hci_transport_api.h |    6 +++---
 .../staging/ath6kl/os/linux/export_hci_transport.c |    2 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    4 ++--
 .../ath6kl/os/linux/include/export_hci_transport.h |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 88ef25a..4b69f91 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -361,7 +361,7 @@ static INLINE int DevSetupGMbox(struct ar6k_device *pDev) {
 #ifdef ATH_AR6K_ENABLE_GMBOX
 
     /* GMBOX protocol modules must expose each of these internal APIs */
-HCI_TRANSPORT_HANDLE GMboxAttachProtocol(struct ar6k_device *pDev, HCI_TRANSPORT_CONFIG_INFO *pInfo);
+HCI_TRANSPORT_HANDLE GMboxAttachProtocol(struct ar6k_device *pDev, struct hci_transport_config_info *pInfo);
 int             GMboxProtocolInstall(struct ar6k_device *pDev);
 void                 GMboxProtocolUninstall(struct ar6k_device *pDev);
 
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 78da8a1..c7e8f71 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -57,7 +57,7 @@
 #define BTPWRSAV_TIMEOUT_MS       1  
 
 struct gmbox_proto_hci_uart {
-    HCI_TRANSPORT_CONFIG_INFO   HCIConfig;
+    struct hci_transport_config_info   HCIConfig;
     bool                      HCIAttached;
     bool                      HCIStopped;
     u32 RecvStateFlags;
@@ -936,7 +936,7 @@ static int NotifyTransportReady(struct gmbox_proto_hci_uart  *pProt)
 
 /***********  HCI UART protocol implementation ************************************************/
 
-HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo)
+HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, struct hci_transport_config_info *pInfo)
 {
     struct gmbox_proto_hci_uart  *pProtocol = NULL; 
     struct ar6k_device           *pDev;
@@ -961,7 +961,7 @@ HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_I
             break;    
         }
         
-        memcpy(&pProtocol->HCIConfig, pInfo, sizeof(HCI_TRANSPORT_CONFIG_INFO));
+        memcpy(&pProtocol->HCIConfig, pInfo, sizeof(struct hci_transport_config_info));
         
         A_ASSERT(pProtocol->HCIConfig.pHCIPktRecv != NULL);
         A_ASSERT(pProtocol->HCIConfig.pHCISendComplete != NULL);
diff --git a/drivers/staging/ath6kl/include/hci_transport_api.h b/drivers/staging/ath6kl/include/hci_transport_api.h
index 8ab692d..7fa44f0 100644
--- a/drivers/staging/ath6kl/include/hci_transport_api.h
+++ b/drivers/staging/ath6kl/include/hci_transport_api.h
@@ -85,7 +85,7 @@ typedef struct {
     int    IOBlockPad;    /* I/O block padding required (always a power of 2) */
 } HCI_TRANSPORT_PROPERTIES;
 
-typedef struct _HCI_TRANSPORT_CONFIG_INFO {
+struct hci_transport_config_info {
     int      ACLRecvBufferWaterMark;     /* low watermark to trigger recv refill */
     int      EventRecvBufferWaterMark;   /* low watermark to trigger recv refill */  
     int      MaxSendQueueDepth;          /* max number of packets in the single send queue */
@@ -99,7 +99,7 @@ typedef struct _HCI_TRANSPORT_CONFIG_INFO {
     HCI_TRANSPORT_RECV_REFILL          pHCIPktRecvRefill;
     HCI_TRANSPORT_RECV_ALLOC           pHCIPktRecvAlloc;
     HCI_TRANSPORT_SEND_FULL            pHCISendFull;
-} HCI_TRANSPORT_CONFIG_INFO;
+};
 
 /* ------ Function Prototypes ------ */
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@@ -113,7 +113,7 @@ typedef struct _HCI_TRANSPORT_CONFIG_INFO {
   @example:
   @see also: HCI_TransportDetach
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo);
+HCI_TRANSPORT_HANDLE HCI_TransportAttach(void *HTCHandle, struct hci_transport_config_info *pInfo);
 
 /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   @desc: Detach from the HCI transport module
diff --git a/drivers/staging/ath6kl/os/linux/export_hci_transport.c b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
index 168d6f7..fd87526 100644
--- a/drivers/staging/ath6kl/os/linux/export_hci_transport.c
+++ b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
@@ -36,7 +36,7 @@
 #include "AR6002/hw4.0/hw/uart_reg.h"
 #include "AR6002/hw4.0/hw/rtc_wlan_reg.h"
 
-HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo);
+HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, struct hci_transport_config_info *pInfo);
 void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
 int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
 int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, bool Synchronous);
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index 61ce094..d0b6814 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -469,7 +469,7 @@ int ar6000_setup_hci(void *ar)
 int ar6000_setup_hci(AR_SOFTC_T *ar)
 #endif
 {
-    HCI_TRANSPORT_CONFIG_INFO config;
+    struct hci_transport_config_info config;
     int                  status = 0;
     int                       i;
     HTC_PACKET                *pPacket;
@@ -521,7 +521,7 @@ int ar6000_setup_hci(AR_SOFTC_T *ar)
             FreeHTCStruct(pHcidevInfo,pPacket);                
         }
         
-        A_MEMZERO(&config,sizeof(HCI_TRANSPORT_CONFIG_INFO));        
+        A_MEMZERO(&config,sizeof(struct hci_transport_config_info));        
         config.ACLRecvBufferWaterMark = MAX_ACL_RECV_BUFS / 2;
         config.EventRecvBufferWaterMark = MAX_EVT_RECV_BUFS / 2;
         config.MaxSendQueueDepth = MAX_HCI_WRITE_QUEUE_DEPTH;
diff --git a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
index 51187f6..cf66717 100644
--- a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
+++ b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
@@ -25,7 +25,7 @@
 #include "hci_transport_api.h"
 #include "common_drv.h"
 
-extern HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, HCI_TRANSPORT_CONFIG_INFO *pInfo);
+extern HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, struct hci_transport_config_info *pInfo);
 extern void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
 extern int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET_QUEUE *pQueue);
 extern int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, HTC_PACKET *pPacket, bool Synchronous);
-- 
1.7.4.15.g7811d

