Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51631 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbZJMJtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:46 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 07/22] wl1271: Move default FW config struct away from stack
Date: Tue, 13 Oct 2009 12:47:44 +0300
Message-Id: <1255427279-1224-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Move the default FW config into a module global static variable, instead
of being a stack variable.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |  535 ++++++++++++++---------------
 1 files changed, 264 insertions(+), 271 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 0b17b05..eba38df 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -46,289 +46,282 @@
 #include "wl1271_cmd.h"
 #include "wl1271_boot.h"
 
-static void wl1271_conf_init(struct wl1271 *wl)
-{
-	struct conf_drv_settings conf = {
-		.sg = {
-			.per_threshold              = 7500,
-			.max_scan_compensation_time = 120000,
-			.nfs_sample_interval        = 400,
-			.load_ratio                 = 50,
-			.auto_ps_mode               = 0,
-			.probe_req_compensation     = 170,
-			.scan_window_compensation   = 50,
-			.antenna_config             = 0,
-			.beacon_miss_threshold      = 60,
-			.rate_adaptation_threshold  = CONF_HW_BIT_RATE_12MBPS,
-			.rate_adaptation_snr        = 0
-		},
-		.rx = {
-			.rx_msdu_life_time          = 512000,
-			.packet_detection_threshold = 0,
-			.ps_poll_timeout            = 15,
-			.upsd_timeout               = 15,
-			.rts_threshold              = 2347,
-			.rx_cca_threshold           = 0xFFEF,
-			.irq_blk_threshold          = 0,
-			.irq_pkt_threshold          = USHORT_MAX,
-			.irq_timeout                = 5,
-			.queue_type           = CONF_RX_QUEUE_TYPE_LOW_PRIORITY,
+static struct conf_drv_settings default_conf = {
+	.sg = {
+		.per_threshold               = 7500,
+		.max_scan_compensation_time  = 120000,
+		.nfs_sample_interval         = 400,
+		.load_ratio                  = 50,
+		.auto_ps_mode                = 0,
+		.probe_req_compensation      = 170,
+		.scan_window_compensation    = 50,
+		.antenna_config              = 0,
+		.beacon_miss_threshold       = 60,
+		.rate_adaptation_threshold   = CONF_HW_BIT_RATE_12MBPS,
+		.rate_adaptation_snr         = 0
+	},
+	.rx = {
+		.rx_msdu_life_time           = 512000,
+		.packet_detection_threshold  = 0,
+		.ps_poll_timeout             = 15,
+		.upsd_timeout                = 15,
+		.rts_threshold               = 2347,
+		.rx_cca_threshold            = 0xFFEF,
+		.irq_blk_threshold           = 0,
+		.irq_pkt_threshold           = USHORT_MAX,
+		.irq_timeout                 = 5,
+		.queue_type                  = CONF_RX_QUEUE_TYPE_LOW_PRIORITY,
+	},
+	.tx = {
+		.tx_energy_detection         = 0,
+		.rc_conf                     = {
+			.enabled_rates       = CONF_TX_RATE_MASK_UNSPECIFIED,
+			.short_retry_limit   = 10,
+			.long_retry_limit    = 10,
+			.aflags              = 0
 		},
-		.tx = {
-			.tx_energy_detection        = 0,
-			.rc_conf                    = {
-				.enabled_rates      =
-				CONF_TX_RATE_MASK_UNSPECIFIED,
-				.short_retry_limit  = 10,
-				.long_retry_limit   = 10,
-				.aflags             = 0
+		.ac_conf_count               = 4,
+		.ac_conf                     = {
+			[0] = {
+				.ac          = CONF_TX_AC_BE,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = 3,
+				.tx_op_limit = 0,
+			},
+			[1] = {
+				.ac          = CONF_TX_AC_BK,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = 7,
+				.tx_op_limit = 0,
 			},
-			.ac_conf_count              = 4,
-			.ac_conf                    = {
-				[0] = {
-					.ac         = CONF_TX_AC_BE,
-					.cw_min     = 15,
-					.cw_max     = 63,
-					.aifsn      = 3,
-					.tx_op_limit = 0,
-				},
-				[1] = {
-					.ac         = CONF_TX_AC_BK,
-					.cw_min     = 15,
-					.cw_max     = 63,
-					.aifsn      = 7,
-					.tx_op_limit = 0,
-				},
-				[2] = {
-					.ac         = CONF_TX_AC_VI,
-					.cw_min     = 15,
-					.cw_max     = 63,
-					.aifsn      = CONF_TX_AIFS_PIFS,
-					.tx_op_limit = 3008,
-				},
-				[3] = {
-					.ac         = CONF_TX_AC_VO,
-					.cw_min     = 15,
-					.cw_max     = 63,
-					.aifsn      = CONF_TX_AIFS_PIFS,
-					.tx_op_limit = 1504,
-				},
+			[2] = {
+				.ac          = CONF_TX_AC_VI,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = CONF_TX_AIFS_PIFS,
+				.tx_op_limit = 3008,
 			},
-			.tid_conf_count = 7,
-			.tid_conf = {
-				[0] = {
-					.queue_id   = 0,
-					.channel_type = CONF_CHANNEL_TYPE_DCF,
-					.tsid = CONF_TX_AC_BE,
-					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
-					.ack_policy = CONF_ACK_POLICY_LEGACY,
-					.apsd_conf  = {0, 0},
-				},
-				[1] = {
-					.queue_id   = 1,
-					.channel_type = CONF_CHANNEL_TYPE_DCF,
-					.tsid = CONF_TX_AC_BE,
-					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
-					.ack_policy = CONF_ACK_POLICY_LEGACY,
-					.apsd_conf  = {0, 0},
-				},
-				[2] = {
-					.queue_id   = 2,
-					.channel_type = CONF_CHANNEL_TYPE_DCF,
-					.tsid = CONF_TX_AC_BE,
-					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
-					.ack_policy = CONF_ACK_POLICY_LEGACY,
-					.apsd_conf  = {0, 0},
-				},
-				[3] = {
-					.queue_id   = 3,
-					.channel_type = CONF_CHANNEL_TYPE_DCF,
-					.tsid = CONF_TX_AC_BE,
-					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
-					.ack_policy = CONF_ACK_POLICY_LEGACY,
-					.apsd_conf  = {0, 0},
-				},
-				[4] = {
-					.queue_id   = 4,
-					.channel_type = CONF_CHANNEL_TYPE_DCF,
-					.tsid = CONF_TX_AC_BE,
-					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
-					.ack_policy = CONF_ACK_POLICY_LEGACY,
-					.apsd_conf  = {0, 0},
-				},
-				[5] = {
-					.queue_id   = 5,
-					.channel_type = CONF_CHANNEL_TYPE_DCF,
-					.tsid = CONF_TX_AC_BE,
-					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
-					.ack_policy = CONF_ACK_POLICY_LEGACY,
-					.apsd_conf  = {0, 0},
-				},
-				[6] = {
-					.queue_id   = 6,
-					.channel_type = CONF_CHANNEL_TYPE_DCF,
-					.tsid = CONF_TX_AC_BE,
-					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
-					.ack_policy = CONF_ACK_POLICY_LEGACY,
-					.apsd_conf  = {0, 0},
-				}
+			[3] = {
+				.ac          = CONF_TX_AC_VO,
+				.cw_min      = 15,
+				.cw_max      = 63,
+				.aifsn       = CONF_TX_AIFS_PIFS,
+				.tx_op_limit = 1504,
 			},
-			.frag_threshold          = IEEE80211_MAX_FRAG_THRESHOLD,
-			.tx_compl_timeout           = 5,
-			.tx_compl_threshold         = 5
 		},
-		.conn = {
-			.wake_up_event           = CONF_WAKE_UP_EVENT_DTIM,
-			.listen_interval            = 0,
-			.bcn_filt_mode             = CONF_BCN_FILT_MODE_ENABLED,
-			.bcn_filt_ie_count          = 1,
-			.bcn_filt_ie = {
-				[0] = {
-					.ie         = WLAN_EID_CHANNEL_SWITCH,
-					.rule       =
-					CONF_BCN_RULE_PASS_ON_APPEARANCE,
-				}
+		.tid_conf_count = 7,
+		.tid_conf = {
+			[0] = {
+				.queue_id    = 0,
+				.channel_type = CONF_CHANNEL_TYPE_DCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+			[1] = {
+				.queue_id    = 1,
+				.channel_type = CONF_CHANNEL_TYPE_DCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
 			},
-			.synch_fail_thold           = 5,
-			.bss_lose_timeout           = 100,
-			.beacon_rx_timeout          = 10000,
-			.broadcast_timeout          = 20000,
-			.rx_broadcast_in_ps         = 1,
-			.ps_poll_threshold          = 4,
-			.sig_trigger_count          = 2,
-			.sig_trigger = {
-				[0] = {
-					.threshold  = -75,
-					.pacing     = 500,
-					.metric  = CONF_TRIG_METRIC_RSSI_BEACON,
-					.type       = CONF_TRIG_EVENT_TYPE_EDGE,
-					.direction  = CONF_TRIG_EVENT_DIR_LOW,
-					.hysteresis = 2,
-					.index      = 0,
-					.enable     = 1
-				},
-				[1] = {
-					.threshold  = -75,
-					.pacing     = 500,
-					.metric  = CONF_TRIG_METRIC_RSSI_BEACON,
-					.type       = CONF_TRIG_EVENT_TYPE_EDGE,
-					.direction  = CONF_TRIG_EVENT_DIR_HIGH,
-					.hysteresis = 2,
-					.index      = 1,
-					.enable     = 1
-				}
+			[2] = {
+				.queue_id    = 2,
+				.channel_type = CONF_CHANNEL_TYPE_DCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
 			},
-			.sig_weights = {
-				.rssi_bcn_avg_weight = 10,
-				.rssi_pkt_avg_weight = 10,
-				.snr_bcn_avg_weight  = 10,
-				.snr_pkt_avg_weight  = 10
+			[3] = {
+				.queue_id    = 3,
+				.channel_type = CONF_CHANNEL_TYPE_DCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+			[4] = {
+				.queue_id    = 4,
+				.channel_type = CONF_CHANNEL_TYPE_DCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+			[5] = {
+				.queue_id    = 5,
+				.channel_type = CONF_CHANNEL_TYPE_DCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
+			},
+			[6] = {
+				.queue_id    = 6,
+				.channel_type = CONF_CHANNEL_TYPE_DCF,
+				.tsid        = CONF_TX_AC_BE,
+				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
+				.ack_policy  = CONF_ACK_POLICY_LEGACY,
+				.apsd_conf   = {0, 0},
 			}
 		},
-		.init = {
-			.sr_err_tbl = {
-				[0] = {
-					.len         = 7,
-					.upper_limit = 0x03,
-					.values      = {
-						0x18, 0x10, 0x05, 0xfb,
-						0xf0, 0xe8, 0x00 }
-				},
-				[1] = {
-					.len         = 7,
-					.upper_limit = 0x03,
-					.values      = {
-						0x18, 0x10, 0x05, 0xf6,
-						0xf0, 0xe8, 0x00 }
-				},
-				[2] = {
-					.len         = 7,
-					.upper_limit = 0x03,
-					.values      = {
-						0x18, 0x10, 0x05, 0xfb,
-						0xf0, 0xe8, 0x00 }
-				}
+		.frag_threshold              = IEEE80211_MAX_FRAG_THRESHOLD,
+		.tx_compl_timeout            = 5,
+		.tx_compl_threshold          = 5
+	},
+	.conn = {
+		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
+		.listen_interval             = 0,
+		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
+		.bcn_filt_ie_count           = 1,
+		.bcn_filt_ie = {
+			[0] = {
+				.ie          = WLAN_EID_CHANNEL_SWITCH,
+				.rule        = CONF_BCN_RULE_PASS_ON_APPEARANCE,
+			}
+		},
+		.synch_fail_thold            = 5,
+		.bss_lose_timeout            = 100,
+		.beacon_rx_timeout           = 10000,
+		.broadcast_timeout           = 20000,
+		.rx_broadcast_in_ps          = 1,
+		.ps_poll_threshold           = 4,
+		.sig_trigger_count           = 2,
+		.sig_trigger = {
+			[0] = {
+				.threshold   = -75,
+				.pacing      = 500,
+				.metric      = CONF_TRIG_METRIC_RSSI_BEACON,
+				.type        = CONF_TRIG_EVENT_TYPE_EDGE,
+				.direction   = CONF_TRIG_EVENT_DIR_LOW,
+				.hysteresis  = 2,
+				.index       = 0,
+				.enable      = 1
 			},
-			.sr_enable = 1,
-			.genparam = {
-				/*
-				 * FIXME: The correct value CONF_REF_CLK_38_4_E
-				 *        causes the firmware to crash on boot.
-				 *        The value 5 apparently is an
-				 *        unnoficial XTAL configuration of the
-				 *        same frequency, which appears to work.
-				 */
-				.ref_clk             = 5,
-				.settling_time       = 5,
-				.clk_valid_on_wakeup = 0,
-				.dc2dcmode           = 0,
-				.single_dual_band    = 0,
-				.tx_bip_fem_autodetect = 0,
-				.tx_bip_fem_manufacturer = 1,
-				.settings = 1,
+			[1] = {
+				.threshold   = -75,
+				.pacing      = 500,
+				.metric      = CONF_TRIG_METRIC_RSSI_BEACON,
+				.type        = CONF_TRIG_EVENT_TYPE_EDGE,
+				.direction   = CONF_TRIG_EVENT_DIR_HIGH,
+				.hysteresis  = 2,
+				.index       = 1,
+				.enable      = 1
+			}
+		},
+		.sig_weights = {
+			.rssi_bcn_avg_weight = 10,
+			.rssi_pkt_avg_weight = 10,
+			.snr_bcn_avg_weight  = 10,
+			.snr_pkt_avg_weight  = 10
+		}
+	},
+	.init = {
+		.sr_err_tbl = {
+			[0] = {
+				.len         = 7,
+				.upper_limit = 0x03,
+				.values      = {
+					0x18, 0x10, 0x05, 0xfb, 0xf0, 0xe8,
+					0x00 }
+			},
+			[1] = {
+				.len         = 7,
+				.upper_limit = 0x03,
+				.values      = {
+					0x18, 0x10, 0x05, 0xf6, 0xf0, 0xe8,
+					0x00 }
 			},
-			.radioparam = {
-				/* FIXME: 5GHz values unset! */
-				.rx_trace_loss       = 10,
-				.tx_trace_loss       = 10,
-				.rx_rssi_and_proc_compens = {
-					0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8,
-					0xfc, 0x00, 0x08, 0x10, 0xf0, 0xf8,
-					0x00, 0x0a, 0x14 },
-				.rx_trace_loss_5     = {
-					0, 0, 0, 0, 0, 0, 0 },
-				.tx_trace_loss_5     = {
-					0, 0, 0, 0, 0, 0, 0 },
-				.rx_rssi_and_proc_compens_5 = {
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-					0x00, 0x00, 0x00 },
-				.tx_ref_pd_voltage   = 0x24e,
-				.tx_ref_power        = 0x78,
-				.tx_offset_db        = 0x0,
-				.tx_rate_limits_normal = {
-					0x1e, 0x1f, 0x22, 0x24, 0x28, 0x29 },
-				.tx_rate_limits_degraded = {
-					0x1b, 0x1c, 0x1e, 0x20, 0x24, 0x25 },
-				.tx_channel_limits_11b = {
-					0x22, 0x50, 0x50, 0x50, 0x50, 0x50,
-					0x50, 0x50, 0x50, 0x50, 0x22, 0x50,
-					0x22, 0x50 },
-				.tx_channel_limits_ofdm = {
-					0x20, 0x50, 0x50, 0x50, 0x50, 0x50,
-					0x50, 0x50, 0x50, 0x50, 0x20, 0x50,
-					0x20, 0x50 },
-				.tx_pdv_rate_offsets = {
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
-				.tx_ibias            = {
-					0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x27 },
-				.rx_fem_insertion_loss = 0x14,
-				.tx_ref_pd_voltage_5 = {
-					0, 0, 0, 0, 0, 0, 0 },
-				.tx_ref_power_5      = {
-					0, 0, 0, 0, 0, 0, 0 },
-				.tx_offset_db_5      = {
-					0, 0, 0, 0, 0, 0, 0 },
-				.tx_rate_limits_normal_5 = {
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
-				.tx_rate_limits_degraded_5 = {
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
-				.tx_channel_limits_ofdm_5 = {
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-					0x00, 0x00, 0x00, 0x00, 0x00},
-				.tx_pdv_rate_offsets_5 = {
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
-				.tx_ibias_5          = {
-					0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
-				.rx_fem_insertion_loss_5 = {
-					0, 0, 0, 0, 0, 0, 0 }
+			[2] = {
+				.len         = 7,
+				.upper_limit = 0x03,
+				.values      = {
+					0x18, 0x10, 0x05, 0xfb, 0xf0, 0xe8,
+					0x00 }
 			}
+		},
+		.sr_enable                   = 1,
+		.genparam                    = {
+			/*
+			 * FIXME: The correct value CONF_REF_CLK_38_4_E
+			 *        causes the firmware to crash on boot.
+			 *        The value 5 apparently is an
+			 *        unnoficial XTAL configuration of the
+			 *        same frequency, which appears to work.
+			 */
+			.ref_clk             = 5,
+			.settling_time       = 5,
+			.clk_valid_on_wakeup = 0,
+			.dc2dcmode           = 0,
+			.single_dual_band    = 0,
+			.tx_bip_fem_autodetect = 0,
+			.tx_bip_fem_manufacturer = 1,
+			.settings = 1,
+		},
+		.radioparam = {
+			/* FIXME: 5GHz values unset! */
+			.rx_trace_loss       = 10,
+			.tx_trace_loss       = 10,
+			.rx_rssi_and_proc_compens = {
+				0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8,
+				0xfc, 0x00, 0x08, 0x10, 0xf0, 0xf8,
+				0x00, 0x0a, 0x14 },
+			.rx_trace_loss_5     = { 0, 0, 0, 0, 0, 0, 0 },
+			.tx_trace_loss_5     = { 0, 0, 0, 0, 0, 0, 0 },
+			.rx_rssi_and_proc_compens_5 = {
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00 },
+			.tx_ref_pd_voltage   = 0x24e,
+			.tx_ref_power        = 0x78,
+			.tx_offset_db        = 0x0,
+			.tx_rate_limits_normal = {
+				0x1e, 0x1f, 0x22, 0x24, 0x28, 0x29 },
+			.tx_rate_limits_degraded = {
+				0x1b, 0x1c, 0x1e, 0x20, 0x24, 0x25 },
+			.tx_channel_limits_11b = {
+				0x22, 0x50, 0x50, 0x50, 0x50, 0x50,
+				0x50, 0x50, 0x50, 0x50, 0x22, 0x50,
+				0x22, 0x50 },
+			.tx_channel_limits_ofdm = {
+				0x20, 0x50, 0x50, 0x50, 0x50, 0x50,
+				0x50, 0x50, 0x50, 0x50, 0x20, 0x50,
+				0x20, 0x50 },
+			.tx_pdv_rate_offsets = {
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+			.tx_ibias            = {
+				0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x27 },
+			.rx_fem_insertion_loss = 0x14,
+			.tx_ref_pd_voltage_5 = { 0, 0, 0, 0, 0, 0, 0 },
+			.tx_ref_power_5      = { 0, 0, 0, 0, 0, 0, 0 },
+			.tx_offset_db_5      = {0, 0, 0, 0, 0, 0, 0 },
+			.tx_rate_limits_normal_5 = {
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+			.tx_rate_limits_degraded_5 = {
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+			.tx_channel_limits_ofdm_5 = {
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00, 0x00},
+			.tx_pdv_rate_offsets_5 = {
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+			.tx_ibias_5          = {
+				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+			.rx_fem_insertion_loss_5 = { 0, 0, 0, 0, 0, 0, 0 }
 		}
-	};
+	}
+};
+
+static void wl1271_conf_init(struct wl1271 *wl)
+{
 
 	/*
 	 * This function applies the default configuration to the driver. This
@@ -341,7 +334,7 @@ static void wl1271_conf_init(struct wl1271 *wl)
 	 */
 
 	/* apply driver default configuration */
-	memcpy(&wl->conf, &conf, sizeof(conf));
+	memcpy(&wl->conf, &default_conf, sizeof(default_conf));
 }
 
 
-- 
1.5.6.5

