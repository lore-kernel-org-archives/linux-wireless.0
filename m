Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761646AbXHJWEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 18:04:47 -0400
Message-Id: <20070810220633.284525000@sipsolutions.net>
References: <20070810220544.321975000@sipsolutions.net>
Date: Sat, 11 Aug 2007 00:05:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] mac80211: dont send frames from unassociated stations  up
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hostapd doesn't care anyway right now. And it could probably use the
monitor interface if we added a flag or something.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_common.h |    2 +-
 net/mac80211/rx.c               |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-11 00:01:27.643840246 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-11 00:01:42.273840246 +0200
@@ -301,12 +301,13 @@ ieee80211_rx_h_check(struct ieee80211_tx
 			return TXRX_DROP;
 		}
 
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_sta_not_assoc);
-		return TXRX_QUEUED;
+		/*
+		 * TODO: hostapd is really responsible for this.
+		 * But it doesn't care right now. So until it wants to care
+		 * drop it, and at that point just add a radiotap flag
+		 * or something
+		 */
+		return TXRX_DROP;
 	}
 
 	return TXRX_CONTINUE;
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-11 00:01:27.643840246 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-11 00:01:42.273840246 +0200
@@ -51,7 +51,7 @@ enum ieee80211_msg_type {
 	/* hole at 4, was ieee80211_msg_wep_frame_unknown_key but now unused */
 	ieee80211_msg_michael_mic_failure = 5,
 	/* hole at 6, was monitor but never sent to userspace */
-	ieee80211_msg_sta_not_assoc = 7,
+	/* hole at 7, was ieee80211_msg_sta_not_assoc but now unused */
 	/* 8 was ieee80211_msg_set_aid_for_sta */
 	ieee80211_msg_key_threshold_notification = 9,
 	ieee80211_msg_radar = 11,

-- 

