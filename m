Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbXH3PUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 11:20:17 -0400
Subject: [PATCH] mac80211: remove TKIP mixing for hw accel again
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 17:21:23 +0200
Message-Id: <1188487283.3978.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TKIP mixing code was added for the benefit of Intel's ipw3945
chipset but that code ended up not using it. We have previously
identified many problems with this code and it crystallized that
library functions for mixing are likely to handle this in much
more generality and might allow b43 to take advantage of hardware
acceleration for TKIP.

Due to these reasons, remove the TKIP mixing for hardware
accelerated crypto operations.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Buesch <mb@bu3sch.de>

---
 include/net/mac80211.h |    9 ---------
 net/mac80211/wpa.c     |   17 -----------------
 2 files changed, 26 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-30 14:35:36.472051253 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-30 14:35:37.232051253 +0200
@@ -189,7 +189,6 @@ struct ieee80211_tx_control {
 #define IEEE80211_TXCTL_REQUEUE		(1<<7)
 #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
 						* the frame */
-#define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
 #define IEEE80211_TXCTL_LONG_RETRY_LIMIT (1<<10) /* this frame should be send
 						  * using the through
 						  * set_retry_limit configured
@@ -205,7 +204,6 @@ struct ieee80211_tx_control {
 	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
-	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
 	u8 queue;		/* hardware queue to use for this frame;
 				 * 0 = highest, hw->queues-1 = lowest */
 	u8 sw_retry_attempt;	/* number of times hw has tried to
@@ -565,13 +563,6 @@ struct ieee80211_hw {
 	 * specified in the device's EEPROM */
 #define IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED (1<<11)
 
-	/* Do TKIP phase1 key mixing in stack to support cards only do
-	 * phase2 key mixing when doing hwcrypto */
-#define IEEE80211_HW_TKIP_REQ_PHASE1_KEY (1<<13)
-	/* Do TKIP phase1 and phase2 key mixing in stack and send the generated
-	 * per-packet RC4 key with each TX frame when doing hwcrypto */
-#define IEEE80211_HW_TKIP_REQ_PHASE2_KEY (1<<14)
-
 	/* The device capable of supporting 11n */
 #define IEEE80211_HW_SUPPORT_HT_MODE (1<<15)
 
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-30 14:35:36.482051253 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-30 14:35:37.232051253 +0200
@@ -297,7 +297,6 @@ skip_iv_inc:
 	    && !tx->wpa_test
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 		) {
-		u32 flags = tx->local->hw.flags;
 		hdr = (struct ieee80211_hdr *)skb->data;
 
 		/* hwaccel - with preallocated room for IV */
@@ -307,22 +306,6 @@ skip_iv_inc:
 					    0x7f),
 				      (u8) key->u.tkip.iv16);
 
-		if (flags & IEEE80211_HW_TKIP_REQ_PHASE2_KEY)
-			ieee80211_tkip_gen_rc4key(key, hdr->addr2,
-						  tx->u.tx.control->tkip_key);
-		else if (flags & IEEE80211_HW_TKIP_REQ_PHASE1_KEY) {
-			if (key->u.tkip.iv16 == 0 ||
-			    !key->u.tkip.tx_initialized) {
-				ieee80211_tkip_gen_phase1key(key, hdr->addr2,
-					    (u16 *)tx->u.tx.control->tkip_key);
-				key->u.tkip.tx_initialized = 1;
-				tx->u.tx.control->flags |=
-					    IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY;
-			} else
-				tx->u.tx.control->flags &=
-					    ~IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY;
-		}
-
 		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
 	}


