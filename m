Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYCPRgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2008 13:36:09 -0400
Subject: [PATCH] wireless: add wiphy channel freq to channel struct lookup
	helper
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 16 Mar 2008 18:34:33 +0100
Message-Id: <1205688873.3878.2.camel@johannes.berg> (sfid-20080316_173614_993026_EE9F1D27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ieee80211_get_channel() which gets you a channel struct for a
specific wiphy if that channel is present in that wiphy.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/wireless.h |    6 ++++++
 net/wireless/util.c    |   23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

--- everything.orig/include/net/wireless.h	2008-03-16 18:17:35.000000000 +0100
+++ everything/include/net/wireless.h	2008-03-16 18:18:48.000000000 +0100
@@ -304,4 +304,10 @@ extern int ieee80211_channel_to_frequenc
  */
 extern int ieee80211_frequency_to_channel(int freq);
 
+/**
+ * ieee80211_get_channel - get channel struct from wiphy for specified frequency
+ */
+extern struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy,
+						       int freq);
+
 #endif /* __NET_WIRELESS_H */
--- everything.orig/net/wireless/util.c	2008-03-16 18:18:52.000000000 +0100
+++ everything/net/wireless/util.c	2008-03-16 18:23:02.000000000 +0100
@@ -33,6 +33,29 @@ int ieee80211_frequency_to_channel(int f
 }
 EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 
+struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy,
+						int freq)
+{
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	int i;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wiphy->bands[band];
+
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_channels; i++) {
+			if (sband->channels[i].center_freq == freq)
+				return &sband->channels[i];
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(ieee80211_get_channel);
+
 static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 				     enum ieee80211_band band)
 {


