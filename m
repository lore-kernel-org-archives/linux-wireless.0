Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab0E1S5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:57:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OI4kY-00048q-Ad
	for linux-wireless@vger.kernel.org; Fri, 28 May 2010 20:57:42 +0200
Message-Id: <20100528185505.622028361@sipsolutions.net>
Date: Fri, 28 May 2010 20:53:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 7/7] mac80211: always process blockack action from workqueue
References: <20100528185302.639535282@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To prepare for making the ampdu_action callback
sleep, make mac80211 always process blockack
action frames from the skb queue. This gets rid
of the current special case for managed mode
interfaces as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   35 ++++++++++++++++++++++++++++++++++-
 net/mac80211/mlme.c  |   38 --------------------------------------
 net/mac80211/rx.c    |   29 +++++++++++++----------------
 3 files changed, 47 insertions(+), 55 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-05-28 20:37:10.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-05-28 20:37:13.000000000 +0200
@@ -727,7 +727,40 @@ static void ieee80211_iface_work(struct
 
 	/* first process frames */
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
-		switch (sdata->vif.type) {
+		struct ieee80211_mgmt *mgmt = (void *)skb->data;
+
+		if (ieee80211_is_action(mgmt->frame_control) &&
+		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
+			int len = skb->len;
+			struct sta_info *sta;
+
+			rcu_read_lock();
+			sta = sta_info_get(sdata, mgmt->sa);
+			if (sta) {
+				local_bh_disable();
+
+				switch (mgmt->u.action.u.addba_req.action_code) {
+				case WLAN_ACTION_ADDBA_REQ:
+					ieee80211_process_addba_request(
+							local, sta, mgmt, len);
+					break;
+				case WLAN_ACTION_ADDBA_RESP:
+					ieee80211_process_addba_resp(local, sta,
+								     mgmt, len);
+					break;
+				case WLAN_ACTION_DELBA:
+					ieee80211_process_delba(sdata, sta,
+								mgmt, len);
+					break;
+				default:
+					WARN_ON(1);
+					break;
+				}
+
+				local_bh_enable();
+			}
+			rcu_read_unlock();
+		} else switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			ieee80211_sta_rx_queued_mgmt(sdata, skb);
 			break;
--- wireless-testing.orig/net/mac80211/mlme.c	2010-05-28 20:37:11.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-05-28 20:37:13.000000000 +0200
@@ -1666,44 +1666,6 @@ void ieee80211_sta_rx_queued_mgmt(struct
 			break;
 		case IEEE80211_STYPE_ACTION:
 			switch (mgmt->u.action.category) {
-			case WLAN_CATEGORY_BACK: {
-				struct ieee80211_local *local = sdata->local;
-				int len = skb->len;
-				struct sta_info *sta;
-
-				rcu_read_lock();
-				sta = sta_info_get(sdata, mgmt->sa);
-				if (!sta) {
-					rcu_read_unlock();
-					break;
-				}
-
-				local_bh_disable();
-
-				switch (mgmt->u.action.u.addba_req.action_code) {
-				case WLAN_ACTION_ADDBA_REQ:
-					if (len < (IEEE80211_MIN_ACTION_SIZE +
-						   sizeof(mgmt->u.action.u.addba_req)))
-						break;
-					ieee80211_process_addba_request(local, sta, mgmt, len);
-					break;
-				case WLAN_ACTION_ADDBA_RESP:
-					if (len < (IEEE80211_MIN_ACTION_SIZE +
-						   sizeof(mgmt->u.action.u.addba_resp)))
-						break;
-					ieee80211_process_addba_resp(local, sta, mgmt, len);
-					break;
-				case WLAN_ACTION_DELBA:
-					if (len < (IEEE80211_MIN_ACTION_SIZE +
-						   sizeof(mgmt->u.action.u.delba)))
-						break;
-					ieee80211_process_delba(sdata, sta, mgmt, len);
-					break;
-				}
-				local_bh_enable();
-				rcu_read_unlock();
-				break;
-				}
 			case WLAN_CATEGORY_SPECTRUM_MGMT:
 				ieee80211_sta_process_chanswitch(sdata,
 						&mgmt->u.action.u.chan_switch.sw_elem,
--- wireless-testing.orig/net/mac80211/rx.c	2010-05-28 20:37:11.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-05-28 20:37:13.000000000 +0200
@@ -1936,33 +1936,29 @@ ieee80211_rx_h_action(struct ieee80211_r
 		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 			break;
 
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			skb_queue_tail(&sdata->skb_queue, rx->skb);
-			ieee80211_queue_work(&local->hw, &sdata->work);
-			return RX_QUEUED;
-		}
-
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.addba_req)))
-				return RX_DROP_MONITOR;
-			ieee80211_process_addba_request(local, rx->sta, mgmt, len);
-			goto handled;
+				goto invalid;
+			break;
 		case WLAN_ACTION_ADDBA_RESP:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.addba_resp)))
-				break;
-			ieee80211_process_addba_resp(local, rx->sta, mgmt, len);
-			goto handled;
+				goto invalid;
+			break;
 		case WLAN_ACTION_DELBA:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.delba)))
-				break;
-			ieee80211_process_delba(sdata, rx->sta, mgmt, len);
-			goto handled;
+				goto invalid;
+			break;
+		default:
+			goto invalid;
 		}
-		break;
+
+		skb_queue_tail(&sdata->skb_queue, rx->skb);
+		ieee80211_queue_work(&local->hw, &sdata->work);
+		return RX_QUEUED;
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
 		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
 			break;
@@ -2019,6 +2015,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 		return RX_QUEUED;
 	}
 
+ invalid:
 	/*
 	 * For AP mode, hostapd is responsible for handling any action
 	 * frames that we didn't handle, including returning unknown


