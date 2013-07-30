Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab3G3Uiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 16:38:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11] nl80211: fix another nl80211_fam.attrbuf race
Date: Tue, 30 Jul 2013 22:38:42 +0200
Message-Id: <1375216722-31194-1-git-send-email-johannes@sipsolutions.net> (sfid-20130730_223853_966724_46A21D35)
In-Reply-To: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk>
References: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is similar to the race Linus had reported, but in this case
it's an older bug: nl80211_prepare_wdev_dump() uses the wiphy
index in cb->args[0] as it is and thus parses the message over
and over again instead of just once because 0 is the first valid
wiphy index. Similar code in nl80211_testmode_dump() correctly
offsets the wiphy_index by 1, do that here as well.

Cc: stable@vger.kernel.org
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 25d217d..3fcba69 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -441,10 +441,12 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 			goto out_unlock;
 		}
 		*rdev = wiphy_to_dev((*wdev)->wiphy);
-		cb->args[0] = (*rdev)->wiphy_idx;
+		/* 0 is the first index - add 1 to parse only once */
+		cb->args[0] = (*rdev)->wiphy_idx + 1;
 		cb->args[1] = (*wdev)->identifier;
 	} else {
-		struct wiphy *wiphy = wiphy_idx_to_wiphy(cb->args[0]);
+		/* subtract the 1 again here */
+		struct wiphy *wiphy = wiphy_idx_to_wiphy(cb->args[0] - 1);
 		struct wireless_dev *tmp;
 
 		if (!wiphy) {
-- 
1.8.0

