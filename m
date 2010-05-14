Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27022 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab0ENHqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 03:46:42 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 1/3] wl1271: Update handling of the NVS file / INI parameters
Date: Fri, 14 May 2010 10:46:22 +0300
Message-Id: <1273823184-9381-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273823184-9381-1-git-send-email-luciano.coelho@nokia.com>
References: <1273823184-9381-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch updates the handling of the NVS file INI-section, trying to make
it slightly more generic, and exposing the parameters being set. This is done
in preparation for 5GHz parameters.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h     |   28 +-------
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   14 ++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h |   26 ++++---
 drivers/net/wireless/wl12xx/wl1271_ini.h |  118 ++++++++++++++++++++++++++++++
 4 files changed, 142 insertions(+), 44 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_ini.h

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 6f1b6b5..1e48e75 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -33,6 +33,7 @@
 #include <net/mac80211.h>
 
 #include "wl1271_conf.h"
+#include "wl1271_ini.h"
 
 #define DRIVER_NAME "wl1271"
 #define DRIVER_PREFIX DRIVER_NAME ": "
@@ -116,33 +117,6 @@ enum {
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
 
-/* NVS data structure */
-#define WL1271_NVS_SECTION_SIZE                  468
-
-#define WL1271_NVS_GENERAL_PARAMS_SIZE            57
-#define WL1271_NVS_GENERAL_PARAMS_SIZE_PADDED \
-	(WL1271_NVS_GENERAL_PARAMS_SIZE + 1)
-#define WL1271_NVS_STAT_RADIO_PARAMS_SIZE         17
-#define WL1271_NVS_STAT_RADIO_PARAMS_SIZE_PADDED \
-	(WL1271_NVS_STAT_RADIO_PARAMS_SIZE + 1)
-#define WL1271_NVS_DYN_RADIO_PARAMS_SIZE          65
-#define WL1271_NVS_DYN_RADIO_PARAMS_SIZE_PADDED \
-	(WL1271_NVS_DYN_RADIO_PARAMS_SIZE + 1)
-#define WL1271_NVS_FEM_COUNT                       2
-#define WL1271_NVS_INI_SPARE_SIZE                124
-
-struct wl1271_nvs_file {
-	/* NVS section */
-	u8 nvs[WL1271_NVS_SECTION_SIZE];
-
-	/* INI section */
-	u8 general_params[WL1271_NVS_GENERAL_PARAMS_SIZE_PADDED];
-	u8 stat_radio_params[WL1271_NVS_STAT_RADIO_PARAMS_SIZE_PADDED];
-	u8 dyn_radio_params[WL1271_NVS_FEM_COUNT]
-			   [WL1271_NVS_DYN_RADIO_PARAMS_SIZE_PADDED];
-	u8 ini_spare[WL1271_NVS_INI_SPARE_SIZE];
-} __attribute__ ((packed));
-
 /*
  * Enable/disable 802.11a support for WL1273
  */
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 19393e2..241b477 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -212,8 +212,8 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 
 	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
 
-	memcpy(gen_parms->params, wl->nvs->general_params,
-	       WL1271_NVS_GENERAL_PARAMS_SIZE);
+	memcpy(&gen_parms->general_params, &wl->nvs->general_params,
+	       sizeof(struct wl1271_ini_general_params));
 
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
 	if (ret < 0)
@@ -238,11 +238,11 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 
 	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
 
-	memcpy(radio_parms->stat_radio_params, wl->nvs->stat_radio_params,
-	       WL1271_NVS_STAT_RADIO_PARAMS_SIZE);
-	memcpy(radio_parms->dyn_radio_params,
-	       wl->nvs->dyn_radio_params[rparam->fem],
-	       WL1271_NVS_DYN_RADIO_PARAMS_SIZE);
+	memcpy(&radio_parms->static_params_2, &wl->nvs->stat_radio_params_2,
+	       sizeof(struct wl1271_ini_band_params_2));
+	memcpy(&radio_parms->dyn_params_2,
+	       &wl->nvs->dyn_radio_params_2[rparam->fem].params,
+	       sizeof(struct wl1271_ini_fem_params_2));
 
 	/* FIXME: current NVS is missing 5GHz parameters */
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index f2820b4..4ff966f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -439,24 +439,30 @@ struct wl1271_general_parms_cmd {
 
 	struct wl1271_cmd_test_header test;
 
-	u8 params[WL1271_NVS_GENERAL_PARAMS_SIZE];
-	s8 reserved[23];
-} __attribute__ ((packed));
+	struct wl1271_ini_general_params general_params;
 
-#define WL1271_STAT_RADIO_PARAMS_5_SIZE    29
-#define WL1271_DYN_RADIO_PARAMS_5_SIZE    104
+	u8 sr_debug_table[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 sr_sen_n_p;
+	u8 sr_sen_n_p_gain;
+	u8 sr_sen_nrn;
+	u8 sr_sen_prn;
+	u8 padding[3];
+} __attribute__ ((packed));
 
 struct wl1271_radio_parms_cmd {
 	struct wl1271_cmd_header header;
 
 	struct wl1271_cmd_test_header test;
 
-	u8 stat_radio_params[WL1271_NVS_STAT_RADIO_PARAMS_SIZE];
-	u8 stat_radio_params_5[WL1271_STAT_RADIO_PARAMS_5_SIZE];
+	/* Static radio parameters */
+	struct wl1271_ini_band_params_2 static_params_2;
+	struct wl1271_ini_band_params_5 static_params_5;
 
-	u8 dyn_radio_params[WL1271_NVS_DYN_RADIO_PARAMS_SIZE];
-	u8 reserved;
-	u8 dyn_radio_params_5[WL1271_DYN_RADIO_PARAMS_5_SIZE];
+	/* Dynamic radio parameters */
+	struct wl1271_ini_fem_params_2 dyn_params_2;
+	u8 padding2;
+	struct wl1271_ini_fem_params_5 dyn_params_5;
+	u8 padding3[2];
 } __attribute__ ((packed));
 
 struct wl1271_cmd_cal_channel_tune {
diff --git a/drivers/net/wireless/wl12xx/wl1271_ini.h b/drivers/net/wireless/wl12xx/wl1271_ini.h
new file mode 100644
index 0000000..d1590bc
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_ini.h
@@ -0,0 +1,118 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL1271_INI_H__
+#define __WL1271_INI_H__
+
+#define WL1271_INI_MAX_SMART_REFLEX_PARAM 16
+
+struct wl1271_ini_general_params {
+	u8 ref_clock;
+	u8 settling_time;
+	u8 clk_valid_on_wakeup;
+	u8 dc2dc_mode;
+	u8 dual_mode_select;
+	u8 tx_bip_fem_auto_detect;
+	u8 tx_bip_fem_manufacturer;
+	u8 general_settings;
+	u8 sr_state;
+	u8 srf1[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 srf2[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 srf3[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+} __attribute__ ((packed));
+
+#define WL1271_INI_RSSI_PROCESS_COMPENS_SIZE 15
+
+struct wl1271_ini_band_params_2 {
+	u8 rx_trace_insertion_loss;
+	u8 tx_trace_loss;
+	u8 rx_rssi_process_compens[WL1271_INI_RSSI_PROCESS_COMPENS_SIZE];
+} __attribute__ ((packed));
+
+#define WL1271_INI_RATE_GROUP_COUNT 6
+#define WL1271_INI_CHANNEL_COUNT_2 14
+
+struct wl1271_ini_fem_params_2 {
+	__le16 tx_bip_ref_pd_voltage;
+	u8 tx_bip_ref_power;
+	u8 tx_bip_ref_offset;
+	u8 tx_per_rate_pwr_limits_normal[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_degraded[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_extreme[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_per_chan_pwr_limits_11b[WL1271_INI_CHANNEL_COUNT_2];
+	u8 tx_per_chan_pwr_limits_ofdm[WL1271_INI_CHANNEL_COUNT_2];
+	u8 tx_pd_vs_rate_offsets[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_ibias[WL1271_INI_RATE_GROUP_COUNT];
+	u8 rx_fem_insertion_loss;
+	u8 degraded_low_to_normal_thr;
+	u8 normal_to_degraded_high_thr;
+} __attribute__ ((packed));
+
+#define WL1271_INI_CHANNEL_COUNT_5 35
+#define WL1271_INI_SUB_BAND_COUNT_5 7
+
+struct wl1271_ini_band_params_5 {
+	u8 rx_trace_insertion_loss[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_trace_loss[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 rx_rssi_process_compens[WL1271_INI_RSSI_PROCESS_COMPENS_SIZE];
+} __attribute__ ((packed));
+
+struct wl1271_ini_fem_params_5 {
+	__le16 tx_bip_ref_pd_voltage[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_bip_ref_power[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_bip_ref_offset[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 tx_per_rate_pwr_limits_normal[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_degraded[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_per_rate_pwr_limits_extreme[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_per_chan_pwr_limits_ofdm[WL1271_INI_CHANNEL_COUNT_5];
+	u8 tx_pd_vs_rate_offsets[WL1271_INI_RATE_GROUP_COUNT];
+	u8 tx_ibias[WL1271_INI_RATE_GROUP_COUNT];
+	u8 rx_fem_insertion_loss[WL1271_INI_SUB_BAND_COUNT_5];
+	u8 degraded_low_to_normal_thr;
+	u8 normal_to_degraded_high_thr;
+} __attribute__ ((packed));
+
+
+/* NVS data structure */
+#define WL1271_INI_NVS_SECTION_SIZE		     468
+#define WL1271_INI_SPARE_SIZE			     124
+#define WL1271_INI_FEM_MODULE_COUNT                  2
+
+struct wl1271_nvs_file {
+	/* NVS section */
+	u8 nvs[WL1271_INI_NVS_SECTION_SIZE];
+
+	/* INI section */
+	struct wl1271_ini_general_params general_params;
+	u8 padding1;
+	struct wl1271_ini_band_params_2 stat_radio_params_2;
+	u8 padding2;
+	struct {
+		struct wl1271_ini_fem_params_2 params;
+		u8 padding;
+	} dyn_radio_params_2[WL1271_INI_FEM_MODULE_COUNT];
+
+	u8 ini_spare[WL1271_INI_SPARE_SIZE];
+} __attribute__ ((packed));
+
+#endif
-- 
1.6.3.3

