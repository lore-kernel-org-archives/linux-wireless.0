Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34414 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbbINDYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:24:54 -0400
Received: by padhy16 with SMTP id hy16so129888972pad.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:24:54 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 06/31] staging: wilc1000: rename WILC_WFI_del_key
Date: Mon, 14 Sep 2015 12:24:06 +0900
Message-Id: <1442201071-16155-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052458_079675_AAB02298)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_del_key with del_key to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b5e6176..dfa9db3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1403,7 +1403,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 }
 
 /**
- *  @brief      WILC_WFI_del_key
+ *  @brief      del_key
  *  @details    Remove a key given the @mac_addr (%NULL for a group key)
  *                      and @key_index, return -ENOENT if the key doesn't exist.
  *  @param[in]
@@ -1412,10 +1412,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
-			    u8 key_index,
-			    bool pairwise,
-			    const u8 *mac_addr)
+static int del_key(struct wiphy *wiphy, struct net_device *netdev,
+		   u8 key_index,
+		   bool pairwise,
+		   const u8 *mac_addr)
 {
 	struct WILC_WFI_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
@@ -3563,7 +3563,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.connect = connect,
 	.disconnect = disconnect,
 	.add_key = add_key,
-	.del_key = WILC_WFI_del_key,
+	.del_key = del_key,
 	.get_key = WILC_WFI_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
-- 
2.5.1

