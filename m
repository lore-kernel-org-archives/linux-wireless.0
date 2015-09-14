Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:32943 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbbIND0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:26:12 -0400
Received: by pacex6 with SMTP id ex6so130311609pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:26:11 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 31/31] staging: wilc1000: rename WILC_WFI_set_cqm_rssi_config
Date: Mon, 14 Sep 2015 12:24:31 +0900
Message-Id: <1442201071-16155-31-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052708_665425_0E605880)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_cqm_rssi_config with
set_cqm_rssi_config to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index fd64303..a75f14a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2741,7 +2741,7 @@ void mgmt_frame_register(struct wiphy *wiphy,
 #endif /*WILC_P2P*/
 
 /**
- *  @brief      WILC_WFI_set_cqm_rssi_config
+ *  @brief      set_cqm_rssi_config
  *  @details    Configure connection quality monitor RSSI threshold.
  *  @param[in]   struct wiphy *wiphy:
  *  @param[in]	struct net_device *dev:
@@ -2752,8 +2752,8 @@ void mgmt_frame_register(struct wiphy *wiphy,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
-					   struct net_device *dev,  s32 rssi_thold, u32 rssi_hyst)
+static int set_cqm_rssi_config(struct wiphy *wiphy,
+			       struct net_device *dev,  s32 rssi_thold, u32 rssi_hyst)
 {
 	PRINT_D(CFG80211_DBG, "Setting CQM RSSi Function\n");
 	return 0;
@@ -3593,7 +3593,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.mgmt_tx = mgmt_tx,
 	.mgmt_frame_register = mgmt_frame_register,
 	.set_power_mgmt = set_power_mgmt,
-	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
+	.set_cqm_rssi_config = set_cqm_rssi_config,
 #endif
 
 };
-- 
2.5.1

