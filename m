Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:61615 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab3IZJaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 05:30:14 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v2 12/13] ath10k: introduce dynamic pdev parameters
Date: Thu, 26 Sep 2013 11:29:51 +0200
Message-ID: <1380187792-25626-13-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_113028_871904_2005B09E)
In-Reply-To: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is done exactly the same way as for vdev.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    1 +
 drivers/net/wireless/ath/ath10k/mac.c  |   10 +--
 drivers/net/wireless/ath/ath10k/wmi.c  |  115 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h  |  148 +++++++++++++++++++++++++++++++-
 4 files changed, 265 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 124e724..d5da8a9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -120,6 +120,7 @@ struct ath10k_wmi {
 	wait_queue_head_t tx_credits_wq;
 	struct wmi_cmd_map *cmd;
 	struct wmi_vdev_param_map *vdev_param;
+	struct wmi_pdev_param_map *pdev_param;
 
 	u32 num_mem_chunks;
 	struct ath10k_mem_chunk mem_chunks[ATH10K_MAX_MEM_REQS];
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d8aba57..0b7e9ac 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1885,12 +1885,12 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	else if (ar->state == ATH10K_STATE_RESTARTING)
 		ar->state = ATH10K_STATE_RESTARTED;
 
-	ret = ath10k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS, 1);
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
 	if (ret)
 		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
 			    ret);
 
-	ret = ath10k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_DYNAMIC_BW, 0);
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 0);
 	if (ret)
 		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
 			    ret);
@@ -2212,7 +2212,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret = 0;
-	u32 vdev_param;
+	u32 vdev_param, pdev_param;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -2238,8 +2238,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   "vdev %d set beacon tx mode to staggered\n",
 			   arvif->vdev_id);
 
-		ret = ath10k_wmi_pdev_set_param(ar,
-						WMI_PDEV_PARAM_BEACON_TX_MODE,
+		pdev_param = ar->wmi.pdev_param->beacon_tx_mode;
+		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
 						WMI_BEACON_STAGGERED_MODE);
 		if (ret)
 			ath10k_warn("Failed to set beacon mode for VDEV: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a6bd87e..8c3316d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -383,6 +383,111 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
 		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
 };
 
+static struct wmi_pdev_param_map wmi_pdev_param_map = {
+	.tx_chain_mask = WMI_PDEV_PARAM_TX_CHAIN_MASK,
+	.rx_chain_mask = WMI_PDEV_PARAM_RX_CHAIN_MASK,
+	.txpower_limit2g = WMI_PDEV_PARAM_TXPOWER_LIMIT2G,
+	.txpower_limit5g = WMI_PDEV_PARAM_TXPOWER_LIMIT5G,
+	.txpower_scale = WMI_PDEV_PARAM_TXPOWER_SCALE,
+	.beacon_gen_mode = WMI_PDEV_PARAM_BEACON_GEN_MODE,
+	.beacon_tx_mode = WMI_PDEV_PARAM_BEACON_TX_MODE,
+	.resmgr_offchan_mode = WMI_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	.protection_mode = WMI_PDEV_PARAM_PROTECTION_MODE,
+	.dynamic_bw = WMI_PDEV_PARAM_DYNAMIC_BW,
+	.non_agg_sw_retry_th = WMI_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	.agg_sw_retry_th = WMI_PDEV_PARAM_AGG_SW_RETRY_TH,
+	.sta_kickout_th = WMI_PDEV_PARAM_STA_KICKOUT_TH,
+	.ac_aggrsize_scaling = WMI_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	.ltr_enable = WMI_PDEV_PARAM_LTR_ENABLE,
+	.ltr_ac_latency_be = WMI_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	.ltr_ac_latency_bk = WMI_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	.ltr_ac_latency_vi = WMI_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	.ltr_ac_latency_vo = WMI_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	.ltr_ac_latency_timeout = WMI_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	.ltr_sleep_override = WMI_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	.ltr_rx_override = WMI_PDEV_PARAM_LTR_RX_OVERRIDE,
+	.ltr_tx_activity_timeout = WMI_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	.l1ss_enable = WMI_PDEV_PARAM_L1SS_ENABLE,
+	.dsleep_enable = WMI_PDEV_PARAM_DSLEEP_ENABLE,
+	.pcielp_txbuf_flush = WMI_PDEV_PARAM_PCIELP_TXBUF_FLUSH,
+	.pcielp_txbuf_watermark = WMI_PDEV_PARAM_PCIELP_TXBUF_TMO_EN,
+	.pcielp_txbuf_tmo_en = WMI_PDEV_PARAM_PCIELP_TXBUF_TMO_EN,
+	.pcielp_txbuf_tmo_value = WMI_PDEV_PARAM_PCIELP_TXBUF_TMO_VALUE,
+	.pdev_stats_update_period = WMI_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	.vdev_stats_update_period = WMI_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	.peer_stats_update_period = WMI_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	.bcnflt_stats_update_period = WMI_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	.pmf_qos = WMI_PDEV_PARAM_PMF_QOS,
+	.arp_ac_override = WMI_PDEV_PARAM_ARP_AC_OVERRIDE,
+	.arpdhcp_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.dcs = WMI_PDEV_PARAM_DCS,
+	.ani_enable = WMI_PDEV_PARAM_ANI_ENABLE,
+	.ani_poll_period = WMI_PDEV_PARAM_ANI_POLL_PERIOD,
+	.ani_listen_period = WMI_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	.ani_ofdm_level = WMI_PDEV_PARAM_ANI_OFDM_LEVEL,
+	.ani_cck_level = WMI_PDEV_PARAM_ANI_CCK_LEVEL,
+	.dyntxchain = WMI_PDEV_PARAM_DYNTXCHAIN,
+	.proxy_sta = WMI_PDEV_PARAM_PROXY_STA,
+	.idle_ps_config = WMI_PDEV_PARAM_IDLE_PS_CONFIG,
+	.power_gating_sleep = WMI_PDEV_PARAM_POWER_GATING_SLEEP,
+	.fast_channel_reset = WMI_PDEV_PARAM_UNSUPPORTED,
+	.burst_dur = WMI_PDEV_PARAM_UNSUPPORTED,
+	.burst_enable = WMI_PDEV_PARAM_UNSUPPORTED,
+};
+
+static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
+	.tx_chain_mask = WMI_10X_PDEV_PARAM_TX_CHAIN_MASK,
+	.rx_chain_mask = WMI_10X_PDEV_PARAM_RX_CHAIN_MASK,
+	.txpower_limit2g = WMI_10X_PDEV_PARAM_TXPOWER_LIMIT2G,
+	.txpower_limit5g = WMI_10X_PDEV_PARAM_TXPOWER_LIMIT5G,
+	.txpower_scale = WMI_10X_PDEV_PARAM_TXPOWER_SCALE,
+	.beacon_gen_mode = WMI_10X_PDEV_PARAM_BEACON_GEN_MODE,
+	.beacon_tx_mode = WMI_10X_PDEV_PARAM_BEACON_TX_MODE,
+	.resmgr_offchan_mode = WMI_10X_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	.protection_mode = WMI_10X_PDEV_PARAM_PROTECTION_MODE,
+	.dynamic_bw = WMI_10X_PDEV_PARAM_DYNAMIC_BW,
+	.non_agg_sw_retry_th = WMI_10X_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	.agg_sw_retry_th = WMI_10X_PDEV_PARAM_AGG_SW_RETRY_TH,
+	.sta_kickout_th = WMI_10X_PDEV_PARAM_STA_KICKOUT_TH,
+	.ac_aggrsize_scaling = WMI_10X_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	.ltr_enable = WMI_10X_PDEV_PARAM_LTR_ENABLE,
+	.ltr_ac_latency_be = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	.ltr_ac_latency_bk = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	.ltr_ac_latency_vi = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	.ltr_ac_latency_vo = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	.ltr_ac_latency_timeout = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	.ltr_sleep_override = WMI_10X_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	.ltr_rx_override = WMI_10X_PDEV_PARAM_LTR_RX_OVERRIDE,
+	.ltr_tx_activity_timeout = WMI_10X_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	.l1ss_enable = WMI_10X_PDEV_PARAM_L1SS_ENABLE,
+	.dsleep_enable = WMI_10X_PDEV_PARAM_DSLEEP_ENABLE,
+	.pcielp_txbuf_flush = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pcielp_txbuf_watermark = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pcielp_txbuf_tmo_en = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pcielp_txbuf_tmo_value = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pdev_stats_update_period = WMI_10X_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	.vdev_stats_update_period = WMI_10X_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	.peer_stats_update_period = WMI_10X_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	.bcnflt_stats_update_period =
+				WMI_10X_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	.pmf_qos = WMI_10X_PDEV_PARAM_PMF_QOS,
+	.arp_ac_override = WMI_PDEV_PARAM_UNSUPPORTED,
+	.arpdhcp_ac_override = WMI_10X_PDEV_PARAM_ARPDHCP_AC_OVERRIDE,
+	.dcs = WMI_10X_PDEV_PARAM_DCS,
+	.ani_enable = WMI_10X_PDEV_PARAM_ANI_ENABLE,
+	.ani_poll_period = WMI_10X_PDEV_PARAM_ANI_POLL_PERIOD,
+	.ani_listen_period = WMI_10X_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	.ani_ofdm_level = WMI_10X_PDEV_PARAM_ANI_OFDM_LEVEL,
+	.ani_cck_level = WMI_10X_PDEV_PARAM_ANI_CCK_LEVEL,
+	.dyntxchain = WMI_10X_PDEV_PARAM_DYNTXCHAIN,
+	.proxy_sta = WMI_PDEV_PARAM_UNSUPPORTED,
+	.idle_ps_config = WMI_PDEV_PARAM_UNSUPPORTED,
+	.power_gating_sleep = WMI_PDEV_PARAM_UNSUPPORTED,
+	.fast_channel_reset = WMI_10X_PDEV_PARAM_FAST_CHANNEL_RESET,
+	.burst_dur = WMI_10X_PDEV_PARAM_BURST_DUR,
+	.burst_enable = WMI_10X_PDEV_PARAM_BURST_ENABLE,
+};
+
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
@@ -1870,10 +1975,12 @@ int ath10k_wmi_attach(struct ath10k *ar)
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
 
@@ -2009,12 +2116,16 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_resume_cmdid);
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
index 1518586..80ab2f0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2072,6 +2072,60 @@ struct wmi_csa_event {
 #define VDEV_DEFAULT_STATS_UPDATE_PERIOD    500
 #define PEER_DEFAULT_STATS_UPDATE_PERIOD    500
 
+struct wmi_pdev_param_map {
+	u32 tx_chain_mask;
+	u32 rx_chain_mask;
+	u32 txpower_limit2g;
+	u32 txpower_limit5g;
+	u32 txpower_scale;
+	u32 beacon_gen_mode;
+	u32 beacon_tx_mode;
+	u32 resmgr_offchan_mode;
+	u32 protection_mode;
+	u32 dynamic_bw;
+	u32 non_agg_sw_retry_th;
+	u32 agg_sw_retry_th;
+	u32 sta_kickout_th;
+	u32 ac_aggrsize_scaling;
+	u32 ltr_enable;
+	u32 ltr_ac_latency_be;
+	u32 ltr_ac_latency_bk;
+	u32 ltr_ac_latency_vi;
+	u32 ltr_ac_latency_vo;
+	u32 ltr_ac_latency_timeout;
+	u32 ltr_sleep_override;
+	u32 ltr_rx_override;
+	u32 ltr_tx_activity_timeout;
+	u32 l1ss_enable;
+	u32 dsleep_enable;
+	u32 pcielp_txbuf_flush;
+	u32 pcielp_txbuf_watermark;
+	u32 pcielp_txbuf_tmo_en;
+	u32 pcielp_txbuf_tmo_value;
+	u32 pdev_stats_update_period;
+	u32 vdev_stats_update_period;
+	u32 peer_stats_update_period;
+	u32 bcnflt_stats_update_period;
+	u32 pmf_qos;
+	u32 arp_ac_override;
+	u32 arpdhcp_ac_override;
+	u32 dcs;
+	u32 ani_enable;
+	u32 ani_poll_period;
+	u32 ani_listen_period;
+	u32 ani_ofdm_level;
+	u32 ani_cck_level;
+	u32 dyntxchain;
+	u32 proxy_sta;
+	u32 idle_ps_config;
+	u32 power_gating_sleep;
+	u32 fast_channel_reset;
+	u32 burst_dur;
+	u32 burst_enable;
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
 int ath10k_wmi_start_scan(struct ath10k *ar, const struct wmi_start_scan_arg *);
 void ath10k_wmi_start_scan_init(struct ath10k *ar, struct wmi_start_scan_arg *);
-- 
1.7.10

