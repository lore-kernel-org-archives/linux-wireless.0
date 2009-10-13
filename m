Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36101 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660AbZJMJtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:46 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 05/22] wl1271: Add config structure for connection management parameters
Date: Tue, 13 Oct 2009 12:47:42 +0300
Message-Id: <1255427279-1224-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add a configuration structure for connection management parameters, and
set default configuration values there.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 -
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   63 ++++++--
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   24 +---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h |  251 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   50 ++++++-
 6 files changed, 348 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 985e896..648223f 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -323,7 +323,6 @@ struct wl1271 {
 	u8 bss_type;
 	u8 ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 ssid_len;
-	u8 listen_int;
 	int channel;
 
 	struct wl1271_acx_mem_map *target_mem_map;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 038203b..d003686 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -34,8 +34,7 @@
 #include "wl1271_spi.h"
 #include "wl1271_ps.h"
 
-int wl1271_acx_wake_up_conditions(struct wl1271 *wl, u8 wake_up_event,
-				  u8 listen_interval)
+int wl1271_acx_wake_up_conditions(struct wl1271 *wl)
 {
 	struct acx_wake_up_condition *wake_up;
 	int ret;
@@ -48,8 +47,8 @@ int wl1271_acx_wake_up_conditions(struct wl1271 *wl, u8 wake_up_event,
 		goto out;
 	}
 
-	wake_up->wake_up_event = wake_up_event;
-	wake_up->listen_interval = listen_interval;
+	wake_up->wake_up_event = wl->conf.conn.wake_up_event;
+	wake_up->listen_interval = wl->conf.conn.listen_interval;
 
 	ret = wl1271_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
 				   wake_up, sizeof(*wake_up));
@@ -393,11 +392,15 @@ out:
 
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter)
 {
-	struct acx_beacon_filter_option *beacon_filter;
-	int ret;
+	struct acx_beacon_filter_option *beacon_filter = NULL;
+	int ret = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx beacon filter opt");
 
+	if (enable_filter &&
+	    wl->conf.conn.bcn_filt_mode == CONF_BCN_FILT_MODE_DISABLED)
+		goto out;
+
 	beacon_filter = kzalloc(sizeof(*beacon_filter), GFP_KERNEL);
 	if (!beacon_filter) {
 		ret = -ENOMEM;
@@ -405,6 +408,11 @@ int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter)
 	}
 
 	beacon_filter->enable = enable_filter;
+
+	/*
+	 * When set to zero, and the filter is enabled, beacons
+	 * without the unicast TIM bit set are dropped.
+	 */
 	beacon_filter->max_num_beacons = 0;
 
 	ret = wl1271_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
@@ -422,8 +430,9 @@ out:
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
 {
 	struct acx_beacon_filter_ie_table *ie_table;
-	int idx = 0;
+	int i, idx = 0;
 	int ret;
+	bool vendor_spec = false;
 
 	wl1271_debug(DEBUG_ACX, "acx beacon filter table");
 
@@ -434,9 +443,31 @@ int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
 	}
 
 	/* configure default beacon pass-through rules */
-	ie_table->num_ie = 1;
-	ie_table->table[idx++] = BEACON_FILTER_IE_ID_CHANNEL_SWITCH_ANN;
-	ie_table->table[idx++] = BEACON_RULE_PASS_ON_APPEARANCE;
+	ie_table->num_ie = 0;
+	for (i = 0; i < wl->conf.conn.bcn_filt_ie_count; i++) {
+		struct conf_bcn_filt_rule *r = &(wl->conf.conn.bcn_filt_ie[i]);
+		ie_table->table[idx++] = r->ie;
+		ie_table->table[idx++] = r->rule;
+
+		if (r->ie == WLAN_EID_VENDOR_SPECIFIC) {
+			/* only one vendor specific ie allowed */
+			if (vendor_spec)
+				continue;
+
+			/* for vendor specific rules configure the
+			   additional fields */
+			memcpy(&(ie_table->table[idx]), r->oui,
+			       CONF_BCN_IE_OUI_LEN);
+			idx += CONF_BCN_IE_OUI_LEN;
+			ie_table->table[idx++] = r->type;
+			memcpy(&(ie_table->table[idx]), r->version,
+			       CONF_BCN_IE_VER_LEN);
+			idx += CONF_BCN_IE_VER_LEN;
+			vendor_spec = true;
+		}
+
+		ie_table->num_ie++;
+	}
 
 	ret = wl1271_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
 				   ie_table, sizeof(*ie_table));
@@ -463,8 +494,8 @@ int wl1271_acx_conn_monit_params(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->synch_fail_thold = SYNCH_FAIL_DEFAULT_THRESHOLD;
-	acx->bss_lose_timeout = NO_BEACON_DEFAULT_TIMEOUT;
+	acx->synch_fail_thold = wl->conf.conn.synch_fail_thold;
+	acx->bss_lose_timeout = wl->conf.conn.bss_lose_timeout;
 
 	ret = wl1271_cmd_configure(wl, ACX_CONN_MONIT_PARAMS,
 				   acx, sizeof(*acx));
@@ -585,10 +616,10 @@ int wl1271_acx_bcn_dtim_options(struct wl1271 *wl)
 		goto out;
 	}
 
-	bb->beacon_rx_timeout = BCN_RX_TIMEOUT_DEF_VALUE;
-	bb->broadcast_timeout = BROADCAST_RX_TIMEOUT_DEF_VALUE;
-	bb->rx_broadcast_in_ps = RX_BROADCAST_IN_PS_DEF_VALUE;
-	bb->ps_poll_threshold = CONSECUTIVE_PS_POLL_FAILURE_DEF;
+	bb->beacon_rx_timeout = wl->conf.conn.beacon_rx_timeout;
+	bb->broadcast_timeout = wl->conf.conn.broadcast_timeout;
+	bb->rx_broadcast_in_ps = wl->conf.conn.rx_broadcast_in_ps;
+	bb->ps_poll_threshold = wl->conf.conn.ps_poll_threshold;
 
 	ret = wl1271_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 63cddce..73ef2bd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -377,11 +377,6 @@ struct acx_beacon_filter_option {
 			   (BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM * \
 			    BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE))
 
-#define BEACON_RULE_PASS_ON_CHANGE                     BIT(0)
-#define BEACON_RULE_PASS_ON_APPEARANCE                 BIT(1)
-
-#define BEACON_FILTER_IE_ID_CHANNEL_SWITCH_ANN         (37)
-
 struct acx_beacon_filter_ie_table {
 	struct acx_header header;
 
@@ -390,9 +385,6 @@ struct acx_beacon_filter_ie_table {
 	u8 pad[3];
 } __attribute__ ((packed));
 
-#define SYNCH_FAIL_DEFAULT_THRESHOLD    5     /* number of beacons */
-#define NO_BEACON_DEFAULT_TIMEOUT       (100) /* TU */
-
 struct acx_conn_monit_params {
        struct acx_header header;
 
@@ -497,11 +489,6 @@ struct acx_energy_detection {
 	u8 pad;
 } __attribute__ ((packed));
 
-#define BCN_RX_TIMEOUT_DEF_VALUE        10000
-#define BROADCAST_RX_TIMEOUT_DEF_VALUE  20000
-#define RX_BROADCAST_IN_PS_DEF_VALUE    1
-#define CONSECUTIVE_PS_POLL_FAILURE_DEF 4
-
 struct acx_beacon_broadcast {
 	struct acx_header header;
 
@@ -575,14 +562,6 @@ struct acx_current_tx_power {
 	u8  padding[3];
 } __attribute__ ((packed));
 
-enum acx_wake_up_event {
-	WAKE_UP_EVENT_BEACON_BITMAP	= 0x01, /* Wake on every Beacon*/
-	WAKE_UP_EVENT_DTIM_BITMAP	= 0x02,	/* Wake on every DTIM*/
-	WAKE_UP_EVENT_N_DTIM_BITMAP	= 0x04, /* Wake on every Nth DTIM */
-	WAKE_UP_EVENT_N_BEACONS_BITMAP	= 0x08, /* Wake on every Nth Beacon */
-	WAKE_UP_EVENT_BITS_MASK		= 0x0F
-};
-
 struct acx_wake_up_condition {
 	struct acx_header header;
 
@@ -1038,8 +1017,7 @@ enum {
 };
 
 
-int wl1271_acx_wake_up_conditions(struct wl1271 *wl, u8 wake_up_event,
-				  u8 listen_interval);
+int wl1271_acx_wake_up_conditions(struct wl1271 *wl);
 int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth);
 int wl1271_acx_fw_version(struct wl1271 *wl, char *buf, size_t len);
 int wl1271_acx_tx_power(struct wl1271 *wl, int power);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index f05bd77..f38e3e0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -436,8 +436,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
 	int ret = 0;
 
 	/* FIXME: this should be in ps.c */
-	ret = wl1271_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
-					    wl->listen_int);
+	ret = wl1271_acx_wake_up_conditions(wl);
 	if (ret < 0) {
 		wl1271_error("couldn't set wake up conditions");
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 3c5ce31..f08e509 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -441,10 +441,261 @@ struct conf_tx_settings {
 
 };
 
+enum {
+	CONF_WAKE_UP_EVENT_BEACON    = 0x01, /* Wake on every Beacon*/
+	CONF_WAKE_UP_EVENT_DTIM      = 0x02, /* Wake on every DTIM*/
+	CONF_WAKE_UP_EVENT_N_DTIM    = 0x04, /* Wake every Nth DTIM */
+	CONF_WAKE_UP_EVENT_N_BEACONS = 0x08, /* Wake every Nth beacon */
+	CONF_WAKE_UP_EVENT_BITS_MASK = 0x0F
+};
+
+#define CONF_MAX_BCN_FILT_IE_COUNT 32
+
+#define CONF_BCN_RULE_PASS_ON_CHANGE         BIT(0)
+#define CONF_BCN_RULE_PASS_ON_APPEARANCE     BIT(1)
+
+#define CONF_BCN_IE_OUI_LEN    3
+#define CONF_BCN_IE_VER_LEN    2
+
+struct conf_bcn_filt_rule {
+	/*
+	 * IE number to which to associate a rule.
+	 *
+	 * Range: u8
+	 */
+	u8 ie;
+
+	/*
+	 * Rule to associate with the specific ie.
+	 *
+	 * Range: CONF_BCN_RULE_PASS_ON_*
+	 */
+	u8 rule;
+
+	/*
+	 * OUI for the vendor specifie IE (221)
+	 */
+	u8 oui[CONF_BCN_IE_OUI_LEN];
+
+	/*
+	 * Type for the vendor specifie IE (221)
+	 */
+	u8 type;
+
+	/*
+	 * Version for the vendor specifie IE (221)
+	 */
+	u8 version[CONF_BCN_IE_VER_LEN];
+};
+
+#define CONF_MAX_RSSI_SNR_TRIGGERS 8
+
+enum {
+	CONF_TRIG_METRIC_RSSI_BEACON = 0,
+	CONF_TRIG_METRIC_RSSI_DATA,
+	CONF_TRIG_METRIC_SNR_BEACON,
+	CONF_TRIG_METRIC_SNR_DATA
+};
+
+enum {
+	CONF_TRIG_EVENT_TYPE_LEVEL = 0,
+	CONF_TRIG_EVENT_TYPE_EDGE
+};
+
+enum {
+	CONF_TRIG_EVENT_DIR_LOW = 0,
+	CONF_TRIG_EVENT_DIR_HIGH,
+	CONF_TRIG_EVENT_DIR_BIDIR
+};
+
+
+struct conf_sig_trigger {
+	/*
+	 * The RSSI / SNR threshold value.
+	 *
+	 * FIXME: what is the range?
+	 */
+	s16 threshold;
+
+	/*
+	 * Minimum delay between two trigger events for this trigger in ms.
+	 *
+	 * Range: 0 - 60000
+	 */
+	u16 pacing;
+
+	/*
+	 * The measurement data source for this trigger.
+	 *
+	 * Range: CONF_TRIG_METRIC_*
+	 */
+	u8 metric;
+
+	/*
+	 * The trigger type of this trigger.
+	 *
+	 * Range: CONF_TRIG_EVENT_TYPE_*
+	 */
+	u8 type;
+
+	/*
+	 * The direction of the trigger.
+	 *
+	 * Range: CONF_TRIG_EVENT_DIR_*
+	 */
+	u8 direction;
+
+	/*
+	 * Hysteresis range of the trigger around the threshold (in dB)
+	 *
+	 * Range: u8
+	 */
+	u8 hysteresis;
+
+	/*
+	 * Index of the trigger rule.
+	 *
+	 * Range: 0 - CONF_MAX_RSSI_SNR_TRIGGERS-1
+	 */
+	u8 index;
+
+	/*
+	 * Enable / disable this rule (to use for clearing rules.)
+	 *
+	 * Range: 1 - Enabled, 2 - Not enabled
+	 */
+	u8 enable;
+};
+
+struct conf_sig_weights {
+
+	/*
+	 * RSSI from beacons average weight.
+	 *
+	 * Range: u8
+	 */
+	u8 rssi_bcn_avg_weight;
+
+	/*
+	 * RSSI from data average weight.
+	 *
+	 * Range: u8
+	 */
+	u8 rssi_pkt_avg_weight;
+
+	/*
+	 * SNR from beacons average weight.
+	 *
+	 * Range: u8
+	 */
+	u8 snr_bcn_avg_weight;
+
+	/*
+	 * SNR from data average weight.
+	 *
+	 * Range: u8
+	 */
+	u8 snr_pkt_avg_weight;
+};
+
+enum conf_bcn_filt_mode {
+	CONF_BCN_FILT_MODE_DISABLED = 0,
+	CONF_BCN_FILT_MODE_ENABLED = 1
+};
+
+struct conf_conn_settings {
+	/*
+	 * Firmware wakeup conditions configuration. The host may set only
+	 * one bit.
+	 *
+	 * Range: CONF_WAKE_UP_EVENT_*
+	 */
+	u8 wake_up_event;
+
+	/*
+	 * Listen interval for beacons or Dtims.
+	 *
+	 * Range: 0 for beacon and Dtim wakeup
+	 *        1-10 for x Dtims
+	 *        1-255 for x beacons
+	 */
+	u8 listen_interval;
+
+	/*
+	 * Enable or disable the beacon filtering.
+	 *
+	 * Range: CONF_BCN_FILT_MODE_*
+	 */
+	enum conf_bcn_filt_mode bcn_filt_mode;
+
+	/*
+	 * Configure Beacon filter pass-thru rules.
+	 */
+	u8 bcn_filt_ie_count;
+	struct conf_bcn_filt_rule bcn_filt_ie[CONF_MAX_BCN_FILT_IE_COUNT];
+
+	/*
+	 * The number of consequtive beacons to lose, before the firmware
+	 * becomes out of synch.
+	 *
+	 * Range: u32
+	 */
+	u32 synch_fail_thold;
+
+	/*
+	 * After out-of-synch, the number of TU's to wait without a further
+	 * received beacon (or probe response) before issuing the BSS_EVENT_LOSE
+	 * event.
+	 *
+	 * Range: u32
+	 */
+	u32 bss_lose_timeout;
+
+	/*
+	 * Beacon receive timeout.
+	 *
+	 * Range: u32
+	 */
+	u32 beacon_rx_timeout;
+
+	/*
+	 * Broadcast receive timeout.
+	 *
+	 * Range: u32
+	 */
+	u32 broadcast_timeout;
+
+	/*
+	 * Enable/disable reception of broadcast packets in power save mode
+	 *
+	 * Range: 1 - enable, 0 - disable
+	 */
+	u8 rx_broadcast_in_ps;
+
+	/*
+	 * Consequtive PS Poll failures before sending event to driver
+	 *
+	 * Range: u8
+	 */
+	u8 ps_poll_threshold;
+
+	/*
+	 * Configuration of signal (rssi/snr) triggers.
+	 */
+	u8 sig_trigger_count;
+	struct conf_sig_trigger sig_trigger[CONF_MAX_RSSI_SNR_TRIGGERS];
+
+	/*
+	 * Configuration of signal average weights.
+	 */
+	struct conf_sig_weights sig_weights;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
 	struct conf_tx_settings tx;
+	struct conf_conn_settings conn;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 35d0b7e..a559a15 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -176,6 +176,54 @@ static void wl1271_conf_init(struct wl1271 *wl)
 			.frag_threshold          = IEEE80211_MAX_FRAG_THRESHOLD,
 			.tx_compl_timeout           = 5,
 			.tx_compl_threshold         = 5
+		},
+		.conn = {
+			.wake_up_event           = CONF_WAKE_UP_EVENT_DTIM,
+			.listen_interval            = 0,
+			.bcn_filt_mode             = CONF_BCN_FILT_MODE_ENABLED,
+			.bcn_filt_ie_count          = 1,
+			.bcn_filt_ie = {
+				[0] = {
+					.ie         = WLAN_EID_CHANNEL_SWITCH,
+					.rule       =
+					CONF_BCN_RULE_PASS_ON_APPEARANCE,
+				}
+			},
+			.synch_fail_thold           = 5,
+			.bss_lose_timeout           = 100,
+			.beacon_rx_timeout          = 10000,
+			.broadcast_timeout          = 20000,
+			.rx_broadcast_in_ps         = 1,
+			.ps_poll_threshold          = 4,
+			.sig_trigger_count          = 2,
+			.sig_trigger = {
+				[0] = {
+					.threshold  = -75,
+					.pacing     = 500,
+					.metric  = CONF_TRIG_METRIC_RSSI_BEACON,
+					.type       = CONF_TRIG_EVENT_TYPE_EDGE,
+					.direction  = CONF_TRIG_EVENT_DIR_LOW,
+					.hysteresis = 2,
+					.index      = 0,
+					.enable     = 1
+				},
+				[1] = {
+					.threshold  = -75,
+					.pacing     = 500,
+					.metric  = CONF_TRIG_METRIC_RSSI_BEACON,
+					.type       = CONF_TRIG_EVENT_TYPE_EDGE,
+					.direction  = CONF_TRIG_EVENT_DIR_HIGH,
+					.hysteresis = 2,
+					.index      = 1,
+					.enable     = 1
+				}
+			},
+			.sig_weights = {
+				.rssi_bcn_avg_weight = 10,
+				.rssi_pkt_avg_weight = 10,
+				.snr_bcn_avg_weight  = 10,
+				.snr_pkt_avg_weight  = 10
+			}
 		}
 	};
 
@@ -765,7 +813,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	memset(wl->bssid, 0, ETH_ALEN);
 	memset(wl->ssid, 0, IW_ESSID_MAX_SIZE + 1);
 	wl->ssid_len = 0;
-	wl->listen_int = 1;
 	wl->bss_type = MAX_BSS_TYPE;
 	wl->band = IEEE80211_BAND_2GHZ;
 
@@ -1504,7 +1551,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->scanning = false;
 	wl->default_key = 0;
-	wl->listen_int = 1;
 	wl->rx_counter = 0;
 	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
-- 
1.5.6.5

