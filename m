Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33705 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbbINDZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:56 -0400
Received: by pacex6 with SMTP id ex6so130305454pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 26/31] staging: wilc1000: rename WILC_WFI_cancel_remain_on_channel
Date: Mon, 14 Sep 2015 12:24:26 +0900
Message-Id: <1442201071-16155-26-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054652_669872_BE4A48AB)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_cancel_remain_on_channel with
cancel_remain_on_channel to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 40bf7a5..c7ac967 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2444,7 +2444,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_cancel_remain_on_channel
+ *  @brief      cancel_remain_on_channel
  *  @details    Cancel an on-going remain-on-channel operation.
  *                      This allows the operation to be terminated prior to timeout based on
  *                      the duration value.
@@ -2456,9 +2456,9 @@ static int remain_on_channel(struct wiphy *wiphy,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-static int   WILC_WFI_cancel_remain_on_channel(struct wiphy *wiphy,
-					       struct wireless_dev *wdev,
-					       u64 cookie)
+static int cancel_remain_on_channel(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    u64 cookie)
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
@@ -3588,7 +3588,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.flush_pmksa = flush_pmksa,
 #ifdef WILC_P2P
 	.remain_on_channel = remain_on_channel,
-	.cancel_remain_on_channel = WILC_WFI_cancel_remain_on_channel,
+	.cancel_remain_on_channel = cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = WILC_WFI_mgmt_tx_cancel_wait,
 	.mgmt_tx = WILC_WFI_mgmt_tx,
 	.mgmt_frame_register = WILC_WFI_frame_register,
-- 
2.5.1

