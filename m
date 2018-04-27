Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757423AbeD0Fa2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 01:30:28 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv2 5/6] mac80211: Add support to configure txrate threshold for station
Date: Fri, 27 Apr 2018 11:00:35 +0530
Message-Id: <1524807036-28056-6-git-send-email-tamizhr@codeaurora.org> (sfid-20180427_073037_570256_BFDF4E51)
In-Reply-To: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
References: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support to configure station specific low and high
txrate thresholds using ieee80211_set_sta_mon_txrate_config API.
This configuration is used for tracking the txrate for connected
stations.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/cfg.c      | 35 +++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |  5 +++++
 2 files changed, 40 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0e2047c..ba2555d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3778,6 +3778,40 @@ static int ieee80211_set_sta_mon_rssi_range_confg(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_sta_mon_txrate_config(struct wiphy *wiphy,
+					       struct net_device *dev,
+					       const u8 *peer,
+					       u32 low_txrate_thold,
+					       u32 high_txrate_thold)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP &&
+	    !wiphy_ext_feature_isset(sdata->local->hw.wiphy,
+			NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG))
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
+	if (sta->txrate_low == low_txrate_thold &&
+	    sta->txrate_high == high_txrate_thold)
+		goto unlock;
+
+	sta->txrate_low = low_txrate_thold;
+	sta->txrate_high = high_txrate_thold;
+
+unlock:
+	mutex_unlock(&sdata->local->sta_mtx);
+	return 0;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3873,4 +3907,5 @@ static int ieee80211_set_sta_mon_rssi_range_confg(struct wiphy *wiphy,
 	.tx_control_port = ieee80211_tx_control_port,
 	.set_sta_mon_rssi_config = ieee80211_set_sta_mon_rssi_config,
 	.set_sta_mon_rssi_range_config = ieee80211_set_sta_mon_rssi_range_confg,
+	.set_sta_mon_txrate_config = ieee80211_set_sta_mon_txrate_config,
 };
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 1599973..c73d010 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -496,6 +496,8 @@ struct ieee80211_sta_rx_stats {
  * @count_rx_signal: Number of data frames used in averaging station signal.
  *	This can be used to avoid generating less reliable station rssi cross
  *	events that would be based only on couple of received frames.
+ * @txrate_low: TXRATE lower threshold for a station to monitor
+ * @txrate_high: TXRATE upper threshold for a station to monitor
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -603,6 +605,9 @@ struct sta_info {
 	int last_sta_mon_event_signal;
 	unsigned int count_rx_signal;
 
+	u32 txrate_low;
+	u32 txrate_high;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
-- 
1.9.1
