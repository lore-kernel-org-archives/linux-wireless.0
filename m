Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27021 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314AbbJ2DEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:36 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 44/64] staging: wilc1000: rename u32RcvdChCount of struct user_scan_req
Date: Thu, 29 Oct 2015 12:05:36 +0900
Message-ID: <1446087956-19054-11-git-send-email-glen.lee@atmel.com> (sfid-20151029_040438_646023_767B47AA)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32RcvdChCount of struct user_scan_req to rcvd_ch_cnt
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3e7c6e4..f465233 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -843,7 +843,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 
-	hif_drv->usr_scan_req.u32RcvdChCount = 0;
+	hif_drv->usr_scan_req.rcvd_ch_cnt = 0;
 
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].type = WID_STR;
@@ -1414,7 +1414,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 			goto done;
 		}
 
-		for (i = 0; i < hif_drv->usr_scan_req.u32RcvdChCount; i++) {
+		for (i = 0; i < hif_drv->usr_scan_req.rcvd_ch_cnt; i++) {
 			if ((hif_drv->usr_scan_req.net_info[i].au8bssid) &&
 			    (pstrNetworkInfo->au8bssid)) {
 				if (memcmp(hif_drv->usr_scan_req.net_info[i].au8bssid,
@@ -1434,15 +1434,15 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 		if (bNewNtwrkFound) {
 			PRINT_D(HOSTINF_DBG, "New network found\n");
 
-			if (hif_drv->usr_scan_req.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
-				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
+			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
+				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].s8rssi = pstrNetworkInfo->s8rssi;
 
-				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid &&
+				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].au8bssid &&
 				    pstrNetworkInfo->au8bssid) {
-					memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid,
+					memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].au8bssid,
 					       pstrNetworkInfo->au8bssid, 6);
 
-					hif_drv->usr_scan_req.u32RcvdChCount++;
+					hif_drv->usr_scan_req.rcvd_ch_cnt++;
 
 					pstrNetworkInfo->bNewNetwork = true;
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f94bba6..f824866 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -198,7 +198,7 @@ struct hidden_network {
 struct user_scan_req {
 	wilc_scan_result scan_result;
 	void *arg;
-	u32 u32RcvdChCount;
+	u32 rcvd_ch_cnt;
 	struct found_net_info net_info[MAX_NUM_SCANNED_NETWORKS];
 };
 
-- 
1.9.1

