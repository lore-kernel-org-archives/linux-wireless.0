Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34430 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbbINDZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:25:59 -0400
Received: by padhy16 with SMTP id hy16so129914114pad.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:25:59 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 27/31] staging: wilc1000: rename WILC_WFI_mgmt_tx_cancel_wait
Date: Mon, 14 Sep 2015 12:24:27 +0900
Message-Id: <1442201071-16155-27-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054654_720480_F38E3BA1)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_mgmt_tx_cancel_wait with
mgmt_tx_cancel_wait to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c7ac967..627a254 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2652,9 +2652,9 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 	return s32Error;
 }
 
-int   WILC_WFI_mgmt_tx_cancel_wait(struct wiphy *wiphy,
-				   struct wireless_dev *wdev,
-				   u64 cookie)
+int mgmt_tx_cancel_wait(struct wiphy *wiphy,
+			struct wireless_dev *wdev,
+			u64 cookie)
 {
 	struct WILC_WFI_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
@@ -3589,7 +3589,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 #ifdef WILC_P2P
 	.remain_on_channel = remain_on_channel,
 	.cancel_remain_on_channel = cancel_remain_on_channel,
-	.mgmt_tx_cancel_wait = WILC_WFI_mgmt_tx_cancel_wait,
+	.mgmt_tx_cancel_wait = mgmt_tx_cancel_wait,
 	.mgmt_tx = WILC_WFI_mgmt_tx,
 	.mgmt_frame_register = WILC_WFI_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
-- 
2.5.1

