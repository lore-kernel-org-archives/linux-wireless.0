Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZHUKX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 06:23:56 -0400
Subject: [PATCH] cfg80211: make spurious warnings less likely, configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 12:23:49 +0200
Message-Id: <1250850229.17888.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob reported that he got warnings in IBSS mode about
the ssid_len being zero on a joined event, but only
when kmemcheck was enabled. This appears to be due
to a race condition between drivers and userspace,
when the driver reports joined but the user in the
meantime decided to leave the IBSS again, the warning
would trigger. This was made more likely by kmemcheck
delaying the code that does the check and sends the
event.

So first, make the warning trigger closer to the
driver, which means it's not locked, but since only
the warning depends on it that's ok.

And secondly, users will not want to have spurious
warnings at all, so make those that are known to be
racy in such a way configurable.

Reported-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/Kconfig |   17 +++++++++++++++++
 net/wireless/core.h  |   11 +++++++++++
 net/wireless/ibss.c  |    4 +++-
 net/wireless/sme.c   |   12 +++++++++---
 4 files changed, 40 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-08-21 12:12:03.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-21 12:17:38.000000000 +0200
@@ -351,7 +351,7 @@ void __cfg80211_connect_result(struct ne
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
-	if (WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTING))
+	if (wdev->sme_state != CFG80211_SME_CONNECTING)
 		return;
 
 	nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
@@ -443,6 +443,8 @@ void cfg80211_connect_result(struct net_
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
+	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTING);
+
 	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
 	if (!ev)
 		return;
@@ -478,7 +480,7 @@ void __cfg80211_roamed(struct wireless_d
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
-	if (WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED))
+	if (wdev->sme_state != CFG80211_SME_CONNECTED)
 		return;
 
 	/* internal error -- how did we get to CONNECTED w/o BSS? */
@@ -537,6 +539,8 @@ void cfg80211_roamed(struct net_device *
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
+	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
+
 	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
 	if (!ev)
 		return;
@@ -572,7 +576,7 @@ void __cfg80211_disconnected(struct net_
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
-	if (WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED))
+	if (wdev->sme_state != CFG80211_SME_CONNECTED)
 		return;
 
 	if (wdev->current_bss) {
@@ -636,6 +640,8 @@ void cfg80211_disconnected(struct net_de
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
+	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
+
 	ev = kzalloc(sizeof(*ev) + ie_len, gfp);
 	if (!ev)
 		return;
--- wireless-testing.orig/net/wireless/ibss.c	2009-08-21 12:12:03.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-08-21 12:17:30.000000000 +0200
@@ -22,7 +22,7 @@ void __cfg80211_ibss_joined(struct net_d
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
 		return;
 
-	if (WARN_ON(!wdev->ssid_len))
+	if (!wdev->ssid_len)
 		return;
 
 	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
@@ -58,6 +58,8 @@ void cfg80211_ibss_joined(struct net_dev
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
+	CFG80211_DEV_WARN_ON(!wdev->ssid_len);
+
 	ev = kzalloc(sizeof(*ev), gfp);
 	if (!ev)
 		return;
--- wireless-testing.orig/net/wireless/Kconfig	2009-08-21 12:12:19.000000000 +0200
+++ wireless-testing/net/wireless/Kconfig	2009-08-21 12:14:31.000000000 +0200
@@ -17,6 +17,23 @@ config NL80211_TESTMODE
 
 	  Say N.
 
+config CFG80211_DEVELOPER_WARNINGS
+	bool "enable developer warnings"
+	depends on CFG80211
+	default n
+	help
+	  This option enables some additional warnings that help
+	  cfg80211 developers and driver developers, but that can
+	  trigger due to races with userspace.
+
+	  For example, when a driver reports that it was disconnected
+	  from the AP, but the user disconnects manually at the same
+	  time, the warning might trigger spuriously due to races.
+
+	  Say Y only if you are developing cfg80211 or a driver based
+	  on it (or mac80211).
+
+
 config CFG80211_REG_DEBUG
 	bool "cfg80211 regulatory debugging"
 	depends on CFG80211
--- wireless-testing.orig/net/wireless/core.h	2009-08-21 12:14:41.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-21 12:17:02.000000000 +0200
@@ -380,4 +380,15 @@ int rdev_set_freq(struct cfg80211_regist
 		  struct wireless_dev *for_wdev,
 		  int freq, enum nl80211_channel_type channel_type);
 
+#ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
+#define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
+#else
+/*
+ * Trick to enable using it as a condition,
+ * and also not give a warning when it's
+ * not used that way.
+ */
+#define CFG80211_DEV_WARN_ON(cond)	({bool __r = (cond); __r; })
+#endif
+
 #endif /* __NET_WIRELESS_CORE_H */


