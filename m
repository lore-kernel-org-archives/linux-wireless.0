Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59359 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbbKSGzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:55:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/26] staging: wilc1000: rename enuScanEvent in CfgScanResult function
Date: Thu, 19 Nov 2015 15:56:31 +0900
Message-ID: <1447916195-24851-22-git-send-email-glen.lee@atmel.com> (sfid-20151119_082252_859427_B00E2FFF)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames enuScanEvent to scan_event that is
first argument of CfgScanResult function to avoid camelcase.
And, remove the relation comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7905f37..646beff 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -419,7 +419,10 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
  *  @date
  *  @version	1.0
  */
-static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
+static void CfgScanResult(enum scan_event scan_event,
+			  tstrNetworkInfo *pstrNetworkInfo,
+			  void *pUserVoid,
+			  void *pJoinParams)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -429,7 +432,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 
 	priv = (struct wilc_priv *)pUserVoid;
 	if (priv->bCfgScanning) {
-		if (enuScanEvent == SCAN_EVENT_NETWORK_FOUND) {
+		if (scan_event == SCAN_EVENT_NETWORK_FOUND) {
 			wiphy = priv->dev->ieee80211_ptr->wiphy;
 
 			if (!wiphy)
@@ -498,7 +501,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 					}
 				}
 			}
-		} else if (enuScanEvent == SCAN_EVENT_DONE)    {
+		} else if (scan_event == SCAN_EVENT_DONE) {
 			PRINT_D(CFG80211_DBG, "Scan Done[%p]\n", priv->dev);
 			PRINT_D(CFG80211_DBG, "Refreshing Scan ...\n");
 			refresh_scan(priv, 1, false);
@@ -517,10 +520,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 				priv->pstrScanReq = NULL;
 			}
 			up(&(priv->hSemScanReq));
-
-		}
-		/*Aborting any scan operation during mac close*/
-		else if (enuScanEvent == SCAN_EVENT_ABORTED) {
+		} else if (scan_event == SCAN_EVENT_ABORTED) {
 			down(&(priv->hSemScanReq));
 
 			PRINT_D(CFG80211_DBG, "Scan Aborted\n");
-- 
1.9.1

