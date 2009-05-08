Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZEHHmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 03:42:46 -0400
Subject: [PATCH] cfg80211: fix wext iw_freq parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 09:42:33 +0200
Message-Id: <1241768553.1567.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function to parse a struct iw_freq has a stupid bug,
it returns NULL when the channel cannot be found at all,
but NULL is supposed to mean "auto". Fix this by checking
the return value of ieee80211_get_channel() and returning
ERR_PTR(-EINVAL) if it returned NULL (channel not found).

This fixes an issue where you could say (in IBSS mode)
	iwconfig wlan0 channel 21
and it would use channel 1 instead because that's the
first available channel with IBSS allowed (which is what
the "auto" setting uses).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-05-08 09:13:39.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-05-08 09:36:54.000000000 +0200
@@ -296,22 +296,34 @@ EXPORT_SYMBOL_GPL(cfg80211_wext_siwmlme)
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq)
 {
+	struct ieee80211_channel *chan;
+	int f;
+
+	/*
+	 * Parse frequency - return NULL for auto and
+	 * -EINVAL for impossible things.
+	 */
 	if (freq->e == 0) {
 		if (freq->m < 0)
 			return NULL;
-		else
-			return ieee80211_get_channel(wiphy,
-				ieee80211_channel_to_frequency(freq->m));
+		f = ieee80211_channel_to_frequency(freq->m);
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)
 			div /= 10;
-		if (div > 0)
-			return ieee80211_get_channel(wiphy, freq->m / div);
-		else
+		if (div <= 0)
 			return ERR_PTR(-EINVAL);
+		f = freq->m / div;
 	}
 
+	/*
+	 * Look up channel struct and return -EINVAL when
+	 * it cannot be found.
+	 */
+	chan = ieee80211_get_channel(wiphy, f);
+	if (!chan)
+		return ERR_PTR(-EINVAL);
+	return chan;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_freq);
 


