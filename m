Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45340 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939139AbeE1Nrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 09:47:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/5] nl80211: add scan features for improved scan privacy
Date: Mon, 28 May 2018 15:47:40 +0200
Message-Id: <20180528134741.10386-5-johannes@sipsolutions.net> (sfid-20180528_154820_913413_D32D75F7)
In-Reply-To: <20180528134741.10386-1-johannes@sipsolutions.net>
References: <20180528134741.10386-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the scan flags for randomized SN and minimized probe request
content for improved scan privacy.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 15 +++++++++++++++
 net/wireless/nl80211.c       |  8 +++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 06f9af23156b..3c06b45f564c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5133,6 +5133,11 @@ enum nl80211_feature_flags {
  *	support to nl80211.
  * @NL80211_EXT_FEATURE_TXQS: Driver supports FQ-CoDel-enabled intermediate
  *      TXQs.
+ * @NL80211_EXT_FEATURE_SCAN_RANDOM_SN: Driver/device supports randomizing the
+ *	SN in probe request frames if requested by %NL80211_SCAN_FLAG_RANDOM_SN.
+ * @NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT: Driver/device can omit all data
+ *	except for supported rates from the probe request content if requested
+ *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5167,6 +5172,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
 	NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT,
 	NL80211_EXT_FEATURE_TXQS,
+	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
+	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -5272,6 +5279,12 @@ enum nl80211_timeout_reason {
  *	possible scan results. This flag hints the driver to use the best
  *	possible scan configuration to improve the accuracy in scanning.
  *	Latency and power use may get impacted with this flag.
+ * @NL80211_SCAN_FLAG_RANDOM_SN: randomize the sequence number in probe
+ *	request frames from this scan to avoid correlation/tracking being
+ *	possible.
+ * @NL80211_SCAN_FLAG_MIN_PREQ_CONTENT: minimize probe request content to
+ *	only have supported rates and no additional capabilities (unless
+ *	added by userspace explicitly.)
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY				= 1<<0,
@@ -5285,6 +5298,8 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_SPAN				= 1<<8,
 	NL80211_SCAN_FLAG_LOW_POWER				= 1<<9,
 	NL80211_SCAN_FLAG_HIGH_ACCURACY				= 1<<10,
+	NL80211_SCAN_FLAG_RANDOM_SN				= 1<<11,
+	NL80211_SCAN_FLAG_MIN_PREQ_CONTENT			= 1<<12,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 384fdad9825d..3af3921e6de9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6925,7 +6925,13 @@ nl80211_check_scan_flags(struct wiphy *wiphy, struct wireless_dev *wdev,
 				     NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION) ||
 	    !nl80211_check_scan_feat(wiphy, *flags,
 				     NL80211_SCAN_FLAG_OCE_PROBE_REQ_HIGH_TX_RATE,
-				     NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE))
+				     NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_RANDOM_SN,
+				     NL80211_EXT_FEATURE_SCAN_RANDOM_SN) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_MIN_PREQ_CONTENT,
+				     NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT))
 		return -EOPNOTSUPP;
 
 	if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
-- 
2.14.3
