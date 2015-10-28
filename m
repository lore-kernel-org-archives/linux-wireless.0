Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41497 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbJ1G5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:57:43 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/80] staging: wilc1000: remove unnecessary parentheses around
Date: Wed, 28 Oct 2015 15:59:21 +0900
Message-ID: <1446015640-29398-1-git-send-email-glen.lee@atmel.com> (sfid-20151028_075746_995158_86B47DCF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the checks reported by checkpatch.pl
for unnecessary parentheses around.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 48 +++++++++++++++----------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f658594..acc6552b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -332,7 +332,7 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
-	strWID.val = (char *)&(pstrHostIFSetChan->set_ch);
+	strWID.val = (char *)&pstrHostIFSetChan->set_ch;
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
@@ -356,7 +356,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_SET_DRV_HANDLER;
 	strWID.type = WID_INT;
-	strWID.val = (s8 *)&(pstrHostIfSetDrvHandler->u32Address);
+	strWID.val = (s8 *)&pstrHostIfSetDrvHandler->u32Address;
 	strWID.size = sizeof(u32);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
@@ -381,7 +381,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_SET_OPERATION_MODE;
 	strWID.type = WID_INT;
-	strWID.val = (s8 *)&(pstrHostIfSetOperationMode->u32Mode);
+	strWID.val = (s8 *)&pstrHostIfSetOperationMode->u32Mode;
 	strWID.size = sizeof(u32);
 
 	result = send_config_pkt(SET_CFG, &strWID, 1,
@@ -881,7 +881,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->type));
+	strWIDList[u32WidsCount].val = (s8 *)&pstrHostIFscanAttr->type;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
@@ -904,7 +904,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->src));
+	strWIDList[u32WidsCount].val = (s8 *)&pstrHostIFscanAttr->src;
 	u32WidsCount++;
 
 	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
@@ -1069,7 +1069,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(hif_drv->strWILC_UsrConnReq.u8security));
+	strWIDList[u32WidsCount].val = (s8 *)&hif_drv->strWILC_UsrConnReq.u8security;
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
@@ -1732,21 +1732,21 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->attr.wep.index));
+			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", pstrHostIFkeyAttr->attr.wep.index);
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.mode));
+			strWIDList[0].val = (s8 *)&pstrHostIFkeyAttr->attr.wep.mode;
 
 			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
 			strWIDList[1].size = sizeof(char);
-			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.auth_type));
+			strWIDList[1].val = (s8 *)&pstrHostIFkeyAttr->attr.wep.auth_type;
 
 			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
 
-			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.index));
+			strWIDList[2].val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
 			strWIDList[2].size = sizeof(char);
 
 			pu8keybuf = kmemdup(pstrHostIFkeyAttr->attr.wep.key,
@@ -1808,7 +1808,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
-			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.index));
+			strWID.val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
 			strWID.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
@@ -1839,7 +1839,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.mode));
+			strWIDList[0].val = (s8 *)&pstrHostIFkeyAttr->attr.wpa.mode;
 
 			strWIDList[1].id = (u16)WID_ADD_RX_GTK;
 			strWIDList[1].type = WID_STR;
@@ -1914,7 +1914,7 @@ _WPARxGtk_end_case_:
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.mode));
+			strWIDList[0].val = (s8 *)&pstrHostIFkeyAttr->attr.wpa.mode;
 
 			strWIDList[1].id = (u16)WID_ADD_PTK;
 			strWIDList[1].type = WID_STR;
@@ -2160,9 +2160,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 		result = -EFAULT;
 	}
 
-	up(&(hif_drv->hSemGetLINKSPEED));
-
-
+	up(&hif_drv->hSemGetLINKSPEED);
 }
 
 s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
@@ -2173,31 +2171,31 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u8LinkSpeed));
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->u8LinkSpeed;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RSSI;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->s8RSSI));
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->s8RSSI;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u32TxCount));
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->u32TxCount;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u32RxCount));
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->u32RxCount;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrStatistics->u32TxFailureCount));
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->u32TxFailureCount;
 	u32WidsCount++;
 
 	result = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
@@ -2608,8 +2606,8 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->bReg;
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
-	memcpy(pu8CurrByte, &(pstrHostIfRegisterFrame->u16FrameType), sizeof(u16));
-
+	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->u16FrameType,
+	       sizeof(u16));
 
 	strWID.size = sizeof(u16) + 2;
 
@@ -4206,7 +4204,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
 
-	sema_init(&(hif_drv->gtOsCfgValuesSem), 1);
+	sema_init(&hif_drv->gtOsCfgValuesSem, 1);
 	down(&hif_drv->gtOsCfgValuesSem);
 
 	hif_drv->enuHostIFstate = HOST_IF_IDLE;
@@ -4302,7 +4300,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		wilc_mq_destroy(&hif_msg_q);
 	}
 
-	down(&(hif_drv->gtOsCfgValuesSem));
+	down(&hif_drv->gtOsCfgValuesSem);
 
 	ret = remove_handler_in_list(hif_drv);
 	if (ret)
-- 
1.9.1

