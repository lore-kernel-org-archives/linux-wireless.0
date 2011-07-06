Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1GFMNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 08:13:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QeQz4-0004CJ-Rf
	for linux-wireless@vger.kernel.org; Wed, 06 Jul 2011 14:13:38 +0200
Message-Id: <20110706121315.215752759@sipsolutions.net> (sfid-20110706_141342_555231_9BAC1052)
Date: Wed, 06 Jul 2011 14:12:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: allow drivers to access key sequence counter
References: <20110706121236.333408679@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to implement GTK rekeying, the device
needs to be able to encrypt frames with the
right PN/IV.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   58 ++++++++++++++++++++++++++++++++++++++++
 net/mac80211/key.c     |   70 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/key.h     |    7 ++--
 3 files changed, 132 insertions(+), 3 deletions(-)

--- a/include/net/mac80211.h	2011-07-06 12:45:34.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-06 12:45:35.000000000 +0200
@@ -2592,6 +2592,64 @@ void ieee80211_get_tkip_p2k(struct ieee8
 			    struct sk_buff *skb, u8 *p2k);
 
 /**
+ * struct ieee80211_key_seq - key sequence counter
+ *
+ * @tkip: TKIP data, containing IV32 and IV16 in host byte order
+ * @ccmp: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
+ * @aes_cmac: PN data, most significant byte first (big endian,
+ *	reverse order than in packet)
+ */
+struct ieee80211_key_seq {
+	union {
+		struct {
+			u32 iv32;
+			u16 iv16;
+		} tkip;
+		struct {
+			u8 pn[6];
+		} ccmp;
+		struct {
+			u8 pn[6];
+		} aes_cmac;
+	};
+};
+
+/**
+ * ieee80211_get_key_tx_seq - get key TX sequence counter
+ *
+ * @keyconf: the parameter passed with the set key
+ * @seq: buffer to receive the sequence data
+ *
+ * This function allows a driver to retrieve the current TX IV/PN
+ * for the given key. It must not be called if IV generation is
+ * offloaded to the device.
+ *
+ * Note that this function may only be called when no TX processing
+ * can be done concurrently, for example when queues are stopped
+ * and the stop has been synchronized.
+ */
+void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
+			      struct ieee80211_key_seq *seq);
+
+/**
+ * ieee80211_get_key_rx_seq - get key RX sequence counter
+ *
+ * @keyconf: the parameter passed with the set key
+ * @tid: the TID, or -1 for the non-QoS value
+ * @seq: buffer to receive the sequence data
+ *
+ * This function allows a driver to retrieve the current RX IV/PNs
+ * for the given key. It must not be called if IV checking is done
+ * by the device and not by mac80211.
+ *
+ * Note that this function may only be called when no RX processing
+ * can be done concurrently.
+ */
+void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
+			      s8 tid, struct ieee80211_key_seq *seq);
+
+/**
  * ieee80211_gtk_rekey_notify - notify userspace supplicant of rekeying
  * @vif: virtual interface the rekeying was done on
  * @bssid: The BSSID of the AP, for checking association
--- a/net/mac80211/key.c	2011-07-06 12:45:34.000000000 +0200
+++ b/net/mac80211/key.c	2011-07-06 12:45:35.000000000 +0200
@@ -579,3 +579,73 @@ void ieee80211_gtk_rekey_notify(struct i
 	cfg80211_gtk_rekey_notify(sdata->dev, bssid, replay_ctr, gfp);
 }
 EXPORT_SYMBOL_GPL(ieee80211_gtk_rekey_notify);
+
+void ieee80211_get_key_tx_seq(struct ieee80211_key_conf *keyconf,
+			      struct ieee80211_key_seq *seq)
+{
+	struct ieee80211_key *key;
+	u64 pn64;
+
+	if (WARN_ON(!(keyconf->flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+		return;
+
+	key = container_of(keyconf, struct ieee80211_key, conf);
+
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		seq->tkip.iv32 = key->u.tkip.tx.iv32;
+		seq->tkip.iv16 = key->u.tkip.tx.iv16;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		pn64 = atomic64_read(&key->u.ccmp.tx_pn);
+		seq->ccmp.pn[5] = pn64;
+		seq->ccmp.pn[4] = pn64 >> 8;
+		seq->ccmp.pn[3] = pn64 >> 16;
+		seq->ccmp.pn[2] = pn64 >> 24;
+		seq->ccmp.pn[1] = pn64 >> 32;
+		seq->ccmp.pn[0] = pn64 >> 40;
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		memcpy(seq->aes_cmac.pn, key->u.aes_cmac.tx_pn, CMAC_PN_LEN);
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+EXPORT_SYMBOL(ieee80211_get_key_tx_seq);
+
+void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
+			      s8 tid, struct ieee80211_key_seq *seq)
+{
+	struct ieee80211_key *key;
+	const u8 *pn;
+
+	if (WARN_ON(tid < -1 || tid > 15))
+		return;
+
+	key = container_of(keyconf, struct ieee80211_key, conf);
+
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		if (tid < 0) {
+			seq->tkip.iv32 = key->u.tkip.rx[16].iv32;
+			seq->tkip.iv16 = key->u.tkip.rx[16].iv16;
+		} else {
+			seq->tkip.iv32 = key->u.tkip.rx[tid].iv32;
+			seq->tkip.iv16 = key->u.tkip.rx[tid].iv16;
+		}
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		if (tid < 0)
+			pn = key->u.ccmp.rx_pn[16];
+		else
+			pn = key->u.ccmp.rx_pn[tid];
+		memcpy(seq->ccmp.pn, pn, CCMP_PN_LEN);
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		pn = key->u.aes_cmac.rx_pn;
+		memcpy(seq->aes_cmac.pn, pn, CMAC_PN_LEN);
+		break;
+	}
+}
+EXPORT_SYMBOL(ieee80211_get_key_rx_seq);
--- a/net/mac80211/key.h	2011-07-06 12:45:35.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-06 12:45:35.000000000 +0200
@@ -28,6 +28,7 @@
 #define CCMP_PN_LEN		6
 #define TKIP_IV_LEN		8
 #define TKIP_ICV_LEN		4
+#define CMAC_PN_LEN		6
 
 #define NUM_RX_DATA_QUEUES	17
 
@@ -89,7 +90,7 @@ struct ieee80211_key {
 			 * frames and the last counter is used with Robust
 			 * Management frames.
 			 */
-			u8 rx_pn[NUM_RX_DATA_QUEUES + 1][6];
+			u8 rx_pn[NUM_RX_DATA_QUEUES + 1][CCMP_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 			/* scratch buffers for virt_to_page() (crypto API) */
@@ -100,8 +101,8 @@ struct ieee80211_key {
 			u8 rx_crypto_buf[6 * AES_BLOCK_LEN];
 		} ccmp;
 		struct {
-			u8 tx_pn[6];
-			u8 rx_pn[6];
+			u8 tx_pn[CMAC_PN_LEN];
+			u8 rx_pn[CMAC_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */


