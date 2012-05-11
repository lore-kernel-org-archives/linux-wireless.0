Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab2EKPRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 11:17:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SSrb5-0007Ye-Ix
	for linux-wireless@vger.kernel.org; Fri, 11 May 2012 17:17:35 +0200
Message-ID: <1336749454.12801.15.camel@jlt3.sipsolutions.net> (sfid-20120511_171817_778993_4FA5390C)
Subject: [RFC] cfg80211: disallow setting channel on WDS interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 11 May 2012 17:17:34 +0200
Content-Type: text/plain; charset="UTF-8"
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
This is based on top of a slightly modified version of the mesh change.

 net/wireless/nl80211.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/wireless/nl80211.c	2012-05-11 17:14:08.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-11 17:14:45.000000000 +0200
@@ -1124,9 +1124,8 @@ static int parse_txq_params(struct nlatt
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
@@ -1140,7 +1139,6 @@ static bool nl80211_can_set_dev_channel(
 	 */
 	return !wdev ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
-		wdev->iftype == NL80211_IFTYPE_WDS ||
 		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
 		wdev->iftype == NL80211_IFTYPE_MONITOR ||
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;


