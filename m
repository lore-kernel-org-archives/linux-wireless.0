Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:56663 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbIOCyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 22:54:11 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/7] staging: wilc1000: remove definition WILC_ERRORREPORT
Date: Tue, 15 Sep 2015 11:53:38 +0900
Message-ID: <1442285621-29457-5-git-send-email-tony.cho@atmel.com> (sfid-20150915_045416_097390_8B897F54)
In-Reply-To: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
References: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the definition WILC_ERRORREPORT which is not used
anymore, and also replace PRINT_ER with printk error log.

The compiler complains the build warnings in some functions for WILC_CATCH and
ERRORHANDLER as unused definitions. So, this patch also removes WILC_CATCH and
ERRORHANDLER in some of functions.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |   6 +-
 drivers/staging/wilc1000/host_interface.c         | 919 +++++++++-------------
 drivers/staging/wilc1000/wilc_errorsupport.h      |   5 -
 drivers/staging/wilc1000/wilc_msgqueue.c          |  98 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   9 +-
 5 files changed, 425 insertions(+), 612 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e0a41c5..8389565 100644
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
@@ -428,8 +429,8 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 	/* Check whether the received message type is 'N' */
 	if ('N' != u8MsgType) {
-		PRINT_ER("Received Message format incorrect.\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Received Message format incorrect.\n", __func__);
+		return -EFAULT;
 	}
 
 	/* Extract message ID */
@@ -525,7 +526,6 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 	*ppstrNetworkInfo = pstrNetworkInfo;
 
-ERRORHANDLER:
 	return s32Error;
 }
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 273d547..86d1828 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -670,12 +670,8 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Failed to set channel\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		printk(KERN_ERR "%s : Failed to set channel\n", __func__);
+		return -EINVAL;
 	}
 
 	return s32Error;
@@ -714,12 +710,8 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 
 
 	if (s32Error) {
-		PRINT_ER("Failed to set driver handler\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		printk(KERN_ERR "%s : Failed to set driver handler\n", __func__);
+		return -EINVAL;
 	}
 
 	return s32Error;
@@ -760,12 +752,8 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 
 
 	if (s32Error) {
-		PRINT_ER("Failed to set driver handler\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		printk(KERN_ERR "%s : Failed to set driver handler\n", __func__);
+		return -EINVAL;
 	}
 
 	return s32Error;
@@ -808,17 +796,12 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
 
 	if (s32Error) {
-		PRINT_D(HOSTINF_DBG, "Failed to set IP address\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		printk(KERN_ERR "%s : Failed to set IP address\n", __func__);
+		return -EINVAL;
 	} else {
 		PRINT_INFO(HOSTINF_DBG, "IP address set\n");
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -859,19 +842,14 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 		host_int_setup_ipaddress(pstrWFIDrv, gs8SetIP[idx], idx);
 
 	if (s32Error != WILC_SUCCESS) {
-		PRINT_ER("Failed to get IP address\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		printk(KERN_ERR "%s : Failed to get IP address\n", __func__);
+		return -EINVAL;
 	} else {
 		PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d\n", idx);
 		PRINT_INFO(HOSTINF_DBG, "%pI4\n", gs8GetIP[idx]);
 		PRINT_INFO(HOSTINF_DBG, "\n");
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -910,14 +888,10 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Failed to set mac address\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to set mac address\n", __func__);
+		s32Error = -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	kfree(mac_buf);
 	return s32Error;
 }
@@ -949,12 +923,8 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false,
 				 get_id_from_handler(drvHandler));
 	if (s32Error) {
-		PRINT_ER("Failed to get mac address\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
-	WILC_CATCH(s32Error)
-	{
-
+		printk(KERN_ERR "%s : Failed to get mac address\n", __func__);
+		s32Error = -EFAULT;
 	}
 	up(&hWaitResponse);
 
@@ -998,7 +968,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1016,7 +988,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1029,7 +1003,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.auth_timeout = strHostIFCfgParamAttr->pstrCfgParamVal.auth_timeout;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1048,7 +1024,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1061,7 +1039,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.short_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.short_retry_limit;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1075,7 +1055,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.long_retry_limit = strHostIFCfgParamAttr->pstrCfgParamVal.long_retry_limit;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1088,7 +1070,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.frag_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.frag_threshold;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1101,7 +1085,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.rts_threshold = strHostIFCfgParamAttr->pstrCfgParamVal.rts_threshold;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1118,7 +1104,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1130,7 +1118,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1146,7 +1136,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1159,7 +1151,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.beacon_interval = strHostIFCfgParamAttr->pstrCfgParamVal.beacon_interval;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1172,7 +1166,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1189,7 +1185,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1202,7 +1200,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.site_survey_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_scan_time;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1215,7 +1215,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.active_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.active_scan_time;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1228,7 +1230,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.passive_scan_time = strHostIFCfgParamAttr->pstrCfgParamVal.passive_scan_time;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1251,7 +1255,9 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 			strWIDList[u8WidCnt].s32ValueSize = sizeof(u16);
 			pstrWFIDrv->strCfgValues.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s \n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		}
 		u8WidCnt++;
 	}
@@ -1261,9 +1267,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER :
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 	return s32Error;
 }
@@ -1319,13 +1323,17 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	if ((pstrWFIDrv->enuHostIFstate >= HOST_IF_SCANNING) && (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTED)) {
 		/* here we either in HOST_IF_SCANNING, HOST_IF_WAITING_CONN_REQ or HOST_IF_WAITING_CONN_RESP */
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", pstrWFIDrv->enuHostIFstate);
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
+		printk(KERN_ERR "%s \n", __func__);
+		s32Error = -EBUSY;
+		goto ERRORHANDLER;
 	}
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
+		printk(KERN_ERR "%s \n", __func__);
+		s32Error = -EBUSY;
+		goto ERRORHANDLER;
 	}
 	#endif
 
@@ -1416,15 +1424,13 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
 
-	if (s32Error) {
-		PRINT_ER("Failed to send scan paramters config packet\n");
-		WILC_ERRORREPORT(s32Error, s32Error);
-	} else {
+	if (s32Error)
+		printk(KERN_ERR "%s : Failed to send scan paramters config packet\n", __func__);
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
@@ -1493,12 +1499,9 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		/*Sending Cfg*/
 		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
-		if (s32Error != WILC_SUCCESS) {
-			PRINT_ER("Failed to set abort running scan\n");
-			WILC_ERRORREPORT(s32Error, WILC_FAIL);
-		}
-		WILC_CATCH(s32Error)
-		{
+		if (s32Error) {
+			printk(KERN_ERR "%s : Failed to set abort running scan\n", __func__);
+			s32Error = -EFAULT;
 		}
 	}
 
@@ -1560,9 +1563,9 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 						  gapu8RcvdSurveyResults,
 						  MAX_SURVEY_RESULT_FRAG_SIZE);
 	if (s32Err) {
-		PRINT_ER("Failed to get site survey results\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-
+		printk(KERN_ERR "%s : Failed to get site survey results\n", __func__);
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
 	}
 	s32Err = ParseSurveyResults(gapu8RcvdSurveyResults, &pstrSurveyResults,
 				    &pstrWFIDrv->u32SurveyResultsCount);
@@ -1578,8 +1581,9 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 		DeallocateSurveyResults(pstrSurveyResults);
 	} else {
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-		PRINT_ER("ParseSurveyResults() Error(%d)\n", s32Err);
+		printk(KERN_ERR "%s : ParseSurveyResults() Error(%d)\n", __func__, s32Err);
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
 	}
 
 
@@ -1691,15 +1695,17 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error) {
-			PRINT_ER("Handle_Connect()] failed to send config packet\n");
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+			printk(KERN_ERR "%s : Handle_Connect()] failed to send config packet\n", __func__);
+			s32Error = -EINVAL;
+			goto ERRORHANDLER;
 		} else {
 			pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
 		}
 
 	} else {
-		PRINT_ER("Required BSSID not found\n");
-		WILC_ERRORREPORT(s32Error, WILC_NOT_FOUND);
+		printk(KERN_ERR "%s : Required BSSID not found\n", __func__);
+		s32Error = -ENOENT;
+		goto ERRORHANDLER;
 	}
 
 	#else
@@ -1719,8 +1725,9 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	#ifdef WILC_PARSE_SCAN_IN_HOST
 	ptstrJoinBssParam = (tstrJoinBssParam *)pstrHostIFconnectAttr->pJoinParams;
 	if (ptstrJoinBssParam == NULL) {
-		PRINT_ER("Required BSSID not found\n");
-		WILC_ERRORREPORT(s32Error, WILC_NOT_FOUND);
+		printk(KERN_ERR "%s : Required BSSID not found\n", __func__);
+		s32Error = -ENOENT;
+		goto ERRORHANDLER;
 	}
 	#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
@@ -1828,8 +1835,10 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].s32ValueSize = MAX_SSID_LEN + 7;
 	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
 
-	if (strWIDList[u32WidsCount].ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
+	}
 
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
 
@@ -1865,8 +1874,10 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
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
 
@@ -2015,15 +2026,17 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Handle_Connect()] failed to send config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		printk(KERN_ERR "%s : Handle_Connect() failed to send config packet\n", __func__);
+		s32Error = -EFAULT;
+		goto ERRORHANDLER;
 	} else {
 		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
 		pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
 	}
 	#endif
 
-	WILC_CATCH(s32Error)
+ERRORHANDLER:
+	if (s32Error)
 	{
 		tstrConnectInfo strConnectInfo;
 
@@ -2145,13 +2158,8 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
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
+		printk(KERN_ERR "%s : Handle_Flush_Connect()] failed to send config packet\n", __func__);
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -2299,7 +2307,9 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
 		ParseNetworkInfo(pstrRcvdNetworkInfo->pu8Buffer, &pstrNetworkInfo);
 		if ((pstrNetworkInfo == NULL)
 		    || (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s : \n", __func__);
+			s32Error = -EINVAL;
+			goto done;
 		}
 
 		/* check whether this network is discovered before */
@@ -2366,12 +2376,6 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
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
@@ -2425,15 +2429,16 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 	    pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		if ((pstrRcvdGnrlAsyncInfo->pu8Buffer == NULL) ||
 		    (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult == NULL)) {
-			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+			printk(KERN_ERR "%s : \n", __func__);
+			return -EINVAL;
 		}
 
 		u8MsgType = pstrRcvdGnrlAsyncInfo->pu8Buffer[0];
 
 		/* Check whether the received message type is 'I' */
 		if ('I' != u8MsgType) {
-			PRINT_ER("Received Message format incorrect.\n");
-			WILC_ERRORREPORT(s32Error, WILC_FAIL);
+			printk(KERN_ERR "%s : Received Message format incorrect.\n", __func__);
+			return -EFAULT;
 		}
 
 		/* Extract message ID */
@@ -2705,11 +2710,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	/* Deallocate pstrRcvdGnrlAsyncInfo->pu8Buffer which was prevoisuly allocated by the sending thread */
 	if (pstrRcvdGnrlAsyncInfo->pu8Buffer != NULL) {
 		kfree(pstrRcvdGnrlAsyncInfo->pu8Buffer);
@@ -3129,8 +3129,7 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error) {
-		PRINT_ER("Failed to send dissconect config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to send dissconect config packet\n", __func__);
 	} else {
 		tstrDisconnectNotifInfo strDisconnectNotifInfo;
 
@@ -3201,11 +3200,6 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	/* ////////////////////////// */
 	up(&(pstrWFIDrv->hSemTestDisconnectBlock));
 	/* ///////////////////////// */
@@ -3245,16 +3239,10 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 
 	if (s32Error) {
 		PRINT_D(HOSTINF_DBG, "Failed to switch log terminal\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		printk(KERN_ERR "%s : \n", __func__);
+		return -EINVAL;
 	} else {
 		PRINT_INFO(HOSTINF_DBG, "MAC address set ::\n");
-
-
-	}
-
-	WILC_CATCH(s32Error)
-	{
-
 	}
 
 	return s32Error;
@@ -3289,15 +3277,10 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
-		PRINT_ER("Failed to get channel number\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to get channel number\n", __func__);
+		s32Error = -EFAULT;
 	}
 
-
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	up(&(pstrWFIDrv->hSemGetCHNL));
 
 	return s32Error;
@@ -3333,14 +3316,10 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Failed to get RSSI value\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to get RSSI value\n", __func__);
+		s32Error = -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	up(&(pstrWFIDrv->hSemGetRSSI));
 
 
@@ -3365,14 +3344,10 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Failed to get LINKSPEED value\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to get LINKSPEED value\n", __func__);
+		s32Error = -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	up(&(pstrWFIDrv->hSemGetLINKSPEED));
 
 
@@ -3416,10 +3391,9 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
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
 
@@ -3466,8 +3440,8 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
-		PRINT_ER("Failed to SET incative time\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to SET incative time\n", __func__);
+		return -EFAULT;
 	}
 
 
@@ -3481,19 +3455,14 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
-		PRINT_ER("Failed to get incative time\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to get incative time\n", __func__);
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
 
@@ -3525,7 +3494,7 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 	strWID.s32ValueSize = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	*pu8CurrByte++ = (pstrSetBeaconParam->u32Interval & 0xFF);
@@ -3561,14 +3530,10 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-		PRINT_ER("Failed to send add beacon config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s : Failed to send add beacon config packet\n", __func__);
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 	kfree(pstrSetBeaconParam->pu8Head);
 	kfree(pstrSetBeaconParam->pu8Tail);
@@ -3597,7 +3562,7 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	strWID.ps8WidVal = &gu8DelBcn;
 
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		return;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3607,15 +3572,8 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
-		PRINT_ER("Failed to send delete beacon config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
-
-	WILC_CATCH(s32Error)
-	{
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s : Failed to send delete beacon config packet\n", __func__);
 }
 
 
@@ -3696,7 +3654,7 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
@@ -3704,15 +3662,10 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error != WILC_SUCCESS) {
-
-		PRINT_ER("Failed to send add station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
+	if (s32Error != WILC_SUCCESS)
+		printk(KERN_ERR "%s : Failed to send add station config packet\n", __func__);
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
 	kfree(strWID.ps8WidVal);
 }
@@ -3744,7 +3697,7 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 
 	strWID.ps8WidVal = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3762,15 +3715,10 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
-		PRINT_ER("Failed to send add station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s : Failed to send add station config packet\n", __func__);
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 
 	up(&hWaitResponse);
@@ -3801,7 +3749,7 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3810,15 +3758,10 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
-		PRINT_ER("Failed to send add station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s : Failed to send add station config packet\n", __func__);
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 }
 
@@ -3846,7 +3789,7 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
@@ -3854,15 +3797,10 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-
-		PRINT_ER("Failed to send edit station config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s : Failed to send edit station config packet\n", __func__);
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
 	kfree(strWID.ps8WidVal);
 }
@@ -3900,17 +3838,20 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
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
 
@@ -3922,8 +3863,10 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
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
@@ -3934,7 +3877,7 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to set remain on channel\n");
 
-	WILC_CATCH(-1)
+ERRORHANDLER:
 	{
 		P2P_LISTEN_STATE = 1;
 		pstrWFIDrv->hRemainOnChannel.data = (unsigned long)pstrWFIDrv;
@@ -3975,7 +3918,7 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 	strWID.enuWIDtype = WID_STR;
 	strWID.ps8WidVal = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		return -ENOMEM;
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3991,13 +3934,8 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Failed to frame register config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-
-
-	WILC_CATCH(s32Error)
-	{
+		printk(KERN_ERR "%s : Failed to frame register config packet\n", __func__);
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -4088,11 +4026,7 @@ static void ListenTimerCB(unsigned long arg)
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s : wilc_mq_send fail\n", __func__);
 }
 #endif
 
@@ -4128,15 +4062,8 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error) {
-		PRINT_ER("Failed to send power management config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-
-	WILC_CATCH(s32Error)
-	{
-
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s :Failed to send power management config packet\n", __func__);
 }
 
 /**
@@ -4161,7 +4088,7 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 	strWID.s32ValueSize = sizeof(tstrHostIFSetMulti) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
+		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.ps8WidVal;
 	*pu8CurrByte++ = (strHostIfSetMulti->bIsEnabled & 0xFF);
@@ -4180,14 +4107,10 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(drvHandler));
-	if (s32Error) {
-		PRINT_ER("Failed to send setup multicast config packet\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s :Failed to send setup multicast config packet\n", __func__);
 
-	WILC_CATCH(s32Error)
-	{
-	}
+ERRORHANDLER:
 	kfree(strWID.ps8WidVal);
 
 }
@@ -4721,8 +4644,11 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 
 	/* prepare the Remove Wep Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4744,10 +4670,6 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -4770,8 +4692,11 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4792,11 +4717,6 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -4826,9 +4746,11 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4859,10 +4781,6 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 
 }
@@ -4892,9 +4810,11 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	tstrHostIFmsg strHostIFmsg;
 	u8 i;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4935,10 +4855,6 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 
 }
@@ -4968,8 +4884,11 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
 	if (pu8TxMic != NULL)
@@ -5037,11 +4956,6 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 	/* /////// */
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5067,8 +4981,11 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	tstrHostIFmsg strHostIFmsg;
 	u8 u8KeyLen = u8GtkKeylen;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -5137,10 +5054,6 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 	/* /////// */
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -5172,8 +5085,11 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	u32 i;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 
 	/* prepare the Key Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -5197,11 +5113,6 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5330,14 +5241,8 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error) {
-		PRINT_ER("Failed to send message queue: Set mac address\n");
-		WILC_ERRORREPORT(s32Error, s32Error);
-	}
-	WILC_CATCH(s32Error)
-	{
-
-	}
+	if (s32Error)
+		printk(KERN_ERR "%s : Failed to send message queue: Set mac address\n", __func__);
 
 	return s32Error;
 
@@ -5427,13 +5332,8 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
-		PRINT_ER("Failed to send config packet to get survey results\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
-	}
-
-	WILC_CATCH(s32Error)
-	{
-
+		printk(KERN_ERR "%s : Failed to send config packet to get survey results\n", __func__);
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5523,26 +5423,22 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || pfConnectResult == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 
 	if (hWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: gWFiDrvHandle = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 
 	if (pJoinParams == NULL) {
-		PRINT_ER("Unable to Join - JoinParams is NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-
+		printk(KERN_ERR "%s : Unable to Join - JoinParams is NULL\n", __func__);
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
 
@@ -5584,8 +5480,8 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
-		PRINT_ER("Failed to send message queue: Set join request\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to send message queue: Set join request\n", __func__);
+		return -EFAULT;
 	}
 
 	enuScanConnTimer = CONNECT_TIMER;
@@ -5593,11 +5489,6 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	mod_timer(&pstrWFIDrv->hConnectTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5624,9 +5515,11 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 	}
 
 
-	if (hWFIDrv  == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (hWFIDrv  == NULL) {
+		s32Error = -EFAULT;
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+		return s32Error;
+	}
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_FLUSH_CONNECT;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -5634,14 +5527,10 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
-		PRINT_ER("Failed to send message queue: Flush join request\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Failed to send message queue: Flush join request\n", __func__);
+		return -EFAULT;
 	}
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 }
 
@@ -5663,13 +5552,8 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
-
-	if (pstrWFIDrv == NULL)	{
-		PRINT_ER("gWFiDrvHandle = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 
 	/* prepare the Disconnect Message */
@@ -5686,11 +5570,6 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	down(&(pstrWFIDrv->hSemTestDisconnectBlock));
 	/* /////// */
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
-
 	return s32Error;
 }
 
@@ -5780,8 +5659,8 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 
 	strWID.u16WIDid = (u16)WID_ASSOC_RES_INFO;
@@ -5794,17 +5673,13 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		printk(KERN_ERR "%s : Failed to send association response config packet\n", __func__);
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
 
@@ -5860,8 +5735,10 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	/* prepare the set channel message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -5870,11 +5747,9 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		printk(KERN_ERR "%s :\n", __func__);
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5892,11 +5767,9 @@ s32 host_int_wait_msg_queue_idle(void)
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		printk(KERN_ERR "%s : %d\n", __func__, s32Error);
+		s32Error = -EINVAL;
 	}
 
 	/* wait untill MSG Q is empty */
@@ -5921,11 +5794,9 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	strHostIFmsg.drvHandler = u32address;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		printk(KERN_ERR "%s : %d\n", __func__, s32Error);
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5948,11 +5819,9 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
+	if (s32Error) {
+		printk(KERN_ERR "%s : %d\n", __func__, s32Error);
+		s32Error = -EINVAL;
 	}
 
 	return s32Error;
@@ -5980,8 +5849,8 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	tstrHostIFmsg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 
 	/* prepare the Get Channel Message */
@@ -5999,10 +5868,6 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 
 	*pu8ChNo = gu8Chnl;
 
-	WILC_CATCH(s32Error)
-	{
-	}
-
 	return s32Error;
 
 
@@ -6027,8 +5892,8 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 
 	/*prepare configuration packet*/
@@ -6041,17 +5906,13 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
-		PRINT_ER("Test Function: Failed to set wid value\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		printk(KERN_ERR "%s : Test Function: Failed to set wid value\n", __func__);
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
 
@@ -6074,8 +5935,8 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	tstrHostIFmsg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -6096,10 +5957,6 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 
 	*pu32InactiveTime = gu32InactiveTime;
 
-	WILC_CATCH(s32Error)
-	{
-	}
-
 	return s32Error;
 }
 #endif
@@ -6122,8 +5979,8 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 
 	strWID.u16WIDid = (u16)WID_MEMORY_ADDRESS;
@@ -6135,17 +5992,13 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
-		PRINT_ER("Test Function: Failed to get wid value\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
+		printk(KERN_ERR "%s : Test Function: Failed to get wid value\n", __func__);
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
 
@@ -6286,9 +6139,10 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || ScanResult == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-
+	if (pstrWFIDrv == NULL || ScanResult == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv or ScanResult = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	/* prepare the Scan Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -6321,8 +6175,8 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
-		PRINT_ER("Error in sending message queue scanning parameters: Error(%d)\n", s32Error);
-		WILC_ERRORREPORT(s32Error, WILC_FAIL);
+		printk(KERN_ERR "%s : Error in sending message queue scanning parameters: Error(%d)\n", __func__, s32Error);
+		return -EINVAL;
 	}
 
 	enuScanConnTimer = SCAN_TIMER;
@@ -6331,10 +6185,6 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	mod_timer(&pstrWFIDrv->hScanTimer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
-	WILC_CATCH(s32Error)
-	{
-
-	}
 	return s32Error;
 
 }
@@ -6358,8 +6208,10 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 	/* prepare the WiphyParams Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
@@ -6368,10 +6220,6 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 
-	WILC_CATCH(s32Error)
-	{
-	}
-
 	return s32Error;
 
 }
@@ -6398,8 +6246,8 @@ s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
 	}
 	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
 	switch (u16WID)	{
@@ -6482,9 +6330,6 @@ s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 
 	up(&(pstrWFIDrv->gtOsCfgValuesSem));
 
-	WILC_CATCH(s32Error)
-	{
-	}
 	return s32Error;
 
 }
@@ -6596,7 +6441,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = kmalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (pstrWFIDrv == NULL) {
-		/* WILC_ERRORREPORT(s32Error,WILC_NO_MEM); */
 		s32Error = WILC_NO_MEM;
 		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
@@ -7033,8 +6877,10 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	/* prepare the remainonchan Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -7051,11 +6897,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s : %d\n", __func__, s32Error);
 
 	return s32Error;
 }
@@ -7080,8 +6922,10 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	/*Stopping remain-on-channel timer*/
 	del_timer(&pstrWFIDrv->hRemainOnChannel);
@@ -7094,11 +6938,8 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
+		printk(KERN_ERR "%s : %d\n", __func__, s32Error);
 
-	}
 	return s32Error;
 }
 
@@ -7116,8 +6957,10 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7144,11 +6987,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s : %d\n", __func__, s32Error);
 
 	return s32Error;
 
@@ -7178,8 +7017,10 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7193,16 +7034,20 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
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
@@ -7210,9 +7055,10 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
+		printk(KERN_ERR "%s : %d\n", __func__, s32Error);
 
-	WILC_CATCH(s32Error)
+ERRORHANDLER:
+	if (s32Error)
 	{
 		if (pstrSetBeaconParam->pu8Head != NULL)
 			kfree(pstrSetBeaconParam->pu8Head);
@@ -7241,8 +7087,10 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BEACON;
@@ -7253,9 +7101,6 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	if (s32Error)
 		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
-	WILC_CATCH(s32Error)
-	{
-	}
 	return s32Error;
 }
 
@@ -7277,8 +7122,10 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7303,11 +7150,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-
-	WILC_CATCH(s32Error)
-	{
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 	return s32Error;
 }
 
@@ -7327,8 +7170,10 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7348,11 +7193,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-
-	WILC_CATCH(s32Error)
-	{
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 	return s32Error;
 }
 /**
@@ -7375,8 +7216,10 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	u8 u8AssocNumb = 0;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7405,12 +7248,8 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 
 
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-
-	WILC_CATCH(s32Error)
-	{
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
-	}
 	down(&hWaitResponse);
 
 	return s32Error;
@@ -7433,8 +7272,10 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
 
@@ -7458,10 +7299,8 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
+
 	return s32Error;
 }
 #endif /*WILC_AP_EXTERNAL_MLME*/
@@ -7476,8 +7315,10 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
@@ -7494,10 +7335,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 	return s32Error;
 }
 
@@ -7510,8 +7348,10 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
 
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
 
@@ -7527,10 +7367,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 	return s32Error;
 }
 
@@ -7779,8 +7616,10 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7795,11 +7634,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
 	return s32Error;
 }
@@ -7812,8 +7647,10 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7826,11 +7663,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
 	/*BugID_5222*/
 	down(&hWaitResponse);
@@ -7845,8 +7678,10 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7859,11 +7694,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
 	/*BugID_5222*/
 	down(&hWaitResponse);
@@ -7888,8 +7719,10 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7902,11 +7735,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
 	return s32Error;
 
@@ -7927,8 +7756,10 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL)
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
+	if (pstrWFIDrv == NULL) {
+		printk(KERN_ERR "%s: pstrWFIDrv = NULL\n", __func__);
+		return -EFAULT;
+	}
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7941,11 +7772,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
-		WILC_ERRORREPORT(s32Error, s32Error);
-	WILC_CATCH(s32Error)
-	{
-
-	}
+		printk(KERN_ERR "%s: %d\n", __func__, s32Error);
 
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
index 2f77e71..7543149 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -59,11 +59,15 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	Message *pstrMessage = NULL;
 
 	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
+		printk(KERN_ERR "%s: \n", __func__);
+		s32RetStatus = -EFAULT;	
+		goto ERRORHANDLER;
 	}
 
 	if (pHandle->bExiting) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
+		printk(KERN_ERR "%s: \n", __func__);
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
+		printk(KERN_ERR "%s : \n", __func__);
+		return -EINVAL;
 	}
 
 	if (pHandle->bExiting) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
+		printk(KERN_ERR "%s : \n", __func__);
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
-			printk(KERN_ERR "%s: %d\n", __func__, s32RetStatus);
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
+		printk(KERN_ERR "%s: WILC_MsgQueueHandle is fail\n", __func__);
+		return s32RetStatus;
+	}
 
-		pHandle->pstrMessageList = pstrMessage->pstrNext;
+	if (pHandle->bExiting) {
+		printk(KERN_ERR "%s : \n", __func__);
+		return -EFAULT;
+	}
 
-		kfree(pstrMessage->pvBuffer);
-		kfree(pstrMessage);
+	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
+	pstrMessage = pHandle->pstrMessageList;
+	if (!pstrMessage) {
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+		printk(KERN_ERR "%s : \n", __func__);
+		return -EFAULT;
 	}
-
-	WILC_CATCH(s32RetStatus)
-	{
+	/* check buffer size */
+	if (u32RecvBufferSize < pstrMessage->u32Length)	{
+		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+		up(&pHandle->hSem);
+		printk(KERN_ERR "%s : \n", __func__);
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
index 7083c77..f7d3392 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -375,7 +375,6 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 	struct wiphy *wiphy;
 	s32 s32Freq;
 	struct ieee80211_channel *channel;
-	s32 s32Error = WILC_SUCCESS;
 	struct cfg80211_bss *bss = NULL;
 
 	priv = (struct WILC_WFI_priv *)pUserVoid;
@@ -392,7 +391,8 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 			     ||
 			     (((s32)pstrNetworkInfo->s8rssi) * 100) > 100)
 			    ) {
-				WILC_ERRORREPORT(s32Error, WILC_FAIL);
+					printk(KERN_ERR "%s : \n", __func__);
+					return;
 			}
 
 			if (pstrNetworkInfo != NULL) {
@@ -486,11 +486,6 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
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

