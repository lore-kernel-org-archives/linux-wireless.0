Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23987 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab0CBJ0O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 04:26:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 01:26:14 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.56857.751904.751288@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 15:14:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k_htc: Remove library
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ath9k_common.ko to share code between ath9k and ath9k_htc.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig        |    1 +
 drivers/net/wireless/ath/ath9k/Makefile       |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h        |   33 +--
 drivers/net/wireless/ath/ath9k/common.c       |  410 +++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/common.h       |   41 ++-
 drivers/net/wireless/ath/ath9k/htc.h          |    5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   82 ++++-
 drivers/net/wireless/ath/ath9k/lib.c          |  487 -------------------------
 drivers/net/wireless/ath/ath9k/lib.h          |   85 -----
 drivers/net/wireless/ath/ath9k/main.c         |   87 +-----
 drivers/net/wireless/ath/ath9k/virtual.c      |    2 +-
 12 files changed, 509 insertions(+), 729 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath9k/lib.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/lib.h

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index fd28803..35f23bd 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -39,6 +39,7 @@ config ATH9K_HTC
        select MAC80211_LEDS
        select LEDS_CLASS
        select NEW_LEDS
+       select ATH9K_COMMON
        ---help---
 	 Support for Atheros HTC based cards.
 	 Chipsets supported: AR9271
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index b1af5d5..97133be 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -35,7 +35,6 @@ ath9k_htc-y +=	htc_hst.o \
 		htc_drv_txrx.o \
 		htc_drv_main.o \
 		htc_drv_beacon.o \
-		htc_drv_init.o \
-		lib.o
+		htc_drv_init.o
 
 obj-$(CONFIG_ATH9K_HTC) += ath9k_htc.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 83c7ea4..c18d1e1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -55,9 +55,6 @@ struct ath_node;
 
 #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
 
-#define TSF_TO_TU(_h,_l) \
-	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
-
 #define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
 
 struct ath_config {
@@ -294,8 +291,6 @@ struct ath_vif {
 #define BSTUCK_THRESH           	(9 * ATH_BCBUF)
 #define	ATH_BCBUF               	4
 #define ATH_DEFAULT_BINTVAL     	100 /* TU */
-#define ATH_DEFAULT_BMISS_LIMIT 	10
-#define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
 struct ath_beacon_config {
 	u16 beacon_interval;
@@ -332,18 +327,6 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 int ath_beaconq_config(struct ath_softc *sc);
 
-/*******/
-/* ANI */
-/*******/
-
-#define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
-#define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
-#define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
-#define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
-#define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
-
-void ath_ani_calibrate(unsigned long data);
-
 /**********/
 /* BTCOEX */
 /**********/
@@ -377,18 +360,6 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 /*   LED Control    */
 /********************/
 
-#define ATH_LED_PIN_DEF 		1
-#define ATH_LED_PIN_9287		8
-#define ATH_LED_ON_DURATION_IDLE	350	/* in msecs */
-#define ATH_LED_OFF_DURATION_IDLE	250	/* in msecs */
-
-enum ath_led_type {
-	ATH_LED_RADIO,
-	ATH_LED_ASSOC,
-	ATH_LED_TX,
-	ATH_LED_RX
-};
-
 struct ath_led {
 	struct ath_softc *sc;
 	struct led_classdev led_cdev;
@@ -549,8 +520,6 @@ void ath9k_deinit_device(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
-void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan);
 void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan);
@@ -600,6 +569,8 @@ void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
 
+void ath_ani_calibrate(unsigned long data);
+
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 4d775ae..2c6db6c 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -102,46 +102,47 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	return true;
 }
 
-static u8 ath9k_process_rate(struct ath_common *common,
-			     struct ieee80211_hw *hw,
-			     struct ath_rx_status *rx_stats,
-			     struct ieee80211_rx_status *rxs,
-			     struct sk_buff *skb)
+/*
+ * Process rate information from a recived packet.
+ */
+void ath9k_process_rate(struct ieee80211_hw *hw,
+			struct ieee80211_rx_status *rx_status,
+			u8 rs_rate, u8 rs_flags)
 {
 	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
-	unsigned int i = 0;
-
-	band = hw->conf.channel->band;
-	sband = hw->wiphy->bands[band];
-
-	if (rx_stats->rs_rate & 0x80) {
-		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		if (rx_stats->rs_flags & ATH9K_RX_2040)
-			rxs->flag |= RX_FLAG_40MHZ;
-		if (rx_stats->rs_flags & ATH9K_RX_GI)
-			rxs->flag |= RX_FLAG_SHORT_GI;
-		return rx_stats->rs_rate & 0x7f;
+	enum ieee80211_band cur_band;
+	int i, n_rates;
+
+	/* Process HT rates */
+	if (rs_rate & 0x80) {
+		rx_status->flag |= RX_FLAG_HT;
+		if (rs_flags & ATH9K_RX_2040)
+			rx_status->flag |= RX_FLAG_40MHZ;
+		if (rs_flags & ATH9K_RX_GI)
+			rx_status->flag |= RX_FLAG_SHORT_GI;
+		rx_status->rate_idx = rs_rate & 0x7f;
+		return;
 	}
 
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
-			return i;
-		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
-			rxs->flag |= RX_FLAG_SHORTPRE;
-			return i;
-		}
-	}
+	cur_band = hw->conf.channel->band;
+	sband = hw->wiphy->bands[cur_band];
+	n_rates = sband->n_bitrates;
 
-	/* No valid hardware bitrate found -- we should not get here */
-	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
-		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
-	if ((common->debug_mask & ATH_DBG_XMIT))
-		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
+	/* Process legacy rates */
+	for (i = 0; i < n_rates; i++) {
+		if (sband->bitrates[i].hw_value == rs_rate) {
+			rx_status->rate_idx = i;
+			break;
+		}
 
-        return 0;
+		if (sband->bitrates[i].hw_value_short == rs_rate) {
+			rx_status->rate_idx = i;
+			rx_status->flag |= RX_FLAG_SHORTPRE;
+			break;
+		}
+	}
 }
+EXPORT_SYMBOL(ath9k_process_rate);
 
 static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hw *hw,
@@ -207,8 +208,7 @@ int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
 
 	ath9k_process_rssi(common, hw, skb, rx_stats);
 
-	rx_status->rate_idx = ath9k_process_rate(common, hw,
-						 rx_stats, rx_status, skb);
+	ath9k_process_rate(hw, rx_status, rx_stats->rs_rate, rx_stats->rs_flags);
 	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
@@ -286,6 +286,346 @@ int ath9k_cmn_padpos(__le16 frame_control)
 }
 EXPORT_SYMBOL(ath9k_cmn_padpos);
 
+static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
+			   struct ath9k_keyval *hk, const u8 *addr,
+			   bool authenticator)
+{
+	struct ath_hw *ah = common->ah;
+	const u8 *key_rxmic;
+	const u8 *key_txmic;
+
+	key_txmic = key + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
+	key_rxmic = key + NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
+
+	if (addr == NULL) {
+		/*
+		 * Group key installation - only two key cache entries are used
+		 * regardless of splitmic capability since group key is only
+		 * used either for TX or RX.
+		 */
+		if (authenticator) {
+			memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
+			memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_mic));
+		} else {
+			memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+			memcpy(hk->kv_txmic, key_rxmic, sizeof(hk->kv_mic));
+		}
+		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
+	}
+	if (!common->splitmic) {
+		/* TX and RX keys share the same key cache entry. */
+		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
+		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
+	}
+
+	/* Separate key cache entries for TX and RX */
+
+	/* TX key goes at first index, RX key at +32. */
+	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
+	if (!ath9k_hw_set_keycache_entry(ah, keyix, hk, NULL)) {
+		/* TX MIC entry failed. No need to proceed further */
+		ath_print(common, ATH_DBG_FATAL,
+			  "Setting TX MIC Key Failed\n");
+		return 0;
+	}
+
+	memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+	/* XXX delete tx key on failure? */
+	return ath9k_hw_set_keycache_entry(ah, keyix + 32, hk, addr);
+}
+
+static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
+{
+	int i;
+
+	for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
+		if (test_bit(i, common->keymap) ||
+		    test_bit(i + 64, common->keymap))
+			continue; /* At least one part of TKIP key allocated */
+		if (common->splitmic &&
+		    (test_bit(i + 32, common->keymap) ||
+		     test_bit(i + 64 + 32, common->keymap)))
+			continue; /* At least one part of TKIP key allocated */
+
+		/* Found a free slot for a TKIP key */
+		return i;
+	}
+	return -1;
+}
+
+static int ath_reserve_key_cache_slot(struct ath_common *common)
+{
+	int i;
+
+	/* First, try to find slots that would not be available for TKIP. */
+	if (common->splitmic) {
+		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
+			if (!test_bit(i, common->keymap) &&
+			    (test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
+				return i;
+			if (!test_bit(i + 32, common->keymap) &&
+			    (test_bit(i, common->keymap) ||
+			     test_bit(i + 64, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
+				return i + 32;
+			if (!test_bit(i + 64, common->keymap) &&
+			    (test_bit(i , common->keymap) ||
+			     test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
+				return i + 64;
+			if (!test_bit(i + 64 + 32, common->keymap) &&
+			    (test_bit(i, common->keymap) ||
+			     test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64, common->keymap)))
+				return i + 64 + 32;
+		}
+	} else {
+		for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
+			if (!test_bit(i, common->keymap) &&
+			    test_bit(i + 64, common->keymap))
+				return i;
+			if (test_bit(i, common->keymap) &&
+			    !test_bit(i + 64, common->keymap))
+				return i + 64;
+		}
+	}
+
+	/* No partially used TKIP slots, pick any available slot */
+	for (i = IEEE80211_WEP_NKID; i < common->keymax; i++) {
+		/* Do not allow slots that could be needed for TKIP group keys
+		 * to be used. This limitation could be removed if we know that
+		 * TKIP will not be used. */
+		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
+			continue;
+		if (common->splitmic) {
+			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
+				continue;
+			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
+				continue;
+		}
+
+		if (!test_bit(i, common->keymap))
+			return i; /* Found a free slot for a key */
+	}
+
+	/* No free slot found */
+	return -1;
+}
+
+/*
+ * Configure encryption in the HW.
+ */
+int ath9k_key_config(struct ath_common *common,
+		     struct ieee80211_vif *vif,
+		     struct ieee80211_sta *sta,
+		     struct ieee80211_key_conf *key)
+{
+	struct ath_hw *ah = common->ah;
+	struct ath9k_keyval hk;
+	const u8 *mac = NULL;
+	int ret = 0;
+	int idx;
+
+	memset(&hk, 0, sizeof(hk));
+
+	switch (key->alg) {
+	case ALG_WEP:
+		hk.kv_type = ATH9K_CIPHER_WEP;
+		break;
+	case ALG_TKIP:
+		hk.kv_type = ATH9K_CIPHER_TKIP;
+		break;
+	case ALG_CCMP:
+		hk.kv_type = ATH9K_CIPHER_AES_CCM;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	hk.kv_len = key->keylen;
+	memcpy(hk.kv_val, key->key, key->keylen);
+
+	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		/* For now, use the default keys for broadcast keys. This may
+		 * need to change with virtual interfaces. */
+		idx = key->keyidx;
+	} else if (key->keyidx) {
+		if (WARN_ON(!sta))
+			return -EOPNOTSUPP;
+		mac = sta->addr;
+
+		if (vif->type != NL80211_IFTYPE_AP) {
+			/* Only keyidx 0 should be used with unicast key, but
+			 * allow this for client mode for now. */
+			idx = key->keyidx;
+		} else
+			return -EIO;
+	} else {
+		if (WARN_ON(!sta))
+			return -EOPNOTSUPP;
+		mac = sta->addr;
+
+		if (key->alg == ALG_TKIP)
+			idx = ath_reserve_key_cache_slot_tkip(common);
+		else
+			idx = ath_reserve_key_cache_slot(common);
+		if (idx < 0)
+			return -ENOSPC; /* no free key cache entries */
+	}
+
+	if (key->alg == ALG_TKIP)
+		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
+				      vif->type == NL80211_IFTYPE_AP);
+	else
+		ret = ath9k_hw_set_keycache_entry(ah, idx, &hk, mac);
+
+	if (!ret)
+		return -EIO;
+
+	set_bit(idx, common->keymap);
+	if (key->alg == ALG_TKIP) {
+		set_bit(idx + 64, common->keymap);
+		if (common->splitmic) {
+			set_bit(idx + 32, common->keymap);
+			set_bit(idx + 64 + 32, common->keymap);
+		}
+	}
+
+	return idx;
+}
+EXPORT_SYMBOL(ath9k_key_config);
+
+/*
+ * Delete Key.
+ */
+void ath9k_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
+{
+	struct ath_hw *ah = common->ah;
+
+	ath9k_hw_keyreset(ah, key->hw_key_idx);
+	if (key->hw_key_idx < IEEE80211_WEP_NKID)
+		return;
+
+	clear_bit(key->hw_key_idx, common->keymap);
+	if (key->alg != ALG_TKIP)
+		return;
+
+	clear_bit(key->hw_key_idx + 64, common->keymap);
+	if (common->splitmic) {
+		ath9k_hw_keyreset(ah, key->hw_key_idx + 32);
+		clear_bit(key->hw_key_idx + 32, common->keymap);
+		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
+	}
+}
+EXPORT_SYMBOL(ath9k_key_delete);
+
+static u32 ath9k_get_extchanmode(struct ieee80211_channel *chan,
+				 enum nl80211_channel_type channel_type)
+{
+	u32 chanmode = 0;
+
+	switch (chan->band) {
+	case IEEE80211_BAND_2GHZ:
+		switch (channel_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			chanmode = CHANNEL_G_HT20;
+			break;
+		case NL80211_CHAN_HT40PLUS:
+			chanmode = CHANNEL_G_HT40PLUS;
+			break;
+		case NL80211_CHAN_HT40MINUS:
+			chanmode = CHANNEL_G_HT40MINUS;
+			break;
+		}
+		break;
+	case IEEE80211_BAND_5GHZ:
+		switch (channel_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			chanmode = CHANNEL_A_HT20;
+			break;
+		case NL80211_CHAN_HT40PLUS:
+			chanmode = CHANNEL_A_HT40PLUS;
+			break;
+		case NL80211_CHAN_HT40MINUS:
+			chanmode = CHANNEL_A_HT40MINUS;
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return chanmode;
+}
+
+/*
+ * Update internal channel flags.
+ */
+void ath9k_update_ichannel(struct ieee80211_hw *hw,
+			   struct ath9k_channel *ichan)
+{
+	struct ieee80211_channel *chan = hw->conf.channel;
+	struct ieee80211_conf *conf = &hw->conf;
+
+	ichan->channel = chan->center_freq;
+	ichan->chan = chan;
+
+	if (chan->band == IEEE80211_BAND_2GHZ) {
+		ichan->chanmode = CHANNEL_G;
+		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
+	} else {
+		ichan->chanmode = CHANNEL_A;
+		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
+	}
+
+	if (conf_is_ht(conf))
+		ichan->chanmode = ath9k_get_extchanmode(chan, conf->channel_type);
+}
+EXPORT_SYMBOL(ath9k_update_ichannel);
+
+/*
+ * Get the internal channel reference.
+ */
+struct ath9k_channel *ath9k_get_curchannel(struct ieee80211_hw *hw,
+					   struct ath_hw *ah)
+{
+	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ath9k_channel *channel;
+	u8 chan_idx;
+
+	chan_idx = curchan->hw_value;
+	channel = &ah->channels[chan_idx];
+	ath9k_update_ichannel(hw, channel);
+
+	return channel;
+}
+EXPORT_SYMBOL(ath9k_get_curchannel);
+
+/*
+ * Get the encryption keytype.
+ */
+int ath9k_get_hw_crypto_keytype(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+
+	if (tx_info->control.hw_key) {
+		if (tx_info->control.hw_key->alg == ALG_WEP)
+			return ATH9K_KEY_TYPE_WEP;
+		else if (tx_info->control.hw_key->alg == ALG_TKIP)
+			return ATH9K_KEY_TYPE_TKIP;
+		else if (tx_info->control.hw_key->alg == ALG_CCMP)
+			return ATH9K_KEY_TYPE_AES;
+	}
+
+	return ATH9K_KEY_TYPE_CLEAR;
+}
+EXPORT_SYMBOL(ath9k_get_hw_crypto_keytype);
+
 static int __init ath9k_cmn_init(void)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 042999c..1f5194a 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -23,6 +23,11 @@
 
 /* Common header for Atheros 802.11n base driver cores */
 
+#define ATH_DEFAULT_BMISS_LIMIT 10
+#define IEEE80211_MS_TO_TU(x)   (((x) * 1000) / 1024)
+#define TSF_TO_TU(_h,_l) \
+	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
+
 #define WME_NUM_TID             16
 #define WME_BA_BMP_SIZE         64
 #define WME_MAX_BA              WME_BA_BMP_SIZE
@@ -49,6 +54,27 @@
 #define ATH_EP_RND(x, mul) 						\
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 
+#define IEEE80211_WEP_NKID 4
+
+#define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
+#define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
+#define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
+#define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
+#define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
+
+#define ATH_LED_PIN_DEF             1
+#define ATH_LED_PIN_9287            8
+#define ATH_LED_PIN_9271            15
+#define ATH_LED_ON_DURATION_IDLE    350	/* in msecs */
+#define ATH_LED_OFF_DURATION_IDLE   250	/* in msecs */
+
+enum ath_led_type {
+	ATH_LED_RADIO,
+	ATH_LED_ASSOC,
+	ATH_LED_TX,
+	ATH_LED_RX
+};
+
 struct ath_atx_ac {
 	int sched;
 	int qnum;
@@ -117,11 +143,22 @@ int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
 				struct ath_rx_status *rx_stats,
 				struct ieee80211_rx_status *rx_status,
 				bool *decrypt_error);
-
 void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 				  struct sk_buff *skb,
 				  struct ath_rx_status *rx_stats,
 				  struct ieee80211_rx_status *rxs,
 				  bool decrypt_error);
-
 int ath9k_cmn_padpos(__le16 frame_control);
+int ath9k_key_config(struct ath_common *common,
+		     struct ieee80211_vif *vif,
+		     struct ieee80211_sta *sta,
+		     struct ieee80211_key_conf *key);
+void ath9k_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
+void ath9k_update_ichannel(struct ieee80211_hw *hw,
+			   struct ath9k_channel *ichan);
+struct ath9k_channel *ath9k_get_curchannel(struct ieee80211_hw *hw,
+					   struct ath_hw *ah);
+void ath9k_process_rate(struct ieee80211_hw *hw,
+			struct ieee80211_rx_status *rx_status,
+			u8 rs_rate, u8 rs_flags);
+int ath9k_get_hw_crypto_keytype(struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index fc9de89..232958a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -29,7 +29,6 @@
 #include "htc_hst.h"
 #include "hif_usb.h"
 #include "wmi.h"
-#include "lib.h"
 
 extern struct ieee80211_ops ath9k_htc_ops;
 extern int modparam_htc_nohwcrypt;
@@ -392,6 +391,10 @@ int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
 void ath9k_host_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_tasklet(unsigned long data);
+u32 ath9k_calcrxfilter(struct ieee80211_hw *hw, struct ath_hw *ah,
+		       unsigned int rxfilter);
+void ath9k_opmode_init(struct ieee80211_hw *hw, struct ath_hw *ah,
+		       unsigned int rxfilter);
 
 void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv);
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e137b6b..578e505 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -977,7 +977,7 @@ static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *) skb->data;
 
 	/* Add the padding after the header if this is not already done */
-	padpos = ath9k_padpos(hdr->frame_control);
+	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len > padpos) {
 		if (skb_headroom(skb) < padsize)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index cbf21c6..a527f50 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -290,6 +290,86 @@ bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv,
 /* RX */
 /******/
 
+/*
+ * Calculate the RX filter to be set in the HW.
+ */
+u32 ath9k_calcrxfilter(struct ieee80211_hw *hw, struct ath_hw *ah,
+		       unsigned int rxfilter)
+{
+#define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
+
+	u32 rfilt;
+
+	rfilt = (ath9k_hw_getrxfilter(ah) & RX_FILTER_PRESERVE)
+		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
+		| ATH9K_RX_FILTER_MCAST;
+
+	/* If not a STA, enable processing of Probe Requests */
+	if (ah->opmode != NL80211_IFTYPE_STATION)
+		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
+
+	/*
+	 * Set promiscuous mode when FIF_PROMISC_IN_BSS is enabled for station
+	 * mode interface or when in monitor mode. AP mode does not need this
+	 * since it receives all in-BSS frames anyway.
+	 */
+	if (((ah->opmode != NL80211_IFTYPE_AP) &&
+	     (rxfilter & FIF_PROMISC_IN_BSS)) ||
+	    (ah->opmode == NL80211_IFTYPE_MONITOR))
+		rfilt |= ATH9K_RX_FILTER_PROM;
+
+	if (rxfilter & FIF_CONTROL)
+		rfilt |= ATH9K_RX_FILTER_CONTROL;
+
+	if ((ah->opmode == NL80211_IFTYPE_STATION) &&
+	    !(rxfilter & FIF_BCN_PRBRESP_PROMISC))
+		rfilt |= ATH9K_RX_FILTER_MYBEACON;
+	else
+		rfilt |= ATH9K_RX_FILTER_BEACON;
+
+	if ((AR_SREV_9280_10_OR_LATER(ah) ||
+	    AR_SREV_9285_10_OR_LATER(ah)) &&
+	    (ah->opmode == NL80211_IFTYPE_AP) &&
+	    (rxfilter & FIF_PSPOLL))
+		rfilt |= ATH9K_RX_FILTER_PSPOLL;
+
+	if (conf_is_ht(&hw->conf))
+		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
+
+	return rfilt;
+
+#undef RX_FILTER_PRESERVE
+}
+
+/*
+ * Recv initialization for opmode change.
+ */
+void ath9k_opmode_init(struct ieee80211_hw *hw, struct ath_hw *ah,
+		       unsigned int rxfilter)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	u32 rfilt, mfilt[2];
+
+	/* configure rx filter */
+	rfilt = ath9k_calcrxfilter(hw, ah, rxfilter);
+	ath9k_hw_setrxfilter(ah, rfilt);
+
+	/* configure bssid mask */
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+		ath_hw_setbssidmask(common);
+
+	/* configure operational mode */
+	ath9k_hw_setopmode(ah);
+
+	/* Handle any link-level address change. */
+	ath9k_hw_setmac(ah, common->macaddr);
+
+	/* calculate and install multicast filter */
+	mfilt[0] = mfilt[1] = ~0;
+	ath9k_hw_setmcastfilter(ah, mfilt[0], mfilt[1]);
+}
+
 void ath9k_host_rx_init(struct ath9k_htc_priv *priv)
 {
 	ath9k_hw_rxena(priv->ah);
@@ -315,7 +395,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 
-	padpos = ath9k_padpos(fc);
+	padpos = ath9k_cmn_padpos(fc);
 
 	padsize = padpos & 3;
 	if (padsize && skb->len >= padpos+padsize) {
diff --git a/drivers/net/wireless/ath/ath9k/lib.c b/drivers/net/wireless/ath/ath9k/lib.c
deleted file mode 100644
index b5493c6..0000000
--- a/drivers/net/wireless/ath/ath9k/lib.c
+++ /dev/null
@@ -1,487 +0,0 @@
-/*
- * Copyright (c) 2010 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include "lib.h"
-
-/*
- * Get the encryption keytype.
- */
-int ath9k_get_hw_crypto_keytype(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-
-	if (tx_info->control.hw_key) {
-		if (tx_info->control.hw_key->alg == ALG_WEP)
-			return ATH9K_KEY_TYPE_WEP;
-		else if (tx_info->control.hw_key->alg == ALG_TKIP)
-			return ATH9K_KEY_TYPE_TKIP;
-		else if (tx_info->control.hw_key->alg == ALG_CCMP)
-			return ATH9K_KEY_TYPE_AES;
-	}
-
-	return ATH9K_KEY_TYPE_CLEAR;
-}
-
-/*
- * Calculate the RX filter to be set in the HW.
- */
-u32 ath9k_calcrxfilter(struct ieee80211_hw *hw, struct ath_hw *ah,
-		       unsigned int rxfilter)
-{
-#define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
-
-	u32 rfilt;
-
-	rfilt = (ath9k_hw_getrxfilter(ah) & RX_FILTER_PRESERVE)
-		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
-		| ATH9K_RX_FILTER_MCAST;
-
-	/* If not a STA, enable processing of Probe Requests */
-	if (ah->opmode != NL80211_IFTYPE_STATION)
-		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
-
-	/*
-	 * Set promiscuous mode when FIF_PROMISC_IN_BSS is enabled for station
-	 * mode interface or when in monitor mode. AP mode does not need this
-	 * since it receives all in-BSS frames anyway.
-	 */
-	if (((ah->opmode != NL80211_IFTYPE_AP) &&
-	     (rxfilter & FIF_PROMISC_IN_BSS)) ||
-	    (ah->opmode == NL80211_IFTYPE_MONITOR))
-		rfilt |= ATH9K_RX_FILTER_PROM;
-
-	if (rxfilter & FIF_CONTROL)
-		rfilt |= ATH9K_RX_FILTER_CONTROL;
-
-	if ((ah->opmode == NL80211_IFTYPE_STATION) &&
-	    !(rxfilter & FIF_BCN_PRBRESP_PROMISC))
-		rfilt |= ATH9K_RX_FILTER_MYBEACON;
-	else
-		rfilt |= ATH9K_RX_FILTER_BEACON;
-
-	if ((AR_SREV_9280_10_OR_LATER(ah) ||
-	    AR_SREV_9285_10_OR_LATER(ah)) &&
-	    (ah->opmode == NL80211_IFTYPE_AP) &&
-	    (rxfilter & FIF_PSPOLL))
-		rfilt |= ATH9K_RX_FILTER_PSPOLL;
-
-	if (conf_is_ht(&hw->conf))
-		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
-
-	return rfilt;
-
-#undef RX_FILTER_PRESERVE
-}
-
-/*
- * Recv initialization for opmode change.
- */
-void ath9k_opmode_init(struct ieee80211_hw *hw, struct ath_hw *ah,
-		       unsigned int rxfilter)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	u32 rfilt, mfilt[2];
-
-	/* configure rx filter */
-	rfilt = ath9k_calcrxfilter(hw, ah, rxfilter);
-	ath9k_hw_setrxfilter(ah, rfilt);
-
-	/* configure bssid mask */
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath_hw_setbssidmask(common);
-
-	/* configure operational mode */
-	ath9k_hw_setopmode(ah);
-
-	/* Handle any link-level address change. */
-	ath9k_hw_setmac(ah, common->macaddr);
-
-	/* calculate and install multicast filter */
-	mfilt[0] = mfilt[1] = ~0;
-	ath9k_hw_setmcastfilter(ah, mfilt[0], mfilt[1]);
-}
-
-/*
- * Process rate information from a recived packet.
- */
-void ath9k_process_rate(struct ieee80211_hw *hw,
-			struct ieee80211_rx_status *rx_status,
-			u8 rs_rate, u8 rs_flags)
-{
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band cur_band;
-	int i, n_rates;
-
-	/* Process HT rates */
-	if (rs_rate & 0x80) {
-		rx_status->flag |= RX_FLAG_HT;
-		if (rs_flags & ATH9K_RX_2040)
-			rx_status->flag |= RX_FLAG_40MHZ;
-		if (rs_flags & ATH9K_RX_GI)
-			rx_status->flag |= RX_FLAG_SHORT_GI;
-		rx_status->rate_idx = rs_rate & 0x7f;
-		return;
-	}
-
-	cur_band = hw->conf.channel->band;
-	sband = hw->wiphy->bands[cur_band];
-	n_rates = sband->n_bitrates;
-
-	/* Process legacy rates */
-	for (i = 0; i < n_rates; i++) {
-		if (sband->bitrates[i].hw_value == rs_rate) {
-			rx_status->rate_idx = i;
-			break;
-		}
-
-		if (sband->bitrates[i].hw_value_short == rs_rate) {
-			rx_status->rate_idx = i;
-			rx_status->flag |= RX_FLAG_SHORTPRE;
-			break;
-		}
-	}
-}
-
-static u32 ath9k_get_extchanmode(struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type)
-{
-	u32 chanmode = 0;
-
-	switch (chan->band) {
-	case IEEE80211_BAND_2GHZ:
-		switch (channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_G_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_G_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_G_HT40MINUS;
-			break;
-		}
-		break;
-	case IEEE80211_BAND_5GHZ:
-		switch (channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_A_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_A_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_A_HT40MINUS;
-			break;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return chanmode;
-}
-
-/*
- * Update internal channel flags.
- */
-void ath9k_update_ichannel(struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan)
-{
-	struct ieee80211_channel *chan = hw->conf.channel;
-	struct ieee80211_conf *conf = &hw->conf;
-
-	ichan->channel = chan->center_freq;
-	ichan->chan = chan;
-
-	if (chan->band == IEEE80211_BAND_2GHZ) {
-		ichan->chanmode = CHANNEL_G;
-		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
-	} else {
-		ichan->chanmode = CHANNEL_A;
-		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
-	}
-
-	if (conf_is_ht(conf))
-		ichan->chanmode = ath9k_get_extchanmode(chan, conf->channel_type);
-}
-
-/*
- * Get the internal channel reference.
- */
-struct ath9k_channel *ath9k_get_curchannel(struct ieee80211_hw *hw,
-					   struct ath_hw *ah)
-{
-	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct ath9k_channel *channel;
-	u8 chan_idx;
-
-	chan_idx = curchan->hw_value;
-	channel = &ah->channels[chan_idx];
-	ath9k_update_ichannel(hw, channel);
-
-	return channel;
-}
-
-static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
-			   struct ath9k_keyval *hk, const u8 *addr,
-			   bool authenticator)
-{
-	struct ath_hw *ah = common->ah;
-	const u8 *key_rxmic;
-	const u8 *key_txmic;
-
-	key_txmic = key + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
-	key_rxmic = key + NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
-
-	if (addr == NULL) {
-		/*
-		 * Group key installation - only two key cache entries are used
-		 * regardless of splitmic capability since group key is only
-		 * used either for TX or RX.
-		 */
-		if (authenticator) {
-			memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
-			memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_mic));
-		} else {
-			memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
-			memcpy(hk->kv_txmic, key_rxmic, sizeof(hk->kv_mic));
-		}
-		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
-	}
-	if (!common->splitmic) {
-		/* TX and RX keys share the same key cache entry. */
-		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
-		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
-		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
-	}
-
-	/* Separate key cache entries for TX and RX */
-
-	/* TX key goes at first index, RX key at +32. */
-	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
-	if (!ath9k_hw_set_keycache_entry(ah, keyix, hk, NULL)) {
-		/* TX MIC entry failed. No need to proceed further */
-		ath_print(common, ATH_DBG_FATAL,
-			  "Setting TX MIC Key Failed\n");
-		return 0;
-	}
-
-	memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
-	/* XXX delete tx key on failure? */
-	return ath9k_hw_set_keycache_entry(ah, keyix + 32, hk, addr);
-}
-
-static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
-{
-	int i;
-
-	for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
-		if (test_bit(i, common->keymap) ||
-		    test_bit(i + 64, common->keymap))
-			continue; /* At least one part of TKIP key allocated */
-		if (common->splitmic &&
-		    (test_bit(i + 32, common->keymap) ||
-		     test_bit(i + 64 + 32, common->keymap)))
-			continue; /* At least one part of TKIP key allocated */
-
-		/* Found a free slot for a TKIP key */
-		return i;
-	}
-	return -1;
-}
-
-static int ath_reserve_key_cache_slot(struct ath_common *common)
-{
-	int i;
-
-	/* First, try to find slots that would not be available for TKIP. */
-	if (common->splitmic) {
-		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
-			if (!test_bit(i, common->keymap) &&
-			    (test_bit(i + 32, common->keymap) ||
-			     test_bit(i + 64, common->keymap) ||
-			     test_bit(i + 64 + 32, common->keymap)))
-				return i;
-			if (!test_bit(i + 32, common->keymap) &&
-			    (test_bit(i, common->keymap) ||
-			     test_bit(i + 64, common->keymap) ||
-			     test_bit(i + 64 + 32, common->keymap)))
-				return i + 32;
-			if (!test_bit(i + 64, common->keymap) &&
-			    (test_bit(i , common->keymap) ||
-			     test_bit(i + 32, common->keymap) ||
-			     test_bit(i + 64 + 32, common->keymap)))
-				return i + 64;
-			if (!test_bit(i + 64 + 32, common->keymap) &&
-			    (test_bit(i, common->keymap) ||
-			     test_bit(i + 32, common->keymap) ||
-			     test_bit(i + 64, common->keymap)))
-				return i + 64 + 32;
-		}
-	} else {
-		for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
-			if (!test_bit(i, common->keymap) &&
-			    test_bit(i + 64, common->keymap))
-				return i;
-			if (test_bit(i, common->keymap) &&
-			    !test_bit(i + 64, common->keymap))
-				return i + 64;
-		}
-	}
-
-	/* No partially used TKIP slots, pick any available slot */
-	for (i = IEEE80211_WEP_NKID; i < common->keymax; i++) {
-		/* Do not allow slots that could be needed for TKIP group keys
-		 * to be used. This limitation could be removed if we know that
-		 * TKIP will not be used. */
-		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
-			continue;
-		if (common->splitmic) {
-			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
-				continue;
-			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
-				continue;
-		}
-
-		if (!test_bit(i, common->keymap))
-			return i; /* Found a free slot for a key */
-	}
-
-	/* No free slot found */
-	return -1;
-}
-
-/*
- * Configure encryption in the HW.
- */
-int ath9k_key_config(struct ath_common *common,
-		     struct ieee80211_vif *vif,
-		     struct ieee80211_sta *sta,
-		     struct ieee80211_key_conf *key)
-{
-	struct ath_hw *ah = common->ah;
-	struct ath9k_keyval hk;
-	const u8 *mac = NULL;
-	int ret = 0;
-	int idx;
-
-	memset(&hk, 0, sizeof(hk));
-
-	switch (key->alg) {
-	case ALG_WEP:
-		hk.kv_type = ATH9K_CIPHER_WEP;
-		break;
-	case ALG_TKIP:
-		hk.kv_type = ATH9K_CIPHER_TKIP;
-		break;
-	case ALG_CCMP:
-		hk.kv_type = ATH9K_CIPHER_AES_CCM;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	hk.kv_len = key->keylen;
-	memcpy(hk.kv_val, key->key, key->keylen);
-
-	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
-		/* For now, use the default keys for broadcast keys. This may
-		 * need to change with virtual interfaces. */
-		idx = key->keyidx;
-	} else if (key->keyidx) {
-		if (WARN_ON(!sta))
-			return -EOPNOTSUPP;
-		mac = sta->addr;
-
-		if (vif->type != NL80211_IFTYPE_AP) {
-			/* Only keyidx 0 should be used with unicast key, but
-			 * allow this for client mode for now. */
-			idx = key->keyidx;
-		} else
-			return -EIO;
-	} else {
-		if (WARN_ON(!sta))
-			return -EOPNOTSUPP;
-		mac = sta->addr;
-
-		if (key->alg == ALG_TKIP)
-			idx = ath_reserve_key_cache_slot_tkip(common);
-		else
-			idx = ath_reserve_key_cache_slot(common);
-		if (idx < 0)
-			return -ENOSPC; /* no free key cache entries */
-	}
-
-	if (key->alg == ALG_TKIP)
-		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
-				      vif->type == NL80211_IFTYPE_AP);
-	else
-		ret = ath9k_hw_set_keycache_entry(ah, idx, &hk, mac);
-
-	if (!ret)
-		return -EIO;
-
-	set_bit(idx, common->keymap);
-	if (key->alg == ALG_TKIP) {
-		set_bit(idx + 64, common->keymap);
-		if (common->splitmic) {
-			set_bit(idx + 32, common->keymap);
-			set_bit(idx + 64 + 32, common->keymap);
-		}
-	}
-
-	return idx;
-}
-
-/*
- * Delete Key.
- */
-void ath9k_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
-{
-	struct ath_hw *ah = common->ah;
-
-	ath9k_hw_keyreset(ah, key->hw_key_idx);
-	if (key->hw_key_idx < IEEE80211_WEP_NKID)
-		return;
-
-	clear_bit(key->hw_key_idx, common->keymap);
-	if (key->alg != ALG_TKIP)
-		return;
-
-	clear_bit(key->hw_key_idx + 64, common->keymap);
-	if (common->splitmic) {
-		ath9k_hw_keyreset(ah, key->hw_key_idx + 32);
-		clear_bit(key->hw_key_idx + 32, common->keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
-	}
-}
-
-int ath9k_padpos(__le16 frame_control)
-{
-	int padpos = 24;
-
-	if (ieee80211_has_a4(frame_control)) {
-		padpos += ETH_ALEN;
-	}
-	if (ieee80211_is_data_qos(frame_control)) {
-		padpos += IEEE80211_QOS_CTL_LEN;
-	}
-
-	return padpos;
-}
diff --git a/drivers/net/wireless/ath/ath9k/lib.h b/drivers/net/wireless/ath/ath9k/lib.h
deleted file mode 100644
index 815d265..0000000
--- a/drivers/net/wireless/ath/ath9k/lib.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Copyright (c) 2010 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef LIB_H
-#define LIB_H
-
-#include "hw.h"
-
-#define IEEE80211_WEP_NKID 4
-
-#define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
-#define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
-#define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
-#define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
-
-#define ATH_DEFAULT_BMISS_LIMIT 10
-#define IEEE80211_MS_TO_TU(x)   (((x) * 1000) / 1024)
-#define TSF_TO_TU(_h,_l) \
-	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
-
-#define ATH_RSSI_DUMMY_MARKER   0x127
-#define RSSI_LPF_THRESHOLD      -20
-#define ATH_RSSI_LPF_LEN        10
-#define ATH_RSSI_EP_MULTIPLIER  (1<<7)
-
-#define ATH_EP_MUL(x, mul)         ((x) * (mul))
-#define ATH_RSSI_IN(x) (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
-
-#define ATH_LPF_RSSI(x, y, len) \
-    ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len)) : (y))
-
-#define ATH_RSSI_LPF(x, y) do {                     			\
-    if ((y) >= RSSI_LPF_THRESHOLD)                         		\
-	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);  	\
-} while (0)
-
-#define ATH_EP_RND(x, mul) 						\
-	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
-
-#define ATH_LED_PIN_DEF             1
-#define ATH_LED_PIN_9287            8
-#define ATH_LED_PIN_9271            15
-#define ATH_LED_ON_DURATION_IDLE    350	/* in msecs */
-#define ATH_LED_OFF_DURATION_IDLE   250	/* in msecs */
-
-enum ath_led_type {
-	ATH_LED_RADIO,
-	ATH_LED_ASSOC,
-	ATH_LED_TX,
-	ATH_LED_RX
-};
-
-int ath9k_get_hw_crypto_keytype(struct sk_buff *skb);
-u32 ath9k_calcrxfilter(struct ieee80211_hw *hw, struct ath_hw *ah,
-		       unsigned int rxfilter);
-void ath9k_opmode_init(struct ieee80211_hw *hw, struct ath_hw *ah,
-		       unsigned int rxfilter);
-void ath9k_process_rate(struct ieee80211_hw *hw,
-			struct ieee80211_rx_status *rx_status,
-			u8 rs_rate, u8 rs_flags);
-int ath9k_padpos(__le16 frame_control);
-void ath9k_update_ichannel(struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan);
-struct ath9k_channel *ath9k_get_curchannel(struct ieee80211_hw *hw,
-					   struct ath_hw *ah);
-int ath9k_key_config(struct ath_common *common,
-		     struct ieee80211_vif *vif,
-		     struct ieee80211_sta *sta,
-		     struct ieee80211_key_conf *key);
-void ath9k_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
-
-#endif /* LIB_H */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 67ca4e5..37663b5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -96,19 +96,6 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
-static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
-						struct ieee80211_hw *hw)
-{
-	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct ath9k_channel *channel;
-	u8 chan_idx;
-
-	chan_idx = curchan->hw_value;
-	channel = &sc->sc_ah->channels[chan_idx];
-	ath9k_update_ichannel(sc, hw, channel);
-	return channel;
-}
-
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 {
 	unsigned long flags;
@@ -545,48 +532,6 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-static u32 ath_get_extchanmode(struct ath_softc *sc,
-			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type)
-{
-	u32 chanmode = 0;
-
-	switch (chan->band) {
-	case IEEE80211_BAND_2GHZ:
-		switch(channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_G_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_G_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_G_HT40MINUS;
-			break;
-		}
-		break;
-	case IEEE80211_BAND_5GHZ:
-		switch(channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_A_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_A_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_A_HT40MINUS;
-			break;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return chanmode;
-}
-
 static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
 			   struct ath9k_keyval *hk, const u8 *addr,
 			   bool authenticator)
@@ -864,7 +809,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_configpcipowersave(ah, 0, 0);
 
 	if (!ah->curchan)
-		ah->curchan = ath_get_curchannel(sc, sc->hw);
+		ah->curchan = ath9k_get_curchannel(sc->hw, ah);
 
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
@@ -919,7 +864,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	if (!ah->curchan)
-		ah->curchan = ath_get_curchannel(sc, hw);
+		ah->curchan = ath9k_get_curchannel(hw, ah);
 
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
@@ -1048,30 +993,6 @@ int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc)
 	return qnum;
 }
 
-/* XXX: Remove me once we don't depend on ath9k_channel for all
- * this redundant data */
-void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan)
-{
-	struct ieee80211_channel *chan = hw->conf.channel;
-	struct ieee80211_conf *conf = &hw->conf;
-
-	ichan->channel = chan->center_freq;
-	ichan->chan = chan;
-
-	if (chan->band == IEEE80211_BAND_2GHZ) {
-		ichan->chanmode = CHANNEL_G;
-		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
-	} else {
-		ichan->chanmode = CHANNEL_A;
-		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
-	}
-
-	if (conf_is_ht(conf))
-		ichan->chanmode = ath_get_extchanmode(sc, chan,
-					    conf->channel_type);
-}
-
 /**********************/
 /* mac80211 callbacks */
 /**********************/
@@ -1117,7 +1038,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	sc->chan_idx = curchan->hw_value;
 
-	init_channel = ath_get_curchannel(sc, hw);
+	init_channel = ath9k_get_curchannel(hw, ah);
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, 0, 0);
@@ -1619,7 +1540,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			  curchan->center_freq);
 
 		/* XXX: remove me eventualy */
-		ath9k_update_ichannel(sc, hw, &sc->sc_ah->channels[pos]);
+		ath9k_update_ichannel(hw, &sc->sc_ah->channels[pos]);
 
 		ath_update_chainmask(sc, conf_is_ht(conf));
 
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index a43fbf8..593a52a 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -312,7 +312,7 @@ void ath9k_wiphy_chan_work(struct work_struct *work)
 	/* Change channels */
 	mutex_lock(&sc->mutex);
 	/* XXX: remove me eventually */
-	ath9k_update_ichannel(sc, aphy->hw,
+	ath9k_update_ichannel(aphy->hw,
 			      &sc->sc_ah->channels[sc->chan_idx]);
 
 	/* sync hw configuration for hw code */
-- 
1.7.0.1

