Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8340 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbJSJ1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:27:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 5/6] staging: wilc1000: fixes alignment should match open parenthesis
Date: Mon, 19 Oct 2015 18:26:12 +0900
Message-ID: <1445246773-22253-6-git-send-email-tony.cho@atmel.com> (sfid-20151019_112704_570926_35B32B64)
In-Reply-To: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
References: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for alignment should match open parenthesis.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 153 +++++++++++++++---------------
 1 file changed, 78 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b1bfd9e..9ee2d86 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -337,7 +337,7 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result) {
 		PRINT_ER("Failed to set channel\n");
@@ -359,7 +359,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 	strWID.size = sizeof(u32);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   pstrHostIfSetDrvHandler->u32Address);
+				 pstrHostIfSetDrvHandler->u32Address);
 
 	if (!hif_drv)
 		up(&hif_sema_driver);
@@ -384,7 +384,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 	strWID.size = sizeof(u32);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
 		up(&hif_sema_driver);
@@ -416,7 +416,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	strWID.size = IP_ALEN;
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	host_int_get_ipaddress(hif_drv, firmwareIPAddress, idx);
 
@@ -441,7 +441,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	strWID.size = IP_ALEN;
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.val);
 
@@ -484,7 +484,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.val);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
 		result = -EFAULT;
@@ -506,7 +506,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 	strWID.size = ETH_ALEN;
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result) {
 		PRINT_ER("Failed to get mac address\n");
@@ -791,7 +791,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 	}
 
 	result = send_config_pkt(SET_CFG, strWIDList, u8WidCnt,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result)
 		PRINT_ER("Error in setting CFG params\n");
@@ -912,7 +912,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		scan_while_connected = false;
 
 	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -957,7 +957,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		strWID.size = sizeof(char);
 
 		result = send_config_pkt(SET_CFG, &strWID, 1,
-					   get_id_from_handler(hif_drv));
+					 get_id_from_handler(hif_drv));
 
 		if (result) {
 			PRINT_ER("Failed to set abort running scan\n");
@@ -1014,16 +1014,18 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssid_len;
 	if (pstrHostIFconnectAttr->ssid != NULL) {
 		hif_drv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->ssid,
-			    pstrHostIFconnectAttr->ssid_len);
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid,
+		       pstrHostIFconnectAttr->ssid,
+		       pstrHostIFconnectAttr->ssid_len);
 		hif_drv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
 
 	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->ies_len;
 	if (pstrHostIFconnectAttr->ies != NULL) {
 		hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->ies,
-			    pstrHostIFconnectAttr->ies_len);
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
+		       pstrHostIFconnectAttr->ies,
+		       pstrHostIFconnectAttr->ies_len);
 	}
 
 	hif_drv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->security;
@@ -1208,7 +1210,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
 		result = -EFAULT;
@@ -1236,8 +1238,8 @@ ERRORHANDLER:
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->ies_len;
 				strConnectInfo.pu8ReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
-					    pstrHostIFconnectAttr->ies,
-					    pstrHostIFconnectAttr->ies_len);
+				       pstrHostIFconnectAttr->ies,
+				       pstrHostIFconnectAttr->ies_len);
 			}
 
 			pstrHostIFconnectAttr->result(CONN_DISCONN_EVENT_CONN_RESP,
@@ -1307,7 +1309,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	u32WidsCount++;
 
 	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(join_req_drv));
+				 get_id_from_handler(join_req_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
 		result = -EINVAL;
@@ -1337,15 +1339,15 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
 		if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
 			memcpy(strConnectInfo.au8bssid,
-				    hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
+			       hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
 		}
 
 		if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
 			strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
 			memcpy(strConnectInfo.pu8ReqIEs,
-				    hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
-				    hif_drv->strWILC_UsrConnReq.ConnReqIEsLen);
+			       hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
+			       hif_drv->strWILC_UsrConnReq.ConnReqIEsLen);
 		}
 
 		hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
@@ -1368,7 +1370,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -1420,7 +1422,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 			if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid != NULL) &&
 			    (pstrNetworkInfo->au8bssid != NULL)) {
 				if (memcmp(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid,
-						pstrNetworkInfo->au8bssid, 6) == 0) {
+					   pstrNetworkInfo->au8bssid, 6) == 0) {
 					if (pstrNetworkInfo->s8rssi <= hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi) {
 						PRINT_D(HOSTINF_DBG, "Network previously discovered\n");
 						goto done;
@@ -1442,7 +1444,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 				if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid != NULL)
 				    && (pstrNetworkInfo->au8bssid != NULL)) {
 					memcpy(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid,
-						    pstrNetworkInfo->au8bssid, 6);
+					       pstrNetworkInfo->au8bssid, 6);
 
 					hif_drv->strWILC_UsrScanReq.u32RcvdChCount++;
 
@@ -1760,7 +1762,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
 			result = send_config_pkt(SET_CFG, strWIDList, 4,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 
 
@@ -1776,7 +1778,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
 			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->attr.wep.key_len, 1);
 			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->attr.wep.key,
-				    pstrHostIFkeyAttr->attr.wep.key_len);
+			       pstrHostIFkeyAttr->attr.wep.key_len);
 			kfree(pstrHostIFkeyAttr->attr.wep.key);
 
 			strWID.id = (u16)WID_ADD_WEP_KEY;
@@ -1785,7 +1787,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
 			result = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
 
@@ -1798,7 +1800,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.size = 1;
 
 			result = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
@@ -1808,7 +1810,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
 			result = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 		}
 		up(&hif_drv->hSemTestKeyBlock);
 		break;
@@ -1828,7 +1830,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.key_len);
+			       pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
@@ -1841,7 +1843,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
 			result = send_config_pkt(SET_CFG, strWIDList, 2,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
@@ -1866,7 +1868,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.key_len);
+			       pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
@@ -1874,7 +1876,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.size = RX_MIC_KEY_MSG_LEN;
 
 			result = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
@@ -1906,7 +1908,7 @@ _WPARxGtk_end_case_:
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.index, 1);
 			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.key_len);
+			       pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
@@ -1919,7 +1921,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
 			result = send_config_pkt(SET_CFG, strWIDList, 2,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
 		}
@@ -1940,7 +1942,7 @@ _WPARxGtk_end_case_:
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.key_len);
+			       pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWID.id = (u16)WID_ADD_PTK;
 			strWID.type = WID_STR;
@@ -1948,7 +1950,7 @@ _WPARxGtk_end_case_:
 			strWID.size = PTK_KEY_MSG_LEN;
 
 			result = send_config_pkt(SET_CFG, &strWID, 1,
-						   get_id_from_handler(hif_drv));
+						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
 		}
@@ -1984,7 +1986,7 @@ _WPAPtk_end_case_:
 		strWID.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		result = send_config_pkt(SET_CFG, &strWID, 1,
-					   get_id_from_handler(hif_drv));
+					 get_id_from_handler(hif_drv));
 
 		kfree(pu8keybuf);
 		break;
@@ -2018,7 +2020,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 	eth_zero_addr(u8ConnectedSSID);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -2102,7 +2104,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result) {
 		PRINT_ER("Failed to get channel number\n");
@@ -2127,7 +2129,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
 		result = -EFAULT;
@@ -2154,7 +2156,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		result = -EFAULT;
@@ -2201,7 +2203,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	u32WidsCount++;
 
 	result = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -2231,7 +2233,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -2245,7 +2247,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	strWID.size = sizeof(u32);
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result) {
 		PRINT_ER("Failed to get incative time\n");
@@ -2304,7 +2306,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
@@ -2333,7 +2335,7 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
@@ -2404,7 +2406,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2447,7 +2449,7 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 	}
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2479,7 +2481,7 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2507,7 +2509,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
 
@@ -2568,7 +2570,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	strWID.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -2615,7 +2617,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	strWID.size = sizeof(u16) + 2;
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
 		result = -EINVAL;
@@ -2647,7 +2649,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		strWID.val[1] = FALSE_FRMWR_CHANNEL;
 
 		result = send_config_pkt(SET_CFG, &strWID, 1,
-					   get_id_from_handler(hif_drv));
+					 get_id_from_handler(hif_drv));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -2705,7 +2707,7 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
 }
@@ -2741,7 +2743,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
@@ -2788,7 +2790,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 0;
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -2808,7 +2810,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	*ptr++ = 3;
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	kfree(strWID.val);
 
@@ -2844,7 +2846,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 32;
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -3378,10 +3380,10 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	msg.drv = hif_drv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
-		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
-			    ETH_ALEN);
-		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
-			    PMKID_LEN);
+		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].bssid,
+		       &pu8PmkidInfoArray->pmkidlist[i].bssid, ETH_ALEN);
+		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].pmkid,
+		       &pu8PmkidInfoArray->pmkidlist[i].pmkid, PMKID_LEN);
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3625,8 +3627,9 @@ s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
 	return 0;
 }
 
-s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv, u8 *pu8AssocReqInfo,
-					u32 u32AssocReqInfoLen)
+s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv,
+				u8 *pu8AssocReqInfo,
+				u32 u32AssocReqInfoLen)
 {
 	struct wid strWID;
 
@@ -3638,8 +3641,10 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv, u8 *pu8AssocReqInfo
 	return 0;
 }
 
-s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInfo,
-					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
+s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
+				u8 *pu8AssocRespInfo,
+				u32 u32MaxAssocRespInfoLen,
+				u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 result = 0;
 	struct wid strWID;
@@ -3655,7 +3660,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInf
 	strWID.size = u32MaxAssocRespInfoLen;
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
@@ -3667,8 +3672,9 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInf
 	return result;
 }
 
-s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv, u8 *pu8RxPowerLevel,
-					u32 u32RxPowerLevelLen)
+s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv,
+				u8 *pu8RxPowerLevel,
+				u32 u32RxPowerLevelLen)
 {
 	struct wid strWID;
 
@@ -3797,10 +3803,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-
-
-	memcpy(msg.body.mac_info.mac,
-		    mac, ETH_ALEN);
+	memcpy(msg.body.mac_info.mac, mac, ETH_ALEN);
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.drv = hif_drv;
@@ -3832,7 +3835,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 	strWID.size = sizeof(u32);
 
 	result = send_config_pkt(GET_CFG, &strWID, 1,
-				   get_id_from_handler(hif_drv));
+				 get_id_from_handler(hif_drv));
 
 	if (result) {
 		PRINT_ER("Failed to get wid value\n");
-- 
1.9.1

