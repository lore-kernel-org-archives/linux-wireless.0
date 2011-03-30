Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47146 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1C3A5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:15 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 16/34] ath6kl: remove unused define WLAN_HEADERS
Date: Tue, 29 Mar 2011 17:56:13 -0700
Message-ID: <1301446591-15236-17-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the code is used so just keep it and remove the static define.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile                    |    1 -
 .../common/AR6002/hw4.0/hw/analog_intf_reg.h       |   13 -------------
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |    8 --------
 .../include/common/AR6002/hw4.0/hw/gpio_reg.h      |    8 --------
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   13 -------------
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |    8 --------
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |    8 --------
 .../include/common/AR6002/hw4.0/hw/umbox_reg.h     |   14 --------------
 .../include/common/AR6002/hw4.0/hw/vmc_reg.h       |    8 --------
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   14 --------------
 drivers/staging/ath6kl/wmi/wmi.c                   |    2 --
 11 files changed, 0 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index d79f862..cd04fba 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -112,7 +112,6 @@ endif
 
 ccflags-y += -DWAPI_ENABLE
 ccflags-y += -DCHECKSUM_OFFLOAD
-ccflags-y += -DWLAN_HEADERS
 ccflags-y += -DINIT_MODE_DRV_ENABLED
 
 obj-$(CONFIG_ATH6K_LEGACY) := ath6kl.o
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h
index 01b9eb5..b8de1c9 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h
@@ -21,17 +21,4 @@
 //===================================================================
 
 
-#ifdef WLAN_HEADERS
-
 #include "analog_intf_athr_wlan_reg.h"
-
-
-#ifndef BT_HEADERS
-
-
-
-#endif
-#endif
-
-
-
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h
index e4d2d62..0068ca3 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h
@@ -21,11 +21,8 @@
 //===================================================================
 
 
-#ifdef WLAN_HEADERS
-
 #include "apb_athr_wlan_map.h"
 
-
 #ifndef BT_HEADERS
 
 #define RTC_BASE_ADDRESS WLAN_RTC_BASE_ADDRESS
@@ -40,9 +37,4 @@
 #define MAC_BASE_ADDRESS WLAN_MAC_BASE_ADDRESS
 #define RDMA_BASE_ADDRESS WLAN_RDMA_BASE_ADDRESS
 
-
-#endif
 #endif
-
-
-
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h
index b3e7126..afef47e 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h
@@ -21,11 +21,8 @@
 //===================================================================
 
 
-#ifdef WLAN_HEADERS
-
 #include "gpio_athr_wlan_reg.h"
 
-
 #ifndef BT_HEADERS
 
 #define GPIO_OUT_ADDRESS WLAN_GPIO_OUT_ADDRESS
@@ -1086,9 +1083,4 @@
 #define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_GET(x) WLAN_RESET_TUPLE_STATUS_PIN_RESET_TUPLE_GET(x)
 #define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_SET(x) WLAN_RESET_TUPLE_STATUS_PIN_RESET_TUPLE_SET(x)
 
-
-#endif
 #endif
-
-
-
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h
index 3af5621..109f24e 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h
@@ -21,17 +21,4 @@
 //===================================================================
 
 
-#ifdef WLAN_HEADERS
-
 #include "mbox_wlan_host_reg.h"
-
-
-#ifndef BT_HEADERS
-
-
-
-#endif
-#endif
-
-
-
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h
index cc67585..72fa483 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h
@@ -21,11 +21,8 @@
 //===================================================================
 
 
-#ifdef WLAN_HEADERS
-
 #include "mbox_wlan_reg.h"
 
-
 #ifndef BT_HEADERS
 
 #define MBOX_FIFO_ADDRESS WLAN_MBOX_FIFO_ADDRESS
@@ -552,9 +549,4 @@
 #define HOST_IF_WINDOW_DATA_GET(x) WLAN_HOST_IF_WINDOW_DATA_GET(x)
 #define HOST_IF_WINDOW_DATA_SET(x) WLAN_HOST_IF_WINDOW_DATA_SET(x)
 
-
-#endif
 #endif
-
-
-
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h
index 0855de5..82bd708 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h
@@ -21,11 +21,8 @@
 //===================================================================
 
 
-#ifdef WLAN_HEADERS
-
 #include "rtc_wlan_reg.h"
 
-
 #ifndef BT_HEADERS
 
 #define RESET_CONTROL_ADDRESS WLAN_RESET_CONTROL_ADDRESS
@@ -967,9 +964,4 @@
 #define GPIO_WAKEUP_CONTROL_ENABLE_GET(x) WLAN_GPIO_WAKEUP_CONTROL_ENABLE_GET(x)
 #define GPIO_WAKEUP_CONTROL_ENABLE_SET(x) WLAN_GPIO_WAKEUP_CONTROL_ENABLE_SET(x)
 
-
-#endif
 #endif
-
-
-
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h
index b233cbc..b18ff48 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h
@@ -20,18 +20,4 @@
 // Author(s): ="Atheros"
 //===================================================================
 
-
-#ifdef WLAN_HEADERS
-
 #include "umbox_wlan_reg.h"
-
-
-#ifndef BT_HEADERS
-
-
-
-#endif
-#endif
-
-
-
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h
index c3d8088..990f2be 100644
--- a/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h
@@ -21,11 +21,8 @@
 //===================================================================
 
 
-#ifdef WLAN_HEADERS
-
 #include "vmc_wlan_reg.h"
 
-
 #ifndef BT_HEADERS
 
 #define MC_BCAM_VALID_ADDRESS WLAN_MC_BCAM_VALID_ADDRESS
@@ -159,9 +156,4 @@
 #define CPU_RAM4_CONFLICT_CNT_GET(x) WLAN_CPU_RAM4_CONFLICT_CNT_GET(x)
 #define CPU_RAM4_CONFLICT_CNT_SET(x) WLAN_CPU_RAM4_CONFLICT_CNT_SET(x)
 
-
-#endif
 #endif
-
-
-
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index abde256..b9d0471 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -152,10 +152,8 @@ unsigned int ar3khcibaud = AR3KHCIBAUD_DEFAULT;
 unsigned int hciuartscale = HCIUARTSCALE_DEFAULT;
 unsigned int hciuartstep = HCIUARTSTEP_DEFAULT;
 #endif
-#ifdef CONFIG_CHECKSUM_OFFLOAD
 unsigned int csumOffload=0;
 unsigned int csumOffloadTest=0;
-#endif
 unsigned int eppingtest=0;
 
 module_param_string(ifname, ifname, sizeof(ifname), 0644);
@@ -177,9 +175,7 @@ module_param(reduce_credit_dribble, int, 0644);
 module_param(allow_trace_signal, int, 0644);
 module_param(enablerssicompensation, uint, 0644);
 module_param(processDot11Hdr, uint, 0644);
-#ifdef CONFIG_CHECKSUM_OFFLOAD
 module_param(csumOffload, uint, 0644);
-#endif
 #ifdef CONFIG_HOST_TCMD_SUPPORT
 module_param(testmode, uint, 0644);
 #endif
@@ -1744,12 +1740,10 @@ ar6000_avail_ev(void *context, void *hif_handle)
 #endif
 
 
-#ifdef CONFIG_CHECKSUM_OFFLOAD
     if(csumOffload){
         /*if external frame work is also needed, change and use an extended rxMetaVerion*/
         ar->rxMetaVersion=WMI_META_VERSION_2;
     }
-#endif
 
     ar->aggr_cntxt = aggr_init(ar6000_alloc_netbufs);
     if (!ar->aggr_cntxt) {
@@ -3006,7 +3000,6 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
         }
 
         if (ar->arWmiEnabled) {
-#ifdef CONFIG_CHECKSUM_OFFLOAD
         u8 csumStart=0;
         u8 csumDest=0;
         u8 csum=skb->ip_summed;
@@ -3015,7 +3008,6 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
 			 sizeof(ATH_LLC_SNAP_HDR));
             csumDest=skb->csum_offset+csumStart;
         }
-#endif
             if (A_NETBUF_HEADROOM(skb) < dev->hard_header_len - LINUX_HACK_FUDGE_FACTOR) {
                 struct sk_buff  *newbuf;
 
@@ -3046,7 +3038,6 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
                     break;
                 }
             }
-#ifdef CONFIG_CHECKSUM_OFFLOAD
             if(csumOffload && (csum ==CHECKSUM_PARTIAL)){
                 WMI_TX_META_V2  metaV2;
                 metaV2.csumStart =csumStart;
@@ -3060,7 +3051,6 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
 
             }
             else
-#endif
             {
                 if (wmi_data_hdr_add(ar->arWmi, skb, DATA_MSGTYPE, bMoreData, dot11Hdr,0,NULL) != 0) {
                     AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_data_tx - wmi_data_hdr_add failed\n"));
@@ -3693,11 +3683,9 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
                             case WMI_META_VERSION_1:
                                 offset += sizeof(WMI_RX_META_V1);
                                 break;
-#ifdef CONFIG_CHECKSUM_OFFLOAD
                             case WMI_META_VERSION_2:
                                 offset += sizeof(WMI_RX_META_V2);
                                 break;
-#endif
                             default:
                                 break;
                         }
@@ -3767,7 +3755,6 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
                                 A_NETBUF_PULL((void*)skb, sizeof(WMI_RX_META_V1));
                                 break;
                             }
-#ifdef CONFIG_CHECKSUM_OFFLOAD
                         case WMI_META_VERSION_2:
                             {
                                 WMI_RX_META_V2 *pMeta = (WMI_RX_META_V2 *)A_NETBUF_DATA(skb);
@@ -3778,7 +3765,6 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
                                 A_NETBUF_PULL((void*)skb, sizeof(WMI_RX_META_V2));
                                 break;
                             }
-#endif
                         default:
                             break;
                     }
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index e1f6acd..3f5bbe3 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -463,7 +463,6 @@ int wmi_meta_add(struct wmi_t *wmip, void *osbuf, u8 *pVersion,void *pTxMetaS)
         	*pVersion = WMI_META_VERSION_1;
 		return (0);
     		}
-#ifdef CONFIG_CHECKSUM_OFFLOAD
 	case WMI_META_VERSION_2:
 		{
      		WMI_TX_META_V2 *pV2 ;
@@ -475,7 +474,6 @@ int wmi_meta_add(struct wmi_t *wmip, void *osbuf, u8 *pVersion,void *pTxMetaS)
          	memcpy(pV2,(WMI_TX_META_V2 *)pTxMetaS,sizeof(WMI_TX_META_V2));
 		return (0);
     		}
-#endif
 	default:
 		return (0);
     }
-- 
1.7.0.4

