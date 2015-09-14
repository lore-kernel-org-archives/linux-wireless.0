Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34171 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbINDZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:44 -0400
Received: by padhy16 with SMTP id hy16so129907808pad.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:43 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 22/31] staging: wilc1000: rename WILC_WFI_set_pmksa
Date: Mon, 14 Sep 2015 12:24:22 +0900
Message-Id: <1442201071-16155-22-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054653_470634_A74A5FD8)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_pmksa with set_pmksa to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 51ed89a..774897f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1880,7 +1880,7 @@ static int WILC_WFI_set_bitrate_mask(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_set_pmksa
+ *  @brief      set_pmksa
  *  @details    Cache a PMKID for a BSSID. This is mostly useful for fullmac
  *                      devices running firmwares capable of generating the (re) association
  *                      RSN IE. It allows for faster roaming between WPA2 BSSIDs.
@@ -1890,8 +1890,8 @@ static int WILC_WFI_set_bitrate_mask(struct wiphy *wiphy,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
-			      struct cfg80211_pmksa *pmksa)
+static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
 	s32 s32Error = WILC_SUCCESS;
@@ -3583,7 +3583,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_bss = change_bss,
 	.set_wiphy_params = set_wiphy_params,
 
-	.set_pmksa = WILC_WFI_set_pmksa,
+	.set_pmksa = set_pmksa,
 	.del_pmksa = WILC_WFI_del_pmksa,
 	.flush_pmksa = WILC_WFI_flush_pmksa,
 #ifdef WILC_P2P
-- 
2.5.1

