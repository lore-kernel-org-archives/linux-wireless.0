Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59385 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbbKSGzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:55:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/26] staging: wilc1000: rename pstrNetworkInfo in CfgScanResult function
Date: Thu, 19 Nov 2015 15:56:32 +0900
Message-ID: <1447916195-24851-23-git-send-email-glen.lee@atmel.com> (sfid-20151119_082254_049654_DCB3152B)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrNetworkInfo to network_info that is
second argument of CfgScanResult function to avoid camelcase.
And, remove the relation comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 41 ++++++++++-------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 646beff..b0d1ed3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -420,7 +420,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
  *  @version	1.0
  */
 static void CfgScanResult(enum scan_event scan_event,
-			  tstrNetworkInfo *pstrNetworkInfo,
+			  tstrNetworkInfo *network_info,
 			  void *pUserVoid,
 			  void *pJoinParams)
 {
@@ -438,33 +438,27 @@ static void CfgScanResult(enum scan_event scan_event,
 			if (!wiphy)
 				return;
 
-			if (wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC
-			    &&
-			    ((((s32)pstrNetworkInfo->s8rssi) * 100) < 0
-			     ||
-			     (((s32)pstrNetworkInfo->s8rssi) * 100) > 100)
-			    ) {
+			if (wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
+			    (((s32)network_info->s8rssi * 100) < 0 ||
+			    ((s32)network_info->s8rssi * 100) > 100)) {
 				PRINT_ER("wiphy signal type fial\n");
 				return;
 			}
 
-			if (pstrNetworkInfo != NULL) {
-				s32Freq = ieee80211_channel_to_frequency((s32)pstrNetworkInfo->u8channel, IEEE80211_BAND_2GHZ);
+			if (network_info) {
+				s32Freq = ieee80211_channel_to_frequency((s32)network_info->u8channel, IEEE80211_BAND_2GHZ);
 				channel = ieee80211_get_channel(wiphy, s32Freq);
 
 				if (!channel)
 					return;
 
 				PRINT_INFO(CFG80211_DBG, "Network Info:: CHANNEL Frequency: %d, RSSI: %d, CapabilityInfo: %d,"
-					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)pstrNetworkInfo->s8rssi) * 100),
-					   pstrNetworkInfo->u16CapInfo, pstrNetworkInfo->u16BeaconPeriod);
+					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)network_info->s8rssi) * 100),
+					   network_info->u16CapInfo, network_info->u16BeaconPeriod);
 
-				if (pstrNetworkInfo->bNewNetwork) {
+				if (network_info->bNewNetwork) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) { /* TODO: mostafa: to be replaced by */
-						/*               max_scan_ssids */
-						PRINT_D(CFG80211_DBG, "Network %s found\n", pstrNetworkInfo->au8ssid);
-
-
+						PRINT_D(CFG80211_DBG, "Network %s found\n", network_info->au8ssid);
 						priv->u32RcvdChCount++;
 
 
@@ -472,14 +466,13 @@ static void CfgScanResult(enum scan_event scan_event,
 						if (pJoinParams == NULL) {
 							PRINT_INFO(CORECONFIG_DBG, ">> Something really bad happened\n");
 						}
-						add_network_to_shadow(pstrNetworkInfo, priv, pJoinParams);
+						add_network_to_shadow(network_info, priv, pJoinParams);
 
 						/*P2P peers are sent to WPA supplicant and added to shadow table*/
-
-						if (!(memcmp("DIRECT-", pstrNetworkInfo->au8ssid, 7))) {
-							bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN,  pstrNetworkInfo->au8bssid, pstrNetworkInfo->u64Tsf, pstrNetworkInfo->u16CapInfo,
-										  pstrNetworkInfo->u16BeaconPeriod, (const u8 *)pstrNetworkInfo->pu8IEs,
-										  (size_t)pstrNetworkInfo->u16IEsLen, (((s32)pstrNetworkInfo->s8rssi) * 100), GFP_KERNEL);
+						if (!(memcmp("DIRECT-", network_info->au8ssid, 7))) {
+							bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN,  network_info->au8bssid, network_info->u64Tsf, network_info->u16CapInfo,
+										  network_info->u16BeaconPeriod, (const u8 *)network_info->pu8IEs,
+										  (size_t)network_info->u16IEsLen, (((s32)network_info->s8rssi) * 100), GFP_KERNEL);
 							cfg80211_put_bss(wiphy, bss);
 						}
 
@@ -491,10 +484,10 @@ static void CfgScanResult(enum scan_event scan_event,
 					u32 i;
 					/* So this network is discovered before, we'll just update its RSSI */
 					for (i = 0; i < priv->u32RcvdChCount; i++) {
-						if (memcmp(last_scanned_shadow[i].au8bssid, pstrNetworkInfo->au8bssid, 6) == 0) {
+						if (memcmp(last_scanned_shadow[i].au8bssid, network_info->au8bssid, 6) == 0) {
 							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].au8ssid);
 
-							last_scanned_shadow[i].s8rssi = pstrNetworkInfo->s8rssi;
+							last_scanned_shadow[i].s8rssi = network_info->s8rssi;
 							last_scanned_shadow[i].u32TimeRcvdInScan = jiffies;
 							break;
 						}
-- 
1.9.1

