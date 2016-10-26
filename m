Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27896 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932471AbcJZVra (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:47:30 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 8/9] mac80211: FILS AEAD protection for station mode association frames
Date: Thu, 27 Oct 2016 00:42:05 +0300
Message-ID: <1477518126-823-9-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234734_944720_7CB85D94)
In-Reply-To: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for encrypting (Re)Association Request frame and
decryption (Re)Association Response frame when using FILS in station
mode.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/Makefile      |   1 +
 net/mac80211/aes_cmac.c    |   8 +-
 net/mac80211/aes_cmac.h    |   4 +
 net/mac80211/fils_aead.c   | 347 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/fils_aead.h   |  19 +++
 net/mac80211/ieee80211_i.h |   4 +
 net/mac80211/mlme.c        |  27 ++++
 7 files changed, 406 insertions(+), 4 deletions(-)
 create mode 100644 net/mac80211/fils_aead.c
 create mode 100644 net/mac80211/fils_aead.h

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index f9137a8..0b202b3 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -19,6 +19,7 @@ mac80211-y := \
 	aes_gcm.o \
 	aes_cmac.o \
 	aes_gmac.o \
+	fils_aead.o \
 	cfg.o \
 	ethtool.o \
 	rx.o \
diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index bdf0790..d0bd5ff 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -23,7 +23,7 @@
 #define AAD_LEN 20
 
 
-static void gf_mulx(u8 *pad)
+void gf_mulx(u8 *pad)
 {
 	int i, carry;
 
@@ -35,9 +35,9 @@ static void gf_mulx(u8 *pad)
 		pad[AES_BLOCK_SIZE - 1] ^= 0x87;
 }
 
-static void aes_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
-			    const u8 *addr[], const size_t *len, u8 *mac,
-			    size_t mac_len)
+void aes_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
+		     const u8 *addr[], const size_t *len, u8 *mac,
+		     size_t mac_len)
 {
 	u8 cbc[AES_BLOCK_SIZE], pad[AES_BLOCK_SIZE];
 	const u8 *pos, *end;
diff --git a/net/mac80211/aes_cmac.h b/net/mac80211/aes_cmac.h
index 3702041..c827e1d 100644
--- a/net/mac80211/aes_cmac.h
+++ b/net/mac80211/aes_cmac.h
@@ -11,6 +11,10 @@
 
 #include <linux/crypto.h>
 
+void gf_mulx(u8 *pad);
+void aes_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
+		     const u8 *addr[], const size_t *len, u8 *mac,
+		     size_t mac_len);
 struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[],
 						   size_t key_len);
 void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
new file mode 100644
index 0000000..afc7efc
--- /dev/null
+++ b/net/mac80211/fils_aead.c
@@ -0,0 +1,347 @@
+/*
+ * FILS AEAD for (Re)Association Request/Response frames
+ * Copyright 2016, Qualcomm Atheros, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/skcipher.h>
+
+#include "ieee80211_i.h"
+#include "aes_cmac.h"
+#include "fils_aead.h"
+
+static int aes_s2v(struct crypto_cipher *tfm,
+		   size_t num_elem, const u8 *addr[], size_t len[], u8 *v)
+{
+	u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE];
+	size_t i;
+	const u8 *data[2];
+	size_t data_len[2], data_elems;
+
+	/* D = AES-CMAC(K, <zero>) */
+	memset(tmp, 0, AES_BLOCK_SIZE);
+	data[0] = tmp;
+	data_len[0] = AES_BLOCK_SIZE;
+	aes_cmac_vector(tfm, 1, data, data_len, d, AES_BLOCK_SIZE);
+
+	for (i = 0; i < num_elem - 1; i++) {
+		/* D = dbl(D) xor AES_CMAC(K, Si) */
+		gf_mulx(d); /* dbl */
+		aes_cmac_vector(tfm, 1, &addr[i], &len[i], tmp,
+				AES_BLOCK_SIZE);
+		crypto_xor(d, tmp, AES_BLOCK_SIZE);
+	}
+
+	if (len[i] >= AES_BLOCK_SIZE) {
+		/* len(Sn) >= 128 */
+		size_t j;
+		const u8 *pos;
+
+		/* T = Sn xorend D */
+
+		/* Use a temporary buffer to perform xorend on Sn (addr[i]) to
+		 * avoid modifying the const input argument.
+		 */
+		data[0] = addr[i];
+		data_len[0] = len[i] - AES_BLOCK_SIZE;
+		pos = addr[i] + data_len[0];
+		for (j = 0; j < AES_BLOCK_SIZE; j++)
+			tmp[j] = pos[j] ^ d[j];
+		data[1] = tmp;
+		data_len[1] = AES_BLOCK_SIZE;
+		data_elems = 2;
+	} else {
+		/* len(Sn) < 128 */
+		/* T = dbl(D) xor pad(Sn) */
+		gf_mulx(d); /* dbl */
+		memset(tmp, 0, AES_BLOCK_SIZE);
+		memcpy(tmp, addr[i], len[i]);
+		tmp[len[i]] = 0x80;
+		crypto_xor(d, tmp, AES_BLOCK_SIZE);
+		data[0] = d;
+		data_len[0] = sizeof(d);
+		data_elems = 1;
+	}
+	/* V = AES-CMAC(K, T) */
+	aes_cmac_vector(tfm, data_elems, data, data_len, v, AES_BLOCK_SIZE);
+
+	return 0;
+}
+
+/* Note: addr[] and len[] needs to have one extra slot at the end. */
+static int aes_siv_encrypt(const u8 *key, size_t key_len,
+			   const u8 *plain, size_t plain_len,
+			   size_t num_elem, const u8 *addr[],
+			   size_t len[], u8 *out)
+{
+	u8 v[AES_BLOCK_SIZE];
+	struct crypto_cipher *tfm;
+	struct crypto_skcipher *tfm2;
+	struct skcipher_request *req;
+	int res;
+	struct scatterlist src[1], dst[1];
+	u8 *tmp;
+
+	key_len /= 2; /* S2V key || CTR key */
+
+	addr[num_elem] = plain;
+	len[num_elem] = plain_len;
+	num_elem++;
+
+	/* S2V */
+
+	tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	/* K1 for S2V */
+	res = crypto_cipher_setkey(tfm, key, key_len);
+	if (!res)
+		res = aes_s2v(tfm, num_elem, addr, len, v);
+	crypto_free_cipher(tfm);
+	if (res)
+		return res;
+
+	/* Use a temporary buffer of the plaintext to handle need for
+	 * overwriting this during AES-CTR.
+	 */
+	tmp = kmalloc(plain_len, GFP_KERNEL);
+	if (!tmp) {
+		res = -ENOMEM;
+		goto fail;
+	}
+	memcpy(tmp, plain, plain_len);
+
+	/* IV for CTR before encrypted data */
+	memcpy(out, v, AES_BLOCK_SIZE);
+
+	/* Synthetic IV to be used as the initial counter in CTR:
+	 * Q = V bitand (1^64 || 0^1 || 1^31 || 0^1 || 1^31)
+	 */
+	v[8] &= 0x7f;
+	v[12] &= 0x7f;
+
+	/* CTR */
+
+	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, 0);
+	if (IS_ERR(tfm2)) {
+		kfree(tmp);
+		return PTR_ERR(tfm2);
+	}
+	/* K2 for CTR */
+	res = crypto_skcipher_setkey(tfm2, key + key_len, key_len);
+	if (res)
+		goto fail;
+
+	req = skcipher_request_alloc(tfm2, GFP_KERNEL);
+	if (!req) {
+		res = -ENOMEM;
+		goto fail;
+	}
+
+	sg_set_buf(&src[0], tmp, plain_len);
+	sg_set_buf(&dst[0], out + AES_BLOCK_SIZE, plain_len);
+	skcipher_request_set_crypt(req, src, dst, plain_len, v);
+	res = crypto_skcipher_encrypt(req);
+	skcipher_request_free(req);
+fail:
+	kfree(tmp);
+	crypto_free_skcipher(tfm2);
+	return res;
+}
+
+/* Note: addr[] and len[] needs to have one extra slot at the end. */
+static int aes_siv_decrypt(const u8 *key, size_t key_len,
+			   const u8 *iv_crypt, size_t iv_c_len,
+			   size_t num_elem, const u8 *addr[], size_t len[],
+			   u8 *out)
+{
+	struct crypto_cipher *tfm;
+	struct crypto_skcipher *tfm2;
+	struct skcipher_request *req;
+	struct scatterlist src[1], dst[1];
+	size_t crypt_len;
+	int res;
+	u8 frame_iv[AES_BLOCK_SIZE], iv[AES_BLOCK_SIZE];
+	u8 check[AES_BLOCK_SIZE];
+
+	crypt_len = iv_c_len - AES_BLOCK_SIZE;
+	key_len /= 2; /* S2V key || CTR key */
+	addr[num_elem] = out;
+	len[num_elem] = crypt_len;
+	num_elem++;
+
+	memcpy(iv, iv_crypt, AES_BLOCK_SIZE);
+	memcpy(frame_iv, iv_crypt, AES_BLOCK_SIZE);
+
+	/* Synthetic IV to be used as the initial counter in CTR:
+	 * Q = V bitand (1^64 || 0^1 || 1^31 || 0^1 || 1^31)
+	 */
+	iv[8] &= 0x7f;
+	iv[12] &= 0x7f;
+
+	/* CTR */
+
+	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, 0);
+	if (IS_ERR(tfm2))
+		return PTR_ERR(tfm2);
+	/* K2 for CTR */
+	res = crypto_skcipher_setkey(tfm2, key + key_len, key_len);
+	if (res) {
+		crypto_free_skcipher(tfm2);
+		return res;
+	}
+
+	req = skcipher_request_alloc(tfm2, GFP_KERNEL);
+	if (!req) {
+		crypto_free_skcipher(tfm2);
+		return -ENOMEM;
+	}
+
+	sg_set_buf(&src[0], iv_crypt + AES_BLOCK_SIZE, crypt_len);
+	sg_set_buf(&dst[0], out, crypt_len);
+	skcipher_request_set_crypt(req, src, dst, crypt_len, iv);
+	res = crypto_skcipher_decrypt(req);
+	skcipher_request_free(req);
+	crypto_free_skcipher(tfm2);
+	if (res)
+		return res;
+
+	/* S2V */
+
+	tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	/* K1 for S2V */
+	res = crypto_cipher_setkey(tfm, key, key_len);
+	if (!res)
+		res = aes_s2v(tfm, num_elem, addr, len, check);
+	crypto_free_cipher(tfm);
+	if (res)
+		return res;
+	if (memcmp(check, frame_iv, AES_BLOCK_SIZE) != 0)
+		return -EINVAL;
+	return 0;
+}
+
+int fils_encrypt_assoc_req(struct sk_buff *skb,
+			   struct ieee80211_mgd_assoc_data *assoc_data)
+{
+	struct ieee80211_mgmt *mgmt;
+	u8 *capab, *ies, *encr;
+	const u8 *addr[5 + 1], *session;
+	size_t len[5 + 1];
+	size_t crypt_len;
+
+	mgmt = (struct ieee80211_mgmt *)skb->data;
+	if (ieee80211_is_reassoc_req(mgmt->frame_control)) {
+		capab = (u8 *)&mgmt->u.reassoc_req.capab_info;
+		ies = mgmt->u.reassoc_req.variable;
+	} else {
+		capab = (u8 *)&mgmt->u.assoc_req.capab_info;
+		ies = mgmt->u.assoc_req.variable;
+	}
+
+	session = cfg80211_find_ext_ie(WLAN_EID_EXT_FILS_SESSION,
+				       ies, skb->data + skb->len - ies);
+	if (!session)
+		return -EINVAL;
+	/* encrypt after FILS Session element */
+	encr = (u8 *)session + 2 + 1 + 8;
+
+	/* AES-SIV AAD vectors */
+
+	/* The STA's MAC address */
+	addr[0] = mgmt->sa;
+	len[0] = ETH_ALEN;
+	/* The AP's BSSID */
+	addr[1] = mgmt->da;
+	len[1] = ETH_ALEN;
+	/* The STA's nonce */
+	addr[2] = assoc_data->fils_nonces;
+	len[2] = FILS_NONCE_LEN;
+	/* The AP's nonce */
+	addr[3] = &assoc_data->fils_nonces[FILS_NONCE_LEN];
+	len[3] = FILS_NONCE_LEN;
+	/* The (Re)Association Request frame from the Capability Information
+	 * field to the FILS Session element (both inclusive).
+	 */
+	addr[4] = capab;
+	len[4] = encr - capab;
+
+	crypt_len = skb->data + skb->len - encr;
+	skb_put(skb, AES_BLOCK_SIZE);
+	return aes_siv_encrypt(assoc_data->fils_kek, assoc_data->fils_kek_len,
+			       encr, crypt_len, 1, addr, len, encr);
+}
+
+int fils_decrypt_assoc_resp(struct ieee80211_sub_if_data *sdata,
+			    u8 *frame, size_t *frame_len,
+			    struct ieee80211_mgd_assoc_data *assoc_data)
+{
+	struct ieee80211_mgmt *mgmt;
+	u8 *capab, *ies, *encr;
+	const u8 *addr[5 + 1], *session;
+	size_t len[5 + 1];
+	int res;
+	size_t crypt_len;
+
+	if (*frame_len < 24 + 6)
+		return -EINVAL;
+
+	mgmt = (struct ieee80211_mgmt *)frame;
+	capab = (u8 *)&mgmt->u.assoc_resp.capab_info;
+	ies = mgmt->u.assoc_resp.variable;
+	session = cfg80211_find_ext_ie(WLAN_EID_EXT_FILS_SESSION,
+				       ies, frame + *frame_len - ies);
+	if (!session) {
+		mlme_dbg(sdata,
+			 "No FILS Session element in (Re)Association Response frame from %pM",
+			 mgmt->sa);
+		return -EINVAL;
+	}
+	/* decrypt after FILS Session element */
+	encr = (u8 *)session + 2 + 1 + 8;
+
+	/* AES-SIV AAD vectors */
+
+	/* The AP's BSSID */
+	addr[0] = mgmt->sa;
+	len[0] = ETH_ALEN;
+	/* The STA's MAC address */
+	addr[1] = mgmt->da;
+	len[1] = ETH_ALEN;
+	/* The AP's nonce */
+	addr[2] = &assoc_data->fils_nonces[FILS_NONCE_LEN];
+	len[2] = FILS_NONCE_LEN;
+	/* The STA's nonce */
+	addr[3] = assoc_data->fils_nonces;
+	len[3] = FILS_NONCE_LEN;
+	/* The (Re)Association Response frame from the Capability Information
+	 * field to the FILS Session element (both inclusive).
+	 */
+	addr[4] = capab;
+	len[4] = encr - capab;
+
+	crypt_len = frame + *frame_len - encr;
+	if (crypt_len < AES_BLOCK_SIZE) {
+		mlme_dbg(sdata,
+			 "Not enough room for AES-SIV data after FILS Session element in (Re)Association Response frame from %pM",
+			 mgmt->sa);
+		return -EINVAL;
+	}
+	res = aes_siv_decrypt(assoc_data->fils_kek, assoc_data->fils_kek_len,
+			      encr, crypt_len, 5, addr, len, encr);
+	if (res != 0) {
+		mlme_dbg(sdata,
+			 "AES-SIV decryption of (Re)Association Response frame from %pM failed",
+			 mgmt->sa);
+		return res;
+	}
+	*frame_len -= AES_BLOCK_SIZE;
+	return 0;
+}
diff --git a/net/mac80211/fils_aead.h b/net/mac80211/fils_aead.h
new file mode 100644
index 0000000..fbc6523
--- /dev/null
+++ b/net/mac80211/fils_aead.h
@@ -0,0 +1,19 @@
+/*
+ * FILS AEAD for (Re)Association Request/Response frames
+ * Copyright 2016, Qualcomm Atheros, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FILS_AEAD_H
+#define FILS_AEAD_H
+
+int fils_encrypt_assoc_req(struct sk_buff *skb,
+			   struct ieee80211_mgd_assoc_data *assoc_data);
+int fils_decrypt_assoc_resp(struct ieee80211_sub_if_data *sdata,
+			    u8 *frame, size_t *frame_len,
+			    struct ieee80211_mgd_assoc_data *assoc_data);
+
+#endif /* FILS_AEAD_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b4e2b6c..d37a577 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -401,6 +401,10 @@ struct ieee80211_mgd_assoc_data {
 
 	struct ieee80211_vht_cap ap_vht_cap;
 
+	u8 fils_nonces[2 * FILS_NONCE_LEN];
+	u8 fils_kek[FILS_MAX_KEK_LEN];
+	size_t fils_kek_len;
+
 	size_t ie_len;
 	u8 ie[];
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b815f2d..f99f9c5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -30,6 +30,7 @@
 #include "driver-ops.h"
 #include "rate.h"
 #include "led.h"
+#include "fils_aead.h"
 
 #define IEEE80211_AUTH_TIMEOUT		(HZ / 5)
 #define IEEE80211_AUTH_TIMEOUT_LONG	(HZ / 2)
@@ -652,6 +653,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
 			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */
 			assoc_data->ie_len + /* extra IEs */
+			(assoc_data->fils_kek_len ? 16 /* AES-SIV */ : 0) +
 			9, /* WMM */
 			GFP_KERNEL);
 	if (!skb)
@@ -875,6 +877,12 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		memcpy(pos, assoc_data->ie + offset, noffset - offset);
 	}
 
+	if (assoc_data->fils_kek_len &&
+	    fils_encrypt_assoc_req(skb, assoc_data) < 0) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
 	drv_mgd_prepare_tx(local, sdata);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -3146,6 +3154,10 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		   reassoc ? "Rea" : "A", mgmt->sa,
 		   capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
 
+	if (assoc_data->fils_kek_len &&
+	    fils_decrypt_assoc_resp(sdata, (u8 *)mgmt, &len, assoc_data) < 0)
+		return;
+
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
 
@@ -4706,6 +4718,21 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		assoc_data->ie_len = req->ie_len;
 	}
 
+	if (req->fils_kek) {
+		if (req->fils_kek_len > FILS_MAX_KEK_LEN) {
+			err = -EINVAL;
+			goto err_free;
+		}
+		memcpy(assoc_data->fils_kek, req->fils_kek,
+		       req->fils_kek_len);
+		assoc_data->fils_kek_len = req->fils_kek_len;
+	}
+
+	if (req->fils_nonces) {
+		memcpy(assoc_data->fils_nonces, req->fils_nonces,
+		       2 * FILS_NONCE_LEN);
+	}
+
 	assoc_data->bss = req->bss;
 
 	if (ifmgd->req_smps == IEEE80211_SMPS_AUTOMATIC) {
-- 
1.9.1
