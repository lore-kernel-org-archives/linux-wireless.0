Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935150AbeFMKqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:46:22 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 7/7] mac80211: Add api to configure low and high RSSI threshold
Date: Wed, 13 Jun 2018 16:15:47 +0530
Message-Id: <1528886747-26342-8-git-send-email-tamizhr@codeaurora.org> (sfid-20180613_124654_137470_DFC5E437)
In-Reply-To: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add set_sta_mon_rssi_range_config api to support
configuring low and high RSSI threshold values
for a connected station. And trigger an event if a
station's signal strength goes out of configured
range.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/cfg.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c       |   23 +++++++++++++++++++++++
 net/mac80211/sta_info.h |    6 ++++++
 3 files changed, 69 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 80ced50..5cdd8a3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3831,12 +3831,51 @@ static int ieee80211_set_sta_mon_rssi_config(struct wiphy *wiphy,
 
 	sta->rssi_thold = rssi_thold;
 	sta->rssi_hyst = rssi_hyst;
+	sta->rssi_low = 0;
+	sta->rssi_high = 0;
 	sta->last_sta_mon_event_signal = 0;
 unlock:
 	mutex_unlock(&sdata->local->sta_mtx);
 	return 0;
 }
 
+static int ieee80211_set_sta_mon_rssi_range_cfg(struct wiphy *wiphy,
+						struct net_device *dev,
+						const u8 *peer,
+						s32 rssi_low, s32 rssi_high)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP &&
+	    (!sdata->vif.bss_conf.enable_beacon ||
+	    !wiphy_ext_feature_isset(sdata->local->hw.wiphy,
+				     NL80211_EXT_FEATURE_STA_MON_RSSI_LIST)))
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
@@ -3932,4 +3971,5 @@ static int ieee80211_set_sta_mon_rssi_config(struct wiphy *wiphy,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
 	.set_sta_mon_rssi_config = ieee80211_set_sta_mon_rssi_config,
+	.set_sta_mon_rssi_range_config = ieee80211_set_sta_mon_rssi_range_cfg,
 };
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 06a6111..fddb5c6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1569,6 +1569,29 @@ static void ieee80211_sta_rx_signal_thold_check(struct ieee80211_rx_data *rx)
 				sig, GFP_ATOMIC);
 		}
 	}
+
+	if (sta->rssi_low) {
+		int last_event = sta->last_sta_mon_event_signal;
+		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
+		int low = sta->rssi_low;
+		int high = sta->rssi_high;
+
+		if (sig < low &&
+		    (last_event == 0 || last_event >= low)) {
+			sta->last_sta_mon_event_signal = sig;
+			cfg80211_sta_mon_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_ATOMIC);
+		} else if (sig > high &&
+			   (last_event == 0 || last_event <= high)) {
+			sta->last_sta_mon_event_signal = sig;
+			cfg80211_sta_mon_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
+				sig, GFP_ATOMIC);
+		}
+	}
 }
 
 static ieee80211_rx_result debug_noinline
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e130f6d..05d68f8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -487,6 +487,10 @@ struct ieee80211_sta_rx_stats {
  *	should cause an event to be sent indicating where the current value
  *	is in relation to the newly configured threshold
  * @rssi_hyst: Station's RSSI hysteresis
+ * @rssi_low: RSSI lower threshold to monitor station's signal strength, a zero
+ *	value implies disabled.  This is an alternative mechanism to the single
+ *	threshold event and can't be enabled simultaneously with it
+ * @rssi_high: RSSI upper threshold for station
  * @last_sta_mon_event_signal: Last signal strength average for a station
  *	that triggered a sta_mon event. 0 indicates that no event has been
  *	generated for the current association
@@ -596,6 +600,8 @@ struct sta_info {
 
 	s32 rssi_thold;
 	u32 rssi_hyst;
+	s32 rssi_low;
+	s32 rssi_high;
 	int last_sta_mon_event_signal;
 	unsigned int count_rx_signal;
 
-- 
1.7.9.5
