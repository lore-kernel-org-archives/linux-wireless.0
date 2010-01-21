Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36824 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab0AUXgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 18:36:45 -0500
Message-ID: <4B58E507.9000101@openwrt.org>
Date: Fri, 22 Jan 2010 00:36:39 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix rx data handling for non-data frames on multiple
 vifs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The loop that passes non-data frames to all relevant vifs inside the
__ieee80211_rx_handle_packet keeps a pointer to the previous sdata to
avoid having to make unnecessary copies of the frame it's handling.
This led to a bug that caused it to apply the ieee80211_rx_data state
to the wrong interface, thereby either missing the rx.sta pointer or
having it assigned where it shouldn't be.
This breaks (among other things) aggregation on some vifs, as action
frame exchages are dropped to the cooked monitor interface due to
rx->sta being NULL.
Fix this by restructuring the loop so that it prepares the rx data just
before making the skb copy and calling the rx handlers.

Cc: stable@kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2348,22 +2348,6 @@ static void __ieee80211_rx_handle_packet
 			    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				continue;
 
-			rx.sta = sta_info_get(sdata, hdr->addr2);
-
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(sdata, &rx, hdr);
-
-			if (!prepares)
-				continue;
-
-			if (status->flag & RX_FLAG_MMIC_ERROR) {
-				rx.sdata = sdata;
-				if (rx.flags & IEEE80211_RX_RA_MATCH)
-					ieee80211_rx_michael_mic_report(hdr,
-									&rx);
-				continue;
-			}
-
 			/*
 			 * frame is destined for this interface, but if it's
 			 * not also for the previous one we handle that after
@@ -2375,6 +2359,22 @@ static void __ieee80211_rx_handle_packet
 				continue;
 			}
 
+			rx.sta = sta_info_get(prev, hdr->addr2);
+
+			rx.flags |= IEEE80211_RX_RA_MATCH;
+			prepares = prepare_for_handlers(prev, &rx, hdr);
+
+			if (!prepares)
+				goto next;
+
+			if (status->flag & RX_FLAG_MMIC_ERROR) {
+				rx.sdata = prev;
+				if (rx.flags & IEEE80211_RX_RA_MATCH)
+					ieee80211_rx_michael_mic_report(hdr,
+									&rx);
+				goto next;
+			}
+
 			/*
 			 * frame was destined for the previous interface
 			 * so invoke RX handlers for it
@@ -2387,11 +2387,22 @@ static void __ieee80211_rx_handle_packet
 					       "multicast frame for %s\n",
 					       wiphy_name(local->hw.wiphy),
 					       prev->name);
-				continue;
+				goto next;
 			}
 			ieee80211_invoke_rx_handlers(prev, &rx, skb_new, rate);
+next:
 			prev = sdata;
 		}
+
+		if (prev) {
+			rx.sta = sta_info_get(prev, hdr->addr2);
+
+			rx.flags |= IEEE80211_RX_RA_MATCH;
+			prepares = prepare_for_handlers(prev, &rx, hdr);
+
+			if (!prepares)
+				prev = NULL;
+		}
 	}
 	if (prev)
 		ieee80211_invoke_rx_handlers(prev, &rx, skb, rate);
