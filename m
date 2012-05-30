Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:42441 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab2E3QCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 12:02:23 -0400
Received: by qadb17 with SMTP id b17so2153941qad.12
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 09:02:21 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [PATCH v2 1/2] nl80211/cfg80211: add scan channel times to scan command
Date: Wed, 30 May 2012 18:59:18 +0300
Message-Id: <1338393559-1792-1-git-send-email-victorg@ti.com> (sfid-20120530_180227_708132_99D9E917)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to give the usermode an ability to configure
scan channel times, and as it required for the beacon
reports in the 802.11k standard.

Add to the scan command min/max channel times. Add
min/max passive channel times, since a single scan
can contain both passive and active channels due to
regulatory constraints.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---

v2:
   New NL80211_FEATURE_SCAN_TIMES.
   Move the default scan times from mac to cfg.
   Handle the default scan times also for wext.   

 include/linux/nl80211.h |   25 +++++++++++++++++++++++++
 include/net/cfg80211.h  |   11 +++++++++++
 net/wireless/core.h     |    1 +
 net/wireless/nl80211.c  |   27 ++++++++++++++++++++++++++-
 net/wireless/scan.c     |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2540e86..6bbcdba 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1222,6 +1222,23 @@ enum nl80211_commands {
  * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
  *      or 0 to disable background scan.
  *
+ * @NL80211_ATTR_SCAN_MIN_CH_TIME: Minimum active scan time (in TUs),
+ *	u32 attribute to setup minimum time to wait on each channel, if received
+ *	at least one probe_resp/beacon during this period will continue waiting
+ *	@NL80211_ATTR_SCAN_MAX_CH_TIME, otherwise will move to next channel.
+ * @NL80211_ATTR_SCAN_MAX_CH_TIME: Maximum active scan time (in TUs),
+ *	u32 attribute to setup maximum time to wait on the channel.
+ * @NL80211_ATTR_SCAN_PSV_MIN_CH_TIME: Minimum passive scan time (in TUs),
+ *	u32 attribute (similar to @NL80211_ATTR_SCAN_MIN_CH_TIME).
+ * @NL80211_ATTR_SCAN_PSV_MAX_CH_TIME: Maximum passive scan time (in TUs),
+ *	u32 attribute (similar to @NL80211_ATTR_SCAN_MAX_CH_TIME).
+ *	Note:
+ *	 The above channel time attributes are for the %NL80211_CMD_TRIGGER_SCAN
+ *	 command. The attributes are optional, the driver will use default
+ *	 channel time values if the attribute is not set or set to zero.
+ *	 If one of the min times will be greater than max, -EINVAL will be
+ *	 returned. For the software scan only the min times are relevant.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1473,6 +1490,11 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BG_SCAN_PERIOD,
 
+	NL80211_ATTR_SCAN_MIN_CH_TIME,
+	NL80211_ATTR_SCAN_MAX_CH_TIME,
+	NL80211_ATTR_SCAN_PSV_MIN_CH_TIME,
+	NL80211_ATTR_SCAN_PSV_MAX_CH_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2865,11 +2887,14 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_HT_IBSS: This driver supports IBSS with HT datarates.
  * @NL80211_FEATURE_INACTIVITY_TIMER: This driver takes care of freeing up
  *	the connected inactive stations in AP mode.
+ * @NL80211_FEATURE_SCAN_TIMES: This driver supports min/max scan times
+ *	configuration for the %NL80211_CMD_TRIGGER_SCAN command.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
+	NL80211_FEATURE_SCAN_TIMES	= 1 << 3,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index adb2320..948cf60 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -920,6 +920,12 @@ struct cfg80211_ssid {
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @min_ch_time: minimum time to wait on each channel for active scans
+ * @max_ch_time: maximum time to wait on each channel for active scans
+ * @min_passive_ch_time: minimum time to wait on each channel for passive scans
+ * @max_passive_ch_time: maximum time to wait on each channel for passive scans
+ *  Note: If the above channel times are not set or set to zero, the default
+ *  channel times will be used.
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -936,6 +942,11 @@ struct cfg80211_scan_request {
 	bool aborted;
 	bool no_cck;
 
+	u32 min_ch_time;
+	u32 max_ch_time;
+	u32 min_passive_ch_time;
+	u32 max_passive_ch_time;
+
 	/* keep last */
 	struct ieee80211_channel *channels[0];
 };
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3ac2dd0..de0ed36e 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -416,6 +416,7 @@ void cfg80211_sme_scan_done(struct net_device *dev);
 void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 void cfg80211_sme_disassoc(struct net_device *dev,
 			   struct cfg80211_internal_bss *bss);
+int cfg80211_trigger_scan(struct cfg80211_registered_device *rdev);
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 859bd66..d2307ad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -206,6 +206,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
 	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
+	[NL80211_ATTR_SCAN_MIN_CH_TIME] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_MAX_CH_TIME] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -3884,6 +3888,27 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		       request->ie_len);
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) {
+		request->min_ch_time =
+			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]);
+	}
+	if (info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]) {
+		request->max_ch_time =
+			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]);
+		if (request->min_ch_time > request->max_ch_time)
+			return -EINVAL;
+	}
+	if (info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]) {
+		request->min_passive_ch_time =
+		    nla_get_u32(info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]);
+	}
+	if (info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]) {
+		request->max_passive_ch_time =
+		    nla_get_u32(info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]);
+		if (request->min_passive_ch_time > request->max_passive_ch_time)
+			return -EINVAL;
+	}
+
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 		if (wiphy->bands[i])
 			request->rates[i] =
@@ -3915,7 +3940,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->wiphy = &rdev->wiphy;
 
 	rdev->scan_req = request;
-	err = rdev->ops->scan(&rdev->wiphy, dev, request);
+	err = cfg80211_trigger_scan(rdev);
 
 	if (!err) {
 		nl80211_send_scan_start(rdev, dev);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9dee87c..03b8b3c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -19,6 +19,27 @@
 #include "wext-compat.h"
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
+#define	IEEE80211_CHANNEL_TIME		(HZ / 33)
+#define	IEEE80211_PASSIVE_CHANNEL_TIME	(HZ / 8)
+
+int cfg80211_trigger_scan(struct cfg80211_registered_device *rdev)
+{
+	struct cfg80211_scan_request *request;
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	request = rdev->scan_req;
+
+	if (!request)
+		return -EINVAL;
+
+	if (!request->min_passive_ch_time)
+		request->min_passive_ch_time = IEEE80211_PASSIVE_CHANNEL_TIME;
+	if (!request->min_ch_time)
+		request->min_ch_time = IEEE80211_CHANNEL_TIME;
+
+	return rdev->ops->scan(&rdev->wiphy, request->dev, request);
+}
 
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
@@ -1023,6 +1044,18 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		if (wiphy->bands[i])
 			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
+	if (wreq->min_channel_time) {
+		creq->min_ch_time = wreq->min_channel_time;
+		if (wreq->scan_type == IW_SCAN_TYPE_ACTIVE)
+			creq->min_passive_ch_time =
+				IEEE80211_PASSIVE_CHANNEL_TIME;
+		else
+			creq->min_passive_ch_time = wreq->min_channel_time;
+	} else {
+		creq->min_ch_time = IEEE80211_CHANNEL_TIME;
+		creq->min_passive_ch_time = IEEE80211_PASSIVE_CHANNEL_TIME;
+	}
+
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
 	if (err) {
-- 
1.7.5.4

