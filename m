Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37156 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3IQPlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 11:41:44 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so2792241eek.22
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 08:41:43 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 07/11] wlcore: remove unsupported channels
Date: Tue, 17 Sep 2013 18:41:26 +0300
Message-Id: <1379432490-22157-7-git-send-email-eliad@wizery.com> (sfid-20130917_174158_104837_7599EE8A)
In-Reply-To: <1379432490-22157-1-git-send-email-eliad@wizery.com>
References: <1379432490-22157-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fw doesn't support channels 7,9,11 in 5ghz band,
so don't advertise supporting them.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d952593..4b52e5a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5414,10 +5414,7 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
 
 /* 5 GHz band channels for WL1273 */
 static struct ieee80211_channel wl1271_channels_5ghz[] = {
-	{ .hw_value = 7, .center_freq = 5035, .max_power = WLCORE_MAX_TXPWR },
 	{ .hw_value = 8, .center_freq = 5040, .max_power = WLCORE_MAX_TXPWR },
-	{ .hw_value = 9, .center_freq = 5045, .max_power = WLCORE_MAX_TXPWR },
-	{ .hw_value = 11, .center_freq = 5055, .max_power = WLCORE_MAX_TXPWR },
 	{ .hw_value = 12, .center_freq = 5060, .max_power = WLCORE_MAX_TXPWR },
 	{ .hw_value = 16, .center_freq = 5080, .max_power = WLCORE_MAX_TXPWR },
 	{ .hw_value = 34, .center_freq = 5170, .max_power = WLCORE_MAX_TXPWR },
-- 
1.8.3.rc1.35.g9b79519

