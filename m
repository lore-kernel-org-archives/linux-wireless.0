Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34533 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbIJTPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:44 -0400
Received: by padhy16 with SMTP id hy16so50965911pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:44 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 21/31] staging: wilc1000: rename WILC_WFI_set_wiphy_params
Date: Fri, 11 Sep 2015 04:14:20 +0900
Message-Id: <1441912470-3371-21-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211600_218801_2240B6DE)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_wiphy_params with wilc_set_wiphy_params
to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8a71027..fb98534 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1802,7 +1802,7 @@ static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_set_wiphy_params
+ *  @brief      wilc_set_wiphy_params
  *  @details    Notify that wiphy parameters have changed;
  *  @param[in]   Changed bitfield (see &enum wiphy_params_flags) describes which values
  *                      have changed.
@@ -1811,7 +1811,7 @@ static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+static int wilc_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrCfgParamVal pstrCfgParamVal;
@@ -3581,7 +3581,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.get_station = wilc_get_station,
 	.dump_station = wilc_dump_station,
 	.change_bss = wilc_change_bss,
-	.set_wiphy_params = WILC_WFI_set_wiphy_params,
+	.set_wiphy_params = wilc_set_wiphy_params,
 
 	.set_pmksa = WILC_WFI_set_pmksa,
 	.del_pmksa = WILC_WFI_del_pmksa,
-- 
2.5.1

