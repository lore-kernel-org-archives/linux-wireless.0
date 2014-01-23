Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37391 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaAWKnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 05:43:43 -0500
Received: by mail-ee0-f42.google.com with SMTP id e49so321497eek.15
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 02:43:42 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: implement channel switching
Date: Thu, 23 Jan 2014 11:38:25 +0100
Message-Id: <1390473506-15677-2-git-send-email-michal.kazior@tieto.com> (sfid-20140123_114359_574354_B40A2869)
In-Reply-To: <1390473506-15677-1-git-send-email-michal.kazior@tieto.com>
References: <1390473506-15677-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now channel change wasn't propagating to FW
directly because operational channel is abstracted
by VDEVs and it wasn't really necessary since
ath10k implements hwscan and hwroc.

This effectively fixes STA CSA and allows for
future AP-like CSA as well.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  12 ++-
 drivers/net/wireless/ath/ath10k/mac.c  | 172 ++++++++++++++++++++++++++++-----
 2 files changed, 154 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ade1781..d39103d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -226,6 +226,11 @@ struct ath10k_vif {
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
 
+	bool is_started;
+	bool is_up;
+	u32 aid;
+	u8 bssid[ETH_ALEN];
+
 	struct work_struct wep_key_work;
 	struct ieee80211_key_conf *wep_keys[WMI_MAX_KEY_INDEX + 1];
 	u8 def_wep_key_idx;
@@ -235,7 +240,6 @@ struct ath10k_vif {
 
 	union {
 		struct {
-			u8 bssid[ETH_ALEN];
 			u32 uapsd;
 		} sta;
 		struct {
@@ -249,9 +253,6 @@ struct ath10k_vif {
 			u32 noa_len;
 			u8 *noa_data;
 		} ap;
-		struct {
-			u8 bssid[ETH_ALEN];
-		} ibss;
 	} u;
 
 	u8 fixed_rate;
@@ -412,6 +413,9 @@ struct ath10k {
 	/* valid during scan; needed for mgmt rx during scan */
 	struct ieee80211_channel *scan_channel;
 
+	/* current operating channel definition */
+	struct cfg80211_chan_def chandef;
+
 	int free_vdev_map;
 	int monitor_vdev_id;
 	bool monitor_enabled;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 776e364..323c886 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -444,8 +444,7 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 static int ath10k_vdev_start(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
-	struct ieee80211_conf *conf = &ar->hw->conf;
-	struct ieee80211_channel *channel = conf->chandef.chan;
+	struct cfg80211_chan_def *chandef = &ar->chandef;
 	struct wmi_vdev_start_request_arg arg = {};
 	int ret = 0;
 
@@ -457,16 +456,14 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
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
@@ -475,7 +472,7 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 
 		/* For now allow DFS for AP mode */
 		arg.channel.chan_radar =
-			!!(channel->flags & IEEE80211_CHAN_RADAR);
+			!!(chandef->chan->flags & IEEE80211_CHAN_RADAR);
 	} else if (arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
 		arg.ssid = arvif->vif->bss_conf.ssid;
 		arg.ssid_len = arvif->vif->bss_conf.ssid_len;
@@ -527,7 +524,8 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 
 static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 {
-	struct ieee80211_channel *channel = ar->hw->conf.chandef.chan;
+	struct cfg80211_chan_def *chandef = &ar->chandef;
+	struct ieee80211_channel *channel = chandef->chan;
 	struct wmi_vdev_start_request_arg arg = {};
 	int ret = 0;
 
@@ -540,11 +538,11 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 
 	arg.vdev_id = vdev_id;
 	arg.channel.freq = channel->center_freq;
-	arg.channel.band_center_freq1 = ar->hw->conf.chandef.center_freq1;
+	arg.channel.band_center_freq1 = chandef->center_freq1;
 
 	/* TODO setup this dynamically, what in case we
 	   don't have any vifs? */
-	arg.channel.mode = chan_to_phymode(&ar->hw->conf.chandef);
+	arg.channel.mode = chan_to_phymode(chandef);
 	arg.channel.chan_radar =
 			!!(channel->flags & IEEE80211_CHAN_RADAR);
 
@@ -791,6 +789,10 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 
 	if (!info->enable_beacon) {
 		ath10k_vdev_stop(arvif);
+
+		arvif->is_started = false;
+		arvif->is_up = false;
+
 		return;
 	}
 
@@ -800,12 +802,21 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	if (ret)
 		return;
 
-	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, 0, info->bssid);
+	arvif->aid = 0;
+	memcpy(arvif->bssid, info->bssid, ETH_ALEN);
+
+	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
+				 arvif->bssid);
 	if (ret) {
 		ath10k_warn("Failed to bring up VDEV: %d\n",
 			    arvif->vdev_id);
+		ath10k_vdev_stop(arvif);
 		return;
 	}
+
+	arvif->is_started = true;
+	arvif->is_up = true;
+
 	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d up\n", arvif->vdev_id);
 }
 
@@ -824,18 +835,18 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 			ath10k_warn("Failed to delete IBSS self peer:%pM for VDEV:%d ret:%d\n",
 				    self_peer, arvif->vdev_id, ret);
 
-		if (is_zero_ether_addr(arvif->u.ibss.bssid))
+		if (is_zero_ether_addr(arvif->bssid))
 			return;
 
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id,
-					 arvif->u.ibss.bssid);
+					 arvif->bssid);
 		if (ret) {
 			ath10k_warn("Failed to delete IBSS BSSID peer:%pM for VDEV:%d ret:%d\n",
-				    arvif->u.ibss.bssid, arvif->vdev_id, ret);
+				    arvif->bssid, arvif->vdev_id, ret);
 			return;
 		}
 
-		memset(arvif->u.ibss.bssid, 0, ETH_ALEN);
+		memset(arvif->bssid, 0, ETH_ALEN);
 
 		return;
 	}
@@ -1338,11 +1349,17 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		   "mac vdev %d up (associated) bssid %pM aid %d\n",
 		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
 
-	ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, bss_conf->aid,
-				 bss_conf->bssid);
-	if (ret)
+	arvif->aid = bss_conf->aid;
+	memcpy(arvif->bssid, bss_conf->bssid, ETH_ALEN);
+
+	ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, arvif->aid, arvif->bssid);
+	if (ret) {
 		ath10k_warn("VDEV: %d up failed: ret %d\n",
 			    arvif->vdev_id, ret);
+		return;
+	}
+
+	arvif->is_up = true;
 }
 
 /*
@@ -1382,6 +1399,9 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
 
 	arvif->def_wep_key_idx = 0;
+
+	arvif->is_started = false;
+	arvif->is_up = false;
 }
 
 static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
@@ -2145,6 +2165,98 @@ static int ath10k_config_ps(struct ath10k *ar)
 	return ret;
 }
 
+static const char *chandef_get_width(enum nl80211_chan_width width)
+{
+	switch (width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		return "20 (noht)";
+	case NL80211_CHAN_WIDTH_20:
+		return "20";
+	case NL80211_CHAN_WIDTH_40:
+		return "40";
+	case NL80211_CHAN_WIDTH_80:
+		return "80";
+	case NL80211_CHAN_WIDTH_80P80:
+		return "80+80";
+	case NL80211_CHAN_WIDTH_160:
+		return "160";
+	case NL80211_CHAN_WIDTH_5:
+		return "5";
+	case NL80211_CHAN_WIDTH_10:
+		return "10";
+	}
+	return "?";
+}
+
+static void ath10k_config_chan(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+	bool monitor_was_enabled;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	ath10k_dbg(ATH10K_DBG_MAC,
+		   "mac config channel to %dMHz (cf1 %dMHz cf2 %dMHz width %s)\n",
+		   ar->chandef.chan->center_freq,
+		   ar->chandef.center_freq1,
+		   ar->chandef.center_freq2,
+		   chandef_get_width(ar->chandef.width));
+
+	/* First stop monitor interface. Some FW versions crash if there's a
+	 * lone monitor interface. */
+	monitor_was_enabled = ar->monitor_enabled;
+
+	if (ar->monitor_enabled)
+		ath10k_monitor_stop(ar);
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (!arvif->is_started)
+			continue;
+
+		if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
+			continue;
+
+		ret = ath10k_vdev_stop(arvif);
+		if (ret) {
+			ath10k_warn("could not stop vdev %d (%d)\n",
+				    arvif->vdev_id, ret);
+			continue;
+		}
+	}
+
+	/* all vdevs are now stopped - now attempt to restart them */
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (!arvif->is_started)
+			continue;
+
+		if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
+			continue;
+
+		ret = ath10k_vdev_start(arvif);
+		if (ret) {
+			ath10k_warn("could not start vdev %d (%d)\n",
+				    arvif->vdev_id, ret);
+			continue;
+		}
+
+		if (!arvif->is_up)
+			continue;
+
+		ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
+					 arvif->bssid);
+		if (ret) {
+			ath10k_warn("could not bring vdev up %d (%d)\n",
+				    arvif->vdev_id, ret);
+			continue;
+		}
+	}
+
+	if (monitor_was_enabled)
+		ath10k_monitor_start(ar, ar->monitor_vdev_id);
+}
+
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath10k *ar = hw->priv;
@@ -2165,6 +2277,11 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		spin_unlock_bh(&ar->data_lock);
 
 		ath10k_config_radar_detection(ar);
+
+		if (!cfg80211_chandef_identical(&ar->chandef, &conf->chandef)) {
+			ar->chandef = conf->chandef;
+			ath10k_config_chan(ar);
+		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -2559,15 +2676,18 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				 * this is never erased as we it for crypto key
 				 * clearing; this is FW requirement
 				 */
-				memcpy(arvif->u.sta.bssid, info->bssid,
-				       ETH_ALEN);
+				memcpy(arvif->bssid, info->bssid, ETH_ALEN);
 
 				ath10k_dbg(ATH10K_DBG_MAC,
 					   "mac vdev %d start %pM\n",
 					   arvif->vdev_id, info->bssid);
 
-				/* FIXME: check return value */
 				ret = ath10k_vdev_start(arvif);
+				if (ret)
+					ath10k_warn("failed to start vdev: %d\n",
+						    ret);
+				else
+					arvif->is_started = true;
 			}
 
 			/*
@@ -2576,7 +2696,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			 * IBSS in order to remove BSSID peer.
 			 */
 			if (vif->type == NL80211_IFTYPE_ADHOC)
-				memcpy(arvif->u.ibss.bssid, info->bssid,
+				memcpy(arvif->bssid, info->bssid,
 				       ETH_ALEN);
 		}
 	}
-- 
1.8.5.3

