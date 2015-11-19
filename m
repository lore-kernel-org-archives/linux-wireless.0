Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59150 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbbKSGya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:30 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/26] staging: wilc1000: rename pUserVoid in refresh_scan function
Date: Thu, 19 Nov 2015 15:56:23 +0900
Message-ID: <1447916195-24851-14-git-send-email-glen.lee@atmel.com> (sfid-20151119_082254_300670_C2E274FA)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pUserVoid to user_void that is
first argument of refresh_scan function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e72608b..e987e78 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -237,7 +237,7 @@ static u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 	return rssi_v;
 }
 
-static void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
+static void refresh_scan(void *user_void, u8 all, bool bDirectScan)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -245,7 +245,7 @@ static void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 	int i;
 	int rssi = 0;
 
-	priv = (struct wilc_priv *)pUserVoid;
+	priv = (struct wilc_priv *)user_void;
 	wiphy = priv->dev->ieee80211_ptr->wiphy;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-- 
1.9.1

