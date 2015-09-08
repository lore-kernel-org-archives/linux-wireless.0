Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35289 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbbIHP4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:19 -0400
Received: by pacfv12 with SMTP id fv12so130433825pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/30] staging: wilc1000: rename WILC_WFI_CfgConnect
Date: Wed,  9 Sep 2015 00:55:40 +0900
Message-Id: <1441727767-26026-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175621_753442_F2334CDE)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_CfgConnect with wilc_cfg80211_connect to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 087f36e..563841f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -806,7 +806,7 @@ static int wilc_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request
 }
 
 /**
- *  @brief      WILC_WFI_CfgConnect
+ *  @brief      wilc_cfg80211_connect
  *  @details    Connect to the ESS with the specified parameters. When connected,
  *                      call cfg80211_connect_result() with status code %WLAN_STATUS_SUCCESS.
  *                      If the connection fails for some reason, call cfg80211_connect_result()
@@ -817,7 +817,7 @@ static int wilc_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
+static int wilc_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_connect_params *sme)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -3605,7 +3605,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
 	.set_monitor_channel = wilc_cfg80211_set_monitor_channel,
 	.scan = wilc_cfg80211_scan,
-	.connect = WILC_WFI_CfgConnect,
+	.connect = wilc_cfg80211_connect,
 	.disconnect = WILC_WFI_disconnect,
 	.add_key = WILC_WFI_add_key,
 	.del_key = WILC_WFI_del_key,
-- 
2.5.1

