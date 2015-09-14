Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36149 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbINDZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:28 -0400
Received: by padhk3 with SMTP id hk3so129794122pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:28 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 17/31] staging: wilc1000: rename WILC_WFI_change_station
Date: Mon, 14 Sep 2015 12:24:17 +0900
Message-Id: <1442201071-16155-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054652_288683_1ED44043)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_station with change_station to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5bdd111..d5365de 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3427,7 +3427,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_change_station
+ *  @brief      change_station
  *  @details    Modify a given station.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3435,8 +3435,8 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
-				   const u8 *mac, struct station_parameters *params)
+static int change_station(struct wiphy *wiphy, struct net_device *dev,
+			  const u8 *mac, struct station_parameters *params)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3576,7 +3576,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.stop_ap = stop_ap,
 	.add_station = add_station,
 	.del_station = del_station,
-	.change_station = WILC_WFI_change_station,
+	.change_station = change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = WILC_WFI_get_station,
 	.dump_station = WILC_WFI_dump_station,
-- 
2.5.1

