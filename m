Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f221.google.com ([209.85.218.221]:64788 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZG0Ung (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 16:43:36 -0400
Received: by mail-bw0-f221.google.com with SMTP id 21so498289bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 13:43:36 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Jul 2009 22:43:36 +0200
Message-ID: <83a869cd0907271343g6111794ejff963258a52f546@mail.gmail.com>
Subject: [RESEND] [PATCH] b43 : remove old kidx API
From: gregor kowski <gregor.kowski@gmail.com>
To: bcm43xx-dev@lists.berlios.de
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove old kidx API.
This simplify the code, and fix a potential key overflow.

Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Index: linux-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/main.c	2009-07-25
10:58:31.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/main.c	2009-07-27
20:40:14.000000000 +0000
@@ -776,13 +776,11 @@
 	unsigned int i;
 	u32 offset;
 	u16 value;
-	u16 kidx;

 	/* Key index/algo block */
-	kidx = b43_kidx_to_fw(dev, index);
-	value = ((kidx << 4) | algorithm);
+	value = ((index << 4) | algorithm);
 	b43_shm_write16(dev, B43_SHM_SHARED,
-			B43_SHM_SH_KEYIDXBLOCK + (kidx * 2), value);
+			B43_SHM_SH_KEYIDXBLOCK + (index * 2), value);

 	/* Write the key to the Key Table Pointer offset */
 	offset = dev->ktp + (index * B43_SEC_KEYSIZE);
@@ -796,10 +794,7 @@
 static void keymac_write(struct b43_wldev *dev, u8 index, const u8 *addr)
 {
 	u32 addrtmp[2] = { 0, 0, };
-	u8 per_sta_keys_start = 8;
-
-	if (b43_new_kidx_api(dev))
-		per_sta_keys_start = 4;
+	const u8 per_sta_keys_start = 4;

 	B43_WARN_ON(index < per_sta_keys_start);
 	/* We have two default TX keys and possibly two default RX keys.
@@ -846,10 +841,7 @@
 			 const u8 *key, size_t key_len, const u8 *mac_addr)
 {
 	u8 buf[B43_SEC_KEYSIZE] = { 0, };
-	u8 per_sta_keys_start = 8;
-
-	if (b43_new_kidx_api(dev))
-		per_sta_keys_start = 4;
+	const u8 per_sta_keys_start = 4;

 	B43_WARN_ON(index >= dev->max_nr_keys);
 	B43_WARN_ON(key_len > B43_SEC_KEYSIZE);
@@ -872,7 +864,6 @@
 			 struct ieee80211_key_conf *keyconf)
 {
 	int i;
-	int sta_keys_start;

 	if (key_len > B43_SEC_KEYSIZE)
 		return -EINVAL;
@@ -881,12 +872,9 @@
 		B43_WARN_ON(dev->key[i].keyconf == keyconf);
 	}
 	if (index < 0) {
+		const int per_sta_keys_start = 4;
 		/* Pairwise key. Get an empty slot for the key. */
-		if (b43_new_kidx_api(dev))
-			sta_keys_start = 4;
-		else
-			sta_keys_start = 8;
-		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
+		for (i = per_sta_keys_start; i < dev->max_nr_keys; i++) {
 			if (!dev->key[i].keyconf) {
 				/* found empty */
 				index = i;
@@ -901,11 +889,6 @@
 		B43_WARN_ON(index > 3);

 	do_key_write(dev, index, algorithm, key, key_len, mac_addr);
-	if ((index <= 3) && !b43_new_kidx_api(dev)) {
-		/* Default RX key */
-		B43_WARN_ON(mac_addr);
-		do_key_write(dev, index + 4, algorithm, key, key_len, NULL);
-	}
 	keyconf->hw_key_idx = index;
 	dev->key[index].keyconf = keyconf;

@@ -918,10 +901,6 @@
 		return -EINVAL;
 	do_key_write(dev, index, B43_SEC_ALGO_NONE,
 		     NULL, B43_SEC_KEYSIZE, NULL);
-	if ((index <= 3) && !b43_new_kidx_api(dev)) {
-		do_key_write(dev, index + 4, B43_SEC_ALGO_NONE,
-			     NULL, B43_SEC_KEYSIZE, NULL);
-	}
 	dev->key[index].keyconf = NULL;

 	return 0;
@@ -2972,7 +2951,8 @@

 static void b43_security_init(struct b43_wldev *dev)
 {
-	dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
+	dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 54 : 20;
+	B43_WARN_ON(dev->fw.rev < 351);
 	B43_WARN_ON(dev->max_nr_keys > ARRAY_SIZE(dev->key));
 	dev->ktp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_KTP);
 	/* KTP is a word address, but we address SHM bytewise.
@@ -2981,7 +2961,7 @@
 	dev->ktp *= 2;
 	if (dev->dev->id.revision >= 5) {
 		/* Number of RCMTA address slots */
-		b43_write16(dev, B43_MMIO_RCMTA_COUNT, dev->max_nr_keys - 8);
+		b43_write16(dev, B43_MMIO_RCMTA_COUNT, dev->max_nr_keys - 4);
 	}
 	b43_clear_keys(dev);
 }
Index: linux-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/xmit.c	2009-07-25
10:58:31.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/xmit.c	2009-07-27
20:40:14.000000000 +0000
@@ -252,7 +252,6 @@
 		/* Hardware appends ICV. */
 		plcp_fragment_len += info->control.hw_key->icv_len;

-		key_idx = b43_kidx_to_fw(dev, key_idx);
 		mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
 			   B43_TXH_MAC_KEYIDX;
 		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
@@ -577,7 +576,6 @@
 		/* We must adjust the key index here. We want the "physical"
 		 * key index, but the ucode passed it slightly different.
 		 */
-		keyidx = b43_kidx_to_raw(dev, keyidx);
 		B43_WARN_ON(keyidx >= dev->max_nr_keys);

 		if (dev->key[keyidx].algorithm != B43_SEC_ALGO_NONE) {
Index: linux-2.6/drivers/net/wireless/b43/xmit.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/xmit.h	2009-07-25
10:58:30.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/xmit.h	2009-07-27
20:40:14.000000000 +0000
@@ -301,36 +301,4 @@
 void b43_tx_suspend(struct b43_wldev *dev);
 void b43_tx_resume(struct b43_wldev *dev);

-
-/* Helper functions for converting the key-table index from "firmware-format"
- * to "raw-format" and back. The firmware API changed for this at
some revision.
- * We need to account for that here. */
-static inline int b43_new_kidx_api(struct b43_wldev *dev)
-{
-	/* FIXME: Not sure the change was at rev 351 */
-	return (dev->fw.rev >= 351);
-}
-static inline u8 b43_kidx_to_fw(struct b43_wldev *dev, u8 raw_kidx)
-{
-	u8 firmware_kidx;
-	if (b43_new_kidx_api(dev)) {
-		firmware_kidx = raw_kidx;
-	} else {
-		if (raw_kidx >= 4)	/* Is per STA key? */
-			firmware_kidx = raw_kidx - 4;
-		else
-			firmware_kidx = raw_kidx;	/* TX default key */
-	}
-	return firmware_kidx;
-}
-static inline u8 b43_kidx_to_raw(struct b43_wldev *dev, u8 firmware_kidx)
-{
-	u8 raw_kidx;
-	if (b43_new_kidx_api(dev))
-		raw_kidx = firmware_kidx;
-	else
-		raw_kidx = firmware_kidx + 4;	/* RX default keys or per STA keys */
-	return raw_kidx;
-}
-
 #endif /* B43_XMIT_H_ */
