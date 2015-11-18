Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20757 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbKRGJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/16] staging: wilc1000: wilc_send_config_pkt: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:33 +0900
Message-ID: <1447827097-9436-13-git-send-email-glen.lee@atmel.com> (sfid-20151118_071410_084857_1853FC95)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch passes struct wilc to wilc_send_config_pkt. The function
wilc_wlan_cfg_set and wilc_wlan_cfg_get function will get wilc to replace
wilc_dev with it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   3 +-
 drivers/staging/wilc1000/coreconfigurator.h |   3 +-
 drivers/staging/wilc1000/host_interface.c   | 127 +++++++++++++++-------------
 3 files changed, 74 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 47fa82f..dc290d1 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -588,7 +588,8 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
  *  @date		1 Mar 2012
  *  @version	1.0
  */
-s32 wilc_send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
+s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
+			 u32 count, u32 drv)
 {
 	s32 counter = 0, ret = 0;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 912d5c2..3f2a7d3 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -127,7 +127,8 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 wilc_send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv);
+s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
+			 u32 count, u32 drv);
 s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3609949..43b77b7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -329,7 +329,7 @@ static s32 handle_set_channel(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -351,7 +351,8 @@ static s32 handle_set_wfi_drv_handler(struct host_if_drv *hif_drv,
 	wid.val = (s8 *)&hif_drv_handler->handler;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1, hif_drv_handler->handler);
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+				      hif_drv_handler->handler);
 
 	if (!hif_drv)
 		up(&hif_sema_driver);
@@ -375,7 +376,7 @@ static s32 handle_set_operation_mode(struct host_if_drv *hif_drv,
 	wid.val = (s8 *)&hif_op_mode->mode;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
@@ -410,7 +411,7 @@ static s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 id
 	wid.val = (u8 *)ip_addr;
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	host_int_get_ipaddress(hif_drv, firmware_ip_addr, idx);
@@ -435,7 +436,7 @@ static s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
 	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
@@ -478,7 +479,7 @@ static s32 handle_set_mac_address(struct host_if_drv *hif_drv,
 	wid.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
@@ -500,7 +501,7 @@ static s32 handle_get_mac_address(struct host_if_drv *hif_drv,
 	wid.val = get_mac_addr->mac_addr;
 	wid.size = ETH_ALEN;
 
-	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -795,8 +796,8 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 		wid_cnt++;
 	}
 
-	result = wilc_send_config_pkt(SET_CFG, wid_list, wid_cnt,
-				 get_id_from_handler(hif_drv));
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, wid_list,
+				      wid_cnt, get_id_from_handler(hif_drv));
 
 	if (result)
 		PRINT_ER("Error in setting CFG params\n");
@@ -918,8 +919,9 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	else if (hif_drv->hif_state == HOST_IF_IDLE)
 		scan_while_connected = false;
 
-	result = wilc_send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				 get_id_from_handler(hif_drv));
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
+				      u32WidsCount,
+				      get_id_from_handler(hif_drv));
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -962,7 +964,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		wid.val = (s8 *)&u8abort_running_scan;
 		wid.size = sizeof(char);
 
-		result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		if (result) {
@@ -1216,8 +1218,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc_connected_SSID);
 	}
 
-	result = wilc_send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				 get_id_from_handler(hif_drv));
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
+				      u32WidsCount,
+				      get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
 		result = -EFAULT;
@@ -1313,8 +1316,9 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 
 	u32WidsCount++;
 
-	result = wilc_send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				 get_id_from_handler(join_req_drv));
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
+				      u32WidsCount,
+				      get_id_from_handler(join_req_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
 		result = -EINVAL;
@@ -1374,7 +1378,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -1757,8 +1761,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[3].size = pstrHostIFkeyAttr->attr.wep.key_len;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
-			result = wilc_send_config_pkt(SET_CFG, strWIDList, 4,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						strWIDList, 4,
+						get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		}
 
@@ -1780,8 +1785,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
-			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						&wid, 1,
+						get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
@@ -1792,8 +1798,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = s8idxarray;
 			wid.size = 1;
 
-			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						&wid, 1,
+						get_id_from_handler(hif_drv));
 		} else {
 			wid.id = (u16)WID_KEY_ID;
 			wid.type = WID_CHAR;
@@ -1802,8 +1809,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						&wid, 1,
+						get_id_from_handler(hif_drv));
 		}
 		up(&hif_drv->sem_test_key_block);
 		break;
@@ -1835,8 +1843,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(SET_CFG, strWIDList, 2,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						strWIDList, 2,
+						get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1868,8 +1877,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = RX_MIC_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						&wid, 1,
+						get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1907,8 +1917,9 @@ _WPARxGtk_end_case_:
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
-			result = wilc_send_config_pkt(SET_CFG, strWIDList, 2,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						strWIDList, 2,
+						get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
 		}
@@ -1930,8 +1941,9 @@ _WPARxGtk_end_case_:
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = PTK_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(SET_CFG, &wid, 1,
-						 get_id_from_handler(hif_drv));
+			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+						&wid, 1,
+						get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
 		}
@@ -1965,7 +1977,7 @@ _WPAPtk_end_case_:
 		wid.val = (s8 *)pu8keybuf;
 		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		kfree(pu8keybuf);
@@ -1997,7 +2009,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	eth_zero_addr(wilc_connected_SSID);
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2084,7 +2096,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2109,7 +2121,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -2133,7 +2145,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -2178,8 +2190,9 @@ static s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pst
 	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->tx_fail_cnt;
 	u32WidsCount++;
 
-	result = wilc_send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
-				 get_id_from_handler(hif_drv));
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, strWIDList,
+				u32WidsCount,
+				get_id_from_handler(hif_drv));
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -2205,7 +2218,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2218,7 +2231,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	wid.val = (s8 *)&inactive_time;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2277,7 +2290,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
@@ -2306,7 +2319,7 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -2379,7 +2392,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2421,7 +2434,7 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2453,7 +2466,7 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2481,7 +2494,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -2542,7 +2555,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	wid.val[0] = u8remain_on_chan_flag;
 	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -2590,7 +2603,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	wid.size = sizeof(u16) + 2;
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -2622,7 +2635,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		wid.val[0] = u8remain_on_chan_flag;
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
-		result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -2680,7 +2693,7 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -2717,7 +2730,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, wilc_multicast_mac_addr_list,
 		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -2763,7 +2776,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 8;
 	*ptr++ = 0;
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
@@ -2782,7 +2795,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
 	*ptr++ = 3;
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	kfree(wid.val);
@@ -2817,7 +2830,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0;
 	*ptr++ = 32;
 
-	result = wilc_send_config_pkt(SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -3556,7 +3569,7 @@ static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	wid.val = pu8AssocRespInfo;
 	wid.size = u32MaxAssocRespInfoLen;
 
-	result = wilc_send_config_pkt(GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
-- 
1.9.1

