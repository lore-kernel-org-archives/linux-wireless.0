Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYCMAIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:08:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/5] mac80211: allows driver to request a Phase 1 RX key
Date: Wed, 12 Mar 2008 17:05:59 -0700
Message-Id: <1205366762-12828-3-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000852_304539_6DAF2BDF)
In-Reply-To: <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes mac80211 able to send a phase1 key for TKIP decryption.
This is needed for drivers that don't do the rekeying by themselves
(i.e. iwlwifi). Upon IV16 wrap around, the packet is decrypted in SW, if
decryption is ok, mac80211 calls to set_key with a new phase 1 RX key.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/tkip.c    |   19 +++++++++++++++++--
 net/mac80211/tkip.h    |    1 +
 net/mac80211/wpa.c     |   12 ++++++++++++
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a0c7cd7..3b5d57c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -590,12 +590,20 @@ enum ieee80211_key_alg {
  * @IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY: This flag should be set by
  *	the driver for a TKIP key if it requires a phase2 TX key generation
  *	in SW. The key will be attached to each packet.
+ * @IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY: This flag should be set by the driver
+ *	for a TKIP key if it requires phase 1 key generation in software.
+ *	The phase 1 key will be sent in the same context as Rx.
+ * @IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID: Set by mac80211, valid only when
+ *	IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY was set. When set, the phase 1
+ *	fields (tkip_p1k and tkip_iv32) in ieee80211_key_conf are valid.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
 	IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY = 1<<3,
+	IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY = 1<<4,
+	IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID = 1<<5,
 };
 
 /**
@@ -619,6 +627,8 @@ struct ieee80211_key_conf {
 	u8 flags;
 	s8 keyidx;
 	u8 keylen;
+	u16 tkip_p1k[5];
+	u8 tkip_iv32;
 	u8 key[0];
 };
 
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 18a3fb0..f61f1dd 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -171,7 +171,7 @@ u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key)
 	return pos;
 }
 
-static void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
+void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
@@ -263,7 +263,8 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		return TKIP_DECRYPT_REPLAY;
 	}
 
-	if (only_iv) {
+	if (only_iv &&
+		!(key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY)) {
 		res = TKIP_DECRYPT_OK;
 		key->u.tkip.rx_initialized[queue] = 1;
 		goto done;
@@ -275,6 +276,14 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 				   iv32, key->u.tkip.p1k_rx[queue]);
+		if (key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY) {
+			/* The driver needs a phase 1 key, provide it */
+			memcpy(&key->conf.tkip_p1k,
+				&key->u.tkip.p1k_rx[queue],
+				sizeof(key->conf.tkip_p1k));
+			key->conf.tkip_iv32 = iv32;
+			key->conf.flags |= IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID;
+		}
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
@@ -294,6 +303,12 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 #endif /* CONFIG_TKIP_DEBUG */
 	}
 
+	if (only_iv) {
+		res = TKIP_DECRYPT_OK;
+		key->u.tkip.rx_initialized[queue] = 1;
+		goto done;
+	}
+
 	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   iv16, rc4key);
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index 662354b..9a07102 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -14,6 +14,7 @@
 #include "ieee80211_key.h"
 
 u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key);
+void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta, u8 *rc4key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index ee9c5cf..478251b 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -324,6 +324,18 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_UNUSABLE;
 	}
 
+	if (key->conf.flags & IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID) {
+		u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+		u8 *sta_addr = rx->sta->addr;
+
+		if (is_multicast_ether_addr(hdr->addr1))
+			sta_addr = bcast;
+
+		rx->local->ops->set_key(local_to_hw(rx->local),
+			SET_KEY, rx->dev->dev_addr, sta_addr, &key->conf);
+		key->conf.flags &= ~IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID;
+	}
+
 	/* Trim ICV */
 	skb_trim(skb, skb->len - TKIP_ICV_LEN);
 
-- 
1.5.3.4

