Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbYBWOVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:47 -0500
Message-Id: <20080223142009.834012000@sipsolutions.net> (sfid-20080223_142150_385773_54C64119)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:07 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 04/18] mac80211: add mesh interface type
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the mesh interface type.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h         |    1 +
 net/mac80211/ieee80211.c       |    1 +
 net/mac80211/ieee80211_iface.c |    1 +
 net/mac80211/rx.c              |   10 ++++++++++
 net/mac80211/util.c            |    1 +
 5 files changed, 14 insertions(+)

--- everything.orig/include/net/mac80211.h	2008-02-23 14:23:35.000000000 +0100
+++ everything/include/net/mac80211.h	2008-02-23 14:23:36.000000000 +0100
@@ -439,6 +439,7 @@ enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_AP,
 	IEEE80211_IF_TYPE_STA,
 	IEEE80211_IF_TYPE_IBSS,
+	IEEE80211_IF_TYPE_MESH_POINT,
 	IEEE80211_IF_TYPE_MNTR,
 	IEEE80211_IF_TYPE_WDS,
 	IEEE80211_IF_TYPE_VLAN,
--- everything.orig/net/mac80211/ieee80211.c	2008-02-23 14:23:35.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-23 14:23:36.000000000 +0100
@@ -258,6 +258,7 @@ static int ieee80211_open(struct net_dev
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		/* no special treatment */
 		break;
 	case IEEE80211_IF_TYPE_INVALID:
--- everything.orig/net/mac80211/ieee80211_iface.c	2008-02-23 14:23:35.000000000 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-02-23 14:23:36.000000000 +0100
@@ -231,6 +231,7 @@ void ieee80211_if_reinit(struct net_devi
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 		}
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		kfree(sdata->u.sta.extra_ie);
--- everything.orig/net/mac80211/rx.c	2008-02-23 14:23:35.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-23 14:23:36.000000000 +0100
@@ -1713,6 +1713,16 @@ static int prepare_for_handlers(struct i
 			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
 							 bssid, hdr->addr2);
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		if (!multicast &&
+		    compare_ether_addr(sdata->dev->dev_addr,
+				       hdr->addr1) != 0) {
+			if (!(sdata->dev->flags & IFF_PROMISC))
+				return 0;
+
+			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+		}
+		break;
 	case IEEE80211_IF_TYPE_VLAN:
 	case IEEE80211_IF_TYPE_AP:
 		if (!bssid) {
--- everything.orig/net/mac80211/util.c	2008-02-23 14:23:35.000000000 +0100
+++ everything/net/mac80211/util.c	2008-02-23 14:23:36.000000000 +0100
@@ -382,6 +382,7 @@ void ieee80211_iterate_active_interfaces
 		case IEEE80211_IF_TYPE_STA:
 		case IEEE80211_IF_TYPE_IBSS:
 		case IEEE80211_IF_TYPE_WDS:
+		case IEEE80211_IF_TYPE_MESH_POINT:
 			break;
 		}
 		if (sdata->dev == local->mdev)

-- 

