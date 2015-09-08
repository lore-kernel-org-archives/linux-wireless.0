Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34703 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbIHP40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:26 -0400
Received: by padhy16 with SMTP id hy16so125288828pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:26 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/30] staging: wilc1000: rename WILC_WFI_get_key
Date: Wed,  9 Sep 2015 00:55:43 +0900
Message-Id: <1441727767-26026-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175629_763747_722412B1)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_get_key with wilc_cfg80211_get_key to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1e08b0c..67a6cfb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1511,7 +1511,7 @@ static int wilc_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /**
- *  @brief      WILC_WFI_get_key
+ *  @brief      wilc_cfg80211_get_key
  *  @details    Get information about the key with the given parameters.
  *                      @mac_addr will be %NULL when requesting information for a group
  *                      key. All pointers given to the @callback function need not be valid
@@ -1523,7 +1523,7 @@ static int wilc_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+static int wilc_cfg80211_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			    bool pairwise,
 			    const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
 {
@@ -3609,7 +3609,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.disconnect = WILC_WFI_disconnect,
 	.add_key = wilc_cfg80211_add_key,
 	.del_key = wilc_cfg80211_del_key,
-	.get_key = WILC_WFI_get_key,
+	.get_key = wilc_cfg80211_get_key,
 	.set_default_key = WILC_WFI_set_default_key,
 	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = WILC_WFI_add_virt_intf,
-- 
2.5.1

