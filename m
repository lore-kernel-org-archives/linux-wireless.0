Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab2GML6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 07:58:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] cfg80211/mac80211: re-add get_channel operation
Date: Fri, 13 Jul 2012 13:58:49 +0200
Message-Id: <1342180730-19987-3-git-send-email-johannes@sipsolutions.net> (sfid-20120713_135858_981861_09E8BDA9)
In-Reply-To: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
References: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This essentially reverts commit 2e165b818456 but
introduces the get_channel operation with a new
wireless_dev argument so that you can retrieve
the channel per interface. This is necessary as
even though we can track all interface channels
(except monitor) we can't track the channel type
used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |    9 +++++++++
 net/mac80211/cfg.c         |   11 +++++++++++
 net/wireless/nl80211.c     |   16 +++++++++++-----
 net/wireless/wext-compat.c |    9 +++++++--
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5a67165..8115d68 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1612,6 +1612,10 @@ struct cfg80211_gtk_rekey_data {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *	See @ethtool_ops.get_strings
+ *
+ * @get_channel: Get the current operating channel for the virtual interface.
+ *	For monitor interfaces, it should return %NULL unless there's a single
+ *	current monitoring channel.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1821,6 +1825,11 @@ struct cfg80211_ops {
 				  u32 sset, u8 *data);
 
 	void (*set_monitor_enabled)(struct wiphy *wiphy, bool enabled);
+
+	struct ieee80211_channel *
+		(*get_channel)(struct wiphy *wiphy,
+			       struct wireless_dev *wdev,
+			       enum nl80211_channel_type *type);
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e95f24e..10dd963 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2982,6 +2982,16 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static struct ieee80211_channel *
+ieee80211_cfg_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
+			  enum nl80211_channel_type *type)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	*type = local->_oper_channel_type;
+	return local->oper_channel;
+}
+
 #ifdef CONFIG_PM
 static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 {
@@ -3062,4 +3072,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_sset_count = ieee80211_get_et_sset_count,
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
+	.get_channel = ieee80211_cfg_get_channel,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 079fc49..6b001e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1759,11 +1759,17 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			(cfg80211_rdev_list_generation << 2)))
 		goto nla_put_failure;
 
-	if (rdev->monitor_channel) {
-		if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
-				rdev->monitor_channel->center_freq) ||
-		    nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
-				rdev->monitor_channel_type))
+	if (rdev->ops->get_channel) {
+		struct ieee80211_channel *chan;
+		enum nl80211_channel_type channel_type;
+
+		chan = rdev->ops->get_channel(&rdev->wiphy, wdev,
+					      &channel_type);
+		if (chan &&
+		    (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
+				 chan->center_freq) ||
+		     nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				 channel_type)))
 			goto nla_put_failure;
 	}
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7df42f5..494379e 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -827,6 +827,8 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct ieee80211_channel *chan;
+	enum nl80211_channel_type channel_type;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -834,10 +836,13 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
 	case NL80211_IFTYPE_MONITOR:
-		if (!rdev->monitor_channel)
+		if (!rdev->ops->get_channel)
 			return -EINVAL;
 
-		freq->m = rdev->monitor_channel->center_freq;
+		chan = rdev->ops->get_channel(wdev->wiphy, wdev, &channel_type);
+		if (!chan)
+			return -EINVAL;
+		freq->m = chan->center_freq;
 		freq->e = 6;
 		return 0;
 	default:
-- 
1.7.10.4

