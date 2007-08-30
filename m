Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbXH3PSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 11:18:30 -0400
Subject: [PATCH] mac80211: remove HW_KEY_IDX_INVALID
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Zhu Yi <yi.zhy@intel.com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 17:19:40 +0200
Message-Id: <1188487180.3978.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the mac80211/driver interface rely only on the
IEEE80211_TXCTL_DO_NOT_ENCRYPT flag to signal to the driver whether
a frame should be encrypted or not, since mac80211 internally no
longer relies on HW_KEY_IDX_INVALID either this removes it, changes
the key index to be a u8 in all places and makes the full range of
the value available to drivers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Changes since v1:
 * use a u8 instead of an int
 * reorder some fields for better space usage (less padding)
Changes since v3:
 * update iwlwifi

 drivers/net/wireless/iwl-base.c |    2 +-
 include/net/mac80211.h          |   17 ++++++++---------
 net/mac80211/key.c              |    4 ----
 net/mac80211/tx.c               |   16 ++++++++++++----
 net/mac80211/wpa.c              |    8 ++++----
 5 files changed, 25 insertions(+), 22 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-30 16:26:01.405374680 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-30 17:13:31.425374680 +0200
@@ -164,7 +164,6 @@ struct ieee80211_low_level_stats {
 /* Transmit control fields. This data structure is passed to low-level driver
  * with each TX frame. The low-level driver is responsible for configuring
  * the hardware to use given values (depending on what is supported). */
-#define HW_KEY_IDX_INVALID -1
 
 struct ieee80211_tx_control {
 	int tx_rate; /* Transmit rate, given as the hw specific value for the
@@ -197,13 +196,13 @@ struct ieee80211_tx_control {
 						  * long retry value */
 	u32 flags;			       /* tx control flags defined
 						* above */
+	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
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
 	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
@@ -467,8 +466,7 @@ enum ieee80211_key_flags {
  *
  * @hw_key_idx: To be set by the driver, this is the key index the driver
  *	wants to be given when a frame is transmitted and needs to be
- *	encrypted in hardware. It defaults to %HW_KEY_IDX_INVALID which
- *	the driver may not use.
+ *	encrypted in hardware.
  * @alg: The key algorithm.
  * @flags: key flags, see &enum ieee80211_key_flags.
  * @keyidx: the key index (0-3)
@@ -476,8 +474,8 @@ enum ieee80211_key_flags {
  * @key: key material
  */
 struct ieee80211_key_conf {
-	int hw_key_idx;
 	ieee80211_key_alg alg;
+	u8 hw_key_idx;
 	u8 flags;
 	s8 keyidx;
 	u8 keylen;
@@ -689,9 +687,10 @@ struct ieee80211_ops {
 	 * selected by the low-level driver.
 	 *
 	 * Return 0 if the key is now in use, -EOPNOTSUPP or -ENOSPC if it
-	 * couldn't be added; if you return 0 then hw_key_idx must be
-	 * assigned to something other than HW_KEY_IDX_INVALID. When the cmd
-	 * is DISABLE_KEY then it must succeed.
+	 * couldn't be added; if you return 0 then hw_key_idx must be assigned
+	 * to the hardware key index, you are free to use the full u8 range.
+	 *
+	 * When the cmd is DISABLE_KEY then it must succeed.
 	 *
 	 * Note that it is permissible to not decrypt a frame even if a key
 	 * for it has been uploaded to hardware, the stack will not make any
--- wireless-dev.orig/net/mac80211/key.c	2007-08-30 16:26:01.355374680 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-30 17:13:24.835374680 +0200
@@ -73,8 +73,6 @@ static void ieee80211_key_enable_hw_acce
 				       key->sdata->dev->dev_addr, addr,
 				       &key->conf);
 
-	WARN_ON(!ret && (key->conf.hw_key_idx == HW_KEY_IDX_INVALID));
-
 	if (!ret)
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
@@ -109,7 +107,6 @@ static void ieee80211_key_disable_hw_acc
 		       key->conf.keyidx, MAC_ARG(addr), ret);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-	key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
 }
 
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
@@ -132,7 +129,6 @@ struct ieee80211_key *ieee80211_key_allo
 	 * Default to software encryption; we'll later upload the
 	 * key to the hardware if possible.
 	 */
-	key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
 	key->conf.flags = 0;
 	key->flags = 0;
 
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-30 16:26:01.185374680 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-30 17:13:31.475374680 +0200
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
@@ -415,7 +415,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 		printk(KERN_INFO "%s: WPA testing - corrupting TX TKIP ICV "
 		       "for STA " MAC_FMT "\n",
 		       tx->dev->name, MAC_ARG(tx->sta->addr));
-		tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		tx->sta->wpa_trigger &= ~WPA_TRIGGER_FAIL_TX_ICV;
 		skb->data[skb->len - 1]++;
 	} else if (!(tx->flags & IEEE80211_TXRXD_TXUNICAST) &&
@@ -423,7 +423,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 		printk(KERN_INFO "%s: WPA testing - corrupting TX TKIP ICV "
 		       "for Group Key\n",
 		       tx->dev->name);
-		tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		tx->local->wpa_trigger &= ~WPA_TRIGGER_FAIL_TX_ICV;
 		skb->data[skb->len - 1]++;
 	}
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-30 16:26:01.195374680 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-30 17:17:28.535374680 +0200
@@ -429,8 +429,6 @@ ieee80211_tx_h_select_key(struct ieee802
 {
 	struct ieee80211_key *key;
 
-	tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
-
 	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
 	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
@@ -441,8 +439,10 @@ ieee80211_tx_h_select_key(struct ieee802
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
@@ -723,6 +723,15 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		}
 	}
 
+	/*
+	 * Tell hardware to not encrypt when we had sw crypto.
+	 * Because we use the same flag to internally indicate that
+	 * no (software) encryption should be done, we have to set it
+	 * after all crypto handlers.
+	 */
+	if (tx->key && !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+
 	return TXRX_CONTINUE;
 }
 
@@ -832,7 +841,6 @@ __ieee80211_parse_tx_radiotap(
 	 */
 
 	control->retry_limit = 1; /* no retry */
-	control->key_idx = HW_KEY_IDX_INVALID;
 	control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
 			    IEEE80211_TXCTL_USE_CTS_PROTECT);
 	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT |
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-30 17:13:30.235374680 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-30 17:14:01.205374680 +0200
@@ -3012,7 +3012,7 @@ static int iwl_tx_skb(struct iwl_priv *p
 
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
-	if (ctl->key_idx != -1)
+	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		iwl_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
 
 	/* 802.11 null functions have no payload... */


