Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZETHFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 03:05:47 -0400
Subject: [PATCH] mac80211: fix parameter confusion when finding IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 May 2009 09:05:10 +0200
Message-Id: <1242803110.31350.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I fixed the crypto bit I must have done the negative
test only -- it is quite clearly impossible to find _any_
IBSS to join with the parameters put the wrong way around.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-05-20 09:01:07.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-05-20 09:02:02.000000000 +0200
@@ -535,9 +535,9 @@ static void ieee80211_sta_find_ibss(stru
 		bssid = ifibss->bssid;
 	bss = (void *)cfg80211_get_bss(local->hw.wiphy, chan, bssid,
 				       ifibss->ssid, ifibss->ssid_len,
-				       capability,
 				       WLAN_CAPABILITY_IBSS |
-				       WLAN_CAPABILITY_PRIVACY);
+				       WLAN_CAPABILITY_PRIVACY,
+				       capability);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	if (bss)


