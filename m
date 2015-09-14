Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33098 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbbINDZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:19 -0400
Received: by pacex6 with SMTP id ex6so130290596pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 14/31] staging: wilc1000: rename WILC_WFI_stop_ap
Date: Mon, 14 Sep 2015 12:24:14 +0900
Message-Id: <1442201071-16155-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054653_804323_1C0BC288)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_stop_ap with stop_ap to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 936db60..0b5baec 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3278,7 +3278,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_stop_ap
+ *  @brief      stop_ap
  *  @details    Remove beacon configuration and stop sending the beacon.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3286,7 +3286,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
  *  @date	23 JUL 2013
  *  @version	1.0
  */
-static int  WILC_WFI_stop_ap(struct wiphy *wiphy, struct net_device *dev)
+static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3573,7 +3573,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
 	.start_ap = start_ap,
 	.change_beacon = change_beacon,
-	.stop_ap = WILC_WFI_stop_ap,
+	.stop_ap = stop_ap,
 	.add_station = WILC_WFI_add_station,
 	.del_station = WILC_WFI_del_station,
 	.change_station = WILC_WFI_change_station,
-- 
2.5.1

