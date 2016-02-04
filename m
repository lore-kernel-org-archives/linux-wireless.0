Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58838 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbcBDJch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:32:37 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 51/70] staging: wilc1000: renames u16CapInfo of connect_resp_info structure
Date: Thu, 4 Feb 2016 18:24:12 +0900
Message-ID: <1454577871-667-12-git-send-email-glen.lee@atmel.com> (sfid-20160204_103242_783084_7F67E948)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16CapInfo variable to cap_info.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  2 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 42 +++++++++++++++++------
 4 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 1e8c56b..6c40d36 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -314,7 +314,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		msa = &wid_val[1];
 
 		rx_len = wid_len - 1;
-		network_info->u16CapInfo = get_cap_info(msa);
+		network_info->cap_info = get_cap_info(msa);
 		network_info->u32Tsf = get_beacon_timestamp_lo(msa);
 
 		tsf_lo = get_beacon_timestamp_lo(msa);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index e386e85..ace50d8 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -78,7 +78,7 @@ typedef struct {
 
 struct network_info {
 	s8 rssi;
-	u16 u16CapInfo;
+	u16 cap_info;
 	u8 au8ssid[MAX_SSID_LEN];
 	u8 u8SsidLen;
 	u8 au8bssid[6];
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f40b5a7..d56a33c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4277,7 +4277,7 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 	if (pNewJoinBssParam) {
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
-		pNewJoinBssParam->cap_info = ptstrNetworkInfo->u16CapInfo;
+		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
 		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
 		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->au8ssid, ptstrNetworkInfo->u8SsidLen + 1);
 		pNewJoinBssParam->ssid_len = ptstrNetworkInfo->u8SsidLen;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f0c6c9f..578a3f2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -246,9 +246,17 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 				rssi = get_rssi_avg(network_info);
 				if (memcmp("DIRECT-", network_info->au8ssid, 7) ||
 				    direct_scan) {
-					bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN, network_info->au8bssid, network_info->u64Tsf, network_info->u16CapInfo,
-								  network_info->u16BeaconPeriod, (const u8 *)network_info->pu8IEs,
-								  (size_t)network_info->u16IEsLen, (((s32)rssi) * 100), GFP_KERNEL);
+					bss = cfg80211_inform_bss(wiphy,
+								  channel,
+								  CFG80211_BSS_FTYPE_UNKNOWN,
+								  network_info->au8bssid,
+								  network_info->u64Tsf,
+								  network_info->cap_info,
+								  network_info->u16BeaconPeriod,
+								  (const u8 *)network_info->pu8IEs,
+								  (size_t)network_info->u16IEsLen,
+								  (s32)rssi * 100,
+								  GFP_KERNEL);
 					cfg80211_put_bss(wiphy, bss);
 				}
 			}
@@ -358,7 +366,7 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	}
 	last_scanned_shadow[ap_index].strRssi.u8Index = rssi_index;
 	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
-	last_scanned_shadow[ap_index].u16CapInfo = pstrNetworkInfo->u16CapInfo;
+	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
 	last_scanned_shadow[ap_index].u8SsidLen = pstrNetworkInfo->u8SsidLen;
 	memcpy(last_scanned_shadow[ap_index].au8ssid,
 	       pstrNetworkInfo->au8ssid, pstrNetworkInfo->u8SsidLen);
@@ -414,9 +422,15 @@ static void CfgScanResult(enum scan_event scan_event,
 				if (!channel)
 					return;
 
-				PRINT_INFO(CFG80211_DBG, "Network Info:: CHANNEL Frequency: %d, RSSI: %d, CapabilityInfo: %d,"
-					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)network_info->rssi) * 100),
-					   network_info->u16CapInfo, network_info->u16BeaconPeriod);
+				PRINT_INFO(CFG80211_DBG, "Network Info::"
+					   "CHANNEL Frequency: %d,"
+					   "RSSI: %d,"
+					   "Capability Info: %d,"
+					   "Beacon Period: %d\n",
+					   channel->center_freq,
+					   (s32)network_info->rssi * 100,
+					   network_info->cap_info,
+					   network_info->u16BeaconPeriod);
 
 				if (network_info->bNewNetwork) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
@@ -426,9 +440,17 @@ static void CfgScanResult(enum scan_event scan_event,
 						add_network_to_shadow(network_info, priv, join_params);
 
 						if (!(memcmp("DIRECT-", network_info->au8ssid, 7))) {
-							bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN,  network_info->au8bssid, network_info->u64Tsf, network_info->u16CapInfo,
-										  network_info->u16BeaconPeriod, (const u8 *)network_info->pu8IEs,
-										  (size_t)network_info->u16IEsLen, (((s32)network_info->rssi) * 100), GFP_KERNEL);
+							bss = cfg80211_inform_bss(wiphy,
+										  channel,
+										  CFG80211_BSS_FTYPE_UNKNOWN,
+										  network_info->au8bssid,
+										  network_info->u64Tsf,
+										  network_info->cap_info,
+										  network_info->u16BeaconPeriod,
+										  (const u8 *)network_info->pu8IEs,
+										  (size_t)network_info->u16IEsLen,
+										  (s32)network_info->rssi * 100,
+										  GFP_KERNEL);
 							cfg80211_put_bss(wiphy, bss);
 						}
 					}
-- 
1.9.1

