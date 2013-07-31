Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3GaTKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:10:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: chrisw@sous-sol.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11] mac80211: continue using disabled channels while connected
Date: Wed, 31 Jul 2013 21:09:59 +0200
Message-Id: <1375297799-2023-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_211029_520496_7736CF8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In case the AP has different regulatory information than we do,
it can happen that we connect to an AP based on e.g. the world
roaming regulatory data, and then update our database with the
AP's country information disables the channel the AP is using.
If this happens on an HT AP, the bandwidth tracking code will
hit the WARN_ON() and disconnect. Since that's not very useful,
ignore the channel-disable flag in bandwidth tracking.

Reported-by: Chris Wright <chrisw@sous-sol.org>
Tested-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 77e7796..3df4fb3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -335,8 +335,17 @@ out:
 	if (ret & IEEE80211_STA_DISABLE_VHT)
 		vht_chandef = *chandef;
 
+	/*
+	 * Ignore the DISABLED flag when we're already connected and only
+	 * tracking the APs beacon for bandwidth changes - otherwise we
+	 * might get disconnected here if we connect to an AP, update our
+	 * regulatory information based on the AP's country IE and the
+	 * information we have is wrong/outdated and disables the channel
+	 * that we're actually using for the connection to the AP.
+	 */
 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
-					IEEE80211_CHAN_DISABLED)) {
+					tracking ? 0 :
+						   IEEE80211_CHAN_DISABLED)) {
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
 			ret = IEEE80211_STA_DISABLE_HT |
 			      IEEE80211_STA_DISABLE_VHT;
-- 
1.8.0

