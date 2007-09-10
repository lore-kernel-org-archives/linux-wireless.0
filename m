Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbXIJMJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 08:09:58 -0400
Subject: [PATCH] mac80211: fix vlan bug
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 10 Sep 2007 14:11:07 +0200
Message-Id: <1189426267.4506.84.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VLAN interfaces have yet another bug: they aren't accounted
for properly in the receive path in prepare_for_handlers().
I noticed this by code inspection, but it would be easy for
the compiler to catch such things if we'd just use the proper
enum where appropriate, so do that as well and fix the
resulting warnings.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c       |    7 +++++++
 net/mac80211/ieee80211_i.h     |    2 +-
 net/mac80211/ieee80211_iface.c |    4 ++++
 net/mac80211/rx.c              |    8 ++++++++
 4 files changed, 20 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-10 09:32:40.657221788 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-10 09:33:16.327222981 +0200
@@ -433,6 +433,13 @@ static int ieee80211_open(struct net_dev
 		if (!sdata->u.vlan.ap)
 			return -ENOLINK;
 		break;
+	case IEEE80211_IF_TYPE_AP:
+	case IEEE80211_IF_TYPE_MGMT:
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_MNTR:
+	case IEEE80211_IF_TYPE_IBSS:
+		/* no special treatment */
+		break;
 	}
 
 	if (local->open_count == 0) {
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-10 09:32:00.247260742 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-10 09:32:12.927214789 +0200
@@ -327,7 +327,7 @@ struct ieee80211_if_sta {
 #define IEEE80211_SDATA_SHORT_PREAMBLE	BIT(3)
 struct ieee80211_sub_if_data {
 	struct list_head list;
-	unsigned int type;
+	enum ieee80211_if_types type;
 
 	struct wireless_dev wdev;
 
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-10 09:33:24.907223470 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-10 09:33:44.197221951 +0200
@@ -237,6 +237,10 @@ void ieee80211_if_reinit(struct net_devi
 	ieee80211_if_sdata_deinit(sdata);
 
 	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_MGMT:
+		/* should never get here */
+		WARN_ON(1);
+		break;
 	case IEEE80211_IF_TYPE_AP: {
 		/* Remove all virtual interfaces that use this BSS
 		 * as their sdata->bss */
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-10 09:33:53.277222711 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-10 09:34:43.067218913 +0200
@@ -1468,6 +1468,7 @@ static int prepare_for_handlers(struct i
 			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
 							 bssid, hdr->addr2);
 		break;
+	case IEEE80211_IF_TYPE_VLAN:
 	case IEEE80211_IF_TYPE_AP:
 		if (!bssid) {
 			if (compare_ether_addr(sdata->dev->dev_addr,
@@ -1492,6 +1493,13 @@ static int prepare_for_handlers(struct i
 		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
 		break;
+	case IEEE80211_IF_TYPE_MNTR:
+		/* take everything */
+		break;
+	case IEEE80211_IF_TYPE_MGMT:
+		/* should never get here */
+		WARN_ON(1);
+		break;
 	}
 
 	return 1;


