Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35191 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbIJTPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:35 -0400
Received: by pacfv12 with SMTP id fv12so51864195pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 18/31] staging: wilc1000: rename WILC_WFI_get_station
Date: Fri, 11 Sep 2015 04:14:17 +0900
Message-Id: <1441912470-3371-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211541_412825_3CBF624C)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_get_station with wilc_get_station to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 76556a0..afacda5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1619,7 +1619,7 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
 
 
 /**
- *  @brief      WILC_WFI_get_station
+ *  @brief      wilc_get_station
  *  @details    Get station information for the station identified by @mac
  *  @param[in]   NONE
  *  @return     int : Return 0 on Success.
@@ -1628,8 +1628,8 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
  *  @version	1.0
  */
 
-static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
-				const u8 *mac, struct station_info *sinfo)
+static int wilc_get_station(struct wiphy *wiphy, struct net_device *dev,
+			    const u8 *mac, struct station_info *sinfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3578,7 +3578,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.del_station = wilc_del_station,
 	.change_station = wilc_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
-	.get_station = WILC_WFI_get_station,
+	.get_station = wilc_get_station,
 	.dump_station = WILC_WFI_dump_station,
 	.change_bss = WILC_WFI_change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
-- 
2.5.1

