Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33152 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbIJTP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:15:57 -0400
Received: by pacex6 with SMTP id ex6so51123501pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:15:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 25/31] staging: wilc1000: rename WILC_WFI_remain_on_channel
Date: Fri, 11 Sep 2015 04:14:24 +0900
Message-Id: <1441912470-3371-25-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211603_593862_A1CF35B8)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_remain_on_channel with
wilc_remain_on_channel to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c7cc1a2..824fba0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2391,7 +2391,7 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 
 
 /**
- *  @brief      WILC_WFI_remain_on_channel
+ *  @brief      wilc_remain_on_channel
  *  @details    Request the driver to remain awake on the specified
  *                      channel for the specified duration to complete an off-channel
  *                      operation (e.g., public action frame exchange). When the driver is
@@ -2403,10 +2403,10 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_remain_on_channel(struct wiphy *wiphy,
-				       struct wireless_dev *wdev,
-				       struct ieee80211_channel *chan,
-				       unsigned int duration, u64 *cookie)
+static int  wilc_remain_on_channel(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct ieee80211_channel *chan,
+				   unsigned int duration, u64 *cookie)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3587,7 +3587,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.del_pmksa = wilc_del_pmksa,
 	.flush_pmksa = wilc_flush_pmksa,
 #ifdef WILC_P2P
-	.remain_on_channel = WILC_WFI_remain_on_channel,
+	.remain_on_channel = wilc_remain_on_channel,
 	.cancel_remain_on_channel = WILC_WFI_cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = WILC_WFI_mgmt_tx_cancel_wait,
 	.mgmt_tx = WILC_WFI_mgmt_tx,
-- 
2.5.1

