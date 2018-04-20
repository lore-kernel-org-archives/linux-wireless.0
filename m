Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35936 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753508AbeDTGye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 02:54:34 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFC 2/6] mac80211: enable setting rssi threshold config for AP mode
Date: Fri, 20 Apr 2018 12:22:47 +0530
Message-Id: <1524207171-3325-3-git-send-email-tamizhr@codeaurora.org> (sfid-20180420_085449_203979_C4AC2E41)
In-Reply-To: <1524207171-3325-1-git-send-email-tamizhr@codeaurora.org>
References: <1524207171-3325-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduce new api to set rssi single or low/high rssi
threshold value to track the connected stations signal strength.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/cfg.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h | 18 ++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 85dbaa8..0e2047c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3705,6 +3705,79 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_sta_mon_rssi_config(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     const u8 *peer, s32 rssi_thold,
+					     u32 rssi_hyst)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP &&
+	    (!sdata->vif.bss_conf.enable_beacon ||
+	    !wiphy_ext_feature_isset(sdata->local->hw.wiphy,
+			NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG)))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&sdata->local->sta_mtx);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta) {
+		mutex_unlock(&sdata->local->sta_mtx);
+		return -ENOENT;
+	}
+
+	if (sta->rssi_thold == rssi_thold &&
+	    sta->rssi_hyst == rssi_hyst)
+		goto unlock;
+
+	sta->rssi_thold = rssi_thold;
+	sta->rssi_hyst = rssi_hyst;
+	sta->rssi_low = 0;
+	sta->rssi_high = 0;
+	sta->last_sta_mon_event_signal = 0;
+unlock:
+	mutex_unlock(&sdata->local->sta_mtx);
+	return 0;
+}
+
+static int ieee80211_set_sta_mon_rssi_range_confg(struct wiphy *wiphy,
+						  struct net_device *dev,
+						  const u8 *peer,
+						  s32 rssi_low, s32 rssi_high)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP &&
+	    (!sdata->vif.bss_conf.enable_beacon ||
+	    !wiphy_ext_feature_isset(sdata->local->hw.wiphy,
+			NL80211_EXT_FEATURE_STA_MON_RSSI_LIST)))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&sdata->local->sta_mtx);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta) {
+		mutex_unlock(&sdata->local->sta_mtx);
+		return -ENOENT;
+	}
+
+	if (sta->rssi_low == rssi_low &&
+	    sta->rssi_high == rssi_high)
+		goto unlock;
+
+	sta->rssi_thold = 0;
+	sta->rssi_hyst = 0;
+	sta->rssi_low = rssi_low;
+	sta->rssi_high = rssi_high;
+	sta->last_sta_mon_event_signal = 0;
+
+unlock:
+	mutex_unlock(&sdata->local->sta_mtx);
+	return 0;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3798,4 +3871,6 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
 	.tx_control_port = ieee80211_tx_control_port,
+	.set_sta_mon_rssi_config = ieee80211_set_sta_mon_rssi_config,
+	.set_sta_mon_rssi_range_config = ieee80211_set_sta_mon_rssi_range_confg,
 };
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f64eb86..701eb37 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -481,6 +481,18 @@ struct ieee80211_sta_rx_stats {
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
  *	this (by advertising the USES_RSS hw flag)
  * @status_stats: TX status statistics
+ * @rssi_thold: RSSI threshold to monitor station's signal strength, a zero
+ *	value implies disabled. As with the cfg80211 callback, a change here
+ *	should cause an event to be sent indicating where the current value
+ *	is in relation to the newly configured threshold
+ * @rssi_hyst: Station's RSSI hysteresis
+ * @rssi_low: RSSI lower threshold to monitor station's signal strength, a zero
+ *	value implies disabled.  This is an alternative mechanism to the single
+ *	threshold event and can't be enabled simultaneously with it
+ * @rssi_high: RSSI upper threshold for station
+ * @last_sta_mon_event_signal: Last signal strength average for a station
+ *	that triggered a sta_mon event. 0 indicates that no event has been
+ *	generated for the current association
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -581,6 +593,12 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	s32 rssi_thold;
+	u32 rssi_hyst;
+	s32 rssi_low;
+	s32 rssi_high;
+	int last_sta_mon_event_signal;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
-- 
1.9.1
