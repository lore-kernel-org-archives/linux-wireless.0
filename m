Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbYBAMJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:23 -0500
Message-Id: <20080131185050.988859000@sipsolutions.net> (sfid-20080201_120930_959461_FCC2D47E)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] mac80211: split ieee80211_txrx_result
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The _DROP result will need to be split in the RX path but not
in the TX path, so for preparation split up the type into two
types, one for RX and one for TX. Also make sure (via sparse)
that they cannot be confused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Not entirely sure about the __bitwise__ stuff, should we do that?

 net/mac80211/ieee80211_i.h   |   23 ++++--
 net/mac80211/ieee80211_sta.c |   14 ++--
 net/mac80211/rx.c            |  150 +++++++++++++++++++++----------------------
 net/mac80211/tx.c            |  110 +++++++++++++++----------------
 net/mac80211/wep.c           |   16 ++--
 net/mac80211/wep.h           |    4 -
 net/mac80211/wpa.c           |   72 ++++++++++----------
 net/mac80211/wpa.h           |   12 +--
 8 files changed, 204 insertions(+), 197 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-31 15:46:06.355845920 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-31 15:46:09.015793999 +0100
@@ -108,9 +108,16 @@ struct ieee80211_sta_bss {
 };
 
 
-typedef enum {
-	TXRX_CONTINUE, TXRX_DROP, TXRX_QUEUED
-} ieee80211_txrx_result;
+typedef unsigned __bitwise__ ieee80211_tx_result;
+#define TX_CONTINUE	((__force ieee80211_tx_result) 0u)
+#define TX_DROP		((__force ieee80211_tx_result) 1u)
+#define TX_QUEUED	((__force ieee80211_tx_result) 2u)
+
+typedef unsigned __bitwise__ ieee80211_rx_result;
+#define RX_CONTINUE	((__force ieee80211_rx_result) 0u)
+#define RX_DROP		((__force ieee80211_rx_result) 1u)
+#define RX_QUEUED	((__force ieee80211_rx_result) 2u)
+
 
 /* flags used in struct ieee80211_txrx_data.flags */
 /* whether the MSDU was fragmented */
@@ -182,10 +189,10 @@ struct ieee80211_tx_stored_packet {
 	unsigned int last_frag_rate_ctrl_probe;
 };
 
-typedef ieee80211_txrx_result (*ieee80211_tx_handler)
+typedef ieee80211_tx_result (*ieee80211_tx_handler)
 (struct ieee80211_txrx_data *tx);
 
-typedef ieee80211_txrx_result (*ieee80211_rx_handler)
+typedef ieee80211_rx_result (*ieee80211_rx_handler)
 (struct ieee80211_txrx_data *rx);
 
 struct beacon_data {
@@ -729,9 +736,9 @@ int ieee80211_sta_req_scan(struct net_de
 void ieee80211_sta_req_auth(struct net_device *dev,
 			    struct ieee80211_if_sta *ifsta);
 int ieee80211_sta_scan_results(struct net_device *dev, char *buf, size_t len);
-ieee80211_txrx_result ieee80211_sta_rx_scan(struct net_device *dev,
-					    struct sk_buff *skb,
-			   struct ieee80211_rx_status *rx_status);
+ieee80211_rx_result ieee80211_sta_rx_scan(
+	struct net_device *dev, struct sk_buff *skb,
+	struct ieee80211_rx_status *rx_status);
 void ieee80211_rx_bss_list_init(struct net_device *dev);
 void ieee80211_rx_bss_list_deinit(struct net_device *dev);
 int ieee80211_sta_set_extra_ie(struct net_device *dev, char *ie, size_t len);
--- everything.orig/net/mac80211/wep.h	2008-01-31 15:45:57.875793999 +0100
+++ everything/net/mac80211/wep.h	2008-01-31 15:46:09.015793999 +0100
@@ -28,9 +28,9 @@ int ieee80211_wep_decrypt(struct ieee802
 			  struct ieee80211_key *key);
 u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx);
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_crypto_wep_encrypt(struct ieee80211_txrx_data *tx);
 
 #endif /* WEP_H */
--- everything.orig/net/mac80211/wpa.h	2008-01-31 15:45:57.935793890 +0100
+++ everything/net/mac80211/wpa.h	2008-01-31 15:46:09.015793999 +0100
@@ -13,19 +13,19 @@
 #include <linux/types.h>
 #include "ieee80211_i.h"
 
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_tx_h_michael_mic_add(struct ieee80211_txrx_data *tx);
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_txrx_data *rx);
 
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_crypto_tkip_encrypt(struct ieee80211_txrx_data *tx);
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx);
 
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_crypto_ccmp_encrypt(struct ieee80211_txrx_data *tx);
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx);
 
 #endif /* WPA_H */
--- everything.orig/net/mac80211/wep.c	2008-01-31 15:45:57.965793728 +0100
+++ everything/net/mac80211/wep.c	2008-01-31 15:46:09.015793999 +0100
@@ -305,13 +305,13 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_
 	return NULL;
 }
 
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx)
 {
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
@@ -320,7 +320,7 @@ ieee80211_crypto_wep_decrypt(struct ieee
 				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
 				       "failed\n", rx->dev->name);
 #endif /* CONFIG_MAC80211_DEBUG */
-			return TXRX_DROP;
+			return RX_DROP;
 		}
 	} else if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED)) {
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
@@ -328,7 +328,7 @@ ieee80211_crypto_wep_decrypt(struct ieee
 		skb_trim(rx->skb, rx->skb->len - 4);
 	}
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
 static int wep_encrypt_skb(struct ieee80211_txrx_data *tx, struct sk_buff *skb)
@@ -346,7 +346,7 @@ static int wep_encrypt_skb(struct ieee80
 	return 0;
 }
 
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_crypto_wep_encrypt(struct ieee80211_txrx_data *tx)
 {
 	tx->u.tx.control->iv_len = WEP_IV_LEN;
@@ -355,7 +355,7 @@ ieee80211_crypto_wep_encrypt(struct ieee
 
 	if (wep_encrypt_skb(tx, tx->skb) < 0) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_wep);
-		return TXRX_DROP;
+		return TX_DROP;
 	}
 
 	if (tx->u.tx.extra_frag) {
@@ -364,10 +364,10 @@ ieee80211_crypto_wep_encrypt(struct ieee
 			if (wep_encrypt_skb(tx, tx->u.tx.extra_frag[i]) < 0) {
 				I802_DEBUG_INC(tx->local->
 					       tx_handlers_drop_wep);
-				return TXRX_DROP;
+				return TX_DROP;
 			}
 		}
 	}
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-01-31 15:45:58.065794107 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-01-31 15:46:09.025793944 +0100
@@ -2558,7 +2558,7 @@ static void ieee80211_sta_rx_queued_mgmt
 }
 
 
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
 		      struct ieee80211_rx_status *rx_status)
 {
@@ -2566,31 +2566,31 @@ ieee80211_sta_rx_scan(struct net_device 
 	u16 fc;
 
 	if (skb->len < 2)
-		return TXRX_DROP;
+		return RX_DROP;
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
 	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL)
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (skb->len < 24)
-		return TXRX_DROP;
+		return RX_DROP;
 
 	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP) {
 			ieee80211_rx_mgmt_probe_resp(dev, mgmt,
 						     skb->len, rx_status);
 			dev_kfree_skb(skb);
-			return TXRX_QUEUED;
+			return RX_QUEUED;
 		} else if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON) {
 			ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len,
 						 rx_status);
 			dev_kfree_skb(skb);
-			return TXRX_QUEUED;
+			return RX_QUEUED;
 		}
 	}
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
 
--- everything.orig/net/mac80211/wpa.c	2008-01-31 15:45:58.015796658 +0100
+++ everything/net/mac80211/wpa.c	2008-01-31 15:46:09.025793944 +0100
@@ -70,7 +70,7 @@ static int ieee80211_get_hdr_info(const 
 }
 
 
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_tx_h_michael_mic_add(struct ieee80211_txrx_data *tx)
 {
 	u8 *data, *sa, *da, *key, *mic, qos_tid;
@@ -84,10 +84,10 @@ ieee80211_tx_h_michael_mic_add(struct ie
 
 	if (!tx->key || tx->key->conf.alg != ALG_TKIP || skb->len < 24 ||
 	    !WLAN_FC_DATA_PRESENT(fc))
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len))
-		return TXRX_DROP;
+		return TX_DROP;
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->flags & IEEE80211_TXRXD_FRAGMENTED) &&
@@ -95,7 +95,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for Michael MIC
 		 */
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 	}
 
 	if (skb_tailroom(skb) < MICHAEL_MIC_LEN) {
@@ -105,7 +105,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 					      GFP_ATOMIC))) {
 			printk(KERN_DEBUG "%s: failed to allocate more memory "
 			       "for Michael MIC\n", tx->dev->name);
-			return TXRX_DROP;
+			return TX_DROP;
 		}
 	}
 
@@ -119,11 +119,11 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
 
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_txrx_data *rx)
 {
 	u8 *data, *sa, *da, *key = NULL, qos_tid;
@@ -140,15 +140,15 @@ ieee80211_rx_h_michael_mic_verify(struct
 	 * No way to verify the MIC if the hardware stripped it
 	 */
 	if (rx->u.rx.status->flag & RX_FLAG_MMIC_STRIPPED)
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
 	    !(rx->fc & IEEE80211_FCTL_PROTECTED) || !WLAN_FC_DATA_PRESENT(fc))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len)
 	    || data_len < MICHAEL_MIC_LEN)
-		return TXRX_DROP;
+		return RX_DROP;
 
 	data_len -= MICHAEL_MIC_LEN;
 
@@ -162,14 +162,14 @@ ieee80211_rx_h_michael_mic_verify(struct
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
 		if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-			return TXRX_DROP;
+			return RX_DROP;
 
 		printk(KERN_DEBUG "%s: invalid Michael MIC in data frame from "
 		       "%s\n", rx->dev->name, print_mac(mac, sa));
 
 		mac80211_ev_michael_mic_failure(rx->dev, rx->key->conf.keyidx,
 						(void *) skb->data);
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
 	/* remove Michael MIC from payload */
@@ -179,7 +179,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	rx->key->u.tkip.iv32_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv32;
 	rx->key->u.tkip.iv16_rx[rx->u.rx.queue] = rx->u.rx.tkip_iv16;
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
 
@@ -242,7 +242,7 @@ static int tkip_encrypt_skb(struct ieee8
 }
 
 
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_crypto_tkip_encrypt(struct ieee80211_txrx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
@@ -257,26 +257,26 @@ ieee80211_crypto_tkip_encrypt(struct iee
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for IV/ICV */
 		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 	}
 
 	if (tkip_encrypt_skb(tx, skb, test) < 0)
-		return TXRX_DROP;
+		return TX_DROP;
 
 	if (tx->u.tx.extra_frag) {
 		int i;
 		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
 			if (tkip_encrypt_skb(tx, tx->u.tx.extra_frag[i], test)
 			    < 0)
-				return TXRX_DROP;
+				return TX_DROP;
 		}
 	}
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
 
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
@@ -290,10 +290,10 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	hdrlen = ieee80211_get_hdrlen(fc);
 
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (!rx->sta || skb->len - hdrlen < 12)
-		return TXRX_DROP;
+		return RX_DROP;
 
 	if (rx->u.rx.status->flag & RX_FLAG_DECRYPTED) {
 		if (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) {
@@ -302,7 +302,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 			 * replay protection, and stripped the ICV/IV so
 			 * we cannot do any checks here.
 			 */
-			return TXRX_CONTINUE;
+			return RX_CONTINUE;
 		}
 
 		/* let TKIP code verify IV, but skip decryption */
@@ -322,7 +322,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 			       "frame from %s (res=%d)\n", rx->dev->name,
 			       print_mac(mac, rx->sta->addr), res);
 #endif /* CONFIG_MAC80211_DEBUG */
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
 	/* Trim ICV */
@@ -332,7 +332,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	memmove(skb->data + TKIP_IV_LEN, skb->data, hdrlen);
 	skb_pull(skb, TKIP_IV_LEN);
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
 
@@ -491,7 +491,7 @@ static int ccmp_encrypt_skb(struct ieee8
 }
 
 
-ieee80211_txrx_result
+ieee80211_tx_result
 ieee80211_crypto_ccmp_encrypt(struct ieee80211_txrx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
@@ -506,26 +506,26 @@ ieee80211_crypto_ccmp_encrypt(struct iee
 		/* hwaccel - with no need for preallocated room for CCMP "
 		 * header or MIC fields */
 		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 	}
 
 	if (ccmp_encrypt_skb(tx, skb, test) < 0)
-		return TXRX_DROP;
+		return TX_DROP;
 
 	if (tx->u.tx.extra_frag) {
 		int i;
 		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
 			if (ccmp_encrypt_skb(tx, tx->u.tx.extra_frag[i], test)
 			    < 0)
-				return TXRX_DROP;
+				return TX_DROP;
 		}
 	}
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
 
-ieee80211_txrx_result
+ieee80211_rx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
@@ -541,15 +541,15 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	hdrlen = ieee80211_get_hdrlen(fc);
 
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	data_len = skb->len - hdrlen - CCMP_HDR_LEN - CCMP_MIC_LEN;
 	if (!rx->sta || data_len < 0)
-		return TXRX_DROP;
+		return RX_DROP;
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
 	    (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	(void) ccmp_hdr2pn(pn, skb->data + hdrlen);
 
@@ -565,7 +565,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 		       ppn[0], ppn[1], ppn[2], ppn[3], ppn[4], ppn[5]);
 #endif /* CONFIG_MAC80211_DEBUG */
 		key->u.ccmp.replays++;
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
 	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
@@ -589,7 +589,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 				       "for RX frame from %s\n", rx->dev->name,
 				       print_mac(mac, rx->sta->addr));
 #endif /* CONFIG_MAC80211_DEBUG */
-			return TXRX_DROP;
+			return RX_DROP;
 		}
 	}
 
@@ -600,5 +600,5 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	memmove(skb->data + CCMP_HDR_LEN, skb->data, hdrlen);
 	skb_pull(skb, CCMP_HDR_LEN);
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
--- everything.orig/net/mac80211/rx.c	2008-01-31 15:46:06.355845920 +0100
+++ everything/net/mac80211/rx.c	2008-01-31 15:46:09.035794161 +0100
@@ -351,16 +351,16 @@ static u32 ieee80211_rx_load_stats(struc
 
 /* rx handlers */
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_if_stats(struct ieee80211_txrx_data *rx)
 {
 	if (rx->sta)
 		rx->sta->channel_use_raw += rx->u.rx.load;
 	rx->sdata->channel_use_raw += rx->u.rx.load;
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
@@ -372,21 +372,21 @@ ieee80211_rx_h_passive_scan(struct ieee8
 	if (unlikely(local->sta_sw_scanning)) {
 		/* drop all the other packets during a software scan anyway */
 		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
-		    != TXRX_QUEUED)
+		    != RX_QUEUED)
 			dev_kfree_skb(skb);
-		return TXRX_QUEUED;
+		return RX_QUEUED;
 	}
 
 	if (unlikely(rx->flags & IEEE80211_TXRXD_RXIN_SCAN)) {
 		/* scanning finished during invoking of handlers */
 		I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
@@ -401,14 +401,14 @@ ieee80211_rx_h_check(struct ieee80211_tx
 				rx->local->dot11FrameDuplicateCount++;
 				rx->sta->num_duplicates++;
 			}
-			return TXRX_DROP;
+			return RX_DROP;
 		} else
 			rx->sta->last_seq_ctrl[rx->u.rx.queue] = hdr->seq_ctrl;
 	}
 
 	if (unlikely(rx->skb->len < 16)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_short);
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
 	/* Drop disallowed frame classes based on STA auth/assoc state;
@@ -430,23 +430,23 @@ ieee80211_rx_h_check(struct ieee80211_tx
 		    || !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
 			/* Drop IBSS frames and frames for other hosts
 			 * silently. */
-			return TXRX_DROP;
+			return RX_DROP;
 		}
 
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	int keyidx;
 	int hdrlen;
-	ieee80211_txrx_result result = TXRX_DROP;
+	ieee80211_rx_result result = RX_DROP;
 	struct ieee80211_key *stakey = NULL;
 
 	/*
@@ -476,14 +476,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	 */
 
 	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	/*
 	 * No point in finding a key and decrypting if the frame is neither
 	 * addressed to us nor a multicast frame.
 	 */
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (rx->sta)
 		stakey = rcu_dereference(rx->sta->key);
@@ -502,12 +502,12 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		 */
 		if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
 		    (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED))
-			return TXRX_CONTINUE;
+			return RX_CONTINUE;
 
 		hdrlen = ieee80211_get_hdrlen(rx->fc);
 
 		if (rx->skb->len < 8 + hdrlen)
-			return TXRX_DROP; /* TODO: count this? */
+			return RX_DROP; /* TODO: count this? */
 
 		/*
 		 * no need to call ieee80211_wep_get_keyidx,
@@ -536,7 +536,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 			printk(KERN_DEBUG "%s: RX protected frame,"
 			       " but have no key\n", rx->dev->name);
 #endif /* CONFIG_MAC80211_DEBUG */
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
 	/* Check for weak IVs if possible */
@@ -629,7 +629,7 @@ static int ap_sta_ps_end(struct net_devi
 	return sent;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
@@ -637,7 +637,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 
 	if (!sta)
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	/* Update last_rx only for IBSS packets which are for the current
 	 * BSSID to avoid keeping the current IBSS network alive in cases where
@@ -658,7 +658,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 	}
 
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
@@ -685,10 +685,10 @@ ieee80211_rx_h_sta_process(struct ieee80
 		 * as a dropped packed. */
 		sta->rx_packets++;
 		dev_kfree_skb(rx->skb);
-		return TXRX_QUEUED;
+		return RX_QUEUED;
 	}
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 } /* ieee80211_rx_h_sta_process */
 
 static inline struct ieee80211_fragment_entry *
@@ -774,7 +774,7 @@ ieee80211_reassemble_find(struct ieee802
 	return NULL;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_defragment(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
@@ -811,7 +811,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			       rx->key->u.ccmp.rx_pn[rx->u.rx.queue],
 			       CCMP_PN_LEN);
 		}
-		return TXRX_QUEUED;
+		return RX_QUEUED;
 	}
 
 	/* This is a fragment for a frame that should already be pending in
@@ -821,7 +821,7 @@ ieee80211_rx_h_defragment(struct ieee802
 					  rx->u.rx.queue, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
 	/* Verify that MPDUs within one MSDU have sequential PN values.
@@ -830,7 +830,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		int i;
 		u8 pn[CCMP_PN_LEN], *rpn;
 		if (!rx->key || rx->key->conf.alg != ALG_CCMP)
-			return TXRX_DROP;
+			return RX_DROP;
 		memcpy(pn, entry->last_pn, CCMP_PN_LEN);
 		for (i = CCMP_PN_LEN - 1; i >= 0; i--) {
 			pn[i]++;
@@ -848,7 +848,7 @@ ieee80211_rx_h_defragment(struct ieee802
 				       rpn[0], rpn[1], rpn[2], rpn[3], rpn[4],
 				       rpn[5], pn[0], pn[1], pn[2], pn[3],
 				       pn[4], pn[5]);
-			return TXRX_DROP;
+			return RX_DROP;
 		}
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
 	}
@@ -859,7 +859,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	entry->extra_len += rx->skb->len;
 	if (rx->fc & IEEE80211_FCTL_MOREFRAGS) {
 		rx->skb = NULL;
-		return TXRX_QUEUED;
+		return RX_QUEUED;
 	}
 
 	rx->skb = __skb_dequeue(&entry->skb_list);
@@ -869,7 +869,7 @@ ieee80211_rx_h_defragment(struct ieee802
 					      GFP_ATOMIC))) {
 			I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
 			__skb_queue_purge(&entry->skb_list);
-			return TXRX_DROP;
+			return RX_DROP;
 		}
 	}
 	while ((skb = __skb_dequeue(&entry->skb_list))) {
@@ -887,10 +887,10 @@ ieee80211_rx_h_defragment(struct ieee802
 		rx->local->dot11MulticastReceivedFrameCount++;
 	else
 		ieee80211_led_rx(rx->local);
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
@@ -902,11 +902,11 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		   (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL ||
 		   (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PSPOLL ||
 		   !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if ((sdata->vif.type != IEEE80211_IF_TYPE_AP) &&
 	    (sdata->vif.type != IEEE80211_IF_TYPE_VLAN))
-		return TXRX_DROP;
+		return RX_DROP;
 
 	skb = skb_dequeue(&rx->sta->tx_filtered);
 	if (!skb) {
@@ -957,14 +957,14 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 
 	}
 
-	/* Free PS Poll skb here instead of returning TXRX_DROP that would
+	/* Free PS Poll skb here instead of returning RX_DROP that would
 	 * count as an dropped frame. */
 	dev_kfree_skb(rx->skb);
 
-	return TXRX_QUEUED;
+	return RX_QUEUED;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx)
 {
 	u16 fc = rx->fc;
@@ -972,7 +972,7 @@ ieee80211_rx_h_remove_qos_control(struct
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) data;
 
 	if (!WLAN_FC_IS_QOS_DATA(fc))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	/* remove the qos control field, update frame type and meta-data */
 	memmove(data + 2, data, ieee80211_get_hdrlen(fc) - 2);
@@ -981,7 +981,7 @@ ieee80211_rx_h_remove_qos_control(struct
 	rx->fc = fc &= ~IEEE80211_STYPE_QOS_DATA;
 	hdr->frame_control = cpu_to_le16(fc);
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
 static int
@@ -1238,7 +1238,7 @@ ieee80211_deliver_skb(struct ieee80211_t
 	}
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_amsdu(struct ieee80211_txrx_data *rx)
 {
 	struct net_device *dev = rx->dev;
@@ -1254,17 +1254,17 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 
 	fc = rx->fc;
 	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
-		return TXRX_DROP;
+		return RX_DROP;
 
 	if (!(rx->flags & IEEE80211_TXRXD_RX_AMSDU))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	err = ieee80211_data_to_8023(rx);
 	if (unlikely(err))
-		return TXRX_DROP;
+		return RX_DROP;
 
 	skb->dev = dev;
 
@@ -1274,7 +1274,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 	/* skip the wrapping header */
 	eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
 	if (!eth)
-		return TXRX_DROP;
+		return RX_DROP;
 
 	while (skb != frame) {
 		u8 padding;
@@ -1289,7 +1289,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 		/* the last MSDU has no padding */
 		if (subframe_len > remaining) {
 			printk(KERN_DEBUG "%s: wrong buffer size", dev->name);
-			return TXRX_DROP;
+			return RX_DROP;
 		}
 
 		skb_pull(skb, sizeof(struct ethhdr));
@@ -1301,7 +1301,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 					      subframe_len);
 
 			if (frame == NULL)
-				return TXRX_DROP;
+				return RX_DROP;
 
 			skb_reserve(frame, local->hw.extra_tx_headroom +
 				    sizeof(struct ethhdr));
@@ -1314,7 +1314,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 				printk(KERN_DEBUG "%s: wrong buffer size ",
 				       dev->name);
 				dev_kfree_skb(frame);
-				return TXRX_DROP;
+				return RX_DROP;
 			}
 		}
 
@@ -1344,7 +1344,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 
 		if (!ieee80211_frame_allowed(rx)) {
 			if (skb == frame) /* last frame */
-				return TXRX_DROP;
+				return RX_DROP;
 			dev_kfree_skb(frame);
 			continue;
 		}
@@ -1352,10 +1352,10 @@ ieee80211_rx_h_amsdu(struct ieee80211_tx
 		ieee80211_deliver_skb(rx);
 	}
 
-	return TXRX_QUEUED;
+	return RX_QUEUED;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 {
 	struct net_device *dev = rx->dev;
@@ -1364,17 +1364,17 @@ ieee80211_rx_h_data(struct ieee80211_txr
 
 	fc = rx->fc;
 	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
-		return TXRX_DROP;
+		return RX_DROP;
 
 	err = ieee80211_data_to_8023(rx);
 	if (unlikely(err))
-		return TXRX_DROP;
+		return RX_DROP;
 
 	if (!ieee80211_frame_allowed(rx))
-		return TXRX_DROP;
+		return RX_DROP;
 
 	rx->skb->dev = dev;
 
@@ -1383,10 +1383,10 @@ ieee80211_rx_h_data(struct ieee80211_txr
 
 	ieee80211_deliver_skb(rx);
 
-	return TXRX_QUEUED;
+	return RX_QUEUED;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_ctrl(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
@@ -1398,15 +1398,15 @@ ieee80211_rx_h_ctrl(struct ieee80211_txr
 	u16 tid;
 
 	if (likely((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL))
-		return TXRX_CONTINUE;
+		return RX_CONTINUE;
 
 	if ((rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BACK_REQ) {
 		if (!rx->sta)
-			return TXRX_CONTINUE;
+			return RX_CONTINUE;
 		tid = le16_to_cpu(bar->control) >> 12;
 		tid_agg_rx = &(rx->sta->ampdu_mlme.tid_rx[tid]);
 		if (tid_agg_rx->state != HT_AGG_STATE_OPERATIONAL)
-			return TXRX_CONTINUE;
+			return RX_CONTINUE;
 
 		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
 
@@ -1423,19 +1423,19 @@ ieee80211_rx_h_ctrl(struct ieee80211_txr
 		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
 						 start_seq_num, 1);
 		rcu_read_unlock();
-		return TXRX_DROP;
+		return RX_DROP;
 	}
 
-	return TXRX_CONTINUE;
+	return RX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_rx_result
 ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata;
 
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return TXRX_DROP;
+		return RX_DROP;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
@@ -1443,39 +1443,39 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
 	else
-		return TXRX_DROP;
+		return RX_DROP;
 
-	return TXRX_QUEUED;
+	return RX_QUEUED;
 }
 
-static inline ieee80211_txrx_result __ieee80211_invoke_rx_handlers(
+static inline ieee80211_rx_result __ieee80211_invoke_rx_handlers(
 				struct ieee80211_local *local,
 				ieee80211_rx_handler *handlers,
 				struct ieee80211_txrx_data *rx,
 				struct sta_info *sta)
 {
 	ieee80211_rx_handler *handler;
-	ieee80211_txrx_result res = TXRX_DROP;
+	ieee80211_rx_result res = RX_DROP;
 
 	for (handler = handlers; *handler != NULL; handler++) {
 		res = (*handler)(rx);
 
 		switch (res) {
-		case TXRX_CONTINUE:
+		case RX_CONTINUE:
 			continue;
-		case TXRX_DROP:
+		case RX_DROP:
 			I802_DEBUG_INC(local->rx_handlers_drop);
 			if (sta)
 				sta->rx_dropped++;
 			break;
-		case TXRX_QUEUED:
+		case RX_QUEUED:
 			I802_DEBUG_INC(local->rx_handlers_queued);
 			break;
 		}
 		break;
 	}
 
-	if (res == TXRX_DROP)
+	if (res == RX_DROP)
 		dev_kfree_skb(rx->skb);
 	return res;
 }
@@ -1486,7 +1486,7 @@ static inline void ieee80211_invoke_rx_h
 						struct sta_info *sta)
 {
 	if (__ieee80211_invoke_rx_handlers(local, handlers, rx, sta) ==
-	    TXRX_CONTINUE)
+	    RX_CONTINUE)
 		dev_kfree_skb(rx->skb);
 }
 
--- everything.orig/net/mac80211/tx.c	2008-01-31 15:45:58.145795247 +0100
+++ everything/net/mac80211/tx.c	2008-01-31 15:46:09.035794161 +0100
@@ -232,7 +232,7 @@ static int inline is_ieee80211_device(st
 
 /* tx handlers */
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -242,15 +242,15 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	u32 sta_flags;
 
 	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sta_sw_scanning) &&
 	    ((tx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
-		return TXRX_DROP;
+		return TX_DROP;
 
 	if (tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED)
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	sta_flags = tx->sta ? tx->sta->flags : 0;
 
@@ -265,7 +265,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 			       tx->dev->name, print_mac(mac, hdr->addr1));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 			I802_DEBUG_INC(tx->local->tx_handlers_drop_not_assoc);
-			return TXRX_DROP;
+			return TX_DROP;
 		}
 	} else {
 		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
@@ -275,15 +275,15 @@ ieee80211_tx_h_check_assoc(struct ieee80
 			 * No associated STAs - no need to send multicast
 			 * frames.
 			 */
-			return TXRX_DROP;
+			return TX_DROP;
 		}
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 	}
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_sequence(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -291,7 +291,7 @@ ieee80211_tx_h_sequence(struct ieee80211
 	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
 		ieee80211_include_sequence(tx->sdata, hdr);
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
 /* This function is called whenever the AP is about to exceed the maximum limit
@@ -341,7 +341,7 @@ static void purge_old_ps_buffers(struct 
 	       wiphy_name(local->hw.wiphy), purged);
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_multicast_ps_buf(struct ieee80211_txrx_data *tx)
 {
 	/*
@@ -354,11 +354,11 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 
 	/* not AP/IBSS or ordered frame */
 	if (!tx->sdata->bss || (tx->fc & IEEE80211_FCTL_ORDER))
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	/* no stations in PS mode */
 	if (!atomic_read(&tx->sdata->bss->num_sta_ps))
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	/* buffered in mac80211 */
 	if (tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING) {
@@ -375,16 +375,16 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 		} else
 			tx->local->total_ps_buffered++;
 		skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);
-		return TXRX_QUEUED;
+		return TX_QUEUED;
 	}
 
 	/* buffered in hardware */
 	tx->u.tx.control->flags |= IEEE80211_TXCTL_SEND_AFTER_DTIM;
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_unicast_ps_buf(struct ieee80211_txrx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
@@ -393,7 +393,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	if (unlikely(!sta ||
 		     ((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
 		      (tx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP)))
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	if (unlikely((sta->flags & WLAN_STA_PS) && !sta->pspoll)) {
 		struct ieee80211_tx_packet_data *pkt_data;
@@ -427,7 +427,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		pkt_data = (struct ieee80211_tx_packet_data *)tx->skb->cb;
 		pkt_data->jiffies = jiffies;
 		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
-		return TXRX_QUEUED;
+		return TX_QUEUED;
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	else if (unlikely(sta->flags & WLAN_STA_PS)) {
@@ -438,14 +438,14 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 	sta->pspoll = 0;
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_ps_buf(struct ieee80211_txrx_data *tx)
 {
 	if (unlikely(tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED))
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	if (tx->flags & IEEE80211_TXRXD_TXUNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
@@ -453,7 +453,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 		return ieee80211_tx_h_multicast_ps_buf(tx);
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_key *key;
@@ -469,7 +469,7 @@ ieee80211_tx_h_select_key(struct ieee802
 		 !(tx->u.tx.control->flags & IEEE80211_TXCTL_EAPOL_FRAME) &&
 		 !(tx->flags & IEEE80211_TXRXD_TX_INJECTED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
-		return TXRX_DROP;
+		return TX_DROP;
 	} else
 		tx->key = NULL;
 
@@ -498,10 +498,10 @@ ieee80211_tx_h_select_key(struct ieee802
 	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
@@ -513,7 +513,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	int frag_threshold = tx->local->fragmentation_threshold;
 
 	if (!(tx->flags & IEEE80211_TXRXD_FRAGMENTED))
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	first = tx->skb;
 
@@ -567,7 +567,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	tx->u.tx.num_extra_frag = num_fragm - 1;
 	tx->u.tx.extra_frag = frags;
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 
  fail:
 	printk(KERN_DEBUG "%s: failed to fragment frame\n", tx->dev->name);
@@ -578,14 +578,14 @@ ieee80211_tx_h_fragment(struct ieee80211
 		kfree(frags);
 	}
 	I802_DEBUG_INC(tx->local->tx_handlers_drop_fragment);
-	return TXRX_DROP;
+	return TX_DROP;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_encrypt(struct ieee80211_txrx_data *tx)
 {
 	if (!tx->key)
-		return TXRX_CONTINUE;
+		return TX_CONTINUE;
 
 	switch (tx->key->conf.alg) {
 	case ALG_WEP:
@@ -598,10 +598,10 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 
 	/* not reached */
 	WARN_ON(1);
-	return TXRX_DROP;
+	return TX_DROP;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_rate_ctrl(struct ieee80211_txrx_data *tx)
 {
 	struct rate_selection rsel;
@@ -622,7 +622,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 			tx->u.tx.control->alt_retry_rate = NULL;
 
 		if (!tx->u.tx.rate)
-			return TXRX_DROP;
+			return TX_DROP;
 	} else
 		tx->u.tx.control->alt_retry_rate = NULL;
 
@@ -642,10 +642,10 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	}
 	tx->u.tx.control->tx_rate = tx->u.tx.rate;
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_misc(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
@@ -754,10 +754,10 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		}
 	}
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
-static ieee80211_txrx_result
+static ieee80211_tx_result
 ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
@@ -810,7 +810,7 @@ ieee80211_tx_h_load_stats(struct ieee802
 		tx->sta->channel_use_raw += load;
 	tx->sdata->channel_use_raw += load;
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
 /* TODO: implement register/unregister functions for adding TX/RX handlers
@@ -837,7 +837,7 @@ ieee80211_tx_handler ieee80211_tx_handle
  * deal with packet injection down monitor interface
  * with Radiotap Header -- only called for monitor mode interface
  */
-static ieee80211_txrx_result
+static ieee80211_tx_result
 __ieee80211_parse_tx_radiotap(struct ieee80211_txrx_data *tx,
 			      struct sk_buff *skb)
 {
@@ -926,7 +926,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 				 * on transmission
 				 */
 				if (skb->len < (iterator.max_length + FCS_LEN))
-					return TXRX_DROP;
+					return TX_DROP;
 
 				skb_trim(skb, skb->len - FCS_LEN);
 			}
@@ -949,7 +949,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 	}
 
 	if (ret != -ENOENT) /* ie, if we didn't simply run out of fields */
-		return TXRX_DROP;
+		return TX_DROP;
 
 	/*
 	 * remove the radiotap header
@@ -958,13 +958,13 @@ __ieee80211_parse_tx_radiotap(struct iee
 	 */
 	skb_pull(skb, iterator.max_length);
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
 /*
  * initialises @tx
  */
-static ieee80211_txrx_result
+static ieee80211_tx_result
 __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 		       struct sk_buff *skb,
 		       struct net_device *dev,
@@ -991,8 +991,8 @@ __ieee80211_tx_prepare(struct ieee80211_
 	/* process and remove the injection radiotap header */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (unlikely(sdata->vif.type == IEEE80211_IF_TYPE_MNTR)) {
-		if (__ieee80211_parse_tx_radiotap(tx, skb) == TXRX_DROP)
-			return TXRX_DROP;
+		if (__ieee80211_parse_tx_radiotap(tx, skb) == TX_DROP)
+			return TX_DROP;
 
 		/*
 		 * __ieee80211_parse_tx_radiotap has now removed
@@ -1037,7 +1037,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 	}
 	control->flags |= IEEE80211_TXCTL_FIRST_FRAGMENT;
 
-	return TXRX_CONTINUE;
+	return TX_CONTINUE;
 }
 
 /*
@@ -1131,7 +1131,7 @@ static int ieee80211_tx(struct net_devic
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
-	ieee80211_txrx_result res = TXRX_DROP, res_prepare;
+	ieee80211_tx_result res = TX_DROP, res_prepare;
 	int ret, i;
 
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
@@ -1144,7 +1144,7 @@ static int ieee80211_tx(struct net_devic
 	/* initialises tx */
 	res_prepare = __ieee80211_tx_prepare(&tx, skb, dev, control);
 
-	if (res_prepare == TXRX_DROP) {
+	if (res_prepare == TX_DROP) {
 		dev_kfree_skb(skb);
 		return 0;
 	}
@@ -1161,7 +1161,7 @@ static int ieee80211_tx(struct net_devic
 	for (handler = local->tx_handlers; *handler != NULL;
 	     handler++) {
 		res = (*handler)(&tx);
-		if (res != TXRX_CONTINUE)
+		if (res != TX_CONTINUE)
 			break;
 	}
 
@@ -1170,12 +1170,12 @@ static int ieee80211_tx(struct net_devic
 	if (sta)
 		sta_info_put(sta);
 
-	if (unlikely(res == TXRX_DROP)) {
+	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
 		goto drop;
 	}
 
-	if (unlikely(res == TXRX_QUEUED)) {
+	if (unlikely(res == TX_QUEUED)) {
 		I802_DEBUG_INC(local->tx_handlers_queued);
 		rcu_read_unlock();
 		return 0;
@@ -1864,7 +1864,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
-	ieee80211_txrx_result res = TXRX_DROP;
+	ieee80211_tx_result res = TX_DROP;
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
@@ -1916,16 +1916,16 @@ ieee80211_get_buffered_bc(struct ieee802
 
 	for (handler = local->tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
-		if (res == TXRX_DROP || res == TXRX_QUEUED)
+		if (res == TX_DROP || res == TX_QUEUED)
 			break;
 	}
 	skb = tx.skb; /* handlers are allowed to change skb */
 
-	if (res == TXRX_DROP) {
+	if (res == TX_DROP) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
 		dev_kfree_skb(skb);
 		skb = NULL;
-	} else if (res == TXRX_QUEUED) {
+	} else if (res == TX_QUEUED) {
 		I802_DEBUG_INC(local->tx_handlers_queued);
 		skb = NULL;
 	}

-- 

