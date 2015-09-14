Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36439 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbbINDZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:47 -0400
Received: by padhk3 with SMTP id hk3so129801179pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:47 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 23/31] staging: wilc1000: rename WILC_WFI_del_pmksa
Date: Mon, 14 Sep 2015 12:24:23 +0900
Message-Id: <1442201071-16155-23-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054654_558025_6D15E30C)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_pmksa with del_pmksa to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 774897f..93d0c2a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1932,7 +1932,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_del_pmksa
+ *  @brief      del_pmksa
  *  @details    Delete a cached PMKID.
  *  @param[in]
  *  @return     int : Return 0 on Success
@@ -1940,8 +1940,8 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
-			      struct cfg80211_pmksa *pmksa)
+static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_pmksa *pmksa)
 {
 
 	u32 i;
@@ -3584,7 +3584,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.set_wiphy_params = set_wiphy_params,
 
 	.set_pmksa = set_pmksa,
-	.del_pmksa = WILC_WFI_del_pmksa,
+	.del_pmksa = del_pmksa,
 	.flush_pmksa = WILC_WFI_flush_pmksa,
 #ifdef WILC_P2P
 	.remain_on_channel = WILC_WFI_remain_on_channel,
-- 
2.5.1

