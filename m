Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37022 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752490AbeDSSR6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 14:17:58 -0400
From: greearb@candelatech.com
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/3] mac80211:  Add support for ethtool gstats2 API.
Date: Thu, 19 Apr 2018 11:17:42 -0700
Message-Id: <1524161863-30860-2-git-send-email-greearb@candelatech.com> (sfid-20180419_201807_521075_A0144114)
In-Reply-To: <1524161863-30860-1-git-send-email-greearb@candelatech.com>
References: <1524161863-30860-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This enables users to request fewer stats to be refreshed
in cases where firmware does not need to be probed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  No changes.

 include/net/mac80211.h    |  6 ++++++
 net/mac80211/driver-ops.h |  9 +++++++--
 net/mac80211/ethtool.c    | 18 +++++++++++++-----
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d2279b2..4854f33 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3361,6 +3361,8 @@ enum ieee80211_reconfig_type {
  *
  * @get_et_stats:  Ethtool API to get a set of u64 stats.
  *
+ * @get_et_stats2:  Ethtool API to get a set of u64 stats, with flags.
+ *
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
@@ -3692,6 +3694,10 @@ struct ieee80211_ops {
 	void	(*get_et_stats)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ethtool_stats *stats, u64 *data);
+	void	(*get_et_stats2)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ethtool_stats *stats, u64 *data,
+				 u32 flags);
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4d82fe7..519d2db 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -58,10 +58,15 @@ static inline void drv_get_et_strings(struct ieee80211_sub_if_data *sdata,
 
 static inline void drv_get_et_stats(struct ieee80211_sub_if_data *sdata,
 				    struct ethtool_stats *stats,
-				    u64 *data)
+				    u64 *data, u32 flags)
 {
 	struct ieee80211_local *local = sdata->local;
-	if (local->ops->get_et_stats) {
+	if (local->ops->get_et_stats2) {
+		trace_drv_get_et_stats(local);
+		local->ops->get_et_stats2(&local->hw, &sdata->vif, stats, data,
+					  flags);
+		trace_drv_return_void(local);
+	} else if (local->ops->get_et_stats) {
 		trace_drv_get_et_stats(local);
 		local->ops->get_et_stats(&local->hw, &sdata->vif, stats, data);
 		trace_drv_return_void(local);
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 9cc986d..b67520e 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -61,9 +61,9 @@ static int ieee80211_get_sset_count(struct net_device *dev, int sset)
 	return rv;
 }
 
-static void ieee80211_get_stats(struct net_device *dev,
-				struct ethtool_stats *stats,
-				u64 *data)
+static void ieee80211_get_stats2(struct net_device *dev,
+				 struct ethtool_stats *stats,
+				 u64 *data, u32 flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -199,7 +199,14 @@ static void ieee80211_get_stats(struct net_device *dev,
 	if (WARN_ON(i != STA_STATS_LEN))
 		return;
 
-	drv_get_et_stats(sdata, stats, &(data[STA_STATS_LEN]));
+	drv_get_et_stats(sdata, stats, &data[STA_STATS_LEN], flags);
+}
+
+static void ieee80211_get_stats(struct net_device *dev,
+				struct ethtool_stats *stats,
+				u64 *data)
+{
+	ieee80211_get_stats2(dev, stats, data, 0);
 }
 
 static void ieee80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
@@ -211,7 +218,7 @@ static void ieee80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
 		sz_sta_stats = sizeof(ieee80211_gstrings_sta_stats);
 		memcpy(data, ieee80211_gstrings_sta_stats, sz_sta_stats);
 	}
-	drv_get_et_strings(sdata, sset, &(data[sz_sta_stats]));
+	drv_get_et_strings(sdata, sset, &data[sz_sta_stats]);
 }
 
 static int ieee80211_get_regs_len(struct net_device *dev)
@@ -238,5 +245,6 @@ const struct ethtool_ops ieee80211_ethtool_ops = {
 	.set_ringparam = ieee80211_set_ringparam,
 	.get_strings = ieee80211_get_strings,
 	.get_ethtool_stats = ieee80211_get_stats,
+	.get_ethtool_stats2 = ieee80211_get_stats2,
 	.get_sset_count = ieee80211_get_sset_count,
 };
-- 
2.4.11
