Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59005 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaAJJYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 04:24:09 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so1917811eak.16
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jan 2014 01:24:07 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add support for AP CSA
Date: Fri, 10 Jan 2014 10:19:23 +0100
Message-Id: <1389345563-3445-1-git-send-email-michal.kazior@tieto.com> (sfid-20140110_102430_395500_A78E4F48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements Channel Switch Announcement
for AP mode. This allows for a smooth channel
switch for connected stations that support CSA
when radar is detected.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 80 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.c  | 18 ++++++++
 3 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 035cbf6..2554161 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -414,6 +414,7 @@ struct ath10k {
 	unsigned int filter_flags;
 	unsigned long dev_flags;
 	u32 dfs_block_radar_events;
+	struct ath10k_vif *csa_arvif;
 
 	struct wmi_pdev_set_wmm_params_arg wmm_params;
 	struct completion install_key_done;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5b45f3a..5c26766 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -435,8 +435,7 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 static int ath10k_vdev_start(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
-	struct ieee80211_conf *conf = &ar->hw->conf;
-	struct ieee80211_channel *channel = conf->chandef.chan;
+	struct cfg80211_chan_def *chandef = &ar->hw->conf.chandef;
 	struct wmi_vdev_start_request_arg arg = {};
 	int ret = 0;
 
@@ -448,16 +447,14 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 	arg.dtim_period = arvif->dtim_period;
 	arg.bcn_intval = arvif->beacon_interval;
 
-	arg.channel.freq = channel->center_freq;
-
-	arg.channel.band_center_freq1 = conf->chandef.center_freq1;
-
-	arg.channel.mode = chan_to_phymode(&conf->chandef);
+	arg.channel.freq = chandef->chan->center_freq;
+	arg.channel.band_center_freq1 = chandef->center_freq1;
+	arg.channel.mode = chan_to_phymode(chandef);
 
 	arg.channel.min_power = 0;
-	arg.channel.max_power = channel->max_power * 2;
-	arg.channel.max_reg_power = channel->max_reg_power * 2;
-	arg.channel.max_antenna_gain = channel->max_antenna_gain * 2;
+	arg.channel.max_power = chandef->chan->max_power * 2;
+	arg.channel.max_reg_power = chandef->chan->max_reg_power * 2;
+	arg.channel.max_antenna_gain = chandef->chan->max_antenna_gain * 2;
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		arg.ssid = arvif->u.ap.ssid;
@@ -466,7 +463,7 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 
 		/* For now allow DFS for AP mode */
 		arg.channel.chan_radar =
-			!!(channel->flags & IEEE80211_CHAN_RADAR);
+			!!(chandef->chan->flags & IEEE80211_CHAN_RADAR);
 	} else if (arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
 		arg.ssid = arvif->vif->bss_conf.ssid;
 		arg.ssid_len = arvif->vif->bss_conf.ssid_len;
@@ -2136,6 +2133,38 @@ static int ath10k_config_ps(struct ath10k *ar)
 	return ret;
 }
 
+static void ath10k_mac_update_ap_channel(struct ath10k_vif *arvif)
+{
+	const u8 *bssid = arvif->vif->bss_conf.bssid;
+	int ret;
+
+	ath10k_dbg(ATH10K_DBG_MAC, "mac AP channel update %dMHz\n",
+		   arvif->ar->hw->conf.chandef.chan->center_freq);
+
+	ret = ath10k_vdev_stop(arvif);
+	if (ret) {
+		ath10k_warn("could not stop vdev %d (%d)\n",
+			    arvif->vdev_id, ret);
+		return;
+	}
+
+	ret = ath10k_vdev_start(arvif);
+	if (ret) {
+		ath10k_warn("could not start vdev %d (%d)\n",
+			    arvif->vdev_id, ret);
+		return;
+	}
+
+	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, 0, bssid);
+	if (ret) {
+		ath10k_warn("could not bring vdev up %d (%d)\n",
+			    arvif->vdev_id, ret);
+		return;
+	}
+
+	ath10k_dbg(ATH10K_DBG_MAC, "mac AP channel update complete\n");
+}
+
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath10k *ar = hw->priv;
@@ -2156,6 +2185,9 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		spin_unlock_bh(&ar->data_lock);
 
 		ath10k_config_radar_detection(ar);
+
+		if (ar->csa_arvif && ar->csa_arvif->vif->csa_active)
+			ath10k_mac_update_ap_channel(ar->csa_arvif);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -2495,6 +2527,12 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   "vdev %d set beacon tx mode to staggered\n",
 			   arvif->vdev_id);
 
+		if (ar->csa_arvif) {
+			ath10k_dbg(ATH10K_DBG_MAC, "mac CSA completed for vdev_id %d\n",
+				   arvif->vdev_id);
+			ar->csa_arvif = NULL;
+		}
+
 		pdev_param = ar->wmi.pdev_param->beacon_tx_mode;
 		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
 						WMI_BEACON_STAGGERED_MODE);
@@ -3310,6 +3348,24 @@ exit:
 	return ret;
 }
 
+static void ath10k_channel_switch_beacon(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct cfg80211_chan_def *chandef)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+
+	/* FIXME: Multi-VIF not supported */
+
+	if (ar->csa_arvif != NULL) {
+		ath10k_warn("CSA is already active for this device, ignoring!\n");
+		return;
+	}
+
+	ar->csa_arvif = arvif;
+	return;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -3332,6 +3388,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.tx_last_beacon			= ath10k_tx_last_beacon,
 	.restart_complete		= ath10k_restart_complete,
 	.get_survey			= ath10k_get_survey,
+	.channel_switch_beacon		= ath10k_channel_switch_beacon,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
@@ -3712,6 +3769,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
 
 	ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 3ec6c9a..5985197 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -558,6 +558,22 @@ err_pull:
 	return ret;
 }
 
+static void ath10k_update_csa(struct ath10k_vif *arvif)
+{
+	lockdep_assert_held(&arvif->ar->data_lock);
+
+	if (arvif->ar->csa_arvif != arvif)
+		return;
+
+	if (!arvif->vif->csa_active)
+		return;
+
+	if (!ieee80211_csa_is_complete(arvif->vif))
+		return;
+
+	ieee80211_csa_finish(arvif->vif);
+}
+
 static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 {
 	struct wmi_bcn_tx_arg arg = {0};
@@ -580,6 +596,8 @@ static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 
 	dev_kfree_skb_any(arvif->beacon);
 	arvif->beacon = NULL;
+
+	ath10k_update_csa(arvif);
 }
 
 static void ath10k_wmi_tx_beacons_iter(void *data, u8 *mac,
-- 
1.8.4.rc3

