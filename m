Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([83.151.30.3]:40100 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3J3PJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 11:09:45 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH-mac80211] cfg80211: fix ibss wext chandef creation
Date: Wed, 30 Oct 2013 16:09:33 +0100
Message-Id: <1383145773-17165-1-git-send-email-sw@simonwunderlich.de> (sfid-20131030_160948_396653_797B5B7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wext internal chandefs for ibss should be created using the
cfg80211_chandef_create() functions. Initializing fields manually is
error-prone.

Reported-by: Dirk Gouders <dirk@gouders.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ibss.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 403fe29..a710019 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -246,7 +246,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 	/* try to find an IBSS channel if none requested ... */
 	if (!wdev->wext.ibss.chandef.chan) {
-		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		struct ieee80211_channel *new_chan = NULL;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
@@ -262,18 +262,19 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 					continue;
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
-				wdev->wext.ibss.chandef.chan = chan;
-				wdev->wext.ibss.chandef.center_freq1 =
-					chan->center_freq;
+				new_chan = chan;
 				break;
 			}
 
-			if (wdev->wext.ibss.chandef.chan)
+			if (new_chan)
 				break;
 		}
 
-		if (!wdev->wext.ibss.chandef.chan)
+		if (!new_chan)
 			return -EINVAL;
+
+		cfg80211_chandef_create(&wdev->wext.ibss.chandef, new_chan,
+					NL80211_CHAN_NO_HT);
 	}
 
 	/* don't join -- SSID is not there */
@@ -347,9 +348,8 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 		return err;
 
 	if (chan) {
-		wdev->wext.ibss.chandef.chan = chan;
-		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
-		wdev->wext.ibss.chandef.center_freq1 = freq;
+		cfg80211_chandef_create(&wdev->wext.ibss.chandef, chan,
+					NL80211_CHAN_NO_HT);
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
-- 
1.7.10.4

