Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1GFUAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 16:00:40 -0400
Subject: [PATCH 3/2] mac80211: fix CMAC races
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110706100929.554431961@sipsolutions.net> (sfid-20110706_121632_072401_EB6BF86E)
References: <20110706100929.554431961@sipsolutions.net>
	 (sfid-20110706_121632_072401_EB6BF86E)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 22:00:35 +0200
Message-ID: <1309982435.3893.13.camel@jlt3.sipsolutions.net> (sfid-20110706_220043_182104_89614FBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just like TKIP and CCMP, CMAC has the PN race.
It might not actually be possible to hit it now
since there aren't multiple ACs for management
frames, but fix it anyway.

Also move scratch buffers onto the stack.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/aes_cmac.c    |    8 ++++----
 net/mac80211/aes_cmac.h    |    2 +-
 net/mac80211/cfg.c         |   13 +++++++------
 net/mac80211/debugfs_key.c |    7 +++----
 net/mac80211/key.h         |    5 +----
 net/mac80211/wpa.c         |   30 +++++++++++++++++-------------
 6 files changed, 33 insertions(+), 32 deletions(-)

--- a/net/mac80211/key.h	2011-07-06 21:56:09.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-06 21:57:51.000000000 +0200
@@ -97,14 +97,11 @@ struct ieee80211_key {
 #endif
 		} ccmp;
 		struct {
-			u8 tx_pn[6];
+			atomic64_t tx_pn;
 			u8 rx_pn[6];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
-			/* scratch buffers for virt_to_page() (crypto API) */
-			u8 tx_crypto_buf[2 * AES_BLOCK_LEN];
-			u8 rx_crypto_buf[2 * AES_BLOCK_LEN];
 		} aes_cmac;
 	} u;
 
--- a/net/mac80211/wpa.c	2011-07-06 21:56:26.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-07-06 21:57:51.000000000 +0200
@@ -523,6 +523,16 @@ static void bip_aad(struct sk_buff *skb,
 }
 
 
+static inline void bip_ipn_set64(u8 *d, u64 pn)
+{
+	*d++ = pn;
+	*d++ = pn >> 8;
+	*d++ = pn >> 16;
+	*d++ = pn >> 24;
+	*d++ = pn >> 32;
+	*d = pn >> 40;
+}
+
 static inline void bip_ipn_swap(u8 *d, const u8 *s)
 {
 	*d++ = s[5];
@@ -541,8 +551,8 @@ ieee80211_crypto_aes_cmac_encrypt(struct
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_mmie *mmie;
-	u8 *pn, aad[20];
-	int i;
+	u8 aad[20];
+	u64 pn64;
 
 	if (info->control.hw_key)
 		return 0;
@@ -556,22 +566,17 @@ ieee80211_crypto_aes_cmac_encrypt(struct
 	mmie->key_id = cpu_to_le16(key->conf.keyidx);
 
 	/* PN = PN + 1 */
-	pn = key->u.aes_cmac.tx_pn;
+	pn64 = atomic64_inc_return(&key->u.aes_cmac.tx_pn);
 
-	for (i = sizeof(key->u.aes_cmac.tx_pn) - 1; i >= 0; i--) {
-		pn[i]++;
-		if (pn[i])
-			break;
-	}
-	bip_ipn_swap(mmie->sequence_number, pn);
+	bip_ipn_set64(mmie->sequence_number, pn64);
 
 	bip_aad(skb, aad);
 
 	/*
 	 * MIC = AES-128-CMAC(IGTK, AAD || Management Frame Body || MMIE, 64)
 	 */
-	ieee80211_aes_cmac(key->u.aes_cmac.tfm, key->u.aes_cmac.tx_crypto_buf,
-			   aad, skb->data + 24, skb->len - 24, mmie->mic);
+	ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
+			   skb->data + 24, skb->len - 24, mmie->mic);
 
 	return TX_CONTINUE;
 }
@@ -609,8 +614,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		/* hardware didn't decrypt/verify MIC */
 		bip_aad(skb, aad);
-		ieee80211_aes_cmac(key->u.aes_cmac.tfm,
-				   key->u.aes_cmac.rx_crypto_buf, aad,
+		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
 				   skb->data + 24, skb->len - 24, mic);
 		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
 			key->u.aes_cmac.icverrors++;
--- a/net/mac80211/aes_cmac.h	2011-07-06 21:56:09.000000000 +0200
+++ b/net/mac80211/aes_cmac.h	2011-07-06 21:57:51.000000000 +0200
@@ -12,7 +12,7 @@
 #include <linux/crypto.h>
 
 struct crypto_cipher * ieee80211_aes_cmac_key_setup(const u8 key[]);
-void ieee80211_aes_cmac(struct crypto_cipher *tfm, u8 *scratch, const u8 *aad,
+void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
 			const u8 *data, size_t data_len, u8 *mic);
 void ieee80211_aes_cmac_key_free(struct crypto_cipher *tfm);
 
--- a/net/mac80211/aes_cmac.c	2011-07-06 21:56:09.000000000 +0200
+++ b/net/mac80211/aes_cmac.c	2011-07-06 21:57:51.000000000 +0200
@@ -35,10 +35,10 @@ static void gf_mulx(u8 *pad)
 }
 
 
-static void aes_128_cmac_vector(struct crypto_cipher *tfm, u8 *scratch,
-				size_t num_elem,
+static void aes_128_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
 				const u8 *addr[], const size_t *len, u8 *mac)
 {
+	u8 scratch[2 * AES_BLOCK_SIZE];
 	u8 *cbc, *pad;
 	const u8 *pos, *end;
 	size_t i, e, left, total_len;
@@ -95,7 +95,7 @@ static void aes_128_cmac_vector(struct c
 }
 
 
-void ieee80211_aes_cmac(struct crypto_cipher *tfm, u8 *scratch, const u8 *aad,
+void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
 			const u8 *data, size_t data_len, u8 *mic)
 {
 	const u8 *addr[3];
@@ -110,7 +110,7 @@ void ieee80211_aes_cmac(struct crypto_ci
 	addr[2] = zero;
 	len[2] = CMAC_TLEN;
 
-	aes_128_cmac_vector(tfm, scratch, 3, addr, len, mic);
+	aes_128_cmac_vector(tfm, 3, addr, len, mic);
 }
 
 
--- a/net/mac80211/cfg.c	2011-07-06 21:56:09.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-07-06 21:57:51.000000000 +0200
@@ -268,12 +268,13 @@ static int ieee80211_get_key(struct wiph
 		params.seq_len = 6;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		seq[0] = key->u.aes_cmac.tx_pn[5];
-		seq[1] = key->u.aes_cmac.tx_pn[4];
-		seq[2] = key->u.aes_cmac.tx_pn[3];
-		seq[3] = key->u.aes_cmac.tx_pn[2];
-		seq[4] = key->u.aes_cmac.tx_pn[1];
-		seq[5] = key->u.aes_cmac.tx_pn[0];
+		pn64 = atomic64_read(&key->u.aes_cmac.tx_pn);
+		seq[0] = pn64;
+		seq[1] = pn64 >> 8;
+		seq[2] = pn64 >> 16;
+		seq[3] = pn64 >> 24;
+		seq[4] = pn64 >> 32;
+		seq[5] = pn64 >> 40;
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
--- a/net/mac80211/debugfs_key.c	2011-07-06 21:56:09.000000000 +0200
+++ b/net/mac80211/debugfs_key.c	2011-07-06 21:57:51.000000000 +0200
@@ -78,7 +78,6 @@ KEY_OPS(algorithm);
 static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
-	const u8 *tpn;
 	u64 pn;
 	char buf[20];
 	int len;
@@ -101,10 +100,10 @@ static ssize_t key_tx_spec_read(struct f
 				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		tpn = key->u.aes_cmac.tx_pn;
+		pn = atomic64_read(&key->u.aes_cmac.tx_pn);
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
-				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4],
-				tpn[5]);
+				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
+				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
 		break;
 	default:
 		return 0;


