Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50583 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaDDLfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 07:35:00 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so1055668wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 04:34:58 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/2] ath10k: reorder functions
Date: Fri,  4 Apr 2014 13:28:45 +0200
Message-Id: <1396610926-5787-2-git-send-email-michal.kazior@tieto.com> (sfid-20140404_134044_608781_7322C2AB)
In-Reply-To: <1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
 <1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is done to avoid forward declarations with
upcomming patches.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * introduced to avoid forward declaration

 drivers/net/wireless/ath/ath10k/mac.c | 170 +++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 58ec5a7..e1f4227 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -489,91 +489,6 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_vdev_start(struct ath10k_vif *arvif)
-{
-	struct ath10k *ar = arvif->ar;
-	struct cfg80211_chan_def *chandef = &ar->chandef;
-	struct wmi_vdev_start_request_arg arg = {};
-	int ret = 0;
-
-	lockdep_assert_held(&ar->conf_mutex);
-
-	reinit_completion(&ar->vdev_setup_done);
-
-	arg.vdev_id = arvif->vdev_id;
-	arg.dtim_period = arvif->dtim_period;
-	arg.bcn_intval = arvif->beacon_interval;
-
-	arg.channel.freq = chandef->chan->center_freq;
-	arg.channel.band_center_freq1 = chandef->center_freq1;
-	arg.channel.mode = chan_to_phymode(chandef);
-
-	arg.channel.min_power = 0;
-	arg.channel.max_power = chandef->chan->max_power * 2;
-	arg.channel.max_reg_power = chandef->chan->max_reg_power * 2;
-	arg.channel.max_antenna_gain = chandef->chan->max_antenna_gain * 2;
-
-	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
-		arg.ssid = arvif->u.ap.ssid;
-		arg.ssid_len = arvif->u.ap.ssid_len;
-		arg.hidden_ssid = arvif->u.ap.hidden_ssid;
-
-		/* For now allow DFS for AP mode */
-		arg.channel.chan_radar =
-			!!(chandef->chan->flags & IEEE80211_CHAN_RADAR);
-	} else if (arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
-		arg.ssid = arvif->vif->bss_conf.ssid;
-		arg.ssid_len = arvif->vif->bss_conf.ssid_len;
-	}
-
-	ath10k_dbg(ATH10K_DBG_MAC,
-		   "mac vdev %d start center_freq %d phymode %s\n",
-		   arg.vdev_id, arg.channel.freq,
-		   ath10k_wmi_phymode_str(arg.channel.mode));
-
-	ret = ath10k_wmi_vdev_start(ar, &arg);
-	if (ret) {
-		ath10k_warn("failed to start WMI vdev %i: %d\n",
-			    arg.vdev_id, ret);
-		return ret;
-	}
-
-	ret = ath10k_vdev_setup_sync(ar);
-	if (ret) {
-		ath10k_warn("failed to synchronise setup for vdev %i: %d\n",
-			    arg.vdev_id, ret);
-		return ret;
-	}
-
-	return ret;
-}
-
-static int ath10k_vdev_stop(struct ath10k_vif *arvif)
-{
-	struct ath10k *ar = arvif->ar;
-	int ret;
-
-	lockdep_assert_held(&ar->conf_mutex);
-
-	reinit_completion(&ar->vdev_setup_done);
-
-	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
-	if (ret) {
-		ath10k_warn("failed to stop WMI vdev %i: %d\n",
-			    arvif->vdev_id, ret);
-		return ret;
-	}
-
-	ret = ath10k_vdev_setup_sync(ar);
-	if (ret) {
-		ath10k_warn("failed to syncronise setup for vdev %i: %d\n",
-			    arvif->vdev_id, ret);
-		return ret;
-	}
-
-	return ret;
-}
-
 static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 {
 	struct cfg80211_chan_def *chandef = &ar->chandef;
@@ -861,6 +776,91 @@ static void ath10k_config_radar_detection(struct ath10k *ar)
 	}
 }
 
+static int ath10k_vdev_start(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	struct cfg80211_chan_def *chandef = &ar->chandef;
+	struct wmi_vdev_start_request_arg arg = {};
+	int ret = 0;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	reinit_completion(&ar->vdev_setup_done);
+
+	arg.vdev_id = arvif->vdev_id;
+	arg.dtim_period = arvif->dtim_period;
+	arg.bcn_intval = arvif->beacon_interval;
+
+	arg.channel.freq = chandef->chan->center_freq;
+	arg.channel.band_center_freq1 = chandef->center_freq1;
+	arg.channel.mode = chan_to_phymode(chandef);
+
+	arg.channel.min_power = 0;
+	arg.channel.max_power = chandef->chan->max_power * 2;
+	arg.channel.max_reg_power = chandef->chan->max_reg_power * 2;
+	arg.channel.max_antenna_gain = chandef->chan->max_antenna_gain * 2;
+
+	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
+		arg.ssid = arvif->u.ap.ssid;
+		arg.ssid_len = arvif->u.ap.ssid_len;
+		arg.hidden_ssid = arvif->u.ap.hidden_ssid;
+
+		/* For now allow DFS for AP mode */
+		arg.channel.chan_radar =
+			!!(chandef->chan->flags & IEEE80211_CHAN_RADAR);
+	} else if (arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
+		arg.ssid = arvif->vif->bss_conf.ssid;
+		arg.ssid_len = arvif->vif->bss_conf.ssid_len;
+	}
+
+	ath10k_dbg(ATH10K_DBG_MAC,
+		   "mac vdev %d start center_freq %d phymode %s\n",
+		   arg.vdev_id, arg.channel.freq,
+		   ath10k_wmi_phymode_str(arg.channel.mode));
+
+	ret = ath10k_wmi_vdev_start(ar, &arg);
+	if (ret) {
+		ath10k_warn("failed to start WMI vdev %i: %d\n",
+			    arg.vdev_id, ret);
+		return ret;
+	}
+
+	ret = ath10k_vdev_setup_sync(ar);
+	if (ret) {
+		ath10k_warn("failed to synchronise setup for vdev %i: %d\n",
+			    arg.vdev_id, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int ath10k_vdev_stop(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	reinit_completion(&ar->vdev_setup_done);
+
+	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
+	if (ret) {
+		ath10k_warn("failed to stop WMI vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
+	ret = ath10k_vdev_setup_sync(ar);
+	if (ret) {
+		ath10k_warn("failed to syncronise setup for vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
 static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 				struct ieee80211_bss_conf *info)
 {
-- 
1.8.5.3

