Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:45348 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756989Ab2FGUkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:40:20 -0400
Received: by lboj14 with SMTP id j14so1120170lbo.35
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:48 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 7/9] wlcore/wl18xx: the conf structs must be packed so they can be exported
Date: Thu,  7 Jun 2012 23:39:26 +0300
Message-Id: <1339101568-25346-8-git-send-email-coelho@ti.com> (sfid-20120607_224032_042298_C0C81F0C)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we are now going to export the conf structure and read it from a
file, it should be packed to avoid surprises with padding bytes.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |    4 +--
 drivers/net/wireless/ti/wlcore/conf.h |   44 ++++++++++++++++-----------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index 4e0f189..b75a6d3 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -48,10 +48,10 @@ struct wl18xx_conf_phy {
 	s8 low_power_val;
 	s8 med_power_val;
 	s8 high_power_val;
-};
+} __packed;
 
 struct wl18xx_priv_conf {
 	struct wl18xx_conf_phy phy;
-};
+} __packed;
 
 #endif /* __WL18XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 0950bd2..27d919f 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -318,7 +318,7 @@ enum {
 struct conf_sg_settings {
 	u32 params[CONF_SG_PARAMS_MAX];
 	u8 state;
-};
+} __packed;
 
 enum conf_rx_queue_type {
 	CONF_RX_QUEUE_TYPE_LOW_PRIORITY,  /* All except the high priority */
@@ -402,7 +402,7 @@ struct conf_rx_settings {
 	 * Range: RX_QUEUE_TYPE_RX_LOW_PRIORITY, RX_QUEUE_TYPE_RX_HIGH_PRIORITY,
 	 */
 	u8 queue_type;
-};
+} __packed;
 
 #define CONF_TX_MAX_RATE_CLASSES       10
 
@@ -501,7 +501,7 @@ struct conf_tx_rate_class {
 	 *               the policy (0 - long preamble, 1 - short preamble.
 	 */
 	u8 aflags;
-};
+} __packed;
 
 #define CONF_TX_MAX_AC_COUNT 4
 
@@ -558,7 +558,7 @@ struct conf_tx_ac_category {
 	 * Range: u16
 	 */
 	u16 tx_op_limit;
-};
+} __packed;
 
 #define CONF_TX_MAX_TID_COUNT 8
 
@@ -592,7 +592,7 @@ struct conf_tx_tid {
 	u8 ps_scheme;
 	u8 ack_policy;
 	u32 apsd_conf[2];
-};
+} __packed;
 
 struct conf_tx_settings {
 	/*
@@ -678,7 +678,7 @@ struct conf_tx_settings {
 
 	/* Time in ms for Tx watchdog timer to expire */
 	u32 tx_watchdog_timeout;
-};
+} __packed;
 
 enum {
 	CONF_WAKE_UP_EVENT_BEACON    = 0x01, /* Wake on every Beacon*/
@@ -725,7 +725,7 @@ struct conf_bcn_filt_rule {
 	 * Version for the vendor specifie IE (221)
 	 */
 	u8 version[CONF_BCN_IE_VER_LEN];
-};
+} __packed;
 
 #define CONF_MAX_RSSI_SNR_TRIGGERS 8
 
@@ -776,7 +776,7 @@ struct conf_sig_weights {
 	 * Range: u8
 	 */
 	u8 snr_pkt_avg_weight;
-};
+} __packed;
 
 enum conf_bcn_filt_mode {
 	CONF_BCN_FILT_MODE_DISABLED = 0,
@@ -951,7 +951,7 @@ struct conf_conn_settings {
 	 * Range: u16
 	 */
 	u8 max_listen_interval;
-};
+} __packed;
 
 enum {
 	CONF_REF_CLK_19_2_E,
@@ -979,7 +979,7 @@ struct conf_itrim_settings {
 
 	/* moderation timeout in microsecs from the last TX */
 	u32 timeout;
-};
+} __packed;
 
 enum conf_fast_wakeup {
 	CONF_FAST_WAKEUP_ENABLE,
@@ -1000,7 +1000,7 @@ struct conf_pm_config_settings {
 	 * Range: enum conf_fast_wakeup
 	 */
 	u8 host_fast_wakeup_support;
-};
+} __packed;
 
 struct conf_roam_trigger_settings {
 	/*
@@ -1037,7 +1037,7 @@ struct conf_roam_trigger_settings {
 	 * Range: 0 - 255
 	 */
 	u8 avg_weight_snr_data;
-};
+} __packed;
 
 struct conf_scan_settings {
 	/*
@@ -1083,7 +1083,7 @@ struct conf_scan_settings {
 	 * Range: u32 Microsecs
 	 */
 	u32 split_scan_timeout;
-};
+} __packed;
 
 struct conf_sched_scan_settings {
 	/*
@@ -1121,7 +1121,7 @@ struct conf_sched_scan_settings {
 
 	/* SNR threshold to be used for filtering */
 	s8 snr_threshold;
-};
+} __packed;
 
 struct conf_ht_setting {
 	u8 rx_ba_win_size;
@@ -1130,7 +1130,7 @@ struct conf_ht_setting {
 
 	/* bitmap of enabled TIDs for TX BA sessions */
 	u8 tx_ba_tid_bitmap;
-};
+} __packed;
 
 struct conf_memory_settings {
 	/* Number of stations supported in IBSS mode */
@@ -1170,7 +1170,7 @@ struct conf_memory_settings {
 	 * Range: 0-120
 	 */
 	u8 tx_min;
-};
+} __packed;
 
 struct conf_fm_coex {
 	u8 enable;
@@ -1183,7 +1183,7 @@ struct conf_fm_coex {
 	u16 ldo_stabilization_time;
 	u8 fm_disturbed_band_margin;
 	u8 swallow_clk_diff;
-};
+} __packed;
 
 struct conf_rx_streaming_settings {
 	/*
@@ -1212,7 +1212,7 @@ struct conf_rx_streaming_settings {
 	 * enable rx streaming also when there is no coex activity
 	 */
 	u8 always;
-};
+} __packed;
 
 struct conf_fwlog {
 	/* Continuous or on-demand */
@@ -1236,7 +1236,7 @@ struct conf_fwlog {
 
 	/* Regulates the frequency of log messages */
 	u8 threshold;
-};
+} __packed;
 
 #define ACX_RATE_MGMT_NUM_OF_RATES 13
 struct conf_rate_policy_settings {
@@ -1255,7 +1255,7 @@ struct conf_rate_policy_settings {
 	u8 rate_check_up;
 	u8 rate_check_down;
 	u8 rate_retry_policy[ACX_RATE_MGMT_NUM_OF_RATES];
-};
+} __packed;
 
 struct conf_hangover_settings {
 	u32 recover_time;
@@ -1269,7 +1269,7 @@ struct conf_hangover_settings {
 	u8 quiet_time;
 	u8 increase_time;
 	u8 window_size;
-};
+} __packed;
 
 struct wlcore_conf {
 	struct conf_sg_settings sg;
@@ -1288,6 +1288,6 @@ struct wlcore_conf {
 	struct conf_fwlog fwlog;
 	struct conf_rate_policy_settings rate;
 	struct conf_hangover_settings hangover;
-};
+} __packed;
 
 #endif
-- 
1.7.10

