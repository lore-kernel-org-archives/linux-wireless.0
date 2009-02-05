Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZBEQPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 11:15:51 -0500
Message-Id: <20090205161132.351536213@sipsolutions.net> (sfid-20090205_171604_911981_786CD84E)
References: <20090205160738.990564487@sipsolutions.net>
Date: Thu, 05 Feb 2009 17:07:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] mac80211: restrict aggregation to supported
	interface modes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can only support aggregation on AP/STA right now. HT isn't defined
for IBSS, WDS or MESH. In the WDS/MESH cases it's not clear what to
put into the IBSS field, and we don't handle that in the code at all.
Also fix the code to handle VLAN correctly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: do not allow IBSS

 net/mac80211/agg-rx.c |    3 ++-
 net/mac80211/agg-tx.c |   16 +++++++++++++++-
 net/mac80211/ht.c     |    3 ++-
 net/mac80211/rx.c     |   11 +++++++++++
 4 files changed, 30 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-02-04 16:03:33.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-02-04 16:03:34.000000000 +0100
@@ -41,7 +41,8 @@ static void ieee80211_send_addba_request
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == NL80211_IFTYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
@@ -180,6 +181,19 @@ int ieee80211_start_tx_ba_session(struct
 		goto exit;
 	}
 
+	/*
+	 * The aggregation code is not prepared to handle
+	 * anything but STA/AP due to the BSSID handling.
+	 * IBSS could work in the code but isn't supported
+	 * by drivers or the standard.
+	 */
+	if (sta->sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sta->sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+	    sta->sdata->vif.type != NL80211_IFTYPE_AP) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	spin_lock_bh(&sta->lock);
 
 	/* we have tried too many times, receiver does not want A-MPDU */
--- wireless-testing.orig/net/mac80211/rx.c	2009-02-04 16:03:29.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-02-04 16:03:34.000000000 +0100
@@ -1735,6 +1735,17 @@ ieee80211_rx_h_action(struct ieee80211_r
 
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_BACK:
+		/*
+		 * The aggregation code is not prepared to handle
+		 * anything but STA/AP due to the BSSID handling;
+		 * IBSS could work in the code but isn't supported
+		 * by drivers or the standard.
+		 */
+		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_AP)
+			return RX_DROP_MONITOR;
+
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-02-04 16:03:33.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-02-04 16:03:34.000000000 +0100
@@ -134,7 +134,8 @@ static void ieee80211_send_addba_resp(st
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == NL80211_IFTYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
--- wireless-testing.orig/net/mac80211/ht.c	2009-02-04 16:03:33.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-02-04 16:03:34.000000000 +0100
@@ -190,7 +190,8 @@ void ieee80211_send_delba(struct ieee802
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == NL80211_IFTYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);

-- 

