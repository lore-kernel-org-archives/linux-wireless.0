Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43396 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933753AbZJMJuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:02 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 06/22] wl1271: Add config structure for FW init parameters
Date: Tue, 13 Oct 2009 12:47:43 +0300
Message-Id: <1255427279-1224-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add a configuration structure for RX path parameters, and set default
configuration values there.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   39 ++-----
 drivers/net/wireless/wl12xx/wl1271_conf.h |  182 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |  128 ++++++++++-----------
 drivers/net/wireless/wl12xx/wl1271_init.h |   51 +++-----
 drivers/net/wireless/wl12xx/wl1271_main.c |  103 ++++++++++++++++
 5 files changed, 376 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index d003686..880c828 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1014,7 +1014,7 @@ int wl1271_acx_smart_reflex(struct wl1271 *wl)
 {
 	struct acx_smart_reflex_state *sr_state = NULL;
 	struct acx_smart_reflex_config_params *sr_param = NULL;
-	int ret;
+	int i, ret;
 
 	wl1271_debug(DEBUG_ACX, "acx smart reflex");
 
@@ -1024,33 +1024,14 @@ int wl1271_acx_smart_reflex(struct wl1271 *wl)
 		goto out;
 	}
 
-	/* set cryptic smart reflex parameters - source TI reference code */
-	sr_param->error_table[0].len = 0x07;
-	sr_param->error_table[0].upper_limit = 0x03;
-	sr_param->error_table[0].values[0] = 0x18;
-	sr_param->error_table[0].values[1] = 0x10;
-	sr_param->error_table[0].values[2] = 0x05;
-	sr_param->error_table[0].values[3] = 0xfb;
-	sr_param->error_table[0].values[4] = 0xf0;
-	sr_param->error_table[0].values[5] = 0xe8;
-
-	sr_param->error_table[1].len = 0x07;
-	sr_param->error_table[1].upper_limit = 0x03;
-	sr_param->error_table[1].values[0] = 0x18;
-	sr_param->error_table[1].values[1] = 0x10;
-	sr_param->error_table[1].values[2] = 0x05;
-	sr_param->error_table[1].values[3] = 0xf6;
-	sr_param->error_table[1].values[4] = 0xf0;
-	sr_param->error_table[1].values[5] = 0xe8;
-
-	sr_param->error_table[2].len = 0x07;
-	sr_param->error_table[2].upper_limit = 0x03;
-	sr_param->error_table[2].values[0] = 0x18;
-	sr_param->error_table[2].values[1] = 0x10;
-	sr_param->error_table[2].values[2] = 0x05;
-	sr_param->error_table[2].values[3] = 0xfb;
-	sr_param->error_table[2].values[4] = 0xf0;
-	sr_param->error_table[2].values[5] = 0xe8;
+	for (i = 0; i < CONF_SR_ERR_TBL_COUNT; i++) {
+		struct conf_mart_reflex_err_table *e =
+			&(wl->conf.init.sr_err_tbl[i]);
+
+		sr_param->error_table[i].len = e->len;
+		sr_param->error_table[i].upper_limit = e->upper_limit;
+		memcpy(sr_param->error_table[i].values, e->values, e->len);
+	}
 
 	ret = wl1271_cmd_configure(wl, ACX_SET_SMART_REFLEX_PARAMS,
 				   sr_param, sizeof(*sr_param));
@@ -1066,7 +1047,7 @@ int wl1271_acx_smart_reflex(struct wl1271 *wl)
 	}
 
 	/* enable smart reflex */
-	sr_state->enable = 1;
+	sr_state->enable = wl->conf.init.sr_enable;
 
 	ret = wl1271_cmd_configure(wl, ACX_SET_SMART_REFLEX_STATE,
 				   sr_state, sizeof(*sr_state));
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index f08e509..5333a27 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -691,11 +691,193 @@ struct conf_conn_settings {
 	struct conf_sig_weights sig_weights;
 };
 
+#define CONF_SR_ERR_TBL_MAX_VALUES   14
+
+struct conf_mart_reflex_err_table {
+	/*
+	 * Length of the error table values table.
+	 *
+	 * Range: 0 - CONF_SR_ERR_TBL_MAX_VALUES
+	 */
+	u8 len;
+
+	/*
+	 * Smart Reflex error table upper limit.
+	 *
+	 * Range: s8
+	 */
+	s8 upper_limit;
+
+	/*
+	 * Smart Reflex error table values.
+	 *
+	 * Range: s8
+	 */
+	s8 values[CONF_SR_ERR_TBL_MAX_VALUES];
+};
+
+enum {
+	CONF_REF_CLK_19_2_E,
+	CONF_REF_CLK_26_E,
+	CONF_REF_CLK_38_4_E,
+	CONF_REF_CLK_52_E
+};
+
+struct conf_general_parms {
+	/*
+	 * RF Reference Clock type / speed
+	 *
+	 * Range: CONF_REF_CLK_*
+	 */
+	u8 ref_clk;
+
+	/*
+	 * Settling time of the reference clock after boot.
+	 *
+	 * Range: u8
+	 */
+	u8 settling_time;
+
+	/*
+	 * Flag defining whether clock is valid on wakeup.
+	 *
+	 * Range: 0 - not valid on wakeup, 1 - valid on wakeup
+	 */
+	u8 clk_valid_on_wakeup;
+
+	/*
+	 * DC-to-DC mode.
+	 *
+	 * Range: Unknown
+	 */
+	u8 dc2dcmode;
+
+	/*
+	 * Flag defining whether used as single or dual-band.
+	 *
+	 * Range: Unknown
+	 */
+	u8 single_dual_band;
+
+	/*
+	 * TX bip fem autodetect flag.
+	 *
+	 * Range: Unknown
+	 */
+	u8 tx_bip_fem_autodetect;
+
+	/*
+	 * TX bip gem manufacturer.
+	 *
+	 * Range: Unknown
+	 */
+	u8 tx_bip_fem_manufacturer;
+
+	/*
+	 * Settings flags.
+	 *
+	 * Range: Unknown
+	 */
+	u8 settings;
+};
+
+#define CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE 15
+#define CONF_NUMBER_OF_SUB_BANDS_5  7
+#define CONF_NUMBER_OF_RATE_GROUPS  6
+#define CONF_NUMBER_OF_CHANNELS_2_4 14
+#define CONF_NUMBER_OF_CHANNELS_5   35
+
+struct conf_radio_parms {
+	/*
+	 * Static radio parameters for 2.4GHz
+	 *
+	 * Range: unknown
+	 */
+	u8 rx_trace_loss;
+	u8 tx_trace_loss;
+	s8 rx_rssi_and_proc_compens[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
+
+	/*
+	 * Static radio parameters for 5GHz
+	 *
+	 * Range: unknown
+	 */
+	u8 rx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	u8 tx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	s8 rx_rssi_and_proc_compens_5[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
+
+	/*
+	 * Dynamic radio parameters for 2.4GHz
+	 *
+	 * Range: unknown
+	 */
+	s16 tx_ref_pd_voltage;
+	s8  tx_ref_power;
+	s8  tx_offset_db;
+
+	s8  tx_rate_limits_normal[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_degraded[CONF_NUMBER_OF_RATE_GROUPS];
+
+	s8  tx_channel_limits_11b[CONF_NUMBER_OF_CHANNELS_2_4];
+	s8  tx_channel_limits_ofdm[CONF_NUMBER_OF_CHANNELS_2_4];
+	s8  tx_pdv_rate_offsets[CONF_NUMBER_OF_RATE_GROUPS];
+
+	u8  tx_ibias[CONF_NUMBER_OF_RATE_GROUPS];
+	u8  rx_fem_insertion_loss;
+
+	/*
+	 * Dynamic radio parameters for 5GHz
+	 *
+	 * Range: unknown
+	 */
+	s16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	s8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
+
+	s8  tx_rate_limits_normal_5[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_degraded_5[CONF_NUMBER_OF_RATE_GROUPS];
+
+	s8  tx_channel_limits_ofdm_5[CONF_NUMBER_OF_CHANNELS_5];
+	s8  tx_pdv_rate_offsets_5[CONF_NUMBER_OF_RATE_GROUPS];
+
+	/* FIXME: this is inconsistent with the types for 2.4GHz */
+	s8  tx_ibias_5[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  rx_fem_insertion_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+};
+
+#define CONF_SR_ERR_TBL_COUNT        3
+
+struct conf_init_settings {
+	/*
+	 * Configure Smart Reflex error table values.
+	 */
+	struct conf_mart_reflex_err_table sr_err_tbl[CONF_SR_ERR_TBL_COUNT];
+
+	/*
+	 * Smart Reflex enable flag.
+	 *
+	 * Range: 1 - Smart Reflex enabled, 0 - Smart Reflex disabled
+	 */
+	u8 sr_enable;
+
+	/*
+	 * Configure general parameters.
+	 */
+	struct conf_general_parms genparam;
+
+	/*
+	 * Configure radio parameters.
+	 */
+	struct conf_radio_parms radioparam;
+
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
 	struct conf_tx_settings tx;
 	struct conf_conn_settings conn;
+	struct conf_init_settings init;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index a3fc4c9..5c2cf1e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -188,6 +188,7 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 static int wl1271_init_general_parms(struct wl1271 *wl)
 {
 	struct wl1271_general_parms *gen_parms;
+	struct conf_general_parms *g = &wl->conf.init.genparam;
 	int ret;
 
 	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
@@ -196,22 +197,14 @@ static int wl1271_init_general_parms(struct wl1271 *wl)
 
 	gen_parms->id = TEST_CMD_INI_FILE_GENERAL_PARAM;
 
-	/*
-	 * FIXME: The firmware crashes on boot with REF_CLK_38_4_E as clock.
-	 *        according to TI engineers, ref clk 5 is an unofficial
-	 *        38.4 XTAL clock config, which seems to boot the device.
-	 *        Restore correct value once the real problem source is
-	 *        identified.
-	 */
-	gen_parms->ref_clk = 5; /* REF_CLK_38_4_E; */
-	/* FIXME: magic numbers */
-	gen_parms->settling_time = 5;
-	gen_parms->clk_valid_on_wakeup = 0;
-	gen_parms->dc2dcmode = 0;
-	gen_parms->single_dual_band = 0;
-	gen_parms->tx_bip_fem_autodetect = 0;
-	gen_parms->tx_bip_fem_manufacturer = 1;
-	gen_parms->settings = 1;
+	gen_parms->ref_clk = g->ref_clk;
+	gen_parms->settling_time = g->settling_time;
+	gen_parms->clk_valid_on_wakeup = g->clk_valid_on_wakeup;
+	gen_parms->dc2dcmode = g->dc2dcmode;
+	gen_parms->single_dual_band = g->single_dual_band;
+	gen_parms->tx_bip_fem_autodetect = g->tx_bip_fem_autodetect;
+	gen_parms->tx_bip_fem_manufacturer = g->tx_bip_fem_manufacturer;
+	gen_parms->settings = g->settings;
 
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
 	if (ret < 0) {
@@ -225,32 +218,9 @@ static int wl1271_init_general_parms(struct wl1271 *wl)
 
 static int wl1271_init_radio_parms(struct wl1271 *wl)
 {
-	/*
-	 * FIXME: All these magic numbers should be moved to some place where
-	 * they can be configured (separate file?)
-	 */
-
 	struct wl1271_radio_parms *radio_parms;
-	int ret;
-	u8 compensation[] = { 0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8, 0xfc, 0x00,
-			      0x08, 0x10, 0xf0, 0xf8, 0x00, 0x0a, 0x14 };
-
-	u8 tx_rate_limits_normal[]   = { 0x1e, 0x1f, 0x22, 0x24, 0x28, 0x29 };
-	u8 tx_rate_limits_degraded[] = { 0x1b, 0x1c, 0x1e, 0x20, 0x24, 0x25 };
-
-	u8 tx_channel_limits_11b[] = { 0x22, 0x50, 0x50, 0x50,
-				       0x50, 0x50, 0x50, 0x50,
-				       0x50, 0x50, 0x22, 0x50,
-				       0x22, 0x50 };
-
-	u8 tx_channel_limits_ofdm[] = { 0x20, 0x50, 0x50, 0x50,
-					0x50, 0x50, 0x50, 0x50,
-					0x50, 0x50, 0x20, 0x50,
-					0x20, 0x50 };
-
-	u8 tx_pdv_rate_offsets[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
-
-	u8 tx_ibias[] = { 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x27 };
+	struct conf_radio_parms *r = &wl->conf.init.radioparam;
+	int i, ret;
 
 	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
 	if (!radio_parms)
@@ -259,33 +229,59 @@ static int wl1271_init_radio_parms(struct wl1271 *wl)
 	radio_parms->id = TEST_CMD_INI_FILE_RADIO_PARAM;
 
 	/* Static radio parameters */
-	radio_parms->rx_trace_loss = 10;
-	radio_parms->tx_trace_loss = 10;
-	memcpy(radio_parms->rx_rssi_and_proc_compens, compensation,
-	       sizeof(compensation));
-
-	/* We don't set the 5GHz -- N/A */
+	radio_parms->rx_trace_loss = r->rx_trace_loss;
+	radio_parms->tx_trace_loss = r->tx_trace_loss;
+	memcpy(radio_parms->rx_rssi_and_proc_compens,
+	       r->rx_rssi_and_proc_compens,
+	       CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE);
+
+	memcpy(radio_parms->rx_trace_loss_5, r->rx_trace_loss_5,
+	       CONF_NUMBER_OF_SUB_BANDS_5);
+	memcpy(radio_parms->tx_trace_loss_5, r->tx_trace_loss_5,
+	       CONF_NUMBER_OF_SUB_BANDS_5);
+	memcpy(radio_parms->rx_rssi_and_proc_compens_5,
+	       r->rx_rssi_and_proc_compens_5,
+	       CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE);
 
 	/* Dynamic radio parameters */
-	radio_parms->tx_ref_pd_voltage = cpu_to_le16(0x24e);
-	radio_parms->tx_ref_power = 0x78;
-	radio_parms->tx_offset_db = 0x0;
-
-	memcpy(radio_parms->tx_rate_limits_normal, tx_rate_limits_normal,
-	       sizeof(tx_rate_limits_normal));
-	memcpy(radio_parms->tx_rate_limits_degraded, tx_rate_limits_degraded,
-	       sizeof(tx_rate_limits_degraded));
-
-	memcpy(radio_parms->tx_channel_limits_11b, tx_channel_limits_11b,
-	       sizeof(tx_channel_limits_11b));
-	memcpy(radio_parms->tx_channel_limits_ofdm, tx_channel_limits_ofdm,
-	       sizeof(tx_channel_limits_ofdm));
-	memcpy(radio_parms->tx_pdv_rate_offsets, tx_pdv_rate_offsets,
-	       sizeof(tx_pdv_rate_offsets));
-	memcpy(radio_parms->tx_ibias, tx_ibias,
-	       sizeof(tx_ibias));
-
-	radio_parms->rx_fem_insertion_loss = 0x14;
+	radio_parms->tx_ref_pd_voltage = cpu_to_le16(r->tx_ref_pd_voltage);
+	radio_parms->tx_ref_power = r->tx_ref_power;
+	radio_parms->tx_offset_db = r->tx_offset_db;
+
+	memcpy(radio_parms->tx_rate_limits_normal, r->tx_rate_limits_normal,
+	       CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->tx_rate_limits_degraded, r->tx_rate_limits_degraded,
+	       CONF_NUMBER_OF_RATE_GROUPS);
+
+	memcpy(radio_parms->tx_channel_limits_11b, r->tx_channel_limits_11b,
+	       CONF_NUMBER_OF_CHANNELS_2_4);
+	memcpy(radio_parms->tx_channel_limits_ofdm, r->tx_channel_limits_ofdm,
+	       CONF_NUMBER_OF_CHANNELS_2_4);
+	memcpy(radio_parms->tx_pdv_rate_offsets, r->tx_pdv_rate_offsets,
+	       CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->tx_ibias, r->tx_ibias, CONF_NUMBER_OF_RATE_GROUPS);
+
+	radio_parms->rx_fem_insertion_loss = r->rx_fem_insertion_loss;
+
+	for (i = 0; i < CONF_NUMBER_OF_SUB_BANDS_5; i++)
+		radio_parms->tx_ref_pd_voltage_5[i] =
+			cpu_to_le16(r->tx_ref_pd_voltage_5[i]);
+	memcpy(radio_parms->tx_ref_power_5, r->tx_ref_power_5,
+	       CONF_NUMBER_OF_SUB_BANDS_5);
+	memcpy(radio_parms->tx_offset_db_5, r->tx_offset_db_5,
+	       CONF_NUMBER_OF_SUB_BANDS_5);
+	memcpy(radio_parms->tx_rate_limits_normal_5,
+	       r->tx_rate_limits_normal_5, CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->tx_rate_limits_degraded_5,
+	       r->tx_rate_limits_degraded_5, CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->tx_channel_limits_ofdm_5,
+	       r->tx_channel_limits_ofdm_5, CONF_NUMBER_OF_CHANNELS_5);
+	memcpy(radio_parms->tx_pdv_rate_offsets_5, r->tx_pdv_rate_offsets_5,
+	       CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->tx_ibias_5, r->tx_ibias_5,
+	       CONF_NUMBER_OF_RATE_GROUPS);
+	memcpy(radio_parms->rx_fem_insertion_loss_5,
+	       r->rx_fem_insertion_loss_5, CONF_NUMBER_OF_SUB_BANDS_5);
 
 	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.h b/drivers/net/wireless/wl12xx/wl1271_init.h
index bd8ff0f..513d0cb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.h
+++ b/drivers/net/wireless/wl12xx/wl1271_init.h
@@ -48,19 +48,6 @@ struct wl1271_general_parms {
 	u8 settings;
 } __attribute__ ((packed));
 
-enum ref_clk_enum {
-	REF_CLK_19_2_E,
-	REF_CLK_26_E,
-	REF_CLK_38_4_E,
-	REF_CLK_52_E
-};
-
-#define RSSI_AND_PROCESS_COMPENSATION_SIZE 15
-#define NUMBER_OF_SUB_BANDS_5  7
-#define NUMBER_OF_RATE_GROUPS  6
-#define NUMBER_OF_CHANNELS_2_4 14
-#define NUMBER_OF_CHANNELS_5   35
-
 struct wl1271_radio_parms {
 	u8 id;
 	u8 padding[3];
@@ -69,12 +56,12 @@ struct wl1271_radio_parms {
 	/* 2.4GHz */
 	u8 rx_trace_loss;
 	u8 tx_trace_loss;
-	s8 rx_rssi_and_proc_compens[RSSI_AND_PROCESS_COMPENSATION_SIZE];
+	s8 rx_rssi_and_proc_compens[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
 
 	/* 5GHz */
-	u8 rx_trace_loss_5[NUMBER_OF_SUB_BANDS_5];
-	u8 tx_trace_loss_5[NUMBER_OF_SUB_BANDS_5];
-	s8 rx_rssi_and_proc_compens_5[RSSI_AND_PROCESS_COMPENSATION_SIZE];
+	u8 rx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	u8 tx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	s8 rx_rssi_and_proc_compens_5[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
 
 	/* Dynamic radio parameters */
 	/* 2.4GHz */
@@ -82,32 +69,32 @@ struct wl1271_radio_parms {
 	s8  tx_ref_power;
 	s8  tx_offset_db;
 
-	s8  tx_rate_limits_normal[NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded[NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_normal[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_degraded[CONF_NUMBER_OF_RATE_GROUPS];
 
-	s8  tx_channel_limits_11b[NUMBER_OF_CHANNELS_2_4];
-	s8  tx_channel_limits_ofdm[NUMBER_OF_CHANNELS_2_4];
-	s8  tx_pdv_rate_offsets[NUMBER_OF_RATE_GROUPS];
+	s8  tx_channel_limits_11b[CONF_NUMBER_OF_CHANNELS_2_4];
+	s8  tx_channel_limits_ofdm[CONF_NUMBER_OF_CHANNELS_2_4];
+	s8  tx_pdv_rate_offsets[CONF_NUMBER_OF_RATE_GROUPS];
 
-	u8  tx_ibias[NUMBER_OF_RATE_GROUPS];
+	u8  tx_ibias[CONF_NUMBER_OF_RATE_GROUPS];
 	u8  rx_fem_insertion_loss;
 
 	u8 padding2;
 
 	/* 5GHz */
-	s16 tx_ref_pd_voltage_5[NUMBER_OF_SUB_BANDS_5];
-	s8  tx_ref_power_5[NUMBER_OF_SUB_BANDS_5];
-	s8  tx_offset_db_5[NUMBER_OF_SUB_BANDS_5];
+	s16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	s8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
 
-	s8  tx_rate_limits_normal_5[NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded_5[NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_normal_5[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_degraded_5[CONF_NUMBER_OF_RATE_GROUPS];
 
-	s8  tx_channel_limits_ofdm_5[NUMBER_OF_CHANNELS_5];
-	s8  tx_pdv_rate_offsets_5[NUMBER_OF_RATE_GROUPS];
+	s8  tx_channel_limits_ofdm_5[CONF_NUMBER_OF_CHANNELS_5];
+	s8  tx_pdv_rate_offsets_5[CONF_NUMBER_OF_RATE_GROUPS];
 
 	/* FIXME: this is inconsistent with the types for 2.4GHz */
-	s8  tx_ibias_5[NUMBER_OF_RATE_GROUPS];
-	s8  rx_fem_insertion_loss_5[NUMBER_OF_SUB_BANDS_5];
+	s8  tx_ibias_5[CONF_NUMBER_OF_RATE_GROUPS];
+	s8  rx_fem_insertion_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
 
 	u8 padding3[2];
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index a559a15..0b17b05 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -224,6 +224,109 @@ static void wl1271_conf_init(struct wl1271 *wl)
 				.snr_bcn_avg_weight  = 10,
 				.snr_pkt_avg_weight  = 10
 			}
+		},
+		.init = {
+			.sr_err_tbl = {
+				[0] = {
+					.len         = 7,
+					.upper_limit = 0x03,
+					.values      = {
+						0x18, 0x10, 0x05, 0xfb,
+						0xf0, 0xe8, 0x00 }
+				},
+				[1] = {
+					.len         = 7,
+					.upper_limit = 0x03,
+					.values      = {
+						0x18, 0x10, 0x05, 0xf6,
+						0xf0, 0xe8, 0x00 }
+				},
+				[2] = {
+					.len         = 7,
+					.upper_limit = 0x03,
+					.values      = {
+						0x18, 0x10, 0x05, 0xfb,
+						0xf0, 0xe8, 0x00 }
+				}
+			},
+			.sr_enable = 1,
+			.genparam = {
+				/*
+				 * FIXME: The correct value CONF_REF_CLK_38_4_E
+				 *        causes the firmware to crash on boot.
+				 *        The value 5 apparently is an
+				 *        unnoficial XTAL configuration of the
+				 *        same frequency, which appears to work.
+				 */
+				.ref_clk             = 5,
+				.settling_time       = 5,
+				.clk_valid_on_wakeup = 0,
+				.dc2dcmode           = 0,
+				.single_dual_band    = 0,
+				.tx_bip_fem_autodetect = 0,
+				.tx_bip_fem_manufacturer = 1,
+				.settings = 1,
+			},
+			.radioparam = {
+				/* FIXME: 5GHz values unset! */
+				.rx_trace_loss       = 10,
+				.tx_trace_loss       = 10,
+				.rx_rssi_and_proc_compens = {
+					0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8,
+					0xfc, 0x00, 0x08, 0x10, 0xf0, 0xf8,
+					0x00, 0x0a, 0x14 },
+				.rx_trace_loss_5     = {
+					0, 0, 0, 0, 0, 0, 0 },
+				.tx_trace_loss_5     = {
+					0, 0, 0, 0, 0, 0, 0 },
+				.rx_rssi_and_proc_compens_5 = {
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x00 },
+				.tx_ref_pd_voltage   = 0x24e,
+				.tx_ref_power        = 0x78,
+				.tx_offset_db        = 0x0,
+				.tx_rate_limits_normal = {
+					0x1e, 0x1f, 0x22, 0x24, 0x28, 0x29 },
+				.tx_rate_limits_degraded = {
+					0x1b, 0x1c, 0x1e, 0x20, 0x24, 0x25 },
+				.tx_channel_limits_11b = {
+					0x22, 0x50, 0x50, 0x50, 0x50, 0x50,
+					0x50, 0x50, 0x50, 0x50, 0x22, 0x50,
+					0x22, 0x50 },
+				.tx_channel_limits_ofdm = {
+					0x20, 0x50, 0x50, 0x50, 0x50, 0x50,
+					0x50, 0x50, 0x50, 0x50, 0x20, 0x50,
+					0x20, 0x50 },
+				.tx_pdv_rate_offsets = {
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				.tx_ibias            = {
+					0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x27 },
+				.rx_fem_insertion_loss = 0x14,
+				.tx_ref_pd_voltage_5 = {
+					0, 0, 0, 0, 0, 0, 0 },
+				.tx_ref_power_5      = {
+					0, 0, 0, 0, 0, 0, 0 },
+				.tx_offset_db_5      = {
+					0, 0, 0, 0, 0, 0, 0 },
+				.tx_rate_limits_normal_5 = {
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				.tx_rate_limits_degraded_5 = {
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				.tx_channel_limits_ofdm_5 = {
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+					0x00, 0x00, 0x00, 0x00, 0x00},
+				.tx_pdv_rate_offsets_5 = {
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				.tx_ibias_5          = {
+					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				.rx_fem_insertion_loss_5 = {
+					0, 0, 0, 0, 0, 0, 0 }
+			}
 		}
 	};
 
-- 
1.5.6.5

