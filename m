Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab2EPVzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:55:03 -0400
Message-Id: <20120516215038.773976797@sipsolutions.net> (sfid-20120516_235513_080603_21F72C30)
Date: Wed, 16 May 2012 23:50:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] cfg80211: disallow setting channel on WDS interfaces
References: <20120516215014.379333357@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If it worked (Felix says it doesn't right now), the
typical use-case for WDS interfaces would be to be
slaved to AP mode interfaces. Therefore, it isn't
necessary to set the channel on WDS interfaces. As
they don't support powersave or anything like that,
they also couldn't use a different channel anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c     |    5 ++---
 net/wireless/wext-compat.c |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/net/wireless/nl80211.c	2012-05-16 10:24:41.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-16 10:24:45.000000000 +0200
@@ -1166,8 +1166,8 @@ static int parse_txq_params(struct nlatt
 static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 {
 	/*
-	 * You can only set the channel explicitly for AP, mesh
-	 * and WDS type interfaces; all others have their channel
+	 * You can only set the channel explicitly for AP and
+	 * mesh type interfaces; all others have their channel
 	 * managed via their respective "establish a connection"
 	 * command (connect, join, ...)
 	 *
@@ -1180,7 +1180,6 @@ static bool nl80211_can_set_dev_channel(
 	 */
 	return !wdev ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
-		wdev->iftype == NL80211_IFTYPE_WDS ||
 		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
 		wdev->iftype == NL80211_IFTYPE_MONITOR ||
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;
--- a/net/wireless/wext-compat.c	2012-05-16 10:22:21.000000000 +0200
+++ b/net/wireless/wext-compat.c	2012-05-16 10:24:45.000000000 +0200
@@ -796,7 +796,6 @@ static int cfg80211_wext_siwfreq(struct
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_siwfreq(dev, info, wextfreq, extra);
 	case NL80211_IFTYPE_MONITOR:
-	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MESH_POINT:
 		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
 		if (freq < 0)


