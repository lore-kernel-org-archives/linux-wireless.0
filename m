Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36281 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbIJTPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:32 -0400
Received: by padhk3 with SMTP id hk3so50754020pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:31 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 17/31] staging: wilc1000: rename WILC_WFI_change_station
Date: Fri, 11 Sep 2015 04:14:16 +0900
Message-Id: <1441912470-3371-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211540_679016_114DCB89)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_station with wilc_change_station to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ff78497..76556a0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3427,7 +3427,7 @@ static int wilc_del_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_change_station
+ *  @brief      wilc_change_station
  *  @details    Modify a given station.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3435,8 +3435,8 @@ static int wilc_del_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
-				   const u8 *mac, struct station_parameters *params)
+static int wilc_change_station(struct wiphy *wiphy, struct net_device *dev,
+			       const u8 *mac, struct station_parameters *params)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3576,7 +3576,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.stop_ap = wilc_stop_ap,
 	.add_station = wilc_add_station,
 	.del_station = wilc_del_station,
-	.change_station = WILC_WFI_change_station,
+	.change_station = wilc_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = WILC_WFI_get_station,
 	.dump_station = WILC_WFI_dump_station,
-- 
2.5.1

