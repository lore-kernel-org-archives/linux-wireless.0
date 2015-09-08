Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36582 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbbIHP4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:14 -0400
Received: by padhk3 with SMTP id hk3so42517044pad.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/30] staging: wilc1000: rename WILC_WFI_CfgSetChannel
Date: Wed,  9 Sep 2015 00:55:38 +0900
Message-Id: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175617_481363_B42F74DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_CfgSetChannel with
wilc_cfg80211_set_monitor_channel to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 75e1687..585ea5e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -677,7 +677,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 
 
 /**
- *  @brief      WILC_WFI_CfgSetChannel
+ *  @brief      wilc_cfg80211_set_monitor_channel
  *  @details    Set channel for a given wireless interface. Some devices
  *                      may support multi-channel operation (by channel hopping) so cfg80211
  *                      doesn't verify much. Note, however, that the passed netdev may be
@@ -689,7 +689,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_CfgSetChannel(struct wiphy *wiphy,
+static int wilc_cfg80211_set_monitor_channel(struct wiphy *wiphy,
 				  struct cfg80211_chan_def *chandef)
 {
 
@@ -3229,7 +3229,7 @@ static int WILC_WFI_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Interval = %d\n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
 		settings->beacon_interval, settings->dtim_period, beacon->head_len, beacon->tail_len);
 
-	s32Error = WILC_WFI_CfgSetChannel(wiphy, &settings->chandef);
+	s32Error = wilc_cfg80211_set_monitor_channel(wiphy, &settings->chandef);
 
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Error in setting channel\n");
@@ -3603,7 +3603,7 @@ int WILC_WFI_del_virt_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 #endif /*WILC_AP_EXTERNAL_MLME*/
 static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
-	.set_monitor_channel = WILC_WFI_CfgSetChannel,
+	.set_monitor_channel = wilc_cfg80211_set_monitor_channel,
 	.scan = WILC_WFI_CfgScan,
 	.connect = WILC_WFI_CfgConnect,
 	.disconnect = WILC_WFI_disconnect,
-- 
2.5.1

