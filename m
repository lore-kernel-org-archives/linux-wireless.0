Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36288 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbINDZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:38 -0400
Received: by padhk3 with SMTP id hk3so129797543pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 20/31] staging: wilc1000: rename WILC_WFI_change_bss
Date: Mon, 14 Sep 2015 12:24:20 +0900
Message-Id: <1442201071-16155-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054654_168622_D2C26DC8)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_bss with change_bss to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e932e64..e1514db 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1710,7 +1710,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_change_bss
+ *  @brief      change_bss
  *  @details    Modify parameters for a given BSS.
  *  @param[in]
  *   -use_cts_prot: Whether to use CTS protection
@@ -1730,8 +1730,8 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_change_bss(struct wiphy *wiphy, struct net_device *dev,
-				struct bss_parameters *params)
+static int change_bss(struct wiphy *wiphy, struct net_device *dev,
+		      struct bss_parameters *params)
 {
 	PRINT_D(CFG80211_DBG, "Changing Bss parametrs\n");
 	return 0;
@@ -3580,7 +3580,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = get_station,
 	.dump_station = dump_station,
-	.change_bss = WILC_WFI_change_bss,
+	.change_bss = change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
 
 	.set_pmksa = WILC_WFI_set_pmksa,
-- 
2.5.1

