Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34033 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIJTPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:07 -0400
Received: by padhy16 with SMTP id hy16so50953437pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:07 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 09/31] staging: wilc1000: rename WILC_WFI_add_virt_intf
Date: Fri, 11 Sep 2015 04:14:08 +0900
Message-Id: <1441912470-3371-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211512_129887_80933964)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_add_virt_intf with wilc_add_virt_intf to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ca7a36f..01d6e4d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3498,7 +3498,7 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_add_virt_intf
+ *  @brief      wilc_add_virt_intf
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3506,10 +3506,10 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-struct wireless_dev *WILC_WFI_add_virt_intf(struct wiphy *wiphy, const char *name,
-						unsigned char name_assign_type,
-						enum nl80211_iftype type, u32 *flags,
-						struct vif_params *params)
+struct wireless_dev *wilc_add_virt_intf(struct wiphy *wiphy, const char *name,
+					unsigned char name_assign_type,
+					enum nl80211_iftype type, u32 *flags,
+					struct vif_params *params)
 {
 	perInterface_wlan_t *nic;
 	struct WILC_WFI_priv *priv;
@@ -3567,7 +3567,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.get_key = wilc_get_key,
 	.set_default_key = wilc_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
-	.add_virtual_intf = WILC_WFI_add_virt_intf,
+	.add_virtual_intf = wilc_add_virt_intf,
 	.del_virtual_intf = WILC_WFI_del_virt_intf,
 	.change_virtual_intf = WILC_WFI_change_virt_intf,
 
-- 
2.5.1

