Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58891 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbbKSGxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:53:32 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/26] staging: wilc1000: rename WILC_WFI_rates variable
Date: Thu, 19 Nov 2015 15:56:13 +0900
Message-ID: <1447916195-24851-4-git-send-email-glen.lee@atmel.com> (sfid-20151119_075334_821720_0F334E88)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames WILC_WFI_rates variable to ieee80211_bitrates
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 349b720..c2e7bf8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -149,7 +149,7 @@ static struct ieee80211_channel ieee80211_2ghz_channels[] = {
 
 
 /* Table 6 in section 3.2.1.1 */
-static struct ieee80211_rate WILC_WFI_rates[] = {
+static struct ieee80211_rate ieee80211_bitrates[] = {
 	RATETAB_ENT(10,  0,  0),
 	RATETAB_ENT(20,  1,  0),
 	RATETAB_ENT(55,  2,  0),
@@ -183,8 +183,8 @@ static bool bWilc_ie;
 static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 	.channels = ieee80211_2ghz_channels,
 	.n_channels = ARRAY_SIZE(ieee80211_2ghz_channels),
-	.bitrates = WILC_WFI_rates,
-	.n_bitrates = ARRAY_SIZE(WILC_WFI_rates),
+	.bitrates = ieee80211_bitrates,
+	.n_bitrates = ARRAY_SIZE(ieee80211_bitrates),
 };
 
 
-- 
1.9.1

