Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4575 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbbJ2C43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:56:29 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 01/64] staging: wilc1000: rename enuHostIFstate of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:24 +0900
Message-ID: <1446087567-16728-1-git-send-email-glen.lee@atmel.com> (sfid-20151029_035632_487043_58D3CDF5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames enuHostIFstate of struct host_if_drv to hif_state
to avoid CamelCase naming convention.
And, some comments modification that has been included name 'enuHostIFstate'.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 62 ++++++++++++++++---------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dbbe72c..4e01dbd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -820,13 +820,15 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	u8 *pu8HdnNtwrksWidVal = NULL;
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
-	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->enuHostIFstate);
+	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->hif_state);
 
 	hif_drv->usr_scan_req.pfUserScanResult = pstrHostIFscanAttr->result;
 	hif_drv->usr_scan_req.u32UserScanPvoid = pstrHostIFscanAttr->arg;
 
-	if ((hif_drv->enuHostIFstate >= HOST_IF_SCANNING) && (hif_drv->enuHostIFstate < HOST_IF_CONNECTED)) {
-		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", hif_drv->enuHostIFstate);
+	if ((hif_drv->hif_state >= HOST_IF_SCANNING) &&
+	    (hif_drv->hif_state < HOST_IF_CONNECTED)) {
+		PRINT_D(GENERIC_DBG, "Don't scan already in [%d] state\n",
+			hif_drv->hif_state);
 		PRINT_ER("Already scan\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
@@ -904,9 +906,9 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].val = (s8 *)&pstrHostIFscanAttr->src;
 	u32WidsCount++;
 
-	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
+	if (hif_drv->hif_state == HOST_IF_CONNECTED)
 		scan_while_connected = true;
-	else if (hif_drv->enuHostIFstate == HOST_IF_IDLE)
+	else if (hif_drv->hif_state == HOST_IF_IDLE)
 		scan_while_connected = false;
 
 	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
@@ -1214,7 +1216,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	} else {
 		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
-		hif_drv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
+		hif_drv->hif_state = HOST_IF_WAITING_CONN_RESP;
 	}
 
 ERRORHANDLER:
@@ -1244,7 +1246,7 @@ ERRORHANDLER:
 							       MAC_DISCONNECTED,
 							       NULL,
 							       pstrHostIFconnectAttr->arg);
-			hif_drv->enuHostIFstate = HOST_IF_IDLE;
+			hif_drv->hif_state = HOST_IF_IDLE;
 			kfree(strConnectInfo.pu8ReqIEs);
 			strConnectInfo.pu8ReqIEs = NULL;
 
@@ -1325,7 +1327,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 		return result;
 	}
 
-	hif_drv->enuHostIFstate = HOST_IF_IDLE;
+	hif_drv->hif_state = HOST_IF_IDLE;
 
 	scan_while_connected = false;
 
@@ -1491,11 +1493,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 		PRINT_ER("Driver handler is NULL\n");
 		return -ENODEV;
 	}
-	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", hif_drv->enuHostIFstate,
-		pstrRcvdGnrlAsyncInfo->buffer[7]);
+	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n",
+		hif_drv->hif_state, pstrRcvdGnrlAsyncInfo->buffer[7]);
 
-	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) ||
-	    (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) ||
+	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
+	    (hif_drv->hif_state == HOST_IF_CONNECTED) ||
 	    hif_drv->usr_scan_req.pfUserScanResult) {
 		if (!pstrRcvdGnrlAsyncInfo->buffer ||
 		    !hif_drv->usr_conn_req.pfUserConnectResult) {
@@ -1518,7 +1520,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->buffer[8];
 		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->buffer[9];
 		PRINT_INFO(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
-		if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
+		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 			u32 u32RcvdAssocRespInfoLen;
 			tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 
@@ -1604,7 +1606,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				host_int_set_power_mgmt(hif_drv, 0, 0);
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
-				hif_drv->enuHostIFstate = HOST_IF_CONNECTED;
+				hif_drv->hif_state = HOST_IF_CONNECTED;
 
 				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
 				g_obtainingIP = true;
@@ -1612,7 +1614,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 					  jiffies + msecs_to_jiffies(10000));
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
-				hif_drv->enuHostIFstate = HOST_IF_IDLE;
+				hif_drv->hif_state = HOST_IF_IDLE;
 				scan_while_connected = false;
 			}
 
@@ -1627,7 +1629,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
 			kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
-			   (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)) {
+			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
 
 			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
@@ -1673,7 +1675,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				info_element = NULL;
 			}
 
-			hif_drv->enuHostIFstate = HOST_IF_IDLE;
+			hif_drv->hif_state = HOST_IF_IDLE;
 			scan_while_connected = false;
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
@@ -1837,10 +1839,10 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 				goto _WPARxGtk_end_case_;
 			}
 
-			if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
+			if (hif_drv->hif_state == HOST_IF_CONNECTED)
 				memcpy(pu8keybuf, hif_drv->au8AssociatedBSSID, ETH_ALEN);
 			else
-				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
+				PRINT_ER("Couldn't handle WPARxGtk while state is not HOST_IF_CONNECTED\n");
 
 			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
@@ -2005,7 +2007,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		}
 
 		if (hif_drv->usr_conn_req.pfUserConnectResult) {
-			if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
+			if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
 				del_timer(&hif_drv->hConnectTimer);
 			}
@@ -2018,7 +2020,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 		scan_while_connected = false;
 
-		hif_drv->enuHostIFstate = HOST_IF_IDLE;
+		hif_drv->hif_state = HOST_IF_IDLE;
 
 		eth_zero_addr(hif_drv->au8AssociatedBSSID);
 
@@ -2046,7 +2048,8 @@ void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 {
 	if (!hif_drv)
 		return;
-	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) || (hif_drv->enuHostIFstate == HOST_IF_CONNECTING)) {
+	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
+	    (hif_drv->hif_state == HOST_IF_CONNECTING)) {
 		PRINT_D(HOSTINF_DBG, "\n\n<< correcting Supplicant state machine >>\n\n");
 		host_int_disconnect(hif_drv, 1);
 	}
@@ -2492,7 +2495,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
-	if (hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) {
+	if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while connecting return\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
@@ -3497,10 +3500,11 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 		msg.body.con_info.ies = kmalloc(IEsLen, GFP_KERNEL);
 		memcpy(msg.body.con_info.ies, pu8IEs, IEsLen);
 	}
-	if (hif_drv->enuHostIFstate < HOST_IF_CONNECTING)
-		hif_drv->enuHostIFstate = HOST_IF_CONNECTING;
+	if (hif_drv->hif_state < HOST_IF_CONNECTING)
+		hif_drv->hif_state = HOST_IF_CONNECTING;
 	else
-		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", hif_drv->enuHostIFstate);
+		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' : %d\n",
+			hif_drv->hif_state);
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -4046,7 +4050,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 		return;
 	}
 
-	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) {
+	if (hif_drv->hif_state == HOST_IF_CONNECTED) {
 		s32 result = 0;
 		struct host_if_msg msg;
 
@@ -4142,7 +4146,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	sema_init(&hif_drv->gtOsCfgValuesSem, 1);
 	down(&hif_drv->gtOsCfgValuesSem);
 
-	hif_drv->enuHostIFstate = HOST_IF_IDLE;
+	hif_drv->hif_state = HOST_IF_IDLE;
 	hif_drv->strCfgValues.site_survey_enabled = SITE_SURVEY_OFF;
 	hif_drv->strCfgValues.scan_source = DEFAULT_SCAN;
 	hif_drv->strCfgValues.active_scan_time = ACTIVE_SCAN_TIME;
@@ -4211,7 +4215,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		hif_drv->usr_scan_req.pfUserScanResult = NULL;
 	}
 
-	hif_drv->enuHostIFstate = HOST_IF_IDLE;
+	hif_drv->hif_state = HOST_IF_IDLE;
 
 	scan_while_connected = false;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b854db5..dcdb9c6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -299,7 +299,7 @@ struct host_if_drv {
 	u64 u64P2p_MgmtTimeout;
 	u8 u8P2PConnect;
 
-	enum host_if_state enuHostIFstate;
+	enum host_if_state hif_state;
 
 	u8 au8AssociatedBSSID[ETH_ALEN];
 	struct cfg_param_val strCfgValues;
-- 
1.9.1

