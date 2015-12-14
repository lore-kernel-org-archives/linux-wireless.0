Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13834 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbLNFoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:44:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/12] staging: wilc1000: remove wilc of struct host_if_drv
Date: Mon, 14 Dec 2015 14:47:01 +0900
Message-ID: <1450072023-13013-11-git-send-email-glen.lee@atmel.com> (sfid-20151214_064424_986178_ED0E072D)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vif has wilc in it's members so no need to have wilc in host_if_drv.
It is redundant so just remove it and use wilc of vif.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 100 ++++++++++++------------------
 drivers/staging/wilc1000/host_interface.h |   1 -
 2 files changed, 41 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 39e93fa..f97ea49 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -293,7 +293,6 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
 	wid.type = WID_CHAR;
@@ -302,7 +301,7 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -343,14 +342,13 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_SET_OPERATION_MODE;
 	wid.type = WID_INT;
 	wid.val = (s8 *)&hif_op_mode->mode;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
@@ -388,7 +386,7 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	wid.val = (u8 *)ip_addr;
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	host_int_get_ipaddress(vif, hif_drv, firmware_ip_addr, idx);
@@ -407,14 +405,13 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_IP_ADDRESS;
 	wid.type = WID_STR;
 	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
@@ -443,7 +440,6 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (!mac_buf) {
@@ -458,7 +454,7 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	wid.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
@@ -474,14 +470,13 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
 	wid.val = get_mac_addr->mac_addr;
 	wid.size = ETH_ALEN;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -777,7 +772,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		wid_cnt++;
 	}
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, wid_list,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, wid_list,
 				      wid_cnt, wilc_get_vif_idx(vif));
 
 	if (result)
@@ -901,7 +896,7 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 	else if (hif_drv->hif_state == HOST_IF_IDLE)
 		scan_while_connected = false;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, strWIDList,
 				      u32WidsCount,
 				      wilc_get_vif_idx(vif));
 
@@ -947,7 +942,7 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 		wid.val = (s8 *)&u8abort_running_scan;
 		wid.size = sizeof(char);
 
-		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 					 wilc_get_vif_idx(vif));
 
 		if (result) {
@@ -1203,7 +1198,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc_connected_ssid);
 	}
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, strWIDList,
 				      u32WidsCount,
 				      wilc_get_vif_idx(vif));
 	if (result) {
@@ -1271,7 +1266,6 @@ static s32 Handle_FlushConnect(struct wilc_vif *vif)
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
@@ -1302,7 +1296,7 @@ static s32 Handle_FlushConnect(struct wilc_vif *vif)
 
 	u32WidsCount++;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, strWIDList,
 				      u32WidsCount,
 				      wilc_get_vif_idx(join_req_vif));
 	if (result) {
@@ -1365,7 +1359,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -1750,7 +1744,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			strWIDList[3].size = pstrHostIFkeyAttr->attr.wep.key_len;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						strWIDList, 4,
 						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1772,7 +1766,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						&wid, 1,
 						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1785,7 +1779,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.val = s8idxarray;
 			wid.size = 1;
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						&wid, 1,
 						wilc_get_vif_idx(vif));
 		} else {
@@ -1796,7 +1790,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						&wid, 1,
 						wilc_get_vif_idx(vif));
 		}
@@ -1830,7 +1824,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						strWIDList, 2,
 						wilc_get_vif_idx(vif));
 
@@ -1862,7 +1856,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = RX_MIC_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						&wid, 1,
 						wilc_get_vif_idx(vif));
 
@@ -1902,7 +1896,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						strWIDList, 2,
 						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1925,7 +1919,7 @@ _WPARxGtk_end_case_:
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = PTK_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
 						&wid, 1,
 						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1961,7 +1955,7 @@ _WPAPtk_end_case_:
 		wid.val = (s8 *)pu8keybuf;
 		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 					 wilc_get_vif_idx(vif));
 
 		kfree(pu8keybuf);
@@ -1994,7 +1988,7 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 
 	eth_zero_addr(wilc_connected_ssid);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2082,7 +2076,7 @@ static s32 Handle_GetChnl(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2107,7 +2101,7 @@ static void Handle_GetRssi(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = wilc_send_config_pkt(vif->hif_drv->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -2132,7 +2126,7 @@ static void Handle_GetLinkspeed(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -2147,7 +2141,6 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 {
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, result = 0;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
@@ -2179,7 +2172,7 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->tx_fail_cnt;
 	u32WidsCount++;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, strWIDList,
 				u32WidsCount,
 				wilc_get_vif_idx(vif));
 
@@ -2208,7 +2201,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2221,7 +2214,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	wid.val = (s8 *)&inactive_time;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2242,7 +2235,6 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
@@ -2281,7 +2273,7 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
@@ -2297,7 +2289,6 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_DEL_BEACON;
 	wid.type = WID_CHAR;
@@ -2311,7 +2302,7 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -2371,7 +2362,6 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	wid.id = (u16)WID_ADD_STA;
@@ -2385,7 +2375,7 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2403,7 +2393,6 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 	u8 *pu8CurrByte;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_DEL_ALL_STA;
 	wid.type = WID_STR;
@@ -2428,7 +2417,7 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2445,7 +2434,6 @@ static void Handle_DelStation(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_REMOVE_STA;
 	wid.type = WID_BIN;
@@ -2461,7 +2449,7 @@ static void Handle_DelStation(struct wilc_vif *vif,
 
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2476,7 +2464,6 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_EDIT_STA;
 	wid.type = WID_BIN;
@@ -2490,7 +2477,7 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -2552,7 +2539,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	wid.val[0] = u8remain_on_chan_flag;
 	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -2581,7 +2568,6 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register : %d FrameType: %d\n",
 		pstrHostIfRegisterFrame->reg,
@@ -2601,7 +2587,7 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 
 	wid.size = sizeof(u16) + 2;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -2636,7 +2622,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 		wid.val[0] = u8remain_on_chan_flag;
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
-		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 					 wilc_get_vif_idx(vif));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -2681,7 +2667,6 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	s8 s8PowerMode;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_POWER_MANAGEMENT;
 
@@ -2695,7 +2680,7 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -2707,7 +2692,6 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
 
@@ -2733,7 +2717,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 		memcpy(pu8CurrByte, wilc_multicast_mac_addr_list,
 		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -2748,7 +2732,6 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	char *ptr = NULL;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->bssid[0],
@@ -2770,7 +2753,7 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 	*ptr++ = 0;
 	*ptr++ = 32;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -3512,7 +3495,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 	wid.val = pu8AssocRespInfo;
 	wid.size = u32MaxAssocRespInfoLen;
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -3807,7 +3790,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		result = -ENOMEM;
 		goto _fail_;
 	}
-	hif_drv->wilc = wilc;
 	*hif_drv_handler = hif_drv;
 
 	wilc_optaining_ip = false;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8922f29..8faac27 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -261,7 +261,6 @@ enum p2p_listen_state {
 
 struct wilc;
 struct host_if_drv {
-	struct wilc *wilc;
 	struct user_scan_req usr_scan_req;
 	struct user_conn_req usr_conn_req;
 	struct remain_ch remain_on_ch;
-- 
1.9.1

