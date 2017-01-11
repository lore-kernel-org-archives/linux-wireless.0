Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33456 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030473AbdAKPhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:37:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix the TID on NDPs sent as EOSP carrier
Date: Wed, 11 Jan 2017 16:37:42 +0100
Message-Id: <20170111153742.741-1-johannes@sipsolutions.net> (sfid-20170111_163801_987344_B02B478E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the commit below, I forgot to translate the mac80211's
AC to QoS IE order. Moreover, the condition in the if was
wrong. Fix both issues.
This bug would hit only with clients that didn't set all
the ACs as delivery enabled.

Fixes: f438ceb81d4 ("mac80211: uapsd_queues is in QoS IE order")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b6cfcf038c11..50c309094c37 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1501,8 +1501,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 		/* This will evaluate to 1, 3, 5 or 7. */
 		for (ac = IEEE80211_AC_VO; ac < IEEE80211_NUM_ACS; ac++)
-			if (ignored_acs & BIT(ac))
-				continue;
+			if (!(ignored_acs & ieee80211_ac_to_qos_mask[ac]))
+				break;
 		tid = 7 - 2 * ac;
 
 		ieee80211_send_null_response(sta, tid, reason, true, false);
-- 
2.9.3
