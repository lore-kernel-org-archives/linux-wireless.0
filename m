Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36202 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbINDZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:31 -0400
Received: by padhk3 with SMTP id hk3so129795321pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:31 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 18/31] staging: wilc1000: rename WILC_WFI_get_station
Date: Mon, 14 Sep 2015 12:24:18 +0900
Message-Id: <1442201071-16155-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054653_930982_273CB32B)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_get_station with get_station to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d5365de..c15bd7c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1619,7 +1619,7 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
 
 
 /**
- *  @brief      WILC_WFI_get_station
+ *  @brief      get_station
  *  @details    Get station information for the station identified by @mac
  *  @param[in]   NONE
  *  @return     int : Return 0 on Success.
@@ -1628,8 +1628,8 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
  *  @version	1.0
  */
 
-static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
-				const u8 *mac, struct station_info *sinfo)
+static int get_station(struct wiphy *wiphy, struct net_device *dev,
+		       const u8 *mac, struct station_info *sinfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3578,7 +3578,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.del_station = del_station,
 	.change_station = change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
-	.get_station = WILC_WFI_get_station,
+	.get_station = get_station,
 	.dump_station = WILC_WFI_dump_station,
 	.change_bss = WILC_WFI_change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
-- 
2.5.1

