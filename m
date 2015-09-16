Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34739 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbbIPLMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:12:07 -0400
Received: by padhy16 with SMTP id hy16so206857462pad.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:12:06 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/10] staging: wilc1000: remove useless comment
Date: Wed, 16 Sep 2015 20:11:34 +0900
Message-Id: <1442401895-7463-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131216_467852_EB90B489)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes useless comment that is included "BugID_xxxx"

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 36 -------------------
 drivers/staging/wilc1000/host_interface.h         |  4 ---
 drivers/staging/wilc1000/linux_wlan.c             |  8 -----
 drivers/staging/wilc1000/linux_wlan_common.h      |  1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 42 -----------------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 -
 drivers/staging/wilc1000/wilc_wlan.c              | 26 ++------------
 drivers/staging/wilc1000/wilc_wlan.h              |  1 -
 drivers/staging/wilc1000/wilc_wlan_if.h           |  9 -----
 9 files changed, 2 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 563063c..e12c95d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7,7 +7,6 @@ extern u8 connecting;
 extern struct timer_list hDuringIpTimer;
 #endif
 
-/*BugID_5137*/
 extern u8 g_wilc_initialized;
 /*****************************************************************************/
 /*								Macros                                       */
@@ -173,7 +172,6 @@ typedef struct _tstrHostIFscanAttr {
 	size_t IEsLen;
 	tWILCpfScanResult pfScanResult;
 	void *pvUserArg;
-	/*BugID_4189*/
 	tstrHiddenNetwork strHiddenNetwork;
 
 } tstrHostIFscanAttr;
@@ -569,7 +567,6 @@ static u8 gu8DelBcn;
 #endif
 static u32 gu32WidConnRstHack;
 
-/*BugID_5137*/
 u8 *gu8FlushedJoinReq;
 u8 *gu8FlushedInfoElemAsoc;
 u8 gu8Flushed11iMode;
@@ -920,7 +917,6 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 }
 
 
-/*BugID_5213*/
 /**
  *  @brief Handle_GetMacAddress
  *  @details    Getting mac address
@@ -1331,7 +1327,6 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 
 	pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount = 0;
 
-	/*BugID_4189*/
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
 
@@ -1477,7 +1472,6 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 
 	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
 
-	/*BugID_4978*/
 	/*Ask FW to abort the running scan, if any*/
 	if (enuEvent == SCAN_EVENT_ABORTED) {
 		PRINT_D(GENERIC_DBG, "Abort running scan\n");
@@ -1774,7 +1768,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		strWIDList[u32WidsCount].s32ValueSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
 		u32WidsCount++;
 
-		/*BugID_5137*/
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 
 			gu32FlushedInfoElemAsocSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
@@ -1789,7 +1782,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
 
-	/*BugID_5137*/
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
 		gu8Flushed11iMode = pstrWFIDrv->strWILC_UsrConnReq.u8security;
 
@@ -1802,7 +1794,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
 
-	/*BugID_5137*/
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
 		gu8FlushedAuthType = (u8)pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type;
 
@@ -1857,7 +1848,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].s32ValueSize = 112; /* 79; */
 	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
 
-	/*BugID_5137*/
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].s32ValueSize;
 		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
@@ -1941,7 +1931,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_cap, sizeof(ptstrJoinBssParam->rsn_cap));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_cap);
 
-	/*BugID_5137*/
 	*(pu8CurrByte++) = REAL_JOIN_REQ;
 
 		#ifdef WILC_P2P
@@ -1994,7 +1983,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	gu32WidConnRstHack = 0;
 	/* ////////////////////// */
 
-	/*BugID_5137*/
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
 		gu8FlushedJoinReqDrvHandler = pstrWFIDrv;
@@ -2249,7 +2237,6 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 	}
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
-	/*BugID_5213*/
 	/*Freeing flushed join request params on connect timeout*/
 	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 		kfree(gu8FlushedJoinReq);
@@ -2674,7 +2661,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 				pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
 			}
 
-			/*BugID_5213*/
 			/*Freeing flushed join request params on receiving*/
 			/*MAC_DISCONNECTED while connected*/
 			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
@@ -3147,7 +3133,6 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 		if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
 
-			/*BugID_5193*/
 			/*Stop connect timer, if connection in progress*/
 			if (pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
@@ -3186,7 +3171,6 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 		}
 
 
-		/*BugID_5137*/
 		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 			kfree(gu8FlushedJoinReq);
 			gu8FlushedJoinReq = NULL;
@@ -4020,7 +4004,6 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
-	/*BugID_5477*/
 	/*Make sure we are already in listen state*/
 	/*This is to handle duplicate expiry messages (listen timer fired and supplicant called cancel_remain_on_channel())*/
 	if (P2P_LISTEN_STATE) {
@@ -4190,7 +4173,6 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 }
 
 
-/*BugID_5222*/
 /**
  *  @brief                      Handle_AddBASession
  *  @details            Add block ack session
@@ -4280,7 +4262,6 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 }
 
 
-/*BugID_5222*/
 /**
  *  @brief                      Handle_DelBASession
  *  @details            Delete block ack session
@@ -4345,7 +4326,6 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	if (strWID.ps8WidVal != NULL)
 		kfree(strWID.ps8WidVal);
 
-	/*BugID_5222*/
 	up(&hWaitResponse);
 
 	return s32Error;
@@ -4400,7 +4380,6 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 	if (strWID.ps8WidVal != NULL)
 		kfree(strWID.ps8WidVal);
 
-	/*BugID_5222*/
 	up(&hWaitResponse);
 
 	return s32Error;
@@ -4461,7 +4440,6 @@ static int hostIFthread(void *pvArg)
 			Handle_Connect(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr);
 			break;
 
-		/*BugID_5137*/
 		case HOST_IF_MSG_FLUSH_CONNECT:
 			Handle_FlushConnect(strHostIFmsg.drvHandler);
 			break;
@@ -4495,7 +4473,6 @@ static int hostIFthread(void *pvArg)
 			del_timer(&pstrWFIDrv->hScanTimer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
-			/*BugID_5213*/
 			/*Allow chip sleep, only if both interfaces are not connected*/
 			if (!linux_wlan_get_num_conn_ifcs())
 				chip_sleep_manually(INFINITE_SLEEP_TIME);
@@ -4585,12 +4562,10 @@ static int hostIFthread(void *pvArg)
 			Handle_get_IPAddress(strHostIFmsg.drvHandler, strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr, strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx);
 			break;
 
-		/*BugID_5077*/
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
 			Handle_SetMacAddress(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress);
 			break;
 
-		/*BugID_5213*/
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
 			Handle_GetMacAddress(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress);
 			break;
@@ -4616,7 +4591,6 @@ static int hostIFthread(void *pvArg)
 			Handle_SetMulticastFilter(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti);
 			break;
 
-		/*BugID_5222*/
 		case HOST_IF_MSG_ADD_BA_SESSION:
 			Handle_AddBASession(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo);
 			break;
@@ -6618,7 +6592,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	if (clients_count == 0)	{
 		sema_init(&hSemHostIFthrdEnd, 0);
 		sema_init(&hSemDeinitDrvHandle, 0);
-		/*BugID_5348*/
 		sema_init(&hSemHostIntDeinit, 1);
 	}
 
@@ -6750,7 +6723,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	 *      return 0;
 	 * }*/
 
-	/*BugID_5348*/
 
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("pstrWFIDrv = NULL\n");
@@ -6762,7 +6734,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	terminated_handle = pstrWFIDrv;
 	PRINT_D(HOSTINF_DBG, "De-initializing host interface for client %d\n", clients_count);
 
-	/*BugID_5348*/
 	/*Destroy all timers before acquiring hSemDeinitDrvHandle*/
 	/*to guarantee handling all messages befor proceeding*/
 	if (del_timer_sync(&pstrWFIDrv->hScanTimer)) {
@@ -6911,7 +6882,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
-	/*BugID_5348*/
 	down(&hSemHostIntDeinit);
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
@@ -6921,7 +6891,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle) {
 		PRINT_D(HOSTINF_DBG, "Wifi driver handler is equal to NULL\n");
-		/*BugID_5348*/
 		up(&hSemHostIntDeinit);
 		return;
 	}
@@ -6929,7 +6898,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult == NULL) {
 		/* received mac status is not needed when there is no current Connect Request */
 		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
-		/*BugID_5348*/
 		up(&hSemHostIntDeinit);
 		return;
 	}
@@ -6952,7 +6920,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
 
-	/*BugID_5348*/
 	up(&hSemHostIntDeinit);
 }
 
@@ -7335,7 +7302,6 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_STATION;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	/*BugID_4795: Handling situation of deleting all stations*/
 	if (pu8MacAddr == NULL)
 		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
 	else
@@ -7825,7 +7791,6 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 
 	}
 
-	/*BugID_5222*/
 	down(&hWaitResponse);
 
 	return s32Error;
@@ -7858,7 +7823,6 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 
 	}
 
-	/*BugID_5222*/
 	down(&hWaitResponse);
 
 	return s32Error;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e3e4b06..3653697 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -218,7 +218,6 @@ typedef struct _tstrRcvdNetworkInfo {
 	u32 u32Length;
 } tstrRcvdNetworkInfo;
 
-/*BugID_4156*/
 typedef struct _tstrHiddenNetworkInfo {
 	u8  *pu8ssid;
 	u8 u8ssidlen;
@@ -266,17 +265,14 @@ typedef struct {
 	u32 u32Mode;
 } tstrHostIfSetOperationMode;
 
-/*BugID_5077*/
 typedef struct {
 	u8 u8MacAddress[ETH_ALEN];
 } tstrHostIfSetMacAddress;
 
-/*BugID_5213*/
 typedef struct {
 	u8 *u8MacAddress;
 } tstrHostIfGetMacAddress;
 
-/*BugID_5222*/
 typedef struct {
 	u8 au8Bssid[ETH_ALEN];
 	u8 u8Ted;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6ad8cd5..004a280 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -576,7 +576,6 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	return ret;
 }
 
-/*BugID_5213*/
 /*Function to get number of connected interfaces*/
 int linux_wlan_get_num_conn_ifcs(void)
 {
@@ -709,7 +708,6 @@ int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
 	else if (nic->iftype == STATION_MODE)
 		firmware = STA_FIRMWARE;
 
-	/*BugID_5137*/
 	else {
 		PRINT_D(INIT_DBG, "Get P2P_CONCURRENCY_FIRMWARE\n");
 		firmware = P2P_CONCURRENCY_FIRMWARE;
@@ -830,7 +828,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	unsigned char c_val[64];
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
 
-	/*BugID_5077*/
 	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
@@ -1181,7 +1178,6 @@ int wlan_init_locks(linux_wlan_t *p_nic)
 	mutex_init(&g_linux_wlan->rxq_cs);
 	mutex_init(&g_linux_wlan->txq_cs);
 
-	/*Added by Amr - BugID_4720*/
 	spin_lock_init(&g_linux_wlan->txq_spinlock);
 	sema_init(&g_linux_wlan->txq_add_to_head_cs, 1);
 
@@ -1226,10 +1222,8 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 	nwi->os_context.tx_buffer_size = LINUX_TX_SIZE;
 	nwi->os_context.txq_critical_section = (void *)&g_linux_wlan->txq_cs;
 
-	/*Added by Amr - BugID_4720*/
 	nwi->os_context.txq_add_to_head_critical_section = (void *)&g_linux_wlan->txq_add_to_head_cs;
 
-	/*Added by Amr - BugID_4720*/
 	nwi->os_context.txq_spin_lock = (void *)&g_linux_wlan->txq_spinlock;
 
 	nwi->os_context.txq_wait_event = (void *)&g_linux_wlan->txq_event;
@@ -1623,7 +1617,6 @@ int mac_open(struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
 
-	/*BugID_5213*/
 	/*No need for setting mac address here anymore,*/
 	/*Just set it in init_test_config()*/
 	unsigned char mac_add[ETH_ALEN] = {0};
@@ -2053,7 +2046,6 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 	int i = 0;
 	perInterface_wlan_t *nic;
 
-	/*BugID_5450*/
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index ea121f9..65bac81 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -12,7 +12,6 @@ enum debug_region {
 	RX_debug,
 	Lock_debug,
 	Tcp_enhance,
-	/*Added by amr - BugID_4720*/
 	Spin_debug,
 
 	Init_debug,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e04d97e..e55e6e8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -37,7 +37,6 @@ struct timer_list hAgingTimer;
 static u8 op_ifcs;
 extern u8 u8ConnectedSSID[6];
 
-/*BugID_5137*/
 u8 g_wilc_initialized = 1;
 extern linux_wlan_t *g_linux_wlan;
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
@@ -103,7 +102,6 @@ struct p2p_mgmt_data {
 /*Global variable used to state the current  connected STA channel*/
 u8 u8WLANChannel = INVALID_CHANNEL;
 
-/*BugID_5442*/
 u8 u8CurrChannel;
 
 u8 u8P2P_oui[] = {0x50, 0x6f, 0x9A, 0x09};
@@ -121,7 +119,6 @@ static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 };
 
 
-/*BugID_5137*/
 struct add_key_params {
 	u8 key_idx;
 	bool pairwise;
@@ -581,7 +578,6 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 			linux_wlan_set_bssid(priv->dev, NullBssid);
 			memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-			/*BugID_5457*/
 			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 			#ifdef WILC_P2P
 			if (!pstrWFIDrv->u8P2PConnect)
@@ -599,9 +595,6 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 				   pstrConnectInfo->au8bssid[1], pstrConnectInfo->au8bssid[2], pstrConnectInfo->au8bssid[3], pstrConnectInfo->au8bssid[4], pstrConnectInfo->au8bssid[5]);
 			memcpy(priv->au8AssociatedBss, pstrConnectInfo->au8bssid, ETH_ALEN);
 
-			/* BugID_4209: if this network has expired in the scan results in the above nl80211 layer, refresh them here by calling
-			 *  cfg80211_inform_bss() with the last Scan results before calling cfg80211_connect_result() to avoid
-			 *  Linux kernel warning generated at the nl80211 layer */
 
 			for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
 				if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid,
@@ -618,7 +611,6 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 			}
 
 			if (bNeedScanRefresh) {
-				/*BugID_5418*/
 				/*Also, refrsh DIRECT- results if */
 				refresh_scan(priv, 1, true);
 
@@ -649,19 +641,16 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 		linux_wlan_set_bssid(priv->dev, NullBssid);
 		memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-		/*BugID_5457*/
 		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 		#ifdef WILC_P2P
 		if (!pstrWFIDrv->u8P2PConnect)
 			u8WLANChannel = INVALID_CHANNEL;
 		#endif
-		/*BugID_5315*/
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
 		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
 			pstrDisconnectNotifInfo->u16reason = 3;
 		}
-		/*BugID_5315*/
 		/*Incase "P2P CLIENT during connection(not connected)" send deauthentication reason by 1 to force the WPA_SUPPLICANT
 		 *      to scan again and retry the connection*/
 		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
@@ -767,7 +756,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 			strHiddenNetwork.u8ssidnum = request->n_ssids;
 
 
-			/*BugID_4156*/
 			for (i = 0; i < request->n_ssids; i++) {
 
 				if (request->ssids[i].ssid != NULL && request->ssids[i].ssid_len != 0) {
@@ -925,7 +913,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
-			/*BugID_5137*/
 			g_key_wep_params.key_len = sme->key_len;
 			g_key_wep_params.key = kmalloc(sme->key_len, GFP_KERNEL);
 			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
@@ -943,7 +930,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
-			/*BugID_5137*/
 			g_key_wep_params.key_len = sme->key_len;
 			g_key_wep_params.key = kmalloc(sme->key_len, GFP_KERNEL);
 			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
@@ -1037,7 +1023,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_INFO(CFG80211_DBG, "Group encryption value = %s\n Cipher Group = %s\n WPA version = %s\n",
 		   pcgroup_encrypt_val, pccipher_group, pcwpa_version);
 
-	/*BugID_5442*/
 	u8CurrChannel = pstrNetworkInfo->u8channel;
 
 	if (!pstrWFIDrv->u8P2PConnect) {
@@ -1084,7 +1069,6 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	connecting = 0;
 	priv = wiphy_priv(wiphy);
 
-	/*BugID_5457*/
 	/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 	#ifdef WILC_P2P
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
@@ -1142,7 +1126,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	PRINT_D(CFG80211_DBG, "Adding key with cipher suite = %x\n", params->cipher);
 
-	/*BugID_5137*/
 	PRINT_D(CFG80211_DBG, "%p %p %d\n", wiphy, netdev, key_index);
 
 	PRINT_D(CFG80211_DBG, "key %x %x %x\n", params->key[0],
@@ -1318,7 +1301,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					KeyLen = params->key_len - 16;
 				}
 
-				/*BugID_5137*/
 				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_gtk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
 					g_add_gtk_key_params.key_idx = key_index;
@@ -1355,7 +1337,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					KeyLen = params->key_len - 16;
 				}
 
-				/*BugID_5137*/
 				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_ptk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
 					g_add_ptk_key_params.key_idx = key_index;
@@ -1422,7 +1403,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 
 	priv = wiphy_priv(wiphy);
 
-	/*BugID_5137*/
 	/*delete saved keys, if any*/
 	if (netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
 		g_ptk_keys_saved = false;
@@ -2022,7 +2002,6 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 	u32 index = 0;
 	u32 i = 0, j = 0;
 
-	/*BugID_5460*/
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
 
@@ -2166,7 +2145,6 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 
 		PRINT_D(GENERIC_DBG, "Rx Frame Type:%x\n", buff[FRAME_TYPE_ID]);
 
-		/*BugID_5442*/
 		/*Upper layer is informed that the frame is received on this freq*/
 		s32Freq = ieee80211_channel_to_frequency(u8CurrChannel, IEEE80211_BAND_2GHZ);
 
@@ -2300,7 +2278,6 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 
 	priv = (struct wilc_priv *)pUserVoid;
 
-	/*BugID_5477*/
 	if (u32SessionID == priv->strRemainOnChanParams.u32ListenSessionID) {
 		PRINT_D(GENERIC_DBG, "Remain on channel expired\n");
 
@@ -2343,9 +2320,6 @@ static int remain_on_channel(struct wiphy *wiphy,
 
 	PRINT_D(GENERIC_DBG, "Remaining on channel %d\n", chan->hw_value);
 
-	/*BugID_4800: if in AP mode, return.*/
-	/*This check is to handle the situation when user*/
-	/*requests "create group" during a running scan*/
 
 	if (wdev->iftype == NL80211_IFTYPE_AP) {
 		PRINT_D(GENERIC_DBG, "Required remain-on-channel while in AP mode");
@@ -2478,9 +2452,7 @@ int mgmt_tx(struct wiphy *wiphy,
 			PRINT_D(GENERIC_DBG, "ACTION FRAME:%x\n", (u16)mgmt->frame_control);
 
 
-			/*BugID_4847*/
 			if (buf[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
-				/*BugID_4847*/
 				/*Only set the channel, if not a negotiation confirmation frame
 				 * (If Negotiation confirmation frame, force it
 				 * to be transmitted on the same negotiation channel)*/
@@ -2530,7 +2502,6 @@ int mgmt_tx(struct wiphy *wiphy,
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
 											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), true, nic->iftype);
 
-										/*BugID_5460*/
 										/*If using supplicant go intent, no need at all*/
 										/*to parse transmitted negotiation frames*/
 										else
@@ -2629,7 +2600,6 @@ void    WILC_WFI_frame_register(struct wiphy *wiphy,
 
 
 
-	/*BugID_5137*/
 	if (!frame_type)
 		return;
 
@@ -2792,7 +2762,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	del_timer(&hDuringIpTimer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 	#endif
-	/*BugID_5137*/
 	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
 		Set_machw_change_vir_if(true);
@@ -2822,7 +2791,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
-			/*BugID_5213*/
 			/*Eliminate host interface blocking state*/
 			up(&g_linux_wlan->cfg_event);
 
@@ -2874,8 +2842,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 					(struct key_params *)(&g_key_gtk_params));
 			}
 
-			/*BugID_4847: registered frames in firmware are now*/
-			/*lost due to mac close. So re-register those frames*/
 			if (g_linux_wlan->wilc1000_initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
@@ -2964,8 +2930,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			refresh_scan(priv, 1, true);
 			Set_machw_change_vir_if(false);
 
-			/*BugID_4847: registered frames in firmware are now lost
-			 *  due to mac close. So re-register those frames */
 			if (g_linux_wlan->wilc1000_initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
@@ -2997,8 +2961,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			mac_close(dev);
 			mac_open(dev);
 
-			/*BugID_4847: registered frames in firmware are now lost
-			 * due to mac close. So re-register those frames */
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
@@ -3018,7 +2980,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		mod_timer(&hDuringIpTimer, jiffies + msecs_to_jiffies(duringIP_TIME));
 		#endif
 		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
-		/*BugID_5222*/
 		/*Delete block ack has to be the latest config packet*/
 		/*sent before downloading new FW. This is because it blocks on*/
 		/*hWaitResponse semaphore, which allows previous config*/
@@ -3093,8 +3054,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		}
 		#endif
 
-		/*BugID_4847: registered frames in firmware are now*/
-		/*lost due to mac close. So re-register those frames*/
 		if (g_linux_wlan->wilc1000_initialized)	{
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
@@ -3225,7 +3184,6 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	PRINT_D(HOSTAPD_DBG, "Deleting beacon\n");
 
-	/*BugID_5188*/
 	linux_wlan_set_bssid(dev, NullBssid);
 
 	s32Error = host_int_del_beacon(priv->hWILCWFIDrv);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 6ea5c87f..39fbbb3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -189,7 +189,6 @@ typedef struct {
 	u8 open_ifcs;
 	struct mutex txq_cs;
 
-	/*Added by Amr - BugID_4720*/
 	struct semaphore txq_add_to_head_cs;
 	spinlock_t txq_spinlock;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d27ef47..e036843 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -71,7 +71,6 @@ typedef struct {
 	 **/
 	void *txq_lock;
 
-	/*Added by Amr - BugID_4720*/
 	struct semaphore *txq_add_to_head_lock;
 	void *txq_spinlock;
 	unsigned long txq_spinlock_flags;
@@ -124,7 +123,6 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 
 static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 
-/*BugID_5213*/
 /*acquire_bus() and release_bus() are made static inline functions*/
 /*as a temporary workaround to fix a problem of receiving*/
 /*unknown interrupt from FW*/
@@ -194,7 +192,6 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 		}
 		p->txq_entries -= 1;
 
-		/*Added by Amr - BugID_4720*/
 
 
 
@@ -209,7 +206,6 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
-	/*Added by Amr - BugID_4720*/
 	spin_lock_irqsave(p->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
@@ -226,7 +222,6 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	/*Added by Amr - BugID_4720*/
 	spin_unlock_irqrestore(p->txq_spinlock, flags);
 
 	/**
@@ -241,7 +236,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
-	/*Added by Amr - BugID_4720*/
 	if (p->os_func.os_wait(p->txq_add_to_head_lock, CFG_PKTS_TIMEOUT))
 		return -1;
 
@@ -261,7 +255,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	/*Added by Amr - BugID_4720*/
 	spin_unlock_irqrestore(p->txq_spinlock, flags);
 	up(p->txq_add_to_head_lock);
 
@@ -272,7 +265,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	up(p->txq_wait);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
-	/*Added by Amr - BugID_4720*/
 	return 0;
 
 }
@@ -524,7 +516,6 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	 **/
 	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
 
-	/*Edited by Amr - BugID_4720*/
 	if (wilc_wlan_txq_add_to_head(tqe))
 		return 0;
 	return 1;
@@ -594,12 +585,10 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 	struct txq_entry_t *tqe;
 	unsigned long flags;
 
-	/*Added by Amr - BugID_4720*/
 	spin_lock_irqsave(p->txq_spinlock, flags);
 
 	tqe = p->txq_head;
 
-	/*Added by Amr - BugID_4720*/
 	spin_unlock_irqrestore(p->txq_spinlock, flags);
 
 
@@ -610,11 +599,9 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
-	/*Added by Amr - BugID_4720*/
 	spin_lock_irqsave(p->txq_spinlock, flags);
 
 	tqe = tqe->next;
-	/*Added by Amr - BugID_4720*/
 	spin_unlock_irqrestore(p->txq_spinlock, flags);
 
 
@@ -869,7 +856,6 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 		if (p->quit)
 			break;
 
-		/*Added by Amr - BugID_4720*/
 		p->os_func.os_wait(p->txq_add_to_head_lock, CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack();
@@ -1151,7 +1137,6 @@ _end_:
 		if (ret != 1)
 			break;
 	} while (0);
-	/*Added by Amr - BugID_4720*/
 	up(p->txq_add_to_head_lock);
 
 	p->txq_exit = 1;
@@ -1595,13 +1580,11 @@ static int wilc_wlan_start(void)
 	reg |= WILC_HAVE_LEGACY_RF_SETTINGS;
 
 
-/*BugID_5257*/
 /*Set oscillator frequency*/
 #ifdef XTAL_24
 	reg |= WILC_HAVE_XTAL_24;
 #endif
 
-/*BugID_5271*/
 /*Enable/Disable GPIO configuration for FW logs*/
 #ifdef DISABLE_WILC_UART
 	reg |= WILC_HAVE_DISABLE_WILC_UART;
@@ -1826,7 +1809,6 @@ static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
 	 *      Add to TX queue
 	 **/
 
-	/*Edited by Amr - BugID_4720*/
 	if (!wilc_wlan_txq_add_cfg_pkt(&cfg->wid_header[0], total_len))
 		return -1;
 
@@ -1856,9 +1838,8 @@ static int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size, in
 		PRINT_D(RX_DBG, "Processing cfg_set()\n");
 		p->cfg_frame_in_use = 1;
 
-		/*Edited by Amr - BugID_4720*/
 		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
-			ret_size = 0;   /* BugID_5213 */
+			ret_size = 0;
 
 		if (p->os_func.os_wait(p->cfg_wait, CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
@@ -1893,9 +1874,8 @@ static int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 	if (commit) {
 		p->cfg_frame_in_use = 1;
 
-		/*Edited by Amr - BugID_4720*/
 		if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, drvHandler))
-			ret_size = 0;   /* BugID_5213 */
+			ret_size = 0;
 
 
 		if (p->os_func.os_wait(p->cfg_wait, CFG_PKTS_TIMEOUT)) {
@@ -2052,10 +2032,8 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	g_wlan.hif_lock = inp->os_context.hif_critical_section;
 	g_wlan.txq_lock = inp->os_context.txq_critical_section;
 
-	/*Added by Amr - BugID_4720*/
 	g_wlan.txq_add_to_head_lock = inp->os_context.txq_add_to_head_critical_section;
 
-	/*Added by Amr - BugID_4720*/
 	g_wlan.txq_spinlock = inp->os_context.txq_spin_lock;
 
 	g_wlan.rxq_lock = inp->os_context.rxq_critical_section;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 18bc11c..50d8ac1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -54,7 +54,6 @@
  *
  ********************************************/
 #define WILC_PERIPH_REG_BASE 0x1000
-/*BugID_5137*/
 #define WILC_CHANGING_VIR_IF                     (0x108c)
 #define WILC_CHIPID	(WILC_PERIPH_REG_BASE)
 #define WILC_GLB_RESET_0 (WILC_PERIPH_REG_BASE + 0x400)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b64f93a..ccef61c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -130,7 +130,6 @@ typedef struct {
 	u32 tx_buffer_size;
 	void *txq_critical_section;
 
-	/*Added by Amr - BugID_4720*/
 	void *txq_add_to_head_critical_section;
 	void *txq_spin_lock;
 
@@ -635,7 +634,6 @@ typedef enum {
 	/*  --------------------------------------------------------------------        */
 	WID_LINK_LOSS_THRESHOLD            = 0x0037,
 
-	/*BugID_4978*/
 	WID_ABORT_RUNNING_SCAN = 0x003E,
 
 	/* NMAC Character WID list */
@@ -890,12 +888,9 @@ typedef enum {
 	 #ifdef WILC_P2P
 	WID_REMAIN_ON_CHAN  = 0x3996,
 	#endif
-	/*BugID_4156*/
 	WID_SSID_PROBE_REQ = 0x3997,
-	/*BugID_4124 WID to trigger modified Join Request using SSID and BSSID instead of bssListIdx (used by WID_JOIN_REQ)*/
 	WID_JOIN_REQ_EXTENDED		 = 0x3998,
 
-	/* BugID 4951: WID toset IP address in firmware */
 	WID_IP_ADDRESS					= 0x3999,
 
 
@@ -915,19 +910,15 @@ typedef enum {
 	WID_11N_AUTORATE_TABLE             = 0x4080,
 
 
-	/*Added here by Amr - BugID 4134*/
 	WID_SCAN_CHANNEL_LIST                      = 0x4084,
 
-	/*BugID_3746 WID to add IE to be added in next probe request*/
 	WID_INFO_ELEMENT_PROBE	 = 0x4085,
-	/*BugID_3746 WID to add IE to be added in next associate request*/
 	WID_INFO_ELEMENT_ASSOCIATE	 = 0x4086,
 	WID_ADD_STA					 = 0X4087,
 	WID_REMOVE_STA				 = 0X4088,
 	WID_EDIT_STA					 = 0X4089,
 	WID_ADD_BEACON				= 0x408a,
 
-	/* BugID 5108 */
 	WID_SETUP_MULTICAST_FILTER	= 0x408b,
 
 	/* Miscellaneous WIDs */
-- 
2.5.1

