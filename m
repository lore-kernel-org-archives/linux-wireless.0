Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaICMcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/10] nl80211: Allow declaring RRM-related features
Date: Wed,  3 Sep 2014 15:25:00 +0300
Message-Id: <1409747106-30717-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143252_912264_7DBDEEEF)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Radio Resource Measurement (RRM) is a bundle of features which will
require the entire stack to participate.
In this patch, the driver is given the opportunity to advertise the
device's support for these RRM-related features, using feature flags:
1. Support for Quiet IEs.
2. Support for adding DS Parameter Set IE to probe requests.
3. Support for adding WFA TPC Report IE to probe requests.
4. Support for inserting tx power value to tx-ed packets at a fixed
   offset. This is used in action frames, such as RRM's Link
   Measurement Report, where the actual tx power should be reported
   in the frame.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/uapi/linux/nl80211.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f1db15b..375225f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3956,6 +3956,16 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE: This driver supports dynamic
  *	channel bandwidth change (e.g., HT 20 <-> 40 MHz channel) during the
  *	lifetime of a BSS.
+ * @NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES: This device adds a DS Parameter
+ *	Set IE to probe requests.
+ * @NL80211_FEATURE_WFA_TPC_IE_IN_PROBES: This device adds a WFA TPC Report IE
+ *	to probe requests.
+ * @NL80211_FEATURE_QUIET: This device, in client mode, supports Quiet Period
+ *	requests sent to it by an AP.
+ * @NL80211_FEATURE_TX_POWER_INSERTION: This device is capable of inserting the
+ *	current tx power value into the TPC Report IE in the spectrum
+ *	management TPC Report action frame, and in the Radio Measurement Link
+ *	Measurement Report action frame.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3977,6 +3987,10 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
 	NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE	= 1 << 18,
+	NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES	= 1 << 19,
+	NL80211_FEATURE_WFA_TPC_IE_IN_PROBES		= 1 << 20,
+	NL80211_FEATURE_QUIET				= 1 << 21,
+	NL80211_FEATURE_TX_POWER_INSERTION		= 1 << 22,
 };
 
 /**
-- 
1.9.1

