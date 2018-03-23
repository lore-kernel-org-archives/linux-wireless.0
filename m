Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34176 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbeCWPJl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 11:09:41 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 9/9] staging: wilc1000: free memory allocated for general info message from firmware
Date: Fri, 23 Mar 2018 20:38:58 +0530
Message-ID: <1521817738-7557-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180323_160948_894221_234725A9)
In-Reply-To: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free allocated memory for failure scenario while processing the
information message received from the firmware. Added NULL check and used
kmemdup in the flow of handling information message.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 48 ++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bb13adb..d35885b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1346,16 +1346,15 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 
 				if (conn_info.status == SUCCESSFUL_STATUSCODE &&
 				    connect_resp_info->ies) {
-					conn_info.resp_ies_len = connect_resp_info->ies_len;
-					conn_info.resp_ies = kmalloc(connect_resp_info->ies_len, GFP_KERNEL);
-					memcpy(conn_info.resp_ies, connect_resp_info->ies,
-					       connect_resp_info->ies_len);
+					conn_info.resp_ies = kmemdup(connect_resp_info->ies,
+								     connect_resp_info->ies_len,
+								     GFP_KERNEL);
+					if (conn_info.resp_ies)
+						conn_info.resp_ies_len = connect_resp_info->ies_len;
 				}
 
-				if (connect_resp_info) {
-					kfree(connect_resp_info->ies);
-					kfree(connect_resp_info);
-				}
+				kfree(connect_resp_info->ies);
+				kfree(connect_resp_info);
 			}
 		}
 	}
@@ -1381,11 +1380,11 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 	}
 
 	if (hif_drv->usr_conn_req.ies) {
-		conn_info.req_ies_len = hif_drv->usr_conn_req.ies_len;
-		conn_info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len,
+		conn_info.req_ies = kmemdup(conn_info.req_ies,
+					    hif_drv->usr_conn_req.ies_len,
 					    GFP_KERNEL);
-		memcpy(conn_info.req_ies, hif_drv->usr_conn_req.ies,
-		       hif_drv->usr_conn_req.ies_len);
+		if (conn_info.req_ies)
+			conn_info.req_ies_len = hif_drv->usr_conn_req.ies_len;
 	}
 
 	del_timer(&hif_drv->connect_timer);
@@ -1463,17 +1462,25 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 	u8 mac_status_additional_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
+	if (!rcvd_info->buffer) {
+		netdev_err(vif->ndev, "Received buffer is NULL\n");
+		return -EINVAL;
+	}
+
 	if (!hif_drv) {
 		netdev_err(vif->ndev, "Driver handler is NULL\n");
+		kfree(rcvd_info->buffer);
+		rcvd_info->buffer = NULL;
 		return -ENODEV;
 	}
 
 	if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP ||
 	    hif_drv->hif_state == HOST_IF_CONNECTED ||
 	    hif_drv->usr_scan_req.scan_result) {
-		if (!rcvd_info->buffer ||
-		    !hif_drv->usr_conn_req.conn_result) {
+		if (!hif_drv->usr_conn_req.conn_result) {
 			netdev_err(vif->ndev, "driver is null\n");
+			kfree(rcvd_info->buffer);
+			rcvd_info->buffer = NULL;
 			return -EINVAL;
 		}
 
@@ -1481,6 +1488,8 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 
 		if ('I' != msg_type) {
 			netdev_err(vif->ndev, "Received Message incorrect.\n");
+			kfree(rcvd_info->buffer);
+			rcvd_info->buffer = NULL;
 			return -EFAULT;
 		}
 
@@ -3528,12 +3537,17 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	msg.vif = vif;
 
 	msg.body.async_info.len = length;
-	msg.body.async_info.buffer = kmalloc(length, GFP_KERNEL);
-	memcpy(msg.body.async_info.buffer, buffer, length);
+	msg.body.async_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
+	if (!msg.body.async_info.buffer) {
+		mutex_unlock(&hif_deinit_lock);
+		return;
+	}
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
+		kfree(msg.body.async_info.buffer);
+	}
 
 	mutex_unlock(&hif_deinit_lock);
 }
-- 
2.7.4
