Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:41322 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761133Ab2DKTyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:13 -0400
Received: by lagv3 with SMTP id v3so1306772lag.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:05 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 18/24] wlcore/wl12xx: use a single memory config and reset if using wl127x
Date: Wed, 11 Apr 2012 22:53:34 +0300
Message-Id: <1334174020-18957-19-git-send-email-coelho@ti.com> (sfid-20120411_215426_263303_5D4D2FA1)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having two memory configuration sets, one for wl127x and
one for wl128x, we can use only one which should be correctly set by
the lower driver.

The wl12xx driver now uses the wl128x memory config by default but
changes it when if it identifies the wl127x chips.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/conf.h |    1 +
 drivers/net/wireless/ti/wl12xx/main.c |   49 +++++++++++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/acx.c  |    5 +---
 drivers/net/wireless/ti/wlcore/conf.h |    3 +-
 4 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/conf.h b/drivers/net/wireless/ti/wl12xx/conf.h
index cb618b9..75e2989 100644
--- a/drivers/net/wireless/ti/wl12xx/conf.h
+++ b/drivers/net/wireless/ti/wl12xx/conf.h
@@ -44,6 +44,7 @@ struct wl12xx_conf_rf {
 
 struct wl12xx_priv_conf {
 	struct wl12xx_conf_rf rf;
+	struct conf_memory_settings mem_wl127x;
 };
 
 #endif /* __WL12XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d9057f8..c90333a 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -285,17 +285,12 @@ static struct wlcore_conf wl12xx_conf = {
 		.inactivity_timeout = 10000,
 		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
 	},
-	.mem_wl127x = {
-		.num_stations                 = 1,
-		.ssid_profiles                = 1,
-		.rx_block_num                 = 70,
-		.tx_min_block_num             = 40,
-		.dynamic_memory               = 1,
-		.min_req_tx_blocks            = 100,
-		.min_req_rx_blocks            = 22,
-		.tx_min                       = 27,
-	},
-	.mem_wl128x = {
+	/*
+	 * Memory config for wl127x chips is given in the
+	 * wl12xx_default_priv_conf struct. The below configuration is
+	 * for wl128x chips.
+	 */
+	.mem = {
 		.num_stations                 = 1,
 		.ssid_profiles                = 1,
 		.rx_block_num                 = 40,
@@ -367,6 +362,29 @@ static struct wlcore_conf wl12xx_conf = {
 	},
 };
 
+static struct wl12xx_priv_conf wl12xx_default_priv_conf = {
+	.rf = {
+		.tx_per_channel_power_compensation_2 = {
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		},
+		.tx_per_channel_power_compensation_5 = {
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		},
+	},
+	.mem_wl127x = {
+		.num_stations                 = 1,
+		.ssid_profiles                = 1,
+		.rx_block_num                 = 70,
+		.tx_min_block_num             = 40,
+		.dynamic_memory               = 1,
+		.min_req_tx_blocks            = 100,
+		.min_req_rx_blocks            = 22,
+		.tx_min                       = 27,
+	},
+
+};
 
 #define WL12XX_TX_HW_BLOCK_SPARE_DEFAULT        1
 #define WL12XX_TX_HW_BLOCK_GEM_SPARE            2
@@ -609,6 +627,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
+		memcpy(&wl->conf.mem, &wl12xx_default_priv_conf.mem_wl127x,
+		       sizeof(wl->conf.mem));
 
 		/* read data preparation is only needed by wl127x */
 		wl->ops->prepare_read = wl127x_prepare_read;
@@ -626,6 +646,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
+		memcpy(&wl->conf.mem, &wl12xx_default_priv_conf.mem_wl127x,
+		       sizeof(wl->conf.mem));
 
 		/* read data preparation is only needed by wl127x */
 		wl->ops->prepare_read = wl127x_prepare_read;
@@ -1172,8 +1194,13 @@ out:
 
 static void wl12xx_conf_init(struct wl1271 *wl)
 {
+	struct wl12xx_priv *priv = wl->priv;
+
 	/* apply driver default configuration */
 	memcpy(&wl->conf, &wl12xx_conf, sizeof(wl12xx_conf));
+
+	/* apply default private configuration */
+	memcpy(&priv->conf, &wl12xx_default_priv_conf, sizeof(priv->conf));
 }
 
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 01dba46..9ad8fd5 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -968,10 +968,7 @@ int wl12xx_acx_mem_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		mem = &wl->conf.mem_wl128x;
-	else
-		mem = &wl->conf.mem_wl127x;
+	mem = &wl->conf.mem;
 
 	/* memory config */
 	mem_conf->num_stations = mem->num_stations;
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index aa2da45..fef0db4 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1263,8 +1263,7 @@ struct wlcore_conf {
 	struct conf_scan_settings scan;
 	struct conf_sched_scan_settings sched_scan;
 	struct conf_ht_setting ht;
-	struct conf_memory_settings mem_wl127x;
-	struct conf_memory_settings mem_wl128x;
+	struct conf_memory_settings mem;
 	struct conf_fm_coex fm_coex;
 	struct conf_rx_streaming_settings rx_streaming;
 	struct conf_fwlog fwlog;
-- 
1.7.5.4

