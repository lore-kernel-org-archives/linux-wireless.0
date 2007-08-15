Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbXHOO7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:59:55 -0400
Message-Id: <20070815145042.064271000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 02/20] mac80211: remove ieee80211_msg_wep_frame_unknown_key
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neither hostapd nor wpa_supplicant really use it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_common.h |    2 +-
 net/mac80211/rx.c               |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 13:39:27.226520121 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-15 13:39:42.366520121 +0200
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
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-15 13:39:27.256520121 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-15 13:39:42.366520121 +0200
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

