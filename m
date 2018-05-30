Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932140AbeE3TLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:11:05 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv3 2/4] mac80211: Add api to configure low and high txrate threshold
Date: Thu, 31 May 2018 00:40:48 +0530
Message-Id: <1527707450-2985-3-git-send-email-tamizhr@codeaurora.org> (sfid-20180530_211110_000441_0E3924DF)
In-Reply-To: <1527707450-2985-1-git-send-email-tamizhr@codeaurora.org>
References: <1527707450-2985-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add set_sta_mon_txrate_config api to configure low and high
txrate threshold for a connected station. The configuration
will be represented in 100kbps.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/cfg.c      | 35 +++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |  7 +++++++
 2 files changed, 42 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5cdd8a3..649f5c7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3876,6 +3876,40 @@ static int ieee80211_set_sta_mon_rssi_range_cfg(struct wiphy *wiphy,
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
+				NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG))
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
@@ -3972,4 +4006,5 @@ static int ieee80211_set_sta_mon_rssi_range_cfg(struct wiphy *wiphy,
 	.get_txq_stats = ieee80211_get_txq_stats,
 	.set_sta_mon_rssi_config = ieee80211_set_sta_mon_rssi_config,
 	.set_sta_mon_rssi_range_config = ieee80211_set_sta_mon_rssi_range_cfg,
+	.set_sta_mon_txrate_config = ieee80211_set_sta_mon_txrate_config,
 };
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 05d68f8..a71f50c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -497,6 +497,10 @@ struct ieee80211_sta_rx_stats {
  * @count_rx_signal: Number of data frames used in averaging station signal.
  *	This can be used to avoid generating less reliable station rssi cross
  *	events that would be based only on couple of received frames
+ * @txrate_low: TXRATE lower threshold for a station to monitor, this will be
+ *	in 100Kbps
+ * @txrate_high: TXRATE upper threshold for a station to monitor, this will be
+ *	in 100Kbps
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -605,6 +609,9 @@ struct sta_info {
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
