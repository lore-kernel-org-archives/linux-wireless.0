Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48780 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYI3JqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 05:46:11 -0400
Received: from 16.121.113.82.net.de.o2.com ([82.113.121.16] helo=pi.local)
	by ds10.mine.nu with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <nbd@openwrt.org>)
	id 1Kkbny-0003Dc-1B
	for linux-wireless@vger.kernel.org; Tue, 30 Sep 2008 11:46:08 +0200
Message-ID: <48E1F554.5030700@openwrt.org> (sfid-20080930_114621_415973_341ED20E)
Date: Tue, 30 Sep 2008 11:45:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: change rate control API to allow multi-rate
 retry
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adjusts the rate control API to allow multi-rate retry
if supported by the driver. The ieee80211_hw struct specifies how
many alternate rate selections the driver supports.
Moves iv_len and icv_len out of the CB into ieee80211_key_conf
to make room for the extra rate retry data.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -292,6 +292,20 @@
 #define IEEE80211_TX_INFO_DRIVER_DATA_PTRS \
 	(IEEE80211_TX_INFO_DRIVER_DATA_SIZE / sizeof(void *))
 
+/* maximum number of alternate rate retry stages */
+#define IEEE80211_TX_MAX_ALTRATE	3
+
+/**
+ * struct ieee80211_tx_altrate - alternate rate selection/status
+ *
+ * @rate_idx: rate index to attempt to send with
+ * @limit: number of retries before fallback
+ */
+struct ieee80211_tx_altrate {
+	s8 rate_idx;
+	u8 limit;
+};
+
 /**
  * struct ieee80211_tx_info - skb transmit information
  *
@@ -335,14 +349,14 @@
 			struct ieee80211_key_conf *hw_key;
 			struct ieee80211_sta *sta;
 			unsigned long jiffies;
-			s8 rts_cts_rate_idx, alt_retry_rate_idx;
+			s8 rts_cts_rate_idx;
 			u8 retry_limit;
-			u8 icv_len;
-			u8 iv_len;
+			struct ieee80211_tx_altrate retries[IEEE80211_TX_MAX_ALTRATE];
 		} control;
 		struct {
 			u64 ampdu_ack_map;
 			int ack_signal;
+			struct ieee80211_tx_altrate retries[IEEE80211_TX_MAX_ALTRATE + 1];
 			u8 retry_count;
 			bool excessive_retries;
 			u8 ampdu_ack_len;
@@ -635,6 +649,8 @@
  */
 struct ieee80211_key_conf {
 	enum ieee80211_key_alg alg;
+	u8 icv_len;
+	u8 iv_len;
 	u8 hw_key_idx;
 	u8 flags;
 	s8 keyidx;
@@ -828,6 +844,9 @@
  *	within &struct ieee80211_vif.
  * @sta_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_sta.
+ *
+ * @max_altrates: maximum number of alternate rate retry stages
+ * @max_altrate_tries: maximum number of tries for each stage
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -844,6 +863,8 @@
 	u16 ampdu_queues;
 	u16 max_listen_interval;
 	s8 max_signal;
+	u8 max_altrates;
+	u8 max_altrate_tries;
 };
 
 struct ieee80211_hw *wiphy_to_hw(struct wiphy *wiphy);
@@ -900,11 +921,11 @@
 
 static inline struct ieee80211_rate *
 ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
-			     const struct ieee80211_tx_info *c)
+			     const struct ieee80211_tx_info *c, int idx)
 {
-	if (c->control.alt_retry_rate_idx < 0)
+	if (c->control.retries[idx].rate_idx < 0)
 		return NULL;
-	return &hw->wiphy->bands[c->band]->bitrates[c->control.alt_retry_rate_idx];
+	return &hw->wiphy->bands[c->band]->bitrates[c->control.retries[idx].rate_idx];
 }
 
 /**
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -208,7 +208,7 @@
 	txrate = ieee80211_get_tx_rate(dev->wl->hw, info);
 	rate = txrate ? txrate->hw_value : B43_CCK_RATE_1MB;
 	rate_ofdm = b43_is_ofdm_rate(rate);
-	fbrate = ieee80211_get_alt_retry_rate(dev->wl->hw, info) ? : txrate;
+	fbrate = ieee80211_get_alt_retry_rate(dev->wl->hw, info, 0) ? : txrate;
 	rate_fb = fbrate->hw_value;
 	rate_fb_ofdm = b43_is_ofdm_rate(rate_fb);
 
@@ -252,7 +252,7 @@
 		}
 
 		/* Hardware appends ICV. */
-		plcp_fragment_len += info->control.icv_len;
+		plcp_fragment_len += info->control.hw_key->icv_len;
 
 		key_idx = b43_kidx_to_fw(dev, key_idx);
 		mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
@@ -260,7 +260,7 @@
 		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
 			   B43_TXH_MAC_KEYALG;
 		wlhdr_len = ieee80211_hdrlen(fctl);
-		iv_len = min((size_t) info->control.iv_len,
+		iv_len = min((size_t) info->control.hw_key->iv_len,
 			     ARRAY_SIZE(txhdr->iv));
 		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
 	}
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -210,7 +210,7 @@
 
 	rate = tx_rate->hw_value;
 	rate_ofdm = b43legacy_is_ofdm_rate(rate);
-	rate_fb = ieee80211_get_alt_retry_rate(dev->wl->hw, info) ? : tx_rate;
+	rate_fb = ieee80211_get_alt_retry_rate(dev->wl->hw, info, 0) ? : tx_rate;
 	rate_fb_ofdm = b43legacy_is_ofdm_rate(rate_fb->hw_value);
 
 	txhdr->mac_frame_ctl = wlhdr->frame_control;
@@ -243,7 +243,7 @@
 
 		if (key->enabled) {
 			/* Hardware appends ICV. */
-			plcp_fragment_len += info->control.icv_len;
+			plcp_fragment_len += info->control.hw_key->icv_len;
 
 			key_idx = b43legacy_kidx_to_fw(dev, key_idx);
 			mac_ctl |= (key_idx << B43legacy_TX4_MAC_KEYIDX_SHIFT) &
@@ -252,7 +252,7 @@
 				   B43legacy_TX4_MAC_KEYALG_SHIFT) &
 				   B43legacy_TX4_MAC_KEYALG;
 			wlhdr_len = ieee80211_hdrlen(wlhdr->frame_control);
-			iv_len = min((size_t)info->control.iv_len,
+			iv_len = min((size_t)info->control.hw_key->iv_len,
 				     ARRAY_SIZE(txhdr->iv));
 			memcpy(txhdr->iv, ((u8 *)wlhdr) + wlhdr_len, iv_len);
 		} else {
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -292,8 +292,8 @@
 	entry->plcp_len = cpu_to_le16(plcp_len);
 	entry->tx_buf = cpu_to_le32(mapping);
 	entry->frame_len = cpu_to_le32(skb->len);
-	entry->flags2 = info->control.alt_retry_rate_idx >= 0 ?
-		ieee80211_get_alt_retry_rate(dev, info)->bitrate << 4 : 0;
+	entry->flags2 = info->control.retries[0].rate_idx >= 0 ?
+		ieee80211_get_alt_retry_rate(dev, info, 0)->bitrate << 4 : 0;
 	entry->retry_limit = info->control.retry_limit;
 	entry->flags = cpu_to_le32(tx_flags);
 	__skb_queue_tail(&ring->queue, skb);
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -454,15 +454,16 @@
 		if (unlikely(rsel.probe_idx >= 0)) {
 			info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 			tx->flags |= IEEE80211_TX_PROBE_LAST_FRAG;
-			info->control.alt_retry_rate_idx = tx->rate_idx;
+			info->control.retries[0].rate_idx = tx->rate_idx;
+			info->control.retries[0].limit = tx->local->hw.max_altrate_tries;
 			tx->rate_idx = rsel.probe_idx;
-		} else
-			info->control.alt_retry_rate_idx = -1;
+		} else if (info->control.retries[0].limit == 0)
+			info->control.retries[0].rate_idx = -1;
 
 		if (unlikely(tx->rate_idx < 0))
 			return TX_DROP;
 	} else
-		info->control.alt_retry_rate_idx = -1;
+		info->control.retries[0].rate_idx = -1;
 
 	if (tx->sdata->bss_conf.use_cts_prot &&
 	    (tx->flags & IEEE80211_TX_FRAGMENTED) && (rsel.nonerp_idx >= 0)) {
@@ -521,7 +522,7 @@
 		 * frames.
 		 * TODO: The last fragment could still use multiple retry
 		 * rates. */
-		info->control.alt_retry_rate_idx = -1;
+		info->control.retries[0].rate_idx = -1;
 	}
 
 	/* Use CTS protection for unicast frames sent using extended rates if
@@ -551,7 +552,7 @@
 		int idx;
 
 		/* Do not use multiple retry rates when using RTS/CTS */
-		info->control.alt_retry_rate_idx = -1;
+		info->control.retries[0].rate_idx = -1;
 
 		/* Use min(data rate, max base rate) as CTS/RTS rate */
 		rate = &sband->bitrates[tx->rate_idx];
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -313,8 +313,8 @@
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	info->control.iv_len = WEP_IV_LEN;
-	info->control.icv_len = WEP_ICV_LEN;
+	info->control.hw_key->iv_len = WEP_IV_LEN;
+	info->control.hw_key->icv_len = WEP_ICV_LEN;
 
 	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -152,8 +152,8 @@
 	int len, tail;
 	u8 *pos;
 
-	info->control.icv_len = TKIP_ICV_LEN;
-	info->control.iv_len = TKIP_IV_LEN;
+	info->control.hw_key->icv_len = TKIP_ICV_LEN;
+	info->control.hw_key->iv_len = TKIP_IV_LEN;
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
@@ -374,8 +374,8 @@
 	u8 *pos, *pn;
 	int i;
 
-	info->control.icv_len = CCMP_MIC_LEN;
-	info->control.iv_len = CCMP_HDR_LEN;
+	info->control.hw_key->icv_len = CCMP_MIC_LEN;
+	info->control.hw_key->iv_len = CCMP_HDR_LEN;
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1164,7 +1164,7 @@
 
 	if (info->control.hw_key) {
 		keyidx = info->control.hw_key->hw_key_idx;
-		pktlen += info->control.icv_len;
+		pktlen += info->control.hw_key->icv_len;
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -237,7 +237,7 @@
 
 	if (tx_info->control.hw_key) {
 		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
-		txctl->frmlen += tx_info->control.icv_len;
+		txctl->frmlen += tx_info->control.hw_key->icv_len;
 
 		if (tx_info->control.hw_key->alg == ALG_WEP)
 			txctl->keytype = ATH9K_KEY_TYPE_WEP;
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -56,10 +56,10 @@
 	 * note that these lengths should only be added when
 	 * mac80211 does not generate it.
 	 */
-	overhead += tx_info->control.icv_len;
+	overhead += tx_info->control.hw_key->icv_len;
 
 	if (!(key->flags & IEEE80211_KEY_FLAG_GENERATE_IV))
-		overhead += tx_info->control.iv_len;
+		overhead += tx_info->control.hw_key->iv_len;
 
 	if (!(key->flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
 		if (key->alg == ALG_TKIP)
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -374,7 +374,7 @@
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
-	unsigned int iv_len = IEEE80211_SKB_CB(skb)->control.iv_len;
+	unsigned int iv_len = IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;
 
 	if (unlikely(rt2x00queue_full(queue)))
 		return -EINVAL;
