Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:32899 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbIHP4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:49 -0400
Received: by pacex6 with SMTP id ex6so127494071pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:49 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/30] staging: wilc1000: rename WILC_WFI_del_station
Date: Wed,  9 Sep 2015 00:55:52 +0900
Message-Id: <1441727767-26026-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180159_647786_F18DB01C)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_station with wilc_cfg80211_del_station
to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ccfd4c6..02ab135 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3417,7 +3417,7 @@ static int  wilc_cfg80211_add_station(struct wiphy *wiphy, struct net_device *de
 }
 
 /**
- *  @brief      WILC_WFI_del_station
+ *  @brief      wilc_cfg80211_del_station
  *  @details    Remove a station; @mac may be NULL to remove all stations.
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3425,7 +3425,7 @@ static int  wilc_cfg80211_add_station(struct wiphy *wiphy, struct net_device *de
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_station(struct wiphy *wiphy, struct net_device *dev,
+static int wilc_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 				struct station_del_parameters *params)
 {
 	const u8 *mac = params->mac;
@@ -3620,7 +3620,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_beacon = wilc_cfg80211_change_beacon,
 	.stop_ap = wilc_cfg80211_stop_ap,
 	.add_station = wilc_cfg80211_add_station,
-	.del_station = WILC_WFI_del_station,
+	.del_station = wilc_cfg80211_del_station,
 	.change_station = WILC_WFI_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	#ifndef WILC_FULLY_HOSTING_AP
-- 
2.5.1

