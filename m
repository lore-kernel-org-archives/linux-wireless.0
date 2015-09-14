Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:32838 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbbINDZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:04 -0400
Received: by pacex6 with SMTP id ex6so130284312pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:03 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 09/31] staging: wilc1000: rename WILC_WFI_add_virt_intf
Date: Mon, 14 Sep 2015 12:24:09 +0900
Message-Id: <1442201071-16155-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052508_428515_C1592989)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_add_virt_intf with add_virtual_intf to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f0065cb..5ff81cf 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3498,7 +3498,7 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_add_virt_intf
+ *  @brief      add_virtual_intf
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
+struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
+				      unsigned char name_assign_type,
+				      enum nl80211_iftype type, u32 *flags,
+				      struct vif_params *params)
 {
 	perInterface_wlan_t *nic;
 	struct WILC_WFI_priv *priv;
@@ -3567,7 +3567,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.get_key = get_key,
 	.set_default_key = set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
-	.add_virtual_intf = WILC_WFI_add_virt_intf,
+	.add_virtual_intf = add_virtual_intf,
 	.del_virtual_intf = WILC_WFI_del_virt_intf,
 	.change_virtual_intf = WILC_WFI_change_virt_intf,
 
-- 
2.5.1

