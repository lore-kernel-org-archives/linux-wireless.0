Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935649Ab3DJMnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:43:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/8] cfg80211: add ieee80211_operating_class_to_band
Date: Wed, 10 Apr 2013 14:43:37 +0200
Message-Id: <1365597822-27660-4-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144354_704055_61CF5A3E)
In-Reply-To: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
References: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function converts a (global only!) operating
class to an internal band identifier. This will
be needed for extended channel switch support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 11 +++++++++++
 net/wireless/util.c    | 20 ++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 57870b6..dff96d8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4024,6 +4024,17 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 void cfg80211_ch_switch_notify(struct net_device *dev,
 			       struct cfg80211_chan_def *chandef);
 
+/**
+ * ieee80211_operating_class_to_band - convert operating class to band
+ *
+ * @operating_class: the operating class to convert
+ * @band: band pointer to fill
+ *
+ * Returns %true if the conversion was successful, %false otherwise.
+ */
+bool ieee80211_operating_class_to_band(u8 operating_class,
+				       enum ieee80211_band *band);
+
 /*
  * cfg80211_tdls_oper_request - request userspace to perform TDLS operation
  * @dev: the device on which the operation is requested
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 37a56ee..3d8a133 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1155,6 +1155,26 @@ int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
 }
 EXPORT_SYMBOL(cfg80211_get_p2p_attr);
 
+bool ieee80211_operating_class_to_band(u8 operating_class,
+				       enum ieee80211_band *band)
+{
+	switch (operating_class) {
+	case 112:
+	case 115 ... 127:
+		*band = IEEE80211_BAND_5GHZ;
+		return true;
+	case 81:
+	case 82:
+	case 83:
+	case 84:
+		*band = IEEE80211_BAND_2GHZ;
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(ieee80211_operating_class_to_band);
+
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int)
 {
-- 
1.8.0

