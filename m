Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36154 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730AbZJMJuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:00 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 02/22] wl1271: Add structure for firmware configuration values
Date: Tue, 13 Oct 2009 12:47:39 +0300
Message-Id: <1255427279-1224-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In order to make the firmware configuration more manageable, collect
hardcoded configuration values into one data structure, and set default values
there.

Add the SoftGemini BT/WLAN coex paramters into the config structure.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    5 +
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   40 ++-----
 drivers/net/wireless/wl12xx/wl1271_acx.h  |  136 +++-------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    6 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    5 -
 drivers/net/wireless/wl12xx/wl1271_conf.h |  178 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   84 ++++++++++----
 drivers/net/wireless/wl12xx/wl1271_reg.h  |   44 -------
 8 files changed, 274 insertions(+), 224 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_conf.h

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index aa9bb2e..64a3270 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -32,6 +32,8 @@
 #include <linux/bitops.h>
 #include <net/mac80211.h>
 
+#include "wl1271_conf.h"
+
 #define DRIVER_NAME "wl1271"
 #define DRIVER_PREFIX DRIVER_NAME ": "
 
@@ -420,6 +422,9 @@ struct wl1271 {
 
 	/* Used for a workaround to send disconnect before rejoining */
 	bool joined;
+
+	/* Current chipset configuration */
+	struct conf_drv_settings conf;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 6c29890..d19d860 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -509,6 +509,7 @@ out:
 int wl1271_acx_sg_cfg(struct wl1271 *wl)
 {
 	struct acx_bt_wlan_coex_param *param;
+	struct conf_sg_settings *c = &wl->conf.sg;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "acx sg cfg");
@@ -520,34 +521,17 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 	}
 
 	/* BT-WLAN coext parameters */
-	param->min_rate = RATE_INDEX_24MBPS;
-	param->bt_hp_max_time = PTA_BT_HP_MAXTIME_DEF;
-	param->wlan_hp_max_time = PTA_WLAN_HP_MAX_TIME_DEF;
-	param->sense_disable_timer = PTA_SENSE_DISABLE_TIMER_DEF;
-	param->rx_time_bt_hp = PTA_PROTECTIVE_RX_TIME_DEF;
-	param->tx_time_bt_hp = PTA_PROTECTIVE_TX_TIME_DEF;
-	param->rx_time_bt_hp_fast = PTA_PROTECTIVE_RX_TIME_FAST_DEF;
-	param->tx_time_bt_hp_fast = PTA_PROTECTIVE_TX_TIME_FAST_DEF;
-	param->wlan_cycle_fast = PTA_CYCLE_TIME_FAST_DEF;
-	param->bt_anti_starvation_period = PTA_ANTI_STARVE_PERIOD_DEF;
-	param->next_bt_lp_packet = PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF;
-	param->wake_up_beacon = PTA_TIME_BEFORE_BEACON_DEF;
-	param->hp_dm_max_guard_time = PTA_HPDM_MAX_TIME_DEF;
-	param->next_wlan_packet = PTA_TIME_OUT_NEXT_WLAN_DEF;
-	param->antenna_type = PTA_ANTENNA_TYPE_DEF;
-	param->signal_type = PTA_SIGNALING_TYPE_DEF;
-	param->afh_leverage_on = PTA_AFH_LEVERAGE_ON_DEF;
-	param->quiet_cycle_num = PTA_NUMBER_QUIET_CYCLE_DEF;
-	param->max_cts = PTA_MAX_NUM_CTS_DEF;
-	param->wlan_packets_num = PTA_NUMBER_OF_WLAN_PACKETS_DEF;
-	param->bt_packets_num = PTA_NUMBER_OF_BT_PACKETS_DEF;
-	param->missed_rx_avalanche = PTA_RX_FOR_AVALANCHE_DEF;
-	param->wlan_elp_hp = PTA_ELP_HP_DEF;
-	param->bt_anti_starvation_cycles = PTA_ANTI_STARVE_NUM_CYCLE_DEF;
-	param->ack_mode_dual_ant = PTA_ACK_MODE_DEF;
-	param->pa_sd_enable = PTA_ALLOW_PA_SD_DEF;
-	param->pta_auto_mode_enable = PTA_AUTO_MODE_NO_CTS_DEF;
-	param->bt_hp_respected_num = PTA_BT_HP_RESPECTED_DEF;
+	param->per_threshold = c->per_threshold;
+	param->max_scan_compensation_time = c->max_scan_compensation_time;
+	param->nfs_sample_interval = c->nfs_sample_interval;
+	param->load_ratio = c->load_ratio;
+	param->auto_ps_mode = c->auto_ps_mode;
+	param->probe_req_compensation = c->probe_req_compensation;
+	param->scan_window_compensation = c->scan_window_compensation;
+	param->antenna_config = c->antenna_config;
+	param->beacon_miss_threshold = c->beacon_miss_threshold;
+	param->rate_adaptation_threshold = c->rate_adaptation_threshold;
+	param->rate_adaptation_snr = c->rate_adaptation_snr;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 0c704af..8e3b97c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -496,126 +496,18 @@ struct acx_smart_reflex_config_params {
 struct acx_bt_wlan_coex_param {
 	struct acx_header header;
 
-	/*
-	 * The minimum rate of a received WLAN packet in the STA,
-	 * during protective mode, of which a new BT-HP request
-	 * during this Rx will always be respected and gain the antenna.
-	 */
-	u32 min_rate;
-
-	/* Max time the BT HP will be respected. */
-	u16 bt_hp_max_time;
-
-	/* Max time the WLAN HP will be respected. */
-	u16 wlan_hp_max_time;
-
-	/*
-	 * The time between the last BT activity
-	 * and the moment when the sense mode returns
-	 * to SENSE_INACTIVE.
-	 */
-	u16 sense_disable_timer;
-
-	/* Time before the next BT HP instance */
-	u16 rx_time_bt_hp;
-	u16 tx_time_bt_hp;
-
-	/* range: 10-20000    default: 1500 */
-	u16 rx_time_bt_hp_fast;
-	u16 tx_time_bt_hp_fast;
-
-	/* range: 2000-65535  default: 8700 */
-	u16 wlan_cycle_fast;
-
-	/* range: 0 - 15000 (Msec) default: 1000 */
-	u16 bt_anti_starvation_period;
-
-	/* range 400-10000(Usec) default: 3000 */
-	u16 next_bt_lp_packet;
-
-	/* Deafult: worst case for BT DH5 traffic */
-	u16 wake_up_beacon;
-
-	/* range: 0-50000(Usec) default: 1050 */
-	u16 hp_dm_max_guard_time;
-
-	/*
-	 * This is to prevent both BT & WLAN antenna
-	 * starvation.
-	 * Range: 100-50000(Usec) default:2550
-	 */
-	u16 next_wlan_packet;
-
-	/* 0 -> shared antenna */
-	u8 antenna_type;
-
-	/*
-	 * 0 -> TI legacy
-	 * 1 -> Palau
-	 */
-	u8 signal_type;
-
-	/*
-	 * BT AFH status
-	 * 0 -> no AFH
-	 * 1 -> from dedicated GPIO
-	 * 2 -> AFH on (from host)
-	 */
-	u8 afh_leverage_on;
-
-	/*
-	 * The number of cycles during which no
-	 * TX will be sent after 1 cycle of RX
-	 * transaction in protective mode
-	 */
-	u8 quiet_cycle_num;
-
-	/*
-	 * The maximum number of CTSs that will
-	 * be sent for receiving RX packet in
-	 * protective mode
-	 */
-	u8 max_cts;
-
-	/*
-	 * The number of WLAN packets
-	 * transferred in common mode before
-	 * switching to BT.
-	 */
-	u8 wlan_packets_num;
-
-	/*
-	 * The number of BT packets
-	 * transferred in common mode before
-	 * switching to WLAN.
-	 */
-	u8 bt_packets_num;
-
-	/* range: 1-255  default: 5 */
-	u8 missed_rx_avalanche;
-
-	/* range: 0-1    default: 1 */
-	u8 wlan_elp_hp;
-
-	/* range: 0 - 15  default: 4 */
-	u8 bt_anti_starvation_cycles;
-
-	u8 ack_mode_dual_ant;
-
-	/*
-	 * Allow PA_SD assertion/de-assertion
-	 * during enabled BT activity.
-	 */
-	u8 pa_sd_enable;
-
-	/*
-	 * Enable/Disable PTA in auto mode:
-	 * Support Both Active & P.S modes
-	 */
-	u8 pta_auto_mode_enable;
-
-	/* range: 0 - 20  default: 1 */
-	u8 bt_hp_respected_num;
+	u32 per_threshold;
+	u32 max_scan_compensation_time;
+	u16 nfs_sample_interval;
+	u8 load_ratio;
+	u8 auto_ps_mode;
+	u8 probe_req_compensation;
+	u8 scan_window_compensation;
+	u8 antenna_config;
+	u8 beacon_miss_threshold;
+	u32 rate_adaptation_threshold;
+	s8 rate_adaptation_snr;
+	u8 padding[3];
 } __attribute__ ((packed));
 
 #define CCA_THRSH_ENABLE_ENERGY_D       0x140A
@@ -690,6 +582,10 @@ struct acx_event_mask {
 #define SCAN_TRIGGERED		BIT(2)
 #define SCAN_PRIORITY_HIGH	BIT(3)
 
+/* When set, disable HW encryption */
+#define DF_ENCRYPTION_DISABLE      0x01
+#define DF_SNIFF_MODE_ENABLE       0x80
+
 struct acx_feature_config {
 	struct acx_header header;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index eaa1de9..c7a8a64 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -229,8 +229,8 @@ int wl1271_cmd_join(struct wl1271 *wl)
 	join->rx_config_options = 0;
 	join->rx_filter_options = WL1271_DEFAULT_RX_FILTER;
 
-	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
-		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
+	join->basic_rate_set = CONF_HW_BIT_RATE_1MBPS | CONF_HW_BIT_RATE_2MBPS |
+		CONF_HW_BIT_RATE_5_5MBPS | CONF_HW_BIT_RATE_11MBPS;
 
 	join->beacon_interval = WL1271_DEFAULT_BEACON_INT;
 	join->dtim_interval = WL1271_DEFAULT_DTIM_PERIOD;
@@ -538,7 +538,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 
 	params->params.num_channels = num_channels;
 	params->params.num_probe_requests = probe_requests;
-	params->params.tx_rate = cpu_to_le32(RATE_MASK_2MBPS);
+	params->params.tx_rate = cpu_to_le32(CONF_HW_BIT_RATE_2MBPS);
 	params->params.tid_trigger = 0;
 	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 0219664..9143087 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -288,11 +288,6 @@ struct wl1271_cmd_ps_params {
 #define NUM_ACCESS_CATEGORIES_COPY 4
 #define MAX_KEY_SIZE 32
 
-/* When set, disable HW encryption */
-#define DF_ENCRYPTION_DISABLE      0x01
-/* When set, disable HW decryption */
-#define DF_SNIFF_MODE_ENABLE       0x80
-
 enum wl1271_cmd_key_action {
 	KEY_ADD_OR_REPLACE = 1,
 	KEY_REMOVE         = 2,
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
new file mode 100644
index 0000000..1d6a44b
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -0,0 +1,178 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
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
+#ifndef __WL1271_CONF_H__
+#define __WL1271_CONF_H__
+
+enum {
+	CONF_HW_BIT_RATE_1MBPS   = BIT(0),
+	CONF_HW_BIT_RATE_2MBPS   = BIT(1),
+	CONF_HW_BIT_RATE_5_5MBPS = BIT(2),
+	CONF_HW_BIT_RATE_6MBPS   = BIT(3),
+	CONF_HW_BIT_RATE_9MBPS   = BIT(4),
+	CONF_HW_BIT_RATE_11MBPS  = BIT(5),
+	CONF_HW_BIT_RATE_12MBPS  = BIT(6),
+	CONF_HW_BIT_RATE_18MBPS  = BIT(7),
+	CONF_HW_BIT_RATE_22MBPS  = BIT(8),
+	CONF_HW_BIT_RATE_24MBPS  = BIT(9),
+	CONF_HW_BIT_RATE_36MBPS  = BIT(10),
+	CONF_HW_BIT_RATE_48MBPS  = BIT(11),
+	CONF_HW_BIT_RATE_54MBPS  = BIT(12),
+	CONF_HW_BIT_RATE_MCS_0   = BIT(13),
+	CONF_HW_BIT_RATE_MCS_1   = BIT(14),
+	CONF_HW_BIT_RATE_MCS_2   = BIT(15),
+	CONF_HW_BIT_RATE_MCS_3   = BIT(16),
+	CONF_HW_BIT_RATE_MCS_4   = BIT(17),
+	CONF_HW_BIT_RATE_MCS_5   = BIT(18),
+	CONF_HW_BIT_RATE_MCS_6   = BIT(19),
+	CONF_HW_BIT_RATE_MCS_7   = BIT(20)
+};
+
+enum {
+	CONF_HW_RATE_INDEX_1MBPS   = 0,
+	CONF_HW_RATE_INDEX_2MBPS   = 1,
+	CONF_HW_RATE_INDEX_5_5MBPS = 2,
+	CONF_HW_RATE_INDEX_6MBPS   = 3,
+	CONF_HW_RATE_INDEX_9MBPS   = 4,
+	CONF_HW_RATE_INDEX_11MBPS  = 5,
+	CONF_HW_RATE_INDEX_12MBPS  = 6,
+	CONF_HW_RATE_INDEX_18MBPS  = 7,
+	CONF_HW_RATE_INDEX_22MBPS  = 8,
+	CONF_HW_RATE_INDEX_24MBPS  = 9,
+	CONF_HW_RATE_INDEX_36MBPS  = 10,
+	CONF_HW_RATE_INDEX_48MBPS  = 11,
+	CONF_HW_RATE_INDEX_54MBPS  = 12,
+	CONF_HW_RATE_INDEX_MAX     = CONF_HW_RATE_INDEX_54MBPS,
+};
+
+struct conf_sg_settings {
+	/*
+	 * Defines the PER threshold in PPM of the BT voice of which reaching
+	 * this value will trigger raising the priority of the BT voice by
+	 * the BT IP until next NFS sample interval time as defined in
+	 * nfs_sample_interval.
+	 *
+	 * Unit: PER value in PPM (parts per million)
+	 * #Error_packets / #Total_packets
+
+	 * Range: u32
+	 */
+	u32 per_threshold;
+
+	/*
+	 * This value is an absolute time in micro-seconds to limit the
+	 * maximum scan duration compensation while in SG
+	 */
+	u32 max_scan_compensation_time;
+
+	/* Defines the PER threshold of the BT voice of which reaching this
+	 * value will trigger raising the priority of the BT voice until next
+	 * NFS sample interval time as defined in sample_interval.
+	 *
+	 * Unit: msec
+	 * Range: 1-65000
+	 */
+	u16 nfs_sample_interval;
+
+	/*
+	 * Defines the load ratio for the BT.
+	 * The WLAN ratio is: 100 - load_ratio
+	 *
+	 * Unit: Percent
+	 * Range: 0-100
+	 */
+	u8 load_ratio;
+
+	/*
+	 * true - Co-ex is allowed to enter/exit P.S automatically and
+	 *        transparently to the host
+	 *
+	 * false - Co-ex is disallowed to enter/exit P.S and will trigger an
+	 *         event to the host to notify for the need to enter/exit P.S
+	 *         due to BT change state
+	 *
+	 */
+	u8 auto_ps_mode;
+
+	/*
+	 * This parameter defines the compensation percentage of num of probe
+	 * requests in case scan is initiated during BT voice/BT ACL
+	 * guaranteed link.
+	 *
+	 * Unit: Percent
+	 * Range: 0-255 (0 - No compensation)
+	 */
+	u8 probe_req_compensation;
+
+	/*
+	 * This parameter defines the compensation percentage of scan window
+	 * size in case scan is initiated during BT voice/BT ACL Guaranteed
+	 * link.
+	 *
+	 * Unit: Percent
+	 * Range: 0-255 (0 - No compensation)
+	 */
+	u8 scan_window_compensation;
+
+	/*
+	 * Defines the antenna configuration.
+	 *
+	 * Range: 0 - Single Antenna; 1 - Dual Antenna
+	 */
+	u8 antenna_config;
+
+	/*
+	 * The percent out of the Max consecutive beacon miss roaming trigger
+	 * which is the threshold for raising the priority of beacon
+	 * reception.
+	 *
+	 * Range: 1-100
+	 * N = MaxConsecutiveBeaconMiss
+	 * P = coexMaxConsecutiveBeaconMissPrecent
+	 * Threshold = MIN( N-1, round(N * P / 100))
+	 */
+	u8 beacon_miss_threshold;
+
+	/*
+	 * The RX rate threshold below which rate adaptation is assumed to be
+	 * occurring at the AP which will raise priority for ACTIVE_RX and RX
+	 * SP.
+	 *
+	 * Range: HW_BIT_RATE_*
+	 */
+	u32 rate_adaptation_threshold;
+
+	/*
+	 * The SNR above which the RX rate threshold indicating AP rate
+	 * adaptation is valid
+	 *
+	 * Range: -128 - 127
+	 */
+	s8 rate_adaptation_snr;
+};
+
+struct conf_drv_settings {
+	struct conf_sg_settings sg;
+};
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 821a775..69bc929 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -46,6 +46,39 @@
 #include "wl1271_cmd.h"
 #include "wl1271_boot.h"
 
+static void wl1271_conf_init(struct wl1271 *wl)
+{
+	struct conf_drv_settings conf = {
+		.sg = {
+			.per_threshold              = 7500,
+			.max_scan_compensation_time = 120000,
+			.nfs_sample_interval        = 400,
+			.load_ratio                 = 50,
+			.auto_ps_mode               = 0,
+			.probe_req_compensation     = 170,
+			.scan_window_compensation   = 50,
+			.antenna_config             = 0,
+			.beacon_miss_threshold      = 60,
+			.rate_adaptation_threshold  = CONF_HW_BIT_RATE_12MBPS,
+			.rate_adaptation_snr        = 0
+		}
+	};
+
+	/*
+	 * This function applies the default configuration to the driver. This
+	 * function is invoked upon driver load (spi probe.)
+	 *
+	 * The configuration is stored in a run-time structure in order to
+	 * facilitate for run-time adjustment of any of the parameters. Making
+	 * changes to the configuration structure will apply the new values on
+	 * the next interface up (wl1271_op_start.)
+	 */
+
+	/* apply driver default configuration */
+	memcpy(&wl->conf, &conf, sizeof(conf));
+}
+
+
 static int wl1271_plt_init(struct wl1271 *wl)
 {
 	int ret;
@@ -1180,44 +1213,44 @@ out:
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
 	{ .bitrate = 10,
-	  .hw_value = 0x1,
-	  .hw_value_short = 0x1, },
+	  .hw_value = CONF_HW_BIT_RATE_1MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_1MBPS, },
 	{ .bitrate = 20,
-	  .hw_value = 0x2,
-	  .hw_value_short = 0x2,
+	  .hw_value = CONF_HW_BIT_RATE_2MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_2MBPS,
 	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 	{ .bitrate = 55,
-	  .hw_value = 0x4,
-	  .hw_value_short = 0x4,
+	  .hw_value = CONF_HW_BIT_RATE_5_5MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_5_5MBPS,
 	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 	{ .bitrate = 110,
-	  .hw_value = 0x20,
-	  .hw_value_short = 0x20,
+	  .hw_value = CONF_HW_BIT_RATE_11MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_11MBPS,
 	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 	{ .bitrate = 60,
-	  .hw_value = 0x8,
-	  .hw_value_short = 0x8, },
+	  .hw_value = CONF_HW_BIT_RATE_6MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_6MBPS, },
 	{ .bitrate = 90,
-	  .hw_value = 0x10,
-	  .hw_value_short = 0x10, },
+	  .hw_value = CONF_HW_BIT_RATE_9MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_9MBPS, },
 	{ .bitrate = 120,
-	  .hw_value = 0x40,
-	  .hw_value_short = 0x40, },
+	  .hw_value = CONF_HW_BIT_RATE_12MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_12MBPS, },
 	{ .bitrate = 180,
-	  .hw_value = 0x80,
-	  .hw_value_short = 0x80, },
+	  .hw_value = CONF_HW_BIT_RATE_18MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_18MBPS, },
 	{ .bitrate = 240,
-	  .hw_value = 0x200,
-	  .hw_value_short = 0x200, },
+	  .hw_value = CONF_HW_BIT_RATE_24MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_24MBPS, },
 	{ .bitrate = 360,
-	 .hw_value = 0x400,
-	 .hw_value_short = 0x400, },
+	 .hw_value = CONF_HW_BIT_RATE_36MBPS,
+	 .hw_value_short = CONF_HW_BIT_RATE_36MBPS, },
 	{ .bitrate = 480,
-	  .hw_value = 0x800,
-	  .hw_value_short = 0x800, },
+	  .hw_value = CONF_HW_BIT_RATE_48MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_48MBPS, },
 	{ .bitrate = 540,
-	  .hw_value = 0x1000,
-	  .hw_value_short = 0x1000, },
+	  .hw_value = CONF_HW_BIT_RATE_54MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_54MBPS, },
 };
 
 /* can't be const, mac80211 writes to this */
@@ -1433,6 +1466,9 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	}
 	dev_set_drvdata(&wl1271_device.dev, wl);
 
+	/* Apply default driver configuration. */
+	wl1271_conf_init(wl);
+
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
 		goto out_platform;
diff --git a/drivers/net/wireless/wl12xx/wl1271_reg.h b/drivers/net/wireless/wl12xx/wl1271_reg.h
index 6af87b5..1f23738 100644
--- a/drivers/net/wireless/wl12xx/wl1271_reg.h
+++ b/drivers/net/wireless/wl12xx/wl1271_reg.h
@@ -613,50 +613,6 @@ enum {
 	MAX_RADIO_BANDS = 0xFF
 };
 
-enum {
-	NO_RATE      = 0,
-	RATE_1MBPS   = 0x0A,
-	RATE_2MBPS   = 0x14,
-	RATE_5_5MBPS = 0x37,
-	RATE_6MBPS   = 0x0B,
-	RATE_9MBPS   = 0x0F,
-	RATE_11MBPS  = 0x6E,
-	RATE_12MBPS  = 0x0A,
-	RATE_18MBPS  = 0x0E,
-	RATE_22MBPS  = 0xDC,
-	RATE_24MBPS  = 0x09,
-	RATE_36MBPS  = 0x0D,
-	RATE_48MBPS  = 0x08,
-	RATE_54MBPS  = 0x0C
-};
-
-enum {
-	RATE_INDEX_1MBPS   =  0,
-	RATE_INDEX_2MBPS   =  1,
-	RATE_INDEX_5_5MBPS =  2,
-	RATE_INDEX_6MBPS   =  3,
-	RATE_INDEX_9MBPS   =  4,
-	RATE_INDEX_11MBPS  =  5,
-	RATE_INDEX_12MBPS  =  6,
-	RATE_INDEX_18MBPS  =  7,
-	RATE_INDEX_22MBPS  =  8,
-	RATE_INDEX_24MBPS  =  9,
-	RATE_INDEX_36MBPS  =  10,
-	RATE_INDEX_48MBPS  =  11,
-	RATE_INDEX_54MBPS  =  12,
-	RATE_INDEX_MAX     =  RATE_INDEX_54MBPS,
-	MAX_RATE_INDEX,
-	INVALID_RATE_INDEX = MAX_RATE_INDEX,
-	RATE_INDEX_ENUM_MAX_SIZE = 0x7FFFFFFF
-};
-
-enum {
-	RATE_MASK_1MBPS = 0x1,
-	RATE_MASK_2MBPS = 0x2,
-	RATE_MASK_5_5MBPS = 0x4,
-	RATE_MASK_11MBPS = 0x20,
-};
-
 #define SHORT_PREAMBLE_BIT   BIT(0) /* CCK or Barker depending on the rate */
 #define OFDM_RATE_BIT        BIT(6)
 #define PBCC_RATE_BIT        BIT(7)
-- 
1.5.6.5

