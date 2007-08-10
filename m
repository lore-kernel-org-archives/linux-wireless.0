Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXHJVXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 17:23:16 -0400
Subject: [PATCH] mac80211: remove ieee80211_msg_wep_frame_unknown_key
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:25:51 +0200
Message-Id: <1186781151.17351.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neither hostapd nor wpa_supplicant really use it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-10 23:22:00.163840246 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-10 23:22:29.713840246 +0200
@@ -3808,12 +3808,11 @@ ieee80211_rx_h_check(struct ieee80211_tx
 				       MAC_ARG(hdr->addr1),
 				       MAC_ARG(hdr->addr2),
 				       MAC_ARG(hdr->addr3));
-				if (!rx->local->apdev)
-					return TXRX_DROP;
-				ieee80211_rx_mgmt(
-					rx->local, rx->skb, rx->u.rx.status,
-					ieee80211_msg_wep_frame_unknown_key);
-				return TXRX_QUEUED;
+				/*
+				 * TODO: notify userspace about this
+				 * via cfg/nl80211
+				 */
+				return TXRX_DROP;
 			}
 		}
 	}
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-10 23:22:33.873840246 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-10 23:22:46.783840246 +0200
@@ -48,7 +48,7 @@ enum ieee80211_msg_type {
 	ieee80211_msg_tx_callback_ack = 1,
 	ieee80211_msg_tx_callback_fail = 2,
 	/* hole at 3, was ieee80211_msg_passive_scan but unused */
-	ieee80211_msg_wep_frame_unknown_key = 4,
+	/* hole at 4, was ieee80211_msg_wep_frame_unknown_key but now unused */
 	ieee80211_msg_michael_mic_failure = 5,
 	/* hole at 6, was monitor but never sent to userspace */
 	ieee80211_msg_sta_not_assoc = 7,


