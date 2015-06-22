Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52434 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbFVOmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:42:20 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 06/10] ath10k: add 10.4 fw wmi pdev cmd ids
Date: Mon, 22 Jun 2015 20:10:14 +0530
Message-ID: <1434984018-24057-7-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164229_096328_CC96B4C3)
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include 10.4 firmware wmi pdev cmd id and prepare wmi vdev map
table wmi_10_4_pdev_param_map and update non 10.4 firmware
pdev cmd map table with newly added vdev cmd id specifically for
10.4 firmware as unsupported.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
v2 changes:
 - udpated pdev cmd id table based on stable 10.4 firmware.

 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  42 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 228 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 136 ++++++++++++++++++
 3 files changed, 406 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index b2a8e32..620b37b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3236,6 +3236,48 @@ static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
 	.burst_dur = WMI_TLV_PDEV_PARAM_BURST_DUR,
 	.burst_enable = WMI_TLV_PDEV_PARAM_BURST_ENABLE,
 	.cal_period = WMI_PDEV_PARAM_UNSUPPORTED,
+	.aggr_burst = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_decap_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.smart_antenna_default_antenna = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.antenna_gain = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_filter = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_to_ucast_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.proxy_sta_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.remove_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.peer_sta_ps_statechg_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.block_interbss = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_disable_reset_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_msdu_ttl_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_ppdu_duration_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.txbf_sound_period_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_promisc_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_burst_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.en_stats = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mu_group_policy = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_detection = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.dpd_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_bcast_echo = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_strict_sch = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_sched_duration = WMI_PDEV_PARAM_UNSUPPORTED,
+	.ant_plzn = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mgmt_retry_limit = WMI_PDEV_PARAM_UNSUPPORTED,
+	.sensitivity_level = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_2g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_5g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_amsdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_ampdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.cca_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pdev_reset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wapi_mbssid_offset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_srcaddr = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_vdev_param_map wmi_tlv_vdev_param_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 087dea8..3f29886 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1053,6 +1053,48 @@ static struct wmi_pdev_param_map wmi_pdev_param_map = {
 	.burst_dur = WMI_PDEV_PARAM_UNSUPPORTED,
 	.burst_enable = WMI_PDEV_PARAM_UNSUPPORTED,
 	.cal_period = WMI_PDEV_PARAM_UNSUPPORTED,
+	.aggr_burst = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_decap_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.smart_antenna_default_antenna = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.antenna_gain = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_filter = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_to_ucast_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.proxy_sta_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.remove_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.peer_sta_ps_statechg_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.block_interbss = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_disable_reset_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_msdu_ttl_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_ppdu_duration_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.txbf_sound_period_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_promisc_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_burst_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.en_stats = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mu_group_policy = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_detection = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.dpd_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_bcast_echo = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_strict_sch = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_sched_duration = WMI_PDEV_PARAM_UNSUPPORTED,
+	.ant_plzn = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mgmt_retry_limit = WMI_PDEV_PARAM_UNSUPPORTED,
+	.sensitivity_level = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_2g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_5g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_amsdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_ampdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.cca_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pdev_reset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wapi_mbssid_offset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_srcaddr = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
@@ -1106,6 +1148,48 @@ static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
 	.burst_dur = WMI_10X_PDEV_PARAM_BURST_DUR,
 	.burst_enable = WMI_10X_PDEV_PARAM_BURST_ENABLE,
 	.cal_period = WMI_10X_PDEV_PARAM_CAL_PERIOD,
+	.aggr_burst = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_decap_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.smart_antenna_default_antenna = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.antenna_gain = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_filter = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_to_ucast_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.proxy_sta_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.remove_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.peer_sta_ps_statechg_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.block_interbss = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_disable_reset_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_msdu_ttl_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_ppdu_duration_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.txbf_sound_period_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_promisc_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_burst_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.en_stats = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mu_group_policy = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_detection = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.dpd_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_bcast_echo = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_strict_sch = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_sched_duration = WMI_PDEV_PARAM_UNSUPPORTED,
+	.ant_plzn = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mgmt_retry_limit = WMI_PDEV_PARAM_UNSUPPORTED,
+	.sensitivity_level = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_2g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_5g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_amsdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_ampdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.cca_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pdev_reset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wapi_mbssid_offset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_srcaddr = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_10_2_4_pdev_param_map = {
@@ -1159,6 +1243,48 @@ static struct wmi_pdev_param_map wmi_10_2_4_pdev_param_map = {
 	.burst_dur = WMI_10X_PDEV_PARAM_BURST_DUR,
 	.burst_enable = WMI_10X_PDEV_PARAM_BURST_ENABLE,
 	.cal_period = WMI_10X_PDEV_PARAM_CAL_PERIOD,
+	.aggr_burst = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_decap_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.smart_antenna_default_antenna = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.antenna_gain = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rx_filter = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_to_ucast_tid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.proxy_sta_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_mode = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.remove_mcast2ucast_buffer = WMI_PDEV_PARAM_UNSUPPORTED,
+	.peer_sta_ps_statechg_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.igmpmld_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.block_interbss = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_disable_reset_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_msdu_ttl_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_ppdu_duration_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.txbf_sound_period_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_promisc_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_burst_mode_cmdid = WMI_PDEV_PARAM_UNSUPPORTED,
+	.en_stats = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mu_group_policy = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_detection = WMI_PDEV_PARAM_UNSUPPORTED,
+	.noise_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.dpd_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+	.set_mcast_bcast_echo = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_strict_sch = WMI_PDEV_PARAM_UNSUPPORTED,
+	.atf_sched_duration = WMI_PDEV_PARAM_UNSUPPORTED,
+	.ant_plzn = WMI_PDEV_PARAM_UNSUPPORTED,
+	.mgmt_retry_limit = WMI_PDEV_PARAM_UNSUPPORTED,
+	.sensitivity_level = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_2g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.signed_txpower_5g = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_amsdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_per_tid_ampdu = WMI_PDEV_PARAM_UNSUPPORTED,
+	.cca_threshold = WMI_PDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pdev_reset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wapi_mbssid_offset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_srcaddr = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 /* firmware 10.2 specific mappings */
@@ -1315,6 +1441,107 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.pdev_reserve_ast_entry_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
+static struct wmi_pdev_param_map wmi_10_4_pdev_param_map = {
+	.tx_chain_mask = WMI_10_4_PDEV_PARAM_TX_CHAIN_MASK,
+	.rx_chain_mask = WMI_10_4_PDEV_PARAM_RX_CHAIN_MASK,
+	.txpower_limit2g = WMI_10_4_PDEV_PARAM_TXPOWER_LIMIT2G,
+	.txpower_limit5g = WMI_10_4_PDEV_PARAM_TXPOWER_LIMIT5G,
+	.txpower_scale = WMI_10_4_PDEV_PARAM_TXPOWER_SCALE,
+	.beacon_gen_mode = WMI_10_4_PDEV_PARAM_BEACON_GEN_MODE,
+	.beacon_tx_mode = WMI_10_4_PDEV_PARAM_BEACON_TX_MODE,
+	.resmgr_offchan_mode = WMI_10_4_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	.protection_mode = WMI_10_4_PDEV_PARAM_PROTECTION_MODE,
+	.dynamic_bw = WMI_10_4_PDEV_PARAM_DYNAMIC_BW,
+	.non_agg_sw_retry_th = WMI_10_4_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	.agg_sw_retry_th = WMI_10_4_PDEV_PARAM_AGG_SW_RETRY_TH,
+	.sta_kickout_th = WMI_10_4_PDEV_PARAM_STA_KICKOUT_TH,
+	.ac_aggrsize_scaling = WMI_10_4_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	.ltr_enable = WMI_10_4_PDEV_PARAM_LTR_ENABLE,
+	.ltr_ac_latency_be = WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	.ltr_ac_latency_bk = WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	.ltr_ac_latency_vi = WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	.ltr_ac_latency_vo = WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	.ltr_ac_latency_timeout = WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	.ltr_sleep_override = WMI_10_4_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	.ltr_rx_override = WMI_10_4_PDEV_PARAM_LTR_RX_OVERRIDE,
+	.ltr_tx_activity_timeout = WMI_10_4_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	.l1ss_enable = WMI_10_4_PDEV_PARAM_L1SS_ENABLE,
+	.dsleep_enable = WMI_10_4_PDEV_PARAM_DSLEEP_ENABLE,
+	.pcielp_txbuf_flush = WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_FLUSH,
+	.pcielp_txbuf_watermark = WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_WATERMARK,
+	.pcielp_txbuf_tmo_en = WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_TMO_EN,
+	.pcielp_txbuf_tmo_value = WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_TMO_VALUE,
+	.pdev_stats_update_period =
+			WMI_10_4_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	.vdev_stats_update_period =
+			WMI_10_4_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	.peer_stats_update_period =
+			WMI_10_4_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	.bcnflt_stats_update_period =
+			WMI_10_4_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	.pmf_qos = WMI_10_4_PDEV_PARAM_PMF_QOS,
+	.arp_ac_override = WMI_10_4_PDEV_PARAM_ARP_AC_OVERRIDE,
+	.dcs = WMI_10_4_PDEV_PARAM_DCS,
+	.ani_enable = WMI_10_4_PDEV_PARAM_ANI_ENABLE,
+	.ani_poll_period = WMI_10_4_PDEV_PARAM_ANI_POLL_PERIOD,
+	.ani_listen_period = WMI_10_4_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	.ani_ofdm_level = WMI_10_4_PDEV_PARAM_ANI_OFDM_LEVEL,
+	.ani_cck_level = WMI_10_4_PDEV_PARAM_ANI_CCK_LEVEL,
+	.dyntxchain = WMI_10_4_PDEV_PARAM_DYNTXCHAIN,
+	.proxy_sta = WMI_10_4_PDEV_PARAM_PROXY_STA,
+	.idle_ps_config = WMI_10_4_PDEV_PARAM_IDLE_PS_CONFIG,
+	.power_gating_sleep = WMI_10_4_PDEV_PARAM_POWER_GATING_SLEEP,
+	.fast_channel_reset = WMI_10_4_PDEV_PARAM_FAST_CHANNEL_RESET,
+	.burst_dur = WMI_10_4_PDEV_PARAM_BURST_DUR,
+	.burst_enable = WMI_10_4_PDEV_PARAM_BURST_ENABLE,
+	.cal_period = WMI_10_4_PDEV_PARAM_CAL_PERIOD,
+	.aggr_burst = WMI_10_4_PDEV_PARAM_AGGR_BURST,
+	.rx_decap_mode = WMI_10_4_PDEV_PARAM_RX_DECAP_MODE,
+	.smart_antenna_default_antenna =
+			WMI_10_4_PDEV_PARAM_SMART_ANTENNA_DEFAULT_ANTENNA,
+	.igmpmld_override = WMI_10_4_PDEV_PARAM_IGMPMLD_OVERRIDE,
+	.igmpmld_tid = WMI_10_4_PDEV_PARAM_IGMPMLD_TID,
+	.antenna_gain = WMI_10_4_PDEV_PARAM_ANTENNA_GAIN,
+	.rx_filter = WMI_10_4_PDEV_PARAM_RX_FILTER,
+	.set_mcast_to_ucast_tid = WMI_10_4_PDEV_SET_MCAST_TO_UCAST_TID,
+	.proxy_sta_mode = WMI_10_4_PDEV_PARAM_PROXY_STA_MODE,
+	.set_mcast2ucast_mode = WMI_10_4_PDEV_PARAM_SET_MCAST2UCAST_MODE,
+	.set_mcast2ucast_buffer = WMI_10_4_PDEV_PARAM_SET_MCAST2UCAST_BUFFER,
+	.remove_mcast2ucast_buffer =
+			WMI_10_4_PDEV_PARAM_REMOVE_MCAST2UCAST_BUFFER,
+	.peer_sta_ps_statechg_enable =
+			WMI_10_4_PDEV_PEER_STA_PS_STATECHG_ENABLE,
+	.igmpmld_ac_override = WMI_10_4_PDEV_PARAM_IGMPMLD_AC_OVERRIDE,
+	.block_interbss = WMI_10_4_PDEV_PARAM_BLOCK_INTERBSS,
+	.set_disable_reset_cmdid = WMI_10_4_PDEV_PARAM_SET_DISABLE_RESET_CMDID,
+	.set_msdu_ttl_cmdid = WMI_10_4_PDEV_PARAM_SET_MSDU_TTL_CMDID,
+	.set_ppdu_duration_cmdid = WMI_10_4_PDEV_PARAM_SET_PPDU_DURATION_CMDID,
+	.txbf_sound_period_cmdid = WMI_10_4_PDEV_PARAM_TXBF_SOUND_PERIOD_CMDID,
+	.set_promisc_mode_cmdid = WMI_10_4_PDEV_PARAM_SET_PROMISC_MODE_CMDID,
+	.set_burst_mode_cmdid = WMI_10_4_PDEV_PARAM_SET_BURST_MODE_CMDID,
+	.en_stats = WMI_10_4_PDEV_PARAM_EN_STATS,
+	.mu_group_policy = WMI_10_4_PDEV_PARAM_MU_GROUP_POLICY,
+	.noise_detection = WMI_10_4_PDEV_PARAM_NOISE_DETECTION,
+	.noise_threshold = WMI_10_4_PDEV_PARAM_NOISE_THRESHOLD,
+	.dpd_enable = WMI_10_4_PDEV_PARAM_DPD_ENABLE,
+	.set_mcast_bcast_echo = WMI_10_4_PDEV_PARAM_SET_MCAST_BCAST_ECHO,
+	.atf_strict_sch = WMI_10_4_PDEV_PARAM_ATF_STRICT_SCH,
+	.atf_sched_duration = WMI_10_4_PDEV_PARAM_ATF_SCHED_DURATION,
+	.ant_plzn = WMI_10_4_PDEV_PARAM_ANT_PLZN,
+	.mgmt_retry_limit = WMI_10_4_PDEV_PARAM_MGMT_RETRY_LIMIT,
+	.sensitivity_level = WMI_10_4_PDEV_PARAM_SENSITIVITY_LEVEL,
+	.signed_txpower_2g = WMI_10_4_PDEV_PARAM_SIGNED_TXPOWER_2G,
+	.signed_txpower_5g = WMI_10_4_PDEV_PARAM_SIGNED_TXPOWER_5G,
+	.enable_per_tid_amsdu = WMI_10_4_PDEV_PARAM_ENABLE_PER_TID_AMSDU,
+	.enable_per_tid_ampdu = WMI_10_4_PDEV_PARAM_ENABLE_PER_TID_AMPDU,
+	.cca_threshold = WMI_10_4_PDEV_PARAM_CCA_THRESHOLD,
+	.rts_fixed_rate = WMI_10_4_PDEV_PARAM_RTS_FIXED_RATE,
+	.pdev_reset = WMI_10_4_PDEV_PARAM_PDEV_RESET,
+	.wapi_mbssid_offset = WMI_10_4_PDEV_PARAM_WAPI_MBSSID_OFFSET,
+	.arp_srcaddr = WMI_10_4_PDEV_PARAM_ARP_SRCADDR,
+	.arp_dstaddr = WMI_10_4_PDEV_PARAM_ARP_DSTADDR,
+};
+
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 				const struct wmi_channel_arg *arg)
 {
@@ -5887,6 +6114,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.ops = &wmi_10_4_ops;
 		ar->wmi.cmd = &wmi_10_4_cmd_map;
 		ar->wmi.vdev_param = &wmi_10_4_vdev_param_map;
+		ar->wmi.pdev_param = &wmi_10_4_pdev_param_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->wmi.cmd = &wmi_10_2_4_cmd_map;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ecc7288..f6ee163 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3011,6 +3011,48 @@ struct wmi_pdev_param_map {
 	u32 burst_dur;
 	u32 burst_enable;
 	u32 cal_period;
+	u32 aggr_burst;
+	u32 rx_decap_mode;
+	u32 smart_antenna_default_antenna;
+	u32 igmpmld_override;
+	u32 igmpmld_tid;
+	u32 antenna_gain;
+	u32 rx_filter;
+	u32 set_mcast_to_ucast_tid;
+	u32 proxy_sta_mode;
+	u32 set_mcast2ucast_mode;
+	u32 set_mcast2ucast_buffer;
+	u32 remove_mcast2ucast_buffer;
+	u32 peer_sta_ps_statechg_enable;
+	u32 igmpmld_ac_override;
+	u32 block_interbss;
+	u32 set_disable_reset_cmdid;
+	u32 set_msdu_ttl_cmdid;
+	u32 set_ppdu_duration_cmdid;
+	u32 txbf_sound_period_cmdid;
+	u32 set_promisc_mode_cmdid;
+	u32 set_burst_mode_cmdid;
+	u32 en_stats;
+	u32 mu_group_policy;
+	u32 noise_detection;
+	u32 noise_threshold;
+	u32 dpd_enable;
+	u32 set_mcast_bcast_echo;
+	u32 atf_strict_sch;
+	u32 atf_sched_duration;
+	u32 ant_plzn;
+	u32 mgmt_retry_limit;
+	u32 sensitivity_level;
+	u32 signed_txpower_2g;
+	u32 signed_txpower_5g;
+	u32 enable_per_tid_amsdu;
+	u32 enable_per_tid_ampdu;
+	u32 cca_threshold;
+	u32 rts_fixed_rate;
+	u32 pdev_reset;
+	u32 wapi_mbssid_offset;
+	u32 arp_srcaddr;
+	u32 arp_dstaddr;
 };
 
 #define WMI_PDEV_PARAM_UNSUPPORTED 0
@@ -3226,6 +3268,100 @@ enum wmi_10x_pdev_param {
 	WMI_10X_PDEV_PARAM_CAL_PERIOD
 };
 
+enum wmi_10_4_pdev_param {
+	WMI_10_4_PDEV_PARAM_TX_CHAIN_MASK = 0x1,
+	WMI_10_4_PDEV_PARAM_RX_CHAIN_MASK,
+	WMI_10_4_PDEV_PARAM_TXPOWER_LIMIT2G,
+	WMI_10_4_PDEV_PARAM_TXPOWER_LIMIT5G,
+	WMI_10_4_PDEV_PARAM_TXPOWER_SCALE,
+	WMI_10_4_PDEV_PARAM_BEACON_GEN_MODE,
+	WMI_10_4_PDEV_PARAM_BEACON_TX_MODE,
+	WMI_10_4_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	WMI_10_4_PDEV_PARAM_PROTECTION_MODE,
+	WMI_10_4_PDEV_PARAM_DYNAMIC_BW,
+	WMI_10_4_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	WMI_10_4_PDEV_PARAM_AGG_SW_RETRY_TH,
+	WMI_10_4_PDEV_PARAM_STA_KICKOUT_TH,
+	WMI_10_4_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	WMI_10_4_PDEV_PARAM_LTR_ENABLE,
+	WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	WMI_10_4_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	WMI_10_4_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	WMI_10_4_PDEV_PARAM_LTR_RX_OVERRIDE,
+	WMI_10_4_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	WMI_10_4_PDEV_PARAM_L1SS_ENABLE,
+	WMI_10_4_PDEV_PARAM_DSLEEP_ENABLE,
+	WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_FLUSH,
+	WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_WATERMARK,
+	WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_TMO_EN,
+	WMI_10_4_PDEV_PARAM_PCIELP_TXBUF_TMO_VALUE,
+	WMI_10_4_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	WMI_10_4_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	WMI_10_4_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	WMI_10_4_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	WMI_10_4_PDEV_PARAM_PMF_QOS,
+	WMI_10_4_PDEV_PARAM_ARP_AC_OVERRIDE,
+	WMI_10_4_PDEV_PARAM_DCS,
+	WMI_10_4_PDEV_PARAM_ANI_ENABLE,
+	WMI_10_4_PDEV_PARAM_ANI_POLL_PERIOD,
+	WMI_10_4_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	WMI_10_4_PDEV_PARAM_ANI_OFDM_LEVEL,
+	WMI_10_4_PDEV_PARAM_ANI_CCK_LEVEL,
+	WMI_10_4_PDEV_PARAM_DYNTXCHAIN,
+	WMI_10_4_PDEV_PARAM_PROXY_STA,
+	WMI_10_4_PDEV_PARAM_IDLE_PS_CONFIG,
+	WMI_10_4_PDEV_PARAM_POWER_GATING_SLEEP,
+	WMI_10_4_PDEV_PARAM_AGGR_BURST,
+	WMI_10_4_PDEV_PARAM_RX_DECAP_MODE,
+	WMI_10_4_PDEV_PARAM_FAST_CHANNEL_RESET,
+	WMI_10_4_PDEV_PARAM_BURST_DUR,
+	WMI_10_4_PDEV_PARAM_BURST_ENABLE,
+	WMI_10_4_PDEV_PARAM_SMART_ANTENNA_DEFAULT_ANTENNA,
+	WMI_10_4_PDEV_PARAM_IGMPMLD_OVERRIDE,
+	WMI_10_4_PDEV_PARAM_IGMPMLD_TID,
+	WMI_10_4_PDEV_PARAM_ANTENNA_GAIN,
+	WMI_10_4_PDEV_PARAM_RX_FILTER,
+	WMI_10_4_PDEV_SET_MCAST_TO_UCAST_TID,
+	WMI_10_4_PDEV_PARAM_PROXY_STA_MODE,
+	WMI_10_4_PDEV_PARAM_SET_MCAST2UCAST_MODE,
+	WMI_10_4_PDEV_PARAM_SET_MCAST2UCAST_BUFFER,
+	WMI_10_4_PDEV_PARAM_REMOVE_MCAST2UCAST_BUFFER,
+	WMI_10_4_PDEV_PEER_STA_PS_STATECHG_ENABLE,
+	WMI_10_4_PDEV_PARAM_IGMPMLD_AC_OVERRIDE,
+	WMI_10_4_PDEV_PARAM_BLOCK_INTERBSS,
+	WMI_10_4_PDEV_PARAM_SET_DISABLE_RESET_CMDID,
+	WMI_10_4_PDEV_PARAM_SET_MSDU_TTL_CMDID,
+	WMI_10_4_PDEV_PARAM_SET_PPDU_DURATION_CMDID,
+	WMI_10_4_PDEV_PARAM_TXBF_SOUND_PERIOD_CMDID,
+	WMI_10_4_PDEV_PARAM_SET_PROMISC_MODE_CMDID,
+	WMI_10_4_PDEV_PARAM_SET_BURST_MODE_CMDID,
+	WMI_10_4_PDEV_PARAM_EN_STATS,
+	WMI_10_4_PDEV_PARAM_MU_GROUP_POLICY,
+	WMI_10_4_PDEV_PARAM_NOISE_DETECTION,
+	WMI_10_4_PDEV_PARAM_NOISE_THRESHOLD,
+	WMI_10_4_PDEV_PARAM_DPD_ENABLE,
+	WMI_10_4_PDEV_PARAM_SET_MCAST_BCAST_ECHO,
+	WMI_10_4_PDEV_PARAM_ATF_STRICT_SCH,
+	WMI_10_4_PDEV_PARAM_ATF_SCHED_DURATION,
+	WMI_10_4_PDEV_PARAM_ANT_PLZN,
+	WMI_10_4_PDEV_PARAM_MGMT_RETRY_LIMIT,
+	WMI_10_4_PDEV_PARAM_SENSITIVITY_LEVEL,
+	WMI_10_4_PDEV_PARAM_SIGNED_TXPOWER_2G,
+	WMI_10_4_PDEV_PARAM_SIGNED_TXPOWER_5G,
+	WMI_10_4_PDEV_PARAM_ENABLE_PER_TID_AMSDU,
+	WMI_10_4_PDEV_PARAM_ENABLE_PER_TID_AMPDU,
+	WMI_10_4_PDEV_PARAM_CCA_THRESHOLD,
+	WMI_10_4_PDEV_PARAM_RTS_FIXED_RATE,
+	WMI_10_4_PDEV_PARAM_CAL_PERIOD,
+	WMI_10_4_PDEV_PARAM_PDEV_RESET,
+	WMI_10_4_PDEV_PARAM_WAPI_MBSSID_OFFSET,
+	WMI_10_4_PDEV_PARAM_ARP_SRCADDR,
+	WMI_10_4_PDEV_PARAM_ARP_DSTADDR,
+};
+
 struct wmi_pdev_set_param_cmd {
 	__le32 param_id;
 	__le32 param_value;
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
