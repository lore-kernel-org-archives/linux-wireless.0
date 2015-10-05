Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55330 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbbJEJeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 05:34:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: dimitrysh@google.com
Subject: [PATCH] nl80211: allow BSS data to include CLOCK_BOOTTIME timestamp
Date: Mon,  5 Oct 2015 11:34:03 +0200
Message-Id: <1444037643-22359-1-git-send-email-johannes@sipsolutions.net> (sfid-20151005_113413_144129_53946AE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Shmidt <dimitrysh@google.com>

For location and connectivity services, userspace would often like
to know the time when the BSS was last seen. The current "last seen"
value is calculated in a way that makes it less useful, especially
if the system suspended in the meantime.

Add the ability for the driver to report a real CLOCK_BOOTTIME stamp
that can then be reported to userspace (if present).

Drivers wishing to use this must be converted to the new API to call
cfg80211_inform_bss_data() or cfg80211_inform_bss_frame_data(). They
need to ensure the reported value is accurate enough even when the
frame might have been buffered in the device (e.g. firmware.)

Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
[modified to use struct, inlines]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 91 +++++++++++++++++++++++++++++++++++---------
 include/uapi/linux/nl80211.h |  4 ++
 net/wireless/core.h          |  1 +
 net/wireless/nl80211.c       |  5 +++
 net/wireless/scan.c          | 58 ++++++++++++++--------------
 net/wireless/trace.h         | 22 +++++------
 6 files changed, 125 insertions(+), 56 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 90332a1838cc..fbe134449e69 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1576,6 +1576,26 @@ enum cfg80211_signal_type {
 };
 
 /**
+ * struct cfg80211_inform_bss - BSS inform data
+ * @chan: channel the frame was received on
+ * @scan_width: scan width that was used
+ * @signal: signal strength value, according to the wiphy's
+ *	signal type
+ * @boottime_ns: timestamp (CLOCK_BOOTTIME) when the information was
+ *	received; should match the time when the frame was actually
+ *	received by the device (not just by the host, in case it was
+ *	buffered on the device) and be accurate to about 10ms.
+ *	If the frame isn't buffered, just passing the return value of
+ *	ktime_get_boot_ns() is likely appropriate.
+ */
+struct cfg80211_inform_bss {
+	struct ieee80211_channel *chan;
+	enum nl80211_bss_scan_width scan_width;
+	s32 signal;
+	u64 boottime_ns;
+};
+
+/**
  * struct cfg80211_bss_ie_data - BSS entry IE data
  * @tsf: TSF contained in the frame that carried these IEs
  * @rcu_head: internal use, for freeing
@@ -3958,14 +3978,9 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
 void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy);
 
 /**
- * cfg80211_inform_bss_width_frame - inform cfg80211 of a received BSS frame
- *
+ * cfg80211_inform_bss_frame_data - inform cfg80211 of a received BSS frame
  * @wiphy: the wiphy reporting the BSS
- * @rx_channel: The channel the frame was received on
- * @scan_width: width of the control channel
- * @mgmt: the management frame (probe response or beacon)
- * @len: length of the management frame
- * @signal: the signal strength, type depends on the wiphy's signal_type
+ * @data: the BSS data
  * @gfp: context flags
  *
  * This informs cfg80211 that BSS information was found and
@@ -3975,11 +3990,26 @@ void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy);
  * Or %NULL on error.
  */
 struct cfg80211_bss * __must_check
+cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
+			       struct cfg80211_inform_bss *data,
+			       struct ieee80211_mgmt *mgmt, size_t len,
+			       gfp_t gfp);
+
+static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 				struct ieee80211_channel *rx_channel,
 				enum nl80211_bss_scan_width scan_width,
 				struct ieee80211_mgmt *mgmt, size_t len,
-				s32 signal, gfp_t gfp);
+				s32 signal, gfp_t gfp)
+{
+	struct cfg80211_inform_bss data = {
+		.chan = rx_channel,
+		.scan_width = scan_width,
+		.signal = signal,
+	};
+
+	return cfg80211_inform_bss_frame_data(wiphy, &data, mgmt, len, gfp);
+}
 
 static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
@@ -3987,9 +4017,13 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_mgmt *mgmt, size_t len,
 			  s32 signal, gfp_t gfp)
 {
-	return cfg80211_inform_bss_width_frame(wiphy, rx_channel,
-					       NL80211_BSS_CHAN_WIDTH_20,
-					       mgmt, len, signal, gfp);
+	struct cfg80211_inform_bss data = {
+		.chan = rx_channel,
+		.scan_width = NL80211_BSS_CHAN_WIDTH_20,
+		.signal = signal,
+	};
+
+	return cfg80211_inform_bss_frame_data(wiphy, &data, mgmt, len, gfp);
 }
 
 /**
@@ -4028,13 +4062,32 @@ enum cfg80211_bss_frame_type {
  * Or %NULL on error.
  */
 struct cfg80211_bss * __must_check
+cfg80211_inform_bss_data(struct wiphy *wiphy,
+			 struct cfg80211_inform_bss *data,
+			 enum cfg80211_bss_frame_type ftype,
+			 const u8 *bssid, u64 tsf, u16 capability,
+			 u16 beacon_interval, const u8 *ie, size_t ielen,
+			 gfp_t gfp);
+
+static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss_width(struct wiphy *wiphy,
 			  struct ieee80211_channel *rx_channel,
 			  enum nl80211_bss_scan_width scan_width,
 			  enum cfg80211_bss_frame_type ftype,
 			  const u8 *bssid, u64 tsf, u16 capability,
 			  u16 beacon_interval, const u8 *ie, size_t ielen,
-			  s32 signal, gfp_t gfp);
+			  s32 signal, gfp_t gfp)
+{
+	struct cfg80211_inform_bss data = {
+		.chan = rx_channel,
+		.scan_width = scan_width,
+		.signal = signal,
+	};
+
+	return cfg80211_inform_bss_data(wiphy, &data, ftype, bssid, tsf,
+					capability, beacon_interval, ie, ielen,
+					gfp);
+}
 
 static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss(struct wiphy *wiphy,
@@ -4044,11 +4097,15 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp)
 {
-	return cfg80211_inform_bss_width(wiphy, rx_channel,
-					 NL80211_BSS_CHAN_WIDTH_20, ftype,
-					 bssid, tsf, capability,
-					 beacon_interval, ie, ielen, signal,
-					 gfp);
+	struct cfg80211_inform_bss data = {
+		.chan = rx_channel,
+		.scan_width = NL80211_BSS_CHAN_WIDTH_20,
+		.signal = signal,
+	};
+
+	return cfg80211_inform_bss_data(wiphy, &data, ftype, bssid, tsf,
+					capability, beacon_interval, ie, ielen,
+					gfp);
 }
 
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c0ab6b0a3919..5dadb844fe18 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3364,6 +3364,9 @@ enum nl80211_bss_scan_width {
  *	(not present if no beacon frame has been received yet)
  * @NL80211_BSS_PRESP_DATA: the data in @NL80211_BSS_INFORMATION_ELEMENTS and
  *	@NL80211_BSS_TSF is known to be from a probe response (flag attribute)
+ * @NL80211_BSS_LAST_SEEN_BOOTTIME: CLOCK_BOOTTIME timestamp when this entry
+ *	was last updated by a received frame. The value is expected to be
+ *	accurate to about 10ms. (u64, nanoseconds)
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3383,6 +3386,7 @@ enum nl80211_bss {
 	NL80211_BSS_CHAN_WIDTH,
 	NL80211_BSS_BEACON_TSF,
 	NL80211_BSS_PRESP_DATA,
+	NL80211_BSS_LAST_SEEN_BOOTTIME,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b9d5bc8c148d..a618b4b86fa4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -137,6 +137,7 @@ struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
 	struct rb_node rbn;
+	u64 ts_boottime;
 	unsigned long ts;
 	unsigned long refcount;
 	atomic_t hold;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f05ba8b7af61..fb0712b3d9cb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6605,6 +6605,11 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			jiffies_to_msecs(jiffies - intbss->ts)))
 		goto nla_put_failure;
 
+	if (intbss->ts_boottime &&
+	    nla_put_u64(msg, NL80211_BSS_LAST_SEEN_BOOTTIME,
+			intbss->ts_boottime))
+		goto nla_put_failure;
+
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
 		if (nla_put_u32(msg, NL80211_BSS_SIGNAL_MBM, res->signal))
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 3a50aa2553bf..3feaa03aa046 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -839,6 +839,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 			found->pub.signal = tmp->pub.signal;
 		found->pub.capability = tmp->pub.capability;
 		found->ts = tmp->ts;
+		found->ts_boottime = tmp->ts_boottime;
 	} else {
 		struct cfg80211_internal_bss *new;
 		struct cfg80211_internal_bss *hidden;
@@ -938,14 +939,13 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 }
 
 /* Returned bss is reference counted and must be cleaned up appropriately. */
-struct cfg80211_bss*
-cfg80211_inform_bss_width(struct wiphy *wiphy,
-			  struct ieee80211_channel *rx_channel,
-			  enum nl80211_bss_scan_width scan_width,
-			  enum cfg80211_bss_frame_type ftype,
-			  const u8 *bssid, u64 tsf, u16 capability,
-			  u16 beacon_interval, const u8 *ie, size_t ielen,
-			  s32 signal, gfp_t gfp)
+struct cfg80211_bss *
+cfg80211_inform_bss_data(struct wiphy *wiphy,
+			 struct cfg80211_inform_bss *data,
+			 enum cfg80211_bss_frame_type ftype,
+			 const u8 *bssid, u64 tsf, u16 capability,
+			 u16 beacon_interval, const u8 *ie, size_t ielen,
+			 gfp_t gfp)
 {
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
@@ -957,19 +957,21 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 		return NULL;
 
 	if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
-			(signal < 0 || signal > 100)))
+		    (data->signal < 0 || data->signal > 100)))
 		return NULL;
 
-	channel = cfg80211_get_bss_channel(wiphy, ie, ielen, rx_channel);
+	channel = cfg80211_get_bss_channel(wiphy, ie, ielen, data->chan);
 	if (!channel)
 		return NULL;
 
 	memcpy(tmp.pub.bssid, bssid, ETH_ALEN);
 	tmp.pub.channel = channel;
-	tmp.pub.scan_width = scan_width;
-	tmp.pub.signal = signal;
+	tmp.pub.scan_width = data->scan_width;
+	tmp.pub.signal = data->signal;
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
+	tmp.ts_boottime = data->boottime_ns;
+
 	/*
 	 * If we do not know here whether the IEs are from a Beacon or Probe
 	 * Response frame, we need to pick one of the options and only use it
@@ -999,7 +1001,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	}
 	rcu_assign_pointer(tmp.pub.ies, ies);
 
-	signal_valid = abs(rx_channel->center_freq - channel->center_freq) <=
+	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
 	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
 	if (!res)
@@ -1019,15 +1021,15 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_inform_bss_width);
+EXPORT_SYMBOL(cfg80211_inform_bss_data);
 
-/* Returned bss is reference counted and must be cleaned up appropriately. */
+/* cfg80211_inform_bss_width_frame helper */
 struct cfg80211_bss *
-cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
-				struct ieee80211_channel *rx_channel,
-				enum nl80211_bss_scan_width scan_width,
-				struct ieee80211_mgmt *mgmt, size_t len,
-				s32 signal, gfp_t gfp)
+cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
+			       struct cfg80211_inform_bss *data,
+			       struct ieee80211_mgmt *mgmt, size_t len,
+			       gfp_t gfp)
+
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
 	struct cfg80211_bss_ies *ies;
@@ -1040,8 +1042,7 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 			offsetof(struct ieee80211_mgmt, u.beacon.variable));
 
-	trace_cfg80211_inform_bss_width_frame(wiphy, rx_channel, scan_width, mgmt,
-					      len, signal);
+	trace_cfg80211_inform_bss_frame(wiphy, data, mgmt, len);
 
 	if (WARN_ON(!mgmt))
 		return NULL;
@@ -1050,14 +1051,14 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 		return NULL;
 
 	if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
-		    (signal < 0 || signal > 100)))
+		    (data->signal < 0 || data->signal > 100)))
 		return NULL;
 
 	if (WARN_ON(len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
 		return NULL;
 
 	channel = cfg80211_get_bss_channel(wiphy, mgmt->u.beacon.variable,
-					   ielen, rx_channel);
+					   ielen, data->chan);
 	if (!channel)
 		return NULL;
 
@@ -1077,12 +1078,13 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	
 	memcpy(tmp.pub.bssid, mgmt->bssid, ETH_ALEN);
 	tmp.pub.channel = channel;
-	tmp.pub.scan_width = scan_width;
-	tmp.pub.signal = signal;
+	tmp.pub.scan_width = data->scan_width;
+	tmp.pub.signal = data->signal;
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
+	tmp.ts_boottime = data->boottime_ns;
 
-	signal_valid = abs(rx_channel->center_freq - channel->center_freq) <=
+	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
 	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
 	if (!res)
@@ -1102,7 +1104,7 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_inform_bss_width_frame);
+EXPORT_SYMBOL(cfg80211_inform_bss_frame_data);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index a808279a432a..0c392d36781b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2670,30 +2670,30 @@ TRACE_EVENT(cfg80211_get_bss,
 		  __entry->privacy)
 );
 
-TRACE_EVENT(cfg80211_inform_bss_width_frame,
-	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
-		 enum nl80211_bss_scan_width scan_width,
-		 struct ieee80211_mgmt *mgmt, size_t len,
-		 s32 signal),
-	TP_ARGS(wiphy, channel, scan_width, mgmt, len, signal),
+TRACE_EVENT(cfg80211_inform_bss_frame,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_inform_bss *data,
+		 struct ieee80211_mgmt *mgmt, size_t len),
+	TP_ARGS(wiphy, data, mgmt, len),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_ENTRY
 		__field(enum nl80211_bss_scan_width, scan_width)
 		__dynamic_array(u8, mgmt, len)
 		__field(s32, signal)
+		__field(u64, ts_boottime)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		CHAN_ASSIGN(channel);
-		__entry->scan_width = scan_width;
+		CHAN_ASSIGN(data->chan);
+		__entry->scan_width = data->scan_width;
 		if (mgmt)
 			memcpy(__get_dynamic_array(mgmt), mgmt, len);
-		__entry->signal = signal;
+		__entry->signal = data->signal;
+		__entry->ts_boottime = data->boottime_ns;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT "(scan_width: %d) signal: %d",
+	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT "(scan_width: %d) signal: %d, tsb:%llu",
 		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->scan_width,
-		  __entry->signal)
+		  __entry->signal, (unsigned long long)__entry->ts_boottime)
 );
 
 DECLARE_EVENT_CLASS(cfg80211_bss_evt,
-- 
2.5.1

