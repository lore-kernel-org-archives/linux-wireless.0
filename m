Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43300 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYI3BiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 21:38:19 -0400
Received: from 16.106.113.82.net.de.o2.com ([82.113.106.16] helo=pi.local)
	by ds10.mine.nu with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <nbd@openwrt.org>)
	id 1KkTt9-0005zi-31
	for linux-wireless@vger.kernel.org; Tue, 30 Sep 2008 03:18:57 +0200
Message-ID: <48E17E75.50201@openwrt.org> (sfid-20080930_033823_737779_1604EF6A)
Date: Tue, 30 Sep 2008 03:18:45 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH RFC] mac80211: change rate control API to allow multi-rate
 retry
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adjusts the rate control API to allow multi-rate retry
if supported by the driver. The ieee80211_hw struct specifies how
many alternate rate selections the driver supports.

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
@@ -335,14 +349,16 @@
 			struct ieee80211_key_conf *hw_key;
 			struct ieee80211_sta *sta;
 			unsigned long jiffies;
-			s8 rts_cts_rate_idx, alt_retry_rate_idx;
+			s8 rts_cts_rate_idx;
 			u8 retry_limit;
 			u8 icv_len;
 			u8 iv_len;
+			struct ieee80211_tx_altrate retries[IEEE80211_TX_MAX_ALTRATE];
 		} control;
 		struct {
 			u64 ampdu_ack_map;
 			int ack_signal;
+			struct ieee80211_tx_altrate retries[IEEE80211_TX_MAX_ALTRATE + 1];
 			u8 retry_count;
 			bool excessive_retries;
 			u8 ampdu_ack_len;
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
 
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -210,7 +210,7 @@
 
 	rate = tx_rate->hw_value;
 	rate_ofdm = b43legacy_is_ofdm_rate(rate);
-	rate_fb = ieee80211_get_alt_retry_rate(dev->wl->hw, info) ? : tx_rate;
+	rate_fb = ieee80211_get_alt_retry_rate(dev->wl->hw, info, 0) ? : tx_rate;
 	rate_fb_ofdm = b43legacy_is_ofdm_rate(rate_fb->hw_value);
 
 	txhdr->mac_frame_ctl = wlhdr->frame_control;
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
