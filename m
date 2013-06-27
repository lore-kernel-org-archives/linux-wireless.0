Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45116 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab3F0Mof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:35 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 01/18] nl80211: add scan width to bss and scan request
Date: Thu, 27 Jun 2013 14:44:07 +0200
Message-Id: <1372337064-19254-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144444_984645_71F78360)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To allow scanning and working with 5 MHz and 10 MHz BSS, extend the
inform bss commands and  add wrappers to take 5 and 10 MHz bss into
account.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h       |   54 +++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/nl80211.h |   18 ++++++++++++++
 net/wireless/nl80211.c       |    1 +
 net/wireless/scan.c          |   31 ++++++++++++++----------
 net/wireless/trace.h         |   12 ++++++----
 5 files changed, 97 insertions(+), 19 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e3a39fc..820cce5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1285,6 +1285,7 @@ struct cfg80211_ssid {
  * @n_ssids: number of SSIDs
  * @channels: channels to scan on.
  * @n_channels: total number of channels to scan
+ * @scan_width: channel width for scanning
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
  * @flags: bit field of flags controlling operation
@@ -1300,6 +1301,7 @@ struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
 	int n_ssids;
 	u32 n_channels;
+	enum nl80211_bss_scan_width scan_width;
 	const u8 *ie;
 	size_t ie_len;
 	u32 flags;
@@ -1333,6 +1335,7 @@ struct cfg80211_match_set {
  * @ssids: SSIDs to scan for (passed in the probe_reqs in active scans)
  * @n_ssids: number of SSIDs
  * @n_channels: total number of channels to scan
+ * @scan_width: channel width for scanning
  * @interval: interval between each scheduled scan cycle
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
@@ -1352,6 +1355,7 @@ struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
 	int n_ssids;
 	u32 n_channels;
+	enum nl80211_bss_scan_width scan_width;
 	u32 interval;
 	const u8 *ie;
 	size_t ie_len;
@@ -1403,6 +1407,7 @@ struct cfg80211_bss_ies {
  * for use in scan results and similar.
  *
  * @channel: channel this BSS is on
+ * @scan_width: width of the control channel
  * @bssid: BSSID of the BSS
  * @beacon_interval: the beacon interval as from the frame
  * @capability: the capability field in host byte order
@@ -1424,6 +1429,7 @@ struct cfg80211_bss_ies {
  */
 struct cfg80211_bss {
 	struct ieee80211_channel *channel;
+	enum nl80211_bss_scan_width scan_width;
 
 	const struct cfg80211_bss_ies __rcu *ies;
 	const struct cfg80211_bss_ies __rcu *beacon_ies;
@@ -3379,10 +3385,11 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy);
 void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
 
 /**
- * cfg80211_inform_bss_frame - inform cfg80211 of a received BSS frame
+ * cfg80211_inform_bss_width_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
  * @channel: The channel the frame was received on
+ * @scan_width: width of the control channel
  * @mgmt: the management frame (probe response or beacon)
  * @len: length of the management frame
  * @signal: the signal strength, type depends on the wiphy's signal_type
@@ -3395,16 +3402,29 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
  * Or %NULL on error.
  */
 struct cfg80211_bss * __must_check
+cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
+				struct ieee80211_channel *channel,
+				enum nl80211_bss_scan_width scan_width,
+				struct ieee80211_mgmt *mgmt, size_t len,
+				s32 signal, gfp_t gfp);
+
+static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_channel *channel,
 			  struct ieee80211_mgmt *mgmt, size_t len,
-			  s32 signal, gfp_t gfp);
+			  s32 signal, gfp_t gfp)
+{
+	return cfg80211_inform_bss_width_frame(wiphy, channel,
+					       NL80211_BSS_CHAN_WIDTH_20,
+					       mgmt, len, signal, gfp);
+}
 
 /**
  * cfg80211_inform_bss - inform cfg80211 of a new BSS
  *
  * @wiphy: the wiphy reporting the BSS
  * @channel: The channel the frame was received on
+ * @scan_width: width of the control channel
  * @bssid: the BSSID of the BSS
  * @tsf: the TSF sent by the peer in the beacon/probe response (or 0)
  * @capability: the capability field sent by the peer
@@ -3421,11 +3441,26 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
  * Or %NULL on error.
  */
 struct cfg80211_bss * __must_check
+cfg80211_inform_bss_width(struct wiphy *wiphy,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_bss_scan_width scan_width,
+			  const u8 *bssid, u64 tsf, u16 capability,
+			  u16 beacon_interval, const u8 *ie, size_t ielen,
+			  s32 signal, gfp_t gfp);
+
+static inline struct cfg80211_bss * __must_check
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,
 		    const u8 *bssid, u64 tsf, u16 capability,
 		    u16 beacon_interval, const u8 *ie, size_t ielen,
-		    s32 signal, gfp_t gfp);
+		    s32 signal, gfp_t gfp)
+{
+	return cfg80211_inform_bss_width(wiphy, channel,
+					 NL80211_BSS_CHAN_WIDTH_20,
+					 bssid, tsf, capability,
+					 beacon_interval, ie, ielen, signal,
+					 gfp);
+}
 
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
@@ -3471,6 +3506,19 @@ void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
  */
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
 
+static inline enum nl80211_bss_scan_width
+cfg80211_chandef_to_scan_width(const struct cfg80211_chan_def *chandef)
+{
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+		return NL80211_BSS_CHAN_WIDTH_5;
+	case NL80211_CHAN_WIDTH_10:
+		return NL80211_BSS_CHAN_WIDTH_10;
+	default:
+		return NL80211_BSS_CHAN_WIDTH_20;
+	}
+}
+
 /**
  * cfg80211_rx_mlme_mgmt - notification of processed MLME management frame
  * @dev: network device
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 861e5eb..7f1eabba4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2773,6 +2773,21 @@ enum nl80211_chan_width {
 };
 
 /**
+ * enum nl80211_bss_scan_width - control channel width for a BSS
+ *
+ * These values are used with the %NL80211_BSS_CHAN_WIDTH attribute.
+ *
+ * @NL80211_BSS_CHAN_WIDTH_20: control channel is 20 MHz wide or compatible
+ * @NL80211_BSS_CHAN_WIDTH_10: control channel is 10 MHz wide
+ * @NL80211_BSS_CHAN_WIDTH_5: control channel is 10 MHz wide
+ */
+enum nl80211_bss_scan_width {
+	NL80211_BSS_CHAN_WIDTH_20,
+	NL80211_BSS_CHAN_WIDTH_10,
+	NL80211_BSS_CHAN_WIDTH_5,
+};
+
+/**
  * enum nl80211_bss - netlink attributes for a BSS
  *
  * @__NL80211_BSS_INVALID: invalid
@@ -2796,6 +2811,8 @@ enum nl80211_chan_width {
  * @NL80211_BSS_BEACON_IES: binary attribute containing the raw information
  *	elements from a Beacon frame (bin); not present if no Beacon frame has
  *	yet been received
+ * @NL80211_BSS_CHAN_WIDTH: channel width of the control channel
+ *	(u32, enum nl80211_bss_scan_width)
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -2812,6 +2829,7 @@ enum nl80211_bss {
 	NL80211_BSS_STATUS,
 	NL80211_BSS_SEEN_MS_AGO,
 	NL80211_BSS_BEACON_IES,
+	NL80211_BSS_CHAN_WIDTH,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3b7fb5c..ebd889d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5619,6 +5619,7 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 		goto nla_put_failure;
 	if (nla_put_u16(msg, NL80211_BSS_CAPABILITY, res->capability) ||
 	    nla_put_u32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq) ||
+	    nla_put_u32(msg, NL80211_BSS_CHAN_WIDTH, res->scan_width) ||
 	    nla_put_u32(msg, NL80211_BSS_SEEN_MS_AGO,
 			jiffies_to_msecs(jiffies - intbss->ts)))
 		goto nla_put_failure;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index dd01b58..cbe4d27 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -650,6 +650,8 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 			continue;
 		if (bss->pub.channel != new->pub.channel)
 			continue;
+		if (bss->pub.scan_width != new->pub.scan_width)
+			continue;
 		if (rcu_access_pointer(bss->pub.beacon_ies))
 			continue;
 		ies = rcu_access_pointer(bss->pub.ies);
@@ -867,11 +869,12 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 }
 
 struct cfg80211_bss*
-cfg80211_inform_bss(struct wiphy *wiphy,
-		    struct ieee80211_channel *channel,
-		    const u8 *bssid, u64 tsf, u16 capability,
-		    u16 beacon_interval, const u8 *ie, size_t ielen,
-		    s32 signal, gfp_t gfp)
+cfg80211_inform_bss_width(struct wiphy *wiphy,
+			  struct ieee80211_channel *channel,
+			  enum nl80211_bss_scan_width scan_width,
+			  const u8 *bssid, u64 tsf, u16 capability,
+			  u16 beacon_interval, const u8 *ie, size_t ielen,
+			  s32 signal, gfp_t gfp)
 {
 	struct cfg80211_bss_ies *ies;
 	struct cfg80211_internal_bss tmp = {}, *res;
@@ -889,6 +892,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 
 	memcpy(tmp.pub.bssid, bssid, ETH_ALEN);
 	tmp.pub.channel = channel;
+	tmp.pub.scan_width = scan_width;
 	tmp.pub.signal = signal;
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
@@ -921,13 +925,14 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_inform_bss);
+EXPORT_SYMBOL(cfg80211_inform_bss_width);
 
 struct cfg80211_bss *
-cfg80211_inform_bss_frame(struct wiphy *wiphy,
-			  struct ieee80211_channel *channel,
-			  struct ieee80211_mgmt *mgmt, size_t len,
-			  s32 signal, gfp_t gfp)
+cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
+				struct ieee80211_channel *channel,
+				enum nl80211_bss_scan_width scan_width,
+				struct ieee80211_mgmt *mgmt, size_t len,
+				s32 signal, gfp_t gfp)
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
 	struct cfg80211_bss_ies *ies;
@@ -937,7 +942,8 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 			offsetof(struct ieee80211_mgmt, u.beacon.variable));
 
-	trace_cfg80211_inform_bss_frame(wiphy, channel, mgmt, len, signal);
+	trace_cfg80211_inform_bss_width_frame(wiphy, channel, scan_width, mgmt,
+					      len, signal);
 
 	if (WARN_ON(!mgmt))
 		return NULL;
@@ -972,6 +978,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	
 	memcpy(tmp.pub.bssid, mgmt->bssid, ETH_ALEN);
 	tmp.pub.channel = channel;
+	tmp.pub.scan_width = scan_width;
 	tmp.pub.signal = signal;
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
@@ -987,7 +994,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_inform_bss_frame);
+EXPORT_SYMBOL(cfg80211_inform_bss_width_frame);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index e1534baf..09af6eb 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2391,26 +2391,30 @@ TRACE_EVENT(cfg80211_get_bss,
 		  __entry->capa_mask, __entry->capa_val)
 );
 
-TRACE_EVENT(cfg80211_inform_bss_frame,
+TRACE_EVENT(cfg80211_inform_bss_width_frame,
 	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
+		 enum nl80211_bss_scan_width scan_width,
 		 struct ieee80211_mgmt *mgmt, size_t len,
 		 s32 signal),
-	TP_ARGS(wiphy, channel, mgmt, len, signal),
+	TP_ARGS(wiphy, channel, scan_width, mgmt, len, signal),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_ENTRY
+		__field(enum nl80211_bss_scan_width, scan_width)
 		__dynamic_array(u8, mgmt, len)
 		__field(s32, signal)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		CHAN_ASSIGN(channel);
+		__entry->scan_width = scan_width;
 		if (mgmt)
 			memcpy(__get_dynamic_array(mgmt), mgmt, len);
 		__entry->signal = signal;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT "signal: %d",
-		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->signal)
+	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT "(scan_width: %d) signal: %d",
+		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->scan_width,
+		  __entry->signal)
 );
 
 DECLARE_EVENT_CLASS(cfg80211_bss_evt,
-- 
1.7.10.4

