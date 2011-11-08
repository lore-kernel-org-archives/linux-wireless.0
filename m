Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1KHSwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 13:52:10 -0500
Subject: [PATCH] mac80211/cfg80211: report monitor channel in wireless
 extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 19:52:07 +0100
Message-ID: <1320778327.24797.36.camel@jlt3.sipsolutions.net> (sfid-20111108_195213_970616_E8AF4017)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just add API to get the channel & report it. Trivial really.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I'm not sure why this is so hard that the aircrack people
couldn't figure out what to do ...

 include/net/cfg80211.h     |    5 +++++
 net/mac80211/cfg.c         |    8 ++++++++
 net/wireless/wext-compat.c |   12 ++++++++++++
 3 files changed, 25 insertions(+)

--- a/include/net/cfg80211.h	2011-11-08 19:37:45.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-08 19:49:33.000000000 +0100
@@ -1342,6 +1342,9 @@ struct cfg80211_gtk_rekey_data {
  *	doesn't verify much. Note, however, that the passed netdev may be
  *	%NULL as well if the user requested changing the channel for the
  *	device itself, or for a monitor interface.
+ * @get_channel: Get the current operating channel, should return %NULL if
+ *	there's no signal defined operating channel if for example the
+ *	device implements channel hopping for multi-channel virtual interfaces.
  *
  * @scan: Request to do a scan. If returning zero, the scan request is given
  *	the driver, and will be valid until passed to cfg80211_scan_done().
@@ -1627,6 +1630,8 @@ struct cfg80211_ops {
 
 	int	(*probe_client)(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *peer, u64 *cookie);
+
+	struct ieee80211_channel *(get_channel)(struct wiphy *wiphy);
 };
 
 /*
--- a/net/wireless/wext-compat.c	2011-11-08 19:37:45.000000000 +0100
+++ b/net/wireless/wext-compat.c	2011-11-08 19:49:33.000000000 +0100
@@ -818,12 +818,24 @@ static int cfg80211_wext_giwfreq(struct
 				 struct iw_freq *freq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct ieee80211_channel *chan;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
+	case NL80211_IFTYPE_MONITOR:
+		if (!rdev->ops->get_channel)
+			return -EINVAL;
+
+		chan = rdev->ops->get_channel(wdev->wiphy);
+		if (!chan)
+			return -EINVAL;
+		freq->m = chan->center_freq;
+		freq->e = 6;
+		return 0;
 	default:
 		if (!wdev->channel)
 			return -EINVAL;
--- a/net/mac80211/cfg.c	2011-11-08 19:37:45.000000000 +0100
+++ b/net/mac80211/cfg.c	2011-11-08 19:49:33.000000000 +0100
@@ -2579,6 +2579,13 @@ static int ieee80211_probe_client(struct
 	return 0;
 }
 
+static const struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return local->oper_channel;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2645,4 +2652,5 @@ struct cfg80211_ops mac80211_config_ops
 	.tdls_oper = ieee80211_tdls_oper,
 	.tdls_mgmt = ieee80211_tdls_mgmt,
 	.probe_client = ieee80211_probe_client,
+	.get_channel = ieee80211_get_channel,
 };


