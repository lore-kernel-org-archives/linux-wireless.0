Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34650 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbIJTPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:53 -0400
Received: by padhy16 with SMTP id hy16so50968825pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:53 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 24/31] staging: wilc1000: rename WILC_WFI_flush_pmksa
Date: Fri, 11 Sep 2015 04:14:23 +0900
Message-Id: <1441912470-3371-24-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211558_460752_B4AF41F9)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_flush_pmksa with wilc_flush_pmksa to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 96c94e59..c7cc1a2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1981,7 +1981,7 @@ static int wilc_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_flush_pmksa
+ *  @brief      wilc_flush_pmksa
  *  @details    Flush all cached PMKIDs.
  *  @param[in]
  *  @return     int : Return 0 on Success
@@ -1989,7 +1989,7 @@ static int wilc_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
+static int  wilc_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 {
 	struct WILC_WFI_priv *priv = wiphy_priv(wiphy);
 
@@ -3585,7 +3585,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
 	.set_pmksa = wilc_set_pmksa,
 	.del_pmksa = wilc_del_pmksa,
-	.flush_pmksa = WILC_WFI_flush_pmksa,
+	.flush_pmksa = wilc_flush_pmksa,
 #ifdef WILC_P2P
 	.remain_on_channel = WILC_WFI_remain_on_channel,
 	.cancel_remain_on_channel = WILC_WFI_cancel_remain_on_channel,
-- 
2.5.1

