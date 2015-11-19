Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58861 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbbKSGx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:53:26 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/26] staging: wilc1000: rename WILC_WFI_2ghz_channels variable
Date: Thu, 19 Nov 2015 15:56:12 +0900
Message-ID: <1447916195-24851-3-git-send-email-glen.lee@atmel.com> (sfid-20151119_075329_424014_936D386A)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames WILC_WFI_2ghz_channels variable to ieee80211_2ghz_channels
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 32cc734..349b720 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -124,7 +124,7 @@ u8 wilc_initialized = 1;
 }
 
 /*Frequency range for channels*/
-static struct ieee80211_channel WILC_WFI_2ghz_channels[] = {
+static struct ieee80211_channel ieee80211_2ghz_channels[] = {
 	CHAN2G(1,  2412, 0),
 	CHAN2G(2,  2417, 0),
 	CHAN2G(3,  2422, 0),
@@ -181,8 +181,8 @@ static u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
 static bool bWilc_ie;
 
 static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
-	.channels = WILC_WFI_2ghz_channels,
-	.n_channels = ARRAY_SIZE(WILC_WFI_2ghz_channels),
+	.channels = ieee80211_2ghz_channels,
+	.n_channels = ARRAY_SIZE(ieee80211_2ghz_channels),
 	.bitrates = WILC_WFI_rates,
 	.n_bitrates = ARRAY_SIZE(WILC_WFI_rates),
 };
-- 
1.9.1

