Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52666 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935275AbeFMK7m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:59:42 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 4/4] mac80211: Implement functionality to monitor txrate cross event for a station
Date: Wed, 13 Jun 2018 16:28:59 +0530
Message-Id: <1528887539-26821-5-git-send-email-tamizhr@codeaurora.org> (sfid-20180613_125954_086065_32E99E5F)
In-Reply-To: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trigger cfg80211_sta_mon_txrate_notify with the corresponding txrate
event when the txrate for a station goes out of configured range.
This event will be useful for the application like steering to take
decision on any station depends on its current capability.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h  |    5 +++++
 net/mac80211/cfg.c      |    1 +
 net/mac80211/sta_info.h |   10 ++++++++++
 net/mac80211/status.c   |   40 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 96fb9a8..02714ea 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -808,6 +808,11 @@ enum mac80211_rate_control_flags {
  */
 #define IEEE80211_STA_SIGNAL_AVE_MIN_COUNT	4
 
+/* Number of txrate count need to have been used in average station's
+ * txrate before checking against the threshold
+ */
+#define IEEE80211_STA_TXRATE_AVE_MIN_COUNT     4
+
 
 /* there are 40 bytes if you don't need the rateset to be kept */
 #define IEEE80211_TX_INFO_DRIVER_DATA_SIZE 40
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 649f5c7..36ec5fb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3904,6 +3904,7 @@ static int ieee80211_set_sta_mon_txrate_config(struct wiphy *wiphy,
 
 	sta->txrate_low = low_txrate_thold;
 	sta->txrate_high = high_txrate_thold;
+	sta->last_txrate_event = 0;
 
 unlock:
 	mutex_unlock(&sdata->local->sta_mtx);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a71f50c..f978e5a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -419,6 +419,8 @@ struct ieee80211_sta_rx_stats {
  */
 #define STA_SLOW_THRESHOLD 6000 /* 6 Mbps */
 
+DECLARE_EWMA(sta_txrate, 4, 4)
+
 /**
  * struct sta_info - STA information
  *
@@ -501,6 +503,11 @@ struct ieee80211_sta_rx_stats {
  *	in 100Kbps
  * @txrate_high: TXRATE upper threshold for a station to monitor, this will be
  *	in 100Kbps
+ * @count_sta_txrate: Number of transmitted data frames used in ave_sta_txrate
+ * @last_txrate_event: Last txrate event that triggered sta_mon event for a
+ *	station
+ * @ave_sta_txrate: Average txrate to check against the txrate_low and
+ *	txrate_high. Values expressed in 100kbps
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -611,6 +618,9 @@ struct sta_info {
 
 	u32 txrate_low;
 	u32 txrate_high;
+	unsigned int count_sta_txrate;
+	enum nl80211_sta_mon_txrate_threshold_event last_txrate_event;
+	struct ewma_sta_txrate ave_sta_txrate;
 
 	/* keep last! */
 	struct ieee80211_sta sta;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9a6d720..112b18d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -701,6 +701,40 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 	dev_kfree_skb(skb);
 }
 
+static void ieee80211_sta_mon_txrate_thold_check(struct sta_info *sta)
+{
+	struct rate_info rinfo;
+	enum nl80211_sta_mon_txrate_threshold_event sta_txrate_event;
+	int txrate;
+
+	if (!sta->txrate_high)
+		return;
+
+	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
+	txrate = cfg80211_calculate_bitrate(&rinfo);
+	ewma_sta_txrate_add(&sta->ave_sta_txrate, txrate);
+	sta->count_sta_txrate++;
+
+	if (sta->count_sta_txrate < IEEE80211_STA_TXRATE_AVE_MIN_COUNT)
+		return;
+
+	txrate = ewma_sta_txrate_read(&sta->ave_sta_txrate);
+
+	if (txrate < sta->txrate_low)
+		sta_txrate_event = NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_LOW;
+	else if (txrate > sta->txrate_high)
+		sta_txrate_event = NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_HIGH;
+	else
+		sta_txrate_event = NL80211_STA_MON_TXRATE_THRESHOLD_IN_RANGE;
+
+	if (sta_txrate_event != sta->last_txrate_event) {
+		cfg80211_sta_mon_txrate_notify(sta->sdata->dev, sta->addr,
+					       sta_txrate_event, txrate,
+					       GFP_ATOMIC);
+		sta->last_txrate_event = sta_txrate_event;
+	}
+}
+
 static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 				  struct ieee80211_tx_status *status)
 {
@@ -750,9 +784,13 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 
 		if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL) &&
 		    (ieee80211_is_data(hdr->frame_control)) &&
-		    (rates_idx != -1))
+		    (rates_idx != -1)) {
 			sta->tx_stats.last_rate =
 				info->status.rates[rates_idx];
+			if (wiphy_ext_feature_isset(hw->wiphy,
+				NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG))
+				ieee80211_sta_mon_txrate_thold_check(sta);
+		}
 
 		if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
 		    (ieee80211_is_data_qos(fc))) {
-- 
1.7.9.5
