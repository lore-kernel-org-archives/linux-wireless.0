Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:52977 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755734AbcKVNcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 08:32:07 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] nl80211: provide minimum scheduled scan (plan) interval
Date: Tue, 22 Nov 2016 13:31:55 +0000
Message-Id: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161122_143227_768297_E15245AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interval for scheduled scan may have a minimum value for
the device. Allow drivers to specify a minimum value in the
struct wiphy so user-space interval values can be validated
against it.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/nl80211.c       | 12 ++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2019310..ef5d6ab 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3427,6 +3427,8 @@ struct wiphy_iftype_ext_capab {
  *	scans
  * @max_sched_scan_plans: maximum number of scan plans (scan interval and number
  *	of iterations) for scheduled scan supported by the device.
+ * @min_sched_scan_plan_interval: minimum interval (in seconds) for a
+ *	single scan plan supported by the device.
  * @max_sched_scan_plan_interval: maximum interval (in seconds) for a
  *	single scan plan supported by the device.
  * @max_sched_scan_plan_iterations: maximum number of iterations for a single
@@ -3552,6 +3554,7 @@ struct wiphy {
 	u16 max_scan_ie_len;
 	u16 max_sched_scan_ie_len;
 	u32 max_sched_scan_plans;
+	u32 min_sched_scan_plan_interval;
 	u32 max_sched_scan_plan_interval;
 	u32 max_sched_scan_plan_iterations;
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 259c9c7..77fc77a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2381,6 +2381,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED,
 
+	NL80211_ATTR_MIN_SCAN_PLAN_INTERVAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 24ab199..47aca56 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1474,6 +1474,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				rdev->wiphy.max_sched_scan_plans) ||
 		    nla_put_u32(msg, NL80211_ATTR_MAX_SCAN_PLAN_INTERVAL,
 				rdev->wiphy.max_sched_scan_plan_interval) ||
+		    nla_put_u32(msg, NL80211_ATTR_MIN_SCAN_PLAN_INTERVAL,
+				rdev->wiphy.min_sched_scan_plan_interval) ||
 		    nla_put_u32(msg, NL80211_ATTR_MAX_SCAN_PLAN_ITERATIONS,
 				rdev->wiphy.max_sched_scan_plan_iterations))
 			goto nla_put_failure;
@@ -6777,6 +6779,12 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 		if (!request->scan_plans[0].interval)
 			return -EINVAL;
 
+		if (wiphy->min_sched_scan_plan_interval &&
+		    request->scan_plans[0].interval <
+		    wiphy->min_sched_scan_plan_interval)
+			request->scan_plans[0].interval =
+				wiphy->min_sched_scan_plan_interval;
+
 		if (request->scan_plans[0].interval >
 		    wiphy->max_sched_scan_plan_interval)
 			request->scan_plans[0].interval =
@@ -6805,6 +6813,10 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 		    request->scan_plans[i].interval >
 		    wiphy->max_sched_scan_plan_interval)
 			return -EINVAL;
+		if (wiphy->min_sched_scan_plan_interval &&
+		    request->scan_plans[i].interval <
+		    wiphy->min_sched_scan_plan_interval)
+			return -EINVAL;
 
 		if (plan[NL80211_SCHED_SCAN_PLAN_ITERATIONS]) {
 			request->scan_plans[i].iterations =
-- 
1.9.1
