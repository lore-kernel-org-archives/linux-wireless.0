Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:61761 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab3IYJih (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 05:38:37 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 12/13] ath10k: introduce dynamic pdev parameters
Date: Wed, 25 Sep 2013 11:38:10 +0200
Message-ID: <1380101891-18312-13-git-send-email-bartosz.markowski@tieto.com> (sfid-20130925_113843_074668_617D4482)
In-Reply-To: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is done exactly the same way as for vdev.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    1 +
 drivers/net/wireless/ath/ath10k/mac.c  |   13 +--
 drivers/net/wireless/ath/ath10k/wmi.c  |  144 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h  |  148 +++++++++++++++++++++++++++++++-
 4 files changed, 297 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c9ad626..d5e4d55 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -118,6 +118,7 @@ struct ath10k_wmi {
 	wait_queue_head_t tx_credits_wq;
 	struct wmi_cmd_map *cmd;
 	struct wmi_vdev_param_map *vdev_param;
+	struct wmi_pdev_param_map *pdev_param;
 
 	u32 num_mem_chunks;
 	struct ath10k_mem_chunk mem_chunks[ATH10K_MAX_MEM_REQS];
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ea11a03..d846594 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1816,6 +1816,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 {
 	struct ath10k *ar = hw->priv;
 	int ret = 0;
+	u32 pdev_param;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -1845,12 +1846,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	else if (ar->state == ATH10K_STATE_RESTARTING)
 		ar->state = ATH10K_STATE_RESTARTED;
 
-	ret = ath10k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS, 1);
+	pdev_param = ar->wmi.pdev_param->wmi_pdev_param_pmf_qos;
+	ret = ath10k_wmi_pdev_set_param(ar, pdev_param, 1);
 	if (ret)
 		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
 			    ret);
 
-	ret = ath10k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_DYNAMIC_BW, 0);
+	pdev_param = ar->wmi.pdev_param->wmi_pdev_param_dynamic_bw;
+	ret = ath10k_wmi_pdev_set_param(ar, pdev_param, 0);
 	if (ret)
 		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
 			    ret);
@@ -2169,7 +2172,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret = 0;
-	u32 vdev_param;
+	u32 vdev_param, pdev_param;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -2195,8 +2198,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   "vdev %d set beacon tx mode to staggered\n",
 			   arvif->vdev_id);
 
-		ret = ath10k_wmi_pdev_set_param(ar,
-						WMI_PDEV_PARAM_BEACON_TX_MODE,
+		pdev_param = ar->wmi.pdev_param->wmi_pdev_param_beacon_tx_mode;
+		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
 						WMI_BEACON_STAGGERED_MODE);
 		if (ret)
 			ath10k_warn("Failed to set beacon mode for VDEV: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 44ed523..2a55bc8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -399,6 +399,140 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
 		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
 };
 
+static struct wmi_pdev_param_map wmi_pdev_param_map = {
+	.wmi_pdev_param_tx_chain_mask = WMI_PDEV_PARAM_TX_CHAIN_MASK,
+	.wmi_pdev_param_rx_chain_mask = WMI_PDEV_PARAM_RX_CHAIN_MASK,
+	.wmi_pdev_param_txpower_limit2g = WMI_PDEV_PARAM_TXPOWER_LIMIT2G,
+	.wmi_pdev_param_txpower_limit5g = WMI_PDEV_PARAM_TXPOWER_LIMIT5G,
+	.wmi_pdev_param_txpower_scale = WMI_PDEV_PARAM_TXPOWER_SCALE,
+	.wmi_pdev_param_beacon_gen_mode = WMI_PDEV_PARAM_BEACON_GEN_MODE,
+	.wmi_pdev_param_beacon_tx_mode = WMI_PDEV_PARAM_BEACON_TX_MODE,
+	.wmi_pdev_param_resmgr_offchan_mode =
+					WMI_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	.wmi_pdev_param_protection_mode = WMI_PDEV_PARAM_PROTECTION_MODE,
+	.wmi_pdev_param_dynamic_bw = WMI_PDEV_PARAM_DYNAMIC_BW,
+	.wmi_pdev_param_non_agg_sw_retry_th =
+					WMI_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	.wmi_pdev_param_agg_sw_retry_th = WMI_PDEV_PARAM_AGG_SW_RETRY_TH,
+	.wmi_pdev_param_sta_kickout_th = WMI_PDEV_PARAM_STA_KICKOUT_TH,
+	.wmi_pdev_param_ac_aggrsize_scaling =
+					WMI_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	.wmi_pdev_param_ltr_enable = WMI_PDEV_PARAM_LTR_ENABLE,
+	.wmi_pdev_param_ltr_ac_latency_be = WMI_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	.wmi_pdev_param_ltr_ac_latency_bk = WMI_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	.wmi_pdev_param_ltr_ac_latency_vi = WMI_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	.wmi_pdev_param_ltr_ac_latency_vo = WMI_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	.wmi_pdev_param_ltr_ac_latency_timeout =
+					WMI_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	.wmi_pdev_param_ltr_sleep_override = WMI_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	.wmi_pdev_param_ltr_rx_override = WMI_PDEV_PARAM_LTR_RX_OVERRIDE,
+	.wmi_pdev_param_ltr_tx_activity_timeout =
+					WMI_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	.wmi_pdev_param_l1ss_enable = WMI_PDEV_PARAM_L1SS_ENABLE,
+	.wmi_pdev_param_dsleep_enable = WMI_PDEV_PARAM_DSLEEP_ENABLE,
+	.wmi_pdev_param_pcielp_txbuf_flush = WMI_PDEV_PARAM_PCIELP_TXBUF_FLUSH,
+	.wmi_pdev_param_pcielp_txbuf_watermark =
+					WMI_PDEV_PARAM_PCIELP_TXBUF_TMO_EN,
+	.wmi_pdev_param_pcielp_txbuf_tmo_en =
+					WMI_PDEV_PARAM_PCIELP_TXBUF_TMO_EN,
+	.wmi_pdev_param_pcielp_txbuf_tmo_value =
+					WMI_PDEV_PARAM_PCIELP_TXBUF_TMO_VALUE,
+	.wmi_pdev_param_pdev_stats_update_period =
+					WMI_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_vdev_stats_update_period =
+					WMI_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_peer_stats_update_period =
+					WMI_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_bcnflt_stats_update_period =
+				WMI_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_pmf_qos = WMI_PDEV_PARAM_PMF_QOS,
+	.wmi_pdev_param_arp_ac_override = WMI_PDEV_PARAM_ARP_AC_OVERRIDE,
+	.wmi_pdev_param_arpdhcp_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_dcs = WMI_PDEV_PARAM_DCS,
+	.wmi_pdev_param_ani_enable = WMI_PDEV_PARAM_ANI_ENABLE,
+	.wmi_pdev_param_ani_poll_period = WMI_PDEV_PARAM_ANI_POLL_PERIOD,
+	.wmi_pdev_param_ani_listen_period = WMI_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	.wmi_pdev_param_ani_ofdm_level = WMI_PDEV_PARAM_ANI_OFDM_LEVEL,
+	.wmi_pdev_param_ani_cck_level = WMI_PDEV_PARAM_ANI_CCK_LEVEL,
+	.wmi_pdev_param_dyntxchain = WMI_PDEV_PARAM_DYNTXCHAIN,
+	.wmi_pdev_param_proxy_sta = WMI_PDEV_PARAM_PROXY_STA,
+	.wmi_pdev_param_idle_ps_config = WMI_PDEV_PARAM_IDLE_PS_CONFIG,
+	.wmi_pdev_param_power_gating_sleep = WMI_PDEV_PARAM_POWER_GATING_SLEEP,
+	.wmi_pdev_param_fast_channel_reset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_burst_dur = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_burst_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+};
+
+static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
+	.wmi_pdev_param_tx_chain_mask = WMI_10X_PDEV_PARAM_TX_CHAIN_MASK,
+	.wmi_pdev_param_rx_chain_mask = WMI_10X_PDEV_PARAM_RX_CHAIN_MASK,
+	.wmi_pdev_param_txpower_limit2g = WMI_10X_PDEV_PARAM_TXPOWER_LIMIT2G,
+	.wmi_pdev_param_txpower_limit5g = WMI_10X_PDEV_PARAM_TXPOWER_LIMIT5G,
+	.wmi_pdev_param_txpower_scale = WMI_10X_PDEV_PARAM_TXPOWER_SCALE,
+	.wmi_pdev_param_beacon_gen_mode = WMI_10X_PDEV_PARAM_BEACON_GEN_MODE,
+	.wmi_pdev_param_beacon_tx_mode = WMI_10X_PDEV_PARAM_BEACON_TX_MODE,
+	.wmi_pdev_param_resmgr_offchan_mode =
+					WMI_10X_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	.wmi_pdev_param_protection_mode = WMI_10X_PDEV_PARAM_PROTECTION_MODE,
+	.wmi_pdev_param_dynamic_bw = WMI_10X_PDEV_PARAM_DYNAMIC_BW,
+	.wmi_pdev_param_non_agg_sw_retry_th =
+					WMI_10X_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	.wmi_pdev_param_agg_sw_retry_th = WMI_10X_PDEV_PARAM_AGG_SW_RETRY_TH,
+	.wmi_pdev_param_sta_kickout_th = WMI_10X_PDEV_PARAM_STA_KICKOUT_TH,
+	.wmi_pdev_param_ac_aggrsize_scaling =
+					WMI_10X_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	.wmi_pdev_param_ltr_enable = WMI_10X_PDEV_PARAM_LTR_ENABLE,
+	.wmi_pdev_param_ltr_ac_latency_be =
+					WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	.wmi_pdev_param_ltr_ac_latency_bk =
+					WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	.wmi_pdev_param_ltr_ac_latency_vi =
+					WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	.wmi_pdev_param_ltr_ac_latency_vo =
+					WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	.wmi_pdev_param_ltr_ac_latency_timeout =
+				WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	.wmi_pdev_param_ltr_sleep_override =
+					WMI_10X_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	.wmi_pdev_param_ltr_rx_override = WMI_10X_PDEV_PARAM_LTR_RX_OVERRIDE,
+	.wmi_pdev_param_ltr_tx_activity_timeout =
+				WMI_10X_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	.wmi_pdev_param_l1ss_enable = WMI_10X_PDEV_PARAM_L1SS_ENABLE,
+	.wmi_pdev_param_dsleep_enable = WMI_10X_PDEV_PARAM_DSLEEP_ENABLE,
+	.wmi_pdev_param_pcielp_txbuf_flush = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_pcielp_txbuf_watermark = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_pcielp_txbuf_tmo_en = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_pcielp_txbuf_tmo_value = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_pdev_stats_update_period =
+				WMI_10X_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_vdev_stats_update_period =
+				WMI_10X_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_peer_stats_update_period =
+				WMI_10X_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_bcnflt_stats_update_period =
+				WMI_10X_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	.wmi_pdev_param_pmf_qos = WMI_10X_PDEV_PARAM_PMF_QOS,
+	.wmi_pdev_param_arp_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_arpdhcp_ac_override =
+					WMI_10X_PDEV_PARAM_ARPDHCP_AC_OVERRIDE,
+	.wmi_pdev_param_dcs = WMI_10X_PDEV_PARAM_DCS,
+	.wmi_pdev_param_ani_enable = WMI_10X_PDEV_PARAM_ANI_ENABLE,
+	.wmi_pdev_param_ani_poll_period = WMI_10X_PDEV_PARAM_ANI_POLL_PERIOD,
+	.wmi_pdev_param_ani_listen_period =
+					WMI_10X_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	.wmi_pdev_param_ani_ofdm_level = WMI_10X_PDEV_PARAM_ANI_OFDM_LEVEL,
+	.wmi_pdev_param_ani_cck_level = WMI_10X_PDEV_PARAM_ANI_CCK_LEVEL,
+	.wmi_pdev_param_dyntxchain = WMI_10X_PDEV_PARAM_DYNTXCHAIN,
+	.wmi_pdev_param_proxy_sta = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_idle_ps_config = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_power_gating_sleep = WMI_PDEV_PARAM_UNSUPPORTED,
+	.wmi_pdev_param_fast_channel_reset =
+					WMI_10X_PDEV_PARAM_FAST_CHANNEL_RESET,
+	.wmi_pdev_param_burst_dur = WMI_10X_PDEV_PARAM_BURST_DUR,
+	.wmi_pdev_param_burst_enable = WMI_10X_PDEV_PARAM_BURST_ENABLE,
+
+};
+
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
@@ -1886,10 +2020,12 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ath10k_warn("Firmware 10.X is not yet supported\n");
 		ar->wmi.cmd = &wmi_10x_cmd_map;
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
+		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
 		ret = -ENOTSUPP;
 	} else {
 		ar->wmi.cmd = &wmi_cmd_map;
 		ar->wmi.vdev_param = &wmi_vdev_param_map;
+		ar->wmi.pdev_param = &wmi_pdev_param_map;
 		ret = 0;
 	}
 
@@ -2027,12 +2163,16 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
 				   ar->wmi.cmd->wmi_pdev_resume_cmdid);
 }
 
-int ath10k_wmi_pdev_set_param(struct ath10k *ar, enum wmi_pdev_param id,
-			      u32 value)
+int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 {
 	struct wmi_pdev_set_param_cmd *cmd;
 	struct sk_buff *skb;
 
+	if (id == WMI_PDEV_PARAM_UNSUPPORTED) {
+		ath10k_warn("pdev param %d not supported by firmware\n", id);
+		return -EINVAL;
+	}
+
 	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index fbff5cb..fcada27 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2072,6 +2072,60 @@ struct wmi_csa_event {
 #define VDEV_DEFAULT_STATS_UPDATE_PERIOD    500
 #define PEER_DEFAULT_STATS_UPDATE_PERIOD    500
 
+struct wmi_pdev_param_map {
+	u32 wmi_pdev_param_tx_chain_mask;
+	u32 wmi_pdev_param_rx_chain_mask;
+	u32 wmi_pdev_param_txpower_limit2g;
+	u32 wmi_pdev_param_txpower_limit5g;
+	u32 wmi_pdev_param_txpower_scale;
+	u32 wmi_pdev_param_beacon_gen_mode;
+	u32 wmi_pdev_param_beacon_tx_mode;
+	u32 wmi_pdev_param_resmgr_offchan_mode;
+	u32 wmi_pdev_param_protection_mode;
+	u32 wmi_pdev_param_dynamic_bw;
+	u32 wmi_pdev_param_non_agg_sw_retry_th;
+	u32 wmi_pdev_param_agg_sw_retry_th;
+	u32 wmi_pdev_param_sta_kickout_th;
+	u32 wmi_pdev_param_ac_aggrsize_scaling;
+	u32 wmi_pdev_param_ltr_enable;
+	u32 wmi_pdev_param_ltr_ac_latency_be;
+	u32 wmi_pdev_param_ltr_ac_latency_bk;
+	u32 wmi_pdev_param_ltr_ac_latency_vi;
+	u32 wmi_pdev_param_ltr_ac_latency_vo;
+	u32 wmi_pdev_param_ltr_ac_latency_timeout;
+	u32 wmi_pdev_param_ltr_sleep_override;
+	u32 wmi_pdev_param_ltr_rx_override;
+	u32 wmi_pdev_param_ltr_tx_activity_timeout;
+	u32 wmi_pdev_param_l1ss_enable;
+	u32 wmi_pdev_param_dsleep_enable;
+	u32 wmi_pdev_param_pcielp_txbuf_flush;
+	u32 wmi_pdev_param_pcielp_txbuf_watermark;
+	u32 wmi_pdev_param_pcielp_txbuf_tmo_en;
+	u32 wmi_pdev_param_pcielp_txbuf_tmo_value;
+	u32 wmi_pdev_param_pdev_stats_update_period;
+	u32 wmi_pdev_param_vdev_stats_update_period;
+	u32 wmi_pdev_param_peer_stats_update_period;
+	u32 wmi_pdev_param_bcnflt_stats_update_period;
+	u32 wmi_pdev_param_pmf_qos;
+	u32 wmi_pdev_param_arp_ac_override;
+	u32 wmi_pdev_param_arpdhcp_ac_override;
+	u32 wmi_pdev_param_dcs;
+	u32 wmi_pdev_param_ani_enable;
+	u32 wmi_pdev_param_ani_poll_period;
+	u32 wmi_pdev_param_ani_listen_period;
+	u32 wmi_pdev_param_ani_ofdm_level;
+	u32 wmi_pdev_param_ani_cck_level;
+	u32 wmi_pdev_param_dyntxchain;
+	u32 wmi_pdev_param_proxy_sta;
+	u32 wmi_pdev_param_idle_ps_config;
+	u32 wmi_pdev_param_power_gating_sleep;
+	u32 wmi_pdev_param_fast_channel_reset;
+	u32 wmi_pdev_param_burst_dur;
+	u32 wmi_pdev_param_burst_enable;
+};
+
+#define WMI_PDEV_PARAM_UNSUPPORTED 0
+
 enum wmi_pdev_param {
 	/* TX chian mask */
 	WMI_PDEV_PARAM_TX_CHAIN_MASK = 0x1,
@@ -2171,6 +2225,97 @@ enum wmi_pdev_param {
 	WMI_PDEV_PARAM_POWER_GATING_SLEEP,
 };
 
+enum wmi_10x_pdev_param {
+	/* TX chian mask */
+	WMI_10X_PDEV_PARAM_TX_CHAIN_MASK = 0x1,
+	/* RX chian mask */
+	WMI_10X_PDEV_PARAM_RX_CHAIN_MASK,
+	/* TX power limit for 2G Radio */
+	WMI_10X_PDEV_PARAM_TXPOWER_LIMIT2G,
+	/* TX power limit for 5G Radio */
+	WMI_10X_PDEV_PARAM_TXPOWER_LIMIT5G,
+	/* TX power scale */
+	WMI_10X_PDEV_PARAM_TXPOWER_SCALE,
+	/* Beacon generation mode . 0: host, 1: target   */
+	WMI_10X_PDEV_PARAM_BEACON_GEN_MODE,
+	/* Beacon generation mode . 0: staggered 1: bursted   */
+	WMI_10X_PDEV_PARAM_BEACON_TX_MODE,
+	/*
+	 * Resource manager off chan mode .
+	 * 0: turn off off chan mode. 1: turn on offchan mode
+	 */
+	WMI_10X_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	/*
+	 * Protection mode:
+	 * 0: no protection 1:use CTS-to-self 2: use RTS/CTS
+	 */
+	WMI_10X_PDEV_PARAM_PROTECTION_MODE,
+	/* Dynamic bandwidth 0: disable 1: enable */
+	WMI_10X_PDEV_PARAM_DYNAMIC_BW,
+	/* Non aggregrate/ 11g sw retry threshold.0-disable */
+	WMI_10X_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	/* aggregrate sw retry threshold. 0-disable*/
+	WMI_10X_PDEV_PARAM_AGG_SW_RETRY_TH,
+	/* Station kickout threshold (non of consecutive failures).0-disable */
+	WMI_10X_PDEV_PARAM_STA_KICKOUT_TH,
+	/* Aggerate size scaling configuration per AC */
+	WMI_10X_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	/* LTR enable */
+	WMI_10X_PDEV_PARAM_LTR_ENABLE,
+	/* LTR latency for BE, in us */
+	WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	/* LTR latency for BK, in us */
+	WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	/* LTR latency for VI, in us */
+	WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	/* LTR latency for VO, in us  */
+	WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	/* LTR AC latency timeout, in ms */
+	WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	/* LTR platform latency override, in us */
+	WMI_10X_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	/* LTR-RX override, in us */
+	WMI_10X_PDEV_PARAM_LTR_RX_OVERRIDE,
+	/* Tx activity timeout for LTR, in us */
+	WMI_10X_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	/* L1SS state machine enable */
+	WMI_10X_PDEV_PARAM_L1SS_ENABLE,
+	/* Deep sleep state machine enable */
+	WMI_10X_PDEV_PARAM_DSLEEP_ENABLE,
+	/* pdev level stats update period in ms */
+	WMI_10X_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	/* vdev level stats update period in ms */
+	WMI_10X_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	/* peer level stats update period in ms */
+	WMI_10X_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	/* beacon filter status update period */
+	WMI_10X_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	/* QOS Mgmt frame protection MFP/PMF 0: disable, 1: enable */
+	WMI_10X_PDEV_PARAM_PMF_QOS,
+	/* Access category on which ARP and DHCP frames are sent */
+	WMI_10X_PDEV_PARAM_ARPDHCP_AC_OVERRIDE,
+	/* DCS configuration */
+	WMI_10X_PDEV_PARAM_DCS,
+	/* Enable/Disable ANI on target */
+	WMI_10X_PDEV_PARAM_ANI_ENABLE,
+	/* configure the ANI polling period */
+	WMI_10X_PDEV_PARAM_ANI_POLL_PERIOD,
+	/* configure the ANI listening period */
+	WMI_10X_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	/* configure OFDM immunity level */
+	WMI_10X_PDEV_PARAM_ANI_OFDM_LEVEL,
+	/* configure CCK immunity level */
+	WMI_10X_PDEV_PARAM_ANI_CCK_LEVEL,
+	/* Enable/Disable CDD for 1x1 STAs in rate control module */
+	WMI_10X_PDEV_PARAM_DYNTXCHAIN,
+	/* Enable/Disable Fast channel reset*/
+	WMI_10X_PDEV_PARAM_FAST_CHANNEL_RESET,
+	/* Set Bursting DUR */
+	WMI_10X_PDEV_PARAM_BURST_DUR,
+	/* Set Bursting Enable*/
+	WMI_10X_PDEV_PARAM_BURST_ENABLE,
+};
+
 struct wmi_pdev_set_param_cmd {
 	__le32 param_id;
 	__le32 param_value;
@@ -3797,8 +3942,7 @@ int ath10k_wmi_pdev_suspend_target(struct ath10k *ar);
 int ath10k_wmi_pdev_resume_target(struct ath10k *ar);
 int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
 				  u16 rd5g, u16 ctl2g, u16 ctl5g);
-int ath10k_wmi_pdev_set_param(struct ath10k *ar, enum wmi_pdev_param id,
-			      u32 value);
+int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value);
 int ath10k_wmi_cmd_init(struct ath10k *ar);
 int ath10k_wmi_10x_cmd_init(struct ath10k *ar);
 int ath10k_wmi_start_scan(struct ath10k *ar, const struct wmi_start_scan_arg *);
-- 
1.7.10

