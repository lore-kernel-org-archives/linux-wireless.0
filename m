Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35624 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbbINDZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:06 -0400
Received: by pacfv12 with SMTP id fv12so132591603pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:06 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 10/31] staging: wilc1000: rename WILC_WFI_del_virt_intf
Date: Mon, 14 Sep 2015 12:24:10 +0900
Message-Id: <1442201071-16155-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052512_649851_DEEDB758)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_virt_intf with del_virtual_intf to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5ff81cf..e85f91f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3539,7 +3539,7 @@ struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
 }
 
 /**
- *  @brief      WILC_WFI_del_virt_intf
+ *  @brief      del_virtual_intf
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3547,7 +3547,7 @@ struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-int WILC_WFI_del_virt_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* tony for v3.8 support */
+int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* tony for v3.8 support */
 {
 	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
 	return WILC_SUCCESS;
@@ -3568,7 +3568,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.set_default_key = set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = add_virtual_intf,
-	.del_virtual_intf = WILC_WFI_del_virt_intf,
+	.del_virtual_intf = del_virtual_intf,
 	.change_virtual_intf = WILC_WFI_change_virt_intf,
 
 	.start_ap = WILC_WFI_start_ap,
-- 
2.5.1

