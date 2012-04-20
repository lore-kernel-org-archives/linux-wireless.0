Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59136 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab2DTWyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 18:54:10 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 2/4] mac80211: Support getting sta_info stats via ethtool.
Date: Fri, 20 Apr 2012 15:53:50 -0700
Message-Id: <1334962432-18620-2-git-send-email-greearb@candelatech.com> (sfid-20120421_005415_571826_381C8D56)
In-Reply-To: <1334962432-18620-1-git-send-email-greearb@candelatech.com>
References: <1334962432-18620-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets ethtool print out stats related to stations
connected to the interface.  Does not yet get stats
from the underlying driver.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v3:  Move code so that future patches in this series is smaller.
     For managed mode, do direct lookup of station by bss.
     For other modes, continue to add stats for all stations
      assigned to the netdev.

:100644 100644 510a745... a1d04c8... M	net/mac80211/cfg.c
 net/mac80211/cfg.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 510a745..a1d04c8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -450,6 +450,94 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
 }
 
+static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
+	"rx_packets", "rx_bytes", "wep_weak_iv_count",
+	"rx_duplicates", "rx_fragments", "rx_dropped",
+	"tx_packets", "tx_bytes", "tx_fragments",
+	"tx_filtered", "tx_retry_failed", "tx_retries",
+	"beacon_loss"
+};
+#define STA_STATS_LEN	ARRAY_SIZE(ieee80211_gstrings_sta_stats)
+
+static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return STA_STATS_LEN;
+
+	return -EOPNOTSUPP;
+}
+
+static void ieee80211_get_et_stats(struct wiphy *wiphy,
+				   struct net_device *dev,
+				   struct ethtool_stats *stats,
+				   u64 *data)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+	struct ieee80211_local *local = sdata->local;
+	int i;
+
+	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
+
+#define ADD_STA_STATS(sta)				\
+	do {						\
+		data[i++] += sta->rx_packets;		\
+		data[i++] += sta->rx_bytes;		\
+		data[i++] += sta->wep_weak_iv_count;	\
+		data[i++] += sta->num_duplicates;	\
+		data[i++] += sta->rx_fragments;		\
+		data[i++] += sta->rx_dropped;		\
+							\
+		data[i++] += sta->tx_packets;		\
+		data[i++] += sta->tx_bytes;		\
+		data[i++] += sta->tx_fragments;		\
+		data[i++] += sta->tx_filtered_count;	\
+		data[i++] += sta->tx_retry_failed;	\
+		data[i++] += sta->tx_retry_count;	\
+		data[i++] += sta->beacon_loss_count;	\
+	} while (0)
+
+	/* For Managed stations, find the single station based on BSSID
+	 * and use that.  For interface types, iterate through all available
+	 * stations and add stats for any station that is assigned to this
+	 * network device.
+	 */
+
+	rcu_read_lock();
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
+		if (sta && !WARN_ON(sta->sdata->dev != dev)) {
+			i = 0;
+			ADD_STA_STATS(sta);
+			BUG_ON(i != STA_STATS_LEN);
+		}
+	} else {
+		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+			/* Make sure this station belongs to the proper dev */
+			if (sta->sdata->dev != dev)
+				continue;
+
+			i = 0;
+			ADD_STA_STATS(sta);
+			BUG_ON(i != STA_STATS_LEN);
+		}
+	}
+
+	rcu_read_unlock();
+}
+
+static void ieee80211_get_et_strings(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS) {
+		int sz_sta_stats = sizeof(ieee80211_gstrings_sta_stats);
+		memcpy(data, *ieee80211_gstrings_sta_stats, sz_sta_stats);
+	}
+}
 
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *mac, struct station_info *sinfo)
@@ -2775,4 +2863,7 @@ struct cfg80211_ops mac80211_config_ops = {
 #ifdef CONFIG_PM
 	.set_wakeup = ieee80211_set_wakeup,
 #endif
+	.get_et_sset_count = ieee80211_get_et_sset_count,
+	.get_et_stats = ieee80211_get_et_stats,
+	.get_et_strings = ieee80211_get_et_strings,
 };
-- 
1.7.3.4

