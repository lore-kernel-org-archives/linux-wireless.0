Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54206 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751629AbeBYHuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 02:50:07 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv4 3/3] mac80211: implement cqm rssi check using rx data signal
Date: Sun, 25 Feb 2018 13:19:58 +0530
Message-Id: <1519544998-2621-4-git-send-email-tamizhr@codeaurora.org> (sfid-20180225_085019_022021_682626EC)
In-Reply-To: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org>
References: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

Triggers cfg80211_ap_sta_cqm_rssi_notify with the corresponding event
when station signal goes lower than the configured rssi threshold. And
notify back to user space once the station signal becomes greater than
the configured value. It uses rx data signal and compare with rssi value
given by user. This rssi threshold is bss specific and it is common for
all the stations.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h  |    7 +++++++
 net/mac80211/rx.c       |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |    9 +++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dc3e9d9..e973bcd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -800,6 +800,13 @@ enum mac80211_rate_control_flags {
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
index 2783c5c..611dea5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1536,6 +1536,47 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	return RX_CONTINUE;
 }
 
+static void ieee80211_sta_rx_signal_thold_check(struct ieee80211_rx_data *rx)
+{
+	struct sta_info *sta = rx->sta;
+	struct ieee80211_bss_conf *bss_conf =
+		&rx->sdata->vif.bss_conf;
+	int sig, last_event, thold;
+
+	if (!wiphy_ext_feature_isset(rx->local->hw.wiphy,
+				NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG))
+		return;
+
+	sta->count_rx_signal++;
+	if (sta->count_rx_signal < IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
+		return;
+
+	if (!bss_conf->cqm_rssi_thold || !bss_conf->enable_beacon) {
+		sta->count_rx_signal = 0;
+		return;
+	}
+
+	sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
+	last_event = sta->last_cqm_event_signal;
+	thold = bss_conf->cqm_rssi_thold;
+
+	if (sig < thold && last_event == 0) {
+		sta->last_cqm_event_signal = sig;
+		cfg80211_ap_sta_cqm_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_ATOMIC);
+		sta->count_rx_signal = 0;
+	} else if (last_event && sig > thold) {
+		sta->last_cqm_event_signal = 0;
+		cfg80211_ap_sta_cqm_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+				sig, GFP_ATOMIC);
+		sta->count_rx_signal = 0;
+	}
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
@@ -1591,6 +1632,7 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->rx_stats.last_signal = status->signal;
 		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
+		ieee80211_sta_rx_signal_thold_check(rx);
 	}
 
 	if (status->chains) {
@@ -4000,9 +4042,11 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 
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
index f64eb86..2127803 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -481,6 +481,12 @@ struct ieee80211_sta_rx_stats {
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
  *	this (by advertising the USES_RSS hw flag)
  * @status_stats: TX status statistics
+ * @last_cqm_event_signal: Last data frame signal strength average that
+ *	triggered a cqm event for a connected station. 0 indicates that no
+ *	event has been generated for the station.
+ * @count_rx_signal: Number of data frames used in avg signal for a station.
+ *	This can be used to avoid generating less reliable cqm events for
+ *	the station.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -581,6 +587,9 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	int last_cqm_event_signal;
+	unsigned int count_rx_signal;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
-- 
1.7.9.5
