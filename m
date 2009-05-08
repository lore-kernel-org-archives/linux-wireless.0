Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56745 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbZEHJeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 05:34:20 -0400
Date: Fri, 8 May 2009 12:34:10 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Drop unencrypted frames based on key setup
Message-ID: <20090508093410.GA21362@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using nl80211, we do not have a mechanism to set
sdata->drop_unencrypted. Currently, this breaks code that is supposed
to drop unencrypted frames when protection is expected since
ieee80211_rx_h_decrypt() is optimized to not set rx->key when the
frame is not protected.

This patch modifies ieee80211_rx_h_decrypt() to set rx->key for all
frames and only skip decryption if the frame is not protected. This
allows ieee80211_drop_unencrypted() to correctly drop frames even if
drop_unencrypted is not set.

The changes here are not enough to handle all cases, though. Additional
patches will be needed to implement proper IEEE 802.1X PAE for station
mode (currently, this is only used for AP mode) and some additional
rules are needed for MFP to drop unprotected Robust Action frames prior
to having PTK and IGTK configured.

In theory, the unprotected frames could and should be dropped in
ieee80211_rx_h_decrypt(). However, due to the special case with EAPOL
frames that have to be allowed to be received unprotected even when
keys are set, it is simpler to only set rx->key and allow the
ieee80211_frame_allowed() function to handle the actual dropping of
data frames after 802.11->802.3 header conversion. In addition,
unprotected robust management frames are dropped before they are
processed.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/rx.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- uml.orig/net/mac80211/rx.c	2009-05-08 11:55:15.000000000 +0300
+++ uml/net/mac80211/rx.c	2009-05-08 12:30:49.000000000 +0300
@@ -630,15 +630,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	 * possible.
 	 */
 
-	if (!ieee80211_has_protected(hdr->frame_control)) {
-		if (!ieee80211_is_mgmt(hdr->frame_control) ||
-		    rx->sta == NULL || !test_sta_flags(rx->sta, WLAN_STA_MFP))
-			return RX_CONTINUE;
-		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
-		if (mmie_keyidx < 0)
-			return RX_CONTINUE;
-	}
-
 	/*
 	 * No point in finding a key and decrypting if the frame is neither
 	 * addressed to us nor a multicast frame.
@@ -649,8 +640,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	if (rx->sta)
 		stakey = rcu_dereference(rx->sta->key);
 
+	if (!ieee80211_has_protected(hdr->frame_control))
+		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
+
 	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
 		rx->key = stakey;
+		/* Skip decryption if the frame is not protected. */
+		if (!ieee80211_has_protected(hdr->frame_control))
+			return RX_CONTINUE;
 	} else if (mmie_keyidx >= 0) {
 		/* Broadcast/multicast robust management frame / BIP */
 		if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
@@ -661,6 +658,21 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
 			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
 		rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
+	} else if (!ieee80211_has_protected(hdr->frame_control)) {
+		/*
+		 * The frame was not protected, so skip decryption. However, we
+		 * need to set rx->key if there is a key that could have been
+		 * used so that the frame may be dropped if encryption would
+		 * have been expected.
+		 */
+		struct ieee80211_key *key = NULL;
+		if (ieee80211_is_mgmt(hdr->frame_control) &&
+		    is_multicast_ether_addr(hdr->addr1) &&
+		    (key = rcu_dereference(rx->sdata->default_mgmt_key)))
+			rx->key = key;
+		else if ((key = rcu_dereference(rx->sdata->default_key)))
+			rx->key = key;
+		return RX_CONTINUE;
 	} else {
 		/*
 		 * The device doesn't give us the IV so we won't be

-- 
Jouni Malinen                                            PGP id EFC895FA
