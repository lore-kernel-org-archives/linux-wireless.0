Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbcCaREV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:21 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/10] mac80211: add separate last_ack variable
Date: Thu, 31 Mar 2016 20:02:07 +0300
Message-Id: <1459443731-4614-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190426_743653_C28DCF0F)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of touching the rx_stats.last_rx from the status path, introduce
and use a status_stats.last_ack variable. This will make rx_stats.last_rx
indicate when the last frame was received, making it available for real
"last_rx" and statistics gathering; statistics, when done per-CPU, will
need to figure out which place was updated last for those items where the
"last" value is exposed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c     | 13 ++++++++-----
 net/mac80211/sta_info.c | 13 +++++++++++--
 net/mac80211/sta_info.h |  3 +++
 net/mac80211/status.c   |  4 ++--
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b3407db..4babd8a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -668,10 +668,11 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		unsigned long last_active = ieee80211_sta_last_active(sta);
+
 		if (sta->sdata == sdata &&
-		    time_after(sta->rx_stats.last_rx +
-			       IEEE80211_IBSS_MERGE_INTERVAL,
-			       jiffies)) {
+		    time_is_after_jiffies(last_active +
+					  IEEE80211_IBSS_MERGE_INTERVAL)) {
 			active++;
 			break;
 		}
@@ -1255,11 +1256,13 @@ static void ieee80211_ibss_sta_expire(struct ieee80211_sub_if_data *sdata)
 	mutex_lock(&local->sta_mtx);
 
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
+		unsigned long last_active = ieee80211_sta_last_active(sta);
+
 		if (sdata != sta->sdata)
 			continue;
 
-		if (time_after(jiffies, sta->rx_stats.last_rx + exp_time) ||
-		    (time_after(jiffies, sta->rx_stats.last_rx + exp_rsn) &&
+		if (time_is_after_jiffies(last_active + exp_time) ||
+		    (time_is_after_jiffies(last_active + exp_rsn) &&
 		     sta->sta_state != IEEE80211_STA_AUTHORIZED)) {
 			sta_dbg(sta->sdata, "expiring inactive %sSTA %pM\n",
 				sta->sta_state != IEEE80211_STA_AUTHORIZED ?
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4f19505..b49e2fb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1094,10 +1094,12 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->sta_mtx);
 
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
+		unsigned long last_active = ieee80211_sta_last_active(sta);
+
 		if (sdata != sta->sdata)
 			continue;
 
-		if (time_after(jiffies, sta->rx_stats.last_rx + exp_time)) {
+		if (time_is_after_jiffies(last_active + exp_time)) {
 			sta_dbg(sta->sdata, "expiring inactive STA %pM\n",
 				sta->sta.addr);
 
@@ -2000,7 +2002,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
 	sinfo->inactive_time =
-		jiffies_to_msecs(jiffies - sta->rx_stats.last_rx);
+		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
 
 	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES64) |
 			       BIT(NL80211_STA_INFO_TX_BYTES)))) {
@@ -2186,3 +2188,10 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->expected_throughput = thr;
 	}
 }
+
+unsigned long ieee80211_sta_last_active(struct sta_info *sta)
+{
+	if (time_after(sta->rx_stats.last_rx, sta->status_stats.last_ack))
+		return sta->rx_stats.last_rx;
+	return sta->status_stats.last_ack;
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 67a604c..0ad9a67 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -474,6 +474,7 @@ struct sta_info {
 		unsigned long last_tdls_pkt_time;
 		u64 msdu_retries[IEEE80211_NUM_TIDS + 1];
 		u64 msdu_failed[IEEE80211_NUM_TIDS + 1];
+		unsigned long last_ack;
 	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
@@ -683,4 +684,6 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
+unsigned long ieee80211_sta_last_active(struct sta_info *sta);
+
 #endif /* STA_INFO_H */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 6101deb..93a4608 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -188,7 +188,7 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
-		sta->rx_stats.last_rx = jiffies;
+		sta->status_stats.last_ack = jiffies;
 
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
@@ -647,7 +647,7 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 		sta->status_stats.retry_count += retry_count;
 
 		if (acked) {
-			sta->rx_stats.last_rx = jiffies;
+			sta->status_stats.last_ack = jiffies;
 
 			if (sta->status_stats.lost_packets)
 				sta->status_stats.lost_packets = 0;
-- 
2.5.0

