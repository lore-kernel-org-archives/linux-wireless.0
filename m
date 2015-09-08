Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33262 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbbIHP5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:12 -0400
Received: by pacex6 with SMTP id ex6so127503062pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:12 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 24/30] staging: wilc1000: rename WILC_WFI_remain_on_channel
Date: Wed,  9 Sep 2015 00:56:01 +0900
Message-Id: <1441727767-26026-24-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180159_287110_1524DCBB)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_remain_on_channel with
wilc_cfg80211_remain_on_channel to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3c49412..f071389 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2391,7 +2391,7 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 
 
 /**
- *  @brief      WILC_WFI_remain_on_channel
+ *  @brief      wilc_cfg80211_remain_on_channel
  *  @details    Request the driver to remain awake on the specified
  *                      channel for the specified duration to complete an off-channel
  *                      operation (e.g., public action frame exchange). When the driver is
@@ -2403,7 +2403,7 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int  WILC_WFI_remain_on_channel(struct wiphy *wiphy,
+static int  wilc_cfg80211_remain_on_channel(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       struct ieee80211_channel *chan,
 				       unsigned int duration, u64 *cookie)
@@ -3634,7 +3634,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.del_pmksa = wilc_cfg80211_del_pmksa,
 	.flush_pmksa = wilc_cfg80211_flush_pmksa,
 #ifdef WILC_P2P
-	.remain_on_channel = WILC_WFI_remain_on_channel,
+	.remain_on_channel = wilc_cfg80211_remain_on_channel,
 	.cancel_remain_on_channel = WILC_WFI_cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = WILC_WFI_mgmt_tx_cancel_wait,
 	.mgmt_tx = WILC_WFI_mgmt_tx,
-- 
2.5.1

