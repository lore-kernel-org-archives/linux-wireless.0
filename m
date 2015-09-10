Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33361 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIJTO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:14:57 -0400
Received: by pacex6 with SMTP id ex6so51103216pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:14:57 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 06/31] staging: wilc1000: rename WILC_WFI_del_key
Date: Fri, 11 Sep 2015 04:14:05 +0900
Message-Id: <1441912470-3371-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211500_548666_DEE139DD)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_key with wilc_del_key to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index db327f7..ba5d790 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1403,7 +1403,7 @@ static int wilc_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_i
 }
 
 /**
- *  @brief      WILC_WFI_del_key
+ *  @brief      wilc_del_key
  *  @details    Remove a key given the @mac_addr (%NULL for a group key)
  *                      and @key_index, return -ENOENT if the key doesn't exist.
  *  @param[in]
@@ -1412,10 +1412,10 @@ static int wilc_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_i
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
-			    u8 key_index,
-			    bool pairwise,
-			    const u8 *mac_addr)
+static int wilc_del_key(struct wiphy *wiphy, struct net_device *netdev,
+			u8 key_index,
+			bool pairwise,
+			const u8 *mac_addr)
 {
 	struct WILC_WFI_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
@@ -3563,7 +3563,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.connect = wilc_connect,
 	.disconnect = wilc_disconnect,
 	.add_key = wilc_add_key,
-	.del_key = WILC_WFI_del_key,
+	.del_key = wilc_del_key,
 	.get_key = WILC_WFI_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
-- 
2.5.1

