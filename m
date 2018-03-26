Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57968 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbeCZRQc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:16:32 -0400
From: Colin King <colin.king@canonical.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: replace kmalloc + memcpy with kmemdup
Date: Mon, 26 Mar 2018 18:16:29 +0100
Message-Id: <20180326171629.28700-1-colin.king@canonical.com> (sfid-20180326_191657_906042_E9F3CFB4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Replace several allocation and memcpys with kmemdup and add in some
missing memory allocation failure checks.  Also fix an incorrect 
-EFAULT return with -ENOMEM.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/host_interface.c | 75 +++++++++++++++++++------------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9b9b86654958..8fd367f87fa5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -797,6 +797,10 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	for (i = 0; i < hidden_net->n_ssids; i++)
 		valuesize += ((hidden_net->net_info[i].ssid_len) + 1);
 	hdn_ntwk_wid_val = kmalloc(valuesize + 1, GFP_KERNEL);
+	if (!hdn_ntwk_wid_val) {
+		result = -ENOMEM;
+		goto error;
+	}
 	wid_list[index].val = hdn_ntwk_wid_val;
 	if (wid_list[index].val) {
 		buffer = wid_list[index].val;
@@ -943,39 +947,35 @@ static s32 handle_connect(struct wilc_vif *vif,
 	}
 
 	if (conn_attr->bssid) {
-		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
+		hif_drv->usr_conn_req.bssid = kmemdup(conn_attr->bssid, 6,
+						      GFP_KERNEL);
 		if (!hif_drv->usr_conn_req.bssid) {
 			result = -ENOMEM;
 			goto error;
 		}
-		memcpy(hif_drv->usr_conn_req.bssid, conn_attr->bssid, 6);
 	}
 
 	hif_drv->usr_conn_req.ssid_len = conn_attr->ssid_len;
 	if (conn_attr->ssid) {
-		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1,
+		hif_drv->usr_conn_req.ssid = kmemdup(conn_attr->ssid,
+						     conn_attr->ssid_len + 1,
 						     GFP_KERNEL);
 		if (!hif_drv->usr_conn_req.ssid) {
 			result = -ENOMEM;
 			goto error;
 		}
-		memcpy(hif_drv->usr_conn_req.ssid,
-		       conn_attr->ssid,
-		       conn_attr->ssid_len);
 		hif_drv->usr_conn_req.ssid[conn_attr->ssid_len] = '\0';
 	}
 
 	hif_drv->usr_conn_req.ies_len = conn_attr->ies_len;
 	if (conn_attr->ies) {
-		hif_drv->usr_conn_req.ies = kmalloc(conn_attr->ies_len,
+		hif_drv->usr_conn_req.ies = kmemdup(conn_attr->ies,
+						    conn_attr->ies_len,
 						    GFP_KERNEL);
 		if (!hif_drv->usr_conn_req.ies) {
 			result = -ENOMEM;
 			goto error;
 		}
-		memcpy(hif_drv->usr_conn_req.ies,
-		       conn_attr->ies,
-		       conn_attr->ies_len);
 	}
 
 	hif_drv->usr_conn_req.security = conn_attr->security;
@@ -1009,9 +1009,12 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
 		info_element_size = hif_drv->usr_conn_req.ies_len;
-		info_element = kmalloc(info_element_size, GFP_KERNEL);
-		memcpy(info_element, hif_drv->usr_conn_req.ies,
-		       info_element_size);
+		info_element = kmemdup(hif_drv->usr_conn_req.ies,
+				       info_element_size, GFP_KERNEL);
+		if (!info_element) {
+			result = -ENOMEM;
+			goto error;
+		}
 	}
 	wid_list[wid_cnt].id = (u16)WID_11I_MODE;
 	wid_list[wid_cnt].type = WID_CHAR;
@@ -1039,9 +1042,13 @@ static s32 handle_connect(struct wilc_vif *vif,
 	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
 		join_req_size = wid_list[wid_cnt].size;
 		join_req = kmalloc(join_req_size, GFP_KERNEL);
+		if (!join_req) {
+			result = -ENOMEM;
+			goto error;
+		}
 	}
 	if (!wid_list[wid_cnt].val) {
-		result = -EFAULT;
+		result = -ENOMEM;
 		goto error;
 	}
 
@@ -1166,11 +1173,13 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 			if (conn_attr->ies) {
 				conn_info.req_ies_len = conn_attr->ies_len;
-				conn_info.req_ies = kmalloc(conn_attr->ies_len,
+				conn_info.req_ies = kmemdup(conn_attr->ies,
+							    conn_attr->ies_len,
 							    GFP_KERNEL);
-				memcpy(conn_info.req_ies,
-				       conn_attr->ies,
-				       conn_attr->ies_len);
+				if (!conn_info.req_ies) {
+					result = -ENOMEM;
+					goto error_free;
+				}
 			}
 
 			conn_attr->result(CONN_DISCONN_EVENT_CONN_RESP,
@@ -1187,6 +1196,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 		}
 	}
 
+error_free:
 	kfree(conn_attr->bssid);
 	conn_attr->bssid = NULL;
 
@@ -1227,10 +1237,9 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 		if (hif_drv->usr_conn_req.ies) {
 			info.req_ies_len = hif_drv->usr_conn_req.ies_len;
-			info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-			memcpy(info.req_ies,
-			       hif_drv->usr_conn_req.ies,
-			       hif_drv->usr_conn_req.ies_len);
+			info.req_ies = kmemdup(hif_drv->usr_conn_req.ies,
+					       hif_drv->usr_conn_req.ies_len,
+					       GFP_KERNEL);
 		}
 
 		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
@@ -1421,9 +1430,11 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 
 						if (conn_info.status == SUCCESSFUL_STATUSCODE && connect_resp_info->ies) {
 							conn_info.resp_ies_len = connect_resp_info->ies_len;
-							conn_info.resp_ies = kmalloc(connect_resp_info->ies_len, GFP_KERNEL);
-							memcpy(conn_info.resp_ies, connect_resp_info->ies,
-							       connect_resp_info->ies_len);
+							conn_info.resp_ies = kmemdup(connect_resp_info->ies,
+										     connect_resp_info->ies_len,
+										     GFP_KERNEL);
+							if (!conn_info.resp_ies)
+								return -ENOMEM;
 						}
 
 						if (connect_resp_info) {
@@ -3524,8 +3535,11 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	msg.vif = vif;
 
 	msg.body.net_info.len = length;
-	msg.body.net_info.buffer = kmalloc(length, GFP_KERNEL);
-	memcpy(msg.body.net_info.buffer, buffer, length);
+	msg.body.net_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
+	if (!msg.body.net_info.buffer) {
+		netdev_err(vif->ndev, "message buffer allocation failed\n");
+		return;
+	}
 
 	result = wilc_enqueue_cmd(&msg);
 	if (result)
@@ -3571,8 +3585,11 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	msg.vif = vif;
 
 	msg.body.async_info.len = length;
-	msg.body.async_info.buffer = kmalloc(length, GFP_KERNEL);
-	memcpy(msg.body.async_info.buffer, buffer, length);
+	msg.body.async_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
+	if (!msg.body.async_info.buffer) {
+		netdev_err(vif->ndev, "message buffer allocation failed\n");
+		return;
+	}
 
 	result = wilc_enqueue_cmd(&msg);
 	if (result)
-- 
2.15.1
