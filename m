Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYIJWHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:07:43 -0400
Message-Id: <20080910220420.638778000@sipsolutions.net> (sfid-20080911_000747_244038_C7EAB4B4)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/18] mac80211: clean up some comments
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some comments refer to 80211.o or similar; also remove
a comment about implementing fragments better, we really
have better things to do.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    7 ++-----
 net/mac80211/rx.c          |    4 ++--
 net/mac80211/tx.c          |   15 +--------------
 net/mac80211/wme.h         |    1 -
 4 files changed, 5 insertions(+), 22 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-10 23:58:03.000000000 +0200
@@ -501,8 +501,8 @@ ieee80211_rx_h_check(struct ieee80211_rx
 	/* Drop disallowed frame classes based on STA auth/assoc state;
 	 * IEEE 802.11, Chap 5.5.
 	 *
-	 * 80211.o does filtering only based on association state, i.e., it
-	 * drops Class 3 frames from not associated stations. hostapd sends
+	 * mac80211 filters only based on association state, i.e. it drops
+	 * Class 3 frames from not associated stations. hostapd sends
 	 * deauth/disassoc frames when needed. In addition, hostapd is
 	 * responsible for filtering on both auth and assoc states.
 	 */
--- everything.orig/net/mac80211/tx.c	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-10 23:58:03.000000000 +0200
@@ -111,7 +111,7 @@ static __le16 ieee80211_duration(struct 
 	hdr = (struct ieee80211_hdr *)tx->skb->data;
 	if (ieee80211_is_ctl(hdr->frame_control)) {
 		/* TODO: These control frames are not currently sent by
-		 * 80211.o, but should they be implemented, this function
+		 * mac80211, but should they be implemented, this function
 		 * needs to be updated to support duration field calculation.
 		 *
 		 * RTS: time needed to transmit pending data/mgmt frame plus
@@ -1580,19 +1580,6 @@ int ieee80211_subif_start_xmit(struct sk
 	nh_pos -= skip_header_bytes;
 	h_pos -= skip_header_bytes;
 
-	/* TODO: implement support for fragments so that there is no need to
-	 * reallocate and copy payload; it might be enough to support one
-	 * extra fragment that would be copied in the beginning of the frame
-	 * data.. anyway, it would be nice to include this into skb structure
-	 * somehow
-	 *
-	 * There are few options for this:
-	 * use skb->cb as an extra space for 802.11 header
-	 * allocate new buffer if not enough headroom
-	 * make sure that there is enough headroom in every skb by increasing
-	 * build in headroom in __dev_alloc_skb() (linux/skbuff.h) and
-	 * alloc_skb() (net/core/skbuff.c)
-	 */
 	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
 
 	/*
--- everything.orig/net/mac80211/wme.h	2008-09-10 23:50:24.000000000 +0200
+++ everything/net/mac80211/wme.h	2008-09-10 23:58:03.000000000 +0200
@@ -1,5 +1,4 @@
 /*
- * IEEE 802.11 driver (80211.o) - QoS datatypes
  * Copyright 2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
  *
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:58:03.000000000 +0200
@@ -29,9 +29,6 @@
 #include "key.h"
 #include "sta_info.h"
 
-/* ieee80211.o internal definitions, etc. These are not included into
- * low-level drivers. */
-
 struct ieee80211_local;
 
 /* Maximum number of broadcast/multicast frames to buffer when some of the
@@ -293,13 +290,13 @@ struct mesh_config {
 #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
-/* flags for  MLME request*/
+/* flags for MLME request */
 #define IEEE80211_STA_REQ_SCAN 0
 #define IEEE80211_STA_REQ_DIRECT_PROBE 1
 #define IEEE80211_STA_REQ_AUTH 2
 #define IEEE80211_STA_REQ_RUN  3
 
-/* flags used for setting mlme state */
+/* STA/IBSS MLME states */
 enum ieee80211_sta_mlme_state {
 	IEEE80211_STA_MLME_DISABLED,
 	IEEE80211_STA_MLME_DIRECT_PROBE,

-- 

