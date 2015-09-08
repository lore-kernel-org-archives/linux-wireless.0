Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34140 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbbIHP45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:57 -0400
Received: by padhy16 with SMTP id hy16so125300411pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:57 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/30] staging: wilc1000: rename WILC_WFI_dump_station
Date: Wed,  9 Sep 2015 00:55:55 +0900
Message-Id: <1441727767-26026-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180151_560454_FD3E5648)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_dump_station with
wilc_cfg80211_dump_station to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1db8b8d..d448df5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2759,7 +2759,7 @@ static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
 
 }
 /**
- *  @brief      WILC_WFI_dump_station
+ *  @brief      wilc_cfg80211_dump_station
  *  @details    Configure connection quality monitor RSSI threshold.
  *  @param[in]   struct wiphy *wiphy:
  *  @param[in]	struct net_device *dev
@@ -2771,7 +2771,7 @@ static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_dump_station(struct wiphy *wiphy, struct net_device *dev,
+static int wilc_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct WILC_WFI_priv *priv;
@@ -3626,7 +3626,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	#ifndef WILC_FULLY_HOSTING_AP
 	.get_station = wilc_cfg80211_get_station,
 	#endif
-	.dump_station = WILC_WFI_dump_station,
+	.dump_station = wilc_cfg80211_dump_station,
 	.change_bss = WILC_WFI_change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
 
-- 
2.5.1

