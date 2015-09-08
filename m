Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36072 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbIHP4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:47 -0400
Received: by padhk3 with SMTP id hk3so42529615pad.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:46 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/30] staging: wilc1000: rename WILC_WFI_add_station
Date: Wed,  9 Sep 2015 00:55:51 +0900
Message-Id: <1441727767-26026-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180158_917205_0E39D48F)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_add_station with wilc_cfg80211_add_station
to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c190d8b..ccfd4c6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3332,7 +3332,7 @@ static int  wilc_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 }
 
 /**
- *  @brief      WILC_WFI_add_station
+ *  @brief      wilc_cfg80211_add_station
  *  @details    Add a new station.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3340,7 +3340,7 @@ static int  wilc_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
+static int  wilc_cfg80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 				 const u8 *mac, struct station_parameters *params)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -3619,7 +3619,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.start_ap = wilc_cfg80211_start_ap,
 	.change_beacon = wilc_cfg80211_change_beacon,
 	.stop_ap = wilc_cfg80211_stop_ap,
-	.add_station = WILC_WFI_add_station,
+	.add_station = wilc_cfg80211_add_station,
 	.del_station = WILC_WFI_del_station,
 	.change_station = WILC_WFI_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
-- 
2.5.1

