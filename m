Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59020 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbcBDJdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:33:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 58/70] staging: wilc1000: renames struct connect_resp_info variables
Date: Thu, 4 Feb 2016 18:24:19 +0900
Message-ID: <1454577871-667-19-git-send-email-glen.lee@atmel.com> (sfid-20160204_103327_056694_62B74FBB)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

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
index 362fe1b..44d1855 100644
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
 		kfree(last_scanned_shadow[ap_index].pJoinParams);
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

