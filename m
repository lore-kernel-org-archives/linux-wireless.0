Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36643 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbbKWNlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 08:41:02 -0500
Received: by pacdm15 with SMTP id dm15so191720997pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2015 05:41:01 -0800 (PST)
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rdunlap@infradead.org, chris.park@atmel.com, austin.shin@atmel.com,
	johnny.kim@atmel.com, linux-wireless@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: Fix typo in host_interface.c
Date: Mon, 23 Nov 2015 22:41:18 +0900
Message-Id: <1448286080-14787-2-git-send-email-standby24x7@gmail.com> (sfid-20151123_144110_371425_E52A994A)
In-Reply-To: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
References: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix spelling typo in host_interface.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5b7725..b9f9541 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -581,7 +581,7 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->cfg_attr_info.power_mgmt_mode;
 		} else {
-			PRINT_ER("Invalide power mode\n");
+			PRINT_ER("Invalid power mode\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -655,7 +655,7 @@ static s32 handle_cfg_param(struct host_if_drv *hif_drv,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.preamble_type = cfg_param_attr->cfg_attr_info.preamble_type;
 		} else {
-			PRINT_ER("Preamle Range(0~2) over\n");
+			PRINT_ER("Preamble Range(0~2) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -844,7 +844,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	}
 
 	if (g_obtainingIP || connecting) {
-		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
+		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP addresses is obtained\n");
 		PRINT_ER("Don't do obss scan\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
@@ -924,7 +924,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
-		PRINT_ER("Failed to send scan paramters config packet\n");
+		PRINT_ER("Failed to send scan parameters config packet\n");
 	else
 		PRINT_D(HOSTINF_DBG, "Successfully sent SCAN params config packet\n");
 
@@ -1379,7 +1379,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
-		PRINT_ER("Failed to send dissconect config packet\n");
+		PRINT_ER("Failed to send disconnect config packet\n");
 
 	hif_drv->usr_conn_req.ssid_len = 0;
 	kfree(hif_drv->usr_conn_req.pu8ssid);
@@ -1529,12 +1529,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 		u8MacStatus  = pstrRcvdGnrlAsyncInfo->buffer[7];
 		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->buffer[8];
 		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->buffer[9];
-		PRINT_INFO(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
+		PRINT_INFO(HOSTINF_DBG, "Received MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 			u32 u32RcvdAssocRespInfoLen;
 			tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 
-			PRINT_D(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Code = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
+			PRINT_D(HOSTINF_DBG, "Received MAC status = %d with Reason = %d , Code = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
 
 			memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
@@ -1998,7 +1998,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
-		PRINT_ER("Failed to send dissconect config packet\n");
+		PRINT_ER("Failed to send disconnect config packet\n");
 	} else {
 		tstrDisconnectNotifInfo strDisconnectNotifInfo;
 
@@ -2179,7 +2179,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 				 get_id_from_handler(hif_drv));
 
 	if (result)
-		PRINT_ER("Failed to send scan paramters config packet\n");
+		PRINT_ER("Failed to send scan parameters config packet\n");
 
 	up(&hif_sema_wait_response);
 	return 0;
@@ -2206,7 +2206,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
-		PRINT_ER("Failed to SET incative time\n");
+		PRINT_ER("Failed to SET inactive time\n");
 		return -EFAULT;
 	}
 
@@ -2219,7 +2219,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
-		PRINT_ER("Failed to get incative time\n");
+		PRINT_ER("Failed to get inactive time\n");
 		return -EFAULT;
 	}
 
@@ -2518,7 +2518,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	}
 
 	if (g_obtainingIP || connecting) {
-		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
+		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP addresses is obtained\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
@@ -4141,7 +4141,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		result = wilc_mq_create(&hif_msg_q);
 
 		if (result < 0) {
-			PRINT_ER("Failed to creat MQ\n");
+			PRINT_ER("Failed to create MQ\n");
 			goto _fail_;
 		}
 
@@ -4149,7 +4149,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 						 "WILC_kthread");
 
 		if (IS_ERR(hif_thread_handler)) {
-			PRINT_ER("Failed to creat Thread\n");
+			PRINT_ER("Failed to create Thread\n");
 			result = -EFAULT;
 			goto _fail_mq_;
 		}
@@ -4319,7 +4319,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	if (!hif_drv->usr_conn_req.conn_result) {
-		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
+		PRINT_ER("Received mac status is not needed when there is no current Connect Request\n");
 		up(&hif_sema_deinit);
 		return;
 	}
-- 
2.6.3.379.g0c83680

