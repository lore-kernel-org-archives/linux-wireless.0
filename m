Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36609 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751433AbcIMN4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 09:56:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: validate number of probe response CSA counters
Date: Tue, 13 Sep 2016 15:56:45 +0200
Message-Id: <1473775005-16286-1-git-send-email-johannes@sipsolutions.net> (sfid-20160913_155653_590126_6A729122)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to an apparent copy/paste bug, the number of counters for the
beacon configuration were checked twice, instead of checking the
number of probe response counters. Fix this to check the number of
probe response counters before parsing those.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ef234d2fd854..a65c94f202f8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6998,7 +6998,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 
 		params.n_counter_offsets_presp = len / sizeof(u16);
 		if (rdev->wiphy.max_num_csa_counters &&
-		    (params.n_counter_offsets_beacon >
+		    (params.n_counter_offsets_presp >
 		     rdev->wiphy.max_num_csa_counters))
 			return -EINVAL;
 
-- 
2.8.1
