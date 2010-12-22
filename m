Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0LVJPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 04:15:15 -0500
Subject: [PATCH] mac80211: cleanup select_queue
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 10:15:30 +0100
Message-ID: <1293009330.3531.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a redundant rcu_read_lock/unlock pair, a
redundant variable, and a few redundant accesses
to the 1d_to_ac array. Fix this to make the code
neater and easier to follow.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wme.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/mac80211/wme.c	2010-12-22 09:54:06.000000000 +0100
+++ wireless-testing/net/mac80211/wme.c	2010-12-22 10:00:12.000000000 +0100
@@ -59,26 +59,22 @@ u16 ieee80211_select_queue(struct ieee80
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta = NULL;
-	u32 sta_flags = 0;
 	const u8 *ra = NULL;
 	bool qos = false;
 
 	if (local->hw.queues < 4 || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
-		return min_t(u16, local->hw.queues - 1,
-			     ieee802_1d_to_ac[skb->priority]);
+		return min_t(u16, local->hw.queues - 1, IEEE80211_AC_BE);
 	}
 
 	rcu_read_lock();
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
-		rcu_read_lock();
 		sta = rcu_dereference(sdata->u.vlan.sta);
-		if (sta)
-			sta_flags = get_sta_flags(sta);
-		rcu_read_unlock();
-		if (sta)
+		if (sta) {
+			qos = get_sta_flags(sta) & WLAN_STA_WME;
 			break;
+		}
 	case NL80211_IFTYPE_AP:
 		ra = skb->data;
 		break;
@@ -107,17 +103,13 @@ u16 ieee80211_select_queue(struct ieee80
 	if (!sta && ra && !is_multicast_ether_addr(ra)) {
 		sta = sta_info_get(sdata, ra);
 		if (sta)
-			sta_flags = get_sta_flags(sta);
+			qos = get_sta_flags(sta) & WLAN_STA_WME;
 	}
-
-	if (sta_flags & WLAN_STA_WME)
-		qos = true;
-
 	rcu_read_unlock();
 
 	if (!qos) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
-		return ieee802_1d_to_ac[skb->priority];
+		return IEEE80211_AC_BE;
 	}
 
 	/* use the data classifier to determine what 802.1d tag the


