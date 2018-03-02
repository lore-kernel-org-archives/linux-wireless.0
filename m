Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:1969 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425214AbeCBOYD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:24:03 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/13] staging: wilc1000: fix line over 80 char in handle_rcvd_ntwrk_info()
Date: Fri, 2 Mar 2018 19:52:48 +0530
Message-ID: <1520000569-27738-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_153349_281849_7EB1349F)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 character' issues found by checkpatch.pl script by
use of temporary variable and avoided leading tab.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 66 +++++++++++++++----------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 19c7483..2354666 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1267,51 +1267,51 @@ static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
 	struct network_info *info = NULL;
 	void *params = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	struct user_scan_req *scan_req = &hif_drv->usr_scan_req;
 
 	found = true;
 
-	if (hif_drv->usr_scan_req.scan_result) {
-		wilc_parse_network_info(rcvd_info->buffer, &info);
-		if (!info || !hif_drv->usr_scan_req.scan_result) {
-			netdev_err(vif->ndev, "driver is null\n");
-			result = -EINVAL;
-			goto done;
-		}
+	if (!scan_req->scan_result)
+		goto done;
 
-		for (i = 0; i < hif_drv->usr_scan_req.rcvd_ch_cnt; i++) {
-			if (memcmp(hif_drv->usr_scan_req.net_info[i].bssid,
-				   info->bssid, 6) == 0) {
-				if (info->rssi <= hif_drv->usr_scan_req.net_info[i].rssi) {
-					goto done;
-				} else {
-					hif_drv->usr_scan_req.net_info[i].rssi = info->rssi;
-					found = false;
-					break;
-				}
+	wilc_parse_network_info(rcvd_info->buffer, &info);
+	if (!info || !scan_req->scan_result) {
+		netdev_err(vif->ndev, "driver is null\n");
+		result = -EINVAL;
+		goto done;
+	}
+
+	for (i = 0; i < scan_req->rcvd_ch_cnt; i++) {
+		if (memcmp(scan_req->net_info[i].bssid, info->bssid, 6) == 0) {
+			if (info->rssi <= scan_req->net_info[i].rssi) {
+				goto done;
+			} else {
+				scan_req->net_info[i].rssi = info->rssi;
+				found = false;
+				break;
 			}
 		}
+	}
 
-		if (found) {
-			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
-				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].rssi = info->rssi;
+	if (found) {
+		if (scan_req->rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
+			scan_req->net_info[scan_req->rcvd_ch_cnt].rssi = info->rssi;
 
-				memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid,
-				       info->bssid, 6);
+			memcpy(scan_req->net_info[scan_req->rcvd_ch_cnt].bssid,
+			       info->bssid, 6);
 
-				hif_drv->usr_scan_req.rcvd_ch_cnt++;
+			scan_req->rcvd_ch_cnt++;
 
-				info->new_network = true;
-				params = host_int_parse_join_bss_param(info);
+			info->new_network = true;
+			params = host_int_parse_join_bss_param(info);
 
-				hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, info,
-								  hif_drv->usr_scan_req.arg,
-								  params);
-			}
-		} else {
-			info->new_network = false;
-			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, info,
-							  hif_drv->usr_scan_req.arg, NULL);
+			scan_req->scan_result(SCAN_EVENT_NETWORK_FOUND, info,
+					       scan_req->arg, params);
 		}
+	} else {
+		info->new_network = false;
+		scan_req->scan_result(SCAN_EVENT_NETWORK_FOUND, info,
+				      scan_req->arg, NULL);
 	}
 
 done:
-- 
2.7.4
