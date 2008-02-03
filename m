Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:28680 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763565AbYBCOvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:55 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1586369mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:53 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/19] rt2x00: Rate structure overhaul
Date: Sun, 3 Feb 2008 15:50:40 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031550.40381.IvDoorn@gmail.com> (sfid-20080203_145158_637395_22E8581E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes to the rate structure registration broke rt2x00,
the hw_value was reduced from 32bits to 16bits while rt2x00 used
the full 32bits. However the way rt2x00 used the value was inflexible
and needed to be changed anyway.

This patch creates a array containing information for each rate,
the hw_value passed to mac80211 is the index value for that array
including a field to indicate if short preamble should be enabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  173 +++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   45 +++++++
 drivers/net/wireless/rt2x00/rt2x00reg.h    |   71 -----------
 4 files changed, 153 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index bbbf356..b39d816 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -242,9 +242,7 @@ config:
 
 		band = &rt2x00dev->bands[conf->channel->band];
 		rate = &band->bitrates[band->n_bitrates - 1];
-
-		libconf.basic_rates =
-		    DEVICE_GET_RATE_FIELD(rate->hw_value, RATEMASK) & DEV_BASIC_RATEMASK;
+		libconf.basic_rates = rt2x00_get_rate(rate->hw_value)->ratemask;
 	}
 
 	if (flags & CONFIG_UPDATE_CHANNEL) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 961bcb3..4fb6c58 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -548,10 +548,10 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate;
 	struct ieee80211_hdr *hdr;
+	const struct rt2x00_rate *rate;
 	unsigned int i;
-	int val = 0, idx = -1;
+	int idx = -1;
 	u16 fc;
 
 	/*
@@ -559,19 +559,15 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	 */
 	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
 	for (i = 0; i < sband->n_bitrates; i++) {
-		rate = &sband->bitrates[i];
+		rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
 
 		/*
 		 * When frame was received with an OFDM bitrate,
 		 * the signal is the PLCP value. If it was received with
-		 * a CCK bitrate the signal is the rate in 0.5kbit/s.
+		 * a CCK bitrate the signal is the rate in 100kbit/s.
 		 */
-		if (!rxdesc->ofdm)
-			val = DEVICE_GET_RATE_FIELD(rate->hw_value, RATE);
-		else
-			val = DEVICE_GET_RATE_FIELD(rate->hw_value, PLCP);
-
-		if (val == rxdesc->signal) {
+		if ((rxdesc->ofdm && rate->plcp == rxdesc->signal) ||
+		    (!rxdesc->ofdm && rate->bitrate == rxdesc->signal)) {
 			idx = i;
 			break;
 		}
@@ -580,7 +576,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	/*
 	 * Only update link status if this is a beacon frame carrying our bssid.
 	 */
-	hdr = (struct ieee80211_hdr*)entry->skb->data;
+	hdr = (struct ieee80211_hdr *)entry->skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
 	if (is_beacon(fc) && rxdesc->my_bss)
 		rt2x00lib_update_link_stats(&rt2x00dev->link, rxdesc->rssi);
@@ -614,9 +610,9 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 {
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	const struct rt2x00_rate *rate;
 	int tx_rate;
-	int bitrate;
 	int length;
 	int duration;
 	int residual;
@@ -643,8 +639,8 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Read required fields from ieee80211 header.
 	 */
-	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
-	seq_ctrl = le16_to_cpu(ieee80211hdr->seq_ctrl);
+	frame_control = le16_to_cpu(hdr->frame_control);
+	seq_ctrl = le16_to_cpu(hdr->seq_ctrl);
 
 	tx_rate = control->tx_rate->hw_value;
 
@@ -668,16 +664,12 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			tx_rate = control->rts_cts_rate->hw_value;
 	}
 
-	/*
-	 * Check for OFDM
-	 */
-	if (DEVICE_GET_RATE_FIELD(tx_rate, RATEMASK) & DEV_OFDM_RATEMASK)
-		__set_bit(ENTRY_TXD_OFDM_RATE, &txdesc.flags);
+	rate = rt2x00_get_rate(tx_rate);
 
 	/*
 	 * Check if more fragments are pending
 	 */
-	if (ieee80211_get_morefrag(ieee80211hdr)) {
+	if (ieee80211_get_morefrag(hdr)) {
 		__set_bit(ENTRY_TXD_BURST, &txdesc.flags);
 		__set_bit(ENTRY_TXD_MORE_FRAG, &txdesc.flags);
 	}
@@ -705,21 +697,21 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * PLCP setup
 	 * Length calculation depends on OFDM/CCK rate.
 	 */
-	txdesc.signal = DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
+	txdesc.signal = rate->plcp;
 	txdesc.service = 0x04;
 
 	length = skb->len + FCS_LEN;
-	if (test_bit(ENTRY_TXD_OFDM_RATE, &txdesc.flags)) {
+	if (rate->flags & DEV_RATE_OFDM) {
+		__set_bit(ENTRY_TXD_OFDM_RATE, &txdesc.flags);
+
 		txdesc.length_high = (length >> 6) & 0x3f;
 		txdesc.length_low = length & 0x3f;
 	} else {
-		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
-
 		/*
 		 * Convert length to microseconds.
 		 */
-		residual = get_duration_res(length, bitrate);
-		duration = get_duration(length, bitrate);
+		residual = get_duration_res(length, rate->bitrate);
+		duration = get_duration(length, rate->bitrate);
 
 		if (residual != 0) {
 			duration++;
@@ -727,7 +719,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			/*
 			 * Check if we need to set the Length Extension
 			 */
-			if (bitrate == 110 && residual <= 30)
+			if (rate->bitrate == 110 && residual <= 30)
 				txdesc.service |= 0x80;
 		}
 
@@ -738,7 +730,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		 * When preamble is enabled we should set the
 		 * preamble bit for the signal.
 		 */
-		if (DEVICE_GET_RATE_FIELD(tx_rate, PREAMBLE))
+		if (rt2x00_get_rate_preamble(tx_rate))
 			txdesc.signal |= 0x08;
 	}
 
@@ -763,6 +755,81 @@ EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
 /*
  * Driver initialization handlers.
  */
+const struct rt2x00_rate rt2x00_supported_rates[12] = {
+	{
+		.flags = 0,
+		.bitrate = 10,
+		.ratemask = DEV_RATEMASK_1MB,
+		.plcp = 0x00,
+	},
+	{
+		.flags = DEV_RATE_SHORT_PREAMBLE,
+		.bitrate = 20,
+		.ratemask = DEV_RATEMASK_2MB,
+		.plcp = 0x01,
+	},
+	{
+		.flags = DEV_RATE_SHORT_PREAMBLE,
+		.bitrate = 55,
+		.ratemask = DEV_RATEMASK_5_5MB,
+		.plcp = 0x02,
+	},
+	{
+		.flags = DEV_RATE_SHORT_PREAMBLE,
+		.bitrate = 110,
+		.ratemask = DEV_RATEMASK_11MB,
+		.plcp = 0x03,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 60,
+		.ratemask = DEV_RATEMASK_6MB,
+		.plcp = 0x0b,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 90,
+		.ratemask = DEV_RATEMASK_9MB,
+		.plcp = 0x0f,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 120,
+		.ratemask = DEV_RATEMASK_12MB,
+		.plcp = 0x0a,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 180,
+		.ratemask = DEV_RATEMASK_18MB,
+		.plcp = 0x0e,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 240,
+		.ratemask = DEV_RATEMASK_24MB,
+		.plcp = 0x09,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 360,
+		.ratemask = DEV_RATEMASK_36MB,
+		.plcp = 0x0d,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 480,
+		.ratemask = DEV_RATEMASK_48MB,
+		.plcp = 0x08,
+	},
+	{
+		.flags = DEV_RATE_OFDM,
+		.bitrate = 540,
+		.ratemask = DEV_RATEMASK_54MB,
+		.plcp = 0x0c,
+	},
+};
+
 static void rt2x00lib_channel(struct ieee80211_channel *entry,
 			      const int channel, const int tx_power,
 			      const int value)
@@ -777,18 +844,17 @@ static void rt2x00lib_channel(struct ieee80211_channel *entry,
 }
 
 static void rt2x00lib_rate(struct ieee80211_rate *entry,
-			   const int rate, const int mask,
-			   const int plcp, const int flags)
+			   const u16 index, const struct rt2x00_rate *rate)
 {
-	entry->bitrate = rate;
-	entry->hw_value =
-	    DEVICE_SET_RATE_FIELD(rate, RATE) |
-	    DEVICE_SET_RATE_FIELD(mask, RATEMASK) |
-	    DEVICE_SET_RATE_FIELD(plcp, PLCP);
-	entry->flags = flags;
+	entry->flags = 0;
+	entry->bitrate = rate->bitrate;
+	entry->hw_value = rt2x00_create_rate_hw_value(index, 0);
 	entry->hw_value_short = entry->hw_value;
-	if (entry->flags & IEEE80211_RATE_SHORT_PREAMBLE)
-		entry->hw_value_short |= DEVICE_SET_RATE_FIELD(1, PREAMBLE);
+
+	if (rate->flags & DEV_RATE_SHORT_PREAMBLE) {
+		entry->flags |= IEEE80211_RATE_SHORT_PREAMBLE;
+		entry->hw_value_short |= rt2x00_create_rate_hw_value(index, 1);
+	}
 }
 
 static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
@@ -814,33 +880,8 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Initialize Rate list.
 	 */
-	rt2x00lib_rate(&rates[0], 10, DEV_RATEMASK_1MB,
-		       0x00, 0);
-	rt2x00lib_rate(&rates[1], 20, DEV_RATEMASK_2MB,
-		       0x01, IEEE80211_RATE_SHORT_PREAMBLE);
-	rt2x00lib_rate(&rates[2], 55, DEV_RATEMASK_5_5MB,
-		       0x02, IEEE80211_RATE_SHORT_PREAMBLE);
-	rt2x00lib_rate(&rates[3], 110, DEV_RATEMASK_11MB,
-		       0x03, IEEE80211_RATE_SHORT_PREAMBLE);
-
-	if (spec->num_rates > 4) {
-		rt2x00lib_rate(&rates[4], 60, DEV_RATEMASK_6MB,
-			       0x0b, 0);
-		rt2x00lib_rate(&rates[5], 90, DEV_RATEMASK_9MB,
-			       0x0f, 0);
-		rt2x00lib_rate(&rates[6], 120, DEV_RATEMASK_12MB,
-			       0x0a, 0);
-		rt2x00lib_rate(&rates[7], 180, DEV_RATEMASK_18MB,
-			       0x0e, 0);
-		rt2x00lib_rate(&rates[8], 240, DEV_RATEMASK_24MB,
-			       0x09, 0);
-		rt2x00lib_rate(&rates[9], 360, DEV_RATEMASK_36MB,
-			       0x0d, 0);
-		rt2x00lib_rate(&rates[10], 480, DEV_RATEMASK_48MB,
-			       0x08, 0);
-		rt2x00lib_rate(&rates[11], 540, DEV_RATEMASK_54MB,
-			       0x0c, 0);
-	}
+	for (i = 0; i < spec->num_rates; i++)
+		rt2x00lib_rate(&rates[0], i, rt2x00_get_rate(i));
 
 	/*
 	 * Initialize Channel list.
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index f6789fd..ca9630c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -34,6 +34,51 @@
 #define RFKILL_POLL_INTERVAL	( 1000 )
 
 /*
+ * rt2x00_rate: Per rate device information
+ */
+struct rt2x00_rate {
+	unsigned short flags;
+#define DEV_RATE_OFDM			0x0001
+#define DEV_RATE_SHORT_PREAMBLE		0x0002
+
+	unsigned short bitrate; /* In 100kbit/s */
+
+	unsigned short ratemask;
+#define DEV_RATEMASK_1MB	( (1 << 1) - 1 )
+#define DEV_RATEMASK_2MB	( (1 << 2) - 1 )
+#define DEV_RATEMASK_5_5MB	( (1 << 3) - 1 )
+#define DEV_RATEMASK_11MB	( (1 << 4) - 1 )
+#define DEV_RATEMASK_6MB	( (1 << 5) - 1 )
+#define DEV_RATEMASK_9MB	( (1 << 6) - 1 )
+#define DEV_RATEMASK_12MB	( (1 << 7) - 1 )
+#define DEV_RATEMASK_18MB	( (1 << 8) - 1 )
+#define DEV_RATEMASK_24MB	( (1 << 9) - 1 )
+#define DEV_RATEMASK_36MB	( (1 << 10) - 1 )
+#define DEV_RATEMASK_48MB	( (1 << 11) - 1 )
+#define DEV_RATEMASK_54MB	( (1 << 12) - 1 )
+
+	unsigned short plcp;
+};
+
+extern const struct rt2x00_rate rt2x00_supported_rates[12];
+
+static inline u16 rt2x00_create_rate_hw_value(const u16 index,
+					      const u16 short_preamble)
+{
+	return (short_preamble << 8) | (index & 0xff);
+}
+
+static inline const struct rt2x00_rate *rt2x00_get_rate(const u16 hw_value)
+{
+	return &rt2x00_supported_rates[hw_value & 0xff];
+}
+
+static inline int rt2x00_get_rate_preamble(const u16 hw_value)
+{
+	return (hw_value & 0xff00);
+}
+
+/*
  * Radio control handlers.
  */
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 0523d75..add1f09 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -218,75 +218,4 @@ static inline u8 rt2x00_get_field8(const u8 reg,
 	return (reg & field.bit_mask) >> field.bit_offset;
 }
 
-/*
- * Device specific rate value.
- * We will have to create the device specific rate value
- * passed to the ieee80211 kernel. We need to make it a consist of
- * multiple fields because we want to store more then 1 device specific
- * values inside the value.
- *	1 - rate, stored as 100 kbit/s.
- *	2 - preamble, short_preamble enabled flag.
- *	3 - MASK_RATE, which rates are enabled in this mode, this mask
- *	corresponds with the TX register format for the current device.
- *	4 - plcp, 802.11b rates are device specific,
- *	802.11g rates are set according to the ieee802.11a-1999 p.14.
- * The bit to enable preamble is set in a seperate define.
- */
-#define DEV_RATE	FIELD32(0x000007ff)
-#define DEV_PREAMBLE	FIELD32(0x00000800)
-#define DEV_RATEMASK	FIELD32(0x00fff000)
-#define DEV_PLCP	FIELD32(0xff000000)
-
-/*
- * Bitfields
- */
-#define DEV_RATEBIT_1MB		( 1 << 0 )
-#define DEV_RATEBIT_2MB		( 1 << 1 )
-#define DEV_RATEBIT_5_5MB	( 1 << 2 )
-#define DEV_RATEBIT_11MB	( 1 << 3 )
-#define DEV_RATEBIT_6MB		( 1 << 4 )
-#define DEV_RATEBIT_9MB		( 1 << 5 )
-#define DEV_RATEBIT_12MB	( 1 << 6 )
-#define DEV_RATEBIT_18MB	( 1 << 7 )
-#define DEV_RATEBIT_24MB	( 1 << 8 )
-#define DEV_RATEBIT_36MB	( 1 << 9 )
-#define DEV_RATEBIT_48MB	( 1 << 10 )
-#define DEV_RATEBIT_54MB	( 1 << 11 )
-
-/*
- * Bitmasks for DEV_RATEMASK
- */
-#define DEV_RATEMASK_1MB	( (DEV_RATEBIT_1MB << 1) -1 )
-#define DEV_RATEMASK_2MB	( (DEV_RATEBIT_2MB << 1) -1 )
-#define DEV_RATEMASK_5_5MB	( (DEV_RATEBIT_5_5MB << 1) -1 )
-#define DEV_RATEMASK_11MB	( (DEV_RATEBIT_11MB << 1) -1 )
-#define DEV_RATEMASK_6MB	( (DEV_RATEBIT_6MB << 1) -1 )
-#define DEV_RATEMASK_9MB	( (DEV_RATEBIT_9MB << 1) -1 )
-#define DEV_RATEMASK_12MB	( (DEV_RATEBIT_12MB << 1) -1 )
-#define DEV_RATEMASK_18MB	( (DEV_RATEBIT_18MB << 1) -1 )
-#define DEV_RATEMASK_24MB	( (DEV_RATEBIT_24MB << 1) -1 )
-#define DEV_RATEMASK_36MB	( (DEV_RATEBIT_36MB << 1) -1 )
-#define DEV_RATEMASK_48MB	( (DEV_RATEBIT_48MB << 1) -1 )
-#define DEV_RATEMASK_54MB	( (DEV_RATEBIT_54MB << 1) -1 )
-
-/*
- * Bitmask groups of bitrates
- */
-#define DEV_BASIC_RATEMASK \
-	( DEV_RATEMASK_11MB | \
-	  DEV_RATEBIT_6MB | DEV_RATEBIT_12MB | DEV_RATEBIT_24MB )
-
-#define DEV_CCK_RATEMASK	( DEV_RATEMASK_11MB )
-#define DEV_OFDM_RATEMASK	( DEV_RATEMASK_54MB & ~DEV_CCK_RATEMASK )
-
-/*
- * Macro's to set and get specific fields from the device specific val and val2
- * fields inside the ieee80211_rate entry.
- */
-#define DEVICE_SET_RATE_FIELD(__value, __mask) \
-	(int)( ((__value) << DEV_##__mask.bit_offset) & DEV_##__mask.bit_mask )
-
-#define DEVICE_GET_RATE_FIELD(__value, __mask) \
-	(int)( ((__value) & DEV_##__mask.bit_mask) >> DEV_##__mask.bit_offset )
-
 #endif /* RT2X00REG_H */
-- 
1.5.3.8

