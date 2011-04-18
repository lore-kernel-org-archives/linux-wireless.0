Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41741 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1DRLPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:15:42 -0400
Received: by wwa36 with SMTP id 36so5506533wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:15:40 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/10] wl12xx: add BT-coexistance for AP
Date: Mon, 18 Apr 2011 14:15:20 +0300
Message-Id: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize AP specific BT coexitance parameters to default values and
enable them in AP mode.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   40 ++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/acx.h  |   16 ++++++++--
 drivers/net/wireless/wl12xx/conf.h |   35 +++++++++++++++++++++-
 drivers/net/wireless/wl12xx/init.c |   15 ++++++----
 drivers/net/wireless/wl12xx/main.c |   57 +++++++++++++++++++++++++++++++++++-
 5 files changed, 146 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index b277947..cda546b 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -540,13 +540,13 @@ out:
 	return ret;
 }
 
-int wl1271_acx_sg_cfg(struct wl1271 *wl)
+int wl1271_acx_sta_sg_cfg(struct wl1271 *wl)
 {
-	struct acx_bt_wlan_coex_param *param;
+	struct acx_sta_bt_wlan_coex_param *param;
 	struct conf_sg_settings *c = &wl->conf.sg;
 	int i, ret;
 
-	wl1271_debug(DEBUG_ACX, "acx sg cfg");
+	wl1271_debug(DEBUG_ACX, "acx sg sta cfg");
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param) {
@@ -555,8 +555,38 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 	}
 
 	/* BT-WLAN coext parameters */
-	for (i = 0; i < CONF_SG_PARAMS_MAX; i++)
-		param->params[i] = cpu_to_le32(c->params[i]);
+	for (i = 0; i < CONF_SG_STA_PARAMS_MAX; i++)
+		param->params[i] = cpu_to_le32(c->sta_params[i]);
+	param->param_idx = CONF_SG_PARAMS_ALL;
+
+	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
+	if (ret < 0) {
+		wl1271_warning("failed to set sg config: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(param);
+	return ret;
+}
+
+int wl1271_acx_ap_sg_cfg(struct wl1271 *wl)
+{
+	struct acx_ap_bt_wlan_coex_param *param;
+	struct conf_sg_settings *c = &wl->conf.sg;
+	int i, ret;
+
+	wl1271_debug(DEBUG_ACX, "acx sg ap cfg");
+
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
+	if (!param) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* BT-WLAN coext parameters */
+	for (i = 0; i < CONF_SG_AP_PARAMS_MAX; i++)
+		param->params[i] = cpu_to_le32(c->ap_params[i]);
 	param->param_idx = CONF_SG_PARAMS_ALL;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 0a40cae..b35ebf5 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -370,14 +370,23 @@ struct acx_bt_wlan_coex {
 	u8 pad[3];
 } __packed;
 
-struct acx_bt_wlan_coex_param {
+struct acx_sta_bt_wlan_coex_param {
 	struct acx_header header;
 
-	__le32 params[CONF_SG_PARAMS_MAX];
+	__le32 params[CONF_SG_STA_PARAMS_MAX];
 	u8 param_idx;
 	u8 padding[3];
 } __packed;
 
+struct acx_ap_bt_wlan_coex_param {
+	struct acx_header header;
+
+	__le32 params[CONF_SG_AP_PARAMS_MAX];
+	u8 param_idx;
+	u8 padding[3];
+} __packed;
+
+
 struct acx_dco_itrim_params {
 	struct acx_header header;
 
@@ -1263,7 +1272,8 @@ int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
 int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable);
 int wl1271_acx_sg_enable(struct wl1271 *wl, bool enable);
-int wl1271_acx_sg_cfg(struct wl1271 *wl);
+int wl1271_acx_sta_sg_cfg(struct wl1271 *wl);
+int wl1271_acx_ap_sg_cfg(struct wl1271 *wl);
 int wl1271_acx_cca_threshold(struct wl1271 *wl);
 int wl1271_acx_bcn_dtim_options(struct wl1271 *wl);
 int wl1271_acx_aid(struct wl1271 *wl, u16 aid);
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 743bd0b..0c1d0c7 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -396,12 +396,43 @@ enum {
 	CONF_SG_TEMP_PARAM_3,
 	CONF_SG_TEMP_PARAM_4,
 	CONF_SG_TEMP_PARAM_5,
-	CONF_SG_PARAMS_MAX,
+
+	/*
+	 * AP beacon miss
+	 *
+	 * Range: 0 - 255
+	 */
+	CONF_SG_AP_BEACON_MISS_TX,
+
+	/*
+	 * AP RX window length
+	 *
+	 * Range: 0 - 50
+	 */
+	CONF_SG_RX_WINDOW_LENGTH,
+
+	/*
+	 * AP connection protection time
+	 *
+	 * Range: 0 - 5000
+	 */
+	CONF_SG_AP_CONNECTION_PROTECTION_TIME,
+
+	CONF_SG_TEMP_PARAM_6,
+	CONF_SG_TEMP_PARAM_7,
+	CONF_SG_TEMP_PARAM_8,
+	CONF_SG_TEMP_PARAM_9,
+	CONF_SG_TEMP_PARAM_10,
+
+	CONF_SG_STA_PARAMS_MAX = CONF_SG_TEMP_PARAM_5 + 1,
+	CONF_SG_AP_PARAMS_MAX = CONF_SG_TEMP_PARAM_10 + 1,
+
 	CONF_SG_PARAMS_ALL = 0xff
 };
 
 struct conf_sg_settings {
-	u32 params[CONF_SG_PARAMS_MAX];
+	u32 sta_params[CONF_SG_STA_PARAMS_MAX];
+	u32 ap_params[CONF_SG_AP_PARAMS_MAX];
 	u8 state;
 };
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index cf46607..e8c979d 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -285,7 +285,10 @@ int wl1271_init_pta(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl1271_acx_sg_cfg(wl);
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		ret = wl1271_acx_ap_sg_cfg(wl);
+	else
+		ret = wl1271_acx_sta_sg_cfg(wl);
 	if (ret < 0)
 		return ret;
 
@@ -351,11 +354,6 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	/* Bluetooth WLAN coexistence */
-	ret = wl1271_init_pta(wl);
-	if (ret < 0)
-		return ret;
-
 	/* Beacons and broadcast settings */
 	ret = wl1271_init_beacon_broadcast(wl);
 	if (ret < 0)
@@ -563,6 +561,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* Bluetooth WLAN coexistence */
+	ret = wl1271_init_pta(wl);
+	if (ret < 0)
+		return ret;
+
 	/* Default memory configuration */
 	ret = wl1271_acx_init_mem_config(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..1c206ae 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -51,7 +51,7 @@
 
 static struct conf_drv_settings default_conf = {
 	.sg = {
-		.params = {
+		.sta_params = {
 			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
 			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
 			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
@@ -101,6 +101,61 @@ static struct conf_drv_settings default_conf = {
 			[CONF_SG_DHCP_TIME]                         = 5000,
 			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP]  = 100,
 		},
+		.ap_params = {
+			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
+			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
+			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
+			[CONF_SG_BT_LOAD_RATIO]                     = 50,
+			[CONF_SG_AUTO_PS_MODE]                      = 1,
+			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
+			[CONF_SG_ANTENNA_CONFIGURATION]             = 0,
+			[CONF_SG_BEACON_MISS_PERCENT]               = 60,
+			[CONF_SG_RATE_ADAPT_THRESH]                 = 64,
+			[CONF_SG_RATE_ADAPT_SNR]                    = 1,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR]      = 10,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR]      = 25,
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR]      = 25,
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR]       = 20,
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR]       = 25,
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR]       = 25,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR]     = 7,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR]     = 25,
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR]     = 25,
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR]      = 8,
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR]      = 25,
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR]      = 25,
+			[CONF_SG_RXT]                               = 1200,
+			[CONF_SG_TXT]                               = 1000,
+			[CONF_SG_ADAPTIVE_RXT_TXT]                  = 1,
+			[CONF_SG_PS_POLL_TIMEOUT]                   = 10,
+			[CONF_SG_UPSD_TIMEOUT]                      = 10,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR] = 7,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR] = 15,
+			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR] = 15,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR]  = 8,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR]  = 20,
+			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR]  = 15,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MIN_BR]         = 20,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MAX_BR]         = 50,
+			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_BR]         = 10,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3]  = 200,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP] = 800,
+			[CONF_SG_PASSIVE_SCAN_A2DP_BT_TIME]         = 75,
+			[CONF_SG_PASSIVE_SCAN_A2DP_WLAN_TIME]       = 15,
+			[CONF_SG_HV3_MAX_SERVED]                    = 6,
+			[CONF_SG_DHCP_TIME]                         = 5000,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP]  = 100,
+			[CONF_SG_TEMP_PARAM_1]                      = 0,
+			[CONF_SG_TEMP_PARAM_2]                      = 0,
+			[CONF_SG_TEMP_PARAM_3]                      = 0,
+			[CONF_SG_TEMP_PARAM_4]                      = 0,
+			[CONF_SG_TEMP_PARAM_5]                      = 0,
+			[CONF_SG_AP_BEACON_MISS_TX]                 = 3,
+			[CONF_SG_RX_WINDOW_LENGTH]                  = 6,
+			[CONF_SG_AP_CONNECTION_PROTECTION_TIME]     = 50,
+			[CONF_SG_TEMP_PARAM_6]                      = 1,
+		},
 		.state = CONF_SG_PROTECTIVE,
 	},
 	.rx = {
-- 
1.7.1

