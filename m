Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34266 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbbINDYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:24:45 -0400
Received: by padhy16 with SMTP id hy16so129885334pad.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:24:44 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 03/31] staging: wilc1000: rename WILC_WFI_CfgConnect
Date: Mon, 14 Sep 2015 12:24:03 +0900
Message-Id: <1442201071-16155-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052450_290551_7B734836)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_CfgConnect with connect to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2c39179..7f1ca95 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -806,7 +806,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 }
 
 /**
- *  @brief      WILC_WFI_CfgConnect
+ *  @brief      connect
  *  @details    Connect to the ESS with the specified parameters. When connected,
  *                      call cfg80211_connect_result() with status code %WLAN_STATUS_SUCCESS.
  *                      If the connection fails for some reason, call cfg80211_connect_result()
@@ -817,8 +817,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
-			       struct cfg80211_connect_params *sme)
+static int connect(struct wiphy *wiphy, struct net_device *dev,
+		   struct cfg80211_connect_params *sme)
 {
 	s32 s32Error = WILC_SUCCESS;
 	u32 i;
@@ -3560,7 +3560,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
 	.set_monitor_channel = set_channel,
 	.scan = scan,
-	.connect = WILC_WFI_CfgConnect,
+	.connect = connect,
 	.disconnect = WILC_WFI_disconnect,
 	.add_key = WILC_WFI_add_key,
 	.del_key = WILC_WFI_del_key,
-- 
2.5.1

