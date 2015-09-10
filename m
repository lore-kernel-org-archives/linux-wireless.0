Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34977 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbbIJTPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:20 -0400
Received: by pacfv12 with SMTP id fv12so51858779pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 13/31] staging: wilc1000: remove WILC_WFI_change_beacon
Date: Fri, 11 Sep 2015 04:14:12 +0900
Message-Id: <1441912470-3371-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211534_024848_451C96B2)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_beacon with wilc_change_beacon to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index eba2d56..69df5a0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3247,7 +3247,7 @@ static int wilc_start_ap(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_change_beacon
+ *  @brief      wilc_change_beacon
  *  @details    Add a beacon with given parameters, @head, @interval
  *                      and @dtim_period will be valid, @tail is optional.
  *  @param[in]   wiphy
@@ -3258,8 +3258,8 @@ static int wilc_start_ap(struct wiphy *wiphy, struct net_device *dev,
  *  @date	23 JUL 2013
  *  @version	1.0
  */
-static int  WILC_WFI_change_beacon(struct wiphy *wiphy, struct net_device *dev,
-				   struct cfg80211_beacon_data *beacon)
+static int  wilc_change_beacon(struct wiphy *wiphy, struct net_device *dev,
+				struct cfg80211_beacon_data *beacon)
 {
 	struct WILC_WFI_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
@@ -3572,7 +3572,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_virtual_intf = wilc_change_virt_intf,
 
 	.start_ap = wilc_start_ap,
-	.change_beacon = WILC_WFI_change_beacon,
+	.change_beacon = wilc_change_beacon,
 	.stop_ap = WILC_WFI_stop_ap,
 	.add_station = WILC_WFI_add_station,
 	.del_station = WILC_WFI_del_station,
-- 
2.5.1

