Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:50291 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbbAPOEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 09:04:21 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Jan 2015 16:04:09 +0200
Message-Id: <1421417049-9087-1-git-send-email-luca@coelho.fi> (sfid-20150116_150436_904439_7488CF1B)
Subject: [PATCH] nl80211: add an attribute to allow delaying the first scheduled scan cycle
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The userspace may want to delay the the first scheduled scan or
net-detect cycle.  Add an optional attribute to the scheduled scan
configuration to pass the delay to be (optionally) used by the driver.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       |  5 +++++
 include/uapi/linux/nl80211.h | 20 ++++++++++++++------
 net/wireless/nl80211.c       |  4 ++++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b44ba0..64e09e1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1493,6 +1493,10 @@ struct cfg80211_match_set {
  * @rcu_head: RCU callback used to free the struct
  * @owner_nlportid: netlink portid of owner (if this should is a request
  *	owned by a particular socket)
+ * @delay: delay in seconds to use before starting the first scan
+ *	cycle.  The driver may ignore this parameter and start
+ *	immediately (or at any other time), if this feature is not
+ *	supported.
  */
 struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1506,6 +1510,7 @@ struct cfg80211_sched_scan_request {
 	struct cfg80211_match_set *match_sets;
 	int n_match_sets;
 	s32 min_rssi_thold;
+	u32 delay;
 
 	u8 mac_addr[ETH_ALEN] __aligned(2);
 	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f52797a..9eaccf0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -324,7 +324,9 @@
  *	if passed, define which channels should be scanned; if not
  *	passed, all channels allowed for the current regulatory domain
  *	are used.  Extra IEs can also be passed from the userspace by
- *	using the %NL80211_ATTR_IE attribute.
+ *	using the %NL80211_ATTR_IE attribute.  The first cycle of the
+ *	scheduled scan can be delayed by %NL80211_ATTR_SCHED_SCAN_DELAY
+ *	is supplied.
  * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan. Returns -ENOENT if
  *	scheduled scan is not running. The caller may assume that as soon
  *	as the call returns, it is safe to start a new scheduled scan again.
@@ -1735,6 +1737,9 @@ enum nl80211_commands {
  *	should be contained in the result as the sum of the respective counters
  *	over all channels.
  *
+ * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
+ *	WoWLAN net-detect scan) is started, u32 in seconds.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2098,6 +2103,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SURVEY_RADIO_STATS,
 
+	NL80211_ATTR_SCHED_SCAN_DELAY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3741,11 +3748,12 @@ struct nl80211_pattern_support {
  * @NL80211_WOWLAN_TRIG_NET_DETECT: wake up when a configured network
  *	is detected.  This is a nested attribute that contains the
  *	same attributes used with @NL80211_CMD_START_SCHED_SCAN.  It
- *	specifies how the scan is performed (e.g. the interval and the
- *	channels to scan) as well as the scan results that will
- *	trigger a wake (i.e. the matchsets).  This attribute is also
- *	sent in a response to @NL80211_CMD_GET_WIPHY, indicating the
- *	number of match sets supported by the driver (u32).
+ *	specifies how the scan is performed (e.g. the interval, the
+ *	channels to scan and the initial delay) as well as the scan
+ *	results that will trigger a wake (i.e. the matchsets).  This
+ *	attribute is also sent in a response to
+ *	@NL80211_CMD_GET_WIPHY, indicating the number of match sets
+ *	supported by the driver (u32).
  * @NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS: nested attribute
  *	containing an array with information about what triggered the
  *	wake up.  If no elements are present in the array, it means
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8e56eeb..f2ef811 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6204,6 +6204,10 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		}
 	}
 
+	if (attrs[NL80211_ATTR_SCHED_SCAN_DELAY])
+		request->delay =
+			nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_DELAY]);
+
 	request->interval = interval;
 	request->scan_start = jiffies;
 
-- 
2.1.4

