Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29967 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1CKC4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:30 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 12/20] ath6kl: remove-typedef AR6K_HCI_BRIDGE_INFO
Date: Thu, 10 Mar 2011 18:55:39 -0800
Message-ID: <1299812147-12069-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6K_HCI_BRIDGE_INFO \
	"struct ar6k_hci_bridge_info" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/hci_bridge.c |   88 +++++++++++++-------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index ee52d11..a02827b 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -73,7 +73,7 @@ extern unsigned int hciuartscale;
 extern unsigned int hciuartstep;
 #endif /* EXPORT_HCI_BRIDGE_INTERFACE */
 
-typedef struct {
+struct ar6k_hci_bridge_info {
     void                    *pHCIDev;          /* HCI bridge device */
     HCI_TRANSPORT_PROPERTIES HCIProps;         /* HCI bridge props */
     struct hci_dev          *pBtStackHCIDev;   /* BT Stack HCI dev */
@@ -87,7 +87,7 @@ typedef struct {
 #else
     AR_SOFTC_T              *ar;
 #endif /* EXPORT_HCI_BRIDGE_INTERFACE */
-} AR6K_HCI_BRIDGE_INFO;
+};
 
 #define MAX_ACL_RECV_BUFS           16
 #define MAX_EVT_RECV_BUFS           8
@@ -103,17 +103,17 @@ extern unsigned int setupbtdev;
 struct ar3k_config_info      ar3kconfig;
 
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-AR6K_HCI_BRIDGE_INFO *g_pHcidevInfo;
+struct ar6k_hci_bridge_info *g_pHcidevInfo;
 #endif
 
-static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
-static void     bt_cleanup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
-static int bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo);
-static bool   bt_indicate_recv(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo,
+static int bt_setup_hci(struct ar6k_hci_bridge_info *pHcidevInfo);
+static void     bt_cleanup_hci(struct ar6k_hci_bridge_info *pHcidevInfo);
+static int bt_register_hci(struct ar6k_hci_bridge_info *pHcidevInfo);
+static bool   bt_indicate_recv(struct ar6k_hci_bridge_info      *pHcidevInfo,
                                  HCI_TRANSPORT_PACKET_TYPE Type, 
                                  struct sk_buff            *skb);
-static struct sk_buff *bt_alloc_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, int Length);
-static void     bt_free_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, struct sk_buff *skb);   
+static struct sk_buff *bt_alloc_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, int Length);
+static void     bt_free_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, struct sk_buff *skb);   
                                
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
 int ar6000_setup_hci(void *ar);
@@ -129,7 +129,7 @@ int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb);
 #define LOCK_BRIDGE(dev)   spin_lock_bh(&(dev)->BridgeLock)
 #define UNLOCK_BRIDGE(dev) spin_unlock_bh(&(dev)->BridgeLock)
 
-static inline void FreeBtOsBuf(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, void *osbuf)
+static inline void FreeBtOsBuf(struct ar6k_hci_bridge_info *pHcidevInfo, void *osbuf)
 {    
     if (pHcidevInfo->HciNormalMode) {
         bt_free_buffer(pHcidevInfo, (struct sk_buff *)osbuf);
@@ -139,14 +139,14 @@ static inline void FreeBtOsBuf(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, void *osbuf)
     }
 }
 
-static void FreeHTCStruct(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, HTC_PACKET *pPacket)
+static void FreeHTCStruct(struct ar6k_hci_bridge_info *pHcidevInfo, HTC_PACKET *pPacket)
 {
     LOCK_BRIDGE(pHcidevInfo);
     HTC_PACKET_ENQUEUE(&pHcidevInfo->HTCPacketStructHead,pPacket);
     UNLOCK_BRIDGE(pHcidevInfo);  
 }
 
-static HTC_PACKET * AllocHTCStruct(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static HTC_PACKET * AllocHTCStruct(struct ar6k_hci_bridge_info *pHcidevInfo)
 {
     HTC_PACKET  *pPacket = NULL;
     LOCK_BRIDGE(pHcidevInfo);
@@ -157,7 +157,7 @@ static HTC_PACKET * AllocHTCStruct(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
 
 #define BLOCK_ROUND_UP_PWR2(x, align)    (((int) (x) + ((align)-1)) & ~((align)-1))
 
-static void RefillRecvBuffers(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo, 
+static void RefillRecvBuffers(struct ar6k_hci_bridge_info      *pHcidevInfo, 
                               HCI_TRANSPORT_PACKET_TYPE Type, 
                               int                       NumBuffers)
 {
@@ -219,7 +219,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
                                            HCI_TRANSPORT_PROPERTIES *pProps, 
                                            void                     *pContext)
 {
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
     int              status;
     u32 address, hci_uart_pwr_mgmt_params;
 //    struct ar3k_config_info      ar3kconfig;
@@ -325,7 +325,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
 
 static void ar6000_hci_transport_failure(void *pContext, int Status)
 {
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("HCI Bridge: transport failure! \n"));
     
@@ -336,7 +336,7 @@ static void ar6000_hci_transport_failure(void *pContext, int Status)
 
 static void ar6000_hci_transport_removed(void *pContext)
 {
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
     
     AR_DEBUG_PRINTF(ATH_DEBUG_HCI_BRIDGE, ("HCI Bridge: transport removed. \n"));
     
@@ -349,7 +349,7 @@ static void ar6000_hci_transport_removed(void *pContext)
 
 static void ar6000_hci_send_complete(void *pContext, HTC_PACKET *pPacket)
 {
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
     void                 *osbuf = pPacket->pPktContext;
     A_ASSERT(osbuf != NULL);
     A_ASSERT(pHcidevInfo != NULL);
@@ -367,7 +367,7 @@ static void ar6000_hci_send_complete(void *pContext, HTC_PACKET *pPacket)
 
 static void ar6000_hci_pkt_recv(void *pContext, HTC_PACKET *pPacket)
 {
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
     struct sk_buff       *skb;
     
     A_ASSERT(pHcidevInfo != NULL);
@@ -432,7 +432,7 @@ static void ar6000_hci_pkt_recv(void *pContext, HTC_PACKET *pPacket)
 
 static void  ar6000_hci_pkt_refill(void *pContext, HCI_TRANSPORT_PACKET_TYPE Type, int BuffersAvailable)
 {
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
     int                  refillCount;
 
     if (Type == HCI_ACL_TYPE) {
@@ -449,7 +449,7 @@ static void  ar6000_hci_pkt_refill(void *pContext, HCI_TRANSPORT_PACKET_TYPE Typ
 
 static HCI_SEND_FULL_ACTION  ar6000_hci_pkt_send_full(void *pContext, HTC_PACKET *pPacket)
 {
-    AR6K_HCI_BRIDGE_INFO    *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)pContext;
+    struct ar6k_hci_bridge_info    *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
     HCI_SEND_FULL_ACTION    action = HCI_SEND_FULL_KEEP;
     
     if (!pHcidevInfo->HciNormalMode) {
@@ -473,19 +473,19 @@ int ar6000_setup_hci(AR_SOFTC_T *ar)
     int                  status = 0;
     int                       i;
     HTC_PACKET                *pPacket;
-    AR6K_HCI_BRIDGE_INFO      *pHcidevInfo;
+    struct ar6k_hci_bridge_info      *pHcidevInfo;
         
        
     do {
         
-        pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)A_MALLOC(sizeof(AR6K_HCI_BRIDGE_INFO));
+        pHcidevInfo = (struct ar6k_hci_bridge_info *)A_MALLOC(sizeof(struct ar6k_hci_bridge_info));
         
         if (NULL == pHcidevInfo) {
             status = A_NO_MEMORY;
             break;    
         }
         
-        A_MEMZERO(pHcidevInfo, sizeof(AR6K_HCI_BRIDGE_INFO));
+        A_MEMZERO(pHcidevInfo, sizeof(struct ar6k_hci_bridge_info));
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
         g_pHcidevInfo = pHcidevInfo;
         pHcidevInfo->HCITransHdl = *(HCI_TRANSPORT_MISC_HANDLES *)ar;
@@ -567,9 +567,9 @@ void  ar6000_cleanup_hci(AR_SOFTC_T *ar)
 #endif
 {
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = g_pHcidevInfo;
+    struct ar6k_hci_bridge_info *pHcidevInfo = g_pHcidevInfo;
 #else
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)ar->hcidev_info;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)ar->hcidev_info;
 #endif
     
     if (pHcidevInfo != NULL) {
@@ -607,9 +607,9 @@ int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb)
     HTC_PACKET       *pPacket;   
     HTC_TX_TAG       htc_tag = AR6K_DATA_PKT_TAG;
 #ifdef EXPORT_HCI_BRIDGE_INTERFACE
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = g_pHcidevInfo;
+    struct ar6k_hci_bridge_info *pHcidevInfo = g_pHcidevInfo;
 #else
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)ar->hcidev_info;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)ar->hcidev_info;
 #endif
             
     do {
@@ -666,7 +666,7 @@ int hci_test_send(AR_SOFTC_T *ar, struct sk_buff *skb)
 
 void ar6000_set_default_ar3kconfig(AR_SOFTC_T *ar, void *ar3kconfig)
 {
-    AR6K_HCI_BRIDGE_INFO *pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)ar->hcidev_info;
+    struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)ar->hcidev_info;
     struct ar3k_config_info *config = (struct ar3k_config_info *)ar3kconfig;
 
     config->pHCIDev = pHcidevInfo->pHCIDev;
@@ -710,7 +710,7 @@ static int bt_send_frame(struct sk_buff *skb)
 {
     struct hci_dev             *hdev = (struct hci_dev *)skb->dev;
     HCI_TRANSPORT_PACKET_TYPE  type;
-    AR6K_HCI_BRIDGE_INFO       *pHcidevInfo;
+    struct ar6k_hci_bridge_info       *pHcidevInfo;
     HTC_PACKET                 *pPacket;
     int                   status = 0;
     struct sk_buff             *txSkb = NULL;
@@ -725,7 +725,7 @@ static int bt_send_frame(struct sk_buff *skb)
         return -EBUSY;
     }
   
-    pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)hdev->driver_data;   
+    pHcidevInfo = (struct ar6k_hci_bridge_info *)hdev->driver_data;   
     A_ASSERT(pHcidevInfo != NULL);
       
     AR_DEBUG_PRINTF(ATH_DEBUG_HCI_SEND, ("+bt_send_frame type: %d \n",bt_cb(skb)->pkt_type));
@@ -832,11 +832,11 @@ static int bt_ioctl(struct hci_dev *hdev, unsigned int cmd, unsigned long arg)
 */
 static int bt_flush(struct hci_dev *hdev)
 {
-    AR6K_HCI_BRIDGE_INFO    *pHcidevInfo; 
+    struct ar6k_hci_bridge_info    *pHcidevInfo; 
     
     AR_DEBUG_PRINTF(ATH_DEBUG_TRC, ("HCI Bridge: bt_flush - enter\n"));
     
-    pHcidevInfo = (AR6K_HCI_BRIDGE_INFO *)hdev->driver_data;   
+    pHcidevInfo = (struct ar6k_hci_bridge_info *)hdev->driver_data;   
     
     /* TODO??? */   
     
@@ -853,7 +853,7 @@ static void bt_destruct(struct hci_dev *hdev)
     /* nothing to do here */
 }
 
-static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_setup_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
 {
     int                    status = 0;
     struct hci_dev              *pHciDev = NULL;
@@ -913,7 +913,7 @@ static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
     return status;
 }
 
-static void bt_cleanup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static void bt_cleanup_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
 {   
     int   err;      
         
@@ -935,7 +935,7 @@ static void bt_cleanup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
     }  
 }
 
-static int bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_register_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
 {
     int       err;
     int  status = 0;
@@ -959,7 +959,7 @@ static int bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
     return status;
 }
 
-static bool bt_indicate_recv(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo,
+static bool bt_indicate_recv(struct ar6k_hci_bridge_info      *pHcidevInfo,
                                HCI_TRANSPORT_PACKET_TYPE Type, 
                                struct                    sk_buff *skb)
 {
@@ -1022,7 +1022,7 @@ static bool bt_indicate_recv(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo,
     return success;
 }
 
-static struct sk_buff* bt_alloc_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, int Length) 
+static struct sk_buff* bt_alloc_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, int Length) 
 { 
     struct sk_buff *skb;         
         /* in normal HCI mode we need to alloc from the bt core APIs */
@@ -1033,7 +1033,7 @@ static struct sk_buff* bt_alloc_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, int Le
     return skb;
 }
 
-static void bt_free_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, struct sk_buff *skb)
+static void bt_free_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, struct sk_buff *skb)
 {
     kfree_skb(skb);    
 }
@@ -1041,21 +1041,21 @@ static void bt_free_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, struct sk_buff *sk
 #else // { CONFIG_BLUEZ_HCI_BRIDGE
 
     /* stubs when we only want to test the HCI bridging Interface without the HT stack */
-static int bt_setup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_setup_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
 {
     return 0;
 }
-static void bt_cleanup_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static void bt_cleanup_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
 {   
      
 }
-static int bt_register_hci(AR6K_HCI_BRIDGE_INFO *pHcidevInfo)
+static int bt_register_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
 {
     A_ASSERT(false);
     return A_ERROR;    
 }
 
-static bool bt_indicate_recv(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo,
+static bool bt_indicate_recv(struct ar6k_hci_bridge_info      *pHcidevInfo,
                                HCI_TRANSPORT_PACKET_TYPE Type, 
                                struct                    sk_buff *skb)
 {
@@ -1063,12 +1063,12 @@ static bool bt_indicate_recv(AR6K_HCI_BRIDGE_INFO      *pHcidevInfo,
     return false;
 }
 
-static struct sk_buff* bt_alloc_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, int Length) 
+static struct sk_buff* bt_alloc_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, int Length) 
 {
     A_ASSERT(false);
     return NULL;
 }
-static void bt_free_buffer(AR6K_HCI_BRIDGE_INFO *pHcidevInfo, struct sk_buff *skb)
+static void bt_free_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, struct sk_buff *skb)
 {
     A_ASSERT(false);
 }
-- 
1.7.4.15.g7811d

