Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:47148 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932750AbcKVKWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 05:22:13 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] nl80211: change validation of scheduled scan interval values
Date: Tue, 22 Nov 2016 10:22:06 +0000
Message-Id: <1479810126-28492-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161122_112216_836581_ABA1AB58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When user-space does not provide scheduled scan plans, ie. uses the
old scheduled scan API containing NL80211_ATTR_SCHED_SCAN_INTERVAL.
The interval value passed by user-space is validated against
struct wiphy::max_sched_scan_plan_interval and if it is exceeding
it the interval is set to struct wiphy::max_sched_scan_plan_interval.
However, when the driver does not set this limit the interval the
interval in the request will always be zero. Hence add a check to
see whether the driver set struct wiphy::max_sched_scan_plan_interval.

For the new API, ie. for scheduled scan plans, the interval validation
has been simalarly adjusted to assure the limit is non-zero.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 24ab199..e621554 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6777,7 +6777,8 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 		if (!request->scan_plans[0].interval)
 			return -EINVAL;
 
-		if (request->scan_plans[0].interval >
+		if (wiphy->max_sched_scan_plan_interval &&
+		    request->scan_plans[0].interval >
 		    wiphy->max_sched_scan_plan_interval)
 			request->scan_plans[0].interval =
 				wiphy->max_sched_scan_plan_interval;
@@ -6801,7 +6802,10 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 
 		request->scan_plans[i].interval =
 			nla_get_u32(plan[NL80211_SCHED_SCAN_PLAN_INTERVAL]);
-		if (!request->scan_plans[i].interval ||
+		if (!request->scan_plans[i].interval)
+			return -EINVAL;
+
+		if (wiphy->max_sched_scan_plan_interval &&
 		    request->scan_plans[i].interval >
 		    wiphy->max_sched_scan_plan_interval)
 			return -EINVAL;
-- 
1.9.1
