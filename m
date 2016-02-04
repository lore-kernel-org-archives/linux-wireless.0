Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58867 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbcBDJcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:32:42 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 52/70] staging: wilc1000: renames au8ssid of connect_resp_info structure
Date: Thu, 4 Feb 2016 18:24:13 +0900
Message-ID: <1454577871-667-13-git-send-email-glen.lee@atmel.com> (sfid-20160204_103251_063740_0079FF06)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8ssid variable to ssid.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  2 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/host_interface.c         |  3 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 19 +++++++++++--------
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 6c40d36..4dd7c8a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -322,7 +322,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 
 		network_info->u64Tsf = tsf_lo | ((u64)tsf_hi << 32);
 
-		get_ssid(msa, network_info->au8ssid, &network_info->u8SsidLen);
+		get_ssid(msa, network_info->ssid, &network_info->u8SsidLen);
 		get_BSSID(msa, network_info->au8bssid);
 
 		network_info->u8channel = get_current_channel_802_11n(msa,
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index ace50d8..781a65f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -79,7 +79,7 @@ typedef struct {
 struct network_info {
 	s8 rssi;
 	u16 cap_info;
-	u8 au8ssid[MAX_SSID_LEN];
+	u8 ssid[MAX_SSID_LEN];
 	u8 u8SsidLen;
 	u8 au8bssid[6];
 	u16 u16BeaconPeriod;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d56a33c..c31f0b5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4279,7 +4279,8 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
 		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
-		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->au8ssid, ptstrNetworkInfo->u8SsidLen + 1);
+		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->ssid,
+		       ptstrNetworkInfo->u8SsidLen + 1);
 		pNewJoinBssParam->ssid_len = ptstrNetworkInfo->u8SsidLen;
 		memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
 		memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 578a3f2..9aae11e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -244,7 +244,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 				channel = ieee80211_get_channel(wiphy, freq);
 
 				rssi = get_rssi_avg(network_info);
-				if (memcmp("DIRECT-", network_info->au8ssid, 7) ||
+				if (memcmp("DIRECT-", network_info->ssid, 7) ||
 				    direct_scan) {
 					bss = cfg80211_inform_bss(wiphy,
 								  channel,
@@ -288,7 +288,8 @@ static void remove_network_from_shadow(unsigned long arg)
 
 	for (i = 0; i < last_scanned_cnt; i++) {
 		if (time_after(now, last_scanned_shadow[i].u32TimeRcvdInScan + (unsigned long)(SCAN_RESULT_EXPIRE))) {
-			PRINT_D(CFG80211_DBG, "Network expired in ScanShadow: %s\n", last_scanned_shadow[i].au8ssid);
+			PRINT_D(CFG80211_DBG, "Network expired ScanShadow:%s\n",
+				last_scanned_shadow[i].ssid);
 
 			kfree(last_scanned_shadow[i].pu8IEs);
 			last_scanned_shadow[i].pu8IEs = NULL;
@@ -368,8 +369,8 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
 	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
 	last_scanned_shadow[ap_index].u8SsidLen = pstrNetworkInfo->u8SsidLen;
-	memcpy(last_scanned_shadow[ap_index].au8ssid,
-	       pstrNetworkInfo->au8ssid, pstrNetworkInfo->u8SsidLen);
+	memcpy(last_scanned_shadow[ap_index].ssid,
+	       pstrNetworkInfo->ssid, pstrNetworkInfo->u8SsidLen);
 	memcpy(last_scanned_shadow[ap_index].au8bssid,
 	       pstrNetworkInfo->au8bssid, ETH_ALEN);
 	last_scanned_shadow[ap_index].u16BeaconPeriod = pstrNetworkInfo->u16BeaconPeriod;
@@ -434,12 +435,14 @@ static void CfgScanResult(enum scan_event scan_event,
 
 				if (network_info->bNewNetwork) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
-						PRINT_D(CFG80211_DBG, "Network %s found\n", network_info->au8ssid);
+						PRINT_D(CFG80211_DBG,
+							"Network %s found\n",
+							network_info->ssid);
 						priv->u32RcvdChCount++;
 
 						add_network_to_shadow(network_info, priv, join_params);
 
-						if (!(memcmp("DIRECT-", network_info->au8ssid, 7))) {
+						if (!(memcmp("DIRECT-", network_info->ssid, 7))) {
 							bss = cfg80211_inform_bss(wiphy,
 										  channel,
 										  CFG80211_BSS_FTYPE_UNKNOWN,
@@ -459,7 +462,7 @@ static void CfgScanResult(enum scan_event scan_event,
 
 					for (i = 0; i < priv->u32RcvdChCount; i++) {
 						if (memcmp(last_scanned_shadow[i].au8bssid, network_info->au8bssid, 6) == 0) {
-							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].au8ssid);
+							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].ssid);
 
 							last_scanned_shadow[i].rssi = network_info->rssi;
 							last_scanned_shadow[i].u32TimeRcvdInScan = jiffies;
@@ -736,7 +739,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	for (i = 0; i < last_scanned_cnt; i++) {
 		if ((sme->ssid_len == last_scanned_shadow[i].u8SsidLen) &&
-		    memcmp(last_scanned_shadow[i].au8ssid,
+		    memcmp(last_scanned_shadow[i].ssid,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
 			PRINT_INFO(CFG80211_DBG, "Network with required SSID is found %s\n", sme->ssid);
-- 
1.9.1

