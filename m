Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab3BKKOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 05:14:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix channel selection bug
Date: Mon, 11 Feb 2013 11:14:13 +0100
Message-Id: <1360577653-20260-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_111423_564069_232BE3F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When trying to connect to an AP that advertises HT but not
VHT, the mac80211 code erroneously uses the configuration
from the AP as is instead of checking it against regulatory
and local capabilities. This can lead to using an invalid
or even inexistent channel (like 11/HT40+).

Additionally, the return flags from downgrading must be
ORed together, to collect them from all of the downgrades.
Also clarify the message.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3b9cb51..5107248 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3400,6 +3400,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 
 	ret = 0;
 
+out:
 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
 					IEEE80211_CHAN_DISABLED)) {
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
@@ -3408,14 +3409,13 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			goto out;
 		}
 
-		ret = chandef_downgrade(chandef);
+		ret |= chandef_downgrade(chandef);
 	}
 
 	if (chandef->width != vht_chandef.width)
 		sdata_info(sdata,
-			   "local regulatory prevented using AP HT/VHT configuration, downgraded\n");
+			   "capabilities/regulatory prevented using AP HT/VHT configuration, downgraded\n");
 
-out:
 	WARN_ON_ONCE(!cfg80211_chandef_valid(chandef));
 	return ret;
 }
-- 
1.8.0

