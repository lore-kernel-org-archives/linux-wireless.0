Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41346 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab1EDPur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 11:50:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 08:50:19 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<Vipin.Mehta@Atheros.com>, <Naveen.Singh@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 1/2] ath6kl: Remove dead code with undefined EXPORT_HCI_BRIDGE_INTERFACE
Date: Wed, 4 May 2011 21:28:10 +0530
Message-ID: <1304524691-12652-1-git-send-email-vasanth@atheros.com> (sfid-20110504_175051_880431_161F9378)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |    4 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   33 -----
 .../staging/ath6kl/os/linux/export_hci_transport.c |  124 ------------------
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |  137 --------------------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    4 -
 .../ath6kl/os/linux/include/export_hci_transport.h |   76 -----------
 drivers/staging/ath6kl/os/linux/netbuf.c           |    8 -
 7 files changed, 0 insertions(+), 386 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/os/linux/export_hci_transport.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/export_hci_transport.h

diff --git a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
index e0ea218..be84cfb 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
@@ -28,11 +28,7 @@
 #define ATH_MODULE_NAME misc
 #include "a_debug.h"
 #include "common_drv.h"
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-#include "export_hci_transport.h"
-#else
 #include "hci_transport_api.h"
-#endif
 #include "ar3kconfig.h"
 #include "tlpm.h"
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 513f205..aece57a 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -110,11 +110,6 @@ A_TIMER aptcTimer;
 APTC_TRAFFIC_RECORD aptcTR;
 #endif /* ADAPTIVE_POWER_THROUGHPUT_CONTROL */
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-// callbacks registered by HCI transport driver
-struct hci_transport_callbacks ar6kHciTransCallbacks = { NULL };
-#endif
-
 unsigned int processDot11Hdr = 0;
 
 char ifname[IFNAMSIZ] = {0,};
@@ -149,11 +144,9 @@ unsigned int nohifscattersupport = NOHIFSCATTERSUPPORT_DEFAULT;
 unsigned int setuphci = SETUPHCI_DEFAULT;
 unsigned int loghci = 0;
 unsigned int setupbtdev = SETUPBTDEV_DEFAULT;
-#ifndef EXPORT_HCI_BRIDGE_INTERFACE
 unsigned int ar3khcibaud = AR3KHCIBAUD_DEFAULT;
 unsigned int hciuartscale = HCIUARTSCALE_DEFAULT;
 unsigned int hciuartstep = HCIUARTSTEP_DEFAULT;
-#endif
 unsigned int csumOffload=0;
 unsigned int csumOffloadTest=0;
 unsigned int eppingtest=0;
@@ -189,11 +182,9 @@ module_param(panic_on_assert, uint, 0644);
 module_param(setuphci, uint, 0644);
 module_param(loghci, uint, 0644);
 module_param(setupbtdev, uint, 0644);
-#ifndef EXPORT_HCI_BRIDGE_INTERFACE
 module_param(ar3khcibaud, uint, 0644);
 module_param(hciuartscale, uint, 0644);
 module_param(hciuartstep, uint, 0644);
-#endif
 module_param(eppingtest, uint, 0644);
 
 /* in 2.6.10 and later this is now a pointer to a uint */
@@ -1956,11 +1947,6 @@ ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs)
     }
 
     if (ar->arHtcTarget != NULL) {
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        if (NULL != ar6kHciTransCallbacks.cleanupTransport) {
-            ar6kHciTransCallbacks.cleanupTransport(NULL);
-        }
-#else
         // FIXME: workaround to reset BT's UART baud rate to default
         if (NULL != ar->exitCallback) {
             struct ar3k_config_info ar3kconfig;
@@ -1976,7 +1962,6 @@ ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs)
         // END workaround
         if (setuphci)
         	ar6000_cleanup_hci(ar);
-#endif
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO,(" Shutting down HTC .... \n"));
         /* stop HTC */
         HTCStop(ar->arHtcTarget);
@@ -2652,21 +2637,10 @@ int ar6000_init(struct net_device *dev)
         ar->arAcStreamPriMap[WMM_AC_VI] = 2; /*         */
         ar->arAcStreamPriMap[WMM_AC_VO] = 3; /* highest */
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        if (setuphci && (NULL != ar6kHciTransCallbacks.setupTransport)) {
-            struct hci_transport_misc_handles hciHandles;
-
-            hciHandles.netDevice = ar->arNetDev;
-            hciHandles.hifDevice = ar->arHifDevice;
-            hciHandles.htcHandle = ar->arHtcTarget;
-            status = (int)(ar6kHciTransCallbacks.setupTransport(&hciHandles));
-        }
-#else
         if (setuphci) {
                 /* setup HCI */
             status = ar6000_setup_hci(ar);
         }
-#endif
 
     } while (false);
 
@@ -3136,11 +3110,9 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
 
                 if (ac == HCI_TRANSPORT_STREAM_NUM) {
                         /* pass this to HCI */
-#ifndef EXPORT_HCI_BRIDGE_INTERFACE
                     if (!hci_test_send(ar,skb)) {
                         return 0;
                     }
-#endif
                         /* set AC to discard this skb */
                     ac = AC_NOT_MAPPED;
                 } else {
@@ -6232,8 +6204,3 @@ int ar6000_remove_ap_interface(struct ar6_softc *ar)
     return 0;
 }
 #endif /* CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT */
-
-
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-EXPORT_SYMBOL(setupbtdev);
-#endif
diff --git a/drivers/staging/ath6kl/os/linux/export_hci_transport.c b/drivers/staging/ath6kl/os/linux/export_hci_transport.c
deleted file mode 100644
index 430998e..0000000
--- a/drivers/staging/ath6kl/os/linux/export_hci_transport.c
+++ /dev/null
@@ -1,124 +0,0 @@
-//------------------------------------------------------------------------------
-// Copyright (c) 2009-2010 Atheros Corporation.  All rights reserved.
-// 
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//------------------------------------------------------------------------------
-//==============================================================================
-// HCI bridge implementation
-//
-// Author(s): ="Atheros"
-//==============================================================================
-#include <a_config.h>
-#include <athdefs.h>
-#include "a_osapi.h"
-#include "htc_api.h"
-#include "a_drv.h"
-#include "hif.h"
-#include "common_drv.h"
-#include "a_debug.h"
-#include "hci_transport_api.h"
-
-#include "AR6002/hw4.0/hw/apb_athr_wlan_map.h"
-#include "AR6002/hw4.0/hw/uart_reg.h"
-#include "AR6002/hw4.0/hw/rtc_wlan_reg.h"
-
-HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, struct hci_transport_config_info *pInfo);
-void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
-int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet_queue *pQueue);
-int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet *pPacket, bool Synchronous);
-void        (*_HCI_TransportStop)(HCI_TRANSPORT_HANDLE HciTrans);
-int    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
-int    (*_HCI_TransportEnableDisableAsyncRecv)(HCI_TRANSPORT_HANDLE HciTrans, bool Enable);
-int    (*_HCI_TransportRecvHCIEventSync)(HCI_TRANSPORT_HANDLE HciTrans,
-                                          struct htc_packet           *pPacket,
-                                          int                  MaxPollMS);
-int    (*_HCI_TransportSetBaudRate)(HCI_TRANSPORT_HANDLE HciTrans, u32 Baud);
-int    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTrans, bool Enable);
-
-extern struct hci_transport_callbacks ar6kHciTransCallbacks;
-
-int ar6000_register_hci_transport(struct hci_transport_callbacks *hciTransCallbacks)
-{
-    ar6kHciTransCallbacks = *hciTransCallbacks;
-
-    _HCI_TransportAttach = HCI_TransportAttach;
-    _HCI_TransportDetach = HCI_TransportDetach;
-    _HCI_TransportAddReceivePkts = HCI_TransportAddReceivePkts;
-    _HCI_TransportSendPkt = HCI_TransportSendPkt;
-    _HCI_TransportStop = HCI_TransportStop;
-    _HCI_TransportStart = HCI_TransportStart;
-    _HCI_TransportEnableDisableAsyncRecv = HCI_TransportEnableDisableAsyncRecv;
-    _HCI_TransportRecvHCIEventSync = HCI_TransportRecvHCIEventSync;
-    _HCI_TransportSetBaudRate = HCI_TransportSetBaudRate;
-    _HCI_TransportEnablePowerMgmt = HCI_TransportEnablePowerMgmt;
-
-    return 0;
-}
-
-int
-ar6000_get_hif_dev(struct hif_device *device, void *config)
-{
-    int status;
-
-    status = HIFConfigureDevice(device,
-                                HIF_DEVICE_GET_OS_DEVICE,
-                                (struct hif_device_os_device_info *)config, 
-                                sizeof(struct hif_device_os_device_info));
-    return status;
-}
-
-int ar6000_set_uart_config(struct hif_device *hifDevice,
-                                u32 scale,
-                                u32 step)
-{
-    u32 regAddress;
-    u32 regVal;
-    int status;
-
-    regAddress = WLAN_UART_BASE_ADDRESS | UART_CLKDIV_ADDRESS;
-    regVal = ((u32)scale << 16) | step;
-    /* change the HCI UART scale/step values through the diagnostic window */
-    status = ar6000_WriteRegDiag(hifDevice, &regAddress, &regVal);                     
-
-    return status;
-}
-
-int ar6000_get_core_clock_config(struct hif_device *hifDevice, u32 *data)
-{
-    u32 regAddress;
-    int status;
-
-    regAddress = WLAN_RTC_BASE_ADDRESS | WLAN_CPU_CLOCK_ADDRESS;
-    /* read CPU clock settings*/
-    status = ar6000_ReadRegDiag(hifDevice, &regAddress, data);
-
-    return status;
-}
-
-EXPORT_SYMBOL(ar6000_register_hci_transport);
-EXPORT_SYMBOL(ar6000_get_hif_dev);
-EXPORT_SYMBOL(ar6000_set_uart_config);
-EXPORT_SYMBOL(ar6000_get_core_clock_config);
-EXPORT_SYMBOL(_HCI_TransportAttach);
-EXPORT_SYMBOL(_HCI_TransportDetach);
-EXPORT_SYMBOL(_HCI_TransportAddReceivePkts);
-EXPORT_SYMBOL(_HCI_TransportSendPkt);
-EXPORT_SYMBOL(_HCI_TransportStop);
-EXPORT_SYMBOL(_HCI_TransportStart);
-EXPORT_SYMBOL(_HCI_TransportEnableDisableAsyncRecv);
-EXPORT_SYMBOL(_HCI_TransportRecvHCIEventSync);
-EXPORT_SYMBOL(_HCI_TransportSetBaudRate);
-EXPORT_SYMBOL(_HCI_TransportEnablePowerMgmt);
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index 6087edc..d445a72 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -22,31 +22,10 @@
 // Author(s): ="Atheros"
 //==============================================================================
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-#include <linux/etherdevice.h>
-#include <a_config.h>
-#include <athdefs.h>
-#include "a_osapi.h"
-#include "htc_api.h"
-#include "wmi.h"
-#include "a_drv.h"
-#include "hif.h"
-#include "common_drv.h"
-#include "a_debug.h"
-#define  ATH_DEBUG_HCI_BRIDGE    ATH_DEBUG_MAKE_MODULE_MASK(6)
-#define  ATH_DEBUG_HCI_RECV      ATH_DEBUG_MAKE_MODULE_MASK(7)
-#define  ATH_DEBUG_HCI_SEND      ATH_DEBUG_MAKE_MODULE_MASK(8)
-#define  ATH_DEBUG_HCI_DUMP      ATH_DEBUG_MAKE_MODULE_MASK(9)
-#else
 #include "ar6000_drv.h"
-#endif  /* EXPORT_HCI_BRIDGE_INTERFACE */
 
 #ifdef ATH_AR6K_ENABLE_GMBOX
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-#include "export_hci_transport.h"
-#else
 #include "hci_transport_api.h"
-#endif
 #include "epping_test.h"
 #include "gmboxif.h"
 #include "ar3kconfig.h"
@@ -58,19 +37,9 @@
 #define CONFIG_BLUEZ_HCI_BRIDGE  
 #endif
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-unsigned int ar3khcibaud = 0;
-unsigned int hciuartscale = 0;
-unsigned int hciuartstep = 0;
-
-module_param(ar3khcibaud, int, 0644);
-module_param(hciuartscale, int, 0644);
-module_param(hciuartstep, int, 0644);
-#else
 extern unsigned int ar3khcibaud;
 extern unsigned int hciuartscale;
 extern unsigned int hciuartstep;
-#endif /* EXPORT_HCI_BRIDGE_INTERFACE */
 
 struct ar6k_hci_bridge_info {
     void                    *pHCIDev;          /* HCI bridge device */
@@ -81,11 +50,7 @@ struct ar6k_hci_bridge_info {
     struct htc_packet_queue        HTCPacketStructHead;
     u8 *pHTCStructAlloc;
     spinlock_t              BridgeLock;
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-    struct hci_transport_misc_handles    HCITransHdl; 
-#else
     struct ar6_softc              *ar;
-#endif /* EXPORT_HCI_BRIDGE_INTERFACE */
 };
 
 #define MAX_ACL_RECV_BUFS           16
@@ -101,10 +66,6 @@ struct ar6k_hci_bridge_info {
 extern unsigned int setupbtdev;
 struct ar3k_config_info      ar3kconfig;
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-struct ar6k_hci_bridge_info *g_pHcidevInfo;
-#endif
-
 static int bt_setup_hci(struct ar6k_hci_bridge_info *pHcidevInfo);
 static void     bt_cleanup_hci(struct ar6k_hci_bridge_info *pHcidevInfo);
 static int bt_register_hci(struct ar6k_hci_bridge_info *pHcidevInfo);
@@ -114,16 +75,10 @@ static bool   bt_indicate_recv(struct ar6k_hci_bridge_info      *pHcidevInfo,
 static struct sk_buff *bt_alloc_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, int Length);
 static void     bt_free_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, struct sk_buff *skb);   
                                
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-int ar6000_setup_hci(void *ar);
-void     ar6000_cleanup_hci(void *ar);
-int hci_test_send(void *ar, struct sk_buff *skb);
-#else
 int ar6000_setup_hci(struct ar6_softc *ar);
 void     ar6000_cleanup_hci(struct ar6_softc *ar);
 /* HCI bridge testing */
 int hci_test_send(struct ar6_softc *ar, struct sk_buff *skb);
-#endif /* EXPORT_HCI_BRIDGE_INTERFACE */
 
 #define LOCK_BRIDGE(dev)   spin_lock_bh(&(dev)->BridgeLock)
 #define UNLOCK_BRIDGE(dev) spin_unlock_bh(&(dev)->BridgeLock)
@@ -233,11 +188,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
             pHcidevInfo->HCIProps.TailRoom,
             pHcidevInfo->HCIProps.IOBlockPad));
     
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-    A_ASSERT((pProps->HeadRoom + pProps->TailRoom) <= (struct net_device *)(pHcidevInfo->HCITransHdl.netDevice)->hard_header_len);
-#else
     A_ASSERT((pProps->HeadRoom + pProps->TailRoom) <= pHcidevInfo->ar->arNetDev->hard_header_len);
-#endif
                              
         /* provide buffers */
     RefillRecvBuffers(pHcidevInfo, HCI_ACL_TYPE, MAX_ACL_RECV_BUFS);
@@ -268,11 +219,7 @@ static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
         A_MEMZERO(&ar3kconfig,sizeof(ar3kconfig));
         ar3kconfig.pHCIDev = pHcidevInfo->pHCIDev;
         ar3kconfig.pHCIProps = &pHcidevInfo->HCIProps;
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        ar3kconfig.pHIFDevice = (struct hif_device *)(pHcidevInfo->HCITransHdl.hifDevice);
-#else
         ar3kconfig.pHIFDevice = pHcidevInfo->ar->arHifDevice;
-#endif
         ar3kconfig.pBtStackHCIDev = pHcidevInfo->pBtStackHCIDev;
         
         if (ar3khcibaud != 0) {
@@ -405,15 +352,9 @@ static void ar6000_hci_pkt_recv(void *pContext, struct htc_packet *pPacket)
         }
         
             /* for testing, indicate packet to the network stack */ 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        skb->dev = (struct net_device *)(pHcidevInfo->HCITransHdl.netDevice);        
-        if ((((struct net_device *)pHcidevInfo->HCITransHdl.netDevice)->flags & IFF_UP) == IFF_UP) {
-            skb->protocol = eth_type_trans(skb, (struct net_device *)(pHcidevInfo->HCITransHdl.netDevice));
-#else
         skb->dev = pHcidevInfo->ar->arNetDev;        
         if ((pHcidevInfo->ar->arNetDev->flags & IFF_UP) == IFF_UP) {
             skb->protocol = eth_type_trans(skb, pHcidevInfo->ar->arNetDev);
-#endif
             netif_rx(skb);
             skb = NULL;
         } 
@@ -462,11 +403,7 @@ static HCI_SEND_FULL_ACTION  ar6000_hci_pkt_send_full(void *pContext, struct htc
     return action;
 }
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-int ar6000_setup_hci(void *ar)
-#else
 int ar6000_setup_hci(struct ar6_softc *ar)
-#endif
 {
     struct hci_transport_config_info config;
     int                  status = 0;
@@ -485,13 +422,8 @@ int ar6000_setup_hci(struct ar6_softc *ar)
         }
         
         A_MEMZERO(pHcidevInfo, sizeof(struct ar6k_hci_bridge_info));
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        g_pHcidevInfo = pHcidevInfo;
-        pHcidevInfo->HCITransHdl = *(struct hci_transport_misc_handles *)ar;
-#else
         ar->hcidev_info = pHcidevInfo;
         pHcidevInfo->ar = ar;
-#endif
         spin_lock_init(&pHcidevInfo->BridgeLock);
         INIT_HTC_PACKET_QUEUE(&pHcidevInfo->HTCPacketStructHead);
 
@@ -533,11 +465,7 @@ int ar6000_setup_hci(struct ar6_softc *ar)
         config.pHCIPktRecvRefill = ar6000_hci_pkt_refill;
         config.pHCISendFull = ar6000_hci_pkt_send_full;
        
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        pHcidevInfo->pHCIDev = HCI_TransportAttach(pHcidevInfo->HCITransHdl.htcHandle, &config);
-#else
         pHcidevInfo->pHCIDev = HCI_TransportAttach(ar->arHtcTarget, &config);
-#endif
 
         if (NULL == pHcidevInfo->pHCIDev) {
             status = A_ERROR;      
@@ -559,17 +487,9 @@ int ar6000_setup_hci(struct ar6_softc *ar)
     return status;
 }
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-void  ar6000_cleanup_hci(void *ar)
-#else
 void  ar6000_cleanup_hci(struct ar6_softc *ar)
-#endif
 {
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-    struct ar6k_hci_bridge_info *pHcidevInfo = g_pHcidevInfo;
-#else
     struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)ar->hcidev_info;
-#endif
     
     if (pHcidevInfo != NULL) {
         bt_cleanup_hci(pHcidevInfo);   
@@ -586,30 +506,20 @@ void  ar6000_cleanup_hci(struct ar6_softc *ar)
         }
         
         kfree(pHcidevInfo);
-#ifndef EXPORT_HCI_BRIDGE_INTERFACE
         ar->hcidev_info = NULL;
-#endif
     }
     
     
 }
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-int hci_test_send(void *ar, struct sk_buff *skb)
-#else
 int hci_test_send(struct ar6_softc *ar, struct sk_buff *skb)
-#endif
 {
     int              status = 0;
     int              length;
     EPPING_HEADER    *pHeader;
     struct htc_packet       *pPacket;   
     HTC_TX_TAG       htc_tag = AR6K_DATA_PKT_TAG;
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-    struct ar6k_hci_bridge_info *pHcidevInfo = g_pHcidevInfo;
-#else
     struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)ar->hcidev_info;
-#endif
             
     do {
         
@@ -866,15 +776,10 @@ static int bt_setup_hci(struct ar6k_hci_bridge_info *pHcidevInfo)
             
         A_MEMZERO(&osDevInfo,sizeof(osDevInfo));
             /* get the underlying OS device */
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-        status = ar6000_get_hif_dev((struct hif_device *)(pHcidevInfo->HCITransHdl.hifDevice), 
-                                    &osDevInfo);
-#else
         status = HIFConfigureDevice(pHcidevInfo->ar->arHifDevice, 
                                     HIF_DEVICE_GET_OS_DEVICE,
                                     &osDevInfo, 
                                     sizeof(osDevInfo));
-#endif
                                     
         if (status) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Failed to OS device info from HIF\n"));
@@ -1076,66 +981,24 @@ static void bt_free_buffer(struct ar6k_hci_bridge_info *pHcidevInfo, struct sk_b
 
     /* stubs when GMBOX support is not needed */
     
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-int ar6000_setup_hci(void *ar)
-#else
 int ar6000_setup_hci(struct ar6_softc *ar)
-#endif
 {
     return 0;
 }
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-void ar6000_cleanup_hci(void *ar)
-#else
 void ar6000_cleanup_hci(struct ar6_softc *ar)
-#endif
 {
     return;    
 }
 
-#ifndef EXPORT_HCI_BRIDGE_INTERFACE
 void ar6000_set_default_ar3kconfig(struct ar6_softc *ar, void *ar3kconfig)
 {
     return;
 }
-#endif
 
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-int hci_test_send(void *ar, struct sk_buff *skb)
-#else
 int hci_test_send(struct ar6_softc *ar, struct sk_buff *skb)
-#endif
 {
     return -EOPNOTSUPP;
 }
 
 #endif // } ATH_AR6K_ENABLE_GMBOX
-
-
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-static int __init
-hcibridge_init_module(void)
-{
-    int status;
-    struct hci_transport_callbacks hciTransCallbacks;
-
-    hciTransCallbacks.setupTransport = ar6000_setup_hci;
-    hciTransCallbacks.cleanupTransport = ar6000_cleanup_hci;
-
-    status = ar6000_register_hci_transport(&hciTransCallbacks);
-    if (status)
-        return -ENODEV;
-
-    return 0;
-}
-
-static void __exit
-hcibridge_cleanup_module(void)
-{
-}
-
-module_init(hcibridge_init_module);
-module_exit(hcibridge_cleanup_module);
-MODULE_LICENSE("Dual BSD/GPL");
-#endif
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 22453b0..ba0c02b 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -605,9 +605,7 @@ struct ar6_softc {
     bool                  DTIMExpired; /* flag to indicate DTIM expired */
     u8 intra_bss;   /* enable/disable intra bss data forward */
     void                    *aggr_cntxt;
-#ifndef EXPORT_HCI_BRIDGE_INTERFACE
     void                    *hcidev_info;
-#endif
     WMI_AP_MODE_STAT        arAPStats;
     u8 ap_hidden_ssid;
     u8 ap_country_code[3];
@@ -748,14 +746,12 @@ u8 remove_sta(struct ar6_softc *ar, u8 *mac, u16 reason);
 
 /* HCI support */
 
-#ifndef EXPORT_HCI_BRIDGE_INTERFACE
 int ar6000_setup_hci(struct ar6_softc *ar);
 void     ar6000_cleanup_hci(struct ar6_softc *ar);
 void     ar6000_set_default_ar3kconfig(struct ar6_softc *ar, void *ar3kconfig);
 
 /* HCI bridge testing */
 int hci_test_send(struct ar6_softc *ar, struct sk_buff *skb);
-#endif
 
 ATH_DEBUG_DECLARE_EXTERN(htc);
 ATH_DEBUG_DECLARE_EXTERN(wmi);
diff --git a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h b/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
deleted file mode 100644
index 74f9861..0000000
--- a/drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
+++ /dev/null
@@ -1,76 +0,0 @@
-//------------------------------------------------------------------------------
-// Copyright (c) 2009-2010 Atheros Corporation.  All rights reserved.
-// 
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//------------------------------------------------------------------------------
-//==============================================================================
-// HCI bridge implementation
-//
-// Author(s): ="Atheros"
-//==============================================================================
-
-#include "hci_transport_api.h"
-#include "common_drv.h"
-
-extern HCI_TRANSPORT_HANDLE (*_HCI_TransportAttach)(void *HTCHandle, struct hci_transport_config_info *pInfo);
-extern void (*_HCI_TransportDetach)(HCI_TRANSPORT_HANDLE HciTrans);
-extern int    (*_HCI_TransportAddReceivePkts)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet_queue *pQueue);
-extern int    (*_HCI_TransportSendPkt)(HCI_TRANSPORT_HANDLE HciTrans, struct htc_packet *pPacket, bool Synchronous);
-extern void        (*_HCI_TransportStop)(HCI_TRANSPORT_HANDLE HciTrans);
-extern int    (*_HCI_TransportStart)(HCI_TRANSPORT_HANDLE HciTrans);
-extern int    (*_HCI_TransportEnableDisableAsyncRecv)(HCI_TRANSPORT_HANDLE HciTrans, bool Enable);
-extern int    (*_HCI_TransportRecvHCIEventSync)(HCI_TRANSPORT_HANDLE HciTrans,
-                                          struct htc_packet           *pPacket,
-                                          int                  MaxPollMS);
-extern int    (*_HCI_TransportSetBaudRate)(HCI_TRANSPORT_HANDLE HciTrans, u32 Baud);
-extern int    (*_HCI_TransportEnablePowerMgmt)(HCI_TRANSPORT_HANDLE HciTrans, bool Enable);
-
-
-#define HCI_TransportAttach(HTCHandle, pInfo)   \
-            _HCI_TransportAttach((HTCHandle), (pInfo))
-#define HCI_TransportDetach(HciTrans)    \
-            _HCI_TransportDetach(HciTrans)
-#define HCI_TransportAddReceivePkts(HciTrans, pQueue)   \
-            _HCI_TransportAddReceivePkts((HciTrans), (pQueue))
-#define HCI_TransportSendPkt(HciTrans, pPacket, Synchronous)  \
-            _HCI_TransportSendPkt((HciTrans), (pPacket), (Synchronous))
-#define HCI_TransportStop(HciTrans)  \
-            _HCI_TransportStop((HciTrans))
-#define HCI_TransportStart(HciTrans)  \
-            _HCI_TransportStart((HciTrans))
-#define HCI_TransportEnableDisableAsyncRecv(HciTrans, Enable)   \
-            _HCI_TransportEnableDisableAsyncRecv((HciTrans), (Enable))
-#define HCI_TransportRecvHCIEventSync(HciTrans, pPacket, MaxPollMS)   \
-            _HCI_TransportRecvHCIEventSync((HciTrans), (pPacket), (MaxPollMS))
-#define HCI_TransportSetBaudRate(HciTrans, Baud)    \
-            _HCI_TransportSetBaudRate((HciTrans), (Baud))
-#define HCI_TransportEnablePowerMgmt(HciTrans, Enable)    \
-            _HCI_TransportEnablePowerMgmt((HciTrans), (Enable))
-
-
-extern int ar6000_register_hci_transport(struct hci_transport_callbacks *hciTransCallbacks);
-
-extern int ar6000_get_hif_dev(struct hif_device *device, void *config);
-
-extern int ar6000_set_uart_config(struct hif_device *hifDevice, u32 scale, u32 step);
-
-/* get core clock register settings
- * data: 0 - 40/44MHz
- *       1 - 80/88MHz
- *       where (5G band/2.4G band)
- * assume 2.4G band for now
- */
-extern int ar6000_get_core_clock_config(struct hif_device *hifDevice, u32 *data);
diff --git a/drivers/staging/ath6kl/os/linux/netbuf.c b/drivers/staging/ath6kl/os/linux/netbuf.c
index 963a2fb..adcd760 100644
--- a/drivers/staging/ath6kl/os/linux/netbuf.c
+++ b/drivers/staging/ath6kl/os/linux/netbuf.c
@@ -221,11 +221,3 @@ a_netbuf_pull_data(void *bufPtr, char *dstPtr, s32 len)
 
     return 0;
 }
-
-#ifdef EXPORT_HCI_BRIDGE_INTERFACE
-EXPORT_SYMBOL(a_netbuf_to_data);
-EXPORT_SYMBOL(a_netbuf_put);
-EXPORT_SYMBOL(a_netbuf_pull);
-EXPORT_SYMBOL(a_netbuf_alloc);
-EXPORT_SYMBOL(a_netbuf_free);
-#endif
-- 
1.7.0.4

