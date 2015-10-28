Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41564 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbbJ1G6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:07 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/80] staging: wilc1000: fixes please don't use multiple blank lines
Date: Wed, 28 Oct 2015 15:59:25 +0900
Message-ID: <1446015640-29398-5-git-send-email-glen.lee@atmel.com> (sfid-20151028_075811_641313_944BCC03)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for Please don't use multiple blank lines.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 39 -------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 15278f7..c3826eb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -527,7 +527,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 
 	down(&hif_drv->gtOsCfgValuesSem);
 
-
 	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
 
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & BSS_TYPE) {
@@ -842,7 +841,6 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 
-
 	hif_drv->strWILC_UsrScanReq.u32RcvdChCount = 0;
 
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
@@ -865,8 +863,6 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 			pu8Buffer += pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
 		}
 
-
-
 		strWIDList[u32WidsCount].size = (s32)(valuesize + 1);
 		u32WidsCount++;
 	}
@@ -947,7 +943,6 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 	u8 u8abort_running_scan;
 	struct wid strWID;
 
-
 	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
 
 	if (enuEvent == SCAN_EVENT_ABORTED) {
@@ -1078,7 +1073,6 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", hif_drv->strWILC_UsrConnReq.u8security);
 
-
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
@@ -1294,8 +1288,6 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	strWIDList[u32WidsCount].val = (s8 *)(&(mode_11i));
 	u32WidsCount++;
 
-
-
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
@@ -1559,8 +1551,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 							PRINT_INFO(HOSTINF_DBG, "Association response received : Successful connection status\n");
 							if (pstrConnectRespInfo->pu8RespIEs) {
 								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->u16RespIEsLen;
-
-
 								strConnectInfo.pu8RespIEs = kmalloc(pstrConnectRespInfo->u16RespIEsLen, GFP_KERNEL);
 								memcpy(strConnectInfo.pu8RespIEs, pstrConnectRespInfo->pu8RespIEs,
 									    pstrConnectRespInfo->u16RespIEsLen);
@@ -1596,7 +1586,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				}
 			}
 
-
 			if (hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs) {
 				strConnectInfo.ReqIEsLen = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
@@ -1605,7 +1594,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 					    hif_drv->strWILC_UsrConnReq.ConnReqIEsLen);
 			}
 
-
 			del_timer(&hif_drv->hConnectTimer);
 			hif_drv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
 									   &strConnectInfo,
@@ -1943,7 +1931,6 @@ _WPAPtk_end_case_:
 
 		break;
 
-
 	case PMKSA:
 
 		PRINT_D(HOSTINF_DBG, "Handling PMKSA key\n");
@@ -1991,8 +1978,6 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 	strWID.val = (s8 *)&u16DummyReasonCode;
 	strWID.size = sizeof(char);
 
-
-
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	g_obtainingIP = false;
@@ -2060,7 +2045,6 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 	up(&hif_drv->hSemTestDisconnectBlock);
 }
 
-
 void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 {
 	if (!hif_drv)
@@ -2118,7 +2102,6 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 	up(&hif_drv->hSemGetRSSI);
 }
 
-
 static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
@@ -2200,11 +2183,9 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	strWID.size = ETH_ALEN;
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 
-
 	stamac = strWID.val;
 	memcpy(stamac, strHostIfStaInactiveT->mac, ETH_ALEN);
 
-
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2215,7 +2196,6 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 		return -EFAULT;
 	}
 
-
 	strWID.id = (u16)WID_GET_INACTIVE_TIME;
 	strWID.type = WID_INT;
 	strWID.val = (s8 *)&inactive_time;
@@ -2767,7 +2747,6 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
-
 	strWID.id = (u16)WID_11E_P_ACTION_REQ;
 	strWID.type = WID_STR;
 	strWID.size = 15;
@@ -2822,7 +2801,6 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
-
 	kfree(strWID.val);
 
 	up(&hif_sema_wait_response);
@@ -3109,7 +3087,6 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 	int result = 0;
 	struct host_if_msg msg;
 
-
 	if (!hif_drv) {
 		result = -EFAULT;
 		PRINT_ER("driver is null\n");
@@ -3118,7 +3095,6 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = DEFAULTKEY;
@@ -3148,7 +3124,6 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
@@ -3231,7 +3206,6 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WPAPtk;
 	if (mode == AP_MODE) {
@@ -3301,7 +3275,6 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 		memcpy(msg.body.key_info.attr.wpa.seq, KeyRSC, u32KeyRSClen);
 	}
 
-
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WPARxGtk;
 	msg.drv = hif_drv;
@@ -3343,7 +3316,6 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	struct host_if_msg msg;
 	u32 i;
 
-
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
@@ -3957,7 +3929,6 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct host_if_msg msg;
 
-
 	if (!hif_drv) {
 		PRINT_ER("hif_drv NULL\n");
 		return -EFAULT;
@@ -4297,9 +4268,6 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	hif_drv = get_handler_from_id(id);
 
-
-
-
 	if (!hif_drv || hif_drv == terminated_handle)	{
 		PRINT_ER("NetworkInfo received but driver not init[%p]\n", hif_drv);
 		return;
@@ -4332,7 +4300,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	hif_drv = get_handler_from_id(id);
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received\n");
 
-
 	if (!hif_drv || hif_drv == terminated_handle) {
 		PRINT_D(HOSTINF_DBG, "Wifi driver handler is equal to NULL\n");
 		up(&hif_sema_deinit);
@@ -4347,7 +4314,6 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
 	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
 	msg.drv = hif_drv;
 
@@ -4372,7 +4338,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	hif_drv = get_handler_from_id(id);
 
-
 	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", hif_drv);
 
 	if (!hif_drv || hif_drv == terminated_handle)
@@ -4389,7 +4354,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", result);
 	}
 
-
 	return;
 }
 
@@ -4570,7 +4534,6 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
-
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
@@ -4639,7 +4602,6 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 	u32 i;
 	u8 u8AssocNumb = 0;
 
-
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
@@ -4757,7 +4719,6 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 	struct host_if_msg msg;
 	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
 
-
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
-- 
1.9.1

