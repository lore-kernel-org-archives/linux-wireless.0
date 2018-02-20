Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbeBTO6T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:19 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/12] staging: wilc1000: rename variables using camelCase in handle_rcvd_ntwrk_info()
Date: Tue, 20 Feb 2018 20:27:52 +0530
Message-ID: <1519138681-1982-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155822_324289_EA9D469C)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 45 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0f1eb17..f79618a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1248,18 +1248,17 @@ static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
 				  struct rcvd_net_info *rcvd_info)
 {
 	u32 i;
-	bool bNewNtwrkFound;
+	bool found;
 	s32 result = 0;
-	struct network_info *pstrNetworkInfo = NULL;
-	void *pJoinParams = NULL;
+	struct network_info *info = NULL;
+	void *params = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	bNewNtwrkFound = true;
+	found = true;
 
 	if (hif_drv->usr_scan_req.scan_result) {
-		wilc_parse_network_info(rcvd_info->buffer, &pstrNetworkInfo);
-		if (!pstrNetworkInfo ||
-		    !hif_drv->usr_scan_req.scan_result) {
+		wilc_parse_network_info(rcvd_info->buffer, &info);
+		if (!info || !hif_drv->usr_scan_req.scan_result) {
 			netdev_err(vif->ndev, "driver is null\n");
 			result = -EINVAL;
 			goto done;
@@ -1267,36 +1266,36 @@ static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
 
 		for (i = 0; i < hif_drv->usr_scan_req.rcvd_ch_cnt; i++) {
 			if (memcmp(hif_drv->usr_scan_req.net_info[i].bssid,
-				   pstrNetworkInfo->bssid, 6) == 0) {
-				if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].rssi) {
+				   info->bssid, 6) == 0) {
+				if (info->rssi <= hif_drv->usr_scan_req.net_info[i].rssi) {
 					goto done;
 				} else {
-					hif_drv->usr_scan_req.net_info[i].rssi = pstrNetworkInfo->rssi;
-					bNewNtwrkFound = false;
+					hif_drv->usr_scan_req.net_info[i].rssi = info->rssi;
+					found = false;
 					break;
 				}
 			}
 		}
 
-		if (bNewNtwrkFound) {
+		if (found) {
 			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
-				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].rssi = pstrNetworkInfo->rssi;
+				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].rssi = info->rssi;
 
 				memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid,
-				       pstrNetworkInfo->bssid, 6);
+				       info->bssid, 6);
 
 				hif_drv->usr_scan_req.rcvd_ch_cnt++;
 
-				pstrNetworkInfo->new_network = true;
-				pJoinParams = host_int_parse_join_bss_param(pstrNetworkInfo);
+				info->new_network = true;
+				params = host_int_parse_join_bss_param(info);
 
-				hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+				hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, info,
 								  hif_drv->usr_scan_req.arg,
-								  pJoinParams);
+								  params);
 			}
 		} else {
-			pstrNetworkInfo->new_network = false;
-			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+			info->new_network = false;
+			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, info,
 							  hif_drv->usr_scan_req.arg, NULL);
 		}
 	}
@@ -1305,9 +1304,9 @@ static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
 	kfree(rcvd_info->buffer);
 	rcvd_info->buffer = NULL;
 
-	if (pstrNetworkInfo) {
-		kfree(pstrNetworkInfo->ies);
-		kfree(pstrNetworkInfo);
+	if (info) {
+		kfree(info->ies);
+		kfree(info);
 	}
 
 	return result;
-- 
2.7.4
