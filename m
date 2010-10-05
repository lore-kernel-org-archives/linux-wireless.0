Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52694 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab0JEJ4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:56:12 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o959tqPd031917
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 12:56:09 +0300
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1271: Add extended radio parameter initialization
Date: Tue,  5 Oct 2010 12:54:58 +0300
Message-Id: <1286272498-21243-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently a command to initialize extended radio parameter tables in the
hardware is missing.

Add the initialization

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   33 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |   24 +++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_conf.h |   20 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |    4 +++
 drivers/net/wireless/wl12xx/wl1271_main.c |   14 ++++++++++++
 5 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 4a56ab0..2b1e448 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -171,6 +171,39 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	return ret;
 }
 
+int wl1271_cmd_ext_radio_parms(struct wl1271 *wl)
+{
+	struct wl1271_ext_radio_parms_cmd *ext_radio_parms;
+	struct conf_rf_settings *rf = &wl->conf.rf;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	ext_radio_parms = kzalloc(sizeof(*ext_radio_parms), GFP_KERNEL);
+	if (!ext_radio_parms)
+		return -ENOMEM;
+
+	ext_radio_parms->test.id = TEST_CMD_INI_FILE_RF_EXTENDED_PARAM;
+
+	memcpy(ext_radio_parms->tx_per_channel_power_compensation_2,
+	       rf->tx_per_channel_power_compensation_2,
+	       WL1271_CONF_HALF_CH_COUNT_2);
+	memcpy(ext_radio_parms->tx_per_channel_power_compensation_5,
+	       rf->tx_per_channel_power_compensation_5,
+	       WL1271_CONF_HALF_CH_COUNT_5);
+
+	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_EXT_RADIO_PARAM: ",
+		    ext_radio_parms, sizeof(*ext_radio_parms));
+
+	ret = wl1271_cmd_test(wl, ext_radio_parms, sizeof(*ext_radio_parms), 0);
+	if (ret < 0)
+		wl1271_warning("TEST_CMD_INI_FILE_RF_EXTENDED_PARAM failed");
+
+	kfree(ext_radio_parms);
+	return ret;
+}
+
 /*
  * Poll the mailbox event field until any of the bits in the mask is set or a
  * timeout occurs (WL1271_EVENT_TIMEOUT in msecs)
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 33b946b..8d2c092 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -33,6 +33,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
 int wl1271_cmd_general_parms(struct wl1271 *wl);
 int wl1271_cmd_radio_parms(struct wl1271 *wl);
+int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
 int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
@@ -324,13 +325,14 @@ enum wl1271_channel_tune_bands {
 	WL1271_CHANNEL_TUNE_BAND_4_9
 };
 
-#define WL1271_PD_REFERENCE_POINT_BAND_B_G 0
+#define WL1271_PD_REFERENCE_POINT_BAND_B_G  0
 
-#define TEST_CMD_P2G_CAL                   0x02
-#define TEST_CMD_CHANNEL_TUNE              0x0d
-#define TEST_CMD_UPDATE_PD_REFERENCE_POINT 0x1d
-#define TEST_CMD_INI_FILE_RADIO_PARAM      0x19
-#define TEST_CMD_INI_FILE_GENERAL_PARAM    0x1E
+#define TEST_CMD_P2G_CAL                    0x02
+#define TEST_CMD_CHANNEL_TUNE               0x0d
+#define TEST_CMD_UPDATE_PD_REFERENCE_POINT  0x1d
+#define TEST_CMD_INI_FILE_RADIO_PARAM       0x19
+#define TEST_CMD_INI_FILE_GENERAL_PARAM     0x1E
+#define TEST_CMD_INI_FILE_RF_EXTENDED_PARAM 0x26
 
 struct wl1271_general_parms_cmd {
 	struct wl1271_cmd_header header;
@@ -363,6 +365,16 @@ struct wl1271_radio_parms_cmd {
 	u8 padding3[2];
 } __packed;
 
+struct wl1271_ext_radio_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	u8 tx_per_channel_power_compensation_2[WL1271_CONF_HALF_CH_COUNT_2];
+	u8 tx_per_channel_power_compensation_5[WL1271_CONF_HALF_CH_COUNT_5];
+	u8 padding[3];
+} __attribute__ ((packed));
+
 struct wl1271_cmd_cal_channel_tune {
 	struct wl1271_cmd_header header;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 60c50d1..48e7966 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -1070,6 +1070,25 @@ struct conf_scan_settings {
 
 };
 
+#define WL1271_CONF_HALF_CH_COUNT_2 7
+#define WL1271_CONF_HALF_CH_COUNT_5 18
+
+struct conf_rf_settings {
+	/*
+	 * Per channel power compensation for 2.4GHz
+	 *
+	 * Range: s8
+	 */
+	u8 tx_per_channel_power_compensation_2[WL1271_CONF_HALF_CH_COUNT_2];
+
+	/*
+	 * Per channel power compensation for 5GHz
+	 *
+	 * Range: s8
+	 */
+	u8 tx_per_channel_power_compensation_5[WL1271_CONF_HALF_CH_COUNT_5];
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1079,6 +1098,7 @@ struct conf_drv_settings {
 	struct conf_pm_config_settings pm_config;
 	struct conf_roam_trigger_settings roam_trigger;
 	struct conf_scan_settings scan;
+	struct conf_rf_settings rf;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 349571f..8044bba 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -222,6 +222,10 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl1271_cmd_ext_radio_parms(wl);
+	if (ret < 0)
+		return ret;
+
 	/* Template settings */
 	ret = wl1271_init_templates_config(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index cb18f22..8d33a2b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -242,6 +242,16 @@ static struct conf_drv_settings default_conf = {
 		.max_dwell_time_passive       = 60000,
 		.num_probe_reqs               = 2,
 	},
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
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
@@ -357,6 +367,10 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl1271_cmd_ext_radio_parms(wl);
+	if (ret < 0)
+		return ret;
+
 	ret = wl1271_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
-- 
1.7.0.4

