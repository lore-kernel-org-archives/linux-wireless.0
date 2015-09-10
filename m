Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33273 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbbIJTQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:16:06 -0400
Received: by pacex6 with SMTP id ex6so51126535pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:16:06 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 28/31] staging: wilc1000: rename WILC_WFI_mgmt_tx
Date: Fri, 11 Sep 2015 04:14:27 +0900
Message-Id: <1441912470-3371-28-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211853_558367_9700CB91)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_mgmt_tx with wilc_mgmt_tx to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8ce6721..dc935cb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2496,10 +2496,10 @@ void WILC_WFI_add_wilcvendorspec(u8 *buff)
  */
 extern linux_wlan_t *g_linux_wlan;
 extern bool bEnablePS;
-int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
-			struct wireless_dev *wdev,
-			struct cfg80211_mgmt_tx_params *params,
-			u64 *cookie)
+int wilc_mgmt_tx(struct wiphy *wiphy,
+		 struct wireless_dev *wdev,
+		 struct cfg80211_mgmt_tx_params *params,
+		 u64 *cookie)
 {
 	struct ieee80211_channel *chan = params->chan;
 	unsigned int wait = params->wait;
@@ -3590,7 +3590,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.remain_on_channel = wilc_remain_on_channel,
 	.cancel_remain_on_channel = wilc_cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = wilc_mgmt_tx_cancel_wait,
-	.mgmt_tx = WILC_WFI_mgmt_tx,
+	.mgmt_tx = wilc_mgmt_tx,
 	.mgmt_frame_register = WILC_WFI_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
-- 
2.5.1

