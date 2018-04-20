Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36148 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753708AbeDTGym (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 02:54:42 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFC 6/6] mac80211: Implement cqm txrate range check for a station
Date: Fri, 20 Apr 2018 12:22:51 +0530
Message-Id: <1524207171-3325-7-git-send-email-tamizhr@codeaurora.org> (sfid-20180420_085447_294718_795F72F7)
In-Reply-To: <1524207171-3325-1-git-send-email-tamizhr@codeaurora.org>
References: <1524207171-3325-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch trigger cfg80211_sta_mon_txrate_notify with
the corresponding txrate event when the txrate for a station goes
out of configured range.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h  |  5 +++++
 net/mac80211/sta_info.h |  5 +++++
 net/mac80211/status.c   | 40 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7b3d505..7023f40 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -809,6 +809,11 @@ enum mac80211_rate_control_flags {
  */
 #define IEEE80211_STA_SIGNAL_AVE_MIN_COUNT	4
 
+/* Number of txrate count need to have been used in average station's
+ * txrate before checking against the threshold
+ */
+#define IEEE80211_STA_TXRATE_AVE_MIN_COUNT	4
+
 
 /* there are 40 bytes if you don't need the rateset to be kept */
 #define IEEE80211_TX_INFO_DRIVER_DATA_SIZE 40
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 14431c7..271267d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -418,6 +418,8 @@ struct ieee80211_sta_rx_stats {
  */
 #define STA_SLOW_THRESHOLD 6000 /* 6 Mbps */
 
+DECLARE_EWMA(sta_txrate, 4, 4)
+
 /**
  * struct sta_info - STA information
  *
@@ -608,6 +610,9 @@ struct sta_info {
 	u32 txrate_low;
 	u32 txrate_high;
 
+	unsigned int count_sta_txrate;
+	enum nl80211_sta_mon_txrate_threshold_event last_txrate_event;
+	struct ewma_sta_txrate ave_sta_txrate;
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 743e89c..6656b04 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -699,6 +699,40 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
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
@@ -748,9 +782,13 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 
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
1.9.1
