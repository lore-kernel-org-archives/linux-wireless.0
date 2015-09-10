Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35841 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIJTPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:01 -0400
Received: by padhk3 with SMTP id hk3so50742983pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:01 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 07/31] staging: wilc1000: rename WILC_WFI_get_key
Date: Fri, 11 Sep 2015 04:14:06 +0900
Message-Id: <1441912470-3371-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211505_025815_E332A6B8)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_get_key with wilc_get_key to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ba5d790..8f90e48 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1511,7 +1511,7 @@ static int wilc_del_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_get_key
+ *  @brief      wilc_get_key
  *  @details    Get information about the key with the given parameters.
  *                      @mac_addr will be %NULL when requesting information for a group
  *                      key. All pointers given to the @callback function need not be valid
@@ -1523,9 +1523,9 @@ static int wilc_del_key(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-			    bool pairwise,
-			    const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
+static int wilc_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+			bool pairwise,
+			const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -3564,7 +3564,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.disconnect = wilc_disconnect,
 	.add_key = wilc_add_key,
 	.del_key = wilc_del_key,
-	.get_key = WILC_WFI_get_key,
+	.get_key = wilc_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = WILC_WFI_add_virt_intf,
-- 
2.5.1

