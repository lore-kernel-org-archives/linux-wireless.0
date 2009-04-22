Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbZDVKkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 06:40:40 -0400
Subject: [PATCH] mac80211: remove IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 12:40:07 +0200
Message-Id: <1240396807.21978.4.camel@johannes.local> (sfid-20090422_124044_329409_C80C76A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just setting IEEE80211_CONF_CHANGE_PS should be sufficient
for changes in the power saving things. The driver already
tells us whether it wants notification of dynps via the
"have dynps support" hw flag.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   10 ++++------
 net/mac80211/wext.c    |    3 +--
 2 files changed, 5 insertions(+), 8 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-04-21 23:35:30.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-21 23:37:27.000000000 +0200
@@ -532,8 +532,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_BEACON_INTERVAL: the beacon interval changed
  * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
  * @IEEE80211_CONF_CHANGE_RADIOTAP: the radiotap flag changed
- * @IEEE80211_CONF_CHANGE_PS: the PS flag changed
- * @IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT: the dynamic PS timeout changed
+ * @IEEE80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
  * @IEEE80211_CONF_CHANGE_POWER: the TX power changed
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
@@ -544,10 +543,9 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
 	IEEE80211_CONF_CHANGE_RADIOTAP		= BIT(3),
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
-	IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT	= BIT(5),
-	IEEE80211_CONF_CHANGE_POWER		= BIT(6),
-	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(7),
-	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(8),
+	IEEE80211_CONF_CHANGE_POWER		= BIT(5),
+	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
+	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/wext.c	2009-04-21 23:35:29.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-21 23:37:27.000000000 +0200
@@ -622,8 +622,7 @@ static int ieee80211_ioctl_siwpower(stru
 	conf->dynamic_ps_timeout = timeout;
 
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
-		ieee80211_hw_config(local,
-				    IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT);
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 
 	ieee80211_recalc_ps(local, -1);
 


