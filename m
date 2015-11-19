Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59268 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688AbbKSGy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/26] staging: wilc1000: update_scan_time: remove unused argument
Date: Thu, 19 Nov 2015 15:56:28 +0900
Message-ID: <1447916195-24851-19-git-send-email-glen.lee@atmel.com> (sfid-20151119_082253_801280_5466DB5F)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes pUserVoid that is first argument of
update_scan_time function because it is not used in this function.
Remove argument in the function call also.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5032705..56005f6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -284,7 +284,7 @@ static void reset_shadow_found(void)
 		last_scanned_shadow[i].u8Found = 0;
 }
 
-static void update_scan_time(void *pUserVoid)
+static void update_scan_time(void)
 {
 	int i;
 
@@ -523,8 +523,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 
 			PRINT_D(CFG80211_DBG, "Scan Aborted\n");
 			if (priv->pstrScanReq != NULL) {
-
-				update_scan_time(priv);
+				update_scan_time();
 				refresh_scan(priv, 1, false);
 
 				cfg80211_scan_done(priv->pstrScanReq, false);
-- 
1.9.1

