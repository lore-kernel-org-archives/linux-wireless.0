Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35359 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbbIHP52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:28 -0400
Received: by pacfv12 with SMTP id fv12so130460750pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:27 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 30/30] staging: wilc1000: rename WILC_WFI_set_cqm_rssi_config
Date: Wed,  9 Sep 2015 00:56:07 +0900
Message-Id: <1441727767-26026-30-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180159_900165_94F15178)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_cqm_rssi_config with
wilc_cfg80211_set_cqm_rssi_config to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 078220f..ee29be7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2740,7 +2740,7 @@ void    wilc_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
 #endif /*WILC_P2P*/
 
 /**
- *  @brief      WILC_WFI_set_cqm_rssi_config
+ *  @brief      wilc_cfg80211_set_cqm_rssi_config
  *  @details    Configure connection quality monitor RSSI threshold.
  *  @param[in]   struct wiphy *wiphy:
  *  @param[in]	struct net_device *dev:
@@ -2751,7 +2751,7 @@ void    wilc_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
+static int    wilc_cfg80211_set_cqm_rssi_config(struct wiphy *wiphy,
 					   struct net_device *dev,  s32 rssi_thold, u32 rssi_hyst)
 {
 	PRINT_D(CFG80211_DBG, "Setting CQM RSSi Function\n");
@@ -3640,7 +3640,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.mgmt_tx = wilc_cfg80211_mgmt_tx,
 	.mgmt_frame_register = wilc_cfg80211_mgmt_frame_register,
 	.set_power_mgmt = wilc_cfg80211_set_power_mgmt,
-	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
+	.set_cqm_rssi_config = wilc_cfg80211_set_cqm_rssi_config,
 #endif
 
 };
-- 
2.5.1

