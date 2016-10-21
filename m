Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59794 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754802AbcJUKQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 06:16:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix beacon interval in interface combination iteration
Date: Fri, 21 Oct 2016 12:15:59 +0200
Message-Id: <1477044959-830-1-git-send-email-johannes@sipsolutions.net> (sfid-20161021_121608_788659_5DD994B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We shouldn't abort the iteration with an error when one of the
potential combinations can't accomodate the beacon interval
request, we should just skip that particular combination. Fix
the code to do so.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index ec17c2800117..78bf53705466 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1676,10 +1676,8 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 
 		if (params->beacon_int_gcd) {
 			if (c->beacon_int_min_gcd &&
-			    params->beacon_int_gcd < c->beacon_int_min_gcd) {
-				kfree(limits);
-				return -EINVAL;
-			}
+			    params->beacon_int_gcd < c->beacon_int_min_gcd)
+				goto cont;
 			if (!c->beacon_int_min_gcd &&
 			    params->beacon_int_different)
 				goto cont;
-- 
2.8.1
