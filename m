Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37668 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668AbbFBJQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 05:16:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: move TX PN to public part of key struct
Date: Tue,  2 Jun 2015 11:16:49 +0200
Message-Id: <1433236609-9011-1-git-send-email-johannes@sipsolutions.net> (sfid-20150602_111707_747772_63813480)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For drivers supporting TSO or similar features, but that still have
PN assignment in software, there's a need to have some memory to
store the current PN value. As mac80211 already stores this and it's
somewhat complicated to add a per-driver area to the key struct (due
to the dynamic sizing thereof) it makes sense to just move the TX PN
to the keyconf, i.e. the public part of the key struct.

As TKIP is more complicated and we won't able to offload it in this
way right now (fast-xmit is skipped for TKIP unless the HW does it
all, and our hardware needs MMIC calculation in software) I've not
moved that for now - it's possible but requires exposing a lot of
the internal TKIP state.

As an bonus side effect, we can remove a lot of code by assuming the
keyseq struct has a certain layout - with BUILD_BUG_ON to verify it.

This might also improve performance, since now TX and RX no longer
share a cacheline.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  4 +++
 net/mac80211/cfg.c         | 59 ++++++----------------------------
 net/mac80211/debugfs_key.c | 17 +---------
 net/mac80211/key.c         | 80 +++++++++++++---------------------------------
 net/mac80211/key.h         |  4 ---
 net/mac80211/tx.c          | 10 +-----
 net/mac80211/wpa.c         | 10 +++---
 7 files changed, 42 insertions(+), 142 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 887fe95b9805..39e864b35083 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1479,6 +1479,9 @@ enum ieee80211_key_flags {
  *	wants to be given when a frame is transmitted and needs to be
  *	encrypted in hardware.
  * @cipher: The key's cipher suite selector.
+ * @tx_pn: PN used for TX on non-TKIP keys, may be used by the driver
+ *	as well if it needs to do software PN assignment by itself
+ *	(e.g. due to TSO)
  * @flags: key flags, see &enum ieee80211_key_flags.
  * @keyidx: the key index (0-3)
  * @keylen: key material length
@@ -1491,6 +1494,7 @@ enum ieee80211_key_flags {
  * @iv_len: The IV length for this key type
  */
 struct ieee80211_key_conf {
+	atomic64_t tx_pn;
 	u32 cipher;
 	u8 icv_len;
 	u8 iv_len;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bb9f83640b46..02f48c848ef5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -361,66 +361,25 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
-		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
-			drv_get_key_seq(sdata->local, key, &kseq);
-			memcpy(seq, kseq.ccmp.pn, 6);
-		} else {
-			pn64 = atomic64_read(&key->u.ccmp.tx_pn);
-			seq[0] = pn64;
-			seq[1] = pn64 >> 8;
-			seq[2] = pn64 >> 16;
-			seq[3] = pn64 >> 24;
-			seq[4] = pn64 >> 32;
-			seq[5] = pn64 >> 40;
-		}
-		params.seq = seq;
-		params.seq_len = 6;
-		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
-		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
-			drv_get_key_seq(sdata->local, key, &kseq);
-			memcpy(seq, kseq.aes_cmac.pn, 6);
-		} else {
-			pn64 = atomic64_read(&key->u.aes_cmac.tx_pn);
-			seq[0] = pn64;
-			seq[1] = pn64 >> 8;
-			seq[2] = pn64 >> 16;
-			seq[3] = pn64 >> 24;
-			seq[4] = pn64 >> 32;
-			seq[5] = pn64 >> 40;
-		}
-		params.seq = seq;
-		params.seq_len = 6;
-		break;
+		BUILD_BUG_ON(offsetof(typeof(kseq), ccmp) !=
+			     offsetof(typeof(kseq), aes_cmac));
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
-		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
-			drv_get_key_seq(sdata->local, key, &kseq);
-			memcpy(seq, kseq.aes_gmac.pn, 6);
-		} else {
-			pn64 = atomic64_read(&key->u.aes_gmac.tx_pn);
-			seq[0] = pn64;
-			seq[1] = pn64 >> 8;
-			seq[2] = pn64 >> 16;
-			seq[3] = pn64 >> 24;
-			seq[4] = pn64 >> 32;
-			seq[5] = pn64 >> 40;
-		}
-		params.seq = seq;
-		params.seq_len = 6;
-		break;
+		BUILD_BUG_ON(offsetof(typeof(kseq), ccmp) !=
+			     offsetof(typeof(kseq), aes_gmac));
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
+		BUILD_BUG_ON(offsetof(typeof(kseq), ccmp) !=
+			     offsetof(typeof(kseq), gcmp));
+
 		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 		    !(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
 			drv_get_key_seq(sdata->local, key, &kseq);
-			memcpy(seq, kseq.gcmp.pn, 6);
+			memcpy(seq, kseq.ccmp.pn, 6);
 		} else {
-			pn64 = atomic64_read(&key->u.gcmp.tx_pn);
+			pn64 = atomic64_read(&key->conf.tx_pn);
 			seq[0] = pn64;
 			seq[1] = pn64 >> 8;
 			seq[2] = pn64 >> 16;
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 71ac1b5f4da5..e82bf1e9d7a8 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -95,28 +95,13 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		pn = atomic64_read(&key->u.ccmp.tx_pn);
-		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
-				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
-				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
-		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-		pn = atomic64_read(&key->u.aes_cmac.tx_pn);
-		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
-				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
-				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
-		break;
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		pn = atomic64_read(&key->u.aes_gmac.tx_pn);
-		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
-				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
-				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
-		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		pn = atomic64_read(&key->u.gcmp.tx_pn);
+		pn = atomic64_read(&key->conf.tx_pn);
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
 				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
 				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 2e677376c958..9a4a4bfafdc2 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -832,27 +832,19 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		pn64 = atomic64_read(&key->u.ccmp.tx_pn);
-		seq->ccmp.pn[5] = pn64;
-		seq->ccmp.pn[4] = pn64 >> 8;
-		seq->ccmp.pn[3] = pn64 >> 16;
-		seq->ccmp.pn[2] = pn64 >> 24;
-		seq->ccmp.pn[1] = pn64 >> 32;
-		seq->ccmp.pn[0] = pn64 >> 40;
-		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-		pn64 = atomic64_read(&key->u.aes_cmac.tx_pn);
-		seq->ccmp.pn[5] = pn64;
-		seq->ccmp.pn[4] = pn64 >> 8;
-		seq->ccmp.pn[3] = pn64 >> 16;
-		seq->ccmp.pn[2] = pn64 >> 24;
-		seq->ccmp.pn[1] = pn64 >> 32;
-		seq->ccmp.pn[0] = pn64 >> 40;
-		break;
+		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
+			     offsetof(typeof(*seq), aes_cmac));
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		pn64 = atomic64_read(&key->u.aes_gmac.tx_pn);
+		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
+			     offsetof(typeof(*seq), aes_gmac));
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
+			     offsetof(typeof(*seq), gcmp));
+		pn64 = atomic64_read(&key->conf.tx_pn);
 		seq->ccmp.pn[5] = pn64;
 		seq->ccmp.pn[4] = pn64 >> 8;
 		seq->ccmp.pn[3] = pn64 >> 16;
@@ -860,16 +852,6 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		seq->ccmp.pn[1] = pn64 >> 32;
 		seq->ccmp.pn[0] = pn64 >> 40;
 		break;
-	case WLAN_CIPHER_SUITE_GCMP:
-	case WLAN_CIPHER_SUITE_GCMP_256:
-		pn64 = atomic64_read(&key->u.gcmp.tx_pn);
-		seq->gcmp.pn[5] = pn64;
-		seq->gcmp.pn[4] = pn64 >> 8;
-		seq->gcmp.pn[3] = pn64 >> 16;
-		seq->gcmp.pn[2] = pn64 >> 24;
-		seq->gcmp.pn[1] = pn64 >> 32;
-		seq->gcmp.pn[0] = pn64 >> 40;
-		break;
 	default:
 		WARN_ON(1);
 	}
@@ -944,43 +926,25 @@ void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		pn64 = (u64)seq->ccmp.pn[5] |
-		       ((u64)seq->ccmp.pn[4] << 8) |
-		       ((u64)seq->ccmp.pn[3] << 16) |
-		       ((u64)seq->ccmp.pn[2] << 24) |
-		       ((u64)seq->ccmp.pn[1] << 32) |
-		       ((u64)seq->ccmp.pn[0] << 40);
-		atomic64_set(&key->u.ccmp.tx_pn, pn64);
-		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-		pn64 = (u64)seq->aes_cmac.pn[5] |
-		       ((u64)seq->aes_cmac.pn[4] << 8) |
-		       ((u64)seq->aes_cmac.pn[3] << 16) |
-		       ((u64)seq->aes_cmac.pn[2] << 24) |
-		       ((u64)seq->aes_cmac.pn[1] << 32) |
-		       ((u64)seq->aes_cmac.pn[0] << 40);
-		atomic64_set(&key->u.aes_cmac.tx_pn, pn64);
-		break;
+		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
+			     offsetof(typeof(*seq), aes_cmac));
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		pn64 = (u64)seq->aes_gmac.pn[5] |
-		       ((u64)seq->aes_gmac.pn[4] << 8) |
-		       ((u64)seq->aes_gmac.pn[3] << 16) |
-		       ((u64)seq->aes_gmac.pn[2] << 24) |
-		       ((u64)seq->aes_gmac.pn[1] << 32) |
-		       ((u64)seq->aes_gmac.pn[0] << 40);
-		atomic64_set(&key->u.aes_gmac.tx_pn, pn64);
-		break;
+		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
+			     offsetof(typeof(*seq), aes_gmac));
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		pn64 = (u64)seq->gcmp.pn[5] |
-		       ((u64)seq->gcmp.pn[4] << 8) |
-		       ((u64)seq->gcmp.pn[3] << 16) |
-		       ((u64)seq->gcmp.pn[2] << 24) |
-		       ((u64)seq->gcmp.pn[1] << 32) |
-		       ((u64)seq->gcmp.pn[0] << 40);
-		atomic64_set(&key->u.gcmp.tx_pn, pn64);
+		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
+			     offsetof(typeof(*seq), gcmp));
+		pn64 = (u64)seq->ccmp.pn[5] |
+		       ((u64)seq->ccmp.pn[4] << 8) |
+		       ((u64)seq->ccmp.pn[3] << 16) |
+		       ((u64)seq->ccmp.pn[2] << 24) |
+		       ((u64)seq->ccmp.pn[1] << 32) |
+		       ((u64)seq->ccmp.pn[0] << 40);
+		atomic64_set(&key->conf.tx_pn, pn64);
 		break;
 	default:
 		WARN_ON(1);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index df430a618764..ac747e442139 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -77,7 +77,6 @@ struct ieee80211_key {
 			u32 mic_failures;
 		} tkip;
 		struct {
-			atomic64_t tx_pn;
 			/*
 			 * Last received packet number. The first
 			 * IEEE80211_NUM_TIDS counters are used with Data
@@ -89,21 +88,18 @@ struct ieee80211_key {
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 		} ccmp;
 		struct {
-			atomic64_t tx_pn;
 			u8 rx_pn[IEEE80211_CMAC_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
 		} aes_cmac;
 		struct {
-			atomic64_t tx_pn;
 			u8 rx_pn[IEEE80211_GMAC_PN_LEN];
 			struct crypto_aead *tfm;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
 		} aes_gmac;
 		struct {
-			atomic64_t tx_pn;
 			/* Last received packet number. The first
 			 * IEEE80211_NUM_TIDS counters are used with Data
 			 * frames and the last counter is used with Robust
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8df134213adf..dbef1b881b3d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2813,17 +2813,9 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		switch (fast_tx->key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
 		case WLAN_CIPHER_SUITE_CCMP_256:
-			pn = atomic64_inc_return(&fast_tx->key->u.ccmp.tx_pn);
-			crypto_hdr[0] = pn;
-			crypto_hdr[1] = pn >> 8;
-			crypto_hdr[4] = pn >> 16;
-			crypto_hdr[5] = pn >> 24;
-			crypto_hdr[6] = pn >> 32;
-			crypto_hdr[7] = pn >> 40;
-			break;
 		case WLAN_CIPHER_SUITE_GCMP:
 		case WLAN_CIPHER_SUITE_GCMP_256:
-			pn = atomic64_inc_return(&fast_tx->key->u.gcmp.tx_pn);
+			pn = atomic64_inc_return(&fast_tx->key->conf.tx_pn);
 			crypto_hdr[0] = pn;
 			crypto_hdr[1] = pn >> 8;
 			crypto_hdr[4] = pn >> 16;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9d63d93c836e..943f7606527e 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -444,7 +444,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	hdr = (struct ieee80211_hdr *) pos;
 	pos += hdrlen;
 
-	pn64 = atomic64_inc_return(&key->u.ccmp.tx_pn);
+	pn64 = atomic64_inc_return(&key->conf.tx_pn);
 
 	pn[5] = pn64;
 	pn[4] = pn64 >> 8;
@@ -670,7 +670,7 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *)pos;
 	pos += hdrlen;
 
-	pn64 = atomic64_inc_return(&key->u.gcmp.tx_pn);
+	pn64 = atomic64_inc_return(&key->conf.tx_pn);
 
 	pn[5] = pn64;
 	pn[4] = pn64 >> 8;
@@ -940,7 +940,7 @@ ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx)
 	mmie->key_id = cpu_to_le16(key->conf.keyidx);
 
 	/* PN = PN + 1 */
-	pn64 = atomic64_inc_return(&key->u.aes_cmac.tx_pn);
+	pn64 = atomic64_inc_return(&key->conf.tx_pn);
 
 	bip_ipn_set64(mmie->sequence_number, pn64);
 
@@ -984,7 +984,7 @@ ieee80211_crypto_aes_cmac_256_encrypt(struct ieee80211_tx_data *tx)
 	mmie->key_id = cpu_to_le16(key->conf.keyidx);
 
 	/* PN = PN + 1 */
-	pn64 = atomic64_inc_return(&key->u.aes_cmac.tx_pn);
+	pn64 = atomic64_inc_return(&key->conf.tx_pn);
 
 	bip_ipn_set64(mmie->sequence_number, pn64);
 
@@ -1129,7 +1129,7 @@ ieee80211_crypto_aes_gmac_encrypt(struct ieee80211_tx_data *tx)
 	mmie->key_id = cpu_to_le16(key->conf.keyidx);
 
 	/* PN = PN + 1 */
-	pn64 = atomic64_inc_return(&key->u.aes_gmac.tx_pn);
+	pn64 = atomic64_inc_return(&key->conf.tx_pn);
 
 	bip_ipn_set64(mmie->sequence_number, pn64);
 
-- 
2.1.4

