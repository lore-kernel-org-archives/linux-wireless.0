Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44102 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYAWUMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 15:12:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix suspend/resume
Date: Wed, 23 Jan 2008 21:10:56 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801232110.57017.mb@bu3sch.de> (sfid-20080123_201235_102494_EC3D227E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes suspend/resume.

We must not overwrite the MAC addresses on resume. Otherwise
the card won't ACK any packets anymore.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix that makes suspend/resume working. Without this
people need to do an interface up/down cycle after each resume.
Please try to push it for 2.6.24.

Stefano, this might need porting to legacy.


Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-23 21:01:44.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-23 21:02:16.000000000 +0100
@@ -3528,14 +3528,12 @@ static int b43_wireless_core_init(struct
 	/* Set the pre-wakeup for synthetic PU (in microseconds). */
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SPUWKUP, 500);
 
 	b43_bluetooth_coext_enable(dev);
 
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
-	memset(wl->bssid, 0, ETH_ALEN);
-	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 	b43_rng_init(wl);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
@@ -3628,12 +3626,20 @@ static int b43_op_start(struct ieee80211
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	int did_init = 0;
 	int err = 0;
 	bool do_rfkill_exit = 0;
 
+	/* Kill all old instance specific information to make sure
+	 * the card won't use it in the short timeframe between start
+	 * and mac80211 reconfiguring it. */
+	memset(wl->bssid, 0, ETH_ALEN);
+	memset(wl->mac_addr, 0, ETH_ALEN);
+	wl->filter_flags = 0;
+	wl->radiotap_enabled = 0;
+
 	/* First register RFkill.
 	 * LEDs that are registered later depend on it. */
 	b43_rfkill_init(dev);
 
 	mutex_lock(&wl->mutex);
 
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2008-01-23 21:01:44.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2008-01-23 21:02:16.000000000 +0100
@@ -234,26 +234,29 @@ void b43_generate_txhdr(struct b43_wldev
 		struct b43_key *key;
 		int wlhdr_len;
 		size_t iv_len;
 
 		B43_WARN_ON(key_idx >= dev->max_nr_keys);
 		key = &(dev->key[key_idx]);
-		B43_WARN_ON(!key->keyconf);
 
-		/* Hardware appends ICV. */
-		plcp_fragment_len += txctl->icv_len;
+		if (likely(key->keyconf)) {
+			/* This key is valid. Use it for encryption. */
 
-		key_idx = b43_kidx_to_fw(dev, key_idx);
-		mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
-			   B43_TXH_MAC_KEYIDX;
-		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
-			   B43_TXH_MAC_KEYALG;
-		wlhdr_len = ieee80211_get_hdrlen(fctl);
-		iv_len = min((size_t) txctl->iv_len,
-			     ARRAY_SIZE(txhdr->iv));
-		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
+			/* Hardware appends ICV. */
+			plcp_fragment_len += txctl->icv_len;
+
+			key_idx = b43_kidx_to_fw(dev, key_idx);
+			mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
+				   B43_TXH_MAC_KEYIDX;
+			mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
+				   B43_TXH_MAC_KEYALG;
+			wlhdr_len = ieee80211_get_hdrlen(fctl);
+			iv_len = min((size_t) txctl->iv_len,
+				     ARRAY_SIZE(txhdr->iv));
+			memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
+		}
 	}
 	if (b43_is_old_txhdr_format(dev)) {
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->old_format.plcp),
 				      plcp_fragment_len, rate);
 	} else {
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->new_format.plcp),
