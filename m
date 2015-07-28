Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47896 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbbG1IsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:48:22 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/21] staging: wilc1000: remove dead codes related to SIMULATION
Date: Tue, 28 Jul 2015 17:47:22 +0900
Message-ID: <1438073261-28315-4-git-send-email-tony.cho@atmel.com> (sfid-20150728_104833_586470_72195119)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes preprocessor conditionals (#ifdef or #ifndef) related
to SIMULATION definition from the codes becasue that SIMULATION feature is not
used anymore.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 86 -----------------------
 drivers/staging/wilc1000/host_interface.c         | 23 ------
 drivers/staging/wilc1000/linux_mon.c              | 15 +---
 drivers/staging/wilc1000/linux_wlan.c             |  2 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 13 ----
 5 files changed, 3 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b069614..8bacd8c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1877,89 +1877,6 @@ s32 ConfigWaitResponse(char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32Bytes
 	return s32Error;
 }
 
-/**
- *  @brief              sends certain Configuration Packet based on the input WIDs pstrWIDs
- *                      and retrieves the packet response pu8RxResp
- *  @details
- *  @param[in]  pstrWIDs WIDs to be sent in the configuration packet
- *  @param[in]  u32WIDsCount number of WIDs to be sent in the configuration packet
- *  @param[out]         pu8RxResp The received Packet Response
- *  @param[out]         ps32RxRespLen Length of the received Packet Response
- *  @return     Error code indicating success/failure
- *  @note
- *  @author	mabubakr
- *  @date		1 Mar 2012
- *  @version	1.0
- */
-#ifdef SIMULATION
-s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
-{
-	s32 s32Error = WILC_SUCCESS;
-	s32 err = WILC_SUCCESS;
-	s32 s32ConfigPacketLen = 0;
-	s32 s32RcvdRespLen = 0;
-
-	down(&SemHandleSendPkt);
-
-	/*set the packet mode*/
-	g_oper_mode = u8Mode;
-
-	WILC_memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
-
-	if (CreateConfigPacket(gps8ConfigPacket, &s32ConfigPacketLen, pstrWIDs, u32WIDsCount) != WILC_SUCCESS) {
-		s32Error = WILC_FAIL;
-		goto End_ConfigPkt;
-	}
-	/*bug 3878*/
-	gstrConfigPktInfo.pcRespBuffer = gps8ConfigPacket;
-	gstrConfigPktInfo.s32MaxRespBuffLen = MAX_PACKET_BUFF_SIZE;
-	PRINT_INFO(CORECONFIG_DBG, "GLOBAL =bRespRequired =%d\n", bRespRequired);
-	gstrConfigPktInfo.bRespRequired = bRespRequired;
-
-	s32Error = SendRawPacket(gps8ConfigPacket, s32ConfigPacketLen);
-	if (s32Error != WILC_SUCCESS) {
-		goto End_ConfigPkt;
-	}
-
-	WILC_memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
-
-	ConfigWaitResponse(gps8ConfigPacket, MAX_PACKET_BUFF_SIZE, &s32RcvdRespLen, bRespRequired);
-
-
-	if (bRespRequired)	{
-		/* If the operating Mode is GET, then we expect a response frame from */
-		/* the driver. Hence start listening to the port for response         */
-		if (g_oper_mode == GET_CFG) {
-			#if 1
-			err = ParseResponse(gps8ConfigPacket, pstrWIDs);
-			if (err != 0) {
-				s32Error = WILC_FAIL;
-				goto End_ConfigPkt;
-			} else {
-				s32Error = WILC_SUCCESS;
-			}
-			#endif
-		} else {
-			err = ParseWriteResponse(gps8ConfigPacket);
-			if (err != WRITE_RESP_SUCCESS) {
-				s32Error = WILC_FAIL;
-				goto End_ConfigPkt;
-			} else {
-				s32Error = WILC_SUCCESS;
-			}
-		}
-
-
-	}
-
-
-End_ConfigPkt:
-	up(&SemHandleSendPkt);
-
-	return s32Error;
-}
-#endif
 s32 ConfigProvideResponse(char *pcRespBuffer, s32 s32RespLen)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -2052,8 +1969,6 @@ s32 CoreConfiguratorDeInit(void)
 	return s32Error;
 }
 
-
-#ifndef SIMULATION
 /*Using the global handle of the driver*/
 extern wilc_wlan_oup_t *gpstrWlanOps;
 /**
@@ -2127,4 +2042,3 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 
 	return ret;
 }
-#endif
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c089e73..02aaf39 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -570,9 +570,7 @@ static u8 gs8GetIP[2][4];
 static u32 gu32InactiveTime;
 static u8 gu8DelBcn;
 #endif
-#ifndef SIMULATION
 static u32 gu32WidConnRstHack;
-#endif
 
 /*BugID_5137*/
 u8 *gu8FlushedJoinReq;
@@ -1626,14 +1624,12 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		strWIDList[u32WidsCount].ps8WidVal = (s8 *)&u8bssDscListIndex;
 		u32WidsCount++;
 
-		#ifndef SIMULATION
 		/* A temporary workaround to avoid handling the misleading MAC_DISCONNECTED raised from the
 		 *   firmware at chip reset when processing the WIDs of the Connect Request.
 		 *   (This workaround should be removed in the future when the Chip reset of the Connect WIDs is disabled) */
 		/* ////////////////////// */
 		gu32WidConnRstHack = 0;
 		/* ////////////////////// */
-		#endif
 
 		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
 		if (s32Error) {
@@ -1936,14 +1932,12 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	#endif /* #ifdef WILC_PARSE_SCAN_IN_HOST*/
 	u32WidsCount++;
 
-	#ifndef SIMULATION
 	/* A temporary workaround to avoid handling the misleading MAC_DISCONNECTED raised from the
 	 *   firmware at chip reset when processing the WIDs of the Connect Request.
 	 *   (This workaround should be removed in the future when the Chip reset of the Connect WIDs is disabled) */
 	/* ////////////////////// */
 	gu32WidConnRstHack = 0;
 	/* ////////////////////// */
-	#endif
 
 	/*BugID_5137*/
 	if (WILC_memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
@@ -6586,12 +6580,6 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	sema_init(&(pstrWFIDrv->gtOsCfgValuesSem), 1);
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
-
-
-#ifdef SIMULATION
-	TransportInit();
-#endif
-
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 	/* gWFiDrvHandle->bPendingConnRequest = false; */
 
@@ -6627,11 +6615,6 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 		goto _fail_mem_;
 	}
 
-#ifdef SIMULATION
-	/*Initialize Simulaor*/
-	CoreConfigSimulatorInit();
-#endif
-
 	u32Intialized = 1;
 	clients_count++; /* increase number of created entities */
 
@@ -6731,13 +6714,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 		pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 	}
 	/*deinit configurator and simulator*/
-#ifdef SIMULATION
-	CoreConfigSimulatorDeInit();
-#endif
 	CoreConfiguratorDeInit();
-#ifdef SIMULATION
-	TransportDeInit();
-#endif
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index d812a3b..aa20421 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -6,20 +6,15 @@
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-
-#ifndef SIMULATION
 #include "wilc_wfi_cfgoperations.h"
 #include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
-#endif
+
 #ifdef WILC_FULLY_HOSTING_AP
 #include "wilc_host_ap.h"
 #endif
 #ifdef WILC_AP_EXTERNAL_MLME
-#ifdef SIMULATION
-#include "wilc_wfi_cfgoperations.h"
-#endif
 
 struct wilc_wfi_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
@@ -39,9 +34,7 @@ extern linux_wlan_t *g_linux_wlan;
 
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
-#ifdef SIMULATION
-extern int WILC_WFI_Tx(struct sk_buff *skb, struct net_device *dev);
-#elif USE_WIRELESS
+#if USE_WIRELESS
 extern int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
 #endif
 
@@ -374,9 +367,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	PRINT_INFO(HOSTAPD_DBG, "SKB netdevice name = %s\n", skb->dev->name);
 	PRINT_INFO(HOSTAPD_DBG, "MONITOR real dev name = %s\n", mon_priv->real_ndev->name);
 
-	#ifdef SIMULATION
-	ret = WILC_WFI_Tx(skb, mon_priv->real_ndev);
-	#elif USE_WIRELESS
+	#if USE_WIRELESS
 	/* Identify if Ethernet or MAC header (data or mgmt) */
 	memcpy(srcAdd, &skb->data[10], 6);
 	memcpy(bssid, &skb->data[16], 6);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5a794df..10ea53a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1,4 +1,3 @@
-#ifndef SIMULATION
 #include "wilc_wfi_cfgoperations.h"
 #include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
@@ -2778,4 +2777,3 @@ static void __exit exit_wilc_driver(void)
 module_exit(exit_wilc_driver);
 
 MODULE_LICENSE("GPL");
-#endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1d0b7f8..c2ef46f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2875,7 +2875,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 		/*Remove the enteries of the previously connected clients*/
 		memset(priv->assoc_stainfo.au8Sta_AssociatedBss, 0, MAX_NUM_STA * ETH_ALEN);
-		#ifndef SIMULATION
 		#ifdef WILC_P2P
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
@@ -2953,7 +2952,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			host_int_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
 		}
 		#endif
-		#endif
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2968,7 +2966,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		priv->wdev->iftype = type;
 		nic->monitor_flag = 0;
 
-		#ifndef SIMULATION
 		#ifdef WILC_P2P
 
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
@@ -3042,7 +3039,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			}
 		}
 		#endif
-		#endif
 		break;
 
 	case NL80211_IFTYPE_AP:
@@ -3053,7 +3049,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		nic->iftype = AP_MODE;
 		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
-		#ifndef SIMULATION
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		linux_wlan_get_firmware(nic);
 		#ifdef WILC_P2P
@@ -3075,7 +3070,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			}
 		}
 		#endif
-		#endif
 		break;
 
 	case NL80211_IFTYPE_P2P_GO:
@@ -3099,7 +3093,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
-		#ifndef SIMULATION
 		#ifdef WILC_P2P
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 
@@ -3174,7 +3167,6 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			}
 		}
 		#endif
-		#endif
 		break;
 
 	default:
@@ -3570,13 +3562,8 @@ struct wireless_dev *WILC_WFI_add_virt_intf(struct wiphy *wiphy, const char *nam
 		new_ifc = WILC_WFI_init_mon_interface(name, nic->wilc_netdev);
 		if (new_ifc != NULL) {
 			PRINT_D(HOSTAPD_DBG, "Setting monitor flag in private structure\n");
-			#ifdef SIMULATION
-			priv = netdev_priv(priv->wdev->netdev);
-			priv->monitor_flag = 1;
-			#else
 			nic = netdev_priv(priv->wdev->netdev);
 			nic->monitor_flag = 1;
-			#endif
 		} else
 			PRINT_ER("Error in initializing monitor interface\n ");
 	}
-- 
1.9.1

