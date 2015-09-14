Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33621 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbbINDYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:24:48 -0400
Received: by pacex6 with SMTP id ex6so130278324pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:24:47 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 04/31] staging: wilc1000: rename WILC_WFI_disconnect
Date: Mon, 14 Sep 2015 12:24:04 +0900
Message-Id: <1442201071-16155-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052453_824510_03937C76)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_disconnect with disconnect to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7f1ca95..1ebaaef 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1064,7 +1064,7 @@ done:
 
 
 /**
- *  @brief      WILC_WFI_disconnect
+ *  @brief      disconnect
  *  @details    Disconnect from the BSS/ESS.
  *  @param[in]
  *  @return     int : Return 0 on Success
@@ -1072,7 +1072,7 @@ done:
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int WILC_WFI_disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
+static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3561,7 +3561,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.set_monitor_channel = set_channel,
 	.scan = scan,
 	.connect = connect,
-	.disconnect = WILC_WFI_disconnect,
+	.disconnect = disconnect,
 	.add_key = WILC_WFI_add_key,
 	.del_key = WILC_WFI_del_key,
 	.get_key = WILC_WFI_get_key,
-- 
2.5.1

