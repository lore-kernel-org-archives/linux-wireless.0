Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43846 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZHSUfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 16:35:45 -0400
Received: by bwz19 with SMTP id 19so4992969bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 13:35:45 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 Aug 2009 22:35:45 +0200
Message-ID: <83a869cd0908191335u723f62c6p119ec4ed8cfb51c5@mail.gmail.com>
Subject: [PATCHv4] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: bcm43xx-dev@lists.berlios.de
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update v4 : add a warn_on in b43_op_update_tkip_key, update to last
driver change (key API).
Update v3 : add a module parameter to enable hw tkip, Coding style
fix, locking fix
Update v2 : work with qos, implement dump key, fix an issue with setting
random value on tkip key clear.

This add hardware tkip for b43.

Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Index: linux-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/dma.c	2009-08-10
20:35:33.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/dma.c	2009-08-10 20:35:43.000000000 +0000
@@ -1188,7 +1188,7 @@
 	header = &(ring->txhdr_cache[(slot / TX_SLOTS_PER_FRAME) * hdrsize]);
 	cookie = generate_cookie(ring, slot);
 	err = b43_generate_txhdr(ring->dev, header,
-				 skb->data, skb->len, info, cookie);
+				 skb, info, cookie);
 	if (unlikely(err)) {
 		ring->current_slot = old_top_slot;
 		ring->used_slots = old_used_slots;
Index: linux-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/main.c	2009-08-10
20:35:42.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/main.c	2009-08-19
20:31:39.000000000 +0000
@@ -80,6 +80,10 @@
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");

+static int modparam_hwtkip;
+module_param_named(hwtkip, modparam_hwtkip, int, 0444);
+MODULE_PARM_DESC(hwtkip, "Enable hardware tkip.");
+
 static int modparam_qos = 1;
 module_param_named(qos, modparam_qos, int, 0444);
 MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
@@ -826,6 +830,85 @@
 			(index * 2) + 1, addrtmp[1]);
 }

+/* The ucode will use phase1 key with TEK key to decrypt rx packets.
+ * When a packet is received, the iv32 is checked.
+ * - if it doesn't the packet is returned without modification (and software
+ *   decryption can be done). That's what happen when iv16 wrap.
+ * - if it does, the rc4 key is computed, and decryption is tried.
+ *   Either it will success and B43_RX_MAC_DEC is returned,
+ *   either it fails and B43_RX_MAC_DEC|B43_RX_MAC_DECERR is returned
+ *   and the packet is not usable (it got modified by the ucode).
+ * So in order to never have B43_RX_MAC_DECERR, we should provide
+ * a iv32 and phase1key that match. Because we drop packets in case of
+ * B43_RX_MAC_DECERR, if we have a correct iv32 but a wrong phase1key, all
+ * packets will be lost without higher layer knowing (ie no resync possible
+ * until next wrap).
+ *
+ * NOTE : this should support 50 key like RCMTA because
+ * (B43_SHM_SH_KEYIDXBLOCK - B43_SHM_SH_TKIPTSCTTAK)/14 = 50
+ */
+static void rx_tkip_phase1_write(struct b43_wldev *dev, u8 index, u32 iv32,
+		u16 *phase1key)
+{
+	unsigned int i;
+	u32 offset;
+	u8 pairwise_keys_start = B43_NR_GROUP_KEYS * 2;
+
+	if (!modparam_hwtkip)
+		return;
+
+	if (b43_new_kidx_api(dev))
+		pairwise_keys_start = B43_NR_GROUP_KEYS;
+
+	B43_WARN_ON(index < pairwise_keys_start);
+	/* We have four default TX keys and possibly four default RX keys.
+	 * Physical mac 0 is mapped to physical key 4 or 8, depending
+	 * on the firmware version.
+	 * So we must adjust the index here.
+	 */
+	index -= pairwise_keys_start;
+	B43_WARN_ON(index >= B43_NR_PAIRWISE_KEYS);
+
+	if (b43_debug(dev, B43_DBG_KEYS)) {
+		b43dbg(dev->wl, "rx_tkip_phase1_write : idx 0x%x, iv32 0x%x\n",
+				index, iv32);
+	}
+	/* Write the key to the  RX tkip shared mem */
+	offset = B43_SHM_SH_TKIPTSCTTAK + index * (10 + 4);
+	for (i = 0; i < 10; i += 2) {
+		b43_shm_write16(dev, B43_SHM_SHARED, offset + i,
+				phase1key ? phase1key[i / 2] : 0);
+	}
+	b43_shm_write16(dev, B43_SHM_SHARED, offset + i, iv32);
+	b43_shm_write16(dev, B43_SHM_SHARED, offset + i + 2, iv32 >> 16);
+}
+
+static void b43_op_update_tkip_key(struct ieee80211_hw *hw,
+			struct ieee80211_key_conf *keyconf, const u8 *addr,
+			u32 iv32, u16 *phase1key)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev;
+	int index = keyconf->hw_key_idx;
+
+	if (B43_WARN_ON(!modparam_hwtkip))
+		return;
+
+	mutex_lock(&wl->mutex);
+
+	dev = wl->current_dev;
+	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
+		goto out_unlock;
+
+	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
+
+	rx_tkip_phase1_write(dev, index, iv32, phase1key);
+	keymac_write(dev, index, addr);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+}
+
 static void do_key_write(struct b43_wldev *dev,
 			 u8 index, u8 algorithm,
 			 const u8 *key, size_t key_len, const u8 *mac_addr)
@@ -841,6 +924,19 @@

 	if (index >= pairwise_keys_start)
 		keymac_write(dev, index, NULL);	/* First zero out mac. */
+	if (algorithm == B43_SEC_ALGO_TKIP) {
+		/*
+		 * We should provide an initial iv32, phase1key pair.
+		 * We could start with iv32=0 and compute the corresponding
+		 * phase1key, but this means calling ieee80211_get_tkip_key
+		 * with a fake skb (or export other tkip function).
+		 * Because we are lazy we hope iv32 won't start with
+		 * 0xffffffff and let's b43_op_update_tkip_key provide a
+		 * correct pair.
+		 */
+		rx_tkip_phase1_write(dev, index, 0xffffffff, (u16*)buf);
+	} else if (index >= pairwise_keys_start) /* clear it */
+		rx_tkip_phase1_write(dev, index, 0, NULL);
 	if (key)
 		memcpy(buf, key, key_len);
 	key_write(dev, index, algorithm, buf);
@@ -859,6 +955,15 @@
 	int i;
 	int pairwise_keys_start;

+	/* For ALG_TKIP the key is encoded as a 256-bit (32 byte) data block:
+	 * 	- Temporal Encryption Key (128 bits)
+	 * 	- Temporal Authenticator Tx MIC Key (64 bits)
+	 * 	- Temporal Authenticator Rx MIC Key (64 bits)
+	 *
+	 * 	Hardware only store TEK
+	 */
+	if (algorithm == B43_SEC_ALGO_TKIP && key_len == 32)
+		key_len = 16;
 	if (key_len > B43_SEC_KEYSIZE)
 		return -EINVAL;
 	for (i = 0; i < ARRAY_SIZE(dev->key); i++) {
@@ -965,6 +1070,14 @@
 		printk("   Algo: %04X/%02X", algo, key->algorithm);

 		if (index >= pairwise_keys_start) {
+			if (key->algorithm == B43_SEC_ALGO_TKIP) {
+				printk("   TKIP: ");
+				offset = B43_SHM_SH_TKIPTSCTTAK + (index - 4) * (10 + 4);
+				for (i = 0; i < 14; i += 2) {
+					u16 tmp = b43_shm_read16(dev, B43_SHM_SHARED, offset + i);
+					printk("%02X%02X", (tmp & 0xFF), ((tmp >> 8) & 0xFF));
+				}
+			}
 			rcmta0 = b43_shm_read32(dev, B43_SHM_RCMTA,
 						((index - pairwise_keys_start) * 2) + 0);
 			rcmta1 = b43_shm_read16(dev, B43_SHM_RCMTA,
@@ -3587,8 +3700,10 @@

 	switch (cmd) {
 	case SET_KEY:
-		if (algorithm == B43_SEC_ALGO_TKIP) {
-			/* FIXME: No TKIP hardware encryption for now. */
+		if (algorithm == B43_SEC_ALGO_TKIP &&
+		    (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ||
+		    !modparam_hwtkip)) {
+			/* We support only pairwise key */
 			err = -EOPNOTSUPP;
 			goto out_unlock;
 		}
@@ -3618,6 +3733,8 @@
 				     b43_hf_read(dev) & ~B43_HF_USEDEFKEYS);
 		}
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		if (algorithm == B43_SEC_ALGO_TKIP)
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
 		break;
 	case DISABLE_KEY: {
 		err = b43_key_clear(dev, key->hw_key_idx);
@@ -4345,6 +4462,7 @@
 	.bss_info_changed	= b43_op_bss_info_changed,
 	.configure_filter	= b43_op_configure_filter,
 	.set_key		= b43_op_set_key,
+	.update_tkip_key	= b43_op_update_tkip_key,
 	.get_stats		= b43_op_get_stats,
 	.get_tx_stats		= b43_op_get_tx_stats,
 	.get_tsf		= b43_op_get_tsf,
Index: linux-2.6/drivers/net/wireless/b43/pio.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/pio.c	2009-08-10
20:35:33.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/pio.c	2009-08-10 20:35:43.000000000 +0000
@@ -461,8 +461,8 @@

 	cookie = generate_cookie(q, pack);
 	hdrlen = b43_txhdr_size(q->dev);
-	err = b43_generate_txhdr(q->dev, (u8 *)&txhdr, skb->data,
-				 skb->len, info, cookie);
+	err = b43_generate_txhdr(q->dev, (u8 *)&txhdr, skb,
+				 info, cookie);
 	if (err)
 		return err;

Index: linux-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/xmit.c	2009-08-10
20:35:42.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/xmit.c	2009-08-10
20:35:43.000000000 +0000
@@ -180,11 +180,12 @@
 /* Generate a TX data header. */
 int b43_generate_txhdr(struct b43_wldev *dev,
 		       u8 *_txhdr,
-		       const unsigned char *fragment_data,
-		       unsigned int fragment_len,
+		       struct sk_buff *skb_frag,
 		       struct ieee80211_tx_info *info,
 		       u16 cookie)
 {
+	const unsigned char *fragment_data = skb_frag->data;
+	unsigned int fragment_len = skb_frag->len;
 	struct b43_txhdr *txhdr = (struct b43_txhdr *)_txhdr;
 	const struct b43_phy *phy = &dev->phy;
 	const struct ieee80211_hdr *wlhdr =
@@ -258,9 +259,26 @@
 		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
 			   B43_TXH_MAC_KEYALG;
 		wlhdr_len = ieee80211_hdrlen(fctl);
-		iv_len = min((size_t) info->control.hw_key->iv_len,
-			     ARRAY_SIZE(txhdr->iv));
-		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
+		if (key->algorithm == B43_SEC_ALGO_TKIP) {
+			u16 phase1key[5];
+			int i;
+			/* we give the phase1key and iv16 here, the key is stored in
+			 * shm. With that the hardware can do phase 2 and encryption.
+			 */
+			ieee80211_get_tkip_key(info->control.hw_key, skb_frag,
+					IEEE80211_TKIP_P1_KEY, (u8*)phase1key);
+			/* phase1key is in host endian */
+			for (i = 0; i < 5; i++)
+				phase1key[i] = cpu_to_le16(phase1key[i]);
+
+			memcpy(txhdr->iv, phase1key, 10);
+			/* iv16 */
+			memcpy(txhdr->iv + 10, ((u8 *) wlhdr) + wlhdr_len, 3);
+		} else {
+			iv_len = min((size_t) info->control.hw_key->iv_len,
+				     ARRAY_SIZE(txhdr->iv));
+			memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
+		}
 	}
 	if (b43_is_old_txhdr_format(dev)) {
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->old_format.plcp),
Index: linux-2.6/drivers/net/wireless/b43/xmit.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/xmit.h	2009-08-10
20:35:33.000000000 +0000
+++ linux-2.6/drivers/net/wireless/b43/xmit.h	2009-08-10
20:35:43.000000000 +0000
@@ -176,8 +176,7 @@

 int b43_generate_txhdr(struct b43_wldev *dev,
 		       u8 * txhdr,
-		       const unsigned char *fragment_data,
-		       unsigned int fragment_len,
+		       struct sk_buff *skb_frag,
 		       struct ieee80211_tx_info *txctl, u16 cookie);

 /* Transmit Status */
