Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40115 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbZKWVXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:23:06 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] wl1271: fix radio and general parameters commands
Date: Mon, 23 Nov 2009 23:22:17 +0200
Message-Id: <1259011339-28149-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
References: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were missing the command header in the radio and general parameters
commands.  This was causing them to fail, resulting in problems in the power
levels and other PLT-related commands.

Also reorganized the command functions, moving from wl1271_init.c to
wl1271_cmd.c where it fits better.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |  107 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |   72 +++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |  110 +----------------------------
 drivers/net/wireless/wl12xx/wl1271_init.h |   72 -------------------
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +-
 5 files changed, 183 insertions(+), 182 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 990eb01..886a9bc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -188,6 +188,113 @@ static int wl1271_cmd_cal(struct wl1271 *wl)
 	return ret;
 }
 
+int wl1271_cmd_general_parms(struct wl1271 *wl)
+{
+	struct wl1271_general_parms_cmd *gen_parms;
+	struct conf_general_parms *g = &wl->conf.init.genparam;
+	int ret;
+
+	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
+	if (!gen_parms)
+		return -ENOMEM;
+
+	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
+
+	gen_parms->ref_clk = g->ref_clk;
+	gen_parms->settling_time = g->settling_time;
+	gen_parms->clk_valid_on_wakeup = g->clk_valid_on_wakeup;
+	gen_parms->dc2dcmode = g->dc2dcmode;
+	gen_parms->single_dual_band = g->single_dual_band;
+	gen_parms->tx_bip_fem_autodetect = g->tx_bip_fem_autodetect;
+	gen_parms->tx_bip_fem_manufacturer = g->tx_bip_fem_manufacturer;
+	gen_parms->settings = g->settings;
+
+	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
+	if (ret < 0)
+		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
+
+	kfree(gen_parms);
+	return ret;
+}
+
+int wl1271_cmd_radio_parms(struct wl1271 *wl)
+{
+	struct wl1271_radio_parms_cmd *radio_parms;
+	struct conf_radio_parms *r = &wl->conf.init.radioparam;
+	int i, ret;
+
+	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
+	if (!radio_parms)
+		return -ENOMEM;
+
+	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
+
+	/* Static radio parameters */
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
+
+	/* Dynamic radio parameters */
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
 int wl1271_cmd_join(struct wl1271 *wl)
 {
 	static bool do_cal = true;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 9d7061b..b4fa4ac 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -31,6 +31,8 @@ struct acx_header;
 
 int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
+int wl1271_cmd_general_parms(struct wl1271 *wl);
+int wl1271_cmd_radio_parms(struct wl1271 *wl);
 int wl1271_cmd_join(struct wl1271 *wl);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
@@ -418,6 +420,76 @@ enum wl1271_channel_tune_bands {
 #define TEST_CMD_P2G_CAL                   0x02
 #define TEST_CMD_CHANNEL_TUNE              0x0d
 #define TEST_CMD_UPDATE_PD_REFERENCE_POINT 0x1d
+#define TEST_CMD_INI_FILE_RADIO_PARAM      0x19
+#define TEST_CMD_INI_FILE_GENERAL_PARAM    0x1E
+
+struct wl1271_general_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	u8 ref_clk;
+	u8 settling_time;
+	u8 clk_valid_on_wakeup;
+	u8 dc2dcmode;
+	u8 single_dual_band;
+
+	u8 tx_bip_fem_autodetect;
+	u8 tx_bip_fem_manufacturer;
+	u8 settings;
+} __attribute__ ((packed));
+
+struct wl1271_radio_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	/* Static radio parameters */
+	/* 2.4GHz */
+	u8 rx_trace_loss;
+	u8 tx_trace_loss;
+	s8 rx_rssi_and_proc_compens[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
+
+	/* 5GHz */
+	u8 rx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	u8 tx_trace_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	s8 rx_rssi_and_proc_compens_5[CONF_RSSI_AND_PROCESS_COMPENSATION_SIZE];
+
+	/* Dynamic radio parameters */
+	/* 2.4GHz */
+	__le16 tx_ref_pd_voltage;
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
+	u8 padding2;
+
+	/* 5GHz */
+	__le16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
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
+
+	u8 padding3[2];
+} __attribute__ ((packed));
 
 struct wl1271_cmd_cal_channel_tune {
 	struct wl1271_cmd_header header;
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 95ee036..44896ac 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -193,112 +193,6 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 	return 0;
 }
 
-int wl1271_init_general_parms(struct wl1271 *wl)
-{
-	struct wl1271_general_parms *gen_parms;
-	struct conf_general_parms *g = &wl->conf.init.genparam;
-	int ret;
-
-	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
-	if (!gen_parms)
-		return -ENOMEM;
-
-	gen_parms->id = TEST_CMD_INI_FILE_GENERAL_PARAM;
-
-	gen_parms->ref_clk = g->ref_clk;
-	gen_parms->settling_time = g->settling_time;
-	gen_parms->clk_valid_on_wakeup = g->clk_valid_on_wakeup;
-	gen_parms->dc2dcmode = g->dc2dcmode;
-	gen_parms->single_dual_band = g->single_dual_band;
-	gen_parms->tx_bip_fem_autodetect = g->tx_bip_fem_autodetect;
-	gen_parms->tx_bip_fem_manufacturer = g->tx_bip_fem_manufacturer;
-	gen_parms->settings = g->settings;
-
-	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
-	if (ret < 0) {
-		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
-		return ret;
-	}
-
-	kfree(gen_parms);
-	return 0;
-}
-
-int wl1271_init_radio_parms(struct wl1271 *wl)
-{
-	struct wl1271_radio_parms *radio_parms;
-	struct conf_radio_parms *r = &wl->conf.init.radioparam;
-	int i, ret;
-
-	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
-	if (!radio_parms)
-		return -ENOMEM;
-
-	radio_parms->id = TEST_CMD_INI_FILE_RADIO_PARAM;
-
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
-	memcpy(radio_parms->tx_channel_limits_ofdm_5,
-	       r->tx_channel_limits_ofdm_5, CONF_NUMBER_OF_CHANNELS_5);
-	memcpy(radio_parms->tx_pdv_rate_offsets_5, r->tx_pdv_rate_offsets_5,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->tx_ibias_5, r->tx_ibias_5,
-	       CONF_NUMBER_OF_RATE_GROUPS);
-	memcpy(radio_parms->rx_fem_insertion_loss_5,
-	       r->rx_fem_insertion_loss_5, CONF_NUMBER_OF_SUB_BANDS_5);
-
-	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
-	if (ret < 0)
-		wl1271_warning("CMD_INI_FILE_RADIO_PARAM failed");
-
-	kfree(radio_parms);
-	return ret;
-}
-
 int wl1271_hw_init(struct wl1271 *wl)
 {
 	int ret;
@@ -306,11 +200,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	/* FIXME: the following parameter setting functions return error
 	 * codes - the reason is so far unknown. The -EIO is therefore
 	 * ignored for the time being. */
-	ret = wl1271_init_general_parms(wl);
+	ret = wl1271_cmd_general_parms(wl);
 	if (ret < 0 && ret != -EIO)
 		return ret;
 
-	ret = wl1271_init_radio_parms(wl);
+	ret = wl1271_cmd_radio_parms(wl);
 	if (ret < 0 && ret != -EIO)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.h b/drivers/net/wireless/wl12xx/wl1271_init.h
index 539b57f..930677f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.h
+++ b/drivers/net/wireless/wl12xx/wl1271_init.h
@@ -28,77 +28,5 @@
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
-int wl1271_init_general_parms(struct wl1271 *wl);
-int wl1271_init_radio_parms(struct wl1271 *wl);
-
-/* These are not really a TEST_CMD, but the ref driver uses them as such */
-#define TEST_CMD_INI_FILE_RADIO_PARAM   0x19
-#define TEST_CMD_INI_FILE_GENERAL_PARAM 0x1E
-
-struct wl1271_general_parms {
-	u8 id;
-	u8 padding[3];
-
-	u8 ref_clk;
-	u8 settling_time;
-	u8 clk_valid_on_wakeup;
-	u8 dc2dcmode;
-	u8 single_dual_band;
-
-	u8 tx_bip_fem_autodetect;
-	u8 tx_bip_fem_manufacturer;
-	u8 settings;
-} __attribute__ ((packed));
-
-struct wl1271_radio_parms {
-	u8 id;
-	u8 padding[3];
-
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
-	s8  tx_ref_power;
-	s8  tx_offset_db;
-
-	s8  tx_rate_limits_normal[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded[CONF_NUMBER_OF_RATE_GROUPS];
-
-	s8  tx_channel_limits_11b[CONF_NUMBER_OF_CHANNELS_2_4];
-	s8  tx_channel_limits_ofdm[CONF_NUMBER_OF_CHANNELS_2_4];
-	s8  tx_pdv_rate_offsets[CONF_NUMBER_OF_RATE_GROUPS];
-
-	u8  tx_ibias[CONF_NUMBER_OF_RATE_GROUPS];
-	u8  rx_fem_insertion_loss;
-
-	u8 padding2;
-
-	/* 5GHz */
-	__le16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
-	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
-
-	s8  tx_rate_limits_normal_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  tx_rate_limits_degraded_5[CONF_NUMBER_OF_RATE_GROUPS];
-
-	s8  tx_channel_limits_ofdm_5[CONF_NUMBER_OF_CHANNELS_5];
-	s8  tx_pdv_rate_offsets_5[CONF_NUMBER_OF_RATE_GROUPS];
-
-	/* FIXME: this is inconsistent with the types for 2.4GHz */
-	s8  tx_ibias_5[CONF_NUMBER_OF_RATE_GROUPS];
-	s8  rx_fem_insertion_loss_5[CONF_NUMBER_OF_SUB_BANDS_5];
-
-	u8 padding3[2];
-} __attribute__ ((packed));
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d4e6039..b75557e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -357,11 +357,11 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	/* FIXME: the following parameter setting functions return error
 	 * codes - the reason is so far unknown. The -EIO is therefore
 	 * ignored for the time being. */
-	ret = wl1271_init_general_parms(wl);
+	ret = wl1271_cmd_general_parms(wl);
 	if (ret < 0 && ret != -EIO)
 		return ret;
 
-	ret = wl1271_init_radio_parms(wl);
+	ret = wl1271_cmd_radio_parms(wl);
 	if (ret < 0 && ret != -EIO)
 		return ret;
 
-- 
1.6.3.3

