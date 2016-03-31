Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbcCaRES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/10] mac80211: move averaged values out of rx_stats
Date: Thu, 31 Mar 2016 20:02:05 +0300
Message-Id: <1459443731-4614-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190421_656039_931842E9)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the averaged values out of rx_stats and into rx_stats_avg,
to cleanly split them out. The averaged ones cannot be supported
for parallel RX in a per-CPU fashion, while the other values can
be collected per CPU and then combined/selected when needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_plink.c |  2 +-
 net/mac80211/rx.c         |  4 ++--
 net/mac80211/sta_info.c   | 10 +++++-----
 net/mac80211/sta_info.h   |  6 ++++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a07e93c..a261fdf 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -61,7 +61,7 @@ static bool rssi_threshold_check(struct ieee80211_sub_if_data *sdata,
 	s32 rssi_threshold = sdata->u.mesh.mshcfg.rssi_threshold;
 	return rssi_threshold == 0 ||
 	       (sta &&
-		(s8)-ewma_signal_read(&sta->rx_stats.avg_signal) >
+		(s8)-ewma_signal_read(&sta->rx_stats_avg.signal) >
 						rssi_threshold);
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1df3a3e..4ae3bf8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1455,7 +1455,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	sta->rx_stats.bytes += rx->skb->len;
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->rx_stats.last_signal = status->signal;
-		ewma_signal_add(&sta->rx_stats.avg_signal, -status->signal);
+		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
 	}
 
 	if (status->chains) {
@@ -1467,7 +1467,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 				continue;
 
 			sta->rx_stats.chain_signal_last[i] = signal;
-			ewma_signal_add(&sta->rx_stats.chain_signal_avg[i],
+			ewma_signal_add(&sta->rx_stats_avg.chain_signal[i],
 					-signal);
 		}
 	}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 01e070c..4f19505 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -341,9 +341,9 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->reserved_tid = IEEE80211_TID_UNRESERVED;
 
 	sta->last_connected = ktime_get_seconds();
-	ewma_signal_init(&sta->rx_stats.avg_signal);
-	for (i = 0; i < ARRAY_SIZE(sta->rx_stats.chain_signal_avg); i++)
-		ewma_signal_init(&sta->rx_stats.chain_signal_avg[i]);
+	ewma_signal_init(&sta->rx_stats_avg.signal);
+	for (i = 0; i < ARRAY_SIZE(sta->rx_stats_avg.chain_signal); i++)
+		ewma_signal_init(&sta->rx_stats_avg.chain_signal[i]);
 
 	if (local->ops->wake_tx_queue) {
 		void *txq_data;
@@ -2056,7 +2056,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
 			sinfo->signal_avg =
-				-ewma_signal_read(&sta->rx_stats.avg_signal);
+				-ewma_signal_read(&sta->rx_stats_avg.signal);
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
 		}
 	}
@@ -2072,7 +2072,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			sinfo->chain_signal[i] =
 				sta->rx_stats.chain_signal_last[i];
 			sinfo->chain_signal_avg[i] =
-				-ewma_signal_read(&sta->rx_stats.chain_signal_avg[i]);
+				-ewma_signal_read(&sta->rx_stats_avg.chain_signal[i]);
 		}
 	}
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index fc91290..67a604c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -450,16 +450,18 @@ struct sta_info {
 		unsigned long fragments;
 		unsigned long dropped;
 		int last_signal;
-		struct ewma_signal avg_signal;
 		u8 chains;
 		s8 chain_signal_last[IEEE80211_MAX_CHAINS];
-		struct ewma_signal chain_signal_avg[IEEE80211_MAX_CHAINS];
 		int last_rate_idx;
 		u32 last_rate_flag;
 		u32 last_rate_vht_flag;
 		u8 last_rate_vht_nss;
 		u64 msdu[IEEE80211_NUM_TIDS + 1];
 	} rx_stats;
+	struct {
+		struct ewma_signal signal;
+		struct ewma_signal chain_signal[IEEE80211_MAX_CHAINS];
+	} rx_stats_avg;
 
 	/* Plus 1 for non-QoS frames */
 	__le16 last_seq_ctrl[IEEE80211_NUM_TIDS + 1];
-- 
2.5.0

