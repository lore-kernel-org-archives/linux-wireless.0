Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXHWQte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:49:34 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFs7-0000zy-Gx
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:49:30 +0100
Message-Id: <20070823164523.418272000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 06/11] mac80211: remove HW_KEY_IDX_INVALID
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the mac80211/driver interface rely only on the
IEEE80211_TXCTL_DO_NOT_ENCRYPT flag to signal to the driver whether
a frame should be encrypted or not, since mac80211 internally no
longer relies on HW_KEY_IDX_INVALID either this removes it, changes
the key index to be an integer in all places and makes the full
range of the value available to drivers.

---
 include/net/mac80211.h |   15 +++++++--------
 net/mac80211/key.c     |    5 -----
 net/mac80211/tx.c      |    7 +++----
 net/mac80211/wpa.c     |    8 ++++----
 4 files changed, 14 insertions(+), 21 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-23 18:38:42.511897709 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-23 18:38:43.161897709 +0200
@@ -245,7 +245,6 @@ struct ieee80211_low_level_stats {
 /* Transmit control fields. This data structure is passed to low-level driver
  * with each TX frame. The low-level driver is responsible for configuring
  * the hardware to use given values (depending on what is supported). */
-#define HW_KEY_IDX_INVALID -1
 
 struct ieee80211_tx_control {
 	int tx_rate; /* Transmit rate, given as the hw specific value for the
@@ -277,13 +276,13 @@ struct ieee80211_tx_control {
 						  * long retry value */
 	u32 flags;			       /* tx control flags defined
 						* above */
+	int key_idx;		/* keyidx from hw->set_key(), undefined if
+				 * IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
 	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
 				 * This could be used when set_retry_limit
 				 * is not implemented by the driver */
 	u8 power_level;		/* per-packet transmit power level, in dBm */
 	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
-	s8 key_idx;		/* HW_KEY_IDX_INVALID = do not encrypt,
-				 * other values: keyidx from hw->set_key() */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 queue;		/* hardware queue to use for this frame;
@@ -594,8 +593,7 @@ enum ieee80211_key_flags {
  *
  * @hw_key_idx: To be set by the driver, this is the key index the driver
  *	wants to be given when a frame is transmitted and needs to be
- *	encrypted in hardware. It defaults to %HW_KEY_IDX_INVALID which
- *	the driver may not use.
+ *	encrypted in hardware.
  * @alg: The key algorithm.
  * @driver_keylist: for use by the driver
  * @flags: key flags, see &enum ieee80211_key_flags.
@@ -791,9 +789,10 @@ static inline void SET_IEEE80211_PERM_AD
  *
  * The set_key() call for the %SET_KEY command should return 0 if
  * the key is now in use, -%EOPNOTSUPP or -%ENOSPC if it couldn't be
- * added; if it returns 0 then hw_key_idx must be assigned to something
- * other than %HW_KEY_IDX_INVALID. When the cmd is %DISABLE_KEY then
- * it must succeed.
+ * added; if it returns 0 then hw_key_idx must be assigned to the key
+ * index the driver would like to get in the tx() call.
+ *
+ * When the cmd is %DISABLE_KEY then it must succeed.
  *
  * Note that it is permissible to not decrypt a frame even if a key
  * for it has been uploaded to hardware, the stack will not make any
--- wireless-dev.orig/net/mac80211/key.c	2007-08-23 18:38:38.701897709 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-23 18:38:43.161897709 +0200
@@ -69,8 +69,6 @@ static void ieee80211_key_enable_hw_acce
 				       key->sdata->dev->dev_addr, addr,
 				       &key->conf);
 
-	WARN_ON(!ret && (key->conf.hw_key_idx == HW_KEY_IDX_INVALID));
-
 	if (!ret)
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
@@ -105,7 +103,6 @@ static void ieee80211_key_disable_hw_acc
 		       key->conf.keyidx, MAC_ARG(addr), ret);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-	key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
 }
 
 /*
@@ -122,7 +119,6 @@ void ieee80211_key_removed(struct ieee80
 		return;
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-	key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
 }
 
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
@@ -144,7 +140,6 @@ struct ieee80211_key *ieee80211_key_allo
 	 * Default to software encryption; we'll later upload the
 	 * key to the hardware if possible.
 	 */
-	key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
 	key->conf.flags = 0;
 	key->flags = 0;
 
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-23 18:38:38.751897709 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-23 18:38:43.161897709 +0200
@@ -136,7 +136,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 		printk(KERN_INFO "%s: WPA testing - corrupting TX Michael MIC "
 		       "for STA " MAC_FMT "\n",
 		       tx->dev->name, MAC_ARG(tx->sta->addr));
-		tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		tx->sta->wpa_trigger &= ~WPA_TRIGGER_FAIL_TX_MIC;
 		tx->wpa_test = 1;
 		mic[0]++;
@@ -144,7 +144,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 		   tx->local->wpa_trigger & WPA_TRIGGER_FAIL_TX_MIC) {
 		printk(KERN_INFO "%s: WPA testing - corrupting TX Michael MIC "
 		       "for Group Key\n", tx->dev->name);
-		tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		tx->local->wpa_trigger &= ~WPA_TRIGGER_FAIL_TX_MIC;
 		tx->wpa_test = 1;
 		mic[0]++;
@@ -398,7 +398,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 		printk(KERN_INFO "%s: WPA testing - corrupting TX TKIP ICV "
 		       "for STA " MAC_FMT "\n",
 		       tx->dev->name, MAC_ARG(tx->sta->addr));
-		tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		tx->sta->wpa_trigger &= ~WPA_TRIGGER_FAIL_TX_ICV;
 		skb->data[skb->len - 1]++;
 	} else if (!tx->u.tx.unicast &&
@@ -406,7 +406,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 		printk(KERN_INFO "%s: WPA testing - corrupting TX TKIP ICV "
 		       "for Group Key\n",
 		       tx->dev->name);
-		tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		tx->local->wpa_trigger &= ~WPA_TRIGGER_FAIL_TX_ICV;
 		skb->data[skb->len - 1]++;
 	}
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-23 18:38:38.791897709 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-23 18:38:43.161897709 +0200
@@ -425,8 +425,6 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 static ieee80211_txrx_result
 ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 {
-	tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
-
 	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
 	else if (tx->sta && tx->sta->key)
@@ -437,8 +435,10 @@ ieee80211_tx_h_select_key(struct ieee802
 		 !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TXRX_DROP;
-	} else
+	} else {
 		tx->key = NULL;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+	}
 
 	if (tx->key) {
 		tx->key->tx_rx_count++;
@@ -827,7 +827,6 @@ __ieee80211_parse_tx_radiotap(
 	 */
 
 	control->retry_limit = 1; /* no retry */
-	control->key_idx = HW_KEY_IDX_INVALID;
 	control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
 			    IEEE80211_TXCTL_USE_CTS_PROTECT);
 	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT |

-- 

