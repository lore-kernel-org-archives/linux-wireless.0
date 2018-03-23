Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34176 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751832AbeCWPJh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 11:09:37 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 8/9] staging: wilc1000: split handle_rcvd_gnrl_async_info() to avoid leading tabs
Date: Fri, 23 Mar 2018 20:38:57 +0530
Message-ID: <1521817738-7557-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180323_160948_315353_48557C23)
In-Reply-To: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Too many leading tabs' issue found by checkpatch.pl script in
handle_rcvd_gnrl_async_info().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 286 ++++++++++++++++--------------
 1 file changed, 149 insertions(+), 137 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 74095ec..bb13adb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1302,6 +1302,153 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				       u32 max_assoc_resp_info_len,
 				       u32 *rcvd_assoc_resp_info_len);
 
+static inline void host_int_free_user_conn_req(struct host_if_drv *hif_drv)
+{
+	hif_drv->usr_conn_req.ssid_len = 0;
+	kfree(hif_drv->usr_conn_req.ssid);
+	hif_drv->usr_conn_req.ssid = NULL;
+	kfree(hif_drv->usr_conn_req.bssid);
+	hif_drv->usr_conn_req.bssid = NULL;
+	hif_drv->usr_conn_req.ies_len = 0;
+	kfree(hif_drv->usr_conn_req.ies);
+	hif_drv->usr_conn_req.ies = NULL;
+}
+
+static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
+						  u8 mac_status)
+{
+	struct connect_resp_info *connect_resp_info = NULL;
+	struct connect_info conn_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
+
+	memset(&conn_info, 0, sizeof(struct connect_info));
+
+	if (mac_status == MAC_CONNECTED) {
+		u32 rcvd_assoc_resp_info_len;
+
+		memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
+
+		host_int_get_assoc_res_info(vif, rcv_assoc_resp,
+					    MAX_ASSOC_RESP_FRAME_SIZE,
+					    &rcvd_assoc_resp_info_len);
+
+		if (rcvd_assoc_resp_info_len != 0) {
+			s32 err = 0;
+
+			err = wilc_parse_assoc_resp_info(rcv_assoc_resp, rcvd_assoc_resp_info_len,
+							 &connect_resp_info);
+			if (err) {
+				netdev_err(vif->ndev,
+					   "wilc_parse_assoc_resp_info() returned error %d\n",
+					   err);
+			} else {
+				conn_info.status = connect_resp_info->status;
+
+				if (conn_info.status == SUCCESSFUL_STATUSCODE &&
+				    connect_resp_info->ies) {
+					conn_info.resp_ies_len = connect_resp_info->ies_len;
+					conn_info.resp_ies = kmalloc(connect_resp_info->ies_len, GFP_KERNEL);
+					memcpy(conn_info.resp_ies, connect_resp_info->ies,
+					       connect_resp_info->ies_len);
+				}
+
+				if (connect_resp_info) {
+					kfree(connect_resp_info->ies);
+					kfree(connect_resp_info);
+				}
+			}
+		}
+	}
+
+	if (mac_status == MAC_CONNECTED &&
+	    conn_info.status != SUCCESSFUL_STATUSCODE) {
+		netdev_err(vif->ndev,
+			   "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
+		eth_zero_addr(wilc_connected_ssid);
+	} else if (mac_status == MAC_DISCONNECTED)    {
+		netdev_err(vif->ndev, "Received MAC status is MAC_DISCONNECTED\n");
+		eth_zero_addr(wilc_connected_ssid);
+	}
+
+	if (hif_drv->usr_conn_req.bssid) {
+		memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
+
+		if (mac_status == MAC_CONNECTED &&
+		    conn_info.status == SUCCESSFUL_STATUSCODE) {
+			memcpy(hif_drv->assoc_bssid,
+			       hif_drv->usr_conn_req.bssid, ETH_ALEN);
+		}
+	}
+
+	if (hif_drv->usr_conn_req.ies) {
+		conn_info.req_ies_len = hif_drv->usr_conn_req.ies_len;
+		conn_info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len,
+					    GFP_KERNEL);
+		memcpy(conn_info.req_ies, hif_drv->usr_conn_req.ies,
+		       hif_drv->usr_conn_req.ies_len);
+	}
+
+	del_timer(&hif_drv->connect_timer);
+	hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
+					  &conn_info, mac_status, NULL,
+					  hif_drv->usr_conn_req.arg);
+
+	if (mac_status == MAC_CONNECTED &&
+	    conn_info.status == SUCCESSFUL_STATUSCODE) {
+		wilc_set_power_mgmt(vif, 0, 0);
+
+		hif_drv->hif_state = HOST_IF_CONNECTED;
+
+		wilc_optaining_ip = true;
+		mod_timer(&wilc_during_ip_timer,
+			  jiffies + msecs_to_jiffies(10000));
+	} else {
+		hif_drv->hif_state = HOST_IF_IDLE;
+		scan_while_connected = false;
+	}
+
+	kfree(conn_info.resp_ies);
+	conn_info.resp_ies = NULL;
+
+	kfree(conn_info.req_ies);
+	conn_info.req_ies = NULL;
+	host_int_free_user_conn_req(hif_drv);
+}
+
+static inline void host_int_handle_disconnect(struct wilc_vif *vif)
+{
+	struct disconnect_info disconn_info;
+	struct host_if_drv *hif_drv = vif->hif_drv;
+
+	memset(&disconn_info, 0, sizeof(struct disconnect_info));
+
+	if (hif_drv->usr_scan_req.scan_result) {
+		del_timer(&hif_drv->scan_timer);
+		handle_scan_done(vif, SCAN_EVENT_ABORTED);
+	}
+
+	disconn_info.reason = 0;
+	disconn_info.ie = NULL;
+	disconn_info.ie_len = 0;
+
+	if (hif_drv->usr_conn_req.conn_result) {
+		wilc_optaining_ip = false;
+		wilc_set_power_mgmt(vif, 0, 0);
+
+		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
+						  NULL, 0, &disconn_info,
+						  hif_drv->usr_conn_req.arg);
+	} else {
+		netdev_err(vif->ndev, "Connect result NULL\n");
+	}
+
+	eth_zero_addr(hif_drv->assoc_bssid);
+
+	host_int_free_user_conn_req(hif_drv);
+	hif_drv->hif_state = HOST_IF_IDLE;
+	scan_while_connected = false;
+}
+
 static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 				       struct rcvd_async_info *rcvd_info)
 {
@@ -1314,9 +1461,6 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 	u8 mac_status;
 	u8 mac_status_reason_code;
 	u8 mac_status_additional_info;
-	struct connect_info conn_info;
-	struct disconnect_info disconn_info;
-	s32 err = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -1348,142 +1492,10 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 		mac_status_reason_code = rcvd_info->buffer[8];
 		mac_status_additional_info = rcvd_info->buffer[9];
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
-			u32 rcvd_assoc_resp_info_len = 0;
-			struct connect_resp_info *connect_resp_info = NULL;
-
-			memset(&conn_info, 0, sizeof(struct connect_info));
-
-			if (mac_status == MAC_CONNECTED) {
-				memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
-
-				host_int_get_assoc_res_info(vif,
-							    rcv_assoc_resp,
-							    MAX_ASSOC_RESP_FRAME_SIZE,
-							    &rcvd_assoc_resp_info_len);
-
-				if (rcvd_assoc_resp_info_len != 0) {
-					err = wilc_parse_assoc_resp_info(rcv_assoc_resp, rcvd_assoc_resp_info_len,
-									 &connect_resp_info);
-					if (err) {
-						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", err);
-					} else {
-						conn_info.status = connect_resp_info->status;
-
-						if (conn_info.status == SUCCESSFUL_STATUSCODE && connect_resp_info->ies) {
-							conn_info.resp_ies_len = connect_resp_info->ies_len;
-							conn_info.resp_ies = kmalloc(connect_resp_info->ies_len, GFP_KERNEL);
-							memcpy(conn_info.resp_ies, connect_resp_info->ies,
-							       connect_resp_info->ies_len);
-						}
-
-						if (connect_resp_info) {
-							kfree(connect_resp_info->ies);
-							kfree(connect_resp_info);
-						}
-					}
-				}
-			}
-
-			if (mac_status == MAC_CONNECTED &&
-			    conn_info.status != SUCCESSFUL_STATUSCODE)	{
-				netdev_err(vif->ndev, "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
-				eth_zero_addr(wilc_connected_ssid);
-			} else if (mac_status == MAC_DISCONNECTED)    {
-				netdev_err(vif->ndev, "Received MAC status is MAC_DISCONNECTED\n");
-				eth_zero_addr(wilc_connected_ssid);
-			}
-
-			if (hif_drv->usr_conn_req.bssid) {
-				memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
-
-				if (mac_status == MAC_CONNECTED &&
-				    conn_info.status == SUCCESSFUL_STATUSCODE)	{
-					memcpy(hif_drv->assoc_bssid,
-					       hif_drv->usr_conn_req.bssid, ETH_ALEN);
-				}
-			}
-
-			if (hif_drv->usr_conn_req.ies) {
-				conn_info.req_ies_len = hif_drv->usr_conn_req.ies_len;
-				conn_info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-				memcpy(conn_info.req_ies,
-				       hif_drv->usr_conn_req.ies,
-				       hif_drv->usr_conn_req.ies_len);
-			}
-
-			del_timer(&hif_drv->connect_timer);
-			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
-							  &conn_info,
-							  mac_status,
-							  NULL,
-							  hif_drv->usr_conn_req.arg);
-
-			if (mac_status == MAC_CONNECTED &&
-			    conn_info.status == SUCCESSFUL_STATUSCODE)	{
-				wilc_set_power_mgmt(vif, 0, 0);
-
-				hif_drv->hif_state = HOST_IF_CONNECTED;
-
-				wilc_optaining_ip = true;
-				mod_timer(&wilc_during_ip_timer,
-					  jiffies + msecs_to_jiffies(10000));
-			} else {
-				hif_drv->hif_state = HOST_IF_IDLE;
-				scan_while_connected = false;
-			}
-
-			kfree(conn_info.resp_ies);
-			conn_info.resp_ies = NULL;
-
-			kfree(conn_info.req_ies);
-			conn_info.req_ies = NULL;
-			hif_drv->usr_conn_req.ssid_len = 0;
-			kfree(hif_drv->usr_conn_req.ssid);
-			hif_drv->usr_conn_req.ssid = NULL;
-			kfree(hif_drv->usr_conn_req.bssid);
-			hif_drv->usr_conn_req.bssid = NULL;
-			hif_drv->usr_conn_req.ies_len = 0;
-			kfree(hif_drv->usr_conn_req.ies);
-			hif_drv->usr_conn_req.ies = NULL;
+			host_int_parse_assoc_resp_info(vif, mac_status);
 		} else if ((mac_status == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
-			memset(&disconn_info, 0, sizeof(struct disconnect_info));
-
-			if (hif_drv->usr_scan_req.scan_result) {
-				del_timer(&hif_drv->scan_timer);
-				handle_scan_done(vif, SCAN_EVENT_ABORTED);
-			}
-
-			disconn_info.reason = 0;
-			disconn_info.ie = NULL;
-			disconn_info.ie_len = 0;
-
-			if (hif_drv->usr_conn_req.conn_result) {
-				wilc_optaining_ip = false;
-				wilc_set_power_mgmt(vif, 0, 0);
-
-				hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
-								  NULL,
-								  0,
-								  &disconn_info,
-								  hif_drv->usr_conn_req.arg);
-			} else {
-				netdev_err(vif->ndev, "Connect result NULL\n");
-			}
-
-			eth_zero_addr(hif_drv->assoc_bssid);
-
-			hif_drv->usr_conn_req.ssid_len = 0;
-			kfree(hif_drv->usr_conn_req.ssid);
-			hif_drv->usr_conn_req.ssid = NULL;
-			kfree(hif_drv->usr_conn_req.bssid);
-			hif_drv->usr_conn_req.bssid = NULL;
-			hif_drv->usr_conn_req.ies_len = 0;
-			kfree(hif_drv->usr_conn_req.ies);
-			hif_drv->usr_conn_req.ies = NULL;
-			hif_drv->hif_state = HOST_IF_IDLE;
-			scan_while_connected = false;
-
+			host_int_handle_disconnect(vif);
 		} else if ((mac_status == MAC_DISCONNECTED) &&
 			   (hif_drv->usr_scan_req.scan_result)) {
 			del_timer(&hif_drv->scan_timer);
-- 
2.7.4
