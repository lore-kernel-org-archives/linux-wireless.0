Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:51617 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbbJTWsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/19] staging/wilc1000: use proper naming for global symbols
Date: Wed, 21 Oct 2015 00:47:22 +0200
Message-Id: <1445381258-1455986-4-git-send-email-arnd@arndb.de> (sfid-20151021_004914_834365_5D592152)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are many global symbols in the wilc1000 driver, some of them
with names like "DEBUG_LEVEL" or "probe" that are not acceptable
for globals in the linux kernel as they may easily conflict with other
(equally broken) drivers.

This renames all the globals that do not already start with
wilc or a variation of that to start with wilc1000_ and to follow
the usual naming conventions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/coreconfigurator.c       |   6 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  12 +-
 drivers/staging/wilc1000/host_interface.c         | 162 ++++-----
 drivers/staging/wilc1000/host_interface.h         | 104 +++---
 drivers/staging/wilc1000/linux_mon.c              |   4 +-
 drivers/staging/wilc1000/linux_wlan.c             | 406 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan_common.h      |  18 +-
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  62 ++--
 drivers/staging/wilc1000/linux_wlan_sdio.h        |  18 +-
 drivers/staging/wilc1000/linux_wlan_spi.c         |  18 +-
 drivers/staging/wilc1000/linux_wlan_spi.h         |  12 +-
 drivers/staging/wilc1000/wilc_debugfs.c           |  18 +-
 drivers/staging/wilc1000/wilc_sdio.c              |   2 +-
 drivers/staging/wilc1000/wilc_spi.c               |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 312 ++++++++---------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  94 ++---
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |   6 +-
 19 files changed, 630 insertions(+), 630 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 28ab89b3a65d..905fd3e03bfa 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -469,7 +469,7 @@ s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
  *  @date		1 Mar 2012
  *  @version		1.0
  */
-s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
+s32 wilc1000_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
 {
 	s32 s32Error = 0;
 
@@ -502,7 +502,7 @@ s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
  *  @date			2 Apr 2012
  *  @version		1.0
  */
-s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
+s32 wilc1000_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 			       tstrConnectRespInfo **ppstrConnectRespInfo)
 {
 	s32 s32Error = 0;
@@ -554,7 +554,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
  *  @date			2 Apr 2012
  *  @version		1.0
  */
-s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
+s32 wilc1000_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 {
 	s32 s32Error = 0;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 6294d929a800..46476f9872a0 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -129,14 +129,14 @@ typedef struct {
 
 s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv);
 s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
-s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
+s32 wilc1000_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
 
-s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
+s32 wilc1000_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 		       tstrConnectRespInfo **ppstrConnectRespInfo);
-s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo);
+s32 wilc1000_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo);
 
-void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length);
-void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length);
-void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length);
+void wilc1000_network_info_received(u8 *pu8Buffer, u32 u32Length);
+void wilc1000_egnrl_async_info_received(u8 *pu8Buffer, u32 u32Length);
+void wilc1000_scan_complete_received(u8 *pu8Buffer, u32 u32Length);
 
 #endif
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4e9dfb493b9f..c8c5f5c602c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -8,11 +8,11 @@
 #include "wilc_msgqueue.h"
 #include <linux/etherdevice.h>
 
-extern u8 connecting;
+extern u8 wilc1000_connecting;
 
-extern struct timer_list hDuringIpTimer;
+extern struct timer_list wilc1000_during_ip_timer;
 
-extern u8 g_wilc_initialized;
+extern u8 wilc1000_initialized;
 
 #define HOST_IF_MSG_SCAN                        0
 #define HOST_IF_MSG_CONNECT                     1
@@ -231,7 +231,7 @@ struct join_bss_param {
 
 static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
-bool g_obtainingIP;
+bool wilc1000_optaining_ip;
 static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
@@ -241,7 +241,7 @@ static struct semaphore hif_sema_wait_response;
 static struct semaphore hif_sema_deinit;
 static struct timer_list periodic_rssi;
 
-u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+u8 wilc1000_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
@@ -268,8 +268,8 @@ static struct host_if_drv *join_req_drv;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-extern void chip_sleep_manually(u32 u32SleepTime);
-extern int linux_wlan_get_num_conn_ifcs(void);
+extern void wilc1000_chip_sleep_manually(u32 u32SleepTime);
+extern int wilc1000_wlan_get_num_conn_ifcs(void);
 
 static int add_handler_in_list(struct host_if_drv *handler)
 {
@@ -456,7 +456,7 @@ static s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 i
 	kfree(strWID.val);
 
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
-		host_int_setup_ipaddress(hif_drv, set_ip[idx], idx);
+		wilc1000_setup_ipaddress(hif_drv, set_ip[idx], idx);
 
 	if (s32Error != 0) {
 		PRINT_ER("Failed to get IP address\n");
@@ -809,7 +809,7 @@ ERRORHANDLER:
 
 static s32 Handle_wait_msg_q_empty(void)
 {
-	g_wilc_initialized = 0;
+	wilc1000_initialized = 0;
 	up(&hif_sema_wait_response);
 	return 0;
 }
@@ -841,7 +841,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	}
 
-	if (g_obtainingIP || connecting) {
+	if (wilc1000_optaining_ip || wilc1000_connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		PRINT_ER("Don't do obss scan\n");
 		s32Error = -EBUSY;
@@ -987,7 +987,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-u8 u8ConnectedSSID[6] = {0};
+u8 wilc1000_connected_SSID[6] = {0};
 static s32 Handle_Connect(struct host_if_drv *hif_drv,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
@@ -999,7 +999,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
-	if (memcmp(pstrHostIFconnectAttr->bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
+	if (memcmp(pstrHostIFconnectAttr->bssid, wilc1000_connected_SSID, ETH_ALEN) == 0) {
 
 		s32Error = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
@@ -1210,10 +1210,10 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
 
 	if (pstrHostIFconnectAttr->bssid != NULL) {
-		memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->bssid, ETH_ALEN);
+		memcpy(wilc1000_connected_SSID, pstrHostIFconnectAttr->bssid, ETH_ALEN);
 
 		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n", pstrHostIFconnectAttr->bssid);
-		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
+		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc1000_connected_SSID);
 	}
 
 	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
@@ -1233,7 +1233,7 @@ ERRORHANDLER:
 
 		del_timer(&hif_drv->hConnectTimer);
 
-		PRINT_D(HOSTINF_DBG, "could not start connecting to the required network\n");
+		PRINT_D(HOSTINF_DBG, "could not start wilc1000_connecting to the required network\n");
 
 		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
@@ -1387,7 +1387,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 	kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-	eth_zero_addr(u8ConnectedSSID);
+	eth_zero_addr(wilc1000_connected_SSID);
 
 	if (join_req != NULL && join_req_drv == hif_drv) {
 		kfree(join_req);
@@ -1482,7 +1482,7 @@ done:
 	pstrRcvdNetworkInfo->buffer = NULL;
 
 	if (pstrNetworkInfo != NULL) {
-		DeallocateNetworkInfo(pstrNetworkInfo);
+		wilc1000_dealloc_network_info(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
 	}
 
@@ -1562,10 +1562,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				if (u32RcvdAssocRespInfoLen != 0) {
 
 					PRINT_D(HOSTINF_DBG, "Parsing association response\n");
-					s32Err = ParseAssocRespInfo(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
+					s32Err = wilc1000_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
 								    &pstrConnectRespInfo);
 					if (s32Err) {
-						PRINT_ER("ParseAssocRespInfo() returned error %d\n", s32Err);
+						PRINT_ER("wilc1000_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
 						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->u16ConnectStatus;
 
@@ -1582,7 +1582,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 						}
 
 						if (pstrConnectRespInfo != NULL) {
-							DeallocateAssocRespInfo(pstrConnectRespInfo);
+							wilc1000_dealloc_assoc_resp_info(pstrConnectRespInfo);
 							pstrConnectRespInfo = NULL;
 						}
 					}
@@ -1592,11 +1592,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
 				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
-				eth_zero_addr(u8ConnectedSSID);
+				eth_zero_addr(wilc1000_connected_SSID);
 
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
 				PRINT_ER("Received MAC status is MAC_DISCONNECTED\n");
-				eth_zero_addr(u8ConnectedSSID);
+				eth_zero_addr(wilc1000_connected_SSID);
 			}
 
 			if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
@@ -1629,14 +1629,14 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-				host_int_set_power_mgmt(hif_drv, 0, 0);
+				wilc1000_set_power_mgmt(hif_drv, 0, 0);
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
 				hif_drv->enuHostIFstate = HOST_IF_CONNECTED;
 
 				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
-				g_obtainingIP = true;
-				mod_timer(&hDuringIpTimer,
+				wilc1000_optaining_ip = true;
+				mod_timer(&wilc1000_during_ip_timer,
 					  jiffies + msecs_to_jiffies(10000));
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
@@ -1671,8 +1671,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			strDisconnectNotifInfo.ie_len = 0;
 
 			if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
-				g_obtainingIP = false;
-				host_int_set_power_mgmt(hif_drv, 0, 0);
+				wilc1000_optaining_ip = false;
+				wilc1000_set_power_mgmt(hif_drv, 0, 0);
 
 				hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 										   NULL,
@@ -2031,10 +2031,10 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	g_obtainingIP = false;
-	host_int_set_power_mgmt(hif_drv, 0, 0);
+	wilc1000_optaining_ip = false;
+	wilc1000_set_power_mgmt(hif_drv, 0, 0);
 
-	eth_zero_addr(u8ConnectedSSID);
+	eth_zero_addr(wilc1000_connected_SSID);
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
@@ -2098,13 +2098,13 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 }
 
 
-void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
+void wilc1000_resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 {
 	if (!hif_drv)
 		return;
 	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (hif_drv->enuHostIFstate == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		host_int_disconnect(hif_drv, 1);
+		wilc1000_disconnect(hif_drv, 1);
 	}
 }
 
@@ -2569,12 +2569,12 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	}
 	if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
-		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while connecting return\n");
+		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while wilc1000_connecting return\n");
 		s32Error = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
-	if (g_obtainingIP || connecting) {
+	if (wilc1000_optaining_ip || wilc1000_connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		s32Error = -EBUSY;
 		goto ERRORHANDLER;
@@ -2768,7 +2768,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
 
 	if ((strHostIfSetMulti->cnt) > 0)
-		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
+		memcpy(pu8CurrByte, wilc1000_multicast_mac_addr_list, ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
@@ -2903,7 +2903,7 @@ static int hostIFthread(void *pvArg)
 			break;
 		}
 
-		if ((!g_wilc_initialized)) {
+		if ((!wilc1000_initialized)) {
 			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -2963,8 +2963,8 @@ static int hostIFthread(void *pvArg)
 			del_timer(&hif_drv->hScanTimer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
-			if (!linux_wlan_get_num_conn_ifcs())
-				chip_sleep_manually(INFINITE_SLEEP_TIME);
+			if (!wilc1000_wlan_get_num_conn_ifcs())
+				wilc1000_chip_sleep_manually(INFINITE_SLEEP_TIME);
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
@@ -3121,7 +3121,7 @@ static void TimerCB_Connect(unsigned long arg)
 	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 }
 
-s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
+s32 wilc1000_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 {
 	struct wid strWID;
 
@@ -3133,7 +3133,7 @@ s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 	return 0;
 }
 
-int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
+int wilc1000_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3160,7 +3160,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
+s32 wilc1000_set_wep_default_keyid(struct host_if_drv *hif_drv, u8 u8Index)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3189,7 +3189,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 	return s32Error;
 }
 
-s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
+s32 wilc1000_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 const u8 *pu8WepKey,
 				 u8 u8WepKeylen,
 				 u8 u8Keyidx)
@@ -3225,7 +3225,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 }
 
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
+s32 wilc1000_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *pu8WepKey,
 				u8 u8WepKeylen,
 				u8 u8Keyidx,
@@ -3270,7 +3270,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 }
 
-s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
+s32 wilc1000_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
@@ -3335,7 +3335,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	return s32Error;
 }
 
-s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
+s32 wilc1000_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
@@ -3397,7 +3397,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	return s32Error;
 }
 
-s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
+s32 wilc1000_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3431,7 +3431,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	return s32Error;
 }
 
-s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 wilc1000_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3452,7 +3452,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return s32Error;
 }
 
-s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 wilc1000_set_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3484,7 +3484,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 	return 0;
 }
 
-s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
+s32 wilc1000_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
 			  wilc_connect_result pfConnectResult, void *pvUserArg,
@@ -3551,7 +3551,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	return s32Error;
 }
 
-s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
+s32 wilc1000_flush_join_req(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3580,7 +3580,7 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
+s32 wilc1000_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3633,7 +3633,7 @@ static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8Assoc
 	return s32Error;
 }
 
-int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
+int wilc1000_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 {
 	int result;
 	struct host_if_msg msg;
@@ -3657,7 +3657,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 	return 0;
 }
 
-int host_int_wait_msg_queue_idle(void)
+int wilc1000_wait_msg_queue_idle(void)
 {
 	int result = 0;
 
@@ -3675,7 +3675,7 @@ int host_int_wait_msg_queue_idle(void)
 	return result;
 }
 
-int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
+int wilc1000_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 {
 	int result = 0;
 
@@ -3694,7 +3694,7 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 	return result;
 }
 
-int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
+int wilc1000_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 {
 	int result = 0;
 
@@ -3713,7 +3713,7 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	return result;
 }
 
-s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
+s32 wilc1000_get_inactive_time(struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 s32Error = 0;
@@ -3744,7 +3744,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
+s32 wilc1000_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3772,7 +3772,7 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	return s32Error;
 }
 
-s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
+s32 wilc1000_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -3792,7 +3792,7 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 	return s32Error;
 }
 
-s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
+s32 wilc1000_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		  u8 u8ScanType, u8 *pu8ChnlFreqList,
 		  u8 u8ChnlListLen, const u8 *pu8IEs,
 		  size_t IEsLen, wilc_scan_result ScanResult,
@@ -3846,7 +3846,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 
 }
 
-s32 hif_set_cfg(struct host_if_drv *hif_drv,
+s32 wilc1000_hif_set_cfg(struct host_if_drv *hif_drv,
 		struct cfg_param_val *pstrCfgParamVal)
 {
 
@@ -3901,7 +3901,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 
 static u32 clients_count;
 
-s32 host_int_init(struct host_if_drv **hif_drv_handler)
+s32 wilc1000_init(struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
 	struct host_if_drv *hif_drv;
@@ -3925,7 +3925,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 		goto _fail_timer_2;
 	}
 
-	g_obtainingIP = false;
+	wilc1000_optaining_ip = false;
 
 	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", hif_drv);
 	if (clients_count == 0)	{
@@ -4004,7 +4004,7 @@ _fail_:
 	return result;
 }
 
-s32 host_int_deinit(struct host_if_drv *hif_drv)
+s32 wilc1000_deinit(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4033,7 +4033,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 
 	del_timer_sync(&hif_drv->hRemainOnChannel);
 
-	host_int_set_wfi_drv_handler(NULL);
+	wilc1000_set_wfi_drv_handler(NULL);
 	down(&hif_sema_driver);
 
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
@@ -4079,7 +4079,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
+void wilc1000_network_info_received(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4111,7 +4111,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
 }
 
-void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
+void wilc1000_egnrl_async_info_received(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4154,7 +4154,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	up(&hif_sema_deinit);
 }
 
-void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
+void wilc1000_scan_complete_received(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4186,7 +4186,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 
 }
 
-s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
+s32 wilc1000_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 			       u32 u32duration, u16 chan,
 			       wilc_remain_on_chan_expired RemainOnChanExpired,
 			       wilc_remain_on_chan_ready RemainOnChanReady,
@@ -4218,7 +4218,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	return s32Error;
 }
 
-s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
+s32 wilc1000_listen_state_expired(struct host_if_drv *hif_drv, u32 u32SessionID)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4242,7 +4242,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	return s32Error;
 }
 
-s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
+s32 wilc1000_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4283,7 +4283,7 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 
 }
 
-s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
+s32 wilc1000_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 			u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
 			u32 u32TailLen, u8 *pu8Tail)
 {
@@ -4338,7 +4338,7 @@ ERRORHANDLER:
 
 }
 
-s32 host_int_del_beacon(struct host_if_drv *hif_drv)
+s32 wilc1000_del_beacon(struct host_if_drv *hif_drv)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4359,7 +4359,7 @@ s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-s32 host_int_add_station(struct host_if_drv *hif_drv,
+s32 wilc1000_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
@@ -4396,7 +4396,7 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
+s32 wilc1000_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
@@ -4425,7 +4425,7 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	return s32Error;
 }
 
-s32 host_int_del_allstation(struct host_if_drv *hif_drv,
+s32 wilc1000_del_allstation(struct host_if_drv *hif_drv,
 			    u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = 0;
@@ -4478,7 +4478,7 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 
 }
 
-s32 host_int_edit_station(struct host_if_drv *hif_drv,
+s32 wilc1000_edit_station(struct host_if_drv *hif_drv,
 			  struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
@@ -4515,7 +4515,7 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
+s32 wilc1000_set_power_mgmt(struct host_if_drv *hif_drv,
 			    bool bIsEnabled,
 			    u32 u32Timeout)
 {
@@ -4546,7 +4546,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
+s32 wilc1000_setup_multicast_filter(struct host_if_drv *hif_drv,
 				    bool bIsEnabled,
 				    u32 u32count)
 {
@@ -4737,7 +4737,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 
 }
 
-void host_int_freeJoinParams(void *pJoinParams)
+void wilc1000_free_join_params(void *pJoinParams)
 {
 	if ((struct bss_param *)pJoinParams != NULL)
 		kfree((struct bss_param *)pJoinParams);
@@ -4745,7 +4745,7 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
+s32 wilc1000_del_all_rx_ba_session(struct host_if_drv *hif_drv,
 				  char *pBSSID,
 				  char TID)
 {
@@ -4775,7 +4775,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
+s32 wilc1000_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1661eeb0a2e7..826ed0f30615 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -356,7 +356,7 @@ struct add_sta_param {
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
+s32 wilc1000_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
 /**
  *  @brief              removes WEP key
  *  @details    valid only in BSS STA mode if External Supplicant support is enabled.
@@ -371,7 +371,7 @@ s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
+int wilc1000_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
 /**
  *  @brief              sets WEP deafault key
  *  @details    Sets the index of the WEP encryption key in use,
@@ -384,7 +384,7 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index);
+s32 wilc1000_set_wep_default_keyid(struct host_if_drv *hWFIDrv, u8 u8Index);
 
 /**
  *  @brief              sets WEP deafault key
@@ -405,9 +405,9 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
+s32 wilc1000_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
 /**
- *  @brief              host_int_add_wep_key_bss_ap
+ *  @brief              wilc1000_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
  *                              sets WEP key entry into MAC hardware when it receives the
  *                              corresponding request from NDIS.
@@ -420,7 +420,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKe
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
+s32 wilc1000_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
@@ -438,11 +438,11 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
+s32 wilc1000_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx);
 
 /**
- *  @brief              host_int_get_inactive_time
+ *  @brief              wilc1000_get_inactive_time
  *  @details
  *  @param[in,out] handle to the wifi driver
  *  @param[in]  message containing inactive time
@@ -453,7 +453,7 @@ s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeyl
  *  @date		15 April 2013
  *  @version		1.0
  */
-s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
+s32 wilc1000_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
 
 /**
  *  @brief              adds Rx GTk Key
@@ -471,7 +471,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
+s32 wilc1000_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
 
@@ -515,7 +515,7 @@ s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk,
  *  @version		1.0
  */
 
-s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
+s32 wilc1000_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
 /**
  *  @brief              gets mac address
  *  @details
@@ -527,7 +527,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
  *  @date		19 April 2012
  *  @version		1.0
  */
-s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+s32 wilc1000_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              sets mac address
@@ -540,7 +540,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
  *  @date		16 July 2012
  *  @version		1.0
  */
-s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+s32 wilc1000_set_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 
 /**
  *  @brief              wait until msg q is empty
@@ -553,7 +553,7 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
  *  @date		19 march 2014
  *  @version		1.0
  */
-int host_int_wait_msg_queue_idle(void);
+int wilc1000_wait_msg_queue_idle(void);
 
 /**
  *  @brief              sets a start scan request
@@ -585,7 +585,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
  *  @version		1.0
  */
 
-s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
+s32 wilc1000_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  wilc_connect_result pfConnectResult, void *pvUserArg,
@@ -605,7 +605,7 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
  *  @version		8.0
  */
 
-s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
+s32 wilc1000_flush_join_req(struct host_if_drv *hWFIDrv);
 
 
 /**
@@ -619,7 +619,7 @@ s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
+s32 wilc1000_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
 
 /**
  *  @brief              sets a channel
@@ -636,7 +636,7 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
+int wilc1000_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
 
 /**
  *  @brief              gets the sta rssi
@@ -651,7 +651,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
+s32 wilc1000_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
 
 /**
  *  @brief              scans a set of channels
@@ -670,7 +670,7 @@ s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
+s32 wilc1000_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, wilc_scan_result ScanResult,
@@ -687,7 +687,7 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
+s32 wilc1000_hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
 
 /*****************************************************************************/
 /*							Notification Functions							 */
@@ -702,7 +702,7 @@ s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamV
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_init(struct host_if_drv **phWFIDrv);
+s32 wilc1000_init(struct host_if_drv **phWFIDrv);
 
 /**
  *  @brief              host interface initialization function
@@ -713,11 +713,11 @@ s32 host_int_init(struct host_if_drv **phWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_deinit(struct host_if_drv *hWFIDrv);
+s32 wilc1000_deinit(struct host_if_drv *hWFIDrv);
 
 
 /*!
- *  @fn		s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv,u8 u8Index)
+ *  @fn		s32 wilc1000_add_beacon(WILC_WFIDrvHandle hWFIDrv,u8 u8Index)
  *  @brief		Sends a beacon to the firmware to be transmitted over the air
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -738,14 +738,14 @@ s32 host_int_deinit(struct host_if_drv *hWFIDrv);
  *  @version		1.0 Description
  *
  */
-s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
+s32 wilc1000_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8tail);
 
 
 /*!
- *  @fn		s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
+ *  @fn		s32 wilc1000_del_beacon(WILC_WFIDrvHandle hWFIDrv)
  *  @brief		Removes the beacon and stops trawilctting it over the air
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -756,10 +756,10 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
  *  @date		10 Julys 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_beacon(struct host_if_drv *hWFIDrv);
+s32 wilc1000_del_beacon(struct host_if_drv *hWFIDrv);
 
 /*!
- *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv,
+ *  @fn		s32 wilc1000_add_station(WILC_WFIDrvHandle hWFIDrv,
  *					 struct add_sta_param *pstrStaParams)
  *  @brief		Notifies the firmware with a new associated stations
  *  @details
@@ -772,11 +772,11 @@ s32 host_int_del_beacon(struct host_if_drv *hWFIDrv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_add_station(struct host_if_drv *hWFIDrv,
+s32 wilc1000_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
 
 /*!
- *  @fn		s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
+ *  @fn		s32 wilc1000_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
  *  @brief		Deauthenticates clients when group is terminating
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -788,10 +788,10 @@ s32 host_int_add_station(struct host_if_drv *hWFIDrv,
  *  @date		09 April 2014
  *  @version		1.0 Description
  */
-s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
+s32 wilc1000_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
 
 /*!
- *  @fn		s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr)
+ *  @fn		s32 wilc1000_del_station(WILC_WFIDrvHandle hWFIDrv, u8* pu8MacAddr)
  *  @brief		Notifies the firmware with a new deleted station
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -803,10 +803,10 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALE
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
+s32 wilc1000_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
- *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
+ *  @fn		s32 wilc1000_edit_station(WILC_WFIDrvHandle hWFIDrv,
  *					  struct add_sta_param *pstrStaParams)
  *  @brief		Notifies the firmware with new parameters of an already associated station
  *  @details
@@ -819,11 +819,11 @@ s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
+s32 wilc1000_edit_station(struct host_if_drv *hWFIDrv,
 			  struct add_sta_param *pstrStaParams);
 
 /*!
- *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
+ *  @fn		s32 wilc1000_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
  *  @brief		Set the power management mode to enabled or disabled
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -837,7 +837,7 @@ s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
+s32 wilc1000_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
 /*  @param[in,out]	hWFIDrv		handle to the wifi driver
  *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
  *  @param[in]	u8count		count of mac address entries in the filter table
@@ -849,9 +849,9 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u3
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count);
+s32 wilc1000_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count);
 /**
- *  @brief           host_int_setup_ipaddress
+ *  @brief           wilc1000_setup_ipaddress
  *  @details       set IP address on firmware
  *  @param[in]
  *  @return         Error code.
@@ -859,7 +859,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled
  *  @date
  *  @version	1.0
  */
-s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 wilc1000_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 
 /**
  *  @brief           host_int_delBASession
@@ -870,10 +870,10 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx)
  *  @date
  *  @version	1.0
  */
-s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
+s32 wilc1000_del_all_rx_ba_session(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
 
 /**
- *  @brief           host_int_remain_on_channel
+ *  @brief           wilc1000_remain_on_channel
  *  @details
  *  @param[in]
  *  @return         Error code.
@@ -881,10 +881,10 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, cha
  *  @date
  *  @version	1.0
  */
-s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg);
+s32 wilc1000_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg);
 
 /**
- *  @brief              host_int_ListenStateExpired
+ *  @brief              wilc1000_listen_state_expired
  *  @details
  *  @param[in]          Handle to wifi driver
  *                              Duration to remain on channel
@@ -897,10 +897,10 @@ s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u3
  *  @date
  *  @version		1.0
  */
-s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
+s32 wilc1000_listen_state_expired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
 
 /**
- *  @brief           host_int_frame_register
+ *  @brief           wilc1000_frame_register
  *  @details
  *  @param[in]
  *  @return         Error code.
@@ -908,9 +908,9 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool bReg);
+s32 wilc1000_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool bReg);
 /**
- *  @brief           host_int_set_wfi_drv_handler
+ *  @brief           wilc1000_set_wfi_drv_handler
  *  @details
  *  @param[in]
  *  @return         Error code.
@@ -918,11 +918,11 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool
  *  @date
  *  @version	1.0
  */
-int host_int_set_wfi_drv_handler(struct host_if_drv *address);
-int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
+int wilc1000_set_wfi_drv_handler(struct host_if_drv *address);
+int wilc1000_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
 
-void host_int_freeJoinParams(void *pJoinParams);
+void wilc1000_free_join_params(void *pJoinParams);
 
-s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
+s32 wilc1000_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
 
 #endif
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index d93594474a2d..52443f039a43 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -26,7 +26,7 @@ struct wilc_wfi_radiotap_cb_hdr {
 
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
-extern int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
+extern int  wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 
 
 static u8 srcAdd[6];
@@ -298,7 +298,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 		mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
 		dev_kfree_skb(skb);
 	} else
-		ret = mac_xmit(skb, mon_priv->real_ndev);
+		ret = wilc1000_mac_xmit(skb, mon_priv->real_ndev);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1b496e84100e..be4b1b1199f8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -45,12 +45,12 @@
  #define _linux_wlan_device_removal()		{}
 #endif
 
-extern bool g_obtainingIP;
-extern u16 Set_machw_change_vir_if(bool bValue);
-extern void resolve_disconnect_aberration(void *drvHandler);
-extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+extern bool wilc1000_optaining_ip;
+extern u16 wilc1000_set_machw_change_vir_if(bool bValue);
+extern void wilc1000_resolve_disconnect_aberration(void *drvHandler);
+extern u8 wilc1000_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 void wilc1000_wlan_deinit(struct wilc *nic);
-extern struct timer_list hDuringIpTimer;
+extern struct timer_list wilc1000_during_ip_timer;
 
 static int linux_wlan_device_power(int on_off)
 {
@@ -89,7 +89,7 @@ static struct notifier_block g_dev_notifier = {
 #define IRQ_WAIT	1
 #define IRQ_NO_WAIT	0
 /*
- *      to sync between mac_close and module exit.
+ *      to sync between wilc1000_mac_close and module exit.
  *      don't initialize or de-initialize from init/deinitlocks
  *      to be initialized from module wilc_netdev_init and
  *      deinitialized from mdoule_exit
@@ -103,9 +103,9 @@ extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
 static void linux_wlan_tx_complete(void *priv, int status);
 static int  mac_init_fn(struct net_device *ndev);
-int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
-int  mac_open(struct net_device *ndev);
-int  mac_close(struct net_device *ndev);
+int  wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
+int  wilc1000_mac_open(struct net_device *ndev);
+int  wilc1000_mac_close(struct net_device *ndev);
 static struct net_device_stats *mac_stats(struct net_device *dev);
 static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static void wilc_set_multicast_list(struct net_device *dev);
@@ -114,14 +114,14 @@ static void wilc_set_multicast_list(struct net_device *dev);
  * for now - in frmw_to_linux there should be private data to be passed to it
  * and this data should be pointer to net device
  */
-struct wilc *g_linux_wlan;
-bool bEnablePS = true;
+struct wilc *wilc1000_dev;
+bool wilc1000_enable_ps = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
 	.ndo_init = mac_init_fn,
-	.ndo_open = mac_open,
-	.ndo_stop = mac_close,
-	.ndo_start_xmit = mac_xmit,
+	.ndo_open = wilc1000_mac_open,
+	.ndo_stop = wilc1000_mac_close,
+	.ndo_start_xmit = wilc1000_mac_xmit,
 	.ndo_do_ioctl = mac_ioctl,
 	.ndo_get_stats = mac_stats,
 	.ndo_set_rx_mode  = wilc_set_multicast_list,
@@ -177,19 +177,19 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		/*If we are in station mode or client mode*/
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
 			pstrWFIDrv->IFC_UP = 1;
-			g_obtainingIP = false;
-			del_timer(&hDuringIpTimer);
+			wilc1000_optaining_ip = false;
+			del_timer(&wilc1000_during_ip_timer);
 			PRINT_D(GENERIC_DBG, "IP obtained , enable scan\n");
 		}
 
-		if (bEnablePS)
-			host_int_set_power_mgmt(pstrWFIDrv, 1, 0);
+		if (wilc1000_enable_ps)
+			wilc1000_set_power_mgmt(pstrWFIDrv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
-		host_int_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		wilc1000_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -199,20 +199,20 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Released ===============\n\n");
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
 			pstrWFIDrv->IFC_UP = 0;
-			g_obtainingIP = false;
+			wilc1000_optaining_ip = false;
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
+			wilc1000_set_power_mgmt(pstrWFIDrv, 0, 0);
 
-		resolve_disconnect_aberration(pstrWFIDrv);
+		wilc1000_resolve_disconnect_aberration(pstrWFIDrv);
 
 		PRINT_D(GENERIC_DBG, "[%s] Down IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = null_ip;
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 
-		host_int_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		wilc1000_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -233,7 +233,7 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 	PRINT_D(INT_DBG, "Interrupt received UH\n");
 
 	/*While mac is closing cacncel the handling of any interrupts received*/
-	if (g_linux_wlan->close) {
+	if (wilc1000_dev->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle UH interrupt\n");
 		return IRQ_HANDLED;
 	}
@@ -247,7 +247,7 @@ static irqreturn_t isr_bh_routine(int irq, void *userdata)
 	nic = (struct wilc *)userdata;
 
 	/*While mac is closing cacncel the handling of any interrupts received*/
-	if (g_linux_wlan->close) {
+	if (wilc1000_dev->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle BH interrupt\n");
 		return IRQ_HANDLED;
 	}
@@ -302,7 +302,7 @@ static void deinit_irq(struct wilc *nic)
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 	/* Deintialize IRQ */
 	if (&nic->dev_irq_num != 0) {
-		free_irq(nic->dev_irq_num, g_linux_wlan);
+		free_irq(nic->dev_irq_num, wilc1000_dev);
 
 		gpio_free(GPIO_NUM);
 	}
@@ -334,7 +334,7 @@ void linux_wlan_mac_indicate(int flag)
 	/*I have to do it that way becuase there is no mean to encapsulate device pointer
 	 * as a parameter
 	 */
-	struct wilc *pd = g_linux_wlan;
+	struct wilc *pd = wilc1000_dev;
 	int status;
 
 	if (flag == WILC_MAC_INDICATE_STATUS) {
@@ -364,10 +364,10 @@ static struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 10;
 	Bssid1 = pMacHeader + 4;
 
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
-			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
+	for (i = 0; i < wilc1000_dev->u8NoIfcs; i++) {
+		if (!memcmp(Bssid1, wilc1000_dev->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, wilc1000_dev->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
+			return wilc1000_dev->strInterfaceInfo[i].wilc_netdev;
 		}
 	}
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
@@ -375,27 +375,27 @@ static struct net_device *GetIfHandler(u8 *pMacHeader)
 		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
-			PRINT_D(INIT_DBG, "Ctx [%p]\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
+	for (i = 0; i < wilc1000_dev->u8NoIfcs; i++) {
+		if (!memcmp(Bssid1, wilc1000_dev->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, wilc1000_dev->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
+			PRINT_D(INIT_DBG, "Ctx [%p]\n", wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
+			return wilc1000_dev->strInterfaceInfo[i].wilc_netdev;
 		}
 	}
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
 }
 
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
+int wilc1000_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 {
 	int i = 0;
 	int ret = -1;
 
 	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
+	for (i = 0; i < wilc1000_dev->u8NoIfcs; i++) {
+		if (wilc1000_dev->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
 			PRINT_D(INIT_DBG, "set bssid [%x][%x][%x]\n", pBSSID[0], pBSSID[1], pBSSID[2]);
-			memcpy(g_linux_wlan->strInterfaceInfo[i].aBSSID, pBSSID, 6);
+			memcpy(wilc1000_dev->strInterfaceInfo[i].aBSSID, pBSSID, 6);
 			ret = 0;
 			break;
 		}
@@ -404,14 +404,14 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 }
 
 /*Function to get number of connected interfaces*/
-int linux_wlan_get_num_conn_ifcs(void)
+int wilc1000_wlan_get_num_conn_ifcs(void)
 {
 	u8 i = 0;
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
 
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (memcmp(g_linux_wlan->strInterfaceInfo[i].aBSSID, null_bssid, 6))
+	for (i = 0; i < wilc1000_dev->u8NoIfcs; i++) {
+		if (memcmp(wilc1000_dev->strInterfaceInfo[i].aBSSID, null_bssid, 6))
 			ret_val++;
 	}
 	return ret_val;
@@ -433,17 +433,17 @@ static int linux_wlan_txq_task(void *vp)
 #endif
 
 	/* inform wilc1000_wlan_init that TXQ task is started. */
-	up(&g_linux_wlan->txq_thread_started);
+	up(&wilc1000_dev->txq_thread_started);
 	while (1) {
 
 		PRINT_D(TX_DBG, "txq_task Taking a nap :)\n");
-		down(&g_linux_wlan->txq_event);
+		down(&wilc1000_dev->txq_event);
 		/* wait_for_completion(&pd->txq_event); */
 		PRINT_D(TX_DBG, "txq_task Who waked me up :$\n");
 
-		if (g_linux_wlan->close) {
-			/*Unlock the mutex in the mac_close function to indicate the exiting of the TX thread */
-			up(&g_linux_wlan->txq_thread_started);
+		if (wilc1000_dev->close) {
+			/*Unlock the mutex in the wilc1000_mac_close function to indicate the exiting of the TX thread */
+			up(&wilc1000_dev->txq_thread_started);
 
 			while (!kthread_should_stop())
 				schedule();
@@ -460,10 +460,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
-				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[0].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
-				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[1].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->strInterfaceInfo[1].wilc_netdev);
+				if (netif_queue_stopped(wilc1000_dev->strInterfaceInfo[0].wilc_netdev))
+					netif_wake_queue(wilc1000_dev->strInterfaceInfo[0].wilc_netdev);
+				if (netif_queue_stopped(wilc1000_dev->strInterfaceInfo[1].wilc_netdev))
+					netif_wake_queue(wilc1000_dev->strInterfaceInfo[1].wilc_netdev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
@@ -485,7 +485,7 @@ static int linux_wlan_txq_task(void *vp)
 				}
 			}
 			/*TODO: drop packets after a certain time/number of retry count. */
-		} while (ret == WILC_TX_ERR_NO_BUF && !g_linux_wlan->close); /* retry sending packets if no more buffers in chip. */
+		} while (ret == WILC_TX_ERR_NO_BUF && !wilc1000_dev->close); /* retry sending packets if no more buffers in chip. */
 #endif
 	}
 	return 0;
@@ -496,7 +496,7 @@ void linux_wlan_rx_complete(void)
 	PRINT_D(RX_DBG, "RX completed\n");
 }
 
-int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
+int wilc1000_wlan_get_firmware(perInterface_wlan_t *p_nic)
 {
 
 	perInterface_wlan_t *nic = p_nic;
@@ -528,19 +528,19 @@ int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
 	 *      root file system with the name specified above */
 
 #ifdef WILC_SDIO
-	if (request_firmware(&wilc_firmware, firmware, &g_linux_wlan->wilc_sdio_func->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, &wilc1000_dev->wilc_sdio_func->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
 #else
-	if (request_firmware(&wilc_firmware, firmware, &g_linux_wlan->wilc_spidev->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, &wilc1000_dev->wilc_spidev->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
 #endif
-	g_linux_wlan->wilc_firmware = wilc_firmware;
+	wilc1000_dev->wilc_firmware = wilc_firmware;
 
 _fail_:
 
@@ -566,7 +566,7 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 
 	/* wait for mac ready */
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
-	ret = linux_wlan_lock_timeout(&g_linux_wlan->sync_event, 5000);
+	ret = linux_wlan_lock_timeout(&wilc1000_dev->sync_event, 5000);
 	if (ret) {
 #ifdef COMPLEMENT_BOOT
 		static int timeout = 5;
@@ -597,7 +597,7 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 
 	int ret = 0;
 
-	if (g_linux_wlan->wilc_firmware == NULL) {
+	if (wilc1000_dev->wilc_firmware == NULL) {
 		PRINT_ER("Firmware buffer is NULL\n");
 		ret = -ENOBUFS;
 		goto _FAIL_;
@@ -606,16 +606,16 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 	 *      do the firmware download
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = wilc_wlan_firmware_download(g_linux_wlan->wilc_firmware->data,
-					  g_linux_wlan->wilc_firmware->size);
+	ret = wilc_wlan_firmware_download(wilc1000_dev->wilc_firmware->data,
+					  wilc1000_dev->wilc_firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
 
 	/* Freeing FW buffer */
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
-	release_firmware(g_linux_wlan->wilc_firmware);
-	g_linux_wlan->wilc_firmware = NULL;
+	release_firmware(wilc1000_dev->wilc_firmware);
+	wilc1000_dev->wilc_firmware = NULL;
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
@@ -883,7 +883,7 @@ _fail_:
 void wilc1000_wlan_deinit(struct wilc *nic)
 {
 
-	if (g_linux_wlan->wilc1000_initialized)	{
+	if (wilc1000_dev->wilc1000_initialized)	{
 
 		printk("Deinitializing wilc1000  ...\n");
 
@@ -901,18 +901,18 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
 #ifdef WILC_SDIO
-		mutex_lock(&g_linux_wlan->hif_cs);
-		disable_sdio_interrupt();
-		mutex_unlock(&g_linux_wlan->hif_cs);
+		mutex_lock(&wilc1000_dev->hif_cs);
+		wilc1000_sdio_disable_interrupt();
+		mutex_unlock(&wilc1000_dev->hif_cs);
 #endif
-		if (&g_linux_wlan->txq_event != NULL)
-			up(&g_linux_wlan->txq_event);
+		if (&wilc1000_dev->txq_event != NULL)
+			up(&wilc1000_dev->txq_event);
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 		wlan_deinitialize_threads(nic);
 
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
-		deinit_irq(g_linux_wlan);
+		deinit_irq(wilc1000_dev);
 
 		wilc_wlan_stop();
 
@@ -922,18 +922,18 @@ void wilc1000_wlan_deinit(struct wilc *nic)
   #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
 
-		mutex_lock(&g_linux_wlan->hif_cs);
-		disable_sdio_interrupt();
-		mutex_unlock(&g_linux_wlan->hif_cs);
+		mutex_lock(&wilc1000_dev->hif_cs);
+		wilc1000_sdio_disable_interrupt();
+		mutex_unlock(&wilc1000_dev->hif_cs);
   #endif
 #endif
 
 		/*De-Initialize locks*/
 		PRINT_D(INIT_DBG, "Deinitializing Locks\n");
-		wlan_deinit_locks(g_linux_wlan);
+		wlan_deinit_locks(wilc1000_dev);
 
 		/* announce that wilc1000 is not initialized */
-		g_linux_wlan->wilc1000_initialized = 0;
+		wilc1000_dev->wilc1000_initialized = 0;
 
 		PRINT_D(INIT_DBG, "wilc1000 deinitialization Done\n");
 
@@ -947,18 +947,18 @@ static int wlan_init_locks(struct wilc *p_nic)
 
 	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
 
-	mutex_init(&g_linux_wlan->hif_cs);
-	mutex_init(&g_linux_wlan->rxq_cs);
+	mutex_init(&wilc1000_dev->hif_cs);
+	mutex_init(&wilc1000_dev->rxq_cs);
 
-	spin_lock_init(&g_linux_wlan->txq_spinlock);
-	sema_init(&g_linux_wlan->txq_add_to_head_cs, 1);
+	spin_lock_init(&wilc1000_dev->txq_spinlock);
+	sema_init(&wilc1000_dev->txq_add_to_head_cs, 1);
 
-	sema_init(&g_linux_wlan->txq_event, 0);
+	sema_init(&wilc1000_dev->txq_event, 0);
 
-	sema_init(&g_linux_wlan->cfg_event, 0);
-	sema_init(&g_linux_wlan->sync_event, 0);
+	sema_init(&wilc1000_dev->cfg_event, 0);
+	sema_init(&wilc1000_dev->sync_event, 0);
 
-	sema_init(&g_linux_wlan->txq_thread_started, 0);
+	sema_init(&wilc1000_dev->txq_thread_started, 0);
 
 	return 0;
 }
@@ -967,11 +967,11 @@ static int wlan_deinit_locks(struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
-	if (&g_linux_wlan->hif_cs != NULL)
-		mutex_destroy(&g_linux_wlan->hif_cs);
+	if (&wilc1000_dev->hif_cs != NULL)
+		mutex_destroy(&wilc1000_dev->hif_cs);
 
-	if (&g_linux_wlan->rxq_cs != NULL)
-		mutex_destroy(&g_linux_wlan->rxq_cs);
+	if (&wilc1000_dev->rxq_cs != NULL)
+		mutex_destroy(&wilc1000_dev->rxq_cs);
 
 	return 0;
 }
@@ -985,20 +985,20 @@ static void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 
 #ifdef WILC_SDIO
 	nwi->io_func.io_type = HIF_SDIO;
-	nwi->io_func.io_init = linux_sdio_init;
-	nwi->io_func.io_deinit = linux_sdio_deinit;
-	nwi->io_func.u.sdio.sdio_cmd52 = linux_sdio_cmd52;
-	nwi->io_func.u.sdio.sdio_cmd53 = linux_sdio_cmd53;
-	nwi->io_func.u.sdio.sdio_set_max_speed = linux_sdio_set_max_speed;
-	nwi->io_func.u.sdio.sdio_set_default_speed = linux_sdio_set_default_speed;
+	nwi->io_func.io_init = wilc1000_sdio_init;
+	nwi->io_func.io_deinit = wilc1000_sdio_deinit;
+	nwi->io_func.u.sdio.sdio_cmd52 = wilc1000_sdio_cmd52;
+	nwi->io_func.u.sdio.sdio_cmd53 = wilc1000_sdio_cmd53;
+	nwi->io_func.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed;
+	nwi->io_func.u.sdio.sdio_set_default_speed = wilc1000_sdio_set_default_speed;
 #else
 	nwi->io_func.io_type = HIF_SPI;
-	nwi->io_func.io_init = linux_spi_init;
-	nwi->io_func.io_deinit = linux_spi_deinit;
-	nwi->io_func.u.spi.spi_tx = linux_spi_write;
-	nwi->io_func.u.spi.spi_rx = linux_spi_read;
-	nwi->io_func.u.spi.spi_trx = linux_spi_write_read;
-	nwi->io_func.u.spi.spi_max_speed = linux_spi_set_max_speed;
+	nwi->io_func.io_init = wilc1000_spi_init;
+	nwi->io_func.io_deinit = wilc1000_spi_deinit;
+	nwi->io_func.u.spi.spi_tx = wilc1000_spi_write;
+	nwi->io_func.u.spi.spi_rx = wilc1000_spi_read;
+	nwi->io_func.u.spi.spi_trx = wilc1000_spi_write_read;
+	nwi->io_func.u.spi.spi_max_speed = wilc1000_spi_set_max_speed;
 #endif
 }
 
@@ -1011,44 +1011,44 @@ static int wlan_initialize_threads(perInterface_wlan_t *nic)
 
 	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
-	g_linux_wlan->txq_thread = kthread_run(linux_wlan_txq_task, (void *)g_linux_wlan, "K_TXQ_TASK");
-	if (g_linux_wlan->txq_thread == NULL) {
+	wilc1000_dev->txq_thread = kthread_run(linux_wlan_txq_task, (void *)wilc1000_dev, "K_TXQ_TASK");
+	if (wilc1000_dev->txq_thread == NULL) {
 		PRINT_ER("couldn't create TXQ thread\n");
 		ret = -ENOBUFS;
 		goto _fail_2;
 	}
 	/* wait for TXQ task to start. */
-	down(&g_linux_wlan->txq_thread_started);
+	down(&wilc1000_dev->txq_thread_started);
 
 	return 0;
 
 _fail_2:
 	/*De-Initialize 2nd thread*/
-	g_linux_wlan->close = 1;
+	wilc1000_dev->close = 1;
 
-	g_linux_wlan->close = 0;
+	wilc1000_dev->close = 0;
 	return ret;
 }
 
 static void wlan_deinitialize_threads(struct wilc *nic)
 {
 
-	g_linux_wlan->close = 1;
+	wilc1000_dev->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 
-	if (&g_linux_wlan->txq_event != NULL)
-		up(&g_linux_wlan->txq_event);
+	if (&wilc1000_dev->txq_event != NULL)
+		up(&wilc1000_dev->txq_event);
 
-	if (g_linux_wlan->txq_thread != NULL) {
-		kthread_stop(g_linux_wlan->txq_thread);
-		g_linux_wlan->txq_thread = NULL;
+	if (wilc1000_dev->txq_thread != NULL) {
+		kthread_stop(wilc1000_dev->txq_thread);
+		wilc1000_dev->txq_thread = NULL;
 	}
 }
 
 #ifdef COMPLEMENT_BOOT
 
-extern volatile int probe;
-extern u8 core_11b_ready(void);
+extern volatile int wilc1000_probe;
+extern u8 wilc1000_core_11b_ready(void);
 
 #define READY_CHECK_THRESHOLD		30
 extern void wilc_wlan_global_reset(void);
@@ -1056,7 +1056,7 @@ static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	u8 trials = 0;
 
-	while ((core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
+	while ((wilc1000_core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
 		PRINT_D(INIT_DBG, "11b core not ready yet: %u\n", trials);
 		wilc_wlan_cleanup();
 		wilc_wlan_global_reset();
@@ -1070,10 +1070,10 @@ static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 
 		sdio_register_driver(&wilc_bus);
 
-		while (!probe)
+		while (!wilc1000_probe)
 			msleep(100);
-		probe = 0;
-		g_linux_wlan->wilc_sdio_func = local_sdio_func;
+		wilc1000_probe = 0;
+		wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
 		linux_to_wlan(nwi, nic);
 		wilc_wlan_init(nwi);
 	}
@@ -1103,26 +1103,26 @@ static int repeat_power_cycle(perInterface_wlan_t *nic)
 	sdio_register_driver(&wilc_bus);
 
 	/* msleep(1000); */
-	while (!probe)
+	while (!wilc1000_probe)
 		msleep(100);
-	probe = 0;
-	g_linux_wlan->wilc_sdio_func = local_sdio_func;
-	linux_to_wlan(&nwi, g_linux_wlan);
+	wilc1000_probe = 0;
+	wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
+	linux_to_wlan(&nwi, wilc1000_dev);
 	ret = wilc_wlan_init(&nwi);
 
-	g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
+	wilc1000_dev->mac_status = WILC_MAC_STATUS_INIT;
 	#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-	enable_sdio_interrupt();
+	wilc1000_sdio_enable_interrupt();
 	#endif
 
-	if (linux_wlan_get_firmware(nic)) {
+	if (wilc1000_wlan_get_firmware(nic)) {
 		PRINT_ER("Can't get firmware\n");
 		ret = -1;
 		goto __fail__;
 	}
 
 	/*Download firmware*/
-	ret = linux_wlan_firmware_download(g_linux_wlan);
+	ret = linux_wlan_firmware_download(wilc1000_dev);
 	if (ret < 0) {
 		PRINT_ER("Failed to download firmware\n");
 		goto __fail__;
@@ -1142,14 +1142,14 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
 
-	if (!g_linux_wlan->wilc1000_initialized) {
-		g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
-		g_linux_wlan->close = 0;
-		g_linux_wlan->wilc1000_initialized = 0;
+	if (!wilc1000_dev->wilc1000_initialized) {
+		wilc1000_dev->mac_status = WILC_MAC_STATUS_INIT;
+		wilc1000_dev->close = 0;
+		wilc1000_dev->wilc1000_initialized = 0;
 
-		wlan_init_locks(g_linux_wlan);
+		wlan_init_locks(wilc1000_dev);
 
-		linux_to_wlan(&nwi, g_linux_wlan);
+		linux_to_wlan(&nwi, wilc1000_dev);
 
 		ret = wilc_wlan_init(&nwi);
 		if (ret < 0) {
@@ -1166,7 +1166,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 #if (defined WILC_SDIO) && (defined COMPLEMENT_BOOT)
-		if (wilc1000_prepare_11b_core(&nwi, g_linux_wlan)) {
+		if (wilc1000_prepare_11b_core(&nwi, wilc1000_dev)) {
 			PRINT_ER("11b Core is not ready\n");
 			ret = -EIO;
 			goto _fail_threads_;
@@ -1174,7 +1174,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 #endif
 
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		if (init_irq(g_linux_wlan)) {
+		if (init_irq(wilc1000_dev)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_threads_;
@@ -1182,21 +1182,21 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 #endif
 
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		if (enable_sdio_interrupt()) {
+		if (wilc1000_sdio_enable_interrupt()) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
 		}
 #endif
 
-		if (linux_wlan_get_firmware(nic)) {
+		if (wilc1000_wlan_get_firmware(nic)) {
 			PRINT_ER("Can't get firmware\n");
 			ret = -EIO;
 			goto _fail_irq_enable_;
 		}
 
 		/*Download firmware*/
-		ret = linux_wlan_firmware_download(g_linux_wlan);
+		ret = linux_wlan_firmware_download(wilc1000_dev);
 		if (ret < 0) {
 			PRINT_ER("Failed to download firmware\n");
 			ret = -EIO;
@@ -1224,7 +1224,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			PRINT_D(INIT_DBG, "***** Firmware Ver = %s  *******\n", Firmware_ver);
 		}
 		/* Initialize firmware with default configuration */
-		ret = linux_wlan_init_test_config(dev, g_linux_wlan);
+		ret = linux_wlan_init_test_config(dev, wilc1000_dev);
 
 		if (ret < 0) {
 			PRINT_ER("Failed to configure firmware\n");
@@ -1232,7 +1232,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_fw_start_;
 		}
 
-		g_linux_wlan->wilc1000_initialized = 1;
+		wilc1000_dev->wilc1000_initialized = 1;
 		return 0; /*success*/
 
 _fail_fw_start_:
@@ -1240,19 +1240,19 @@ _fail_fw_start_:
 
 _fail_irq_enable_:
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		disable_sdio_interrupt();
+		wilc1000_sdio_disable_interrupt();
 _fail_irq_init_:
 #endif
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		deinit_irq(g_linux_wlan);
+		deinit_irq(wilc1000_dev);
 
 #endif
 _fail_threads_:
-		wlan_deinitialize_threads(g_linux_wlan);
+		wlan_deinitialize_threads(wilc1000_dev);
 _fail_wilc_wlan_:
 		wilc_wlan_cleanup();
 _fail_locks_:
-		wlan_deinit_locks(g_linux_wlan);
+		wlan_deinit_locks(wilc1000_dev);
 		PRINT_ER("WLAN Iinitialization FAILED\n");
 	} else {
 		PRINT_D(INIT_DBG, "wilc1000 already initialized\n");
@@ -1275,7 +1275,7 @@ static int mac_init_fn(struct net_device *ndev)
 }
 
 /* This fn is called, when this device is setup using ifconfig */
-int mac_open(struct net_device *ndev)
+int wilc1000_mac_open(struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
 
@@ -1287,7 +1287,7 @@ int mac_open(struct net_device *ndev)
 	struct wilc_priv *priv;
 
 #ifdef WILC_SPI
-	if (!g_linux_wlan || !g_linux_wlan->wilc_spidev) {
+	if (!wilc1000_dev || !wilc1000_dev->wilc_spidev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
@@ -1312,22 +1312,22 @@ int mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	Set_machw_change_vir_if(false);
+	wilc1000_set_machw_change_vir_if(false);
 
-	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
+	wilc1000_get_mac_address(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	/* loop through the NUM of supported devices and set the MAC address */
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
-			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
+	for (i = 0; i < wilc1000_dev->u8NoIfcs; i++) {
+		if (ndev == wilc1000_dev->strInterfaceInfo[i].wilc_netdev) {
+			memcpy(wilc1000_dev->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
+			wilc1000_dev->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 	}
 
 	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, g_linux_wlan->strInterfaceInfo[i].aSrcAddress, ETH_ALEN);
+	memcpy(ndev->dev_addr, wilc1000_dev->strInterfaceInfo[i].aSrcAddress, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
@@ -1340,13 +1340,13 @@ int mac_open(struct net_device *ndev)
 	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
 				 nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
-	g_linux_wlan->open_ifcs++;
+	wilc1000_dev->open_ifcs++;
 	nic->mac_opened = 1;
 	return 0;
 
 _err_:
 	wilc_deinit_host_int(ndev);
-	wilc1000_wlan_deinit(g_linux_wlan);
+	wilc1000_wlan_deinit(wilc1000_dev);
 	return ret;
 }
 
@@ -1387,27 +1387,27 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		/* get all multicast packets */
-		host_int_setup_multicast_filter(pstrWFIDrv, false, 0);
+		wilc1000_setup_multicast_filter(pstrWFIDrv, false, 0);
 		return;
 	}
 
 	/* No multicast?  Just get our own stuff */
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		host_int_setup_multicast_filter(pstrWFIDrv, true, 0);
+		wilc1000_setup_multicast_filter(pstrWFIDrv, true, 0);
 		return;
 	}
 
 	/* Store all of the multicast addresses in the hardware filter */
 	netdev_for_each_mc_addr(ha, dev)
 	{
-		memcpy(gau8MulticastMacAddrList[i], ha->addr, ETH_ALEN);
+		memcpy(wilc1000_multicast_mac_addr_list[i], ha->addr, ETH_ALEN);
 		PRINT_D(INIT_DBG, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i,
-			gau8MulticastMacAddrList[i][0], gau8MulticastMacAddrList[i][1], gau8MulticastMacAddrList[i][2], gau8MulticastMacAddrList[i][3], gau8MulticastMacAddrList[i][4], gau8MulticastMacAddrList[i][5]);
+			wilc1000_multicast_mac_addr_list[i][0], wilc1000_multicast_mac_addr_list[i][1], wilc1000_multicast_mac_addr_list[i][2], wilc1000_multicast_mac_addr_list[i][3], wilc1000_multicast_mac_addr_list[i][4], wilc1000_multicast_mac_addr_list[i][5]);
 		i++;
 	}
 
-	host_int_setup_multicast_filter(pstrWFIDrv, true, (dev->mc.count));
+	wilc1000_setup_multicast_filter(pstrWFIDrv, true, (dev->mc.count));
 
 	return;
 
@@ -1427,7 +1427,7 @@ static void linux_wlan_tx_complete(void *priv, int status)
 	kfree(pv_data);
 }
 
-int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
+int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
 	struct tx_complete_data *tx_data = NULL;
@@ -1479,20 +1479,20 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = g_linux_wlan->strInterfaceInfo[nic->u8IfIdx].aBSSID;
+	tx_data->pBssid = wilc1000_dev->strInterfaceInfo[nic->u8IfIdx].aBSSID;
 	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
 					       tx_data->size,
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
-		netif_stop_queue(g_linux_wlan->strInterfaceInfo[1].wilc_netdev);
+		netif_stop_queue(wilc1000_dev->strInterfaceInfo[0].wilc_netdev);
+		netif_stop_queue(wilc1000_dev->strInterfaceInfo[1].wilc_netdev);
 	}
 
 	return 0;
 }
 
-int mac_close(struct net_device *ndev)
+int wilc1000_mac_close(struct net_device *ndev)
 {
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
@@ -1516,8 +1516,8 @@ int mac_close(struct net_device *ndev)
 
 	PRINT_D(GENERIC_DBG, "Mac close\n");
 
-	if (g_linux_wlan == NULL) {
-		PRINT_ER("g_linux_wlan = NULL\n");
+	if (wilc1000_dev == NULL) {
+		PRINT_ER("wilc1000_dev = NULL\n");
 		return 0;
 	}
 
@@ -1526,8 +1526,8 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if ((g_linux_wlan->open_ifcs) > 0) {
-		g_linux_wlan->open_ifcs--;
+	if ((wilc1000_dev->open_ifcs) > 0) {
+		wilc1000_dev->open_ifcs--;
 	} else {
 		PRINT_ER("ERROR: MAC close called while number of opened interfaces is zero\n");
 		return 0;
@@ -1540,10 +1540,10 @@ int mac_close(struct net_device *ndev)
 		wilc_deinit_host_int(nic->wilc_netdev);
 	}
 
-	if (g_linux_wlan->open_ifcs == 0) {
+	if (wilc1000_dev->open_ifcs == 0) {
 		PRINT_D(GENERIC_DBG, "Deinitializing wilc1000\n");
-		g_linux_wlan->close = 1;
-		wilc1000_wlan_deinit(g_linux_wlan);
+		wilc1000_dev->close = 1;
+		wilc1000_wlan_deinit(wilc1000_dev);
 		WILC_WFI_deinit_mon_interface();
 	}
 
@@ -1566,7 +1566,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
 
-	if (!g_linux_wlan->wilc1000_initialized)
+	if (!wilc1000_dev->wilc1000_initialized)
 		return 0;
 
 	switch (cmd) {
@@ -1586,7 +1586,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 				priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
-				s32Error = host_int_get_rssi(priv->hWILCWFIDrv, &(rssi));
+				s32Error = wilc1000_get_rssi(priv->hWILCWFIDrv, &(rssi));
 				if (s32Error)
 					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
@@ -1650,8 +1650,8 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 			return;
 		}
 
-		if (g_linux_wlan == NULL || wilc_netdev == NULL)
-			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
+		if (wilc1000_dev == NULL || wilc_netdev == NULL)
+			PRINT_ER("wilc_netdev in wilc1000_dev is NULL");
 		skb->dev = wilc_netdev;
 
 		if (skb->dev == NULL)
@@ -1689,18 +1689,18 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		nic = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+	for (i = 0; i < wilc1000_dev->u8NoIfcs; i++) {
+		nic = netdev_priv(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(g_linux_wlan->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
+	nic = netdev_priv(wilc1000_dev->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(g_linux_wlan->strInterfaceInfo[1].wilc_netdev, buff, size);
+		WILC_WFI_p2p_rx(wilc1000_dev->strInterfaceInfo[1].wilc_netdev, buff, size);
 }
 
 int wilc_netdev_init(void)
@@ -1713,8 +1713,8 @@ int wilc_netdev_init(void)
 	sema_init(&close_exit_sync, 0);
 
 	/*create the common structure*/
-	g_linux_wlan = kzalloc(sizeof(*g_linux_wlan), GFP_KERNEL);
-	if (!g_linux_wlan)
+	wilc1000_dev = kzalloc(sizeof(*wilc1000_dev), GFP_KERNEL);
+	if (!wilc1000_dev)
 		return -ENOMEM;
 
 	register_inetaddr_notifier(&g_dev_notifier);
@@ -1742,10 +1742,10 @@ int wilc_netdev_init(void)
 		} else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = g_linux_wlan->u8NoIfcs;
+		nic->u8IfIdx = wilc1000_dev->u8NoIfcs;
 		nic->wilc_netdev = ndev;
-		g_linux_wlan->strInterfaceInfo[g_linux_wlan->u8NoIfcs].wilc_netdev = ndev;
-		g_linux_wlan->u8NoIfcs++;
+		wilc1000_dev->strInterfaceInfo[wilc1000_dev->u8NoIfcs].wilc_netdev = ndev;
+		wilc1000_dev->u8NoIfcs++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
@@ -1755,7 +1755,7 @@ int wilc_netdev_init(void)
 
 			#ifdef WILC_SDIO
 			/* set netdev, tony */
-			SET_NETDEV_DEV(ndev, &local_sdio_func->dev);
+			SET_NETDEV_DEV(ndev, &wilc1000_sdio_func->dev);
 			#endif
 
 			if (wdev == NULL) {
@@ -1785,13 +1785,13 @@ int wilc_netdev_init(void)
 	}
 
 	#ifndef WILC_SDIO
-	if (!linux_spi_init(&g_linux_wlan->wilc_spidev)) {
+	if (!wilc1000_spi_init(&wilc1000_dev->wilc_spidev)) {
 		PRINT_ER("Can't initialize SPI\n");
 		return -1; /* ERROR */
 	}
-	g_linux_wlan->wilc_spidev = wilc_spi_dev;
+	wilc1000_dev->wilc_spidev = wilc_spi_dev;
 	#else
-	g_linux_wlan->wilc_sdio_func = local_sdio_func;
+	wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
 	#endif
 
 	return 0;
@@ -1839,22 +1839,22 @@ static void __exit exit_wilc_driver(void)
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+	if ((wilc1000_dev != NULL) && (((wilc1000_dev->strInterfaceInfo[0].wilc_netdev) != NULL)
+				       || ((wilc1000_dev->strInterfaceInfo[1].wilc_netdev) != NULL))) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			nic[i] = netdev_priv(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 	}
 
-	if ((g_linux_wlan != NULL) && g_linux_wlan->wilc_firmware != NULL) {
-		release_firmware(g_linux_wlan->wilc_firmware);
-		g_linux_wlan->wilc_firmware = NULL;
+	if ((wilc1000_dev != NULL) && wilc1000_dev->wilc_firmware != NULL) {
+		release_firmware(wilc1000_dev->wilc_firmware);
+		wilc1000_dev->wilc_firmware = NULL;
 	}
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->strInterfaceInfo[1].wilc_netdev) != NULL))) {
-		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
+	if ((wilc1000_dev != NULL) && (((wilc1000_dev->strInterfaceInfo[0].wilc_netdev) != NULL)
+				       || ((wilc1000_dev->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+		PRINT_D(INIT_DBG, "Waiting for wilc1000_mac_close ....\n");
 
 		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
 			PRINT_D(INIT_DBG, "Closed TimedOUT\n");
@@ -1863,18 +1863,18 @@ static void __exit exit_wilc_driver(void)
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 			/* close all opened interfaces */
-			if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev != NULL) {
+			if (wilc1000_dev->strInterfaceInfo[i].wilc_netdev != NULL) {
 				if (nic[i]->mac_opened)
-					mac_close(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+					wilc1000_mac_close(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 			}
 		}
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			unregister_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
+			unregister_netdev(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			wilc_free_wiphy(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			free_netdev(wilc1000_dev->strInterfaceInfo[i].wilc_netdev);
 		}
 	}
 
@@ -1886,8 +1886,8 @@ static void __exit exit_wilc_driver(void)
 	sdio_unregister_driver(&wilc_bus);
 #endif
 
-	kfree(g_linux_wlan);
-	g_linux_wlan = NULL;
+	kfree(wilc1000_dev);
+	wilc1000_dev = NULL;
 	printk("Module_exit Done.\n");
 
 #if defined(WILC_DEBUGFS)
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 2b76e41ebd4d..7bd626196e10 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -41,8 +41,8 @@ enum debug_region {
 int wilc_debugfs_init(void);
 void wilc_debugfs_remove(void);
 
-extern atomic_t REGION;
-extern atomic_t DEBUG_LEVEL;
+extern atomic_t WILC1000_REGION;
+extern atomic_t WILC1000_DEBUG_LEVEL;
 
 #define DEBUG           BIT(0)
 #define INFO            BIT(1)
@@ -51,8 +51,8 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_D(region, ...)						\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & DEBUG) &&		\
-		   ((atomic_read(&REGION)) & (region))) {		\
+		if ((atomic_read(&WILC1000_DEBUG_LEVEL) & DEBUG) &&	\
+		   ((atomic_read(&WILC1000_REGION)) & (region))) {	\
 			printk("DBG [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -60,8 +60,8 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_INFO(region, ...)						\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & INFO) &&		\
-		   ((atomic_read(&REGION)) & (region))) {		\
+		if ((atomic_read(&WILC1000_DEBUG_LEVEL) & INFO) &&	\
+		   ((atomic_read(&WILC1000_REGION)) & (region))) {	\
 			printk("INFO [%s]", __func__);			\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -69,8 +69,8 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_WRN(region, ...)						\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & WRN) &&		\
-		   ((atomic_read(&REGION)) & (region))) {		\
+		if ((atomic_read(&WILC1000_DEBUG_LEVEL) & WRN) &&	\
+		   ((atomic_read(&WILC1000_REGION)) & (region))) {	\
 			printk("WRN [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -78,7 +78,7 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_ER(...)							\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & ERR)) {		\
+		if ((atomic_read(&WILC1000_DEBUG_LEVEL) & ERR)) {	\
 			printk("ERR [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 96558accf877..470f4bf372f1 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -22,7 +22,7 @@
 #endif
 
 
-struct sdio_func *local_sdio_func;
+struct sdio_func *wilc1000_sdio_func;
 extern int wilc_netdev_init(void);
 extern void wilc_handle_isr(void);
 
@@ -47,9 +47,9 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 #endif
 
 
-int linux_sdio_cmd52(sdio_cmd52_t *cmd)
+int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = wilc1000_dev->wilc_sdio_func;
 	int ret;
 	u8 data;
 
@@ -79,9 +79,9 @@ int linux_sdio_cmd52(sdio_cmd52_t *cmd)
 }
 
 
-int linux_sdio_cmd53(sdio_cmd53_t *cmd)
+int wilc1000_sdio_cmd53(sdio_cmd53_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = wilc1000_dev->wilc_sdio_func;
 	int size, ret;
 
 	sdio_claim_host(func);
@@ -110,21 +110,21 @@ int linux_sdio_cmd53(sdio_cmd53_t *cmd)
 	return 1;
 }
 
-volatile int probe; /* COMPLEMENT_BOOT */
+volatile int wilc1000_probe; /* COMPLEMENT_BOOT */
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
 	PRINT_D(INIT_DBG, "probe function\n");
 
 #ifdef COMPLEMENT_BOOT
-	if (local_sdio_func != NULL) {
-		local_sdio_func = func;
-		probe = 1;
-		PRINT_D(INIT_DBG, "local_sdio_func isn't NULL\n");
+	if (wilc1000_sdio_func != NULL) {
+		wilc1000_sdio_func = func;
+		wilc1000_probe = 1;
+		PRINT_D(INIT_DBG, "wilc1000_sdio_func isn't NULL\n");
 		return 0;
 	}
 #endif
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	local_sdio_func = func;
+	wilc1000_sdio_func = func;
 	if (wilc_netdev_init()) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		return -1;
@@ -149,14 +149,14 @@ struct sdio_driver wilc_bus = {
 	.remove		= linux_sdio_remove,
 };
 
-int enable_sdio_interrupt(void)
+int wilc1000_sdio_enable_interrupt(void)
 {
 	int ret = 0;
 #ifndef WILC_SDIO_IRQ_GPIO
 
-	sdio_claim_host(local_sdio_func);
-	ret = sdio_claim_irq(local_sdio_func, wilc_sdio_interrupt);
-	sdio_release_host(local_sdio_func);
+	sdio_claim_host(wilc1000_sdio_func);
+	ret = sdio_claim_irq(wilc1000_sdio_func, wilc_sdio_interrupt);
+	sdio_release_host(wilc1000_sdio_func);
 
 	if (ret < 0) {
 		PRINT_ER("can't claim sdio_irq, err(%d)\n", ret);
@@ -166,22 +166,22 @@ int enable_sdio_interrupt(void)
 	return ret;
 }
 
-void disable_sdio_interrupt(void)
+void wilc1000_sdio_disable_interrupt(void)
 {
 
 #ifndef WILC_SDIO_IRQ_GPIO
 	int ret;
 
-	PRINT_D(INIT_DBG, "disable_sdio_interrupt IN\n");
+	PRINT_D(INIT_DBG, "wilc1000_sdio_disable_interrupt IN\n");
 
-	sdio_claim_host(local_sdio_func);
-	ret = sdio_release_irq(local_sdio_func);
+	sdio_claim_host(wilc1000_sdio_func);
+	ret = sdio_release_irq(wilc1000_sdio_func);
 	if (ret < 0) {
 		PRINT_ER("can't release sdio_irq, err(%d)\n", ret);
 	}
-	sdio_release_host(local_sdio_func);
+	sdio_release_host(wilc1000_sdio_func);
 
-	PRINT_D(INIT_DBG, "disable_sdio_interrupt OUT\n");
+	PRINT_D(INIT_DBG, "wilc1000_sdio_disable_interrupt OUT\n");
 #endif
 }
 
@@ -189,13 +189,13 @@ static int linux_sdio_set_speed(int speed)
 {
 	struct mmc_ios ios;
 
-	sdio_claim_host(local_sdio_func);
+	sdio_claim_host(wilc1000_sdio_func);
 
-	memcpy((void *)&ios, (void *)&local_sdio_func->card->host->ios, sizeof(struct mmc_ios));
-	local_sdio_func->card->host->ios.clock = speed;
+	memcpy((void *)&ios, (void *)&wilc1000_sdio_func->card->host->ios, sizeof(struct mmc_ios));
+	wilc1000_sdio_func->card->host->ios.clock = speed;
 	ios.clock = speed;
-	local_sdio_func->card->host->ops->set_ios(local_sdio_func->card->host, &ios);
-	sdio_release_host(local_sdio_func);
+	wilc1000_sdio_func->card->host->ops->set_ios(wilc1000_sdio_func->card->host, &ios);
+	sdio_release_host(wilc1000_sdio_func);
 	PRINT_INFO(INIT_DBG, "@@@@@@@@@@@@ change SDIO speed to %d @@@@@@@@@\n", speed);
 
 	return 1;
@@ -203,10 +203,10 @@ static int linux_sdio_set_speed(int speed)
 
 static int linux_sdio_get_speed(void)
 {
-	return local_sdio_func->card->host->ios.clock;
+	return wilc1000_sdio_func->card->host->ios.clock;
 }
 
-int linux_sdio_init(void *pv)
+int wilc1000_sdio_init(void *pv)
 {
 
 	/**
@@ -218,7 +218,7 @@ int linux_sdio_init(void *pv)
 	return 1;
 }
 
-void linux_sdio_deinit(void *pv)
+void wilc1000_sdio_deinit(void *pv)
 {
 
 	/**
@@ -229,12 +229,12 @@ void linux_sdio_deinit(void *pv)
 	sdio_unregister_driver(&wilc_bus);
 }
 
-int linux_sdio_set_max_speed(void)
+int wilc1000_sdio_set_max_speed(void)
 {
 	return linux_sdio_set_speed(MAX_SPEED);
 }
 
-int linux_sdio_set_default_speed(void)
+int wilc1000_sdio_set_default_speed(void)
 {
 	return linux_sdio_set_speed(sdio_default_speed);
 }
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 4b515f5108e7..ff0a37b880c2 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,14 +1,14 @@
-extern struct sdio_func *local_sdio_func;
+extern struct sdio_func *wilc1000_sdio_func;
 extern struct sdio_driver wilc_bus;
 
 #include <linux/mmc/sdio_func.h>
 
-int linux_sdio_init(void *);
-void linux_sdio_deinit(void *);
-int linux_sdio_cmd52(sdio_cmd52_t *cmd);
-int linux_sdio_cmd53(sdio_cmd53_t *cmd);
-int enable_sdio_interrupt(void);
-void disable_sdio_interrupt(void);
-int linux_sdio_set_max_speed(void);
-int linux_sdio_set_default_speed(void);
+int wilc1000_sdio_init(void *);
+void wilc1000_sdio_deinit(void *);
+int wilc1000_sdio_cmd52(sdio_cmd52_t *cmd);
+int wilc1000_sdio_cmd53(sdio_cmd53_t *cmd);
+int wilc1000_sdio_enable_interrupt(void);
+void wilc1000_sdio_disable_interrupt(void);
+int wilc1000_sdio_set_max_speed(void);
+int wilc1000_sdio_set_default_speed(void);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 039d06192d6b..8d8310681658 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -42,7 +42,7 @@
 static u32 SPEED = MIN_SPEED;
 
 struct spi_device *wilc_spi_dev;
-void linux_spi_deinit(void *vp);
+void wilc1000_spi_deinit(void *vp);
 
 static int __init wilc_bus_probe(struct spi_device *spi)
 {
@@ -81,7 +81,7 @@ struct spi_driver wilc_bus __refdata = {
 };
 
 
-void linux_spi_deinit(void *vp)
+void wilc1000_spi_deinit(void *vp)
 {
 
 	spi_unregister_driver(&wilc_bus);
@@ -93,7 +93,7 @@ void linux_spi_deinit(void *vp)
 
 
 
-int linux_spi_init(void *vp)
+int wilc1000_spi_init(void *vp)
 {
 	int ret = 1;
 	static int called;
@@ -116,7 +116,7 @@ int linux_spi_init(void *vp)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int linux_spi_write(u8 *b, u32 len)
+int wilc1000_spi_write(u8 *b, u32 len)
 {
 	int ret;
 
@@ -193,7 +193,7 @@ int linux_spi_write(u8 *b, u32 len)
 }
 
 #else
-int linux_spi_write(u8 *b, u32 len)
+int wilc1000_spi_write(u8 *b, u32 len)
 {
 
 	int ret;
@@ -244,7 +244,7 @@ int linux_spi_write(u8 *b, u32 len)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int linux_spi_read(u8 *rb, u32 rlen)
+int wilc1000_spi_read(u8 *rb, u32 rlen)
 {
 	int ret;
 
@@ -318,7 +318,7 @@ int linux_spi_read(u8 *rb, u32 rlen)
 }
 
 #else
-int linux_spi_read(u8 *rb, u32 rlen)
+int wilc1000_spi_read(u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -363,7 +363,7 @@ int linux_spi_read(u8 *rb, u32 rlen)
 
 #endif
 
-int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
+int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -400,7 +400,7 @@ int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 	return ret;
 }
 
-int linux_spi_set_max_speed(void)
+int wilc1000_spi_set_max_speed(void)
 {
 	SPEED = MAX_SPEED;
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 7356785296f9..efa95e3e8bfe 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -5,10 +5,10 @@
 extern struct spi_device *wilc_spi_dev;
 extern struct spi_driver wilc_bus;
 
-int linux_spi_init(void *vp);
-void linux_spi_deinit(void *vp);
-int linux_spi_write(u8 *b, u32 len);
-int linux_spi_read(u8 *rb, u32 rlen);
-int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
-int linux_spi_set_max_speed(void);
+int wilc1000_spi_init(void *vp);
+void wilc1000_spi_deinit(void *vp);
+int wilc1000_spi_write(u8 *b, u32 len);
+int wilc1000_spi_read(u8 *rb, u32 rlen);
+int wilc1000_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
+int wilc1000_spi_set_max_speed(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ae111862e7a9..c22f0ca10250 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -26,8 +26,8 @@ static struct dentry *wilc_dir;
 
 #define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CORECONFIG_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
-atomic_t DEBUG_LEVEL = ATOMIC_INIT(ERR);
+atomic_t WILC1000_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
+atomic_t WILC1000_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 
 /*
  * --------------------------------------------------------------------------------
@@ -43,7 +43,7 @@ static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, si
 	if (*ppos > 0)
 		return 0;
 
-	res = scnprintf(buf, sizeof(buf), "Debug Level: %x\n", atomic_read(&DEBUG_LEVEL));
+	res = scnprintf(buf, sizeof(buf), "Debug Level: %x\n", atomic_read(&WILC1000_DEBUG_LEVEL));
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
@@ -59,11 +59,11 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 		return ret;
 
 	if (flag > DBG_LEVEL_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));
+		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&WILC1000_DEBUG_LEVEL));
 		return -EINVAL;
 	}
 
-	atomic_set(&DEBUG_LEVEL, (int)flag);
+	atomic_set(&WILC1000_DEBUG_LEVEL, (int)flag);
 
 	if (flag == 0)
 		printk("Debug-level disabled\n");
@@ -82,7 +82,7 @@ static ssize_t wilc_debug_region_read(struct file *file, char __user *userbuf, s
 	if (*ppos > 0)
 		return 0;
 
-	res = scnprintf(buf, sizeof(buf), "Debug region: %x\n", atomic_read(&REGION));
+	res = scnprintf(buf, sizeof(buf), "Debug region: %x\n", atomic_read(&WILC1000_REGION));
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
@@ -102,12 +102,12 @@ static ssize_t wilc_debug_region_write(struct file *filp, const char *buf, size_
 	flag = buffer[0] - '0';
 
 	if (flag > DBG_REGION_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&REGION));
+		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&WILC1000_REGION));
 		return -EFAULT;
 	}
 
-	atomic_set(&REGION, (int)flag);
-	printk("new debug-region is %x\n", atomic_read(&REGION));
+	atomic_set(&WILC1000_REGION, (int)flag);
+	printk("new debug-region is %x\n", atomic_read(&WILC1000_REGION));
 
 	return count;
 }
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 4425b5f369e0..91b626ac8797 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -936,7 +936,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
  *
  ********************************************/
 
-wilc_hif_func_t hif_sdio = {
+wilc_hif_func_t wilc1000_hif_sdio = {
 	sdio_init,
 	sdio_deinit,
 	sdio_read_reg,
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 732c3f8c7f32..bb7ee37171ce 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1031,7 +1031,7 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
  *      Global spi HIF function table
  *
  ********************************************/
-wilc_hif_func_t hif_spi = {
+wilc_hif_func_t wilc1000_hif_spi = {
 	spi_init,
 	spi_deinit,
 	spi_read_reg,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c54c9fce41e7..672741632f85 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -21,21 +21,21 @@
 #define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-extern int linux_wlan_get_firmware(perInterface_wlan_t *p_nic);
-extern u16 Set_machw_change_vir_if(bool bValue);
+extern int wilc1000_wlan_get_firmware(perInterface_wlan_t *p_nic);
+extern u16 wilc1000_set_machw_change_vir_if(bool bValue);
 
-extern int mac_open(struct net_device *ndev);
-extern int mac_close(struct net_device *ndev);
+extern int wilc1000_mac_open(struct net_device *ndev);
+extern int wilc1000_mac_close(struct net_device *ndev);
 
 static tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 u32LastScannedNtwrksCountShadow;
-struct timer_list hDuringIpTimer;
+struct timer_list wilc1000_during_ip_timer;
 static struct timer_list hAgingTimer;
 static u8 op_ifcs;
-extern u8 u8ConnectedSSID[6];
+extern u8 wilc1000_connected_SSID[6];
 
-u8 g_wilc_initialized = 1;
-extern bool g_obtainingIP;
+u8 wilc1000_initialized = 1;
+extern bool wilc1000_optaining_ip;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
 		.band             = IEEE80211_BAND_2GHZ, \
@@ -142,7 +142,7 @@ static void clear_shadow_scan(void *pUserVoid)
 				astrLastScannedNtwrksShadow[u32LastScannedNtwrksCountShadow].pu8IEs = NULL;
 			}
 
-			host_int_freeJoinParams(astrLastScannedNtwrksShadow[i].pJoinParams);
+			wilc1000_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
 			astrLastScannedNtwrksShadow[i].pJoinParams = NULL;
 		}
 		u32LastScannedNtwrksCountShadow = 0;
@@ -235,7 +235,7 @@ static void remove_network_from_shadow(unsigned long arg)
 			kfree(astrLastScannedNtwrksShadow[i].pu8IEs);
 			astrLastScannedNtwrksShadow[i].pu8IEs = NULL;
 
-			host_int_freeJoinParams(astrLastScannedNtwrksShadow[i].pJoinParams);
+			wilc1000_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
 
 			for (j = i; (j < u32LastScannedNtwrksCountShadow - 1); j++) {
 				astrLastScannedNtwrksShadow[j] = astrLastScannedNtwrksShadow[j + 1];
@@ -256,7 +256,7 @@ static void remove_network_from_shadow(unsigned long arg)
 static void clear_duringIP(unsigned long arg)
 {
 	PRINT_D(GENERIC_DBG, "GO:IP Obtained , enable scan\n");
-	g_obtainingIP = false;
+	wilc1000_optaining_ip = false;
 }
 
 static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
@@ -334,7 +334,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserV
 	astrLastScannedNtwrksShadow[ap_index].u32TimeRcvdInScanCached = jiffies;
 	astrLastScannedNtwrksShadow[ap_index].u8Found = 1;
 	if (ap_found != -1)
-		host_int_freeJoinParams(astrLastScannedNtwrksShadow[ap_index].pJoinParams);
+		wilc1000_free_join_params(astrLastScannedNtwrksShadow[ap_index].pJoinParams);
 	astrLastScannedNtwrksShadow[ap_index].pJoinParams = pJoinParams;
 
 }
@@ -473,7 +473,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 }
 
 
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
+int wilc1000_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
 
 
 /**
@@ -490,7 +490,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-int connecting;
+int wilc1000_connecting;
 
 static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			     tstrConnectInfo *pstrConnectInfo,
@@ -503,7 +503,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 	struct host_if_drv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
-	connecting = 0;
+	wilc1000_connecting = 0;
 
 	priv = (struct wilc_priv *)pUserVoid;
 	dev = priv->dev;
@@ -522,8 +522,8 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			/* The case here is that our station was waiting for association response frame and has just received it containing status code
 			 *  = SUCCESSFUL_STATUSCODE, while mac status is MAC_DISCONNECTED (which means something wrong happened) */
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
-			linux_wlan_set_bssid(priv->dev, NullBssid);
-			eth_zero_addr(u8ConnectedSSID);
+			wilc1000_wlan_set_bssid(priv->dev, NullBssid);
+			eth_zero_addr(wilc1000_connected_SSID);
 
 			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 			if (!pstrWFIDrv->u8P2PConnect)
@@ -574,27 +574,27 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 					u16ConnectStatus, GFP_KERNEL);                         /* TODO: mostafa: u16ConnectStatus to */
 		/* be replaced by pstrConnectInfo->u16ConnectStatus */
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
-		g_obtainingIP = false;
+		wilc1000_optaining_ip = false;
 		PRINT_ER("Received MAC_DISCONNECTED from firmware with reason %d on dev [%p]\n",
 			 pstrDisconnectNotifInfo->u16reason, priv->dev);
 		u8P2Plocalrandom = 0x01;
 		u8P2Precvrandom = 0x00;
 		bWilc_ie = false;
 		eth_zero_addr(priv->au8AssociatedBss);
-		linux_wlan_set_bssid(priv->dev, NullBssid);
-		eth_zero_addr(u8ConnectedSSID);
+		wilc1000_wlan_set_bssid(priv->dev, NullBssid);
+		eth_zero_addr(wilc1000_connected_SSID);
 
 		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 		if (!pstrWFIDrv->u8P2PConnect)
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
-		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
+		if ((pstrWFIDrv->IFC_UP) && (dev == wilc1000_dev->strInterfaceInfo[1].wilc_netdev)) {
 			pstrDisconnectNotifInfo->u16reason = 3;
 		}
 		/*Incase "P2P CLIENT during connection(not connected)" send deauthentication reason by 1 to force the WPA_SUPPLICANT
 		 *      to scan again and retry the connection*/
-		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
+		else if ((!pstrWFIDrv->IFC_UP) && (dev == wilc1000_dev->strInterfaceInfo[1].wilc_netdev)) {
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
@@ -632,7 +632,7 @@ static int set_channel(struct wiphy *wiphy,
 	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
 	curr_channel = channelnum;
-	result = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
+	result = wilc1000_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
 
 	if (result != 0)
 		PRINT_ER("Error in setting channel %d\n", channelnum);
@@ -667,7 +667,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	priv->u32RcvdChCount = 0;
 
-	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
+	wilc1000_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 
 	reset_shadow_found(priv);
@@ -704,13 +704,13 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				}
 			}
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			s32Error = wilc1000_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, &strHiddenNetwork);
 		} else {
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			s32Error = wilc1000_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, NULL);
@@ -757,11 +757,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 
 
-	connecting = 1;
+	wilc1000_connecting = 1;
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (struct host_if_drv *)(priv->hWILCWFIDrv);
 
-	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
+	wilc1000_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
@@ -853,8 +853,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, sme->key_idx);
-			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc1000_set_wep_default_keyid(priv->hWILCWFIDrv, sme->key_idx);
+			wilc1000_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)   {
 			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 			pcgroup_encrypt_val = "WEP104";
@@ -870,8 +870,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, sme->key_idx);
-			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc1000_set_wep_default_keyid(priv->hWILCWFIDrv, sme->key_idx);
+			wilc1000_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)   {
 			if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP)	{
 				u8security = ENCRYPT_ENABLED | WPA2 | TKIP;
@@ -963,15 +963,15 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		u8WLANChannel = pstrNetworkInfo->u8channel;
 	}
 
-	linux_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
+	wilc1000_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
 
-	s32Error = host_int_set_join_req(priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
+	s32Error = wilc1000_set_join_req(priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
 					 sme->ssid_len, sme->ie, sme->ie_len,
 					 CfgConnectResult, (void *)priv, u8security,
 					 tenuAuth_type, pstrNetworkInfo->u8channel,
 					 pstrNetworkInfo->pJoinParams);
 	if (s32Error != 0) {
-		PRINT_ER("host_int_set_join_req(): Error(%d)\n", s32Error);
+		PRINT_ER("wilc1000_set_join_req(): Error(%d)\n", s32Error);
 		s32Error = -ENOENT;
 		goto done;
 	}
@@ -998,14 +998,14 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	struct host_if_drv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
-	connecting = 0;
+	wilc1000_connecting = 0;
 	priv = wiphy_priv(wiphy);
 
 	/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	if (!pstrWFIDrv->u8P2PConnect)
 		u8WLANChannel = INVALID_CHANNEL;
-	linux_wlan_set_bssid(priv->dev, NullBssid);
+	wilc1000_wlan_set_bssid(priv->dev, NullBssid);
 
 	PRINT_D(CFG80211_DBG, "Disconnecting with reason code(%d)\n", reason_code);
 
@@ -1014,7 +1014,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	bWilc_ie = false;
 	pstrWFIDrv->u64P2p_MgmtTimeout = 0;
 
-	s32Error = host_int_disconnect(priv->hWILCWFIDrv, reason_code);
+	s32Error = wilc1000_disconnect(priv->hWILCWFIDrv, reason_code);
 	if (s32Error != 0) {
 		PRINT_ER("Error in disconnecting: Error(%d)\n", s32Error);
 		s32Error = -EINVAL;
@@ -1081,7 +1081,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			else
 				u8mode = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
-			host_int_add_wep_key_bss_ap(priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
+			wilc1000_add_wep_key_bss_ap(priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
 			break;
 		}
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
@@ -1095,7 +1095,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				for (i = 0; i < params->key_len; i++)
 					PRINT_INFO(CFG80211_DBG, "WEP key value[%d] = %d\n", i, params->key[i]);
 			}
-			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, params->key, params->key_len, key_index);
+			wilc1000_add_wep_key_bss_sta(priv->hWILCWFIDrv, params->key, params->key_len, key_index);
 		}
 
 		break;
@@ -1158,7 +1158,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 
-				host_int_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
+				wilc1000_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
 						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, AP_MODE, u8gmode);
 
 			} else {
@@ -1203,7 +1203,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_ptk[key_index]->key_len = params->key_len;
 				priv->wilc_ptk[key_index]->seq_len = params->seq_len;
 
-				host_int_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
+				wilc1000_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
 						 pu8RxMic, pu8TxMic, AP_MODE, u8pmode, key_index);
 			}
 			break;
@@ -1220,7 +1220,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_gtk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+				if (!g_gtk_keys_saved && netdev == wilc1000_dev->strInterfaceInfo[0].wilc_netdev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1245,7 +1245,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_gtk_keys_saved = true;
 				}
 
-				host_int_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
+				wilc1000_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
 						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, STATION_MODE, u8mode);
 			} else {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
@@ -1256,7 +1256,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_ptk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+				if (!g_ptk_keys_saved && netdev == wilc1000_dev->strInterfaceInfo[0].wilc_netdev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1281,7 +1281,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_ptk_keys_saved = true;
 				}
 
-				host_int_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
+				wilc1000_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
 						 pu8RxMic, pu8TxMic, STATION_MODE, u8mode, key_index);
 				PRINT_D(CFG80211_DBG, "Adding pairwise key\n");
 				if (INFO) {
@@ -1321,7 +1321,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	priv = wiphy_priv(wiphy);
 
 	/*delete saved keys, if any*/
-	if (netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+	if (netdev == wilc1000_dev->strInterfaceInfo[0].wilc_netdev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
@@ -1366,7 +1366,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		g_key_gtk_params.seq = NULL;
 
 		/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-		Set_machw_change_vir_if(false);
+		wilc1000_set_machw_change_vir_if(false);
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
@@ -1374,10 +1374,10 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		priv->WILC_WFI_wep_key_len[key_index] = 0;
 
 		PRINT_D(CFG80211_DBG, "Removing WEP key with index = %d\n", key_index);
-		host_int_remove_wep_key(priv->hWILCWFIDrv, key_index);
+		wilc1000_remove_wep_key(priv->hWILCWFIDrv, key_index);
 	} else {
 		PRINT_D(CFG80211_DBG, "Removing all installed keys\n");
-		host_int_remove_key(priv->hWILCWFIDrv, mac_addr);
+		wilc1000_remove_key(priv->hWILCWFIDrv, mac_addr);
 	}
 
 	return 0;
@@ -1455,7 +1455,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 
 	if (key_index != priv->WILC_WFI_wep_default) {
 
-		host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, key_index);
+		wilc1000_set_wep_default_keyid(priv->hWILCWFIDrv, key_index);
 	}
 
 	return 0;
@@ -1503,7 +1503,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
 
-		host_int_get_inactive_time(priv->hWILCWFIDrv, mac, &(inactive_time));
+		wilc1000_get_inactive_time(priv->hWILCWFIDrv, mac, &(inactive_time));
 		sinfo->inactive_time = 1000 * inactive_time;
 		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
 
@@ -1512,7 +1512,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == STATION_MODE) {
 		struct rf_info strStatistics;
 
-		host_int_get_statistics(priv->hWILCWFIDrv, &strStatistics);
+		wilc1000_get_statistics(priv->hWILCWFIDrv, &strStatistics);
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
 						BIT(NL80211_STA_INFO_RX_PACKETS) |
@@ -1527,9 +1527,9 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		sinfo->txrate.legacy = strStatistics.u8LinkSpeed * 10;
 
 		if ((strStatistics.u8LinkSpeed > TCP_ACK_FILTER_LINK_SPEED_THRESH) && (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED))
-			Enable_TCP_ACK_Filter(true);
+			wilc1000_enable_tcp_ack_filter(true);
 		else if (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)
-			Enable_TCP_ACK_Filter(false);
+			wilc1000_enable_tcp_ack_filter(false);
 
 		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
 			sinfo->tx_failed, sinfo->txrate.legacy);
@@ -1616,7 +1616,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	}
 
 	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
-	s32Error = hif_set_cfg(priv->hWILCWFIDrv, &pstrCfgParamVal);
+	s32Error = wilc1000_hif_set_cfg(priv->hWILCWFIDrv, &pstrCfgParamVal);
 	if (s32Error)
 		PRINT_ER("Error in setting WIPHY PARAMS\n");
 
@@ -1671,7 +1671,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (!s32Error) {
 		PRINT_D(CFG80211_DBG, "Setting pmkid in the host interface\n");
-		s32Error = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
+		s32Error = wilc1000_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
 	}
 	return s32Error;
 }
@@ -2094,7 +2094,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 	priv->strRemainOnChanParams.u32ListenDuration = duration;
 	priv->strRemainOnChanParams.u32ListenSessionID++;
 
-	s32Error = host_int_remain_on_channel(priv->hWILCWFIDrv
+	s32Error = wilc1000_remain_on_channel(priv->hWILCWFIDrv
 					      , priv->strRemainOnChanParams.u32ListenSessionID
 					      , duration
 					      , chan->hw_value
@@ -2129,7 +2129,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 
 	PRINT_D(CFG80211_DBG, "Cancel remain on channel\n");
 
-	s32Error = host_int_ListenStateExpired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
+	s32Error = wilc1000_listen_state_expired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
 	return s32Error;
 }
 /**
@@ -2156,7 +2156,7 @@ static void WILC_WFI_add_wilcvendorspec(u8 *buff)
  *  @date	01 JUL 2012
  *  @version
  */
-extern bool bEnablePS;
+extern bool wilc1000_enable_ps;
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
 		   struct cfg80211_mgmt_tx_params *params,
@@ -2203,7 +2203,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 			PRINT_D(GENERIC_DBG, "TX: Probe Response\n");
 			PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-			host_int_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
+			wilc1000_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
 			/*Save the current channel after we tune to it*/
 			curr_channel = chan->hw_value;
 		} else if (ieee80211_is_action(mgmt->frame_control))   {
@@ -2218,7 +2218,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 				if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
 				    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF)	{
 					PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-					host_int_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
+					wilc1000_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
 					/*Save the current channel after we tune to it*/
 					curr_channel = chan->hw_value;
 				}
@@ -2383,11 +2383,11 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	}
 	/*If mac is closed, then return*/
-	if (!g_linux_wlan->wilc1000_initialized) {
+	if (!wilc1000_dev->wilc1000_initialized) {
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
 	}
-	host_int_frame_register(priv->hWILCWFIDrv, frame_type, reg);
+	wilc1000_frame_register(priv->hWILCWFIDrv, frame_type, reg);
 
 
 }
@@ -2438,7 +2438,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 
-	host_int_get_rssi(priv->hWILCWFIDrv, &(sinfo->signal));
+	wilc1000_get_rssi(priv->hWILCWFIDrv, &(sinfo->signal));
 
 	return 0;
 
@@ -2470,8 +2470,8 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		return -EIO;
 	}
 
-	if (bEnablePS)
-		host_int_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
+	if (wilc1000_enable_ps)
+		wilc1000_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
 
 
 	return 0;
@@ -2510,17 +2510,17 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	bWilc_ie = false;
 
-	g_obtainingIP = false;
-	del_timer(&hDuringIpTimer);
+	wilc1000_optaining_ip = false;
+	del_timer(&wilc1000_during_ip_timer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
-		Set_machw_change_vir_if(true);
+		wilc1000_set_machw_change_vir_if(true);
 	}
 
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
-		connecting = 0;
+		wilc1000_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_STATION\n");
 
 		/* send delba over wlan interface */
@@ -2536,30 +2536,30 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
 
-		if (g_linux_wlan->wilc1000_initialized)	{
-			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+		if (wilc1000_dev->wilc1000_initialized)	{
+			wilc1000_del_all_rx_ba_session(priv->hWILCWFIDrv, wilc1000_dev->strInterfaceInfo[0].aBSSID, TID);
 			/* ensure that the message Q is empty */
-			host_int_wait_msg_queue_idle();
+			wilc1000_wait_msg_queue_idle();
 
 			/*Eliminate host interface blocking state*/
-			up(&g_linux_wlan->cfg_event);
+			up(&wilc1000_dev->cfg_event);
 
-			wilc1000_wlan_deinit(g_linux_wlan);
+			wilc1000_wlan_deinit(wilc1000_dev);
 			wilc1000_wlan_init(dev, nic);
-			g_wilc_initialized = 1;
+			wilc1000_initialized = 1;
 			nic->iftype = interface_type;
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
-			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
+			wilc1000_set_wfi_drv_handler(wilc1000_dev->strInterfaceInfo[0].drvHandler);
+			wilc1000_set_mac_address(wilc1000_dev->strInterfaceInfo[0].drvHandler,
+						wilc1000_dev->strInterfaceInfo[0].aSrcAddress);
+			wilc1000_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				wilc1000_set_wep_default_keyid(wilc1000_dev->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				wilc1000_add_wep_key_bss_sta(wilc1000_dev->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2567,7 +2567,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*No matter the driver handler passed here, it will be overwriiten*/
 			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
-			host_int_flush_join_req(priv->hWILCWFIDrv);
+			wilc1000_flush_join_req(priv->hWILCWFIDrv);
 
 			/*Add saved PTK and GTK keys, if any*/
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
@@ -2577,43 +2577,43 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wilc1000_dev->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wilc1000_dev->strInterfaceInfo[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wilc1000_dev->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wilc1000_dev->strInterfaceInfo[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
 					(struct key_params *)(&g_key_gtk_params));
 			}
 
-			if (g_linux_wlan->wilc1000_initialized)	{
+			if (wilc1000_dev->wilc1000_initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
-					host_int_frame_register(priv->hWILCWFIDrv,
+					wilc1000_frame_register(priv->hWILCWFIDrv,
 								nic->g_struct_frame_reg[i].frame_type,
 								nic->g_struct_frame_reg[i].reg);
 				}
 			}
 
-			bEnablePS = true;
-			host_int_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
+			wilc1000_enable_ps = true;
+			wilc1000_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
 		}
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
-		bEnablePS = false;
-		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
-		connecting = 0;
+		wilc1000_enable_ps = false;
+		wilc1000_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
+		wilc1000_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+		wilc1000_del_all_rx_ba_session(priv->hWILCWFIDrv, wilc1000_dev->strInterfaceInfo[0].aBSSID, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2623,24 +2623,24 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->iftype = CLIENT_MODE;
 
 
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (wilc1000_dev->wilc1000_initialized)	{
 			/* ensure that the message Q is empty */
-			host_int_wait_msg_queue_idle();
+			wilc1000_wait_msg_queue_idle();
 
-			wilc1000_wlan_deinit(g_linux_wlan);
+			wilc1000_wlan_deinit(wilc1000_dev);
 			wilc1000_wlan_init(dev, nic);
-			g_wilc_initialized = 1;
+			wilc1000_initialized = 1;
 
-			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
-			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
+			wilc1000_set_wfi_drv_handler(wilc1000_dev->strInterfaceInfo[0].drvHandler);
+			wilc1000_set_mac_address(wilc1000_dev->strInterfaceInfo[0].drvHandler,
+						wilc1000_dev->strInterfaceInfo[0].aSrcAddress);
+			wilc1000_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				wilc1000_set_wep_default_keyid(wilc1000_dev->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				wilc1000_add_wep_key_bss_sta(wilc1000_dev->strInterfaceInfo[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2648,7 +2648,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*No matter the driver handler passed here, it will be overwriiten*/
 			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
-			host_int_flush_join_req(priv->hWILCWFIDrv);
+			wilc1000_flush_join_req(priv->hWILCWFIDrv);
 
 			/*Add saved PTK and GTK keys, if any*/
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
@@ -2658,15 +2658,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wilc1000_dev->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wilc1000_dev->strInterfaceInfo[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(wilc1000_dev->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wilc1000_dev->strInterfaceInfo[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2675,13 +2675,13 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*Refresh scan, to refresh the scan results to the wpa_supplicant. Set MachHw to false to enable further key installments*/
 			refresh_scan(priv, 1, true);
-			Set_machw_change_vir_if(false);
+			wilc1000_set_machw_change_vir_if(false);
 
-			if (g_linux_wlan->wilc1000_initialized)	{
+			if (wilc1000_dev->wilc1000_initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
-					host_int_frame_register(priv->hWILCWFIDrv,
+					wilc1000_frame_register(priv->hWILCWFIDrv,
 								nic->g_struct_frame_reg[i].frame_type,
 								nic->g_struct_frame_reg[i].reg);
 				}
@@ -2690,7 +2690,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	case NL80211_IFTYPE_AP:
-		bEnablePS = false;
+		wilc1000_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_AP %d\n", type);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2698,18 +2698,18 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
-		linux_wlan_get_firmware(nic);
+		wilc1000_wlan_get_firmware(nic);
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (wilc1000_dev->wilc1000_initialized)	{
 			nic->iftype = AP_MODE;
-			g_linux_wlan->wilc1000_initialized = 1;
-			mac_close(dev);
-			mac_open(dev);
+			wilc1000_dev->wilc1000_initialized = 1;
+			wilc1000_mac_close(dev);
+			wilc1000_mac_open(dev);
 
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
-				host_int_frame_register(priv->hWILCWFIDrv,
+				wilc1000_frame_register(priv->hWILCWFIDrv,
 							nic->g_struct_frame_reg[i].frame_type,
 							nic->g_struct_frame_reg[i].reg);
 			}
@@ -2719,15 +2719,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_P2P_GO:
 		PRINT_D(GENERIC_DBG, "start duringIP timer\n");
 
-		g_obtainingIP = true;
-		mod_timer(&hDuringIpTimer, jiffies + msecs_to_jiffies(duringIP_TIME));
-		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
+		wilc1000_optaining_ip = true;
+		mod_timer(&wilc1000_during_ip_timer, jiffies + msecs_to_jiffies(duringIP_TIME));
+		wilc1000_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
 		/*Delete block ack has to be the latest config packet*/
 		/*sent before downloading new FW. This is because it blocks on*/
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
-		bEnablePS = false;
+		wilc1000_del_all_rx_ba_session(priv->hWILCWFIDrv, wilc1000_dev->strInterfaceInfo[0].aBSSID, TID);
+		wilc1000_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2740,23 +2740,23 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->iftype = GO_MODE;
 
 		/* ensure that the message Q is empty */
-		host_int_wait_msg_queue_idle();
-		wilc1000_wlan_deinit(g_linux_wlan);
+		wilc1000_wait_msg_queue_idle();
+		wilc1000_wlan_deinit(wilc1000_dev);
 		wilc1000_wlan_init(dev, nic);
-		g_wilc_initialized = 1;
+		wilc1000_initialized = 1;
 
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-		host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-		host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-					g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
-		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
+		wilc1000_set_wfi_drv_handler(wilc1000_dev->strInterfaceInfo[0].drvHandler);
+		wilc1000_set_mac_address(wilc1000_dev->strInterfaceInfo[0].drvHandler,
+					wilc1000_dev->strInterfaceInfo[0].aSrcAddress);
+		wilc1000_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+			wilc1000_set_wep_default_keyid(wilc1000_dev->strInterfaceInfo[0].drvHandler,
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+			wilc1000_add_wep_key_bss_sta(wilc1000_dev->strInterfaceInfo[0].drvHandler,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
@@ -2764,7 +2764,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/*No matter the driver handler passed here, it will be overwriiten*/
 		/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
-		host_int_flush_join_req(priv->hWILCWFIDrv);
+		wilc1000_flush_join_req(priv->hWILCWFIDrv);
 
 		/*Add saved PTK and GTK keys, if any*/
 		if (g_ptk_keys_saved && g_gtk_keys_saved) {
@@ -2776,26 +2776,26 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+			add_key(wilc1000_dev->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc1000_dev->strInterfaceInfo[0].wilc_netdev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+			add_key(wilc1000_dev->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wilc1000_dev->strInterfaceInfo[0].wilc_netdev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
 				(struct key_params *)(&g_key_gtk_params));
 		}
 
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (wilc1000_dev->wilc1000_initialized)	{
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
-				host_int_frame_register(priv->hWILCWFIDrv,
+				wilc1000_frame_register(priv->hWILCWFIDrv,
 							nic->g_struct_frame_reg[i].frame_type,
 							nic->g_struct_frame_reg[i].reg);
 			}
@@ -2854,9 +2854,9 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	linux_wlan_set_bssid(dev, g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+	wilc1000_wlan_set_bssid(dev, wilc1000_dev->strInterfaceInfo[0].aSrcAddress);
 
-	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
+	s32Error = wilc1000_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
 					settings->dtim_period,
 					beacon->head_len, (u8 *)beacon->head,
@@ -2887,7 +2887,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
 
 
-	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
+	s32Error = wilc1000_add_beacon(priv->hWILCWFIDrv,
 					0,
 					0,
 					beacon->head_len, (u8 *)beacon->head,
@@ -2918,9 +2918,9 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	PRINT_D(HOSTAPD_DBG, "Deleting beacon\n");
 
-	linux_wlan_set_bssid(dev, NullBssid);
+	wilc1000_wlan_set_bssid(dev, NullBssid);
 
-	s32Error = host_int_del_beacon(priv->hWILCWFIDrv);
+	s32Error = wilc1000_del_beacon(priv->hWILCWFIDrv);
 
 	if (s32Error)
 		PRINT_ER("Host delete beacon fail\n");
@@ -2989,7 +2989,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
-		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
+		s32Error = wilc1000_add_station(priv->hWILCWFIDrv, &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host add station fail\n");
 	}
@@ -3026,12 +3026,12 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 		if (mac == NULL) {
 			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
-			s32Error = host_int_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
+			s32Error = wilc1000_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
 		} else {
 			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 		}
 
-		s32Error = host_int_del_station(priv->hWILCWFIDrv, mac);
+		s32Error = wilc1000_del_station(priv->hWILCWFIDrv, mac);
 
 		if (s32Error)
 			PRINT_ER("Host delete station fail\n");
@@ -3101,7 +3101,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
-		s32Error = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
+		s32Error = wilc1000_edit_station(priv->hWILCWFIDrv, &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host edit station fail\n");
 	}
@@ -3361,7 +3361,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 		   wdev->wiphy->interface_modes, wdev->iftype);
 
 	#ifdef WILC_SDIO
-	set_wiphy_dev(wdev->wiphy, &local_sdio_func->dev);
+	set_wiphy_dev(wdev->wiphy, &wilc1000_sdio_func->dev);
 	#endif
 
 	/*Register wiphy structure*/
@@ -3398,7 +3398,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv = wdev_priv(net->ieee80211_ptr);
 	if (op_ifcs == 0) {
 		setup_timer(&hAgingTimer, remove_network_from_shadow, 0);
-		setup_timer(&hDuringIpTimer, clear_duringIP, 0);
+		setup_timer(&wilc1000_during_ip_timer, clear_duringIP, 0);
 	}
 	op_ifcs++;
 	if (s32Error < 0) {
@@ -3411,7 +3411,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv->bInP2PlistenState = false;
 
 	sema_init(&(priv->hSemScanReq), 1);
-	s32Error = host_int_init(&priv->hWILCWFIDrv);
+	s32Error = wilc1000_init(&priv->hWILCWFIDrv);
 	if (s32Error)
 		PRINT_ER("Error while initializing hostinterface\n");
 
@@ -3441,13 +3441,13 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	op_ifcs--;
 
-	s32Error = host_int_deinit(priv->hWILCWFIDrv);
+	s32Error = wilc1000_deinit(priv->hWILCWFIDrv);
 
 	/* Clear the Shadow scan */
 	clear_shadow_scan(priv);
 	if (op_ifcs == 0) {
 		PRINT_D(CORECONFIG_DBG, "destroy during ip\n");
-		del_timer_sync(&hDuringIpTimer);
+		del_timer_sync(&wilc1000_during_ip_timer);
 	}
 
 	if (s32Error)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index e7ea397644de..a87982cfcd4b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -103,6 +103,6 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
-void Enable_TCP_ACK_Filter(bool value);
+void wilc1000_enable_tcp_ack_filter(bool value);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index c5061fd07312..700f6f343b52 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -206,7 +206,7 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-extern struct wilc *g_linux_wlan;
+extern struct wilc *wilc1000_dev;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(int flag);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 83fd41a4f521..140778d8aab5 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -16,11 +16,11 @@
  *      Global
  *
  ********************************************/
-extern wilc_hif_func_t hif_sdio;
-extern wilc_hif_func_t hif_spi;
+extern wilc_hif_func_t wilc1000_hif_sdio;
+extern wilc_hif_func_t wilc1000_hif_spi;
 extern void WILC_WFI_mgmt_rx(u8 *buff, u32 size);
 u32 wilc_get_chipid(u8 update);
-u16 Set_machw_change_vir_if(bool bValue);
+u16 wilc1000_set_machw_change_vir_if(bool bValue);
 
 
 
@@ -116,7 +116,7 @@ static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
 
-	mutex_lock(&g_linux_wlan->hif_cs);
+	mutex_lock(&wilc1000_dev->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 	if (genuChipPSstate != CHIP_WAKEDUP)
 	#endif
@@ -132,7 +132,7 @@ static inline void release_bus(BUS_RELEASE_T release)
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep();
 	#endif
-	mutex_unlock(&g_linux_wlan->hif_cs);
+	mutex_unlock(&wilc1000_dev->hif_cs);
 }
 /********************************************
  *
@@ -171,7 +171,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, flags);
 	if (p->txq_head) {
 		tqe = p->txq_head;
 		p->txq_head = tqe->next;
@@ -186,7 +186,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	} else {
 		tqe = NULL;
 	}
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock, flags);
 	return tqe;
 }
 
@@ -194,7 +194,7 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -210,25 +210,25 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock, flags);
 
 	/**
 	 *      wake up TX queue
 	 **/
 	PRINT_D(TX_DBG, "Wake the txq_handling\n");
 
-	up(&g_linux_wlan->txq_event);
+	up(&wilc1000_dev->txq_event);
 }
 
 static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	if (linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+	if (linux_wlan_lock_timeout(&wilc1000_dev->txq_add_to_head_cs,
 				    CFG_PKTS_TIMEOUT))
 		return -1;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -244,14 +244,14 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
-	up(&g_linux_wlan->txq_add_to_head_cs);
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock, flags);
+	up(&wilc1000_dev->txq_add_to_head_cs);
 
 
 	/**
 	 *      wake up TX queue
 	 **/
-	up(&g_linux_wlan->txq_event);
+	up(&wilc1000_dev->txq_event);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
 	return 0;
@@ -338,9 +338,9 @@ static inline int remove_TCP_related(void)
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, flags);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock, flags);
 	return 0;
 }
 
@@ -354,7 +354,7 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, flags);
 
 	eth_hdr_ptr = &buffer[0];
 	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
@@ -402,7 +402,7 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	} else {
 		ret = 0;
 	}
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock, flags);
 	return ret;
 }
 
@@ -414,7 +414,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 	u32 Dropped = 0;
 	wilc_wlan_dev_t *p = &g_wlan;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, p->txq_spinlock_flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
 		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].Bigger_Ack_num) {
 			struct txq_entry_t *tqe;
@@ -440,12 +440,12 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 		PendingAcks_arrBase = 0;
 
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock,
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock,
 			       p->txq_spinlock_flags);
 
 	while (Dropped > 0) {
 		/*consume the semaphore count of the removed packet*/
-		linux_wlan_lock_timeout(&g_linux_wlan->txq_event, 1);
+		linux_wlan_lock_timeout(&wilc1000_dev->txq_event, 1);
 		Dropped--;
 	}
 
@@ -455,7 +455,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 
 static bool EnableTCPAckFilter = false;
 
-void Enable_TCP_ACK_Filter(bool value)
+void wilc1000_enable_tcp_ack_filter(bool value)
 {
 	EnableTCPAckFilter = value;
 }
@@ -475,7 +475,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	PRINT_D(TX_DBG, "Adding config packet ...\n");
 	if (p->quit) {
 		PRINT_D(TX_DBG, "Return due to clear function\n");
-		up(&g_linux_wlan->cfg_event);
+		up(&wilc1000_dev->cfg_event);
 		return 0;
 	}
 
@@ -565,11 +565,11 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 	struct txq_entry_t *tqe;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, flags);
 
 	tqe = p->txq_head;
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock, flags);
 
 
 	return tqe;
@@ -578,10 +578,10 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 static struct txq_entry_t *wilc_wlan_txq_get_next(struct txq_entry_t *tqe)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc1000_dev->txq_spinlock, flags);
 
 	tqe = tqe->next;
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc1000_dev->txq_spinlock, flags);
 
 
 	return tqe;
@@ -594,7 +594,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	if (p->quit)
 		return 0;
 
-	mutex_lock(&g_linux_wlan->rxq_cs);
+	mutex_lock(&wilc1000_dev->rxq_cs);
 	if (p->rxq_head == NULL) {
 		PRINT_D(RX_DBG, "Add to Queue head\n");
 		rqe->next = NULL;
@@ -608,7 +608,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	}
 	p->rxq_entries += 1;
 	PRINT_D(RX_DBG, "Number of queue entries: %d\n", p->rxq_entries);
-	mutex_unlock(&g_linux_wlan->rxq_cs);
+	mutex_unlock(&wilc1000_dev->rxq_cs);
 	return p->rxq_entries;
 }
 
@@ -620,12 +620,12 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(void)
 	if (p->rxq_head) {
 		struct rxq_entry_t *rqe;
 
-		mutex_lock(&g_linux_wlan->rxq_cs);
+		mutex_lock(&wilc1000_dev->rxq_cs);
 		rqe = p->rxq_head;
 		p->rxq_head = p->rxq_head->next;
 		p->rxq_entries -= 1;
 		PRINT_D(RX_DBG, "RXQ entries decreased\n");
-		mutex_unlock(&g_linux_wlan->rxq_cs);
+		mutex_unlock(&wilc1000_dev->rxq_cs);
 		return rqe;
 	}
 	PRINT_D(RX_DBG, "Nothing to get from Q\n");
@@ -790,7 +790,7 @@ static inline void chip_wakeup(void)
 	genuChipPSstate = CHIP_WAKEDUP;
 }
 #endif
-void chip_sleep_manually(u32 u32SleepTime)
+void wilc1000_chip_sleep_manually(u32 u32SleepTime)
 {
 	if (genuChipPSstate != CHIP_WAKEDUP) {
 		/* chip is already sleeping. Do nothing */
@@ -836,7 +836,7 @@ int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 		if (p->quit)
 			break;
 
-		linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+		linux_wlan_lock_timeout(&wilc1000_dev->txq_add_to_head_cs,
 					CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack();
@@ -1100,7 +1100,7 @@ _end_:
 		if (ret != 1)
 			break;
 	} while (0);
-	up(&g_linux_wlan->txq_add_to_head_cs);
+	up(&wilc1000_dev->txq_add_to_head_cs);
 
 	p->txq_exit = 1;
 	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
@@ -1124,7 +1124,7 @@ static void wilc_wlan_handle_rxq(void)
 	do {
 		if (p->quit) {
 			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
-			up(&g_linux_wlan->cfg_event);
+			up(&wilc1000_dev->cfg_event);
 			break;
 		}
 		rqe = wilc_wlan_rxq_remove();
@@ -1196,7 +1196,7 @@ static void wilc_wlan_handle_rxq(void)
 						 **/
 						PRINT_D(RX_DBG, "p->cfg_seq_no = %d - rsp.seq_no = %d\n", p->cfg_seq_no, rsp.seq_no);
 						if (p->cfg_seq_no == rsp.seq_no)
-							up(&g_linux_wlan->cfg_event);
+							up(&wilc1000_dev->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
 						/**
 						 *      Call back to indicate status...
@@ -1766,7 +1766,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
 			ret_size = 0;
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wilc1000_dev->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
@@ -1804,7 +1804,7 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 			ret_size = 0;
 
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wilc1000_dev->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
 			ret_size = 0;
@@ -1922,7 +1922,7 @@ _fail_:
 }
 
 #ifdef COMPLEMENT_BOOT
-u8 core_11b_ready(void)
+u8 wilc1000_core_11b_ready(void)
 {
 	u32 reg_val;
 
@@ -1956,23 +1956,23 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp)
 	 *      host interface init
 	 **/
 	if ((inp->io_func.io_type & 0x1) == HIF_SDIO) {
-		if (!hif_sdio.hif_init(inp, wilc_debug)) {
+		if (!wilc1000_hif_sdio.hif_init(inp, wilc_debug)) {
 			/* EIO	5 */
 			ret = -5;
 			goto _fail_;
 		}
-		memcpy((void *)&g_wlan.hif_func, &hif_sdio, sizeof(wilc_hif_func_t));
+		memcpy((void *)&g_wlan.hif_func, &wilc1000_hif_sdio, sizeof(wilc_hif_func_t));
 	} else {
 		if ((inp->io_func.io_type & 0x1) == HIF_SPI) {
 			/**
 			 *      TODO:
 			 **/
-			if (!hif_spi.hif_init(inp, wilc_debug)) {
+			if (!wilc1000_hif_spi.hif_init(inp, wilc_debug)) {
 				/* EIO	5 */
 				ret = -5;
 				goto _fail_;
 			}
-			memcpy((void *)&g_wlan.hif_func, &hif_spi, sizeof(wilc_hif_func_t));
+			memcpy((void *)&g_wlan.hif_func, &wilc1000_hif_spi, sizeof(wilc_hif_func_t));
 		} else {
 			/* EIO	5 */
 			ret = -5;
@@ -2040,13 +2040,13 @@ _fail_:
 
 }
 
-u16 Set_machw_change_vir_if(bool bValue)
+u16 wilc1000_set_machw_change_vir_if(bool bValue)
 {
 	u16 ret;
 	u32 reg;
 
 	/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-	mutex_lock(&g_linux_wlan->hif_cs);
+	mutex_lock(&wilc1000_dev->hif_cs);
 	ret = (&g_wlan)->hif_func.hif_read_reg(WILC_CHANGING_VIR_IF, &reg);
 	if (!ret)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
@@ -2061,7 +2061,7 @@ u16 Set_machw_change_vir_if(bool bValue)
 	if (!ret)
 		PRINT_ER("Error while writing reg WILC_CHANGING_VIR_IF\n");
 
-	mutex_unlock(&g_linux_wlan->hif_cs);
+	mutex_unlock(&wilc1000_dev->hif_cs);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index a34a81cdeb5e..d3e3ad617dfb 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -532,17 +532,17 @@ int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
 		rsp->seq_no = msg_id;
 		/*call host interface info parse as well*/
 		PRINT_INFO(RX_DBG, "Info message received\n");
-		GnrlAsyncInfoReceived(frame - 4, size + 4);
+		wilc1000_egnrl_async_info_received(frame - 4, size + 4);
 		break;
 
 	case 'N':
-		NetworkInfoReceived(frame - 4, size + 4);
+		wilc1000_network_info_received(frame - 4, size + 4);
 		rsp->type = 0;
 		break;
 
 	case 'S':
 		PRINT_INFO(RX_DBG, "Scan Notification Received\n");
-		host_int_ScanCompleteReceived(frame - 4, size + 4);
+		wilc1000_scan_complete_received(frame - 4, size + 4);
 		break;
 
 	default:
-- 
2.1.0.rc2

