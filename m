Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26869 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbIPJg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:36:28 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 3/6] staging: wilc1000: remove the macro WILC_ERRORREPORT
Date: Wed, 16 Sep 2015 18:36:01 +0900
Message-ID: <1442396164-18728-4-git-send-email-tony.cho@atmel.com> (sfid-20150916_113633_095787_D3BDC89D)
In-Reply-To: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
References: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the macro WILC_ERRORREPORT which is not used
anymore by replacing it with the plain statements.

The compiler complains the build warnings in some functions for WILC_CATCH and
ERRORHANDLER as unused definitions. So, this patch also removes WILC_CATCH and
ERRORHANDLER from some of functions.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |   4 +-
 drivers/staging/wilc1000/host_interface.c         | 869 +++++++++-------------
 drivers/staging/wilc1000/wilc_errorsupport.h      |   5 -
 drivers/staging/wilc1000/wilc_msgqueue.c          |  98 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   9 +-
 5 files changed, 398 insertions(+), 587 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 87d32ae..96358a9 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -13,6 +13,7 @@
 /* File Includes                                                             */
 /*****************************************************************************/
 #include "coreconfigurator.h"
+#include <linux/errno.h>
 /*****************************************************************************/
 /* Constants                                                                 */
 /*****************************************************************************/
@@ -429,7 +430,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 	/* Check whether the received message type is 'N' */
 	if ('N' != u8MsgType) {
 		PRINT_ER("Received Message format incorrect.\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		return -EFAULT;
 	}
 
 	/* Extract message ID */
@@ -525,7 +526,6 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 	*ppstrNetworkInfo = pstrNetworkInfo;
 
-ERRORHANDLER:
 	return s32Error;
 }
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8ed1aaf..8c6de42 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -668,11 +668,7 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		return -EINVAL;
 	}
 
 	return s32Error;
@@ -712,11 +708,7 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 
 	if (s32Error) {
 		PRINT_ER("Failed to set driver handler\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		return -EINVAL;
 	}
 
 	return s32Error;
@@ -758,11 +750,7 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 
 	if (s32Error) {
 		PRINT_ER("Failed to set driver handler\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		return -EINVAL;
 	}
 
 	return s32Error;
@@ -805,16 +793,11 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
 
 	if (s32Error) {
-		PRINT_D(HOSTINF_DBG, "Failed to set IP address\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	} else {
-		PRINT_INFO(HOSTINF_DBG, "IP address set\n");
+		PRINT_ER("Failed to set IP address\n");
+		return -EINVAL;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
+	PRINT_INFO(HOSTINF_DBG, "IP address set\n");
 
 	return s32Error;
 }
@@ -857,17 +840,12 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to get IP address\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	} else {
-		PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d\n", idx);
-		PRINT_INFO(HOSTINF_DBG, "%pI4\n", gs8GetIP[idx]);
-		PRINT_INFO(HOSTINF_DBG, "\n");
+		return -EINVAL;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
+	PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d\n", idx);
+	PRINT_INFO(HOSTINF_DBG, "%pI4\n", gs8GetIP[idx]);
+	PRINT_INFO(HOSTINF_DBG, "\n");
 
 	return s32Error;
 }
@@ -908,13 +886,9 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		s32Error = -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	kfree(mac_buf);
 	return s32Error;
 }
@@ -947,11 +921,7 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
 				 get_id_from_handler(drvHandler));
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		s32Error = -EFAULT;
 	}
 	up(&hWaitResponse);
 
@@ -995,7 +965,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("check value 6 over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1013,7 +985,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Impossible value \n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1026,7 +1000,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Range(1 ~ 65535) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1045,7 +1021,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Invalide power mode\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1058,7 +1036,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Range(1~256) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1072,7 +1052,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Range(1~256) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1085,7 +1067,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Threshold Range fail\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1098,7 +1082,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Threshold Range fail\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1115,7 +1101,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Preamle Range(0~2) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1127,7 +1115,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Short slot(2) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1143,7 +1133,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("TXOP prot disable\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1156,7 +1148,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Beacon interval(1~65535) fail\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1169,7 +1163,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("DTIM range(1~255) fail\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1186,7 +1182,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Site survey disable\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1199,7 +1197,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Site survey scan time(1~65535) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1212,7 +1212,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Active scan time(1~65535) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1225,7 +1227,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("Passive scan time(1~65535) over\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1248,7 +1252,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("out of TX rate\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1258,9 +1264,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 	return s32Error;
 }
@@ -1316,13 +1320,17 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	if ((pstrWFIDrv->enuHostIFstate >= HOST_IF_SCANNING) && (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTED)) {
 		/* here we either in HOST_IF_SCANNING, HOST_IF_WAITING_CONN_REQ or HOST_IF_WAITING_CONN_RESP */
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", pstrWFIDrv->enuHostIFstate);
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
+		PRINT_ER("Already scan\n");
+		s32Error = -EBUSY;
+		goto ERRORHANDLER;
 	}
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
+		PRINT_ER("Don't do obss scan\n");
+		s32Error = -EBUSY;
+		goto ERRORHANDLER;
 	}
 	#endif
 
@@ -1413,15 +1421,13 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
 
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Failed to send scan paramters config packet\n");
-		WILC_ERRORREPORT(s32Error, s32Error);
-	} else {
+	else
 		PRINT_D(HOSTINF_DBG, "Successfully sent SCAN params config packet\n");
-	}
 
-	WILC_CATCH(s32Error)
-	{
+ERRORHANDLER:
+	if (s32Error) {
 		del_timer(&pstrWFIDrv->hScanTimer);
 		/*if there is an ongoing scan request*/
 		Handle_ScanDone(drvHandler, SCAN_EVENT_ABORTED);
@@ -1490,12 +1496,9 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		/*Sending Cfg*/
 		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
-		if (s32Error != WILC_SUCCESS) {
+		if (s32Error) {
 			PRINT_ER("Failed to set abort running scan\n");
-			WILC_ERRORREPORT(s32Error, WILC_FAIL);
-		}
-		WILC_CATCH(s32Error)
-		{
+			s32Error = -EFAULT;
 		}
 	}
 
@@ -1558,8 +1561,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 						  MAX_SURVEY_RESULT_FRAG_SIZE);
 	if (s32Err) {
 		PRINT_ER("Failed to get site survey results\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
 	}
 	s32Err = ParseSurveyResults(gapu8RcvdSurveyResults, &pstrSurveyResults,
 				    &pstrWFIDrv->u32SurveyResultsCount);
@@ -1575,8 +1578,9 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 		DeallocateSurveyResults(pstrSurveyResults);
 	} else {
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-		PRINT_ER("ParseSurveyResults() Error(%d)\n", s32Err);
+		PRINT_ER("ParseSurveyResults() Error\n");
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
 	}
 
 
@@ -1688,15 +1692,17 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error) {
-			PRINT_ER("Handle_Connect()] failed to send config packet\n");
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+			PRINT_ER("failed to send config packet\n");
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		} else {
 			pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
 		}
 
 	} else {
 		PRINT_ER("Required BSSID not found\n");
-		WILC_ERRORREPORT(s32Error, WILC_NOT_FOUND);
+		s32Error = -ENOENT;
+		goto ERRORHANDLER;
 	}
 
 	#else
@@ -1717,7 +1723,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	ptstrJoinBssParam = (tstrJoinBssParam *)pstrHostIFconnectAttr->pJoinParams;
 	if (ptstrJoinBssParam == NULL) {
 		PRINT_ER("Required BSSID not found\n");
-		WILC_ERRORREPORT(s32Error, WILC_NOT_FOUND);
+		s32Error = -ENOENT;
+		goto ERRORHANDLER;
 	}
 	#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
@@ -1825,8 +1832,10 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].s32ValueSize = MAX_SSID_LEN + 7;
 	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
 
-	if (strWIDList[u32WidsCount].ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
+	}
 
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
 
@@ -1862,8 +1871,10 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].s32ValueSize;
 		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
 	}
-	if (strWIDList[u32WidsCount].ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
+	}
 
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
 
@@ -2012,16 +2023,17 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Handle_Connect()] failed to send config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		PRINT_ER("failed to send config packet\n");
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
 	} else {
 		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
 		pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
 	}
 	#endif
 
-	WILC_CATCH(s32Error)
-	{
+ERRORHANDLER:
+	if (s32Error) {
 		tstrConnectInfo strConnectInfo;
 
 		del_timer(&pstrWFIDrv->hConnectTimer);
@@ -2142,13 +2154,8 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(gu8FlushedJoinReqDrvHandler));
 	if (s32Error) {
-		PRINT_ER("Handle_Flush_Connect()] failed to send config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-
-	WILC_CATCH(s32Error)
-	{
-
+		PRINT_ER("failed to send config packet\n");
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -2296,7 +2303,9 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
 		ParseNetworkInfo(pstrRcvdNetworkInfo->pu8Buffer, &pstrNetworkInfo);
 		if ((pstrNetworkInfo == NULL)
 		    || (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("driver is null\n");
+			s32Error = -EINVAL;
+			goto done;
 		}
 
 		/* check whether this network is discovered before */
@@ -2363,12 +2372,6 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
 		}
 	}
 
-
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 done:
 	/* Deallocate pstrRcvdNetworkInfo->pu8Buffer which was prevoisuly allocated by the sending thread */
 	if (pstrRcvdNetworkInfo->pu8Buffer != NULL) {
@@ -2422,7 +2425,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 	    pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		if ((pstrRcvdGnrlAsyncInfo->pu8Buffer == NULL) ||
 		    (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult == NULL)) {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			PRINT_ER("driver is null\n");
+			return -EINVAL;
 		}
 
 		u8MsgType = pstrRcvdGnrlAsyncInfo->pu8Buffer[0];
@@ -2430,7 +2434,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 		/* Check whether the received message type is 'I' */
 		if ('I' != u8MsgType) {
 			PRINT_ER("Received Message format incorrect.\n");
-			WILC_ERRORREPORT(s32Error, WILC_FAIL);
+			return -EFAULT;
 		}
 
 		/* Extract message ID */
@@ -2702,11 +2706,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	/* Deallocate pstrRcvdGnrlAsyncInfo->pu8Buffer which was prevoisuly allocated by the sending thread */
 	if (pstrRcvdGnrlAsyncInfo->pu8Buffer != NULL) {
 		kfree(pstrRcvdGnrlAsyncInfo->pu8Buffer);
@@ -3127,7 +3126,6 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
 	} else {
 		tstrDisconnectNotifInfo strDisconnectNotifInfo;
 
@@ -3198,11 +3196,6 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	/* ////////////////////////// */
 	up(&(pstrWFIDrv->hSemTestDisconnectBlock));
 	/* ///////////////////////// */
@@ -3242,17 +3235,11 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 
 	if (s32Error) {
 		PRINT_D(HOSTINF_DBG, "Failed to switch log terminal\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	} else {
-		PRINT_INFO(HOSTINF_DBG, "MAC address set ::\n");
-
-
+		PRINT_ER("Failed to switch log terminal\n");
+		return -EINVAL;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
+	PRINT_INFO(HOSTINF_DBG, "MAC address set ::\n");
 
 	return s32Error;
 }
@@ -3287,14 +3274,9 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		s32Error = -EFAULT;
 	}
 
-
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	up(&(pstrWFIDrv->hSemGetCHNL));
 
 	return s32Error;
@@ -3331,13 +3313,9 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		s32Error = -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	up(&(pstrWFIDrv->hSemGetRSSI));
 
 
@@ -3363,13 +3341,9 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		s32Error = -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	up(&(pstrWFIDrv->hSemGetLINKSPEED));
 
 
@@ -3413,10 +3387,9 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(drvHandler));
 
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Failed to send scan paramters config packet\n");
-		/* WILC_ERRORREPORT(s32Error, s32Error); */
-	}
+
 	up(&hWaitResponse);
 	return 0;
 
@@ -3464,7 +3437,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		return -EFAULT;
 	}
 
 
@@ -3479,18 +3452,13 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		return -EFAULT;
 	}
 
 
 	PRINT_D(CFG80211_DBG, "Getting inactive time : %d\n", gu32InactiveTime);
 
 	up(&(pstrWFIDrv->hSemInactiveTime));
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 
 	return s32Error;
 
@@ -3522,7 +3490,7 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 	strWID.s32ValueSize = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	*pu8CurrByte++ = (pstrSetBeaconParam->u32Interval & 0xFF);
@@ -3558,14 +3526,10 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Failed to send add beacon config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 	kfree(pstrSetBeaconParam->pu8Head);
 	kfree(pstrSetBeaconParam->pu8Tail);
@@ -3594,7 +3558,7 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	strWID.ps8WidVal = &gu8DelBcn;
 
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		return;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3604,15 +3568,8 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
+	if (s32Error)
 		PRINT_ER("Failed to send delete beacon config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
-
-	WILC_CATCH(s32Error)
-	{
-	}
 }
 
 
@@ -3693,7 +3650,7 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
@@ -3701,15 +3658,10 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error != WILC_SUCCESS) {
-
+	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to send add station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
 	kfree(strWID.ps8WidVal);
 }
@@ -3741,7 +3693,7 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 
 	strWID.ps8WidVal = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3759,15 +3711,10 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
+	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 
 	up(&hWaitResponse);
@@ -3798,7 +3745,7 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3807,15 +3754,10 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
+	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 }
 
@@ -3843,7 +3785,7 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
@@ -3851,15 +3793,10 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
+	if (s32Error)
 		PRINT_ER("Failed to send edit station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
 	kfree(strWID.ps8WidVal);
 }
@@ -3897,17 +3834,20 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
 		pstrWFIDrv->u8RemainOnChan_pendingreq = 1;
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
+		s32Error = -EBUSY;
+		goto ERRORHANDLER;
 	}
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while connecting return\n");
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
+		s32Error = -EBUSY;
+		goto ERRORHANDLER;
 	}
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
+		s32Error = -EBUSY;
+		goto ERRORHANDLER;
 	}
 	#endif
 
@@ -3919,8 +3859,10 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.s32ValueSize = 2;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
-	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+	if (strWID.ps8WidVal == NULL) {
+		s32Error = -ENOMEM;
+		goto ERRORHANDLER;
+	}
 
 	strWID.ps8WidVal[0] = u8remain_on_chan_flag;
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
@@ -3931,7 +3873,7 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to set remain on channel\n");
 
-	WILC_CATCH(-1)
+ERRORHANDLER:
 	{
 		P2P_LISTEN_STATE = 1;
 		pstrWFIDrv->hRemainOnChannel.data = (unsigned long)pstrWFIDrv;
@@ -3972,7 +3914,7 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 	strWID.enuWIDtype = WID_STR;
 	strWID.ps8WidVal = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		return -ENOMEM;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3989,12 +3931,7 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-
-
-	WILC_CATCH(s32Error)
-	{
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -4085,11 +4022,7 @@ static void ListenTimerCB(unsigned long arg)
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 }
 #endif
 
@@ -4125,15 +4058,8 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Failed to send power management config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-
-	WILC_CATCH(s32Error)
-	{
-
-	}
 }
 
 /**
@@ -4158,7 +4084,7 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 	strWID.s32ValueSize = sizeof(tstrHostIFSetMulti) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	*pu8CurrByte++ = (strHostIfSetMulti->bIsEnabled & 0xFF);
@@ -4177,14 +4103,10 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(drvHandler));
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Failed to send setup multicast config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 
 }
@@ -4718,8 +4640,11 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("Failed to send setup multicast config packet\n");
+		return s32Error;
+	}
 
 	/* prepare the Remove Wep Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4741,10 +4666,6 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -4767,8 +4688,11 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("driver is null\n");
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4789,11 +4713,6 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -4823,9 +4742,11 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("driver is null\n");
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4856,10 +4777,6 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 
 }
@@ -4889,9 +4806,11 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	tstrHostIFmsg strHostIFmsg;
 	u8 i;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("driver is null\n");
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4932,10 +4851,6 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 
 }
@@ -4965,8 +4880,11 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("driver is null\n");
+		return s32Error;
+	}
 	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
 	if (pu8TxMic != NULL)
@@ -5034,11 +4952,6 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 	/* /////// */
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5064,8 +4977,11 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	tstrHostIFmsg strHostIFmsg;
 	u8 u8KeyLen = u8GtkKeylen;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("driver is null\n");
+		return s32Error;
+	}
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -5134,10 +5050,6 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 	/* /////// */
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -5169,8 +5081,11 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	u32 i;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("driver is null\n");
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -5194,11 +5109,6 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5327,14 +5237,8 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Failed to send message queue: Set mac address\n");
-		WILC_ERRORREPORT(s32Error, s32Error);
-	}
-	WILC_CATCH(s32Error)
-	{
-
-	}
 
 	return s32Error;
 
@@ -5425,12 +5329,7 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to send config packet to get survey results\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-
-	WILC_CATCH(s32Error)
-	{
-
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5520,26 +5419,22 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || pfConnectResult == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("Driver is null\n");
+		return s32Error;
+	}
 
 	if (hWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: gWFiDrvHandle = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		PRINT_ER("Driver is null\n");
+		return -EFAULT;
 	}
 
 	if (pJoinParams == NULL) {
 		PRINT_ER("Unable to Join - JoinParams is NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-
+		return -EFAULT;
 	}
-/*
- *      if(gWFiDrvHandle->strWILC_UsrScanReq.u32RcvdChCount == 0)
- *      {
- *              PRINT_ER("No scan results exist: Scanning should be done\n");
- *              WILC_ERRORREPORT(s32Error, WILC_FAIL);
- *      }
- */
+
 	/* prepare the Connect Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -5582,7 +5477,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		return -EFAULT;
 	}
 
 	enuScanConnTimer = CONNECT_TIMER;
@@ -5590,11 +5485,6 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	mod_timer(&pstrWFIDrv->hConnectTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5621,9 +5511,11 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 	}
 
 
-	if (hWFIDrv  == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (hWFIDrv  == NULL) {
+		s32Error = -EFAULT;
+		PRINT_ER("Driver is null\n");
+		return s32Error;
+	}
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_FLUSH_CONNECT;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -5632,13 +5524,9 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		return -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -5660,13 +5548,8 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
-
-	if (pstrWFIDrv == NULL)	{
-		PRINT_ER("gWFiDrvHandle = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		PRINT_ER("Driver is null\n");
+		return -EFAULT;
 	}
 
 	/* prepare the Disconnect Message */
@@ -5683,11 +5566,6 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	down(&(pstrWFIDrv->hSemTestDisconnectBlock));
 	/* /////// */
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5777,8 +5655,8 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		PRINT_ER("Driver is null\n");
+		return -EFAULT;
 	}
 
 	strWID.u16WIDid = (u16)WID_ASSOC_RES_INFO;
@@ -5791,17 +5669,13 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		PRINT_ER("Failed to send association response config packet\n");
+		return -EINVAL;
 	} else {
 		*pu32RcvdAssocRespInfoLen = strWID.s32ValueSize;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -5857,8 +5731,10 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	/* prepare the set channel message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -5867,11 +5743,9 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		PRINT_ER("wilc mq send fail\n");
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5889,11 +5763,9 @@ s32 host_int_wait_msg_queue_idle(void)
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		PRINT_ER("wilc mq send fail\n");
+		s32Error = -EINVAL;
 	}
 
 	/* wait untill MSG Q is empty */
@@ -5918,11 +5790,9 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	strHostIFmsg.drvHandler = u32address;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		PRINT_ER("wilc mq send fail\n");
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5945,11 +5815,9 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		PRINT_ER("wilc mq send fail\n");
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5977,8 +5845,8 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	tstrHostIFmsg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
 	}
 
 	/* prepare the Get Channel Message */
@@ -5990,16 +5858,12 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	/* send the message */
 	s32Error =	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		PRINT_ER("Failed to send get host channel param's message queue ");
+		PRINT_ER("wilc mq send fail\n");
 	down(&(pstrWFIDrv->hSemGetCHNL));
 	/* gu8Chnl = 11; */
 
 	*pu8ChNo = gu8Chnl;
 
-	WILC_CATCH(s32Error)
-	{
-	}
-
 	return s32Error;
 
 
@@ -6024,8 +5888,8 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
 	}
 
 	/*prepare configuration packet*/
@@ -6038,17 +5902,13 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Test Function: Failed to set wid value\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		PRINT_ER("Failed to set wid value\n");
+		return -EINVAL;
 	} else {
 		PRINT_D(HOSTINF_DBG, "Successfully set wid value\n");
 
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -6071,8 +5931,8 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	tstrHostIFmsg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
 	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -6093,10 +5953,6 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 
 	*pu32InactiveTime = gu32InactiveTime;
 
-	WILC_CATCH(s32Error)
-	{
-	}
-
 	return s32Error;
 }
 #endif
@@ -6119,8 +5975,8 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
 	}
 
 	strWID.u16WIDid = (u16)WID_MEMORY_ADDRESS;
@@ -6132,17 +5988,13 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
-		PRINT_ER("Test Function: Failed to get wid value\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		PRINT_ER("Failed to get wid value\n");
+		return -EINVAL;
 	} else {
 		PRINT_D(HOSTINF_DBG, "Successfully got wid value\n");
 
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -6283,9 +6135,10 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || ScanResult == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (pstrWFIDrv == NULL || ScanResult == NULL) {
+		PRINT_ER("pstrWFIDrv or ScanResult = NULL\n");
+		return -EFAULT;
+	}
 
 	/* prepare the Scan Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -6318,8 +6171,8 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
-		PRINT_ER("Error in sending message queue scanning parameters: Error(%d)\n", s32Error);
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		PRINT_ER("Error in sending message queue\n");
+		return -EINVAL;
 	}
 
 	enuScanConnTimer = SCAN_TIMER;
@@ -6328,10 +6181,6 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	mod_timer(&pstrWFIDrv->hScanTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 
 }
@@ -6355,8 +6204,10 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("pstrWFIDrv NULL\n");
+		return -EFAULT;
+	}
 	/* prepare the WiphyParams Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
@@ -6365,10 +6216,6 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 
-	WILC_CATCH(s32Error)
-	{
-	}
-
 	return s32Error;
 
 }
@@ -6395,8 +6242,8 @@ s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		PRINT_ER("pstrWFIDrv NULL\n");
+		return -EFAULT;
 	}
 	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
 	switch (u16WID)	{
@@ -6479,9 +6326,6 @@ s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 
-	WILC_CATCH(s32Error)
-	{
-	}
 	return s32Error;
 
 }
@@ -6593,7 +6437,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = kmalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (pstrWFIDrv == NULL) {
-		/* WILC_ERRORREPORT(s32Error,WILC_NO_MEM); */
 		s32Error = WILC_NO_MEM;
 		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
@@ -7030,8 +6873,10 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	/* prepare the remainonchan Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -7048,11 +6893,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc mq send fail\n");
 
 	return s32Error;
 }
@@ -7077,8 +6918,10 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	/*Stopping remain-on-channel timer*/
 	del_timer(&pstrWFIDrv->hRemainOnChannel);
@@ -7091,11 +6934,8 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
+		PRINT_ER("wilc mq send fail\n");
 
-	}
 	return s32Error;
 }
 
@@ -7113,8 +6953,10 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7141,11 +6983,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc mq send fail\n");
 
 	return s32Error;
 
@@ -7175,8 +7013,10 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7190,16 +7030,20 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
 	pstrSetBeaconParam->pu8Head = kmalloc(u32HeadLen, GFP_KERNEL);
-	if (pstrSetBeaconParam->pu8Head == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+	if (pstrSetBeaconParam->pu8Head == NULL) {
+		s32Error = -ENOMEM;
+		goto ERRORHANDLER;
+	}
 	memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
 	pstrSetBeaconParam->u32TailLen = u32TailLen;
 
 	/* Bug 4599 : if tail length = 0 skip allocating & copying */
 	if (u32TailLen > 0) {
 		pstrSetBeaconParam->pu8Tail = kmalloc(u32TailLen, GFP_KERNEL);
-		if (pstrSetBeaconParam->pu8Tail == NULL)
-			WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		if (pstrSetBeaconParam->pu8Tail == NULL) {
+			s32Error = -ENOMEM;
+			goto ERRORHANDLER;
+		}
 		memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
 	} else {
 		pstrSetBeaconParam->pu8Tail = NULL;
@@ -7207,10 +7051,10 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
+		PRINT_ER("wilc mq send fail\n");
 
-	WILC_CATCH(s32Error)
-	{
+ERRORHANDLER:
+	if (s32Error) {
 		if (pstrSetBeaconParam->pu8Head != NULL)
 			kfree(pstrSetBeaconParam->pu8Head);
 
@@ -7238,8 +7082,10 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BEACON;
@@ -7250,9 +7096,6 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-	WILC_CATCH(s32Error)
-	{
-	}
 	return s32Error;
 }
 
@@ -7274,8 +7117,10 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7300,11 +7145,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-
-	WILC_CATCH(s32Error)
-	{
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
 }
 
@@ -7324,8 +7165,10 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7345,11 +7188,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-
-	WILC_CATCH(s32Error)
-	{
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
 }
 /**
@@ -7372,8 +7211,10 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	u8 u8AssocNumb = 0;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7402,12 +7243,8 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 
 
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-
-	WILC_CATCH(s32Error)
-	{
+		PRINT_ER("wilc_mq_send fail\n");
 
-	}
 	down(&hWaitResponse);
 
 	return s32Error;
@@ -7430,8 +7267,10 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
 
@@ -7455,10 +7294,8 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-	}
+		PRINT_ER("wilc_mq_send fail\n");
+
 	return s32Error;
 }
 #endif /*WILC_AP_EXTERNAL_MLME*/
@@ -7473,8 +7310,10 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
@@ -7491,10 +7330,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
 }
 
@@ -7507,8 +7343,10 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
 
@@ -7524,10 +7362,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
 }
 
@@ -7776,8 +7611,10 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7792,11 +7629,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 
 	return s32Error;
 }
@@ -7809,8 +7642,10 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7823,11 +7658,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 
 	/*BugID_5222*/
 	down(&hWaitResponse);
@@ -7842,8 +7673,10 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7856,11 +7689,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 
 	/*BugID_5222*/
 	down(&hWaitResponse);
@@ -7885,8 +7714,10 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7899,11 +7730,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 
 	return s32Error;
 
@@ -7924,8 +7751,10 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		PRINT_ER("driver is null\n");
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7938,11 +7767,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		PRINT_ER("wilc_mq_send fail\n");
 
 	return s32Error;
 
diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
index 769cef0..99ded3d 100644
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ b/drivers/staging/wilc1000/wilc_errorsupport.h
@@ -38,11 +38,6 @@
 
 
 
-#define WILC_ERRORREPORT(__status__, __err__) do { \
-		PRINT_ER("PRINT_ER(%d)\n", __err__); \
-		__status__ = __err__; \
-		goto ERRORHANDLER; \
-} while (0)
 
 #define WILC_CATCH(__status__) \
 ERRORHANDLER: \
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 53b6f07..01fd94b 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -59,11 +59,15 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	Message *pstrMessage = NULL;
 
 	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
+		PRINT_ER("pHandle or pvSendBuffer is null\n");
+		s32RetStatus = -EFAULT;
+		goto ERRORHANDLER;
 	}
 
 	if (pHandle->bExiting) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
+		PRINT_ER("pHandle fail\n");
+		s32RetStatus = -EFAULT;
+		goto ERRORHANDLER;
 	}
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
@@ -97,13 +101,11 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 	up(&pHandle->hSem);
 
-	WILC_CATCH(s32RetStatus)
-	{
-		/* error occured, free any allocations */
-		if (pstrMessage) {
-			kfree(pstrMessage->pvBuffer);
-			kfree(pstrMessage);
-		}
+ERRORHANDLER:
+	/* error occured, free any allocations */
+	if (pstrMessage) {
+		kfree(pstrMessage->pvBuffer);
+		kfree(pstrMessage);
 	}
 
 	return s32RetStatus;
@@ -125,11 +127,13 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 
 	if ((!pHandle) || (u32RecvBufferSize == 0)
 	    || (!pvRecvBuffer) || (!pu32ReceivedLength)) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
+		PRINT_ER("pHandle or pvRecvBuffer is null\n");
+		return -EINVAL;
 	}
 
 	if (pHandle->bExiting) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
+		PRINT_ER("pHandle fail\n");
+		return -EFAULT;
 	}
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
@@ -138,52 +142,44 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 
 	down(&pHandle->hSem);
 
-	if (s32RetStatus == WILC_TIMEOUT) {
-		/* timed out, just exit without consumeing the message */
-		spin_lock_irqsave(&pHandle->strCriticalSection, flags);
-		pHandle->u32ReceiversCount--;
-		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
-	} else {
-		/* other non-timeout scenarios */
-		if (s32RetStatus) {
-			PRINT_ER("Non-timeout\n");
-			return s32RetStatus;
-		}
-
-		if (pHandle->bExiting) {
-			WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
-		}
-
-		spin_lock_irqsave(&pHandle->strCriticalSection, flags);
-
-		pstrMessage = pHandle->pstrMessageList;
-		if (!pstrMessage) {
-			spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
-			WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
-		}
-		/* check buffer size */
-		if (u32RecvBufferSize < pstrMessage->u32Length)	{
-			spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
-			up(&pHandle->hSem);
-			WILC_ERRORREPORT(s32RetStatus, WILC_BUFFER_OVERFLOW);
-		}
-
-		/* consume the message */
-		pHandle->u32ReceiversCount--;
-		memcpy(pvRecvBuffer, pstrMessage->pvBuffer, pstrMessage->u32Length);
-		*pu32ReceivedLength = pstrMessage->u32Length;
+	/* other non-timeout scenarios */
+	if (s32RetStatus) {
+		PRINT_ER("Non-timeout\n");
+		return s32RetStatus;
+	}
 
-		pHandle->pstrMessageList = pstrMessage->pstrNext;
+	if (pHandle->bExiting) {
+		PRINT_ER("pHandle fail\n");
+		return -EFAULT;
+	}
 
-		kfree(pstrMessage->pvBuffer);
-		kfree(pstrMessage);
+	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
+	pstrMessage = pHandle->pstrMessageList;
+	if (!pstrMessage) {
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+		PRINT_ER("pstrMessage is null\n");
+		return -EFAULT;
 	}
-
-	WILC_CATCH(s32RetStatus)
-	{
+	/* check buffer size */
+	if (u32RecvBufferSize < pstrMessage->u32Length)	{
+		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+		up(&pHandle->hSem);
+		PRINT_ER("u32RecvBufferSize overflow\n");
+		return -EOVERFLOW;
 	}
 
+	/* consume the message */
+	pHandle->u32ReceiversCount--;
+	memcpy(pvRecvBuffer, pstrMessage->pvBuffer, pstrMessage->u32Length);
+	*pu32ReceivedLength = pstrMessage->u32Length;
+
+	pHandle->pstrMessageList = pstrMessage->pstrNext;
+
+	kfree(pstrMessage->pvBuffer);
+	kfree(pstrMessage);
+
+	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+
 	return s32RetStatus;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 72fc105..48def8c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -374,7 +374,6 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 	struct wiphy *wiphy;
 	s32 s32Freq;
 	struct ieee80211_channel *channel;
-	s32 s32Error = WILC_SUCCESS;
 	struct cfg80211_bss *bss = NULL;
 
 	priv = (struct wilc_priv *)pUserVoid;
@@ -391,7 +390,8 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 			     ||
 			     (((s32)pstrNetworkInfo->s8rssi) * 100) > 100)
 			    ) {
-				WILC_ERRORREPORT(s32Error, WILC_FAIL);
+				PRINT_ER("wiphy signal type fial\n");
+				return;
 			}
 
 			if (pstrNetworkInfo != NULL) {
@@ -485,11 +485,6 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 			up(&(priv->hSemScanReq));
 		}
 	}
-
-
-	WILC_CATCH(s32Error)
-	{
-	}
 }
 
 
-- 
1.9.1

