Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35475 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbINDY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:24:57 -0400
Received: by pacfv12 with SMTP id fv12so132587952pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:24:57 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 07/31] staging: wilc1000: rename WILC_WFI_get_key
Date: Mon, 14 Sep 2015 12:24:07 +0900
Message-Id: <1442201071-16155-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052500_233092_A8A3F887)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_get_key with get_key to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index dfa9db3..5794db3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1511,7 +1511,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_get_key
+ *  @brief      get_key
  *  @details    Get information about the key with the given parameters.
  *                      @mac_addr will be %NULL when requesting information for a group
  *                      key. All pointers given to the @callback function need not be valid
@@ -1523,9 +1523,9 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-			    bool pairwise,
-			    const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
+static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+		   bool pairwise,
+		   const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -3564,7 +3564,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.disconnect = disconnect,
 	.add_key = add_key,
 	.del_key = del_key,
-	.get_key = WILC_WFI_get_key,
+	.get_key = get_key,
 	.set_default_key = WILC_WFI_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = WILC_WFI_add_virt_intf,
-- 
2.5.1

