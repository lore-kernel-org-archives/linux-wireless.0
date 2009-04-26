Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56675 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZDZONZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 10:13:25 -0400
Received: by ewy24 with SMTP id 24so1732517ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2009 07:13:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/5] rt2x00: Implement support for 802.11n
Date: Sun, 26 Apr 2009 16:09:32 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200904261608.30384.IvDoorn@gmail.com> <200904261608.50411.IvDoorn@gmail.com> <200904261609.11447.IvDoorn@gmail.com>
In-Reply-To: <200904261609.11447.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904261609.32275.IvDoorn@gmail.com> (sfid-20090426_161333_566183_A7B07217)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend rt2x00lib capabilities to support 802.11n,
it still lacks aggregation support, but that can
be added in the future.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig        |    3 +
 drivers/net/wireless/rt2x00/Makefile       |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h       |   11 +++
 drivers/net/wireless/rt2x00/rt2x00config.c |    5 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   92 ++++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00ht.c     |   69 +++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   24 +++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c  |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   39 +++++++++---
 9 files changed, 211 insertions(+), 34 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00ht.c

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index bfc5d9c..4338c93 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -88,6 +88,9 @@ config RT2X00_LIB_USB
 config RT2X00_LIB
 	tristate
 
+config RT2X00_LIB_HT
+	boolean
+
 config RT2X00_LIB_FIRMWARE
 	boolean
 	select FW_LOADER
diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
index f22d808..776ec2b 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -8,6 +8,7 @@ rt2x00lib-$(CONFIG_RT2X00_LIB_CRYPTO)	+= rt2x00crypto.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_RFKILL)	+= rt2x00rfkill.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_FIRMWARE)	+= rt2x00firmware.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_LEDS)	+= rt2x00leds.o
+rt2x00lib-$(CONFIG_RT2X00_LIB_HT)	+= rt2x00ht.o
 
 obj-$(CONFIG_RT2X00_LIB)		+= rt2x00lib.o
 obj-$(CONFIG_RT2X00_LIB_PCI)		+= rt2x00pci.o
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 676fb7d..db99fa7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -366,6 +366,7 @@ static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
  *	for @tx_power_a, @tx_power_bg and @channels.
  * @channels: Device/chipset specific channel values (See &struct rf_channel).
  * @channels_info: Additional information for channels (See &struct channel_info).
+ * @ht: Driver HT Capabilities (See &ieee80211_sta_ht_cap).
  */
 struct hw_mode_spec {
 	unsigned int supported_bands;
@@ -379,6 +380,8 @@ struct hw_mode_spec {
 	unsigned int num_channels;
 	const struct rf_channel *channels;
 	const struct channel_info *channels_info;
+
+	struct ieee80211_sta_ht_cap ht;
 };
 
 /*
@@ -616,6 +619,7 @@ enum rt2x00_flags {
 	CONFIG_EXTERNAL_LNA_BG,
 	CONFIG_DOUBLE_ANTENNA,
 	CONFIG_DISABLE_LINK_TUNING,
+	CONFIG_CHANNEL_HT40,
 };
 
 /*
@@ -788,6 +792,13 @@ struct rt2x00_dev {
 	u8 freq_offset;
 
 	/*
+	 * Calibration information (for rt2800usb & rt2800pci).
+	 * [0] -> BW20
+	 * [1] -> BW40
+	 */
+	u8 calibration[2];
+
+	/*
 	 * Low level statistics which will have
 	 * to be kept up to date while device is running.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 9c2f551..863e399 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -173,6 +173,11 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	libconf.conf = conf;
 
 	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL) {
+		if (conf_is_ht40(conf))
+			__set_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags);
+		else
+			__clear_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags);
+
 		memcpy(&libconf.rf,
 		       &rt2x00dev->spec.channels[conf->channel->hw_value],
 		       sizeof(libconf.rf));
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e15086a..f227084 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -323,19 +323,54 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
+static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
+					struct rxdone_entry_desc *rxdesc)
+{
+	struct ieee80211_supported_band *sband;
+	const struct rt2x00_rate *rate;
+	unsigned int i;
+	int signal;
+	int type;
+
+	/*
+	 * For non-HT rates the MCS value needs to contain the
+	 * actually used rate modulation (CCK or OFDM).
+	 */
+	if (rxdesc->dev_flags & RXDONE_SIGNAL_MCS)
+		signal = RATE_MCS(rxdesc->rate_mode, rxdesc->signal);
+	else
+		signal = rxdesc->signal;
+
+	type = (rxdesc->dev_flags & RXDONE_SIGNAL_MASK);
+
+	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
+	for (i = 0; i < sband->n_bitrates; i++) {
+		rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
+
+		if (((type == RXDONE_SIGNAL_PLCP) &&
+		     (rate->plcp == signal)) ||
+		    ((type == RXDONE_SIGNAL_BITRATE) &&
+		      (rate->bitrate == signal)) ||
+		    ((type == RXDONE_SIGNAL_MCS) &&
+		      (rate->mcs == signal))) {
+			return i;
+		}
+	}
+
+	WARNING(rt2x00dev, "Frame received with unrecognized signal, "
+		"signal=0x%.4x, type=%d.\n", signal, type);
+	return 0;
+}
+
 void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 		      struct queue_entry *entry)
 {
 	struct rxdone_entry_desc rxdesc;
 	struct sk_buff *skb;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
-	struct ieee80211_supported_band *sband;
-	const struct rt2x00_rate *rate;
 	unsigned int header_length;
 	bool l2pad;
-	unsigned int i;
-	int idx = -1;
-
+	int rate_idx;
 	/*
 	 * Allocate a new sk_buffer. If no new buffer available, drop the
 	 * received frame and reuse the existing buffer.
@@ -379,26 +414,17 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 		rt2x00queue_payload_align(entry->skb, l2pad, header_length);
 
 	/*
-	 * Update RX statistics.
+	 * Check if the frame was received using HT. In that case,
+	 * the rate is the MCS index and should be passed to mac80211
+	 * directly. Otherwise we need to translate the signal to
+	 * the correct bitrate index.
 	 */
-	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
-	for (i = 0; i < sband->n_bitrates; i++) {
-		rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
-
-		if (((rxdesc.dev_flags & RXDONE_SIGNAL_PLCP) &&
-		     (rate->plcp == rxdesc.signal)) ||
-		    ((rxdesc.dev_flags & RXDONE_SIGNAL_BITRATE) &&
-		      (rate->bitrate == rxdesc.signal))) {
-			idx = i;
-			break;
-		}
-	}
-
-	if (idx < 0) {
-		WARNING(rt2x00dev, "Frame received with unrecognized signal,"
-			"signal=0x%.2x, type=%d.\n", rxdesc.signal,
-			(rxdesc.dev_flags & RXDONE_SIGNAL_MASK));
-		idx = 0;
+	if (rxdesc.rate_mode == RATE_MODE_CCK ||
+	    rxdesc.rate_mode == RATE_MODE_OFDM) {
+		rate_idx = rt2x00lib_rxdone_read_signal(rt2x00dev, &rxdesc);
+	} else {
+		rxdesc.flags |= RX_FLAG_HT;
+		rate_idx = rxdesc.signal;
 	}
 
 	/*
@@ -408,7 +434,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	rt2x00debug_update_crypto(rt2x00dev, &rxdesc);
 
 	rx_status->mactime = rxdesc.timestamp;
-	rx_status->rate_idx = idx;
+	rx_status->rate_idx = rate_idx;
 	rx_status->qual = rt2x00link_calculate_signal(rt2x00dev, rxdesc.rssi);
 	rx_status->signal = rxdesc.rssi;
 	rx_status->noise = rxdesc.noise;
@@ -443,72 +469,84 @@ const struct rt2x00_rate rt2x00_supported_rates[12] = {
 		.bitrate = 10,
 		.ratemask = BIT(0),
 		.plcp = 0x00,
+		.mcs = RATE_MCS(RATE_MODE_CCK, 0),
 	},
 	{
 		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 20,
 		.ratemask = BIT(1),
 		.plcp = 0x01,
+		.mcs = RATE_MCS(RATE_MODE_CCK, 1),
 	},
 	{
 		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 55,
 		.ratemask = BIT(2),
 		.plcp = 0x02,
+		.mcs = RATE_MCS(RATE_MODE_CCK, 2),
 	},
 	{
 		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 110,
 		.ratemask = BIT(3),
 		.plcp = 0x03,
+		.mcs = RATE_MCS(RATE_MODE_CCK, 3),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 60,
 		.ratemask = BIT(4),
 		.plcp = 0x0b,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 0),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 90,
 		.ratemask = BIT(5),
 		.plcp = 0x0f,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 1),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 120,
 		.ratemask = BIT(6),
 		.plcp = 0x0a,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 2),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 180,
 		.ratemask = BIT(7),
 		.plcp = 0x0e,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 3),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 240,
 		.ratemask = BIT(8),
 		.plcp = 0x09,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 4),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 360,
 		.ratemask = BIT(9),
 		.plcp = 0x0d,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 5),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 480,
 		.ratemask = BIT(10),
 		.plcp = 0x08,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 6),
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 540,
 		.ratemask = BIT(11),
 		.plcp = 0x0c,
+		.mcs = RATE_MCS(RATE_MODE_OFDM, 7),
 	},
 };
 
@@ -584,6 +622,8 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 		rt2x00dev->bands[IEEE80211_BAND_2GHZ].bitrates = rates;
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 		    &rt2x00dev->bands[IEEE80211_BAND_2GHZ];
+		memcpy(&rt2x00dev->bands[IEEE80211_BAND_2GHZ].ht_cap,
+		       &spec->ht, sizeof(spec->ht));
 	}
 
 	/*
@@ -600,6 +640,8 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 		rt2x00dev->bands[IEEE80211_BAND_5GHZ].bitrates = &rates[4];
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 		    &rt2x00dev->bands[IEEE80211_BAND_5GHZ];
+		memcpy(&rt2x00dev->bands[IEEE80211_BAND_5GHZ].ht_cap,
+		       &spec->ht, sizeof(spec->ht));
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
new file mode 100644
index 0000000..e3cec83
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -0,0 +1,69 @@
+/*
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: rt2x00 HT specific routines.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "rt2x00.h"
+#include "rt2x00lib.h"
+
+void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
+				   struct txentry_desc *txdesc,
+				   const struct rt2x00_rate *hwrate)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
+
+	if (tx_info->control.sta)
+		txdesc->mpdu_density =
+		    tx_info->control.sta->ht_cap.ampdu_density;
+	else
+		txdesc->mpdu_density = 0;
+
+	txdesc->ba_size = 7;	/* FIXME: What value is needed? */
+	txdesc->stbc = 0;	/* FIXME: What value is needed? */
+
+	txdesc->mcs = rt2x00_get_rate_mcs(hwrate->mcs);
+	if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		txdesc->mcs |= 0x08;
+
+	/*
+	 * Convert flags
+	 */
+	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
+		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
+
+	/*
+	 * Determine HT Mix/Greenfield rate mode
+	 */
+	if (txrate->flags & IEEE80211_TX_RC_MCS)
+		txdesc->rate_mode = RATE_MODE_HT_MIX;
+	if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
+		txdesc->rate_mode = RATE_MODE_HT_GREENFIELD;
+	if (txrate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		__set_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags);
+	if (txrate->flags & IEEE80211_TX_RC_SHORT_GI)
+		__set_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags);
+}
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 747178c..39e00b3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -48,6 +48,7 @@ struct rt2x00_rate {
 	unsigned short ratemask;
 
 	unsigned short plcp;
+	unsigned short mcs;
 };
 
 extern const struct rt2x00_rate rt2x00_supported_rates[12];
@@ -57,6 +58,14 @@ static inline const struct rt2x00_rate *rt2x00_get_rate(const u16 hw_value)
 	return &rt2x00_supported_rates[hw_value & 0xff];
 }
 
+#define RATE_MCS(__mode, __mcs) \
+	( (((__mode) & 0x00ff) << 8) | ((__mcs) & 0x00ff) )
+
+static inline int rt2x00_get_rate_mcs(const u16 mcs_value)
+{
+	return (mcs_value & 0x00ff);
+}
+
 /*
  * Radio control handlers.
  */
@@ -360,6 +369,21 @@ static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
 /*
+ * HT handlers.
+ */
+#ifdef CONFIG_RT2X00_LIB_HT
+void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
+				   struct txentry_desc *txdesc,
+				   const struct rt2x00_rate *hwrate);
+#else
+static inline void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
+						 struct txentry_desc *txdesc,
+						 const struct rt2x00_rate *hwrate)
+{
+}
+#endif /* CONFIG_RT2X00_LIB_HT */
+
+/*
  * RFkill handlers.
  */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index bc1742c..44e5b32 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -361,6 +361,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Apply TX descriptor handling by components
 	 */
 	rt2x00crypto_create_tx_descriptor(entry, txdesc);
+	rt2x00ht_create_tx_descriptor(entry, txdesc, hwrate);
 	rt2x00queue_create_tx_descriptor_seq(entry, txdesc);
 	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 13e0ece..b5e0634 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -35,9 +35,12 @@
  * for USB devices this restriction does not apply, but the value of
  * 2432 makes sense since it is big enough to contain the maximum fragment
  * size according to the ieee802.11 specs.
+ * The aggregation size depends on support from the driver, but should
+ * be something around 3840 bytes.
  */
-#define DATA_FRAME_SIZE	2432
-#define MGMT_FRAME_SIZE	256
+#define DATA_FRAME_SIZE		2432
+#define MGMT_FRAME_SIZE		256
+#define AGGREGATION_SIZE	3840
 
 /**
  * DOC: Number of entries per queue
@@ -148,18 +151,20 @@ static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
  *
  * @RXDONE_SIGNAL_PLCP: Signal field contains the plcp value.
  * @RXDONE_SIGNAL_BITRATE: Signal field contains the bitrate value.
+ * @RXDONE_SIGNAL_MCS: Signal field contains the mcs value.
  * @RXDONE_MY_BSS: Does this frame originate from device's BSS.
  * @RXDONE_CRYPTO_IV: Driver provided IV/EIV data.
  * @RXDONE_CRYPTO_ICV: Driver provided ICV data.
  * @RXDONE_L2PAD: 802.11 payload has been padded to 4-byte boundary.
  */
 enum rxdone_entry_desc_flags {
-	RXDONE_SIGNAL_PLCP = 1 << 0,
-	RXDONE_SIGNAL_BITRATE = 1 << 1,
-	RXDONE_MY_BSS = 1 << 2,
-	RXDONE_CRYPTO_IV = 1 << 3,
-	RXDONE_CRYPTO_ICV = 1 << 4,
-	RXDONE_L2PAD = 1 << 5,
+	RXDONE_SIGNAL_PLCP = BIT(0),
+	RXDONE_SIGNAL_BITRATE = BIT(1),
+	RXDONE_SIGNAL_MCS = BIT(2),
+	RXDONE_MY_BSS = BIT(3),
+	RXDONE_CRYPTO_IV = BIT(4),
+	RXDONE_CRYPTO_ICV = BIT(5),
+	RXDONE_L2PAD = BIT(6),
 };
 
 /**
@@ -168,7 +173,7 @@ enum rxdone_entry_desc_flags {
  * from &rxdone_entry_desc to a signal value type.
  */
 #define RXDONE_SIGNAL_MASK \
-       ( RXDONE_SIGNAL_PLCP | RXDONE_SIGNAL_BITRATE )
+	( RXDONE_SIGNAL_PLCP | RXDONE_SIGNAL_BITRATE | RXDONE_SIGNAL_MCS )
 
 /**
  * struct rxdone_entry_desc: RX Entry descriptor
@@ -182,6 +187,7 @@ enum rxdone_entry_desc_flags {
  * @size: Data size of the received frame.
  * @flags: MAC80211 receive flags (See &enum mac80211_rx_flags).
  * @dev_flags: Ralink receive flags (See &enum rxdone_entry_desc_flags).
+ * @rate_mode: Rate mode (See @enum rate_modulation).
  * @cipher: Cipher type used during decryption.
  * @cipher_status: Decryption status.
  * @iv: IV/EIV data used during decryption.
@@ -195,6 +201,7 @@ struct rxdone_entry_desc {
 	int size;
 	int flags;
 	int dev_flags;
+	u16 rate_mode;
 	u8 cipher;
 	u8 cipher_status;
 
@@ -248,6 +255,9 @@ struct txdone_entry_desc {
  * @ENTRY_TXD_ENCRYPT_PAIRWISE: Use pairwise key table (instead of shared).
  * @ENTRY_TXD_ENCRYPT_IV: Generate IV/EIV in hardware.
  * @ENTRY_TXD_ENCRYPT_MMIC: Generate MIC in hardware.
+ * @ENTRY_TXD_HT_AMPDU: This frame is part of an AMPDU.
+ * @ENTRY_TXD_HT_BW_40: Use 40MHz Bandwidth.
+ * @ENTRY_TXD_HT_SHORT_GI: Use short GI.
  */
 enum txentry_desc_flags {
 	ENTRY_TXD_RTS_FRAME,
@@ -263,6 +273,9 @@ enum txentry_desc_flags {
 	ENTRY_TXD_ENCRYPT_PAIRWISE,
 	ENTRY_TXD_ENCRYPT_IV,
 	ENTRY_TXD_ENCRYPT_MMIC,
+	ENTRY_TXD_HT_AMPDU,
+	ENTRY_TXD_HT_BW_40,
+	ENTRY_TXD_HT_SHORT_GI,
 };
 
 /**
@@ -278,7 +291,11 @@ enum txentry_desc_flags {
  * @length_low: PLCP length low word.
  * @signal: PLCP signal.
  * @service: PLCP service.
+ * @msc: MCS.
+ * @stbc: STBC.
+ * @ba_size: BA size.
  * @rate_mode: Rate mode (See @enum rate_modulation).
+ * @mpdu_density: MDPU density.
  * @retry_limit: Max number of retries.
  * @aifs: AIFS value.
  * @ifs: IFS value.
@@ -302,7 +319,11 @@ struct txentry_desc {
 	u16 signal;
 	u16 service;
 
+	u16 mcs;
+	u16 stbc;
+	u16 ba_size;
 	u16 rate_mode;
+	u16 mpdu_density;
 
 	short retry_limit;
 	short aifs;
-- 
1.6.2.3

