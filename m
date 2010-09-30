Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0I3TFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 15:05:36 -0400
Subject: [PATCH v2] cfg80211/mac80211: allow management frame TX in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285873384.5137.14.camel@jlt3.sipsolutions.net>
References: <1285873384.5137.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 21:06:09 +0200
Message-ID: <1285873569.5137.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Enable management frame transmission and subscribing
to management frames through nl80211 in both cfg80211
and mac80211. Also update a few places that I forgot
to update for P2P-client mode previously, and fix a
small bug with non-action frames in this API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: diff against right tree ...

 net/mac80211/cfg.c     |    7 +++++-
 net/wireless/mlme.c    |   54 +++++++++++++++++++++++++++++++++++++++----------
 net/wireless/nl80211.c |   10 +++++++--
 3 files changed, 57 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2010-09-30 21:03:45.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-09-30 21:05:15.000000000 +0200
@@ -876,21 +876,53 @@ int cfg80211_mlme_mgmt_tx(struct cfg8021
 
 	if (ieee80211_is_action(mgmt->frame_control) &&
 	    mgmt->u.action.category != WLAN_CATEGORY_PUBLIC) {
-		/* Verify that we are associated with the destination AP */
+		int err = 0;
+
 		wdev_lock(wdev);
 
-		if (!wdev->current_bss ||
-		    memcmp(wdev->current_bss->pub.bssid, mgmt->bssid,
-			   ETH_ALEN) != 0 ||
-		    ((wdev->iftype == NL80211_IFTYPE_STATION ||
-		      wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
-		     memcmp(wdev->current_bss->pub.bssid, mgmt->da,
-			    ETH_ALEN) != 0)) {
-			wdev_unlock(wdev);
-			return -ENOTCONN;
-		}
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_P2P_CLIENT:
+			if (!wdev->current_bss) {
+				err = -ENOTCONN;
+				break;
+			}
+
+			if (memcmp(wdev->current_bss->pub.bssid,
+				   mgmt->bssid, ETH_ALEN)) {
+				err = -ENOTCONN;
+				break;
+			}
 
+			/*
+			 * check for IBSS DA must be done by driver as
+			 * cfg80211 doesn't track the stations
+			 */
+			if (wdev->iftype == NL80211_IFTYPE_ADHOC)
+				break;
+
+			/* for station, check that DA is the AP */
+			if (memcmp(wdev->current_bss->pub.bssid,
+				   mgmt->da, ETH_ALEN)) {
+				err = -ENOTCONN;
+				break;
+			}
+			break;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
+		case NL80211_IFTYPE_AP_VLAN:
+			if (memcmp(mgmt->bssid, dev->dev_addr, ETH_ALEN))
+				err = -EINVAL;
+			break;
+		default:
+			err = -EOPNOTSUPP;
+			break;
+		}
 		wdev_unlock(wdev);
+
+		if (err)
+			return err;
 	}
 
 	if (memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0)
--- wireless-testing.orig/net/wireless/nl80211.c	2010-09-30 21:03:46.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-09-30 21:05:15.000000000 +0200
@@ -4826,7 +4826,10 @@ static int nl80211_register_mgmt(struct
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4879,7 +4882,10 @@ static int nl80211_tx_mgmt(struct sk_buf
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
--- wireless-testing.orig/net/mac80211/cfg.c	2010-09-30 21:03:46.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-09-30 21:05:15.000000000 +0200
@@ -1521,7 +1521,11 @@ static int ieee80211_mgmt_tx(struct wiph
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_ADHOC:
-		if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
+		if (!ieee80211_is_action(mgmt->frame_control) ||
+		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
 			break;
 		rcu_read_lock();
 		sta = sta_info_get(sdata, mgmt->da);
@@ -1530,6 +1534,7 @@ static int ieee80211_mgmt_tx(struct wiph
 			return -ENOLINK;
 		break;
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
 		break;
 	default:
 		return -EOPNOTSUPP;


