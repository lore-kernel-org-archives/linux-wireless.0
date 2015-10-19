Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8264 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbJSJ0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:26:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 1/6] staging: wilc1000: rename variable s32Error
Date: Mon, 19 Oct 2015 18:26:08 +0900
Message-ID: <1445246773-22253-2-git-send-email-tony.cho@atmel.com> (sfid-20151019_112639_639441_22C30011)
In-Reply-To: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
References: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable s32Error to result
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 781 ++++++++++++++----------------
 1 file changed, 370 insertions(+), 411 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 38fead4..066123f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -324,8 +324,7 @@ static struct host_if_drv *get_handler_from_id(int id)
 static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 			     struct channel_attr *pstrHostIFSetChan)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
@@ -335,21 +334,21 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+
+	if (result) {
 		PRINT_ER("Failed to set channel\n");
 		return -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 				   struct drv_handler *pstrHostIfSetDrvHandler)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	strWID.id = (u16)WID_SET_DRV_HANDLER;
@@ -357,25 +356,24 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 	strWID.val = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
 	strWID.size = sizeof(u32);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   pstrHostIfSetDrvHandler->u32Address);
 
 	if (!hif_drv)
 		up(&hif_sema_driver);
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set driver handler\n");
 		return -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 				   struct op_mode *pstrHostIfSetOperationMode)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	strWID.id = (u16)WID_SET_OPERATION_MODE;
@@ -383,25 +381,23 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 	strWID.val = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
 	strWID.size = sizeof(u32);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
-
 	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
 		up(&hif_sema_driver);
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set driver handler\n");
 		return -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	char firmwareIPAddress[4] = {0};
 
@@ -417,26 +413,24 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	strWID.val = (u8 *)pu8IPAddr;
 	strWID.size = IP_ALEN;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
-
 	host_int_get_ipaddress(hif_drv, firmwareIPAddress, idx);
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set IP address\n");
 		return -EINVAL;
 	}
 
 	PRINT_INFO(HOSTINF_DBG, "IP address set\n");
 
-	return s32Error;
+	return result;
 }
 
 s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	strWID.id = (u16)WID_IP_ADDRESS;
@@ -444,7 +438,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	strWID.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.size = IP_ALEN;
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.val);
@@ -456,7 +450,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
 		host_int_setup_ipaddress(hif_drv, set_ip[idx], idx);
 
-	if (s32Error != 0) {
+	if (result != 0) {
 		PRINT_ER("Failed to get IP address\n");
 		return -EINVAL;
 	}
@@ -465,14 +459,13 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", get_ip[idx]);
 	PRINT_INFO(HOSTINF_DBG, "\n");
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 				struct set_mac_addr *pstrHostIfSetMacAddress)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
@@ -488,22 +481,21 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	strWID.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.val);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set mac address\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 	kfree(mac_buf);
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 				struct get_mac_addr *pstrHostIfGetMacAddress)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	strWID.id = (u16)WID_MAC_ADDR;
@@ -511,21 +503,22 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 	strWID.val = pstrHostIfGetMacAddress->u8MacAddress;
 	strWID.size = ETH_ALEN;
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+
+	if (result) {
 		PRINT_ER("Failed to get mac address\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 	up(&hif_sema_wait_response);
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			   struct cfg_param_attr *strHostIFCfgParamAttr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWIDList[32];
 	u8 u8WidCnt = 0;
 
@@ -543,7 +536,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -557,7 +550,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->cfg_attr_info.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -571,7 +564,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->cfg_attr_info.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -585,7 +578,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->cfg_attr_info.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -599,7 +592,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -614,7 +607,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->cfg_attr_info.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -629,7 +622,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->cfg_attr_info.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -643,7 +636,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->cfg_attr_info.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -657,7 +650,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.preamble_type = strHostIFCfgParamAttr->cfg_attr_info.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -671,7 +664,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->cfg_attr_info.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -685,7 +678,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -699,7 +692,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->cfg_attr_info.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -713,7 +706,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.dtim_period = strHostIFCfgParamAttr->cfg_attr_info.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -727,7 +720,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->cfg_attr_info.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -741,7 +734,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->cfg_attr_info.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -755,7 +748,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->cfg_attr_info.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -769,7 +762,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->cfg_attr_info.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -789,20 +782,21 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 			hif_drv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			PRINT_ER("out of TX rate\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u8WidCnt,
+
+	result = send_config_pkt(SET_CFG, strWIDList, u8WidCnt,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Error in setting CFG params\n");
 
 ERRORHANDLER:
 	up(&hif_drv->gtOsCfgValuesSem);
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_wait_msg_q_empty(void)
@@ -815,7 +809,7 @@ static s32 Handle_wait_msg_q_empty(void)
 static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0;
 	u32 i;
@@ -832,14 +826,14 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	if ((hif_drv->enuHostIFstate >= HOST_IF_SCANNING) && (hif_drv->enuHostIFstate < HOST_IF_CONNECTED)) {
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", hif_drv->enuHostIFstate);
 		PRINT_ER("Already scan\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		PRINT_ER("Don't do obss scan\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
@@ -915,16 +909,16 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	else if (hif_drv->enuHostIFstate == HOST_IF_IDLE)
 		scan_while_connected = false;
 
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
 	else
 		PRINT_D(HOSTINF_DBG, "Successfully sent SCAN params config packet\n");
 
 ERRORHANDLER:
-	if (s32Error) {
+	if (result) {
 		del_timer(&hif_drv->hScanTimer);
 		Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 	}
@@ -939,13 +933,13 @@ ERRORHANDLER:
 
 	kfree(pu8HdnNtwrksWidVal);
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 			   enum scan_event enuEvent)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 u8abort_running_scan;
 	struct wid strWID;
 
@@ -960,17 +954,18 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		strWID.val = (s8 *)&u8abort_running_scan;
 		strWID.size = sizeof(char);
 
-		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+		result = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(hif_drv));
-		if (s32Error) {
+
+		if (result) {
 			PRINT_ER("Failed to set abort running scan\n");
-			s32Error = -EFAULT;
+			result = -EFAULT;
 		}
 	}
 
 	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
-		return s32Error;
+		return result;
 	}
 
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
@@ -979,14 +974,14 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 u8 u8ConnectedSSID[6] = {0};
 static s32 Handle_Connect(struct host_if_drv *hif_drv,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
 	u8 *pu8CurrByte = NULL;
@@ -995,10 +990,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
 	if (memcmp(pstrHostIFconnectAttr->bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
-
-		s32Error = 0;
+		result = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
-		return s32Error;
+		return result;
 	}
 
 	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
@@ -1006,7 +1000,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	ptstrJoinBssParam = (struct join_bss_param *)pstrHostIFconnectAttr->params;
 	if (ptstrJoinBssParam == NULL) {
 		PRINT_ER("Required BSSID not found\n");
-		s32Error = -ENOENT;
+		result = -ENOENT;
 		goto ERRORHANDLER;
 	}
 
@@ -1102,7 +1096,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		join_req = kmalloc(join_req_size, GFP_KERNEL);
 	}
 	if (strWIDList[u32WidsCount].val == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
@@ -1211,11 +1205,11 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("failed to send config packet\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	} else {
 		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
@@ -1223,7 +1217,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 ERRORHANDLER:
-	if (s32Error) {
+	if (result) {
 		tstrConnectInfo strConnectInfo;
 
 		del_timer(&hif_drv->hConnectTimer);
@@ -1269,12 +1263,12 @@ ERRORHANDLER:
 	pstrHostIFconnectAttr->ies = NULL;
 
 	kfree(pu8CurrByte);
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
@@ -1310,26 +1304,26 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 
 	u32WidsCount++;
 
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(join_req_drv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("failed to send config packet\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrConnectInfo strConnectInfo;
 	struct wid strWID;
 	u16 u16DummyReasonCode = 0;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
-		return s32Error;
+		return result;
 	}
 
 	hif_drv->enuHostIFstate = HOST_IF_IDLE;
@@ -1371,9 +1365,9 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
 	hif_drv->strWILC_UsrConnReq.ssidLen = 0;
@@ -1394,7 +1388,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 		info_element = NULL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
@@ -1402,10 +1396,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 {
 	u32 i;
 	bool bNewNtwrkFound;
-
-
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	void *pJoinParams = NULL;
 
@@ -1418,7 +1409,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 		if ((pstrNetworkInfo == NULL)
 		    || (hif_drv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
 			PRINT_ER("driver is null\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto done;
 		}
 
@@ -1481,13 +1472,13 @@ done:
 		pstrNetworkInfo = NULL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 u8MsgType = 0;
 	u8 u8MsgID = 0;
 	u16 u16MsgLen = 0;
@@ -1711,13 +1702,13 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 	kfree(pstrRcvdGnrlAsyncInfo->buffer);
 	pstrRcvdGnrlAsyncInfo->buffer = NULL;
 
-	return s32Error;
+	return result;
 }
 
 static int Handle_Key(struct host_if_drv *hif_drv,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	struct wid strWIDList[5];
 	u8 i;
@@ -1766,8 +1757,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[3].size = pstrHostIFkeyAttr->attr.wep.key_len;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
-
-			s32Error = send_config_pkt(SET_CFG, strWIDList, 4,
+			result = send_config_pkt(SET_CFG, strWIDList, 4,
 						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 
@@ -1792,7 +1782,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
@@ -1805,7 +1795,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.val = s8idxarray;
 			strWID.size = 1;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
@@ -1815,7 +1805,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
 		}
 		up(&hif_drv->hSemTestKeyBlock);
@@ -1848,7 +1838,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
+			result = send_config_pkt(SET_CFG, strWIDList, 2,
 						   get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
@@ -1881,7 +1871,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
@@ -1926,7 +1916,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
+			result = send_config_pkt(SET_CFG, strWIDList, 2,
 						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
@@ -1955,7 +1945,7 @@ _WPARxGtk_end_case_:
 			strWID.val = (s8 *)pu8keybuf;
 			strWID.size = PTK_KEY_MSG_LEN;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
@@ -1991,25 +1981,24 @@ _WPAPtk_end_case_:
 		strWID.val = (s8 *)pu8keybuf;
 		strWID.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+		result = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(hif_drv));
 
 		kfree(pu8keybuf);
 		break;
 	}
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send key config packet\n");
 
-
-	return s32Error;
+	return result;
 }
 
 static void Handle_Disconnect(struct host_if_drv *hif_drv)
 {
 	struct wid strWID;
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	u16 u16DummyReasonCode = 0;
 
 	strWID.id = (u16)WID_DISCONNECT;
@@ -2026,10 +2015,10 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	eth_zero_addr(u8ConnectedSSID);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to send dissconect config packet\n");
 	} else {
 		tstrDisconnectNotifInfo strDisconnectNotifInfo;
@@ -2100,8 +2089,7 @@ void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 
 static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
@@ -2111,25 +2099,22 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get channel number\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 	up(&hif_drv->hSemGetCHNL);
 
-	return s32Error;
-
-
-
+	return result;
 }
 
 static void Handle_GetRssi(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	strWID.id = (u16)WID_RSSI;
@@ -2139,11 +2124,11 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 	up(&hif_drv->hSemGetRSSI);
@@ -2154,7 +2139,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 
 static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	link_speed = 0;
@@ -2166,11 +2151,11 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 	up(&(hif_drv->hSemGetLINKSPEED));
@@ -2181,7 +2166,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	struct wid strWIDList[5];
-	u32 u32WidsCount = 0, s32Error = 0;
+	u32 u32WidsCount = 0, result = 0;
 
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
@@ -2213,10 +2198,10 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
 
 	up(&hif_sema_wait_response);
@@ -2227,8 +2212,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 				   struct sta_inactive_t *strHostIfStaInactiveT)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 *stamac;
 	struct wid strWID;
 
@@ -2244,11 +2228,10 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
-
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to SET incative time\n");
 		return -EFAULT;
 	}
@@ -2259,11 +2242,10 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	strWID.val = (s8 *)&inactive_time;
 	strWID.size = sizeof(u32);
 
-
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get incative time\n");
 		return -EFAULT;
 	}
@@ -2272,16 +2254,13 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	up(&hif_drv->hSemInactiveTime);
 
-	return s32Error;
-
-
-
+	return result;
 }
 
 static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 			     struct beacon_attr *pstrSetBeaconParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
 
@@ -2322,9 +2301,9 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
 ERRORHANDLER:
@@ -2335,7 +2314,7 @@ ERRORHANDLER:
 
 static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
 
@@ -2351,9 +2330,9 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
 
@@ -2406,7 +2385,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 static void Handle_AddStation(struct host_if_drv *hif_drv,
 			      struct add_sta_param *pstrStationParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
 
@@ -2422,9 +2401,9 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = strWID.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error != 0)
+	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
@@ -2435,7 +2414,7 @@ ERRORHANDLER:
 static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 			     struct del_all_sta *pstrDelAllStaParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	struct wid strWID;
 	u8 *pu8CurrByte;
@@ -2465,9 +2444,9 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
@@ -2479,7 +2458,7 @@ ERRORHANDLER:
 static void Handle_DelStation(struct host_if_drv *hif_drv,
 			      struct del_sta *pstrDelStaParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
 
@@ -2497,9 +2476,9 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
@@ -2509,7 +2488,7 @@ ERRORHANDLER:
 static void Handle_EditStation(struct host_if_drv *hif_drv,
 			       struct add_sta_param *pstrStationParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
 
@@ -2525,9 +2504,9 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = strWID.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
 
 ERRORHANDLER:
@@ -2538,7 +2517,7 @@ ERRORHANDLER:
 static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 			       struct remain_ch *pstrHostIfRemainOnChan)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 u8remain_on_chan_flag;
 	struct wid strWID;
 
@@ -2555,18 +2534,18 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
 		hif_drv->u8RemainOnChan_pendingreq = 1;
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 	if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while connecting return\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
@@ -2579,16 +2558,16 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 
 	if (strWID.val == NULL) {
-		s32Error = -ENOMEM;
+		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
 
 	strWID.val[0] = u8remain_on_chan_flag;
 	strWID.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error != 0)
+	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
 ERRORHANDLER:
@@ -2605,13 +2584,14 @@ ERRORHANDLER:
 		if (hif_drv->u8RemainOnChan_pendingreq)
 			hif_drv->u8RemainOnChan_pendingreq = 0;
 	}
-	return s32Error;
+
+	return result;
 }
 
 static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 				struct reg_frame *pstrHostIfRegisterFrame)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
 
@@ -2632,15 +2612,14 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	strWID.size = sizeof(u16) + 2;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
-
+	return result;
 }
 
 #define FALSE_FRMWR_CHANNEL 100
@@ -2649,7 +2628,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 {
 	u8 u8remain_on_chan_flag;
 	struct wid strWID;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
@@ -2666,9 +2645,9 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		strWID.val[0] = u8remain_on_chan_flag;
 		strWID.val[1] = FALSE_FRMWR_CHANNEL;
 
-		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+		result = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(hif_drv));
-		if (s32Error != 0) {
+		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
 		}
@@ -2680,16 +2659,16 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		P2P_LISTEN_STATE = 0;
 	} else {
 		PRINT_D(GENERIC_DBG, "Not in listen state\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 _done_:
-	return s32Error;
+	return result;
 }
 
 static void ListenTimerCB(unsigned long arg)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
 
@@ -2700,15 +2679,15 @@ static void ListenTimerCB(unsigned long arg)
 	msg.drv = hif_drv;
 	msg.body.remain_on_ch.u32ListenSessionID = hif_drv->strHostIfRemainOnChan.u32ListenSessionID;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 }
 
 static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 				   struct power_mgmt_param *strPowerMgmtParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	s8 s8PowerMode;
 
@@ -2724,16 +2703,16 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
 }
 
 static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 				      struct set_multicast *strHostIfSetMulti)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	u8 *pu8CurrByte;
 
@@ -2760,9 +2739,9 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	if ((strHostIfSetMulti->cnt) > 0)
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
 ERRORHANDLER:
@@ -2773,7 +2752,7 @@ ERRORHANDLER:
 static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 			       struct ba_session_info *strHostIfBASessionInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
@@ -2807,9 +2786,9 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 8;
 	*ptr++ = 0;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
 
@@ -2827,19 +2806,19 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	*ptr++ = 3;
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
 	kfree(strWID.val);
 
-	return s32Error;
+	return result;
 
 }
 
 static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 	char *ptr = NULL;
 
@@ -2863,9 +2842,9 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0;
 	*ptr++ = 32;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error)
+	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
 
@@ -2873,8 +2852,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 
 	up(&hif_sema_wait_response);
 
-	return s32Error;
-
+	return result;
 }
 
 static int hostIFthread(void *pvArg)
@@ -3152,14 +3130,14 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 
 s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 
 	if (!hif_drv) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3171,12 +3149,12 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 	msg.drv = hif_drv;
 	msg.body.key_info.attr.wep.index = u8Index;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&hif_drv->hSemTestKeyBlock);
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
@@ -3184,14 +3162,13 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 				 u8 u8WepKeylen,
 				 u8 u8Keyidx)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3206,13 +3183,12 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
 	msg.body.key_info.attr.wep.index = u8Keyidx;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&hif_drv->hSemTestKeyBlock);
 
-	return s32Error;
-
+	return result;
 }
 
 s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
@@ -3222,15 +3198,14 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 				u8 u8mode,
 				enum AUTHTYPE tenuAuth_type)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	u8 i;
 
 	if (!hif_drv) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3250,14 +3225,13 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	msg.body.key_info.attr.wep.mode = u8mode;
 	msg.body.key_info.attr.wep.auth_type = tenuAuth_type;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&hif_drv->hSemTestKeyBlock);
 
-	return s32Error;
-
+	return result;
 }
 
 s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
@@ -3265,15 +3239,15 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		     const u8 *pu8RxMic, const u8 *pu8TxMic,
 		     u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
 	if (!hif_drv) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
@@ -3315,14 +3289,14 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.attr.wpa.mode = u8Ciphermode;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
 
 	down(&hif_drv->hSemTestKeyBlock);
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
@@ -3331,14 +3305,14 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 			const u8 *pu8RxMic, const u8 *pu8TxMic,
 			u8 mode, u8 u8Ciphermode)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (!hif_drv) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
@@ -3378,26 +3352,26 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
 	msg.body.key_info.attr.wpa.seq_len = u32KeyRSClen;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 
 	down(&hif_drv->hSemTestKeyBlock);
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	u32 i;
 
 
 	if (!hif_drv) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3414,11 +3388,11 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 			    PMKID_LEN);
 	}
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
@@ -3453,7 +3427,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 
 s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3462,19 +3436,19 @@ s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send get mac address\n");
 		return -EFAULT;
 	}
 
 	down(&hif_sema_wait_response);
-	return s32Error;
+	return result;
 }
 
 s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
@@ -3484,12 +3458,11 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	memcpy(msg.body.set_mac_info.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Failed to send message queue: Set mac address\n");
 
-	return s32Error;
-
+	return result;
 }
 
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
@@ -3536,13 +3509,13 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 			  u8 u8security, enum AUTHTYPE tenuAuth_type,
 			  u8 u8channel, void *pJoinParams)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv || pfConnectResult == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("Driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	if (pJoinParams == NULL) {
@@ -3583,8 +3556,8 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	else
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", hif_drv->enuHostIFstate);
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
 		return -EFAULT;
 	}
@@ -3593,41 +3566,41 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	mod_timer(&hif_drv->hConnectTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!join_req) {
-		s32Error = -EFAULT;
-		return s32Error;
+		result = -EFAULT;
+		return result;
 	}
 
 
 	if (!hif_drv) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("Driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
 		return -EFAULT;
 	}
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -3640,13 +3613,13 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	msg.id = HOST_IF_MSG_DISCONNECT;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 
 	down(&hif_drv->hSemTestDisconnectBlock);
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
@@ -3677,7 +3650,7 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv, u8 *pu8AssocReqInfo
 s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	if (!hif_drv) {
@@ -3690,9 +3663,9 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInf
 	strWID.val = pu8AssocRespInfo;
 	strWID.size = u32MaxAssocRespInfoLen;
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
-	if (s32Error) {
+	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
 		return -EINVAL;
@@ -3700,7 +3673,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInf
 		*pu32RcvdAssocRespInfoLen = strWID.size;
 	}
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv, u8 *pu8RxPowerLevel,
@@ -3798,7 +3771,7 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 
 s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -3811,22 +3784,20 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 	msg.id = HOST_IF_MSG_GET_CHNL;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 	down(&hif_drv->hSemGetCHNL);
 
 	*pu8ChNo = ch_no;
 
-	return s32Error;
-
-
+	return result;
 }
 
 s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 			       const u8 *mac, u32 *pu32InactiveTime)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -3843,21 +3814,20 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
 	down(&hif_drv->hSemInactiveTime);
 
 	*pu32InactiveTime = inactive_time;
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wid strWID;
 
 	if (!hif_drv) {
@@ -3870,10 +3840,10 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 	strWID.val = (s8 *)pu32TestMemAddr;
 	strWID.size = sizeof(u32);
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get wid value\n");
 		return -EINVAL;
 	} else {
@@ -3881,20 +3851,20 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 
 	}
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
 	}
@@ -3909,20 +3879,20 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 
 	*ps8Rssi = rssi;
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 {
 	struct host_if_msg msg;
-	s32 s32Error = 0;
+	s32 result = 0;
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
 		return -EFAULT;
 	}
@@ -3937,12 +3907,12 @@ s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 
 	*ps8lnkspd = link_speed;
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
@@ -3950,14 +3920,14 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 	msg.body.data = (char *)pstrStatistics;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
 	}
 
 	down(&hif_sema_wait_response);
-	return s32Error;
+	return result;
 }
 
 s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
@@ -3966,7 +3936,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		  size_t IEsLen, wilc_scan_result ScanResult,
 		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv || ScanResult == NULL) {
@@ -3999,8 +3969,8 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.body.scan_info.ies = kmalloc(IEsLen, GFP_KERNEL);
 	memcpy(msg.body.scan_info.ies, pu8IEs, IEsLen);
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Error in sending message queue\n");
 		return -EINVAL;
 	}
@@ -4010,15 +3980,13 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	mod_timer(&hif_drv->hScanTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
-	return s32Error;
-
+	return result;
 }
 
 s32 hif_set_cfg(struct host_if_drv *hif_drv,
 		struct cfg_param_val *pstrCfgParamVal)
 {
-
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 
@@ -4032,15 +4000,14 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 	msg.body.cfg_info.cfg_attr_info = *pstrCfgParamVal;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-
-	return s32Error;
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
+	return result;
 }
 
 s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	down(&hif_drv->gtOsCfgValuesSem);
 
@@ -4129,8 +4096,7 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 
 	up(&hif_drv->gtOsCfgValuesSem);
 
-	return s32Error;
-
+	return result;
 }
 
 void host_int_send_join_leave_info_to_host
@@ -4148,7 +4114,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 	}
 
 	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) {
-		s32 s32Error = 0;
+		s32 result = 0;
 		struct host_if_msg msg;
 
 		memset(&msg, 0, sizeof(struct host_if_msg));
@@ -4156,8 +4122,8 @@ static void GetPeriodicRSSI(unsigned long arg)
 		msg.id = HOST_IF_MSG_GET_RSSI;
 		msg.drv = hif_drv;
 
-		s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-		if (s32Error) {
+		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+		if (result) {
 			PRINT_ER("Failed to send get host channel param's message queue ");
 			return;
 		}
@@ -4279,7 +4245,7 @@ _fail_:
 
 s32 host_int_deinit(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	int ret;
 
@@ -4329,9 +4295,9 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.drv = hif_drv;
 
-		s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-		if (s32Error != 0)
-			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
+		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+		if (result != 0)
+			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", result);
 
 		down(&hif_sema_thread);
 
@@ -4342,19 +4308,19 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 
 	ret = remove_handler_in_list(hif_drv);
 	if (ret)
-		s32Error = -ENOENT;
+		result = -ENOENT;
 
 	kfree(hif_drv);
 
 	clients_count--;
 	terminated_handle = NULL;
 	up(&hif_sema_deinit);
-	return s32Error;
+	return result;
 }
 
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
@@ -4379,14 +4345,14 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.body.net_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.net_info.buffer, pu8Buffer, u32Length);
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
-		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
+		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", result);
 }
 
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
@@ -4420,16 +4386,16 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.body.async_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.async_info.buffer, pu8Buffer, u32Length);
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
-		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
+		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", result);
 
 	up(&hif_sema_deinit);
 }
 
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
@@ -4449,9 +4415,9 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		msg.drv = hif_drv;
 
-		s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-		if (s32Error)
-			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
+		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+		if (result)
+			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", result);
 	}
 
 
@@ -4465,7 +4431,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 			       wilc_remain_on_chan_ready RemainOnChanReady,
 			       void *pvUserArg)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -4484,16 +4450,16 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -4508,16 +4474,16 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	msg.drv = hif_drv;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool bReg)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -4547,20 +4513,18 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 	msg.body.reg_frame.bReg = bReg;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
-	return s32Error;
-
-
+	return result;
 }
 
 s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 			u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
 			u32 u32TailLen, u8 *pu8Tail)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
 
@@ -4580,7 +4544,7 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 	pstrSetBeaconParam->head_len = u32HeadLen;
 	pstrSetBeaconParam->head = kmemdup(pu8Head, u32HeadLen, GFP_KERNEL);
 	if (pstrSetBeaconParam->head == NULL) {
-		s32Error = -ENOMEM;
+		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
 	pstrSetBeaconParam->tail_len = u32TailLen;
@@ -4589,31 +4553,31 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 		pstrSetBeaconParam->tail = kmemdup(pu8Tail, u32TailLen,
 						   GFP_KERNEL);
 		if (pstrSetBeaconParam->tail == NULL) {
-			s32Error = -ENOMEM;
+			result = -ENOMEM;
 			goto ERRORHANDLER;
 		}
 	} else {
 		pstrSetBeaconParam->tail = NULL;
 	}
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
 ERRORHANDLER:
-	if (s32Error) {
+	if (result) {
 		kfree(pstrSetBeaconParam->head);
 
 		kfree(pstrSetBeaconParam->tail);
 	}
 
-	return s32Error;
+	return result;
 
 }
 
 s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -4625,17 +4589,17 @@ s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 	msg.drv = hif_drv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
@@ -4663,15 +4627,15 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 
 s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
 
@@ -4692,16 +4656,16 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	else
 		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 
 s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 			    u8 pu8MacAddr[][ETH_ALEN])
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct del_all_sta *pstrDelAllStationMsg = &msg.body.del_all_sta_info;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
@@ -4736,25 +4700,24 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 	}
 	if (!u8AssocNumb) {
 		PRINT_D(CFG80211_DBG, "NO ASSOCIATED STAS\n");
-		return s32Error;
+		return result;
 	}
 
 	pstrDelAllStationMsg->assoc_sta = u8AssocNumb;
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
 	down(&hif_sema_wait_response);
 
-	return s32Error;
-
+	return result;
 }
 
 s32 host_int_edit_station(struct host_if_drv *hif_drv,
 			  struct add_sta_param *pstrStaParams)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
@@ -4781,18 +4744,18 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 			    bool bIsEnabled,
 			    u32 u32Timeout)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
 
@@ -4813,17 +4776,17 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 	pstrPowerMgmtParam->enabled = bIsEnabled;
 	pstrPowerMgmtParam->timeout = u32Timeout;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 
 s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 				    bool bIsEnabled,
 				    u32 u32count)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
 
@@ -4843,10 +4806,10 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 	pstrMulticastFilterParam->enabled = bIsEnabled;
 	pstrMulticastFilterParam->cnt = u32count;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
@@ -5020,7 +4983,7 @@ void host_int_freeJoinParams(void *pJoinParams)
 
 s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
@@ -5037,20 +5000,20 @@ s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 	pBASessionInfo->u8Ted = TID;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
 	down(&hif_sema_wait_response);
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 				  char *pBSSID,
 				  char TID)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
@@ -5067,18 +5030,18 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	pBASessionInfo->u8Ted = TID;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
 	down(&hif_sema_wait_response);
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	return 0;
@@ -5096,18 +5059,16 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
-
-
+	return result;
 }
 
 s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
@@ -5123,11 +5084,9 @@ s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
-	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
-
-
+	return result;
 }
-- 
1.9.1

