Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50760 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0BRL2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:22 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/22] wl1271: Use NVS INI file configuration
Date: Thu, 18 Feb 2010 13:25:42 +0200
Message-Id: <1266492357-462-8-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the hardcoded general and radio parameter configuration in the driver
with configuration taken from the NVS file directly. Also remove the driver
dependency to the structures with the parameter data.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |   32 ++++++-
 drivers/net/wireless/wl12xx/wl1271_boot.c |   29 ++----
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |  117 ++++--------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |   86 ++---------------
 drivers/net/wireless/wl12xx/wl1271_conf.h |  144 +----------------------------
 drivers/net/wireless/wl12xx/wl1271_main.c |  101 +-------------------
 6 files changed, 77 insertions(+), 432 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index d0938db..b3a3402 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -109,7 +109,33 @@ enum {
 
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
-#define WL1271_NVS_LEN  468
+
+/* NVS data structure */
+#define WL1271_NVS_SECTION_SIZE                  468
+
+#define WL1271_NVS_GENERAL_PARAMS_SIZE            57
+#define WL1271_NVS_GENERAL_PARAMS_SIZE_PADDED \
+	(WL1271_NVS_GENERAL_PARAMS_SIZE + 1)
+#define WL1271_NVS_STAT_RADIO_PARAMS_SIZE         17
+#define WL1271_NVS_STAT_RADIO_PARAMS_SIZE_PADDED \
+	(WL1271_NVS_STAT_RADIO_PARAMS_SIZE + 1)
+#define WL1271_NVS_DYN_RADIO_PARAMS_SIZE          65
+#define WL1271_NVS_DYN_RADIO_PARAMS_SIZE_PADDED \
+	(WL1271_NVS_DYN_RADIO_PARAMS_SIZE + 1)
+#define WL1271_NVS_FEM_COUNT                       2
+#define WL1271_NVS_INI_SPARE_SIZE                124
+
+struct wl1271_nvs_file {
+	/* NVS section */
+	u8 nvs[WL1271_NVS_SECTION_SIZE];
+
+	/* INI section */
+	u8 general_params[WL1271_NVS_GENERAL_PARAMS_SIZE_PADDED];
+	u8 stat_radio_params[WL1271_NVS_STAT_RADIO_PARAMS_SIZE_PADDED];
+	u8 dyn_radio_params[WL1271_NVS_FEM_COUNT]
+			   [WL1271_NVS_DYN_RADIO_PARAMS_SIZE_PADDED];
+	u8 ini_spare[WL1271_NVS_INI_SPARE_SIZE];
+} __attribute__ ((packed));
 
 /*
  * Enable/disable 802.11a support for WL1273
@@ -342,8 +368,7 @@ struct wl1271 {
 
 	u8 *fw;
 	size_t fw_len;
-	u8 *nvs;
-	size_t nvs_len;
+	struct wl1271_nvs_file *nvs;
 
 	u8 bssid[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
@@ -461,6 +486,7 @@ int wl1271_plt_stop(struct wl1271 *wl);
 
 static inline bool wl1271_11a_enabled(void)
 {
+	/* FIXME: this could be determined based on the NVS-INI file */
 #ifdef WL1271_80211A_ENABLED
 	return true;
 #else
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index e803b87..bc3fe02 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -219,29 +219,22 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	size_t nvs_len, burst_len;
 	int i;
 	u32 dest_addr, val;
-	u8 *nvs_ptr, *nvs, *nvs_aligned;
+	u8 *nvs_ptr, *nvs_aligned;
 
-	nvs = wl->nvs;
-	if (nvs == NULL)
+	if (wl->nvs == NULL)
 		return -ENODEV;
 
-	if (wl->nvs_len < WL1271_NVS_LEN)
-		return -EINVAL;
-
-	nvs_ptr = nvs;
-
 	/* only the first part of the NVS needs to be uploaded */
-	nvs_len = WL1271_NVS_LEN;
-
-	/* FIXME: read init settings from the remaining part of the NVS */
+	nvs_len = sizeof(wl->nvs->nvs);
+	nvs_ptr = (u8 *)wl->nvs->nvs;
 
 	/* Update the device MAC address into the nvs */
-	nvs[11] = wl->mac_addr[0];
-	nvs[10] = wl->mac_addr[1];
-	nvs[6] = wl->mac_addr[2];
-	nvs[5] = wl->mac_addr[3];
-	nvs[4] = wl->mac_addr[4];
-	nvs[3] = wl->mac_addr[5];
+	nvs_ptr[11] = wl->mac_addr[0];
+	nvs_ptr[10] = wl->mac_addr[1];
+	nvs_ptr[6] = wl->mac_addr[2];
+	nvs_ptr[5] = wl->mac_addr[3];
+	nvs_ptr[4] = wl->mac_addr[4];
+	nvs_ptr[3] = wl->mac_addr[5];
 
 	/*
 	 * Layout before the actual NVS tables:
@@ -283,7 +276,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	 * is 7 bytes further.
 	 */
 	nvs_ptr += 7;
-	nvs_len -= nvs_ptr - nvs;
+	nvs_len -= nvs_ptr - (u8 *)wl->nvs->nvs;
 	nvs_len = ALIGN(nvs_len, 4);
 
 	/* FIXME: The driver sets the partition here, but this is not needed,
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index dd2b5f0..54b5124 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -191,43 +191,19 @@ static int wl1271_cmd_cal(struct wl1271 *wl)
 int wl1271_cmd_general_parms(struct wl1271 *wl)
 {
 	struct wl1271_general_parms_cmd *gen_parms;
-	struct conf_general_parms *g = &wl->conf.init.genparam;
 	int ret;
 
+	if (!wl->nvs)
+		return -ENODEV;
+
 	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
 	if (!gen_parms)
 		return -ENOMEM;
 
 	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
 
-	gen_parms->ref_clk = g->ref_clk;
-	gen_parms->settling_time = g->settling_time;
-	gen_parms->clk_valid_on_wakeup = g->clk_valid_on_wakeup;
-	gen_parms->dc2dcmode = g->dc2dcmode;
-	gen_parms->single_dual_band = g->single_dual_band;
-	gen_parms->tx_bip_fem_autodetect = g->tx_bip_fem_autodetect;
-	gen_parms->tx_bip_fem_manufacturer = g->tx_bip_fem_manufacturer;
-	gen_parms->settings = g->settings;
-
-	gen_parms->sr_state = g->sr_state;
-
-	memcpy(gen_parms->srf1,
-	       g->srf1,
-	       CONF_MAX_SMART_REFLEX_PARAMS);
-	memcpy(gen_parms->srf2,
-	       g->srf2,
-	       CONF_MAX_SMART_REFLEX_PARAMS);
-	memcpy(gen_parms->srf3,
-	       g->srf3,
-	       CONF_MAX_SMART_REFLEX_PARAMS);
-	memcpy(gen_parms->sr_debug_table,
-	       g->sr_debug_table,
-	       CONF_MAX_SMART_REFLEX_PARAMS);
-
-	gen_parms->sr_sen_n_p = g->sr_sen_n_p;
-	gen_parms->sr_sen_n_p_gain = g->sr_sen_n_p_gain;
-	gen_parms->sr_sen_nrn = g->sr_sen_nrn;
-	gen_parms->sr_sen_prn = g->sr_sen_prn;
+	memcpy(gen_parms->params, wl->nvs->general_params,
+	       WL1271_NVS_GENERAL_PARAMS_SIZE);
 
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
 	if (ret < 0)
@@ -240,8 +216,11 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 int wl1271_cmd_radio_parms(struct wl1271 *wl)
 {
 	struct wl1271_radio_parms_cmd *radio_parms;
-	struct conf_radio_parms *r = &wl->conf.init.radioparam;
-	int i, ret;
+	struct conf_radio_parms *rparam = &wl->conf.init.radioparam;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
 
 	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
 	if (!radio_parms)
@@ -249,73 +228,13 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 
 	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
 
-	/* Static radio parameters */
-	radio_parms->rx_trace_loss = r->rx_trace_loss;
-	radio_parms->tx_trace_loss = r->tx_trace_loss;
-	memcpy(radio_parms->rx_rssi_and_proc_compens,
-	       r->rx_rssi_and_proc_compens,
-	       CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE);
-
-	memcpy(radio_parms->rx_trace_loss_5, r->rx_trace_loss_5,
-	       CONF_NUMBER_OF_SUB_BANDS_5);
-	memcpy(radio_parms->tx_trace_loss_5, r->tx_trace_loss_5,
-	       CONF_NUMBER_OF_SUB_BANDS_5);
-	memcpy(radio_parms->rx_rssi_and_proc_compens_5,
-	       r->rx_rssi_and_proc_compens_5,
-	       CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE);
-
-	/* Dynamic radio parameters */
-	radio_parms->tx_ref_pd_voltage = cpu_to_le16(r->tx_ref_pd_voltage);
-	radio_parms->tx_ref_power = r->tx_ref_power;
-	radio_parms->tx_offset_db = r->tx_offset_db;
-
-	memcpy(radio_parms->tx_rate_limits_normal, r->tx_rate_limits_normal,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_rate_limits_degraded, r->tx_rate_limits_degraded,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_rate_limits_extreme, r->tx_rate_limits_extreme,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-
-	memcpy(radio_parms->tx_channel_limits_11b, r->tx_channel_limits_11b,
-	       CONF_NUMBER_OF_CHANNELS_2_4);
-	memcpy(radio_parms->tx_channel_limits_ofdm, r->tx_channel_limits_ofdm,
-	       CONF_NUMBER_OF_CHANNELS_2_4);
-	memcpy(radio_parms->tx_pdv_rate_offsets, r->tx_pdv_rate_offsets,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_ibias, r->tx_ibias, CONF_NUMBER_OF_RATE_GROUPS);
-
-	radio_parms->rx_fem_insertion_loss = r->rx_fem_insertion_loss;
-	radio_parms->degraded_low_to_normal_threshold =
-		r->degraded_low_to_normal_threshold;
-	radio_parms->degraded_normal_to_high_threshold =
-		r->degraded_normal_to_high_threshold;
-
-
-	for (i = 0; i < CONF_NUMBER_OF_SUB_BANDS_5; i++)
-		radio_parms->tx_ref_pd_voltage_5[i] =
-			cpu_to_le16(r->tx_ref_pd_voltage_5[i]);
-	memcpy(radio_parms->tx_ref_power_5, r->tx_ref_power_5,
-	       CONF_NUMBER_OF_SUB_BANDS_5);
-	memcpy(radio_parms->tx_offset_db_5, r->tx_offset_db_5,
-	       CONF_NUMBER_OF_SUB_BANDS_5);
-	memcpy(radio_parms->tx_rate_limits_normal_5,
-	       r->tx_rate_limits_normal_5, CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_rate_limits_degraded_5,
-	       r->tx_rate_limits_degraded_5, CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_rate_limits_extreme_5,
-	       r->tx_rate_limits_extreme_5, CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_channel_limits_ofdm_5,
-	       r->tx_channel_limits_ofdm_5, CONF_NUMBER_OF_CHANNELS_5);
-	memcpy(radio_parms->tx_pdv_rate_offsets_5, r->tx_pdv_rate_offsets_5,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_ibias_5, r->tx_ibias_5,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->rx_fem_insertion_loss_5,
-	       r->rx_fem_insertion_loss_5, CONF_NUMBER_OF_SUB_BANDS_5);
-	radio_parms->degraded_low_to_normal_threshold_5 =
-		r->degraded_low_to_normal_threshold_5;
-	radio_parms->degraded_normal_to_high_threshold_5 =
-		r->degraded_normal_to_high_threshold_5;
+	memcpy(radio_parms->stat_radio_params, wl->nvs->stat_radio_params,
+	       WL1271_NVS_STAT_RADIO_PARAMS_SIZE);
+	memcpy(radio_parms->dyn_radio_params,
+	       wl->nvs->dyn_radio_params[rparam->fem],
+	       WL1271_NVS_DYN_RADIO_PARAMS_SIZE);
+
+	/* FIXME: current NVS is missing 5GHz parameters */
 
 	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
 		    radio_parms, sizeof(*radio_parms));
@@ -1022,7 +941,7 @@ int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_warning("could not set keys");
-		goto out;
+	goto out;
 	}
 
 out:
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index ba433f4..2dc06c7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -428,90 +428,24 @@ struct wl1271_general_parms_cmd {
 
 	struct wl1271_cmd_test_header test;
 
-	u8 ref_clk;
-	u8 settling_time;
-	u8 clk_valid_on_wakeup;
-	u8 dc2dcmode;
-	u8 single_dual_band;
-
-	u8 tx_bip_fem_autodetect;
-	u8 tx_bip_fem_manufacturer;
-	u8 settings;
-
-	u8 sr_state;
-
-	s8 srf1[CONF_MAX_SMART_REFLEX_PARAMS];
-	s8 srf2[CONF_MAX_SMART_REFLEX_PARAMS];
-	s8 srf3[CONF_MAX_SMART_REFLEX_PARAMS];
-
-	s8 sr_debug_table[CONF_MAX_SMART_REFLEX_PARAMS];
-
-	u8 sr_sen_n_p;
-	u8 sr_sen_n_p_gain;
-	u8 sr_sen_nrn;
-	u8 sr_sen_prn;
-
-	u8 padding[3];
+	u8 params[WL1271_NVS_GENERAL_PARAMS_SIZE];
+	s8 reserved[23];
 } __attribute__ ((packed));
 
+#define WL1271_STAT_RADIO_PARAMS_5_SIZE    29
+#define WL1271_DYN_RADIO_PARAMS_5_SIZE    104
+
 struct wl1271_radio_parms_cmd {
 	struct wl1271_cmd_header header;
 
 	struct wl1271_cmd_test_header test;
 
-	/* Static radio parameters */
-	/* 2.4GHz */
-	u8 rx_trace_loss;
-	u8 tx_trace_loss;
-	s8 rx_rssi_and_proc_compens[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
-
-	/* 5GHz */
-	u8 rx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	u8 tx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8 rx_rssi_and_proc_compens_5[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
-
-	/* Dynamic radio parameters */
-	/* 2.4GHz */
-	__le16 tx_ref_pd_voltage;
-	u8  tx_ref_power;
-	s8  tx_offset_db;
-
-	s8  tx_rate_limits_normal[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_extreme[CONF_NUMBER_OF_RATE_GROUPS];
+	u8 stat_radio_params[WL1271_NVS_STAT_RADIO_PARAMS_SIZE];
+	u8 stat_radio_params_5[WL1271_STAT_RADIO_PARAMS_5_SIZE];
 
-	s8  tx_channel_limits_11b[CONF_NUMBER_OF_CHANNELS_2_4];
-	s8  tx_channel_limits_ofdm[CONF_NUMBER_OF_CHANNELS_2_4];
-	s8  tx_pdv_rate_offsets[CONF_NUMBER_OF_RATE_GROUPS];
-
-	u8  tx_ibias[CONF_NUMBER_OF_RATE_GROUPS];
-	u8  rx_fem_insertion_loss;
-
-	u8  degraded_low_to_normal_threshold;
-	u8  degraded_normal_to_high_threshold;
-
-	u8  padding1; /* our own padding, not in ref driver */
-
-	/* 5GHz */
-	__le16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	u8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
-
-	s8  tx_rate_limits_normal_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_extreme_5[CONF_NUMBER_OF_RATE_GROUPS];
-
-	s8  tx_channel_limits_ofdm_5[CONF_NUMBER_OF_CHANNELS_5];
-	s8  tx_pdv_rate_offsets_5[CONF_NUMBER_OF_RATE_GROUPS];
-
-	/* FIXME: this is inconsistent with the types for 2.4GHz */
-	s8  tx_ibias_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  rx_fem_insertion_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
-
-	u8  degraded_low_to_normal_threshold_5;
-	u8  degraded_normal_to_high_threshold_5;
-
-	u8 padding2[2];
+	u8 dyn_radio_params[WL1271_NVS_DYN_RADIO_PARAMS_SIZE];
+	u8 reserved;
+	u8 dyn_radio_params_5[WL1271_DYN_RADIO_PARAMS_5_SIZE];
 } __attribute__ ((packed));
 
 struct wl1271_cmd_cal_channel_tune {
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 1993d63..6f9e75c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -735,81 +735,6 @@ enum single_dual_band_enum {
 	CONF_DUAL_BAND
 };
 
-
-#define CONF_MAX_SMART_REFLEX_PARAMS 16
-
-struct conf_general_parms {
-	/*
-	 * RF Reference Clock type / speed
-	 *
-	 * Range: CONF_REF_CLK_*
-	 */
-	u8 ref_clk;
-
-	/*
-	 * Settling time of the reference clock after boot.
-	 *
-	 * Range: u8
-	 */
-	u8 settling_time;
-
-	/*
-	 * Flag defining whether clock is valid on wakeup.
-	 *
-	 * Range: 0 - not valid on wakeup, 1 - valid on wakeup
-	 */
-	u8 clk_valid_on_wakeup;
-
-	/*
-	 * DC-to-DC mode.
-	 *
-	 * Range: Unknown
-	 */
-	u8 dc2dcmode;
-
-	/*
-	 * Flag defining whether used as single or dual-band.
-	 *
-	 * Range: CONF_SINGLE_BAND, CONF_DUAL_BAND
-	 */
-	u8 single_dual_band;
-
-	/*
-	 * TX bip fem autodetect flag.
-	 *
-	 * Range: Unknown
-	 */
-	u8 tx_bip_fem_autodetect;
-
-	/*
-	 * TX bip gem manufacturer.
-	 *
-	 * Range: Unknown
-	 */
-	u8 tx_bip_fem_manufacturer;
-
-	/*
-	 * Settings flags.
-	 *
-	 * Range: Unknown
-	 */
-	u8 settings;
-
-	/* Smart reflex settings */
-	u8 sr_state;
-
-	s8 srf1[CONF_MAX_SMART_REFLEX_PARAMS];
-	s8 srf2[CONF_MAX_SMART_REFLEX_PARAMS];
-	s8 srf3[CONF_MAX_SMART_REFLEX_PARAMS];
-
-	s8 sr_debug_table[CONF_MAX_SMART_REFLEX_PARAMS];
-
-	u8 sr_sen_n_p;
-	u8 sr_sen_n_p_gain;
-	u8 sr_sen_nrn;
-	u8 sr_sen_prn;
-};
-
 #define CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE 15
 #define CONF_NUMBER_OF_SUB_BANDS_5  7
 #define CONF_NUMBER_OF_RATE_GROUPS  6
@@ -818,78 +743,15 @@ struct conf_general_parms {
 
 struct conf_radio_parms {
 	/*
-	 * Static radio parameters for 2.4GHz
-	 *
-	 * Range: unknown
-	 */
-	u8 rx_trace_loss;
-	u8 tx_trace_loss;
-	s8 rx_rssi_and_proc_compens[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
-
-	/*
-	 * Static radio parameters for 5GHz
-	 *
-	 * Range: unknown
-	 */
-	u8 rx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	u8 tx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8 rx_rssi_and_proc_compens_5[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
-
-	/*
-	 * Dynamic radio parameters for 2.4GHz
+	 * FEM parameter set to use
 	 *
-	 * Range: unknown
+	 * Range: 0 or 1
 	 */
-	u16 tx_ref_pd_voltage;
-	u8  tx_ref_power;
-	s8  tx_offset_db;
-
-	s8  tx_rate_limits_normal[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_extreme[CONF_NUMBER_OF_RATE_GROUPS];
-
-	s8  tx_channel_limits_11b[CONF_NUMBER_OF_CHANNELS_2_4];
-	s8  tx_channel_limits_ofdm[CONF_NUMBER_OF_CHANNELS_2_4];
-	s8  tx_pdv_rate_offsets[CONF_NUMBER_OF_RATE_GROUPS];
-
-	u8  tx_ibias[CONF_NUMBER_OF_RATE_GROUPS];
-	u8  rx_fem_insertion_loss;
-
-	u8  degraded_low_to_normal_threshold;
-	u8  degraded_normal_to_high_threshold;
-
-
-	/*
-	 * Dynamic radio parameters for 5GHz
-	 *
-	 * Range: unknown
-	 */
-	u16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	u8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
-
-	s8  tx_rate_limits_normal_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_extreme_5[CONF_NUMBER_OF_RATE_GROUPS];
-
-	s8  tx_channel_limits_ofdm_5[CONF_NUMBER_OF_CHANNELS_5];
-	s8  tx_pdv_rate_offsets_5[CONF_NUMBER_OF_RATE_GROUPS];
-
-	/* FIXME: this is inconsistent with the types for 2.4GHz */
-	s8  tx_ibias_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  rx_fem_insertion_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
-
-	u8  degraded_low_to_normal_threshold_5;
-	u8  degraded_normal_to_high_threshold_5;
+	u8 fem;
 };
 
 struct conf_init_settings {
 	/*
-	 * Configure general parameters.
-	 */
-	struct conf_general_parms genparam;
-
-	/*
 	 * Configure radio parameters.
 	 */
 	struct conf_radio_parms radioparam;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 6f7a7d9..282c2bb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -229,93 +229,8 @@ static struct conf_drv_settings default_conf = {
 		.psm_entry_retries           = 3
 	},
 	.init = {
-		.genparam                    = {
-			.ref_clk             = CONF_REF_CLK_38_4_E,
-			.settling_time       = 5,
-			.clk_valid_on_wakeup = 0,
-			.dc2dcmode           = 0,
-			.single_dual_band    = CONF_SINGLE_BAND,
-			.tx_bip_fem_autodetect = 1,
-			.tx_bip_fem_manufacturer = 1,
-			.settings = 1,
-			.sr_state = 1,
-			.srf1 = { 0x07, 0x03, 0x18, 0x10, 0x05, 0xfb, 0xf0,
-				  0xe8, 0, 0, 0, 0, 0, 0, 0, 0 },
-			.srf2 = { 0x07, 0x03, 0x18, 0x10, 0x05, 0xfb, 0xf0,
-				  0xe8, 0, 0, 0, 0, 0, 0, 0, 0 },
-			.srf3 = { 0x07, 0x03, 0x18, 0x10, 0x05, 0xfb, 0xf0,
-				  0xe8, 0, 0, 0, 0, 0, 0, 0, 0 },
-			.sr_debug_table = { 0, 0, 0, 0, 0, 0, 0, 0,
-					    0, 0, 0, 0, 0, 0, 0, 0 },
-			.sr_sen_n_p = 0,
-			.sr_sen_n_p_gain = 0,
-			.sr_sen_nrn = 0,
-			.sr_sen_prn = 0,
-		},
 		.radioparam = {
-			.rx_trace_loss       = 0x24,
-			.tx_trace_loss       = 0x0,
-			.rx_rssi_and_proc_compens = {
-				0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8,
-				0xfc, 0x00, 0x80, 0x10, 0xf0, 0xf8,
-				0x00, 0x0a, 0x14 },
-			.rx_trace_loss_5     = { 0, 0, 0, 0, 0, 0, 0 },
-			.tx_trace_loss_5     = { 0, 0, 0, 0, 0, 0, 0 },
-			.rx_rssi_and_proc_compens_5 = {
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00 },
-			.tx_ref_pd_voltage   = 0x1a9,
-			.tx_ref_power        = 0x80,
-			.tx_offset_db        = 0x0,
-			.tx_rate_limits_normal = {
-				0x1d, 0x1f, 0x24, 0x28, 0x28, 0x29 },
-			.tx_rate_limits_degraded = {
-				0x19, 0x1f, 0x22, 0x23, 0x27, 0x28 },
-			.tx_rate_limits_extreme = {
-				0x19, 0x1c, 0x1e, 0x20, 0x24, 0x25 },
-			.tx_channel_limits_11b = {
-				0x22, 0x50, 0x50, 0x50, 0x50, 0x50,
-				0x50, 0x50, 0x50, 0x50, 0x22, 0x50,
-				0x22, 0x50 },
-			.tx_channel_limits_ofdm = {
-				0x20, 0x50, 0x50, 0x50, 0x50, 0x50,
-				0x50, 0x50, 0x50, 0x50, 0x20, 0x50,
-				0x20, 0x50 },
-			.tx_pdv_rate_offsets = {
-				0x07, 0x08, 0x04, 0x02, 0x02, 0x00 },
-			.tx_ibias            = {
-				0x11, 0x11, 0x15, 0x11, 0x15, 0x0f },
-			.rx_fem_insertion_loss = 0x0e,
-			.degraded_low_to_normal_threshold = 0x1e,
-			.degraded_normal_to_high_threshold = 0x2d,
-			.tx_ref_pd_voltage_5 = {
-				0x0190, 0x01a4, 0x01c3, 0x01d8,
-				0x020a, 0x021c },
-			.tx_ref_power_5      = {
-				0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 },
-			.tx_offset_db_5      = {
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
-			.tx_rate_limits_normal_5 = {
-				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
-			.tx_rate_limits_degraded_5 = {
-				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
-			.tx_rate_limits_extreme_5 = {
-				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
-			.tx_channel_limits_ofdm_5 = {
-				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
-				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
-				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
-				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
-				0x50, 0x50, 0x50 },
-			.tx_pdv_rate_offsets_5 = {
-				0x01, 0x02, 0x02, 0x02, 0x02, 0x00 },
-			.tx_ibias_5          = {
-				0x10, 0x10, 0x10, 0x10, 0x10, 0x10 },
-			.rx_fem_insertion_loss_5 = {
-				0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10 },
-			.degraded_low_to_normal_threshold_5 = 0x00,
-			.degraded_normal_to_high_threshold_5 = 0x00
+			.fem                 = 1,
 		}
 	},
 	.itrim = {
@@ -345,9 +260,6 @@ static void wl1271_conf_init(struct wl1271 *wl)
 
 	/* apply driver default configuration */
 	memcpy(&wl->conf, &default_conf, sizeof(default_conf));
-
-	if (wl1271_11a_enabled())
-		wl->conf.init.genparam.single_dual_band = CONF_DUAL_BAND;
 }
 
 
@@ -567,15 +479,14 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 		return ret;
 	}
 
-	if (fw->size % 4) {
-		wl1271_error("nvs size is not multiple of 32 bits: %zu",
-			     fw->size);
+	if (fw->size != sizeof(struct wl1271_nvs_file)) {
+		wl1271_error("nvs size is not as expected: %zu != %zu",
+			     fw->size, sizeof(struct wl1271_nvs_file));
 		ret = -EILSEQ;
 		goto out;
 	}
 
-	wl->nvs_len = fw->size;
-	wl->nvs = kmalloc(wl->nvs_len, GFP_KERNEL);
+	wl->nvs = kmalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
 
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
@@ -583,7 +494,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 		goto out;
 	}
 
-	memcpy(wl->nvs, fw->data, wl->nvs_len);
+	memcpy(wl->nvs, fw->data, sizeof(struct wl1271_nvs_file));
 
 	ret = 0;
 
-- 
1.6.3.3

