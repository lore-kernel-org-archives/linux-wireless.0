Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41750 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbbJ1G7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:59:02 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/80] staging: wilc1000: rename strWILC_UsrConnReq of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:34 +0900
Message-ID: <1446015640-29398-14-git-send-email-glen.lee@atmel.com> (sfid-20151028_081702_264751_6549C59B)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strWILC_UsrConnReq of struct host_if_drv to usr_conn_req
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 167 +++++++++++++++---------------
 drivers/staging/wilc1000/host_interface.h |   2 +-
 2 files changed, 84 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2df22e2..ce09879 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1004,31 +1004,31 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 	if (pstrHostIFconnectAttr->bssid) {
-		hif_drv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->bssid, 6);
+		hif_drv->usr_conn_req.pu8bssid = kmalloc(6, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.pu8bssid, pstrHostIFconnectAttr->bssid, 6);
 	}
 
-	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssid_len;
+	hif_drv->usr_conn_req.ssidLen = pstrHostIFconnectAttr->ssid_len;
 	if (pstrHostIFconnectAttr->ssid) {
-		hif_drv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid,
+		hif_drv->usr_conn_req.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.pu8ssid,
 		       pstrHostIFconnectAttr->ssid,
 		       pstrHostIFconnectAttr->ssid_len);
-		hif_drv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
+		hif_drv->usr_conn_req.pu8ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
 
-	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->ies_len;
+	hif_drv->usr_conn_req.ConnReqIEsLen = pstrHostIFconnectAttr->ies_len;
 	if (pstrHostIFconnectAttr->ies) {
-		hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
+		hif_drv->usr_conn_req.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.pu8ConnReqIEs,
 		       pstrHostIFconnectAttr->ies,
 		       pstrHostIFconnectAttr->ies_len);
 	}
 
-	hif_drv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->security;
-	hif_drv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->auth_type;
-	hif_drv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->result;
-	hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->arg;
+	hif_drv->usr_conn_req.u8security = pstrHostIFconnectAttr->security;
+	hif_drv->usr_conn_req.tenuAuth_type = pstrHostIFconnectAttr->auth_type;
+	hif_drv->usr_conn_req.pfUserConnectResult = pstrHostIFconnectAttr->result;
+	hif_drv->usr_conn_req.u32UserConnectPvoid = pstrHostIFconnectAttr->arg;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
@@ -1051,40 +1051,40 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	{
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].val = hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs;
-		strWIDList[u32WidsCount].size = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
+		strWIDList[u32WidsCount].val = hif_drv->usr_conn_req.pu8ConnReqIEs;
+		strWIDList[u32WidsCount].size = hif_drv->usr_conn_req.ConnReqIEsLen;
 		u32WidsCount++;
 
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-			info_element_size = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
+			info_element_size = hif_drv->usr_conn_req.ConnReqIEsLen;
 			info_element = kmalloc(info_element_size, GFP_KERNEL);
-			memcpy(info_element, hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
+			memcpy(info_element, hif_drv->usr_conn_req.pu8ConnReqIEs,
 			       info_element_size);
 		}
 	}
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&hif_drv->strWILC_UsrConnReq.u8security;
+	strWIDList[u32WidsCount].val = (s8 *)&hif_drv->usr_conn_req.u8security;
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
-		mode_11i = hif_drv->strWILC_UsrConnReq.u8security;
+		mode_11i = hif_drv->usr_conn_req.u8security;
 
-	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", hif_drv->strWILC_UsrConnReq.u8security);
+	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", hif_drv->usr_conn_req.u8security);
 
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&hif_drv->strWILC_UsrConnReq.tenuAuth_type);
+	strWIDList[u32WidsCount].val = (s8 *)(&hif_drv->usr_conn_req.tenuAuth_type);
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
-		auth_type = (u8)hif_drv->strWILC_UsrConnReq.tenuAuth_type;
+		auth_type = (u8)hif_drv->usr_conn_req.tenuAuth_type;
 
-	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->strWILC_UsrConnReq.tenuAuth_type);
+	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->usr_conn_req.tenuAuth_type);
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
-		hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->ch);
+		hif_drv->usr_conn_req.pu8ssid, pstrHostIFconnectAttr->ch);
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
@@ -1141,7 +1141,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	*(pu8CurrByte++)  = ptstrJoinBssParam->uapsd_cap;
 
 	*(pu8CurrByte++)  = ptstrJoinBssParam->ht_capable;
-	hif_drv->strWILC_UsrConnReq.IsHTCapable = ptstrJoinBssParam->ht_capable;
+	hif_drv->usr_conn_req.IsHTCapable = ptstrJoinBssParam->ht_capable;
 
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_found;
 	PRINT_D(HOSTINF_DBG, "* rsn found %d*\n", *(pu8CurrByte - 1));
@@ -1331,25 +1331,25 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
-	if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
-		if (hif_drv->strWILC_UsrConnReq.pu8bssid) {
+	if (hif_drv->usr_conn_req.pfUserConnectResult) {
+		if (hif_drv->usr_conn_req.pu8bssid) {
 			memcpy(strConnectInfo.au8bssid,
-			       hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
+			       hif_drv->usr_conn_req.pu8bssid, 6);
 		}
 
-		if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs) {
-			strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
-			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
+		if (hif_drv->usr_conn_req.pu8ConnReqIEs) {
+			strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ConnReqIEsLen;
+			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ConnReqIEsLen, GFP_KERNEL);
 			memcpy(strConnectInfo.pu8ReqIEs,
-			       hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
-			       hif_drv->strWILC_UsrConnReq.ConnReqIEsLen);
+			       hif_drv->usr_conn_req.pu8ConnReqIEs,
+			       hif_drv->usr_conn_req.ConnReqIEsLen);
 		}
 
-		hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
-								   &strConnectInfo,
-								   MAC_DISCONNECTED,
-								   NULL,
-								   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
+		hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
+							  &strConnectInfo,
+							  MAC_DISCONNECTED,
+							  NULL,
+							  hif_drv->usr_conn_req.u32UserConnectPvoid);
 
 		kfree(strConnectInfo.pu8ReqIEs);
 		strConnectInfo.pu8ReqIEs = NULL;
@@ -1369,11 +1369,11 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
-	hif_drv->strWILC_UsrConnReq.ssidLen = 0;
-	kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
-	kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
-	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-	kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
+	hif_drv->usr_conn_req.ssidLen = 0;
+	kfree(hif_drv->usr_conn_req.pu8ssid);
+	kfree(hif_drv->usr_conn_req.pu8bssid);
+	hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+	kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
 
 	eth_zero_addr(u8ConnectedSSID);
 
@@ -1498,7 +1498,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 	    (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) ||
 	    hif_drv->usr_scan_req.pfUserScanResult) {
 		if (!pstrRcvdGnrlAsyncInfo->buffer ||
-		    !hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
+		    !hif_drv->usr_conn_req.pfUserConnectResult) {
 			PRINT_ER("driver is null\n");
 			return -EINVAL;
 		}
@@ -1573,31 +1573,31 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				eth_zero_addr(u8ConnectedSSID);
 			}
 
-			if (hif_drv->strWILC_UsrConnReq.pu8bssid) {
+			if (hif_drv->usr_conn_req.pu8bssid) {
 				PRINT_D(HOSTINF_DBG, "Retrieving actual BSSID from AP\n");
-				memcpy(strConnectInfo.au8bssid, hif_drv->strWILC_UsrConnReq.pu8bssid, 6);
+				memcpy(strConnectInfo.au8bssid, hif_drv->usr_conn_req.pu8bssid, 6);
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
 				    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
 					memcpy(hif_drv->au8AssociatedBSSID,
-						    hif_drv->strWILC_UsrConnReq.pu8bssid, ETH_ALEN);
+					       hif_drv->usr_conn_req.pu8bssid, ETH_ALEN);
 				}
 			}
 
-			if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs) {
-				strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
-				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
+			if (hif_drv->usr_conn_req.pu8ConnReqIEs) {
+				strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ConnReqIEsLen;
+				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ConnReqIEsLen, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
-					    hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
-					    hif_drv->strWILC_UsrConnReq.ConnReqIEsLen);
+				       hif_drv->usr_conn_req.pu8ConnReqIEs,
+				       hif_drv->usr_conn_req.ConnReqIEsLen);
 			}
 
 			del_timer(&hif_drv->hConnectTimer);
-			hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
-									   &strConnectInfo,
-									   u8MacStatus,
-									   NULL,
-									   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
+			hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
+								  &strConnectInfo,
+								  u8MacStatus,
+								  NULL,
+								  hif_drv->usr_conn_req.u32UserConnectPvoid);
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
@@ -1621,11 +1621,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			kfree(strConnectInfo.pu8ReqIEs);
 			strConnectInfo.pu8ReqIEs = NULL;
-			hif_drv->strWILC_UsrConnReq.ssidLen = 0;
-			kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
-			kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
-			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
+			hif_drv->usr_conn_req.ssidLen = 0;
+			kfree(hif_drv->usr_conn_req.pu8ssid);
+			kfree(hif_drv->usr_conn_req.pu8bssid);
+			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+			kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
@@ -1642,27 +1642,26 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			strDisconnectNotifInfo.ie = NULL;
 			strDisconnectNotifInfo.ie_len = 0;
 
-			if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
+			if (hif_drv->usr_conn_req.pfUserConnectResult) {
 				g_obtainingIP = false;
 				host_int_set_power_mgmt(hif_drv, 0, 0);
 
-				hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
-										   NULL,
-										   0,
-										   &strDisconnectNotifInfo,
-										   hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
-
+				hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
+									  NULL,
+									  0,
+									  &strDisconnectNotifInfo,
+									  hif_drv->usr_conn_req.u32UserConnectPvoid);
 			} else {
 				PRINT_ER("Connect result callback function is NULL\n");
 			}
 
 			eth_zero_addr(hif_drv->au8AssociatedBSSID);
 
-			hif_drv->strWILC_UsrConnReq.ssidLen = 0;
-			kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
-			kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
-			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
+			hif_drv->usr_conn_req.ssidLen = 0;
+			kfree(hif_drv->usr_conn_req.pu8ssid);
+			kfree(hif_drv->usr_conn_req.pu8bssid);
+			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+			kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
 
 			if (join_req && join_req_drv == hif_drv) {
 				kfree(join_req);
@@ -2005,16 +2004,16 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 			hif_drv->usr_scan_req.pfUserScanResult = NULL;
 		}
 
-		if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
+		if (hif_drv->usr_conn_req.pfUserConnectResult) {
 			if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
 				del_timer(&hif_drv->hConnectTimer);
 			}
 
-			hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
-									   0, &strDisconnectNotifInfo, hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid);
+			hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
+								  0, &strDisconnectNotifInfo, hif_drv->usr_conn_req.u32UserConnectPvoid);
 		} else {
-			PRINT_ER("strWILC_UsrConnReq.pfUserConnectResult = NULL\n");
+			PRINT_ER("usr_conn_req.pfUserConnectResult = NULL\n");
 		}
 
 		scan_while_connected = false;
@@ -2023,11 +2022,11 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 		eth_zero_addr(hif_drv->au8AssociatedBSSID);
 
-		hif_drv->strWILC_UsrConnReq.ssidLen = 0;
-		kfree(hif_drv->strWILC_UsrConnReq.pu8ssid);
-		kfree(hif_drv->strWILC_UsrConnReq.pu8bssid);
-		hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
-		kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
+		hif_drv->usr_conn_req.ssidLen = 0;
+		kfree(hif_drv->usr_conn_req.pu8ssid);
+		kfree(hif_drv->usr_conn_req.pu8bssid);
+		hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+		kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
 
 		if (join_req && join_req_drv == hif_drv) {
 			kfree(join_req);
@@ -4292,7 +4291,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		return;
 	}
 
-	if (!hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
+	if (!hif_drv->usr_conn_req.pfUserConnectResult) {
 		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
 		up(&hif_sema_deinit);
 		return;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fc9e96c..e9bc83a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -293,7 +293,7 @@ enum p2p_listen_state {
 
 struct host_if_drv {
 	struct user_scan_req usr_scan_req;
-	struct user_conn_req strWILC_UsrConnReq;
+	struct user_conn_req usr_conn_req;
 
 	/*Remain on channel struvture*/
 	struct remain_ch strHostIfRemainOnChan;
-- 
1.9.1

