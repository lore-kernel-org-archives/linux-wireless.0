Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60792 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755480AbcJUMZU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:25:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>,
        jouni@qca.qualcomm.com, usdutt@qti.qualcomm.com,
        amarnath@qca.qualcomm.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] cfg80211: disallow beacon_int_min_gcd with IBSS
Date: Fri, 21 Oct 2016 14:25:12 +0200
Message-Id: <1477052714-11223-2-git-send-email-johannes@sipsolutions.net> (sfid-20161021_142525_346919_6F7FFF67)
In-Reply-To: <1477052714-11223-1-git-send-email-johannes@sipsolutions.net>
References: <1477052714-11223-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This can't really be supported right now, because the IBSS
interface may change its beacon interval at any time due to
joining another network; thus, there's already "support"
for different beacon intervals here, implicitly.

Until we figure out how we should handle this case (continue
to allow it to arbitrarily join? Join only if compatible?)
disallow advertising that different beacon intervals are
supported if IBSS is allowed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 725adff6c7d4..158c59ecf90a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -562,6 +562,21 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				    c->limits[j].max > 1))
 				return -EINVAL;
 
+			/*
+			 * This isn't well-defined right now. If you have an
+			 * IBSS interface, then its beacon interval may change
+			 * by joining other networks, and nothing prevents it
+			 * from doing that.
+			 * So technically we probably shouldn't even allow AP
+			 * and IBSS in the same interface, but it seems that
+			 * some drivers support that, possibly only with fixed
+			 * beacon intervals for IBSS.
+			 */
+			if (WARN_ON(types & BIT(NL80211_IFTYPE_ADHOC) &&
+				    c->beacon_int_min_gcd)) {
+				return -EINVAL;
+			}
+
 			cnt += c->limits[j].max;
 			/*
 			 * Don't advertise an unsupported type
-- 
2.8.1
