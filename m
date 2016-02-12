Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32859 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbcBLOE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:04:57 -0500
Received: by mail-pf0-f193.google.com with SMTP id c10so4036326pfc.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:04:57 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/11] staging: wilc1000: rename s8rssi in struct found_net_info
Date: Fri, 12 Feb 2016 23:04:39 +0900
Message-Id: <1455285887-29946-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150503_120921_198D9323)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames s8rssi to rssi to remove s8 prefix in struct
found_net_info. There is no need to use prefix to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 60c1827..cd4a0a6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1356,10 +1356,10 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 			    (pstrNetworkInfo->bssid)) {
 				if (memcmp(hif_drv->usr_scan_req.net_info[i].bssid,
 					   pstrNetworkInfo->bssid, 6) == 0) {
-					if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].s8rssi) {
+					if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].rssi) {
 						goto done;
 					} else {
-						hif_drv->usr_scan_req.net_info[i].s8rssi = pstrNetworkInfo->rssi;
+						hif_drv->usr_scan_req.net_info[i].rssi = pstrNetworkInfo->rssi;
 						bNewNtwrkFound = false;
 						break;
 					}
@@ -1369,7 +1369,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 
 		if (bNewNtwrkFound) {
 			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
-				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].s8rssi = pstrNetworkInfo->rssi;
+				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].rssi = pstrNetworkInfo->rssi;
 
 				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid &&
 				    pstrNetworkInfo->bssid) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e4729e3..08c072c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -145,7 +145,7 @@ enum cfg_param {
 
 struct found_net_info {
 	u8 bssid[6];
-	s8 s8rssi;
+	s8 rssi;
 };
 
 enum scan_event {
-- 
2.7.1

