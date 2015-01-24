Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:65064 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbbAXRyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:54:13 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] mac80111: Add BIP-CMAC-256 cipher
Date: Sat, 24 Jan 2015 19:52:08 +0200
Message-ID: <1422121929-18238-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20150124_185416_685210_123F9F5C)
In-Reply-To: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows mac80211 to configure BIP-CMAC-256 to the driver and also
use software-implementation within mac80211 when the driver does not
support this with hardware accelaration.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/ieee80211.h  |  9 +++++
 net/mac80211/aes_cmac.c    | 34 +++++++++++++----
 net/mac80211/aes_cmac.h    |  5 ++-
 net/mac80211/cfg.c         |  2 +
 net/mac80211/debugfs_key.c |  4 ++
 net/mac80211/key.c         | 14 ++++++-
 net/mac80211/main.c        | 13 ++++---
 net/mac80211/rx.c          | 21 ++++++++---
 net/mac80211/tx.c          |  3 ++
 net/mac80211/wpa.c         | 92 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wpa.h         |  4 ++
 11 files changed, 180 insertions(+), 21 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index dbf417b..b9c7897 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1017,6 +1017,15 @@ struct ieee80211_mmie {
 	u8 mic[8];
 } __packed;
 
+/* Management MIC information element (IEEE 802.11w) for GMAC and CMAC-256 */
+struct ieee80211_mmie_16 {
+	u8 element_id;
+	u8 length;
+	__le16 key_id;
+	u8 sequence_number[6];
+	u8 mic[16];
+} __packed;
+
 struct ieee80211_vendor_ie {
 	u8 element_id;
 	u8 len;
diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index 9b9009f..4192806 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -18,8 +18,8 @@
 #include "key.h"
 #include "aes_cmac.h"
 
-#define AES_CMAC_KEY_LEN 16
 #define CMAC_TLEN 8 /* CMAC TLen = 64 bits (8 octets) */
+#define CMAC_TLEN_256 16 /* CMAC TLen = 128 bits (16 octets) */
 #define AAD_LEN 20
 
 
@@ -35,9 +35,9 @@ static void gf_mulx(u8 *pad)
 		pad[AES_BLOCK_SIZE - 1] ^= 0x87;
 }
 
-
-static void aes_128_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
-				const u8 *addr[], const size_t *len, u8 *mac)
+static void aes_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
+			    const u8 *addr[], const size_t *len, u8 *mac,
+			    size_t mac_len)
 {
 	u8 cbc[AES_BLOCK_SIZE], pad[AES_BLOCK_SIZE];
 	const u8 *pos, *end;
@@ -88,7 +88,7 @@ static void aes_128_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
 	for (i = 0; i < AES_BLOCK_SIZE; i++)
 		pad[i] ^= cbc[i];
 	crypto_cipher_encrypt_one(tfm, pad, pad);
-	memcpy(mac, pad, CMAC_TLEN);
+	memcpy(mac, pad, mac_len);
 }
 
 
@@ -107,17 +107,35 @@ void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
 	addr[2] = zero;
 	len[2] = CMAC_TLEN;
 
-	aes_128_cmac_vector(tfm, 3, addr, len, mic);
+	aes_cmac_vector(tfm, 3, addr, len, mic, CMAC_TLEN);
 }
 
+void ieee80211_aes_cmac_256(struct crypto_cipher *tfm, const u8 *aad,
+			    const u8 *data, size_t data_len, u8 *mic)
+{
+	const u8 *addr[3];
+	size_t len[3];
+	u8 zero[CMAC_TLEN_256];
+
+	memset(zero, 0, CMAC_TLEN_256);
+	addr[0] = aad;
+	len[0] = AAD_LEN;
+	addr[1] = data;
+	len[1] = data_len - CMAC_TLEN_256;
+	addr[2] = zero;
+	len[2] = CMAC_TLEN_256;
+
+	aes_cmac_vector(tfm, 3, addr, len, mic, CMAC_TLEN_256);
+}
 
-struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[])
+struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[],
+						   size_t key_len)
 {
 	struct crypto_cipher *tfm;
 
 	tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
 	if (!IS_ERR(tfm))
-		crypto_cipher_setkey(tfm, key, AES_CMAC_KEY_LEN);
+		crypto_cipher_setkey(tfm, key, key_len);
 
 	return tfm;
 }
diff --git a/net/mac80211/aes_cmac.h b/net/mac80211/aes_cmac.h
index 0ce6487..3702041 100644
--- a/net/mac80211/aes_cmac.h
+++ b/net/mac80211/aes_cmac.h
@@ -11,9 +11,12 @@
 
 #include <linux/crypto.h>
 
-struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[]);
+struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[],
+						   size_t key_len);
 void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
 			const u8 *data, size_t data_len, u8 *mic);
+void ieee80211_aes_cmac_256(struct crypto_cipher *tfm, const u8 *aad,
+			    const u8 *data, size_t data_len, u8 *mic);
 void ieee80211_aes_cmac_key_free(struct crypto_cipher *tfm);
 
 #endif /* AES_CMAC_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ef84441..b7e528b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -164,6 +164,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		break;
@@ -362,6 +363,7 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		params.seq_len = 6;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		pn64 = atomic64_read(&key->u.aes_cmac.tx_pn);
 		seq[0] = pn64;
 		seq[1] = pn64 >> 8;
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 64de07b..d1b60eb 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -101,6 +101,7 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		pn = atomic64_read(&key->u.aes_cmac.tx_pn);
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
 				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
@@ -153,6 +154,7 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 		len = p - buf;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		rpn = key->u.aes_cmac.rx_pn;
 		p += scnprintf(p, sizeof(buf)+buf-p,
 			       "%02x%02x%02x%02x%02x%02x\n",
@@ -191,6 +193,7 @@ static ssize_t key_replays_read(struct file *file, char __user *userbuf,
 		len = scnprintf(buf, sizeof(buf), "%u\n", key->u.ccmp.replays);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		len = scnprintf(buf, sizeof(buf), "%u\n",
 				key->u.aes_cmac.replays);
 		break;
@@ -214,6 +217,7 @@ static ssize_t key_icverrors_read(struct file *file, char __user *userbuf,
 
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		len = scnprintf(buf, sizeof(buf), "%u\n",
 				key->u.aes_cmac.icverrors);
 		break;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 83c6108..7ceea9d 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -165,6 +165,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		/* all of these we can do in software - if driver can */
@@ -417,8 +418,12 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		}
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		key->conf.iv_len = 0;
-		key->conf.icv_len = sizeof(struct ieee80211_mmie);
+		if (cipher == WLAN_CIPHER_SUITE_AES_CMAC)
+			key->conf.icv_len = sizeof(struct ieee80211_mmie);
+		else
+			key->conf.icv_len = sizeof(struct ieee80211_mmie_16);
 		if (seq)
 			for (j = 0; j < IEEE80211_CMAC_PN_LEN; j++)
 				key->u.aes_cmac.rx_pn[j] =
@@ -428,7 +433,7 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		 * it does not need to be initialized for every packet.
 		 */
 		key->u.aes_cmac.tfm =
-			ieee80211_aes_cmac_key_setup(key_data);
+			ieee80211_aes_cmac_key_setup(key_data, key_len);
 		if (IS_ERR(key->u.aes_cmac.tfm)) {
 			err = PTR_ERR(key->u.aes_cmac.tfm);
 			kfree(key);
@@ -481,6 +486,7 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 		break;
 	case WLAN_CIPHER_SUITE_GCMP:
@@ -804,6 +810,7 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		seq->ccmp.pn[0] = pn64 >> 40;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		pn64 = atomic64_read(&key->u.aes_cmac.tx_pn);
 		seq->ccmp.pn[5] = pn64;
 		seq->ccmp.pn[4] = pn64 >> 8;
@@ -854,6 +861,7 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		memcpy(seq->ccmp.pn, pn, IEEE80211_CCMP_PN_LEN);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		if (WARN_ON(tid != 0))
 			return;
 		pn = key->u.aes_cmac.rx_pn;
@@ -897,6 +905,7 @@ void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		atomic64_set(&key->u.ccmp.tx_pn, pn64);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		pn64 = (u64)seq->aes_cmac.pn[5] |
 		       ((u64)seq->aes_cmac.pn[4] << 8) |
 		       ((u64)seq->aes_cmac.pn[3] << 16) |
@@ -948,6 +957,7 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		memcpy(pn, seq->ccmp.pn, IEEE80211_CCMP_PN_LEN);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		if (WARN_ON(tid != 0))
 			return;
 		pn = key->u.aes_cmac.rx_pn;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a5ad2d5..053a17c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -671,7 +671,8 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		WLAN_CIPHER_SUITE_GCMP_256,
 
 		/* keep last -- depends on hw flags! */
-		WLAN_CIPHER_SUITE_AES_CMAC
+		WLAN_CIPHER_SUITE_AES_CMAC,
+		WLAN_CIPHER_SUITE_BIP_CMAC_256,
 	};
 
 	if (local->hw.flags & IEEE80211_HW_SW_CRYPTO_CONTROL ||
@@ -710,7 +711,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
 		if (!have_mfp)
-			local->hw.wiphy->n_cipher_suites--;
+			local->hw.wiphy->n_cipher_suites -= 2;
 
 		if (!have_wep) {
 			local->hw.wiphy->cipher_suites += 2;
@@ -736,9 +737,9 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		if (have_wep)
 			n_suites += 2;
 
-		/* check if we have AES_CMAC */
+		/* check if we have AES_CMAC, BIP-CMAC-256 */
 		if (have_mfp)
-			n_suites++;
+			n_suites += 2;
 
 		suites = kmalloc(sizeof(u32) * n_suites, GFP_KERNEL);
 		if (!suites)
@@ -755,8 +756,10 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 			suites[w++] = WLAN_CIPHER_SUITE_WEP104;
 		}
 
-		if (have_mfp)
+		if (have_mfp) {
 			suites[w++] = WLAN_CIPHER_SUITE_AES_CMAC;
+			suites[w++] = WLAN_CIPHER_SUITE_BIP_CMAC_256;
+		}
 
 		for (r = 0; r < local->hw.n_cipher_schemes; r++)
 			suites[w++] = cs[r].cipher;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1bcec37..79d3c91 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -647,6 +647,7 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *hdr = (struct ieee80211_mgmt *) skb->data;
 	struct ieee80211_mmie *mmie;
+	struct ieee80211_mmie_16 *mmie16;
 
 	if (skb->len < 24 + sizeof(*mmie) || !is_multicast_ether_addr(hdr->da))
 		return -1;
@@ -656,11 +657,18 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 
 	mmie = (struct ieee80211_mmie *)
 		(skb->data + skb->len - sizeof(*mmie));
-	if (mmie->element_id != WLAN_EID_MMIE ||
-	    mmie->length != sizeof(*mmie) - 2)
-		return -1;
-
-	return le16_to_cpu(mmie->key_id);
+	if (mmie->element_id == WLAN_EID_MMIE &&
+	    mmie->length == sizeof(*mmie) - 2)
+		return le16_to_cpu(mmie->key_id);
+
+	mmie16 = (struct ieee80211_mmie_16 *)
+		(skb->data + skb->len - sizeof(*mmie16));
+	if (skb->len >= 24 + sizeof(*mmie16) &&
+	    mmie16->element_id == WLAN_EID_MMIE &&
+	    mmie16->length == sizeof(*mmie16) - 2)
+		return le16_to_cpu(mmie16->key_id);
+
+	return -1;
 }
 
 static int iwl80211_get_cs_keyid(const struct ieee80211_cipher_scheme *cs,
@@ -1658,6 +1666,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		result = ieee80211_crypto_aes_cmac_decrypt(rx);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		result = ieee80211_crypto_aes_cmac_256_decrypt(rx);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		result = ieee80211_crypto_gcmp_decrypt(rx);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 360773b..0127a95 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -639,6 +639,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 					ieee80211_is_mgmt(hdr->frame_control);
 			break;
 		case WLAN_CIPHER_SUITE_AES_CMAC:
+		case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 			if (!ieee80211_is_mgmt(hdr->frame_control))
 				tx->key = NULL;
 			break;
@@ -1019,6 +1020,8 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 		return ieee80211_crypto_ccmp_encrypt(tx, true);
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		return ieee80211_crypto_aes_cmac_encrypt(tx);
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		return ieee80211_crypto_aes_cmac_256_encrypt(tx);
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		return ieee80211_crypto_gcmp_encrypt(tx);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 1edb5f0..92c3dc7 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -957,6 +957,48 @@ ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+ieee80211_tx_result
+ieee80211_crypto_aes_cmac_256_encrypt(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_key *key = tx->key;
+	struct ieee80211_mmie_16 *mmie;
+	u8 aad[20];
+	u64 pn64;
+
+	if (WARN_ON(skb_queue_len(&tx->skbs) != 1))
+		return TX_DROP;
+
+	skb = skb_peek(&tx->skbs);
+
+	info = IEEE80211_SKB_CB(skb);
+
+	if (info->control.hw_key)
+		return TX_CONTINUE;
+
+	if (WARN_ON(skb_tailroom(skb) < sizeof(*mmie)))
+		return TX_DROP;
+
+	mmie = (struct ieee80211_mmie_16 *)skb_put(skb, sizeof(*mmie));
+	mmie->element_id = WLAN_EID_MMIE;
+	mmie->length = sizeof(*mmie) - 2;
+	mmie->key_id = cpu_to_le16(key->conf.keyidx);
+
+	/* PN = PN + 1 */
+	pn64 = atomic64_inc_return(&key->u.aes_cmac.tx_pn);
+
+	bip_ipn_set64(mmie->sequence_number, pn64);
+
+	bip_aad(skb, aad);
+
+	/* MIC = AES-256-CMAC(IGTK, AAD || Management Frame Body || MMIE, 128)
+	 */
+	ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
+			       skb->data + 24, skb->len - 24, mmie->mic);
+
+	return TX_CONTINUE;
+}
 
 ieee80211_rx_result
 ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
@@ -1008,6 +1050,56 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
+ieee80211_rx_result
+ieee80211_crypto_aes_cmac_256_decrypt(struct ieee80211_rx_data *rx)
+{
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_key *key = rx->key;
+	struct ieee80211_mmie_16 *mmie;
+	u8 aad[20], mic[16], ipn[6];
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_is_mgmt(hdr->frame_control))
+		return RX_CONTINUE;
+
+	/* management frames are already linear */
+
+	if (skb->len < 24 + sizeof(*mmie))
+		return RX_DROP_UNUSABLE;
+
+	mmie = (struct ieee80211_mmie_16 *)
+		(skb->data + skb->len - sizeof(*mmie));
+	if (mmie->element_id != WLAN_EID_MMIE ||
+	    mmie->length != sizeof(*mmie) - 2)
+		return RX_DROP_UNUSABLE; /* Invalid MMIE */
+
+	bip_ipn_swap(ipn, mmie->sequence_number);
+
+	if (memcmp(ipn, key->u.aes_cmac.rx_pn, 6) <= 0) {
+		key->u.aes_cmac.replays++;
+		return RX_DROP_UNUSABLE;
+	}
+
+	if (!(status->flag & RX_FLAG_DECRYPTED)) {
+		/* hardware didn't decrypt/verify MIC */
+		bip_aad(skb, aad);
+		ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
+				       skb->data + 24, skb->len - 24, mic);
+		if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+			key->u.aes_cmac.icverrors++;
+			return RX_DROP_UNUSABLE;
+		}
+	}
+
+	memcpy(key->u.aes_cmac.rx_pn, ipn, 6);
+
+	/* Remove MMIE */
+	skb_trim(skb, skb->len - sizeof(*mmie));
+
+	return RX_CONTINUE;
+}
+
 ieee80211_tx_result
 ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx)
 {
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index ccf6c0c..1edfc58 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -30,8 +30,12 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx, bool ccmp256);
 
 ieee80211_tx_result
 ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_tx_result
+ieee80211_crypto_aes_cmac_256_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_rx_result
+ieee80211_crypto_aes_cmac_256_decrypt(struct ieee80211_rx_data *rx);
 ieee80211_tx_result
 ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
-- 
1.9.1

