Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34466 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbbIHP5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:17 -0400
Received: by padhy16 with SMTP id hy16so125308420pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 26/30] staging: wilc1000: rename WILC_WFI_mgmt_tx_cancel_wait
Date: Wed,  9 Sep 2015 00:56:03 +0900
Message-Id: <1441727767-26026-26-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180151_744487_214CB969)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_mgmt_tx_cancel_wait with
wilc_cfg80211_mgmt_tx_cancel_wait to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3e6af0c..e65c18a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2651,7 +2651,7 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 	return s32Error;
 }
 
-int   WILC_WFI_mgmt_tx_cancel_wait(struct wiphy *wiphy,
+int   wilc_cfg80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 				   struct wireless_dev *wdev,
 				   u64 cookie)
 {
@@ -3636,7 +3636,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 #ifdef WILC_P2P
 	.remain_on_channel = wilc_cfg80211_remain_on_channel,
 	.cancel_remain_on_channel = wilc_cfg80211_cancel_remain_on_channel,
-	.mgmt_tx_cancel_wait = WILC_WFI_mgmt_tx_cancel_wait,
+	.mgmt_tx_cancel_wait = wilc_cfg80211_mgmt_tx_cancel_wait,
 	.mgmt_tx = WILC_WFI_mgmt_tx,
 	.mgmt_frame_register = WILC_WFI_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
-- 
2.5.1

