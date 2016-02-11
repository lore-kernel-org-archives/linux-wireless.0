Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36442 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbcBKEqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 23:46:35 -0500
Received: by mail-pa0-f65.google.com with SMTP id y7so628594paa.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 20:46:35 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 1/4] staging: wilc1000: fix return type of wilc_send_config_pkt
Date: Thu, 11 Feb 2016 13:46:22 +0900
Message-Id: <1455165985-5509-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160211_054639_481809_FBCE17AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_send_config_pkt is returned 0 or -ETIMEDOUT according to return
value of wilc_wlan_cfg_set or wilc_wlan_cfg_set.
It is better to use int type to represent linux standard error code.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wlan.c | 5 +++--
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 98b21d4..2bc2970 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1349,10 +1349,11 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
-s32 wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
+int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
-	s32 counter = 0, ret = 0;
+	s32 counter = 0;
+	int ret = 0;
 
 	if (mode == GET_CFG) {
 		for (counter = 0; counter < count; counter++) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index d362fa8..06d02ab 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -301,6 +301,6 @@ void host_sleep_notify(struct wilc *wilc);
 extern bool wilc_enable_ps;
 void chip_allow_sleep(struct wilc *wilc);
 void chip_wakeup(struct wilc *wilc);
-s32 wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
+int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			 u32 count, u32 drv);
 #endif
-- 
2.7.1

