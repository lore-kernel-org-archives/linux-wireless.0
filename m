Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40102 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbbIPJxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:53:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/8] staging: wilc1000: remove define WILC_P2P and ifdef line
Date: Wed, 16 Sep 2015 18:53:21 +0900
Message-ID: <1442397207-20491-2-git-send-email-tony.cho@atmel.com> (sfid-20150916_115348_203542_E9CA9A2D)
In-Reply-To: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
References: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

WILC_P2P is always used in the driver. So delete define WILC_P2P and ifdef line.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  2 --
 drivers/staging/wilc1000/coreconfigurator.h       |  2 --
 drivers/staging/wilc1000/host_interface.c         | 32 --------------------
 drivers/staging/wilc1000/host_interface.h         | 10 ------
 drivers/staging/wilc1000/linux_wlan.c             |  2 --
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 37 -----------------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  3 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  7 -----
 drivers/staging/wilc1000/wilc_wlan.c              |  8 ++---
 drivers/staging/wilc1000/wilc_wlan_if.h           |  9 ------
 10 files changed, 2 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index aecaa03..b7a4bff 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -476,11 +476,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 		/* Get the cap_info */
 		pstrNetworkInfo->u16CapInfo = get_cap_info(pu8msa);
-		#ifdef WILC_P2P
 		/* Get time-stamp [Low only 32 bit] */
 		pstrNetworkInfo->u32Tsf = get_beacon_timestamp_lo(pu8msa);
 		PRINT_D(CORECONFIG_DBG, "TSF :%x\n", pstrNetworkInfo->u32Tsf);
-		#endif
 
 		/* Get full time-stamp [Low and High 64 bit] */
 		u32Tsf_Lo = get_beacon_timestamp_lo(pu8msa);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 32e5b31..8439066 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -111,9 +111,7 @@ typedef struct {
 #ifdef AGING_ALG
 	u8 u8Found;
 #endif
-#ifdef WILC_P2P
 	u32 u32Tsf; /* time-stamp [Low only 32 bit] */
-#endif
 	u8 *pu8IEs;
 	u16 u16IEsLen;
 	void *pJoinParams;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 41e80aa..6fdf392 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -443,10 +443,8 @@ typedef union _tuniHostIFmsgBody {
 	tstrHostIfSetMacAddress strHostIfSetMacAddress;
 	tstrHostIfGetMacAddress strHostIfGetMacAddress;
 	tstrHostIfBASessionInfo strHostIfBASessionInfo;
-	#ifdef WILC_P2P
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
-	#endif
 	char *pUserData;
 	tstrHostIFDelAllSta strHostIFDelAllSta;
 } tuniHostIFmsgBody;
@@ -497,7 +495,6 @@ typedef struct _tstrJoinBssParam {
 	u8 rsn_auth_policy[3];
 	u8 rsn_cap[2];
 	struct _tstrJoinParam *nextJoinBss;
-	#ifdef WILC_P2P
 	u32 tsf;
 	u8 u8NoaEnbaled;
 	u8 u8OppEnable;
@@ -507,7 +504,6 @@ typedef struct _tstrJoinBssParam {
 	u8 au8Duration[4];
 	u8 au8Interval[4];
 	u8 au8StartTime[4];
-	#endif
 } tstrJoinBssParam;
 /*Bug4218: Parsing Join Param*/
 /*a linked list table containing needed join parameters entries for each AP found in most recent scan*/
@@ -1312,9 +1308,6 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = pstrHostIFscanAttr->pfScanResult;
 	pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->pvUserArg;
 
-	#ifdef WILC_P2P
-	#endif
-
 	if ((pstrWFIDrv->enuHostIFstate >= HOST_IF_SCANNING) && (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTED)) {
 		/* here we either in HOST_IF_SCANNING, HOST_IF_WAITING_CONN_REQ or HOST_IF_WAITING_CONN_RESP */
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", pstrWFIDrv->enuHostIFstate);
@@ -1953,7 +1946,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	/*BugID_5137*/
 	*(pu8CurrByte++) = REAL_JOIN_REQ;
 
-		#ifdef WILC_P2P
 	*(pu8CurrByte++) = ptstrJoinBssParam->u8NoaEnbaled;
 	if (ptstrJoinBssParam->u8NoaEnbaled) {
 		PRINT_D(HOSTINF_DBG, "NOA present\n");
@@ -1986,8 +1978,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	} else
 		PRINT_D(HOSTINF_DBG, "NOA not present\n");
-	#endif
-
 
 	/* keep the buffer at the start of the allocated pointer to use it with the free*/
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
@@ -3787,7 +3777,6 @@ ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 }
 
-#ifdef WILC_P2P
 /**
  *  @brief Handle_RemainOnChan
  *  @details        Sending config packet to edit station
@@ -4009,8 +3998,6 @@ static void ListenTimerCB(unsigned long arg)
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 }
-#endif
-
 
 /**
  *  @brief Handle_EditStation
@@ -4409,10 +4396,8 @@ static int hostIFthread(void *pvArg)
 
 			Handle_ScanDone(strHostIFmsg.drvHandler, SCAN_EVENT_DONE);
 
-				#ifdef WILC_P2P
 			if (pstrWFIDrv->u8RemainOnChan_pendingreq)
 				Handle_RemainOnChan(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan);
-				#endif
 
 			break;
 
@@ -4500,7 +4485,6 @@ static int hostIFthread(void *pvArg)
 			Handle_GetMacAddress(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress);
 			break;
 
-#ifdef WILC_P2P
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REMAIN_ON_CHAN\n");
 			Handle_RemainOnChan(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan);
@@ -4515,7 +4499,6 @@ static int hostIFthread(void *pvArg)
 			Handle_ListenStateExpired(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan);
 			break;
 
-			#endif
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_MULTICAST_FILTER\n");
 			Handle_SetMulticastFilter(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti);
@@ -6479,10 +6462,8 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 	setup_timer(&pstrWFIDrv->hConnectTimer, TimerCB_Connect, 0);
 
-	#ifdef WILC_P2P
 	/*Remain on channel timer*/
 	setup_timer(&pstrWFIDrv->hRemainOnChannel, ListenTimerCB, 0);
-	#endif
 
 	sema_init(&(pstrWFIDrv->gtOsCfgValuesSem), 1);
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
@@ -6498,13 +6479,8 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	pstrWFIDrv->strCfgValues.passive_scan_time = PASSIVE_SCAN_TIME;
 	pstrWFIDrv->strCfgValues.curr_tx_rate = AUTORATE;
 
-
-	#ifdef WILC_P2P
-
 	pstrWFIDrv->u64P2p_MgmtTimeout = 0;
 
-	#endif
-
 	PRINT_INFO(HOSTINF_DBG, "Initialization values, Site survey value: %d\n Scan source: %d\n Active scan time: %d\n Passive scan time: %d\nCurrent tx Rate = %d\n",
 
 		   pstrWFIDrv->strCfgValues.site_survey_enabled, pstrWFIDrv->strCfgValues.scan_source,
@@ -6531,9 +6507,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 _fail_mem_:
 	if (pstrWFIDrv != NULL)
 		kfree(pstrWFIDrv);
-#ifdef WILC_P2P
 	del_timer_sync(&pstrWFIDrv->hRemainOnChannel);
-#endif
 _fail_timer_2:
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 	del_timer_sync(&pstrWFIDrv->hConnectTimer);
@@ -6601,10 +6575,8 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 		/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 	}
 
-	#ifdef WILC_P2P
 	/*Destroy Remain-onchannel Timer*/
 	del_timer_sync(&pstrWFIDrv->hRemainOnChannel);
-	#endif
 
 	host_int_set_wfi_drv_handler(NULL);
 	down(&hSemDeinitDrvHandle);
@@ -6829,7 +6801,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 
 }
 
-#ifdef WILC_P2P
 /**
  *  @brief              host_int_remain_on_channel
  *  @details
@@ -6966,7 +6937,6 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 
 
 }
-#endif
 
 /**
  *  @brief host_int_add_beacon
@@ -7446,7 +7416,6 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				index += pu8IEs[index + 1] + 2;
 				continue;
 			}
-			#ifdef WILC_P2P
 			else if ((pu8IEs[index] == P2P_IE) && /* P2P Element ID */
 				 (pu8IEs[index + 2] == 0x50) && (pu8IEs[index + 3] == 0x6f) &&
 				 (pu8IEs[index + 4] == 0x9a) && /* OUI */
@@ -7483,7 +7452,6 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				continue;
 
 			}
-			#endif
 			else if ((pu8IEs[index] == RSN_IE) ||
 				 ((pu8IEs[index] == WPA_IE) && (pu8IEs[index + 2] == 0x00) &&
 				  (pu8IEs[index + 3] == 0x50) && (pu8IEs[index + 4] == 0xF2) &&
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e3e4b06..fd5fa19 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -193,10 +193,8 @@ typedef void (*tWILCpfConnectResult)(tenuConnDisconnEvent,
 				     tstrDisconnectNotifInfo *,
 				     void *);
 
-#ifdef WILC_P2P
 typedef void (*tWILCpfRemainOnChanExpired)(void *, u32);  /*Remain on channel expiration callback function*/
 typedef void (*tWILCpfRemainOnChanReady)(void *); /*Remain on channel callback function*/
-#endif
 
 /* typedef u32 WILC_WFIDrvHandle; */
 typedef struct {
@@ -284,7 +282,6 @@ typedef struct {
 	u16 u16SessionTimeout;
 } tstrHostIfBASessionInfo;
 
-#ifdef WILC_P2P
 typedef struct {
 	u16 u16Channel;
 	u32 u32duration;
@@ -317,7 +314,6 @@ enum p2p_listen_state {
 	P2P_GRP_FORMATION
 };
 
-#endif
 typedef struct {
 	/* Scan user structure */
 	tstrWILC_UsrScanReq strWILC_UsrScanReq;
@@ -325,13 +321,11 @@ typedef struct {
 	/* Connect User structure */
 	tstrWILC_UsrConnReq strWILC_UsrConnReq;
 
-	#ifdef WILC_P2P
 	/*Remain on channel struvture*/
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
 	u8 u8RemainOnChan_pendingreq;
 	u64 u64P2p_MgmtTimeout;
 	u8 u8P2PConnect;
-	#endif
 
 	tenuHostIFstate enuHostIFstate;
 
@@ -354,9 +348,7 @@ typedef struct {
 /* timer handlers */
 	struct timer_list hScanTimer;
 	struct timer_list hConnectTimer;
-	#ifdef WILC_P2P
 	struct timer_list hRemainOnChannel;
-	#endif
 
 	bool IFC_UP;
 } tstrWILC_WFIDrv;
@@ -1194,7 +1186,6 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
  */
 s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
-#ifdef WILC_P2P
 /**
  *  @brief           host_int_remain_on_channel
  *  @details
@@ -1232,7 +1223,6 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID);
  *  @version	1.0
  */
 s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bReg);
-#endif
 /**
  *  @brief           host_int_set_wfi_drv_handler
  *  @details
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index bc9aae4..f79aa49 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2058,12 +2058,10 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 		}
 	}
 
-	#ifdef WILC_P2P
 	nic = netdev_priv(g_linux_wlan->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
 		WILC_WFI_p2p_rx(g_linux_wlan->strInterfaceInfo[1].wilc_netdev, buff, size);
-	#endif
 }
 
 int wilc_netdev_init(void)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cc61f26..468b632 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -94,7 +94,6 @@ static struct ieee80211_rate WILC_WFI_rates[] = {
 	RATETAB_ENT(540, 12, 0),
 };
 
-#ifdef WILC_P2P
 struct p2p_mgmt_data {
 	int size;
 	u8 *buff;
@@ -111,7 +110,6 @@ u8 u8P2Plocalrandom = 0x01;
 u8 u8P2Precvrandom = 0x00;
 u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
 bool bWilc_ie;
-#endif
 
 static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 	.channels = WILC_WFI_2ghz_channels,
@@ -550,18 +548,14 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 {
 	struct wilc_priv *priv;
 	struct net_device *dev;
-	#ifdef WILC_P2P
 	tstrWILC_WFIDrv *pstrWFIDrv;
-	#endif
 	u8 NullBssid[ETH_ALEN] = {0};
 
 	connecting = 0;
 
 	priv = (struct wilc_priv *)pUserVoid;
 	dev = priv->dev;
-	#ifdef WILC_P2P
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
-	#endif
 
 	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
 		/*Initialization*/
@@ -581,10 +575,8 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 
 			/*BugID_5457*/
 			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
-			#ifdef WILC_P2P
 			if (!pstrWFIDrv->u8P2PConnect)
 				u8WLANChannel = INVALID_CHANNEL;
-			#endif
 
 			PRINT_ER("Unspecified failure: Connection status %d : MAC status = %d\n", u16ConnectStatus, u8MacStatus);
 		}
@@ -649,10 +641,8 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 
 		/*BugID_5457*/
 		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
-		#ifdef WILC_P2P
 		if (!pstrWFIDrv->u8P2PConnect)
 			u8WLANChannel = INVALID_CHANNEL;
-		#endif
 		/*BugID_5315*/
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
@@ -838,13 +828,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
-	#ifdef WILC_P2P
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
 		PRINT_D(CFG80211_DBG, "Connected to Direct network,OBSS disabled\n");
 		pstrWFIDrv->u8P2PConnect = 1;
 	} else
 		pstrWFIDrv->u8P2PConnect = 0;
-	#endif
 	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d\n", sme->ssid, sme->auth_type);
 
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
@@ -1074,9 +1062,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 {
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
-	#ifdef WILC_P2P
 	tstrWILC_WFIDrv *pstrWFIDrv;
-	#endif
 	u8 NullBssid[ETH_ALEN] = {0};
 
 	connecting = 0;
@@ -1084,11 +1070,9 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 
 	/*BugID_5457*/
 	/*Invalidate u8WLANChannel value on wlan0 disconnect*/
-	#ifdef WILC_P2P
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
 	if (!pstrWFIDrv->u8P2PConnect)
 		u8WLANChannel = INVALID_CHANNEL;
-	#endif
 	linux_wlan_set_bssid(priv->dev, NullBssid);
 
 	PRINT_D(CFG80211_DBG, "Disconnecting with reason code(%d)\n", reason_code);
@@ -1096,9 +1080,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	u8P2Plocalrandom = 0x01;
 	u8P2Precvrandom = 0x00;
 	bWilc_ie = false;
-	#ifdef WILC_P2P
 	pstrWFIDrv->u64P2p_MgmtTimeout = 0;
-	#endif
 
 	s32Error = host_int_disconnect(priv->hWILCWFIDrv, reason_code);
 	if (s32Error != 0) {
@@ -1987,7 +1969,6 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
-#ifdef WILC_P2P
 
 /**
  *  @brief      WILC_WFI_CfgParseRxAction
@@ -2650,7 +2631,6 @@ void    WILC_WFI_frame_register(struct wiphy *wiphy,
 
 
 }
-#endif /*WILC_P2P*/
 
 /**
  *  @brief      WILC_WFI_set_cqm_rssi_config
@@ -2759,9 +2739,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	perInterface_wlan_t *nic;
 	u8 interface_type;
 	u16 TID = 0;
-	#ifdef WILC_P2P
 	u8 i;
-	#endif
 
 	nic = netdev_priv(dev);
 	priv = wiphy_priv(wiphy);
@@ -2799,7 +2777,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/*Remove the enteries of the previously connected clients*/
 		memset(priv->assoc_stainfo.au8Sta_AssociatedBss, 0, MAX_NUM_STA * ETH_ALEN);
-		#ifdef WILC_P2P
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
 
@@ -2875,7 +2852,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			bEnablePS = true;
 			host_int_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
 		}
-		#endif
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2890,8 +2866,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		priv->wdev->iftype = type;
 		nic->monitor_flag = 0;
 
-		#ifdef WILC_P2P
-
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 		nic->iftype = CLIENT_MODE;
 
@@ -2962,7 +2936,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				}
 			}
 		}
-		#endif
 		break;
 
 	case NL80211_IFTYPE_AP:
@@ -2975,7 +2948,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		linux_wlan_get_firmware(nic);
-		#ifdef WILC_P2P
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
 		if (g_linux_wlan->wilc1000_initialized)	{
 			nic->iftype = AP_MODE;
@@ -2993,7 +2965,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 							nic->g_struct_frame_reg[i].reg);
 			}
 		}
-		#endif
 		break;
 
 	case NL80211_IFTYPE_P2P_GO:
@@ -3017,7 +2988,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
-		#ifdef WILC_P2P
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 
 
@@ -3090,7 +3060,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 							nic->g_struct_frame_reg[i].reg);
 			}
 		}
-		#endif
 		break;
 
 	default:
@@ -3487,7 +3456,6 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.set_pmksa = set_pmksa,
 	.del_pmksa = del_pmksa,
 	.flush_pmksa = flush_pmksa,
-#ifdef WILC_P2P
 	.remain_on_channel = remain_on_channel,
 	.cancel_remain_on_channel = cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = mgmt_tx_cancel_wait,
@@ -3495,7 +3463,6 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.mgmt_frame_register = WILC_WFI_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
-#endif
 
 };
 
@@ -3643,15 +3610,11 @@ struct wireless_dev *WILC_WFI_WiphyRegister(struct net_device *net)
 	/*Setting default managment types: for register action frame:  */
 	wdev->wiphy->mgmt_stypes = wilc_wfi_cfg80211_mgmt_types;
 
-#ifdef WILC_P2P
 	wdev->wiphy->max_remain_on_channel_duration = 500;
 	/*Setting the wiphy interfcae mode and type before registering the wiphy*/
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP) | BIT(NL80211_IFTYPE_MONITOR) | BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT);
 	wdev->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
-#else
-	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP) | BIT(NL80211_IFTYPE_MONITOR);
-#endif
 	wdev->iftype = NL80211_IFTYPE_STATION;
 
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 5fd0757..dff8265 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -20,8 +20,6 @@
 #define AES			BIT(5)
 #define TKIP			BIT(6)
 
-#ifdef WILC_P2P
-
 /*Public action frame index IDs*/
 #define FRAME_TYPE_ID			0
 #define ACTION_CAT_ID			24
@@ -47,7 +45,6 @@
 #define GAS_INTIAL_RSP			0x0b
 
 #define INVALID_CHANNEL			0
-#endif
 
 #define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
 #define SCAN_RESULT_EXPIRE		(40 * HZ)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 904d9c3..27c9ccf 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -100,7 +100,6 @@ struct sta_info {
 	u8 au8Sta_AssociatedBss[MAX_NUM_STA][ETH_ALEN];
 };
 
-#ifdef WILC_P2P
 /*Parameters needed for host interface for  remaining on channel*/
 struct wilc_wfi_p2pListenParams {
 	struct ieee80211_channel *pstrListenChan;
@@ -110,16 +109,12 @@ struct wilc_wfi_p2pListenParams {
 	u32 u32ListenSessionID;
 };
 
-#endif  /*WILC_P2P*/
-
 struct wilc_priv {
 	struct wireless_dev *wdev;
 	struct cfg80211_scan_request *pstrScanReq;
 
-	#ifdef WILC_P2P
 	struct wilc_wfi_p2pListenParams strRemainOnChanParams;
 	u64 u64tx_cookie;
-	#endif
 
 	bool bCfgScanning;
 	u32 u32RcvdChCount;
@@ -229,9 +224,7 @@ typedef struct {
 	u8 iftype;
 	int monitor_flag;
 	int mac_opened;
-	#ifdef WILC_P2P
 	struct_frame_reg g_struct_frame_reg[num_reg_frame];
-	#endif
 	struct net_device *wilc_netdev;
 	struct net_device_stats netstats;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 97aac50..54f30b2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -561,8 +561,8 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size, wi
 	/*return number of itemes in the queue*/
 	return p->txq_entries;
 }
+
 /*Bug3959: transmitting mgmt frames received from host*/
-#if defined(WILC_P2P)
 int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_complete_func_t func)
 {
 
@@ -588,7 +588,7 @@ int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_
 	wilc_wlan_txq_add_to_tail(tqe);
 	return 1;
 }
-#endif /* WILC_P2P */
+
 static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
@@ -1213,7 +1213,6 @@ static void wilc_wlan_handle_rxq(void)
 			}
 
 /*bug 3887: [AP] Allow Management frames to be passed to the host*/
-			#if defined(WILC_P2P)
 			#define IS_MANAGMEMENT				0x100
 			#define IS_MANAGMEMENT_CALLBACK			0x080
 			#define IS_MGMT_STATUS_SUCCES			0x040
@@ -1227,7 +1226,6 @@ static void wilc_wlan_handle_rxq(void)
 			}
 			/* BUG4530 fix */
 			else
-			#endif
 			{
 
 				if (!is_cfg_packet) {
@@ -2145,9 +2143,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	oup->wlan_cfg_get_value = wilc_wlan_cfg_get_val;
 
 	/*Bug3959: transmitting mgmt frames received from host*/
-	#if defined(WILC_P2P)
 	oup->wlan_add_mgmt_to_tx_que = wilc_wlan_txq_add_mgmt_pkt;
-	#endif
 
 	if (!init_chip()) {
 		/* EIO	5 */
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index da37cff..d67718f 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -12,7 +12,6 @@
 #define WILC_WLAN_IF_H
 
 /*bug 3887: [AP] Allow Management frames to be passed to the host*/
-#define WILC_P2P
 #define TCP_ENHANCEMENTS
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
@@ -177,9 +176,7 @@ typedef struct {
 	int (*wlan_cfg_get)(int, u32, int, u32);
 	int (*wlan_cfg_get_value)(u32, u8 *, u32);
 	/*Bug3959: transmitting mgmt frames received from host*/
-	#if defined(WILC_P2P)
 	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
-	#endif
 } wilc_wlan_oup_t;
 
 /********************************************
@@ -201,9 +198,7 @@ typedef enum {
 	RSN_IE = 48,
 	WPA_IE = 221,
 	WMM_IE = 221,
-	#ifdef WILC_P2P
 	P2P_IE = 221,
-	#endif
 } BEACON_IE;
 #endif
 typedef enum {
@@ -880,13 +875,9 @@ typedef enum {
 	WID_HUT_TEST_ID                    = 0x3081,
 	WID_PMKID_INFO                     = 0x3082,
 	WID_FIRMWARE_INFO                  = 0x3083,
-	#ifdef WILC_P2P
 	WID_REGISTER_FRAME                = 0x3084,
-	#endif
 	WID_DEL_ALL_STA          = 0x3085,
-	 #ifdef WILC_P2P
 	WID_REMAIN_ON_CHAN  = 0x3996,
-	#endif
 	/*BugID_4156*/
 	WID_SSID_PROBE_REQ = 0x3997,
 	/*BugID_4124 WID to trigger modified Join Request using SSID and BSSID instead of bssListIdx (used by WID_JOIN_REQ)*/
-- 
1.9.1

