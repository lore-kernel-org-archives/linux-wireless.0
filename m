Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59435 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbbKSGzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:55:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/26] staging: wilc1000: rename pJoinParams in CfgScanResult function
Date: Thu, 19 Nov 2015 15:56:34 +0900
Message-ID: <1447916195-24851-25-git-send-email-glen.lee@atmel.com> (sfid-20151119_082255_267940_C56D73B8)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pJoinParams to join_params that is
fourth argument of CfgScanResult function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0b03e54..a429167 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -422,7 +422,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
 static void CfgScanResult(enum scan_event scan_event,
 			  tstrNetworkInfo *network_info,
 			  void *user_void,
-			  void *pJoinParams)
+			  void *join_params)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -461,12 +461,9 @@ static void CfgScanResult(enum scan_event scan_event,
 						PRINT_D(CFG80211_DBG, "Network %s found\n", network_info->au8ssid);
 						priv->u32RcvdChCount++;
 
-
-
-						if (pJoinParams == NULL) {
+						if (!join_params)
 							PRINT_INFO(CORECONFIG_DBG, ">> Something really bad happened\n");
-						}
-						add_network_to_shadow(network_info, priv, pJoinParams);
+						add_network_to_shadow(network_info, priv, join_params);
 
 						/*P2P peers are sent to WPA supplicant and added to shadow table*/
 						if (!(memcmp("DIRECT-", network_info->au8ssid, 7))) {
-- 
1.9.1

