Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab2HAPVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 6/8] cfg80211: add ieee80211_operating_class_to_band
Date: Wed,  1 Aug 2012 17:21:25 +0200
Message-Id: <1343834487-23737-7-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172153_499393_C55084A0)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function converts a (global only!) operating
class to an internal band identifier. This will
be needed for extended channel switch support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |   11 +++++++++++
 net/wireless/util.c    |   20 ++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 493fa0c..700232b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3520,6 +3520,17 @@ bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
 			       enum nl80211_channel_type type);
 
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
  * cfg80211_calculate_bitrate - calculate actual bitrate (in 100Kbps units)
  * @rate: given rate_info to calculate bitrate from
diff --git a/net/wireless/util.c b/net/wireless/util.c
index ce393dd..14d3c5e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -971,6 +971,26 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 }
 EXPORT_SYMBOL(cfg80211_calculate_bitrate);
 
+bool ieee80211_operating_class_to_band(u8 operating_class,
+				       enum ieee80211_band *band)
+{
+	switch (operating_class) {
+	case 112:
+	case 113:
+	case 115 ... 127:
+		*band = IEEE80211_BAND_5GHZ;
+		return true;
+	
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
1.7.10.4

