Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:34026 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754094Ab2FTHhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:37:08 -0400
Received: by obbwd18 with SMTP id wd18so7491208obb.7
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 00:37:06 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>, <eliad@wizery.com>
Subject: [PATCH v3 1/2] nl80211/cfg80211: add scan channel times to scan command
Date: Wed, 20 Jun 2012 10:33:53 +0300
Message-Id: <1340177634-24568-1-git-send-email-victorg@ti.com> (sfid-20120620_093713_567632_FEB8BD8D)
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

v3:
	Redefine default scan times in milliseconds instead of jiffies.
	New ieee80211_msec_to_tu() helper function.

 include/linux/ieee80211.h |    9 +++++++++
 include/linux/nl80211.h   |   26 ++++++++++++++++++++++++++
 include/net/cfg80211.h    |   11 +++++++++++
 net/wireless/core.h       |    1 +
 net/wireless/nl80211.c    |   31 ++++++++++++++++++++++++++++++-
 net/wireless/scan.c       |   38 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 115 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce9af89..9522b7e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1856,6 +1856,15 @@ static inline unsigned long ieee80211_tu_to_usec(unsigned long tu)
 }
 
 /**
+ * ieee80211_msec_to_tu - convert milliseconds to time units (TU)
+ * @msec: the milliseconds
+ */
+static inline unsigned long ieee80211_msec_to_tu(unsigned long msec)
+{
+	return msec * 1000 / 1024;
+}
+
+/**
  * ieee80211_check_tim - check if AID bit is set in TIM
  * @tim: the TIM IE
  * @tim_len: length of the TIM IE
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a6959f7..10d517b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1222,6 +1222,24 @@ enum nl80211_commands {
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
+ *	 channel time values if the attribute is not set.
+ *	 If one of the min times will be greater than max or set to zero,
+ *	 -EINVAL will be returned. For the software scan only the min times
+ *	 are relevant.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1473,6 +1491,11 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BG_SCAN_PERIOD,
 
+	NL80211_ATTR_SCAN_MIN_CH_TIME,
+	NL80211_ATTR_SCAN_MAX_CH_TIME,
+	NL80211_ATTR_SCAN_PSV_MIN_CH_TIME,
+	NL80211_ATTR_SCAN_PSV_MAX_CH_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2867,11 +2890,14 @@ enum nl80211_ap_sme_features {
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
index 0289d4c..56fd3d9 100644
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
+ *  Note: If the above channel times are not set, the default channel times
+ *  will be used. The channel times are in TUs.
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
index 8523f38..04e2cd1 100644
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
index 206465d..5058395 100644
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
@@ -3964,6 +3968,31 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		       request->ie_len);
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) {
+		request->min_ch_time =
+			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]);
+		if (!request->min_ch_time)
+			return -EINVAL;
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
+		if (!request->min_passive_ch_time)
+			return -EINVAL;
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
@@ -3995,7 +4024,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->wiphy = &rdev->wiphy;
 
 	rdev->scan_req = request;
-	err = rdev->ops->scan(&rdev->wiphy, dev, request);
+	err = cfg80211_trigger_scan(rdev);
 
 	if (!err) {
 		nl80211_send_scan_start(rdev, dev);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index af2b1ca..45edd68 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -20,6 +20,30 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
+#define IEEE80211_CH_TIME_MSEC		30
+#define IEEE80211_PSV_CH_TIME_MSEC	125
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
+		request->min_passive_ch_time =
+		      ieee80211_msec_to_tu(IEEE80211_PSV_CH_TIME_MSEC);
+	if (!request->min_ch_time)
+		request->min_ch_time =
+			ieee80211_msec_to_tu(IEEE80211_CH_TIME_MSEC);
+
+	return rdev->ops->scan(&rdev->wiphy, request->dev, request);
+}
+
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
@@ -1023,6 +1047,20 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		if (wiphy->bands[i])
 			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
+	if (wreq->min_channel_time) {
+		creq->min_ch_time = wreq->min_channel_time;
+		if (wreq->scan_type == IW_SCAN_TYPE_ACTIVE)
+			creq->min_passive_ch_time =
+			       ieee80211_msec_to_tu(IEEE80211_PSV_CH_TIME_MSEC);
+		else
+			creq->min_passive_ch_time = wreq->min_channel_time;
+	} else {
+		creq->min_ch_time =
+			ieee80211_msec_to_tu(IEEE80211_CH_TIME_MSEC);
+		creq->min_passive_ch_time =
+			ieee80211_msec_to_tu(IEEE80211_PSV_CH_TIME_MSEC);
+	}
+
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
 	if (err) {
-- 
1.7.5.4

