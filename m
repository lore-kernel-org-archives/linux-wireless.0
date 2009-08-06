Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39114 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZHFIhk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 04:37:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix hardware key index handling
Date: Thu, 6 Aug 2009 10:36:50 +0200
Cc: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de,
	gregor kowski <gregor.kowski@gmail.com>
MIME-Version: 1.0
Message-Id: <200908061036.50631.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the hardware encryption keys index and array size handling.

Thanks to Gregor Kowski for reporting this issue.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This should probably go as a bugfix.
(Does this actually fix the PHY transmission errors? I don't see them anymore...
Note that you need to enable debugging to see them.)


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-08-06 09:58:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-08-06 09:58:53.000000000 +0200
@@ -493,6 +493,10 @@ enum {
 
 /* Max size of a security key */
 #define B43_SEC_KEYSIZE			16
+/* Max number of group keys */
+#define B43_NR_GROUP_KEYS		4
+/* Max number of pairwise keys */
+#define B43_NR_PAIRWISE_KEYS		50
 /* Security algorithms. */
 enum {
 	B43_SEC_ALGO_NONE = 0,	/* unencrypted, as of TX header. */
@@ -819,8 +823,7 @@ struct b43_wldev {
 
 	/* encryption/decryption */
 	u16 ktp;		/* Key table pointer */
-	u8 max_nr_keys;
-	struct b43_key key[58];
+	struct b43_key key[B43_NR_GROUP_KEYS * 2 + B43_NR_PAIRWISE_KEYS];
 
 	/* Firmware data */
 	struct b43_firmware fw;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-08-06 09:58:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-08-06 10:28:03.000000000 +0200
@@ -796,18 +796,19 @@ static void key_write(struct b43_wldev *
 static void keymac_write(struct b43_wldev *dev, u8 index, const u8 *addr)
 {
 	u32 addrtmp[2] = { 0, 0, };
-	u8 per_sta_keys_start = 8;
+	u8 pairwise_keys_start = B43_NR_GROUP_KEYS * 2;
 
 	if (b43_new_kidx_api(dev))
-		per_sta_keys_start = 4;
+		pairwise_keys_start = B43_NR_GROUP_KEYS;
 
-	B43_WARN_ON(index < per_sta_keys_start);
-	/* We have two default TX keys and possibly two default RX keys.
+	B43_WARN_ON(index < pairwise_keys_start);
+	/* We have four default TX keys and possibly four default RX keys.
 	 * Physical mac 0 is mapped to physical key 4 or 8, depending
 	 * on the firmware version.
 	 * So we must adjust the index here.
 	 */
-	index -= per_sta_keys_start;
+	index -= pairwise_keys_start;
+	B43_WARN_ON(index >= B43_NR_PAIRWISE_KEYS);
 
 	if (addr) {
 		addrtmp[0] = addr[0];
@@ -818,27 +819,11 @@ static void keymac_write(struct b43_wlde
 		addrtmp[1] |= ((u32) (addr[5]) << 8);
 	}
 
-	if (dev->dev->id.revision >= 5) {
-		/* Receive match transmitter address mechanism */
-		b43_shm_write32(dev, B43_SHM_RCMTA,
-				(index * 2) + 0, addrtmp[0]);
-		b43_shm_write16(dev, B43_SHM_RCMTA,
-				(index * 2) + 1, addrtmp[1]);
-	} else {
-		/* RXE (Receive Engine) and
-		 * PSM (Programmable State Machine) mechanism
-		 */
-		if (index < 8) {
-			/* TODO write to RCM 16, 19, 22 and 25 */
-		} else {
-			b43_shm_write32(dev, B43_SHM_SHARED,
-					B43_SHM_SH_PSM + (index * 6) + 0,
-					addrtmp[0]);
-			b43_shm_write16(dev, B43_SHM_SHARED,
-					B43_SHM_SH_PSM + (index * 6) + 4,
-					addrtmp[1]);
-		}
-	}
+	/* Receive match transmitter address (RCMTA) mechanism */
+	b43_shm_write32(dev, B43_SHM_RCMTA,
+			(index * 2) + 0, addrtmp[0]);
+	b43_shm_write16(dev, B43_SHM_RCMTA,
+			(index * 2) + 1, addrtmp[1]);
 }
 
 static void do_key_write(struct b43_wldev *dev,
@@ -846,20 +831,20 @@ static void do_key_write(struct b43_wlde
 			 const u8 *key, size_t key_len, const u8 *mac_addr)
 {
 	u8 buf[B43_SEC_KEYSIZE] = { 0, };
-	u8 per_sta_keys_start = 8;
+	u8 pairwise_keys_start = B43_NR_GROUP_KEYS * 2;
 
 	if (b43_new_kidx_api(dev))
-		per_sta_keys_start = 4;
+		pairwise_keys_start = B43_NR_GROUP_KEYS;
 
-	B43_WARN_ON(index >= dev->max_nr_keys);
+	B43_WARN_ON(index >= ARRAY_SIZE(dev->key));
 	B43_WARN_ON(key_len > B43_SEC_KEYSIZE);
 
-	if (index >= per_sta_keys_start)
+	if (index >= pairwise_keys_start)
 		keymac_write(dev, index, NULL);	/* First zero out mac. */
 	if (key)
 		memcpy(buf, key, key_len);
 	key_write(dev, index, algorithm, buf);
-	if (index >= per_sta_keys_start)
+	if (index >= pairwise_keys_start)
 		keymac_write(dev, index, mac_addr);
 
 	dev->key[index].algorithm = algorithm;
@@ -872,21 +857,24 @@ static int b43_key_write(struct b43_wlde
 			 struct ieee80211_key_conf *keyconf)
 {
 	int i;
-	int sta_keys_start;
+	int pairwise_keys_start;
 
 	if (key_len > B43_SEC_KEYSIZE)
 		return -EINVAL;
-	for (i = 0; i < dev->max_nr_keys; i++) {
+	for (i = 0; i < ARRAY_SIZE(dev->key); i++) {
 		/* Check that we don't already have this key. */
 		B43_WARN_ON(dev->key[i].keyconf == keyconf);
 	}
 	if (index < 0) {
 		/* Pairwise key. Get an empty slot for the key. */
 		if (b43_new_kidx_api(dev))
-			sta_keys_start = 4;
+			pairwise_keys_start = B43_NR_GROUP_KEYS;
 		else
-			sta_keys_start = 8;
-		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
+			pairwise_keys_start = B43_NR_GROUP_KEYS * 2;
+		for (i = pairwise_keys_start;
+		     i < pairwise_keys_start + B43_NR_PAIRWISE_KEYS;
+		     i++) {
+			B43_WARN_ON(i >= ARRAY_SIZE(dev->key));
 			if (!dev->key[i].keyconf) {
 				/* found empty */
 				index = i;
@@ -914,7 +902,7 @@ static int b43_key_write(struct b43_wlde
 
 static int b43_key_clear(struct b43_wldev *dev, int index)
 {
-	if (B43_WARN_ON((index < 0) || (index >= dev->max_nr_keys)))
+	if (B43_WARN_ON((index < 0) || (index >= ARRAY_SIZE(dev->key))))
 		return -EINVAL;
 	do_key_write(dev, index, B43_SEC_ALGO_NONE,
 		     NULL, B43_SEC_KEYSIZE, NULL);
@@ -929,15 +917,19 @@ static int b43_key_clear(struct b43_wlde
 
 static void b43_clear_keys(struct b43_wldev *dev)
 {
-	int i;
+	int i, count;
 
-	for (i = 0; i < dev->max_nr_keys; i++)
+	if (b43_new_kidx_api(dev))
+		count = B43_NR_GROUP_KEYS + B43_NR_PAIRWISE_KEYS;
+	else
+		count = B43_NR_GROUP_KEYS * 2 + B43_NR_PAIRWISE_KEYS;
+	for (i = 0; i < count; i++)
 		b43_key_clear(dev, i);
 }
 
 static void b43_dump_keymemory(struct b43_wldev *dev)
 {
-	unsigned int i, index, offset;
+	unsigned int i, index, count, offset, pairwise_keys_start;
 	u8 mac[ETH_ALEN];
 	u16 algo;
 	u32 rcmta0;
@@ -951,7 +943,14 @@ static void b43_dump_keymemory(struct b4
 	hf = b43_hf_read(dev);
 	b43dbg(dev->wl, "Hardware key memory dump:  USEDEFKEYS=%u\n",
 	       !!(hf & B43_HF_USEDEFKEYS));
-	for (index = 0; index < dev->max_nr_keys; index++) {
+	if (b43_new_kidx_api(dev)) {
+		pairwise_keys_start = B43_NR_GROUP_KEYS;
+		count = B43_NR_GROUP_KEYS + B43_NR_PAIRWISE_KEYS;
+	} else {
+		pairwise_keys_start = B43_NR_GROUP_KEYS * 2;
+		count = B43_NR_GROUP_KEYS * 2 + B43_NR_PAIRWISE_KEYS;
+	}
+	for (index = 0; index < count; index++) {
 		key = &(dev->key[index]);
 		printk(KERN_DEBUG "Key slot %02u: %s",
 		       index, (key->keyconf == NULL) ? " " : "*");
@@ -965,11 +964,11 @@ static void b43_dump_keymemory(struct b4
 				      B43_SHM_SH_KEYIDXBLOCK + (index * 2));
 		printk("   Algo: %04X/%02X", algo, key->algorithm);
 
-		if (index >= 4) {
+		if (index >= pairwise_keys_start) {
 			rcmta0 = b43_shm_read32(dev, B43_SHM_RCMTA,
-						((index - 4) * 2) + 0);
+						((index - pairwise_keys_start) * 2) + 0);
 			rcmta1 = b43_shm_read16(dev, B43_SHM_RCMTA,
-						((index - 4) * 2) + 1);
+						((index - pairwise_keys_start) * 2) + 1);
 			*((__le32 *)(&mac[0])) = cpu_to_le32(rcmta0);
 			*((__le16 *)(&mac[4])) = cpu_to_le16(rcmta1);
 			printk("   MAC: %pM", mac);
@@ -2990,17 +2989,14 @@ error:
 
 static void b43_security_init(struct b43_wldev *dev)
 {
-	dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
-	B43_WARN_ON(dev->max_nr_keys > ARRAY_SIZE(dev->key));
 	dev->ktp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_KTP);
 	/* KTP is a word address, but we address SHM bytewise.
 	 * So multiply by two.
 	 */
 	dev->ktp *= 2;
-	if (dev->dev->id.revision >= 5) {
-		/* Number of RCMTA address slots */
-		b43_write16(dev, B43_MMIO_RCMTA_COUNT, dev->max_nr_keys - 8);
-	}
+	/* Number of RCMTA address slots */
+	b43_write16(dev, B43_MMIO_RCMTA_COUNT, B43_NR_PAIRWISE_KEYS);
+	/* Clear the key memory. */
 	b43_clear_keys(dev);
 }
 
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-08-06 09:58:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-08-06 09:58:53.000000000 +0200
@@ -237,7 +237,7 @@ int b43_generate_txhdr(struct b43_wldev 
 		int wlhdr_len;
 		size_t iv_len;
 
-		B43_WARN_ON(key_idx >= dev->max_nr_keys);
+		B43_WARN_ON(key_idx >= ARRAY_SIZE(dev->key));
 		key = &(dev->key[key_idx]);
 
 		if (unlikely(!key->keyconf)) {
@@ -578,7 +578,7 @@ void b43_rx(struct b43_wldev *dev, struc
 		 * key index, but the ucode passed it slightly different.
 		 */
 		keyidx = b43_kidx_to_raw(dev, keyidx);
-		B43_WARN_ON(keyidx >= dev->max_nr_keys);
+		B43_WARN_ON(keyidx >= ARRAY_SIZE(dev->key));
 
 		if (dev->key[keyidx].algorithm != B43_SEC_ALGO_NONE) {
 			wlhdr_len = ieee80211_hdrlen(fctl);

-- 
Greetings, Michael.
