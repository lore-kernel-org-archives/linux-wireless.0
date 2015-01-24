Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53685 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbbAXRx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:53:26 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] mac80111: Add CCMP-256 cipher
Date: Sat, 24 Jan 2015 19:52:07 +0200
Message-ID: <1422121929-18238-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20150124_185329_338871_93FDB913)
In-Reply-To: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows mac80211 to configure CCMP-256 to the driver and also use
software-implementation within mac80211 when the driver does not support
this with hardware accelaration.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/aes_ccm.c     | 21 ++++++++++++---------
 net/mac80211/aes_ccm.h     | 10 +++++++---
 net/mac80211/cfg.c         |  2 ++
 net/mac80211/debugfs_key.c |  3 +++
 net/mac80211/key.c         | 27 ++++++++++++++++++++++++++-
 net/mac80211/main.c        |  6 ++++--
 net/mac80211/rx.c          | 13 ++++++++++---
 net/mac80211/tx.c          |  5 ++++-
 net/mac80211/wpa.c         | 24 ++++++++++++++----------
 net/mac80211/wpa.h         |  4 ++--
 10 files changed, 84 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index 09d9caa..7869bb4 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -20,7 +20,8 @@
 #include "aes_ccm.h"
 
 void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
-			       u8 *data, size_t data_len, u8 *mic)
+			       u8 *data, size_t data_len, u8 *mic,
+			       size_t mic_len)
 {
 	struct scatterlist assoc, pt, ct[2];
 
@@ -35,7 +36,7 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
 	sg_init_table(ct, 2);
 	sg_set_buf(&ct[0], data, data_len);
-	sg_set_buf(&ct[1], mic, IEEE80211_CCMP_MIC_LEN);
+	sg_set_buf(&ct[1], mic, mic_len);
 
 	aead_request_set_tfm(aead_req, tfm);
 	aead_request_set_assoc(aead_req, &assoc, assoc.length);
@@ -45,7 +46,8 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 }
 
 int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
-			      u8 *data, size_t data_len, u8 *mic)
+			      u8 *data, size_t data_len, u8 *mic,
+			      size_t mic_len)
 {
 	struct scatterlist assoc, pt, ct[2];
 	char aead_req_data[sizeof(struct aead_request) +
@@ -62,17 +64,18 @@ int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
 	sg_init_table(ct, 2);
 	sg_set_buf(&ct[0], data, data_len);
-	sg_set_buf(&ct[1], mic, IEEE80211_CCMP_MIC_LEN);
+	sg_set_buf(&ct[1], mic, mic_len);
 
 	aead_request_set_tfm(aead_req, tfm);
 	aead_request_set_assoc(aead_req, &assoc, assoc.length);
-	aead_request_set_crypt(aead_req, ct, &pt,
-			       data_len + IEEE80211_CCMP_MIC_LEN, b_0);
+	aead_request_set_crypt(aead_req, ct, &pt, data_len + mic_len, b_0);
 
 	return crypto_aead_decrypt(aead_req);
 }
 
-struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[])
+struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[],
+						    size_t key_len,
+						    size_t mic_len)
 {
 	struct crypto_aead *tfm;
 	int err;
@@ -81,9 +84,9 @@ struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[])
 	if (IS_ERR(tfm))
 		return tfm;
 
-	err = crypto_aead_setkey(tfm, key, WLAN_KEY_LEN_CCMP);
+	err = crypto_aead_setkey(tfm, key, key_len);
 	if (!err)
-		err = crypto_aead_setauthsize(tfm, IEEE80211_CCMP_MIC_LEN);
+		err = crypto_aead_setauthsize(tfm, mic_len);
 	if (!err)
 		return tfm;
 
diff --git a/net/mac80211/aes_ccm.h b/net/mac80211/aes_ccm.h
index 2c7ab19..6a73d1e 100644
--- a/net/mac80211/aes_ccm.h
+++ b/net/mac80211/aes_ccm.h
@@ -12,11 +12,15 @@
 
 #include <linux/crypto.h>
 
-struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[]);
+struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[],
+						    size_t key_len,
+						    size_t mic_len);
 void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
-			       u8 *data, size_t data_len, u8 *mic);
+			       u8 *data, size_t data_len, u8 *mic,
+			       size_t mic_len);
 int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
-			      u8 *data, size_t data_len, u8 *mic);
+			      u8 *data, size_t data_len, u8 *mic,
+			      size_t mic_len);
 void ieee80211_aes_key_free(struct crypto_aead *tfm);
 
 #endif /* AES_CCM_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1c1d061..ef84441 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -162,6 +162,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			return -EINVAL;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
@@ -349,6 +350,7 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		params.seq_len = 6;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		pn64 = atomic64_read(&key->u.ccmp.tx_pn);
 		seq[0] = pn64;
 		seq[1] = pn64 >> 8;
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 0e223e6..64de07b 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -94,6 +94,7 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 				key->u.tkip.tx.iv16);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		pn = atomic64_read(&key->u.ccmp.tx_pn);
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
 				(u8)(pn >> 40), (u8)(pn >> 32), (u8)(pn >> 24),
@@ -141,6 +142,7 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 		len = p - buf;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
 			rpn = key->u.ccmp.rx_pn[i];
 			p += scnprintf(p, sizeof(buf)+buf-p,
@@ -185,6 +187,7 @@ static ssize_t key_replays_read(struct file *file, char __user *userbuf,
 
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		len = scnprintf(buf, sizeof(buf), "%u\n", key->u.ccmp.replays);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index cbee2f5..83c6108 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -163,6 +163,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_WEP104:
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
@@ -389,7 +390,26 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
 		 */
-		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(key_data);
+		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(
+			key_data, key_len, IEEE80211_CCMP_MIC_LEN);
+		if (IS_ERR(key->u.ccmp.tfm)) {
+			err = PTR_ERR(key->u.ccmp.tfm);
+			kfree(key);
+			return ERR_PTR(err);
+		}
+		break;
+	case WLAN_CIPHER_SUITE_CCMP_256:
+		key->conf.iv_len = IEEE80211_CCMP_256_HDR_LEN;
+		key->conf.icv_len = IEEE80211_CCMP_256_MIC_LEN;
+		for (i = 0; seq && i < IEEE80211_NUM_TIDS + 1; i++)
+			for (j = 0; j < IEEE80211_CCMP_256_PN_LEN; j++)
+				key->u.ccmp.rx_pn[i][j] =
+					seq[IEEE80211_CCMP_256_PN_LEN - j - 1];
+		/* Initialize AES key state here as an optimization so that
+		 * it does not need to be initialized for every packet.
+		 */
+		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(
+			key_data, key_len, IEEE80211_CCMP_256_MIC_LEN);
 		if (IS_ERR(key->u.ccmp.tfm)) {
 			err = PTR_ERR(key->u.ccmp.tfm);
 			kfree(key);
@@ -457,6 +477,7 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 {
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
@@ -773,6 +794,7 @@ void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		seq->tkip.iv16 = key->u.tkip.tx.iv16;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		pn64 = atomic64_read(&key->u.ccmp.tx_pn);
 		seq->ccmp.pn[5] = pn64;
 		seq->ccmp.pn[4] = pn64 >> 8;
@@ -822,6 +844,7 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		seq->tkip.iv16 = key->u.tkip.rx[tid].iv16;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
 			return;
 		if (tid < 0)
@@ -864,6 +887,7 @@ void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
 		key->u.tkip.tx.iv16 = seq->tkip.iv16;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		pn64 = (u64)seq->ccmp.pn[5] |
 		       ((u64)seq->ccmp.pn[4] << 8) |
 		       ((u64)seq->ccmp.pn[3] << 16) |
@@ -914,6 +938,7 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
 		key->u.tkip.rx[tid].iv16 = seq->tkip.iv16;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
 			return;
 		if (tid < 0)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7223b4e..a5ad2d5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -666,6 +666,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		WLAN_CIPHER_SUITE_WEP104,
 		WLAN_CIPHER_SUITE_TKIP,
 		WLAN_CIPHER_SUITE_CCMP,
+		WLAN_CIPHER_SUITE_CCMP_256,
 		WLAN_CIPHER_SUITE_GCMP,
 		WLAN_CIPHER_SUITE_GCMP_256,
 
@@ -727,9 +728,9 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		 * including the schemes)
 		 *
 		 * We start counting ciphers defined by schemes, TKIP, CCMP,
-		 * GCMP, and GCMP-256
+		 * CCMP-256, GCMP, and GCMP-256
 		 */
-		n_suites = local->hw.n_cipher_schemes + 4;
+		n_suites = local->hw.n_cipher_schemes + 5;
 
 		/* check if we have WEP40 and WEP104 */
 		if (have_wep)
@@ -744,6 +745,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 			return -ENOMEM;
 
 		suites[w++] = WLAN_CIPHER_SUITE_CCMP;
+		suites[w++] = WLAN_CIPHER_SUITE_CCMP_256;
 		suites[w++] = WLAN_CIPHER_SUITE_TKIP;
 		suites[w++] = WLAN_CIPHER_SUITE_GCMP;
 		suites[w++] = WLAN_CIPHER_SUITE_GCMP_256;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a11d251..1bcec37 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1650,7 +1650,10 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		result = ieee80211_crypto_tkip_decrypt(rx);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		result = ieee80211_crypto_ccmp_decrypt(rx);
+		result = ieee80211_crypto_ccmp_decrypt(rx, false);
+		break;
+	case WLAN_CIPHER_SUITE_CCMP_256:
+		result = ieee80211_crypto_ccmp_decrypt(rx, true);
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		result = ieee80211_crypto_aes_cmac_decrypt(rx);
@@ -1785,7 +1788,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		/* This is the first fragment of a new frame. */
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->seqno_idx, &(rx->skb));
-		if (rx->key && rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP &&
+		if (rx->key &&
+		    (rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP ||
+		     rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP_256) &&
 		    ieee80211_has_protected(fc)) {
 			int queue = rx->security_idx;
 			/* Store CCMP PN so that we can verify that the next
@@ -1814,7 +1819,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		int i;
 		u8 pn[IEEE80211_CCMP_PN_LEN], *rpn;
 		int queue;
-		if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP)
+		if (!rx->key ||
+		    (rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP &&
+		     rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP_256))
 			return RX_DROP_UNUSABLE;
 		memcpy(pn, entry->last_pn, IEEE80211_CCMP_PN_LEN);
 		for (i = IEEE80211_CCMP_PN_LEN - 1; i >= 0; i--) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e4c6fbc..360773b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -626,6 +626,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 				tx->key = NULL;
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP_256:
 		case WLAN_CIPHER_SUITE_GCMP:
 		case WLAN_CIPHER_SUITE_GCMP_256:
 			if (!ieee80211_is_data_present(hdr->frame_control) &&
@@ -1013,7 +1014,9 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 	case WLAN_CIPHER_SUITE_TKIP:
 		return ieee80211_crypto_tkip_encrypt(tx);
 	case WLAN_CIPHER_SUITE_CCMP:
-		return ieee80211_crypto_ccmp_encrypt(tx);
+		return ieee80211_crypto_ccmp_encrypt(tx, false);
+	case WLAN_CIPHER_SUITE_CCMP_256:
+		return ieee80211_crypto_ccmp_encrypt(tx, true);
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		return ieee80211_crypto_aes_cmac_encrypt(tx);
 	case WLAN_CIPHER_SUITE_GCMP:
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 96b65c2..1edb5f0 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -394,7 +394,8 @@ static inline void ccmp_hdr2pn(u8 *pn, u8 *hdr)
 }
 
 
-static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
+static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
+			    bool ccmp256)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
@@ -405,6 +406,8 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	u64 pn64;
 	u8 aad[2 * AES_BLOCK_SIZE];
 	u8 b_0[AES_BLOCK_SIZE];
+	unsigned int mic_len = ccmp256 ? IEEE80211_CCMP_256_MIC_LEN :
+		IEEE80211_CCMP_MIC_LEN;
 
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
@@ -425,7 +428,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	if (info->control.hw_key)
 		tail = 0;
 	else
-		tail = IEEE80211_CCMP_MIC_LEN;
+		tail = mic_len;
 
 	if (WARN_ON(skb_tailroom(skb) < tail ||
 		    skb_headroom(skb) < IEEE80211_CCMP_HDR_LEN))
@@ -460,21 +463,21 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	pos += IEEE80211_CCMP_HDR_LEN;
 	ccmp_special_blocks(skb, pn, b_0, aad);
 	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, b_0, aad, pos, len,
-				  skb_put(skb, IEEE80211_CCMP_MIC_LEN));
+				  skb_put(skb, mic_len), mic_len);
 
 	return 0;
 }
 
 
 ieee80211_tx_result
-ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
+ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx, bool ccmp256)
 {
 	struct sk_buff *skb;
 
 	ieee80211_tx_set_protected(tx);
 
 	skb_queue_walk(&tx->skbs, skb) {
-		if (ccmp_encrypt_skb(tx, skb) < 0)
+		if (ccmp_encrypt_skb(tx, skb, ccmp256) < 0)
 			return TX_DROP;
 	}
 
@@ -483,7 +486,7 @@ ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
 
 
 ieee80211_rx_result
-ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
+ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx, bool ccmp256)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int hdrlen;
@@ -493,6 +496,8 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	u8 pn[IEEE80211_CCMP_PN_LEN];
 	int data_len;
 	int queue;
+	unsigned int mic_len = ccmp256 ? IEEE80211_CCMP_256_MIC_LEN :
+		IEEE80211_CCMP_MIC_LEN;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -500,8 +505,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	    !ieee80211_is_robust_mgmt_frame(skb))
 		return RX_CONTINUE;
 
-	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN -
-		   IEEE80211_CCMP_MIC_LEN;
+	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
 
@@ -532,14 +536,14 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 			    key->u.ccmp.tfm, b_0, aad,
 			    skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN,
 			    data_len,
-			    skb->data + skb->len - IEEE80211_CCMP_MIC_LEN))
+			    skb->data + skb->len - mic_len, mic_len))
 			return RX_DROP_UNUSABLE;
 	}
 
 	memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
 
 	/* Remove CCMP header and MIC */
-	if (pskb_trim(skb, skb->len - IEEE80211_CCMP_MIC_LEN))
+	if (pskb_trim(skb, skb->len - mic_len))
 		return RX_DROP_UNUSABLE;
 	memmove(skb->data + IEEE80211_CCMP_HDR_LEN, skb->data, hdrlen);
 	skb_pull(skb, IEEE80211_CCMP_HDR_LEN);
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index ea955f2..ccf6c0c 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -24,9 +24,9 @@ ieee80211_rx_result
 ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx);
 
 ieee80211_tx_result
-ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx, bool ccmp256);
 ieee80211_rx_result
-ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx, bool ccmp256);
 
 ieee80211_tx_result
 ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx);
-- 
1.9.1

