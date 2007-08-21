Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761604AbXHUPEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:04:04 -0400
Message-Id: <20070821150047.420655000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 18/27] mac80211: fix software decryption
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When doing key selection for software decryption, mac80211 gets
a few things wrong: it always uses pairwise keys if configured,
even if the frame is addressed to a multicast address. Also, it
doesn't allow using a key index of zero if a pairwise key has
also been found.

This patch changes the key selection code to be (more) in line
with the 802.11 specification. I have confirmed that with this,
multicast frames are correctly decrypted and I've tested with
WEP as well.

While at it, I've cleaned up the semantics of the hardware flags
IEEE80211_HW_WEP_INCLUDE_IV and IEEE80211_HW_DEVICE_HIDES_WEP
and clarified them in the mac80211.h header; it is also now
allowed to set the IEEE80211_HW_DEVICE_HIDES_WEP option even if
it only applies to frames that have been decrypted by the hw,
unencrypted frames must be dropped but encrypted frames that
the hardware couldn't handle can be passed up unmodified.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |   37 +++++++++++---
 net/mac80211/rx.c      |  125 ++++++++++++++++++++++++++++++-------------------
 net/mac80211/wpa.c     |    7 +-
 3 files changed, 112 insertions(+), 57 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-21 15:23:31.625923881 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-21 15:29:55.865923881 +0200
@@ -317,52 +317,83 @@ static ieee80211_txrx_result
 ieee80211_rx_h_load_key(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-	int always_sta_key;
+	int keyidx;
+	int hdrlen;
+	int trying_wep = 0;
+
+	/*
+	 * Key selection 101
+	 *
+	 * There are three types of keys:
+	 *  - GTK (group keys)
+	 *  - PTK (pairwise keys)
+	 *  - STK (station-to-station pairwise keys)
+	 *
+	 * When selecting a key, we have to distinguish between multicast
+	 * (including broadcast) and unicast frames, the latter can only
+	 * use PTKs and STKs while the former always use GTKs. Unless, of
+	 * course, actual WEP keys ("pre-RSNA") are used, then unicast
+	 * frames can also use key indizes like GTKs. Hence, if we don't
+	 * have a PTK/STK we check the key index for a WEP key.
+	 *
+	 * There is also a slight problem in IBSS mode: GTKs are negotiated
+	 * with each station, that is something we don't currently handle.
+	 */
 
-	if (rx->sdata->type == IEEE80211_IF_TYPE_STA)
-		always_sta_key = 0;
-	else
-		always_sta_key = 1;
+	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
+		return TXRX_CONTINUE;
 
-	if (rx->sta && rx->sta->key && always_sta_key) {
-		rx->key = rx->sta->key;
+	/*
+	 * No point in finding a key if the frame is neither
+	 * addressed to us nor a multicast frame.
+	 */
+	if (!rx->u.rx.ra_match)
+		return TXRX_DROP;
+
+	if (is_multicast_ether_addr(hdr->addr1) || !rx->sta) {
+ find_by_index:
+		/*
+		 * The device doesn't give us the IV so won't be
+		 * able to look up the key. That's ok though, we
+		 * don't need to decrypt the frame, we just won't
+		 * be able to keep statistics accurate.
+		 * Except for key threshold notifications, should
+		 * we somehow allow the driver to tell us which key
+		 * the hardware used if this flag is set?
+		 */
+		if (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV))
+			return TXRX_CONTINUE;
+
+		hdrlen = ieee80211_get_hdrlen(rx->fc);
+
+		if (rx->skb->len < 8 + hdrlen)
+			/* COUNT THIS? */
+			return TXRX_DROP;
+		/*
+		 * no need to call ieee80211_wep_get_keyidx,
+		 * it verifies a bunch of things we've done already
+		 */
+		keyidx = rx->skb->data[hdrlen + 3] >> 6;
+
+		/*
+		 * TODO: handle IBSS! We can have per-STA group keys there!
+		 */
+		rx->key = rx->sdata->keys[keyidx];
+
+		/*
+		 * If we got here for WEP, make sure we got WEP
+		 */
+		if (trying_wep && rx->key && rx->key->alg != ALG_WEP)
+			rx->key = NULL;
 	} else {
-		if (rx->sta && rx->sta->key)
-			rx->key = rx->sta->key;
-		else
-			rx->key = rx->sdata->default_key;
-
-		if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
-		    rx->fc & IEEE80211_FCTL_PROTECTED) {
-			int keyidx = ieee80211_wep_get_keyidx(rx->skb);
-
-			if (keyidx >= 0 && keyidx < NUM_DEFAULT_KEYS &&
-			    (!rx->sta || !rx->sta->key || keyidx > 0))
-				rx->key = rx->sdata->keys[keyidx];
-
-			if (!rx->key) {
-				if (!rx->u.rx.ra_match)
-					return TXRX_DROP;
-				if (net_ratelimit())
-					printk(KERN_DEBUG "%s: RX WEP frame "
-					       "with unknown keyidx %d "
-					       "(A1=" MAC_FMT
-					       " A2=" MAC_FMT
-					       " A3=" MAC_FMT ")\n",
-					       rx->dev->name, keyidx,
-					       MAC_ARG(hdr->addr1),
-					       MAC_ARG(hdr->addr2),
-					       MAC_ARG(hdr->addr3));
-				/*
-				 * TODO: notify userspace about this
-				 * via cfg/nl80211
-				 */
-				return TXRX_DROP;
-			}
+		rx->key = rx->sta->key;
+		if (!rx->key) {
+			trying_wep = 1;
+			goto find_by_index;
 		}
 	}
 
-	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) {
+	if (rx->key && rx->u.rx.ra_match) {
 		rx->key->tx_rx_count++;
 		if (unlikely(rx->local->key_tx_rx_threshold &&
 			     rx->key->tx_rx_count >
@@ -520,10 +551,6 @@ ieee80211_rx_h_wep_weak_iv_detection(str
 static ieee80211_txrx_result
 ieee80211_rx_h_wep_decrypt(struct ieee80211_txrx_data *rx)
 {
-	/* If the device handles decryption totally, skip this test */
-	if (rx->local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP)
-		return TXRX_CONTINUE;
-
 	if ((rx->key && rx->key->alg != ALG_WEP) ||
 	    !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
@@ -875,8 +902,14 @@ ieee80211_rx_h_802_1x_pae(struct ieee802
 static ieee80211_txrx_result
 ieee80211_rx_h_drop_unencrypted(struct ieee80211_txrx_data *rx)
 {
-	/*  If the device handles decryption totally, skip this test */
-	if (rx->local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP)
+	/*
+	 * Pass through unencrypted frames if the hardware might have
+	 * decrypted them already without telling us, but that can only
+	 * be true if we either didn't find a key or the found key is
+	 * uploaded to the hardware.
+	 */
+	if ((rx->local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP) &&
+	    (!rx->key || !rx->key->force_sw_encrypt))
 		return TXRX_CONTINUE;
 
 	/* Drop unencrypted frames if key is set. */
--- wireless-dev.orig/include/net/mac80211.h	2007-08-21 15:24:26.015923881 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-21 15:28:19.455923881 +0200
@@ -1,7 +1,9 @@
 /*
- * Low-level hardware driver -- IEEE 802.11 driver (80211.o) interface
+ * mac80211 <-> driver interface
+ *
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -471,10 +473,16 @@ struct ieee80211_hw {
 	 */
 #define IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE (1<<1)
 
-	/* Some devices handle decryption internally and do not
+	/*
+	 * Some devices handle decryption internally and do not
 	 * indicate whether the frame was encrypted (unencrypted frames
 	 * will be dropped by the hardware, unless specifically allowed
-	 * through) */
+	 * through.)
+	 * It is permissible to not handle all encrypted frames and fall
+	 * back to software encryption; however, if this flag is set
+	 * unencrypted frames must be dropped unless the driver is told
+	 * otherwise via the set_ieee8021x() callback.
+	 */
 #define IEEE80211_HW_DEVICE_HIDES_WEP (1<<2)
 
 	/* Whether RX frames passed to ieee80211_rx() include FCS in the end */
@@ -488,6 +496,18 @@ struct ieee80211_hw {
 	 * can fetch them with ieee80211_get_buffered_bc(). */
 #define IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING (1<<4)
 
+	/*
+	 * This flag is only relevant if hardware encryption is used.
+	 * If set, it has two meanings:
+	 *  1) the IV and ICV are present in received frames that have
+	 *     been decrypted (unless IEEE80211_HW_DEVICE_HIDES_WEP is
+	 *     also set)
+	 *  2) on transmission, the IV should be generated in software.
+	 *
+	 * Please let us know if you *don't* use this flag, the stack would
+	 * really like to be able to get the IV to keep key statistics
+	 * accurate.
+	 */
 #define IEEE80211_HW_WEP_INCLUDE_IV (1<<5)
 
 /* hole at 6 */
@@ -495,11 +515,12 @@ struct ieee80211_hw {
 	/* Force software encryption for TKIP packets if WMM is enabled. */
 #define IEEE80211_HW_NO_TKIP_WMM_HWACCEL (1<<7)
 
-	/* Some devices handle Michael MIC internally and do not include MIC in
-	 * the received packets passed up. device_strips_mic must be set
-	 * for such devices. The 'encryption' frame control bit is expected to
-	 * be still set in the IEEE 802.11 header with this option unlike with
-	 * the device_hides_wep configuration option.
+	/*
+	 * Some devices handle Michael MIC internally and do not include MIC in
+	 * the received packets passed up. This flag must be set for such
+	 * devices. The 'encryption' frame control bit is expected to be still
+	 * set in the IEEE 802.11 header with this option unlike with the
+	 * IEEE80211_HW_DEVICE_HIDES_WEP flag.
 	 */
 #define IEEE80211_HW_DEVICE_STRIPS_MIC (1<<8)
 
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-21 14:58:42.015923881 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-21 15:28:19.455923881 +0200
@@ -169,9 +169,10 @@ ieee80211_rx_h_michael_mic_verify(struct
 
 	fc = rx->fc;
 
-	/* If device handles decryption totally, skip this check */
-	if ((rx->local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP) ||
-	    (rx->local->hw.flags & IEEE80211_HW_DEVICE_STRIPS_MIC))
+	/*
+	 * No way to verify the MIC if the hardware stripped it
+	 */
+	if (rx->local->hw.flags & IEEE80211_HW_DEVICE_STRIPS_MIC)
 		return TXRX_CONTINUE;
 
 	if (!rx->key || rx->key->alg != ALG_TKIP ||

-- 

