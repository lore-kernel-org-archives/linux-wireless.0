Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:32795 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756991Ab2FGUkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:40:20 -0400
Received: by laai10 with SMTP id i10so933084laa.13
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:46 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 5/9] wlcore/wl18xx/wl12xx: use u8 instead of bool for host_fast_wakeup_support
Date: Thu,  7 Jun 2012 23:39:24 +0300
Message-Id: <1339101568-25346-6-git-send-email-coelho@ti.com> (sfid-20120607_224029_174436_565E6D49)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The conf structure is going to be exported to a file, so we should use
only well defined types.  bool is not well defined and may vary from
platform to platform, so change the host_fast_wakeup_support type to
u8 instead.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 drivers/net/wireless/ti/wlcore/conf.h |    9 +++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 8338045..85d1600 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -253,7 +253,7 @@ static struct wlcore_conf wl12xx_conf = {
 	},
 	.pm_config = {
 		.host_clk_settling_time = 5000,
-		.host_fast_wakeup_support = false
+		.host_fast_wakeup_support = CONF_FAST_WAKEUP_DISABLE,
 	},
 	.roam_trigger = {
 		.trigger_pacing               = 1,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index fd02795..b6a80cd 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -376,7 +376,7 @@ static struct wlcore_conf wl18xx_conf = {
 	},
 	.pm_config = {
 		.host_clk_settling_time = 5000,
-		.host_fast_wakeup_support = false
+		.host_fast_wakeup_support = CONF_FAST_WAKEUP_DISABLE,
 	},
 	.roam_trigger = {
 		.trigger_pacing               = 1,
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index d2c4885..2e84ae1 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -981,6 +981,11 @@ struct conf_itrim_settings {
 	u32 timeout;
 };
 
+enum conf_fast_wakeup {
+	CONF_FAST_WAKEUP_ENABLE,
+	CONF_FAST_WAKEUP_DISABLE,
+};
+
 struct conf_pm_config_settings {
 	/*
 	 * Host clock settling time
@@ -992,9 +997,9 @@ struct conf_pm_config_settings {
 	/*
 	 * Host fast wakeup support
 	 *
-	 * Range: true, false
+	 * Range: enum conf_fast_wakeup
 	 */
-	bool host_fast_wakeup_support;
+	u8 host_fast_wakeup_support;
 };
 
 struct conf_roam_trigger_settings {
-- 
1.7.10

