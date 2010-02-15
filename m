Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39993 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab0BOKqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 05:46:49 -0500
Date: Mon, 15 Feb 2010 12:46:39 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: =?utf-8?B?W1BBVENIXcKgbWFjODAyMTE=?=
	=?utf-8?Q?=3A?= reject unhandled action frames
Message-ID: <20100215104639.GA8173@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

802.11-2007 7.3.1.11 mandates that we need to
reject action frames we don't handle by setting
the 0x80 bit in the category and returning them
to the sender, so do that. In AP mode, hostapd
is responsible for this.

Additionally, drop completely malformed action
frames or ones that should've been encrypted as
unusable, userspace shouldn't see those.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 net/mac80211/rx.c |   90 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 33 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-02-09 14:46:00.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-02-15 12:39:32.000000000 +0200
@@ -2,7 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
- * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1855,23 +1855,28 @@ ieee80211_rx_h_action(struct ieee80211_r
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
+	struct sk_buff *nskb;
 	int len = rx->skb->len;
 
 	if (!ieee80211_is_action(mgmt->frame_control))
 		return RX_CONTINUE;
 
 	if (!rx->sta)
-		return RX_DROP_MONITOR;
+		return RX_DROP_UNUSABLE;
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
-		return RX_DROP_MONITOR;
+		return RX_DROP_UNUSABLE;
 
 	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
-		return RX_DROP_MONITOR;
+		return RX_DROP_UNUSABLE;
 
-	/* all categories we currently handle have action_code */
+	/* drop too small frames */
+	if (len < IEEE80211_MIN_ACTION_SIZE)
+		return RX_DROP_UNUSABLE;
+
+	/* return action frames that have *only* category */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
-		return RX_DROP_MONITOR;
+		goto return_frame;
 
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_BACK:
@@ -1884,7 +1889,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_AP)
-			return RX_DROP_MONITOR;
+			break;
 
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
@@ -1892,45 +1897,45 @@ ieee80211_rx_h_action(struct ieee80211_r
 				   sizeof(mgmt->u.action.u.addba_req)))
 				return RX_DROP_MONITOR;
 			ieee80211_process_addba_request(local, rx->sta, mgmt, len);
-			break;
+			goto handled;
 		case WLAN_ACTION_ADDBA_RESP:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.addba_resp)))
-				return RX_DROP_MONITOR;
+				break;
 			ieee80211_process_addba_resp(local, rx->sta, mgmt, len);
-			break;
+			goto handled;
 		case WLAN_ACTION_DELBA:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.delba)))
-				return RX_DROP_MONITOR;
+				break;
 			ieee80211_process_delba(sdata, rx->sta, mgmt, len);
-			break;
+			goto handled;
 		}
 		break;
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
 		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
-			return RX_DROP_MONITOR;
+			break;
 
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			return RX_DROP_MONITOR;
+			break;
 
 		switch (mgmt->u.action.u.measurement.action_code) {
 		case WLAN_ACTION_SPCT_MSR_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.measurement)))
-				return RX_DROP_MONITOR;
+				break;
 			ieee80211_process_measurement_req(sdata, mgmt, len);
-			break;
+			goto handled;
 		case WLAN_ACTION_SPCT_CHL_SWITCH:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.chan_switch)))
-				return RX_DROP_MONITOR;
+				break;
 
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
-				return RX_DROP_MONITOR;
+				break;
 
 			if (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN))
-				return RX_DROP_MONITOR;
+				break;
 
 			return ieee80211_sta_rx_mgmt(sdata, rx->skb);
 		}
@@ -1938,29 +1943,48 @@ ieee80211_rx_h_action(struct ieee80211_r
 	case WLAN_CATEGORY_SA_QUERY:
 		if (len < (IEEE80211_MIN_ACTION_SIZE +
 			   sizeof(mgmt->u.action.u.sa_query)))
-			return RX_DROP_MONITOR;
+			break;
+
 		switch (mgmt->u.action.u.sa_query.action) {
 		case WLAN_ACTION_SA_QUERY_REQUEST:
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
-				return RX_DROP_MONITOR;
+				break;
 			ieee80211_process_sa_query_req(sdata, mgmt, len);
-			break;
-		case WLAN_ACTION_SA_QUERY_RESPONSE:
-			/*
-			 * SA Query response is currently only used in AP mode
-			 * and it is processed in user space.
-			 */
-			return RX_CONTINUE;
+			goto handled;
 		}
 		break;
-	default:
-		/* do not process rejected action frames */
-		if (mgmt->u.action.category & 0x80)
-			return RX_DROP_MONITOR;
+	}
+ return_frame:
+	/*
+	 * For AP mode, hostapd is responsible for handling any action
+	 * frames that we didn't handle, including returning unknown
+	 * ones. For all other modes we will return them to the sender,
+	 * setting the 0x80 bit in the action category, as required by
+	 * 802.11-2007 7.3.1.11.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		return RX_DROP_MONITOR;
 
-		return RX_CONTINUE;
+	/* do not return rejected action frames */
+	if (mgmt->u.action.category & 0x80)
+		return RX_DROP_UNUSABLE;
+
+	nskb = skb_copy_expand(rx->skb, local->hw.extra_tx_headroom, 0,
+			       GFP_ATOMIC);
+	if (nskb) {
+		struct ieee80211_mgmt *mgmt = (void *)nskb->data;
+
+		mgmt->u.action.category |= 0x80;
+		memcpy(mgmt->da, mgmt->sa, ETH_ALEN);
+		memcpy(mgmt->sa, rx->sdata->vif.addr, ETH_ALEN);
+
+		memset(nskb->cb, 0, sizeof(nskb->cb));
+
+		ieee80211_tx_skb(rx->sdata, nskb);
 	}
 
+ handled:
 	rx->sta->rx_packets++;
 	dev_kfree_skb(rx->skb);
 	return RX_QUEUED;

-- 
Jouni Malinen                                            PGP id EFC895FA
