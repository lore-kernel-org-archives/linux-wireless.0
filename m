Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161145AbYCSXtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5/7] mac80211: allows driver to request a Phase 1 RX key
Date: Wed, 19 Mar 2008 16:41:44 -0700
Message-Id: <1205970106-22196-6-git-send-email-reinette.chatre@intel.com> (sfid-20080319_235024_178688_DCE9AFA5)
In-Reply-To: <1205970106-22196-5-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-2-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-4-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-5-git-send-email-reinette.chatre@intel.com>
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
 include/net/mac80211.h |   27 ++++++++++++++++++++++++---
 net/mac80211/tkip.c    |   16 +++++++++++++++-
 net/mac80211/tkip.h    |    2 +-
 net/mac80211/wpa.c     |    2 +-
 4 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4b35f64..d3e2337 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -586,11 +586,15 @@ enum ieee80211_key_alg {
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
+ * @IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY: This flag should bet by
+ * 	the driver for a TKIP key if it requires phase 1 key generation
+ * 	in SW.
  */
 enum ieee80211_key_flags {
-	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
-	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
-	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
+	IEEE80211_KEY_FLAG_WMM_STA		= 1<<0,
+	IEEE80211_KEY_FLAG_GENERATE_IV		= 1<<1,
+	IEEE80211_KEY_FLAG_GENERATE_MMIC	= 1<<2,
+	IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY	= 1<<3,
 };
 
 /**
@@ -827,6 +831,16 @@ static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
  * parameter is guaranteed to be valid until another call to set_key()
  * removes it, but it can only be used as a cookie to differentiate
  * keys.
+ *
+ * In TKIP some HW need to be provided a phase 1 key, for RX decryption
+ * acceleration (i.e. iwlwifi). Those drivers should set
+ * IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
+ * The update_tkip_key() call updates the driver with the new phase 1 key.
+ * This happens everytime the iv16 wraps around (every 65536 packets). The
+ * set_key() call will happen only once during a rekeying session, it will not
+ * include a valid phase 1 key. The valid phase 1 key is provided by
+ * udpate_tkip_key only. The trigger that makes mac80211 call this handler is
+ * software decryption with wrap around of iv16.
  */
 
 /**
@@ -1003,6 +1017,10 @@ enum ieee80211_ampdu_mlme_action {
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
@@ -1094,6 +1112,9 @@ struct ieee80211_ops {
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
index 5c36b2d..94d4f1b 100644
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
@@ -368,6 +368,20 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 			printk("\n");
 		}
 #endif /* CONFIG_TKIP_DEBUG */
+		if (key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY) {
+			u8 bcast[ETH_ALEN] =
+				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+			u8 *sta_addr = key->sta->addr;
+
+			BUG_ON(!key->local->ops->update_tkip_key);
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
1.5.3.4

