Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:17168 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbeGSGqp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:45 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 17/23] staging: wilc1000: avoid forward declaration for handle_scan_done()
Date: Thu, 19 Jul 2018 04:15:13 +0530
Message-ID: <1531953919-20804-18-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080522_199824_07196EAC)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder the function position in host interface to avoid forward
declaration of handle_scan_done().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 77 +++++++++++++++----------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 85ecba8..eabe5c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -199,7 +199,6 @@ static u32 clients_count;
 
 static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt);
 
 /* 'msg' should be free by the caller for syc */
 static struct host_if_msg*
@@ -724,6 +723,44 @@ static void handle_cfg_param(struct work_struct *work)
 	kfree(msg);
 }
 
+static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
+{
+	s32 result = 0;
+	u8 abort_running_scan;
+	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
+	struct user_scan_req *scan_req;
+
+	if (evt == SCAN_EVENT_ABORTED) {
+		abort_running_scan = 1;
+		wid.id = WID_ABORT_RUNNING_SCAN;
+		wid.type = WID_CHAR;
+		wid.val = (s8 *)&abort_running_scan;
+		wid.size = sizeof(char);
+
+		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+					      wilc_get_vif_idx(vif));
+
+		if (result) {
+			netdev_err(vif->ndev, "Failed to set abort running\n");
+			result = -EFAULT;
+		}
+	}
+
+	if (!hif_drv) {
+		netdev_err(vif->ndev, "Driver handler is NULL\n");
+		return result;
+	}
+
+	scan_req = &hif_drv->usr_scan_req;
+	if (scan_req->scan_result) {
+		scan_req->scan_result(evt, NULL, scan_req->arg, NULL);
+		scan_req->scan_result = NULL;
+	}
+
+	return result;
+}
+
 static void handle_scan(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
@@ -841,44 +878,6 @@ static void handle_scan(struct work_struct *work)
 	kfree(msg);
 }
 
-static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
-{
-	s32 result = 0;
-	u8 abort_running_scan;
-	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
-	struct user_scan_req *scan_req;
-
-	if (evt == SCAN_EVENT_ABORTED) {
-		abort_running_scan = 1;
-		wid.id = WID_ABORT_RUNNING_SCAN;
-		wid.type = WID_CHAR;
-		wid.val = (s8 *)&abort_running_scan;
-		wid.size = sizeof(char);
-
-		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-					      wilc_get_vif_idx(vif));
-
-		if (result) {
-			netdev_err(vif->ndev, "Failed to set abort running\n");
-			result = -EFAULT;
-		}
-	}
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "Driver handler is NULL\n");
-		return result;
-	}
-
-	scan_req = &hif_drv->usr_scan_req;
-	if (scan_req->scan_result) {
-		scan_req->scan_result(evt, NULL, scan_req->arg, NULL);
-		scan_req->scan_result = NULL;
-	}
-
-	return result;
-}
-
 u8 wilc_connected_ssid[6] = {0};
 static void handle_connect(struct work_struct *work)
 {
-- 
2.7.4
