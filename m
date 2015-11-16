Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:54687 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbbKPOF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/19] staging/wilc1000: use proper naming for global symbols
Date: Mon, 16 Nov 2015 15:04:54 +0100
Message-Id: <1447682710-2908925-4-git-send-email-arnd@arndb.de> (sfid-20151116_150802_490621_A63AAF07)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are many global symbols in the wilc1000 driver, some of them
with names like "DEBUG_LEVEL" or "probe" that are not acceptable
for globals in the linux kernel as they may easily conflict with other
(equally broken) drivers.

This renames all the globals that do not already start with
wilc or a variation of that to start with wilc_ and to follow
the usual naming conventions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  10 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  16 +-
 drivers/staging/wilc1000/host_interface.c         | 260 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |  82 +++----
 drivers/staging/wilc1000/linux_mon.c              |   4 +-
 drivers/staging/wilc1000/linux_wlan.c             | 115 +++++-----
 drivers/staging/wilc1000/linux_wlan_common.h      |  18 +-
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  50 ++---
 drivers/staging/wilc1000/linux_wlan_sdio.h        |  16 +-
 drivers/staging/wilc1000/linux_wlan_spi.c         |  14 +-
 drivers/staging/wilc1000/linux_wlan_spi.h         |  10 +-
 drivers/staging/wilc1000/wilc_debugfs.c           |  18 +-
 drivers/staging/wilc1000/wilc_sdio.c              |  62 +++---
 drivers/staging/wilc1000/wilc_spi.c               |  48 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 260 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  42 ++--
 drivers/staging/wilc1000/wilc_wlan.h              |   2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |   6 +-
 20 files changed, 521 insertions(+), 522 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index eef06cdcc905..6a5b2273fda6 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -342,7 +342,7 @@ static u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
  *  @date			1 Mar 2012
  *  @version		1.0
  */
-s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
+s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 {
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	u8 u8MsgType = 0;
@@ -464,7 +464,7 @@ s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
  *  @date		1 Mar 2012
  *  @version		1.0
  */
-s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
+s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
 {
 	s32 s32Error = 0;
 
@@ -497,7 +497,7 @@ s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
  *  @date			2 Apr 2012
  *  @version		1.0
  */
-s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
+s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 			       tstrConnectRespInfo **ppstrConnectRespInfo)
 {
 	s32 s32Error = 0;
@@ -549,7 +549,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
  *  @date			2 Apr 2012
  *  @version		1.0
  */
-s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
+s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 {
 	s32 s32Error = 0;
 
@@ -586,7 +586,7 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
  *  @date		1 Mar 2012
  *  @version	1.0
  */
-s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
+s32 wilc_send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
 {
 	s32 counter = 0, ret = 0;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 3253f6f1393a..912d5c2879e4 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -127,16 +127,16 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv);
-s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
-s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
+s32 wilc_send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv);
+s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
+s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
 
-s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
+s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 		       tstrConnectRespInfo **ppstrConnectRespInfo);
-s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo);
+s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo);
 
-void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length);
-void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length);
-void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length);
+void wilc_network_info_received(u8 *pu8Buffer, u32 u32Length);
+void wilc_gnrl_async_info_received(u8 *pu8Buffer, u32 u32Length);
+void wilc_scan_complete_received(u8 *pu8Buffer, u32 u32Length);
 
 #endif
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 93bdb224f973..228a2fefe714 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -9,11 +9,11 @@
 #include <linux/etherdevice.h>
 #include "wilc_wfi_netdevice.h"
 
-extern u8 connecting;
+extern u8 wilc_connecting;
 
-extern struct timer_list hDuringIpTimer;
+extern struct timer_list wilc_during_ip_timer;
 
-extern u8 g_wilc_initialized;
+extern u8 wilc_initialized;
 
 #define HOST_IF_MSG_SCAN                        0
 #define HOST_IF_MSG_CONNECT                     1
@@ -233,7 +233,7 @@ struct join_bss_param {
 
 static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
-bool g_obtainingIP;
+bool wilc_optaining_ip;
 static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
@@ -243,7 +243,7 @@ static struct semaphore hif_sema_wait_response;
 static struct semaphore hif_sema_deinit;
 static struct timer_list periodic_rssi;
 
-u8 multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
@@ -271,7 +271,7 @@ static struct host_if_drv *join_req_drv;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-extern int linux_wlan_get_num_conn_ifcs(void);
+extern int wilc_wlan_get_num_conn_ifcs(void);
 
 static int add_handler_in_list(struct host_if_drv *handler)
 {
@@ -336,7 +336,7 @@ static s32 handle_set_channel(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -358,7 +358,7 @@ static s32 handle_set_wfi_drv_handler(struct host_if_drv *hif_drv,
 	wid.val = (s8 *)&hif_drv_handler->handler;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(SET_CFG, &wid, 1, hif_drv_handler->handler);
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1, hif_drv_handler->handler);
 
 	if (!hif_drv)
 		up(&hif_sema_driver);
@@ -382,7 +382,7 @@ static s32 handle_set_operation_mode(struct host_if_drv *hif_drv,
 	wid.val = (s8 *)&hif_op_mode->mode;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
@@ -417,7 +417,7 @@ static s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 id
 	wid.val = (u8 *)ip_addr;
 	wid.size = IP_ALEN;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	host_int_get_ipaddress(hif_drv, firmware_ip_addr, idx);
@@ -442,7 +442,7 @@ static s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
 	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	wid.size = IP_ALEN;
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
@@ -452,7 +452,7 @@ static s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
 	kfree(wid.val);
 
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
-		host_int_setup_ipaddress(hif_drv, set_ip[idx], idx);
+		wilc_setup_ipaddress(hif_drv, set_ip[idx], idx);
 
 	if (result != 0) {
 		PRINT_ER("Failed to get IP address\n");
@@ -485,7 +485,7 @@ static s32 handle_set_mac_address(struct host_if_drv *hif_drv,
 	wid.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
@@ -507,7 +507,7 @@ static s32 handle_get_mac_address(struct host_if_drv *hif_drv,
 	wid.val = get_mac_addr->mac_addr;
 	wid.size = ETH_ALEN;
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -802,7 +802,7 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 		wid_cnt++;
 	}
 
-	result = send_config_pkt(SET_CFG, wid_list, wid_cnt,
+	result = wilc_send_config_pkt(SET_CFG, wid_list, wid_cnt,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
@@ -815,7 +815,7 @@ ERRORHANDLER:
 
 static void Handle_wait_msg_q_empty(void)
 {
-	g_wilc_initialized = 0;
+	wilc_initialized = 0;
 	up(&hif_sema_wait_response);
 }
 
@@ -848,7 +848,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	}
 
-	if (g_obtainingIP || connecting) {
+	if (wilc_optaining_ip || wilc_connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		PRINT_ER("Don't do obss scan\n");
 		result = -EBUSY;
@@ -925,7 +925,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	else if (hif_drv->hif_state == HOST_IF_IDLE)
 		scan_while_connected = false;
 
-	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = wilc_send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
@@ -969,7 +969,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		wid.val = (s8 *)&u8abort_running_scan;
 		wid.size = sizeof(char);
 
-		result = send_config_pkt(SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		if (result) {
@@ -992,7 +992,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 	return result;
 }
 
-u8 u8ConnectedSSID[6] = {0};
+u8 wilc_connected_SSID[6] = {0};
 static s32 Handle_Connect(struct host_if_drv *hif_drv,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
@@ -1004,7 +1004,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
-	if (memcmp(pstrHostIFconnectAttr->bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
+	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_SSID, ETH_ALEN) == 0) {
 		result = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
 		return result;
@@ -1217,13 +1217,13 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
 
 	if (pstrHostIFconnectAttr->bssid) {
-		memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->bssid, ETH_ALEN);
+		memcpy(wilc_connected_SSID, pstrHostIFconnectAttr->bssid, ETH_ALEN);
 
 		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n", pstrHostIFconnectAttr->bssid);
-		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
+		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc_connected_SSID);
 	}
 
-	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = wilc_send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
@@ -1240,7 +1240,7 @@ ERRORHANDLER:
 
 		del_timer(&hif_drv->connect_timer);
 
-		PRINT_D(HOSTINF_DBG, "could not start connecting to the required network\n");
+		PRINT_D(HOSTINF_DBG, "could not start wilc_connecting to the required network\n");
 
 		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
@@ -1320,7 +1320,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 
 	u32WidsCount++;
 
-	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = wilc_send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(join_req_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
@@ -1381,7 +1381,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -1392,7 +1392,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	hif_drv->usr_conn_req.ies_len = 0;
 	kfree(hif_drv->usr_conn_req.ies);
 
-	eth_zero_addr(u8ConnectedSSID);
+	eth_zero_addr(wilc_connected_SSID);
 
 	if (join_req && join_req_drv == hif_drv) {
 		kfree(join_req);
@@ -1421,7 +1421,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
-		parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
+		wilc_parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
 		if ((!pstrNetworkInfo) ||
 		    (!hif_drv->usr_scan_req.scan_result)) {
 			PRINT_ER("driver is null\n");
@@ -1481,7 +1481,7 @@ done:
 	pstrRcvdNetworkInfo->buffer = NULL;
 
 	if (pstrNetworkInfo) {
-		DeallocateNetworkInfo(pstrNetworkInfo);
+		wilc_dealloc_network_info(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
 	}
 
@@ -1560,10 +1560,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 				if (u32RcvdAssocRespInfoLen != 0) {
 					PRINT_D(HOSTINF_DBG, "Parsing association response\n");
-					s32Err = ParseAssocRespInfo(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
+					s32Err = wilc_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
 								    &pstrConnectRespInfo);
 					if (s32Err) {
-						PRINT_ER("ParseAssocRespInfo() returned error %d\n", s32Err);
+						PRINT_ER("wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
 						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->u16ConnectStatus;
 
@@ -1578,7 +1578,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 						}
 
 						if (pstrConnectRespInfo) {
-							DeallocateAssocRespInfo(pstrConnectRespInfo);
+							wilc_dealloc_assoc_resp_info(pstrConnectRespInfo);
 							pstrConnectRespInfo = NULL;
 						}
 					}
@@ -1588,11 +1588,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
 				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
-				eth_zero_addr(u8ConnectedSSID);
+				eth_zero_addr(wilc_connected_SSID);
 
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
 				PRINT_ER("Received MAC status is MAC_DISCONNECTED\n");
-				eth_zero_addr(u8ConnectedSSID);
+				eth_zero_addr(wilc_connected_SSID);
 			}
 
 			if (hif_drv->usr_conn_req.pu8bssid) {
@@ -1623,14 +1623,14 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-				host_int_set_power_mgmt(hif_drv, 0, 0);
+				wilc_set_power_mgmt(hif_drv, 0, 0);
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
 				hif_drv->hif_state = HOST_IF_CONNECTED;
 
 				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
-				g_obtainingIP = true;
-				mod_timer(&hDuringIpTimer,
+				wilc_optaining_ip = true;
+				mod_timer(&wilc_during_ip_timer,
 					  jiffies + msecs_to_jiffies(10000));
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
@@ -1665,8 +1665,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			strDisconnectNotifInfo.ie_len = 0;
 
 			if (hif_drv->usr_conn_req.conn_result) {
-				g_obtainingIP = false;
-				host_int_set_power_mgmt(hif_drv, 0, 0);
+				wilc_optaining_ip = false;
+				wilc_set_power_mgmt(hif_drv, 0, 0);
 
 				hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 								  NULL,
@@ -1764,7 +1764,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[3].size = pstrHostIFkeyAttr->attr.wep.key_len;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
-			result = send_config_pkt(SET_CFG, strWIDList, 4,
+			result = wilc_send_config_pkt(SET_CFG, strWIDList, 4,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		}
@@ -1787,7 +1787,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
@@ -1799,7 +1799,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = s8idxarray;
 			wid.size = 1;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 		} else {
 			wid.id = (u16)WID_KEY_ID;
@@ -1809,7 +1809,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 		}
 		up(&hif_drv->sem_test_key_block);
@@ -1842,7 +1842,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, strWIDList, 2,
+			result = wilc_send_config_pkt(SET_CFG, strWIDList, 2,
 						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
@@ -1875,7 +1875,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = RX_MIC_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
@@ -1914,7 +1914,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
-			result = send_config_pkt(SET_CFG, strWIDList, 2,
+			result = wilc_send_config_pkt(SET_CFG, strWIDList, 2,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1937,7 +1937,7 @@ _WPARxGtk_end_case_:
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = PTK_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1972,7 +1972,7 @@ _WPAPtk_end_case_:
 		wid.val = (s8 *)pu8keybuf;
 		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		result = send_config_pkt(SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		kfree(pu8keybuf);
@@ -1999,12 +1999,12 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	g_obtainingIP = false;
-	host_int_set_power_mgmt(hif_drv, 0, 0);
+	wilc_optaining_ip = false;
+	wilc_set_power_mgmt(hif_drv, 0, 0);
 
-	eth_zero_addr(u8ConnectedSSID);
+	eth_zero_addr(wilc_connected_SSID);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2068,14 +2068,14 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 	up(&hif_drv->sem_test_disconn_block);
 }
 
-void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
+void wilc_resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 {
 	if (!hif_drv)
 		return;
 	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
 	    (hif_drv->hif_state == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
-		host_int_disconnect(hif_drv, 1);
+		wilc_disconnect(hif_drv, 1);
 	}
 }
 
@@ -2091,7 +2091,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2116,7 +2116,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -2140,7 +2140,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -2185,7 +2185,7 @@ static s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pst
 	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->tx_fail_cnt;
 	u32WidsCount++;
 
-	result = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
+	result = wilc_send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
@@ -2212,7 +2212,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2225,7 +2225,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	wid.val = (s8 *)&inactive_time;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2284,7 +2284,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
@@ -2313,7 +2313,7 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -2386,7 +2386,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2428,7 +2428,7 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2460,7 +2460,7 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2488,7 +2488,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -2527,7 +2527,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	}
 
-	if (g_obtainingIP || connecting) {
+	if (wilc_optaining_ip || wilc_connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
@@ -2549,7 +2549,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	wid.val[0] = u8remain_on_chan_flag;
 	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -2597,7 +2597,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	wid.size = sizeof(u16) + 2;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -2629,7 +2629,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		wid.val[0] = u8remain_on_chan_flag;
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
-		result = send_config_pkt(SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -2687,7 +2687,7 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -2721,10 +2721,10 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
 
 	if ((strHostIfSetMulti->cnt) > 0)
-		memcpy(pu8CurrByte, multicast_mac_addr_list,
+		memcpy(pu8CurrByte, wilc_multicast_mac_addr_list,
 		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -2770,7 +2770,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 8;
 	*ptr++ = 0;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
@@ -2789,7 +2789,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
 	*ptr++ = 3;
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	kfree(wid.val);
@@ -2824,7 +2824,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0;
 	*ptr++ = 32;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -2852,7 +2852,7 @@ static int hostIFthread(void *pvArg)
 			break;
 		}
 
-		if ((!g_wilc_initialized)) {
+		if ((!wilc_initialized)) {
 			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -2912,8 +2912,8 @@ static int hostIFthread(void *pvArg)
 			del_timer(&hif_drv->scan_timer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
-			if (!linux_wlan_get_num_conn_ifcs())
-				chip_sleep_manually();
+			if (!wilc_wlan_get_num_conn_ifcs())
+				wilc_chip_sleep_manually();
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
@@ -3073,7 +3073,7 @@ static void TimerCB_Connect(unsigned long arg)
 	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 }
 
-s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
+s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 {
 	struct wid wid;
 
@@ -3085,7 +3085,7 @@ s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 	return 0;
 }
 
-int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
+int wilc_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3112,7 +3112,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
+int wilc_set_wep_default_keyid(struct host_if_drv *hif_drv, u8 index)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3139,7 +3139,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 	return result;
 }
 
-int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
+int wilc_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 const u8 *key,
 				 u8 len,
 				 u8 index)
@@ -3173,12 +3173,12 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
-				const u8 *key,
-				u8 len,
-				u8 index,
-				u8 mode,
-				enum AUTHTYPE auth_type)
+int wilc_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
+			    const u8 *key,
+			    u8 len,
+			    u8 index,
+			    u8 mode,
+			    enum AUTHTYPE auth_type)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3217,7 +3217,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
+s32 wilc_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
@@ -3282,7 +3282,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	return result;
 }
 
-s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
+s32 wilc_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
@@ -3344,7 +3344,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	return result;
 }
 
-s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
+s32 wilc_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3376,7 +3376,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	return result;
 }
 
-s32 hif_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 wilc_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3397,7 +3397,7 @@ s32 hif_get_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	return result;
 }
 
-s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
+s32 wilc_set_mac_address(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3428,7 +3428,7 @@ s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 	return 0;
 }
 
-s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
+s32 wilc_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
 			  wilc_connect_result pfConnectResult, void *pvUserArg,
@@ -3495,7 +3495,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	return result;
 }
 
-s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
+s32 wilc_flush_join_req(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3520,7 +3520,7 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 	return result;
 }
 
-s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
+s32 wilc_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3562,7 +3562,7 @@ static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	wid.val = pu8AssocRespInfo;
 	wid.size = u32MaxAssocRespInfoLen;
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -3575,7 +3575,7 @@ static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
+int wilc_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 {
 	int result;
 	struct host_if_msg msg;
@@ -3599,7 +3599,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 	return 0;
 }
 
-int host_int_wait_msg_queue_idle(void)
+int wilc_wait_msg_queue_idle(void)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3617,7 +3617,7 @@ int host_int_wait_msg_queue_idle(void)
 	return result;
 }
 
-int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
+int wilc_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3636,7 +3636,7 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 	return result;
 }
 
-int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
+int wilc_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3655,7 +3655,7 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	return result;
 }
 
-s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
+s32 wilc_get_inactive_time(struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
 	s32 result = 0;
@@ -3683,7 +3683,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
+s32 wilc_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3710,7 +3710,7 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	return result;
 }
 
-s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
+s32 wilc_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3730,7 +3730,7 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 	return result;
 }
 
-s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
+s32 wilc_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		  u8 u8ScanType, u8 *pu8ChnlFreqList,
 		  u8 u8ChnlListLen, const u8 *pu8IEs,
 		  size_t IEsLen, wilc_scan_result ScanResult,
@@ -3783,7 +3783,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	return result;
 }
 
-s32 hif_set_cfg(struct host_if_drv *hif_drv,
+s32 wilc_hif_set_cfg(struct host_if_drv *hif_drv,
 		struct cfg_param_val *pstrCfgParamVal)
 {
 	s32 result = 0;
@@ -3832,7 +3832,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
 
-s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
+s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
 	struct host_if_drv *hif_drv;
@@ -3861,7 +3861,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		goto _fail_timer_2;
 	}
 
-	g_obtainingIP = false;
+	wilc_optaining_ip = false;
 
 	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", hif_drv);
 	if (clients_count == 0)	{
@@ -3940,7 +3940,7 @@ _fail_:
 	return result;
 }
 
-s32 host_int_deinit(struct host_if_drv *hif_drv)
+s32 wilc_deinit(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -3967,7 +3967,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
-	host_int_set_wfi_drv_handler(NULL);
+	wilc_set_wfi_drv_handler(NULL);
 	down(&hif_sema_driver);
 
 	if (hif_drv->usr_scan_req.scan_result) {
@@ -4012,7 +4012,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	return result;
 }
 
-void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
+void wilc_network_info_received(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4041,7 +4041,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", result);
 }
 
-void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
+void wilc_gnrl_async_info_received(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4082,7 +4082,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	up(&hif_sema_deinit);
 }
 
-void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
+void wilc_scan_complete_received(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4111,7 +4111,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	return;
 }
 
-s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
+s32 wilc_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 			       u32 u32duration, u16 chan,
 			       wilc_remain_on_chan_expired RemainOnChanExpired,
 			       wilc_remain_on_chan_ready RemainOnChanReady,
@@ -4143,7 +4143,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	return result;
 }
 
-s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
+s32 wilc_listen_state_expired(struct host_if_drv *hif_drv, u32 u32SessionID)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4167,7 +4167,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	return result;
 }
 
-s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
+s32 wilc_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4206,7 +4206,7 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 	return result;
 }
 
-s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
+s32 wilc_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 			u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
 			u32 u32TailLen, u8 *pu8Tail)
 {
@@ -4260,7 +4260,7 @@ ERRORHANDLER:
 	return result;
 }
 
-int host_int_del_beacon(struct host_if_drv *hif_drv)
+int wilc_del_beacon(struct host_if_drv *hif_drv)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4281,8 +4281,8 @@ int host_int_del_beacon(struct host_if_drv *hif_drv)
 	return result;
 }
 
-int host_int_add_station(struct host_if_drv *hif_drv,
-			 struct add_sta_param *sta_param)
+int wilc_add_station(struct host_if_drv *hif_drv,
+		     struct add_sta_param *sta_param)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4315,7 +4315,7 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
+int wilc_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4344,7 +4344,7 @@ int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 	return result;
 }
 
-s32 host_int_del_allstation(struct host_if_drv *hif_drv,
+s32 wilc_del_allstation(struct host_if_drv *hif_drv,
 			    u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 result = 0;
@@ -4395,7 +4395,7 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_edit_station(struct host_if_drv *hif_drv,
+s32 wilc_edit_station(struct host_if_drv *hif_drv,
 			  struct add_sta_param *pstrStaParams)
 {
 	s32 result = 0;
@@ -4433,7 +4433,7 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
+s32 wilc_set_power_mgmt(struct host_if_drv *hif_drv,
 			    bool bIsEnabled,
 			    u32 u32Timeout)
 {
@@ -4464,7 +4464,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
+s32 wilc_setup_multicast_filter(struct host_if_drv *hif_drv,
 				    bool bIsEnabled,
 				    u32 u32count)
 {
@@ -4650,7 +4650,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	return (void *)pNewJoinBssParam;
 }
 
-void host_int_freeJoinParams(void *pJoinParams)
+void wilc_free_join_params(void *pJoinParams)
 {
 	if ((struct bss_param *)pJoinParams)
 		kfree((struct bss_param *)pJoinParams);
@@ -4658,7 +4658,7 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
+s32 wilc_del_all_rx_ba_session(struct host_if_drv *hif_drv,
 				  char *pBSSID,
 				  char TID)
 {
@@ -4688,7 +4688,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
+s32 wilc_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 312da75fc02e..d0b85a53c29e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -303,95 +303,95 @@ struct add_sta_param {
 	u16 flags_set;
 };
 
-s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
-int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
-int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
-int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
+s32 wilc_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
+int wilc_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
+int wilc_set_wep_default_keyid(struct host_if_drv *hif_drv, u8 index);
+int wilc_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 const u8 *key, u8 len, u8 index);
-int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
+int wilc_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				const u8 *key, u8 len, u8 index, u8 mode,
 				enum AUTHTYPE auth_type);
-s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk,
+s32 wilc_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk,
 		     u8 u8PtkKeylen, const u8 *mac_addr,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
-s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
+s32 wilc_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
 			       u32 *pu32InactiveTime);
-s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk,
+s32 wilc_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk,
 			u8 u8GtkKeylen,	u8 u8KeyIdx,
 			u32 u32KeyRSClen, const u8 *KeyRSC,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode);
-s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
+s32 wilc_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
 			u8 *pu8TxGtk, u8 u8KeyIdx);
-s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv,
+s32 wilc_set_pmkid_info(struct host_if_drv *hWFIDrv,
 			    struct host_if_pmkid_attr *pu8PmkidInfoArray);
-s32 hif_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
-s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
-int host_int_wait_msg_queue_idle(void);
-s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
-s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
+s32 wilc_get_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+s32 wilc_set_mac_address(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
+int wilc_wait_msg_queue_idle(void);
+s32 wilc_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
+s32 wilc_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
 			  wilc_connect_result pfConnectResult, void *pvUserArg,
 			  u8 u8security, enum AUTHTYPE tenuAuth_type,
 			  u8 u8channel, void *pJoinParams);
-s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
-s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
-int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
-s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
-s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
+s32 wilc_flush_join_req(struct host_if_drv *hWFIDrv);
+s32 wilc_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
+int wilc_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
+s32 wilc_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
+s32 wilc_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 		  u8 u8ScanType, u8 *pu8ChnlFreqList,
 		  u8 u8ChnlListLen, const u8 *pu8IEs,
 		  size_t IEsLen, wilc_scan_result ScanResult,
 		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork);
-s32 hif_set_cfg(struct host_if_drv *hWFIDrv,
+s32 wilc_hif_set_cfg(struct host_if_drv *hWFIDrv,
 		struct cfg_param_val *pstrCfgParamVal);
-s32 host_int_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
-s32 host_int_deinit(struct host_if_drv *hWFIDrv);
-s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
+s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
+s32 wilc_deinit(struct host_if_drv *hWFIDrv);
+s32 wilc_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 			u32 u32DTIMPeriod,
 			u32 u32HeadLen,
 			u8 *pu8Head,
 			u32 u32TailLen,
 			u8 *pu8tail);
-int host_int_del_beacon(struct host_if_drv *hif_drv);
-int host_int_add_station(struct host_if_drv *hif_drv,
+int wilc_del_beacon(struct host_if_drv *hif_drv);
+int wilc_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *sta_param);
-s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
+s32 wilc_del_allstation(struct host_if_drv *hWFIDrv,
 			    u8 pu8MacAddr[][ETH_ALEN]);
-int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr);
-s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
+int wilc_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr);
+s32 wilc_edit_station(struct host_if_drv *hWFIDrv,
 			  struct add_sta_param *pstrStaParams);
-s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv,
+s32 wilc_set_power_mgmt(struct host_if_drv *hWFIDrv,
 			    bool bIsEnabled,
 			    u32 u32Timeout);
-s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv,
+s32 wilc_setup_multicast_filter(struct host_if_drv *hWFIDrv,
 				    bool bIsEnabled,
 				    u32 u32count);
-s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv,
+s32 wilc_setup_ipaddress(struct host_if_drv *hWFIDrv,
 			     u8 *pu8IPAddr,
 			     u8 idx);
-s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv,
+s32 wilc_del_all_rx_ba_session(struct host_if_drv *hWFIDrv,
 				  char *pBSSID,
 				  char TID);
-s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv,
+s32 wilc_remain_on_channel(struct host_if_drv *hWFIDrv,
 			       u32 u32SessionID,
 			       u32 u32duration,
 			       u16 chan,
 			       wilc_remain_on_chan_expired RemainOnChanExpired,
 			       wilc_remain_on_chan_ready RemainOnChanReady,
 			       void *pvUserArg);
-s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
-s32 host_int_frame_register(struct host_if_drv *hWFIDrv,
+s32 wilc_listen_state_expired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
+s32 wilc_frame_register(struct host_if_drv *hWFIDrv,
 			    u16 u16FrameType,
 			    bool bReg);
-int host_int_set_wfi_drv_handler(struct host_if_drv *address);
-int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
+int wilc_set_wfi_drv_handler(struct host_if_drv *address);
+int wilc_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
 
-void host_int_freeJoinParams(void *pJoinParams);
+void wilc_free_join_params(void *pJoinParams);
 
-s32 host_int_get_statistics(struct host_if_drv *hWFIDrv,
+s32 wilc_get_statistics(struct host_if_drv *hWFIDrv,
 			    struct rf_info *pstrStatistics);
-void resolve_disconnect_aberration(struct host_if_drv *hif_drv);
+void wilc_resolve_disconnect_aberration(struct host_if_drv *hif_drv);
 #endif
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 2d518acb4af3..f0a458764ff2 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -26,7 +26,7 @@ struct wilc_wfi_radiotap_cb_hdr {
 
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
-extern int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
+extern int  wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 
 
 static u8 srcAdd[6];
@@ -298,7 +298,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 		mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
 		dev_kfree_skb(skb);
 	} else
-		ret = mac_xmit(skb, mon_priv->real_ndev);
+		ret = wilc_mac_xmit(skb, mon_priv->real_ndev);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b95dba74a37d..d3d07fc30e23 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -37,9 +37,9 @@
  #define _linux_wlan_device_detection()		{}
  #define _linux_wlan_device_removal()		{}
 
-extern bool g_obtainingIP;
-extern u8 multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
-extern struct timer_list hDuringIpTimer;
+extern bool wilc_optaining_ip;
+extern u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+extern struct timer_list wilc_during_ip_timer;
 
 static int linux_wlan_device_power(int on_off)
 {
@@ -86,20 +86,20 @@ extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
 static void linux_wlan_tx_complete(void *priv, int status);
 static int  mac_init_fn(struct net_device *ndev);
-int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
-int  mac_open(struct net_device *ndev);
-int  mac_close(struct net_device *ndev);
+int  wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
+int  wilc_mac_open(struct net_device *ndev);
+int  wilc_mac_close(struct net_device *ndev);
 static struct net_device_stats *mac_stats(struct net_device *dev);
 static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static void wilc_set_multicast_list(struct net_device *dev);
-struct wilc *g_linux_wlan;
-bool bEnablePS = true;
+struct wilc *wilc_dev;
+bool wilc_enable_ps = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
 	.ndo_init = mac_init_fn,
-	.ndo_open = mac_open,
-	.ndo_stop = mac_close,
-	.ndo_start_xmit = mac_xmit,
+	.ndo_open = wilc_mac_open,
+	.ndo_stop = wilc_mac_close,
+	.ndo_start_xmit = wilc_mac_xmit,
 	.ndo_do_ioctl = mac_ioctl,
 	.ndo_get_stats = mac_stats,
 	.ndo_set_rx_mode  = wilc_set_multicast_list,
@@ -155,13 +155,13 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
 			hif_drv->IFC_UP = 1;
-			g_obtainingIP = false;
-			del_timer(&hDuringIpTimer);
+			wilc_optaining_ip = false;
+			del_timer(&wilc_during_ip_timer);
 			PRINT_D(GENERIC_DBG, "IP obtained , enable scan\n");
 		}
 
-		if (bEnablePS)
-			host_int_set_power_mgmt(hif_drv, 1, 0);
+		if (wilc_enable_ps)
+			wilc_set_power_mgmt(hif_drv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
@@ -169,7 +169,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n",
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
-		host_int_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
+		wilc_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
 
 		break;
 
@@ -179,13 +179,13 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Released ===============\n\n");
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
 			hif_drv->IFC_UP = 0;
-			g_obtainingIP = false;
+			wilc_optaining_ip = false;
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			host_int_set_power_mgmt(hif_drv, 0, 0);
+			wilc_set_power_mgmt(hif_drv, 0, 0);
 
-		resolve_disconnect_aberration(hif_drv);
+		wilc_resolve_disconnect_aberration(hif_drv);
 
 		PRINT_D(GENERIC_DBG, "[%s] Down IP\n", dev_iface->ifa_label);
 
@@ -194,7 +194,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 			ip_addr_buf[0], ip_addr_buf[1],
 			ip_addr_buf[2], ip_addr_buf[3]);
 
-		host_int_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
+		wilc_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
 
 		break;
 
@@ -358,7 +358,7 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	return NULL;
 }
 
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
+int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
 {
 	int i = 0;
 	int ret = -1;
@@ -378,14 +378,14 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
 	return ret;
 }
 
-int linux_wlan_get_num_conn_ifcs(void)
+int wilc_wlan_get_num_conn_ifcs(void)
 {
 	u8 i = 0;
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
 
-	for (i = 0; i < g_linux_wlan->vif_num; i++)
-		if (memcmp(g_linux_wlan->vif[i].bssid, null_bssid, 6))
+	for (i = 0; i < wilc_dev->vif_num; i++)
+		if (memcmp(wilc_dev->vif[i].bssid, null_bssid, 6))
 			ret_val++;
 
 	return ret_val;
@@ -466,7 +466,7 @@ void linux_wlan_rx_complete(void)
 	PRINT_D(RX_DBG, "RX completed\n");
 }
 
-int linux_wlan_get_firmware(struct net_device *dev)
+int wilc_wlan_get_firmware(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
@@ -799,7 +799,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
 #ifdef WILC_SDIO
 		mutex_lock(&wl->hif_cs);
-		disable_sdio_interrupt();
+		wilc_sdio_disable_interrupt();
 		mutex_unlock(&wl->hif_cs);
 #endif
 		if (&wl->txq_event)
@@ -820,7 +820,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
 
 		mutex_lock(&wl->hif_cs);
-		disable_sdio_interrupt();
+		wilc_sdio_disable_interrupt();
 		mutex_unlock(&wl->hif_cs);
   #endif
 #endif
@@ -972,14 +972,14 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		if (enable_sdio_interrupt()) {
+		if (wilc_sdio_enable_interrupt()) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
 		}
 #endif
 
-		if (linux_wlan_get_firmware(dev)) {
+		if (wilc_wlan_get_firmware(dev)) {
 			PRINT_ER("Can't get firmware\n");
 			ret = -EIO;
 			goto _fail_irq_enable_;
@@ -1027,7 +1027,7 @@ _fail_fw_start_:
 
 _fail_irq_enable_:
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-		disable_sdio_interrupt();
+		wilc_sdio_disable_interrupt();
 _fail_irq_init_:
 #endif
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
@@ -1054,7 +1054,7 @@ static int mac_init_fn(struct net_device *ndev)
 	return 0;
 }
 
-int mac_open(struct net_device *ndev)
+int wilc_mac_open(struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
 
@@ -1092,9 +1092,9 @@ int mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	set_machw_change_vir_if(ndev, false);
+	wilc_set_machw_change_vir_if(ndev, false);
 
-	hif_get_mac_address(priv->hWILCWFIDrv, mac_add);
+	wilc_get_mac_address(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	for (i = 0; i < wl->vif_num; i++) {
@@ -1159,29 +1159,29 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) ||
 	    (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
-		host_int_setup_multicast_filter(hif_drv, false, 0);
+		wilc_setup_multicast_filter(hif_drv, false, 0);
 		return;
 	}
 
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		host_int_setup_multicast_filter(hif_drv, true, 0);
+		wilc_setup_multicast_filter(hif_drv, true, 0);
 		return;
 	}
 
 	netdev_for_each_mc_addr(ha, dev) {
-		memcpy(multicast_mac_addr_list[i], ha->addr, ETH_ALEN);
+		memcpy(wilc_multicast_mac_addr_list[i], ha->addr, ETH_ALEN);
 		PRINT_D(INIT_DBG, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i,
-			multicast_mac_addr_list[i][0],
-			multicast_mac_addr_list[i][1],
-			multicast_mac_addr_list[i][2],
-			multicast_mac_addr_list[i][3],
-			multicast_mac_addr_list[i][4],
-			multicast_mac_addr_list[i][5]);
+			wilc_multicast_mac_addr_list[i][0],
+			wilc_multicast_mac_addr_list[i][1],
+			wilc_multicast_mac_addr_list[i][2],
+			wilc_multicast_mac_addr_list[i][3],
+			wilc_multicast_mac_addr_list[i][4],
+			wilc_multicast_mac_addr_list[i][5]);
 		i++;
 	}
 
-	host_int_setup_multicast_filter(hif_drv, true, (dev->mc.count));
+	wilc_setup_multicast_filter(hif_drv, true, (dev->mc.count));
 
 	return;
 }
@@ -1198,7 +1198,7 @@ static void linux_wlan_tx_complete(void *priv, int status)
 	kfree(pv_data);
 }
 
-int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
+int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
 	struct tx_complete_data *tx_data = NULL;
@@ -1259,7 +1259,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return 0;
 }
 
-int mac_close(struct net_device *ndev)
+int wilc_mac_close(struct net_device *ndev)
 {
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
@@ -1353,8 +1353,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 				priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
-				ret = host_int_get_rssi(priv->hWILCWFIDrv,
-							&rssi);
+				ret = wilc_get_rssi(priv->hWILCWFIDrv, &rssi);
 				if (ret)
 					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
@@ -1472,7 +1471,7 @@ void wl_wlan_cleanup(struct wilc *wilc)
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i].ndev)
 				if (nic[i]->mac_opened)
-					mac_close(wilc->vif[i].ndev);
+					wilc_mac_close(wilc->vif[i].ndev);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 			unregister_netdev(wilc->vif[i].ndev);
@@ -1498,11 +1497,11 @@ int wilc_netdev_init(struct wilc **wilc)
 
 	sema_init(&close_exit_sync, 0);
 
-	g_linux_wlan = kzalloc(sizeof(*g_linux_wlan), GFP_KERNEL);
-	if (!g_linux_wlan)
+	wilc_dev = kzalloc(sizeof(*wilc_dev), GFP_KERNEL);
+	if (!wilc_dev)
 		return -ENOMEM;
 
-	*wilc = g_linux_wlan;
+	*wilc = wilc_dev;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
@@ -1521,11 +1520,11 @@ int wilc_netdev_init(struct wilc **wilc)
 		else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = g_linux_wlan->vif_num;
+		nic->u8IfIdx = wilc_dev->vif_num;
 		nic->wilc_netdev = ndev;
 		nic->wilc = *wilc;
-		g_linux_wlan->vif[g_linux_wlan->vif_num].ndev = ndev;
-		g_linux_wlan->vif_num++;
+		wilc_dev->vif[wilc_dev->vif_num].ndev = ndev;
+		wilc_dev->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
@@ -1533,7 +1532,7 @@ int wilc_netdev_init(struct wilc **wilc)
 			wdev = wilc_create_wiphy(ndev);
 
 			#ifdef WILC_SDIO
-			SET_NETDEV_DEV(ndev, &local_sdio_func->dev);
+			SET_NETDEV_DEV(ndev, &wilc_sdio_func->dev);
 			#endif
 
 			if (!wdev) {
@@ -1561,13 +1560,13 @@ int wilc_netdev_init(struct wilc **wilc)
 	}
 
 	#ifndef WILC_SDIO
-	if (!linux_spi_init()) {
+	if (!wilc_spi_init()) {
 		PRINT_ER("Can't initialize SPI\n");
 		return -1;
 	}
-	g_linux_wlan->wilc_spidev = wilc_spi_dev;
+	wilc_dev->wilc_spidev = wilc_spi_dev;
 	#else
-	g_linux_wlan->wilc_sdio_func = local_sdio_func;
+	wilc_dev->wilc_sdio_func = wilc_sdio_func;
 	#endif
 
 	return 0;
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 2b76e41ebd4d..b8dfc4a5e5cb 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -41,8 +41,8 @@ enum debug_region {
 int wilc_debugfs_init(void);
 void wilc_debugfs_remove(void);
 
-extern atomic_t REGION;
-extern atomic_t DEBUG_LEVEL;
+extern atomic_t WILC_REGION;
+extern atomic_t WILC_DEBUG_LEVEL;
 
 #define DEBUG           BIT(0)
 #define INFO            BIT(1)
@@ -51,8 +51,8 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_D(region, ...)						\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & DEBUG) &&		\
-		   ((atomic_read(&REGION)) & (region))) {		\
+		if ((atomic_read(&WILC_DEBUG_LEVEL) & DEBUG) &&	\
+		   ((atomic_read(&WILC_REGION)) & (region))) {	\
 			printk("DBG [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -60,8 +60,8 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_INFO(region, ...)						\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & INFO) &&		\
-		   ((atomic_read(&REGION)) & (region))) {		\
+		if ((atomic_read(&WILC_DEBUG_LEVEL) & INFO) &&	\
+		   ((atomic_read(&WILC_REGION)) & (region))) {	\
 			printk("INFO [%s]", __func__);			\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -69,8 +69,8 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_WRN(region, ...)						\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & WRN) &&		\
-		   ((atomic_read(&REGION)) & (region))) {		\
+		if ((atomic_read(&WILC_DEBUG_LEVEL) & WRN) &&	\
+		   ((atomic_read(&WILC_REGION)) & (region))) {	\
 			printk("WRN [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -78,7 +78,7 @@ extern atomic_t DEBUG_LEVEL;
 
 #define PRINT_ER(...)							\
 	do {								\
-		if ((atomic_read(&DEBUG_LEVEL) & ERR)) {		\
+		if ((atomic_read(&WILC_DEBUG_LEVEL) & ERR)) {	\
 			printk("ERR [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index a0640ebe904e..0b01873faf79 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -26,7 +26,7 @@ struct wilc_sdio {
 	struct wilc *wilc;
 };
 
-struct sdio_func *local_sdio_func;
+struct sdio_func *wilc_sdio_func;
 
 static unsigned int sdio_default_speed;
 
@@ -53,9 +53,9 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 #endif
 
 
-int linux_sdio_cmd52(sdio_cmd52_t *cmd)
+int wilc_sdio_cmd52(sdio_cmd52_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = wilc_dev->wilc_sdio_func;
 	int ret;
 	u8 data;
 
@@ -85,9 +85,9 @@ int linux_sdio_cmd52(sdio_cmd52_t *cmd)
 }
 
 
-int linux_sdio_cmd53(sdio_cmd53_t *cmd)
+int wilc_sdio_cmd53(sdio_cmd53_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = wilc_dev->wilc_sdio_func;
 	int size, ret;
 
 	sdio_claim_host(func);
@@ -127,7 +127,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 		return -ENOMEM;
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	local_sdio_func = func;
+	wilc_sdio_func = func;
 	if (wilc_netdev_init(&wilc)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		kfree(wl_sdio);
@@ -157,14 +157,14 @@ struct sdio_driver wilc_bus = {
 	.remove		= linux_sdio_remove,
 };
 
-int enable_sdio_interrupt(void)
+int wilc_sdio_enable_interrupt(void)
 {
 	int ret = 0;
 #ifndef WILC_SDIO_IRQ_GPIO
 
-	sdio_claim_host(local_sdio_func);
-	ret = sdio_claim_irq(local_sdio_func, wilc_sdio_interrupt);
-	sdio_release_host(local_sdio_func);
+	sdio_claim_host(wilc_sdio_func);
+	ret = sdio_claim_irq(wilc_sdio_func, wilc_sdio_interrupt);
+	sdio_release_host(wilc_sdio_func);
 
 	if (ret < 0) {
 		PRINT_ER("can't claim sdio_irq, err(%d)\n", ret);
@@ -174,22 +174,22 @@ int enable_sdio_interrupt(void)
 	return ret;
 }
 
-void disable_sdio_interrupt(void)
+void wilc_sdio_disable_interrupt(void)
 {
 
 #ifndef WILC_SDIO_IRQ_GPIO
 	int ret;
 
-	PRINT_D(INIT_DBG, "disable_sdio_interrupt IN\n");
+	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt IN\n");
 
-	sdio_claim_host(local_sdio_func);
-	ret = sdio_release_irq(local_sdio_func);
+	sdio_claim_host(wilc_sdio_func);
+	ret = sdio_release_irq(wilc_sdio_func);
 	if (ret < 0) {
 		PRINT_ER("can't release sdio_irq, err(%d)\n", ret);
 	}
-	sdio_release_host(local_sdio_func);
+	sdio_release_host(wilc_sdio_func);
 
-	PRINT_D(INIT_DBG, "disable_sdio_interrupt OUT\n");
+	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt OUT\n");
 #endif
 }
 
@@ -197,13 +197,13 @@ static int linux_sdio_set_speed(int speed)
 {
 	struct mmc_ios ios;
 
-	sdio_claim_host(local_sdio_func);
+	sdio_claim_host(wilc_sdio_func);
 
-	memcpy((void *)&ios, (void *)&local_sdio_func->card->host->ios, sizeof(struct mmc_ios));
-	local_sdio_func->card->host->ios.clock = speed;
+	memcpy((void *)&ios, (void *)&wilc_sdio_func->card->host->ios, sizeof(struct mmc_ios));
+	wilc_sdio_func->card->host->ios.clock = speed;
 	ios.clock = speed;
-	local_sdio_func->card->host->ops->set_ios(local_sdio_func->card->host, &ios);
-	sdio_release_host(local_sdio_func);
+	wilc_sdio_func->card->host->ops->set_ios(wilc_sdio_func->card->host, &ios);
+	sdio_release_host(wilc_sdio_func);
 	PRINT_INFO(INIT_DBG, "@@@@@@@@@@@@ change SDIO speed to %d @@@@@@@@@\n", speed);
 
 	return 1;
@@ -211,10 +211,10 @@ static int linux_sdio_set_speed(int speed)
 
 static int linux_sdio_get_speed(void)
 {
-	return local_sdio_func->card->host->ios.clock;
+	return wilc_sdio_func->card->host->ios.clock;
 }
 
-int linux_sdio_init(void)
+int wilc_sdio_init(void)
 {
 
 	/**
@@ -226,12 +226,12 @@ int linux_sdio_init(void)
 	return 1;
 }
 
-int linux_sdio_set_max_speed(void)
+int wilc_sdio_set_max_speed(void)
 {
 	return linux_sdio_set_speed(MAX_SPEED);
 }
 
-int linux_sdio_set_default_speed(void)
+int wilc_sdio_set_default_speed(void)
 {
 	return linux_sdio_set_speed(sdio_default_speed);
 }
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 7c59b2f6543a..49cce2c43410 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,13 +1,13 @@
-extern struct sdio_func *local_sdio_func;
+extern struct sdio_func *wilc_sdio_func;
 extern struct sdio_driver wilc_bus;
 
 #include <linux/mmc/sdio_func.h>
 
-int linux_sdio_init(void);
-int linux_sdio_cmd52(sdio_cmd52_t *cmd);
-int linux_sdio_cmd53(sdio_cmd53_t *cmd);
-int enable_sdio_interrupt(void);
-void disable_sdio_interrupt(void);
-int linux_sdio_set_max_speed(void);
-int linux_sdio_set_default_speed(void);
+int wilc_sdio_init(void);
+int wilc_sdio_cmd52(sdio_cmd52_t *cmd);
+int wilc_sdio_cmd53(sdio_cmd53_t *cmd);
+int wilc_sdio_enable_interrupt(void);
+void wilc_sdio_disable_interrupt(void);
+int wilc_sdio_set_max_speed(void);
+int wilc_sdio_set_default_speed(void);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 3655077a936f..790128f6d034 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -79,7 +79,7 @@ struct spi_driver wilc_bus __refdata = {
 	.remove = __exit_p(wilc_bus_remove),
 };
 
-int linux_spi_init(void)
+int wilc_spi_init(void)
 {
 	int ret = 1;
 	static int called;
@@ -102,7 +102,7 @@ int linux_spi_init(void)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int linux_spi_write(u8 *b, u32 len)
+int wilc_spi_write(u8 *b, u32 len)
 {
 	int ret;
 
@@ -179,7 +179,7 @@ int linux_spi_write(u8 *b, u32 len)
 }
 
 #else
-int linux_spi_write(u8 *b, u32 len)
+int wilc_spi_write(u8 *b, u32 len)
 {
 
 	int ret;
@@ -230,7 +230,7 @@ int linux_spi_write(u8 *b, u32 len)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int linux_spi_read(u8 *rb, u32 rlen)
+int wilc_spi_read(u8 *rb, u32 rlen)
 {
 	int ret;
 
@@ -304,7 +304,7 @@ int linux_spi_read(u8 *rb, u32 rlen)
 }
 
 #else
-int linux_spi_read(u8 *rb, u32 rlen)
+int wilc_spi_read(u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -349,7 +349,7 @@ int linux_spi_read(u8 *rb, u32 rlen)
 
 #endif
 
-int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
+int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -386,7 +386,7 @@ int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 	return ret;
 }
 
-int linux_spi_set_max_speed(void)
+int wilc_spi_set_max_speed(void)
 {
 	SPEED = MAX_SPEED;
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 2edd97b4c5cc..aecb522ff56d 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -5,9 +5,9 @@
 extern struct spi_device *wilc_spi_dev;
 extern struct spi_driver wilc_bus;
 
-int linux_spi_init(void);
-int linux_spi_write(u8 *b, u32 len);
-int linux_spi_read(u8 *rb, u32 rlen);
-int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
-int linux_spi_set_max_speed(void);
+int wilc_spi_init(void);
+int wilc_spi_write(u8 *b, u32 len);
+int wilc_spi_read(u8 *rb, u32 rlen);
+int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
+int wilc_spi_set_max_speed(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ae111862e7a9..d70f96f475b8 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -26,8 +26,8 @@ static struct dentry *wilc_dir;
 
 #define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CORECONFIG_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
-atomic_t DEBUG_LEVEL = ATOMIC_INIT(ERR);
+atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
+atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 
 /*
  * --------------------------------------------------------------------------------
@@ -43,7 +43,7 @@ static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, si
 	if (*ppos > 0)
 		return 0;
 
-	res = scnprintf(buf, sizeof(buf), "Debug Level: %x\n", atomic_read(&DEBUG_LEVEL));
+	res = scnprintf(buf, sizeof(buf), "Debug Level: %x\n", atomic_read(&WILC_DEBUG_LEVEL));
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
@@ -59,11 +59,11 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 		return ret;
 
 	if (flag > DBG_LEVEL_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));
+		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&WILC_DEBUG_LEVEL));
 		return -EINVAL;
 	}
 
-	atomic_set(&DEBUG_LEVEL, (int)flag);
+	atomic_set(&WILC_DEBUG_LEVEL, (int)flag);
 
 	if (flag == 0)
 		printk("Debug-level disabled\n");
@@ -82,7 +82,7 @@ static ssize_t wilc_debug_region_read(struct file *file, char __user *userbuf, s
 	if (*ppos > 0)
 		return 0;
 
-	res = scnprintf(buf, sizeof(buf), "Debug region: %x\n", atomic_read(&REGION));
+	res = scnprintf(buf, sizeof(buf), "Debug region: %x\n", atomic_read(&WILC_REGION));
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
@@ -102,12 +102,12 @@ static ssize_t wilc_debug_region_write(struct file *filp, const char *buf, size_
 	flag = buffer[0] - '0';
 
 	if (flag > DBG_REGION_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&REGION));
+		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&WILC_REGION));
 		return -EFAULT;
 	}
 
-	atomic_set(&REGION, (int)flag);
-	printk("new debug-region is %x\n", atomic_read(&REGION));
+	atomic_set(&WILC_REGION, (int)flag);
+	printk("new debug-region is %x\n", atomic_read(&WILC_REGION));
 
 	return count;
 }
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index d26e4cf0f436..7fca3b23b485 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -48,21 +48,21 @@ static int sdio_set_func0_csa_address(u32 adr)
 	cmd.raw = 0;
 	cmd.address = 0x10c;
 	cmd.data = (u8)adr;
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10d;
 	cmd.data = (u8)(adr >> 8);
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10d data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10e;
 	cmd.data = (u8)(adr >> 16);
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10e data...\n");
 		goto _fail_;
 	}
@@ -81,14 +81,14 @@ static int sdio_set_func0_block_size(u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x10;
 	cmd.data = (u8)block_size;
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10 data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x11;
 	cmd.data = (u8)(block_size >> 8);
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x11 data...\n");
 		goto _fail_;
 	}
@@ -113,13 +113,13 @@ static int sdio_set_func1_block_size(u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x110;
 	cmd.data = (u8)block_size;
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x110 data...\n");
 		goto _fail_;
 	}
 	cmd.address = 0x111;
 	cmd.data = (u8)(block_size >> 8);
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x111 data...\n");
 		goto _fail_;
 	}
@@ -140,7 +140,7 @@ static int sdio_clear_int(void)
 	cmd.raw = 0;
 	cmd.address = 0x4;
 	cmd.data = 0;
-	linux_sdio_cmd52(&cmd);
+	wilc_sdio_cmd52(&cmd);
 
 	return cmd.data;
 #else
@@ -176,7 +176,7 @@ static int sdio_write_reg(u32 addr, u32 data)
 		cmd.raw = 0;
 		cmd.address = addr;
 		cmd.data = data;
-		if (!linux_sdio_cmd52(&cmd)) {
+		if (!wilc_sdio_cmd52(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -198,7 +198,7 @@ static int sdio_write_reg(u32 addr, u32 data)
 		cmd.buffer = (u8 *)&data;
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!linux_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, write reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -261,7 +261,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!linux_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block send...\n", addr);
 			goto _fail_;
 		}
@@ -282,7 +282,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!linux_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes send...\n", addr);
 			goto _fail_;
 		}
@@ -304,7 +304,7 @@ static int sdio_read_reg(u32 addr, u32 *data)
 		cmd.function = 0;
 		cmd.raw = 0;
 		cmd.address = addr;
-		if (!linux_sdio_cmd52(&cmd)) {
+		if (!wilc_sdio_cmd52(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -325,7 +325,7 @@ static int sdio_read_reg(u32 addr, u32 *data)
 
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!linux_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, read reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -392,7 +392,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!linux_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
 			goto _fail_;
 		}
@@ -413,7 +413,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!linux_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes read...\n", addr);
 			goto _fail_;
 		}
@@ -505,7 +505,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 
 	g_sdio.dPrint = func;
 
-	if (!linux_sdio_init()) {
+	if (!wilc_sdio_init()) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
 		return 0;
 	} else {
@@ -520,7 +520,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x100;
 	cmd.data = 0x80;
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, enable csa...\n");
 		goto _fail_;
 	}
@@ -542,7 +542,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x2;
 	cmd.data = 0x2;
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio] Fail cmd 52, set IOE register...\n");
 		goto _fail_;
 	}
@@ -557,7 +557,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	loop = 3;
 	do {
 		cmd.data = 0;
-		if (!linux_sdio_cmd52(&cmd)) {
+		if (!wilc_sdio_cmd52(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get IOR register...\n");
 			goto _fail_;
 		}
@@ -586,7 +586,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x4;
 	cmd.data = 0x3;
-	if (!linux_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, set IEN register...\n");
 		goto _fail_;
 	}
@@ -614,12 +614,12 @@ _fail_:
 
 static void sdio_set_max_speed(void)
 {
-	linux_sdio_set_max_speed();
+	wilc_sdio_set_max_speed();
 }
 
 static void sdio_set_default_speed(void)
 {
-	linux_sdio_set_default_speed();
+	wilc_sdio_set_default_speed();
 }
 
 static int sdio_read_size(u32 *size)
@@ -636,7 +636,7 @@ static int sdio_read_size(u32 *size)
 	cmd.raw = 0;
 	cmd.address = 0xf2;
 	cmd.data = 0;
-	linux_sdio_cmd52(&cmd);
+	wilc_sdio_cmd52(&cmd);
 	tmp = cmd.data;
 
 	/* cmd.read_write = 0; */
@@ -644,7 +644,7 @@ static int sdio_read_size(u32 *size)
 	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
-	linux_sdio_cmd52(&cmd);
+	wilc_sdio_cmd52(&cmd);
 	tmp |= (cmd.data << 8);
 
 	*size = tmp;
@@ -666,7 +666,7 @@ static int sdio_read_int(u32 *int_status)
 	cmd.function = 1;
 	cmd.address = 0x04;
 	cmd.data = 0;
-	linux_sdio_cmd52(&cmd);
+	wilc_sdio_cmd52(&cmd);
 
 	if (cmd.data & BIT(0))
 		tmp |= INT_0;
@@ -699,7 +699,7 @@ static int sdio_read_int(u32 *int_status)
 		cmd.raw = 0;
 		cmd.address = 0xf7;
 		cmd.data = 0;
-		linux_sdio_cmd52(&cmd);
+		wilc_sdio_cmd52(&cmd);
 		irq_flags = cmd.data & 0x1f;
 		tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
 	}
@@ -746,7 +746,7 @@ static int sdio_clear_int_ext(u32 val)
 			cmd.address = 0xf8;
 			cmd.data = reg;
 
-			ret = linux_sdio_cmd52(&cmd);
+			ret = wilc_sdio_cmd52(&cmd);
 			if (!ret) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 				goto _fail_;
@@ -775,7 +775,7 @@ static int sdio_clear_int_ext(u32 val)
 						cmd.address = 0xf8;
 						cmd.data = BIT(i);
 
-						ret = linux_sdio_cmd52(&cmd);
+						ret = wilc_sdio_cmd52(&cmd);
 						if (!ret) {
 							g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 							goto _fail_;
@@ -819,7 +819,7 @@ static int sdio_clear_int_ext(u32 val)
 				cmd.raw = 0;
 				cmd.address = 0xf6;
 				cmd.data = vmm_ctl;
-				ret = linux_sdio_cmd52(&cmd);
+				ret = wilc_sdio_cmd52(&cmd);
 				if (!ret) {
 					g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
 					goto _fail_;
@@ -925,7 +925,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
  *
  ********************************************/
 
-struct wilc_hif_func hif_sdio = {
+struct wilc_hif_func wilc_hif_sdio = {
 	sdio_init,
 	sdio_deinit,
 	sdio_read_reg,
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 9af35d1ef99e..dc9cdf5e4065 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -22,8 +22,8 @@ typedef struct {
 
 static wilc_spi_t g_spi;
 
-static int wilc_spi_read(u32, u8 *, u32);
-static int wilc_spi_write(u32, u8 *, u32);
+static int _wilc_spi_read(u32, u8 *, u32);
+static int _wilc_spi_write(u32, u8 *, u32);
 
 /********************************************
  *
@@ -249,7 +249,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 	}
 	rix = len;
 
-	if (!linux_spi_write_read(wb, rb, len2)) {
+	if (!wilc_spi_write_read(wb, rb, len2)) {
 		PRINT_ER("[wilc spi]: Failed cmd write, bus error...\n");
 		result = N_FAIL;
 		return result;
@@ -364,7 +364,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				/**
 				 * Read bytes
 				 **/
-				if (!linux_spi_read(&b[ix], nbytes)) {
+				if (!wilc_spi_read(&b[ix], nbytes)) {
 					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
 					result = N_FAIL;
 					goto _error_;
@@ -374,7 +374,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!linux_spi_read(crc, 2)) {
+					if (!wilc_spi_read(crc, 2)) {
 						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						goto _error_;
@@ -405,7 +405,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				 **/
 				retry = 10;
 				do {
-					if (!linux_spi_read(&rsp, 1)) {
+					if (!wilc_spi_read(&rsp, 1)) {
 						PRINT_ER("[wilc spi]: Failed data response read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -421,7 +421,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				/**
 				 * Read bytes
 				 **/
-				if (!linux_spi_read(&b[ix], nbytes)) {
+				if (!wilc_spi_read(&b[ix], nbytes)) {
 					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
 					result = N_FAIL;
 					break;
@@ -431,7 +431,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!linux_spi_read(crc, 2)) {
+					if (!wilc_spi_read(crc, 2)) {
 						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -481,7 +481,7 @@ static int spi_data_write(u8 *b, u32 sz)
 				order = 0x2;
 		}
 		cmd |= order;
-		if (!linux_spi_write(&cmd, 1)) {
+		if (!wilc_spi_write(&cmd, 1)) {
 			PRINT_ER("[wilc spi]: Failed data block cmd write, bus error...\n");
 			result = N_FAIL;
 			break;
@@ -490,7 +490,7 @@ static int spi_data_write(u8 *b, u32 sz)
 		/**
 		 *      Write data
 		 **/
-		if (!linux_spi_write(&b[ix], nbytes)) {
+		if (!wilc_spi_write(&b[ix], nbytes)) {
 			PRINT_ER("[wilc spi]: Failed data block write, bus error...\n");
 			result = N_FAIL;
 			break;
@@ -500,7 +500,7 @@ static int spi_data_write(u8 *b, u32 sz)
 		 *      Write Crc
 		 **/
 		if (!g_spi.crc_off) {
-			if (!linux_spi_write(crc, 2)) {
+			if (!wilc_spi_write(crc, 2)) {
 				PRINT_ER("[wilc spi]: Failed data block crc write, bus error...\n");
 				result = N_FAIL;
 				break;
@@ -585,7 +585,7 @@ static int wilc_spi_write_reg(u32 addr, u32 data)
 	return result;
 }
 
-static int wilc_spi_write(u32 addr, u8 *buf, u32 size)
+static int _wilc_spi_write(u32 addr, u8 *buf, u32 size)
 {
 	int result;
 	u8 cmd = CMD_DMA_EXT_WRITE;
@@ -639,7 +639,7 @@ static int wilc_spi_read_reg(u32 addr, u32 *data)
 	return 1;
 }
 
-static int wilc_spi_read(u32 addr, u8 *buf, u32 size)
+static int _wilc_spi_read(u32 addr, u8 *buf, u32 size)
 {
 	u8 cmd = CMD_DMA_EXT_READ;
 	int result;
@@ -675,7 +675,7 @@ static int wilc_spi_clear_int(void)
 	return 1;
 }
 
-static int wilc_spi_deinit(void *pv)
+static int _wilc_spi_deinit(void *pv)
 {
 	/**
 	 *      TODO:
@@ -721,7 +721,7 @@ static int wilc_spi_sync(void)
 	return 1;
 }
 
-static int wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
+static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 {
 	u32 reg;
 	u32 chipid;
@@ -740,7 +740,7 @@ static int wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 	memset(&g_spi, 0, sizeof(wilc_spi_t));
 
 	g_spi.dPrint = func;
-	if (!linux_spi_init()) {
+	if (!wilc_spi_init()) {
 		PRINT_ER("[wilc spi]: Failed io init bus...\n");
 		return 0;
 	} else {
@@ -795,7 +795,7 @@ static int wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 
 static void wilc_spi_max_bus_speed(void)
 {
-	linux_spi_set_max_speed();
+	wilc_spi_set_max_speed();
 }
 
 static void wilc_spi_default_bus_speed(void)
@@ -1021,20 +1021,20 @@ static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
  *      Global spi HIF function table
  *
  ********************************************/
-struct wilc_hif_func hif_spi = {
-	wilc_spi_init,
-	wilc_spi_deinit,
+struct wilc_hif_func wilc_hif_spi = {
+	_wilc_spi_init,
+	_wilc_spi_deinit,
 	wilc_spi_read_reg,
 	wilc_spi_write_reg,
-	wilc_spi_read,
-	wilc_spi_write,
+	_wilc_spi_read,
+	_wilc_spi_write,
 	wilc_spi_sync,
 	wilc_spi_clear_int,
 	wilc_spi_read_int,
 	wilc_spi_clear_int_ext,
 	wilc_spi_read_size,
-	wilc_spi_write,
-	wilc_spi_read,
+	_wilc_spi_write,
+	_wilc_spi_read,
 	wilc_spi_sync_ext,
 	wilc_spi_max_bus_speed,
 	wilc_spi_default_bus_speed,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 842f0e4bec97..f8fd7a895d44 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -21,18 +21,18 @@
 #define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-extern int mac_open(struct net_device *ndev);
-extern int mac_close(struct net_device *ndev);
+extern int wilc_mac_open(struct net_device *ndev);
+extern int wilc_mac_close(struct net_device *ndev);
 
 static tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 u32LastScannedNtwrksCountShadow;
-struct timer_list hDuringIpTimer;
+struct timer_list wilc_during_ip_timer;
 static struct timer_list hAgingTimer;
 static u8 op_ifcs;
-extern u8 u8ConnectedSSID[6];
+extern u8 wilc_connected_SSID[6];
 
-u8 g_wilc_initialized = 1;
-extern bool g_obtainingIP;
+u8 wilc_initialized = 1;
+extern bool wilc_optaining_ip;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
 		.band             = IEEE80211_BAND_2GHZ, \
@@ -139,7 +139,7 @@ static void clear_shadow_scan(void *pUserVoid)
 				astrLastScannedNtwrksShadow[u32LastScannedNtwrksCountShadow].pu8IEs = NULL;
 			}
 
-			host_int_freeJoinParams(astrLastScannedNtwrksShadow[i].pJoinParams);
+			wilc_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
 			astrLastScannedNtwrksShadow[i].pJoinParams = NULL;
 		}
 		u32LastScannedNtwrksCountShadow = 0;
@@ -232,7 +232,7 @@ static void remove_network_from_shadow(unsigned long arg)
 			kfree(astrLastScannedNtwrksShadow[i].pu8IEs);
 			astrLastScannedNtwrksShadow[i].pu8IEs = NULL;
 
-			host_int_freeJoinParams(astrLastScannedNtwrksShadow[i].pJoinParams);
+			wilc_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
 
 			for (j = i; (j < u32LastScannedNtwrksCountShadow - 1); j++) {
 				astrLastScannedNtwrksShadow[j] = astrLastScannedNtwrksShadow[j + 1];
@@ -253,7 +253,7 @@ static void remove_network_from_shadow(unsigned long arg)
 static void clear_duringIP(unsigned long arg)
 {
 	PRINT_D(GENERIC_DBG, "GO:IP Obtained , enable scan\n");
-	g_obtainingIP = false;
+	wilc_optaining_ip = false;
 }
 
 static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
@@ -331,7 +331,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserV
 	astrLastScannedNtwrksShadow[ap_index].u32TimeRcvdInScanCached = jiffies;
 	astrLastScannedNtwrksShadow[ap_index].u8Found = 1;
 	if (ap_found != -1)
-		host_int_freeJoinParams(astrLastScannedNtwrksShadow[ap_index].pJoinParams);
+		wilc_free_join_params(astrLastScannedNtwrksShadow[ap_index].pJoinParams);
 	astrLastScannedNtwrksShadow[ap_index].pJoinParams = pJoinParams;
 
 }
@@ -484,7 +484,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-int connecting;
+int wilc_connecting;
 
 static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			     tstrConnectInfo *pstrConnectInfo,
@@ -499,7 +499,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 	struct wilc *wl;
 	perInterface_wlan_t *nic;
 
-	connecting = 0;
+	wilc_connecting = 0;
 
 	priv = (struct wilc_priv *)pUserVoid;
 	dev = priv->dev;
@@ -520,8 +520,8 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			/* The case here is that our station was waiting for association response frame and has just received it containing status code
 			 *  = SUCCESSFUL_STATUSCODE, while mac status is MAC_DISCONNECTED (which means something wrong happened) */
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
-			linux_wlan_set_bssid(priv->dev, NullBssid);
-			eth_zero_addr(u8ConnectedSSID);
+			wilc_wlan_set_bssid(priv->dev, NullBssid);
+			eth_zero_addr(wilc_connected_SSID);
 
 			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 			if (!pstrWFIDrv->p2p_connect)
@@ -572,15 +572,15 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 					u16ConnectStatus, GFP_KERNEL);                         /* TODO: mostafa: u16ConnectStatus to */
 		/* be replaced by pstrConnectInfo->u16ConnectStatus */
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
-		g_obtainingIP = false;
+		wilc_optaining_ip = false;
 		PRINT_ER("Received MAC_DISCONNECTED from firmware with reason %d on dev [%p]\n",
 			 pstrDisconnectNotifInfo->u16reason, priv->dev);
 		u8P2Plocalrandom = 0x01;
 		u8P2Precvrandom = 0x00;
 		bWilc_ie = false;
 		eth_zero_addr(priv->au8AssociatedBss);
-		linux_wlan_set_bssid(priv->dev, NullBssid);
-		eth_zero_addr(u8ConnectedSSID);
+		wilc_wlan_set_bssid(priv->dev, NullBssid);
+		eth_zero_addr(wilc_connected_SSID);
 
 		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 		if (!pstrWFIDrv->p2p_connect)
@@ -630,7 +630,7 @@ static int set_channel(struct wiphy *wiphy,
 	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
 	curr_channel = channelnum;
-	result = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
+	result = wilc_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
 
 	if (result != 0)
 		PRINT_ER("Error in setting channel %d\n", channelnum);
@@ -665,7 +665,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	priv->u32RcvdChCount = 0;
 
-	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
+	wilc_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 
 	reset_shadow_found(priv);
@@ -702,13 +702,13 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				}
 			}
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			s32Error = wilc_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, &strHiddenNetwork);
 		} else {
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			s32Error = wilc_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, NULL);
@@ -755,11 +755,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 
 
-	connecting = 1;
+	wilc_connecting = 1;
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (struct host_if_drv *)(priv->hWILCWFIDrv);
 
-	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
+	wilc_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
@@ -852,8 +852,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			host_int_set_wep_default_key(priv->hWILCWFIDrv, sme->key_idx);
-			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc_set_wep_default_keyid(priv->hWILCWFIDrv, sme->key_idx);
+			wilc_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)   {
 			u8security = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 			pcgroup_encrypt_val = "WEP104";
@@ -869,8 +869,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
 
-			host_int_set_wep_default_key(priv->hWILCWFIDrv, sme->key_idx);
-			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
+			wilc_set_wep_default_keyid(priv->hWILCWFIDrv, sme->key_idx);
+			wilc_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
 		} else if (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)   {
 			if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP)	{
 				u8security = ENCRYPT_ENABLED | WPA2 | TKIP;
@@ -961,15 +961,15 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (!pstrWFIDrv->p2p_connect)
 		u8WLANChannel = pstrNetworkInfo->u8channel;
 
-	linux_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
+	wilc_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
 
-	s32Error = host_int_set_join_req(priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
+	s32Error = wilc_set_join_req(priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
 					 sme->ssid_len, sme->ie, sme->ie_len,
 					 CfgConnectResult, (void *)priv, u8security,
 					 tenuAuth_type, pstrNetworkInfo->u8channel,
 					 pstrNetworkInfo->pJoinParams);
 	if (s32Error != 0) {
-		PRINT_ER("host_int_set_join_req(): Error(%d)\n", s32Error);
+		PRINT_ER("wilc_set_join_req(): Error(%d)\n", s32Error);
 		s32Error = -ENOENT;
 		goto done;
 	}
@@ -996,14 +996,14 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	struct host_if_drv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
-	connecting = 0;
+	wilc_connecting = 0;
 	priv = wiphy_priv(wiphy);
 
 	/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	if (!pstrWFIDrv->p2p_connect)
 		u8WLANChannel = INVALID_CHANNEL;
-	linux_wlan_set_bssid(priv->dev, NullBssid);
+	wilc_wlan_set_bssid(priv->dev, NullBssid);
 
 	PRINT_D(CFG80211_DBG, "Disconnecting with reason code(%d)\n", reason_code);
 
@@ -1012,7 +1012,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	bWilc_ie = false;
 	pstrWFIDrv->p2p_timeout = 0;
 
-	s32Error = host_int_disconnect(priv->hWILCWFIDrv, reason_code);
+	s32Error = wilc_disconnect(priv->hWILCWFIDrv, reason_code);
 	if (s32Error != 0) {
 		PRINT_ER("Error in disconnecting: Error(%d)\n", s32Error);
 		s32Error = -EINVAL;
@@ -1083,7 +1083,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			else
 				u8mode = ENCRYPT_ENABLED | WEP | WEP_EXTENDED;
 
-			host_int_add_wep_key_bss_ap(priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
+			wilc_add_wep_key_bss_ap(priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
 			break;
 		}
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
@@ -1097,7 +1097,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				for (i = 0; i < params->key_len; i++)
 					PRINT_INFO(CFG80211_DBG, "WEP key value[%d] = %d\n", i, params->key[i]);
 			}
-			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, params->key, params->key_len, key_index);
+			wilc_add_wep_key_bss_sta(priv->hWILCWFIDrv, params->key, params->key_len, key_index);
 		}
 
 		break;
@@ -1160,7 +1160,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 
-				host_int_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
+				wilc_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
 						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, AP_MODE, u8gmode);
 
 			} else {
@@ -1205,7 +1205,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_ptk[key_index]->key_len = params->key_len;
 				priv->wilc_ptk[key_index]->seq_len = params->seq_len;
 
-				host_int_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
+				wilc_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
 						 pu8RxMic, pu8TxMic, AP_MODE, u8pmode, key_index);
 			}
 			break;
@@ -1247,7 +1247,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_gtk_keys_saved = true;
 				}
 
-				host_int_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
+				wilc_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
 						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, STATION_MODE, u8mode);
 			} else {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
@@ -1283,7 +1283,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_ptk_keys_saved = true;
 				}
 
-				host_int_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
+				wilc_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
 						 pu8RxMic, pu8TxMic, STATION_MODE, u8mode, key_index);
 				PRINT_D(CFG80211_DBG, "Adding pairwise key\n");
 				if (INFO) {
@@ -1372,7 +1372,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		g_key_gtk_params.seq = NULL;
 
 		/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-		set_machw_change_vir_if(netdev, false);
+		wilc_set_machw_change_vir_if(netdev, false);
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
@@ -1380,10 +1380,10 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		priv->WILC_WFI_wep_key_len[key_index] = 0;
 
 		PRINT_D(CFG80211_DBG, "Removing WEP key with index = %d\n", key_index);
-		host_int_remove_wep_key(priv->hWILCWFIDrv, key_index);
+		wilc_remove_wep_key(priv->hWILCWFIDrv, key_index);
 	} else {
 		PRINT_D(CFG80211_DBG, "Removing all installed keys\n");
-		host_int_remove_key(priv->hWILCWFIDrv, mac_addr);
+		wilc_remove_key(priv->hWILCWFIDrv, mac_addr);
 	}
 
 	return 0;
@@ -1461,7 +1461,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 
 	if (key_index != priv->WILC_WFI_wep_default) {
 
-		host_int_set_wep_default_key(priv->hWILCWFIDrv, key_index);
+		wilc_set_wep_default_keyid(priv->hWILCWFIDrv, key_index);
 	}
 
 	return 0;
@@ -1509,7 +1509,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
 
-		host_int_get_inactive_time(priv->hWILCWFIDrv, mac, &(inactive_time));
+		wilc_get_inactive_time(priv->hWILCWFIDrv, mac, &(inactive_time));
 		sinfo->inactive_time = 1000 * inactive_time;
 		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
 
@@ -1518,7 +1518,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == STATION_MODE) {
 		struct rf_info strStatistics;
 
-		host_int_get_statistics(priv->hWILCWFIDrv, &strStatistics);
+		wilc_get_statistics(priv->hWILCWFIDrv, &strStatistics);
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
 						BIT(NL80211_STA_INFO_RX_PACKETS) |
@@ -1534,9 +1534,9 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		if ((strStatistics.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH) &&
 		    (strStatistics.link_speed != DEFAULT_LINK_SPEED))
-			enable_tcp_ack_filter(true);
+			wilc_enable_tcp_ack_filter(true);
 		else if (strStatistics.link_speed != DEFAULT_LINK_SPEED)
-			enable_tcp_ack_filter(false);
+			wilc_enable_tcp_ack_filter(false);
 
 		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
 			sinfo->tx_failed, sinfo->txrate.legacy);
@@ -1623,7 +1623,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	}
 
 	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
-	s32Error = hif_set_cfg(priv->hWILCWFIDrv, &pstrCfgParamVal);
+	s32Error = wilc_hif_set_cfg(priv->hWILCWFIDrv, &pstrCfgParamVal);
 	if (s32Error)
 		PRINT_ER("Error in setting WIPHY PARAMS\n");
 
@@ -1678,7 +1678,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (!s32Error) {
 		PRINT_D(CFG80211_DBG, "Setting pmkid in the host interface\n");
-		s32Error = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
+		s32Error = wilc_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
 	}
 	return s32Error;
 }
@@ -2101,7 +2101,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 	priv->strRemainOnChanParams.u32ListenDuration = duration;
 	priv->strRemainOnChanParams.u32ListenSessionID++;
 
-	s32Error = host_int_remain_on_channel(priv->hWILCWFIDrv
+	s32Error = wilc_remain_on_channel(priv->hWILCWFIDrv
 					      , priv->strRemainOnChanParams.u32ListenSessionID
 					      , duration
 					      , chan->hw_value
@@ -2136,7 +2136,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 
 	PRINT_D(CFG80211_DBG, "Cancel remain on channel\n");
 
-	s32Error = host_int_ListenStateExpired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
+	s32Error = wilc_listen_state_expired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
 	return s32Error;
 }
 /**
@@ -2149,7 +2149,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
  *  @date	01 JUL 2012
  *  @version
  */
-extern bool bEnablePS;
+extern bool wilc_enable_ps;
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
 		   struct cfg80211_mgmt_tx_params *params,
@@ -2196,7 +2196,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 			PRINT_D(GENERIC_DBG, "TX: Probe Response\n");
 			PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-			host_int_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
+			wilc_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
 			/*Save the current channel after we tune to it*/
 			curr_channel = chan->hw_value;
 		} else if (ieee80211_is_action(mgmt->frame_control))   {
@@ -2211,7 +2211,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 				if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
 				    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF)	{
 					PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
-					host_int_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
+					wilc_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
 					/*Save the current channel after we tune to it*/
 					curr_channel = chan->hw_value;
 				}
@@ -2383,7 +2383,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
 	}
-	host_int_frame_register(priv->hWILCWFIDrv, frame_type, reg);
+	wilc_frame_register(priv->hWILCWFIDrv, frame_type, reg);
 
 
 }
@@ -2434,7 +2434,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 
-	host_int_get_rssi(priv->hWILCWFIDrv, &(sinfo->signal));
+	wilc_get_rssi(priv->hWILCWFIDrv, &(sinfo->signal));
 
 	return 0;
 
@@ -2466,8 +2466,8 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		return -EIO;
 	}
 
-	if (bEnablePS)
-		host_int_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
+	if (wilc_enable_ps)
+		wilc_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
 
 
 	return 0;
@@ -2507,17 +2507,17 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	bWilc_ie = false;
 
-	g_obtainingIP = false;
-	del_timer(&hDuringIpTimer);
+	wilc_optaining_ip = false;
+	del_timer(&wilc_during_ip_timer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
-		set_machw_change_vir_if(dev, true);
+		wilc_set_machw_change_vir_if(dev, true);
 	}
 
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
-		connecting = 0;
+		wilc_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_STATION\n");
 
 		/* send delba over wlan interface */
@@ -2534,30 +2534,30 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->iftype = STATION_MODE;
 
 		if (wl->initialized) {
-			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-						      wl->vif[0].bssid, TID);
+			wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
+						   wl->vif[0].bssid, TID);
 			/* ensure that the message Q is empty */
-			host_int_wait_msg_queue_idle();
+			wilc_wait_msg_queue_idle();
 
 			/*Eliminate host interface blocking state*/
 			up(&wl->cfg_event);
 
 			wilc1000_wlan_deinit(dev);
 			wilc1000_wlan_init(dev, nic);
-			g_wilc_initialized = 1;
+			wilc_initialized = 1;
 			nic->iftype = interface_type;
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-			host_int_set_wfi_drv_handler(wl->vif[0].hif_drv);
-			host_int_set_MacAddress(wl->vif[0].hif_drv,
+			wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
+			wilc_set_mac_address(wl->vif[0].hif_drv,
 						wl->vif[0].src_addr);
-			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
+			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_wep_default_key(wl->vif[0].hif_drv,
+				wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
+				wilc_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2565,7 +2565,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*No matter the driver handler passed here, it will be overwriiten*/
 			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
-			host_int_flush_join_req(priv->hWILCWFIDrv);
+			wilc_flush_join_req(priv->hWILCWFIDrv);
 
 			/*Add saved PTK and GTK keys, if any*/
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
@@ -2594,25 +2594,25 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
-					host_int_frame_register(priv->hWILCWFIDrv,
+					wilc_frame_register(priv->hWILCWFIDrv,
 								nic->g_struct_frame_reg[i].frame_type,
 								nic->g_struct_frame_reg[i].reg);
 				}
 			}
 
-			bEnablePS = true;
-			host_int_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
+			wilc_enable_ps = true;
+			wilc_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
 		}
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
-		bEnablePS = false;
-		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
-		connecting = 0;
+		wilc_enable_ps = false;
+		wilc_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
+		wilc_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-					      wl->vif[0].bssid, TID);
+		wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
+					   wl->vif[0].bssid, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2624,30 +2624,30 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized)	{
 			/* ensure that the message Q is empty */
-			host_int_wait_msg_queue_idle();
+			wilc_wait_msg_queue_idle();
 
 			wilc1000_wlan_deinit(dev);
 			wilc1000_wlan_init(dev, nic);
-			g_wilc_initialized = 1;
+			wilc_initialized = 1;
 
-			host_int_set_wfi_drv_handler(wl->vif[0].hif_drv);
-			host_int_set_MacAddress(wl->vif[0].hif_drv,
+			wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
+			wilc_set_mac_address(wl->vif[0].hif_drv,
 						wl->vif[0].src_addr);
-			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
+			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_wep_default_key(wl->vif[0].hif_drv,
-							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
-							     g_key_wep_params.key,
-							     g_key_wep_params.key_len,
-							     g_key_wep_params.key_idx);
+				wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
+							   g_key_wep_params.key_idx);
+				wilc_add_wep_key_bss_sta(wl->vif[0].hif_drv,
+							 g_key_wep_params.key,
+							 g_key_wep_params.key_len,
+							 g_key_wep_params.key_idx);
 			}
 
 			/*No matter the driver handler passed here, it will be overwriiten*/
 			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
-			host_int_flush_join_req(priv->hWILCWFIDrv);
+			wilc_flush_join_req(priv->hWILCWFIDrv);
 
 			/*Add saved PTK and GTK keys, if any*/
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
@@ -2674,13 +2674,13 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*Refresh scan, to refresh the scan results to the wpa_supplicant. Set MachHw to false to enable further key installments*/
 			refresh_scan(priv, 1, true);
-			set_machw_change_vir_if(dev, false);
+			wilc_set_machw_change_vir_if(dev, false);
 
 			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
-					host_int_frame_register(priv->hWILCWFIDrv,
+					wilc_frame_register(priv->hWILCWFIDrv,
 								nic->g_struct_frame_reg[i].frame_type,
 								nic->g_struct_frame_reg[i].reg);
 				}
@@ -2689,7 +2689,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	case NL80211_IFTYPE_AP:
-		bEnablePS = false;
+		wilc_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_AP %d\n", type);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2697,17 +2697,17 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
-		linux_wlan_get_firmware(dev);
+		wilc_wlan_get_firmware(dev);
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
 		if (wl->initialized)	{
 			nic->iftype = AP_MODE;
-			mac_close(dev);
-			mac_open(dev);
+			wilc_mac_close(dev);
+			wilc_mac_open(dev);
 
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
-				host_int_frame_register(priv->hWILCWFIDrv,
+				wilc_frame_register(priv->hWILCWFIDrv,
 							nic->g_struct_frame_reg[i].frame_type,
 							nic->g_struct_frame_reg[i].reg);
 			}
@@ -2717,16 +2717,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_P2P_GO:
 		PRINT_D(GENERIC_DBG, "start duringIP timer\n");
 
-		g_obtainingIP = true;
-		mod_timer(&hDuringIpTimer, jiffies + msecs_to_jiffies(duringIP_TIME));
-		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
+		wilc_optaining_ip = true;
+		mod_timer(&wilc_during_ip_timer, jiffies + msecs_to_jiffies(duringIP_TIME));
+		wilc_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
 		/*Delete block ack has to be the latest config packet*/
 		/*sent before downloading new FW. This is because it blocks on*/
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-					      wl->vif[0].bssid, TID);
-		bEnablePS = false;
+		wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
+					   wl->vif[0].bssid, TID);
+		wilc_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2739,23 +2739,23 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->iftype = GO_MODE;
 
 		/* ensure that the message Q is empty */
-		host_int_wait_msg_queue_idle();
+		wilc_wait_msg_queue_idle();
 		wilc1000_wlan_deinit(dev);
 		wilc1000_wlan_init(dev, nic);
-		g_wilc_initialized = 1;
+		wilc_initialized = 1;
 
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-		host_int_set_wfi_drv_handler(wl->vif[0].hif_drv);
-		host_int_set_MacAddress(wl->vif[0].hif_drv,
-					wl->vif[0].src_addr);
-		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
+		wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
+		wilc_set_mac_address(wl->vif[0].hif_drv,
+				     wl->vif[0].src_addr);
+		wilc_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_wep_default_key(wl->vif[0].hif_drv,
-						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
+			wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
+						   g_key_wep_params.key_idx);
+			wilc_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
@@ -2763,7 +2763,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/*No matter the driver handler passed here, it will be overwriiten*/
 		/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
-		host_int_flush_join_req(priv->hWILCWFIDrv);
+		wilc_flush_join_req(priv->hWILCWFIDrv);
 
 		/*Add saved PTK and GTK keys, if any*/
 		if (g_ptk_keys_saved && g_gtk_keys_saved) {
@@ -2794,7 +2794,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
-				host_int_frame_register(priv->hWILCWFIDrv,
+				wilc_frame_register(priv->hWILCWFIDrv,
 							nic->g_struct_frame_reg[i].frame_type,
 							nic->g_struct_frame_reg[i].reg);
 			}
@@ -2857,9 +2857,9 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	linux_wlan_set_bssid(dev, wl->vif[0].src_addr);
+	wilc_wlan_set_bssid(dev, wl->vif[0].src_addr);
 
-	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
+	s32Error = wilc_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
 					settings->dtim_period,
 					beacon->head_len, (u8 *)beacon->head,
@@ -2890,7 +2890,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
 
 
-	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
+	s32Error = wilc_add_beacon(priv->hWILCWFIDrv,
 					0,
 					0,
 					beacon->head_len, (u8 *)beacon->head,
@@ -2921,9 +2921,9 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	PRINT_D(HOSTAPD_DBG, "Deleting beacon\n");
 
-	linux_wlan_set_bssid(dev, NullBssid);
+	wilc_wlan_set_bssid(dev, NullBssid);
 
-	s32Error = host_int_del_beacon(priv->hWILCWFIDrv);
+	s32Error = wilc_del_beacon(priv->hWILCWFIDrv);
 
 	if (s32Error)
 		PRINT_ER("Host delete beacon fail\n");
@@ -3003,7 +3003,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
 			strStaParams.flags_set);
 
-		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
+		s32Error = wilc_add_station(priv->hWILCWFIDrv, &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host add station fail\n");
 	}
@@ -3040,12 +3040,12 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 		if (mac == NULL) {
 			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
-			s32Error = host_int_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
+			s32Error = wilc_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
 		} else {
 			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 		}
 
-		s32Error = host_int_del_station(priv->hWILCWFIDrv, mac);
+		s32Error = wilc_del_station(priv->hWILCWFIDrv, mac);
 
 		if (s32Error)
 			PRINT_ER("Host delete station fail\n");
@@ -3127,7 +3127,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
 			strStaParams.flags_set);
 
-		s32Error = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
+		s32Error = wilc_edit_station(priv->hWILCWFIDrv, &strStaParams);
 		if (s32Error)
 			PRINT_ER("Host edit station fail\n");
 	}
@@ -3387,7 +3387,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 		   wdev->wiphy->interface_modes, wdev->iftype);
 
 	#ifdef WILC_SDIO
-	set_wiphy_dev(wdev->wiphy, &local_sdio_func->dev);
+	set_wiphy_dev(wdev->wiphy, &wilc_sdio_func->dev);
 	#endif
 
 	/*Register wiphy structure*/
@@ -3424,7 +3424,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv = wdev_priv(net->ieee80211_ptr);
 	if (op_ifcs == 0) {
 		setup_timer(&hAgingTimer, remove_network_from_shadow, 0);
-		setup_timer(&hDuringIpTimer, clear_duringIP, 0);
+		setup_timer(&wilc_during_ip_timer, clear_duringIP, 0);
 	}
 	op_ifcs++;
 	if (s32Error < 0) {
@@ -3437,7 +3437,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv->bInP2PlistenState = false;
 
 	sema_init(&(priv->hSemScanReq), 1);
-	s32Error = host_int_init(net, &priv->hWILCWFIDrv);
+	s32Error = wilc_init(net, &priv->hWILCWFIDrv);
 	if (s32Error)
 		PRINT_ER("Error while initializing hostinterface\n");
 
@@ -3467,13 +3467,13 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	op_ifcs--;
 
-	s32Error = host_int_deinit(priv->hWILCWFIDrv);
+	s32Error = wilc_deinit(priv->hWILCWFIDrv);
 
 	/* Clear the Shadow scan */
 	clear_shadow_scan(priv);
 	if (op_ifcs == 0) {
 		PRINT_D(CORECONFIG_DBG, "destroy during ip\n");
-		del_timer_sync(&hDuringIpTimer);
+		del_timer_sync(&wilc_during_ip_timer);
 	}
 
 	if (s32Error)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 9f9a9aeb3655..5262b2513fa8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -103,6 +103,6 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
-void enable_tcp_ack_filter(bool value);
+void wilc_enable_tcp_ack_filter(bool value);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 54ed72336775..2a0a3b166a7c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -206,7 +206,7 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-extern struct wilc *g_linux_wlan;
+extern struct wilc *wilc_dev;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(struct wilc *wilc, int flag);
@@ -217,7 +217,7 @@ void wl_wlan_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-u16 set_machw_change_vir_if(struct net_device *dev, bool value);
-int linux_wlan_get_firmware(struct net_device *dev);
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
+u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value);
+int wilc_wlan_get_firmware(struct net_device *dev);
+int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5c8c59257f58..a797c61e8061 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -3,9 +3,9 @@
 #include "wilc_wlan_cfg.h"
 
 #ifdef WILC_SDIO
-extern struct wilc_hif_func hif_sdio;
+extern struct wilc_hif_func wilc_hif_sdio;
 #else
-extern struct wilc_hif_func hif_spi;
+extern struct wilc_hif_func wilc_hif_spi;
 #endif
 u32 wilc_get_chipid(u8 update);
 
@@ -64,7 +64,7 @@ static CHIP_PS_STATE_T chip_ps_state = CHIP_WAKEDUP;
 
 static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
-	mutex_lock(&g_linux_wlan->hif_cs);
+	mutex_lock(&wilc_dev->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 	if (chip_ps_state != CHIP_WAKEDUP)
 	#endif
@@ -80,7 +80,7 @@ static inline void release_bus(BUS_RELEASE_T release)
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep();
 	#endif
-	mutex_unlock(&g_linux_wlan->hif_cs);
+	mutex_unlock(&wilc_dev->hif_cs);
 }
 
 #ifdef TCP_ACK_FILTER
@@ -169,11 +169,11 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	if (linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+	if (linux_wlan_lock_timeout(&wilc_dev->txq_add_to_head_cs,
 				    CFG_PKTS_TIMEOUT))
 		return -1;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc_dev->txq_spinlock, flags);
 
 	if (!p->txq_head) {
 		tqe->next = NULL;
@@ -189,9 +189,9 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
-	up(&g_linux_wlan->txq_add_to_head_cs);
-	up(&g_linux_wlan->txq_event);
+	spin_unlock_irqrestore(&wilc_dev->txq_spinlock, flags);
+	up(&wilc_dev->txq_add_to_head_cs);
+	up(&wilc_dev->txq_event);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
 	return 0;
@@ -266,9 +266,9 @@ static inline int remove_TCP_related(void)
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc_dev->txq_spinlock, flags);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc_dev->txq_spinlock, flags);
 	return 0;
 }
 
@@ -393,7 +393,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 static bool enabled = false;
 
-void enable_tcp_ack_filter(bool value)
+void wilc_enable_tcp_ack_filter(bool value)
 {
 	enabled = value;
 }
@@ -413,7 +413,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	PRINT_D(TX_DBG, "Adding config packet ...\n");
 	if (p->quit) {
 		PRINT_D(TX_DBG, "Return due to clear function\n");
-		up(&g_linux_wlan->cfg_event);
+		up(&wilc_dev->cfg_event);
 		return 0;
 	}
 
@@ -684,7 +684,7 @@ static inline void chip_wakeup(void)
 	chip_ps_state = CHIP_WAKEDUP;
 }
 #endif
-void chip_sleep_manually(void)
+void wilc_chip_sleep_manually(void)
 {
 	if (chip_ps_state != CHIP_WAKEDUP)
 		return;
@@ -1520,7 +1520,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drv_handler))
 			ret_size = 0;
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wilc_dev->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
@@ -1556,7 +1556,7 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler)
 		if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, drv_handler))
 			ret_size = 0;
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wilc_dev->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
 			ret_size = 0;
@@ -1670,18 +1670,18 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	       sizeof(wilc_wlan_io_func_t));
 
 #ifdef WILC_SDIO
-	if (!hif_sdio.hif_init(wilc, wilc_debug)) {
+	if (!wilc_hif_sdio.hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
 	}
-	memcpy((void *)&g_wlan.hif_func, &hif_sdio,
+	memcpy((void *)&g_wlan.hif_func, &wilc_hif_sdio,
 	       sizeof(struct wilc_hif_func));
 #else
-	if (!hif_spi.hif_init(wilc, wilc_debug)) {
+	if (!wilc_hif_spi.hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
 	}
-	memcpy((void *)&g_wlan.hif_func, &hif_spi,
+	memcpy((void *)&g_wlan.hif_func, &wilc_hif_spi,
 	       sizeof(struct wilc_hif_func));
 #endif
 
@@ -1733,7 +1733,7 @@ _fail_:
 	return ret;
 }
 
-u16 set_machw_change_vir_if(struct net_device *dev, bool value)
+u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value)
 {
 	u16 ret;
 	u32 reg;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 64fd019595ce..6cb6abe26096 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -290,5 +290,5 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
-void chip_sleep_manually(void);
+void wilc_chip_sleep_manually(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index e23796392e9c..274052f36400 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -532,17 +532,17 @@ int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, struct wilc_cfg_rsp *rsp)
 		rsp->seq_no = msg_id;
 		/*call host interface info parse as well*/
 		PRINT_INFO(RX_DBG, "Info message received\n");
-		GnrlAsyncInfoReceived(frame - 4, size + 4);
+		wilc_gnrl_async_info_received(frame - 4, size + 4);
 		break;
 
 	case 'N':
-		NetworkInfoReceived(frame - 4, size + 4);
+		wilc_network_info_received(frame - 4, size + 4);
 		rsp->type = 0;
 		break;
 
 	case 'S':
 		PRINT_INFO(RX_DBG, "Scan Notification Received\n");
-		host_int_ScanCompleteReceived(frame - 4, size + 4);
+		wilc_scan_complete_received(frame - 4, size + 4);
 		break;
 
 	default:
-- 
2.1.0.rc2

