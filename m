Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36240 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbbIJTP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:29 -0400
Received: by padhk3 with SMTP id hk3so50752999pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:28 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 16/31] staging: wilc1000: rename WILC_WFI_del_station
Date: Fri, 11 Sep 2015 04:14:15 +0900
Message-Id: <1441912470-3371-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211542_166126_BA7066F4)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_station with wilc_del_station to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 03dd87f..ff78497 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3384,7 +3384,7 @@ static int  wilc_add_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_del_station
+ *  @brief      wilc_del_station
  *  @details    Remove a station; @mac may be NULL to remove all stations.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3392,8 +3392,8 @@ static int  wilc_add_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_station(struct wiphy *wiphy, struct net_device *dev,
-				struct station_del_parameters *params)
+static int wilc_del_station(struct wiphy *wiphy, struct net_device *dev,
+			    struct station_del_parameters *params)
 {
 	const u8 *mac = params->mac;
 	s32 s32Error = WILC_SUCCESS;
@@ -3575,7 +3575,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_beacon = wilc_change_beacon,
 	.stop_ap = wilc_stop_ap,
 	.add_station = wilc_add_station,
-	.del_station = WILC_WFI_del_station,
+	.del_station = wilc_del_station,
 	.change_station = WILC_WFI_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = WILC_WFI_get_station,
-- 
2.5.1

