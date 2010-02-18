Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24694 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0BRL2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:13 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 09/22] wl1271: add most of the normal initialization commands to PLT mode
Date: Thu, 18 Feb 2010 13:25:44 +0200
Message-Id: <1266492357-462-10-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

We need to configure PLT mode almost in the same way as normal mode.  Most of
the configuration functions need to be called also when entering PLT, with
the exception of a few RX and TX configuration (which cause mac80211 warnings
if enable while runnning PLT tests).

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_init.c |    8 ++--
 drivers/net/wireless/wl12xx/wl1271_init.h |    4 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |   85 ++++++++++++++++++++++++++---
 3 files changed, 86 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 78403da..86c30a8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -49,7 +49,7 @@ static int wl1271_init_hwenc_config(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_init_templates_config(struct wl1271 *wl)
+int wl1271_init_templates_config(struct wl1271 *wl)
 {
 	int ret;
 
@@ -113,7 +113,7 @@ static int wl1271_init_rx_config(struct wl1271 *wl, u32 config, u32 filter)
 	return 0;
 }
 
-static int wl1271_init_phy_config(struct wl1271 *wl)
+int wl1271_init_phy_config(struct wl1271 *wl)
 {
 	int ret;
 
@@ -156,7 +156,7 @@ static int wl1271_init_beacon_filter(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_init_pta(struct wl1271 *wl)
+int wl1271_init_pta(struct wl1271 *wl)
 {
 	int ret;
 
@@ -171,7 +171,7 @@ static int wl1271_init_pta(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_init_energy_detection(struct wl1271 *wl)
+int wl1271_init_energy_detection(struct wl1271 *wl)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.h b/drivers/net/wireless/wl12xx/wl1271_init.h
index 930677f..bc26f8c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.h
+++ b/drivers/net/wireless/wl12xx/wl1271_init.h
@@ -27,6 +27,10 @@
 #include "wl1271.h"
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
+int wl1271_init_templates_config(struct wl1271 *wl);
+int wl1271_init_phy_config(struct wl1271 *wl);
+int wl1271_init_pta(struct wl1271 *wl);
+int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b5d53a3..e698dec 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -265,7 +265,9 @@ static void wl1271_conf_init(struct wl1271 *wl)
 
 static int wl1271_plt_init(struct wl1271 *wl)
 {
-	int ret;
+	struct conf_tx_ac_category *conf_ac;
+	struct conf_tx_tid *conf_tid;
+	int ret, i;
 
 	ret = wl1271_cmd_general_parms(wl);
 	if (ret < 0)
@@ -275,15 +277,89 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl1271_init_templates_config(wl);
+	if (ret < 0)
+		return ret;
+
 	ret = wl1271_acx_init_mem_config(wl);
 	if (ret < 0)
 		return ret;
 
+	/* PHY layer config */
+	ret = wl1271_init_phy_config(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	ret = wl1271_acx_dco_itrim_params(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Initialize connection monitoring thresholds */
+	ret = wl1271_acx_conn_monit_params(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Bluetooth WLAN coexistence */
+	ret = wl1271_init_pta(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Energy detection */
+	ret = wl1271_init_energy_detection(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Default fragmentation threshold */
+	ret = wl1271_acx_frag_threshold(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Default TID configuration */
+	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
+		conf_tid = &wl->conf.tx.tid_conf[i];
+		ret = wl1271_acx_tid_cfg(wl, conf_tid->queue_id,
+					 conf_tid->channel_type,
+					 conf_tid->tsid,
+					 conf_tid->ps_scheme,
+					 conf_tid->ack_policy,
+					 conf_tid->apsd_conf[0],
+					 conf_tid->apsd_conf[1]);
+		if (ret < 0)
+			goto out_free_memmap;
+	}
+
+	/* Default AC configuration */
+	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
+		conf_ac = &wl->conf.tx.ac_conf[i];
+		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
+					conf_ac->cw_max, conf_ac->aifsn,
+					conf_ac->tx_op_limit);
+		if (ret < 0)
+			goto out_free_memmap;
+	}
+
+	/* Enable data path */
 	ret = wl1271_cmd_data_path(wl, 1);
 	if (ret < 0)
-		return ret;
+		goto out_free_memmap;
+
+	/* Configure for CAM power saving (ie. always active) */
+	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* configure PM */
+	ret = wl1271_acx_pm_config(wl);
+	if (ret < 0)
+		goto out_free_memmap;
 
 	return 0;
+
+ out_free_memmap:
+	kfree(wl->target_mem_map);
+	wl->target_mem_map = NULL;
+
+	return ret;
 }
 
 static void wl1271_disable_interrupts(struct wl1271 *wl)
@@ -653,11 +729,6 @@ int wl1271_plt_start(struct wl1271 *wl)
 		if (ret < 0)
 			goto irq_disable;
 
-		/* Make sure power saving is disabled */
-		ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
-		if (ret < 0)
-			goto irq_disable;
-
 		wl->state = WL1271_STATE_PLT;
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver);
-- 
1.6.3.3

