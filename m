Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:57919 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab2F1KH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 06:07:28 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 11/13] cfg80211/mac80211: remove .get_channel
Date: Thu, 28 Jun 2012 12:07:03 +0200
Message-ID: <1340878025-2695-12-git-send-email-michal.kazior@tieto.com> (sfid-20120628_120733_973834_068FC742)
In-Reply-To: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com>
References: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not need it anymore since cfg80211 tracks
monitor channel and monitor channel type.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h     |    6 ------
 net/mac80211/cfg.c         |   11 -----------
 net/wireless/nl80211.c     |   15 +++++----------
 net/wireless/wext-compat.c |    9 ++-------
 4 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 120eae0..7672552 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1430,9 +1430,6 @@ struct cfg80211_gtk_rekey_data {
  *	be stored for when a monitor interface becomes active.
  * @set_monitor_enabled: Notify driver that there are only monitor
  *	interfaces running.
- * @get_channel: Get the current operating channel, should return %NULL if
- *	there's no single defined operating channel if for example the
- *	device implements channel hopping for multi-channel virtual interfaces.
  *
  * @scan: Request to do a scan. If returning zero, the scan request is given
  *	the driver, and will be valid until passed to cfg80211_scan_done().
@@ -1739,9 +1736,6 @@ struct cfg80211_ops {
 				  struct net_device *dev,
 				  u16 noack_map);
 
-	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
-					       enum nl80211_channel_type *type);
-
 	int	(*get_et_sset_count)(struct wiphy *wiphy,
 				     struct net_device *dev, int sset);
 	void	(*get_et_stats)(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index df7332e..4efc1ff 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2933,16 +2933,6 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static struct ieee80211_channel *
-ieee80211_wiphy_get_channel(struct wiphy *wiphy,
-			    enum nl80211_channel_type *type)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-
-	*type = local->_oper_channel_type;
-	return local->oper_channel;
-}
-
 static void ieee80211_set_monitor_enabled(struct wiphy *wiphy, bool enabled)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
@@ -3026,7 +3016,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.tdls_oper = ieee80211_tdls_oper,
 	.tdls_mgmt = ieee80211_tdls_mgmt,
 	.probe_client = ieee80211_probe_client,
-	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
 	.set_monitor_enabled = ieee80211_set_monitor_enabled,
 #ifdef CONFIG_PM
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d36124..6773488 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1588,16 +1588,11 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			(cfg80211_rdev_list_generation << 2)))
 		goto nla_put_failure;
 
-	if (rdev->ops->get_channel) {
-		struct ieee80211_channel *chan;
-		enum nl80211_channel_type channel_type;
-
-		chan = rdev->ops->get_channel(&rdev->wiphy, &channel_type);
-		if (chan &&
-		    (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
-				    chan->center_freq) ||
-		     nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
-				    channel_type)))
+	if (rdev->monitor_channel) {
+		if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
+				rdev->monitor_channel->center_freq) ||
+		    nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				rdev->monitor_channel_type))
 			goto nla_put_failure;
 	}
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index bc87983..7df42f5 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -827,8 +827,6 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
-	struct ieee80211_channel *chan;
-	enum nl80211_channel_type channel_type;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -836,13 +834,10 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
 	case NL80211_IFTYPE_MONITOR:
-		if (!rdev->ops->get_channel)
+		if (!rdev->monitor_channel)
 			return -EINVAL;
 
-		chan = rdev->ops->get_channel(wdev->wiphy, &channel_type);
-		if (!chan)
-			return -EINVAL;
-		freq->m = chan->center_freq;
+		freq->m = rdev->monitor_channel->center_freq;
 		freq->e = 6;
 		return 0;
 	default:
-- 
1.7.0.4

