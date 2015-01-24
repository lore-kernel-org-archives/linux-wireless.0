Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5875 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbbAXRxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:53:03 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/6] mac80111: Add GCMP and GCMP-256 ciphers
Date: Sat, 24 Jan 2015 19:52:06 +0200
Message-ID: <1422121929-18238-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20150124_185308_694620_FA4D9F99)
In-Reply-To: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows mac80211 to configure GCMP and GCMP-256 to the driver and
also use software-implementation within mac80211 when the driver does
not support this with hardware accelaration.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/mac80211.h     |  15 ++-
 net/mac80211/Kconfig       |   1 +
 net/mac80211/Makefile      |   1 +
 net/mac80211/aes_gcm.c     |  95 +++++++++++++++++++
 net/mac80211/aes_gcm.h     |  22 +++++
 net/mac80211/cfg.c         |  13 +++
 net/mac80211/debugfs_key.c |  22 +++++
 net/mac80211/key.c         |  74 ++++++++++++++-
 net/mac80211/key.h         |  11 +++
 net/mac80211/main.c        |   9 +-
 net/mac80211/rx.c          |   4 +
 net/mac80211/tx.c          |   5 +
 net/mac80211/wpa.c         | 224 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wpa.h         |   5 +
 14 files changed, 492 insertions(+), 9 deletions(-)
 create mode 100644 net/mac80211/aes_gcm.c
 create mode 100644 net/mac80211/aes_gcm.h

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 866073e..ae66384 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1294,8 +1294,8 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  * @IEEE80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
  *	that the key is pairwise rather then a shared key.
  * @IEEE80211_KEY_FLAG_SW_MGMT_TX: This flag should be set by the driver for a
- *	CCMP key if it requires CCMP encryption of management frames (MFP) to
- *	be done in software.
+ *	CCMP/GCMP key if it requires CCMP/GCMP encryption of management frames
+ *	(MFP) to be done in software.
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
  *	if space should be prepared for the IV, but the IV
  *	itself should not be generated. Do not set together with
@@ -1310,7 +1310,7 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *	RX, if your crypto engine can't deal with TX you can also set the
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
  * @IEEE80211_KEY_FLAG_GENERATE_IV_MGMT: This flag should be set by the
- *	driver for a CCMP key to indicate that is requires IV generation
+ *	driver for a CCMP/GCMP key to indicate that is requires IV generation
  *	only for managment frames (MFP).
  * @IEEE80211_KEY_FLAG_RESERVE_TAILROOM: This flag should be set by the
  *	driver for a key to indicate that sufficient tailroom must always
@@ -4098,6 +4098,8 @@ void ieee80211_aes_cmac_calculate_k1_k2(struct ieee80211_key_conf *keyconf,
  *	reverse order than in packet)
  * @aes_cmac: PN data, most significant byte first (big endian,
  *	reverse order than in packet)
+ * @gcmp: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
  */
 struct ieee80211_key_seq {
 	union {
@@ -4111,6 +4113,9 @@ struct ieee80211_key_seq {
 		struct {
 			u8 pn[6];
 		} aes_cmac;
+		struct {
+			u8 pn[6];
+		} gcmp;
 	};
 };
 
@@ -4135,7 +4140,7 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
  * ieee80211_get_key_rx_seq - get key RX sequence counter
  *
  * @keyconf: the parameter passed with the set key
- * @tid: The TID, or -1 for the management frame value (CCMP only);
+ * @tid: The TID, or -1 for the management frame value (CCMP/GCMP only);
  *	the value on TID 0 is also used for non-QoS frames. For
  *	CMAC, only TID 0 is valid.
  * @seq: buffer to receive the sequence data
@@ -4171,7 +4176,7 @@ void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
  * ieee80211_set_key_rx_seq - set key RX sequence counter
  *
  * @keyconf: the parameter passed with the set key
- * @tid: The TID, or -1 for the management frame value (CCMP only);
+ * @tid: The TID, or -1 for the management frame value (CCMP/GCMP only);
  *	the value on TID 0 is also used for non-QoS frames. For
  *	CMAC, only TID 0 is valid.
  * @seq: new sequence data
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 75cc680..64a012a 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -5,6 +5,7 @@ config MAC80211
 	select CRYPTO_ARC4
 	select CRYPTO_AES
 	select CRYPTO_CCM
+	select CRYPTO_GCM
 	select CRC32
 	select AVERAGE
 	---help---
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index e53671b..0cbf936 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -15,6 +15,7 @@ mac80211-y := \
 	michael.o \
 	tkip.o \
 	aes_ccm.o \
+	aes_gcm.o \
 	aes_cmac.o \
 	cfg.o \
 	ethtool.o \
diff --git a/net/mac80211/aes_gcm.c b/net/mac80211/aes_gcm.c
new file mode 100644
index 0000000..c2bf669
--- /dev/null
+++ b/net/mac80211/aes_gcm.c
@@ -0,0 +1,95 @@
+/*
+ * Copyright 2014-2015, Qualcomm Atheros, Inc.
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
+#include "aes_gcm.h"
+
+void ieee80211_aes_gcm_encrypt(struct crypto_aead *tfm, u8 *j_0, u8 *aad,
+			       u8 *data, size_t data_len, u8 *mic)
+{
+	struct scatterlist assoc, pt, ct[2];
+
+	char aead_req_data[sizeof(struct aead_request) +
+			   crypto_aead_reqsize(tfm)]
+		__aligned(__alignof__(struct aead_request));
+	struct aead_request *aead_req = (void *)aead_req_data;
+
+	memset(aead_req, 0, sizeof(aead_req_data));
+
+	sg_init_one(&pt, data, data_len);
+	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
+	sg_init_table(ct, 2);
+	sg_set_buf(&ct[0], data, data_len);
+	sg_set_buf(&ct[1], mic, IEEE80211_GCMP_MIC_LEN);
+
+	aead_request_set_tfm(aead_req, tfm);
+	aead_request_set_assoc(aead_req, &assoc, assoc.length);
+	aead_request_set_crypt(aead_req, &pt, ct, data_len, j_0);
+
+	crypto_aead_encrypt(aead_req);
+}
+
+int ieee80211_aes_gcm_decrypt(struct crypto_aead *tfm, u8 *j_0, u8 *aad,
+			      u8 *data, size_t data_len, u8 *mic)
+{
+	struct scatterlist assoc, pt, ct[2];
+	char aead_req_data[sizeof(struct aead_request) +
+			   crypto_aead_reqsize(tfm)]
+		__aligned(__alignof__(struct aead_request));
+	struct aead_request *aead_req = (void *)aead_req_data;
+
+	if (data_len == 0)
+		return -EINVAL;
+
+	memset(aead_req, 0, sizeof(aead_req_data));
+
+	sg_init_one(&pt, data, data_len);
+	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
+	sg_init_table(ct, 2);
+	sg_set_buf(&ct[0], data, data_len);
+	sg_set_buf(&ct[1], mic, IEEE80211_GCMP_MIC_LEN);
+
+	aead_request_set_tfm(aead_req, tfm);
+	aead_request_set_assoc(aead_req, &assoc, assoc.length);
+	aead_request_set_crypt(aead_req, ct, &pt,
+			       data_len + IEEE80211_GCMP_MIC_LEN, j_0);
+
+	return crypto_aead_decrypt(aead_req);
+}
+
+struct crypto_aead *ieee80211_aes_gcm_key_setup_encrypt(const u8 key[],
+							size_t key_len)
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
+		err = crypto_aead_setauthsize(tfm, IEEE80211_GCMP_MIC_LEN);
+	if (!err)
+		return tfm;
+
+	crypto_free_aead(tfm);
+	return ERR_PTR(err);
+}
+
+void ieee80211_aes_gcm_key_free(struct crypto_aead *tfm)
+{
+	crypto_free_aead(tfm);
+}
diff --git a/net/mac80211/aes_gcm.h b/net/mac80211/aes_gcm.h
new file mode 100644
index 0000000..1347fda
--- /dev/null
+++ b/net/mac80211/aes_gcm.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright 2014-2015, Qualcomm Atheros, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef AES_GCM_H
+#define AES_GCM_H
+
+#include <linux/crypto.h>
+
+void ieee80211_aes_gcm_encrypt(struct crypto_aead *tfm, u8 *j_0, u8 *aad,
+			       u8 *data, size_t data_len, u8 *mic);
+int ieee80211_aes_gcm_decrypt(struct crypto_aead *tfm, u8 *j_0, u8 *aad,
+			      u8 *data, size_t data_len, u8 *mic);
+struct crypto_aead *ieee80211_aes_gcm_key_setup_encrypt(const u8 key[],
+							size_t key_len);
+void ieee80211_aes_gcm_key_free(struct crypto_aead *tfm);
+
+#endif /* AES_GCM_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a777114..1c1d061 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -164,6 +164,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
 		break;
 	default:
 		cs = ieee80211_cs_get(local, params->cipher, sdata->vif.type);
@@ -369,6 +370,18 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		pn64 = atomic64_read(&key->u.gcmp.tx_pn);
+		seq[0] = pn64;
+		seq[1] = pn64 >> 8;
+		seq[2] = pn64 >> 16;
+		seq[3] = pn64 >> 24;
+		seq[4] = pn64 >> 32;
+		seq[5] = pn64 >> 40;
+		params.seq = seq;
+		params.seq_len = 6;
+		break;
 	}
 
 	params.key = key->conf.key;
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 5523b94..0e223e6 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -105,6 +105,13 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
 				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		pn = atomic64_read(&key->u.gcmp.tx_pn);
+		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
+				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
+				(u8)(pn >> 16), (u8)(pn >> 8), (u8)pn);
+		break;
 	default:
 		return 0;
 	}
@@ -151,6 +158,17 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 			       rpn[3], rpn[4], rpn[5]);
 		len = p - buf;
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
+			rpn = key->u.gcmp.rx_pn[i];
+			p += scnprintf(p, sizeof(buf)+buf-p,
+				       "%02x%02x%02x%02x%02x%02x\n",
+				       rpn[0], rpn[1], rpn[2],
+				       rpn[3], rpn[4], rpn[5]);
+		}
+		len = p - buf;
+		break;
 	default:
 		return 0;
 	}
@@ -173,6 +191,10 @@ static ssize_t key_replays_read(struct file *file, char __user *userbuf,
 		len = scnprintf(buf, sizeof(buf), "%u\n",
 				key->u.aes_cmac.replays);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		len = scnprintf(buf, sizeof(buf), "%u\n", key->u.gcmp.replays);
+		break;
 	default:
 		return 0;
 	}
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 5167c53..cbee2f5 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -24,6 +24,7 @@
 #include "debugfs_key.h"
 #include "aes_ccm.h"
 #include "aes_cmac.h"
+#include "aes_gcm.h"
 
 
 /**
@@ -163,6 +164,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
@@ -412,6 +415,25 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 			return ERR_PTR(err);
 		}
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		key->conf.iv_len = IEEE80211_GCMP_HDR_LEN;
+		key->conf.icv_len = IEEE80211_GCMP_MIC_LEN;
+		for (i = 0; seq && i < IEEE80211_NUM_TIDS + 1; i++)
+			for (j = 0; j < IEEE80211_GCMP_PN_LEN; j++)
+				key->u.gcmp.rx_pn[i][j] =
+					seq[IEEE80211_GCMP_PN_LEN - j - 1];
+		/* Initialize AES key state here as an optimization so that
+		 * it does not need to be initialized for every packet.
+		 */
+		key->u.gcmp.tfm = ieee80211_aes_gcm_key_setup_encrypt(key_data,
+								      key_len);
+		if (IS_ERR(key->u.gcmp.tfm)) {
+			err = PTR_ERR(key->u.gcmp.tfm);
+			kfree(key);
+			return ERR_PTR(err);
+		}
+		break;
 	default:
 		if (cs) {
 			size_t len = (seq_len > MAX_PN_LEN) ?
@@ -433,10 +455,18 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 
 static void ieee80211_key_free_common(struct ieee80211_key *key)
 {
-	if (key->conf.cipher == WLAN_CIPHER_SUITE_CCMP)
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
-	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
+		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		ieee80211_aes_gcm_key_free(key->u.gcmp.tfm);
+		break;
+	}
 	kzfree(key);
 }
 
@@ -760,6 +790,16 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		seq->ccmp.pn[1] = pn64 >> 32;
 		seq->ccmp.pn[0] = pn64 >> 40;
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		pn64 = atomic64_read(&key->u.gcmp.tx_pn);
+		seq->gcmp.pn[5] = pn64;
+		seq->gcmp.pn[4] = pn64 >> 8;
+		seq->gcmp.pn[3] = pn64 >> 16;
+		seq->gcmp.pn[2] = pn64 >> 24;
+		seq->gcmp.pn[1] = pn64 >> 32;
+		seq->gcmp.pn[0] = pn64 >> 40;
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -796,6 +836,16 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		pn = key->u.aes_cmac.rx_pn;
 		memcpy(seq->aes_cmac.pn, pn, IEEE80211_CMAC_PN_LEN);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
+			return;
+		if (tid < 0)
+			pn = key->u.gcmp.rx_pn[IEEE80211_NUM_TIDS];
+		else
+			pn = key->u.gcmp.rx_pn[tid];
+		memcpy(seq->gcmp.pn, pn, IEEE80211_GCMP_PN_LEN);
+		break;
 	}
 }
 EXPORT_SYMBOL(ieee80211_get_key_rx_seq);
@@ -831,6 +881,16 @@ void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		       ((u64)seq->aes_cmac.pn[0] << 40);
 		atomic64_set(&key->u.aes_cmac.tx_pn, pn64);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		pn64 = (u64)seq->gcmp.pn[5] |
+		       ((u64)seq->gcmp.pn[4] << 8) |
+		       ((u64)seq->gcmp.pn[3] << 16) |
+		       ((u64)seq->gcmp.pn[2] << 24) |
+		       ((u64)seq->gcmp.pn[1] << 32) |
+		       ((u64)seq->gcmp.pn[0] << 40);
+		atomic64_set(&key->u.gcmp.tx_pn, pn64);
+		break;
 	default:
 		WARN_ON(1);
 		break;
@@ -868,6 +928,16 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		pn = key->u.aes_cmac.rx_pn;
 		memcpy(pn, seq->aes_cmac.pn, IEEE80211_CMAC_PN_LEN);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
+			return;
+		if (tid < 0)
+			pn = key->u.gcmp.rx_pn[IEEE80211_NUM_TIDS];
+		else
+			pn = key->u.gcmp.rx_pn[tid];
+		memcpy(pn, seq->gcmp.pn, IEEE80211_GCMP_PN_LEN);
+		break;
 	default:
 		WARN_ON(1);
 		break;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 19db686..27580da 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -95,6 +95,17 @@ struct ieee80211_key {
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
 		} aes_cmac;
 		struct {
+			atomic64_t tx_pn;
+			/* Last received packet number. The first
+			 * IEEE80211_NUM_TIDS counters are used with Data
+			 * frames and the last counter is used with Robust
+			 * Management frames.
+			 */
+			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_GCMP_PN_LEN];
+			struct crypto_aead *tfm;
+			u32 replays; /* dot11RSNAStatsGCMPReplays */
+		} gcmp;
+		struct {
 			/* generic cipher scheme */
 			u8 rx_pn[IEEE80211_NUM_TIDS + 1][MAX_PN_LEN];
 		} gen;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ea6b82a..7223b4e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -666,6 +666,8 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		WLAN_CIPHER_SUITE_WEP104,
 		WLAN_CIPHER_SUITE_TKIP,
 		WLAN_CIPHER_SUITE_CCMP,
+		WLAN_CIPHER_SUITE_GCMP,
+		WLAN_CIPHER_SUITE_GCMP_256,
 
 		/* keep last -- depends on hw flags! */
 		WLAN_CIPHER_SUITE_AES_CMAC
@@ -724,9 +726,10 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		/* Driver specifies cipher schemes only (but not cipher suites
 		 * including the schemes)
 		 *
-		 * We start counting ciphers defined by schemes, TKIP and CCMP
+		 * We start counting ciphers defined by schemes, TKIP, CCMP,
+		 * GCMP, and GCMP-256
 		 */
-		n_suites = local->hw.n_cipher_schemes + 2;
+		n_suites = local->hw.n_cipher_schemes + 4;
 
 		/* check if we have WEP40 and WEP104 */
 		if (have_wep)
@@ -742,6 +745,8 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 
 		suites[w++] = WLAN_CIPHER_SUITE_CCMP;
 		suites[w++] = WLAN_CIPHER_SUITE_TKIP;
+		suites[w++] = WLAN_CIPHER_SUITE_GCMP;
+		suites[w++] = WLAN_CIPHER_SUITE_GCMP_256;
 
 		if (have_wep) {
 			suites[w++] = WLAN_CIPHER_SUITE_WEP40;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ed516ae..a11d251 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1655,6 +1655,10 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		result = ieee80211_crypto_aes_cmac_decrypt(rx);
 		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		result = ieee80211_crypto_gcmp_decrypt(rx);
+		break;
 	default:
 		result = ieee80211_crypto_hw_decrypt(rx);
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 02ed6f6..e4c6fbc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -626,6 +626,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 				tx->key = NULL;
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_GCMP:
+		case WLAN_CIPHER_SUITE_GCMP_256:
 			if (!ieee80211_is_data_present(hdr->frame_control) &&
 			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
 					       tx->skb))
@@ -1014,6 +1016,9 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 		return ieee80211_crypto_ccmp_encrypt(tx);
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		return ieee80211_crypto_aes_cmac_encrypt(tx);
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		return ieee80211_crypto_gcmp_encrypt(tx);
 	default:
 		return ieee80211_crypto_hw_encrypt(tx);
 	}
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 12398fde..96b65c2 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -22,6 +22,7 @@
 #include "tkip.h"
 #include "aes_ccm.h"
 #include "aes_cmac.h"
+#include "aes_gcm.h"
 #include "wpa.h"
 
 ieee80211_tx_result
@@ -546,6 +547,229 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
+static void gcmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *j_0, u8 *aad)
+{
+	__le16 mask_fc;
+	u8 qos_tid;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	memcpy(j_0, hdr->addr2, ETH_ALEN);
+	memcpy(&j_0[ETH_ALEN], pn, IEEE80211_GCMP_PN_LEN);
+	j_0[13] = 0;
+	j_0[14] = 0;
+	j_0[AES_BLOCK_SIZE - 1] = 0x01;
+
+	/* AAD (extra authenticate-only data) / masked 802.11 header
+	 * FC | A1 | A2 | A3 | SC | [A4] | [QC]
+	 */
+	put_unaligned_be16(ieee80211_hdrlen(hdr->frame_control) - 2, &aad[0]);
+	/* Mask FC: zero subtype b4 b5 b6 (if not mgmt)
+	 * Retry, PwrMgt, MoreData; set Protected
+	 */
+	mask_fc = hdr->frame_control;
+	mask_fc &= ~cpu_to_le16(IEEE80211_FCTL_RETRY |
+				IEEE80211_FCTL_PM | IEEE80211_FCTL_MOREDATA);
+	if (!ieee80211_is_mgmt(hdr->frame_control))
+		mask_fc &= ~cpu_to_le16(0x0070);
+	mask_fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+
+	put_unaligned(mask_fc, (__le16 *)&aad[2]);
+	memcpy(&aad[4], &hdr->addr1, 3 * ETH_ALEN);
+
+	/* Mask Seq#, leave Frag# */
+	aad[22] = *((u8 *)&hdr->seq_ctrl) & 0x0f;
+	aad[23] = 0;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		qos_tid = *ieee80211_get_qos_ctl(hdr) &
+			IEEE80211_QOS_CTL_TID_MASK;
+	else
+		qos_tid = 0;
+
+	if (ieee80211_has_a4(hdr->frame_control)) {
+		memcpy(&aad[24], hdr->addr4, ETH_ALEN);
+		aad[30] = qos_tid;
+		aad[31] = 0;
+	} else {
+		memset(&aad[24], 0, ETH_ALEN + IEEE80211_QOS_CTL_LEN);
+		aad[24] = qos_tid;
+	}
+}
+
+static inline void gcmp_pn2hdr(u8 *hdr, const u8 *pn, int key_id)
+{
+	hdr[0] = pn[5];
+	hdr[1] = pn[4];
+	hdr[2] = 0;
+	hdr[3] = 0x20 | (key_id << 6);
+	hdr[4] = pn[3];
+	hdr[5] = pn[2];
+	hdr[6] = pn[1];
+	hdr[7] = pn[0];
+}
+
+static inline void gcmp_hdr2pn(u8 *pn, const u8 *hdr)
+{
+	pn[0] = hdr[7];
+	pn[1] = hdr[6];
+	pn[2] = hdr[5];
+	pn[3] = hdr[4];
+	pn[4] = hdr[1];
+	pn[5] = hdr[0];
+}
+
+static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_key *key = tx->key;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int hdrlen, len, tail;
+	u8 *pos;
+	u8 pn[6];
+	u64 pn64;
+	u8 aad[2 * AES_BLOCK_SIZE];
+	u8 j_0[AES_BLOCK_SIZE];
+
+	if (info->control.hw_key &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
+	    !((info->control.hw_key->flags &
+	       IEEE80211_KEY_FLAG_GENERATE_IV_MGMT) &&
+	      ieee80211_is_mgmt(hdr->frame_control))) {
+		/* hwaccel has no need for preallocated room for GCMP
+		 * header or MIC fields
+		 */
+		return 0;
+	}
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	len = skb->len - hdrlen;
+
+	if (info->control.hw_key)
+		tail = 0;
+	else
+		tail = IEEE80211_GCMP_MIC_LEN;
+
+	if (WARN_ON(skb_tailroom(skb) < tail ||
+		    skb_headroom(skb) < IEEE80211_GCMP_HDR_LEN))
+		return -1;
+
+	pos = skb_push(skb, IEEE80211_GCMP_HDR_LEN);
+	memmove(pos, pos + IEEE80211_GCMP_HDR_LEN, hdrlen);
+	skb_set_network_header(skb, skb_network_offset(skb) +
+				    IEEE80211_GCMP_HDR_LEN);
+
+	/* the HW only needs room for the IV, but not the actual IV */
+	if (info->control.hw_key &&
+	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
+		return 0;
+
+	hdr = (struct ieee80211_hdr *)pos;
+	pos += hdrlen;
+
+	pn64 = atomic64_inc_return(&key->u.gcmp.tx_pn);
+
+	pn[5] = pn64;
+	pn[4] = pn64 >> 8;
+	pn[3] = pn64 >> 16;
+	pn[2] = pn64 >> 24;
+	pn[1] = pn64 >> 32;
+	pn[0] = pn64 >> 40;
+
+	gcmp_pn2hdr(pos, pn, key->conf.keyidx);
+
+	/* hwaccel - with software GCMP header */
+	if (info->control.hw_key)
+		return 0;
+
+	pos += IEEE80211_GCMP_HDR_LEN;
+	gcmp_special_blocks(skb, pn, j_0, aad);
+	ieee80211_aes_gcm_encrypt(key->u.gcmp.tfm, j_0, aad, pos, len,
+				  skb_put(skb, IEEE80211_GCMP_MIC_LEN));
+
+	return 0;
+}
+
+ieee80211_tx_result
+ieee80211_crypto_gcmp_encrypt(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb;
+
+	ieee80211_tx_set_protected(tx);
+
+	skb_queue_walk(&tx->skbs, skb) {
+		if (gcmp_encrypt_skb(tx, skb) < 0)
+			return TX_DROP;
+	}
+
+	return TX_CONTINUE;
+}
+
+ieee80211_rx_result
+ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	int hdrlen;
+	struct ieee80211_key *key = rx->key;
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	u8 pn[IEEE80211_GCMP_PN_LEN];
+	int data_len;
+	int queue;
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	if (!ieee80211_is_data(hdr->frame_control) &&
+	    !ieee80211_is_robust_mgmt_frame(skb))
+		return RX_CONTINUE;
+
+	data_len = skb->len - hdrlen - IEEE80211_GCMP_HDR_LEN -
+		   IEEE80211_GCMP_MIC_LEN;
+	if (!rx->sta || data_len < 0)
+		return RX_DROP_UNUSABLE;
+
+	if (status->flag & RX_FLAG_DECRYPTED) {
+		if (!pskb_may_pull(rx->skb, hdrlen + IEEE80211_GCMP_HDR_LEN))
+			return RX_DROP_UNUSABLE;
+	} else {
+		if (skb_linearize(rx->skb))
+			return RX_DROP_UNUSABLE;
+	}
+
+	gcmp_hdr2pn(pn, skb->data + hdrlen);
+
+	queue = rx->security_idx;
+
+	if (memcmp(pn, key->u.gcmp.rx_pn[queue], IEEE80211_GCMP_PN_LEN) <= 0) {
+		key->u.gcmp.replays++;
+		return RX_DROP_UNUSABLE;
+	}
+
+	if (!(status->flag & RX_FLAG_DECRYPTED)) {
+		u8 aad[2 * AES_BLOCK_SIZE];
+		u8 j_0[AES_BLOCK_SIZE];
+		/* hardware didn't decrypt/verify MIC */
+		gcmp_special_blocks(skb, pn, j_0, aad);
+
+		if (ieee80211_aes_gcm_decrypt(
+			    key->u.gcmp.tfm, j_0, aad,
+			    skb->data + hdrlen + IEEE80211_GCMP_HDR_LEN,
+			    data_len,
+			    skb->data + skb->len - IEEE80211_GCMP_MIC_LEN))
+			return RX_DROP_UNUSABLE;
+	}
+
+	memcpy(key->u.gcmp.rx_pn[queue], pn, IEEE80211_GCMP_PN_LEN);
+
+	/* Remove GCMP header and MIC */
+	if (pskb_trim(skb, skb->len - IEEE80211_GCMP_MIC_LEN))
+		return RX_DROP_UNUSABLE;
+	memmove(skb->data + IEEE80211_GCMP_HDR_LEN, skb->data, hdrlen);
+	skb_pull(skb, IEEE80211_GCMP_HDR_LEN);
+
+	return RX_CONTINUE;
+}
+
 static ieee80211_tx_result
 ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 			    struct sk_buff *skb)
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index 62e5a12..ea955f2 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -37,4 +37,9 @@ ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_hw_decrypt(struct ieee80211_rx_data *rx);
 
+ieee80211_tx_result
+ieee80211_crypto_gcmp_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_rx_result
+ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx);
+
 #endif /* WPA_H */
-- 
1.9.1

