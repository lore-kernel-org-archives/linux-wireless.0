Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44239 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbbGaHjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:45 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/28] staging: wilc1000: remove unused variables
Date: Fri, 31 Jul 2015 16:38:15 +0900
Message-ID: <1438328316-30197-8-git-send-email-tony.cho@atmel.com> (sfid-20150731_093947_714048_94388ADE)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch removes unused variable pstrWFIDrv.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c8ebf51..66565f6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -607,7 +607,6 @@ static s32 Handle_SetChannel(WILC_WFIDrvHandle drvHandler, tstrHostIFSetChan *ps
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
@@ -733,7 +732,6 @@ s32 Handle_set_IPAddress(WILC_WFIDrvHandle drvHandler, u8 *pu8IPAddr, u8 idx)
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	char firmwareIPAddress[4] = {0};
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	if (pu8IPAddr[0] < 192)
 		pu8IPAddr[0] = 0;
@@ -837,7 +835,6 @@ static s32 Handle_SetMacAddress(WILC_WFIDrvHandle drvHandler, tstrHostIfSetMacAd
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 *mac_buf = (u8 *)WILC_MALLOC(ETH_ALEN);
 
 	if (mac_buf == NULL) {
@@ -3161,7 +3158,6 @@ static s32 Switch_Log_Terminal(WILC_WFIDrvHandle drvHandler)
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	static char dummy = 9;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_LOGTerminal_Switch;
 	strWID.enuWIDtype = WID_CHAR;
@@ -3438,7 +3434,6 @@ static void Handle_AddBeacon(WILC_WFIDrvHandle drvHandler, tstrHostIFSetBeacon *
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
@@ -3510,7 +3505,6 @@ static void Handle_DelBeacon(WILC_WFIDrvHandle drvHandler, tstrHostIFDelBeacon *
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_DEL_BEACON;
 	strWID.enuWIDtype = WID_CHAR;
@@ -3607,7 +3601,6 @@ static void Handle_AddStation(WILC_WFIDrvHandle drvHandler, tstrWILC_AddStaParam
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	strWID.u16WIDid = (u16)WID_ADD_STA;
@@ -3651,7 +3644,6 @@ static void Handle_DelAllSta(WILC_WFIDrvHandle drvHandler, tstrHostIFDelAllSta *
 
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
 
@@ -3709,7 +3701,6 @@ static void Handle_DelStation(WILC_WFIDrvHandle drvHandler, tstrHostIFDelSta *ps
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_REMOVE_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3754,7 +3745,6 @@ static void Handle_EditStation(WILC_WFIDrvHandle drvHandler, tstrWILC_AddStaPara
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_EDIT_STA;
 	strWID.enuWIDtype = WID_BIN;
@@ -3878,7 +3868,6 @@ static int Handle_RegisterFrame(WILC_WFIDrvHandle drvHandler, tstrHostIfRegister
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
 
@@ -4021,7 +4010,6 @@ static void Handle_PowerManagement(WILC_WFIDrvHandle drvHandler, tstrHostIfPower
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	s8 s8PowerMode;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_POWER_MANAGEMENT;
 
@@ -4118,7 +4106,6 @@ static s32 Handle_AddBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASession
 	tstrWID strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -4205,7 +4192,6 @@ static s32 Handle_DelBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASession
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
@@ -4275,7 +4261,6 @@ static s32 Handle_DelAllRxBASessions(WILC_WFIDrvHandle drvHandler, tstrHostIfBAS
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
 	char *ptr = NULL;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
-- 
1.9.1

