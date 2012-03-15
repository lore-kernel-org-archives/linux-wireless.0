Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40183 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161218Ab2COXUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 19:20:19 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/4] mac80211:  Framework to get wifi-driver stats via ethtool.
Date: Thu, 15 Mar 2012 16:20:05 -0700
Message-Id: <1331853606-28434-3-git-send-email-greearb@candelatech.com> (sfid-20120316_002024_641881_9A17A76F)
In-Reply-To: <1331853606-28434-1-git-send-email-greearb@candelatech.com>
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This adds hooks to call into the driver to get additional
stats for the ethtool API.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 d49928b... e89a742... M	include/net/mac80211.h
:100644 100644 0aef0d2... 872e06e... M	net/mac80211/cfg.c
 include/net/mac80211.h |    9 +++++++++
 net/mac80211/cfg.c     |   23 +++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d49928b..e89a742 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2236,6 +2236,15 @@ struct ieee80211_ops {
 					u16 tids, int num_frames,
 					enum ieee80211_frame_release_type reason,
 					bool more_data);
+
+	int	(*get_et_sset_count)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif, int sset);
+	void	(*get_et_stats)(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ethtool_stats *stats, u64 *data);
+	void	(*get_et_strings)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  u32 sset, u8 *data);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0aef0d2..872e06e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -125,8 +125,17 @@ static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       int sset)
 {
-	if (sset == ETH_SS_STATS)
-		return STA_STATS_LEN;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	if (sset == ETH_SS_STATS) {
+		int rv = STA_STATS_LEN;
+		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+		local = sdata->local;
+		if (local->ops->get_et_sset_count)
+			rv += local->ops->get_et_sset_count(&local->hw,
+							    &sdata->vif, sset);
+		return rv;
+	}
 	
 	return -EOPNOTSUPP;
 }
@@ -167,15 +176,25 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 		BUG_ON(i != STA_STATS_LEN);
 	}
 	rcu_read_unlock();
+
+	if (local->ops->get_et_stats)
+		local->ops->get_et_stats(&local->hw, &sdata->vif,
+					 stats, &(data[STA_STATS_LEN]));
 }
 
 static void ieee80211_get_et_strings(struct wiphy *wiphy,
 				     struct net_device *dev,
 				     u32 sset, u8 *data)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	if (sset == ETH_SS_STATS) {
 		int sz_sta_stats = sizeof(ieee80211_gstrings_sta_stats);
 		memcpy(data, *ieee80211_gstrings_sta_stats, sz_sta_stats);
+
+		if (local->ops->get_et_strings)
+			local->ops->get_et_strings(&local->hw, &sdata->vif,
+						   sset, &(data[sz_sta_stats]));
 	}
 }
 
-- 
1.7.3.4

