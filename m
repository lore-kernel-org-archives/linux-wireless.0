Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34753 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbbIUAZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 20:25:42 -0400
Received: by padhy16 with SMTP id hy16so100038119pad.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2015 17:25:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: replace s32Error with result
Date: Mon, 21 Sep 2015 09:25:31 +0900
Message-Id: <1442795132-19660-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_022608_576889_C82AD3EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of functions use s32Error variable to check error and return its value.
This patch replaces s32Error with result to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  40 +-
 drivers/staging/wilc1000/host_interface.c         | 900 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |  12 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 230 +++---
 4 files changed, 591 insertions(+), 591 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 14e8efc..ad3b546 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -339,11 +339,11 @@ static inline u16 get_asoc_id(u8 *data)
 
 s32 CoreConfiguratorInit(void)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
-	return s32Error;
+	return result;
 }
 
 u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
@@ -414,7 +414,7 @@ u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
  */
 s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	u8 u8MsgType = 0;
 	u8 u8MsgID = 0;
@@ -523,7 +523,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 	*ppstrNetworkInfo = pstrNetworkInfo;
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -538,24 +538,24 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
  */
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	if (pstrNetworkInfo != NULL) {
 		if (pstrNetworkInfo->pu8IEs != NULL) {
 			kfree(pstrNetworkInfo->pu8IEs);
 			pstrNetworkInfo->pu8IEs = NULL;
 		} else {
-			s32Error = -EFAULT;
+			result = -EFAULT;
 		}
 
 		kfree(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
 
 	} else {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -572,7 +572,7 @@ s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
 s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 			       tstrConnectRespInfo **ppstrConnectRespInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 	u16 u16AssocRespLen = 0;
 	u8 *pu8IEs = NULL;
@@ -614,7 +614,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	*ppstrConnectRespInfo = pstrConnectRespInfo;
 
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -629,24 +629,24 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
  */
 s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	if (pstrConnectRespInfo != NULL) {
 		if (pstrConnectRespInfo->pu8RespIEs != NULL) {
 			kfree(pstrConnectRespInfo->pu8RespIEs);
 			pstrConnectRespInfo->pu8RespIEs = NULL;
 		} else {
-			s32Error = -EFAULT;
+			result = -EFAULT;
 		}
 
 		kfree(pstrConnectRespInfo);
 		pstrConnectRespInfo = NULL;
 
 	} else {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
-	return s32Error;
+	return result;
 }
 
 #ifndef CONNECT_DIRECT
@@ -654,7 +654,7 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 			       wid_site_survey_reslts_s **ppstrSurveyResults,
 			       u32 *pu32SurveyResultsCount)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	wid_site_survey_reslts_s *pstrSurveyResults = NULL;
 	u32 u32SurveyResultsCount = 0;
 	u32 u32SurveyBytesLength = 0;
@@ -703,19 +703,19 @@ ERRORHANDLER:
 	*ppstrSurveyResults = pstrSurveyResults;
 	*pu32SurveyResultsCount = u32SurveyResultsCount;
 
-	return s32Error;
+	return result;
 }
 
 
 s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	if (pstrSurveyResults != NULL) {
 		kfree(pstrSurveyResults);
 	}
 
-	return s32Error;
+	return result;
 }
 #endif
 
@@ -731,12 +731,12 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 
 s32 CoreConfiguratorDeInit(void)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
 
 
-	return s32Error;
+	return result;
 }
 
 /*Using the global handle of the driver*/
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0546f7a..f997628 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -639,7 +639,7 @@ static tstrWILC_WFIDrv *get_handler_from_id(int id)
 static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pstrHostIFSetChan)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -651,14 +651,14 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set channel\n");
 		return -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 /**
  *  @brief Handle_SetWfiDrvHandler
@@ -673,7 +673,7 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 				   tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = drvHandler;
 
@@ -686,19 +686,19 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 pstrHostIfSetDrvHandler->u32Address);
 
 	if (pstrWFIDrv == NULL)
 		up(&hSemDeinitDrvHandle);
 
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set driver handler\n");
 		return -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -713,7 +713,7 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOperationMode *pstrHostIfSetOperationMode)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -727,7 +727,7 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 
@@ -735,12 +735,12 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 		up(&hSemDeinitDrvHandle);
 
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set driver handler\n");
 		return -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -755,7 +755,7 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	char firmwareIPAddress[4] = {0};
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -773,20 +773,20 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 
 	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set IP address\n");
 		return -EINVAL;
 	}
 
 	PRINT_INFO(HOSTINF_DBG, "IP address set\n");
 
-	return s32Error;
+	return result;
 }
 
 
@@ -802,7 +802,7 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -812,7 +812,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
@@ -825,7 +825,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
 		host_int_setup_ipaddress(pstrWFIDrv, gs8SetIP[idx], idx);
 
-	if (s32Error != 0) {
+	if (result != 0) {
 		PRINT_ER("Failed to get IP address\n");
 		return -EINVAL;
 	}
@@ -834,7 +834,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", gs8GetIP[idx]);
 	PRINT_INFO(HOSTINF_DBG, "\n");
 
-	return s32Error;
+	return result;
 }
 
 
@@ -850,7 +850,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
@@ -868,15 +868,15 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
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
 
 
@@ -892,7 +892,7 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAddress *pstrHostIfGetMacAddress)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 
 	/*prepare configuration packet*/
@@ -902,15 +902,15 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, false,
 				 get_id_from_handler(drvHandler));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get mac address\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 	up(&hWaitResponse);
 
-	return s32Error;
+	return result;
 }
 
 
@@ -925,7 +925,7 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
  */
 static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *strHostIFCfgParamAttr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWIDList[32];
 	u8 u8WidCnt = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -951,7 +951,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 		} else {
 			PRINT_ER("check value 6 over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -971,7 +971,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 		} else {
 			PRINT_ER("Impossible value \n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -986,7 +986,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 		} else {
 			PRINT_ER("Range(1 ~ 65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1007,7 +1007,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 		} else {
 			PRINT_ER("Invalide power mode\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1022,7 +1022,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1038,7 +1038,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 		} else {
 			PRINT_ER("Range(1~256) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1053,7 +1053,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1068,7 +1068,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 		} else {
 			PRINT_ER("Threshold Range fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1087,7 +1087,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 		} else {
 			PRINT_ER("Preamle Range(0~2) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1101,7 +1101,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 		} else {
 			PRINT_ER("Short slot(2) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1119,7 +1119,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 		} else {
 			PRINT_ER("TXOP prot disable\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1134,7 +1134,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 		} else {
 			PRINT_ER("Beacon interval(1~65535) fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1149,7 +1149,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 		} else {
 			PRINT_ER("DTIM range(1~255) fail\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1168,7 +1168,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 		} else {
 			PRINT_ER("Site survey disable\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1183,7 +1183,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 		} else {
 			PRINT_ER("Site survey scan time(1~65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1198,7 +1198,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 		} else {
 			PRINT_ER("Active scan time(1~65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1213,7 +1213,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 		} else {
 			PRINT_ER("Passive scan time(1~65535) over\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
@@ -1238,20 +1238,20 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			PRINT_ER("out of TX rate\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false,
+	result = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false,
 				 get_id_from_handler(pstrWFIDrv));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Error in setting CFG params\n");
 
 ERRORHANDLER:
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
-	return s32Error;
+	return result;
 }
 
 
@@ -1266,11 +1266,11 @@ ERRORHANDLER:
  */
 static s32 Handle_wait_msg_q_empty(void)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	g_wilc_initialized = 0;
 	up(&hWaitResponse);
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1284,7 +1284,7 @@ static s32 Handle_wait_msg_q_empty(void)
  */
 static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWIDList[5];
 	u32 u32WidsCount = 0;
 	u32 i;
@@ -1303,7 +1303,7 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 		/* here we either in HOST_IF_SCANNING, HOST_IF_WAITING_CONN_REQ or HOST_IF_WAITING_CONN_RESP */
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", pstrWFIDrv->enuHostIFstate);
 		PRINT_ER("Already scan\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
@@ -1311,7 +1311,7 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		PRINT_ER("Don't do obss scan\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 	#endif
@@ -1398,16 +1398,16 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+	result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
 	else
 		PRINT_D(HOSTINF_DBG, "Successfully sent SCAN params config packet\n");
 
 ERRORHANDLER:
-	if (s32Error) {
+	if (result) {
 		del_timer(&pstrWFIDrv->hScanTimer);
 		/*if there is an ongoing scan request*/
 		Handle_ScanDone(drvHandler, SCAN_EVENT_ABORTED);
@@ -1438,7 +1438,7 @@ ERRORHANDLER:
 	if (pu8HdnNtwrksWidVal != NULL)
 		kfree(pu8HdnNtwrksWidVal);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1452,7 +1452,7 @@ ERRORHANDLER:
  */
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -1473,17 +1473,17 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+		result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
-		if (s32Error) {
+		if (result) {
 			PRINT_ER("Failed to set abort running scan\n");
-			s32Error = -EFAULT;
+			result = -EFAULT;
 		}
 	}
 
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("Driver handler is NULL\n");
-		return s32Error;
+		return result;
 	}
 
 	/*if there is an ongoing scan request*/
@@ -1494,7 +1494,7 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = NULL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1510,7 +1510,7 @@ u8 u8ConnectedSSID[6] = {0};
 static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *pstrHostIFconnectAttr)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
 	/* char passphrase[] = "12345678"; */
@@ -1539,7 +1539,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 						  MAX_SURVEY_RESULT_FRAG_SIZE);
 	if (s32Err) {
 		PRINT_ER("Failed to get site survey results\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 	s32Err = ParseSurveyResults(gapu8RcvdSurveyResults, &pstrSurveyResults,
@@ -1557,7 +1557,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		DeallocateSurveyResults(pstrSurveyResults);
 	} else {
 		PRINT_ER("ParseSurveyResults() Error\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
@@ -1667,11 +1667,11 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		gu32WidConnRstHack = 0;
 		/* ////////////////////// */
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+		result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 					 get_id_from_handler(pstrWFIDrv));
-		if (s32Error) {
+		if (result) {
 			PRINT_ER("failed to send config packet\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto ERRORHANDLER;
 		} else {
 			pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
@@ -1679,7 +1679,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	} else {
 		PRINT_ER("Required BSSID not found\n");
-		s32Error = -ENOENT;
+		result = -ENOENT;
 		goto ERRORHANDLER;
 	}
 
@@ -1689,9 +1689,9 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	if (memcmp(pstrHostIFconnectAttr->pu8bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
 
-		s32Error = 0;
+		result = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
-		return s32Error;
+		return result;
 	}
 
 	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
@@ -1700,7 +1700,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	ptstrJoinBssParam = (tstrJoinBssParam *)pstrHostIFconnectAttr->pJoinParams;
 	if (ptstrJoinBssParam == NULL) {
 		PRINT_ER("Required BSSID not found\n");
-		s32Error = -ENOENT;
+		result = -ENOENT;
 		goto ERRORHANDLER;
 	}
 	#endif /*WILC_PARSE_SCAN_IN_HOST*/
@@ -1807,7 +1807,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
 
 	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
@@ -1845,7 +1845,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
 	}
 	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
@@ -1988,11 +1988,11 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+	result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("failed to send config packet\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	} else {
 		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
@@ -2001,7 +2001,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	#endif
 
 ERRORHANDLER:
-	if (s32Error) {
+	if (result) {
 		tstrConnectInfo strConnectInfo;
 
 		del_timer(&pstrWFIDrv->hConnectTimer);
@@ -2061,7 +2061,7 @@ ERRORHANDLER:
 
 	if (pu8CurrByte != NULL)
 		kfree(pu8CurrByte);
-	return s32Error;
+	return result;
 }
 
 /**
@@ -2077,7 +2077,7 @@ ERRORHANDLER:
 
 static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWIDList[5];
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
@@ -2119,14 +2119,14 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 
 	#endif
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+	result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(gu8FlushedJoinReqDrvHandler));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("failed to send config packet\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -2140,7 +2140,7 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
  */
 static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrConnectInfo strConnectInfo;
 	tstrWID strWID;
 	u16 u16DummyReasonCode = 0;
@@ -2148,7 +2148,7 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 	if (pstrWFIDrv == NULL)	{
 		PRINT_ER("Driver handler is NULL\n");
-		return s32Error;
+		return result;
 	}
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
@@ -2200,9 +2200,9 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
 	/* Deallocation of the Saved Connect Request in the global Handle */
@@ -2234,7 +2234,7 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 		gu8FlushedInfoElemAsoc = NULL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -2253,7 +2253,7 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
 
 
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	void *pJoinParams = NULL;
 
@@ -2271,7 +2271,7 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
 		if ((pstrNetworkInfo == NULL)
 		    || (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
 			PRINT_ER("driver is null\n");
-			s32Error = -EINVAL;
+			result = -EINVAL;
 			goto done;
 		}
 
@@ -2351,7 +2351,7 @@ done:
 		pstrNetworkInfo = NULL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -2367,7 +2367,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 {
 	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
 	/*				 which carries only 1 WID which have WID ID = WID_STATUS */
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 u8MsgType = 0;
 	u8 u8MsgID = 0;
 	u16 u16MsgLen = 0;
@@ -2677,7 +2677,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 		pstrRcvdGnrlAsyncInfo->pu8Buffer = NULL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -2691,7 +2691,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
  */
 static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	tstrWID strWIDList[5];
 	u8 i;
@@ -2747,7 +2747,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true,
+			result = SendConfigPkt(SET_CFG, strWIDList, 4, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -2775,7 +2775,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
@@ -2788,7 +2788,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
@@ -2798,7 +2798,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -2844,7 +2844,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+			result = SendConfigPkt(SET_CFG, strWIDList, 2, true,
 						 get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
@@ -2890,7 +2890,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
@@ -2947,7 +2947,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+			result = SendConfigPkt(SET_CFG, strWIDList, 2, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -2988,7 +2988,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -3028,18 +3028,18 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+		result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
 
 		kfree(pu8keybuf);
 		break;
 	}
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send key config packet\n");
 
 
-	return s32Error;
+	return result;
 }
 
 
@@ -3056,7 +3056,7 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 {
 	tstrWID strWID;
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	u16 u16DummyReasonCode = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -3078,10 +3078,10 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to send dissconect config packet\n");
 	} else {
 		tstrDisconnectNotifInfo strDisconnectNotifInfo;
@@ -3174,7 +3174,7 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 {
 
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	static char dummy = 9;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3184,11 +3184,11 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 
-	if (s32Error) {
+	if (result) {
 		PRINT_D(HOSTINF_DBG, "Failed to switch log terminal\n");
 		PRINT_ER("Failed to switch log terminal\n");
 		return -EINVAL;
@@ -3196,7 +3196,7 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_INFO(HOSTINF_DBG, "MAC address set ::\n");
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3212,7 +3212,7 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3224,17 +3224,17 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get channel number\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 	up(&(pstrWFIDrv->hSemGetCHNL));
 
-	return s32Error;
+	return result;
 
 
 
@@ -3252,7 +3252,7 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
  */
 static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -3264,11 +3264,11 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 	up(&(pstrWFIDrv->hSemGetRSSI));
@@ -3279,7 +3279,7 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 
 static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -3292,11 +3292,11 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
-		s32Error = -EFAULT;
+		result = -EFAULT;
 	}
 
 	up(&(pstrWFIDrv->hSemGetLINKSPEED));
@@ -3307,7 +3307,7 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatistics)
 {
 	tstrWID strWIDList[5];
-	u32 u32WidsCount = 0, s32Error = 0;
+	u32 u32WidsCount = 0, result = 0;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_LINKSPEED;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
@@ -3339,10 +3339,10 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false,
+	result = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(drvHandler));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
 
 	up(&hWaitResponse);
@@ -3364,7 +3364,7 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaInactiveT *strHostIfStaInactiveT)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 *stamac;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3383,10 +3383,10 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to SET incative time\n");
 		return -EFAULT;
 	}
@@ -3398,10 +3398,10 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get incative time\n");
 		return -EFAULT;
 	}
@@ -3411,7 +3411,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 
 	up(&(pstrWFIDrv->hSemInactiveTime));
 
-	return s32Error;
+	return result;
 
 
 
@@ -3429,7 +3429,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
  */
 static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *pstrSetBeaconParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3474,9 +3474,9 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
 ERRORHANDLER:
@@ -3497,7 +3497,7 @@ ERRORHANDLER:
  */
 static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *pstrDelBeacon)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3516,9 +3516,9 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
 
@@ -3588,7 +3588,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
  */
 static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3606,9 +3606,9 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error != 0)
+	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
@@ -3627,7 +3627,7 @@ ERRORHANDLER:
  */
 static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	tstrWID strWID;
 	u8 *pu8CurrByte;
@@ -3659,9 +3659,9 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
@@ -3682,7 +3682,7 @@ ERRORHANDLER:
  */
 static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pstrDelStaParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3702,9 +3702,9 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
@@ -3723,7 +3723,7 @@ ERRORHANDLER:
  */
 static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3741,9 +3741,9 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
 
 ERRORHANDLER:
@@ -3762,7 +3762,7 @@ ERRORHANDLER:
  */
 static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
@@ -3782,19 +3782,19 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
 		pstrWFIDrv->u8RemainOnChan_pendingreq = 1;
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while connecting return\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
-		s32Error = -EBUSY;
+		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 	#endif
@@ -3808,7 +3808,7 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
 	if (strWID.ps8WidVal == NULL) {
-		s32Error = -ENOMEM;
+		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
 
@@ -3816,9 +3816,9 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error != 0)
+	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
 ERRORHANDLER:
@@ -3836,7 +3836,7 @@ ERRORHANDLER:
 		if (pstrWFIDrv->u8RemainOnChan_pendingreq)
 			pstrWFIDrv->u8RemainOnChan_pendingreq = 0;
 	}
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3850,7 +3850,7 @@ ERRORHANDLER:
  */
 static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterFrame *pstrHostIfRegisterFrame)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3875,14 +3875,14 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 
 }
 
@@ -3900,7 +3900,7 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 {
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
@@ -3921,9 +3921,9 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+		result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
-		if (s32Error != 0) {
+		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
 		}
@@ -3935,11 +3935,11 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
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
 
 
@@ -3954,7 +3954,7 @@ _done_:
  */
 static void ListenTimerCB(unsigned long arg)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)arg;
 	/*Stopping remain-on-channel timer*/
@@ -3967,8 +3967,8 @@ static void ListenTimerCB(unsigned long arg)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 }
 
@@ -3983,7 +3983,7 @@ static void ListenTimerCB(unsigned long arg)
  */
 static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerMgmtParam *strPowerMgmtParam)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	s8 s8PowerMode;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -4001,9 +4001,9 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
 }
 
@@ -4018,7 +4018,7 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
  */
 static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetMulti *strHostIfSetMulti)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 
@@ -4046,9 +4046,9 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(drvHandler));
-	if (s32Error)
+	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
 ERRORHANDLER:
@@ -4068,7 +4068,7 @@ ERRORHANDLER:
  */
 static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
@@ -4110,9 +4110,9 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
 
@@ -4135,13 +4135,13 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
 		kfree(strWID.ps8WidVal);
 
-	return s32Error;
+	return result;
 
 }
 
@@ -4157,7 +4157,7 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  */
 static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	char *ptr = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -4185,9 +4185,9 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
 
@@ -4204,7 +4204,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
@@ -4212,7 +4212,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 
 	up(&hWaitResponse);
 
-	return s32Error;
+	return result;
 
 }
 
@@ -4228,7 +4228,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  */
 static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	char *ptr = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -4255,9 +4255,9 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
+	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
 
@@ -4266,7 +4266,7 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 
 	up(&hWaitResponse);
 
-	return s32Error;
+	return result;
 
 }
 
@@ -4536,7 +4536,7 @@ static void TimerCB_Connect(unsigned long arg)
 /* Check implementation in core adding 9 bytes to the input! */
 s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -4545,7 +4545,7 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
 	strWID.ps8WidVal	= (s8 *)pu8StaAddress;
 	strWID.s32ValueSize = 6;
 
-	return s32Error;
+	return result;
 
 }
 
@@ -4565,15 +4565,15 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
  */
 s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("Failed to send setup multicast config packet\n");
-		return s32Error;
+		return result;
 	}
 
 	/* prepare the Remove Wep Key Message */
@@ -4591,12 +4591,12 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -4613,15 +4613,15 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
  */
 s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	/* prepare the Key Message */
@@ -4638,12 +4638,12 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -4668,14 +4668,14 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	/* prepare the Key Message */
@@ -4702,12 +4702,12 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	return s32Error;
+	return result;
 
 }
 
@@ -4730,15 +4730,15 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	u8 i;
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	/* prepare the Key Message */
@@ -4774,13 +4774,13 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	return s32Error;
+	return result;
 
 }
 
@@ -4803,16 +4803,16 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
@@ -4870,16 +4870,16 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
 
 	/* ////////////// */
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 	/* /////// */
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -4899,15 +4899,15 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
@@ -4968,14 +4968,14 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 	/* ////////////// */
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 	/* /////// */
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5000,16 +5000,16 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
  */
 s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	u32 i;
 
 
 	if (pstrWFIDrv == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	/* prepare the Key Message */
@@ -5030,11 +5030,11 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	}
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5061,7 +5061,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5070,7 +5070,7 @@ s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 	strWID.s32ValueSize = u32PmkidInfoLen;
 	strWID.ps8WidVal = pu8PmkidInfoArray;
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5090,7 +5090,7 @@ s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 
 	/*validating psk length*/
@@ -5101,7 +5101,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
 		strWID.s32ValueSize = u8Psklength;
 	}
 
-	return s32Error;
+	return result;
 }
 /**
  *  @brief              host_int_get_MacAddress
@@ -5116,7 +5116,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
  */
 s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 
 
@@ -5127,14 +5127,14 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send get mac address\n");
 		return -EFAULT;
 	}
 
 	down(&hWaitResponse);
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5150,7 +5150,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
  */
 s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
@@ -5161,11 +5161,11 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Failed to send message queue: Set mac address\n");
 
-	return s32Error;
+	return result;
 
 }
 
@@ -5186,7 +5186,7 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5195,7 +5195,7 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
 	strWID.s32ValueSize = u8Psklength;
 	strWID.ps8WidVal	= pu8PassPhrase;
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5234,7 +5234,7 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID astrWIDList[2];
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5248,16 +5248,16 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true,
+	result = SendConfigPkt(GET_CFG, astrWIDList, 2, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	/*get the value by searching the local copy*/
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to send config packet to get survey results\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 #endif
 
@@ -5278,7 +5278,7 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
  */
 s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5287,7 +5287,7 @@ s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
 	strWID.ps8WidVal = (s8 *)&scanSource;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5308,7 +5308,7 @@ s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
 
 s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5317,7 +5317,7 @@ s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource)
 	strWID.ps8WidVal = (s8 *)pu8ScanSource;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5339,15 +5339,15 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  u8 u8channel,
 				  void *pJoinParams)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("Driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	if (hWFIDrv == NULL) {
@@ -5399,8 +5399,8 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", pstrWFIDrv->enuHostIFstate);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
 		return -EFAULT;
 	}
@@ -5410,7 +5410,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	mod_timer(&pstrWFIDrv->hConnectTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5427,32 +5427,32 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 
 s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 
 	if (!gu8FlushedJoinReq)	{
-		s32Error = -EFAULT;
-		return s32Error;
+		result = -EFAULT;
+		return result;
 	}
 
 
 	if (hWFIDrv  == NULL) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		PRINT_ER("Driver is null\n");
-		return s32Error;
+		return result;
 	}
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_FLUSH_CONNECT;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
 		return -EFAULT;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5468,7 +5468,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
  */
 s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5484,14 +5484,14 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 	/* ////////////// */
 	down(&(pstrWFIDrv->hSemTestDisconnectBlock));
 	/* /////// */
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5507,7 +5507,7 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
  */
 s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5516,7 +5516,7 @@ s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
 	strWID.ps8WidVal = (s8 *)&assoc_id;
 	strWID.s32ValueSize = sizeof(char);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5548,7 +5548,7 @@ s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
 s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5558,7 +5558,7 @@ s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 	strWID.s32ValueSize = u32AssocReqInfoLen;
 
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5575,7 +5575,7 @@ s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5591,9 +5591,9 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
 		return -EINVAL;
@@ -5601,7 +5601,7 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 		*pu32RcvdAssocRespInfoLen = strWID.s32ValueSize;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5622,7 +5622,7 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5632,7 +5632,7 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
 	strWID.s32ValueSize = u32RxPowerLevelLen;
 
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5652,7 +5652,7 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
  */
 s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -5667,19 +5667,19 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	strHostIFmsg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 
 s32 host_int_wait_msg_queue_idle(void)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	struct host_if_msg strHostIFmsg;
 
@@ -5687,22 +5687,22 @@ s32 host_int_wait_msg_queue_idle(void)
 
 	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
 	/* wait untill MSG Q is empty */
 	down(&hWaitResponse);
 
-	return s32Error;
+	return result;
 
 }
 
 s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	struct host_if_msg strHostIFmsg;
 
@@ -5714,20 +5714,20 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
 	strHostIFmsg.drvHandler = u32address;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 
 
 s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	struct host_if_msg strHostIFmsg;
 
@@ -5739,13 +5739,13 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5765,7 +5765,7 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
  */
 s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -5781,15 +5781,15 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error =	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result =	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 	down(&(pstrWFIDrv->hSemGetCHNL));
 	/* gu8Chnl = 11; */
 
 	*pu8ChNo = gu8Chnl;
 
-	return s32Error;
+	return result;
 
 
 }
@@ -5807,7 +5807,7 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
  */
 s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5824,9 +5824,9 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to set wid value\n");
 		return -EINVAL;
 	} else {
@@ -5834,7 +5834,7 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5850,7 +5850,7 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
  */
 s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -5869,15 +5869,15 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
 	down(&(pstrWFIDrv->hSemInactiveTime));
 
 	*pu32InactiveTime = gu32InactiveTime;
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -5893,7 +5893,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5908,10 +5908,10 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
-	if (s32Error) {
+	if (result) {
 		PRINT_ER("Failed to get wid value\n");
 		return -EINVAL;
 	} else {
@@ -5919,7 +5919,7 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 
 	}
 
-	return s32Error;
+	return result;
 }
 
 
@@ -5938,7 +5938,7 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
  */
 s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5950,8 +5950,8 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
 	}
@@ -5968,13 +5968,13 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 	*ps8Rssi = gs8Rssi;
 
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 {
 	struct host_if_msg strHostIFmsg;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5987,8 +5987,8 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
 		return -EFAULT;
 	}
@@ -6005,12 +6005,12 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 	*ps8lnkspd = gs8lnkspd;
 
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 
 
@@ -6021,14 +6021,14 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
 	strHostIFmsg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
 	}
 
 	down(&hWaitResponse);
-	return s32Error;
+	return result;
 }
 
 
@@ -6054,7 +6054,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
 			  void *pvUserArg, tstrHiddenNetwork  *pstrHiddenNetwork)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
@@ -6093,8 +6093,8 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("Error in sending message queue\n");
 		return -EINVAL;
 	}
@@ -6105,7 +6105,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	mod_timer(&pstrWFIDrv->hScanTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
-	return s32Error;
+	return result;
 
 }
 /**
@@ -6122,7 +6122,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	struct host_if_msg strHostIFmsg;
@@ -6138,9 +6138,9 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	strHostIFmsg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
-	return s32Error;
+	return result;
 
 }
 
@@ -6160,7 +6160,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
  */
 s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
@@ -6250,7 +6250,7 @@ s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 
-	return s32Error;
+	return result;
 
 }
 
@@ -6300,7 +6300,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 	}
 
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
-		s32 s32Error = 0;
+		s32 result = 0;
 		struct host_if_msg strHostIFmsg;
 
 		/* prepare the Get RSSI Message */
@@ -6310,8 +6310,8 @@ static void GetPeriodicRSSI(unsigned long arg)
 		strHostIFmsg.drvHandler = pstrWFIDrv;
 
 		/* send the message */
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-		if (s32Error) {
+		result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+		if (result) {
 			PRINT_ER("Failed to send get host channel param's message queue ");
 			return;
 		}
@@ -6340,7 +6340,7 @@ static u32 clients_count;
 
 s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	int err;
 
@@ -6361,7 +6361,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = kmalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (pstrWFIDrv == NULL) {
-		s32Error = -ENOMEM;
+		result = -ENOMEM;
 		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
 	}
@@ -6371,7 +6371,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*save into globl handle*/
 	err = add_handler_in_list(pstrWFIDrv);
 	if (err) {
-		s32Error = -EFAULT;
+		result = -EFAULT;
 		goto _fail_timer_2;
 	}
 
@@ -6402,9 +6402,9 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
 	if (clients_count == 0)	{
-		s32Error = wilc_mq_create(&gMsgQHostIF);
+		result = wilc_mq_create(&gMsgQHostIF);
 
-		if (s32Error < 0) {
+		if (result < 0) {
 			PRINT_ER("Failed to creat MQ\n");
 			goto _fail_;
 		}
@@ -6412,7 +6412,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		HostIFthreadHandler = kthread_run(hostIFthread, NULL, "WILC_kthread");
 		if (IS_ERR(HostIFthreadHandler)) {
 			PRINT_ER("Failed to creat Thread\n");
-			s32Error = -EFAULT;
+			result = -EFAULT;
 			goto _fail_mq_;
 		}
 		setup_timer(&g_hPeriodicRSSI, GetPeriodicRSSI,
@@ -6455,8 +6455,8 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 	/*TODO Code to setup simulation to be removed later*/
 	/*Intialize configurator module*/
-	s32Error = CoreConfiguratorInit();
-	if (s32Error < 0) {
+	result = CoreConfiguratorInit();
+	if (result < 0) {
 		PRINT_ER("Failed to initialize core configurator\n");
 		goto _fail_mem_;
 	}
@@ -6464,7 +6464,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	u32Intialized = 1;
 	clients_count++; /* increase number of created entities */
 
-	return s32Error;
+	return result;
 
 
 _fail_mem_:
@@ -6479,7 +6479,7 @@ _fail_timer_2:
 _fail_mq_:
 	wilc_mq_destroy(&gMsgQHostIF);
 _fail_:
-	return s32Error;
+	return result;
 
 
 }
@@ -6495,7 +6495,7 @@ _fail_:
 
 s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 	int ret;
 
@@ -6568,9 +6568,9 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 		strHostIFmsg.drvHandler = hWFIDrv;
 
 
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-		if (s32Error != 0)
-			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
+		result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+		if (result != 0)
+			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", result);
 
 		down(&hSemHostIFthrdEnd);
 
@@ -6585,7 +6585,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	/* gWFiDrvHandle = NULL; */
 	ret = remove_handler_in_list(pstrWFIDrv);
 	if (ret)
-		s32Error = -ENOENT;
+		result = -ENOENT;
 
 	if (pstrWFIDrv != NULL) {
 		kfree(pstrWFIDrv);
@@ -6596,7 +6596,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	clients_count--; /* Decrease number of created entities */
 	terminated_handle = NULL;
 	up(&hSemHostIntDeinit);
-	return s32Error;
+	return result;
 }
 
 
@@ -6613,7 +6613,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
  */
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
@@ -6641,9 +6641,9 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
-		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
+		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", result);
 }
 
 /**
@@ -6659,7 +6659,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
  */
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
@@ -6698,9 +6698,9 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
-		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
+		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", result);
 
 	up(&hSemHostIntDeinit);
 }
@@ -6716,7 +6716,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
  */
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct host_if_msg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
@@ -6748,9 +6748,9 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-		if (s32Error)
-			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
+		result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+		if (result)
+			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", result);
 	}
 
 
@@ -6774,7 +6774,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  */
 s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -6796,11 +6796,11 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -6819,7 +6819,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
  */
 s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -6837,11 +6837,11 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -6854,7 +6854,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
  *  @version		1.0*/
 s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bReg)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -6886,11 +6886,11 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.bReg = bReg;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
-	return s32Error;
+	return result;
 
 
 }
@@ -6911,7 +6911,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8Tail)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
@@ -6934,7 +6934,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
 	pstrSetBeaconParam->pu8Head = kmalloc(u32HeadLen, GFP_KERNEL);
 	if (pstrSetBeaconParam->pu8Head == NULL) {
-		s32Error = -ENOMEM;
+		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
 	memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
@@ -6943,7 +6943,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	if (u32TailLen > 0) {
 		pstrSetBeaconParam->pu8Tail = kmalloc(u32TailLen, GFP_KERNEL);
 		if (pstrSetBeaconParam->pu8Tail == NULL) {
-			s32Error = -ENOMEM;
+			result = -ENOMEM;
 			goto ERRORHANDLER;
 		}
 		memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
@@ -6951,12 +6951,12 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 		pstrSetBeaconParam->pu8Tail = NULL;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc mq send fail\n");
 
 ERRORHANDLER:
-	if (s32Error) {
+	if (result) {
 		if (pstrSetBeaconParam->pu8Head != NULL)
 			kfree(pstrSetBeaconParam->pu8Head);
 
@@ -6964,7 +6964,7 @@ ERRORHANDLER:
 			kfree(pstrSetBeaconParam->pu8Tail);
 	}
 
-	return s32Error;
+	return result;
 
 }
 
@@ -6980,7 +6980,7 @@ ERRORHANDLER:
  */
 s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -6994,11 +6994,11 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 
@@ -7013,7 +7013,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
  */
 s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
@@ -7045,10 +7045,10 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	}
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 
 /**
@@ -7062,7 +7062,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
  */
 s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
@@ -7087,10 +7087,10 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	else
 		memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 /**
  *  @brief      host_int_del_allstation
@@ -7103,7 +7103,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
  */
 s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrHostIFDelAllSta *pstrDelAllStationMsg = &strHostIFmsg.uniHostIFmsgBody.strHostIFDelAllSta;
@@ -7136,19 +7136,19 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	}
 	if (!u8AssocNumb) {
 		PRINT_D(CFG80211_DBG, "NO ASSOCIATED STAS\n");
-		return s32Error;
+		return result;
 	}
 
 	pstrDelAllStationMsg->u8Num_AssocSta = u8AssocNumb;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
 
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
 	down(&hWaitResponse);
 
-	return s32Error;
+	return result;
 
 }
 
@@ -7163,7 +7163,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
  */
 s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
@@ -7193,16 +7193,16 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam;
@@ -7227,15 +7227,15 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 
 s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32count)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
@@ -7259,10 +7259,10 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
-	return s32Error;
+	return result;
 }
 
 
@@ -7501,7 +7501,7 @@ void host_int_freeJoinParams(void *pJoinParams)
 static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
@@ -7522,17 +7522,17 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	pBASessionInfo->u16SessionTimeout = SessionTimeout;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
+	return result;
 }
 
 
 s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
@@ -7551,18 +7551,18 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
 	down(&hWaitResponse);
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
@@ -7581,13 +7581,13 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
 	down(&hWaitResponse);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -7600,7 +7600,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
  *  @version		1.0*/
 s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -7621,11 +7621,11 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
+	return result;
 
 
 }
@@ -7640,7 +7640,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
  *  @version		1.0*/
 s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg strHostIFmsg;
 
@@ -7658,11 +7658,11 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
-	if (s32Error)
+	result = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	return s32Error;
+	return result;
 
 
 }
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7857ad2..8ecc5aa 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1688,7 +1688,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	u32 size = 0, length = 0;
 	perInterface_wlan_t *nic;
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
@@ -1713,8 +1713,8 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 				priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
-				s32Error = host_int_get_rssi(priv->hWILCWFIDrv, &(rssi));
-				if (s32Error)
+				result = host_int_get_rssi(priv->hWILCWFIDrv, &(rssi));
+				if (result)
 					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
 
@@ -1725,7 +1725,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
 					PRINT_ER("%s: failed to copy data to user buffer\n", __func__);
-					s32Error = -EFAULT;
+					result = -EFAULT;
 					goto done;
 				}
 			}
@@ -1736,7 +1736,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	default:
 	{
 		PRINT_INFO(GENERIC_DBG, "Command - %d - has been received\n", cmd);
-		s32Error = -EOPNOTSUPP;
+		result = -EOPNOTSUPP;
 		goto done;
 	}
 	}
@@ -1745,7 +1745,7 @@ done:
 
 	kfree(buff);
 
-	return s32Error;
+	return result;
 }
 
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a44d8a0..b563af5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -495,7 +495,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
 {
 	u32 i;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
@@ -505,16 +505,16 @@ int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
 			PRINT_D(CFG80211_DBG, "PMKID successful comparison");
 
 			/*If bssid is found, set the values*/
-			s32Error = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
+			result = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
 
-			if (s32Error != 0)
+			if (result != 0)
 				PRINT_ER("Error in pmkid\n");
 
 			break;
 		}
 	}
 
-	return s32Error;
+	return result;
 
 
 }
@@ -672,7 +672,7 @@ static int set_channel(struct wiphy *wiphy,
 
 	u32 channelnum = 0;
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	priv = wiphy_priv(wiphy);
 
@@ -680,12 +680,12 @@ static int set_channel(struct wiphy *wiphy,
 	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
 	u8CurrChannel = channelnum;
-	s32Error   = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
+	result   = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
 
-	if (s32Error != 0)
+	if (result != 0)
 		PRINT_ER("Error in setting channel %d\n", channelnum);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -709,7 +709,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
 	u32 i;
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
 	tstrHiddenNetwork strHiddenNetwork;
 
@@ -756,13 +756,13 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				}
 			}
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			result = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, &strHiddenNetwork);
 		} else {
 			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
-			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
+			result = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, NULL);
@@ -773,12 +773,12 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 			 " channels\n");
 	}
 
-	if (s32Error != 0) {
-		s32Error = -EBUSY;
-		PRINT_WRN(CFG80211_DBG, "Device is busy: Error(%d)\n", s32Error);
+	if (result != 0) {
+		result = -EBUSY;
+		PRINT_WRN(CFG80211_DBG, "Device is busy: Error(%d)\n", result);
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -796,7 +796,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 static int connect(struct wiphy *wiphy, struct net_device *dev,
 		   struct cfg80211_connect_params *sme)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	u32 i;
 	u8 u8security = NO_ENCRYPT;
 	AUTHTYPE_T tenuAuth_type = ANY;
@@ -857,11 +857,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			   pstrNetworkInfo->au8bssid[2], pstrNetworkInfo->au8bssid[3],
 			   pstrNetworkInfo->au8bssid[4], pstrNetworkInfo->au8bssid[5]);
 	} else {
-		s32Error = -ENOENT;
+		result = -ENOENT;
 		if (u32LastScannedNtwrksCountShadow == 0)
 			PRINT_D(CFG80211_DBG, "No Scan results yet\n");
 		else
-			PRINT_D(CFG80211_DBG, "Required bss not in scan results: Error(%d)\n", s32Error);
+			PRINT_D(CFG80211_DBG, "Required bss not in scan results: Error(%d)\n", result);
 
 		goto done;
 	}
@@ -951,8 +951,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			pcwpa_version = "WPA_VERSION_1";
 
 		} else {
-			s32Error = -ENOTSUPP;
-			PRINT_ER("Not supported cipher: Error(%d)\n", s32Error);
+			result = -ENOTSUPP;
+			PRINT_ER("Not supported cipher: Error(%d)\n", result);
 
 			goto done;
 		}
@@ -1017,20 +1017,20 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	linux_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
 
-	s32Error = host_int_set_join_req(priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
+	result = host_int_set_join_req(priv->hWILCWFIDrv, pstrNetworkInfo->au8bssid, sme->ssid,
 					 sme->ssid_len, sme->ie, sme->ie_len,
 					 CfgConnectResult, (void *)priv, u8security,
 					 tenuAuth_type, pstrNetworkInfo->u8channel,
 					 pstrNetworkInfo->pJoinParams);
-	if (s32Error != 0) {
-		PRINT_ER("host_int_set_join_req(): Error(%d)\n", s32Error);
-		s32Error = -ENOENT;
+	if (result != 0) {
+		PRINT_ER("host_int_set_join_req(): Error(%d)\n", result);
+		result = -ENOENT;
 		goto done;
 	}
 
 done:
 
-	return s32Error;
+	return result;
 }
 
 
@@ -1045,7 +1045,7 @@ done:
  */
 static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
@@ -1066,13 +1066,13 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	bWilc_ie = false;
 	pstrWFIDrv->u64P2p_MgmtTimeout = 0;
 
-	s32Error = host_int_disconnect(priv->hWILCWFIDrv, reason_code);
-	if (s32Error != 0) {
-		PRINT_ER("Error in disconnecting: Error(%d)\n", s32Error);
-		s32Error = -EINVAL;
+	result = host_int_disconnect(priv->hWILCWFIDrv, reason_code);
+	if (result != 0) {
+		PRINT_ER("Error in disconnecting: Error(%d)\n", result);
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1090,7 +1090,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   const u8 *mac_addr, struct key_params *params)
 
 {
-	s32 s32Error = 0, KeyLen = params->key_len;
+	s32 result = 0, KeyLen = params->key_len;
 	u32 i;
 	struct wilc_priv *priv;
 	const u8 *pu8RxMic = NULL;
@@ -1349,12 +1349,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		break;
 
 	default:
-		PRINT_ER("Not supported cipher: Error(%d)\n", s32Error);
-		s32Error = -ENOTSUPP;
+		PRINT_ER("Not supported cipher: Error(%d)\n", result);
+		result = -ENOTSUPP;
 
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1373,7 +1373,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		   const u8 *mac_addr)
 {
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	priv = wiphy_priv(wiphy);
 
@@ -1459,7 +1459,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		host_int_remove_key(priv->hWILCWFIDrv, mac_addr);
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1480,7 +1480,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
 {
 
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	struct wilc_priv *priv;
 	struct  key_params key_params;
@@ -1514,7 +1514,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	callback(cookie, &key_params);
 
-	return s32Error;        /* priv->wilc_gtk->key_len ?0 : -ENOENT; */
+	return result;        /* priv->wilc_gtk->key_len ?0 : -ENOENT; */
 }
 
 /**
@@ -1529,7 +1529,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			   bool unicast, bool multicast)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 
 
@@ -1542,7 +1542,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 		host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, key_index);
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1557,16 +1557,16 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
 				int idx, struct survey_info *info)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 
 	if (idx != 0) {
-		s32Error = -ENOENT;
-		PRINT_ER("Error Idx value doesn't equal zero: Error(%d)\n", s32Error);
+		result = -ENOENT;
+		PRINT_ER("Error Idx value doesn't equal zero: Error(%d)\n", result);
 
 	}
 
-	return s32Error;
+	return result;
 }
 
 
@@ -1583,7 +1583,7 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
 static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_info *sinfo)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	u32 i = 0;
@@ -1607,10 +1607,10 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		if (associatedsta == -1) {
-			s32Error = -ENOENT;
-			PRINT_ER("Station required is not associated : Error(%d)\n", s32Error);
+			result = -ENOENT;
+			PRINT_ER("Station required is not associated : Error(%d)\n", result);
 
-			return s32Error;
+			return result;
 		}
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
@@ -1651,7 +1651,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
 			sinfo->tx_failed, sinfo->txrate.legacy);
 	}
-	return s32Error;
+	return result;
 }
 
 
@@ -1759,7 +1759,7 @@ static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
  */
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrCfgParamVal pstrCfgParamVal;
 	struct wilc_priv *priv;
 
@@ -1797,12 +1797,12 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	}
 
 	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
-	s32Error = hif_set_cfg(priv->hWILCWFIDrv, &pstrCfgParamVal);
-	if (s32Error)
+	result = hif_set_cfg(priv->hWILCWFIDrv, &pstrCfgParamVal);
+	if (result)
 		PRINT_ER("Error in setting WIPHY PARAMS\n");
 
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1818,10 +1818,10 @@ static int WILC_WFI_set_bitrate_mask(struct wiphy *wiphy,
 				     struct net_device *dev, const u8 *peer,
 				     const struct cfg80211_bitrate_mask *mask)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	PRINT_D(CFG80211_DBG, "Setting Bitrate mask function\n");
-	return s32Error;
+	return result;
 
 }
 
@@ -1840,7 +1840,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
-	s32 s32Error = 0;
+	s32 result = 0;
 	u8 flag = 0;
 
 	struct wilc_priv *priv = wiphy_priv(wiphy);
@@ -1867,14 +1867,14 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 			priv->pmkid_list.numpmkid++;
 	} else {
 		PRINT_ER("Invalid PMKID index\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	if (!s32Error) {
+	if (!result) {
 		PRINT_D(CFG80211_DBG, "Setting pmkid in the host interface\n");
-		s32Error = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
+		result = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
 	}
-	return s32Error;
+	return result;
 }
 
 /**
@@ -1892,7 +1892,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	u32 i;
 	u8 flag = 0;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
@@ -1920,10 +1920,10 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		}
 		priv->pmkid_list.numpmkid--;
 	} else {
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -2278,7 +2278,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 			     struct ieee80211_channel *chan,
 			     unsigned int duration, u64 *cookie)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
@@ -2288,7 +2288,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 
 	if (wdev->iftype == NL80211_IFTYPE_AP) {
 		PRINT_D(GENERIC_DBG, "Required remain-on-channel while in AP mode");
-		return s32Error;
+		return result;
 	}
 
 	u8CurrChannel = chan->hw_value;
@@ -2299,7 +2299,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 	priv->strRemainOnChanParams.u32ListenDuration = duration;
 	priv->strRemainOnChanParams.u32ListenSessionID++;
 
-	s32Error = host_int_remain_on_channel(priv->hWILCWFIDrv
+	result = host_int_remain_on_channel(priv->hWILCWFIDrv
 					      , priv->strRemainOnChanParams.u32ListenSessionID
 					      , duration
 					      , chan->hw_value
@@ -2307,7 +2307,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 					      , WILC_WFI_RemainOnChannelReady
 					      , (void *)priv);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -2327,15 +2327,15 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    u64 cookie)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
 
 	PRINT_D(CFG80211_DBG, "Cancel remain on channel\n");
 
-	s32Error = host_int_ListenStateExpired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
-	return s32Error;
+	result = host_int_ListenStateExpired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
+	return result;
 }
 /**
  *  @brief       WILC_WFI_add_wilcvendorspec
@@ -2375,7 +2375,7 @@ int mgmt_tx(struct wiphy *wiphy,
 	const struct ieee80211_mgmt *mgmt;
 	struct p2p_mgmt_data *mgmt_tx;
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 result = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	u32 i;
 	perInterface_wlan_t *nic;
@@ -2511,7 +2511,7 @@ int mgmt_tx(struct wiphy *wiphy,
 	} else {
 		PRINT_D(GENERIC_DBG, "This function transmits only management frames\n");
 	}
-	return s32Error;
+	return result;
 }
 
 int mgmt_tx_cancel_wait(struct wiphy *wiphy,
@@ -2699,7 +2699,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	u8 interface_type;
@@ -3014,12 +3014,12 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	default:
 		PRINT_ER("Unknown interface type= %d\n", type);
-		s32Error = -EINVAL;
-		return s32Error;
+		result = -EINVAL;
+		return result;
 		break;
 	}
 
-	return s32Error;
+	return result;
 }
 
 /* (austin.2013-07-23)
@@ -3053,7 +3053,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct cfg80211_beacon_data *beacon = &(settings->beacon);
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	priv = wiphy_priv(wiphy);
 	PRINT_D(HOSTAPD_DBG, "Starting ap\n");
@@ -3061,20 +3061,20 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Interval = %d\n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
 		settings->beacon_interval, settings->dtim_period, beacon->head_len, beacon->tail_len);
 
-	s32Error = set_channel(wiphy, &settings->chandef);
+	result = set_channel(wiphy, &settings->chandef);
 
-	if (s32Error != 0)
+	if (result != 0)
 		PRINT_ER("Error in setting channel\n");
 
 	linux_wlan_set_bssid(dev, g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 
-	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
+	result = host_int_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
 					settings->dtim_period,
 					beacon->head_len, (u8 *)beacon->head,
 					beacon->tail_len, (u8 *)beacon->tail);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3093,19 +3093,19 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_beacon_data *beacon)
 {
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	priv = wiphy_priv(wiphy);
 	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
 
 
-	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
+	result = host_int_add_beacon(priv->hWILCWFIDrv,
 					0,
 					0,
 					beacon->head_len, (u8 *)beacon->head,
 					beacon->tail_len, (u8 *)beacon->tail);
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3119,7 +3119,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
  */
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
@@ -3132,12 +3132,12 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	linux_wlan_set_bssid(dev, NullBssid);
 
-	s32Error = host_int_del_beacon(priv->hWILCWFIDrv);
+	result = host_int_del_beacon(priv->hWILCWFIDrv);
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Host delete beacon fail\n");
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3152,7 +3152,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_parameters *params)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
@@ -3201,12 +3201,12 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
-		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
-		if (s32Error)
+		result = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
+		if (result)
 			PRINT_ER("Host add station fail\n");
 	}
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3222,7 +3222,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 		       struct station_del_parameters *params)
 {
 	const u8 *mac = params->mac;
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 
@@ -3238,17 +3238,17 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 		if (mac == NULL) {
 			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
-			s32Error = host_int_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
+			result = host_int_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
 		} else {
 			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 		}
 
-		s32Error = host_int_del_station(priv->hWILCWFIDrv, mac);
+		result = host_int_del_station(priv->hWILCWFIDrv, mac);
 
-		if (s32Error)
+		if (result)
 			PRINT_ER("Host delete station fail\n");
 	}
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3263,7 +3263,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
-	s32 s32Error = 0;
+	s32 result = 0;
 	struct wilc_priv *priv;
 	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
@@ -3313,11 +3313,11 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n", strStaParams.u16FlagsMask);
 		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n", strStaParams.u16FlagsSet);
 
-		s32Error = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
-		if (s32Error)
+		result = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
+		if (result)
 			PRINT_ER("Host edit station fail\n");
 	}
-	return s32Error;
+	return result;
 }
 
 
@@ -3524,7 +3524,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
-	s32 s32Error = 0;
+	s32 result = 0;
 
 	PRINT_D(CFG80211_DBG, "Registering wifi device\n");
 
@@ -3577,8 +3577,8 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 	#endif
 
 	/*Register wiphy structure*/
-	s32Error = wiphy_register(wdev->wiphy);
-	if (s32Error) {
+	result = wiphy_register(wdev->wiphy);
+	if (result) {
 		PRINT_ER("Cannot register wiphy device\n");
 		/*should define what action to be taken in such failure*/
 	} else {
@@ -3602,7 +3602,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 int wilc_init_host_int(struct net_device *net)
 {
 
-	int s32Error = 0;
+	int result = 0;
 
 	struct wilc_priv *priv;
 
@@ -3615,9 +3615,9 @@ int wilc_init_host_int(struct net_device *net)
 		#endif
 	}
 	op_ifcs++;
-	if (s32Error < 0) {
+	if (result < 0) {
 		PRINT_ER("Failed to creat refresh Timer\n");
-		return s32Error;
+		return result;
 	}
 
 	priv->gbAutoRateAdjusted = false;
@@ -3625,11 +3625,11 @@ int wilc_init_host_int(struct net_device *net)
 	priv->bInP2PlistenState = false;
 
 	sema_init(&(priv->hSemScanReq), 1);
-	s32Error = host_int_init(&priv->hWILCWFIDrv);
-	if (s32Error)
+	result = host_int_init(&priv->hWILCWFIDrv);
+	if (result)
 		PRINT_ER("Error while initializing hostinterface\n");
 
-	return s32Error;
+	return result;
 }
 
 /**
@@ -3643,7 +3643,7 @@ int wilc_init_host_int(struct net_device *net)
  */
 int wilc_deinit_host_int(struct net_device *net)
 {
-	int s32Error = 0;
+	int result = 0;
 
 	struct wilc_priv *priv;
 
@@ -3655,7 +3655,7 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	op_ifcs--;
 
-	s32Error = host_int_deinit(priv->hWILCWFIDrv);
+	result = host_int_deinit(priv->hWILCWFIDrv);
 
 	/* Clear the Shadow scan */
 	clear_shadow_scan(priv);
@@ -3666,10 +3666,10 @@ int wilc_deinit_host_int(struct net_device *net)
 	}
 	#endif
 
-	if (s32Error)
+	if (result)
 		PRINT_ER("Error while deintializing host interface\n");
 
-	return s32Error;
+	return result;
 }
 
 
-- 
2.5.1

