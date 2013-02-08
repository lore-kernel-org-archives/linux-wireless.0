Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759790Ab3BHIUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 03:20:13 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id r188KCCe031244
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 02:20:12 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r188KCOH027110
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 02:20:12 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <victorg@ti.com>
Subject: [PATCH] wl18xx: add new phy configuration parameters for telec support
Date: Fri, 8 Feb 2013 10:19:13 +0200
Message-ID: <1360311553-2543-1-git-send-email-coelho@ti.com> (sfid-20130208_092019_015207_9D3FDEC5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Add back-off settings to the wl18xx_mac_and_phy_params.  We had an
empty space where the new parameters are added, so this change doesn't
affect backwards-compatibility with older firmwares.

Update WL18XX_CONF_VERSION accordingly.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |    7 ++++---
 drivers/net/wireless/ti/wl18xx/main.c |    5 +++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index b5f1148..e34302e 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -23,7 +23,7 @@
 #define __WL18XX_CONF_H__
 
 #define WL18XX_CONF_MAGIC	0x10e100ca
-#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0005)
+#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0006)
 #define WL18XX_CONF_MASK	0x0000ffff
 #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
 				 sizeof(struct wl18xx_priv_conf))
@@ -70,8 +70,9 @@ struct wl18xx_mac_and_phy_params {
 	u8 pwr_limit_reference_11_abg;
 	u8 per_chan_pwr_limit_arr_11p[NUM_OF_CHANNELS_11_P];
 	u8 pwr_limit_reference_11p;
-	u8 spare1[9];
-	u8 spare2[9];
+	u8 spare1;
+	u8 per_chan_bo_mode_11_abg[13];
+	u8 per_chan_bo_mode_11_p[4];
 	u8 primary_clock_setting_time;
 	u8 clock_valid_on_wake_up;
 	u8 secondary_clock_setting_time;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0be1cfc..a10b7a7 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -547,6 +547,11 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
 		.pwr_limit_reference_11p	= 0x64,
+		.per_chan_bo_mode_11_abg	= { 0x00, 0x00, 0x00, 0x00,
+						    0x00, 0x00, 0x00, 0x00,
+						    0x00, 0x00, 0x00, 0x00,
+						    0x00 },
+		.per_chan_bo_mode_11_p		= { 0x00, 0x00, 0x00, 0x00 },
 		.per_chan_pwr_limit_arr_11p	= { 0xff, 0xff, 0xff, 0xff,
 						    0xff, 0xff, 0xff },
 		.psat				= 0,
-- 
1.7.10.4

