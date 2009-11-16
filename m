Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZKPLIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 06:08:47 -0500
Message-Id: <20091116110720.667891539@sipsolutions.net>
Date: Mon, 16 Nov 2009 12:00:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 3/4] mac80211: push michael MIC report after DA check
References: <20091116110036.010062226@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we receive a michael MIC failure report from the
hardware we currently do not check whether it is actually
reported on a frame that is destined to us. It shouldn't
be possible to get a michael MIC failure report on other
frames, but it also doesn't hurt to verify.

Also, since we then don't need the station struct that
early, move looking it up a bit later in the RX path.

Finally, while at it, a few code cleanups in the area.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-11-12 20:36:39.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-12 21:28:21.000000000 +0100
@@ -1818,11 +1818,11 @@ static void ieee80211_rx_michael_mic_rep
 		 * Some hardware seem to generate incorrect Michael MIC
 		 * reports; ignore them to avoid triggering countermeasures.
 		 */
-		goto ignore;
+		return;
 	}
 
 	if (!ieee80211_has_protected(hdr->frame_control))
-		goto ignore;
+		return;
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
 		/*
@@ -1831,18 +1831,15 @@ static void ieee80211_rx_michael_mic_rep
 		 * group keys and only the AP is sending real multicast
 		 * frames in the BSS.
 		 */
-		goto ignore;
+		return;
 	}
 
 	if (!ieee80211_is_data(hdr->frame_control) &&
 	    !ieee80211_is_auth(hdr->frame_control))
-		goto ignore;
+		return;
 
 	mac80211_ev_michael_mic_failure(rx->sdata, keyidx, hdr, NULL,
 					GFP_ATOMIC);
- ignore:
-	dev_kfree_skb(rx->skb);
-	rx->skb = NULL;
 }
 
 /* TODO: use IEEE80211_RX_FRAGMENTED */
@@ -2064,8 +2061,6 @@ static int prepare_for_handlers(struct i
 			return 0;
 		break;
 	case NL80211_IFTYPE_MONITOR:
-		/* take everything */
-		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case __NL80211_IFTYPE_AFTER_LAST:
 		/* should never get here */
@@ -2097,24 +2092,12 @@ static void __ieee80211_rx_handle_packet
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
-
 	rx.status = status;
 	rx.rate = rate;
 
 	if (ieee80211_is_data(hdr->frame_control) || ieee80211_is_mgmt(hdr->frame_control))
 		local->dot11ReceivedFragmentCount++;
 
-	rx.sta = sta_info_get(local, hdr->addr2);
-	if (rx.sta) {
-		rx.sdata = rx.sta->sdata;
-		rx.dev = rx.sta->sdata->dev;
-	}
-
-	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
-		ieee80211_rx_michael_mic_report(hdr, &rx);
-		return;
-	}
-
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
 		rx.flags |= IEEE80211_RX_IN_SCAN;
@@ -2122,13 +2105,22 @@ static void __ieee80211_rx_handle_packet
 	ieee80211_parse_qos(&rx);
 	ieee80211_verify_alignment(&rx);
 
-	skb = rx.skb;
+	rx.sta = sta_info_get(local, hdr->addr2);
+	if (rx.sta) {
+		rx.sdata = rx.sta->sdata;
+		rx.dev = rx.sta->sdata->dev;
+	}
 
 	if (rx.sdata && ieee80211_is_data(hdr->frame_control)) {
 		rx.flags |= IEEE80211_RX_RA_MATCH;
 		prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
-		if (prepares)
-			prev = rx.sdata;
+		if (prepares) {
+			if (status->flag & RX_FLAG_MMIC_ERROR) {
+				if (rx.flags & IEEE80211_RX_RA_MATCH)
+					ieee80211_rx_michael_mic_report(hdr, &rx);
+			} else
+				prev = rx.sdata;
+		}
 	} else list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
@@ -2143,6 +2135,13 @@ static void __ieee80211_rx_handle_packet
 		if (!prepares)
 			continue;
 
+		if (status->flag & RX_FLAG_MMIC_ERROR) {
+			rx.sdata = sdata;
+			if (rx.flags & IEEE80211_RX_RA_MATCH)
+				ieee80211_rx_michael_mic_report(hdr, &rx);
+			continue;
+		}
+
 		/*
 		 * frame is destined for this interface, but if it's not
 		 * also for the previous one we handle that after the


