Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57742 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbbAXRyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:54:43 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] mac80111: Add BIP-GMAC-128 and BIP-GMAC-256 ciphers
Date: Sat, 24 Jan 2015 19:52:09 +0200
Message-ID: <1422121929-18238-6-git-send-email-jouni@qca.qualcomm.com> (sfid-20150124_185445_978246_54752795)
In-Reply-To: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows mac80211 to configure BIP-GMAC-128 and BIP-GMAC-256 to the
driver and also use software-implementation within mac80211 when the
driver does not support this with hardware accelaration.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/mac80211.h     |   5 +++
 net/mac80211/Makefile      |   1 +
 net/mac80211/aes_gmac.c    |  84 ++++++++++++++++++++++++++++++++++++
 net/mac80211/aes_gmac.h    |  20 +++++++++
 net/mac80211/cfg.c         |  14 ++++++
 net/mac80211/debugfs_key.c |  26 +++++++++++
 net/mac80211/key.c         |  60 ++++++++++++++++++++++++++
 net/mac80211/key.h         |   7 +++
 net/mac80211/main.c        |  12 ++++--
 net/mac80211/rx.c          |   4 ++
 net/mac80211/tx.c          |   5 +++
 net/mac80211/wpa.c         | 105 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wpa.h         |   4 ++
 13 files changed, 344 insertions(+), 3 deletions(-)
 create mode 100644 net/mac80211/aes_gmac.c
 create mode 100644 net/mac80211/aes_gmac.h

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ae66384..d52914b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4098,6 +4098,8 @@ void ieee80211_aes_cmac_calculate_k1_k2(struct ieee80211_key_conf *keyconf,
  *	reverse order than in packet)
  * @aes_cmac: PN data, most significant byte first (big endian,
  *	reverse order than in packet)
+ * @aes_gmac: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
  * @gcmp: PN data, most significant byte first (big endian,
  *	reverse order than in packet)
  */
@@ -4115,6 +4117,9 @@ struct ieee80211_key_seq {
 		} aes_cmac;
 		struct {
 			u8 pn[6];
+		} aes_gmac;
+		struct {
+			u8 pn[6];
 		} gcmp;
 	};
 };
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 0cbf936..3275f01 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -17,6 +17,7 @@ mac80211-y := \
 	aes_ccm.o \
 	aes_gcm.o \
 	aes_cmac.o \
+	aes_gmac.o \
 	cfg.o \
 	ethtool.o \
 	rx.o \
diff --git a/net/mac80211/aes_gmac.c b/net/mac80211/aes_gmac.c
new file mode 100644
index 0000000..1c72edc
--- /dev/null
+++ b/net/mac80211/aes_gmac.c
@@ -0,0 +1,84 @@
+/*
+ * AES-GMAC for IEEE 802.11 BIP-GMAC-128 and BIP-GMAC-256
+ * Copyright 2015, Qualcomm Atheros, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <crypto/aes.h>
+
+#include <net/mac80211.h>
+#include "key.h"
+#include "aes_gmac.h"
+
+#define GMAC_MIC_LEN 16
+#define GMAC_NONCE_LEN 12
+#define AAD_LEN 20
+
+int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
+		       const u8 *data, size_t data_len, u8 *mic)
+{
+	struct scatterlist sg[3], ct[1];
+	char aead_req_data[sizeof(struct aead_request) +
+			   crypto_aead_reqsize(tfm)]
+		__aligned(__alignof__(struct aead_request));
+	struct aead_request *aead_req = (void *)aead_req_data;
+	u8 zero[GMAC_MIC_LEN], iv[AES_BLOCK_SIZE];
+
+	if (data_len < GMAC_MIC_LEN)
+		return -EINVAL;
+
+	memset(aead_req, 0, sizeof(aead_req_data));
+
+	memset(zero, 0, GMAC_MIC_LEN);
+	sg_init_table(sg, 3);
+	sg_set_buf(&sg[0], aad, AAD_LEN);
+	sg_set_buf(&sg[1], data, data_len - GMAC_MIC_LEN);
+	sg_set_buf(&sg[2], zero, GMAC_MIC_LEN);
+
+	memcpy(iv, nonce, GMAC_NONCE_LEN);
+	memset(iv + GMAC_NONCE_LEN, 0, sizeof(iv) - GMAC_NONCE_LEN);
+	iv[AES_BLOCK_SIZE - 1] = 0x01;
+
+	sg_init_table(ct, 1);
+	sg_set_buf(&ct[0], mic, GMAC_MIC_LEN);
+
+	aead_request_set_tfm(aead_req, tfm);
+	aead_request_set_assoc(aead_req, sg, AAD_LEN + data_len);
+	aead_request_set_crypt(aead_req, NULL, ct, 0, iv);
+
+	crypto_aead_encrypt(aead_req);
+
+	return 0;
+}
+
+struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
+						 size_t key_len)
+{
+	struct crypto_aead *tfm;
+	int err;
+
+	tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+		return tfm;
+
+	err = crypto_aead_setkey(tfm, key, key_len);
+	if (!err)
+		return tfm;
+	if (!err)
+		err = crypto_aead_setauthsize(tfm, GMAC_MIC_LEN);
+
+	crypto_free_aead(tfm);
+	return ERR_PTR(err);
+}
+
+void ieee80211_aes_gmac_key_free(struct crypto_aead *tfm)
+{
+	crypto_free_aead(tfm);
+}
diff --git a/net/mac80211/aes_gmac.h b/net/mac80211/aes_gmac.h
new file mode 100644
index 0000000..d328204
--- /dev/null
+++ b/net/mac80211/aes_gmac.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2015, Qualcomm Atheros, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef AES_GMAC_H
+#define AES_GMAC_H
+
+#include <linux/crypto.h>
+
+struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
+						 size_t key_len);
+int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
+		       const u8 *data, size_t data_len, u8 *mic);
+void ieee80211_aes_gmac_key_free(struct crypto_aead *tfm);
+
+#endif /* AES_GMAC_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b7e528b..dd4ff36 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -165,6 +165,8 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		break;
@@ -374,6 +376,18 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		pn64 = atomic64_read(&key->u.aes_gmac.tx_pn);
+		seq[0] = pn64;
+		seq[1] = pn64 >> 8;
+		seq[2] = pn64 >> 16;
+		seq[3] = pn64 >> 24;
+		seq[4] = pn64 >> 32;
+		seq[5] = pn64 >> 40;
+		params.seq = seq;
+		params.seq_len = 6;
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		pn64 = atomic64_read(&key->u.gcmp.tx_pn);
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index d1b60eb..71ac1b5 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -107,6 +107,13 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
 				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		pn = atomic64_read(&key->u.aes_gmac.tx_pn);
+		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
+				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
+				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		pn = atomic64_read(&key->u.gcmp.tx_pn);
@@ -162,6 +169,15 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 			       rpn[3], rpn[4], rpn[5]);
 		len = p - buf;
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		rpn = key->u.aes_gmac.rx_pn;
+		p += scnprintf(p, sizeof(buf)+buf-p,
+			       "%02x%02x%02x%02x%02x%02x\n",
+			       rpn[0], rpn[1], rpn[2],
+			       rpn[3], rpn[4], rpn[5]);
+		len = p - buf;
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
@@ -197,6 +213,11 @@ static ssize_t key_replays_read(struct file *file, char __user *userbuf,
 		len = scnprintf(buf, sizeof(buf), "%u\n",
 				key->u.aes_cmac.replays);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		len = scnprintf(buf, sizeof(buf), "%u\n",
+				key->u.aes_gmac.replays);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		len = scnprintf(buf, sizeof(buf), "%u\n", key->u.gcmp.replays);
@@ -221,6 +242,11 @@ static ssize_t key_icverrors_read(struct file *file, char __user *userbuf,
 		len = scnprintf(buf, sizeof(buf), "%u\n",
 				key->u.aes_cmac.icverrors);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		len = scnprintf(buf, sizeof(buf), "%u\n",
+				key->u.aes_gmac.icverrors);
+		break;
 	default:
 		return 0;
 	}
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 7ceea9d..0825d76 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -24,6 +24,7 @@
 #include "debugfs_key.h"
 #include "aes_ccm.h"
 #include "aes_cmac.h"
+#include "aes_gmac.h"
 #include "aes_gcm.h"
 
 
@@ -166,6 +167,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		/* all of these we can do in software - if driver can */
@@ -440,6 +443,25 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 			return ERR_PTR(err);
 		}
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		key->conf.iv_len = 0;
+		key->conf.icv_len = sizeof(struct ieee80211_mmie_16);
+		if (seq)
+			for (j = 0; j < IEEE80211_GMAC_PN_LEN; j++)
+				key->u.aes_gmac.rx_pn[j] =
+					seq[IEEE80211_GMAC_PN_LEN - j - 1];
+		/* Initialize AES key state here as an optimization so that
+		 * it does not need to be initialized for every packet.
+		 */
+		key->u.aes_gmac.tfm =
+			ieee80211_aes_gmac_key_setup(key_data, key_len);
+		if (IS_ERR(key->u.aes_gmac.tfm)) {
+			err = PTR_ERR(key->u.aes_gmac.tfm);
+			kfree(key);
+			return ERR_PTR(err);
+		}
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		key->conf.iv_len = IEEE80211_GCMP_HDR_LEN;
@@ -489,6 +511,10 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		ieee80211_aes_gmac_key_free(key->u.aes_gmac.tfm);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		ieee80211_aes_gcm_key_free(key->u.gcmp.tfm);
@@ -819,6 +845,16 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		seq->ccmp.pn[1] = pn64 >> 32;
 		seq->ccmp.pn[0] = pn64 >> 40;
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		pn64 = atomic64_read(&key->u.aes_gmac.tx_pn);
+		seq->ccmp.pn[5] = pn64;
+		seq->ccmp.pn[4] = pn64 >> 8;
+		seq->ccmp.pn[3] = pn64 >> 16;
+		seq->ccmp.pn[2] = pn64 >> 24;
+		seq->ccmp.pn[1] = pn64 >> 32;
+		seq->ccmp.pn[0] = pn64 >> 40;
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		pn64 = atomic64_read(&key->u.gcmp.tx_pn);
@@ -867,6 +903,13 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		pn = key->u.aes_cmac.rx_pn;
 		memcpy(seq->aes_cmac.pn, pn, IEEE80211_CMAC_PN_LEN);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		if (WARN_ON(tid != 0))
+			return;
+		pn = key->u.aes_gmac.rx_pn;
+		memcpy(seq->aes_gmac.pn, pn, IEEE80211_GMAC_PN_LEN);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
@@ -914,6 +957,16 @@ void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		       ((u64)seq->aes_cmac.pn[0] << 40);
 		atomic64_set(&key->u.aes_cmac.tx_pn, pn64);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		pn64 = (u64)seq->aes_gmac.pn[5] |
+		       ((u64)seq->aes_gmac.pn[4] << 8) |
+		       ((u64)seq->aes_gmac.pn[3] << 16) |
+		       ((u64)seq->aes_gmac.pn[2] << 24) |
+		       ((u64)seq->aes_gmac.pn[1] << 32) |
+		       ((u64)seq->aes_gmac.pn[0] << 40);
+		atomic64_set(&key->u.aes_gmac.tx_pn, pn64);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		pn64 = (u64)seq->gcmp.pn[5] |
@@ -963,6 +1016,13 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		pn = key->u.aes_cmac.rx_pn;
 		memcpy(pn, seq->aes_cmac.pn, IEEE80211_CMAC_PN_LEN);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		if (WARN_ON(tid != 0))
+			return;
+		pn = key->u.aes_gmac.rx_pn;
+		memcpy(pn, seq->aes_gmac.pn, IEEE80211_GMAC_PN_LEN);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 27580da..d57a9915 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -96,6 +96,13 @@ struct ieee80211_key {
 		} aes_cmac;
 		struct {
 			atomic64_t tx_pn;
+			u8 rx_pn[IEEE80211_GMAC_PN_LEN];
+			struct crypto_aead *tfm;
+			u32 replays; /* dot11RSNAStatsCMACReplays */
+			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
+		} aes_gmac;
+		struct {
+			atomic64_t tx_pn;
 			/* Last received packet number. The first
 			 * IEEE80211_NUM_TIDS counters are used with Data
 			 * frames and the last counter is used with Robust
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 053a17c..5e09d35 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -673,6 +673,8 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		/* keep last -- depends on hw flags! */
 		WLAN_CIPHER_SUITE_AES_CMAC,
 		WLAN_CIPHER_SUITE_BIP_CMAC_256,
+		WLAN_CIPHER_SUITE_BIP_GMAC_128,
+		WLAN_CIPHER_SUITE_BIP_GMAC_256,
 	};
 
 	if (local->hw.flags & IEEE80211_HW_SW_CRYPTO_CONTROL ||
@@ -711,7 +713,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
 		if (!have_mfp)
-			local->hw.wiphy->n_cipher_suites -= 2;
+			local->hw.wiphy->n_cipher_suites -= 4;
 
 		if (!have_wep) {
 			local->hw.wiphy->cipher_suites += 2;
@@ -737,9 +739,11 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		if (have_wep)
 			n_suites += 2;
 
-		/* check if we have AES_CMAC, BIP-CMAC-256 */
+		/* check if we have AES_CMAC, BIP-CMAC-256, BIP-GMAC-128,
+		 * BIP-GMAC-256
+		 */
 		if (have_mfp)
-			n_suites += 2;
+			n_suites += 4;
 
 		suites = kmalloc(sizeof(u32) * n_suites, GFP_KERNEL);
 		if (!suites)
@@ -759,6 +763,8 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		if (have_mfp) {
 			suites[w++] = WLAN_CIPHER_SUITE_AES_CMAC;
 			suites[w++] = WLAN_CIPHER_SUITE_BIP_CMAC_256;
+			suites[w++] = WLAN_CIPHER_SUITE_BIP_GMAC_128;
+			suites[w++] = WLAN_CIPHER_SUITE_BIP_GMAC_256;
 		}
 
 		for (r = 0; r < local->hw.n_cipher_schemes; r++)
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 79d3c91..971c455 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1669,6 +1669,10 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		result = ieee80211_crypto_aes_cmac_256_decrypt(rx);
 		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		result = ieee80211_crypto_aes_gmac_decrypt(rx);
+		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		result = ieee80211_crypto_gcmp_decrypt(rx);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0127a95..5184fea 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -640,6 +640,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 			break;
 		case WLAN_CIPHER_SUITE_AES_CMAC:
 		case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_256:
 			if (!ieee80211_is_mgmt(hdr->frame_control))
 				tx->key = NULL;
 			break;
@@ -1022,6 +1024,9 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 		return ieee80211_crypto_aes_cmac_encrypt(tx);
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		return ieee80211_crypto_aes_cmac_256_encrypt(tx);
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		return ieee80211_crypto_aes_gmac_encrypt(tx);
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		return ieee80211_crypto_gcmp_encrypt(tx);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 92c3dc7..68ab404 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -22,6 +22,7 @@
 #include "tkip.h"
 #include "aes_ccm.h"
 #include "aes_cmac.h"
+#include "aes_gmac.h"
 #include "aes_gcm.h"
 #include "wpa.h"
 
@@ -1101,6 +1102,110 @@ ieee80211_crypto_aes_cmac_256_decrypt(struct ieee80211_rx_data *rx)
 }
 
 ieee80211_tx_result
+ieee80211_crypto_aes_gmac_encrypt(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_key *key = tx->key;
+	struct ieee80211_mmie_16 *mmie;
+	struct ieee80211_hdr *hdr;
+	u8 aad[20];
+	u64 pn64;
+	u8 nonce[12];
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
+	pn64 = atomic64_inc_return(&key->u.aes_gmac.tx_pn);
+
+	bip_ipn_set64(mmie->sequence_number, pn64);
+
+	bip_aad(skb, aad);
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	memcpy(nonce, hdr->addr2, ETH_ALEN);
+	bip_ipn_swap(nonce + ETH_ALEN, mmie->sequence_number);
+
+	/* MIC = AES-GMAC(IGTK, AAD || Management Frame Body || MMIE, 128) */
+	if (ieee80211_aes_gmac(key->u.aes_gmac.tfm, aad, nonce,
+			       skb->data + 24, skb->len - 24, mmie->mic) < 0)
+		return TX_DROP;
+
+	return TX_CONTINUE;
+}
+
+ieee80211_rx_result
+ieee80211_crypto_aes_gmac_decrypt(struct ieee80211_rx_data *rx)
+{
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_key *key = rx->key;
+	struct ieee80211_mmie_16 *mmie;
+	u8 aad[20], mic[16], ipn[6], nonce[12];
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
+	if (memcmp(ipn, key->u.aes_gmac.rx_pn, 6) <= 0) {
+		key->u.aes_gmac.replays++;
+		return RX_DROP_UNUSABLE;
+	}
+
+	if (!(status->flag & RX_FLAG_DECRYPTED)) {
+		/* hardware didn't decrypt/verify MIC */
+		bip_aad(skb, aad);
+
+		memcpy(nonce, hdr->addr2, ETH_ALEN);
+		memcpy(nonce + ETH_ALEN, ipn, 6);
+
+		if (ieee80211_aes_gmac(key->u.aes_gmac.tfm, aad, nonce,
+				       skb->data + 24, skb->len - 24,
+				       mic) < 0 ||
+		    memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0) {
+			key->u.aes_gmac.icverrors++;
+			return RX_DROP_UNUSABLE;
+		}
+	}
+
+	memcpy(key->u.aes_gmac.rx_pn, ipn, 6);
+
+	/* Remove MMIE */
+	skb_trim(skb, skb->len - sizeof(*mmie));
+
+	return RX_CONTINUE;
+}
+
+ieee80211_tx_result
 ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb;
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index 1edfc58..7c0ca11 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -37,6 +37,10 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
 ieee80211_rx_result
 ieee80211_crypto_aes_cmac_256_decrypt(struct ieee80211_rx_data *rx);
 ieee80211_tx_result
+ieee80211_crypto_aes_gmac_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_rx_result
+ieee80211_crypto_aes_gmac_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_tx_result
 ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_hw_decrypt(struct ieee80211_rx_data *rx);
-- 
1.9.1

