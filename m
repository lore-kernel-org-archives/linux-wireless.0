Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52168 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab1ATJhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:37:25 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PfqxH-0001Dg-7h
	for linux-wireless@vger.kernel.org; Thu, 20 Jan 2011 10:37:23 +0100
Received: from dslb-084-059-120-020.pools.arcor-ip.net ([84.59.120.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:37:23 +0100
Received: from alexander.simon by dslb-084-059-120-020.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:37:23 +0100
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: [RFC 4/4] mac80211: support for IEEE80211N in IBSS
Date: Thu, 20 Jan 2011 09:37:11 +0000 (UTC)
Message-ID: <loom.20110120T102902-813@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de> <1295447708.4685.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some ifs to let the packet aggregation also
work while being in IBSS mode.


diff -Nrup compat-wireless-2011-01-17.1/net/mac80211/agg-rx.c
compat-wireless-2011-01-17/net/mac80211/agg-rx.c
--- compat-wireless-2011-01-17.1/net/mac80211/agg-rx.c	2011-01-17
21:03:25.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/agg-rx.c	2011-01-19
17:40:36.000000000 +0100
@@ -160,6 +160,8 @@ static void ieee80211_send_addba_resp(st
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup compat-wireless-2011-01-17.1/net/mac80211/agg-tx.c
compat-wireless-2011-01-17/net/mac80211/agg-tx.c
--- compat-wireless-2011-01-17.1/net/mac80211/agg-tx.c	2011-01-17
21:03:25.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/agg-tx.c	2011-01-19
17:40:36.000000000 +0100
@@ -83,6 +83,8 @@ static void ieee80211_send_addba_request
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
@@ -376,7 +378,8 @@ int ieee80211_start_tx_ba_session(struct
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
diff -Nrup compat-wireless-2011-01-17.1/net/mac80211/ht.c
compat-wireless-2011-01-17/net/mac80211/ht.c
--- compat-wireless-2011-01-17.1/net/mac80211/ht.c
	2011-01-17 21:03:25.000000000
+0100
+++ compat-wireless-2011-01-17/net/mac80211/ht.c
	2011-01-19 17:40:36.000000000 +0100
@@ -179,6 +179,8 @@ void ieee80211_send_delba(struct ieee802
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff -Nrup compat-wireless-2011-01-17.1/net/mac80211/rx.c
compat-wireless-2011-01-17/net/mac80211/rx.c
--- compat-wireless-2011-01-17.1/net/mac80211/rx.c
	2011-01-17 21:03:26.000000000
+0100
+++ compat-wireless-2011-01-17/net/mac80211/rx.c
	2011-01-19 17:40:36.000000000 +0100
@@ -2063,7 +2063,8 @@ ieee80211_rx_h_action(struct ieee80211_r
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
 		/* verify action_code is present */


