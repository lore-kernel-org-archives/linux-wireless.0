Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33871 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:14 -0400
Received: by padhy16 with SMTP id hy16so4748604pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 03/16] staging: wilc1000: rename WILC_WFI_set_cqm_rssi_config
Date: Tue, 22 Sep 2015 18:34:48 +0900
Message-Id: <1442914501-2315-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113519_211472_4B1396EE)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_cqm_rssi_config with
set_cqm_rssi_config to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 58b1481..40fd3ca 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2589,7 +2589,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 /**
- *  @brief      WILC_WFI_set_cqm_rssi_config
+ *  @brief      set_cqm_rssi_config
  *  @details    Configure connection quality monitor RSSI threshold.
  *  @param[in]   struct wiphy *wiphy:
  *  @param[in]	struct net_device *dev:
@@ -2600,8 +2600,8 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
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
@@ -3402,7 +3402,7 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.mgmt_tx = mgmt_tx,
 	.mgmt_frame_register = wilc_mgmt_frame_register,
 	.set_power_mgmt = set_power_mgmt,
-	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
+	.set_cqm_rssi_config = set_cqm_rssi_config,
 
 };
 
-- 
2.5.1

