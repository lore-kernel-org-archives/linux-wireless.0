Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33877 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbIHP4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:39 -0400
Received: by padhy16 with SMTP id hy16so125293788pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:39 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/30] staging: wilc1000: rename WILC_WFI_start_ap
Date: Wed,  9 Sep 2015 00:55:48 +0900
Message-Id: <1441727767-26026-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180159_043484_67A189F6)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_start_ap with wilc_cfg80211_start_ap to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 97a7a4b..b5d512e0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3205,7 +3205,7 @@ static int wilc_cfg80211_change_virtual_intf(struct wiphy *wiphy, struct net_dev
  */
 
 /**
- *  @brief      WILC_WFI_start_ap
+ *  @brief      wilc_cfg80211_start_ap
  *  @details    Add a beacon with given parameters, @head, @interval
  *                      and @dtim_period will be valid, @tail is optional.
  *  @param[in]   wiphy
@@ -3216,7 +3216,7 @@ static int wilc_cfg80211_change_virtual_intf(struct wiphy *wiphy, struct net_dev
  *  @date	23 JUL 2013
  *  @version	1.0
  */
-static int WILC_WFI_start_ap(struct wiphy *wiphy, struct net_device *dev,
+static int wilc_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_ap_settings *settings)
 {
 	struct cfg80211_beacon_data *beacon = &(settings->beacon);
@@ -3616,7 +3616,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.del_virtual_intf = wilc_cfg80211_del_virtual_intf,
 	.change_virtual_intf = wilc_cfg80211_change_virtual_intf,
 
-	.start_ap = WILC_WFI_start_ap,
+	.start_ap = wilc_cfg80211_start_ap,
 	.change_beacon = WILC_WFI_change_beacon,
 	.stop_ap = WILC_WFI_stop_ap,
 	.add_station = WILC_WFI_add_station,
-- 
2.5.1

