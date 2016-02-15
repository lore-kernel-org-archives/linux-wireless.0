Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbcBOKeP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 05:34:15 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3 v2] mac80211: remove ieee80211_get_key_tx_seq/ieee80211_set_key_tx_seq
Date: Mon, 15 Feb 2016 12:34:10 +0200
Message-Id: <1455532450-18364-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160215_113426_563550_93A81635)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Since the PNs of all the tx keys are now tracked in the public
part of the key struct (with atomic counter), we no longer
need these functions.

dvm and vt665{5,6} are currently the only users of these functions,
so update them accordingly.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: fix vt6655 and vt6656
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 20 +++----
 drivers/staging/vt6655/rxtx.c                | 12 ++--
 drivers/staging/vt6656/rxtx.c                | 12 ++--
 include/net/mac80211.h                       | 34 -----------
 net/mac80211/key.c                           | 87 ----------------------------
 5 files changed, 24 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 4841be2..1799469 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -943,14 +943,16 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
 		if (sta) {
+			u64 pn64;
+
 			tkip_sc = data->rsc_tsc->all_tsc_rsc.tkip.unicast_rsc;
 			tkip_tx_sc = &data->rsc_tsc->all_tsc_rsc.tkip.tsc;
 
 			rx_p1ks = data->tkip->rx_uni;
 
-			ieee80211_get_key_tx_seq(key, &seq);
-			tkip_tx_sc->iv16 = cpu_to_le16(seq.tkip.iv16);
-			tkip_tx_sc->iv32 = cpu_to_le32(seq.tkip.iv32);
+			pn64 = atomic64_read(&key->tx_pn);
+			tkip_tx_sc->iv16 = cpu_to_le16(TKIP_PN_TO_IV16(pn64));
+			tkip_tx_sc->iv32 = cpu_to_le32(TKIP_PN_TO_IV32(pn64));
 
 			ieee80211_get_tkip_p1k_iv(key, seq.tkip.iv32, p1k);
 			iwlagn_convert_p1k(p1k, data->tkip->tx.p1k);
@@ -996,19 +998,13 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (sta) {
-			u8 *pn = seq.ccmp.pn;
+			u64 pn64;
 
 			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.unicast_rsc;
 			aes_tx_sc = &data->rsc_tsc->all_tsc_rsc.aes.tsc;
 
-			ieee80211_get_key_tx_seq(key, &seq);
-			aes_tx_sc->pn = cpu_to_le64(
-					(u64)pn[5] |
-					((u64)pn[4] << 8) |
-					((u64)pn[3] << 16) |
-					((u64)pn[2] << 24) |
-					((u64)pn[1] << 32) |
-					((u64)pn[0] << 40));
+			pn64 = atomic64_read(&key->tx_pn);
+			aes_tx_sc->pn = cpu_to_le64(pn64);
 		} else
 			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.multicast_rsc;
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index b668db6..1a2dda0 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1210,7 +1210,7 @@ static void vnt_fill_txkey(struct ieee80211_hdr *hdr, u8 *key_buffer,
 			   struct sk_buff *skb,	u16 payload_len,
 			   struct vnt_mic_hdr *mic_hdr)
 {
-	struct ieee80211_key_seq seq;
+	u64 pn64;
 	u8 *iv = ((u8 *)hdr + ieee80211_get_hdrlen_from_skb(skb));
 
 	/* strip header and icv len from payload */
@@ -1243,9 +1243,13 @@ static void vnt_fill_txkey(struct ieee80211_hdr *hdr, u8 *key_buffer,
 		mic_hdr->payload_len = cpu_to_be16(payload_len);
 		ether_addr_copy(mic_hdr->mic_addr2, hdr->addr2);
 
-		ieee80211_get_key_tx_seq(tx_key, &seq);
-
-		memcpy(mic_hdr->ccmp_pn, seq.ccmp.pn, IEEE80211_CCMP_PN_LEN);
+		pn64 = atomic64_read(&tx_key->tx_pn);
+		mic_hdr->ccmp_pn[5] = pn64;
+		mic_hdr->ccmp_pn[4] = pn64 >> 8;
+		mic_hdr->ccmp_pn[3] = pn64 >> 16;
+		mic_hdr->ccmp_pn[2] = pn64 >> 24;
+		mic_hdr->ccmp_pn[1] = pn64 >> 32;
+		mic_hdr->ccmp_pn[0] = pn64 >> 40;
 
 		if (ieee80211_has_a4(hdr->frame_control))
 			mic_hdr->hlen = cpu_to_be16(28);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index efb54f5..76378d2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -719,7 +719,7 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
 	u16 payload_len, struct vnt_mic_hdr *mic_hdr)
 {
 	struct ieee80211_hdr *hdr = tx_context->hdr;
-	struct ieee80211_key_seq seq;
+	u64 pn64;
 	u8 *iv = ((u8 *)hdr + ieee80211_get_hdrlen_from_skb(skb));
 
 	/* strip header and icv len from payload */
@@ -752,9 +752,13 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
 		mic_hdr->payload_len = cpu_to_be16(payload_len);
 		ether_addr_copy(mic_hdr->mic_addr2, hdr->addr2);
 
-		ieee80211_get_key_tx_seq(tx_key, &seq);
-
-		memcpy(mic_hdr->ccmp_pn, seq.ccmp.pn, IEEE80211_CCMP_PN_LEN);
+		pn64 = atomic64_read(&tx_key->tx_pn);
+		mic_hdr->ccmp_pn[5] = pn64;
+		mic_hdr->ccmp_pn[4] = pn64 >> 8;
+		mic_hdr->ccmp_pn[3] = pn64 >> 16;
+		mic_hdr->ccmp_pn[2] = pn64 >> 24;
+		mic_hdr->ccmp_pn[1] = pn64 >> 32;
+		mic_hdr->ccmp_pn[0] = pn64 >> 40;
 
 		if (ieee80211_has_a4(hdr->frame_control))
 			mic_hdr->hlen = cpu_to_be16(28);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 15879b4..66155d3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4464,23 +4464,6 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key_conf *keyconf, u64 pn);
 
 /**
- * ieee80211_get_key_tx_seq - get key TX sequence counter
- *
- * @keyconf: the parameter passed with the set key
- * @seq: buffer to receive the sequence data
- *
- * This function allows a driver to retrieve the current TX IV/PN
- * for the given key. It must not be called if IV generation is
- * offloaded to the device.
- *
- * Note that this function may only be called when no TX processing
- * can be done concurrently, for example when queues are stopped
- * and the stop has been synchronized.
- */
-void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
-			      struct ieee80211_key_seq *seq);
-
-/**
  * ieee80211_get_key_rx_seq - get key RX sequence counter
  *
  * @keyconf: the parameter passed with the set key
@@ -4500,23 +4483,6 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 			      int tid, struct ieee80211_key_seq *seq);
 
 /**
- * ieee80211_set_key_tx_seq - set key TX sequence counter
- *
- * @keyconf: the parameter passed with the set key
- * @seq: new sequence data
- *
- * This function allows a driver to set the current TX IV/PNs for the
- * given key. This is useful when resuming from WoWLAN sleep and the
- * device may have transmitted frames using the PTK, e.g. replies to
- * ARP requests.
- *
- * Note that this function may only be called when no TX processing
- * can be done concurrently.
- */
-void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
-			      struct ieee80211_key_seq *seq);
-
-/**
  * ieee80211_set_key_rx_seq - set key RX sequence counter
  *
  * @keyconf: the parameter passed with the set key
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f9c4cb9..3df7b03 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -932,51 +932,6 @@ void ieee80211_gtk_rekey_notify(struct ieee80211_vif *vif, const u8 *bssid,
 }
 EXPORT_SYMBOL_GPL(ieee80211_gtk_rekey_notify);
 
-void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
-			      struct ieee80211_key_seq *seq)
-{
-	struct ieee80211_key *key;
-	u64 pn64;
-
-	if (WARN_ON(!(keyconf->flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
-		return;
-
-	key = container_of(keyconf, struct ieee80211_key, conf);
-
-	switch (key->conf.cipher) {
-	case WLAN_CIPHER_SUITE_TKIP:
-		pn64 = atomic64_read(&key->conf.tx_pn);
-		seq->tkip.iv32 = TKIP_PN_TO_IV32(pn64);
-		seq->tkip.iv16 = TKIP_PN_TO_IV16(pn64);
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-	case WLAN_CIPHER_SUITE_CCMP_256:
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
-			     offsetof(typeof(*seq), aes_cmac));
-	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
-	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
-			     offsetof(typeof(*seq), aes_gmac));
-	case WLAN_CIPHER_SUITE_GCMP:
-	case WLAN_CIPHER_SUITE_GCMP_256:
-		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
-			     offsetof(typeof(*seq), gcmp));
-		pn64 = atomic64_read(&key->conf.tx_pn);
-		seq->ccmp.pn[5] = pn64;
-		seq->ccmp.pn[4] = pn64 >> 8;
-		seq->ccmp.pn[3] = pn64 >> 16;
-		seq->ccmp.pn[2] = pn64 >> 24;
-		seq->ccmp.pn[1] = pn64 >> 32;
-		seq->ccmp.pn[0] = pn64 >> 40;
-		break;
-	default:
-		WARN_ON(1);
-	}
-}
-EXPORT_SYMBOL(ieee80211_get_key_tx_seq);
-
 void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 			      int tid, struct ieee80211_key_seq *seq)
 {
@@ -1030,48 +985,6 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 }
 EXPORT_SYMBOL(ieee80211_get_key_rx_seq);
 
-void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
-			      struct ieee80211_key_seq *seq)
-{
-	struct ieee80211_key *key;
-	u64 pn64;
-
-	key = container_of(keyconf, struct ieee80211_key, conf);
-
-	switch (key->conf.cipher) {
-	case WLAN_CIPHER_SUITE_TKIP:
-		pn64 = (u64)seq->tkip.iv16 | ((u64)seq->tkip.iv32 << 16);
-		atomic64_set(&key->conf.tx_pn, pn64);
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-	case WLAN_CIPHER_SUITE_CCMP_256:
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
-			     offsetof(typeof(*seq), aes_cmac));
-	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
-	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
-		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
-			     offsetof(typeof(*seq), aes_gmac));
-	case WLAN_CIPHER_SUITE_GCMP:
-	case WLAN_CIPHER_SUITE_GCMP_256:
-		BUILD_BUG_ON(offsetof(typeof(*seq), ccmp) !=
-			     offsetof(typeof(*seq), gcmp));
-		pn64 = (u64)seq->ccmp.pn[5] |
-		       ((u64)seq->ccmp.pn[4] << 8) |
-		       ((u64)seq->ccmp.pn[3] << 16) |
-		       ((u64)seq->ccmp.pn[2] << 24) |
-		       ((u64)seq->ccmp.pn[1] << 32) |
-		       ((u64)seq->ccmp.pn[0] << 40);
-		atomic64_set(&key->conf.tx_pn, pn64);
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(ieee80211_set_key_tx_seq);
-
 void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
 			      int tid, struct ieee80211_key_seq *seq)
 {
-- 
2.5.0

