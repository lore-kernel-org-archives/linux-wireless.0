Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:49442 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934942Ab0GSTKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 15:10:51 -0400
Message-ID: <4C449C67.6010004@davizone.at>
Date: Mon, 19 Jul 2010 20:41:43 +0200
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: fix WEXT ioctl GIWFREQ for monitor interfaces
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cfg80211_set_freq function now also saves the channel for monitor
interfaces.
This fixes a issue were the WEXT ioctl GIWFREQ doesn't report the correct
channel when the channel was switched in monitor mode.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 net/wireless/chan.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d0c92dd..fd05938 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -51,9 +51,6 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 	struct ieee80211_channel *chan;
 	int result;

-	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
-		wdev = NULL;
-
 	if (wdev) {
 		ASSERT_WDEV_LOCK(wdev);

@@ -69,7 +66,9 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		return -EINVAL;

 	result = rdev->ops->set_channel(&rdev->wiphy,
-					wdev ? wdev->netdev : NULL,
+					wdev && wdev->iftype !=
+						NL80211_IFTYPE_MONITOR ?
+							wdev->netdev : NULL,
 					chan, channel_type);
 	if (result)
 		return result;
-- 
1.6.3.3

