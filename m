Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59140 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2DTWy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 18:54:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 4/4] mac80211: Add more ethtools stats: survey, rates, etc
Date: Fri, 20 Apr 2012 15:53:52 -0700
Message-Id: <1334962432-18620-4-git-send-email-greearb@candelatech.com> (sfid-20120421_005430_129157_D00F3C21)
In-Reply-To: <1334962432-18620-1-git-send-email-greearb@candelatech.com>
References: <1334962432-18620-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The signal and noise are forced to be positive since ethtool
deals in unsigned 64-bit values and this number should be human
readable.  This gives easy access to some of the data formerly
exposed in the deprecated /proc/net/wireless file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v3:  Get sta-state info in this patch instead a subsequent one.
     Iterate through all surveys until we find one matching
     our frequency.

:100644 100644 6952ff9... 86a5d40... M	net/mac80211/cfg.c
 net/mac80211/cfg.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6952ff9..86a5d40 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -455,7 +455,9 @@ static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
 	"rx_duplicates", "rx_fragments", "rx_dropped",
 	"tx_packets", "tx_bytes", "tx_fragments",
 	"tx_filtered", "tx_retry_failed", "tx_retries",
-	"beacon_loss"
+	"beacon_loss", "sta_state", "txrate", "rxrate", "signal",
+	"channel", "noise", "ch_time", "ch_time_busy",
+	"ch_time_ext_busy", "ch_time_rx", "ch_time_tx"
 };
 #define STA_STATS_LEN	ARRAY_SIZE(ieee80211_gstrings_sta_stats)
 
@@ -483,8 +485,12 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
+	struct sta_info *last_sta = NULL;
 	struct ieee80211_local *local = sdata->local;
-	int i;
+	struct station_info sinfo;
+	struct survey_info survey;
+	int i, q;
+#define STA_STATS_SURVEY_LEN 7
 
 	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
 
@@ -519,7 +525,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 		if (sta && !WARN_ON(sta->sdata->dev != dev)) {
 			i = 0;
 			ADD_STA_STATS(sta);
-			BUG_ON(i != STA_STATS_LEN);
+			last_sta = sta;
 		}
 	} else {
 		list_for_each_entry_rcu(sta, &local->sta_list, list) {
@@ -529,12 +535,81 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 
 			i = 0;
 			ADD_STA_STATS(sta);
-			BUG_ON(i != STA_STATS_LEN);
+			last_sta = sta;
 		}
 	}
 
+	if (last_sta) {
+		data[i++] = sta->sta_state;
+
+		sinfo.filled = 0;
+		sta_set_sinfo(last_sta, &sinfo);
+
+		if (sinfo.filled | STATION_INFO_TX_BITRATE)
+			data[i] = 100000 *
+				cfg80211_calculate_bitrate(&sinfo.txrate);
+		i++;
+		if (sinfo.filled | STATION_INFO_RX_BITRATE)
+			data[i] = 100000 *
+				cfg80211_calculate_bitrate(&sinfo.rxrate);
+		i++;
+
+		if (sinfo.filled | STATION_INFO_SIGNAL_AVG)
+			data[i] = (u8)sinfo.signal_avg;
+		i++;
+	}
+
+	i = STA_STATS_LEN - STA_STATS_SURVEY_LEN;
+	/* Get survey stats for current channel */
+	q = 0;
+	while (true) {
+		survey.filled = 0;
+		if (drv_get_survey(local, q, &survey) != 0) {
+			survey.filled = 0;
+			break;
+		}
+
+		if (survey.channel &&
+		    (local->oper_channel->center_freq ==
+		     survey.channel->center_freq))
+			break;
+		q++;
+	}
+
+	if (survey.filled)
+		data[i++] = survey.channel->center_freq;
+	else
+		data[i++] = 0;
+	if (survey.filled & SURVEY_INFO_NOISE_DBM)
+		data[i++] = (u8)survey.noise;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME)
+		data[i++] = survey.channel_time;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_BUSY)
+		data[i++] = survey.channel_time_busy;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_EXT_BUSY)
+		data[i++] = survey.channel_time_ext_busy;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_RX)
+		data[i++] = survey.channel_time_rx;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_TX)
+		data[i++] = survey.channel_time_tx;
+	else
+		data[i++] = -1LL;
+
 	rcu_read_unlock();
 
+	if (WARN_ON(i != STA_STATS_LEN))
+		return;
+
 	drv_get_et_stats(sdata, stats, &(data[STA_STATS_LEN]));
 }
 
-- 
1.7.3.4

