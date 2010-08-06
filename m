Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933957Ab0HFHgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 03:36:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OhHTa-0005aD-FO
	for linux-wireless@vger.kernel.org; Fri, 06 Aug 2010 09:36:23 +0200
Subject: [RFC] mac80211: use cipher suite selectors
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 09:36:21 +0200
Message-ID: <1281080181.3853.79.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, mac80211 translates the cfg80211
cipher suite selectors into ALG_* values.
That isn't all too useful, and some drivers
benefit from the distinction between WEP40
and WEP104 as well. Therefore, convert it
all to use the cipher suite selectors.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I rolled up mcgrof's key thing patch for ath9k.

 drivers/net/wireless/ath/ar9170/main.c        |   31 +++++++-------
 drivers/net/wireless/ath/ath5k/base.c         |    9 ++--
 drivers/net/wireless/ath/ath5k/pcu.c          |   19 +++-----
 drivers/net/wireless/ath/ath9k/common.c       |   36 +++++++++--------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
 drivers/net/wireless/ath/ath9k/main.c         |    5 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |   18 --------
 drivers/net/wireless/b43/main.c               |   16 +++----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   16 +++----
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    4 +
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    2 
 drivers/net/wireless/iwlwifi/iwl-sta.c        |   24 ++++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |   43 +++++++++++---------
 drivers/net/wireless/p54/main.c               |    9 ++--
 drivers/net/wireless/p54/txrx.c               |   17 ++++----
 drivers/net/wireless/rt2x00/rt2500usb.c       |    4 +
 drivers/net/wireless/rt2x00/rt2x00crypto.c    |   17 +++-----
 drivers/net/wireless/wl12xx/wl1251_main.c     |   13 +++---
 drivers/net/wireless/wl12xx/wl1251_tx.c       |    4 -
 drivers/net/wireless/wl12xx/wl1271_main.c     |   13 +++---
 drivers/net/wireless/wl12xx/wl1271_tx.c       |    4 -
 include/net/mac80211.h                        |   18 --------
 net/mac80211/cfg.c                            |   44 +++++---------------
 net/mac80211/debugfs_key.c                    |   55 ++++++++++----------------
 net/mac80211/driver-trace.h                   |    4 -
 net/mac80211/key.c                            |   25 +++++------
 net/mac80211/key.h                            |    4 -
 net/mac80211/rx.c                             |   18 ++++----
 net/mac80211/tx.c                             |   22 +++++-----
 net/mac80211/wep.c                            |    2 
 net/mac80211/wpa.c                            |    6 +-
 31 files changed, 233 insertions(+), 274 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-08-05 23:30:25.000000000 +0200
@@ -789,20 +789,6 @@ static inline bool ieee80211_vif_is_mesh
 }
 
 /**
- * enum ieee80211_key_alg - key algorithm
- * @ALG_WEP: WEP40 or WEP104
- * @ALG_TKIP: TKIP
- * @ALG_CCMP: CCMP (AES)
- * @ALG_AES_CMAC: AES-128-CMAC
- */
-enum ieee80211_key_alg {
-	ALG_WEP,
-	ALG_TKIP,
-	ALG_CCMP,
-	ALG_AES_CMAC,
-};
-
-/**
  * enum ieee80211_key_flags - key flags
  *
  * These flags are used for communication about keys between the driver
@@ -839,7 +825,7 @@ enum ieee80211_key_flags {
  * @hw_key_idx: To be set by the driver, this is the key index the driver
  *	wants to be given when a frame is transmitted and needs to be
  *	encrypted in hardware.
- * @alg: The key algorithm.
+ * @cipher: The key's cipher suite selector.
  * @flags: key flags, see &enum ieee80211_key_flags.
  * @keyidx: the key index (0-3)
  * @keylen: key material length
@@ -852,7 +838,7 @@ enum ieee80211_key_flags {
  * @iv_len: The IV length for this key type
  */
 struct ieee80211_key_conf {
-	enum ieee80211_key_alg alg;
+	u32 cipher;
 	u8 icv_len;
 	u8 iv_len;
 	u8 hw_key_idx;
--- wireless-testing.orig/net/mac80211/cfg.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-08-06 09:01:49.000000000 +0200
@@ -116,7 +116,6 @@ static int ieee80211_add_key(struct wiph
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
-	enum ieee80211_key_alg alg;
 	struct ieee80211_key *key;
 	int err;
 
@@ -125,31 +124,20 @@ static int ieee80211_add_key(struct wiph
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	/* reject WEP and TKIP keys if WEP failed to initialize */
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
-		alg = ALG_WEP;
-		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		alg = ALG_TKIP;
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-		alg = ALG_CCMP;
-		break;
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-		alg = ALG_AES_CMAC;
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (IS_ERR(sdata->local->wep_tx_tfm))
+			return -EINVAL;
 		break;
 	default:
-		return -EINVAL;
+		break;
 	}
 
-	/* reject WEP and TKIP keys if WEP failed to initialize */
-	if ((alg == ALG_WEP || alg == ALG_TKIP) &&
-	    IS_ERR(sdata->local->wep_tx_tfm))
-		return -EINVAL;
-
-	key = ieee80211_key_alloc(alg, key_idx, params->key_len, params->key,
-				  params->seq_len, params->seq);
+	key = ieee80211_key_alloc(params->cipher, key_idx, params->key_len,
+				  params->key, params->seq_len, params->seq);
 	if (!key)
 		return -ENOMEM;
 
@@ -247,10 +235,10 @@ static int ieee80211_get_key(struct wiph
 
 	memset(&params, 0, sizeof(params));
 
-	switch (key->conf.alg) {
-	case ALG_TKIP:
-		params.cipher = WLAN_CIPHER_SUITE_TKIP;
+	params.cipher = key->conf.cipher;
 
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
 		iv32 = key->u.tkip.tx.iv32;
 		iv16 = key->u.tkip.tx.iv16;
 
@@ -268,8 +256,7 @@ static int ieee80211_get_key(struct wiph
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
-	case ALG_CCMP:
-		params.cipher = WLAN_CIPHER_SUITE_CCMP;
+	case WLAN_CIPHER_SUITE_CCMP:
 		seq[0] = key->u.ccmp.tx_pn[5];
 		seq[1] = key->u.ccmp.tx_pn[4];
 		seq[2] = key->u.ccmp.tx_pn[3];
@@ -279,14 +266,7 @@ static int ieee80211_get_key(struct wiph
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
-	case ALG_WEP:
-		if (key->conf.keylen == 5)
-			params.cipher = WLAN_CIPHER_SUITE_WEP40;
-		else
-			params.cipher = WLAN_CIPHER_SUITE_WEP104;
-		break;
-	case ALG_AES_CMAC:
-		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		seq[0] = key->u.aes_cmac.tx_pn[5];
 		seq[1] = key->u.aes_cmac.tx_pn[4];
 		seq[2] = key->u.aes_cmac.tx_pn[3];
--- wireless-testing.orig/net/mac80211/key.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2010-08-06 09:01:49.000000000 +0200
@@ -227,9 +227,7 @@ static void __ieee80211_key_replace(stru
 	}
 }
 
-struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
-					  int idx,
-					  size_t key_len,
+struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 					  const u8 *key_data,
 					  size_t seq_len, const u8 *seq)
 {
@@ -249,15 +247,16 @@ struct ieee80211_key *ieee80211_key_allo
 	key->conf.flags = 0;
 	key->flags = 0;
 
-	key->conf.alg = alg;
+	key->conf.cipher = cipher;
 	key->conf.keyidx = idx;
 	key->conf.keylen = key_len;
-	switch (alg) {
-	case ALG_WEP:
+	switch (cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		key->conf.iv_len = WEP_IV_LEN;
 		key->conf.icv_len = WEP_ICV_LEN;
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		key->conf.iv_len = TKIP_IV_LEN;
 		key->conf.icv_len = TKIP_ICV_LEN;
 		if (seq) {
@@ -269,7 +268,7 @@ struct ieee80211_key *ieee80211_key_allo
 			}
 		}
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		key->conf.iv_len = CCMP_HDR_LEN;
 		key->conf.icv_len = CCMP_MIC_LEN;
 		if (seq) {
@@ -279,7 +278,7 @@ struct ieee80211_key *ieee80211_key_allo
 						seq[CCMP_PN_LEN - j - 1];
 		}
 		break;
-	case ALG_AES_CMAC:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		key->conf.iv_len = 0;
 		key->conf.icv_len = sizeof(struct ieee80211_mmie);
 		if (seq)
@@ -290,7 +289,7 @@ struct ieee80211_key *ieee80211_key_allo
 	memcpy(key->conf.key, key_data, key_len);
 	INIT_LIST_HEAD(&key->list);
 
-	if (alg == ALG_CCMP) {
+	if (cipher == WLAN_CIPHER_SUITE_CCMP) {
 		/*
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
@@ -302,7 +301,7 @@ struct ieee80211_key *ieee80211_key_allo
 		}
 	}
 
-	if (alg == ALG_AES_CMAC) {
+	if (cipher == WLAN_CIPHER_SUITE_AES_CMAC) {
 		/*
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
@@ -326,9 +325,9 @@ static void __ieee80211_key_destroy(stru
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
 
-	if (key->conf.alg == ALG_CCMP)
+	if (key->conf.cipher == WLAN_CIPHER_SUITE_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
-	if (key->conf.alg == ALG_AES_CMAC)
+	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 	if (key->local)
 		ieee80211_debugfs_key_remove(key);
--- wireless-testing.orig/net/mac80211/key.h	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/key.h	2010-08-06 09:01:49.000000000 +0200
@@ -123,9 +123,7 @@ struct ieee80211_key {
 	struct ieee80211_key_conf conf;
 };
 
-struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
-					  int idx,
-					  size_t key_len,
+struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 					  const u8 *key_data,
 					  size_t seq_len, const u8 *seq);
 /*
--- wireless-testing.orig/net/mac80211/rx.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-08-06 09:01:49.000000000 +0200
@@ -935,7 +935,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		 * pairwise or station-to-station keys, but for WEP we allow
 		 * using a key index as well.
 		 */
-		if (rx->key && rx->key->conf.alg != ALG_WEP &&
+		if (rx->key && rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
+		    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
 		    !is_multicast_ether_addr(hdr->addr1))
 			rx->key = NULL;
 	}
@@ -951,8 +952,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		return RX_DROP_UNUSABLE;
 	/* the hdr variable is invalid now! */
 
-	switch (rx->key->conf.alg) {
-	case ALG_WEP:
+	switch (rx->key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		/* Check for weak IVs if possible */
 		if (rx->sta && ieee80211_is_data(fc) &&
 		    (!(status->flag & RX_FLAG_IV_STRIPPED) ||
@@ -962,13 +964,13 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 
 		result = ieee80211_crypto_wep_decrypt(rx);
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		result = ieee80211_crypto_tkip_decrypt(rx);
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		result = ieee80211_crypto_ccmp_decrypt(rx);
 		break;
-	case ALG_AES_CMAC:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		result = ieee80211_crypto_aes_cmac_decrypt(rx);
 		break;
 	}
@@ -1265,7 +1267,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		/* This is the first fragment of a new frame. */
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->queue, &(rx->skb));
-		if (rx->key && rx->key->conf.alg == ALG_CCMP &&
+		if (rx->key && rx->key->conf.cipher == WLAN_CIPHER_SUITE_CCMP &&
 		    ieee80211_has_protected(fc)) {
 			int queue = ieee80211_is_mgmt(fc) ?
 				NUM_RX_DATA_QUEUES : rx->queue;
@@ -1294,7 +1296,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		int i;
 		u8 pn[CCMP_PN_LEN], *rpn;
 		int queue;
-		if (!rx->key || rx->key->conf.alg != ALG_CCMP)
+		if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_CCMP)
 			return RX_DROP_UNUSABLE;
 		memcpy(pn, entry->last_pn, CCMP_PN_LEN);
 		for (i = CCMP_PN_LEN - 1; i >= 0; i--) {
--- wireless-testing.orig/net/mac80211/tx.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-08-06 09:01:49.000000000 +0200
@@ -543,15 +543,16 @@ ieee80211_tx_h_select_key(struct ieee802
 		tx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 
-		switch (tx->key->conf.alg) {
-		case ALG_WEP:
+		switch (tx->key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
 			if (ieee80211_is_auth(hdr->frame_control))
 				break;
-		case ALG_TKIP:
+		case WLAN_CIPHER_SUITE_TKIP:
 			if (!ieee80211_is_data_present(hdr->frame_control))
 				tx->key = NULL;
 			break;
-		case ALG_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP:
 			if (!ieee80211_is_data_present(hdr->frame_control) &&
 			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
 					       tx->skb))
@@ -561,7 +562,7 @@ ieee80211_tx_h_select_key(struct ieee802
 					   IEEE80211_KEY_FLAG_SW_MGMT) &&
 					ieee80211_is_mgmt(hdr->frame_control);
 			break;
-		case ALG_AES_CMAC:
+		case WLAN_CIPHER_SUITE_AES_CMAC:
 			if (!ieee80211_is_mgmt(hdr->frame_control))
 				tx->key = NULL;
 			break;
@@ -949,14 +950,15 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 	if (!tx->key)
 		return TX_CONTINUE;
 
-	switch (tx->key->conf.alg) {
-	case ALG_WEP:
+	switch (tx->key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		return ieee80211_crypto_wep_encrypt(tx);
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		return ieee80211_crypto_tkip_encrypt(tx);
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		return ieee80211_crypto_ccmp_encrypt(tx);
-	case ALG_AES_CMAC:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		return ieee80211_crypto_aes_cmac_encrypt(tx);
 	}
 
--- wireless-testing.orig/net/mac80211/wep.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/wep.c	2010-08-05 23:30:25.000000000 +0200
@@ -240,7 +240,7 @@ static int ieee80211_wep_decrypt(struct
 
 	keyidx = skb->data[hdrlen + 3] >> 6;
 
-	if (!key || keyidx != key->conf.keyidx || key->conf.alg != ALG_WEP)
+	if (!key || keyidx != key->conf.keyidx)
 		return -1;
 
 	klen = 3 + key->conf.keylen;
--- wireless-testing.orig/net/mac80211/wpa.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2010-08-05 23:30:25.000000000 +0200
@@ -36,8 +36,8 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	int tail;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	if (!tx->key || tx->key->conf.alg != ALG_TKIP || skb->len < 24 ||
-	    !ieee80211_is_data_present(hdr->frame_control))
+	if (!tx->key || tx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP ||
+	    skb->len < 24 || !ieee80211_is_data_present(hdr->frame_control))
 		return TX_CONTINUE;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -94,7 +94,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	if (status->flag & RX_FLAG_MMIC_STRIPPED)
 		return RX_CONTINUE;
 
-	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
+	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP ||
 	    !ieee80211_has_protected(hdr->frame_control) ||
 	    !ieee80211_is_data_present(hdr->frame_control))
 		return RX_CONTINUE;
--- wireless-testing.orig/net/mac80211/debugfs_key.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_key.c	2010-08-05 23:30:25.000000000 +0200
@@ -64,26 +64,13 @@ static ssize_t key_algorithm_read(struct
 				  char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	char *alg;
+	char buf[15];
 	struct ieee80211_key *key = file->private_data;
+	u32 c = key->conf.cipher;
 
-	switch (key->conf.alg) {
-	case ALG_WEP:
-		alg = "WEP\n";
-		break;
-	case ALG_TKIP:
-		alg = "TKIP\n";
-		break;
-	case ALG_CCMP:
-		alg = "CCMP\n";
-		break;
-	case ALG_AES_CMAC:
-		alg = "AES-128-CMAC\n";
-		break;
-	default:
-		return 0;
-	}
-	return simple_read_from_buffer(userbuf, count, ppos, alg, strlen(alg));
+	sprintf(buf, "%.2x-%.2x-%.2x:%d\n",
+		c >> 24, (c >> 16) & 0xff, (c >> 8) & 0xff, c & 0xff);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
 }
 KEY_OPS(algorithm);
 
@@ -95,21 +82,22 @@ static ssize_t key_tx_spec_read(struct f
 	int len;
 	struct ieee80211_key *key = file->private_data;
 
-	switch (key->conf.alg) {
-	case ALG_WEP:
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		len = scnprintf(buf, sizeof(buf), "\n");
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		len = scnprintf(buf, sizeof(buf), "%08x %04x\n",
 				key->u.tkip.tx.iv32,
 				key->u.tkip.tx.iv16);
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		tpn = key->u.ccmp.tx_pn;
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
 				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4], tpn[5]);
 		break;
-	case ALG_AES_CMAC:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		tpn = key->u.aes_cmac.tx_pn;
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
 				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4],
@@ -130,11 +118,12 @@ static ssize_t key_rx_spec_read(struct f
 	int i, len;
 	const u8 *rpn;
 
-	switch (key->conf.alg) {
-	case ALG_WEP:
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		len = scnprintf(buf, sizeof(buf), "\n");
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "%08x %04x\n",
@@ -142,7 +131,7 @@ static ssize_t key_rx_spec_read(struct f
 				       key->u.tkip.rx[i].iv16);
 		len = p - buf;
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++) {
 			rpn = key->u.ccmp.rx_pn[i];
 			p += scnprintf(p, sizeof(buf)+buf-p,
@@ -152,7 +141,7 @@ static ssize_t key_rx_spec_read(struct f
 		}
 		len = p - buf;
 		break;
-	case ALG_AES_CMAC:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		rpn = key->u.aes_cmac.rx_pn;
 		p += scnprintf(p, sizeof(buf)+buf-p,
 			       "%02x%02x%02x%02x%02x%02x\n",
@@ -174,11 +163,11 @@ static ssize_t key_replays_read(struct f
 	char buf[20];
 	int len;
 
-	switch (key->conf.alg) {
-	case ALG_CCMP:
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
 		len = scnprintf(buf, sizeof(buf), "%u\n", key->u.ccmp.replays);
 		break;
-	case ALG_AES_CMAC:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		len = scnprintf(buf, sizeof(buf), "%u\n",
 				key->u.aes_cmac.replays);
 		break;
@@ -196,8 +185,8 @@ static ssize_t key_icverrors_read(struct
 	char buf[20];
 	int len;
 
-	switch (key->conf.alg) {
-	case ALG_AES_CMAC:
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		len = scnprintf(buf, sizeof(buf), "%u\n",
 				key->u.aes_cmac.icverrors);
 		break;
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.h	2010-08-05 23:30:25.000000000 +0200
@@ -336,7 +336,7 @@ TRACE_EVENT(drv_set_key,
 		LOCAL_ENTRY
 		VIF_ENTRY
 		STA_ENTRY
-		__field(enum ieee80211_key_alg, alg)
+		__field(u32, cipher)
 		__field(u8, hw_key_idx)
 		__field(u8, flags)
 		__field(s8, keyidx)
@@ -346,7 +346,7 @@ TRACE_EVENT(drv_set_key,
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		STA_ASSIGN;
-		__entry->alg = key->alg;
+		__entry->cipher = key->cipher;
 		__entry->flags = key->flags;
 		__entry->keyidx = key->keyidx;
 		__entry->hw_key_idx = key->hw_key_idx;
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2010-08-05 23:30:25.000000000 +0200
@@ -1190,14 +1190,13 @@ static int ar9170_tx_prepare(struct ar91
 	if (info->control.hw_key) {
 		icv = info->control.hw_key->icv_len;
 
-		switch (info->control.hw_key->alg) {
-		case ALG_WEP:
+		switch (info->control.hw_key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
 			keytype = AR9170_TX_MAC_ENCR_RC4;
 			break;
-		case ALG_TKIP:
-			keytype = AR9170_TX_MAC_ENCR_RC4;
-			break;
-		case ALG_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP:
 			keytype = AR9170_TX_MAC_ENCR_AES;
 			break;
 		default:
@@ -1778,17 +1777,17 @@ static int ar9170_set_key(struct ieee802
 	if ((!ar->vif) || (ar->disable_offload))
 		return -EOPNOTSUPP;
 
-	switch (key->alg) {
-	case ALG_WEP:
-		if (key->keylen == WLAN_KEY_LEN_WEP40)
-			ktype = AR9170_ENC_ALG_WEP64;
-		else
-			ktype = AR9170_ENC_ALG_WEP128;
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		ktype = AR9170_ENC_ALG_WEP64;
+		break;
+	case WLAN_CIPHER_SUITE_WEP104:
+		ktype = AR9170_ENC_ALG_WEP128;
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		ktype = AR9170_ENC_ALG_TKIP;
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		ktype = AR9170_ENC_ALG_AESCCMP;
 		break;
 	default:
@@ -1827,7 +1826,7 @@ static int ar9170_set_key(struct ieee802
 		if (err)
 			goto out;
 
-		if (key->alg == ALG_TKIP) {
+		if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 			err = ar9170_upload_key(ar, i, sta ? sta->addr : NULL,
 						ktype, 1, key->key + 16, 16);
 			if (err)
@@ -1864,7 +1863,7 @@ static int ar9170_set_key(struct ieee802
 			if (err)
 				goto out;
 
-			if (key->alg == ALG_TKIP) {
+			if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 				err = ar9170_upload_key(ar, key->hw_key_idx,
 							NULL,
 							AR9170_ENC_ALG_NONE, 1,
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2010-08-05 23:30:25.000000000 +0200
@@ -3276,11 +3276,12 @@ ath5k_set_key(struct ieee80211_hw *hw, e
 	if (sc->opmode == NL80211_IFTYPE_AP)
 		return -EOPNOTSUPP;
 
-	switch (key->alg) {
-	case ALG_WEP:
-	case ALG_TKIP:
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+	case WLAN_CIPHER_SUITE_TKIP:
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		if (sc->ah->ah_aes_support)
 			break;
 
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/pcu.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath5k/pcu.c	2010-08-05 23:30:25.000000000 +0200
@@ -695,21 +695,18 @@ int ath5k_hw_reset_key(struct ath5k_hw *
 static
 int ath5k_keycache_type(const struct ieee80211_key_conf *key)
 {
-	switch (key->alg) {
-	case ALG_TKIP:
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
 		return AR5K_KEYTABLE_TYPE_TKIP;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		return AR5K_KEYTABLE_TYPE_CCM;
-	case ALG_WEP:
-		if (key->keylen == WLAN_KEY_LEN_WEP40)
-			return AR5K_KEYTABLE_TYPE_40;
-		else if (key->keylen == WLAN_KEY_LEN_WEP104)
-			return AR5K_KEYTABLE_TYPE_104;
-		return -EINVAL;
+	case WLAN_CIPHER_SUITE_WEP40:
+		return AR5K_KEYTABLE_TYPE_40;
+	case WLAN_CIPHER_SUITE_WEP104:
+		return AR5K_KEYTABLE_TYPE_104;
 	default:
 		return -EINVAL;
 	}
-	return -EINVAL;
 }
 
 /*
@@ -728,7 +725,7 @@ int ath5k_hw_set_key(struct ath5k_hw *ah
 	bool is_tkip;
 	const u8 *key_ptr;
 
-	is_tkip = (key->alg == ALG_TKIP);
+	is_tkip = (key->cipher == WLAN_CIPHER_SUITE_TKIP);
 
 	/*
 	 * key->keylen comes in from mac80211 in bytes.
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2010-08-05 23:30:25.000000000 +0200
@@ -1776,9 +1776,10 @@ static int ath9k_set_key(struct ieee8021
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-			if (key->alg == ALG_TKIP)
+			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-			if (sc->sc_ah->sw_mgmt_crypto && key->alg == ALG_CCMP)
+			if (sc->sc_ah->sw_mgmt_crypto &&
+			    key->cipher == WLAN_CIPHER_SUITE_CCMP)
 				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
 			ret = 0;
 		}
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c	2010-08-06 08:56:43.000000000 +0200
@@ -1407,22 +1407,6 @@ static enum ath9k_pkt_type get_hw_packet
 	return htype;
 }
 
-static int get_hw_crypto_keytype(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-
-	if (tx_info->control.hw_key) {
-		if (tx_info->control.hw_key->alg == ALG_WEP)
-			return ATH9K_KEY_TYPE_WEP;
-		else if (tx_info->control.hw_key->alg == ALG_TKIP)
-			return ATH9K_KEY_TYPE_TKIP;
-		else if (tx_info->control.hw_key->alg == ALG_CCMP)
-			return ATH9K_KEY_TYPE_AES;
-	}
-
-	return ATH9K_KEY_TYPE_CLEAR;
-}
-
 static void assign_aggr_tid_seqno(struct sk_buff *skb,
 				  struct ath_buf *bf)
 {
@@ -1661,7 +1645,7 @@ static int ath_tx_setup_buffer(struct ie
 		bf->bf_state.bfs_paprd_timestamp = jiffies;
 	bf->bf_flags = setup_tx_flags(skb, use_ldpc);
 
-	bf->bf_keytype = get_hw_crypto_keytype(skb);
+	bf->bf_keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
 		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
 		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/common.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/common.c	2010-08-05 23:30:25.000000000 +0200
@@ -46,12 +46,17 @@ int ath9k_cmn_get_hw_crypto_keytype(stru
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 
 	if (tx_info->control.hw_key) {
-		if (tx_info->control.hw_key->alg == ALG_WEP)
+		switch (tx_info->control.hw_key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
 			return ATH9K_KEY_TYPE_WEP;
-		else if (tx_info->control.hw_key->alg == ALG_TKIP)
+		case WLAN_CIPHER_SUITE_TKIP:
 			return ATH9K_KEY_TYPE_TKIP;
-		else if (tx_info->control.hw_key->alg == ALG_CCMP)
+		case WLAN_CIPHER_SUITE_CCMP:
 			return ATH9K_KEY_TYPE_AES;
+		default:
+			break;
+		}
 	}
 
 	return ATH9K_KEY_TYPE_CLEAR;
@@ -212,11 +217,11 @@ static int ath_reserve_key_cache_slot_tk
 }
 
 static int ath_reserve_key_cache_slot(struct ath_common *common,
-				      enum ieee80211_key_alg alg)
+				      u32 cipher)
 {
 	int i;
 
-	if (alg == ALG_TKIP)
+	if (cipher == WLAN_CIPHER_SUITE_TKIP)
 		return ath_reserve_key_cache_slot_tkip(common);
 
 	/* First, try to find slots that would not be available for TKIP. */
@@ -293,14 +298,15 @@ int ath9k_cmn_key_config(struct ath_comm
 
 	memset(&hk, 0, sizeof(hk));
 
-	switch (key->alg) {
-	case ALG_WEP:
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		hk.kv_type = ATH9K_CIPHER_WEP;
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		hk.kv_type = ATH9K_CIPHER_TKIP;
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		hk.kv_type = ATH9K_CIPHER_AES_CCM;
 		break;
 	default:
@@ -316,7 +322,7 @@ int ath9k_cmn_key_config(struct ath_comm
 			memcpy(gmac, vif->addr, ETH_ALEN);
 			gmac[0] |= 0x01;
 			mac = gmac;
-			idx = ath_reserve_key_cache_slot(common, key->alg);
+			idx = ath_reserve_key_cache_slot(common, key->cipher);
 			break;
 		case NL80211_IFTYPE_ADHOC:
 			if (!sta) {
@@ -326,7 +332,7 @@ int ath9k_cmn_key_config(struct ath_comm
 			memcpy(gmac, sta->addr, ETH_ALEN);
 			gmac[0] |= 0x01;
 			mac = gmac;
-			idx = ath_reserve_key_cache_slot(common, key->alg);
+			idx = ath_reserve_key_cache_slot(common, key->cipher);
 			break;
 		default:
 			idx = key->keyidx;
@@ -348,13 +354,13 @@ int ath9k_cmn_key_config(struct ath_comm
 			return -EOPNOTSUPP;
 		mac = sta->addr;
 
-		idx = ath_reserve_key_cache_slot(common, key->alg);
+		idx = ath_reserve_key_cache_slot(common, key->cipher);
 	}
 
 	if (idx < 0)
 		return -ENOSPC; /* no free key cache entries */
 
-	if (key->alg == ALG_TKIP)
+	if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
 				      vif->type == NL80211_IFTYPE_AP);
 	else
@@ -364,7 +370,7 @@ int ath9k_cmn_key_config(struct ath_comm
 		return -EIO;
 
 	set_bit(idx, common->keymap);
-	if (key->alg == ALG_TKIP) {
+	if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		set_bit(idx + 64, common->keymap);
 		if (common->splitmic) {
 			set_bit(idx + 32, common->keymap);
@@ -389,7 +395,7 @@ void ath9k_cmn_key_delete(struct ath_com
 		return;
 
 	clear_bit(key->hw_key_idx, common->keymap);
-	if (key->alg != ALG_TKIP)
+	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
 		return;
 
 	clear_bit(key->hw_key_idx + 64, common->keymap);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2010-08-05 23:30:25.000000000 +0200
@@ -1584,9 +1584,10 @@ static int ath9k_htc_set_key(struct ieee
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-			if (key->alg == ALG_TKIP)
+			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-			if (priv->ah->sw_mgmt_crypto && key->alg == ALG_CCMP)
+			if (priv->ah->sw_mgmt_crypto &&
+			    key->cipher == WLAN_CIPHER_SUITE_CCMP)
 				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
 			ret = 0;
 		}
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2010-08-05 23:30:25.000000000 +0200
@@ -3754,17 +3754,17 @@ static int b43_op_set_key(struct ieee802
 	}
 
 	err = -EINVAL;
-	switch (key->alg) {
-	case ALG_WEP:
-		if (key->keylen == WLAN_KEY_LEN_WEP40)
-			algorithm = B43_SEC_ALGO_WEP40;
-		else
-			algorithm = B43_SEC_ALGO_WEP104;
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		algorithm = B43_SEC_ALGO_WEP40;
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_WEP104:
+		algorithm = B43_SEC_ALGO_WEP104;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
 		algorithm = B43_SEC_ALGO_TKIP;
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		algorithm = B43_SEC_ALGO_AES;
 		break;
 	default:
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-08-05 23:30:25.000000000 +0200
@@ -488,8 +488,8 @@ static void iwlagn_tx_cmd_build_hwcrypto
 {
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;
 
-	switch (keyconf->alg) {
-	case ALG_CCMP:
+	switch (keyconf->cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
@@ -497,20 +497,20 @@ static void iwlagn_tx_cmd_build_hwcrypto
 		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
 		break;
 
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
 		ieee80211_get_tkip_key(keyconf, skb_frag,
 			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
 		IWL_DEBUG_TX(priv, "tx_cmd with tkip hwcrypto\n");
 		break;
 
-	case ALG_WEP:
+	case WLAN_CIPHER_SUITE_WEP104:
+		tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
+		/* fall through */
+	case WLAN_CIPHER_SUITE_WEP40:
 		tx_cmd->sec_ctl |= (TX_CMD_SEC_WEP |
 			(keyconf->keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
 
-		if (keyconf->keylen == WEP_KEY_LEN_128)
-			tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-
 		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
 
 		IWL_DEBUG_TX(priv, "Configuring packet for WEP encryption "
@@ -518,7 +518,7 @@ static void iwlagn_tx_cmd_build_hwcrypto
 		break;
 
 	default:
-		IWL_ERR(priv, "Unknown encode alg %d\n", keyconf->alg);
+		IWL_ERR(priv, "Unknown encode cipher %x\n", keyconf->cipher);
 		break;
 	}
 }
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-dev.h	2010-08-05 23:30:25.000000000 +0200
@@ -420,7 +420,7 @@ struct iwl_tid_data {
 };
 
 struct iwl_hw_key {
-	enum ieee80211_key_alg alg;
+	u32 cipher;
 	int keylen;
 	u8 keyidx;
 	u8 key[32];
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-08-05 23:30:25.000000000 +0200
@@ -151,7 +151,7 @@ static int iwl3945_set_ccmp_dynamic_key_
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
 	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
 	       keyconf->keylen);
@@ -222,23 +222,25 @@ static int iwl3945_set_dynamic_key(struc
 
 	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
 
-	switch (keyconf->alg) {
-	case ALG_CCMP:
+	switch (keyconf->cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
 		ret = iwl3945_set_ccmp_dynamic_key_info(priv, keyconf, sta_id);
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		ret = iwl3945_set_tkip_dynamic_key_info(priv, keyconf, sta_id);
 		break;
-	case ALG_WEP:
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		ret = iwl3945_set_wep_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	default:
-		IWL_ERR(priv, "Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
+		IWL_ERR(priv, "Unknown alg: %s alg=%x\n", __func__,
+			keyconf->cipher);
 		ret = -EINVAL;
 	}
 
-	IWL_DEBUG_WEP(priv, "Set dynamic key: alg= %d len=%d idx=%d sta=%d ret=%d\n",
-		      keyconf->alg, keyconf->keylen, keyconf->keyidx,
+	IWL_DEBUG_WEP(priv, "Set dynamic key: alg=%x len=%d idx=%d sta=%d ret=%d\n",
+		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
 		      sta_id, ret);
 
 	return ret;
@@ -254,10 +256,11 @@ static int iwl3945_remove_static_key(str
 static int iwl3945_set_static_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key)
 {
-	if (key->alg == ALG_WEP)
+	if (key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	    key->cipher == WLAN_CIPHER_SUITE_WEP104)
 		return -EOPNOTSUPP;
 
-	IWL_ERR(priv, "Static key invalid: alg %d\n", key->alg);
+	IWL_ERR(priv, "Static key invalid: cipher %x\n", key->cipher);
 	return -EINVAL;
 }
 
@@ -369,23 +372,25 @@ static void iwl3945_build_tx_cmd_hwcrypt
 	struct iwl3945_tx_cmd *tx_cmd = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
 
-	switch (keyinfo->alg) {
-	case ALG_CCMP:
+	tx_cmd->sec_ctl = 0;
+
+	switch (keyinfo->cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(tx_cmd->key, keyinfo->key, keyinfo->keylen);
 		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
 		break;
 
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		break;
 
-	case ALG_WEP:
-		tx_cmd->sec_ctl = TX_CMD_SEC_WEP |
+	case WLAN_CIPHER_SUITE_WEP104:
+		tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
+		/* fall through */
+	case WLAN_CIPHER_SUITE_WEP40:
+		tx_cmd->sec_ctl |= TX_CMD_SEC_WEP |
 		    (info->control.hw_key->hw_key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
 
-		if (keyinfo->keylen == 13)
-			tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-
 		memcpy(&tx_cmd->key[3], keyinfo->key, keyinfo->keylen);
 
 		IWL_DEBUG_TX(priv, "Configuring packet for WEP encryption "
@@ -393,7 +398,7 @@ static void iwl3945_build_tx_cmd_hwcrypt
 		break;
 
 	default:
-		IWL_ERR(priv, "Unknown encode alg %d\n", keyinfo->alg);
+		IWL_ERR(priv, "Unknown encode cipher %x\n", keyinfo->cipher);
 		break;
 	}
 }
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-08-05 23:30:25.000000000 +0200
@@ -3429,7 +3429,9 @@ static int iwl_mac_set_key(struct ieee80
 	 * in 1X mode.
 	 * In legacy wep mode, we use another host command to the uCode.
 	 */
-	if (key->alg == ALG_WEP && !sta && vif->type != NL80211_IFTYPE_AP) {
+	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
+	    !sta && vif->type != NL80211_IFTYPE_AP) {
 		if (cmd == SET_KEY)
 			is_default_wep_key = !priv->key_mapping_key;
 		else
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2010-08-05 23:30:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-sta.c	2010-08-05 23:30:25.000000000 +0200
@@ -818,7 +818,7 @@ int iwl_set_default_wep_key(struct iwl_p
 
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
-	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
+	priv->stations[IWL_AP_ID].keyinfo.cipher = keyconf->cipher;
 
 	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
@@ -856,7 +856,7 @@ static int iwl_set_wep_dynamic_key_info(
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
 	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
 	priv->stations[sta_id].keyinfo.keyidx = keyconf->keyidx;
 
@@ -906,7 +906,7 @@ static int iwl_set_ccmp_dynamic_key_info
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
 	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
 
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
@@ -955,7 +955,7 @@ static int iwl_set_tkip_dynamic_key_info
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
 	priv->stations[sta_id].keyinfo.keylen = 16;
 
 	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
@@ -1090,24 +1090,26 @@ int iwl_set_dynamic_key(struct iwl_priv
 	priv->key_mapping_key++;
 	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
 
-	switch (keyconf->alg) {
-	case ALG_CCMP:
+	switch (keyconf->cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
 		ret = iwl_set_ccmp_dynamic_key_info(priv, keyconf, sta_id);
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		ret = iwl_set_tkip_dynamic_key_info(priv, keyconf, sta_id);
 		break;
-	case ALG_WEP:
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		ret = iwl_set_wep_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	default:
 		IWL_ERR(priv,
-			"Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
+			"Unknown alg: %s cipher = %x\n", __func__,
+			keyconf->cipher);
 		ret = -EINVAL;
 	}
 
-	IWL_DEBUG_WEP(priv, "Set dynamic key: alg= %d len=%d idx=%d sta=%d ret=%d\n",
-		      keyconf->alg, keyconf->keylen, keyconf->keyidx,
+	IWL_DEBUG_WEP(priv, "Set dynamic key: cipher=%x len=%d idx=%d sta=%d ret=%d\n",
+		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
 		      sta_id, ret);
 
 	return ret;
--- wireless-testing.orig/drivers/net/wireless/p54/main.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/p54/main.c	2010-08-05 23:30:25.000000000 +0200
@@ -429,8 +429,8 @@ static int p54_set_key(struct ieee80211_
 
 	mutex_lock(&priv->conf_mutex);
 	if (cmd == SET_KEY) {
-		switch (key->alg) {
-		case ALG_TKIP:
+		switch (key->cipher) {
+		case WLAN_CIPHER_SUITE_TKIP:
 			if (!(priv->privacy_caps & (BR_DESC_PRIV_CAP_MICHAEL |
 			      BR_DESC_PRIV_CAP_TKIP))) {
 				ret = -EOPNOTSUPP;
@@ -439,7 +439,8 @@ static int p54_set_key(struct ieee80211_
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			algo = P54_CRYPTO_TKIPMICHAEL;
 			break;
-		case ALG_WEP:
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
 			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_WEP)) {
 				ret = -EOPNOTSUPP;
 				goto out_unlock;
@@ -447,7 +448,7 @@ static int p54_set_key(struct ieee80211_
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			algo = P54_CRYPTO_WEP;
 			break;
-		case ALG_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP:
 			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_AESCCMP)) {
 				ret = -EOPNOTSUPP;
 				goto out_unlock;
--- wireless-testing.orig/drivers/net/wireless/p54/txrx.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/p54/txrx.c	2010-08-05 23:30:25.000000000 +0200
@@ -683,14 +683,15 @@ static void p54_tx_80211_header(struct p
 	}
 }
 
-static u8 p54_convert_algo(enum ieee80211_key_alg alg)
+static u8 p54_convert_algo(u32 cipher)
 {
-	switch (alg) {
-	case ALG_WEP:
+	switch (cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		return P54_CRYPTO_WEP;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		return P54_CRYPTO_TKIPMICHAEL;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		return P54_CRYPTO_AESCCMP;
 	default:
 		return 0;
@@ -731,7 +732,7 @@ int p54_tx_80211(struct ieee80211_hw *de
 
 	if (info->control.hw_key) {
 		crypt_offset = ieee80211_get_hdrlen_from_skb(skb);
-		if (info->control.hw_key->alg == ALG_TKIP) {
+		if (info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 			u8 *iv = (u8 *)(skb->data + crypt_offset);
 			/*
 			 * The firmware excepts that the IV has to have
@@ -827,10 +828,10 @@ int p54_tx_80211(struct ieee80211_hw *de
 	hdr->tries = ridx;
 	txhdr->rts_rate_idx = 0;
 	if (info->control.hw_key) {
-		txhdr->key_type = p54_convert_algo(info->control.hw_key->alg);
+		txhdr->key_type = p54_convert_algo(info->control.hw_key->cipher);
 		txhdr->key_len = min((u8)16, info->control.hw_key->keylen);
 		memcpy(txhdr->key, info->control.hw_key->key, txhdr->key_len);
-		if (info->control.hw_key->alg == ALG_TKIP) {
+		if (info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 			/* reserve space for the MIC key */
 			len += 8;
 			memcpy(skb_put(skb, 8), &(info->control.hw_key->key
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2500usb.c	2010-08-05 23:30:25.000000000 +0200
@@ -355,7 +355,9 @@ static int rt2500usb_config_key(struct r
 		 * it is known that not work at least on some hardware.
 		 * SW crypto will be used in that case.
 		 */
-		if (key->alg == ALG_WEP && key->keyidx != 0)
+		if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+		     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
+		    key->keyidx != 0)
 			return -EOPNOTSUPP;
 
 		/*
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00crypto.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00crypto.c	2010-08-05 23:30:25.000000000 +0200
@@ -31,15 +31,14 @@
 
 enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *key)
 {
-	switch (key->alg) {
-	case ALG_WEP:
-		if (key->keylen == WLAN_KEY_LEN_WEP40)
-			return CIPHER_WEP64;
-		else
-			return CIPHER_WEP128;
-	case ALG_TKIP:
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		return CIPHER_WEP64;
+	case WLAN_CIPHER_SUITE_WEP104:
+		return CIPHER_WEP128;
+	case WLAN_CIPHER_SUITE_TKIP:
 		return CIPHER_TKIP;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		return CIPHER_AES;
 	default:
 		return CIPHER_NONE;
@@ -95,7 +94,7 @@ unsigned int rt2x00crypto_tx_overhead(st
 		overhead += key->iv_len;
 
 	if (!(key->flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
-		if (key->alg == ALG_TKIP)
+		if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 			overhead += 8;
 	}
 
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_main.c	2010-08-05 23:30:25.000000000 +0200
@@ -725,8 +725,9 @@ static int wl1251_set_key_type(struct wl
 			       struct ieee80211_key_conf *mac80211_key,
 			       const u8 *addr)
 {
-	switch (mac80211_key->alg) {
-	case ALG_WEP:
+	switch (mac80211_key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		if (is_broadcast_ether_addr(addr))
 			key->key_type = KEY_WEP_DEFAULT;
 		else
@@ -734,7 +735,7 @@ static int wl1251_set_key_type(struct wl
 
 		mac80211_key->hw_key_idx = mac80211_key->keyidx;
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		if (is_broadcast_ether_addr(addr))
 			key->key_type = KEY_TKIP_MIC_GROUP;
 		else
@@ -742,7 +743,7 @@ static int wl1251_set_key_type(struct wl
 
 		mac80211_key->hw_key_idx = mac80211_key->keyidx;
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		if (is_broadcast_ether_addr(addr))
 			key->key_type = KEY_AES_GROUP;
 		else
@@ -750,7 +751,7 @@ static int wl1251_set_key_type(struct wl
 		mac80211_key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
 	default:
-		wl1251_error("Unknown key algo 0x%x", mac80211_key->alg);
+		wl1251_error("Unknown key cipher 0x%x", mac80211_key->cipher);
 		return -EOPNOTSUPP;
 	}
 
@@ -783,7 +784,7 @@ static int wl1251_op_set_key(struct ieee
 	wl1251_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
 	wl1251_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
 	wl1251_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
-		     key->alg, key->keyidx, key->keylen, key->flags);
+		     key->cipher, key->keyidx, key->keylen, key->flags);
 	wl1251_dump(DEBUG_CRYPT, "KEY: ", key->key, key->keylen);
 
 	if (is_zero_ether_addr(addr)) {
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_tx.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_tx.c	2010-08-05 23:30:25.000000000 +0200
@@ -189,7 +189,7 @@ static int wl1251_tx_send_packet(struct
 	tx_hdr = (struct tx_double_buffer_desc *) skb->data;
 
 	if (control->control.hw_key &&
-	    control->control.hw_key->alg == ALG_TKIP) {
+	    control->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		int hdrlen;
 		__le16 fc;
 		u16 length;
@@ -399,7 +399,7 @@ static void wl1251_tx_packet_cb(struct w
 	 */
 	frame = skb_pull(skb, sizeof(struct tx_double_buffer_desc));
 	if (info->control.hw_key &&
-	    info->control.hw_key->alg == ALG_TKIP) {
+	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 		memmove(frame + WL1251_TKIP_IV_SPACE, frame, hdrlen);
 		skb_pull(skb, WL1251_TKIP_IV_SPACE);
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_main.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_main.c	2010-08-05 23:30:25.000000000 +0200
@@ -1439,7 +1439,7 @@ static int wl1271_op_set_key(struct ieee
 	wl1271_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
 	wl1271_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
 	wl1271_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
-		     key_conf->alg, key_conf->keyidx,
+		     key_conf->cipher, key_conf->keyidx,
 		     key_conf->keylen, key_conf->flags);
 	wl1271_dump(DEBUG_CRYPT, "KEY: ", key_conf->key, key_conf->keylen);
 
@@ -1455,20 +1455,21 @@ static int wl1271_op_set_key(struct ieee
 	if (ret < 0)
 		goto out_unlock;
 
-	switch (key_conf->alg) {
-	case ALG_WEP:
+	switch (key_conf->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
 		key_type = KEY_WEP;
 
 		key_conf->hw_key_idx = key_conf->keyidx;
 		break;
-	case ALG_TKIP:
+	case WLAN_CIPHER_SUITE_TKIP:
 		key_type = KEY_TKIP;
 
 		key_conf->hw_key_idx = key_conf->keyidx;
 		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
 		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
 		break;
-	case ALG_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = KEY_AES;
 
 		key_conf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -1476,7 +1477,7 @@ static int wl1271_op_set_key(struct ieee
 		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
 		break;
 	default:
-		wl1271_error("Unknown key algo 0x%x", key_conf->alg);
+		wl1271_error("Unknown key algo 0x%x", key_conf->cipher);
 
 		ret = -EOPNOTSUPP;
 		goto out_sleep;
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_tx.c	2010-08-05 23:30:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_tx.c	2010-08-05 23:30:25.000000000 +0200
@@ -193,7 +193,7 @@ static int wl1271_tx_frame(struct wl1271
 	info = IEEE80211_SKB_CB(skb);
 
 	if (info->control.hw_key &&
-	    info->control.hw_key->alg == ALG_TKIP)
+	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP)
 		extra = WL1271_TKIP_IV_SPACE;
 
 	if (info->control.hw_key) {
@@ -347,7 +347,7 @@ static void wl1271_tx_complete_packet(st
 
 	/* remove TKIP header space if present */
 	if (info->control.hw_key &&
-	    info->control.hw_key->alg == ALG_TKIP) {
+	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 		memmove(skb->data + WL1271_TKIP_IV_SPACE, skb->data, hdrlen);
 		skb_pull(skb, WL1271_TKIP_IV_SPACE);



