Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32845 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbcBLOEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:04:54 -0500
Received: by mail-pf0-f194.google.com with SMTP id c10so4036266pfc.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:04:54 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/11] staging: wilc1000: rename au8bssid in struct found_net_info
Date: Fri, 12 Feb 2016 23:04:38 +0900
Message-Id: <1455285887-29946-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150500_678258_52AAC716)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames au8bssid to bssid to remove au8 prefix. There is no
need to use prefix to show data type of this variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ab02159..60c1827 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1352,9 +1352,9 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 		}
 
 		for (i = 0; i < hif_drv->usr_scan_req.rcvd_ch_cnt; i++) {
-			if ((hif_drv->usr_scan_req.net_info[i].au8bssid) &&
+			if ((hif_drv->usr_scan_req.net_info[i].bssid) &&
 			    (pstrNetworkInfo->bssid)) {
-				if (memcmp(hif_drv->usr_scan_req.net_info[i].au8bssid,
+				if (memcmp(hif_drv->usr_scan_req.net_info[i].bssid,
 					   pstrNetworkInfo->bssid, 6) == 0) {
 					if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].s8rssi) {
 						goto done;
@@ -1371,9 +1371,9 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
 				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].s8rssi = pstrNetworkInfo->rssi;
 
-				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].au8bssid &&
+				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid &&
 				    pstrNetworkInfo->bssid) {
-					memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].au8bssid,
+					memcpy(hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].bssid,
 					       pstrNetworkInfo->bssid, 6);
 
 					hif_drv->usr_scan_req.rcvd_ch_cnt++;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index bfa4a41..e4729e3 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -144,7 +144,7 @@ enum cfg_param {
 };
 
 struct found_net_info {
-	u8 au8bssid[6];
+	u8 bssid[6];
 	s8 s8rssi;
 };
 
-- 
2.7.1

