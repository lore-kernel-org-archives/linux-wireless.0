Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58817 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbbKSGxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:53:14 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/26] staging: wilc1000: rename u32LastScannedNtwrksCountShadow variable
Date: Thu, 19 Nov 2015 15:56:10 +0900
Message-ID: <1447916195-24851-1-git-send-email-glen.lee@atmel.com> (sfid-20151119_075318_060105_CB39284C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32LastScannedNtwrksCountShadow variable to last_scanned_cnt
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 50 +++++++++++------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cc279c6..97848e4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -107,7 +107,7 @@ extern int wilc_mac_open(struct net_device *ndev);
 extern int wilc_mac_close(struct net_device *ndev);
 
 static tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
-static u32 u32LastScannedNtwrksCountShadow;
+static u32 last_scanned_cnt;
 struct timer_list wilc_during_ip_timer;
 static struct timer_list hAgingTimer;
 static u8 op_ifcs;
@@ -213,16 +213,16 @@ static void clear_shadow_scan(void *pUserVoid)
 		del_timer_sync(&hAgingTimer);
 		PRINT_INFO(CORECONFIG_DBG, "destroy aging timer\n");
 
-		for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
-			if (astrLastScannedNtwrksShadow[u32LastScannedNtwrksCountShadow].pu8IEs != NULL) {
+		for (i = 0; i < last_scanned_cnt; i++) {
+			if (astrLastScannedNtwrksShadow[last_scanned_cnt].pu8IEs != NULL) {
 				kfree(astrLastScannedNtwrksShadow[i].pu8IEs);
-				astrLastScannedNtwrksShadow[u32LastScannedNtwrksCountShadow].pu8IEs = NULL;
+				astrLastScannedNtwrksShadow[last_scanned_cnt].pu8IEs = NULL;
 			}
 
 			wilc_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
 			astrLastScannedNtwrksShadow[i].pJoinParams = NULL;
 		}
-		u32LastScannedNtwrksCountShadow = 0;
+		last_scanned_cnt = 0;
 	}
 
 }
@@ -251,7 +251,7 @@ static void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 	priv = (struct wilc_priv *)pUserVoid;
 	wiphy = priv->dev->ieee80211_ptr->wiphy;
 
-	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
+	for (i = 0; i < last_scanned_cnt; i++) {
 		tstrNetworkInfo *pstrNetworkInfo;
 
 		pstrNetworkInfo = &(astrLastScannedNtwrksShadow[i]);
@@ -284,19 +284,16 @@ static void reset_shadow_found(void *pUserVoid)
 {
 	int i;
 
-	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
+	for (i = 0; i < last_scanned_cnt; i++)
 		astrLastScannedNtwrksShadow[i].u8Found = 0;
-
-	}
 }
 
 static void update_scan_time(void *pUserVoid)
 {
 	int i;
 
-	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
+	for (i = 0; i < last_scanned_cnt; i++)
 		astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan = jiffies;
-	}
 }
 
 static void remove_network_from_shadow(unsigned long arg)
@@ -305,7 +302,7 @@ static void remove_network_from_shadow(unsigned long arg)
 	int i, j;
 
 
-	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
+	for (i = 0; i < last_scanned_cnt; i++) {
 		if (time_after(now, astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan + (unsigned long)(SCAN_RESULT_EXPIRE))) {
 			PRINT_D(CFG80211_DBG, "Network expired in ScanShadow: %s\n", astrLastScannedNtwrksShadow[i].au8ssid);
 
@@ -314,15 +311,16 @@ static void remove_network_from_shadow(unsigned long arg)
 
 			wilc_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
 
-			for (j = i; (j < u32LastScannedNtwrksCountShadow - 1); j++) {
+			for (j = i; (j < last_scanned_cnt - 1); j++)
 				astrLastScannedNtwrksShadow[j] = astrLastScannedNtwrksShadow[j + 1];
-			}
-			u32LastScannedNtwrksCountShadow--;
+
+			last_scanned_cnt--;
 		}
 	}
 
-	PRINT_D(CFG80211_DBG, "Number of cached networks: %d\n", u32LastScannedNtwrksCountShadow);
-	if (u32LastScannedNtwrksCountShadow != 0) {
+	PRINT_D(CFG80211_DBG, "Number of cached networks: %d\n",
+		last_scanned_cnt);
+	if (last_scanned_cnt != 0) {
 		hAgingTimer.data = arg;
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
 	} else {
@@ -341,14 +339,14 @@ static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoi
 	int state = -1;
 	int i;
 
-	if (u32LastScannedNtwrksCountShadow == 0) {
+	if (last_scanned_cnt == 0) {
 		PRINT_D(CFG80211_DBG, "Starting Aging timer\n");
 		hAgingTimer.data = (unsigned long)pUserVoid;
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
 	} else {
 		/* Linear search for now */
-		for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
+		for (i = 0; i < last_scanned_cnt; i++) {
 			if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid,
 					pstrNetworkInfo->au8bssid, 6) == 0) {
 				state = i;
@@ -365,13 +363,13 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserV
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
-	if (u32LastScannedNtwrksCountShadow >= MAX_NUM_SCANNED_NETWORKS_SHADOW) {
+	if (last_scanned_cnt >= MAX_NUM_SCANNED_NETWORKS_SHADOW) {
 		PRINT_D(CFG80211_DBG, "Shadow network reached its maximum limit\n");
 		return;
 	}
 	if (ap_found == -1) {
-		ap_index = u32LastScannedNtwrksCountShadow;
-		u32LastScannedNtwrksCountShadow++;
+		ap_index = last_scanned_cnt;
+		last_scanned_cnt++;
 
 	} else {
 		ap_index = ap_found;
@@ -619,7 +617,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			memcpy(priv->au8AssociatedBss, pstrConnectInfo->au8bssid, ETH_ALEN);
 
 
-			for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
+			for (i = 0; i < last_scanned_cnt; i++) {
 				if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid,
 						pstrConnectInfo->au8bssid, ETH_ALEN) == 0) {
 					unsigned long now = jiffies;
@@ -850,7 +848,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d\n", sme->ssid, sme->auth_type);
 
-	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
+	for (i = 0; i < last_scanned_cnt; i++) {
 		if ((sme->ssid_len == astrLastScannedNtwrksShadow[i].u8SsidLen) &&
 		    memcmp(astrLastScannedNtwrksShadow[i].au8ssid,
 				sme->ssid,
@@ -874,7 +872,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	if (i < u32LastScannedNtwrksCountShadow) {
+	if (i < last_scanned_cnt) {
 		PRINT_D(CFG80211_DBG, "Required bss is in scan results\n");
 
 		pstrNetworkInfo = &(astrLastScannedNtwrksShadow[i]);
@@ -885,7 +883,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			   pstrNetworkInfo->au8bssid[4], pstrNetworkInfo->au8bssid[5]);
 	} else {
 		s32Error = -ENOENT;
-		if (u32LastScannedNtwrksCountShadow == 0)
+		if (last_scanned_cnt == 0)
 			PRINT_D(CFG80211_DBG, "No Scan results yet\n");
 		else
 			PRINT_D(CFG80211_DBG, "Required bss not in scan results: Error(%d)\n", s32Error);
-- 
1.9.1

