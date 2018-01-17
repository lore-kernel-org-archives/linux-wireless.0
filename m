Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33126 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbeAQHek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 02:34:40 -0500
From: tamizhr@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 4/4] mac80211: implement cqm using rx data signal
Date: Wed, 17 Jan 2018 13:01:16 +0530
Message-Id: <1516174276-16789-5-git-send-email-tamizhr@codeaurora.org> (sfid-20180117_083448_469076_74A29700)
In-Reply-To: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

Triggers ieee80211_cqm_rssi_notify with the corresponding event when
station signal goes lower than the configured rssi threshold. And
notify back to user space once the station signal becomes greater than
the configured value. It uses rx data signal and compare with rssi value
given by user. This rssi threshold is bss specific and it is common for
all the stations.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h  |  7 +++++++
 net/mac80211/rx.c       | 43 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |  3 +++
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d71ac81..1dec4ec 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -799,6 +799,13 @@ enum mac80211_rate_control_flags {
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
index fd58061..e6f728a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1534,6 +1534,39 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	return RX_CONTINUE;
 }
 
+static void ieee80211_sta_rx_signal_thold_check(struct ieee80211_rx_data *rx)
+{
+	struct sta_info *sta = rx->sta;
+	struct ieee80211_bss_conf *bss_conf =
+		&rx->sdata->vif.bss_conf;
+	int sig, last_event, thold;
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
+		ieee80211_cqm_rssi_notify(
+				&rx->sdata->vif, sta->addr,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_ATOMIC);
+		sta->count_rx_signal = 0;
+	} else if (last_event && sig > thold) {
+		sta->last_cqm_event_signal = 0;
+		ieee80211_cqm_rssi_notify(
+				&rx->sdata->vif, sta->addr,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+				sig, GFP_ATOMIC);
+		sta->count_rx_signal = 0;
+	}
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
@@ -1589,6 +1622,9 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->rx_stats.last_signal = status->signal;
 		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
+		sta->count_rx_signal++;
+		if (sta->count_rx_signal >= IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
+			ieee80211_sta_rx_signal_thold_check(rx);
 	}
 
 	if (status->chains) {
@@ -3967,9 +4003,14 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		stats->last_signal = status->signal;
-		if (!fast_rx->uses_rss)
+		if (!fast_rx->uses_rss) {
 			ewma_signal_add(&sta->rx_stats_avg.signal,
 					-status->signal);
+			sta->count_rx_signal++;
+			if (sta->count_rx_signal >=
+			    IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
+				ieee80211_sta_rx_signal_thold_check(rx);
+		}
 	}
 
 	if (status->chains) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index cd53619..76e8877 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -579,6 +579,9 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	int last_cqm_event_signal;
+	unsigned int count_rx_signal;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
-- 
1.9.1
