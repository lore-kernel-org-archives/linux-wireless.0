Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbXIZNYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:33 -0400
Message-Id: <20070926132132.308101000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 03/12] mac80211: consolidate encryption
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we run through all crypto handlers for each transmitted
frame although we already know which one will be used. This
changes the code to invoke only the needed handler. It also moves
the wep code into wep.c.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/tx.c  |   62 ++++++++++++-----------------------------------------
 net/mac80211/wep.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/wep.h |    5 +---
 net/mac80211/wpa.c |   10 +++-----
 net/mac80211/wpa.h |    4 +--
 5 files changed, 77 insertions(+), 61 deletions(-)

--- wireless-dev.orig/net/mac80211/tx.c	2007-09-25 23:28:22.131610568 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-09-25 23:29:35.111582139 +0200
@@ -541,56 +541,26 @@ ieee80211_tx_h_fragment(struct ieee80211
 	return TXRX_DROP;
 }
 
-static int wep_encrypt_skb(struct ieee80211_txrx_data *tx, struct sk_buff *skb)
-{
-	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
-			return -1;
-	} else {
-		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
-		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
-			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
-				return -1;
-		}
-	}
-	return 0;
-}
-
 static ieee80211_txrx_result
-ieee80211_tx_h_wep_encrypt(struct ieee80211_txrx_data *tx)
+ieee80211_tx_h_encrypt(struct ieee80211_txrx_data *tx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	u16 fc;
-
-	fc = le16_to_cpu(hdr->frame_control);
-
-	if (!tx->key || tx->key->conf.alg != ALG_WEP ||
-	    ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
-	     ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	      (fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)))
+	if (!tx->key)
 		return TXRX_CONTINUE;
 
-	tx->u.tx.control->iv_len = WEP_IV_LEN;
-	tx->u.tx.control->icv_len = WEP_ICV_LEN;
-	ieee80211_tx_set_iswep(tx);
-
-	if (wep_encrypt_skb(tx, tx->skb) < 0) {
-		I802_DEBUG_INC(tx->local->tx_handlers_drop_wep);
-		return TXRX_DROP;
-	}
-
-	if (tx->u.tx.extra_frag) {
-		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-			if (wep_encrypt_skb(tx, tx->u.tx.extra_frag[i]) < 0) {
-				I802_DEBUG_INC(tx->local->
-					       tx_handlers_drop_wep);
-				return TXRX_DROP;
-			}
-		}
+	switch (tx->key->conf.alg) {
+	case ALG_WEP:
+		return ieee80211_crypto_wep_encrypt(tx);
+	case ALG_TKIP:
+		return ieee80211_crypto_tkip_encrypt(tx);
+	case ALG_CCMP:
+		return ieee80211_crypto_ccmp_encrypt(tx);
+	case ALG_NONE:
+		return TXRX_CONTINUE;
 	}
 
-	return TXRX_CONTINUE;
+	/* not reached */
+	WARN_ON(1);
+	return TXRX_DROP;
 }
 
 static ieee80211_txrx_result
@@ -805,9 +775,7 @@ ieee80211_tx_handler ieee80211_tx_handle
 	ieee80211_tx_h_select_key,
 	ieee80211_tx_h_michael_mic_add,
 	ieee80211_tx_h_fragment,
-	ieee80211_tx_h_tkip_encrypt,
-	ieee80211_tx_h_ccmp_encrypt,
-	ieee80211_tx_h_wep_encrypt,
+	ieee80211_tx_h_encrypt,
 	ieee80211_tx_h_rate_ctrl,
 	ieee80211_tx_h_misc,
 	ieee80211_tx_h_load_stats,
--- wireless-dev.orig/net/mac80211/wpa.c	2007-09-25 23:29:34.131604926 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-09-25 23:29:35.111582139 +0200
@@ -239,17 +239,16 @@ static int tkip_encrypt_skb(struct ieee8
 
 
 ieee80211_txrx_result
-ieee80211_tx_h_tkip_encrypt(struct ieee80211_txrx_data *tx)
+ieee80211_crypto_tkip_encrypt(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 	u16 fc;
-	struct ieee80211_key *key = tx->key;
 	struct sk_buff *skb = tx->skb;
 	int wpa_test = 0, test = 0;
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-	if (!key || key->conf.alg != ALG_TKIP || !WLAN_FC_DATA_PRESENT(fc))
+	if (!WLAN_FC_DATA_PRESENT(fc))
 		return TXRX_CONTINUE;
 
 	tx->u.tx.control->icv_len = TKIP_ICV_LEN;
@@ -491,17 +490,16 @@ static int ccmp_encrypt_skb(struct ieee8
 
 
 ieee80211_txrx_result
-ieee80211_tx_h_ccmp_encrypt(struct ieee80211_txrx_data *tx)
+ieee80211_crypto_ccmp_encrypt(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	struct ieee80211_key *key = tx->key;
 	u16 fc;
 	struct sk_buff *skb = tx->skb;
 	int test = 0;
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-	if (!key || key->conf.alg != ALG_CCMP || !WLAN_FC_DATA_PRESENT(fc))
+	if (!WLAN_FC_DATA_PRESENT(fc))
 		return TXRX_CONTINUE;
 
 	tx->u.tx.control->icv_len = CCMP_MIC_LEN;
--- wireless-dev.orig/net/mac80211/wpa.h	2007-09-25 23:29:34.131604926 +0200
+++ wireless-dev/net/mac80211/wpa.h	2007-09-25 23:29:35.131571125 +0200
@@ -19,12 +19,12 @@ ieee80211_txrx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_txrx_data *rx);
 
 ieee80211_txrx_result
-ieee80211_tx_h_tkip_encrypt(struct ieee80211_txrx_data *tx);
+ieee80211_crypto_tkip_encrypt(struct ieee80211_txrx_data *tx);
 ieee80211_txrx_result
 ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx);
 
 ieee80211_txrx_result
-ieee80211_tx_h_ccmp_encrypt(struct ieee80211_txrx_data *tx);
+ieee80211_crypto_ccmp_encrypt(struct ieee80211_txrx_data *tx);
 ieee80211_txrx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx);
 
--- wireless-dev.orig/net/mac80211/wep.c	2007-09-25 23:29:34.131604926 +0200
+++ wireless-dev/net/mac80211/wep.c	2007-09-25 23:29:35.131571125 +0200
@@ -80,9 +80,9 @@ static void ieee80211_wep_get_iv(struct 
 }
 
 
-u8 * ieee80211_wep_add_iv(struct ieee80211_local *local,
-			  struct sk_buff *skb,
-			  struct ieee80211_key *key)
+static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
+				struct sk_buff *skb,
+				struct ieee80211_key *key)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 fc;
@@ -350,3 +350,54 @@ ieee80211_crypto_wep_decrypt(struct ieee
 
 	return TXRX_CONTINUE;
 }
+
+static int wep_encrypt_skb(struct ieee80211_txrx_data *tx, struct sk_buff *skb)
+{
+	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
+		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
+			return -1;
+	} else {
+		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
+		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
+			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
+				return -1;
+		}
+	}
+	return 0;
+}
+
+ieee80211_txrx_result
+ieee80211_crypto_wep_encrypt(struct ieee80211_txrx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
+	u16 fc;
+
+	fc = le16_to_cpu(hdr->frame_control);
+
+	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
+	     ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
+	      (fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)))
+		return TXRX_CONTINUE;
+
+	tx->u.tx.control->iv_len = WEP_IV_LEN;
+	tx->u.tx.control->icv_len = WEP_ICV_LEN;
+	ieee80211_tx_set_iswep(tx);
+
+	if (wep_encrypt_skb(tx, tx->skb) < 0) {
+		I802_DEBUG_INC(tx->local->tx_handlers_drop_wep);
+		return TXRX_DROP;
+	}
+
+	if (tx->u.tx.extra_frag) {
+		int i;
+		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
+			if (wep_encrypt_skb(tx, tx->u.tx.extra_frag[i]) < 0) {
+				I802_DEBUG_INC(tx->local->
+					       tx_handlers_drop_wep);
+				return TXRX_DROP;
+			}
+		}
+	}
+
+	return TXRX_CONTINUE;
+}
--- wireless-dev.orig/net/mac80211/wep.h	2007-09-25 23:29:34.141573296 +0200
+++ wireless-dev/net/mac80211/wep.h	2007-09-25 23:29:35.131571125 +0200
@@ -18,9 +18,6 @@
 
 int ieee80211_wep_init(struct ieee80211_local *local);
 void ieee80211_wep_free(struct ieee80211_local *local);
-u8 * ieee80211_wep_add_iv(struct ieee80211_local *local,
-			  struct sk_buff *skb,
-			  struct ieee80211_key *key);
 void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
@@ -34,5 +31,7 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_
 
 ieee80211_txrx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx);
+ieee80211_txrx_result
+ieee80211_crypto_wep_encrypt(struct ieee80211_txrx_data *tx);
 
 #endif /* WEP_H */

-- 

