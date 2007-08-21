Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759893AbXHUPD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:03:29 -0400
Message-Id: <20070821150045.991627000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 15/27] mac80211: remove ieee80211_msg_wep_frame_unknown_key
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neither hostapd nor wpa_supplicant really use it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_common.h |    2 +-
 net/mac80211/rx.c               |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-21 14:49:06.855923881 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-21 14:51:10.105923881 +0200
@@ -353,12 +353,11 @@ ieee80211_rx_h_load_key(struct ieee80211
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
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-21 14:42:05.475923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-21 14:51:10.105923881 +0200
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

