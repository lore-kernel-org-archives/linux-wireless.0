Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbYIOPLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:11:04 -0400
Subject: [PATCH] cfg80211: fix code ordering in header file
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 13:11:19 +0200
Message-Id: <1221477079.3700.41.camel@johannes.berg> (sfid-20080915_171108_263872_F85BE06D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis added the regulatory hint stuff to this file without
observing that __ieee80211_get_channel and ieee80211_get_channel
really belong together.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/wireless.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- everything.orig/include/net/wireless.h	2008-09-15 13:08:18.000000000 +0200
+++ everything/include/net/wireless.h	2008-09-15 13:09:26.000000000 +0200
@@ -329,6 +329,15 @@ extern int ieee80211_frequency_to_channe
 extern struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
 							 int freq);
 /**
+ * ieee80211_get_channel - get channel struct from wiphy for specified frequency
+ */
+static inline struct ieee80211_channel *
+ieee80211_get_channel(struct wiphy *wiphy, int freq)
+{
+	return __ieee80211_get_channel(wiphy, freq);
+}
+
+/**
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if a driver is providing the hint this is the driver's very
  * 	own &struct wiphy
@@ -380,13 +389,4 @@ extern int __regulatory_hint(struct wiph
  */
 extern int regulatory_hint(struct wiphy *wiphy,
 		const char *alpha2, struct ieee80211_regdomain *rd);
-
-/**
- * ieee80211_get_channel - get channel struct from wiphy for specified frequency
- */
-static inline struct ieee80211_channel *
-ieee80211_get_channel(struct wiphy *wiphy, int freq)
-{
-	return __ieee80211_get_channel(wiphy, freq);
-}
 #endif /* __NET_WIRELESS_H */


