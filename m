Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35805 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbIHP4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:52 -0400
Received: by pacfv12 with SMTP id fv12so130446548pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:52 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/30] staging: wilc1000: rename WILC_WFI_change_station
Date: Wed,  9 Sep 2015 00:55:53 +0900
Message-Id: <1441727767-26026-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180159_421619_5B65E141)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_station with
wilc_cfg80211_change_station to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 02ab135..4a46aea 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3464,7 +3464,7 @@ static int wilc_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev
 }
 
 /**
- *  @brief      WILC_WFI_change_station
+ *  @brief      wilc_cfg80211_change_station
  *  @details    Modify a given station.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3472,7 +3472,7 @@ static int wilc_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
+static int wilc_cfg80211_change_station(struct wiphy *wiphy, struct net_device *dev,
 				   const u8 *mac, struct station_parameters *params)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -3621,7 +3621,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.stop_ap = wilc_cfg80211_stop_ap,
 	.add_station = wilc_cfg80211_add_station,
 	.del_station = wilc_cfg80211_del_station,
-	.change_station = WILC_WFI_change_station,
+	.change_station = wilc_cfg80211_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	#ifndef WILC_FULLY_HOSTING_AP
 	.get_station = WILC_WFI_get_station,
-- 
2.5.1

