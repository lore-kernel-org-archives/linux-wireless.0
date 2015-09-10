Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35402 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbIJTPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:50 -0400
Received: by pacfv12 with SMTP id fv12so51869471pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 23/31] staging: wilc1000: rename WILC_WFI_del_pmksa
Date: Fri, 11 Sep 2015 04:14:22 +0900
Message-Id: <1441912470-3371-23-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211555_477099_69FA7619)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_pmksa with wilc_del_pmksa to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3bac541..96c94e59 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1932,7 +1932,7 @@ static int wilc_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_del_pmksa
+ *  @brief      wilc_del_pmksa
  *  @details    Delete a cached PMKID.
  *  @param[in]
  *  @return     int : Return 0 on Success
@@ -1940,8 +1940,8 @@ static int wilc_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
-			      struct cfg80211_pmksa *pmksa)
+static int wilc_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+			  struct cfg80211_pmksa *pmksa)
 {
 
 	u32 i;
@@ -3584,7 +3584,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.set_wiphy_params = wilc_set_wiphy_params,
 
 	.set_pmksa = wilc_set_pmksa,
-	.del_pmksa = WILC_WFI_del_pmksa,
+	.del_pmksa = wilc_del_pmksa,
 	.flush_pmksa = WILC_WFI_flush_pmksa,
 #ifdef WILC_P2P
 	.remain_on_channel = WILC_WFI_remain_on_channel,
-- 
2.5.1

