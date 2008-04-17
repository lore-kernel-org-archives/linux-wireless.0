Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:19135 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYDQUNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 16:13:47 -0400
Received: by wx-out-0506.google.com with SMTP id h31so221112wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 13:13:47 -0700 (PDT)
Subject: [PATCH 5/7] mac80211: add a struct to hold tkip context
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 13:13:49 -0700
Message-Id: <1208463229.17196.27.camel@brick> (sfid-20080417_211452_363804_0599A206)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/cfg.c         |    4 +-
 net/mac80211/debugfs_key.c |    8 +++---
 net/mac80211/key.h         |   17 +++++++------
 net/mac80211/tkip.c        |   54 ++++++++++++++++++++++----------------------
 net/mac80211/wpa.c         |   16 ++++++------
 5 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 699d97b..17d0656 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -256,8 +256,8 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	case ALG_TKIP:
 		params.cipher = WLAN_CIPHER_SUITE_TKIP;
 
-		iv32 = key->u.tkip.iv32;
-		iv16 = key->u.tkip.iv16;
+		iv32 = key->u.tkip.tx.iv32;
+		iv16 = key->u.tkip.tx.iv16;
 
 		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 		    sdata->local->ops->get_tkip_seq)
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 879e721..c13b08b 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -97,8 +97,8 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 		break;
 	case ALG_TKIP:
 		len = scnprintf(buf, sizeof(buf), "%08x %04x\n",
-				key->u.tkip.iv32,
-				key->u.tkip.iv16);
+				key->u.tkip.tx.iv32,
+				key->u.tkip.tx.iv16);
 		break;
 	case ALG_CCMP:
 		tpn = key->u.ccmp.tx_pn;
@@ -128,8 +128,8 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "%08x %04x\n",
-				       key->u.tkip.iv32_rx[i],
-				       key->u.tkip.iv16_rx[i]);
+				       key->u.tkip.rx[i].iv32,
+				       key->u.tkip.rx[i].iv16);
 		len = p - buf;
 		break;
 	case ALG_CCMP:
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index f52c3df..a0f774a 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -69,6 +69,13 @@ enum ieee80211_internal_key_flags {
 	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(5),
 };
 
+struct tkip_ctx {
+	u32 iv32;
+	u16 iv16;
+	u16 p1k[5];
+	int initialized;
+};
+
 struct ieee80211_key {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -85,16 +92,10 @@ struct ieee80211_key {
 	union {
 		struct {
 			/* last used TSC */
-			u32 iv32;
-			u16 iv16;
-			u16 p1k[5];
-			int tx_initialized;
+			struct tkip_ctx tx;
 
 			/* last received RSC */
-			u32 iv32_rx[NUM_RX_DATA_QUEUES];
-			u16 iv16_rx[NUM_RX_DATA_QUEUES];
-			u16 p1k_rx[NUM_RX_DATA_QUEUES][5];
-			int rx_initialized[NUM_RX_DATA_QUEUES];
+			struct tkip_ctx rx[NUM_RX_DATA_QUEUES];
 		} tkip;
 		struct {
 			u8 tx_pn[6];
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 8cdf053..d74c91e 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -138,7 +138,7 @@ u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 	*pos++ = iv1;
 	*pos++ = iv2;
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
-	put_unaligned_le32(key->u.tkip.iv32, pos);
+	put_unaligned_le32(key->u.tkip.tx.iv32, pos);
 	return pos + 4;
 }
 
@@ -146,16 +146,16 @@ static void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
-	if (key->u.tkip.iv16 == 0 || !key->u.tkip.tx_initialized) {
+	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   key->u.tkip.iv32, key->u.tkip.p1k);
-		key->u.tkip.tx_initialized = 1;
+				   key->u.tkip.tx.iv32, key->u.tkip.tx.p1k);
+		key->u.tkip.tx.initialized = 1;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k,
+	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv16, rc4key);
+			   key->u.tkip.tx.iv16, rc4key);
 }
 
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
@@ -179,9 +179,9 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
 			iv16, iv32);
 
-	if (iv32 != key->u.tkip.iv32) {
+	if (iv32 != key->u.tkip.tx.iv32) {
 		printk(KERN_DEBUG "skb: iv32 = 0x%08x key: iv32 = 0x%08x\n",
-			iv32, key->u.tkip.iv32);
+			iv32, key->u.tkip.tx.iv32);
 		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
 			"fragmented packet\n");
 	}
@@ -190,19 +190,19 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
-	if (iv16 == 0 || !key->u.tkip.tx_initialized) {
+	if (iv16 == 0 || !key->u.tkip.tx.initialized) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			iv32, key->u.tkip.p1k);
-		key->u.tkip.tx_initialized = 1;
+			iv32, key->u.tkip.tx.p1k);
+		key->u.tkip.tx.initialized = 1;
 	}
 
 	if (type == IEEE80211_TKIP_P1_KEY) {
-		memcpy(outkey, key->u.tkip.p1k, sizeof(u16) * 5);
+		memcpy(outkey, key->u.tkip.tx.p1k, sizeof(u16) * 5);
 		return;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k,
+	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
@@ -263,33 +263,33 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 	if ((keyid >> 6) != key->conf.keyidx)
 		return TKIP_DECRYPT_INVALID_KEYIDX;
 
-	if (key->u.tkip.rx_initialized[queue] &&
-	    (iv32 < key->u.tkip.iv32_rx[queue] ||
-	     (iv32 == key->u.tkip.iv32_rx[queue] &&
-	      iv16 <= key->u.tkip.iv16_rx[queue]))) {
+	if (key->u.tkip.rx[queue].initialized &&
+	    (iv32 < key->u.tkip.rx[queue].iv32 ||
+	     (iv32 == key->u.tkip.rx[queue].iv32 &&
+	      iv16 <= key->u.tkip.rx[queue].iv16))) {
 #ifdef CONFIG_TKIP_DEBUG
 		DECLARE_MAC_BUF(mac);
 		printk(KERN_DEBUG "TKIP replay detected for RX frame from "
 		       "%s (RX IV (%04x,%02x) <= prev. IV (%04x,%02x)\n",
 		       print_mac(mac, ta),
-		       iv32, iv16, key->u.tkip.iv32_rx[queue],
-		       key->u.tkip.iv16_rx[queue]);
+		       iv32, iv16, key->u.tkip.rx[queue].iv32,
+		       key->u.tkip.rx[queue].iv16);
 #endif /* CONFIG_TKIP_DEBUG */
 		return TKIP_DECRYPT_REPLAY;
 	}
 
 	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
-		key->u.tkip.rx_initialized[queue] = 1;
+		key->u.tkip.rx[queue].initialized = 1;
 		goto done;
 	}
 
-	if (!key->u.tkip.rx_initialized[queue] ||
-	    key->u.tkip.iv32_rx[queue] != iv32) {
-		key->u.tkip.rx_initialized[queue] = 1;
+	if (!key->u.tkip.rx[queue].initialized ||
+	    key->u.tkip.rx[queue].iv32 != iv32) {
+		key->u.tkip.rx[queue].initialized = 1;
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   iv32, key->u.tkip.p1k_rx[queue]);
+				   iv32, key->u.tkip.rx[queue].p1k);
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
@@ -303,7 +303,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 			printk("\n");
 			printk(KERN_DEBUG "TKIP decrypt: P1K=");
 			for (i = 0; i < 5; i++)
-				printk("%04x ", key->u.tkip.p1k_rx[queue][i]);
+				printk("%04x ", key->u.tkip.rx[queue].p1k[i]);
 			printk("\n");
 		}
 #endif /* CONFIG_TKIP_DEBUG */
@@ -318,11 +318,11 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 
 			key->local->ops->update_tkip_key(
 				local_to_hw(key->local), &key->conf,
-				sta_addr, iv32, key->u.tkip.p1k_rx[queue]);
+				sta_addr, iv32, key->u.tkip.rx[queue].p1k);
 		}
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
+	tkip_mixing_phase2(key->u.tkip.rx[queue].p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 45709ad..fbd9299 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -176,8 +176,8 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.iv32_rx[rx->queue] = rx->tkip_iv32;
-	rx->key->u.tkip.iv16_rx[rx->queue] = rx->tkip_iv16;
+	rx->key->u.tkip.rx[rx->queue].iv32 = rx->tkip_iv32;
+	rx->key->u.tkip.rx[rx->queue].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
 }
@@ -214,19 +214,19 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
 	pos += hdrlen;
 
 	/* Increase IV for the frame */
-	key->u.tkip.iv16++;
-	if (key->u.tkip.iv16 == 0)
-		key->u.tkip.iv32++;
+	key->u.tkip.tx.iv16++;
+	if (key->u.tkip.tx.iv16 == 0)
+		key->u.tkip.tx.iv32++;
 
 	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		hdr = (struct ieee80211_hdr *)skb->data;
 
 		/* hwaccel - with preallocated room for IV */
 		ieee80211_tkip_add_iv(pos, key,
-				      (u8) (key->u.tkip.iv16 >> 8),
-				      (u8) (((key->u.tkip.iv16 >> 8) | 0x20) &
+				      (u8) (key->u.tkip.tx.iv16 >> 8),
+				      (u8) (((key->u.tkip.tx.iv16 >> 8) | 0x20) &
 					    0x7f),
-				      (u8) key->u.tkip.iv16);
+				      (u8) key->u.tkip.tx.iv16);
 
 		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
-- 
1.5.5.144.g3e42


