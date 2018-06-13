Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935188AbeFMKqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:46:16 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 3/7] mac80211: Add api to support configuring station specific rssi threshold
Date: Wed, 13 Jun 2018 16:15:43 +0530
Message-Id: <1528886747-26342-4-git-send-email-tamizhr@codeaurora.org> (sfid-20180613_124623_365761_29EA56AC)
In-Reply-To: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add set_sta_mon_rssi_config api to configure rssi and
hysteresis threshold value for a connected station. This configuration
will be applied only for the connected station.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/cfg.c      |   35 +++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |   12 ++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bdf6fa7..80ced50 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3803,6 +3803,40 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return ret;
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
+	     !wiphy_ext_feature_isset(sdata->local->hw.wiphy,
+				 NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG)))
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
+	sta->last_sta_mon_event_signal = 0;
+unlock:
+	mutex_unlock(&sdata->local->sta_mtx);
+	return 0;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3897,4 +3931,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
+	.set_sta_mon_rssi_config = ieee80211_set_sta_mon_rssi_config,
 };
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 81b35f6..8c459a7 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -482,6 +482,14 @@ struct ieee80211_sta_rx_stats {
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
  *	this (by advertising the USES_RSS hw flag)
  * @status_stats: TX status statistics
+ * @rssi_thold: RSSI threshold to monitor station's signal strength, a zero
+ *	value implies disabled. As with the cfg80211 callback, a change here
+ *	should cause an event to be sent indicating where the current value
+ *	is in relation to the newly configured threshold
+ * @rssi_hyst: Station's RSSI hysteresis
+ * @last_sta_mon_event_signal: Last signal strength average for a station
+ *	that triggered a sta_mon event. 0 indicates that no event has been
+ *	generated for the current association
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -583,6 +591,10 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	s32 rssi_thold;
+	u32 rssi_hyst;
+	int last_sta_mon_event_signal;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
-- 
1.7.9.5
