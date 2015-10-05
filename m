Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9031 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbJEG2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:28:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/18] staging: wilc1000: host_interface.c : remove unused functions
Date: Mon, 5 Oct 2015 15:25:53 +0900
Message-ID: <1444026353-29024-18-git-send-email-tony.cho@atmel.com> (sfid-20151005_082805_645286_980D84AE)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused functions from the host_interface.c(h).
 - Switch_Log_Terminal
 - Handle_DelBASession
 - host_int_addBASession

This patch includes the removal of the comment for host_int_addBASession
as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 143 ------------------------------
 drivers/staging/wilc1000/host_interface.h |   4 -
 2 files changed, 147 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dd444d1..dbaebad 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2260,7 +2260,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
 
 				/* open a BA session if possible */
 				/* if(pstrWFIDrv->strWILC_UsrConnReq.IsHTCapable) */
-				/* host_int_addBASession(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid,0, */
 				/* BA_SESSION_DEFAULT_BUFFER_SIZE,BA_SESSION_DEFAULT_TIMEOUT); */
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
@@ -2884,34 +2883,6 @@ void resolve_disconnect_aberration(tstrWILC_WFIDrv *drvHandler)
 		host_int_disconnect(pstrWFIDrv, 1);
 	}
 }
-static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
-{
-
-
-	s32 s32Error = 0;
-	tstrWID strWID;
-	static char dummy = 9;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
-
-	strWID.u16WIDid = (u16)WID_LOGTerminal_Switch;
-	strWID.enuWIDtype = WID_CHAR;
-	strWID.ps8WidVal = &dummy;
-	strWID.s32ValueSize = sizeof(char);
-
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
-				   get_id_from_handler(pstrWFIDrv));
-
-
-	if (s32Error) {
-		PRINT_D(HOSTINF_DBG, "Failed to switch log terminal\n");
-		PRINT_ER("Failed to switch log terminal\n");
-		return -EINVAL;
-	}
-
-	PRINT_INFO(HOSTINF_DBG, "MAC address set ::\n");
-
-	return s32Error;
-}
 
 /**
  *  @brief Handle_GetChnl
@@ -3870,79 +3841,6 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler,
 
 }
 
-
-/**
- *  @brief                      Handle_DelBASession
- *  @details            Delete block ack session
- *  @param[in]          tstrHostIFSetMulti* strHostIfSetMulti
- *  @return             NONE
- *  @author		Amr Abdel-Moghny
- *  @date			Feb. 2013
- *  @version		9.0
- */
-static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler,
-			       struct ba_session_info *strHostIfBASessionInfo)
-{
-	s32 s32Error = 0;
-	tstrWID strWID;
-	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
-
-	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
-		strHostIfBASessionInfo->au8Bssid[0],
-		strHostIfBASessionInfo->au8Bssid[1],
-		strHostIfBASessionInfo->au8Bssid[2],
-		strHostIfBASessionInfo->u8Ted);
-
-	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
-	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
-	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
-	ptr = strWID.ps8WidVal;
-	/* *ptr++ = 0x14; */
-	*ptr++ = 0x14;
-	*ptr++ = 0x3;
-	*ptr++ = 0x2;
-	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
-	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
-	/* BA direction = recipent*/
-	*ptr++ = 0;
-	/* Delba Reason */
-	*ptr++ = 32; /* Unspecific QOS reason */
-
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
-				   get_id_from_handler(pstrWFIDrv));
-	if (s32Error)
-		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
-
-
-	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
-	strWID.enuWIDtype = WID_STR;
-	strWID.s32ValueSize = 15;
-	ptr = strWID.ps8WidVal;
-	/* *ptr++ = 0x14; */
-	*ptr++ = 15;
-	*ptr++ = 7;
-	*ptr++ = 0x3;
-	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
-	ptr += ETH_ALEN;
-	/* TID*/
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
-
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
-				   get_id_from_handler(pstrWFIDrv));
-
-	if (strWID.ps8WidVal != NULL)
-		kfree(strWID.ps8WidVal);
-
-	up(&hWaitResponse);
-
-	return s32Error;
-
-}
-
-
 /**
  *  @brief                      Handle_DelAllRxBASessions
  *  @details            Delete all Rx BA sessions
@@ -7097,47 +6995,6 @@ void host_int_freeJoinParams(void *pJoinParams)
 		PRINT_ER("Unable to FREE null pointer\n");
 }
 
-/**
- *  @brief              host_int_addBASession
- *  @details            Open a block Ack session with the given parameters
- *  @param[in]          tstrNetworkInfo* ptstrNetworkInfo
- *  @return
- *  @author		anoureldin
- *  @date
- *  @version		1.0**/
-
-static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
-				 short int SessionTimeout, void *drvHandler)
-{
-	s32 s32Error = 0;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg msg;
-	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
-
-	if (pstrWFIDrv == NULL) {
-		PRINT_ER("driver is null\n");
-		return -EFAULT;
-	}
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	/* prepare the WiphyParams Message */
-	msg.id = HOST_IF_MSG_ADD_BA_SESSION;
-
-	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->u8Ted = TID;
-	pBASessionInfo->u16BufferSize = BufferSize;
-	pBASessionInfo->u16SessionTimeout = SessionTimeout;
-	msg.drvHandler = hWFIDrv;
-
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-	if (s32Error)
-		PRINT_ER("wilc_mq_send fail\n");
-
-	return s32Error;
-}
-
-
 s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7c2846e..7391903 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1191,10 +1191,6 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
 
-static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
-				 short int SessionTimeout, void *drvHandler);
-
-
 void host_int_freeJoinParams(void *pJoinParams);
 
 s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics);
-- 
1.9.1

