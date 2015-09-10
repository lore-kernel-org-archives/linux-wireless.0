Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35977 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIJTPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:10 -0400
Received: by padhk3 with SMTP id hk3so50746506pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 10/31] staging: wilc1000: rename WILC_WFI_del_virt_intf
Date: Fri, 11 Sep 2015 04:14:09 +0900
Message-Id: <1441912470-3371-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211514_642604_1ED663DD)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_virt_intf with wilc_del_virt_intf to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 01d6e4d..f014811 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3539,7 +3539,7 @@ struct wireless_dev *wilc_add_virt_intf(struct wiphy *wiphy, const char *name,
 }
 
 /**
- *  @brief      WILC_WFI_del_virt_intf
+ *  @brief      wilc_del_virt_intf
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3547,7 +3547,7 @@ struct wireless_dev *wilc_add_virt_intf(struct wiphy *wiphy, const char *name,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-int WILC_WFI_del_virt_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* tony for v3.8 support */
+int wilc_del_virt_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* tony for v3.8 support */
 {
 	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
 	return WILC_SUCCESS;
@@ -3568,7 +3568,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.set_default_key = wilc_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = wilc_add_virt_intf,
-	.del_virtual_intf = WILC_WFI_del_virt_intf,
+	.del_virtual_intf = wilc_del_virt_intf,
 	.change_virtual_intf = WILC_WFI_change_virt_intf,
 
 	.start_ap = WILC_WFI_start_ap,
-- 
2.5.1

