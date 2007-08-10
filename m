Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764900AbXHJWEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 18:04:44 -0400
Message-Id: <20070810220632.677662000@sipsolutions.net>
References: <20070810220544.321975000@sipsolutions.net>
Date: Sat, 11 Aug 2007 00:05:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] mac80211: remove ieee80211_msg_wep_frame_unknown_key
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neither hostapd nor wpa_supplicant really use it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_common.h |    2 +-
 net/mac80211/rx.c               |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-10 23:55:56.063840246 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-11 00:01:27.643840246 +0200
@@ -350,12 +350,11 @@ ieee80211_rx_h_load_key(struct ieee80211
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
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-10 23:50:37.933840246 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-11 00:01:27.643840246 +0200
@@ -48,7 +48,7 @@ enum ieee80211_msg_type {
 	ieee80211_msg_tx_callback_ack = 1,
 	ieee80211_msg_tx_callback_fail = 2,
 	/* hole at 3, was ieee80211_msg_passive_scan but unused */
-	ieee80211_msg_wep_frame_unknown_key = 4,
+	/* hole at 4, was ieee80211_msg_wep_frame_unknown_key but now unused */
 	ieee80211_msg_michael_mic_failure = 5,
 	/* hole at 6, was monitor but never sent to userspace */
 	ieee80211_msg_sta_not_assoc = 7,

-- 

