Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9508 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbcBBMHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:07:03 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/26] staging: wilc1000: renames struct connect_resp_info variables
Date: Tue, 2 Feb 2016 21:02:24 +0900
Message-ID: <1454414556-9822-14-git-send-email-leo.kim@atmel.com> (sfid-20160202_130707_884409_E3C622F2)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames to avoid camelcase changes follow are:
 - u32TimeRcvdInScanCached to time_scan_cached
 - u32TimeRcvdInScan to time_scan

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 2f030a9..0e10c75 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -85,8 +85,8 @@ struct network_info {
 	u16 beacon_period;
 	u8 dtim_period;
 	u8 ch;
-	unsigned long u32TimeRcvdInScanCached;
-	unsigned long u32TimeRcvdInScan;
+	unsigned long time_scan_cached;
+	unsigned long time_scan;
 	bool bNewNetwork;
 	u8 u8Found;
 	u32 u32Tsf;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1773587..4767aa0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -277,7 +277,7 @@ static void update_scan_time(void)
 	int i;
 
 	for (i = 0; i < last_scanned_cnt; i++)
-		last_scanned_shadow[i].u32TimeRcvdInScan = jiffies;
+		last_scanned_shadow[i].time_scan = jiffies;
 }
 
 static void remove_network_from_shadow(unsigned long arg)
@@ -287,7 +287,8 @@ static void remove_network_from_shadow(unsigned long arg)
 
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if (time_after(now, last_scanned_shadow[i].u32TimeRcvdInScan + (unsigned long)(SCAN_RESULT_EXPIRE))) {
+		if (time_after(now, last_scanned_shadow[i].time_scan +
+			       (unsigned long)(SCAN_RESULT_EXPIRE))) {
 			PRINT_D(CFG80211_DBG, "Network expired ScanShadow:%s\n",
 				last_scanned_shadow[i].ssid);
 
@@ -384,8 +385,8 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 		kmalloc(pstrNetworkInfo->u16IEsLen, GFP_KERNEL);
 	memcpy(last_scanned_shadow[ap_index].pu8IEs,
 	       pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
-	last_scanned_shadow[ap_index].u32TimeRcvdInScan = jiffies;
-	last_scanned_shadow[ap_index].u32TimeRcvdInScanCached = jiffies;
+	last_scanned_shadow[ap_index].time_scan = jiffies;
+	last_scanned_shadow[ap_index].time_scan_cached = jiffies;
 	last_scanned_shadow[ap_index].u8Found = 1;
 	if (ap_found != -1)
 		wilc_free_join_params(last_scanned_shadow[ap_index].pJoinParams);
@@ -465,7 +466,7 @@ static void CfgScanResult(enum scan_event scan_event,
 							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].ssid);
 
 							last_scanned_shadow[i].rssi = network_info->rssi;
-							last_scanned_shadow[i].u32TimeRcvdInScan = jiffies;
+							last_scanned_shadow[i].time_scan = jiffies;
 							break;
 						}
 					}
@@ -566,9 +567,9 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 					unsigned long now = jiffies;
 
 					if (time_after(now,
-						       last_scanned_shadow[i].u32TimeRcvdInScanCached + (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ)))) {
+						       last_scanned_shadow[i].time_scan_cached +
+						       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
 						bNeedScanRefresh = true;
-					}
 
 					break;
 				}
-- 
1.9.1

