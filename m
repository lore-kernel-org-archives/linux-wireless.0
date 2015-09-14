Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35031 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbINDZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:34 -0400
Received: by pacfv12 with SMTP id fv12so132601975pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 19/31] staging: wilc1000: rename WILC_WFI_dump_station
Date: Mon, 14 Sep 2015 12:24:19 +0900
Message-Id: <1442201071-16155-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054654_050363_820430F7)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_dump_station with dump_station to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c15bd7c..e932e64 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2760,7 +2760,7 @@ static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
 
 }
 /**
- *  @brief      WILC_WFI_dump_station
+ *  @brief      dump_station
  *  @details    Configure connection quality monitor RSSI threshold.
  *  @param[in]   struct wiphy *wiphy:
  *  @param[in]	struct net_device *dev
@@ -2772,8 +2772,8 @@ static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_dump_station(struct wiphy *wiphy, struct net_device *dev,
-				 int idx, u8 *mac, struct station_info *sinfo)
+static int dump_station(struct wiphy *wiphy, struct net_device *dev,
+			int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct WILC_WFI_priv *priv;
 
@@ -3579,7 +3579,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_station = change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = get_station,
-	.dump_station = WILC_WFI_dump_station,
+	.dump_station = dump_station,
 	.change_bss = WILC_WFI_change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
 
-- 
2.5.1

