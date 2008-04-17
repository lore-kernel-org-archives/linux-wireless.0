Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:39228 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYDQRga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 13:36:30 -0400
Received: by nf-out-0910.google.com with SMTP id g13so105588nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 10:36:28 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v4] mac80211: Replace ieee80211_tx_control->key_idx with ieee80211_key_conf
Date: Thu, 17 Apr 2008 19:41:02 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>
References: <200804171728.30188.IvDoorn@gmail.com> <200804171759.54830.IvDoorn@gmail.com> <200804171923.41533.IvDoorn@gmail.com>
In-Reply-To: <200804171923.41533.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804171941.03002.IvDoorn@gmail.com> (sfid-20080417_183653_595777_FF5E34A3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hw_key_idx inside the ieee80211_key_conf structure does
not provide all the information drivers might need to perform
hardware encryption.

This is in particular true for rt2x00 who needs to know the
key algorithm and whether it is a shared or pairwise key.

By passing the ieee80211_key_conf pointer it assures us that
drivers can make full use of all information that it should know
about a particular key.

Additionally this patch updates all drivers to grab the hw_key_idx from
the ieee80211_key_conf structure.

v2: Removed bogus u16 cast
v3: Add warning about ieee80211_tx_control pointers
v4: Update warning about ieee80211_tx_control pointers

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index e18305b..cd20abe 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1323,7 +1323,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	pktlen = skb->len;
 
 	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
-		keyidx = ctl->key_idx;
+		keyidx = ctl->hw_key->hw_key_idx;
 		pktlen += ctl->icv_len;
 	}
 
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 19aefbf..8849194 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -235,7 +235,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
 	if (use_encryption) {
-		u8 key_idx = (u16) (txctl->key_idx);
+		u8 key_idx = txctl->hw_key->hw_key_idx;
 		struct b43_key *key;
 		int wlhdr_len;
 		size_t iv_len;
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index dcad249..fc83dab 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -232,7 +232,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
 	if (use_encryption) {
-		u8 key_idx = (u16)(txctl->key_idx);
+		u8 key_idx = txctl->hw_key->hw_key_idx;
 		struct b43legacy_key *key;
 		int wlhdr_len;
 		size_t iv_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a5678f..b1250ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2391,7 +2391,8 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
 				      struct sk_buff *skb_frag,
 				      int last_frag)
 {
-	struct iwl3945_hw_key *keyinfo = &priv->stations[ctl->key_idx].keyinfo;
+	struct iwl3945_hw_key *keyinfo =
+	    &priv->stations[ctl->hw_key->hw_key_idx].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -2414,7 +2415,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
 
 	case ALG_WEP:
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_WEP |
-		    (ctl->key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
+		    (ctl->hw_key->hw_key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
 
 		if (keyinfo->keylen == 13)
 			cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
@@ -2422,7 +2423,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
 		memcpy(&cmd->cmd.tx.key[3], keyinfo->key, keyinfo->keylen);
 
 		IWL_DEBUG_TX("Configuring packet for WEP encryption "
-			     "with key %d\n", ctl->key_idx);
+			     "with key %d\n", ctl->hw_key->hw_key_idx);
 		break;
 
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d7e2358..ae74042 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1936,7 +1936,7 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 	struct iwl_wep_key *wepkey;
 	int keyidx = 0;
 
-	BUG_ON(ctl->key_idx > 3);
+	BUG_ON(ctl->hw_key->hw_key_idx > 3);
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -1955,11 +1955,11 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	case ALG_WEP:
-		wepkey = &priv->wep_keys[ctl->key_idx];
+		wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
 		cmd->cmd.tx.sec_ctl = 0;
 		if (priv->default_wep_key) {
 			/* the WEP key was sent as static */
-			keyidx = ctl->key_idx;
+			keyidx = ctl->hw_key->hw_key_idx;
 			memcpy(&cmd->cmd.tx.key[3], wepkey->key,
 							wepkey->key_size);
 			if (wepkey->key_size == WEP_KEY_LEN_128)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4a80d74..27ef9f7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -286,8 +286,17 @@ enum mac80211_tx_control_flags {
 
 /* Transmit control fields. This data structure is passed to low-level driver
  * with each TX frame. The low-level driver is responsible for configuring
- * the hardware to use given values (depending on what is supported). */
-
+ * the hardware to use given values (depending on what is supported).
+ *
+ * NOTE: Be careful with using the pointers outside of the ieee80211_ops->tx()
+ * context (i.e. when defering the work to a workqueue).
+ * The vif pointer is valid until the it has been removed with the
+ * ieee80211_ops->remove_interface() callback funtion.
+ * The hw_key pointer is valid until it has been removed with the
+ * ieee80211_ops->set_key() callback function.
+ * The tx_rate and alt_retry_rate pointers are valid until the phy is
+ * deregistered.
+ */
 struct ieee80211_tx_control {
 	struct ieee80211_vif *vif;
 	struct ieee80211_rate *tx_rate;
@@ -298,9 +307,11 @@ struct ieee80211_tx_control {
 	/* retry rate for the last retries */
 	struct ieee80211_rate *alt_retry_rate;
 
+	/* Key used for hardware encryption
+	 * NULL if IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
+	struct ieee80211_key_conf *hw_key;
+
 	u32 flags;		/* tx control flags defined above */
-	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
-				 * IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
 	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
 				 * This could be used when set_retry_limit
 				 * is not implemented by the driver */
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index affcecd..3cbae42 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -337,7 +337,7 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
 			return -1;
 	} else {
-		tx->control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->hw_key = &tx->key->conf;
 		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
 			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
 				return -1;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 45709ad..42f3654 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -228,7 +228,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
 					    0x7f),
 				      (u8) key->u.tkip.iv16);
 
-		tx->control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->hw_key = &tx->key->conf;
 		return 0;
 	}
 
@@ -256,7 +256,7 @@ ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for IV/ICV */
-		tx->control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->hw_key = &tx->key->conf;
 		return TX_CONTINUE;
 	}
 
@@ -478,7 +478,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx,
 
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		/* hwaccel - with preallocated room for CCMP header */
-		tx->control->key_idx = key->conf.hw_key_idx;
+		tx->control->hw_key = &tx->key->conf;
 		return 0;
 	}
 
@@ -505,7 +505,7 @@ ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
 		/* hwaccel - with no need for preallocated room for CCMP "
 		 * header or MIC fields */
-		tx->control->key_idx = tx->key->conf.hw_key_idx;
+		tx->control->hw_key = &tx->key->conf;
 		return TX_CONTINUE;
 	}
 
