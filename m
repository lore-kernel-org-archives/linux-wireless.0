Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab2EJJPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:23 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:22 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 24/78] wl18xx: add runtime configuration parameters
Date: Thu, 10 May 2012 12:13:29 +0300
Message-Id: <1336641263-5761-25-git-send-email-arik@wizery.com> (sfid-20120510_112352_464076_4A38FB61)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Now wlcore requires the lower drivers to set the correct
configuration.  Move the existing private configuration to the proper
place and add all generic configuration parameters.

The important changes are in Tx interrupt pacing and Rx BA window size.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h   |    4 +-
 drivers/net/wireless/ti/wl18xx/main.c   |  381 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    3 +
 3 files changed, 360 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index 7cd7bf1..d2b097e 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -48,9 +48,7 @@ struct wl18xx_conf_phy {
 	u8 secondary_clock_setting_time;
 };
 
-struct wl18xx_conf {
-	/* TODO: move the wlcore conf here? */
-
+struct wl18xx_priv_conf {
 	struct wl18xx_conf_phy phy;
 };
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 90fccb7..fd7a803 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -153,7 +153,324 @@ enum wl18xx_hw_rates {
 	WL18XX_CONF_HW_RXTX_RATE_MAX,
 };
 
-static struct wl18xx_conf wl18xx_default_conf = {
+static struct wlcore_conf wl18xx_conf = {
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
+		.tx_compl_timeout            = 350,
+		.tx_compl_threshold          = 10,
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
+	.ht = {
+		.rx_ba_win_size = 10,
+		.tx_ba_win_size = 10,
+		.inactivity_timeout = 10000,
+		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
+	},
+	.mem = {
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
+static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 	.phy = {
 		.phy_standalone			= 0x00,
 		.primary_clock_setting_time	= 0x05,
@@ -323,42 +640,43 @@ static void wl18xx_pre_upload(struct wl1271 *wl)
 
 static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 {
+	struct wl18xx_priv *priv = wl->priv;
+	struct wl18xx_conf_phy *phy = &priv->conf.phy;
 	struct wl18xx_mac_and_phy_params params;
 
 	memset(&params, 0, sizeof(params));
 
-	params.phy_standalone = wl18xx_default_conf.phy.phy_standalone;
-	params.rdl = wl18xx_default_conf.phy.rdl;
-	params.enable_clpc = wl18xx_default_conf.phy.enable_clpc;
+	params.phy_standalone = phy->phy_standalone;
+	params.rdl = phy->rdl;
+	params.enable_clpc = phy->enable_clpc;
 	params.enable_tx_low_pwr_on_siso_rdl =
-		wl18xx_default_conf.phy.enable_tx_low_pwr_on_siso_rdl;
-	params.auto_detect = wl18xx_default_conf.phy.auto_detect;
-	params.dedicated_fem = wl18xx_default_conf.phy.dedicated_fem;
-	params.low_band_component = wl18xx_default_conf.phy.low_band_component;
+		phy->enable_tx_low_pwr_on_siso_rdl;
+	params.auto_detect = phy->auto_detect;
+	params.dedicated_fem = phy->dedicated_fem;
+	params.low_band_component = phy->low_band_component;
 	params.low_band_component_type =
-		wl18xx_default_conf.phy.low_band_component_type;
-	params.high_band_component =
-		wl18xx_default_conf.phy.high_band_component;
+		phy->low_band_component_type;
+	params.high_band_component = phy->high_band_component;
 	params.high_band_component_type =
-		wl18xx_default_conf.phy.high_band_component_type;
+		phy->high_band_component_type;
 	params.number_of_assembled_ant2_4 =
-		wl18xx_default_conf.phy.number_of_assembled_ant2_4;
+		phy->number_of_assembled_ant2_4;
 	params.number_of_assembled_ant5 =
-		wl18xx_default_conf.phy.number_of_assembled_ant5;
-	params.external_pa_dc2dc = wl18xx_default_conf.phy.external_pa_dc2dc;
-	params.tcxo_ldo_voltage = wl18xx_default_conf.phy.tcxo_ldo_voltage;
-	params.xtal_itrim_val = wl18xx_default_conf.phy.xtal_itrim_val;
-	params.srf_state = wl18xx_default_conf.phy.srf_state;
-	params.io_configuration = wl18xx_default_conf.phy.io_configuration;
-	params.sdio_configuration = wl18xx_default_conf.phy.sdio_configuration;
-	params.settings = wl18xx_default_conf.phy.settings;
-	params.rx_profile = wl18xx_default_conf.phy.rx_profile;
+		phy->number_of_assembled_ant5;
+	params.external_pa_dc2dc = phy->external_pa_dc2dc;
+	params.tcxo_ldo_voltage = phy->tcxo_ldo_voltage;
+	params.xtal_itrim_val = phy->xtal_itrim_val;
+	params.srf_state = phy->srf_state;
+	params.io_configuration = phy->io_configuration;
+	params.sdio_configuration = phy->sdio_configuration;
+	params.settings = phy->settings;
+	params.rx_profile = phy->rx_profile;
 	params.primary_clock_setting_time =
-		wl18xx_default_conf.phy.primary_clock_setting_time;
+		phy->primary_clock_setting_time;
 	params.clock_valid_on_wake_up =
-		wl18xx_default_conf.phy.clock_valid_on_wake_up;
+		phy->clock_valid_on_wake_up;
 	params.secondary_clock_setting_time =
-		wl18xx_default_conf.phy.secondary_clock_setting_time;
+		phy->secondary_clock_setting_time;
 
 	/* TODO: hardcoded for now */
 	params.board_type = BOARD_TYPE_DVP_EVB_18XX;
@@ -544,6 +862,17 @@ static void wl18xx_set_rx_csum(struct wl1271 *wl,
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 }
 
+static void wl18xx_conf_init(struct wl1271 *wl)
+{
+	struct wl18xx_priv *priv = wl->priv;
+
+	/* apply driver default configuration */
+	memcpy(&wl->conf, &wl18xx_conf, sizeof(wl18xx_conf));
+
+	/* apply default private configuration */
+	memcpy(&priv->conf, &wl18xx_default_priv_conf, sizeof(priv->conf));
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -584,6 +913,8 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
+	wl18xx_conf_init(wl);
+
 	return wlcore_probe(wl, pdev);
 }
 
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index d24f9c0..c9bf5c6 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -22,6 +22,7 @@
 #ifndef __WL18XX_PRIV_H__
 #define __WL18XX_PRIV_H__
 
+#include "conf.h"
 
 #define WL18XX_CMD_MAX_SIZE          740
 
@@ -29,6 +30,8 @@ struct wl18xx_priv {
 	/* buffer for sending commands to FW */
 	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
 
+	struct wl18xx_priv_conf conf;
+
 	/* Index of last released Tx desc in FW */
 	u8 last_fw_rls_idx;
 };
-- 
1.7.9.5

