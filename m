Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35771 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbbINDZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:16 -0400
Received: by pacfv12 with SMTP id fv12so132595129pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:15 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 13/31] staging: wilc1000: rename WILC_WFI_change_beacon
Date: Mon, 14 Sep 2015 12:24:13 +0900
Message-Id: <1442201071-16155-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054653_210129_109F70E8)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_beacon with change_beacon to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3853113..936db60 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3247,7 +3247,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_change_beacon
+ *  @brief      change_beacon
  *  @details    Add a beacon with given parameters, @head, @interval
  *                      and @dtim_period will be valid, @tail is optional.
  *  @param[in]   wiphy
@@ -3258,8 +3258,8 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
  *  @date	23 JUL 2013
  *  @version	1.0
  */
-static int  WILC_WFI_change_beacon(struct wiphy *wiphy, struct net_device *dev,
-				   struct cfg80211_beacon_data *beacon)
+static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
+			 struct cfg80211_beacon_data *beacon)
 {
 	struct WILC_WFI_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
@@ -3572,7 +3572,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_virtual_intf = change_virtual_intf,
 
 	.start_ap = start_ap,
-	.change_beacon = WILC_WFI_change_beacon,
+	.change_beacon = change_beacon,
 	.stop_ap = WILC_WFI_stop_ap,
 	.add_station = WILC_WFI_add_station,
 	.del_station = WILC_WFI_del_station,
-- 
2.5.1

