Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755199AbeD0FaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 01:30:23 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv2 3/6] mac80211: Implement functionality to monitor station's rssi threshold cross
Date: Fri, 27 Apr 2018 11:00:33 +0530
Message-Id: <1524807036-28056-4-git-send-email-tamizhr@codeaurora.org> (sfid-20180427_073036_883047_002502EA)
In-Reply-To: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
References: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Triggers cfg80211_sta_mon_rssi_notify with the corresponding event when
station signal goes out of configured threshold. It uses rx data signal
to check against rssi threshold configured by the user.
This event will be useful for the application like steering to take
decision on any station depends on its current capability.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h  |  7 ++++++
 net/mac80211/rx.c       | 65 ++++++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |  4 +++
 3 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d2279b2..7b3d505 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -803,6 +803,13 @@ enum mac80211_rate_control_flags {
 };
 
 
+/*
+ * How many frames need to have been used in average station's
+ * signal strength before checking against the threshold
+ */
+#define IEEE80211_STA_SIGNAL_AVE_MIN_COUNT	4
+
+
 /* there are 40 bytes if you don't need the rateset to be kept */
 #define IEEE80211_TX_INFO_DRIVER_DATA_SIZE 40
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 03102af..d21f5b1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1536,6 +1536,66 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	return RX_CONTINUE;
 }
 
+static void ieee80211_sta_rx_signal_thold_check(struct ieee80211_rx_data *rx)
+{
+	struct sta_info *sta = rx->sta;
+	struct ieee80211_bss_conf *bss_conf = &rx->sdata->vif.bss_conf;
+
+	if (!wiphy_ext_feature_isset(rx->local->hw.wiphy,
+				NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
+		return;
+
+	sta->count_rx_signal++;
+	if (sta->count_rx_signal < IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
+		return;
+
+	if (sta->rssi_thold && bss_conf->enable_beacon) {
+		int last_event = sta->last_sta_mon_event_signal;
+		int thold = sta->rssi_thold;
+		int hyst = sta->rssi_hyst;
+		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
+
+		if (sig < thold &&
+		    (last_event == 0 || sig < last_event - hyst)) {
+			sta->last_sta_mon_event_signal = sig;
+			cfg80211_sta_mon_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_ATOMIC);
+		} else if (sig > thold &&
+			   (last_event == 0 || sig > last_event + hyst)) {
+			sta->last_sta_mon_event_signal = sig;
+			cfg80211_sta_mon_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
+				sig, GFP_ATOMIC);
+		}
+	}
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
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
@@ -1591,6 +1651,7 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->rx_stats.last_signal = status->signal;
 		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
+		ieee80211_sta_rx_signal_thold_check(rx);
 	}
 
 	if (status->chains) {
@@ -4032,9 +4093,11 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	/* statistics part of ieee80211_rx_h_sta_process() */
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		stats->last_signal = status->signal;
-		if (!fast_rx->uses_rss)
+		if (!fast_rx->uses_rss) {
 			ewma_signal_add(&sta->rx_stats_avg.signal,
 					-status->signal);
+			ieee80211_sta_rx_signal_thold_check(rx);
+		}
 	}
 
 	if (status->chains) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 701eb37..1599973 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -493,6 +493,9 @@ struct ieee80211_sta_rx_stats {
  * @last_sta_mon_event_signal: Last signal strength average for a station
  *	that triggered a sta_mon event. 0 indicates that no event has been
  *	generated for the current association
+ * @count_rx_signal: Number of data frames used in averaging station signal.
+ *	This can be used to avoid generating less reliable station rssi cross
+ *	events that would be based only on couple of received frames.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -598,6 +601,7 @@ struct sta_info {
 	s32 rssi_low;
 	s32 rssi_high;
 	int last_sta_mon_event_signal;
+	unsigned int count_rx_signal;
 
 	/* keep last! */
 	struct ieee80211_sta sta;
-- 
1.9.1
