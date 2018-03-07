Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:40450 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933278AbeCHPwY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:24 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/10] staging: wilc1000: fix line over 80 character in handle_disconnect()
Date: Wed, 7 Mar 2018 07:43:55 +0530
Message-ID: <1520388839-7048-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165227_247746_5B0FD0DF)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor handle_disconnect() to avoid line over 80 characters issue
reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 90 +++++++++++++++----------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 22d7bcc..4050128 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1801,7 +1801,9 @@ static void handle_disconnect(struct wilc_vif *vif)
 {
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
-
+	struct disconnect_info disconn_info;
+	struct user_scan_req *scan_req;
+	struct user_conn_req *conn_req;
 	s32 result = 0;
 	u16 dummy_reason_code = 0;
 
@@ -1820,63 +1822,61 @@ static void handle_disconnect(struct wilc_vif *vif)
 
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send dissconect\n");
-	} else {
-		struct disconnect_info disconn_info;
+		goto out;
+	}
 
-		memset(&disconn_info, 0, sizeof(struct disconnect_info));
+	memset(&disconn_info, 0, sizeof(struct disconnect_info));
 
-		disconn_info.reason = 0;
-		disconn_info.ie = NULL;
-		disconn_info.ie_len = 0;
+	disconn_info.reason = 0;
+	disconn_info.ie = NULL;
+	disconn_info.ie_len = 0;
+	scan_req = &hif_drv->usr_scan_req;
+	conn_req = &hif_drv->usr_conn_req;
 
-		if (hif_drv->usr_scan_req.scan_result) {
-			del_timer(&hif_drv->scan_timer);
-			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED,
-							  NULL,
-							  hif_drv->usr_scan_req.arg,
-							  NULL);
-			hif_drv->usr_scan_req.scan_result = NULL;
-		}
+	if (scan_req->scan_result) {
+		del_timer(&hif_drv->scan_timer);
+		scan_req->scan_result(SCAN_EVENT_ABORTED, NULL, scan_req->arg,
+				      NULL);
+		scan_req->scan_result = NULL;
+	}
 
-		if (hif_drv->usr_conn_req.conn_result) {
-			if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP)
-				del_timer(&hif_drv->connect_timer);
+	if (conn_req->conn_result) {
+		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP)
+			del_timer(&hif_drv->connect_timer);
 
-			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
-							  NULL,
-							  0,
-							  &disconn_info,
-							  hif_drv->usr_conn_req.arg);
-		} else {
-			netdev_err(vif->ndev, "conn_result = NULL\n");
-		}
+		conn_req->conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
+				      0, &disconn_info, conn_req->arg);
+	} else {
+		netdev_err(vif->ndev, "conn_result = NULL\n");
+	}
 
-		scan_while_connected = false;
+	scan_while_connected = false;
 
-		hif_drv->hif_state = HOST_IF_IDLE;
+	hif_drv->hif_state = HOST_IF_IDLE;
 
-		eth_zero_addr(hif_drv->assoc_bssid);
+	eth_zero_addr(hif_drv->assoc_bssid);
 
-		hif_drv->usr_conn_req.ssid_len = 0;
-		kfree(hif_drv->usr_conn_req.ssid);
-		hif_drv->usr_conn_req.ssid = NULL;
-		kfree(hif_drv->usr_conn_req.bssid);
-		hif_drv->usr_conn_req.bssid = NULL;
-		hif_drv->usr_conn_req.ies_len = 0;
-		kfree(hif_drv->usr_conn_req.ies);
-		hif_drv->usr_conn_req.ies = NULL;
+	conn_req->ssid_len = 0;
+	kfree(conn_req->ssid);
+	conn_req->ssid = NULL;
+	kfree(conn_req->bssid);
+	conn_req->bssid = NULL;
+	conn_req->ies_len = 0;
+	kfree(conn_req->ies);
+	conn_req->ies = NULL;
 
-		if (join_req && join_req_vif == vif) {
-			kfree(join_req);
-			join_req = NULL;
-		}
+	if (join_req && join_req_vif == vif) {
+		kfree(join_req);
+		join_req = NULL;
+	}
 
-		if (info_element && join_req_vif == vif) {
-			kfree(info_element);
-			info_element = NULL;
-		}
+	if (info_element && join_req_vif == vif) {
+		kfree(info_element);
+		info_element = NULL;
 	}
 
+out:
+
 	complete(&hif_drv->comp_test_disconn_block);
 }
 
-- 
2.7.4
