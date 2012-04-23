Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53515 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2DWTvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 15:51:31 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v4 4/4] mac80211: Add more ethtools stats: survey, rates, etc
Date: Mon, 23 Apr 2012 12:50:32 -0700
Message-Id: <1335210632-19958-5-git-send-email-greearb@candelatech.com> (sfid-20120423_215134_453631_F9D6227D)
In-Reply-To: <1335210632-19958-1-git-send-email-greearb@candelatech.com>
References: <1335210632-19958-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The signal and noise are forced to be positive since ethtool
deals in unsigned 64-bit values and this number should be human
readable.  This gives easy access to some of the data formerly
exposed in the deprecated /proc/net/wireless file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v4:  Don't assign station rates, state, or signal avg unless
     netdev is in managed mode.

:100644 100644 6952ff9... 06518f5... M	net/mac80211/cfg.c
 net/mac80211/cfg.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6952ff9..06518f5 100644
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
 
@@ -484,7 +486,10 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
 	struct ieee80211_local *local = sdata->local;
-	int i;
+	struct station_info sinfo;
+	struct survey_info survey;
+	int i, q;
+#define STA_STATS_SURVEY_LEN 7
 
 	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
 
@@ -516,11 +521,30 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
-		if (sta && !WARN_ON(sta->sdata->dev != dev)) {
-			i = 0;
-			ADD_STA_STATS(sta);
-			BUG_ON(i != STA_STATS_LEN);
-		}
+
+		if (!(sta && !WARN_ON(sta->sdata->dev != dev)))
+			goto do_survey;
+
+		i = 0;
+		ADD_STA_STATS(sta);
+
+		data[i++] = sta->sta_state;
+
+		sinfo.filled = 0;
+		sta_set_sinfo(sta, &sinfo);
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
 	} else {
 		list_for_each_entry_rcu(sta, &local->sta_list, list) {
 			/* Make sure this station belongs to the proper dev */
@@ -529,12 +553,61 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 
 			i = 0;
 			ADD_STA_STATS(sta);
-			BUG_ON(i != STA_STATS_LEN);
 		}
 	}
 
+do_survey:
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

