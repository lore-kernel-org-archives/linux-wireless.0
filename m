Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9127 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbcBBMFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:05:30 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/26] staging: wilc1000: renames s8rssi of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:16 +0900
Message-ID: <1454414556-9822-6-git-send-email-leo.kim@atmel.com> (sfid-20160202_130533_043416_04A43C39)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames s8rssi variable to rssi.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  2 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/host_interface.c         |  6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 0d0a4ec..1e8c56b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -309,7 +309,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		if (!network_info)
 			return -ENOMEM;
 
-		network_info->s8rssi = wid_val[0];
+		network_info->rssi = wid_val[0];
 
 		msa = &wid_val[1];
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 214b43b..e386e85 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -77,7 +77,7 @@ typedef struct {
 } tstrRSSI;
 
 struct network_info {
-	s8 s8rssi;
+	s8 rssi;
 	u16 u16CapInfo;
 	u8 au8ssid[MAX_SSID_LEN];
 	u8 u8SsidLen;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 355bee7..96f7f94 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1372,10 +1372,10 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 			    (pstrNetworkInfo->au8bssid)) {
 				if (memcmp(hif_drv->usr_scan_req.net_info[i].au8bssid,
 					   pstrNetworkInfo->au8bssid, 6) == 0) {
-					if (pstrNetworkInfo->s8rssi <= hif_drv->usr_scan_req.net_info[i].s8rssi) {
+					if (pstrNetworkInfo->rssi <= hif_drv->usr_scan_req.net_info[i].s8rssi) {
 						goto done;
 					} else {
-						hif_drv->usr_scan_req.net_info[i].s8rssi = pstrNetworkInfo->s8rssi;
+						hif_drv->usr_scan_req.net_info[i].s8rssi = pstrNetworkInfo->rssi;
 						bNewNtwrkFound = false;
 						break;
 					}
@@ -1385,7 +1385,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 
 		if (bNewNtwrkFound) {
 			if (hif_drv->usr_scan_req.rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
-				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].s8rssi = pstrNetworkInfo->s8rssi;
+				hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].s8rssi = pstrNetworkInfo->rssi;
 
 				if (hif_drv->usr_scan_req.net_info[hif_drv->usr_scan_req.rcvd_ch_cnt].au8bssid &&
 				    pstrNetworkInfo->au8bssid) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8a007743..048e6df 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -351,13 +351,13 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 		ap_index = ap_found;
 	}
 	rssi_index = last_scanned_shadow[ap_index].strRssi.u8Index;
-	last_scanned_shadow[ap_index].strRssi.as8RSSI[rssi_index++] = pstrNetworkInfo->s8rssi;
+	last_scanned_shadow[ap_index].strRssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
 	if (rssi_index == NUM_RSSI) {
 		rssi_index = 0;
 		last_scanned_shadow[ap_index].strRssi.u8Full = 1;
 	}
 	last_scanned_shadow[ap_index].strRssi.u8Index = rssi_index;
-	last_scanned_shadow[ap_index].s8rssi = pstrNetworkInfo->s8rssi;
+	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
 	last_scanned_shadow[ap_index].u16CapInfo = pstrNetworkInfo->u16CapInfo;
 	last_scanned_shadow[ap_index].u8SsidLen = pstrNetworkInfo->u8SsidLen;
 	memcpy(last_scanned_shadow[ap_index].au8ssid,
@@ -403,8 +403,8 @@ static void CfgScanResult(enum scan_event scan_event,
 				return;
 
 			if (wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
-			    (((s32)network_info->s8rssi * 100) < 0 ||
-			    ((s32)network_info->s8rssi * 100) > 100))
+			    (((s32)network_info->rssi * 100) < 0 ||
+			    ((s32)network_info->rssi * 100) > 100))
 				return;
 
 			if (network_info) {
@@ -415,7 +415,7 @@ static void CfgScanResult(enum scan_event scan_event,
 					return;
 
 				PRINT_INFO(CFG80211_DBG, "Network Info:: CHANNEL Frequency: %d, RSSI: %d, CapabilityInfo: %d,"
-					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)network_info->s8rssi) * 100),
+					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)network_info->rssi) * 100),
 					   network_info->u16CapInfo, network_info->u16BeaconPeriod);
 
 				if (network_info->bNewNetwork) {
@@ -428,7 +428,7 @@ static void CfgScanResult(enum scan_event scan_event,
 						if (!(memcmp("DIRECT-", network_info->au8ssid, 7))) {
 							bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN,  network_info->au8bssid, network_info->u64Tsf, network_info->u16CapInfo,
 										  network_info->u16BeaconPeriod, (const u8 *)network_info->pu8IEs,
-										  (size_t)network_info->u16IEsLen, (((s32)network_info->s8rssi) * 100), GFP_KERNEL);
+										  (size_t)network_info->u16IEsLen, (((s32)network_info->rssi) * 100), GFP_KERNEL);
 							cfg80211_put_bss(wiphy, bss);
 						}
 					}
@@ -439,7 +439,7 @@ static void CfgScanResult(enum scan_event scan_event,
 						if (memcmp(last_scanned_shadow[i].au8bssid, network_info->au8bssid, 6) == 0) {
 							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].au8ssid);
 
-							last_scanned_shadow[i].s8rssi = network_info->s8rssi;
+							last_scanned_shadow[i].rssi = network_info->rssi;
 							last_scanned_shadow[i].u32TimeRcvdInScan = jiffies;
 							break;
 						}
-- 
1.9.1

