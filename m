Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbXLRO2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 09:28:08 -0500
Subject: [PATCH] mac80211: move tx crypto decision
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 15:27:47 +0100
Message-Id: <1197988067.4885.162.camel@johannes.berg> (sfid-20071218_142816_842497_85E08ABA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the decision making about whether a frame is encrypted
with a certain algorithm up into the TX handlers rather than having it
in the crypto algorithm implementation.

This fixes a problem with the radiotap injection code where injecting
a non-data packet and requesting encryption could end up asking the
driver to encrypt a packet without giving it a key.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Also, that will make implementing 802.11w more straight-forward.

 net/mac80211/tx.c  |   39 ++++++++++++++++++++++-----------------
 net/mac80211/wep.c |   10 ----------
 net/mac80211/wpa.c |   14 --------------
 3 files changed, 22 insertions(+), 41 deletions(-)

--- everything.orig/net/mac80211/tx.c	2007-12-18 14:36:17.243016004 +0100
+++ everything/net/mac80211/tx.c	2007-12-18 14:48:45.853013509 +0100
@@ -436,11 +436,7 @@ static ieee80211_txrx_result
 ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_key *key;
-	const struct ieee80211_hdr *hdr;
-	u16 fc;
-
-	hdr = (const struct ieee80211_hdr *) tx->skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
+	u16 fc = tx->fc;
 
 	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
@@ -453,16 +449,34 @@ ieee80211_tx_h_select_key(struct ieee802
 		   ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc)))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TXRX_DROP;
-	} else {
+	} else
 		tx->key = NULL;
-		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
-	}
 
 	if (tx->key) {
+		u16 ftype, stype;
+
 		tx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
+
+		switch (tx->key->conf.alg) {
+		case ALG_WEP:
+			ftype = fc & IEEE80211_FCTL_FTYPE;
+			stype = fc & IEEE80211_FCTL_STYPE;
+
+			if (ftype == IEEE80211_FTYPE_MGMT &&
+			    stype == IEEE80211_STYPE_AUTH)
+				break;
+		case ALG_TKIP:
+		case ALG_CCMP:
+			if (!WLAN_FC_DATA_PRESENT(fc))
+				tx->key = NULL;
+			break;
+		}
 	}
 
+	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+
 	return TXRX_CONTINUE;
 }
 
@@ -708,15 +722,6 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		}
 	}
 
-	/*
-	 * Tell hardware to not encrypt when we had sw crypto.
-	 * Because we use the same flag to internally indicate that
-	 * no (software) encryption should be done, we have to set it
-	 * after all crypto handlers.
-	 */
-	if (tx->key && !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
-
 	return TXRX_CONTINUE;
 }
 
--- everything.orig/net/mac80211/wep.c	2007-12-18 14:36:17.263016276 +0100
+++ everything/net/mac80211/wep.c	2007-12-18 14:48:45.863017306 +0100
@@ -349,16 +349,6 @@ static int wep_encrypt_skb(struct ieee80
 ieee80211_txrx_result
 ieee80211_crypto_wep_encrypt(struct ieee80211_txrx_data *tx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	u16 fc;
-
-	fc = le16_to_cpu(hdr->frame_control);
-
-	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
-	     ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	      (fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)))
-		return TXRX_CONTINUE;
-
 	tx->u.tx.control->iv_len = WEP_IV_LEN;
 	tx->u.tx.control->icv_len = WEP_ICV_LEN;
 	ieee80211_tx_set_iswep(tx);
--- everything.orig/net/mac80211/wpa.c	2007-12-18 14:36:17.303016601 +0100
+++ everything/net/mac80211/wpa.c	2007-12-18 14:48:45.863017306 +0100
@@ -245,16 +245,9 @@ static int tkip_encrypt_skb(struct ieee8
 ieee80211_txrx_result
 ieee80211_crypto_tkip_encrypt(struct ieee80211_txrx_data *tx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	u16 fc;
 	struct sk_buff *skb = tx->skb;
 	int wpa_test = 0, test = 0;
 
-	fc = le16_to_cpu(hdr->frame_control);
-
-	if (!WLAN_FC_DATA_PRESENT(fc))
-		return TXRX_CONTINUE;
-
 	tx->u.tx.control->icv_len = TKIP_ICV_LEN;
 	tx->u.tx.control->iv_len = TKIP_IV_LEN;
 	ieee80211_tx_set_iswep(tx);
@@ -501,16 +494,9 @@ static int ccmp_encrypt_skb(struct ieee8
 ieee80211_txrx_result
 ieee80211_crypto_ccmp_encrypt(struct ieee80211_txrx_data *tx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
-	u16 fc;
 	struct sk_buff *skb = tx->skb;
 	int test = 0;
 
-	fc = le16_to_cpu(hdr->frame_control);
-
-	if (!WLAN_FC_DATA_PRESENT(fc))
-		return TXRX_CONTINUE;
-
 	tx->u.tx.control->icv_len = CCMP_MIC_LEN;
 	tx->u.tx.control->iv_len = CCMP_HDR_LEN;
 	ieee80211_tx_set_iswep(tx);


