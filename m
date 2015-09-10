Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35275 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbIJTPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:41 -0400
Received: by pacfv12 with SMTP id fv12so51866263pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:41 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 20/31] staging: wilc1000: rename WILC_WFI_change_bss
Date: Fri, 11 Sep 2015 04:14:19 +0900
Message-Id: <1441912470-3371-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211551_828314_804EEA5D)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_bss with wilc_change_bss to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 06276de..8a71027 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1710,7 +1710,7 @@ static int wilc_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_change_bss
+ *  @brief      wilc_change_bss
  *  @details    Modify parameters for a given BSS.
  *  @param[in]
  *   -use_cts_prot: Whether to use CTS protection
@@ -1730,8 +1730,8 @@ static int wilc_get_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_change_bss(struct wiphy *wiphy, struct net_device *dev,
-				struct bss_parameters *params)
+static int  wilc_change_bss(struct wiphy *wiphy, struct net_device *dev,
+			    struct bss_parameters *params)
 {
 	PRINT_D(CFG80211_DBG, "Changing Bss parametrs\n");
 	return 0;
@@ -3580,7 +3580,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = wilc_get_station,
 	.dump_station = wilc_dump_station,
-	.change_bss = WILC_WFI_change_bss,
+	.change_bss = wilc_change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
 
 	.set_pmksa = WILC_WFI_set_pmksa,
-- 
2.5.1

