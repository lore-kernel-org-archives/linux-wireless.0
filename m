Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8364 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbbJSJ1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:27:07 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 6/6] staging: wilc1000: fixes comparison to NULL could be written
Date: Mon, 19 Oct 2015 18:26:13 +0900
Message-ID: <1445246773-22253-7-git-send-email-tony.cho@atmel.com> (sfid-20151019_112711_024961_F144569D)
In-Reply-To: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
References: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for comparison to NULL could be written.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 181 ++++++++++++++----------------
 1 file changed, 87 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9ee2d86..646e7e9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -470,8 +470,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid strWID;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
-
-	if (mac_buf == NULL) {
+	if (!mac_buf) {
 		PRINT_ER("No buffer to send mac address\n");
 		return -EFAULT;
 	}
@@ -851,7 +850,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		valuesize += ((pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
-	if (strWIDList[u32WidsCount].val != NULL) {
+	if (strWIDList[u32WidsCount].val) {
 		pu8Buffer = strWIDList[u32WidsCount].val;
 
 		*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.u8ssidnum;
@@ -887,7 +886,8 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 
-	if (pstrHostIFscanAttr->ch_freq_list != NULL && pstrHostIFscanAttr->ch_list_len > 0) {
+	if (pstrHostIFscanAttr->ch_freq_list &&
+	    pstrHostIFscanAttr->ch_list_len > 0) {
 		int i;
 
 		for (i = 0; i < pstrHostIFscanAttr->ch_list_len; i++)	{
@@ -1000,19 +1000,19 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
 
 	ptstrJoinBssParam = (struct join_bss_param *)pstrHostIFconnectAttr->params;
-	if (ptstrJoinBssParam == NULL) {
+	if (!ptstrJoinBssParam) {
 		PRINT_ER("Required BSSID not found\n");
 		result = -ENOENT;
 		goto ERRORHANDLER;
 	}
 
-	if (pstrHostIFconnectAttr->bssid != NULL) {
+	if (pstrHostIFconnectAttr->bssid) {
 		hif_drv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
 		memcpy(hif_drv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->bssid, 6);
 	}
 
 	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssid_len;
-	if (pstrHostIFconnectAttr->ssid != NULL) {
+	if (pstrHostIFconnectAttr->ssid) {
 		hif_drv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
 		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid,
 		       pstrHostIFconnectAttr->ssid,
@@ -1021,7 +1021,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->ies_len;
-	if (pstrHostIFconnectAttr->ies != NULL) {
+	if (pstrHostIFconnectAttr->ies) {
 		hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
 		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
 		       pstrHostIFconnectAttr->ies,
@@ -1099,15 +1099,14 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		join_req_size = strWIDList[u32WidsCount].size;
 		join_req = kmalloc(join_req_size, GFP_KERNEL);
 	}
-	if (strWIDList[u32WidsCount].val == NULL) {
+	if (!strWIDList[u32WidsCount].val) {
 		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
 	pu8CurrByte = strWIDList[u32WidsCount].val;
 
-
-	if (pstrHostIFconnectAttr->ssid != NULL) {
+	if (pstrHostIFconnectAttr->ssid) {
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
 		pu8CurrByte[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
@@ -1124,7 +1123,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
 	PRINT_D(HOSTINF_DBG, "* Cap Info %0x*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
 
-	if (pstrHostIFconnectAttr->bssid != NULL)
+	if (pstrHostIFconnectAttr->bssid)
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->bssid, 6);
 	pu8CurrByte += 6;
 
@@ -1202,7 +1201,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
 
-	if (pstrHostIFconnectAttr->bssid != NULL) {
+	if (pstrHostIFconnectAttr->bssid) {
 		memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->bssid, ETH_ALEN);
 
 		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n", pstrHostIFconnectAttr->bssid);
@@ -1230,11 +1229,11 @@ ERRORHANDLER:
 
 		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
-		if (pstrHostIFconnectAttr->result != NULL) {
-			if (pstrHostIFconnectAttr->bssid != NULL)
+		if (pstrHostIFconnectAttr->result) {
+			if (pstrHostIFconnectAttr->bssid)
 				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->bssid, 6);
 
-			if (pstrHostIFconnectAttr->ies != NULL) {
+			if (pstrHostIFconnectAttr->ies) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->ies_len;
 				strConnectInfo.pu8ReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
@@ -1336,13 +1335,13 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
-	if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
-		if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
+	if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
+		if (hif_drv->strWILC_UsrConnReq.pu8bssid) {
 			memcpy(strConnectInfo.au8bssid,
 			       hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
 		}
 
-		if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
+		if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs) {
 			strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
 			memcpy(strConnectInfo.pu8ReqIEs,
@@ -1382,12 +1381,12 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	eth_zero_addr(u8ConnectedSSID);
 
-	if (join_req != NULL && join_req_drv == hif_drv) {
+	if (join_req && join_req_drv == hif_drv) {
 		kfree(join_req);
 		join_req = NULL;
 	}
 
-	if (info_element != NULL && join_req_drv == hif_drv) {
+	if (info_element && join_req_drv == hif_drv) {
 		kfree(info_element);
 		info_element = NULL;
 	}
@@ -1410,8 +1409,8 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
 		parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
-		if ((pstrNetworkInfo == NULL)
-		    || (hif_drv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
+		if ((!pstrNetworkInfo) ||
+		    (!hif_drv->strWILC_UsrScanReq.pfUserScanResult)) {
 			PRINT_ER("driver is null\n");
 			result = -EINVAL;
 			goto done;
@@ -1419,8 +1418,8 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 
 		for (i = 0; i < hif_drv->strWILC_UsrScanReq.u32RcvdChCount; i++) {
 
-			if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid != NULL) &&
-			    (pstrNetworkInfo->au8bssid != NULL)) {
+			if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid) &&
+			    (pstrNetworkInfo->au8bssid)) {
 				if (memcmp(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid,
 					   pstrNetworkInfo->au8bssid, 6) == 0) {
 					if (pstrNetworkInfo->s8rssi <= hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi) {
@@ -1441,8 +1440,8 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 			if (hif_drv->strWILC_UsrScanReq.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
 				hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
 
-				if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid != NULL)
-				    && (pstrNetworkInfo->au8bssid != NULL)) {
+				if (hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid &&
+				    pstrNetworkInfo->au8bssid) {
 					memcpy(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid,
 					       pstrNetworkInfo->au8bssid, 6);
 
@@ -1471,7 +1470,7 @@ done:
 	kfree(pstrRcvdNetworkInfo->buffer);
 	pstrRcvdNetworkInfo->buffer = NULL;
 
-	if (pstrNetworkInfo != NULL) {
+	if (pstrNetworkInfo) {
 		DeallocateNetworkInfo(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
 	}
@@ -1505,8 +1504,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) ||
 	    (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) ||
 	    hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
-		if ((pstrRcvdGnrlAsyncInfo->buffer == NULL) ||
-		    (hif_drv->strWILC_UsrConnReq.pfUserConnectResult == NULL)) {
+		if (!pstrRcvdGnrlAsyncInfo->buffer ||
+		    !hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
 			PRINT_ER("driver is null\n");
 			return -EINVAL;
 		}
@@ -1556,7 +1555,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 						if (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
 							PRINT_INFO(HOSTINF_DBG, "Association response received : Successful connection status\n");
-							if (pstrConnectRespInfo->pu8RespIEs != NULL) {
+							if (pstrConnectRespInfo->pu8RespIEs) {
 								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->u16RespIEsLen;
 
 
@@ -1566,7 +1565,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 							}
 						}
 
-						if (pstrConnectRespInfo != NULL) {
+						if (pstrConnectRespInfo) {
 							DeallocateAssocRespInfo(pstrConnectRespInfo);
 							pstrConnectRespInfo = NULL;
 						}
@@ -1584,7 +1583,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				eth_zero_addr(u8ConnectedSSID);
 			}
 
-			if (hif_drv->strWILC_UsrConnReq.pu8bssid != NULL) {
+			if (hif_drv->strWILC_UsrConnReq.pu8bssid) {
 				PRINT_D(HOSTINF_DBG, "Retrieving actual BSSID from AP\n");
 				memcpy(strConnectInfo.au8bssid, hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
 
@@ -1596,7 +1595,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			}
 
 
-			if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
+			if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs) {
 				strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
@@ -1655,7 +1654,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			strDisconnectNotifInfo.ie = NULL;
 			strDisconnectNotifInfo.ie_len = 0;
 
-			if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
+			if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
 				g_obtainingIP = false;
 				host_int_set_power_mgmt(hif_drv, 0, 0);
 
@@ -1677,12 +1676,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-			if (join_req != NULL && join_req_drv == hif_drv) {
+			if (join_req && join_req_drv == hif_drv) {
 				kfree(join_req);
 				join_req = NULL;
 			}
 
-			if (info_element != NULL && join_req_drv == hif_drv) {
+			if (info_element && join_req_drv == hif_drv) {
 				kfree(info_element);
 				info_element = NULL;
 			}
@@ -1691,7 +1690,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			scan_while_connected = false;
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
-			   (hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL)) {
+			   (hif_drv->strWILC_UsrScanReq.pfUserScanResult)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
 			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
 
@@ -1771,7 +1770,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
-			if (pu8keybuf == NULL) {
+			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
 			}
@@ -1818,13 +1817,13 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 	case WPARxGtk:
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
-			if (pu8keybuf == NULL) {
+			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
 				ret = -1;
 				goto _WPARxGtk_end_case_;
 			}
 
-			if (pstrHostIFkeyAttr->attr.wpa.seq != NULL)
+			if (pstrHostIFkeyAttr->attr.wpa.seq)
 				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
@@ -1894,10 +1893,7 @@ _WPARxGtk_end_case_:
 
 
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
-
-
-
-			if (pu8keybuf == NULL) {
+			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send PTK Key\n");
 				ret = -1;
 				goto _WPAPtk_end_case_;
@@ -1929,10 +1925,7 @@ _WPARxGtk_end_case_:
 
 
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
-
-
-
-			if (pu8keybuf == NULL) {
+			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send PTK Key\n");
 				ret = -1;
 				goto _WPAPtk_end_case_;
@@ -1968,7 +1961,7 @@ _WPAPtk_end_case_:
 		PRINT_D(HOSTINF_DBG, "Handling PMKSA key\n");
 
 		pu8keybuf = kmalloc((pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
-		if (pu8keybuf == NULL) {
+		if (!pu8keybuf) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
 			return -1;
 		}
@@ -2041,7 +2034,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 			hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 		}
 
-		if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
+		if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
 			if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
 				del_timer(&hif_drv->hConnectTimer);
@@ -2065,12 +2058,12 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 		kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-		if (join_req != NULL && join_req_drv == hif_drv) {
+		if (join_req && join_req_drv == hif_drv) {
 			kfree(join_req);
 			join_req = NULL;
 		}
 
-		if (info_element != NULL && join_req_drv == hif_drv) {
+		if (info_element && join_req_drv == hif_drv) {
 			kfree(info_element);
 			info_element = NULL;
 		}
@@ -2274,7 +2267,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	strWID.type = WID_BIN;
 	strWID.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->tail_len + 16;
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
@@ -2327,7 +2320,7 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 	strWID.size = sizeof(char);
 	strWID.val = &del_beacon;
 
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		return;
 
 	pu8CurrByte = strWID.val;
@@ -2399,7 +2392,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	strWID.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
@@ -2432,7 +2425,7 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
 	strWID.val = kmalloc((pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
@@ -2473,7 +2466,7 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
@@ -2502,7 +2495,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
@@ -2535,7 +2528,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		pstrHostIfRemainOnChan->u16Channel = hif_drv->strHostIfRemainOnChan.u16Channel;
 	}
 
-	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
+	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
 		hif_drv->u8RemainOnChan_pendingreq = 1;
 		result = -EBUSY;
@@ -2560,8 +2553,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	strWID.type = WID_STR;
 	strWID.size = 2;
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-
-	if (strWID.val == NULL) {
+	if (!strWID.val) {
 		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
@@ -2604,7 +2596,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	strWID.id = (u16)WID_REGISTER_FRAME;
 	strWID.type = WID_STR;
 	strWID.val = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		return -ENOMEM;
 
 	pu8CurrByte = strWID.val;
@@ -2642,7 +2634,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		strWID.size = 2;
 		strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 
-		if (strWID.val == NULL)
+		if (!strWID.val)
 			PRINT_ER("Failed to allocate memory\n");
 
 		strWID.val[0] = u8remain_on_chan_flag;
@@ -2725,7 +2717,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	strWID.type = WID_BIN;
 	strWID.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->cnt) * ETH_ALEN);
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (strWID.val == NULL)
+	if (!strWID.val)
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
@@ -2881,7 +2873,8 @@ static int hostIFthread(void *pvArg)
 			continue;
 		}
 
-		if (msg.id == HOST_IF_MSG_CONNECT && hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
+		if (msg.id == HOST_IF_MSG_CONNECT &&
+		    hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
@@ -3249,9 +3242,11 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
-	if (pu8RxMic != NULL)
+
+	if (pu8RxMic)
 		u8KeyLen += RX_MIC_KEY_LEN;
-	if (pu8TxMic != NULL)
+
+	if (pu8TxMic)
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3269,14 +3264,14 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.attr.wpa.key = kmalloc(u8PtkKeylen, GFP_KERNEL);
 	memcpy(msg.body.key_info.attr.wpa.key, pu8Ptk, u8PtkKeylen);
 
-	if (pu8RxMic != NULL) {
+	if (pu8RxMic) {
 		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
 				PRINT_INFO(CFG80211_DBG, "PairwiseRx[%d] = %x\n", i, pu8RxMic[i]);
 		}
 	}
-	if (pu8TxMic != NULL) {
+	if (pu8TxMic) {
 		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
@@ -3315,12 +3310,13 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	}
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
-	if (pu8RxMic != NULL)
+	if (pu8RxMic)
 		u8KeyLen += RX_MIC_KEY_LEN;
-	if (pu8TxMic != NULL)
+
+	if (pu8TxMic)
 		u8KeyLen += TX_MIC_KEY_LEN;
-	if (KeyRSC != NULL) {
+
+	if (KeyRSC) {
 		msg.body.key_info.attr.wpa.seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
 		memcpy(msg.body.key_info.attr.wpa.seq, KeyRSC, u32KeyRSClen);
 	}
@@ -3340,10 +3336,11 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	msg.body.key_info.attr.wpa.key = kmalloc(u8KeyLen, GFP_KERNEL);
 	memcpy(msg.body.key_info.attr.wpa.key, pu8RxGtk, u8GtkKeylen);
 
-	if (pu8RxMic != NULL) {
+	if (pu8RxMic) {
 		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
 	}
-	if (pu8TxMic != NULL) {
+
+	if (pu8TxMic) {
 		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic, TX_MIC_KEY_LEN);
 	}
 
@@ -3510,12 +3507,12 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	s32 result = 0;
 	struct host_if_msg msg;
 
-	if (!hif_drv || pfConnectResult == NULL) {
+	if (!hif_drv || !pfConnectResult) {
 		PRINT_ER("Driver is null\n");
 		return -EFAULT;
 	}
 
-	if (pJoinParams == NULL) {
+	if (!pJoinParams) {
 		PRINT_ER("Unable to Join - JoinParams is NULL\n");
 		return -EFAULT;
 	}
@@ -3532,18 +3529,18 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.body.con_info.params = pJoinParams;
 	msg.drv = hif_drv ;
 
-	if (pu8bssid != NULL) {
+	if (pu8bssid) {
 		msg.body.con_info.bssid = kmalloc(6, GFP_KERNEL);
 		memcpy(msg.body.con_info.bssid, pu8bssid, 6);
 	}
 
-	if (pu8ssid != NULL) {
+	if (pu8ssid) {
 		msg.body.con_info.ssid_len = ssidLen;
 		msg.body.con_info.ssid = kmalloc(ssidLen, GFP_KERNEL);
 		memcpy(msg.body.con_info.ssid, pu8ssid, ssidLen);
 	}
 
-	if (pu8IEs != NULL) {
+	if (pu8IEs) {
 		msg.body.con_info.ies_len = IEsLen;
 		msg.body.con_info.ies = kmalloc(IEsLen, GFP_KERNEL);
 		memcpy(msg.body.con_info.ies, pu8IEs, IEsLen);
@@ -3865,8 +3862,7 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 
 	down(&hif_drv->hSemGetRSSI);
 
-
-	if (ps8Rssi == NULL) {
+	if (!ps8Rssi) {
 		PRINT_ER("RSS pointer value is null");
 		return -EFAULT;
 	}
@@ -3893,8 +3889,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 
 	down(&hif_drv->hSemGetLINKSPEED);
 
-
-	if (ps8lnkspd == NULL) {
+	if (!ps8lnkspd) {
 		PRINT_ER("LINKSPEED pointer value is null");
 		return -EFAULT;
 	}
@@ -3933,7 +3928,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	s32 result = 0;
 	struct host_if_msg msg;
 
-	if (!hif_drv || ScanResult == NULL) {
+	if (!hif_drv || !ScanResult) {
 		PRINT_ER("hif_drv or ScanResult = NULL\n");
 		return -EFAULT;
 	}
@@ -3942,7 +3937,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 
 	msg.id = HOST_IF_MSG_SCAN;
 
-	if (pstrHiddenNetwork != NULL) {
+	if (pstrHiddenNetwork) {
 		msg.body.scan_info.hidden_network.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
 		msg.body.scan_info.hidden_network.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
 
@@ -4535,7 +4530,7 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
 	pstrSetBeaconParam->head_len = u32HeadLen;
 	pstrSetBeaconParam->head = kmemdup(pu8Head, u32HeadLen, GFP_KERNEL);
-	if (pstrSetBeaconParam->head == NULL) {
+	if (!pstrSetBeaconParam->head) {
 		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
@@ -4544,7 +4539,7 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 	if (u32TailLen > 0) {
 		pstrSetBeaconParam->tail = kmemdup(pu8Tail, u32TailLen,
 						   GFP_KERNEL);
-		if (pstrSetBeaconParam->tail == NULL) {
+		if (!pstrSetBeaconParam->tail) {
 			result = -ENOMEM;
 			goto ERRORHANDLER;
 		}
@@ -4611,7 +4606,6 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
-
 		if (!rates)
 			return -ENOMEM;
 
@@ -4643,7 +4637,7 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	msg.id = HOST_IF_MSG_DEL_STATION;
 	msg.drv = hif_drv;
 
-	if (pu8MacAddr == NULL)
+	if (!pu8MacAddr)
 		memset(pstrDelStationMsg->mac_addr, 255, ETH_ALEN);
 	else
 		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
@@ -4728,7 +4722,6 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
-
 		if (!rates)
 			return -ENOMEM;
 
@@ -4823,7 +4816,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	u16IEsLen = ptstrNetworkInfo->u16IEsLen;
 
 	pNewJoinBssParam = kzalloc(sizeof(struct join_bss_param), GFP_KERNEL);
-	if (pNewJoinBssParam != NULL) {
+	if (pNewJoinBssParam) {
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->u16CapInfo;
@@ -4967,7 +4960,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 
 void host_int_freeJoinParams(void *pJoinParams)
 {
-	if ((struct bss_param *)pJoinParams != NULL)
+	if ((struct bss_param *)pJoinParams)
 		kfree((struct bss_param *)pJoinParams);
 	else
 		PRINT_ER("Unable to FREE null pointer\n");
-- 
1.9.1

