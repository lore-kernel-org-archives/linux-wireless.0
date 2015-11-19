Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59251 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688AbbKSGyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/26] staging: wilc1000: reset_shadow_found: remove unused argument
Date: Thu, 19 Nov 2015 15:56:27 +0900
Message-ID: <1447916195-24851-18-git-send-email-glen.lee@atmel.com> (sfid-20151119_082252_569707_F0E297CA)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes pUserVoid that is first argument of
reset_shadow_found function because it is not used in this function.
Remove argument in the function call also.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 55cf444..5032705 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -276,7 +276,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 
 }
 
-static void reset_shadow_found(void *pUserVoid)
+static void reset_shadow_found(void)
 {
 	int i;
 
@@ -731,9 +731,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	priv->u32RcvdChCount = 0;
 
 	wilc_set_wfi_drv_handler(priv->hWILCWFIDrv);
-
-
-	reset_shadow_found(priv);
+	reset_shadow_found();
 
 	priv->bCfgScanning = true;
 	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) { /* TODO: mostafa: to be replaced by */
-- 
1.9.1

