Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:22611 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933278AbeCHPwf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:35 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/10] staging: wilc1000: rename variables using camelCase in handle_rcvd_gnrl_async_info()
Date: Wed, 7 Mar 2018 07:43:58 +0530
Message-ID: <1520388839-7048-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165238_331248_CEAD2F4C)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 86 +++++++++++++++----------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b26ea85..d822b15 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1343,17 +1343,17 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 				       struct rcvd_async_info *rcvd_info)
 {
 	s32 result = 0;
-	u8 u8MsgType = 0;
-	u8 u8MsgID = 0;
-	u16 u16MsgLen = 0;
-	u16 u16WidID = (u16)WID_NIL;
-	u8 u8WidLen  = 0;
-	u8 u8MacStatus;
-	u8 u8MacStatusReasonCode;
-	u8 u8MacStatusAdditionalInfo;
+	u8 msg_type = 0;
+	u8 msg_id = 0;
+	u16 msg_len = 0;
+	u16 wid_id = (u16)WID_NIL;
+	u8 wid_len  = 0;
+	u8 mac_status;
+	u8 mac_status_reason_code;
+	u8 mac_status_additional_info;
 	struct connect_info conn_info;
 	struct disconnect_info disconn_info;
-	s32 s32Err = 0;
+	s32 err = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -1370,62 +1370,62 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			return -EINVAL;
 		}
 
-		u8MsgType = rcvd_info->buffer[0];
+		msg_type = rcvd_info->buffer[0];
 
-		if ('I' != u8MsgType) {
+		if ('I' != msg_type) {
 			netdev_err(vif->ndev, "Received Message incorrect.\n");
 			return -EFAULT;
 		}
 
-		u8MsgID = rcvd_info->buffer[1];
-		u16MsgLen = MAKE_WORD16(rcvd_info->buffer[2], rcvd_info->buffer[3]);
-		u16WidID = MAKE_WORD16(rcvd_info->buffer[4], rcvd_info->buffer[5]);
-		u8WidLen = rcvd_info->buffer[6];
-		u8MacStatus  = rcvd_info->buffer[7];
-		u8MacStatusReasonCode = rcvd_info->buffer[8];
-		u8MacStatusAdditionalInfo = rcvd_info->buffer[9];
+		msg_id = rcvd_info->buffer[1];
+		msg_len = MAKE_WORD16(rcvd_info->buffer[2], rcvd_info->buffer[3]);
+		wid_id = MAKE_WORD16(rcvd_info->buffer[4], rcvd_info->buffer[5]);
+		wid_len = rcvd_info->buffer[6];
+		mac_status  = rcvd_info->buffer[7];
+		mac_status_reason_code = rcvd_info->buffer[8];
+		mac_status_additional_info = rcvd_info->buffer[9];
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
-			u32 u32RcvdAssocRespInfoLen = 0;
-			struct connect_resp_info *pstrConnectRespInfo = NULL;
+			u32 rcvd_assoc_resp_info_len = 0;
+			struct connect_resp_info *connect_resp_info = NULL;
 
 			memset(&conn_info, 0, sizeof(struct connect_info));
 
-			if (u8MacStatus == MAC_CONNECTED) {
+			if (mac_status == MAC_CONNECTED) {
 				memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
 				host_int_get_assoc_res_info(vif,
 							    rcv_assoc_resp,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
-							    &u32RcvdAssocRespInfoLen);
+							    &rcvd_assoc_resp_info_len);
 
-				if (u32RcvdAssocRespInfoLen != 0) {
-					s32Err = wilc_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
-									    &pstrConnectRespInfo);
-					if (s32Err) {
-						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
+				if (rcvd_assoc_resp_info_len != 0) {
+					err = wilc_parse_assoc_resp_info(rcv_assoc_resp, rcvd_assoc_resp_info_len,
+									 &connect_resp_info);
+					if (err) {
+						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", err);
 					} else {
-						conn_info.status = pstrConnectRespInfo->status;
+						conn_info.status = connect_resp_info->status;
 
-						if (conn_info.status == SUCCESSFUL_STATUSCODE && pstrConnectRespInfo->ies) {
-							conn_info.resp_ies_len = pstrConnectRespInfo->ies_len;
-							conn_info.resp_ies = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
-							memcpy(conn_info.resp_ies, pstrConnectRespInfo->ies,
-							       pstrConnectRespInfo->ies_len);
+						if (conn_info.status == SUCCESSFUL_STATUSCODE && connect_resp_info->ies) {
+							conn_info.resp_ies_len = connect_resp_info->ies_len;
+							conn_info.resp_ies = kmalloc(connect_resp_info->ies_len, GFP_KERNEL);
+							memcpy(conn_info.resp_ies, connect_resp_info->ies,
+							       connect_resp_info->ies_len);
 						}
 
-						if (pstrConnectRespInfo) {
-							kfree(pstrConnectRespInfo->ies);
-							kfree(pstrConnectRespInfo);
+						if (connect_resp_info) {
+							kfree(connect_resp_info->ies);
+							kfree(connect_resp_info);
 						}
 					}
 				}
 			}
 
-			if (u8MacStatus == MAC_CONNECTED &&
+			if (mac_status == MAC_CONNECTED &&
 			    conn_info.status != SUCCESSFUL_STATUSCODE)	{
 				netdev_err(vif->ndev, "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 				eth_zero_addr(wilc_connected_ssid);
-			} else if (u8MacStatus == MAC_DISCONNECTED)    {
+			} else if (mac_status == MAC_DISCONNECTED)    {
 				netdev_err(vif->ndev, "Received MAC status is MAC_DISCONNECTED\n");
 				eth_zero_addr(wilc_connected_ssid);
 			}
@@ -1433,7 +1433,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			if (hif_drv->usr_conn_req.bssid) {
 				memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
 
-				if (u8MacStatus == MAC_CONNECTED &&
+				if (mac_status == MAC_CONNECTED &&
 				    conn_info.status == SUCCESSFUL_STATUSCODE)	{
 					memcpy(hif_drv->assoc_bssid,
 					       hif_drv->usr_conn_req.bssid, ETH_ALEN);
@@ -1451,11 +1451,11 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			del_timer(&hif_drv->connect_timer);
 			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
 							  &conn_info,
-							  u8MacStatus,
+							  mac_status,
 							  NULL,
 							  hif_drv->usr_conn_req.arg);
 
-			if (u8MacStatus == MAC_CONNECTED &&
+			if (mac_status == MAC_CONNECTED &&
 			    conn_info.status == SUCCESSFUL_STATUSCODE)	{
 				wilc_set_power_mgmt(vif, 0, 0);
 
@@ -1482,7 +1482,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
 			hif_drv->usr_conn_req.ies = NULL;
-		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
+		} else if ((mac_status == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
 			memset(&disconn_info, 0, sizeof(struct disconnect_info));
 
@@ -1532,7 +1532,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			hif_drv->hif_state = HOST_IF_IDLE;
 			scan_while_connected = false;
 
-		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
+		} else if ((mac_status == MAC_DISCONNECTED) &&
 			   (hif_drv->usr_scan_req.scan_result)) {
 			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.scan_result)
-- 
2.7.4
