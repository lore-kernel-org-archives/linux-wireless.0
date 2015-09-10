Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35563 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbbIJTQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:16:03 -0400
Received: by pacfv12 with SMTP id fv12so51873577pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:16:02 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 27/31] staging: wilc1000: rename WILC_WFI_mgmt_tx_cancel_wait
Date: Fri, 11 Sep 2015 04:14:26 +0900
Message-Id: <1441912470-3371-27-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211853_935261_A5DCD217)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_mgmt_tx_cancel_wait with
wilc_mgmt_tx_cancel_wait to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6b84821..8ce6721 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2652,9 +2652,9 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 	return s32Error;
 }
 
-int   WILC_WFI_mgmt_tx_cancel_wait(struct wiphy *wiphy,
-				   struct wireless_dev *wdev,
-				   u64 cookie)
+int   wilc_mgmt_tx_cancel_wait(struct wiphy *wiphy,
+			       struct wireless_dev *wdev,
+			       u64 cookie)
 {
 	struct WILC_WFI_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
@@ -3589,7 +3589,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 #ifdef WILC_P2P
 	.remain_on_channel = wilc_remain_on_channel,
 	.cancel_remain_on_channel = wilc_cancel_remain_on_channel,
-	.mgmt_tx_cancel_wait = WILC_WFI_mgmt_tx_cancel_wait,
+	.mgmt_tx_cancel_wait = wilc_mgmt_tx_cancel_wait,
 	.mgmt_tx = WILC_WFI_mgmt_tx,
 	.mgmt_frame_register = WILC_WFI_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
-- 
2.5.1

