Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41527 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbbJ1G5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:57:55 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/80] staging: wilc1000: fixes blank lines aren't necessary brace
Date: Wed, 28 Oct 2015 15:59:23 +0900
Message-ID: <1446015640-29398-3-git-send-email-glen.lee@atmel.com> (sfid-20151028_075758_242019_90BF8F47)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for Blank lines aren't necessary after an open brace '{' and
Blank lines aren't necessary before a close brace '}'.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 33 -------------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 47064fe..74f1f9d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -615,7 +615,6 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & FRAG_THRESHOLD) {
-
 		if (strHostIFCfgParamAttr->cfg_attr_info.frag_threshold > 255 && strHostIFCfgParamAttr->cfg_attr_info.frag_threshold < 7937) {
 			strWIDList[u8WidCnt].id = WID_FRAG_THRESHOLD;
 			strWIDList[u8WidCnt].val = (s8 *)&strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
@@ -1422,7 +1421,6 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 		}
 
 		for (i = 0; i < hif_drv->strWILC_UsrScanReq.u32RcvdChCount; i++) {
-
 			if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid) &&
 			    (pstrNetworkInfo->au8bssid)) {
 				if (memcmp(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid,
@@ -1458,8 +1456,6 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 					hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
 											hif_drv->strWILC_UsrScanReq.u32UserScanPvoid,
 											pJoinParams);
-
-
 				}
 			} else {
 				PRINT_WRN(HOSTINF_DBG, "Discovered networks exceeded max. limit\n");
@@ -1549,7 +1545,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				PRINT_INFO(HOSTINF_DBG, "Received association response with length = %d\n", u32RcvdAssocRespInfoLen);
 
 				if (u32RcvdAssocRespInfoLen != 0) {
-
 					PRINT_D(HOSTINF_DBG, "Parsing association response\n");
 					s32Err = ParseAssocRespInfo(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
 								    &pstrConnectRespInfo);
@@ -1702,9 +1697,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			del_timer(&hif_drv->hScanTimer);
 			if (hif_drv->strWILC_UsrScanReq.pfUserScanResult)
 				Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
-
 		}
-
 	}
 
 	kfree(pstrRcvdGnrlAsyncInfo->buffer);
@@ -1725,12 +1718,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 	s8 ret = 0;
 
 	switch (pstrHostIFkeyAttr->type) {
-
-
 	case WEP:
 
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
-
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", pstrHostIFkeyAttr->attr.wep.index);
 			strWIDList[0].id = (u16)WID_11I_MODE;
@@ -1768,8 +1758,6 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			result = send_config_pkt(SET_CFG, strWIDList, 4,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
-
-
 		}
 
 		if (pstrHostIFkeyAttr->action & ADDKEY) {
@@ -1794,7 +1782,6 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
-
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
 			strWID.id = (u16)WID_REMOVE_WEP_KEY;
 			strWID.type = WID_STR;
@@ -1895,14 +1882,11 @@ _WPARxGtk_end_case_:
 
 	case WPAPtk:
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
-
-
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send PTK Key\n");
 				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
-
 			}
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
@@ -1927,14 +1911,11 @@ _WPARxGtk_end_case_:
 			up(&hif_drv->hSemTestKeyBlock);
 		}
 		if (pstrHostIFkeyAttr->action & ADDKEY) {
-
-
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send PTK Key\n");
 				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
-
 			}
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
@@ -2072,7 +2053,6 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 			kfree(info_element);
 			info_element = NULL;
 		}
-
 	}
 
 	up(&hif_drv->hSemTestDisconnectBlock);
@@ -2134,8 +2114,6 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 	}
 
 	up(&hif_drv->hSemGetRSSI);
-
-
 }
 
 
@@ -2206,7 +2184,6 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 
 	up(&hif_sema_wait_response);
 	return 0;
-
 }
 
 static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
@@ -2744,7 +2721,6 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 
 ERRORHANDLER:
 	kfree(strWID.val);
-
 }
 
 static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
@@ -2810,7 +2786,6 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	kfree(strWID.val);
 
 	return result;
-
 }
 
 static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
@@ -3842,7 +3817,6 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 		return -EINVAL;
 	} else {
 		PRINT_D(HOSTINF_DBG, "Successfully got wid value\n");
-
 	}
 
 	return result;
@@ -4009,7 +3983,6 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 	}
 	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
 	switch (u16WID)	{
-
 	case WID_BSS_TYPE:
 		*pu16WID_Value = (u16)hif_drv->strCfgValues.bss_type;
 		break;
@@ -4416,7 +4389,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	return;
-
 }
 
 s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
@@ -4566,7 +4538,6 @@ ERRORHANDLER:
 	}
 
 	return result;
-
 }
 
 s32 host_int_del_beacon(struct host_if_drv *hif_drv)
@@ -4955,14 +4926,10 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				continue;
 			} else
 				index += pu8IEs[index + 1] + 2;
-
 		}
-
-
 	}
 
 	return (void *)pNewJoinBssParam;
-
 }
 
 void host_int_freeJoinParams(void *pJoinParams)
-- 
1.9.1

