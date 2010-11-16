Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab0KPTs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 14:48:27 -0500
Subject: [PATCH] mac80211: defines for AC numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 11:49:58 -0800
Message-ID: <1289936998.3673.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In many places we've just hardcoded the
AC numbers -- which is a relic from the
original mac80211 (d80211). Add constants
for them so we know what we're talking
about.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   14 ++++++++++++++
 net/mac80211/wme.c     |   11 ++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-11-12 13:34:33.000000000 -0800
+++ wireless-testing/include/net/mac80211.h	2010-11-12 13:34:42.000000000 -0800
@@ -97,6 +97,20 @@ enum ieee80211_max_queues {
 };
 
 /**
+ * enum ieee80211_ac_numbers - AC numbers as used in mac80211
+ * @IEEE80211_AC_VO: voice
+ * @IEEE80211_AC_VI: video
+ * @IEEE80211_AC_BE: best effort
+ * @IEEE80211_AC_BK: background
+ */
+enum ieee80211_ac_numbers {
+	IEEE80211_AC_VO		= 0,
+	IEEE80211_AC_VI		= 1,
+	IEEE80211_AC_BE		= 2,
+	IEEE80211_AC_BK		= 3,
+};
+
+/**
  * struct ieee80211_tx_queue_params - transmit queue configuration
  *
  * The information provided in this structure is required for QoS
--- wireless-testing.orig/net/mac80211/wme.c	2010-11-12 13:34:33.000000000 -0800
+++ wireless-testing/net/mac80211/wme.c	2010-11-12 13:34:42.000000000 -0800
@@ -21,7 +21,16 @@
 /* Default mapping in classifier to work with default
  * queue setup.
  */
-const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
+const int ieee802_1d_to_ac[8] = {
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VO
+};
 
 static int wme_downgrade_ac(struct sk_buff *skb)
 {


