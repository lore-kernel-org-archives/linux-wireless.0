Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32852 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbbEKMCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 08:02:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: check fast-xmit if IBSS STA QoS changed
Date: Mon, 11 May 2015 14:02:42 +0200
Message-Id: <1431345762-15075-1-git-send-email-johannes@sipsolutions.net> (sfid-20150511_140248_107540_BB373C9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an IBSS station gets QoS enabled after having been added,
check fast-xmit to make sure the QoS header gets added to the
cache properly and frames can go out with QoS and higher rates.

Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bfef1b215050..21716af8bec3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1031,8 +1031,11 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (sta && elems->wmm_info && local->hw.queues >= IEEE80211_NUM_ACS)
+	if (sta && !sta->sta.wme &&
+	    elems->wmm_info && local->hw.queues >= IEEE80211_NUM_ACS) {
 		sta->sta.wme = true;
+		ieee80211_check_fast_xmit(sta);
+	}
 
 	if (sta && elems->ht_operation && elems->ht_cap_elem &&
 	    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
-- 
2.1.4

