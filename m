Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbXIZNYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:30 -0400
Message-Id: <20070926132133.194911000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 05/12] mac80211: fix vlan bug
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VLAN interfaces have yet another bug: they aren't accounted
for properly in the receive path in prepare_for_handlers().
I noticed this by code inspection, but it would be easy for
the compiler to catch such things if we'd just use the proper
enum where appropriate.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c       |    7 +++++++
 net/mac80211/ieee80211_i.h     |    2 +-
 net/mac80211/ieee80211_iface.c |    3 +++
 net/mac80211/rx.c              |    8 ++++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-25 23:28:21.581572375 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-25 23:29:36.561571777 +0200
@@ -345,6 +345,13 @@ static int ieee80211_open(struct net_dev
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
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-25 23:28:21.631571018 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-25 23:29:36.561571777 +0200
@@ -290,7 +290,7 @@ struct ieee80211_if_sta {
 #define IEEE80211_SDATA_SHORT_PREAMBLE	BIT(3)
 struct ieee80211_sub_if_data {
 	struct list_head list;
-	unsigned int type;
+	enum ieee80211_if_types type;
 
 	struct wireless_dev wdev;
 
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-25 23:28:21.651570910 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-25 23:29:36.571573405 +0200
@@ -239,6 +239,9 @@ void ieee80211_if_reinit(struct net_devi
 	ieee80211_if_sdata_deinit(sdata);
 
 	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_MGMT:
+		/* nothing to do */
+		break;
 	case IEEE80211_IF_TYPE_AP: {
 		/* Remove all virtual interfaces that use this BSS
 		 * as their sdata->bss */
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-25 23:29:34.131604926 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-25 23:29:36.571573405 +0200
@@ -1425,6 +1425,7 @@ static int prepare_for_handlers(struct i
 			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
 							 bssid, hdr->addr2);
 		break;
+	case IEEE80211_IF_TYPE_VLAN:
 	case IEEE80211_IF_TYPE_AP:
 		if (!bssid) {
 			if (compare_ether_addr(sdata->dev->dev_addr,
@@ -1449,6 +1450,13 @@ static int prepare_for_handlers(struct i
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

-- 

