Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57974 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030464Ab2CORji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 13:39:38 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
Date: Thu, 15 Mar 2012 10:39:19 -0700
Message-Id: <1331833159-12694-2-git-send-email-greearb@candelatech.com> (sfid-20120315_183942_222982_FD61EFBD)
In-Reply-To: <1331833159-12694-1-git-send-email-greearb@candelatech.com>
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets ethtool print out stats related to station
interfaces.  Does not yet get stats from the underlying
driver.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 cf5b08a... 2acd0ea... M	net/mac80211/cfg.c
 net/mac80211/cfg.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cf5b08a..2acd0ea 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -112,6 +112,72 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
 	return 0;
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
+	switch (sset) {
+	case ETH_SS_STATS:
+		return STA_STATS_LEN;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void ieee80211_get_et_stats(struct wiphy *wiphy,
+				   struct net_device *dev,
+				   struct ethtool_stats *stats,
+				   u64 *data)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+
+	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
+
+	mutex_lock(&sdata->local->sta_mtx);
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		int i = 0;
+		data[i++] += sta->rx_packets;
+		data[i++] += sta->rx_bytes;
+		data[i++] += sta->wep_weak_iv_count;
+		data[i++] += sta->num_duplicates;
+		data[i++] += sta->rx_fragments;
+		data[i++] += sta->rx_dropped;
+
+		data[i++] += sta->tx_packets;
+		data[i++] += sta->tx_bytes;
+		data[i++] += sta->tx_fragments;
+		data[i++] += sta->tx_filtered_count;
+		data[i++] += sta->tx_retry_failed;
+		data[i++] += sta->tx_retry_count;
+		data[i++] += sta->beacon_loss_count;
+		BUG_ON(i != STA_STATS_LEN);
+	}
+	mutex_unlock(&sdata->local->sta_mtx);
+}
+
+static void ieee80211_get_et_strings(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     u32 sset, u8 *data)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		memcpy(data, *ieee80211_gstrings_sta_stats,
+		       sizeof(ieee80211_gstrings_sta_stats));
+		break;
+	}
+}
+
+
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr,
 			     struct key_params *params)
@@ -2768,4 +2834,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.probe_client = ieee80211_probe_client,
 	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
+	.get_et_sset_count = ieee80211_get_et_sset_count,
+	.get_et_stats = ieee80211_get_et_stats,
+	.get_et_strings = ieee80211_get_et_strings,
 };
-- 
1.7.3.4

