Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34906 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbbIHP5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:00 -0400
Received: by pacfv12 with SMTP id fv12so130449570pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:59 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 19/30] staging: wilc1000: rename WILC_WFI_change_bss
Date: Wed,  9 Sep 2015 00:55:56 +0900
Message-Id: <1441727767-26026-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180159_169701_7A6498F8)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_bss with wilc_cfg80211_change_bss to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d448df5..c74f95c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1710,7 +1710,7 @@ static int wilc_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev
 
 
 /**
- *  @brief      WILC_WFI_change_bss
+ *  @brief      wilc_cfg80211_change_bss
  *  @details    Modify parameters for a given BSS.
  *  @param[in]
  *   -use_cts_prot: Whether to use CTS protection
@@ -1730,7 +1730,7 @@ static int wilc_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_change_bss(struct wiphy *wiphy, struct net_device *dev,
+static int  wilc_cfg80211_change_bss(struct wiphy *wiphy, struct net_device *dev,
 				struct bss_parameters *params)
 {
 	PRINT_D(CFG80211_DBG, "Changing Bss parametrs\n");
@@ -3627,7 +3627,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.get_station = wilc_cfg80211_get_station,
 	#endif
 	.dump_station = wilc_cfg80211_dump_station,
-	.change_bss = WILC_WFI_change_bss,
+	.change_bss = wilc_cfg80211_change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
 
 	.set_pmksa = WILC_WFI_set_pmksa,
-- 
2.5.1

