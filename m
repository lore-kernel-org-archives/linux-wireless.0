Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34715 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbIJTOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:14:42 -0400
Received: by padhy16 with SMTP id hy16so50944979pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:14:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 01/31] staging: wilc1000: rename WILC_WFI_CfgSetChannel
Date: Fri, 11 Sep 2015 04:14:00 +0900
Message-Id: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211446_081498_45111E00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_CfgSetChannel with
wilc_set_channel to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cf76a33..3149fd8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -677,7 +677,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 
 
 /**
- *  @brief      WILC_WFI_CfgSetChannel
+ *  @brief      wilc_set_channel
  *  @details    Set channel for a given wireless interface. Some devices
  *                      may support multi-channel operation (by channel hopping) so cfg80211
  *                      doesn't verify much. Note, however, that the passed netdev may be
@@ -689,8 +689,8 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_CfgSetChannel(struct wiphy *wiphy,
-				  struct cfg80211_chan_def *chandef)
+static int wilc_set_channel(struct wiphy *wiphy,
+			    struct cfg80211_chan_def *chandef)
 {
 
 	u32 channelnum = 0;
@@ -3230,7 +3230,7 @@ static int WILC_WFI_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Interval = %d\n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
 		settings->beacon_interval, settings->dtim_period, beacon->head_len, beacon->tail_len);
 
-	s32Error = WILC_WFI_CfgSetChannel(wiphy, &settings->chandef);
+	s32Error = wilc_set_channel(wiphy, &settings->chandef);
 
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Error in setting channel\n");
@@ -3558,7 +3558,7 @@ int WILC_WFI_del_virt_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 #endif /*WILC_AP_EXTERNAL_MLME*/
 static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
-	.set_monitor_channel = WILC_WFI_CfgSetChannel,
+	.set_monitor_channel = wilc_set_channel,
 	.scan = WILC_WFI_CfgScan,
 	.connect = WILC_WFI_CfgConnect,
 	.disconnect = WILC_WFI_disconnect,
-- 
2.5.1

