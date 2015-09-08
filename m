Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36857 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbIHP4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:32 -0400
Received: by padhk3 with SMTP id hk3so42523778pad.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:31 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/30] staging: wilc1000: rename WILC_WFI_add_virt_intf
Date: Wed,  9 Sep 2015 00:55:45 +0900
Message-Id: <1441727767-26026-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175634_538476_D0E735A3)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_add_virt_intf with
wilc_cfg80211_add_virtual_intf to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0ac9acb..9c22c19 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3543,7 +3543,7 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_add_virt_intf
+ *  @brief      wilc_cfg80211_add_virtual_intf
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -3551,7 +3551,7 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-struct wireless_dev *WILC_WFI_add_virt_intf(struct wiphy *wiphy, const char *name,
+struct wireless_dev *wilc_cfg80211_add_virtual_intf(struct wiphy *wiphy, const char *name,
 						unsigned char name_assign_type,
 						enum nl80211_iftype type, u32 *flags,
 						struct vif_params *params)
@@ -3612,7 +3612,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.get_key = wilc_cfg80211_get_key,
 	.set_default_key = wilc_cfg80211_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
-	.add_virtual_intf = WILC_WFI_add_virt_intf,
+	.add_virtual_intf = wilc_cfg80211_add_virtual_intf,
 	.del_virtual_intf = WILC_WFI_del_virt_intf,
 	.change_virtual_intf = WILC_WFI_change_virt_intf,
 
-- 
2.5.1

