Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47550 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526AbcBACOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 21:14:31 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 6/7] staging: wilc1000: remove unused log message using the HOSTINF_DBG tag
Date: Mon, 1 Feb 2016 11:11:24 +0900
Message-ID: <1454292685-12294-6-git-send-email-leo.kim@atmel.com> (sfid-20160201_031435_682288_716F7ECE)
In-Reply-To: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
References: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove unused log message using the HOSTINF_DBG tag

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 198 +---------------------
 drivers/staging/wilc1000/linux_wlan_common.h      |   2 -
 drivers/staging/wilc1000/wilc_debugfs.c           |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   2 -
 4 files changed, 10 insertions(+), 194 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ad54db2..e6a6a03 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -309,8 +309,6 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 	wid.val = (char *)&hif_set_ch->set_ch;
 	wid.size = sizeof(char);
 
-	PRINT_D(HOSTINF_DBG, "Setting channel\n");
-
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
@@ -386,9 +384,6 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	if (ip_addr[0] < 192)
 		ip_addr[0] = 0;
 
-	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n",
-		   idx, ip_addr);
-
 	memcpy(set_ip[idx], ip_addr, IP_ALEN);
 
 	wid.id = (u16)WID_IP_ADDRESS;
@@ -406,8 +401,6 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 		return -EINVAL;
 	}
 
-	PRINT_INFO(HOSTINF_DBG, "IP address set\n");
-
 	return result;
 }
 
@@ -424,8 +417,6 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
-	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
-
 	memcpy(get_ip[idx], wid.val, IP_ALEN);
 
 	kfree(wid.val);
@@ -438,10 +429,6 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 		return -EINVAL;
 	}
 
-	PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d\n", idx);
-	PRINT_INFO(HOSTINF_DBG, "%pI4\n", get_ip[idx]);
-	PRINT_INFO(HOSTINF_DBG, "\n");
-
 	return result;
 }
 
@@ -508,8 +495,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 
 	down(&hif_drv->sem_cfg_values);
 
-	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
-
 	if (cfg_param_attr->cfg_attr_info.flag & BSS_TYPE) {
 		if (cfg_param_attr->cfg_attr_info.bss_type < 6) {
 			wid_list[wid_cnt].id = WID_BSS_TYPE;
@@ -814,9 +799,6 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 	u8 *pu8HdnNtwrksWidVal = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
-	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->hif_state);
-
 	hif_drv->usr_scan_req.scan_result = pstrHostIFscanAttr->result;
 	hif_drv->usr_scan_req.arg = pstrHostIFscanAttr->arg;
 
@@ -836,8 +818,6 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 		goto ERRORHANDLER;
 	}
 
-	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
-
 	hif_drv->usr_scan_req.rcvd_ch_cnt = 0;
 
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
@@ -852,8 +832,6 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 
 		*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.u8ssidnum;
 
-		PRINT_D(HOSTINF_DBG, "In Handle_ProbeRequest number of ssid %d\n", pstrHostIFscanAttr->hidden_network.u8ssidnum);
-
 		for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++) {
 			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
 			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].pu8ssid, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen);
@@ -912,8 +890,6 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
-	else
-		PRINT_D(HOSTINF_DBG, "Successfully sent SCAN params config packet\n");
 
 ERRORHANDLER:
 	if (result) {
@@ -942,8 +918,6 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
-
 	if (enuEvent == SCAN_EVENT_ABORTED) {
 		PRINT_D(GENERIC_DBG, "Abort running scan\n");
 		u8abort_running_scan = 1;
@@ -994,8 +968,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		return result;
 	}
 
-	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
-
 	ptstrJoinBssParam = (struct join_bss_param *)pstrHostIFconnectAttr->params;
 	if (!ptstrJoinBssParam) {
 		PRINT_ER("Required BSSID not found\n");
@@ -1071,8 +1043,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
 		mode_11i = hif_drv->usr_conn_req.u8security;
 
-	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", hif_drv->usr_conn_req.u8security);
-
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
@@ -1082,11 +1052,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
 		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
 
-	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n",
-		   hif_drv->usr_conn_req.auth_type);
-	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
-		hif_drv->usr_conn_req.pu8ssid, pstrHostIFconnectAttr->ch);
-
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
 	strWIDList[u32WidsCount].size = 112;
@@ -1118,7 +1083,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	}
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->cap_info) & 0xFF;
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
-	PRINT_D(HOSTINF_DBG, "* Cap Info %0x*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
 
 	if (pstrHostIFconnectAttr->bssid)
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->bssid, 6);
@@ -1130,26 +1094,20 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->beacon_period) >> 8) & 0xFF;
-	PRINT_D(HOSTINF_DBG, "* Beacon Period %d*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->dtim_period;
-	PRINT_D(HOSTINF_DBG, "* DTIM Period %d*\n", (*(pu8CurrByte - 1)));
 
 	memcpy(pu8CurrByte, ptstrJoinBssParam->supp_rates, MAX_RATES_SUPPORTED + 1);
 	pu8CurrByte += (MAX_RATES_SUPPORTED + 1);
 
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->wmm_cap;
-	PRINT_D(HOSTINF_DBG, "* wmm cap%d*\n", (*(pu8CurrByte - 1)));
 	*(pu8CurrByte++)  = ptstrJoinBssParam->uapsd_cap;
 
 	*(pu8CurrByte++)  = ptstrJoinBssParam->ht_capable;
 	hif_drv->usr_conn_req.ht_capable = ptstrJoinBssParam->ht_capable;
 
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_found;
-	PRINT_D(HOSTINF_DBG, "* rsn found %d*\n", *(pu8CurrByte - 1));
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_grp_policy;
-	PRINT_D(HOSTINF_DBG, "* rsn group policy %0x*\n", (*(pu8CurrByte - 1)));
 	*(pu8CurrByte++) =  ptstrJoinBssParam->mode_802_11i;
-	PRINT_D(HOSTINF_DBG, "* mode_802_11i %d*\n", (*(pu8CurrByte - 1)));
 
 	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_pcip_policy, sizeof(ptstrJoinBssParam->rsn_pcip_policy));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_pcip_policy);
@@ -1164,8 +1122,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	*(pu8CurrByte++) = ptstrJoinBssParam->noa_enabled;
 
 	if (ptstrJoinBssParam->noa_enabled) {
-		PRINT_D(HOSTINF_DBG, "NOA present\n");
-
 		*(pu8CurrByte++) = (ptstrJoinBssParam->tsf) & 0xFF;
 		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 8) & 0xFF;
 		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 16) & 0xFF;
@@ -1187,8 +1143,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 		memcpy(pu8CurrByte, ptstrJoinBssParam->start_time, sizeof(ptstrJoinBssParam->start_time));
 		pu8CurrByte += sizeof(ptstrJoinBssParam->start_time);
-	} else
-		PRINT_D(HOSTINF_DBG, "NOA not present\n");
+	}
 
 	pu8CurrByte = strWIDList[u32WidsCount].val;
 	u32WidsCount++;
@@ -1198,8 +1153,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		join_req_vif = vif;
 	}
 
-	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
-
 	if (pstrHostIFconnectAttr->bssid) {
 		memcpy(wilc_connected_ssid,
 		       pstrHostIFconnectAttr->bssid, ETH_ALEN);
@@ -1226,8 +1179,6 @@ ERRORHANDLER:
 
 		del_timer(&hif_drv->connect_timer);
 
-		PRINT_D(HOSTINF_DBG, "could not start wilc_connecting to the required network\n");
-
 		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 		if (pstrHostIFconnectAttr->result) {
@@ -1256,7 +1207,6 @@ ERRORHANDLER:
 		}
 	}
 
-	PRINT_D(HOSTINF_DBG, "Deallocating connection parameters\n");
 	kfree(pstrHostIFconnectAttr->bssid);
 	pstrHostIFconnectAttr->bssid = NULL;
 
@@ -1367,8 +1317,6 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 	wid.val = (s8 *)&u16DummyReasonCode;
 	wid.size = sizeof(char);
 
-	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
-
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
@@ -1409,10 +1357,8 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	bNewNtwrkFound = true;
-	PRINT_INFO(HOSTINF_DBG, "Handling received network info\n");
 
 	if (hif_drv->usr_scan_req.scan_result) {
-		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
 		wilc_parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
 		if ((!pstrNetworkInfo) ||
 		    (!hif_drv->usr_scan_req.scan_result)) {
@@ -1427,7 +1373,6 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 				if (memcmp(hif_drv->usr_scan_req.net_info[i].au8bssid,
 					   pstrNetworkInfo->au8bssid, 6) == 0) {
 					if (pstrNetworkInfo->s8rssi <= hif_drv->usr_scan_req.net_info[i].s8rssi) {
-						PRINT_D(HOSTINF_DBG, "Network previously discovered\n");
 						goto done;
 					} else {
 						hif_drv->usr_scan_req.net_info[i].s8rssi = pstrNetworkInfo->s8rssi;
@@ -1439,8 +1384,6 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 		}
 
 		if (bNewNtwrkFound) {
-			PRINT_D(HOSTINF_DBG, "New network found\n");
-
 			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
 				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].s8rssi = pstrNetworkInfo->s8rssi;
 
@@ -1458,8 +1401,6 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 									  hif_drv->usr_scan_req.arg,
 									  pJoinParams);
 				}
-			} else {
-				PRINT_WRN(HOSTINF_DBG, "Discovered networks exceeded max. limit\n");
 			}
 		} else {
 			pstrNetworkInfo->bNewNetwork = false;
@@ -1532,13 +1473,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 		u8MacStatus  = pstrRcvdGnrlAsyncInfo->buffer[7];
 		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->buffer[8];
 		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->buffer[9];
-		PRINT_INFO(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 			u32 u32RcvdAssocRespInfoLen = 0;
 			tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 
-			PRINT_D(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Code = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
-
 			memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 			if (u8MacStatus == MAC_CONNECTED) {
@@ -1549,10 +1487,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
 							    &u32RcvdAssocRespInfoLen);
 
-				PRINT_INFO(HOSTINF_DBG, "Received association response with length = %d\n", u32RcvdAssocRespInfoLen);
-
 				if (u32RcvdAssocRespInfoLen != 0) {
-					PRINT_D(HOSTINF_DBG, "Parsing association response\n");
 					s32Err = wilc_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
 								    &pstrConnectRespInfo);
 					if (s32Err) {
@@ -1561,7 +1496,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->u16ConnectStatus;
 
 						if (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
-							PRINT_INFO(HOSTINF_DBG, "Association response received : Successful connection status\n");
 							if (pstrConnectRespInfo->pu8RespIEs) {
 								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->u16RespIEsLen;
 								strConnectInfo.pu8RespIEs = kmalloc(pstrConnectRespInfo->u16RespIEsLen, GFP_KERNEL);
@@ -1588,7 +1522,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			}
 
 			if (hif_drv->usr_conn_req.pu8bssid) {
-				PRINT_D(HOSTINF_DBG, "Retrieving actual BSSID from AP\n");
 				memcpy(strConnectInfo.au8bssid, hif_drv->usr_conn_req.pu8bssid, 6);
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
@@ -1617,7 +1550,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
 				wilc_set_power_mgmt(vif, 0, 0);
 
-				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
 				hif_drv->hif_state = HOST_IF_CONNECTED;
 
 				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
@@ -1625,7 +1557,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 				mod_timer(&wilc_during_ip_timer,
 					  jiffies + msecs_to_jiffies(10000));
 			} else {
-				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
 				hif_drv->hif_state = HOST_IF_IDLE;
 				scan_while_connected = false;
 			}
@@ -1645,12 +1576,9 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ies = NULL;
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
-			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
-
 			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
 
 			if (hif_drv->usr_scan_req.scan_result) {
-				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
 				del_timer(&hif_drv->scan_timer);
 				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
 			}
@@ -1698,9 +1626,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->usr_scan_req.scan_result)) {
-			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
-			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
-
 			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.scan_result)
 				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
@@ -1729,8 +1654,6 @@ static int Handle_Key(struct wilc_vif *vif,
 	case WEP:
 
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
-			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", pstrHostIFkeyAttr->attr.wep.index);
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
@@ -1767,7 +1690,6 @@ static int Handle_Key(struct wilc_vif *vif,
 						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
-			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send Key\n");
@@ -1789,7 +1711,6 @@ static int Handle_Key(struct wilc_vif *vif,
 						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
-			PRINT_D(HOSTINF_DBG, "Removing key\n");
 			wid.id = (u16)WID_REMOVE_WEP_KEY;
 			wid.type = WID_STR;
 
@@ -1806,8 +1727,6 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
 			wid.size = sizeof(char);
 
-			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
-
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						&wid, 1,
 						wilc_get_vif_idx(vif));
@@ -1849,8 +1768,6 @@ static int Handle_Key(struct wilc_vif *vif,
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
-			PRINT_D(HOSTINF_DBG, "Handling group key(Rx) function\n");
-
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
@@ -1952,9 +1869,6 @@ _WPAPtk_end_case_:
 		break;
 
 	case PMKSA:
-
-		PRINT_D(HOSTINF_DBG, "Handling PMKSA key\n");
-
 		pu8keybuf = kmalloc((pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (!pu8keybuf) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
@@ -1999,8 +1913,6 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 	wid.val = (s8 *)&u16DummyReasonCode;
 	wid.size = sizeof(char);
 
-	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
-
 	wilc_optaining_ip = false;
 	wilc_set_power_mgmt(vif, 0, 0);
 
@@ -2030,10 +1942,8 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 		}
 
 		if (hif_drv->usr_conn_req.conn_result) {
-			if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
-				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
+			if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP)
 				del_timer(&hif_drv->connect_timer);
-			}
 
 			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 							  NULL,
@@ -2078,10 +1988,8 @@ void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
 	if (!vif->hif_drv)
 		return;
 	if ((vif->hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
-	    (vif->hif_drv->hif_state == HOST_IF_CONNECTING)) {
-		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
+	    (vif->hif_drv->hif_state == HOST_IF_CONNECTING))
 		wilc_disconnect(vif, 1);
-	}
 }
 
 static s32 Handle_GetChnl(struct wilc_vif *vif)
@@ -2095,8 +2003,6 @@ static s32 Handle_GetChnl(struct wilc_vif *vif)
 	wid.val = (s8 *)&ch_no;
 	wid.size = sizeof(char);
 
-	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
-
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
@@ -2120,8 +2026,6 @@ static void Handle_GetRssi(struct wilc_vif *vif)
 	wid.val = &rssi;
 	wid.size = sizeof(char);
 
-	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
-
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result) {
@@ -2145,8 +2049,6 @@ static void Handle_GetLinkspeed(struct wilc_vif *vif)
 	wid.val = &link_speed;
 	wid.size = sizeof(char);
 
-	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
-
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result) {
@@ -2264,8 +2166,6 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 	struct wid wid;
 	u8 *pu8CurrByte;
 
-	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
-
 	wid.id = (u16)WID_ADD_BEACON;
 	wid.type = WID_BIN;
 	wid.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->tail_len + 16;
@@ -2328,8 +2228,6 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 
 	pu8CurrByte = wid.val;
 
-	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
-
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
@@ -2343,7 +2241,6 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 
 	pu8CurrByte = pu8Buffer;
 
-	PRINT_D(HOSTINF_DBG, "Packing STA params\n");
 	memcpy(pu8CurrByte, pstrStationParam->bssid, ETH_ALEN);
 	pu8CurrByte +=  ETH_ALEN;
 
@@ -2391,7 +2288,6 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	struct wid wid;
 	u8 *pu8CurrByte;
 
-	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	wid.id = (u16)WID_ADD_STA;
 	wid.type = WID_BIN;
 	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
@@ -2426,8 +2322,6 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 	wid.type = WID_STR;
 	wid.size = (pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1;
 
-	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
-
 	wid.val = kmalloc((pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
@@ -2467,8 +2361,6 @@ static void Handle_DelStation(struct wilc_vif *vif,
 	wid.type = WID_BIN;
 	wid.size = ETH_ALEN;
 
-	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
-
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
@@ -2497,7 +2389,6 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	wid.type = WID_BIN;
 	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
 
-	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
@@ -2551,9 +2442,6 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 		goto ERRORHANDLER;
 	}
 
-	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n",
-		pstrHostIfRemainOnChan->ch);
-
 	u8remain_on_chan_flag = true;
 	wid.id = (u16)WID_REMAIN_ON_CHAN;
 	wid.type = WID_STR;
@@ -2597,10 +2485,6 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 	struct wid wid;
 	u8 *pu8CurrByte;
 
-	PRINT_D(HOSTINF_DBG, "Handling frame register : %d FrameType: %d\n",
-		pstrHostIfRegisterFrame->reg,
-		pstrHostIfRegisterFrame->frame_type);
-
 	wid.id = (u16)WID_REGISTER_FRAME;
 	wid.type = WID_STR;
 	wid.val = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
@@ -2633,8 +2517,6 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 	s32 result = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
-
 	if (P2P_LISTEN_STATE) {
 		u8remain_on_chan_flag = false;
 		wid.id = (u16)WID_REMAIN_ON_CHAN;
@@ -2702,12 +2584,10 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 		s8PowerMode = MIN_FAST_PS;
 	else
 		s8PowerMode = NO_POWERSAVE;
-	PRINT_D(HOSTINF_DBG, "Handling power mgmt to %d\n", s8PowerMode);
+
 	wid.val = &s8PowerMode;
 	wid.size = sizeof(char);
 
-	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
-
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 	if (result)
@@ -2721,8 +2601,6 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 	struct wid wid;
 	u8 *pu8CurrByte;
 
-	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
-
 	wid.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	wid.type = WID_BIN;
 	wid.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->cnt) * ETH_ALEN);
@@ -2783,8 +2661,6 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
-	if (result)
-		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
 	kfree(wid.val);
 
@@ -2853,7 +2729,6 @@ static int hostIFthread(void *pvArg)
 
 		if (msg.id == HOST_IF_MSG_CONNECT &&
 		    vif->hif_drv->usr_scan_req.scan_result) {
-			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
 			continue;
@@ -2903,7 +2778,6 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
 			del_timer(&vif->hif_drv->scan_timer);
-			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
 			if (!wilc_wlan_get_num_conn_ifcs(wilc))
 				wilc_chip_sleep_manually(wilc);
@@ -2958,13 +2832,11 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
-			PRINT_D(HOSTINF_DBG, "Scan Timeout\n");
 
 			Handle_ScanDone(msg.vif, SCAN_EVENT_ABORTED);
 			break;
 
 		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-			PRINT_D(HOSTINF_DBG, "Connect Timeout\n");
 			Handle_ConnectTimeout(msg.vif);
 			break;
 
@@ -2982,14 +2854,12 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_IPADDRESS:
-			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
 			handle_set_ip_address(vif,
 					      msg.body.ip_info.ip_addr,
 					      msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
-			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
 			handle_get_ip_address(vif, msg.body.ip_info.idx);
 			break;
 
@@ -3004,12 +2874,10 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
-			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REMAIN_ON_CHAN\n");
 			Handle_RemainOnChan(msg.vif, &msg.body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_REGISTER_FRAME:
-			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REGISTER_FRAME\n");
 			Handle_RegisterFrame(msg.vif, &msg.body.reg_frame);
 			break;
 
@@ -3018,7 +2886,6 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
-			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_MULTICAST_FILTER\n");
 			Handle_SetMulticastFilter(msg.vif, &msg.body.multicast_info);
 			break;
 
@@ -3043,7 +2910,6 @@ static int hostIFthread(void *pvArg)
 		}
 	}
 
-	PRINT_D(HOSTINF_DBG, "Releasing thread exit semaphore\n");
 	up(&hif_sema_thread);
 	return 0;
 }
@@ -3690,9 +3556,7 @@ s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	if (pstrHiddenNetwork) {
 		msg.body.scan_info.hidden_network.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
 		msg.body.scan_info.hidden_network.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
-
-	} else
-		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
+	}
 
 	msg.vif = vif;
 	msg.body.scan_info.src = u8ScanSource;
@@ -3714,7 +3578,6 @@ s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 		return -EINVAL;
 	}
 
-	PRINT_D(HOSTINF_DBG, ">> Starting the SCAN timer\n");
 	hif_drv->scan_timer.data = (unsigned long)vif;
 	mod_timer(&hif_drv->scan_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
@@ -3771,8 +3634,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
-
 	scan_while_connected = false;
 
 	sema_init(&hif_sema_wait_response, 0);
@@ -3791,7 +3652,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	wilc_optaining_ip = false;
 
-	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", hif_drv);
 	if (clients_count == 0)	{
 		sema_init(&hif_sema_thread, 0);
 		sema_init(&hif_sema_driver, 0);
@@ -3805,8 +3665,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	sema_init(&hif_drv->sem_get_chnl, 0);
 	sema_init(&hif_drv->sem_inactive_time, 0);
 
-	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
-
 	if (clients_count == 0)	{
 		result = wilc_mq_create(&hif_msg_q);
 
@@ -3844,13 +3702,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	hif_drv->p2p_timeout = 0;
 
-	PRINT_INFO(HOSTINF_DBG, "Initialization values, Site survey value: %d\n Scan source: %d\n Active scan time: %d\n Passive scan time: %d\nCurrent tx Rate = %d\n",
-		   hif_drv->cfg_values.site_survey_enabled,
-		   hif_drv->cfg_values.scan_source,
-		   hif_drv->cfg_values.active_scan_time,
-		   hif_drv->cfg_values.passive_scan_time,
-		   hif_drv->cfg_values.curr_tx_rate);
-
 	up(&hif_drv->sem_cfg_values);
 
 	clients_count++;
@@ -3877,17 +3728,10 @@ s32 wilc_deinit(struct wilc_vif *vif)
 	down(&hif_sema_deinit);
 
 	terminated_handle = hif_drv;
-	PRINT_D(HOSTINF_DBG, "De-initializing host interface for client %d\n", clients_count);
-
-	if (del_timer_sync(&hif_drv->scan_timer))
-		PRINT_D(HOSTINF_DBG, ">> Scan timer is active\n");
-
-	if (del_timer_sync(&hif_drv->connect_timer))
-		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-
-	if (del_timer_sync(&periodic_rssi))
-		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 
+	del_timer_sync(&hif_drv->scan_timer);
+	del_timer_sync(&hif_drv->connect_timer);
+	del_timer_sync(&periodic_rssi);
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
 	wilc_set_wfi_drv_handler(vif, 0, 0);
@@ -3906,9 +3750,7 @@ s32 wilc_deinit(struct wilc_vif *vif)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
-		if (del_timer_sync(&periodic_rssi))
-			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-
+		del_timer_sync(&periodic_rssi);
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.vif = vif;
 
@@ -3982,10 +3824,8 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	}
 
 	hif_drv = vif->hif_drv;
-	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received\n");
 
 	if (!hif_drv || hif_drv == terminated_handle) {
-		PRINT_D(HOSTINF_DBG, "Wifi driver handler is equal to NULL\n");
 		up(&hif_sema_deinit);
 		return;
 	}
@@ -4120,17 +3960,14 @@ s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
 	msg.id = HOST_IF_MSG_REGISTER_FRAME;
 	switch (u16FrameType) {
 	case ACTION:
-		PRINT_D(HOSTINF_DBG, "ACTION\n");
 		msg.body.reg_frame.reg_id = ACTION_FRM_IDX;
 		break;
 
 	case PROBE_REQ:
-		PRINT_D(HOSTINF_DBG, "PROBE REQ\n");
 		msg.body.reg_frame.reg_id = PROBE_REQ_IDX;
 		break;
 
 	default:
-		PRINT_D(HOSTINF_DBG, "Not valid frame type\n");
 		break;
 	}
 	msg.body.reg_frame.frame_type = u16FrameType;
@@ -4159,8 +3996,6 @@ s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
-
 	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.vif = vif;
 	pstrSetBeaconParam->interval = u32Interval;
@@ -4211,7 +4046,6 @@ int wilc_del_beacon(struct wilc_vif *vif)
 
 	msg.id = HOST_IF_MSG_DEL_BEACON;
 	msg.vif = vif;
-	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -4234,8 +4068,6 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	PRINT_D(HOSTINF_DBG, "Setting adding station message queue params\n");
-
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.vif = vif;
 
@@ -4268,8 +4100,6 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	PRINT_D(HOSTINF_DBG, "Setting deleting station message queue params\n");
-
 	msg.id = HOST_IF_MSG_DEL_STATION;
 	msg.vif = vif;
 
@@ -4301,8 +4131,6 @@ s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
-
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
 	msg.vif = vif;
 
@@ -4348,8 +4176,6 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 		return -EFAULT;
 	}
 
-	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_EDIT_STATION;
@@ -4381,8 +4207,6 @@ s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
 	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
-
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
@@ -4391,8 +4215,6 @@ s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
 	if (wilc_wlan_get_num_conn_ifcs(vif->wilc) == 2 && bIsEnabled)
 		return 0;
 
-	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_POWER_MGMT;
@@ -4420,8 +4242,6 @@ s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 		return -EFAULT;
 	}
 
-	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 5e1d3ad..5374f36 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -4,7 +4,6 @@
 enum debug_region {
 	Generic_debug = 0,
 	Hostapd_debug,
-	Hostinf_debug,
 	CFG80211_debug,
 	Interrupt_debug,
 	TX_debug,
@@ -22,7 +21,6 @@ enum debug_region {
 
 #define GENERIC_DBG             (1 << Generic_debug)
 #define HOSTAPD_DBG             (1 << Hostapd_debug)
-#define HOSTINF_DBG             (1 << Hostinf_debug)
 #define CFG80211_DBG            (1 << CFG80211_debug)
 #define INT_DBG                 (1 << Interrupt_debug)
 #define TX_DBG                  (1 << TX_debug)
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 8d665d9..1e38d1b 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,7 +24,7 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
+#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 07e50ccb..4310abe 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1716,8 +1716,6 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 
 	priv = (struct wilc_priv *)pUserVoid;
 
-	PRINT_D(HOSTINF_DBG, "Remain on channel ready\n");
-
 	priv->bInP2PlistenState = true;
 
 	cfg80211_ready_on_channel(priv->wdev,
-- 
1.9.1

