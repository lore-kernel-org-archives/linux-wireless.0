Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58835 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbbKSGxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:53:20 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/26] staging: wilc1000: rename astrLastScannedNtwrksShadow variable
Date: Thu, 19 Nov 2015 15:56:11 +0900
Message-ID: <1447916195-24851-2-git-send-email-glen.lee@atmel.com> (sfid-20151119_075323_596446_8A09B185)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames astrLastScannedNtwrksShadow variable to last_scanned_shadow
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 124 ++++++++++------------
 1 file changed, 58 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 97848e4..32cc734 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -106,7 +106,7 @@ static const struct ieee80211_txrx_stypes
 extern int wilc_mac_open(struct net_device *ndev);
 extern int wilc_mac_close(struct net_device *ndev);
 
-static tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
+static tstrNetworkInfo last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 last_scanned_cnt;
 struct timer_list wilc_during_ip_timer;
 static struct timer_list hAgingTimer;
@@ -214,13 +214,13 @@ static void clear_shadow_scan(void *pUserVoid)
 		PRINT_INFO(CORECONFIG_DBG, "destroy aging timer\n");
 
 		for (i = 0; i < last_scanned_cnt; i++) {
-			if (astrLastScannedNtwrksShadow[last_scanned_cnt].pu8IEs != NULL) {
-				kfree(astrLastScannedNtwrksShadow[i].pu8IEs);
-				astrLastScannedNtwrksShadow[last_scanned_cnt].pu8IEs = NULL;
+			if (last_scanned_shadow[last_scanned_cnt].pu8IEs) {
+				kfree(last_scanned_shadow[i].pu8IEs);
+				last_scanned_shadow[last_scanned_cnt].pu8IEs = NULL;
 			}
 
-			wilc_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
-			astrLastScannedNtwrksShadow[i].pJoinParams = NULL;
+			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
+			last_scanned_shadow[i].pJoinParams = NULL;
 		}
 		last_scanned_cnt = 0;
 	}
@@ -254,8 +254,7 @@ static void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 	for (i = 0; i < last_scanned_cnt; i++) {
 		tstrNetworkInfo *pstrNetworkInfo;
 
-		pstrNetworkInfo = &(astrLastScannedNtwrksShadow[i]);
-
+		pstrNetworkInfo = &last_scanned_shadow[i];
 
 		if ((!pstrNetworkInfo->u8Found) || all) {
 			s32 s32Freq;
@@ -285,7 +284,7 @@ static void reset_shadow_found(void *pUserVoid)
 	int i;
 
 	for (i = 0; i < last_scanned_cnt; i++)
-		astrLastScannedNtwrksShadow[i].u8Found = 0;
+		last_scanned_shadow[i].u8Found = 0;
 }
 
 static void update_scan_time(void *pUserVoid)
@@ -293,7 +292,7 @@ static void update_scan_time(void *pUserVoid)
 	int i;
 
 	for (i = 0; i < last_scanned_cnt; i++)
-		astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan = jiffies;
+		last_scanned_shadow[i].u32TimeRcvdInScan = jiffies;
 }
 
 static void remove_network_from_shadow(unsigned long arg)
@@ -303,16 +302,16 @@ static void remove_network_from_shadow(unsigned long arg)
 
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if (time_after(now, astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan + (unsigned long)(SCAN_RESULT_EXPIRE))) {
-			PRINT_D(CFG80211_DBG, "Network expired in ScanShadow: %s\n", astrLastScannedNtwrksShadow[i].au8ssid);
+		if (time_after(now, last_scanned_shadow[i].u32TimeRcvdInScan + (unsigned long)(SCAN_RESULT_EXPIRE))) {
+			PRINT_D(CFG80211_DBG, "Network expired in ScanShadow: %s\n", last_scanned_shadow[i].au8ssid);
 
-			kfree(astrLastScannedNtwrksShadow[i].pu8IEs);
-			astrLastScannedNtwrksShadow[i].pu8IEs = NULL;
+			kfree(last_scanned_shadow[i].pu8IEs);
+			last_scanned_shadow[i].pu8IEs = NULL;
 
-			wilc_free_join_params(astrLastScannedNtwrksShadow[i].pJoinParams);
+			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
 
 			for (j = i; (j < last_scanned_cnt - 1); j++)
-				astrLastScannedNtwrksShadow[j] = astrLastScannedNtwrksShadow[j + 1];
+				last_scanned_shadow[j] = last_scanned_shadow[j + 1];
 
 			last_scanned_cnt--;
 		}
@@ -347,8 +346,8 @@ static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoi
 	} else {
 		/* Linear search for now */
 		for (i = 0; i < last_scanned_cnt; i++) {
-			if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid,
-					pstrNetworkInfo->au8bssid, 6) == 0) {
+			if (memcmp(last_scanned_shadow[i].au8bssid,
+				   pstrNetworkInfo->au8bssid, 6) == 0) {
 				state = i;
 				break;
 			}
@@ -374,44 +373,37 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserV
 	} else {
 		ap_index = ap_found;
 	}
-	rssi_index = astrLastScannedNtwrksShadow[ap_index].strRssi.u8Index;
-	astrLastScannedNtwrksShadow[ap_index].strRssi.as8RSSI[rssi_index++] = pstrNetworkInfo->s8rssi;
+	rssi_index = last_scanned_shadow[ap_index].strRssi.u8Index;
+	last_scanned_shadow[ap_index].strRssi.as8RSSI[rssi_index++] = pstrNetworkInfo->s8rssi;
 	if (rssi_index == NUM_RSSI) {
 		rssi_index = 0;
-		astrLastScannedNtwrksShadow[ap_index].strRssi.u8Full = 1;
-	}
-	astrLastScannedNtwrksShadow[ap_index].strRssi.u8Index = rssi_index;
-
-	astrLastScannedNtwrksShadow[ap_index].s8rssi = pstrNetworkInfo->s8rssi;
-	astrLastScannedNtwrksShadow[ap_index].u16CapInfo = pstrNetworkInfo->u16CapInfo;
-
-	astrLastScannedNtwrksShadow[ap_index].u8SsidLen = pstrNetworkInfo->u8SsidLen;
-	memcpy(astrLastScannedNtwrksShadow[ap_index].au8ssid,
-		    pstrNetworkInfo->au8ssid, pstrNetworkInfo->u8SsidLen);
-
-	memcpy(astrLastScannedNtwrksShadow[ap_index].au8bssid,
-		    pstrNetworkInfo->au8bssid, ETH_ALEN);
-
-	astrLastScannedNtwrksShadow[ap_index].u16BeaconPeriod = pstrNetworkInfo->u16BeaconPeriod;
-	astrLastScannedNtwrksShadow[ap_index].u8DtimPeriod = pstrNetworkInfo->u8DtimPeriod;
-	astrLastScannedNtwrksShadow[ap_index].u8channel = pstrNetworkInfo->u8channel;
-
-	astrLastScannedNtwrksShadow[ap_index].u16IEsLen = pstrNetworkInfo->u16IEsLen;
-	astrLastScannedNtwrksShadow[ap_index].u64Tsf = pstrNetworkInfo->u64Tsf;
+		last_scanned_shadow[ap_index].strRssi.u8Full = 1;
+	}
+	last_scanned_shadow[ap_index].strRssi.u8Index = rssi_index;
+	last_scanned_shadow[ap_index].s8rssi = pstrNetworkInfo->s8rssi;
+	last_scanned_shadow[ap_index].u16CapInfo = pstrNetworkInfo->u16CapInfo;
+	last_scanned_shadow[ap_index].u8SsidLen = pstrNetworkInfo->u8SsidLen;
+	memcpy(last_scanned_shadow[ap_index].au8ssid,
+	       pstrNetworkInfo->au8ssid, pstrNetworkInfo->u8SsidLen);
+	memcpy(last_scanned_shadow[ap_index].au8bssid,
+	       pstrNetworkInfo->au8bssid, ETH_ALEN);
+	last_scanned_shadow[ap_index].u16BeaconPeriod = pstrNetworkInfo->u16BeaconPeriod;
+	last_scanned_shadow[ap_index].u8DtimPeriod = pstrNetworkInfo->u8DtimPeriod;
+	last_scanned_shadow[ap_index].u8channel = pstrNetworkInfo->u8channel;
+	last_scanned_shadow[ap_index].u16IEsLen = pstrNetworkInfo->u16IEsLen;
+	last_scanned_shadow[ap_index].u64Tsf = pstrNetworkInfo->u64Tsf;
 	if (ap_found != -1)
-		kfree(astrLastScannedNtwrksShadow[ap_index].pu8IEs);
-	astrLastScannedNtwrksShadow[ap_index].pu8IEs =
+		kfree(last_scanned_shadow[ap_index].pu8IEs);
+	last_scanned_shadow[ap_index].pu8IEs =
 		kmalloc(pstrNetworkInfo->u16IEsLen, GFP_KERNEL);        /* will be deallocated by the WILC_WFI_CfgScan() function */
-	memcpy(astrLastScannedNtwrksShadow[ap_index].pu8IEs,
-		    pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
-
-	astrLastScannedNtwrksShadow[ap_index].u32TimeRcvdInScan = jiffies;
-	astrLastScannedNtwrksShadow[ap_index].u32TimeRcvdInScanCached = jiffies;
-	astrLastScannedNtwrksShadow[ap_index].u8Found = 1;
+	memcpy(last_scanned_shadow[ap_index].pu8IEs,
+	       pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
+	last_scanned_shadow[ap_index].u32TimeRcvdInScan = jiffies;
+	last_scanned_shadow[ap_index].u32TimeRcvdInScanCached = jiffies;
+	last_scanned_shadow[ap_index].u8Found = 1;
 	if (ap_found != -1)
-		wilc_free_join_params(astrLastScannedNtwrksShadow[ap_index].pJoinParams);
-	astrLastScannedNtwrksShadow[ap_index].pJoinParams = pJoinParams;
-
+		wilc_free_join_params(last_scanned_shadow[ap_index].pJoinParams);
+	last_scanned_shadow[ap_index].pJoinParams = pJoinParams;
 }
 
 
@@ -497,11 +489,11 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 					u32 i;
 					/* So this network is discovered before, we'll just update its RSSI */
 					for (i = 0; i < priv->u32RcvdChCount; i++) {
-						if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid, pstrNetworkInfo->au8bssid, 6) == 0) {
-							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", astrLastScannedNtwrksShadow[i].au8ssid);
+						if (memcmp(last_scanned_shadow[i].au8bssid, pstrNetworkInfo->au8bssid, 6) == 0) {
+							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].au8ssid);
 
-							astrLastScannedNtwrksShadow[i].s8rssi = pstrNetworkInfo->s8rssi;
-							astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan = jiffies;
+							last_scanned_shadow[i].s8rssi = pstrNetworkInfo->s8rssi;
+							last_scanned_shadow[i].u32TimeRcvdInScan = jiffies;
 							break;
 						}
 					}
@@ -618,12 +610,12 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 
 			for (i = 0; i < last_scanned_cnt; i++) {
-				if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid,
-						pstrConnectInfo->au8bssid, ETH_ALEN) == 0) {
+				if (memcmp(last_scanned_shadow[i].au8bssid,
+					   pstrConnectInfo->au8bssid, ETH_ALEN) == 0) {
 					unsigned long now = jiffies;
 
 					if (time_after(now,
-						       astrLastScannedNtwrksShadow[i].u32TimeRcvdInScanCached + (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ)))) {
+						       last_scanned_shadow[i].u32TimeRcvdInScanCached + (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ)))) {
 						bNeedScanRefresh = true;
 					}
 
@@ -849,10 +841,10 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d\n", sme->ssid, sme->auth_type);
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if ((sme->ssid_len == astrLastScannedNtwrksShadow[i].u8SsidLen) &&
-		    memcmp(astrLastScannedNtwrksShadow[i].au8ssid,
-				sme->ssid,
-				sme->ssid_len) == 0) {
+		if ((sme->ssid_len == last_scanned_shadow[i].u8SsidLen) &&
+		    memcmp(last_scanned_shadow[i].au8ssid,
+			   sme->ssid,
+			   sme->ssid_len) == 0) {
 			PRINT_INFO(CFG80211_DBG, "Network with required SSID is found %s\n", sme->ssid);
 			if (sme->bssid == NULL)	{
 				/* BSSID is not passed from the user, so decision of matching
@@ -862,9 +854,9 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			} else {
 				/* BSSID is also passed from the user, so decision of matching
 				 * should consider also this passed BSSID */
-				if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid,
-						sme->bssid,
-						ETH_ALEN) == 0)	{
+				if (memcmp(last_scanned_shadow[i].au8bssid,
+					   sme->bssid,
+					   ETH_ALEN) == 0) {
 					PRINT_INFO(CFG80211_DBG, "BSSID is passed from the user and matched\n");
 					break;
 				}
@@ -875,7 +867,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (i < last_scanned_cnt) {
 		PRINT_D(CFG80211_DBG, "Required bss is in scan results\n");
 
-		pstrNetworkInfo = &(astrLastScannedNtwrksShadow[i]);
+		pstrNetworkInfo = &last_scanned_shadow[i];
 
 		PRINT_INFO(CFG80211_DBG, "network BSSID to be associated: %x%x%x%x%x%x\n",
 			   pstrNetworkInfo->au8bssid[0], pstrNetworkInfo->au8bssid[1],
-- 
1.9.1

