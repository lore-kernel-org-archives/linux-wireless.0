Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:19665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYCTNIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 09:08:40 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/7 V2] mac80211: allows driver to request a Phase 1 RX key
Date: Thu, 20 Mar 2008 15:06:42 +0200
Message-Id: <1206018403-8308-3-git-send-email-tomas.winkler@intel.com> (sfid-20080320_130851_573343_7D692F74)
In-Reply-To: <1206018403-8308-2-git-send-email-tomas.winkler@intel.com>
References: <1206018403-8308-1-git-send-email-tomas.winkler@intel.com>
 <1206018403-8308-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes mac80211 able to send a phase1 key for TKIP
decryption.
This is needed for drivers that don't do the rekeying by themselves
(i.e. iwlwifi). Upon IV16 wrap around, the packet is decrypted in SW,
if decryption is ok, mac80211 calls to update_tkip_key  with a new
phase 1 RX key.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h |   17 +++++++++++++++++
 net/mac80211/tkip.c    |   15 ++++++++++++++-
 net/mac80211/tkip.h    |    2 +-
 net/mac80211/wpa.c     |    2 +-
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a13458..48428a6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -827,6 +827,16 @@ static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
  * parameter is guaranteed to be valid until another call to set_key()
  * removes it, but it can only be used as a cookie to differentiate
  * keys.
+ *
+ * In TKIP some HW need to be provided a phase 1 key, for RX decryption
+ * acceleration (i.e. iwlwifi). Those drivers should provide update_tkip_key
+ * handler.
+ * The update_tkip_key() call updates the driver with the new phase 1 key.
+ * This happens everytime the iv16 wraps around (every 65536 packets). The
+ * set_key() call will happen only once for each key (unless the AP did
+ * rekeying), it will not include a valid phase 1 key. The valid phase 1 key is
+ * provided by udpate_tkip_key only. The trigger that makes mac80211 call this
+ * handler is software decryption with wrap around of iv16.
  */
 
 /**
@@ -1003,6 +1013,10 @@ enum ieee80211_ampdu_mlme_action {
  *	and remove_interface calls, i.e. while the interface with the
  *	given local_address is enabled.
  *
+ * @update_tkip_key: See the section "Hardware crypto acceleration"
+ * 	This callback will be called in the context of Rx. Called for drivers
+ * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
+ *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack. The scan must honour the channel
  *	configuration done by the regulatory agent in the wiphy's registered
@@ -1094,6 +1108,9 @@ struct ieee80211_ops {
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		       const u8 *local_address, const u8 *address,
 		       struct ieee80211_key_conf *key);
+	void (*update_tkip_key)(struct ieee80211_hw *hw,
+			struct ieee80211_key_conf *conf, const u8 *address,
+			u32 iv32, u16 *phase1key);
 	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 5c36b2d..45d59f1 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -291,7 +291,7 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
-				int only_iv, int queue,
+				u8 *ra, int only_iv, int queue,
 				u32 *out_iv32, u16 *out_iv16)
 {
 	u32 iv32;
@@ -368,6 +368,19 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 			printk("\n");
 		}
 #endif /* CONFIG_TKIP_DEBUG */
+		if (key->local->ops->update_tkip_key &&
+			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+			u8 bcast[ETH_ALEN] =
+				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+			u8 *sta_addr = key->sta->addr;
+
+			if (is_multicast_ether_addr(ra))
+				sta_addr = bcast;
+
+			key->local->ops->update_tkip_key(
+				local_to_hw(key->local), &key->conf,
+				sta_addr, iv32, key->u.tkip.p1k_rx[queue]);
+		}
 	}
 
 	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index 73d8ef2..ffaee32 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -31,7 +31,7 @@ enum {
 int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
-				int only_iv, int queue,
+				u8 *ra, int only_iv, int queue,
 				u32 *out_iv32, u16 *out_iv16);
 
 #endif /* TKIP_H */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index df0b734..45709ad 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -312,7 +312,7 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->addr,
-					  hwaccel, rx->queue,
+					  hdr->addr1, hwaccel, rx->queue,
 					  &rx->tkip_iv32,
 					  &rx->tkip_iv16);
 	if (res != TKIP_DECRYPT_OK || wpa_test) {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

