Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59419 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbbKSGz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:55:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/26] staging: wilc1000: rename pUserVoid in CfgScanResult function
Date: Thu, 19 Nov 2015 15:56:33 +0900
Message-ID: <1447916195-24851-24-git-send-email-glen.lee@atmel.com> (sfid-20151119_082255_027325_B95375E2)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pUserVoid to user_void that is
third argument of CfgScanResult function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b0d1ed3..0b03e54 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -421,7 +421,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
  */
 static void CfgScanResult(enum scan_event scan_event,
 			  tstrNetworkInfo *network_info,
-			  void *pUserVoid,
+			  void *user_void,
 			  void *pJoinParams)
 {
 	struct wilc_priv *priv;
@@ -430,7 +430,7 @@ static void CfgScanResult(enum scan_event scan_event,
 	struct ieee80211_channel *channel;
 	struct cfg80211_bss *bss = NULL;
 
-	priv = (struct wilc_priv *)pUserVoid;
+	priv = (struct wilc_priv *)user_void;
 	if (priv->bCfgScanning) {
 		if (scan_event == SCAN_EVENT_NETWORK_FOUND) {
 			wiphy = priv->dev->ieee80211_ptr->wiphy;
-- 
1.9.1

