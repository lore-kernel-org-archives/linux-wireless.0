Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50206 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbbAUQe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 11:34:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, eyalx.shapira@intel.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: support rate-control based TX ratestats
Date: Wed, 21 Jan 2015 17:34:18 +0100
Message-Id: <1421858058-14828-1-git-send-email-johannes@sipsolutions.net> (sfid-20150121_173431_368554_827DDDCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The rate control algorithms typically already capture (some)
rate statistics (minstrel fully, for example) so adding more
to mac80211 isn't very useful.

Add support for the rate control reporting TX ratestats by
simply passing through the start/dump/stop calls to it.

If rate control doesn't have support, then don't allow the
driver to support ratestats. This ensure that full ratestats
support is always there if it is supported at all. If any
driver that doesn't have mac80211-based rate control will
want to support it we'll add the same as a driver operation
and adjust the code accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 20 ++++++++++++++++++++
 net/mac80211/cfg.c     |  6 +++++-
 net/mac80211/main.c    |  7 +++++++
 net/mac80211/rate.c    | 19 +++++++++++++++++++
 net/mac80211/rate.h    |  9 +++++++++
 5 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 275ee56152ad..9ebb27d22ead 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4886,6 +4886,9 @@ struct rate_control_ops {
 	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
 
 	u32 (*get_expected_throughput)(void *priv_sta);
+
+	void (*tx_ratestats)(void *priv, void *priv_sta,
+			     enum cfg80211_ratestats_ops op);
 };
 
 static inline int rate_supported(struct ieee80211_sta *sta,
@@ -4966,6 +4969,23 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 int ieee80211_rate_control_register(const struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(const struct rate_control_ops *ops);
 
+/**
+ * ieee80211_report_ratestats - report (TX) rate statistics for a station
+ * @hw: the hardware pointer
+ * @pubsta: the station
+ * @n_stats: number of statistics entries in array
+ * @stats: statistics array
+ * @gfp: allocation flags
+ *
+ * Note that RX statistics are implemented by mac80211 directly, not by the
+ * rate control algorithm, so this must only be used by the latter to report
+ * TX statistics.
+ */
+void ieee80211_report_ratestats(struct ieee80211_hw *hw,
+				struct ieee80211_sta *pubsta,
+				unsigned int n_stats,
+				struct cfg80211_ratestats *stats, gfp_t gfp);
+
 static inline bool
 conf_is_ht20(struct ieee80211_conf *conf)
 {
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ba191924aa87..730a7aa5e6ab 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3702,8 +3702,10 @@ static void ieee80211_ratestats(struct wiphy *wiphy,
 	switch (op) {
 	case CFG80211_RATESTATS_START:
 		local->ratestats_active = true;
-		list_for_each_entry(sta, &local->sta_list, list)
+		list_for_each_entry(sta, &local->sta_list, list) {
 			ieee80211_sta_start_ratestats(sta);
+			rate_control_tx_ratestats(sta, op);
+		}
 		/* list stays empty */
 		break;
 	case CFG80211_RATESTATS_DUMP:
@@ -3711,6 +3713,7 @@ static void ieee80211_ratestats(struct wiphy *wiphy,
 			stats = ieee80211_sta_reset_ratestats(sta);
 			if (stats)
 				list_add_tail(&stats->list, &list);
+			rate_control_tx_ratestats(sta, op);
 		}
 		break;
 	case CFG80211_RATESTATS_STOP:
@@ -3719,6 +3722,7 @@ static void ieee80211_ratestats(struct wiphy *wiphy,
 			stats = ieee80211_sta_stop_ratestats(sta);
 			if (stats)
 				list_add_tail(&stats->list, &list);
+			rate_control_tx_ratestats(sta, op);
 		}
 		break;
 	}
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 336c72137a0d..2d17acc28b0d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1037,6 +1037,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_rate;
 	}
 
+	if (WARN_ON(wiphy_ext_feature_isset(hw->wiphy,
+					    NL80211_EXT_FEATURE_RATESTATS) &&
+		    (!local->rate_ctrl ||
+		     !local->rate_ctrl->ops->tx_ratestats)))
+		hw->wiphy->ext_features[NL80211_EXT_FEATURE_RATESTATS / 8] &=
+			~BIT(NL80211_EXT_FEATURE_RATESTATS % 8);
+
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
 	    !(hw->flags & IEEE80211_HW_NO_AUTO_VIF)) {
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index d53355b011f5..211058a305cd 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -762,3 +762,22 @@ void rate_control_deinitialize(struct ieee80211_local *local)
 	rate_control_free(ref);
 }
 
+void ieee80211_report_ratestats(struct ieee80211_hw *hw,
+				struct ieee80211_sta *pubsta,
+				unsigned int n_stats,
+				struct cfg80211_ratestats *stats, gfp_t gfp)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	int i;
+
+	for (i = 0; i < n_stats; i++) {
+		struct cfg80211_tid_stats *s = &stats[i].stats;
+
+		if (WARN_ON(s->filled & BIT(NL80211_TID_STATS_RX_MSDU)))
+			s->filled &= ~BIT(NL80211_TID_STATS_RX_MSDU);
+	}
+
+	cfg80211_report_ratestats(hw->wiphy, &sta->sdata->wdev, sta->sta.addr,
+				  n_stats, stats, gfp);
+}
+EXPORT_SYMBOL_GPL(ieee80211_report_ratestats);
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 38652f09feaf..bf26dec6ffa3 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -157,6 +157,15 @@ static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
 #endif
 }
 
+static inline void rate_control_tx_ratestats(struct sta_info *sta,
+					     enum cfg80211_ratestats_ops op)
+{
+	struct rate_control_ref *ref = sta->rate_ctrl;
+
+	if (ref && ref->ops->tx_ratestats)
+		ref->ops->tx_ratestats(ref->priv, sta->rate_ctrl_priv, op);
+}
+
 /* Get a reference to the rate control algorithm. If `name' is NULL, get the
  * first available algorithm. */
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
-- 
2.1.4

