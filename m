Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33724 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbIHP4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:37 -0400
Received: by pacex6 with SMTP id ex6so127489193pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/30] staging: wilc1000: rename WILC_WFI_change_virt_intf
Date: Wed,  9 Sep 2015 00:55:47 +0900
Message-Id: <1441727767-26026-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175639_552638_7BE7E6C8)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_change_virt_intf with
wilc_cfg80211_change_virtual_intf to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cffe4b4..97a7a4b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2826,7 +2826,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 }
 #ifdef WILC_AP_EXTERNAL_MLME
 /**
- *  @brief      WILC_WFI_change_virt_intf
+ *  @brief      wilc_cfg80211_change_virtual_intf
  *  @details    Change type/configuration of virtual interface,
  *                      keep the struct wireless_dev's iftype updated.
  *  @param[in]   NONE
@@ -2838,7 +2838,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 void wilc1000_wlan_deinit(linux_wlan_t *nic);
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 
-static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev,
+static int wilc_cfg80211_change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				     enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -3614,7 +3614,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = wilc_cfg80211_add_virtual_intf,
 	.del_virtual_intf = wilc_cfg80211_del_virtual_intf,
-	.change_virtual_intf = WILC_WFI_change_virt_intf,
+	.change_virtual_intf = wilc_cfg80211_change_virtual_intf,
 
 	.start_ap = WILC_WFI_start_ap,
 	.change_beacon = WILC_WFI_change_beacon,
-- 
2.5.1

