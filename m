Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59167 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbbKSGyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:36 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/26] staging: wilc1000: rename bDirectScan in refresh_scan function
Date: Thu, 19 Nov 2015 15:56:24 +0900
Message-ID: <1447916195-24851-15-git-send-email-glen.lee@atmel.com> (sfid-20151119_082253_321304_12C60CAA)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames bDirectScan to direct_scan that is
third argument of refresh_scan function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e987e78..6f79662 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -237,7 +237,7 @@ static u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 	return rssi_v;
 }
 
-static void refresh_scan(void *user_void, u8 all, bool bDirectScan)
+static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -263,7 +263,8 @@ static void refresh_scan(void *user_void, u8 all, bool bDirectScan)
 				channel = ieee80211_get_channel(wiphy, s32Freq);
 
 				rssi = get_rssi_avg(pstrNetworkInfo);
-				if (memcmp("DIRECT-", pstrNetworkInfo->au8ssid, 7) || bDirectScan)	{
+				if (memcmp("DIRECT-", pstrNetworkInfo->au8ssid, 7) ||
+				    direct_scan) {
 					bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN, pstrNetworkInfo->au8bssid, pstrNetworkInfo->u64Tsf, pstrNetworkInfo->u16CapInfo,
 								  pstrNetworkInfo->u16BeaconPeriod, (const u8 *)pstrNetworkInfo->pu8IEs,
 								  (size_t)pstrNetworkInfo->u16IEsLen, (((s32)rssi) * 100), GFP_KERNEL);
-- 
1.9.1

