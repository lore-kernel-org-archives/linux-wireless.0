Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36816 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbbIJTQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:16:12 -0400
Received: by padhk3 with SMTP id hk3so50767545pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:16:12 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 30/31] staging: wilc1000: rename WILC_WFI_set_power_mgmt
Date: Fri, 11 Sep 2015 04:14:29 +0900
Message-Id: <1441912470-3371-30-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211620_551146_318FD5A5)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_power_mgmt with wilc_set_power_mgmt to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2ecaeec..4967306 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2794,7 +2794,7 @@ static int wilc_dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 /**
- *  @brief      WILC_WFI_set_power_mgmt
+ *  @brief      wilc_set_power_mgmt
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -2802,8 +2802,8 @@ static int wilc_dump_station(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 JUL 2012
  *  @version	1.0WILC_WFI_set_cqmWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_config_rssi_config
  */
-int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			    bool enabled, int timeout)
+int wilc_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			bool enabled, int timeout)
 {
 	struct WILC_WFI_priv *priv;
 
@@ -3592,7 +3592,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.mgmt_tx_cancel_wait = wilc_mgmt_tx_cancel_wait,
 	.mgmt_tx = wilc_mgmt_tx,
 	.mgmt_frame_register = wilc_mgmt_frame_register,
-	.set_power_mgmt = WILC_WFI_set_power_mgmt,
+	.set_power_mgmt = wilc_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 #endif
 
-- 
2.5.1

