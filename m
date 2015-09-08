Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34987 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbbIHP5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:05 -0400
Received: by pacfv12 with SMTP id fv12so130451538pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:04 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 21/30] staging: wilc1000: rename WILC_WFI_set_pmksa
Date: Wed,  9 Sep 2015 00:55:58 +0900
Message-Id: <1441727767-26026-21-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180158_799942_BAC281C7)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_pmksa with wilc_cfg80211_set_pmksa to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 25b4531..7b2f200 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1880,7 +1880,7 @@ static int WILC_WFI_set_bitrate_mask(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_set_pmksa
+ *  @brief      wilc_cfg80211_set_pmksa
  *  @details    Cache a PMKID for a BSSID. This is mostly useful for fullmac
  *                      devices running firmwares capable of generating the (re) association
  *                      RSN IE. It allows for faster roaming between WPA2 BSSIDs.
@@ -1890,7 +1890,7 @@ static int WILC_WFI_set_bitrate_mask(struct wiphy *wiphy,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+static int wilc_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 			      struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
@@ -3630,7 +3630,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.change_bss = wilc_cfg80211_change_bss,
 	.set_wiphy_params = wilc_cfg80211_set_wiphy_params,
 
-	.set_pmksa = WILC_WFI_set_pmksa,
+	.set_pmksa = wilc_cfg80211_set_pmksa,
 	.del_pmksa = WILC_WFI_del_pmksa,
 	.flush_pmksa = WILC_WFI_flush_pmksa,
 #ifdef WILC_P2P
-- 
2.5.1

