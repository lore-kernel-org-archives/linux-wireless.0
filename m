Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:52039 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3KNIfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 03:35:18 -0500
Received: by mail-we0-f170.google.com with SMTP id p61so1563340wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 00:35:17 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/3] ath10k: introduce DFS implementation
Date: Thu, 14 Nov 2013 09:33:37 +0100
Message-Id: <1384418018-4973-2-git-send-email-marek.puzyniak@tieto.com> (sfid-20131114_093521_572593_68FAC90D)
In-Reply-To: <1384418018-4973-1-git-send-email-marek.puzyniak@tieto.com>
References: <1384418018-4973-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure interface combination for AP running on channels
where radar detection is required. It allows only one type
of interface - AP on DFS channel and limits number of AP
interfaces to 8. Setup WMI channel flags accordingly to mac
channel configuration. CAC based on additional monitor vdev
is started if required for current channel.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/Kconfig  |   7 ++
 drivers/net/wireless/ath/ath10k/core.h   |   6 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   5 +
 drivers/net/wireless/ath/ath10k/mac.c    | 160 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.c    |  23 ++++-
 drivers/net/wireless/ath/ath10k/wmi.h    |   1 +
 6 files changed, 189 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 82e8088..f51b8e9 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -37,3 +37,10 @@ config ATH10K_TRACING
 	---help---
 	  Select this to ath10k use tracing infrastructure.
 
+config ATH10K_DFS_CERTIFIED
+	bool "Atheros DFS support for certified platforms"
+	depends on ATH10K && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  This option enables DFS support for initiating radiation on
+	  ath10k.
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 671dbe3..d5fd74b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -310,6 +310,11 @@ enum ath10k_fw_features {
 	ATH10K_FW_FEATURE_COUNT,
 };
 
+enum ath10k_dev_flags {
+	/* Indicates that ath10k device is during CAC phase of DFS */
+	ATH10K_CAC_RUNNING,
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -403,6 +408,7 @@ struct ath10k {
 	bool monitor_enabled;
 	bool monitor_present;
 	unsigned int filter_flags;
+	unsigned long dev_flags;
 
 	struct wmi_pdev_set_wmm_params_arg wmm_params;
 	struct completion install_key_done;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 90d4f74..d619291 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -959,6 +959,11 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
+			if (test_bit(ATH10K_CAC_RUNNING, &htt->ar->dev_flags)) {
+				ath10k_htt_rx_free_msdu_chain(msdu_head);
+				continue;
+			}
+
 			/* FIXME: we do not support chaining yet.
 			 * this needs investigation */
 			if (msdu_chaining) {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1a70d0c..a1bc8a8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -463,6 +463,10 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 		arg.ssid = arvif->u.ap.ssid;
 		arg.ssid_len = arvif->u.ap.ssid_len;
 		arg.hidden_ssid = arvif->u.ap.hidden_ssid;
+
+		/* For now allow DFS for AP mode */
+		arg.channel.chan_radar =
+			!!(channel->flags & IEEE80211_CHAN_RADAR);
 	} else if (arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
 		arg.ssid = arvif->vif->bss_conf.ssid;
 		arg.ssid_len = arvif->vif->bss_conf.ssid_len;
@@ -532,6 +536,8 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 	/* TODO setup this dynamically, what in case we
 	   don't have any vifs? */
 	arg.channel.mode = chan_to_phymode(&ar->hw->conf.chandef);
+	arg.channel.chan_radar =
+			!!(channel->flags & IEEE80211_CHAN_RADAR);
 
 	arg.channel.min_power = 0;
 	arg.channel.max_power = channel->max_power * 2;
@@ -666,6 +672,107 @@ static int ath10k_monitor_destroy(struct ath10k *ar)
 	return ret;
 }
 
+static int ath10k_start_cac(struct ath10k *ar)
+{
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	set_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+
+	ret = ath10k_monitor_create(ar);
+	if (ret) {
+		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+		return ret;
+	}
+
+	ret = ath10k_monitor_start(ar, ar->monitor_vdev_id);
+	if (ret) {
+		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+		ath10k_monitor_destroy(ar);
+		return ret;
+	}
+
+	ath10k_dbg(ATH10K_DBG_MAC, "mac cac start monitor vdev %d\n",
+		   ar->monitor_vdev_id);
+
+	return 0;
+}
+
+static int ath10k_stop_cac(struct ath10k *ar)
+{
+	lockdep_assert_held(&ar->conf_mutex);
+
+	/* CAC is not running - do nothing */
+	if (!test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags))
+		return 0;
+
+	ath10k_monitor_stop(ar);
+	ath10k_monitor_destroy(ar);
+	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+
+	ath10k_dbg(ATH10K_DBG_MAC, "mac cac finished\n");
+
+	return 0;
+}
+
+static const char *ath10k_dfs_state(enum nl80211_dfs_state dfs_state)
+{
+	switch (dfs_state) {
+	case NL80211_DFS_USABLE:
+		return "USABLE";
+	case NL80211_DFS_UNAVAILABLE:
+		return "UNAVAILABLE";
+	case NL80211_DFS_AVAILABLE:
+		return "AVAILABLE";
+	default:
+		WARN_ON(1);
+		return "bug";
+	}
+}
+
+static void ath10k_config_radar_detection(struct ath10k *ar)
+{
+	struct ieee80211_channel *chan = ar->hw->conf.chandef.chan;
+	bool radar = ar->hw->conf.radar_enabled;
+	bool chan_radar = !!(chan->flags & IEEE80211_CHAN_RADAR);
+	enum nl80211_dfs_state dfs_state = chan->dfs_state;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	ath10k_dbg(ATH10K_DBG_MAC,
+		   "mac radar config update: chan %dMHz radar %d chan radar %d chan state %s\n",
+		   chan->center_freq, radar, chan_radar,
+		   ath10k_dfs_state(dfs_state));
+
+	/*
+	 * It's safe to call it even if CAC is not started.
+	 * This call here guarantees changing channel, etc. will stop CAC.
+	 */
+	ath10k_stop_cac(ar);
+
+	if (!radar)
+		return;
+
+	if (!chan_radar)
+		return;
+
+	if (dfs_state != NL80211_DFS_USABLE)
+		return;
+
+	ret = ath10k_start_cac(ar);
+	if (ret) {
+		/*
+		 * Not possible to start CAC on current channel so starting
+		 * radiation is not allowed, make this channel DFS_UNAVAILABLE
+		 * by indicating that radar was detected.
+		 */
+		ath10k_warn("failed to start CAC (%d)\n", ret);
+		ieee80211_radar_detected(ar->hw);
+	}
+}
+
 static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 				struct ieee80211_bss_conf *info)
 {
@@ -1375,6 +1482,9 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			ch->ht40plus =
 				!(channel->flags & IEEE80211_CHAN_NO_HT40PLUS);
 
+			ch->chan_radar =
+				!!(channel->flags & IEEE80211_CHAN_RADAR);
+
 			passive = channel->flags & IEEE80211_CHAN_PASSIVE_SCAN;
 			ch->passive = passive;
 
@@ -1921,6 +2031,7 @@ void ath10k_halt(struct ath10k *ar)
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
+	ath10k_stop_cac(ar);
 	del_timer_sync(&ar->scan.timeout);
 	ath10k_offchan_tx_purge(ar);
 	ath10k_mgmt_over_wmi_tx_purge(ar);
@@ -2035,11 +2146,16 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&ar->conf_mutex);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac config channel %d mhz\n",
-			   conf->chandef.chan->center_freq);
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac config channel %d mhz flags 0x%x\n",
+			   conf->chandef.chan->center_freq,
+			   conf->chandef.chan->flags);
+
 		spin_lock_bh(&ar->data_lock);
 		ar->rx_channel = conf->chandef.chan;
 		spin_unlock_bh(&ar->data_lock);
+
+		ath10k_config_radar_detection(ar);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -3308,12 +3424,36 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	},
 };
 
-static const struct ieee80211_iface_combination ath10k_if_comb = {
-	.limits = ath10k_if_limits,
-	.n_limits = ARRAY_SIZE(ath10k_if_limits),
-	.max_interfaces = 8,
-	.num_different_channels = 1,
-	.beacon_int_infra_match = true,
+#ifdef CONFIG_ATH10K_DFS_CERTIFIED
+static const struct ieee80211_iface_limit ath10k_if_dfs_limits[] = {
+	{
+	.max	= 8,
+	.types	= BIT(NL80211_IFTYPE_AP)
+	},
+};
+#endif
+
+static const struct ieee80211_iface_combination ath10k_if_comb[] = {
+	{
+		.limits = ath10k_if_limits,
+		.n_limits = ARRAY_SIZE(ath10k_if_limits),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+	},
+#ifdef CONFIG_ATH10K_DFS_CERTIFIED
+	{
+		.limits = ath10k_if_dfs_limits,
+		.n_limits = ARRAY_SIZE(ath10k_if_dfs_limits),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40) |
+					BIT(NL80211_CHAN_WIDTH_80),
+	}
+#endif
 };
 
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
@@ -3537,8 +3677,8 @@ int ath10k_mac_register(struct ath10k *ar)
 	 */
 	ar->hw->queues = 4;
 
-	ar->hw->wiphy->iface_combinations = &ath10k_if_comb;
-	ar->hw->wiphy->n_iface_combinations = 1;
+	ar->hw->wiphy->iface_combinations = ath10k_if_comb;
+	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_if_comb);
 
 	ar->hw->netdev_features = NETIF_F_HW_CSUM;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f0bc94a..aea81d9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -907,6 +907,11 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ATH10K_DBG_MGMT,
 		   "event mgmt rx status %08x\n", rx_status);
 
+	if (test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags)) {
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
 	if (rx_status & WMI_RX_STATUS_ERR_DECRYPT) {
 		dev_kfree_skb(skb);
 		return 0;
@@ -2302,6 +2307,7 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 {
 	struct wmi_set_channel_cmd *cmd;
 	struct sk_buff *skb;
+	u32 ch_flags = 0;
 
 	if (arg->passive)
 		return -EINVAL;
@@ -2310,10 +2316,14 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 	if (!skb)
 		return -ENOMEM;
 
+	if (arg->chan_radar)
+		ch_flags |= WMI_CHAN_FLAG_DFS;
+
 	cmd = (struct wmi_set_channel_cmd *)skb->data;
 	cmd->chan.mhz               = __cpu_to_le32(arg->freq);
 	cmd->chan.band_center_freq1 = __cpu_to_le32(arg->freq);
 	cmd->chan.mode              = arg->mode;
+	cmd->chan.flags		   |= __cpu_to_le32(ch_flags);
 	cmd->chan.min_power         = arg->min_power;
 	cmd->chan.max_power         = arg->max_power;
 	cmd->chan.reg_power         = arg->max_reg_power;
@@ -2862,6 +2872,7 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	struct sk_buff *skb;
 	const char *cmdname;
 	u32 flags = 0;
+	u32 ch_flags = 0;
 
 	if (cmd_id != ar->wmi.cmd->vdev_start_request_cmdid &&
 	    cmd_id != ar->wmi.cmd->vdev_restart_request_cmdid)
@@ -2888,6 +2899,8 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 		flags |= WMI_VDEV_START_HIDDEN_SSID;
 	if (arg->pmf_enabled)
 		flags |= WMI_VDEV_START_PMF_ENABLED;
+	if (arg->channel.chan_radar)
+		ch_flags |= WMI_CHAN_FLAG_DFS;
 
 	cmd = (struct wmi_vdev_start_request_cmd *)skb->data;
 	cmd->vdev_id         = __cpu_to_le32(arg->vdev_id);
@@ -2909,6 +2922,7 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 		__cpu_to_le32(arg->channel.band_center_freq1);
 
 	cmd->chan.mode = arg->channel.mode;
+	cmd->chan.flags |= __cpu_to_le32(ch_flags);
 	cmd->chan.min_power = arg->channel.min_power;
 	cmd->chan.max_power = arg->channel.max_power;
 	cmd->chan.reg_power = arg->channel.max_reg_power;
@@ -2916,9 +2930,10 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	cmd->chan.antenna_max = arg->channel.max_antenna_gain;
 
 	ath10k_dbg(ATH10K_DBG_WMI,
-		   "wmi vdev %s id 0x%x freq %d, mode %d, ch_flags: 0x%0X,"
-		   "max_power: %d\n", cmdname, arg->vdev_id, arg->channel.freq,
-		   arg->channel.mode, flags, arg->channel.max_power);
+		   "wmi vdev %s id 0x%x flags: 0x%0X, freq %d, mode %d, "
+		   "ch_flags: 0x%0X, max_power: %d\n", cmdname, arg->vdev_id,
+		   flags, arg->channel.freq, arg->channel.mode,
+		   cmd->chan.flags, arg->channel.max_power);
 
 	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
 }
@@ -3252,6 +3267,8 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 			flags |= WMI_CHAN_FLAG_ALLOW_VHT;
 		if (ch->ht40plus)
 			flags |= WMI_CHAN_FLAG_HT40_PLUS;
+		if (ch->chan_radar)
+			flags |= WMI_CHAN_FLAG_DFS;
 
 		ci->mhz               = __cpu_to_le32(ch->freq);
 		ci->band_center_freq1 = __cpu_to_le32(ch->freq);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ad53333..b47a301 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -916,6 +916,7 @@ struct wmi_channel_arg {
 	bool allow_ht;
 	bool allow_vht;
 	bool ht40plus;
+	bool chan_radar;
 	/* note: power unit is 0.5 dBm */
 	u32 min_power;
 	u32 max_power;
-- 
1.8.1.2

