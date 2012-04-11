Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59982 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933050Ab2DKTyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:07 -0400
Received: by lagj5 with SMTP id j5so1083116lag.31
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:04 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 16/24] wlcore/wl12xx: move runtime configuration struct to the lower driver
Date: Wed, 11 Apr 2012 22:53:32 +0300
Message-Id: <1334174020-18957-17-git-send-email-coelho@ti.com> (sfid-20120411_215438_038052_4491178B)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configuration parameters vary with different chip families.  Some
of the parameters used only by some chip families, others should have
different value depending on the family.  Thus move the configuration
values from wlcore to wl12xx.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |  345 +++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/conf.h   |    2 +-
 drivers/net/wireless/ti/wlcore/main.c   |  359 +------------------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 +-
 4 files changed, 352 insertions(+), 356 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 083e1d8..242bb5f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -39,6 +39,344 @@
 #include "cmd.h"
 #include "acx.h"
 
+static struct wlcore_conf wl12xx_conf = {
+	.sg = {
+		.params = {
+			[CONF_SG_ACL_BT_MASTER_MIN_BR] = 10,
+			[CONF_SG_ACL_BT_MASTER_MAX_BR] = 180,
+			[CONF_SG_ACL_BT_SLAVE_MIN_BR] = 10,
+			[CONF_SG_ACL_BT_SLAVE_MAX_BR] = 180,
+			[CONF_SG_ACL_BT_MASTER_MIN_EDR] = 10,
+			[CONF_SG_ACL_BT_MASTER_MAX_EDR] = 80,
+			[CONF_SG_ACL_BT_SLAVE_MIN_EDR] = 10,
+			[CONF_SG_ACL_BT_SLAVE_MAX_EDR] = 80,
+			[CONF_SG_ACL_WLAN_PS_MASTER_BR] = 8,
+			[CONF_SG_ACL_WLAN_PS_SLAVE_BR] = 8,
+			[CONF_SG_ACL_WLAN_PS_MASTER_EDR] = 20,
+			[CONF_SG_ACL_WLAN_PS_SLAVE_EDR] = 20,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR] = 20,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR] = 35,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR] = 16,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR] = 35,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR] = 32,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR] = 50,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR] = 28,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR] = 50,
+			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR] = 10,
+			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR] = 20,
+			[CONF_SG_ACL_PASSIVE_SCAN_BT_BR] = 75,
+			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR] = 15,
+			[CONF_SG_ACL_PASSIVE_SCAN_BT_EDR] = 27,
+			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR] = 17,
+			/* active scan params */
+			[CONF_SG_AUTO_SCAN_PROBE_REQ] = 170,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3] = 50,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP] = 100,
+			/* passive scan params */
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_BR] = 800,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_EDR] = 200,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3] = 200,
+			/* passive scan in dual antenna params */
+			[CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN] = 0,
+			[CONF_SG_BCN_HV3_COLLISION_THRESH_IN_PASSIVE_SCAN] = 0,
+			[CONF_SG_TX_RX_PROTECTION_BWIDTH_IN_PASSIVE_SCAN] = 0,
+			/* general params */
+			[CONF_SG_STA_FORCE_PS_IN_BT_SCO] = 1,
+			[CONF_SG_ANTENNA_CONFIGURATION] = 0,
+			[CONF_SG_BEACON_MISS_PERCENT] = 60,
+			[CONF_SG_DHCP_TIME] = 5000,
+			[CONF_SG_RXT] = 1200,
+			[CONF_SG_TXT] = 1000,
+			[CONF_SG_ADAPTIVE_RXT_TXT] = 1,
+			[CONF_SG_GENERAL_USAGE_BIT_MAP] = 3,
+			[CONF_SG_HV3_MAX_SERVED] = 6,
+			[CONF_SG_PS_POLL_TIMEOUT] = 10,
+			[CONF_SG_UPSD_TIMEOUT] = 10,
+			[CONF_SG_CONSECUTIVE_CTS_THRESHOLD] = 2,
+			[CONF_SG_STA_RX_WINDOW_AFTER_DTIM] = 5,
+			[CONF_SG_STA_CONNECTION_PROTECTION_TIME] = 30,
+			/* AP params */
+			[CONF_AP_BEACON_MISS_TX] = 3,
+			[CONF_AP_RX_WINDOW_AFTER_BEACON] = 10,
+			[CONF_AP_BEACON_WINDOW_INTERVAL] = 2,
+			[CONF_AP_CONNECTION_PROTECTION_TIME] = 0,
+			[CONF_AP_BT_ACL_VAL_BT_SERVE_TIME] = 25,
+			[CONF_AP_BT_ACL_VAL_WL_SERVE_TIME] = 25,
+			/* CTS Diluting params */
+			[CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH] = 0,
+			[CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER] = 0,
+		},
+		.state = CONF_SG_PROTECTIVE,
+	},
+	.rx = {
+		.rx_msdu_life_time           = 512000,
+		.packet_detection_threshold  = 0,
+		.ps_poll_timeout             = 15,
+		.upsd_timeout                = 15,
+		.rts_threshold               = IEEE80211_MAX_RTS_THRESHOLD,
+		.rx_cca_threshold            = 0,
+		.irq_blk_threshold           = 0xFFFF,
+		.irq_pkt_threshold           = 0,
+		.irq_timeout                 = 600,
+		.queue_type                  = CONF_RX_QUEUE_TYPE_LOW_PRIORITY,
+	},
+	.tx = {
+		.tx_energy_detection         = 0,
+		.sta_rc_conf                 = {
+			.enabled_rates       = 0,
+			.short_retry_limit   = 10,
+			.long_retry_limit    = 10,
+			.aflags              = 0,
+		},
+		.ac_conf_count               = 4,
+		.ac_conf                     = {
+			[CONF_TX_AC_BE] = {
+				.ac          = CONF_TX_AC_BE,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = 3,
+				.tx_op_limit = 0,
+			},
+			[CONF_TX_AC_BK] = {
+				.ac          = CONF_TX_AC_BK,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = 7,
+				.tx_op_limit = 0,
+			},
+			[CONF_TX_AC_VI] = {
+				.ac          = CONF_TX_AC_VI,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = CONF_TX_AIFS_PIFS,
+				.tx_op_limit = 3008,
+			},
+			[CONF_TX_AC_VO] = {
+				.ac          = CONF_TX_AC_VO,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = CONF_TX_AIFS_PIFS,
+				.tx_op_limit = 1504,
+			},
+		},
+		.max_tx_retries = 100,
+		.ap_aging_period = 300,
+		.tid_conf_count = 4,
+		.tid_conf = {
+			[CONF_TX_AC_BE] = {
+				.queue_id    = CONF_TX_AC_BE,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+			[CONF_TX_AC_BK] = {
+				.queue_id    = CONF_TX_AC_BK,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
+				.tsid        = CONF_TX_AC_BK,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+			[CONF_TX_AC_VI] = {
+				.queue_id    = CONF_TX_AC_VI,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
+				.tsid        = CONF_TX_AC_VI,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+			[CONF_TX_AC_VO] = {
+				.queue_id    = CONF_TX_AC_VO,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
+				.tsid        = CONF_TX_AC_VO,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+		},
+		.frag_threshold              = IEEE80211_MAX_FRAG_THRESHOLD,
+		.tx_compl_timeout            = 700,
+		.tx_compl_threshold          = 4,
+		.basic_rate                  = CONF_HW_BIT_RATE_1MBPS,
+		.basic_rate_5                = CONF_HW_BIT_RATE_6MBPS,
+		.tmpl_short_retry_limit      = 10,
+		.tmpl_long_retry_limit       = 10,
+		.tx_watchdog_timeout         = 5000,
+	},
+	.conn = {
+		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
+		.listen_interval             = 1,
+		.suspend_wake_up_event       = CONF_WAKE_UP_EVENT_N_DTIM,
+		.suspend_listen_interval     = 3,
+		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
+		.bcn_filt_ie_count           = 2,
+		.bcn_filt_ie = {
+			[0] = {
+				.ie          = WLAN_EID_CHANNEL_SWITCH,
+				.rule        = CONF_BCN_RULE_PASS_ON_APPEARANCE,
+			},
+			[1] = {
+				.ie          = WLAN_EID_HT_OPERATION,
+				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
+			},
+		},
+		.synch_fail_thold            = 10,
+		.bss_lose_timeout            = 100,
+		.beacon_rx_timeout           = 10000,
+		.broadcast_timeout           = 20000,
+		.rx_broadcast_in_ps          = 1,
+		.ps_poll_threshold           = 10,
+		.bet_enable                  = CONF_BET_MODE_ENABLE,
+		.bet_max_consecutive         = 50,
+		.psm_entry_retries           = 8,
+		.psm_exit_retries            = 16,
+		.psm_entry_nullfunc_retries  = 3,
+		.dynamic_ps_timeout          = 40,
+		.forced_ps                   = false,
+		.keep_alive_interval         = 55000,
+		.max_listen_interval         = 20,
+	},
+	.itrim = {
+		.enable = false,
+		.timeout = 50000,
+	},
+	.pm_config = {
+		.host_clk_settling_time = 5000,
+		.host_fast_wakeup_support = false
+	},
+	.roam_trigger = {
+		.trigger_pacing               = 1,
+		.avg_weight_rssi_beacon       = 20,
+		.avg_weight_rssi_data         = 10,
+		.avg_weight_snr_beacon        = 20,
+		.avg_weight_snr_data          = 10,
+	},
+	.scan = {
+		.min_dwell_time_active        = 7500,
+		.max_dwell_time_active        = 30000,
+		.min_dwell_time_passive       = 100000,
+		.max_dwell_time_passive       = 100000,
+		.num_probe_reqs               = 2,
+		.split_scan_timeout           = 50000,
+	},
+	.sched_scan = {
+		/*
+		 * Values are in TU/1000 but since sched scan FW command
+		 * params are in TUs rounding up may occur.
+		 */
+		.base_dwell_time		= 7500,
+		.max_dwell_time_delta		= 22500,
+		/* based on 250bits per probe @1Mbps */
+		.dwell_time_delta_per_probe	= 2000,
+		/* based on 250bits per probe @6Mbps (plus a bit more) */
+		.dwell_time_delta_per_probe_5	= 350,
+		.dwell_time_passive		= 100000,
+		.dwell_time_dfs			= 150000,
+		.num_probe_reqs			= 2,
+		.rssi_threshold			= -90,
+		.snr_threshold			= 0,
+	},
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
+	.ht = {
+		.rx_ba_win_size = 8,
+		.tx_ba_win_size = 64,
+		.inactivity_timeout = 10000,
+		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
+	},
+	.mem_wl127x = {
+		.num_stations                 = 1,
+		.ssid_profiles                = 1,
+		.rx_block_num                 = 70,
+		.tx_min_block_num             = 40,
+		.dynamic_memory               = 1,
+		.min_req_tx_blocks            = 100,
+		.min_req_rx_blocks            = 22,
+		.tx_min                       = 27,
+	},
+	.mem_wl128x = {
+		.num_stations                 = 1,
+		.ssid_profiles                = 1,
+		.rx_block_num                 = 40,
+		.tx_min_block_num             = 40,
+		.dynamic_memory               = 1,
+		.min_req_tx_blocks            = 45,
+		.min_req_rx_blocks            = 22,
+		.tx_min                       = 27,
+	},
+	.fm_coex = {
+		.enable                       = true,
+		.swallow_period               = 5,
+		.n_divider_fref_set_1         = 0xff,       /* default */
+		.n_divider_fref_set_2         = 12,
+		.m_divider_fref_set_1         = 148,
+		.m_divider_fref_set_2         = 0xffff,     /* default */
+		.coex_pll_stabilization_time  = 0xffffffff, /* default */
+		.ldo_stabilization_time       = 0xffff,     /* default */
+		.fm_disturbed_band_margin     = 0xff,       /* default */
+		.swallow_clk_diff             = 0xff,       /* default */
+	},
+	.rx_streaming = {
+		.duration                      = 150,
+		.queues                        = 0x1,
+		.interval                      = 20,
+		.always                        = 0,
+	},
+	.fwlog = {
+		.mode                         = WL12XX_FWLOG_ON_DEMAND,
+		.mem_blocks                   = 2,
+		.severity                     = 0,
+		.timestamp                    = WL12XX_FWLOG_TIMESTAMP_DISABLED,
+		.output                       = WL12XX_FWLOG_OUTPUT_HOST,
+		.threshold                    = 0,
+	},
+	.rate = {
+		.rate_retry_score = 32000,
+		.per_add = 8192,
+		.per_th1 = 2048,
+		.per_th2 = 4096,
+		.max_per = 8100,
+		.inverse_curiosity_factor = 5,
+		.tx_fail_low_th = 4,
+		.tx_fail_high_th = 10,
+		.per_alpha_shift = 4,
+		.per_add_shift = 13,
+		.per_beta1_shift = 10,
+		.per_beta2_shift = 8,
+		.rate_check_up = 2,
+		.rate_check_down = 12,
+		.rate_retry_policy = {
+			0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00,
+		},
+	},
+	.hangover = {
+		.recover_time               = 0,
+		.hangover_period            = 20,
+		.dynamic_mode               = 1,
+		.early_termination_mode     = 1,
+		.max_period                 = 20,
+		.min_period                 = 1,
+		.increase_delta             = 1,
+		.decrease_delta             = 2,
+		.quiet_time                 = 4,
+		.increase_time              = 1,
+		.window_size                = 16,
+	},
+};
+
+
 #define WL12XX_TX_HW_BLOCK_SPARE_DEFAULT        1
 #define WL12XX_TX_HW_BLOCK_GEM_SPARE            2
 #define WL12XX_TX_HW_BLOCK_SIZE                 252
@@ -841,6 +1179,12 @@ out:
 	return ret;
 }
 
+static void wl12xx_conf_init(struct wl1271 *wl)
+{
+	/* apply driver default configuration */
+	memcpy(&wl->conf, &wl12xx_conf, sizeof(wl12xx_conf));
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -947,6 +1291,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
+	wl12xx_conf_init(wl);
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 11b6951..4e04e86 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1272,7 +1272,7 @@ struct conf_hangover_settings {
 	u8 window_size;
 };
 
-struct conf_drv_settings {
+struct wlcore_conf {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
 	struct conf_tx_settings tx;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6a98013..d351c8f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -53,342 +53,7 @@
 
 #define WL1271_BOOT_RETRIES 3
 
-static struct conf_drv_settings default_conf = {
-	.sg = {
-		.params = {
-			[CONF_SG_ACL_BT_MASTER_MIN_BR] = 10,
-			[CONF_SG_ACL_BT_MASTER_MAX_BR] = 180,
-			[CONF_SG_ACL_BT_SLAVE_MIN_BR] = 10,
-			[CONF_SG_ACL_BT_SLAVE_MAX_BR] = 180,
-			[CONF_SG_ACL_BT_MASTER_MIN_EDR] = 10,
-			[CONF_SG_ACL_BT_MASTER_MAX_EDR] = 80,
-			[CONF_SG_ACL_BT_SLAVE_MIN_EDR] = 10,
-			[CONF_SG_ACL_BT_SLAVE_MAX_EDR] = 80,
-			[CONF_SG_ACL_WLAN_PS_MASTER_BR] = 8,
-			[CONF_SG_ACL_WLAN_PS_SLAVE_BR] = 8,
-			[CONF_SG_ACL_WLAN_PS_MASTER_EDR] = 20,
-			[CONF_SG_ACL_WLAN_PS_SLAVE_EDR] = 20,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR] = 20,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR] = 35,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR] = 16,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR] = 35,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR] = 32,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR] = 50,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR] = 28,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR] = 50,
-			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR] = 10,
-			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR] = 20,
-			[CONF_SG_ACL_PASSIVE_SCAN_BT_BR] = 75,
-			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR] = 15,
-			[CONF_SG_ACL_PASSIVE_SCAN_BT_EDR] = 27,
-			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR] = 17,
-			/* active scan params */
-			[CONF_SG_AUTO_SCAN_PROBE_REQ] = 170,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3] = 50,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP] = 100,
-			/* passive scan params */
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_BR] = 800,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_EDR] = 200,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3] = 200,
-			/* passive scan in dual antenna params */
-			[CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN] = 0,
-			[CONF_SG_BCN_HV3_COLLISION_THRESH_IN_PASSIVE_SCAN] = 0,
-			[CONF_SG_TX_RX_PROTECTION_BWIDTH_IN_PASSIVE_SCAN] = 0,
-			/* general params */
-			[CONF_SG_STA_FORCE_PS_IN_BT_SCO] = 1,
-			[CONF_SG_ANTENNA_CONFIGURATION] = 0,
-			[CONF_SG_BEACON_MISS_PERCENT] = 60,
-			[CONF_SG_DHCP_TIME] = 5000,
-			[CONF_SG_RXT] = 1200,
-			[CONF_SG_TXT] = 1000,
-			[CONF_SG_ADAPTIVE_RXT_TXT] = 1,
-			[CONF_SG_GENERAL_USAGE_BIT_MAP] = 3,
-			[CONF_SG_HV3_MAX_SERVED] = 6,
-			[CONF_SG_PS_POLL_TIMEOUT] = 10,
-			[CONF_SG_UPSD_TIMEOUT] = 10,
-			[CONF_SG_CONSECUTIVE_CTS_THRESHOLD] = 2,
-			[CONF_SG_STA_RX_WINDOW_AFTER_DTIM] = 5,
-			[CONF_SG_STA_CONNECTION_PROTECTION_TIME] = 30,
-			/* AP params */
-			[CONF_AP_BEACON_MISS_TX] = 3,
-			[CONF_AP_RX_WINDOW_AFTER_BEACON] = 10,
-			[CONF_AP_BEACON_WINDOW_INTERVAL] = 2,
-			[CONF_AP_CONNECTION_PROTECTION_TIME] = 0,
-			[CONF_AP_BT_ACL_VAL_BT_SERVE_TIME] = 25,
-			[CONF_AP_BT_ACL_VAL_WL_SERVE_TIME] = 25,
-			/* CTS Diluting params */
-			[CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH] = 0,
-			[CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER] = 0,
-		},
-		.state = CONF_SG_PROTECTIVE,
-	},
-	.rx = {
-		.rx_msdu_life_time           = 512000,
-		.packet_detection_threshold  = 0,
-		.ps_poll_timeout             = 15,
-		.upsd_timeout                = 15,
-		.rts_threshold               = IEEE80211_MAX_RTS_THRESHOLD,
-		.rx_cca_threshold            = 0,
-		.irq_blk_threshold           = 0xFFFF,
-		.irq_pkt_threshold           = 0,
-		.irq_timeout                 = 600,
-		.queue_type                  = CONF_RX_QUEUE_TYPE_LOW_PRIORITY,
-	},
-	.tx = {
-		.tx_energy_detection         = 0,
-		.sta_rc_conf                 = {
-			.enabled_rates       = 0,
-			.short_retry_limit   = 10,
-			.long_retry_limit    = 10,
-			.aflags              = 0,
-		},
-		.ac_conf_count               = 4,
-		.ac_conf                     = {
-			[CONF_TX_AC_BE] = {
-				.ac          = CONF_TX_AC_BE,
-				.cw_min      = 15,
-				.cw_max      = 63,
-				.aifsn       = 3,
-				.tx_op_limit = 0,
-			},
-			[CONF_TX_AC_BK] = {
-				.ac          = CONF_TX_AC_BK,
-				.cw_min      = 15,
-				.cw_max      = 63,
-				.aifsn       = 7,
-				.tx_op_limit = 0,
-			},
-			[CONF_TX_AC_VI] = {
-				.ac          = CONF_TX_AC_VI,
-				.cw_min      = 15,
-				.cw_max      = 63,
-				.aifsn       = CONF_TX_AIFS_PIFS,
-				.tx_op_limit = 3008,
-			},
-			[CONF_TX_AC_VO] = {
-				.ac          = CONF_TX_AC_VO,
-				.cw_min      = 15,
-				.cw_max      = 63,
-				.aifsn       = CONF_TX_AIFS_PIFS,
-				.tx_op_limit = 1504,
-			},
-		},
-		.max_tx_retries = 100,
-		.ap_aging_period = 300,
-		.tid_conf_count = 4,
-		.tid_conf = {
-			[CONF_TX_AC_BE] = {
-				.queue_id    = CONF_TX_AC_BE,
-				.channel_type = CONF_CHANNEL_TYPE_EDCF,
-				.tsid        = CONF_TX_AC_BE,
-				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
-				.ack_policy  = CONF_ACK_POLICY_LEGACY,
-				.apsd_conf   = {0, 0},
-			},
-			[CONF_TX_AC_BK] = {
-				.queue_id    = CONF_TX_AC_BK,
-				.channel_type = CONF_CHANNEL_TYPE_EDCF,
-				.tsid        = CONF_TX_AC_BK,
-				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
-				.ack_policy  = CONF_ACK_POLICY_LEGACY,
-				.apsd_conf   = {0, 0},
-			},
-			[CONF_TX_AC_VI] = {
-				.queue_id    = CONF_TX_AC_VI,
-				.channel_type = CONF_CHANNEL_TYPE_EDCF,
-				.tsid        = CONF_TX_AC_VI,
-				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
-				.ack_policy  = CONF_ACK_POLICY_LEGACY,
-				.apsd_conf   = {0, 0},
-			},
-			[CONF_TX_AC_VO] = {
-				.queue_id    = CONF_TX_AC_VO,
-				.channel_type = CONF_CHANNEL_TYPE_EDCF,
-				.tsid        = CONF_TX_AC_VO,
-				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
-				.ack_policy  = CONF_ACK_POLICY_LEGACY,
-				.apsd_conf   = {0, 0},
-			},
-		},
-		.frag_threshold              = IEEE80211_MAX_FRAG_THRESHOLD,
-		.tx_compl_timeout            = 700,
-		.tx_compl_threshold          = 4,
-		.basic_rate                  = CONF_HW_BIT_RATE_1MBPS,
-		.basic_rate_5                = CONF_HW_BIT_RATE_6MBPS,
-		.tmpl_short_retry_limit      = 10,
-		.tmpl_long_retry_limit       = 10,
-		.tx_watchdog_timeout         = 5000,
-	},
-	.conn = {
-		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
-		.listen_interval             = 1,
-		.suspend_wake_up_event       = CONF_WAKE_UP_EVENT_N_DTIM,
-		.suspend_listen_interval     = 3,
-		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
-		.bcn_filt_ie_count           = 2,
-		.bcn_filt_ie = {
-			[0] = {
-				.ie          = WLAN_EID_CHANNEL_SWITCH,
-				.rule        = CONF_BCN_RULE_PASS_ON_APPEARANCE,
-			},
-			[1] = {
-				.ie          = WLAN_EID_HT_OPERATION,
-				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
-			},
-		},
-		.synch_fail_thold            = 10,
-		.bss_lose_timeout            = 100,
-		.beacon_rx_timeout           = 10000,
-		.broadcast_timeout           = 20000,
-		.rx_broadcast_in_ps          = 1,
-		.ps_poll_threshold           = 10,
-		.bet_enable                  = CONF_BET_MODE_ENABLE,
-		.bet_max_consecutive         = 50,
-		.psm_entry_retries           = 8,
-		.psm_exit_retries            = 16,
-		.psm_entry_nullfunc_retries  = 3,
-		.dynamic_ps_timeout          = 200,
-		.forced_ps                   = false,
-		.keep_alive_interval         = 55000,
-		.max_listen_interval         = 20,
-	},
-	.itrim = {
-		.enable = false,
-		.timeout = 50000,
-	},
-	.pm_config = {
-		.host_clk_settling_time = 5000,
-		.host_fast_wakeup_support = false
-	},
-	.roam_trigger = {
-		.trigger_pacing               = 1,
-		.avg_weight_rssi_beacon       = 20,
-		.avg_weight_rssi_data         = 10,
-		.avg_weight_snr_beacon        = 20,
-		.avg_weight_snr_data          = 10,
-	},
-	.scan = {
-		.min_dwell_time_active        = 7500,
-		.max_dwell_time_active        = 30000,
-		.min_dwell_time_passive       = 100000,
-		.max_dwell_time_passive       = 100000,
-		.num_probe_reqs               = 2,
-		.split_scan_timeout           = 50000,
-	},
-	.sched_scan = {
-		/*
-		 * Values are in TU/1000 but since sched scan FW command
-		 * params are in TUs rounding up may occur.
-		 */
-		.base_dwell_time              = 7500,
-		.max_dwell_time_delta         = 22500,
-		/* based on 250bits per probe @1Mbps */
-		.dwell_time_delta_per_probe   = 2000,
-		/* based on 250bits per probe @6Mbps (plus a bit more) */
-		.dwell_time_delta_per_probe_5 = 350,
-		.dwell_time_passive           = 100000,
-		.dwell_time_dfs               = 150000,
-		.num_probe_reqs               = 2,
-		.rssi_threshold               = -90,
-		.snr_threshold                = 0,
-	},
-	.rf = {
-		.tx_per_channel_power_compensation_2 = {
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-		},
-		.tx_per_channel_power_compensation_5 = {
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-		},
-	},
-	.ht = {
-		.rx_ba_win_size = 8,
-		.tx_ba_win_size = 64,
-		.inactivity_timeout = 10000,
-		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
-	},
-	.mem_wl127x = {
-		.num_stations                 = 1,
-		.ssid_profiles                = 1,
-		.rx_block_num                 = 70,
-		.tx_min_block_num             = 40,
-		.dynamic_memory               = 1,
-		.min_req_tx_blocks            = 100,
-		.min_req_rx_blocks            = 22,
-		.tx_min                       = 27,
-	},
-	.mem_wl128x = {
-		.num_stations                 = 1,
-		.ssid_profiles                = 1,
-		.rx_block_num                 = 40,
-		.tx_min_block_num             = 40,
-		.dynamic_memory               = 1,
-		.min_req_tx_blocks            = 45,
-		.min_req_rx_blocks            = 22,
-		.tx_min                       = 27,
-	},
-	.fm_coex = {
-		.enable                       = true,
-		.swallow_period               = 5,
-		.n_divider_fref_set_1         = 0xff,       /* default */
-		.n_divider_fref_set_2         = 12,
-		.m_divider_fref_set_1         = 148,
-		.m_divider_fref_set_2         = 0xffff,     /* default */
-		.coex_pll_stabilization_time  = 0xffffffff, /* default */
-		.ldo_stabilization_time       = 0xffff,     /* default */
-		.fm_disturbed_band_margin     = 0xff,       /* default */
-		.swallow_clk_diff             = 0xff,       /* default */
-	},
-	.rx_streaming = {
-		.duration                      = 150,
-		.queues                        = 0x1,
-		.interval                      = 20,
-		.always                        = 0,
-	},
-	.fwlog = {
-		.mode                         = WL12XX_FWLOG_ON_DEMAND,
-		.mem_blocks                   = 2,
-		.severity                     = 0,
-		.timestamp                    = WL12XX_FWLOG_TIMESTAMP_DISABLED,
-		.output                       = WL12XX_FWLOG_OUTPUT_HOST,
-		.threshold                    = 0,
-	},
-	.rate = {
-		.rate_retry_score = 32000,
-		.per_add = 8192,
-		.per_th1 = 2048,
-		.per_th2 = 4096,
-		.max_per = 8100,
-		.inverse_curiosity_factor = 5,
-		.tx_fail_low_th = 4,
-		.tx_fail_high_th = 10,
-		.per_alpha_shift = 4,
-		.per_add_shift = 13,
-		.per_beta1_shift = 10,
-		.per_beta2_shift = 8,
-		.rate_check_up = 2,
-		.rate_check_down = 12,
-		.rate_retry_policy = {
-			0x00, 0x00, 0x00, 0x00, 0x00,
-			0x00, 0x00, 0x00, 0x00, 0x00,
-			0x00, 0x00, 0x00,
-		},
-	},
-	.hangover = {
-		.recover_time               = 0,
-		.hangover_period            = 20,
-		.dynamic_mode               = 1,
-		.early_termination_mode     = 1,
-		.max_period                 = 20,
-		.min_period                 = 1,
-		.increase_delta             = 1,
-		.decrease_delta             = 2,
-		.quiet_time                 = 4,
-		.increase_time              = 1,
-		.window_size                = 16,
-	},
-};
+#define WL1271_BOOT_RETRIES 3
 
 static char *fwlog_param;
 static bool bug_on_recovery;
@@ -634,22 +299,8 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static void wl1271_conf_init(struct wl1271 *wl)
+static void wlcore_adjust_conf(struct wl1271 *wl)
 {
-
-	/*
-	 * This function applies the default configuration to the driver. This
-	 * function is invoked upon driver load (spi probe.)
-	 *
-	 * The configuration is stored in a run-time structure in order to
-	 * facilitate for run-time adjustment of any of the parameters. Making
-	 * changes to the configuration structure will apply the new values on
-	 * the next interface up (wl1271_op_start.)
-	 */
-
-	/* apply driver default configuration */
-	memcpy(&wl->conf, &default_conf, sizeof(default_conf));
-
 	/* Adjust settings according to optional module parameters */
 	if (fwlog_param) {
 		if (!strcmp(fwlog_param, "continuous")) {
@@ -5190,9 +4841,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	wl->fw_type = WL12XX_FW_TYPE_NONE;
 	mutex_init(&wl->mutex);
 
-	/* Apply default driver configuration. */
-	wl1271_conf_init(wl);
-
 	order = get_order(WL1271_AGGR_BUFFER_SIZE);
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
 	if (!wl->aggr_buf) {
@@ -5325,6 +4973,9 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 
 	BUG_ON(wl->num_tx_desc > WLCORE_MAX_TX_DESCRIPTORS);
 
+	/* adjust some runtime configuration parameters */
+	wlcore_adjust_conf(wl);
+
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->ref_clock = pdata->board_ref_clock;
 	wl->tcxo_clock = pdata->board_tcxo_clock;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 83f1d7c..9f33f96 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -261,7 +261,7 @@ struct wl1271 {
 	struct wl1271_tx_hw_res_if *tx_res_if;
 
 	/* Current chipset configuration */
-	struct conf_drv_settings conf;
+	struct wlcore_conf conf;
 
 	bool sg_enabled;
 
-- 
1.7.5.4

