Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35674 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbbINDZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:10 -0400
Received: by pacfv12 with SMTP id fv12so132592786pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 11/31] staging: wilc1000: rename WILC_WFI_change_virt_intf
Date: Mon, 14 Sep 2015 12:24:11 +0900
Message-Id: <1442201071-16155-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054652_122264_412A9FF6)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_virt_intf with change_virtual_intf
to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e85f91f..4197d74 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2827,7 +2827,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 }
 #ifdef WILC_AP_EXTERNAL_MLME
 /**
- *  @brief      WILC_WFI_change_virt_intf
+ *  @brief      change_virtual_intf
  *  @details    Change type/configuration of virtual interface,
  *                      keep the struct wireless_dev's iftype updated.
  *  @param[in]   NONE
@@ -2839,8 +2839,8 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 void wilc1000_wlan_deinit(linux_wlan_t *nic);
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 
-static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev,
-				     enum nl80211_iftype type, u32 *flags, struct vif_params *params)
+static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
+			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3569,7 +3569,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = add_virtual_intf,
 	.del_virtual_intf = del_virtual_intf,
-	.change_virtual_intf = WILC_WFI_change_virt_intf,
+	.change_virtual_intf = change_virtual_intf,
 
 	.start_ap = WILC_WFI_start_ap,
 	.change_beacon = WILC_WFI_change_beacon,
-- 
2.5.1

