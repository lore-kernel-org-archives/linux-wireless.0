Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33155 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbYLSUj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 15:39:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Fixup set_key handling
Date: Fri, 19 Dec 2008 21:30:52 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812192130.52399.mb@bu3sch.de> (sfid-20081219_213931_410851_64ED8B10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the key handling for mac80211's new key->flags.
It also adds TX locking to the set_key handler and adds a comment why this is required.
This doesn't fix any known bugs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.29

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-12-19 19:42:21.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-19 21:17:44.000000000 +0100
@@ -934,27 +934,26 @@ static int b43_key_write(struct b43_wlde
 		return -EINVAL;
 	for (i = 0; i < dev->max_nr_keys; i++) {
 		/* Check that we don't already have this key. */
 		B43_WARN_ON(dev->key[i].keyconf == keyconf);
 	}
 	if (index < 0) {
-		/* Either pairwise key or address is 00:00:00:00:00:00
-		 * for transmit-only keys. Search the index. */
+		/* Pairwise key. Get an empty slot for the key. */
 		if (b43_new_kidx_api(dev))
 			sta_keys_start = 4;
 		else
 			sta_keys_start = 8;
 		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
 			if (!dev->key[i].keyconf) {
 				/* found empty */
 				index = i;
 				break;
 			}
 		}
 		if (index < 0) {
-			b43err(dev->wl, "Out of hardware key memory\n");
+			b43warn(dev->wl, "Out of hardware key memory\n");
 			return -ENOSPC;
 		}
 	} else
 		B43_WARN_ON(index > 3);
 
 	do_key_write(dev, index, algorithm, key, key_len, mac_addr);
@@ -3522,23 +3521,30 @@ out_unlock_mutex:
 static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
-	unsigned long flags;
 	u8 algorithm;
 	u8 index;
 	int err;
 	DECLARE_MAC_BUF(mac);
 
 	if (modparam_nohwcrypt)
 		return -ENOSPC; /* User disabled HW-crypto */
 
 	mutex_lock(&wl->mutex);
-	spin_lock_irqsave(&wl->irq_lock, flags);
+	spin_lock_irq(&wl->irq_lock);
+	write_lock(&wl->tx_lock);
+	/* Why do we need all this locking here?
+	 * mutex     -> Every config operation must take it.
+	 * irq_lock  -> We modify the dev->key array, which is accessed
+	 *              in the IRQ handlers.
+	 * tx_lock   -> We modify the dev->key array, which is accessed
+	 *              in the TX handler.
+	 */
 
 	dev = wl->current_dev;
 	err = -ENODEV;
 	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
 		goto out_unlock;
 
@@ -3549,13 +3555,13 @@ static int b43_op_set_key(struct ieee802
 		goto out_unlock;
 	}
 
 	err = -EINVAL;
 	switch (key->alg) {
 	case ALG_WEP:
-		if (key->keylen == 5)
+		if (key->keylen == LEN_WEP40)
 			algorithm = B43_SEC_ALGO_WEP40;
 		else
 			algorithm = B43_SEC_ALGO_WEP104;
 		break;
 	case ALG_TKIP:
 		algorithm = B43_SEC_ALGO_TKIP;
@@ -3576,23 +3582,20 @@ static int b43_op_set_key(struct ieee802
 		if (algorithm == B43_SEC_ALGO_TKIP) {
 			/* FIXME: No TKIP hardware encryption for now. */
 			err = -EOPNOTSUPP;
 			goto out_unlock;
 		}
 
-		if (is_broadcast_ether_addr(addr)) {
-			/* addr is FF:FF:FF:FF:FF:FF for default keys */
-			err = b43_key_write(dev, index, algorithm,
-					    key->key, key->keylen, NULL, key);
-		} else {
-			/*
-			 * either pairwise key or address is 00:00:00:00:00:00
-			 * for transmit-only keys
-			 */
+		if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+			/* Pairwise key with an assigned MAC address. */
 			err = b43_key_write(dev, -1, algorithm,
 					    key->key, key->keylen, addr, key);
+		} else {
+			/* Group key */
+			err = b43_key_write(dev, index, algorithm,
+					    key->key, key->keylen, NULL, key);
 		}
 		if (err)
 			goto out_unlock;
 
 		if (algorithm == B43_SEC_ALGO_WEP40 ||
 		    algorithm == B43_SEC_ALGO_WEP104) {
@@ -3618,13 +3621,14 @@ out_unlock:
 		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
 		       "mac: %s\n",
 		       cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
 		       print_mac(mac, addr));
 		b43_dump_keymemory(dev);
 	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	write_unlock(&wl->tx_lock);
+	spin_unlock_irq(&wl->irq_lock);
 	mutex_unlock(&wl->mutex);
 
 	return err;
 }
 
 static void b43_op_configure_filter(struct ieee80211_hw *hw,

-- 
Greetings, Michael.
