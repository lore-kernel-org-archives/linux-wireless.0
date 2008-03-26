Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYCZNPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 09:15:03 -0400
Subject: [PATCH] cfg80211: don't export ieee80211_get_channel
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 14:14:55 +0100
Message-Id: <1206537295.16475.325.camel@johannes.berg> (sfid-20080326_131511_607060_C9705F7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes ieee80211_get_channel a static inline defined in
cfg80211's header file which simply calls __ieee80211_get_channel
to avoid symbol clashes with the ieee80211 code.

The problem was pointed out by David Miller, thanks!

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>
---
 include/net/wireless.h |   18 +++++++++++++++---
 net/wireless/util.c    |    6 +++---
 2 files changed, 18 insertions(+), 6 deletions(-)

--- everything.orig/include/net/wireless.h	2008-03-26 14:07:31.000000000 +0100
+++ everything/include/net/wireless.h	2008-03-26 14:09:12.000000000 +0100
@@ -304,10 +304,22 @@ extern int ieee80211_channel_to_frequenc
  */
 extern int ieee80211_frequency_to_channel(int freq);
 
+/*
+ * Name indirection necessary because the ieee80211 code also has
+ * a function named "ieee80211_get_channel", so if you include
+ * cfg80211's header file you get cfg80211's version, if you try
+ * to include both header files you'll (rightfully!) get a symbol
+ * clash.
+ */
+extern struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
+							 int freq);
+
 /**
  * ieee80211_get_channel - get channel struct from wiphy for specified frequency
  */
-extern struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy,
-						       int freq);
-
+static inline struct ieee80211_channel *
+ieee80211_get_channel(struct wiphy *wiphy, int freq)
+{
+	return __ieee80211_get_channel(wiphy, freq);
+}
 #endif /* __NET_WIRELESS_H */
--- everything.orig/net/wireless/util.c	2008-03-26 14:07:11.000000000 +0100
+++ everything/net/wireless/util.c	2008-03-26 14:07:27.000000000 +0100
@@ -33,8 +33,8 @@ int ieee80211_frequency_to_channel(int f
 }
 EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 
-struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy,
-						int freq)
+struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
+						  int freq)
 {
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -54,7 +54,7 @@ struct ieee80211_channel *ieee80211_get_
 
 	return NULL;
 }
-EXPORT_SYMBOL(ieee80211_get_channel);
+EXPORT_SYMBOL(__ieee80211_get_channel);
 
 static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 				     enum ieee80211_band band)


