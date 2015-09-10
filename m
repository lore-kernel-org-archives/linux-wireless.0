Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36735 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIJTOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:14:51 -0400
Received: by padhk3 with SMTP id hk3so50739695pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:14:51 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 04/31] staging: wilc1000: rename WILC_WFI_disconnect
Date: Fri, 11 Sep 2015 04:14:03 +0900
Message-Id: <1441912470-3371-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211455_430389_951A8F8C)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_disconnect with wilc_disconnect to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0337a29..e301372 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1064,7 +1064,7 @@ done:
 
 
 /**
- *  @brief      WILC_WFI_disconnect
+ *  @brief      wilc_disconnect
  *  @details    Disconnect from the BSS/ESS.
  *  @param[in]
  *  @return     int : Return 0 on Success
@@ -1072,7 +1072,7 @@ done:
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
+static int wilc_disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3561,7 +3561,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.set_monitor_channel = wilc_set_channel,
 	.scan = wilc_scan,
 	.connect = wilc_connect,
-	.disconnect = WILC_WFI_disconnect,
+	.disconnect = wilc_disconnect,
 	.add_key = WILC_WFI_add_key,
 	.del_key = WILC_WFI_del_key,
 	.get_key = WILC_WFI_get_key,
-- 
2.5.1

