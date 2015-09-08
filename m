Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35453 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbIHP43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:29 -0400
Received: by pacfv12 with SMTP id fv12so130437953pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:29 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/30] staging: wilc1000: rename WILC_WFI_set_default_key
Date: Wed,  9 Sep 2015 00:55:44 +0900
Message-Id: <1441727767-26026-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175632_258306_EB4B74D5)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_default_key with
wilc_cfg80211_set_default_key to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 67a6cfb..0ac9acb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1566,7 +1566,7 @@ static int wilc_cfg80211_get_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_set_default_key
+ *  @brief      wilc_cfg80211_set_default_key
  *  @details    Set the default management frame key on an interface
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -1574,7 +1574,7 @@ static int wilc_cfg80211_get_key(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+static int wilc_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				    bool unicast, bool multicast)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -3610,7 +3610,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.add_key = wilc_cfg80211_add_key,
 	.del_key = wilc_cfg80211_del_key,
 	.get_key = wilc_cfg80211_get_key,
-	.set_default_key = WILC_WFI_set_default_key,
+	.set_default_key = wilc_cfg80211_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = WILC_WFI_add_virt_intf,
 	.del_virtual_intf = WILC_WFI_del_virt_intf,
-- 
2.5.1

