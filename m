Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7766 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbcGVJnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 05:43:08 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <ganeshk@qti.qualcomm.com>,
	<mkalikot@qca.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<pkushwah@qti.qualcomm.com>
Subject: [PATCH v3] cfg80211: Allow different beacon interval if driver supports
Date: Fri, 22 Jul 2016 15:12:37 +0530
Message-ID: <1469180557-24210-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160722_114311_757864_1DD842C1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver may allow support for different beacon interval on virtual interfaces.
Allow if such support is advertised by driver. This adds new ext_feature as
NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/util.c          | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..a910d0e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4551,6 +4551,8 @@ enum nl80211_feature_flags {
  *	(if available).
  * @NL80211_EXT_FEATURE_SET_SCAN_DWELL: This driver supports configuration of
  *	channel dwell time.
+ * @NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL: This driver supports different
+ *	beacon interval on virtual interfaces.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4562,6 +4564,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_START_TIME,
 	NL80211_EXT_FEATURE_BSS_PARENT_TSF,
 	NL80211_EXT_FEATURE_SET_SCAN_DWELL,
+	NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2443ee3..65eeb23 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1560,6 +1560,10 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	if (!beacon_int)
 		return -EINVAL;
 
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL))
+		return 0;
+
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
-- 
1.9.1

