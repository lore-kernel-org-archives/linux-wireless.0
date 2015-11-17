Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbbKQIYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:45 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/8] cfg80211: Add missing tracing to cfg80211
Date: Tue, 17 Nov 2015 10:24:33 +0200
Message-Id: <1447748680-23075-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092456_271749_F54DEF7A)
In-Reply-To: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Add missing tracing for:

1. start_radar_detection()
2. set_mcast_rates()
3. set_coalesce()

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/nl80211.c  |  9 ++++----
 net/wireless/rdev-ops.h | 43 ++++++++++++++++++++++++++++++++++
 net/wireless/trace.h    | 61 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c71e274..41e57d0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6507,8 +6507,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (WARN_ON(!cac_time_ms))
 		cac_time_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
 
-	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef,
-					       cac_time_ms);
+	err = rdev_start_radar_detection(rdev, dev, &chandef, cac_time_ms);
 	if (!err) {
 		wdev->chandef = chandef;
 		wdev->cac_started = true;
@@ -7571,7 +7570,7 @@ static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
 	if (!nl80211_parse_mcast_rate(rdev, mcast_rate, nla_rate))
 		return -EINVAL;
 
-	err = rdev->ops->set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
+	err = rdev_set_mcast_rate(rdev, dev, mcast_rate);
 
 	return err;
 }
@@ -9716,7 +9715,7 @@ static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 
 	if (!info->attrs[NL80211_ATTR_COALESCE_RULE]) {
 		cfg80211_rdev_free_coalesce(rdev);
-		rdev->ops->set_coalesce(&rdev->wiphy, NULL);
+		rdev_set_coalesce(rdev, NULL);
 		return 0;
 	}
 
@@ -9744,7 +9743,7 @@ static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 		i++;
 	}
 
-	err = rdev->ops->set_coalesce(&rdev->wiphy, &new_coalesce);
+	err = rdev_set_coalesce(rdev, &new_coalesce);
 	if (err)
 		goto error;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index c23516d..b8cc594 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1020,4 +1020,47 @@ rdev_tdls_cancel_channel_switch(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_start_radar_detection(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev,
+			   struct cfg80211_chan_def *chandef,
+			   u32 cac_time_ms)
+{
+	int ret = -ENOTSUPP;
+
+	trace_rdev_start_radar_detection(&rdev->wiphy, dev, chandef,
+					 cac_time_ms);
+	if (rdev->ops->start_radar_detection)
+		ret = rdev->ops->start_radar_detection(&rdev->wiphy, dev,
+						       chandef, cac_time_ms);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
+rdev_set_mcast_rate(struct cfg80211_registered_device *rdev,
+		    struct net_device *dev,
+		    int mcast_rate[IEEE80211_NUM_BANDS])
+{
+	int ret = -ENOTSUPP;
+
+	trace_rdev_set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
+	if (rdev->ops->set_mcast_rate)
+		ret = rdev->ops->set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
+rdev_set_coalesce(struct cfg80211_registered_device *rdev,
+		  struct cfg80211_coalesce *coalesce)
+{
+	int ret = -ENOTSUPP;
+
+	trace_rdev_set_coalesce(&rdev->wiphy, coalesce);
+	if (rdev->ops->set_coalesce)
+		ret = rdev->ops->set_coalesce(&rdev->wiphy, coalesce);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0c392d3..62d9b96 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2818,6 +2818,67 @@ TRACE_EVENT(cfg80211_stop_iface,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
 
+TRACE_EVENT(rdev_start_radar_detection,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_chan_def *chandef,
+		 u32 cac_time_ms),
+	TP_ARGS(wiphy, netdev, chandef, cac_time_ms),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+		__field(u32, cac_time_ms)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+		__entry->cac_time_ms = cac_time_ms;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT
+		  ", cac_time_ms=%u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG,
+		  __entry->cac_time_ms)
+);
+
+TRACE_EVENT(rdev_set_mcast_rate,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 int mcast_rate[IEEE80211_NUM_BANDS]),
+	TP_ARGS(wiphy, netdev, mcast_rate),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__array(int, mcast_rate, IEEE80211_NUM_BANDS)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		memcpy(__entry->mcast_rate, mcast_rate,
+		       sizeof(int) * IEEE80211_NUM_BANDS);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", "
+		  "mcast_rates [2.4GHz=0x%x, 5.2GHz=0x%x, 60GHz=0x%x]",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  __entry->mcast_rate[IEEE80211_BAND_2GHZ],
+		  __entry->mcast_rate[IEEE80211_BAND_5GHZ],
+		  __entry->mcast_rate[IEEE80211_BAND_60GHZ])
+);
+
+TRACE_EVENT(rdev_set_coalesce,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_coalesce *coalesce),
+	TP_ARGS(wiphy, coalesce),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, n_rules)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->n_rules = coalesce ? coalesce->n_rules : 0;
+	),
+	TP_printk(WIPHY_PR_FMT ", n_rules=%d",
+		  WIPHY_PR_ARG, __entry->n_rules)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.5.0

