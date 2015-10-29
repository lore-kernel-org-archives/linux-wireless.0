Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5130 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965183AbbJ2C7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:59:52 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 29/64] staging: wilc1000: rename astrFoundNetworkInfo of struct user_scan_req
Date: Thu, 29 Oct 2015 11:58:52 +0900
Message-ID: <1446087567-16728-29-git-send-email-glen.lee@atmel.com> (sfid-20151029_041657_277414_7AF537FC)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames astrFoundNetworkInfo of struct user_scan_req to net_info
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3648e3c..35a1262 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1415,15 +1415,15 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 		}
 
 		for (i = 0; i < hif_drv->usr_scan_req.u32RcvdChCount; i++) {
-			if ((hif_drv->usr_scan_req.astrFoundNetworkInfo[i].au8bssid) &&
+			if ((hif_drv->usr_scan_req.net_info[i].au8bssid) &&
 			    (pstrNetworkInfo->au8bssid)) {
-				if (memcmp(hif_drv->usr_scan_req.astrFoundNetworkInfo[i].au8bssid,
+				if (memcmp(hif_drv->usr_scan_req.net_info[i].au8bssid,
 					   pstrNetworkInfo->au8bssid, 6) == 0) {
-					if (pstrNetworkInfo->s8rssi <= hif_drv->usr_scan_req.astrFoundNetworkInfo[i].s8rssi) {
+					if (pstrNetworkInfo->s8rssi <= hif_drv->usr_scan_req.net_info[i].s8rssi) {
 						PRINT_D(HOSTINF_DBG, "Network previously discovered\n");
 						goto done;
 					} else {
-						hif_drv->usr_scan_req.astrFoundNetworkInfo[i].s8rssi = pstrNetworkInfo->s8rssi;
+						hif_drv->usr_scan_req.net_info[i].s8rssi = pstrNetworkInfo->s8rssi;
 						bNewNtwrkFound = false;
 						break;
 					}
@@ -1435,11 +1435,11 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 			PRINT_D(HOSTINF_DBG, "New network found\n");
 
 			if (hif_drv->usr_scan_req.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
-				hif_drv->usr_scan_req.astrFoundNetworkInfo[hif_drv->usr_scan_req.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
+				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
 
-				if (hif_drv->usr_scan_req.astrFoundNetworkInfo[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid &&
+				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid &&
 				    pstrNetworkInfo->au8bssid) {
-					memcpy(hif_drv->usr_scan_req.astrFoundNetworkInfo[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid,
+					memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid,
 					       pstrNetworkInfo->au8bssid, 6);
 
 					hif_drv->usr_scan_req.u32RcvdChCount++;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 058ea17..dcb68ea 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -195,7 +195,7 @@ struct user_scan_req {
 	wilc_scan_result scan_result;
 	void *arg;
 	u32 u32RcvdChCount;
-	struct found_net_info astrFoundNetworkInfo[MAX_NUM_SCANNED_NETWORKS];
+	struct found_net_info net_info[MAX_NUM_SCANNED_NETWORKS];
 };
 
 struct user_conn_req {
-- 
1.9.1

