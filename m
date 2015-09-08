Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33454 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbbIHP5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:25 -0400
Received: by pacex6 with SMTP id ex6so127507772pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:25 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 29/30] staging: wilc1000: rename WILC_WFI_set_power_mgmt
Date: Wed,  9 Sep 2015 00:56:06 +0900
Message-Id: <1441727767-26026-29-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180200_038312_8C62EEC2)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_set_power_mgmt with
wilc_cfg80211_set_power_mgmt to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 55ca2db..078220f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2793,7 +2793,7 @@ static int wilc_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *de
 
 
 /**
- *  @brief      WILC_WFI_set_power_mgmt
+ *  @brief      wilc_cfg80211_set_power_mgmt
  *  @details
  *  @param[in]
  *  @return     int : Return 0 on Success.
@@ -2801,7 +2801,7 @@ static int wilc_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *de
  *  @date	01 JUL 2012
  *  @version	1.0WILC_WFI_set_cqmWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_config_rssi_config
  */
-int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+int wilc_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			    bool enabled, int timeout)
 {
 	struct WILC_WFI_priv *priv;
@@ -3639,7 +3639,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.mgmt_tx_cancel_wait = wilc_cfg80211_mgmt_tx_cancel_wait,
 	.mgmt_tx = wilc_cfg80211_mgmt_tx,
 	.mgmt_frame_register = wilc_cfg80211_mgmt_frame_register,
-	.set_power_mgmt = WILC_WFI_set_power_mgmt,
+	.set_power_mgmt = wilc_cfg80211_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 #endif
 
-- 
2.5.1

