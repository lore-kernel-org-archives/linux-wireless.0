Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35033 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbbIHP5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:07 -0400
Received: by pacfv12 with SMTP id fv12so130452683pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:07 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 22/30] staging: wilc1000: rename WILC_WFI_del_pmksa
Date: Wed,  9 Sep 2015 00:55:59 +0900
Message-Id: <1441727767-26026-22-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180158_566164_4729B97C)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_pmksa with wilc_cfg80211_del_pmksa to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7b2f200..bdcd649 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1932,7 +1932,7 @@ static int wilc_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *netde
 }
 
 /**
- *  @brief      WILC_WFI_del_pmksa
+ *  @brief      wilc_cfg80211_del_pmksa
  *  @details    Delete a cached PMKID.
  *  @param[in]
  *  @return     int : Return 0 on Success
@@ -1940,7 +1940,7 @@ static int wilc_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *netde
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+static int wilc_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 			      struct cfg80211_pmksa *pmksa)
 {
 
@@ -3631,7 +3631,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.set_wiphy_params = wilc_cfg80211_set_wiphy_params,
 
 	.set_pmksa = wilc_cfg80211_set_pmksa,
-	.del_pmksa = WILC_WFI_del_pmksa,
+	.del_pmksa = wilc_cfg80211_del_pmksa,
 	.flush_pmksa = WILC_WFI_flush_pmksa,
 #ifdef WILC_P2P
 	.remain_on_channel = WILC_WFI_remain_on_channel,
-- 
2.5.1

