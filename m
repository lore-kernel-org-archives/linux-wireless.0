Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbXIFNqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:00 -0400
Message-Id: <20070905234629.224313000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 16/21] mac80211: consolidate decryption
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, we run through all three crypto algorithms for each
received frame even though we have previously determined which
key we have and as such already know which algorithm will be
used. Change it to invoke only the needed function. Also move
the WEP decrypt handler to wep.c so that fewer functions need
to be non-static.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c  |   40 +++++++++++++++++-----------------------
 net/mac80211/wep.c |   34 +++++++++++++++++++++++++++++-----
 net/mac80211/wep.h |    8 +++-----
 net/mac80211/wpa.c |   12 ++++--------
 net/mac80211/wpa.h |    4 ++--
 5 files changed, 55 insertions(+), 43 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-09-06 01:35:21.734453431 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-06 01:35:24.464453431 +0200
@@ -569,36 +569,32 @@ ieee80211_rx_h_wep_weak_iv_detection(str
 }
 
 static ieee80211_txrx_result
-ieee80211_rx_h_wep_decrypt(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
 {
-	if ((rx->key && rx->key->conf.alg != ALG_WEP) ||
-	    !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
-	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
-	     ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	      (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)))
+	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
 		return TXRX_CONTINUE;
 
 	if (!rx->key) {
 		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: RX WEP frame, but no key set\n",
-			       rx->dev->name);
+			printk(KERN_DEBUG "%s: RX protected frame,"
+			       " but have no key\n", rx->dev->name);
 		return TXRX_DROP;
 	}
 
-	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
-		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
-				       "failed\n", rx->dev->name);
-			return TXRX_DROP;
-		}
-	} else if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED)) {
-		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
-		/* remove ICV */
-		skb_trim(rx->skb, rx->skb->len - 4);
+	switch (rx->key->conf.alg) {
+	case ALG_WEP:
+		return ieee80211_crypto_wep_decrypt(rx);
+	case ALG_TKIP:
+		return ieee80211_crypto_tkip_decrypt(rx);
+	case ALG_CCMP:
+		return ieee80211_crypto_ccmp_decrypt(rx);
+	case ALG_NONE:
+		return TXRX_CONTINUE;
 	}
 
-	return TXRX_CONTINUE;
+	/* not reached */
+	WARN_ON(1);
+	return TXRX_DROP;
 }
 
 static inline struct ieee80211_fragment_entry *
@@ -1413,10 +1409,8 @@ ieee80211_rx_handler ieee80211_rx_handle
 	ieee80211_rx_h_check,
 	ieee80211_rx_h_load_key,
 	ieee80211_rx_h_sta_process,
-	ieee80211_rx_h_ccmp_decrypt,
-	ieee80211_rx_h_tkip_decrypt,
 	ieee80211_rx_h_wep_weak_iv_detection,
-	ieee80211_rx_h_wep_decrypt,
+	ieee80211_rx_h_decrypt,
 	ieee80211_rx_h_defragment,
 	ieee80211_rx_h_ps_poll,
 	ieee80211_rx_h_michael_mic_verify,
--- wireless-dev.orig/net/mac80211/wpa.c	2007-09-06 01:34:54.424453431 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-09-06 01:35:24.464453431 +0200
@@ -417,7 +417,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 
 
 ieee80211_txrx_result
-ieee80211_rx_h_tkip_decrypt(struct ieee80211_txrx_data *rx)
+ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	u16 fc;
@@ -428,9 +428,7 @@ ieee80211_rx_h_tkip_decrypt(struct ieee8
 	fc = le16_to_cpu(hdr->frame_control);
 	hdrlen = ieee80211_get_hdrlen(fc);
 
-	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
-	    !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
-	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		return TXRX_CONTINUE;
 
 	if (!rx->sta || skb->len - hdrlen < 12)
@@ -720,7 +718,7 @@ ieee80211_tx_h_ccmp_encrypt(struct ieee8
 
 
 ieee80211_txrx_result
-ieee80211_rx_h_ccmp_decrypt(struct ieee80211_txrx_data *rx)
+ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	u16 fc;
@@ -733,9 +731,7 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 	fc = le16_to_cpu(hdr->frame_control);
 	hdrlen = ieee80211_get_hdrlen(fc);
 
-	if (!key || key->conf.alg != ALG_CCMP ||
-	    !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
-	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		return TXRX_CONTINUE;
 
 	data_len = skb->len - hdrlen - CCMP_HDR_LEN - CCMP_MIC_LEN;
--- wireless-dev.orig/net/mac80211/wpa.h	2007-09-06 01:34:54.454453431 +0200
+++ wireless-dev/net/mac80211/wpa.h	2007-09-06 01:35:24.464453431 +0200
@@ -21,11 +21,11 @@ ieee80211_rx_h_michael_mic_verify(struct
 ieee80211_txrx_result
 ieee80211_tx_h_tkip_encrypt(struct ieee80211_txrx_data *tx);
 ieee80211_txrx_result
-ieee80211_rx_h_tkip_decrypt(struct ieee80211_txrx_data *rx);
+ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx);
 
 ieee80211_txrx_result
 ieee80211_tx_h_ccmp_encrypt(struct ieee80211_txrx_data *tx);
 ieee80211_txrx_result
-ieee80211_rx_h_ccmp_decrypt(struct ieee80211_txrx_data *rx);
+ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx);
 
 #endif /* WPA_H */
--- wireless-dev.orig/net/mac80211/wep.c	2007-09-06 01:34:54.504453431 +0200
+++ wireless-dev/net/mac80211/wep.c	2007-09-06 01:35:24.474453431 +0200
@@ -63,8 +63,8 @@ static inline int ieee80211_wep_weak_iv(
 }
 
 
-void ieee80211_wep_get_iv(struct ieee80211_local *local,
-			  struct ieee80211_key *key, u8 *iv)
+static void ieee80211_wep_get_iv(struct ieee80211_local *local,
+				 struct ieee80211_key *key, u8 *iv)
 {
 	local->wep_iv++;
 	if (ieee80211_wep_weak_iv(local->wep_iv, key->conf.keylen))
@@ -109,9 +109,9 @@ u8 * ieee80211_wep_add_iv(struct ieee802
 }
 
 
-void ieee80211_wep_remove_iv(struct ieee80211_local *local,
-			     struct sk_buff *skb,
-			     struct ieee80211_key *key)
+static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
+				    struct sk_buff *skb,
+				    struct ieee80211_key *key)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 fc;
@@ -326,3 +326,27 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_
 
 	return NULL;
 }
+
+ieee80211_txrx_result
+ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx)
+{
+	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
+	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
+	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
+		return TXRX_CONTINUE;
+
+	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
+		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
+				       "failed\n", rx->dev->name);
+			return TXRX_DROP;
+		}
+	} else if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED)) {
+		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
+		/* remove ICV */
+		skb_trim(rx->skb, rx->skb->len - 4);
+	}
+
+	return TXRX_CONTINUE;
+}
--- wireless-dev.orig/net/mac80211/wep.h	2007-09-06 01:34:54.614453431 +0200
+++ wireless-dev/net/mac80211/wep.h	2007-09-06 01:35:24.474453431 +0200
@@ -18,14 +18,9 @@
 
 int ieee80211_wep_init(struct ieee80211_local *local);
 void ieee80211_wep_free(struct ieee80211_local *local);
-void ieee80211_wep_get_iv(struct ieee80211_local *local,
-			  struct ieee80211_key *key, u8 *iv);
 u8 * ieee80211_wep_add_iv(struct ieee80211_local *local,
 			  struct sk_buff *skb,
 			  struct ieee80211_key *key);
-void ieee80211_wep_remove_iv(struct ieee80211_local *local,
-			     struct sk_buff *skb,
-			     struct ieee80211_key *key);
 void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
@@ -37,4 +32,7 @@ int ieee80211_wep_decrypt(struct ieee802
 int ieee80211_wep_get_keyidx(struct sk_buff *skb);
 u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
+ieee80211_txrx_result
+ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx);
+
 #endif /* WEP_H */

-- 

