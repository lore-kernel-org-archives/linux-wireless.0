Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59197 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbbKSGyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:41 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/26] staging: wilc1000: rename pstrNetworkInfo variable
Date: Thu, 19 Nov 2015 15:56:25 +0900
Message-ID: <1447916195-24851-16-git-send-email-glen.lee@atmel.com> (sfid-20151119_082255_502426_8516EC77)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrNetworkInfo variable to network_info
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6f79662..9416644 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -249,25 +249,24 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 	wiphy = priv->dev->ieee80211_ptr->wiphy;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		tstrNetworkInfo *pstrNetworkInfo;
+		tstrNetworkInfo *network_info;
 
-		pstrNetworkInfo = &last_scanned_shadow[i];
+		network_info = &last_scanned_shadow[i];
 
-		if ((!pstrNetworkInfo->u8Found) || all) {
+		if (!network_info->u8Found || all) {
 			s32 s32Freq;
 			struct ieee80211_channel *channel;
 
-			if (pstrNetworkInfo != NULL) {
-
-				s32Freq = ieee80211_channel_to_frequency((s32)pstrNetworkInfo->u8channel, IEEE80211_BAND_2GHZ);
+			if (network_info) {
+				s32Freq = ieee80211_channel_to_frequency((s32)network_info->u8channel, IEEE80211_BAND_2GHZ);
 				channel = ieee80211_get_channel(wiphy, s32Freq);
 
-				rssi = get_rssi_avg(pstrNetworkInfo);
-				if (memcmp("DIRECT-", pstrNetworkInfo->au8ssid, 7) ||
+				rssi = get_rssi_avg(network_info);
+				if (memcmp("DIRECT-", network_info->au8ssid, 7) ||
 				    direct_scan) {
-					bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN, pstrNetworkInfo->au8bssid, pstrNetworkInfo->u64Tsf, pstrNetworkInfo->u16CapInfo,
-								  pstrNetworkInfo->u16BeaconPeriod, (const u8 *)pstrNetworkInfo->pu8IEs,
-								  (size_t)pstrNetworkInfo->u16IEsLen, (((s32)rssi) * 100), GFP_KERNEL);
+					bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN, network_info->au8bssid, network_info->u64Tsf, network_info->u16CapInfo,
+								  network_info->u16BeaconPeriod, (const u8 *)network_info->pu8IEs,
+								  (size_t)network_info->u16IEsLen, (((s32)rssi) * 100), GFP_KERNEL);
 					cfg80211_put_bss(wiphy, bss);
 				}
 			}
-- 
1.9.1

