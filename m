Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2EKSUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 14:20:47 -0400
Message-Id: <20120511181044.938534049@sipsolutions.net> (sfid-20120511_202052_431487_8F92F00D)
Date: Fri, 11 May 2012 20:08:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 2/3] cfg80211: disallow setting channel on WDS interfaces
References: <20120511180817.974687689@sipsolutions.net>
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
 net/wireless/nl80211.c     |    6 ++----
 net/wireless/wext-compat.c |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/net/wireless/nl80211.c	2012-05-11 19:34:13.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-11 20:01:08.000000000 +0200
@@ -1128,9 +1128,8 @@ static int parse_txq_params(struct nlatt
 static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 {
 	/*
-	 * You can only set the channel explicitly for WDS interfaces,
-	 * all others have their channel managed via their respective
-	 * "establish a connection" command (connect, join, ...)
+	 * You can't set the channel explicitly, it is managed with
+	 * the "establish a connection" commands (connect, join, ...)
 	 *
 	 * For AP/GO and mesh mode, the channel can be set with the
 	 * channel userspace API, but is only stored and passed to the
@@ -1144,7 +1143,6 @@ static bool nl80211_can_set_dev_channel(
 	 */
 	return !wdev ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
-		wdev->iftype == NL80211_IFTYPE_WDS ||
 		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
 		wdev->iftype == NL80211_IFTYPE_MONITOR ||
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;
--- a/net/wireless/wext-compat.c	2012-05-11 19:45:41.000000000 +0200
+++ b/net/wireless/wext-compat.c	2012-05-11 20:01:08.000000000 +0200
@@ -796,7 +796,6 @@ static int cfg80211_wext_siwfreq(struct
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_siwfreq(dev, info, wextfreq, extra);
 	case NL80211_IFTYPE_MONITOR:
-	case NL80211_IFTYPE_WDS:
 		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
 		if (freq < 0)
 			return freq;


