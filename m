Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35285 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbbINDZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:50 -0400
Received: by pacfv12 with SMTP id fv12so132608073pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 24/31] staging: wilc1000: rename WILC_WFI_flush_pmksa
Date: Mon, 14 Sep 2015 12:24:24 +0900
Message-Id: <1442201071-16155-24-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054653_075713_9405AE5E)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_flush_pmksa with flush_pmksa to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 93d0c2a..c425037 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1981,7 +1981,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_flush_pmksa
+ *  @brief      flush_pmksa
  *  @details    Flush all cached PMKIDs.
  *  @param[in]
  *  @return     int : Return 0 on Success
@@ -1989,7 +1989,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
+static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 {
 	struct WILC_WFI_priv *priv = wiphy_priv(wiphy);
 
@@ -3585,7 +3585,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
 	.set_pmksa = set_pmksa,
 	.del_pmksa = del_pmksa,
-	.flush_pmksa = WILC_WFI_flush_pmksa,
+	.flush_pmksa = flush_pmksa,
 #ifdef WILC_P2P
 	.remain_on_channel = WILC_WFI_remain_on_channel,
 	.cancel_remain_on_channel = WILC_WFI_cancel_remain_on_channel,
-- 
2.5.1

