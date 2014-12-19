Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46994 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaLSP6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 10:58:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/3] nl80211: support per-rate/per-station statistics
Date: Fri, 19 Dec 2014 16:58:03 +0100
Message-Id: <1419004683-25369-3-git-send-email-johannes@sipsolutions.net> (sfid-20141219_165815_958575_D3B60856)
In-Reply-To: <1419004683-25369-1-git-send-email-johannes@sipsolutions.net>
References: <1419004683-25369-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Per-rate/per-station statistics can be desirable to have but they're
quite expensive (keeping the four counters for each rate would take
close to 4k of memory per station only for VHT MCSes for a moderately
capable VHT chip (with 2 spatial streams and 80MHz support) so it's
not a good idea to keep all of this in the kernel. Using a hash table
instead can be done, but then addressing becomes more expensive.

Instead, this API provides a way for interested clients in userspace
to subscribe to such statistics. When supported by a driver, it can
then start collecting the data only when subscribers exist. To avoid
the kernel's data collection becoming too big, it can send out the
data at any point in time, for example to limit the counters to u32
internally and send it out when they're close to reaching the limit,
or to keep a hash table and sending it out when too many collisions
occur. Userspace can then keep track of the full state.

This RFC defines only the userspace API so far, without even a trace
of implementation.

Change-Id: I80313d3a62502bf28a7e241807a585fb4e976ab9
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 77 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ef99b90e9241..2ca0cc2a5d87 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -787,6 +787,13 @@
  *	as an event to indicate changes for devices with wiphy-specific regdom
  *	management.
  *
+ * @NL80211_CMD_RATE_STATISTICS: Used as a command to subscribe to per-rate
+ *	packet statistics, and as a notification to send those statistics to
+ *	the subscribers. See the "per-rate statistics" documentation section.
+ * @NL80211_CMD_RATE_STATISTICS_GET: This command can be used to trigger the
+ *	rate statistics dump to userspace, which also clears the data in the
+ *	kernel (driver). See the "per-rate statistics" documentation section.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -973,6 +980,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_WIPHY_REG_CHANGE,
 
+	NL80211_CMD_RATE_STATISTICS,
+	NL80211_CMD_RATE_STATISTICS_GET,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1718,6 +1728,10 @@ enum nl80211_commands {
  *	should be contained in the result as the sum of the respective counters
  *	over all channels.
  *
+ * @NL80211_ATTR_RATE_STATS: per-rate statistics container attribute, this is
+ *	used as an array with each entry containing &enum nl80211_rate_stats
+ *	attributes.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2079,6 +2093,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SURVEY_RADIO_STATS,
 
+	NL80211_ATTR_RATE_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	NL80211_ATTR_REG_INDOOR = 0x1000,
@@ -4505,4 +4521,65 @@ enum nl80211_tdls_peer_capability {
 	NL80211_TDLS_PEER_WMM = 1<<2,
 };
 
+/**
+ * DOC: per-rate statistics
+ *
+ * The nl80211 API provides a way to subscribe to per-bitrate statistics. Since
+ * there are many bitrates it isn't always desirable to keep statistics for all
+ * of the rates in the kernel. As a consequence, the API allows the drivers to
+ * dump the information to userspace and reset their internal values. As it can
+ * also be expensive to keep the counters, this is only done when subscribers
+ * exist.
+ *
+ * To use this facility, a userspace client must subscribe to the data using the
+ * %NL80211_CMD_RATE_STATISTICS command. This starts data collection. If other
+ * clients already exists, those are also sent the current statistics (as if the
+ * %NL80211_CMD_RATE_STATISTICS_GET command had been issued) to allow the new
+ * client to collect only the data while subscribed.
+ *
+ * While subscribed, the client must listen for %NL80211_CMD_RATE_STATISTICS
+ * events sent to the subscribed socket, and accumulate data retrieved in them.
+ * Every time such an event is sent by the kernel, the in-kernel data is also
+ * cleared. Therefore, to achieve data collection over longer periods of time,
+ * the subscribers must accumulate data. No representation is made about how
+ * long the kernel will collect data, but (as an implementation guideline) the
+ * data shouldn't be sent out frequently, and only while traffic is keeping the
+ * CPU busy anyway (i.e. it is recommended to not use timers.)
+ *
+ * In order to obtain a sample or clear the statistics at a given point in time,
+ * the %NL80211_CMD_RATE_STATISTICS_GET command can be used. This command can
+ * be called by any nl80211 client (even non-subscribers) and causes the kernel
+ * to send out and clear (atomically) the currently accumulated data to all of
+ * the subscribers.
+ *
+ * Note that the data sent out in each %NL80211_CMD_RATE_STATISTICS notification
+ * pertains only to a single station (identified by the interface index and the
+ * station's MAC address.) It is therefore expected that multiple messages will
+ * be received by an application, and subscribers must ensure that their socket
+ * buffers are big enough to retrieve all the data.
+ *
+ * To unsubscribe, simply close the subscribed socket.
+ */
+
+/**
+ * enum nl80211_rate_stats - per-rate statistics container attributes
+ * @__NL80211_ATTR_RATE_STATS_INVALID: attribute number 0 is reserved
+ * @NL80211_ATTR_RATE_STATS_RATE: bitrate definition, nested attribute
+ *	containing the attributes from &enum nl80211_rate_info.
+ * @NL80211_ATTR_RATE_STATS_STATS: statistics values, nested attribute
+ *	containing the attributes from &enum nl80211_tid_stats (even
+ *	though the statistics are not per TID)
+ * @NUM_NL80211_ATTR_RATE_STATS: number of attributes here
+ * @NL80211_ATTR_RATE_STATS_MAX: highest numbered attribute here
+ */
+enum nl80211_rate_stats {
+	__NL80211_ATTR_RATE_STATS_INVALID,
+	NL80211_ATTR_RATE_STATS_RATE,
+	NL80211_ATTR_RATE_STATS_STATS,
+
+	/* keep last */
+	NUM_NL80211_ATTR_RATE_STATS,
+	NL80211_ATTR_RATE_STATS_MAX = NUM_NL80211_ATTR_RATE_STATS - 1
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
2.1.1

