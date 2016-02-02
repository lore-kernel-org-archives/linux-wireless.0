Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9428 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbcBBMGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:06:46 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/26] staging: wilc1000: renames u16BeaconPeriod of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:21 +0900
Message-ID: <1454414556-9822-11-git-send-email-leo.kim@atmel.com> (sfid-20160202_130649_646231_8D6FD39D)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16BeaconPeriod variable to beacon_period.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 2 +-
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4a82576..b4f7ec3 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -330,7 +330,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 
 		index = MAC_HDR_LEN + TIME_STAMP_LEN;
 
-		network_info->u16BeaconPeriod = get_beacon_period(msa + index);
+		network_info->beacon_period = get_beacon_period(msa + index);
 
 		index += BEACON_INTERVAL_LEN + CAP_INFO_LEN;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 5404162..2fbffe8 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -82,7 +82,7 @@ struct network_info {
 	u8 ssid[MAX_SSID_LEN];
 	u8 ssid_len;
 	u8 bssid[6];
-	u16 u16BeaconPeriod;
+	u16 beacon_period;
 	u8 u8DtimPeriod;
 	u8 u8channel;
 	unsigned long u32TimeRcvdInScanCached;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b465e9e..99bc890 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4277,7 +4277,7 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 	pNewJoinBssParam = kzalloc(sizeof(struct join_bss_param), GFP_KERNEL);
 	if (pNewJoinBssParam) {
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
-		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
+		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->beacon_period;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
 		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->bssid, 6);
 		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->ssid,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c8b9a97..086ec07 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -252,7 +252,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 								  network_info->bssid,
 								  network_info->u64Tsf,
 								  network_info->cap_info,
-								  network_info->u16BeaconPeriod,
+								  network_info->beacon_period,
 								  (const u8 *)network_info->pu8IEs,
 								  (size_t)network_info->u16IEsLen,
 								  (s32)rssi * 100,
@@ -373,7 +373,7 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	       pstrNetworkInfo->ssid, pstrNetworkInfo->ssid_len);
 	memcpy(last_scanned_shadow[ap_index].bssid,
 	       pstrNetworkInfo->bssid, ETH_ALEN);
-	last_scanned_shadow[ap_index].u16BeaconPeriod = pstrNetworkInfo->u16BeaconPeriod;
+	last_scanned_shadow[ap_index].beacon_period = pstrNetworkInfo->beacon_period;
 	last_scanned_shadow[ap_index].u8DtimPeriod = pstrNetworkInfo->u8DtimPeriod;
 	last_scanned_shadow[ap_index].u8channel = pstrNetworkInfo->u8channel;
 	last_scanned_shadow[ap_index].u16IEsLen = pstrNetworkInfo->u16IEsLen;
@@ -431,7 +431,7 @@ static void CfgScanResult(enum scan_event scan_event,
 					   channel->center_freq,
 					   (s32)network_info->rssi * 100,
 					   network_info->cap_info,
-					   network_info->u16BeaconPeriod);
+					   network_info->beacon_period);
 
 				if (network_info->bNewNetwork) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
@@ -449,7 +449,7 @@ static void CfgScanResult(enum scan_event scan_event,
 										  network_info->bssid,
 										  network_info->u64Tsf,
 										  network_info->cap_info,
-										  network_info->u16BeaconPeriod,
+										  network_info->beacon_period,
 										  (const u8 *)network_info->pu8IEs,
 										  (size_t)network_info->u16IEsLen,
 										  (s32)network_info->rssi * 100,
-- 
1.9.1

