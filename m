Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36097 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbINDZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:25 -0400
Received: by padhk3 with SMTP id hk3so129792839pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:25 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 16/31] staging: wilc1000: rename WILC_WFI_del_station
Date: Mon, 14 Sep 2015 12:24:16 +0900
Message-Id: <1442201071-16155-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054652_939922_5642FD77)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_station with del_station to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 72bcdc9..5bdd111 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3384,7 +3384,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_del_station
+ *  @brief      del_station
  *  @details    Remove a station; @mac may be NULL to remove all stations.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3392,8 +3392,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_station(struct wiphy *wiphy, struct net_device *dev,
-				struct station_del_parameters *params)
+static int del_station(struct wiphy *wiphy, struct net_device *dev,
+		       struct station_del_parameters *params)
 {
 	const u8 *mac = params->mac;
 	s32 s32Error = WILC_SUCCESS;
@@ -3575,7 +3575,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_beacon = change_beacon,
 	.stop_ap = stop_ap,
 	.add_station = add_station,
-	.del_station = WILC_WFI_del_station,
+	.del_station = del_station,
 	.change_station = WILC_WFI_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = WILC_WFI_get_station,
-- 
2.5.1

