Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49748 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaKYI5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 03:57:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove pointless channel lookup in survey code
Date: Tue, 25 Nov 2014 09:57:33 +0100
Message-Id: <1416905853-15488-1-git-send-email-johannes@sipsolutions.net> (sfid-20141125_095743_317860_8C390D7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We have a channel pointer, and we use its center frequency
to look up a channel pointer - which will thus be exactly
the same as the original pointer.

Remove that pointless lookup and just use the pointer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6e4177701d86..b5e3c489239d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6562,8 +6562,6 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 	}
 
 	while (1) {
-		struct ieee80211_channel *chan;
-
 		res = rdev_dump_survey(rdev, wdev->netdev, survey_idx, &survey);
 		if (res == -ENOENT)
 			break;
@@ -6576,9 +6574,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 			goto out;
 		}
 
-		chan = ieee80211_get_channel(&rdev->wiphy,
-					     survey.channel->center_freq);
-		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
+		if (survey.channel->flags & IEEE80211_CHAN_DISABLED) {
 			survey_idx++;
 			continue;
 		}
-- 
2.1.1

