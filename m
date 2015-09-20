Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33203 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbITGwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:11 -0400
Received: by pacex6 with SMTP id ex6so87541295pac.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/18] staging: wilc1000: rename WILC_WFI_set_cqm_rssi_config
Date: Sun, 20 Sep 2015 15:51:18 +0900
Message-Id: <1442731885-4344-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085220_785788_15A06697)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_cqm_rssi_config with
set_cqm_rssi_config to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e6e437f..5512dd5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2600,7 +2600,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 /**
- *  @brief      WILC_WFI_set_cqm_rssi_config
+ *  @brief      set_cqm_rssi_config
  *  @details    Configure connection quality monitor RSSI threshold.
  *  @param[in]   struct wiphy *wiphy:
  *  @param[in]	struct net_device *dev:
@@ -2611,8 +2611,8 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int    WILC_WFI_set_cqm_rssi_config(struct wiphy *wiphy,
-					   struct net_device *dev,  s32 rssi_thold, u32 rssi_hyst)
+static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
+			       s32 rssi_thold, u32 rssi_hyst)
 {
 	PRINT_D(CFG80211_DBG, "Setting CQM RSSi Function\n");
 	return 0;
@@ -3417,7 +3417,7 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.mgmt_tx = mgmt_tx,
 	.mgmt_frame_register = wilc_mgmt_frame_register,
 	.set_power_mgmt = set_power_mgmt,
-	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
+	.set_cqm_rssi_config = set_cqm_rssi_config,
 
 };
 
-- 
2.5.1

