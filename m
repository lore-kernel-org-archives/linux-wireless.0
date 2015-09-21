Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33928 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:58:34 -0400
Received: by padhy16 with SMTP id hy16so116235119pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:58:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/16] staging: wilc1000: rename WILC_WFI_set_power_mgmt
Date: Mon, 21 Sep 2015 21:58:11 +0900
Message-Id: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145837_839902_4156E359)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_power_mgmt with set_power_mgmt.
then makes set_power_mgmt static.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index de8c83d..eaec88c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2651,7 +2651,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_set_power_mgmt
+ *  @brief      set_power_mgmt
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -2659,8 +2659,8 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 JUL 2012
  *  @version	1.0WILC_WFI_set_cqmWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_config_rssi_config
  */
-int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			    bool enabled, int timeout)
+static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			  bool enabled, int timeout)
 {
 	struct wilc_priv *priv;
 
@@ -3410,7 +3410,7 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.mgmt_tx_cancel_wait = mgmt_tx_cancel_wait,
 	.mgmt_tx = mgmt_tx,
 	.mgmt_frame_register = wilc_mgmt_frame_register,
-	.set_power_mgmt = WILC_WFI_set_power_mgmt,
+	.set_power_mgmt = set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 
 };
-- 
2.5.1

