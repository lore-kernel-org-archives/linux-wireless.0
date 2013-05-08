Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3EHNdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 09:33:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: move crypto constants to ieee80211.h
Date: Wed,  8 May 2013 15:33:46 +0200
Message-Id: <1368020026-24031-1-git-send-email-johannes@sipsolutions.net> (sfid-20130508_153357_176198_80C79DEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 and the Intel drivers both define crypto
constants, move them to ieee80211.h instead.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h |  8 ----
 drivers/net/wireless/iwlwifi/pcie/tx.c      |  6 +--
 include/linux/ieee80211.h                   |  9 ++++
 net/mac80211/aes_ccm.c                      |  6 +--
 net/mac80211/key.c                          | 24 +++++-----
 net/mac80211/key.h                          | 15 +------
 net/mac80211/rx.c                           | 12 ++---
 net/mac80211/wep.c                          | 48 ++++++++++----------
 net/mac80211/wpa.c                          | 68 +++++++++++++++--------------
 9 files changed, 96 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index 95ca026..174b0f1 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -1225,14 +1225,6 @@ struct iwl_rx_mpdu_res_start {
 #define TX_CMD_SEC_KEY128	0x08
 
 /*
- * security overhead sizes
- */
-#define WEP_IV_LEN 4
-#define WEP_ICV_LEN 4
-#define CCMP_MIC_LEN 8
-#define TKIP_ICV_LEN 4
-
-/*
  * REPLY_TX = 0x1c (command)
  */
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index d97c1fa..aea024f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -224,13 +224,13 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 
 	switch (sec_ctl & TX_CMD_SEC_MSK) {
 	case TX_CMD_SEC_CCM:
-		len += CCMP_MIC_LEN;
+		len += IEEE80211_CCMP_MIC_LEN;
 		break;
 	case TX_CMD_SEC_TKIP:
-		len += TKIP_ICV_LEN;
+		len += IEEE80211_TKIP_ICV_LEN;
 		break;
 	case TX_CMD_SEC_WEP:
-		len += WEP_IV_LEN + WEP_ICV_LEN;
+		len += IEEE80211_WEP_IV_LEN + IEEE80211_WEP_ICV_LEN;
 		break;
 	}
 
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 06b0ed0..d826e5a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1829,6 +1829,15 @@ enum ieee80211_key_len {
 	WLAN_KEY_LEN_AES_CMAC = 16,
 };
 
+#define IEEE80211_WEP_IV_LEN		4
+#define IEEE80211_WEP_ICV_LEN		4
+#define IEEE80211_CCMP_HDR_LEN		8
+#define IEEE80211_CCMP_MIC_LEN		8
+#define IEEE80211_CCMP_PN_LEN		6
+#define IEEE80211_TKIP_IV_LEN		8
+#define IEEE80211_TKIP_ICV_LEN		4
+#define IEEE80211_CMAC_PN_LEN		6
+
 /* Public action codes */
 enum ieee80211_pub_actioncode {
 	WLAN_PUB_ACTION_EXT_CHANSW_ANN = 4,
diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index 0785e95..be7614b9 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -85,7 +85,7 @@ void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
 			*cpos++ = *pos++ ^ e[i];
 	}
 
-	for (i = 0; i < CCMP_MIC_LEN; i++)
+	for (i = 0; i < IEEE80211_CCMP_MIC_LEN; i++)
 		mic[i] = b[i] ^ s_0[i];
 }
 
@@ -123,7 +123,7 @@ int ieee80211_aes_ccm_decrypt(struct crypto_cipher *tfm, u8 *scratch,
 		crypto_cipher_encrypt_one(tfm, a, a);
 	}
 
-	for (i = 0; i < CCMP_MIC_LEN; i++) {
+	for (i = 0; i < IEEE80211_CCMP_MIC_LEN; i++) {
 		if ((mic[i] ^ s_0[i]) != a[i])
 			return -1;
 	}
@@ -138,7 +138,7 @@ struct crypto_cipher *ieee80211_aes_key_setup_encrypt(const u8 key[])
 
 	tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
 	if (!IS_ERR(tfm))
-		crypto_cipher_setkey(tfm, key, ALG_CCMP_KEY_LEN);
+		crypto_cipher_setkey(tfm, key, WLAN_KEY_LEN_CCMP);
 
 	return tfm;
 }
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 67059b8..e39cc91 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -335,12 +335,12 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 	switch (cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		key->conf.iv_len = WEP_IV_LEN;
-		key->conf.icv_len = WEP_ICV_LEN;
+		key->conf.iv_len = IEEE80211_WEP_IV_LEN;
+		key->conf.icv_len = IEEE80211_WEP_ICV_LEN;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		key->conf.iv_len = TKIP_IV_LEN;
-		key->conf.icv_len = TKIP_ICV_LEN;
+		key->conf.iv_len = IEEE80211_TKIP_IV_LEN;
+		key->conf.icv_len = IEEE80211_TKIP_ICV_LEN;
 		if (seq) {
 			for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 				key->u.tkip.rx[i].iv32 =
@@ -352,13 +352,13 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		spin_lock_init(&key->u.tkip.txlock);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		key->conf.iv_len = CCMP_HDR_LEN;
-		key->conf.icv_len = CCMP_MIC_LEN;
+		key->conf.iv_len = IEEE80211_CCMP_HDR_LEN;
+		key->conf.icv_len = IEEE80211_CCMP_MIC_LEN;
 		if (seq) {
 			for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
-				for (j = 0; j < CCMP_PN_LEN; j++)
+				for (j = 0; j < IEEE80211_CCMP_PN_LEN; j++)
 					key->u.ccmp.rx_pn[i][j] =
-						seq[CCMP_PN_LEN - j - 1];
+						seq[IEEE80211_CCMP_PN_LEN - j - 1];
 		}
 		/*
 		 * Initialize AES key state here as an optimization so that
@@ -375,9 +375,9 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		key->conf.iv_len = 0;
 		key->conf.icv_len = sizeof(struct ieee80211_mmie);
 		if (seq)
-			for (j = 0; j < CMAC_PN_LEN; j++)
+			for (j = 0; j < IEEE80211_CMAC_PN_LEN; j++)
 				key->u.aes_cmac.rx_pn[j] =
-					seq[CMAC_PN_LEN - j - 1];
+					seq[IEEE80211_CMAC_PN_LEN - j - 1];
 		/*
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
@@ -740,13 +740,13 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 			pn = key->u.ccmp.rx_pn[IEEE80211_NUM_TIDS];
 		else
 			pn = key->u.ccmp.rx_pn[tid];
-		memcpy(seq->ccmp.pn, pn, CCMP_PN_LEN);
+		memcpy(seq->ccmp.pn, pn, IEEE80211_CCMP_PN_LEN);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		if (WARN_ON(tid != 0))
 			return;
 		pn = key->u.aes_cmac.rx_pn;
-		memcpy(seq->aes_cmac.pn, pn, CMAC_PN_LEN);
+		memcpy(seq->aes_cmac.pn, pn, IEEE80211_CMAC_PN_LEN);
 		break;
 	}
 }
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index e8de3e6..036d57e 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -19,17 +19,6 @@
 #define NUM_DEFAULT_KEYS 4
 #define NUM_DEFAULT_MGMT_KEYS 2
 
-#define WEP_IV_LEN		4
-#define WEP_ICV_LEN		4
-#define ALG_CCMP_KEY_LEN	16
-#define CCMP_HDR_LEN		8
-#define CCMP_MIC_LEN		8
-#define CCMP_TK_LEN		16
-#define CCMP_PN_LEN		6
-#define TKIP_IV_LEN		8
-#define TKIP_ICV_LEN		4
-#define CMAC_PN_LEN		6
-
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
 struct sta_info;
@@ -93,13 +82,13 @@ struct ieee80211_key {
 			 * frames and the last counter is used with Robust
 			 * Management frames.
 			 */
-			u8 rx_pn[IEEE80211_NUM_TIDS + 1][CCMP_PN_LEN];
+			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_CCMP_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 		} ccmp;
 		struct {
 			atomic64_t tx_pn;
-			u8 rx_pn[CMAC_PN_LEN];
+			u8 rx_pn[IEEE80211_CMAC_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 22e412b..6e2c8c5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1622,7 +1622,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 			entry->ccmp = 1;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
-			       CCMP_PN_LEN);
+			       IEEE80211_CCMP_PN_LEN);
 		}
 		return RX_QUEUED;
 	}
@@ -1641,21 +1641,21 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	 * (IEEE 802.11i, 8.3.3.4.5) */
 	if (entry->ccmp) {
 		int i;
-		u8 pn[CCMP_PN_LEN], *rpn;
+		u8 pn[IEEE80211_CCMP_PN_LEN], *rpn;
 		int queue;
 		if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP)
 			return RX_DROP_UNUSABLE;
-		memcpy(pn, entry->last_pn, CCMP_PN_LEN);
-		for (i = CCMP_PN_LEN - 1; i >= 0; i--) {
+		memcpy(pn, entry->last_pn, IEEE80211_CCMP_PN_LEN);
+		for (i = IEEE80211_CCMP_PN_LEN - 1; i >= 0; i--) {
 			pn[i]++;
 			if (pn[i])
 				break;
 		}
 		queue = rx->security_idx;
 		rpn = rx->key->u.ccmp.rx_pn[queue];
-		if (memcmp(pn, rpn, CCMP_PN_LEN))
+		if (memcmp(pn, rpn, IEEE80211_CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
-		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
+		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
 	}
 
 	skb_pull(rx->skb, ieee80211_hdrlen(fc));
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index c04d401..6ee2b58 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -28,7 +28,7 @@
 int ieee80211_wep_init(struct ieee80211_local *local)
 {
 	/* start WEP IV from a random value */
-	get_random_bytes(&local->wep_iv, WEP_IV_LEN);
+	get_random_bytes(&local->wep_iv, IEEE80211_WEP_IV_LEN);
 
 	local->wep_tx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_tx_tfm)) {
@@ -98,20 +98,21 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 
-	if (WARN_ON(skb_tailroom(skb) < WEP_ICV_LEN ||
-		    skb_headroom(skb) < WEP_IV_LEN))
+	if (WARN_ON(skb_tailroom(skb) < IEEE80211_WEP_ICV_LEN ||
+		    skb_headroom(skb) < IEEE80211_WEP_IV_LEN))
 		return NULL;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	newhdr = skb_push(skb, WEP_IV_LEN);
-	memmove(newhdr, newhdr + WEP_IV_LEN, hdrlen);
+	newhdr = skb_push(skb, IEEE80211_WEP_IV_LEN);
+	memmove(newhdr, newhdr + IEEE80211_WEP_IV_LEN, hdrlen);
 
 	/* the HW only needs room for the IV, but not the actual IV */
 	if (info->control.hw_key &&
 	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
 		return newhdr + hdrlen;
 
-	skb_set_network_header(skb, skb_network_offset(skb) + WEP_IV_LEN);
+	skb_set_network_header(skb, skb_network_offset(skb) +
+				    IEEE80211_WEP_IV_LEN);
 	ieee80211_wep_get_iv(local, keylen, keyidx, newhdr + hdrlen);
 	return newhdr + hdrlen;
 }
@@ -125,8 +126,8 @@ static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
 	unsigned int hdrlen;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	memmove(skb->data + WEP_IV_LEN, skb->data, hdrlen);
-	skb_pull(skb, WEP_IV_LEN);
+	memmove(skb->data + IEEE80211_WEP_IV_LEN, skb->data, hdrlen);
+	skb_pull(skb, IEEE80211_WEP_IV_LEN);
 }
 
 
@@ -146,7 +147,7 @@ int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 	put_unaligned(icv, (__le32 *)(data + data_len));
 
 	crypto_cipher_setkey(tfm, rc4key, klen);
-	for (i = 0; i < data_len + WEP_ICV_LEN; i++)
+	for (i = 0; i < data_len + IEEE80211_WEP_ICV_LEN; i++)
 		crypto_cipher_encrypt_one(tfm, data + i, data + i);
 
 	return 0;
@@ -172,7 +173,7 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	if (!iv)
 		return -1;
 
-	len = skb->len - (iv + WEP_IV_LEN - skb->data);
+	len = skb->len - (iv + IEEE80211_WEP_IV_LEN - skb->data);
 
 	/* Prepend 24-bit IV to RC4 key */
 	memcpy(rc4key, iv, 3);
@@ -181,10 +182,10 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	memcpy(rc4key + 3, key, keylen);
 
 	/* Add room for ICV */
-	skb_put(skb, WEP_ICV_LEN);
+	skb_put(skb, IEEE80211_WEP_ICV_LEN);
 
 	return ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, keylen + 3,
-					  iv + WEP_IV_LEN, len);
+					  iv + IEEE80211_WEP_IV_LEN, len);
 }
 
 
@@ -201,11 +202,11 @@ int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 		return -1;
 
 	crypto_cipher_setkey(tfm, rc4key, klen);
-	for (i = 0; i < data_len + WEP_ICV_LEN; i++)
+	for (i = 0; i < data_len + IEEE80211_WEP_ICV_LEN; i++)
 		crypto_cipher_decrypt_one(tfm, data + i, data + i);
 
 	crc = cpu_to_le32(~crc32_le(~0, data, data_len));
-	if (memcmp(&crc, data + data_len, WEP_ICV_LEN) != 0)
+	if (memcmp(&crc, data + data_len, IEEE80211_WEP_ICV_LEN) != 0)
 		/* ICV mismatch */
 		return -1;
 
@@ -237,10 +238,10 @@ static int ieee80211_wep_decrypt(struct ieee80211_local *local,
 		return -1;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	if (skb->len < hdrlen + WEP_IV_LEN + WEP_ICV_LEN)
+	if (skb->len < hdrlen + IEEE80211_WEP_IV_LEN + IEEE80211_WEP_ICV_LEN)
 		return -1;
 
-	len = skb->len - hdrlen - WEP_IV_LEN - WEP_ICV_LEN;
+	len = skb->len - hdrlen - IEEE80211_WEP_IV_LEN - IEEE80211_WEP_ICV_LEN;
 
 	keyidx = skb->data[hdrlen + 3] >> 6;
 
@@ -256,16 +257,16 @@ static int ieee80211_wep_decrypt(struct ieee80211_local *local,
 	memcpy(rc4key + 3, key->conf.key, key->conf.keylen);
 
 	if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
-				       skb->data + hdrlen + WEP_IV_LEN,
-				       len))
+				       skb->data + hdrlen +
+				       IEEE80211_WEP_IV_LEN, len))
 		ret = -1;
 
 	/* Trim ICV */
-	skb_trim(skb, skb->len - WEP_ICV_LEN);
+	skb_trim(skb, skb->len - IEEE80211_WEP_ICV_LEN);
 
 	/* Remove IV */
-	memmove(skb->data + WEP_IV_LEN, skb->data, hdrlen);
-	skb_pull(skb, WEP_IV_LEN);
+	memmove(skb->data + IEEE80211_WEP_IV_LEN, skb->data, hdrlen);
+	skb_pull(skb, IEEE80211_WEP_IV_LEN);
 
 	return ret;
 }
@@ -305,13 +306,14 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key))
 			return RX_DROP_UNUSABLE;
 	} else if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
-		if (!pskb_may_pull(rx->skb, ieee80211_hdrlen(fc) + WEP_IV_LEN))
+		if (!pskb_may_pull(rx->skb, ieee80211_hdrlen(fc) +
+					    IEEE80211_WEP_IV_LEN))
 			return RX_DROP_UNUSABLE;
 		if (rx->sta && ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 			rx->sta->wep_weak_iv_count++;
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
-		if (pskb_trim(rx->skb, rx->skb->len - WEP_ICV_LEN))
+		if (pskb_trim(rx->skb, rx->skb->len - IEEE80211_WEP_ICV_LEN))
 			return RX_DROP_UNUSABLE;
 	}
 
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index c7c6d64..c9edfcb 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -62,10 +62,10 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 
 	tail = MICHAEL_MIC_LEN;
 	if (!info->control.hw_key)
-		tail += TKIP_ICV_LEN;
+		tail += IEEE80211_TKIP_ICV_LEN;
 
 	if (WARN_ON(skb_tailroom(skb) < tail ||
-		    skb_headroom(skb) < TKIP_IV_LEN))
+		    skb_headroom(skb) < IEEE80211_TKIP_IV_LEN))
 		return TX_DROP;
 
 	key = &tx->key->conf.key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY];
@@ -198,15 +198,16 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	if (info->control.hw_key)
 		tail = 0;
 	else
-		tail = TKIP_ICV_LEN;
+		tail = IEEE80211_TKIP_ICV_LEN;
 
 	if (WARN_ON(skb_tailroom(skb) < tail ||
-		    skb_headroom(skb) < TKIP_IV_LEN))
+		    skb_headroom(skb) < IEEE80211_TKIP_IV_LEN))
 		return -1;
 
-	pos = skb_push(skb, TKIP_IV_LEN);
-	memmove(pos, pos + TKIP_IV_LEN, hdrlen);
-	skb_set_network_header(skb, skb_network_offset(skb) + TKIP_IV_LEN);
+	pos = skb_push(skb, IEEE80211_TKIP_IV_LEN);
+	memmove(pos, pos + IEEE80211_TKIP_IV_LEN, hdrlen);
+	skb_set_network_header(skb, skb_network_offset(skb) +
+				    IEEE80211_TKIP_IV_LEN);
 	pos += hdrlen;
 
 	/* the HW only needs room for the IV, but not the actual IV */
@@ -227,7 +228,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 
 	/* Add room for ICV */
-	skb_put(skb, TKIP_ICV_LEN);
+	skb_put(skb, IEEE80211_TKIP_ICV_LEN);
 
 	return ieee80211_tkip_encrypt_data(tx->local->wep_tx_tfm,
 					   key, skb, pos, len);
@@ -290,11 +291,11 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_UNUSABLE;
 
 	/* Trim ICV */
-	skb_trim(skb, skb->len - TKIP_ICV_LEN);
+	skb_trim(skb, skb->len - IEEE80211_TKIP_ICV_LEN);
 
 	/* Remove IV */
-	memmove(skb->data + TKIP_IV_LEN, skb->data, hdrlen);
-	skb_pull(skb, TKIP_IV_LEN);
+	memmove(skb->data + IEEE80211_TKIP_IV_LEN, skb->data, hdrlen);
+	skb_pull(skb, IEEE80211_TKIP_IV_LEN);
 
 	return RX_CONTINUE;
 }
@@ -337,9 +338,9 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *scratch,
 	else
 		qos_tid = 0;
 
-	data_len = skb->len - hdrlen - CCMP_HDR_LEN;
+	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN;
 	if (encrypted)
-		data_len -= CCMP_MIC_LEN;
+		data_len -= IEEE80211_CCMP_MIC_LEN;
 
 	/* First block, b_0 */
 	b_0[0] = 0x59; /* flags: Adata: 1, M: 011, L: 001 */
@@ -348,7 +349,7 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *scratch,
 	 */
 	b_0[1] = qos_tid | (mgmt << 4);
 	memcpy(&b_0[2], hdr->addr2, ETH_ALEN);
-	memcpy(&b_0[8], pn, CCMP_PN_LEN);
+	memcpy(&b_0[8], pn, IEEE80211_CCMP_PN_LEN);
 	/* l(m) */
 	put_unaligned_be16(data_len, &b_0[14]);
 
@@ -424,15 +425,16 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	if (info->control.hw_key)
 		tail = 0;
 	else
-		tail = CCMP_MIC_LEN;
+		tail = IEEE80211_CCMP_MIC_LEN;
 
 	if (WARN_ON(skb_tailroom(skb) < tail ||
-		    skb_headroom(skb) < CCMP_HDR_LEN))
+		    skb_headroom(skb) < IEEE80211_CCMP_HDR_LEN))
 		return -1;
 
-	pos = skb_push(skb, CCMP_HDR_LEN);
-	memmove(pos, pos + CCMP_HDR_LEN, hdrlen);
-	skb_set_network_header(skb, skb_network_offset(skb) + CCMP_HDR_LEN);
+	pos = skb_push(skb, IEEE80211_CCMP_HDR_LEN);
+	memmove(pos, pos + IEEE80211_CCMP_HDR_LEN, hdrlen);
+	skb_set_network_header(skb, skb_network_offset(skb) +
+				    IEEE80211_CCMP_HDR_LEN);
 
 	/* the HW only needs room for the IV, but not the actual IV */
 	if (info->control.hw_key &&
@@ -457,10 +459,10 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	if (info->control.hw_key)
 		return 0;
 
-	pos += CCMP_HDR_LEN;
+	pos += IEEE80211_CCMP_HDR_LEN;
 	ccmp_special_blocks(skb, pn, scratch, 0);
 	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, scratch, pos, len,
-				  pos, skb_put(skb, CCMP_MIC_LEN));
+				  pos, skb_put(skb, IEEE80211_CCMP_MIC_LEN));
 
 	return 0;
 }
@@ -490,7 +492,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	u8 pn[CCMP_PN_LEN];
+	u8 pn[IEEE80211_CCMP_PN_LEN];
 	int data_len;
 	int queue;
 
@@ -500,12 +502,13 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	    !ieee80211_is_robust_mgmt_frame(hdr))
 		return RX_CONTINUE;
 
-	data_len = skb->len - hdrlen - CCMP_HDR_LEN - CCMP_MIC_LEN;
+	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN -
+		   IEEE80211_CCMP_MIC_LEN;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
 
 	if (status->flag & RX_FLAG_DECRYPTED) {
-		if (!pskb_may_pull(rx->skb, hdrlen + CCMP_HDR_LEN))
+		if (!pskb_may_pull(rx->skb, hdrlen + IEEE80211_CCMP_HDR_LEN))
 			return RX_DROP_UNUSABLE;
 	} else {
 		if (skb_linearize(rx->skb))
@@ -516,7 +519,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 	queue = rx->security_idx;
 
-	if (memcmp(pn, key->u.ccmp.rx_pn[queue], CCMP_PN_LEN) <= 0) {
+	if (memcmp(pn, key->u.ccmp.rx_pn[queue], IEEE80211_CCMP_PN_LEN) <= 0) {
 		key->u.ccmp.replays++;
 		return RX_DROP_UNUSABLE;
 	}
@@ -528,19 +531,20 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 		if (ieee80211_aes_ccm_decrypt(
 			    key->u.ccmp.tfm, scratch,
-			    skb->data + hdrlen + CCMP_HDR_LEN, data_len,
-			    skb->data + skb->len - CCMP_MIC_LEN,
-			    skb->data + hdrlen + CCMP_HDR_LEN))
+			    skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN,
+			    data_len,
+			    skb->data + skb->len - IEEE80211_CCMP_MIC_LEN,
+			    skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN))
 			return RX_DROP_UNUSABLE;
 	}
 
-	memcpy(key->u.ccmp.rx_pn[queue], pn, CCMP_PN_LEN);
+	memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
 
 	/* Remove CCMP header and MIC */
-	if (pskb_trim(skb, skb->len - CCMP_MIC_LEN))
+	if (pskb_trim(skb, skb->len - IEEE80211_CCMP_MIC_LEN))
 		return RX_DROP_UNUSABLE;
-	memmove(skb->data + CCMP_HDR_LEN, skb->data, hdrlen);
-	skb_pull(skb, CCMP_HDR_LEN);
+	memmove(skb->data + IEEE80211_CCMP_HDR_LEN, skb->data, hdrlen);
+	skb_pull(skb, IEEE80211_CCMP_HDR_LEN);
 
 	return RX_CONTINUE;
 }
-- 
1.8.0

