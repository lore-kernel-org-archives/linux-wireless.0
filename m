Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36809 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbbIND0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:26:09 -0400
Received: by padhk3 with SMTP id hk3so129810082pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:26:08 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 30/31] staging: wilc1000: rename WILC_WFI_set_power_mgmt
Date: Mon, 14 Sep 2015 12:24:30 +0900
Message-Id: <1442201071-16155-30-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052736_114402_20439A31)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_power_mgmt with set_power_mgmt to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f2ffef8..fd64303 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2794,7 +2794,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_set_power_mgmt
+ *  @brief      set_power_mgmt
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -2802,8 +2802,8 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 JUL 2012
  *  @version	1.0WILC_WFI_set_cqmWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_config_rssi_config
  */
-int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			    bool enabled, int timeout)
+int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+		   bool enabled, int timeout)
 {
 	struct WILC_WFI_priv *priv;
 
@@ -3592,7 +3592,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.mgmt_tx_cancel_wait = mgmt_tx_cancel_wait,
 	.mgmt_tx = mgmt_tx,
 	.mgmt_frame_register = mgmt_frame_register,
-	.set_power_mgmt = WILC_WFI_set_power_mgmt,
+	.set_power_mgmt = set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 #endif
 
-- 
2.5.1

