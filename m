Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47104 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1C3A4w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Prerepa (Dham) Viswanadham" <dham@atheros.com>,
	Shanmugamkamatchi Balashanmugam <sbalashanmugam@atheros.com>
Subject: [PATCH 07/34] ath6kl: remove Bluetooth PAL code and WMI ACL TX/RX data support
Date: Tue, 29 Mar 2011 17:56:04 -0700
Message-ID: <1301446591-15236-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl used to have an internal PAL for Bluetooth 3.0 support
but this is no longer supported. The target used a WMI with an
ACL header for supporting these frames. Userspace would use
the ioctl AR6000_XIOCTL_ACL_DATA to send data to the target
and the firmware would generate ACL frames.

Remove both the parsing of the frames and the ioctl support.
We leave a warning for now for if the target generates some
sort of ACL data frame, later on we can remove this warning
once we have proven the target is no longer generating these
frames. It should be noted this also provides a fix for the
processing of spurious ACL data frames from the target,
previously they would not be dropped if they were generated
by the target but EXPORT_HCI_PAL_INTERFACE was not compiled
in.

Cc: Naveen Singh <nsingh@atheros.com>
Cc: Prerepa (Dham) Viswanadham <dham@atheros.com>
Cc: Shanmugamkamatchi Balashanmugam <sbalashanmugam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile                    |    1 -
 drivers/staging/ath6kl/include/common/wmi.h        |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   59 +--
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |  479 --------------------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    7 -
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |    2 +-
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |    2 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            |   68 ---
 8 files changed, 22 insertions(+), 598 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6k_pal.c

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index 50c1db0..025027a 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -142,7 +142,6 @@ ath6kl-y += os/linux/netbuf.o
 ath6kl-y += os/linux/wireless_ext.o
 ath6kl-y += os/linux/ioctl.o
 ath6kl-y += os/linux/hci_bridge.o
-ath6kl-y += os/linux/ar6k_pal.o
 ath6kl-y += miscdrv/common_drv.o
 ath6kl-y += miscdrv/credit_dist.o
 ath6kl-y += wmi/wmi.o
diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
index c645af3..d3de3cc 100644
--- a/drivers/staging/ath6kl/include/common/wmi.h
+++ b/drivers/staging/ath6kl/include/common/wmi.h
@@ -118,7 +118,7 @@ typedef enum {
 typedef enum {
     WMI_DATA_HDR_DATA_TYPE_802_3 = 0,
     WMI_DATA_HDR_DATA_TYPE_802_11,
-    WMI_DATA_HDR_DATA_TYPE_ACL,
+    WMI_DATA_HDR_DATA_TYPE_ACL, /* used to be used for the PAL */
 } WMI_DATA_HDR_DATA_TYPE;
 
 #define WMI_DATA_HDR_DATA_TYPE_MASK     0x3
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 94b9132..3dfbb0d 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -147,7 +147,6 @@ unsigned int panic_on_assert = 1;
 unsigned int nohifscattersupport = NOHIFSCATTERSUPPORT_DEFAULT;
 
 unsigned int setuphci = SETUPHCI_DEFAULT;
-unsigned int setuphcipal = SETUPHCIPAL_DEFAULT;
 unsigned int loghci = 0;
 unsigned int setupbtdev = SETUPBTDEV_DEFAULT;
 #ifndef EXPORT_HCI_BRIDGE_INTERFACE
@@ -190,7 +189,6 @@ module_param(irqprocmode, uint, 0644);
 module_param(nohifscattersupport, uint, 0644);
 module_param(panic_on_assert, uint, 0644);
 module_param(setuphci, uint, 0644);
-module_param(setuphcipal, uint, 0644);
 module_param(loghci, uint, 0644);
 module_param(setupbtdev, uint, 0644);
 #ifndef EXPORT_HCI_BRIDGE_INTERFACE
@@ -344,8 +342,6 @@ ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
 static int
 ar6000_sysfs_bmi_init(struct ar6_softc *ar);
 
-/* HCI PAL callback function declarations */
-int ar6k_setup_hci_pal(struct ar6_softc *ar);
 void  ar6k_cleanup_hci_pal(struct ar6_softc *ar);
 
 static void
@@ -2028,15 +2024,6 @@ ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs)
         if (setuphci)
         	ar6000_cleanup_hci(ar);
 #endif
-#ifdef EXPORT_HCI_PAL_INTERFACE
-        if (setuphcipal && (NULL != ar6kHciPalCallbacks_g.cleanupTransport)) {
-           ar6kHciPalCallbacks_g.cleanupTransport(ar);
-        }
-#else
-				/* cleanup hci pal driver data structures */
-        if(setuphcipal)
-          ar6k_cleanup_hci_pal(ar);
-#endif
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO,(" Shutting down HTC .... \n"));
         /* stop HTC */
         HTCStop(ar->arHtcTarget);
@@ -2737,13 +2724,6 @@ int ar6000_init(struct net_device *dev)
             status = ar6000_setup_hci(ar);
         }
 #endif
-#ifdef EXPORT_HCI_PAL_INTERFACE
-        if (setuphcipal && (NULL != ar6kHciPalCallbacks_g.setupTransport))
-          status = ar6kHciPalCallbacks_g.setupTransport(ar);
-#else
-        if(setuphcipal)
-          status = ar6k_setup_hci_pal(ar);
-#endif
 
     } while (false);
 
@@ -3705,8 +3685,23 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
                 WMI_DATA_HDR *dhdr = (WMI_DATA_HDR *)A_NETBUF_DATA(skb);
                 bool is_amsdu;
                 u8 tid;
-                bool is_acl_data_frame;
-                is_acl_data_frame = WMI_DATA_HDR_GET_DATA_TYPE(dhdr) == WMI_DATA_HDR_DATA_TYPE_ACL;
+
+		/*
+		 * This check can be removed if after a while we do not
+		 * see the warning. For now we leave it to ensure
+		 * we drop these frames accordingly in case the
+		 * target generates them for some reason. These
+		 * were used for an internal PAL but that's not
+		 * used or supported anymore. These frames should
+		 * not come up from the target.
+		 */
+                if (WARN_ON(WMI_DATA_HDR_GET_DATA_TYPE(dhdr) ==
+			    WMI_DATA_HDR_DATA_TYPE_ACL)) {
+			AR6000_STAT_INC(ar, rx_errors);
+			A_NETBUF_FREE(skb);
+			return;
+		}
+
 #ifdef CONFIG_PM 
                 ar6000_check_wow_status(ar, NULL, false);
 #endif /* CONFIG_PM */
@@ -3728,7 +3723,7 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
                  * ACL data frames don't follow ethernet frame bounds for
                  * min length
                  */
-                if (ar->arNetworkType != AP_NETWORK &&  !is_acl_data_frame &&
+                if (ar->arNetworkType != AP_NETWORK &&
                     ((pPacket->ActualLength < minHdrLen) ||
                     (pPacket->ActualLength > AR6000_MAX_RX_MESSAGE_SIZE)))
                 {
@@ -3863,7 +3858,7 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
                     /* NWF: print the 802.11 hdr bytes */
                     if(containsDot11Hdr) {
                         status = wmi_dot11_hdr_remove(ar->arWmi,skb);
-                    } else if(!is_amsdu && !is_acl_data_frame) {
+                    } else if(!is_amsdu) {
                         status = wmi_dot3_2_dix(skb);
                     }
 
@@ -3873,16 +3868,6 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
                         goto rx_done;
                     }
 
-                    if (is_acl_data_frame) {
-                        A_NETBUF_PUSH(skb, sizeof(int));
-                        *((short *)A_NETBUF_DATA(skb)) = WMI_ACL_DATA_EVENTID;
-	                /* send the data packet to PAL driver */
-			if(ar6k_pal_config_g.fpar6k_pal_recv_pkt) {
-				if((*ar6k_pal_config_g.fpar6k_pal_recv_pkt)(ar->hcipal_info, skb) == true)
-					goto rx_done;
-			}
-                    }
-
                     if ((ar->arNetDev->flags & IFF_UP) == IFF_UP) {
                         if (ar->arNetworkType == AP_NETWORK) {
                             struct sk_buff *skb1 = NULL;
@@ -4829,12 +4814,6 @@ ar6000_hci_event_rcv_evt(struct ar6_softc *ar, WMI_HCI_EVENT *cmd)
     buf += sizeof(int);
     memcpy(buf, cmd->buf, cmd->evt_buf_sz);
 
-    if(ar6k_pal_config_g.fpar6k_pal_recv_pkt)
-    {
-      /* pass the cmd packet to PAL driver */
-      if((*ar6k_pal_config_g.fpar6k_pal_recv_pkt)(ar->hcipal_info, osbuf) == true)
-        return;
-    }
     ar6000_deliver_frames_to_nw_stack(ar->arNetDev, osbuf);
     if(loghci) {
         A_PRINTF_LOG("HCI Event From PAL <-- \n");
diff --git a/drivers/staging/ath6kl/os/linux/ar6k_pal.c b/drivers/staging/ath6kl/os/linux/ar6k_pal.c
deleted file mode 100644
index 7e6279f..0000000
--- a/drivers/staging/ath6kl/os/linux/ar6k_pal.c
+++ /dev/null
@@ -1,479 +0,0 @@
-//------------------------------------------------------------------------------
-// Copyright (c) 2004-2010 Atheros Communications Inc.
-// All rights reserved.
-//
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
-//
-// Author(s): ="Atheros"
-//------------------------------------------------------------------------------
-
-#include "ar6000_drv.h"
-#ifdef AR6K_ENABLE_HCI_PAL
-#include <net/bluetooth/bluetooth.h>
-#include <net/bluetooth/hci_core.h>
-#include <ar6k_pal.h>
-
-extern unsigned int setupbtdev;
-#define bt_check_bit(val, bit) (val & bit)
-#define bt_set_bit(val, bit) (val |= bit)
-#define bt_clear_bit(val, bit) (val &= ~bit)
-
-/* export ATH_AR6K_DEBUG_HCI_PAL=yes in host/localmake.linux.inc
- * to enable debug information */
-#ifdef HCIPAL_DEBUG
-#define PRIN_LOG(format, args...) printk(KERN_ALERT "%s:%d - %s Msg:" format "\n",__FUNCTION__, __LINE__, __FILE__, ## args) 
-#else
-#define PRIN_LOG(format, args...)
-#endif
-
-/**********************************
- * HCI PAL private info structure 
- *********************************/
-typedef struct ar6k_hci_pal_info_s{
-
-	unsigned long ulFlags;
-#define HCI_NORMAL_MODE (1)
-#define HCI_REGISTERED (1<<1)
-	struct hci_dev *hdev;            /* BT Stack HCI dev */
-	struct ar6_softc *ar;
-
-}ar6k_hci_pal_info_t;
-
-/*** BT Stack Entrypoints *******/
-/***************************************
- * bt_open - open a handle to the device
- ***************************************/
-static int bt_open(struct hci_dev *hdev)
-{
-	PRIN_LOG("HCI PAL: bt_open - enter - x\n");
-	set_bit(HCI_RUNNING, &hdev->flags);
-	set_bit(HCI_UP, &hdev->flags);
-	set_bit(HCI_INIT, &hdev->flags);         
-	return 0;
-}
-
-/***************************************
- * bt_close - close handle to the device
- ***************************************/
-static int bt_close(struct hci_dev *hdev)
-{
-	PRIN_LOG("HCI PAL: bt_close - enter\n");
-	clear_bit(HCI_RUNNING, &hdev->flags);
-	return 0;
-}
-
-/*****************************
- * bt_ioctl - ioctl processing
- *****************************/
-static int bt_ioctl(struct hci_dev *hdev, unsigned int cmd, unsigned long arg)
-{
-	PRIN_LOG("HCI PAL: bt_ioctl - enter\n");
-	return -ENOIOCTLCMD;
-}
-
-/**************************************
- * bt_flush - flush outstanding packets
- **************************************/
-static int bt_flush(struct hci_dev *hdev)
-{
-	PRIN_LOG("HCI PAL: bt_flush - enter\n");
-	return 0;
-}
-
-/***************
- * bt_destruct  
- ***************/
-static void bt_destruct(struct hci_dev *hdev)
-{
-	PRIN_LOG("HCI PAL: bt_destruct - enter\n");
-	/* nothing to do here */
-}
-
-/****************************************************
- * Invoked from bluetooth stack via hdev->send()
- * to send the packet out via ar6k to PAL firmware.
- *
- * For HCI command packet wmi_send_hci_cmd() is invoked.
- * wmi_send_hci_cmd adds WMI_CMD_HDR and sends the packet
- * to PAL firmware.
- *
- * For HCI ACL data packet wmi_data_hdr_add is invoked 
- * to add WMI_DATA_HDR to the packet.  ar6000_acl_data_tx 
- * is then invoked to send the packet to PAL firmware.
- ******************************************************/
-static int btpal_send_frame(struct sk_buff *skb)
-{
-	struct hci_dev *hdev = (struct hci_dev *)skb->dev;
-	HCI_TRANSPORT_PACKET_TYPE type;
-	ar6k_hci_pal_info_t *pHciPalInfo;
-	int status = 0;
-	struct sk_buff *txSkb = NULL;
-	struct ar6_softc *ar;
-
-	if (!hdev) {
-		PRIN_LOG("HCI PAL: btpal_send_frame - no device\n");
-		return -ENODEV;
-	}
-
-	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
-		PRIN_LOG("HCI PAL: btpal_send_frame - not open\n");
-		return -EBUSY;
-	}
-
-	pHciPalInfo = (ar6k_hci_pal_info_t *)hdev->driver_data;   
-	A_ASSERT(pHciPalInfo != NULL);
-	ar = pHciPalInfo->ar;
-
-	PRIN_LOG("+btpal_send_frame type: %d \n",bt_cb(skb)->pkt_type);
-	type = HCI_COMMAND_TYPE;
-
-	switch (bt_cb(skb)->pkt_type) {
-		case HCI_COMMAND_PKT:
-			type = HCI_COMMAND_TYPE;
-			hdev->stat.cmd_tx++;
-			break;
-
-		case HCI_ACLDATA_PKT:
-			type = HCI_ACL_TYPE;
-			hdev->stat.acl_tx++;
-			break;
-
-		case HCI_SCODATA_PKT:
-			/* we don't support SCO over the pal */
-			kfree_skb(skb);
-			return 0;
-		default:
-			A_ASSERT(false);
-			kfree_skb(skb);
-			return 0;
-	} 
-
-	if (AR_DEBUG_LVL_CHECK(ATH_DEBUG_HCI_DUMP)) {
-		A_PRINTF(">>> Send HCI %s packet len: %d\n",
-				(type == HCI_COMMAND_TYPE) ? "COMMAND" : "ACL",
-				skb->len);
-		if (type == HCI_COMMAND_TYPE) {
-			PRIN_LOG("    HCI Command: OGF:0x%X OCF:0x%X \r\n", 
-					HCI_GET_OP_CODE(skb-data) >> 10, HCI_GET_OP_CODE(skb-data) & 0x3FF);
-		}
-		AR_DEBUG_PRINTBUF(skb->data,skb->len,"BT HCI SEND Packet Dump");
-	}
-
-	do {
-		if(type == HCI_COMMAND_TYPE)
-		{
-			PRIN_LOG("HCI command");
-
-			if (ar->arWmiReady == false)
-			{
-				PRIN_LOG("WMI not ready ");
-				break;
-			}
-
-			if (wmi_send_hci_cmd(ar->arWmi, skb->data, skb->len) != 0)
-			{
-				PRIN_LOG("send hci cmd error");
-				break;
-			}
-		}
-		else if(type == HCI_ACL_TYPE)
-		{
-			void *osbuf;
-
-			PRIN_LOG("ACL data");
-			if (ar->arWmiReady == false)
-			{
-				PRIN_LOG("WMI not ready");
-				break;
-			}
-
-			/* need to add WMI header so allocate a skb with more space */
-			txSkb = bt_skb_alloc(TX_PACKET_RSV_OFFSET + WMI_MAX_TX_META_SZ + 
-					sizeof(WMI_DATA_HDR) + skb->len, 
-					GFP_ATOMIC);
-
-			if (txSkb == NULL) {
-				status = A_NO_MEMORY;
-				PRIN_LOG("No memory");
-				break;
-			}
-
-			bt_cb(txSkb)->pkt_type = bt_cb(skb)->pkt_type;
-			txSkb->dev = (void *)pHciPalInfo->hdev;
-			skb_reserve(txSkb, TX_PACKET_RSV_OFFSET + WMI_MAX_TX_META_SZ + sizeof(WMI_DATA_HDR));
-			memcpy(txSkb->data, skb->data, skb->len);
-			skb_put(txSkb,skb->len);
-			/* Add WMI packet type */
-			osbuf = (void *)txSkb;
-
-			if (wmi_data_hdr_add(ar->arWmi, osbuf, DATA_MSGTYPE, 0, WMI_DATA_HDR_DATA_TYPE_ACL,0,NULL) != 0) {
-				PRIN_LOG("XIOCTL_ACL_DATA - wmi_data_hdr_add failed\n");
-			} else {
-				/* Send data buffer over HTC */
-				PRIN_LOG("acl data tx");
-				ar6000_acl_data_tx(osbuf, ar->arNetDev);
-			}
-			txSkb = NULL;
-		}
-	} while (false);
-
-	if (txSkb != NULL) {
-		PRIN_LOG("Free skb");
-		kfree_skb(txSkb);    
-	}
-	kfree_skb(skb);        
-	return 0;
-}
-
-
-/***********************************************
- * Unregister HCI device and free HCI device info
- ***********************************************/
-static void bt_cleanup_hci_pal(ar6k_hci_pal_info_t *pHciPalInfo)
-{   
-	int err;      
-
-	if (bt_check_bit(pHciPalInfo->ulFlags, HCI_REGISTERED)) {
-		bt_clear_bit(pHciPalInfo->ulFlags, HCI_REGISTERED);
-		clear_bit(HCI_RUNNING, &pHciPalInfo->hdev->flags);
-		clear_bit(HCI_UP, &pHciPalInfo->hdev->flags);
-		clear_bit(HCI_INIT, &pHciPalInfo->hdev->flags);   
-		A_ASSERT(pHciPalInfo->hdev != NULL);
-		/* unregister */
-		PRIN_LOG("Unregister PAL device");
-		if ((err = hci_unregister_dev(pHciPalInfo->hdev)) < 0) {
-			PRIN_LOG("HCI PAL: failed to unregister with bluetooth %d\n",err);
-		}          
-	}
-
-	kfree(pHciPalInfo->hdev);
-	pHciPalInfo->hdev = NULL;
-}
-
-/*********************************************************
- * Allocate HCI device and store in PAL private info structure.
- *********************************************************/
-static int bt_setup_hci_pal(ar6k_hci_pal_info_t *pHciPalInfo)
-{
-	int status = 0;
-	struct hci_dev *pHciDev = NULL;
-
-	if (!setupbtdev) {
-		return 0;
-	} 
-
-	do {
-		/* allocate a BT HCI struct for this device */
-		pHciDev = hci_alloc_dev();
-		if (NULL == pHciDev) {
-			PRIN_LOG("HCI PAL driver - failed to allocate BT HCI struct \n");
-			status = A_NO_MEMORY;
-			break;
-		}    
-
-		/* save the device, we'll register this later */
-		pHciPalInfo->hdev = pHciDev;       
-                SET_HCI_BUS_TYPE(pHciDev, HCI_VIRTUAL, HCI_80211);
-		pHciDev->driver_data = pHciPalInfo;
-		pHciDev->open     = bt_open;
-		pHciDev->close    = bt_close;
-		pHciDev->send     = btpal_send_frame;
-		pHciDev->ioctl    = bt_ioctl;
-		pHciDev->flush    = bt_flush;
-		pHciDev->destruct = bt_destruct;
-		pHciDev->owner = THIS_MODULE; 
-		/* driver is running in normal BT mode */
-		PRIN_LOG("Normal mode enabled");
-		bt_set_bit(pHciPalInfo->ulFlags, HCI_NORMAL_MODE);
-
-	} while (false);
-
-	if (status) {
-		bt_cleanup_hci_pal(pHciPalInfo);    
-	}
-	return status;
-}
-
-/**********************************************
- * Cleanup HCI device and free HCI PAL private info
- *********************************************/
-void ar6k_cleanup_hci_pal(void *ar_p)
-{
-	struct ar6_softc *ar = (struct ar6_softc *)ar_p;
-	ar6k_hci_pal_info_t *pHciPalInfo = (ar6k_hci_pal_info_t *)ar->hcipal_info;
-
-	if (pHciPalInfo != NULL) {
-		bt_cleanup_hci_pal(pHciPalInfo);   
-		kfree(pHciPalInfo);
-		ar->hcipal_info = NULL;
-	}
-}
-
-/****************************
- *  Register HCI device
- ****************************/
-static bool ar6k_pal_transport_ready(void *pHciPal)
-{
-	ar6k_hci_pal_info_t *pHciPalInfo = (ar6k_hci_pal_info_t *)pHciPal;
-
-	PRIN_LOG("HCI device transport ready");
-	if(pHciPalInfo == NULL)
-		return false;
-
-	if (hci_register_dev(pHciPalInfo->hdev) < 0) {
-		PRIN_LOG("Can't register HCI device");
-		hci_free_dev(pHciPalInfo->hdev);
-		return false;
-	}
-	PRIN_LOG("HCI device registered");
-	pHciPalInfo->ulFlags |= HCI_REGISTERED;
-	return true;
-}
-
-/**************************************************
- * Called from ar6k driver when command or ACL data 
- * packet is received. Pass the packet to bluetooth
- * stack via hci_recv_frame.
- **************************************************/
-bool ar6k_pal_recv_pkt(void *pHciPal, void *osbuf)
-{
-	struct sk_buff *skb = (struct sk_buff *)osbuf;
-	ar6k_hci_pal_info_t *pHciPalInfo;
-	bool success = false;
-	u8 btType = 0;
-	pHciPalInfo = (ar6k_hci_pal_info_t *)pHciPal;
-
-	do {
-
-		/* if normal mode is not enabled pass on to the stack
-		 * by returning failure */
-		if(!(pHciPalInfo->ulFlags & HCI_NORMAL_MODE))
-		{
-			PRIN_LOG("Normal mode not enabled");
-			break;
-		}
-
-		if (!test_bit(HCI_RUNNING, &pHciPalInfo->hdev->flags)) {
-			PRIN_LOG("HCI PAL: HCI - not running\n");
-			break;
-		}
-
-		if(*((short *)A_NETBUF_DATA(skb)) == WMI_ACL_DATA_EVENTID)
-			btType = HCI_ACLDATA_PKT;
-		else
-			btType = HCI_EVENT_PKT;
-		/* pull 4 bytes which contains WMI packet type */
-		A_NETBUF_PULL(skb, sizeof(int));
-		bt_cb(skb)->pkt_type = btType;
-		skb->dev = (void *)pHciPalInfo->hdev;
-
-		/* pass the received event packet up the stack */    
-		if (hci_recv_frame(skb) != 0) {
-			PRIN_LOG("HCI PAL: hci_recv_frame failed \n");
-			break;
-		} else {
-			PRIN_LOG("HCI PAL: Indicated RCV of type:%d, Length:%d \n",HCI_EVENT_PKT, skb->len);
-		}
-		PRIN_LOG("hci recv success");
-		success = true;
-	}while(false);
-	return success;
-}
-
-/**********************************************************
- * HCI PAL init function called from ar6k when it is loaded..
- * Allocates PAL private info, stores the same in ar6k private info.
- * Registers a HCI device.
- * Registers packet receive callback function with ar6k 
- **********************************************************/
-int ar6k_setup_hci_pal(void *ar_p)
-{
-	int status = 0;
-	ar6k_hci_pal_info_t *pHciPalInfo;
-	ar6k_pal_config_t ar6k_pal_config;
-	struct ar6_softc *ar = (struct ar6_softc *)ar_p;
-
-	do {
-
-		pHciPalInfo = (ar6k_hci_pal_info_t *)A_MALLOC(sizeof(ar6k_hci_pal_info_t));
-
-		if (NULL == pHciPalInfo) {
-			status = A_NO_MEMORY;
-			break;    
-		}
-
-		A_MEMZERO(pHciPalInfo, sizeof(ar6k_hci_pal_info_t));
-		ar->hcipal_info = pHciPalInfo;
-		pHciPalInfo->ar = ar;
-
-		status = bt_setup_hci_pal(pHciPalInfo);
-		if (status) {
-			break;    
-		}
-
-		if(bt_check_bit(pHciPalInfo->ulFlags, HCI_NORMAL_MODE))
-			PRIN_LOG("HCI PAL: running in normal mode... \n");    
-		else 
-			PRIN_LOG("HCI PAL: running in test mode... \n");     
-
-		ar6k_pal_config.fpar6k_pal_recv_pkt = ar6k_pal_recv_pkt;
-		register_pal_cb(&ar6k_pal_config);
-		ar6k_pal_transport_ready(ar->hcipal_info);
-	} while (false);
-
-	if (status) {
-		ar6k_cleanup_hci_pal(ar);    
-	}
-	return status;
-}
-#else  /* AR6K_ENABLE_HCI_PAL */
-int ar6k_setup_hci_pal(void *ar_p)
-{
-	return 0;
-}
-void ar6k_cleanup_hci_pal(void *ar_p)
-{
-}
-#endif /* AR6K_ENABLE_HCI_PAL */
-
-#ifdef EXPORT_HCI_PAL_INTERFACE
-/*****************************************************
- * Register init and callback function with ar6k
- * when PAL driver is a separate kernel module.
- ****************************************************/
-int ar6k_register_hci_pal(struct hci_transport_callbacks *hciTransCallbacks);
-static int __init pal_init_module(void)
-{
-	struct hci_transport_callbacks hciTransCallbacks;
-
-	hciTransCallbacks.setupTransport = ar6k_setup_hci_pal;
-	hciTransCallbacks.cleanupTransport = ar6k_cleanup_hci_pal;
-
-	if(ar6k_register_hci_pal(&hciTransCallbacks) != 0)
-		return -ENODEV;
-
-	return 0;
-}
-
-static void __exit pal_cleanup_module(void)
-{
-}
-
-module_init(pal_init_module);
-module_exit(pal_cleanup_module);
-MODULE_LICENSE("Dual BSD/GPL");
-#endif
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index dc27860..781e18f 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -215,12 +215,6 @@ typedef enum _AR6K_BIN_FILE {
 #define SETUPHCI_DEFAULT           0
 #endif /* SETUPHCI_ENABLED */
 
-#ifdef SETUPHCIPAL_ENABLED
-#define SETUPHCIPAL_DEFAULT           1
-#else
-#define SETUPHCIPAL_DEFAULT           0
-#endif /* SETUPHCIPAL_ENABLED */
-
 #ifdef SETUPBTDEV_ENABLED
 #define SETUPBTDEV_DEFAULT         1
 #else
@@ -571,7 +565,6 @@ struct ar6_softc {
 #ifndef EXPORT_HCI_BRIDGE_INTERFACE
     void                    *hcidev_info;
 #endif
-    void                    *hcipal_info;
     WMI_AP_MODE_STAT        arAPStats;
     u8 ap_hidden_ssid;
     u8 ap_country_code[3];
diff --git a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
index 66817c2..065b09b 100644
--- a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
@@ -942,7 +942,7 @@ typedef enum {
 
 #define AR6000_XIOCTL_HCI_CMD                       132
 
-#define AR6000_XIOCTL_ACL_DATA                      133
+#define AR6000_XIOCTL_ACL_DATA                      133 /* used to be used for PAL */
 
 #define AR6000_XIOCTL_WLAN_CONN_PRECEDENCE          134
 
diff --git a/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h b/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
index d172625..1eb6f82 100644
--- a/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
@@ -266,7 +266,7 @@ u8 xioctl_filter[] = {
 (0xFF),                                         /* AR6000_XIOCTL_DELE_AGGR                         130  */
 (0xFF),                                         /* AR6000_XIOCTL_FETCH_TARGET_REGS                 131  */
 (0xFF),                                         /* AR6000_XIOCTL_HCI_CMD                           132  */
-(0xFF),                                         /* AR6000_XIOCTL_ACL_DATA                          133  */
+(0xFF),                                         /* AR6000_XIOCTL_ACL_DATA(used to be used for PAL) 133  */
 (0xFF),                                         /* AR6000_XIOCTL_WLAN_CONN_PRECEDENCE              134  */
 (AP_NETWORK),                                   /* AR6000_XIOCTL_AP_SET_11BG_RATESET               135  */
 (0xFF),
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index f2acc68..711f43a 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -1488,57 +1488,6 @@ prof_count_rx(u32 addr, u32 count)
 }
 #endif /* CONFIG_TARGET_PROFILE_SUPPORT */
 
-
-static int
-ar6000_create_acl_data_osbuf(struct net_device *dev, u8 *userdata, void **p_osbuf)
-{
-    void *osbuf = NULL;
-    u8 tmp_space[8];
-    HCI_ACL_DATA_PKT *acl;
-    u8 hdr_size, *datap=NULL;
-    int ret = 0;
-
-    /* ACL is in data path. There is a need to create pool
-     * mechanism for allocating and freeing NETBUFs - ToDo later.
-     */
-
-    *p_osbuf = NULL;
-    acl = (HCI_ACL_DATA_PKT *)tmp_space;
-    hdr_size = sizeof(acl->hdl_and_flags) + sizeof(acl->data_len);
-
-    do {
-        if (a_copy_from_user(acl, userdata, hdr_size)) {
-            ret = A_EFAULT;
-            break;
-        }
-
-        osbuf = A_NETBUF_ALLOC(hdr_size + acl->data_len);
-        if (osbuf == NULL) {
-           ret = A_NO_MEMORY;
-           break;
-        }
-        A_NETBUF_PUT(osbuf, hdr_size + acl->data_len);
-        datap = (u8 *)A_NETBUF_DATA(osbuf);
-
-        /* Real copy to osbuf */
-        acl = (HCI_ACL_DATA_PKT *)(datap);
-        memcpy(acl, tmp_space, hdr_size);
-        if (a_copy_from_user(acl->data, userdata + hdr_size, acl->data_len)) {
-            ret = A_EFAULT;
-            break;
-        }
-    } while(false);
-
-    if (ret == 0) {
-        *p_osbuf = osbuf;
-    } else {
-        A_NETBUF_FREE(osbuf);
-    }
-    return ret;
-}
-
-
-
 int
 ar6000_ioctl_ap_setparam(struct ar6_softc *ar, int param, int value)
 {
@@ -4411,23 +4360,6 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
              break;
         }
 #endif
-        case AR6000_XIOCTL_ACL_DATA:
-        {
-            void *osbuf = NULL;
-            if (ar->arWmiReady == false) {
-                ret = -EIO;
-            } else if (ar6000_create_acl_data_osbuf(dev, (u8 *)userdata, &osbuf) != 0) {
-                     ret = -EIO;
-            } else {
-                if (wmi_data_hdr_add(ar->arWmi, osbuf, DATA_MSGTYPE, 0, WMI_DATA_HDR_DATA_TYPE_ACL,0,NULL) != 0) {
-                    AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("XIOCTL_ACL_DATA - wmi_data_hdr_add failed\n"));
-                } else {
-                    /* Send data buffer over HTC */
-                    ar6000_acl_data_tx(osbuf, ar->arNetDev);
-                }
-            }
-            break;
-        }
         case AR6000_XIOCTL_HCI_CMD:
         {
             char tmp_buf[512];
-- 
1.7.0.4

