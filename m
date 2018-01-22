Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:43388 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbeAVKX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 05:23:28 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 11/14] staging: wilc1000: rename strConnectInfo variable to avoid camelCase
Date: Mon, 22 Jan 2018 15:52:24 +0530
Message-ID: <1516616547-24654-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180122_113154_946379_CC440AFD)
In-Reply-To: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue reported by checkpatch.pl script.
In this patch rename "strConnectInfo" variable to resolve
issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 74 +++++++++++++++----------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c3b6368..0eaf6c6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1115,30 +1115,30 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 ERRORHANDLER:
 	if (result) {
-		struct connect_info strConnectInfo;
+		struct connect_info conn_info;
 
 		del_timer(&hif_drv->connect_timer);
 
-		memset(&strConnectInfo, 0, sizeof(struct connect_info));
+		memset(&conn_info, 0, sizeof(struct connect_info));
 
 		if (attr->result) {
 			if (attr->bssid)
-				memcpy(strConnectInfo.bssid, attr->bssid, 6);
+				memcpy(conn_info.bssid, attr->bssid, 6);
 
 			if (attr->ies) {
-				strConnectInfo.req_ies_len = attr->ies_len;
-				strConnectInfo.req_ies = kmalloc(attr->ies_len, GFP_KERNEL);
-				memcpy(strConnectInfo.req_ies, attr->ies, attr->ies_len);
+				conn_info.req_ies_len = attr->ies_len;
+				conn_info.req_ies = kmalloc(attr->ies_len, GFP_KERNEL);
+				memcpy(conn_info.req_ies, attr->ies, attr->ies_len);
 			}
 
 			attr->result(CONN_DISCONN_EVENT_CONN_RESP,
-							       &strConnectInfo,
+							       &conn_info,
 							       MAC_DISCONNECTED,
 							       NULL,
 							       attr->arg);
 			hif_drv->hif_state = HOST_IF_IDLE;
-			kfree(strConnectInfo.req_ies);
-			strConnectInfo.req_ies = NULL;
+			kfree(conn_info.req_ies);
+			conn_info.req_ies = NULL;
 
 		} else {
 			netdev_err(vif->ndev, "Connect callback is NULL\n");
@@ -1161,7 +1161,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 {
 	s32 result = 0;
-	struct connect_info strConnectInfo;
+	struct connect_info conn_info;
 	struct wid wid;
 	u16 u16DummyReasonCode = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1175,30 +1175,30 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 	scan_while_connected = false;
 
-	memset(&strConnectInfo, 0, sizeof(struct connect_info));
+	memset(&conn_info, 0, sizeof(struct connect_info));
 
 	if (hif_drv->usr_conn_req.conn_result) {
 		if (hif_drv->usr_conn_req.bssid) {
-			memcpy(strConnectInfo.bssid,
+			memcpy(conn_info.bssid,
 			       hif_drv->usr_conn_req.bssid, 6);
 		}
 
 		if (hif_drv->usr_conn_req.ies) {
-			strConnectInfo.req_ies_len = hif_drv->usr_conn_req.ies_len;
-			strConnectInfo.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-			memcpy(strConnectInfo.req_ies,
+			conn_info.req_ies_len = hif_drv->usr_conn_req.ies_len;
+			conn_info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
+			memcpy(conn_info.req_ies,
 			       hif_drv->usr_conn_req.ies,
 			       hif_drv->usr_conn_req.ies_len);
 		}
 
 		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
-						  &strConnectInfo,
+						  &conn_info,
 						  MAC_DISCONNECTED,
 						  NULL,
 						  hif_drv->usr_conn_req.arg);
 
-		kfree(strConnectInfo.req_ies);
-		strConnectInfo.req_ies = NULL;
+		kfree(conn_info.req_ies);
+		conn_info.req_ies = NULL;
 	} else {
 		netdev_err(vif->ndev, "Connect callback is NULL\n");
 	}
@@ -1323,7 +1323,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	u8 u8MacStatus;
 	u8 u8MacStatusReasonCode;
 	u8 u8MacStatusAdditionalInfo;
-	struct connect_info strConnectInfo;
+	struct connect_info conn_info;
 	struct disconnect_info strDisconnectNotifInfo;
 	s32 s32Err = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1360,7 +1360,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			u32 u32RcvdAssocRespInfoLen = 0;
 			struct connect_resp_info *pstrConnectRespInfo = NULL;
 
-			memset(&strConnectInfo, 0, sizeof(struct connect_info));
+			memset(&conn_info, 0, sizeof(struct connect_info));
 
 			if (u8MacStatus == MAC_CONNECTED) {
 				memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
@@ -1376,12 +1376,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 					if (s32Err) {
 						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
-						strConnectInfo.status = pstrConnectRespInfo->status;
+						conn_info.status = pstrConnectRespInfo->status;
 
-						if (strConnectInfo.status == SUCCESSFUL_STATUSCODE && pstrConnectRespInfo->ies) {
-							strConnectInfo.resp_ies_len = pstrConnectRespInfo->ies_len;
-							strConnectInfo.resp_ies = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
-							memcpy(strConnectInfo.resp_ies, pstrConnectRespInfo->ies,
+						if (conn_info.status == SUCCESSFUL_STATUSCODE && pstrConnectRespInfo->ies) {
+							conn_info.resp_ies_len = pstrConnectRespInfo->ies_len;
+							conn_info.resp_ies = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
+							memcpy(conn_info.resp_ies, pstrConnectRespInfo->ies,
 							       pstrConnectRespInfo->ies_len);
 						}
 
@@ -1394,7 +1394,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			}
 
 			if (u8MacStatus == MAC_CONNECTED &&
-			    strConnectInfo.status != SUCCESSFUL_STATUSCODE)	{
+			    conn_info.status != SUCCESSFUL_STATUSCODE)	{
 				netdev_err(vif->ndev, "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 				eth_zero_addr(wilc_connected_ssid);
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
@@ -1403,32 +1403,32 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			}
 
 			if (hif_drv->usr_conn_req.bssid) {
-				memcpy(strConnectInfo.bssid, hif_drv->usr_conn_req.bssid, 6);
+				memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
 
 				if (u8MacStatus == MAC_CONNECTED &&
-				    strConnectInfo.status == SUCCESSFUL_STATUSCODE)	{
+				    conn_info.status == SUCCESSFUL_STATUSCODE)	{
 					memcpy(hif_drv->assoc_bssid,
 					       hif_drv->usr_conn_req.bssid, ETH_ALEN);
 				}
 			}
 
 			if (hif_drv->usr_conn_req.ies) {
-				strConnectInfo.req_ies_len = hif_drv->usr_conn_req.ies_len;
-				strConnectInfo.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-				memcpy(strConnectInfo.req_ies,
+				conn_info.req_ies_len = hif_drv->usr_conn_req.ies_len;
+				conn_info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
+				memcpy(conn_info.req_ies,
 				       hif_drv->usr_conn_req.ies,
 				       hif_drv->usr_conn_req.ies_len);
 			}
 
 			del_timer(&hif_drv->connect_timer);
 			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
-							  &strConnectInfo,
+							  &conn_info,
 							  u8MacStatus,
 							  NULL,
 							  hif_drv->usr_conn_req.arg);
 
 			if (u8MacStatus == MAC_CONNECTED &&
-			    strConnectInfo.status == SUCCESSFUL_STATUSCODE)	{
+			    conn_info.status == SUCCESSFUL_STATUSCODE)	{
 				wilc_set_power_mgmt(vif, 0, 0);
 
 				hif_drv->hif_state = HOST_IF_CONNECTED;
@@ -1441,11 +1441,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 				scan_while_connected = false;
 			}
 
-			kfree(strConnectInfo.resp_ies);
-			strConnectInfo.resp_ies = NULL;
+			kfree(conn_info.resp_ies);
+			conn_info.resp_ies = NULL;
 
-			kfree(strConnectInfo.req_ies);
-			strConnectInfo.req_ies = NULL;
+			kfree(conn_info.req_ies);
+			conn_info.req_ies = NULL;
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.ssid);
 			hif_drv->usr_conn_req.ssid = NULL;
-- 
2.7.4
