Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35647 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbIHP4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:42 -0400
Received: by pacfv12 with SMTP id fv12so130442693pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:41 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/30] staging: wilc1000: rename WILC_WFI_change_beacon
Date: Wed,  9 Sep 2015 00:55:49 +0900
Message-Id: <1441727767-26026-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180158_162025_363D0F82)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_beacon with
wilc_cfg80211_change_beacon to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b5d512e0..8773f16 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3254,7 +3254,7 @@ static int wilc_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_change_beacon
+ *  @brief      wilc_cfg80211_change_beacon
  *  @details    Add a beacon with given parameters, @head, @interval
  *                      and @dtim_period will be valid, @tail is optional.
  *  @param[in]   wiphy
@@ -3265,7 +3265,7 @@ static int wilc_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
  *  @date	23 JUL 2013
  *  @version	1.0
  */
-static int  WILC_WFI_change_beacon(struct wiphy *wiphy, struct net_device *dev,
+static int  wilc_cfg80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_beacon_data *beacon)
 {
 	struct WILC_WFI_priv *priv;
@@ -3617,7 +3617,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_virtual_intf = wilc_cfg80211_change_virtual_intf,
 
 	.start_ap = wilc_cfg80211_start_ap,
-	.change_beacon = WILC_WFI_change_beacon,
+	.change_beacon = wilc_cfg80211_change_beacon,
 	.stop_ap = WILC_WFI_stop_ap,
 	.add_station = WILC_WFI_add_station,
 	.del_station = WILC_WFI_del_station,
-- 
2.5.1

