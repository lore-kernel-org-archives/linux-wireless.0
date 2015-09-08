Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33100 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbbIHP5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:03 -0400
Received: by pacex6 with SMTP id ex6so127499096pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:02 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 20/30] staging: wilc1000: rename WILC_WFI_set_wiphy_params
Date: Wed,  9 Sep 2015 00:55:57 +0900
Message-Id: <1441727767-26026-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180159_538583_86EAD519)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_wiphy_params with
wilc_cfg80211_set_wiphy_params to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c74f95c..25b4531 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1802,7 +1802,7 @@ static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_set_wiphy_params
+ *  @brief      wilc_cfg80211_set_wiphy_params
  *  @details    Notify that wiphy parameters have changed;
  *  @param[in]   Changed bitfield (see &enum wiphy_params_flags) describes which values
  *                      have changed.
@@ -1811,7 +1811,7 @@ static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+static int wilc_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrCfgParamVal pstrCfgParamVal;
@@ -3628,7 +3628,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	#endif
 	.dump_station = wilc_cfg80211_dump_station,
 	.change_bss = wilc_cfg80211_change_bss,
-	.set_wiphy_params = WILC_WFI_set_wiphy_params,
+	.set_wiphy_params = wilc_cfg80211_set_wiphy_params,
 
 	.set_pmksa = WILC_WFI_set_pmksa,
 	.del_pmksa = WILC_WFI_del_pmksa,
-- 
2.5.1

