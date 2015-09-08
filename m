Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34101 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbbIHP4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:54 -0400
Received: by padhy16 with SMTP id hy16so125299427pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:54 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/30] staging: wilc1000: rename WILC_WFI_get_station
Date: Wed,  9 Sep 2015 00:55:54 +0900
Message-Id: <1441727767-26026-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180151_919540_1D1FFAEF)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_get_station with wilc_cfg80211_get_station
to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4a46aea..1db8b8d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1619,7 +1619,7 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
 
 
 /**
- *  @brief      WILC_WFI_get_station
+ *  @brief      wilc_cfg80211_get_station
  *  @details    Get station information for the station identified by @mac
  *  @param[in]   NONE
  *  @return     int : Return 0 on Success.
@@ -1628,7 +1628,7 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
  *  @version	1.0
  */
 
-static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
+static int wilc_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *mac, struct station_info *sinfo)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -3624,7 +3624,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_station = wilc_cfg80211_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	#ifndef WILC_FULLY_HOSTING_AP
-	.get_station = WILC_WFI_get_station,
+	.get_station = wilc_cfg80211_get_station,
 	#endif
 	.dump_station = WILC_WFI_dump_station,
 	.change_bss = WILC_WFI_change_bss,
-- 
2.5.1

