Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZELSsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 14:48:06 -0400
Subject: [PATCH] mac80211: don't connect to IBSS network with different
 privacy
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Tue, 12 May 2009 20:47:32 +0200
Message-Id: <1242154053.14227.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even when we find an IBSS with the SSID we're looking for, we
may not be able to connect to it because it has a key and we
don't, or vice versa. Avoid such situations by checking the
privacy capability bit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-05-12 20:37:52.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-05-12 20:40:19.000000000 +0200
@@ -499,6 +499,7 @@ static void ieee80211_sta_find_ibss(stru
 	struct ieee80211_channel *chan = NULL;
 	const u8 *bssid = NULL;
 	int active_ibss;
+	u16 capability;
 
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
@@ -509,6 +510,10 @@ static void ieee80211_sta_find_ibss(stru
 	if (active_ibss)
 		return;
 
+	capability = WLAN_CAPABILITY_IBSS;
+	if (sdata->default_key)
+		capability |= WLAN_CAPABILITY_PRIVACY;
+
 	if (ifibss->fixed_bssid)
 		bssid = ifibss->bssid;
 	if (ifibss->fixed_channel)
@@ -517,8 +522,9 @@ static void ieee80211_sta_find_ibss(stru
 		bssid = ifibss->bssid;
 	bss = (void *)cfg80211_get_bss(local->hw.wiphy, chan, bssid,
 				       ifibss->ssid, ifibss->ssid_len,
-				       WLAN_CAPABILITY_IBSS,
-				       WLAN_CAPABILITY_IBSS);
+				       capability,
+				       WLAN_CAPABILITY_IBSS |
+				       WLAN_CAPABILITY_PRIVACY);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	if (bss)


