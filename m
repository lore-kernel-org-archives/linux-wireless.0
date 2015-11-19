Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59216 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbbKSGyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:47 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/26] staging: wilc1000: rename s32Freq variable
Date: Thu, 19 Nov 2015 15:56:26 +0900
Message-ID: <1447916195-24851-17-git-send-email-glen.lee@atmel.com> (sfid-20151119_082253_569479_15472F59)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames s32Freq variable to freq to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9416644..55cf444 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -254,12 +254,12 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 		network_info = &last_scanned_shadow[i];
 
 		if (!network_info->u8Found || all) {
-			s32 s32Freq;
+			s32 freq;
 			struct ieee80211_channel *channel;
 
 			if (network_info) {
-				s32Freq = ieee80211_channel_to_frequency((s32)network_info->u8channel, IEEE80211_BAND_2GHZ);
-				channel = ieee80211_get_channel(wiphy, s32Freq);
+				freq = ieee80211_channel_to_frequency((s32)network_info->u8channel, IEEE80211_BAND_2GHZ);
+				channel = ieee80211_get_channel(wiphy, freq);
 
 				rssi = get_rssi_avg(network_info);
 				if (memcmp("DIRECT-", network_info->au8ssid, 7) ||
-- 
1.9.1

