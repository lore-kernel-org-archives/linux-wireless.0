Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22116 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbeG2Hgk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:40 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 6/8] staging: wilc1000: rename 'rcvd_ch_cnt' element in 'user_scan_req' struct
Date: Sun, 29 Jul 2018 11:36:55 +0530
Message-ID: <1532844417-3192-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080728_463612_489D8D06)
In-Reply-To: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use shorter name for 'rcvd_ch_cnt' to 'ch_cnt' to avoid
line over 80 character issue reported by checkpatch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0df4d9c..86d8aaf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -792,7 +792,7 @@ static void handle_scan(struct work_struct *work)
 		goto error;
 	}
 
-	hif_drv->usr_scan_req.rcvd_ch_cnt = 0;
+	hif_drv->usr_scan_req.ch_cnt = 0;
 
 	wid_list[index].id = WID_SSID_PROBE_REQ;
 	wid_list[index].type = WID_STR;
@@ -1406,7 +1406,7 @@ static void handle_rcvd_ntwrk_info(struct work_struct *work)
 		goto done;
 	}
 
-	for (i = 0; i < scan_req->rcvd_ch_cnt; i++) {
+	for (i = 0; i < scan_req->ch_cnt; i++) {
 		if (memcmp(scan_req->net_info[i].bssid, info->bssid, 6) == 0) {
 			if (info->rssi <= scan_req->net_info[i].rssi) {
 				goto done;
@@ -1419,13 +1419,13 @@ static void handle_rcvd_ntwrk_info(struct work_struct *work)
 	}
 
 	if (found) {
-		if (scan_req->rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
-			scan_req->net_info[scan_req->rcvd_ch_cnt].rssi = info->rssi;
+		if (scan_req->ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
+			scan_req->net_info[scan_req->ch_cnt].rssi = info->rssi;
 
-			memcpy(scan_req->net_info[scan_req->rcvd_ch_cnt].bssid,
+			memcpy(scan_req->net_info[scan_req->ch_cnt].bssid,
 			       info->bssid, 6);
 
-			scan_req->rcvd_ch_cnt++;
+			scan_req->ch_cnt++;
 
 			info->new_network = true;
 			params = host_int_parse_join_bss_param(info);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9a016c5..3ddeec2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -199,7 +199,7 @@ struct hidden_network {
 struct user_scan_req {
 	wilc_scan_result scan_result;
 	void *arg;
-	u32 rcvd_ch_cnt;
+	u32 ch_cnt;
 	struct found_net_info net_info[MAX_NUM_SCANNED_NETWORKS];
 };
 
-- 
2.7.4
