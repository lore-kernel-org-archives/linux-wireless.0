Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40418 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0GHOvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:51:04 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/13] wl1271: read fem manufacturer value from nvs
Date: Thu,  8 Jul 2010 17:50:01 +0300
Message-Id: <1278600608-22411-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should read the fem manufacturer value from the NVS, so we can modify it
easily and use a consistent value throughout the configuration.  Previously
we had to set the FEM value in the NVS and in the driver's initialization
parameters.  This patch removes the latter.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    6 +++---
 drivers/net/wireless/wl12xx/wl1271_conf.h |    9 ---------
 drivers/net/wireless/wl12xx/wl1271_main.c |    5 -----
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 834f7f8..23c7598 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -132,7 +132,7 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 int wl1271_cmd_radio_parms(struct wl1271 *wl)
 {
 	struct wl1271_radio_parms_cmd *radio_parms;
-	struct conf_radio_parms *rparam = &wl->conf.init.radioparam;
+	struct wl1271_ini_general_params *gp = &wl->nvs->general_params;
 	int ret;
 
 	if (!wl->nvs)
@@ -148,7 +148,7 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	memcpy(&radio_parms->static_params_2, &wl->nvs->stat_radio_params_2,
 	       sizeof(struct wl1271_ini_band_params_2));
 	memcpy(&radio_parms->dyn_params_2,
-	       &wl->nvs->dyn_radio_params_2[rparam->fem].params,
+	       &wl->nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
 	       sizeof(struct wl1271_ini_fem_params_2));
 
 	/* 5GHz parameters */
@@ -156,7 +156,7 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	       &wl->nvs->stat_radio_params_5,
 	       sizeof(struct wl1271_ini_band_params_5));
 	memcpy(&radio_parms->dyn_params_5,
-	       &wl->nvs->dyn_radio_params_5[rparam->fem].params,
+	       &wl->nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
 	       sizeof(struct wl1271_ini_fem_params_5));
 
 	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 84b0de7..0435ffd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -955,14 +955,6 @@ struct conf_radio_parms {
 	u8 fem;
 };
 
-struct conf_init_settings {
-	/*
-	 * Configure radio parameters.
-	 */
-	struct conf_radio_parms radioparam;
-
-};
-
 struct conf_itrim_settings {
 	/* enable dco itrim */
 	u8 enable;
@@ -1029,7 +1021,6 @@ struct conf_drv_settings {
 	struct conf_rx_settings rx;
 	struct conf_tx_settings tx;
 	struct conf_conn_settings conn;
-	struct conf_init_settings init;
 	struct conf_itrim_settings itrim;
 	struct conf_pm_config_settings pm_config;
 	struct conf_roam_trigger_settings roam_trigger;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 8a4b17f..3a64896 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -241,11 +241,6 @@ static struct conf_drv_settings default_conf = {
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
 	},
-	.init = {
-		.radioparam = {
-			.fem                 = 1,
-		}
-	},
 	.itrim = {
 		.enable = false,
 		.timeout = 50000,
-- 
1.6.3.3

