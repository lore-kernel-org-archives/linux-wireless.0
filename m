Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49740 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751146AbdAMJCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 04:02:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: corbet@lwn.net, linux-doc@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix a documentation warning
Date: Fri, 13 Jan 2017 10:02:13 +0100
Message-Id: <20170113090213.29414-1-johannes@sipsolutions.net> (sfid-20170113_100222_034504_EDBDF673)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new restructured text parser complains about the formatting,
and really this should be a definition list.

Unfortunately, due to it being inside the parameter description,
and the definition list needing a blank line, this adds trailing
whitespace to keep it in the parameter description.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b7aba6e1a586..181e2d544a1b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3190,10 +3190,13 @@ struct ieee80211_iface_limit {
  * @radar_detect_regions: bitmap of regions supported for radar detection
  * @beacon_int_min_gcd: This interface combination supports different
  *	beacon intervals.
- *	= 0 - all beacon intervals for different interface must be same.
- *	> 0 - any beacon interval for the interface part of this combination AND
- *	      *GCD* of all beacon intervals from beaconing interfaces of this
- *	      combination must be greater or equal to this value.
+ *	
+ *	= 0
+ *	  all beacon intervals for different interface must be same.
+ *	> 0
+ *	  any beacon interval for the interface part of this combination AND
+ *	  GCD of all beacon intervals from beaconing interfaces of this
+ *	  combination must be greater or equal to this value.
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
-- 
2.9.3
