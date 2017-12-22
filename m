Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41302 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbdLVQef (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 11:34:35 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Sunil Dutt <usdutt@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 3/3] nl80211: Introduce scan flags to emphasize requested scan behavior
Date: Fri, 22 Dec 2017 18:33:39 +0200
Message-ID: <1513960419-24780-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20171222_173438_131853_C96E0BF9)
In-Reply-To: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
References: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sunil Dutt <usdutt@qti.qualcomm.com>

This commit defines new scan flags (LOW_SPAN, LOW_POWER, HIGH_LATENCY)
to emphasize the requested scan behavior for the driver. These flags are
optional and are mutually exclusive. The implementation of the
respective functionality can be driver/hardware specific.

These flags can be used to control the compromise between how long a
scan takes, how much power it uses, and high accurate/complete the scan
is in finding the BSSs.

Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 28 +++++++++++++++++++++++++++-
 net/wireless/nl80211.c       | 13 +++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

v2:
- added driver capability flags to indicate which of the options are
  supported
- added to this patch series due to a new dependency in one of the
  header files

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 083c6c1..56e6bc0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4979,6 +4979,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_MFP_OPTIONAL: Driver supports the %NL80211_MFP_OPTIONAL
  *	value in %NL80211_ATTR_USE_MFP.
  * @NL80211_EXT_FEATURE_EXTERNAL_AUTH: Driver supports external authentication
+ * @NL80211_EXT_FEATURE_LOW_SPAN_SCAN: Driver supports low span scan.
+ * @NL80211_EXT_FEATURE_LOW_POWER_SCAN: Driver supports low power scan.
+ * @NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN: Driver supports high accuracy scan.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5007,6 +5010,9 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
 	NL80211_EXT_FEATURE_MFP_OPTIONAL,
 	NL80211_EXT_FEATURE_EXTERNAL_AUTH,
+	NL80211_EXT_FEATURE_LOW_SPAN_SCAN,
+	NL80211_EXT_FEATURE_LOW_POWER_SCAN,
+	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -5067,6 +5073,10 @@ enum nl80211_timeout_reason {
  * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
  * requests.
  *
+ * NL80211_SCAN_FLAG_LOW_SPAN, NL80211_SCAN_FLAG_LOW_POWER, and
+ * NL80211_SCAN_FLAG_HIGH_ACCURACY flags are exclusive of each other, i.e., only
+ * one of them can be used in the request.
+ *
  * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
  * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
  * @NL80211_SCAN_FLAG_AP: force a scan even if the interface is configured
@@ -5094,7 +5104,20 @@ enum nl80211_timeout_reason {
  *	and suppression (if it has received a broadcast Probe Response frame,
  *	Beacon frame or FILS Discovery frame from an AP that the STA considers
  *	a suitable candidate for (re-)association - suitable in terms of
- *	SSID and/or RSSI
+ *	SSID and/or RSSI.
+ * @NL80211_SCAN_FLAG_LOW_SPAN: Span corresponds to the total time taken to
+ *	accomplish the scan. Thus, this flag intends the driver to perform the
+ *	scan request with lesser span/duration. It is specific to the driver
+ *	implementations on how this is accomplished. Scan accuracy may get
+ *	impacted with this flag.
+ * @NL80211_SCAN_FLAG_LOW_POWER: This flag intends the scan attempts to consume
+ *	optimal possible power. Drivers can resort to their specific means to
+ *	optimize the power. Scan accuracy may get impacted with this flag.
+ * @NL80211_SCAN_FLAG_HIGH_ACCURACY: Accuracy here intends to the extent of scan
+ *	results obtained. Thus HIGH_ACCURACY scan flag aims to get maximum
+ *	possible scan results. This flag hints the driver to use the best
+ *	possible scan configuration to improve the accuracy in scanning.
+ *	Latency and power use may get impacted with this flag.
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY				= 1<<0,
@@ -5105,6 +5128,9 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_ACCEPT_BCAST_PROBE_RESP		= 1<<5,
 	NL80211_SCAN_FLAG_OCE_PROBE_REQ_HIGH_TX_RATE		= 1<<6,
 	NL80211_SCAN_FLAG_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION	= 1<<7,
+	NL80211_SCAN_FLAG_LOW_SPAN				= 1<<8,
+	NL80211_SCAN_FLAG_LOW_POWER				= 1<<9,
+	NL80211_SCAN_FLAG_HIGH_ACCURACY				= 1<<10,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ea36514..8a53e6e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6712,8 +6712,17 @@ nl80211_check_scan_flags(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	*flags = nla_get_u32(attrs[NL80211_ATTR_SCAN_FLAGS]);
 
-	if ((*flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
-	    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN))
+	if (((*flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+	     !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) ||
+	    ((*flags & NL80211_SCAN_FLAG_LOW_SPAN) &&
+	     !wiphy_ext_feature_isset(wiphy,
+				      NL80211_EXT_FEATURE_LOW_SPAN_SCAN)) ||
+	    ((*flags & NL80211_SCAN_FLAG_LOW_POWER) &&
+	     !wiphy_ext_feature_isset(wiphy,
+				      NL80211_EXT_FEATURE_LOW_POWER_SCAN)) ||
+	    ((*flags & NL80211_SCAN_FLAG_HIGH_ACCURACY) &&
+	     !wiphy_ext_feature_isset(wiphy,
+				      NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN)))
 		return -EOPNOTSUPP;
 
 	if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
-- 
2.7.4
