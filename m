Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34004 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZAGL1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:27:39 -0500
Message-Id: <20090107112629.187345998@atheros.com> (sfid-20090107_122745_569073_37AD5A1D)
References: <20090107112346.369581673@atheros.com>
Date: Wed, 07 Jan 2009 13:23:49 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 03/14] mac80211: 802.11w - Add BIP (AES-128-CMAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement Broadcast/Multicast Integrity Protocol for management frame
protection. This patch adds the needed definitions for the new
information element (MMIE) and implementation for the new "encryption"
type (though, BIP is actually not encrypting data, it provides only
integrity protection). These routines will be used by a follow-on patch
that enables BIP for multicast/broadcast robust management frames.

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 include/linux/ieee80211.h  |   10 +++
 net/mac80211/Makefile      |    1 
 net/mac80211/aes_cmac.c    |  135 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/aes_cmac.h    |   19 ++++++
 net/mac80211/ieee80211_i.h |    2 
 net/mac80211/key.h         |   10 +++
 net/mac80211/wpa.c         |  125 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wpa.h         |    5 +
 8 files changed, 306 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-01-07 13:07:44.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-01-07 13:07:46.000000000 +0200
@@ -655,6 +655,15 @@ struct ieee80211_mgmt {
 #define IEEE80211_MIN_ACTION_SIZE offsetof(struct ieee80211_mgmt, u.action.u)
 
 
+/* Management MIC information element (IEEE 802.11w) */
+struct ieee80211_mmie {
+	u8 element_id;
+	u8 length;
+	__le16 key_id;
+	u8 sequence_number[6];
+	u8 mic[8];
+} __attribute__ ((packed));
+
 /* Control frames */
 struct ieee80211_rts {
 	__le16 frame_control;
@@ -1018,6 +1027,7 @@ enum ieee80211_eid {
 	WLAN_EID_HT_INFORMATION = 61,
 	/* 802.11i */
 	WLAN_EID_RSN = 48,
+	WLAN_EID_MMIE = 76 /* 802.11w */,
 	WLAN_EID_WPA = 221,
 	WLAN_EID_GENERIC = 221,
 	WLAN_EID_VENDOR_SPECIFIC = 221,
--- wireless-testing.orig/net/mac80211/key.h	2008-12-31 17:33:38.000000000 +0200
+++ wireless-testing/net/mac80211/key.h	2009-01-07 13:07:46.000000000 +0200
@@ -96,6 +96,16 @@ struct ieee80211_key {
 			u8 tx_crypto_buf[6 * AES_BLOCK_LEN];
 			u8 rx_crypto_buf[6 * AES_BLOCK_LEN];
 		} ccmp;
+		struct {
+			u8 tx_pn[6];
+			u8 rx_pn[6];
+			struct crypto_cipher *tfm;
+			u32 replays; /* dot11RSNAStatsCMACReplays */
+			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
+			/* scratch buffers for virt_to_page() (crypto API) */
+			u8 tx_crypto_buf[2 * AES_BLOCK_LEN];
+			u8 rx_crypto_buf[2 * AES_BLOCK_LEN];
+		} aes_cmac;
 	} u;
 
 	/* number of times this key has been used */
--- wireless-testing.orig/net/mac80211/wpa.c	2009-01-07 13:07:44.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2009-01-07 13:07:46.000000000 +0200
@@ -1,5 +1,6 @@
 /*
  * Copyright 2002-2004, Instant802 Networks, Inc.
+ * Copyright 2008, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,6 +20,7 @@
 #include "michael.h"
 #include "tkip.h"
 #include "aes_ccm.h"
+#include "aes_cmac.h"
 #include "wpa.h"
 
 ieee80211_tx_result
@@ -494,3 +496,126 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 
 	return RX_CONTINUE;
 }
+
+
+static void bip_aad(struct sk_buff *skb, u8 *aad)
+{
+	/* BIP AAD: FC(masked) || A1 || A2 || A3 */
+
+	/* FC type/subtype */
+	aad[0] = skb->data[0];
+	/* Mask FC Retry, PwrMgt, MoreData flags to zero */
+	aad[1] = skb->data[1] & ~(BIT(4) | BIT(5) | BIT(6));
+	/* A1 || A2 || A3 */
+	memcpy(aad + 2, skb->data + 4, 3 * ETH_ALEN);
+}
+
+
+static inline void bip_ipn_swap(u8 *d, const u8 *s)
+{
+	*d++ = s[5];
+	*d++ = s[4];
+	*d++ = s[3];
+	*d++ = s[2];
+	*d++ = s[1];
+	*d = s[0];
+}
+
+
+ieee80211_tx_result
+ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb = tx->skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_key *key = tx->key;
+	struct ieee80211_mmie *mmie;
+	u8 *pn, aad[20];
+	int i;
+
+	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+		/* hwaccel */
+		info->control.hw_key = &tx->key->conf;
+		return 0;
+	}
+
+	if (WARN_ON(skb_tailroom(skb) < sizeof(*mmie)))
+		return TX_DROP;
+
+	mmie = (struct ieee80211_mmie *) skb_put(skb, sizeof(*mmie));
+	mmie->element_id = WLAN_EID_MMIE;
+	mmie->length = sizeof(*mmie) - 2;
+	mmie->key_id = cpu_to_le16(key->conf.keyidx);
+
+	/* PN = PN + 1 */
+	pn = key->u.aes_cmac.tx_pn;
+
+	for (i = sizeof(key->u.aes_cmac.tx_pn) - 1; i >= 0; i--) {
+		pn[i]++;
+		if (pn[i])
+			break;
+	}
+	bip_ipn_swap(mmie->sequence_number, pn);
+
+	bip_aad(skb, aad);
+
+	/*
+	 * MIC = AES-128-CMAC(IGTK, AAD || Management Frame Body || MMIE, 64)
+	 */
+	ieee80211_aes_cmac(key->u.aes_cmac.tfm, key->u.aes_cmac.tx_crypto_buf,
+			   aad, skb->data + 24, skb->len - 24, mmie->mic);
+
+	return TX_CONTINUE;
+}
+
+
+ieee80211_rx_result
+ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
+{
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_key *key = rx->key;
+	struct ieee80211_mmie *mmie;
+	u8 aad[20], mic[8], ipn[6];
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (!ieee80211_is_mgmt(hdr->frame_control))
+		return RX_CONTINUE;
+
+	if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
+	    (rx->status->flag & RX_FLAG_IV_STRIPPED))
+		return RX_CONTINUE;
+
+	if (skb->len < 24 + sizeof(*mmie))
+		return RX_DROP_UNUSABLE;
+
+	mmie = (struct ieee80211_mmie *)
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
+	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
+		/* hardware didn't decrypt/verify MIC */
+		bip_aad(skb, aad);
+		ieee80211_aes_cmac(key->u.aes_cmac.tfm,
+				   key->u.aes_cmac.rx_crypto_buf, aad,
+				   skb->data + 24, skb->len - 24, mic);
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
--- wireless-testing.orig/net/mac80211/wpa.h	2008-12-31 17:33:38.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.h	2009-01-07 13:07:46.000000000 +0200
@@ -28,4 +28,9 @@ ieee80211_crypto_ccmp_encrypt(struct iee
 ieee80211_rx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx);
 
+ieee80211_tx_result
+ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_rx_result
+ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
+
 #endif /* WPA_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/aes_cmac.c	2009-01-07 13:07:46.000000000 +0200
@@ -0,0 +1,135 @@
+/*
+ * AES-128-CMAC with TLen 16 for IEEE 802.11w BIP
+ * Copyright 2008, Jouni Malinen <j@w1.fi>
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
+
+#include <net/mac80211.h>
+#include "key.h"
+#include "aes_cmac.h"
+
+#define AES_BLOCK_SIZE 16
+#define AES_CMAC_KEY_LEN 16
+#define CMAC_TLEN 8 /* CMAC TLen = 64 bits (8 octets) */
+#define AAD_LEN 20
+
+
+static void gf_mulx(u8 *pad)
+{
+	int i, carry;
+
+	carry = pad[0] & 0x80;
+	for (i = 0; i < AES_BLOCK_SIZE - 1; i++)
+		pad[i] = (pad[i] << 1) | (pad[i + 1] >> 7);
+	pad[AES_BLOCK_SIZE - 1] <<= 1;
+	if (carry)
+		pad[AES_BLOCK_SIZE - 1] ^= 0x87;
+}
+
+
+static void aes_128_cmac_vector(struct crypto_cipher *tfm, u8 *scratch,
+				size_t num_elem,
+				const u8 *addr[], const size_t *len, u8 *mac)
+{
+	u8 *cbc, *pad;
+	const u8 *pos, *end;
+	size_t i, e, left, total_len;
+
+	cbc = scratch;
+	pad = scratch + AES_BLOCK_SIZE;
+
+	memset(cbc, 0, AES_BLOCK_SIZE);
+
+	total_len = 0;
+	for (e = 0; e < num_elem; e++)
+		total_len += len[e];
+	left = total_len;
+
+	e = 0;
+	pos = addr[0];
+	end = pos + len[0];
+
+	while (left >= AES_BLOCK_SIZE) {
+		for (i = 0; i < AES_BLOCK_SIZE; i++) {
+			cbc[i] ^= *pos++;
+			if (pos >= end) {
+				e++;
+				pos = addr[e];
+				end = pos + len[e];
+			}
+		}
+		if (left > AES_BLOCK_SIZE)
+			crypto_cipher_encrypt_one(tfm, cbc, cbc);
+		left -= AES_BLOCK_SIZE;
+	}
+
+	memset(pad, 0, AES_BLOCK_SIZE);
+	crypto_cipher_encrypt_one(tfm, pad, pad);
+	gf_mulx(pad);
+
+	if (left || total_len == 0) {
+		for (i = 0; i < left; i++) {
+			cbc[i] ^= *pos++;
+			if (pos >= end) {
+				e++;
+				pos = addr[e];
+				end = pos + len[e];
+			}
+		}
+		cbc[left] ^= 0x80;
+		gf_mulx(pad);
+	}
+
+	for (i = 0; i < AES_BLOCK_SIZE; i++)
+		pad[i] ^= cbc[i];
+	crypto_cipher_encrypt_one(tfm, pad, pad);
+	memcpy(mac, pad, CMAC_TLEN);
+}
+
+
+void ieee80211_aes_cmac(struct crypto_cipher *tfm, u8 *scratch, const u8 *aad,
+			const u8 *data, size_t data_len, u8 *mic)
+{
+	const u8 *addr[3];
+	size_t len[3];
+	u8 zero[CMAC_TLEN];
+
+	memset(zero, 0, CMAC_TLEN);
+	addr[0] = aad;
+	len[0] = AAD_LEN;
+	addr[1] = data;
+	len[1] = data_len - CMAC_TLEN;
+	addr[2] = zero;
+	len[2] = CMAC_TLEN;
+
+	aes_128_cmac_vector(tfm, scratch, 3, addr, len, mic);
+}
+
+
+struct crypto_cipher * ieee80211_aes_cmac_key_setup(const u8 key[])
+{
+	struct crypto_cipher *tfm;
+
+	tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+		return NULL;
+
+	crypto_cipher_setkey(tfm, key, AES_CMAC_KEY_LEN);
+
+	return tfm;
+}
+
+
+void ieee80211_aes_cmac_key_free(struct crypto_cipher *tfm)
+{
+	if (tfm)
+		crypto_free_cipher(tfm);
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/aes_cmac.h	2009-01-07 13:07:46.000000000 +0200
@@ -0,0 +1,19 @@
+/*
+ * Copyright 2008, Jouni Malinen <j@w1.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef AES_CMAC_H
+#define AES_CMAC_H
+
+#include <linux/crypto.h>
+
+struct crypto_cipher * ieee80211_aes_cmac_key_setup(const u8 key[]);
+void ieee80211_aes_cmac(struct crypto_cipher *tfm, u8 *scratch, const u8 *aad,
+			const u8 *data, size_t data_len, u8 *mic);
+void ieee80211_aes_cmac_key_free(struct crypto_cipher *tfm);
+
+#endif /* AES_CMAC_H */
--- wireless-testing.orig/net/mac80211/Makefile	2008-12-31 17:33:38.000000000 +0200
+++ wireless-testing/net/mac80211/Makefile	2009-01-07 13:07:46.000000000 +0200
@@ -15,6 +15,7 @@ mac80211-y := \
 	michael.o \
 	tkip.o \
 	aes_ccm.o \
+	aes_cmac.o \
 	cfg.o \
 	rx.o \
 	spectmgmt.o \
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-07 13:07:41.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-07 13:07:46.000000000 +0200
@@ -43,7 +43,7 @@ struct ieee80211_local;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 12
+#define IEEE80211_ENCRYPT_TAILROOM 18
 
 /* IEEE 802.11 (Ch. 9.5 Defragmentation) requires support for concurrent
  * reception of at least three fragmented frames. This limit can be increased

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
