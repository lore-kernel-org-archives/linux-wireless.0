Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34417 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab1CFO2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:14 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESDd8005601
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:13 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 04/15] wl12xx: 1281/1283 support - New radio struc & func
Date: Sun,  6 Mar 2011 16:32:09 +0200
Message-Id: <1299421940-26292-5-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New general radio parameters structures & functions.
Implemented as separate functions due to auto-detection
between wl127x and wl128x.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |   86 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/cmd.h  |   34 +++++++++++++
 drivers/net/wireless/wl12xx/ini.h  |   96 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/init.c |   18 +++++--
 drivers/net/wireless/wl12xx/main.c |   16 +++++-
 5 files changed, 240 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index f0aa7ab..37eb9f3 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -110,7 +110,47 @@ out:
 int wl1271_cmd_general_parms(struct wl1271 *wl)
 {
 	struct wl1271_general_parms_cmd *gen_parms;
-	struct wl1271_ini_general_params *gp = &wl->nvs->general_params;
+	struct wl1271_ini_general_params *gp =
+		&((struct wl1271_nvs_file *)wl->nvs)->general_params;
+	bool answer = false;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
+	if (!gen_parms)
+		return -ENOMEM;
+
+	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
+
+	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
+
+	if (gp->tx_bip_fem_auto_detect)
+		answer = true;
+
+	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
+	if (ret < 0) {
+		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
+		goto out;
+	}
+
+	gp->tx_bip_fem_manufacturer =
+		gen_parms->general_params.tx_bip_fem_manufacturer;
+
+	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
+		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
+
+out:
+	kfree(gen_parms);
+	return ret;
+}
+
+int wl128x_cmd_general_parms(struct wl1271 *wl)
+{
+	struct wl128x_general_parms_cmd *gen_parms;
+	struct wl128x_ini_general_params *gp =
+		&((struct wl128x_nvs_file *)wl->nvs)->general_params;
 	bool answer = false;
 	int ret;
 
@@ -186,6 +226,50 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	return ret;
 }
 
+int wl128x_cmd_radio_parms(struct wl1271 *wl)
+{
+	struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
+	struct wl128x_radio_parms_cmd *radio_parms;
+	struct wl128x_ini_general_params *gp = &nvs->general_params;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
+	if (!radio_parms)
+		return -ENOMEM;
+
+	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
+
+	/* 2.4GHz parameters */
+	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
+	       sizeof(struct wl128x_ini_band_params_2));
+	memcpy(&radio_parms->dyn_params_2,
+	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
+	       sizeof(struct wl128x_ini_fem_params_2));
+
+	/* 5GHz parameters */
+	memcpy(&radio_parms->static_params_5,
+	       &nvs->stat_radio_params_5,
+	       sizeof(struct wl128x_ini_band_params_5));
+	memcpy(&radio_parms->dyn_params_5,
+	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
+	       sizeof(struct wl128x_ini_fem_params_5));
+
+	radio_parms->fem_vendor_and_options = nvs->fem_vendor_and_options;
+
+	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
+		    radio_parms, sizeof(*radio_parms));
+
+	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
+	if (ret < 0)
+		wl1271_warning("CMD_INI_FILE_RADIO_PARAM failed");
+
+	kfree(radio_parms);
+	return ret;
+}
+
 int wl1271_cmd_ext_radio_parms(struct wl1271 *wl)
 {
 	struct wl1271_ext_radio_parms_cmd *ext_radio_parms;
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 54c12e7..5cac95d 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -32,7 +32,9 @@ struct acx_header;
 int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
 int wl1271_cmd_general_parms(struct wl1271 *wl);
+int wl128x_cmd_general_parms(struct wl1271 *wl);
 int wl1271_cmd_radio_parms(struct wl1271 *wl);
+int wl128x_cmd_radio_parms(struct wl1271 *wl);
 int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
 int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
@@ -415,6 +417,21 @@ struct wl1271_general_parms_cmd {
 	u8 padding[3];
 } __packed;
 
+struct wl128x_general_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	struct wl128x_ini_general_params general_params;
+
+	u8 sr_debug_table[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 sr_sen_n_p;
+	u8 sr_sen_n_p_gain;
+	u8 sr_sen_nrn;
+	u8 sr_sen_prn;
+	u8 padding[3];
+} __packed;
+
 struct wl1271_radio_parms_cmd {
 	struct wl1271_cmd_header header;
 
@@ -431,6 +448,23 @@ struct wl1271_radio_parms_cmd {
 	u8 padding3[2];
 } __packed;
 
+struct wl128x_radio_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	/* Static radio parameters */
+	struct wl128x_ini_band_params_2 static_params_2;
+	struct wl128x_ini_band_params_5 static_params_5;
+
+	u8 fem_vendor_and_options;
+
+	/* Dynamic radio parameters */
+	struct wl128x_ini_fem_params_2 dyn_params_2;
+	u8 padding2;
+	struct wl128x_ini_fem_params_5 dyn_params_5;
+} __packed;
+
 struct wl1271_ext_radio_parms_cmd {
 	struct wl1271_cmd_header header;
 
diff --git a/drivers/net/wireless/wl12xx/ini.h b/drivers/net/wireless/wl12xx/ini.h
index c330a25..30efcd6 100644
--- a/drivers/net/wireless/wl12xx/ini.h
+++ b/drivers/net/wireless/wl12xx/ini.h
@@ -41,6 +41,28 @@ struct wl1271_ini_general_params {
 	u8 srf3[WL1271_INI_MAX_SMART_REFLEX_PARAM];
 } __packed;
 
+#define WL128X_INI_MAX_SETTINGS_PARAM 4
+
+struct wl128x_ini_general_params {
+	u8 ref_clock;
+	u8 settling_time;
+	u8 clk_valid_on_wakeup;
+	u8 tcxo_ref_clock;
+	u8 tcxo_settling_time;
+	u8 tcxo_valid_on_wakeup;
+	u8 tcxo_ldo_voltage;
+	u8 xtal_itrim_val;
+	u8 platform_conf;
+	u8 dual_mode_select;
+	u8 tx_bip_fem_auto_detect;
+	u8 tx_bip_fem_manufacturer;
+	u8 general_settings[WL128X_INI_MAX_SETTINGS_PARAM];
+	u8 sr_state;
+	u8 srf1[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 srf2[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 srf3[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+} __packed;
+
 #define WL1271_INI_RSSI_PROCESS_COMPENS_SIZE 15
 
 struct wl1271_ini_band_params_2 {
@@ -49,9 +71,16 @@ struct wl1271_ini_band_params_2 {
 	u8 rx_rssi_process_compens[WL1271_INI_RSSI_PROCESS_COMPENS_SIZE];
 } __packed;
 
-#define WL1271_INI_RATE_GROUP_COUNT 6
 #define WL1271_INI_CHANNEL_COUNT_2 14
 
+struct wl128x_ini_band_params_2 {
+	u8 rx_trace_insertion_loss;
+	u8 tx_trace_loss[WL1271_INI_CHANNEL_COUNT_2];
+	u8 rx_rssi_process_compens[WL1271_INI_RSSI_PROCESS_COMPENS_SIZE];
+} __packed;
+
+#define WL1271_INI_RATE_GROUP_COUNT 6
+
 struct wl1271_ini_fem_params_2 {
 	__le16 tx_bip_ref_pd_voltage;
 	u8 tx_bip_ref_power;
@@ -68,6 +97,28 @@ struct wl1271_ini_fem_params_2 {
 	u8 normal_to_degraded_high_thr;
 } __packed;
 
+#define WL128X_INI_RATE_GROUP_COUNT 7
+/* low and high temperatures */
+#define WL128X_INI_PD_VS_TEMPERATURE_RANGES 2
+
+struct wl128x_ini_fem_params_2 {
+	__le16 tx_bip_ref_pd_voltage;
+	u8 tx_bip_ref_power;
+	u8 tx_bip_ref_offset;
+	u8 tx_per_rate_pwr_limits_normal[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_degraded[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_extreme[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_per_chan_pwr_limits_11b[WL1271_INI_CHANNEL_COUNT_2];
+	u8 tx_per_chan_pwr_limits_ofdm[WL1271_INI_CHANNEL_COUNT_2];
+	u8 tx_pd_vs_rate_offsets[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_ibias[WL128X_INI_RATE_GROUP_COUNT + 1];
+	u8 tx_pd_vs_chan_offsets[WL1271_INI_CHANNEL_COUNT_2];
+	u8 tx_pd_vs_temperature[WL128X_INI_PD_VS_TEMPERATURE_RANGES];
+	u8 rx_fem_insertion_loss;
+	u8 degraded_low_to_normal_thr;
+	u8 normal_to_degraded_high_thr;
+} __packed;
+
 #define WL1271_INI_CHANNEL_COUNT_5 35
 #define WL1271_INI_SUB_BAND_COUNT_5 7
 
@@ -77,6 +128,12 @@ struct wl1271_ini_band_params_5 {
 	u8 rx_rssi_process_compens[WL1271_INI_RSSI_PROCESS_COMPENS_SIZE];
 } __packed;
 
+struct wl128x_ini_band_params_5 {
+	u8 rx_trace_insertion_loss[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_trace_loss[WL1271_INI_CHANNEL_COUNT_5];
+	u8 rx_rssi_process_compens[WL1271_INI_RSSI_PROCESS_COMPENS_SIZE];
+} __packed;
+
 struct wl1271_ini_fem_params_5 {
 	__le16 tx_bip_ref_pd_voltage[WL1271_INI_SUB_BAND_COUNT_5];
 	u8 tx_bip_ref_power[WL1271_INI_SUB_BAND_COUNT_5];
@@ -92,6 +149,23 @@ struct wl1271_ini_fem_params_5 {
 	u8 normal_to_degraded_high_thr;
 } __packed;
 
+struct wl128x_ini_fem_params_5 {
+	__le16 tx_bip_ref_pd_voltage[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_bip_ref_power[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_bip_ref_offset[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_per_rate_pwr_limits_normal[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_degraded[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_extreme[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_per_chan_pwr_limits_ofdm[WL1271_INI_CHANNEL_COUNT_5];
+	u8 tx_pd_vs_rate_offsets[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_ibias[WL128X_INI_RATE_GROUP_COUNT];
+	u8 tx_pd_vs_chan_offsets[WL1271_INI_CHANNEL_COUNT_5];
+	u8 tx_pd_vs_temperature[WL1271_INI_SUB_BAND_COUNT_5 *
+		WL128X_INI_PD_VS_TEMPERATURE_RANGES];
+	u8 rx_fem_insertion_loss[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 degraded_low_to_normal_thr;
+	u8 normal_to_degraded_high_thr;
+} __packed;
 
 /* NVS data structure */
 #define WL1271_INI_NVS_SECTION_SIZE		     468
@@ -120,4 +194,24 @@ struct wl1271_nvs_file {
 	} dyn_radio_params_5[WL1271_INI_FEM_MODULE_COUNT];
 } __packed;
 
+struct wl128x_nvs_file {
+	/* NVS section */
+	u8 nvs[WL1271_INI_NVS_SECTION_SIZE];
+
+	/* INI section */
+	struct wl128x_ini_general_params general_params;
+	u8 fem_vendor_and_options;
+	struct wl128x_ini_band_params_2 stat_radio_params_2;
+	u8 padding2;
+	struct {
+		struct wl128x_ini_fem_params_2 params;
+		u8 padding;
+	} dyn_radio_params_2[WL1271_INI_FEM_MODULE_COUNT];
+	struct wl128x_ini_band_params_5 stat_radio_params_5;
+	u8 padding3;
+	struct {
+		struct wl128x_ini_fem_params_5 params;
+		u8 padding;
+	} dyn_radio_params_5[WL1271_INI_FEM_MODULE_COUNT];
+} __packed;
 #endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 2f31d14..3676082 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -322,9 +322,11 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl1271_cmd_ext_radio_parms(wl);
-	if (ret < 0)
-		return ret;
+	if (wl->chip.id != CHIP_ID_1283_PG20) {
+		ret = wl1271_cmd_ext_radio_parms(wl);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* PS config */
 	ret = wl1271_acx_config_ps(wl);
@@ -512,11 +514,17 @@ int wl1271_hw_init(struct wl1271 *wl)
 	int ret, i;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
-	ret = wl1271_cmd_general_parms(wl);
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		ret = wl128x_cmd_general_parms(wl);
+	else
+		ret = wl1271_cmd_general_parms(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_radio_parms(wl);
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		ret = wl128x_cmd_radio_parms(wl);
+	else
+		ret = wl1271_cmd_radio_parms(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ac0513a..0a23a9e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -438,15 +438,25 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	struct conf_tx_tid *conf_tid;
 	int ret, i;
 
-	ret = wl1271_cmd_general_parms(wl);
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		ret = wl128x_cmd_general_parms(wl);
+	else
+		ret = wl1271_cmd_general_parms(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_radio_parms(wl);
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		ret = wl128x_cmd_radio_parms(wl);
+	else
+		ret = wl1271_cmd_radio_parms(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_ext_radio_parms(wl);
+	if (wl->chip.id != CHIP_ID_1283_PG20) {
+		ret = wl1271_cmd_ext_radio_parms(wl);
+		if (ret < 0)
+			return ret;
+	}
 	if (ret < 0)
 		return ret;
 
-- 
1.7.0.4

