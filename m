Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236Ab2GLUfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 16:35:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com, mohammed@qca.qualcomm.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] Revert "cfg80211/mac80211: remove .get_channel"
Date: Thu, 12 Jul 2012 22:35:39 +0200
Message-Id: <1342125340-6468-3-git-send-email-johannes@sipsolutions.net> (sfid-20120712_223557_064302_22677AA2)
In-Reply-To: <1342125340-6468-1-git-send-email-johannes@sipsolutions.net>
References: <1342125340-6468-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit 2e165b818456ecc1024dd0387eeac64745526377.

Since we're going to have to revert the monitor
interface tracking in cfg80211, we won't have
the ability to track the channel either so we
do need the get_channel callback.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |    6 ++++++
 net/mac80211/cfg.c         |   11 +++++++++++
 net/wireless/nl80211.c     |   15 ++++++++++-----
 net/wireless/wext-compat.c |    9 +++++++--
 4 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5a67165..e0968d5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1506,6 +1506,9 @@ struct cfg80211_gtk_rekey_data {
  *	be stored for when a monitor interface becomes active.
  * @set_monitor_enabled: Notify driver that there are only monitor
  *	interfaces running.
+ * @get_channel: Get the current operating channel, should return %NULL if
+ *	there's no single defined operating channel if for example the
+ *	device implements channel hopping for multi-channel virtual interfaces.
  *
  * @scan: Request to do a scan. If returning zero, the scan request is given
  *	the driver, and will be valid until passed to cfg80211_scan_done().
@@ -1813,6 +1816,9 @@ struct cfg80211_ops {
 				  struct net_device *dev,
 				  u16 noack_map);
 
+	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
+						 enum nl80211_channel_type *type);
+
 	int	(*get_et_sset_count)(struct wiphy *wiphy,
 				     struct net_device *dev, int sset);
 	void	(*get_et_stats)(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e95f24e..1e27017 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2982,6 +2982,16 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static struct ieee80211_channel *
+ieee80211_wiphy_get_channel(struct wiphy *wiphy,
+			    enum nl80211_channel_type *type)
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
@@ -3055,6 +3065,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.tdls_oper = ieee80211_tdls_oper,
 	.tdls_mgmt = ieee80211_tdls_mgmt,
 	.probe_client = ieee80211_probe_client,
+	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
 #ifdef CONFIG_PM
 	.set_wakeup = ieee80211_set_wakeup,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 079fc49..54726a6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1759,11 +1759,16 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
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
+		chan = rdev->ops->get_channel(&rdev->wiphy, &channel_type);
+		if (chan &&
+		    (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
+				 chan->center_freq) ||
+		     nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				 channel_type)))
 			goto nla_put_failure;
 	}
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7df42f5..bc87983 100644
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
+		chan = rdev->ops->get_channel(wdev->wiphy, &channel_type);
+		if (!chan)
+			return -EINVAL;
+		freq->m = chan->center_freq;
 		freq->e = 6;
 		return 0;
 	default:
-- 
1.7.10.4

