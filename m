Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:47612 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758877AbXHFAYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 20:24:30 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: consistent handling of ZD1211 specific rates
Message-Id: <20070806002431.C7A287B409F@zog.reactivated.net>
Date: Mon,  6 Aug 2007 01:24:31 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

As pointed out by Daniel Drake, the zd1211rw driver used several
different rate values and names throughout the driver. He has
written a patch to change it and tweaked it after some pretty wild
ideas from my side. But the discussion helped me to understand the
problem better and I think I have nailed it down with this patch.

A zd-rate will consist from now on of a four-bit "pure" rate value
and a modulation type flag as used in the ZD1211 control set used
for packet transmission. This is consistent with the usage in the
zd_rates table. If possible these zd-rates should be used in the
code.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 zd_chip.c      |   51 ++++++++++++++++-------------
 zd_ieee80211.h |   43 +++++++++++++++---------
 zd_mac.c       |   99 +++++++++++++++----------------------------------------
 zd_mac.h       |   65 +++++++++++++++++++++++++------------
 4 files changed, 126 insertions(+), 132 deletions(-)

Index: linux/drivers/net/wireless/zd1211rw/zd_chip.c
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_chip.c
+++ linux/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1009,19 +1009,19 @@ int zd_chip_set_rts_cts_rate_locked(stru
 	u32 value = 0;
 
 	/* Modulation bit */
-	if (ZD_CS_TYPE(rts_rate) == ZD_CS_OFDM)
+	if (ZD_MODULATION_TYPE(rts_rate) == ZD_OFDM)
 		rts_mod = ZD_RX_OFDM;
 
 	dev_dbg_f(zd_chip_dev(chip), "rts_rate=%x preamble=%x\n",
 		rts_rate, preamble);
 
-	value |= rts_rate << RTSCTS_SH_RTS_RATE;
+	value |= ZD_PURE_RATE(rts_rate) << RTSCTS_SH_RTS_RATE;
 	value |= rts_mod << RTSCTS_SH_RTS_MOD_TYPE;
 	value |= preamble << RTSCTS_SH_RTS_PMB_TYPE;
 	value |= preamble << RTSCTS_SH_CTS_PMB_TYPE;
 
 	/* We always send 11M self-CTS messages, like the vendor driver. */
-	value |= ZD_CCK_RATE_11M << RTSCTS_SH_CTS_RATE;
+	value |= ZD_PURE_RATE(ZD_CCK_RATE_11M) << RTSCTS_SH_CTS_RATE;
 	value |= ZD_RX_CCK << RTSCTS_SH_CTS_MOD_TYPE;
 
 	return zd_iowrite32_locked(chip, value, CR_RTS_CTS_RATE);
@@ -1328,7 +1328,7 @@ int zd_chip_set_basic_rates_locked(struc
 	return zd_iowrite32_locked(chip, cr_rates, CR_BASIC_RATE_TBL);
 }
 
-static int ofdm_qual_db(u8 status_quality, u8 rate, unsigned int size)
+static int ofdm_qual_db(u8 status_quality, u8 zd_rate, unsigned int size)
 {
 	static const u16 constants[] = {
 		715, 655, 585, 540, 470, 410, 360, 315,
@@ -1342,7 +1342,7 @@ static int ofdm_qual_db(u8 status_qualit
 	/* It seems that their quality parameter is somehow per signal
 	 * and is now transferred per bit.
 	 */
-	switch (rate) {
+	switch (zd_rate) {
 	case ZD_OFDM_RATE_6M:
 	case ZD_OFDM_RATE_12M:
 	case ZD_OFDM_RATE_24M:
@@ -1369,7 +1369,7 @@ static int ofdm_qual_db(u8 status_qualit
 			break;
 	}
 
-	switch (rate) {
+	switch (zd_rate) {
 	case ZD_OFDM_RATE_6M:
 	case ZD_OFDM_RATE_9M:
 		i += 3;
@@ -1393,11 +1393,11 @@ static int ofdm_qual_db(u8 status_qualit
 	return i;
 }
 
-static int ofdm_qual_percent(u8 status_quality, u8 rate, unsigned int size)
+static int ofdm_qual_percent(u8 status_quality, u8 zd_rate, unsigned int size)
 {
 	int r;
 
-	r = ofdm_qual_db(status_quality, rate, size);
+	r = ofdm_qual_db(status_quality, zd_rate, size);
 	ZD_ASSERT(r >= 0);
 	if (r < 0)
 		r = 0;
@@ -1458,12 +1458,17 @@ static int cck_qual_percent(u8 status_qu
 	return r <= 100 ? r : 100;
 }
 
+static inline u8 zd_rate_from_ofdm_plcp_header(const void *rx_frame)
+{
+	return ZD_OFDM | zd_ofdm_plcp_header_rate(rx_frame);
+}
+
 u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 	              const struct rx_status *status)
 {
 	return (status->frame_status&ZD_RX_OFDM) ?
 		ofdm_qual_percent(status->signal_quality_ofdm,
-			          zd_ofdm_plcp_header_rate(rx_frame),
+					  zd_rate_from_ofdm_plcp_header(rx_frame),
 			          size) :
 		cck_qual_percent(status->signal_quality_cck);
 }
@@ -1479,32 +1484,32 @@ u8 zd_rx_strength_percent(u8 rssi)
 u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
 {
 	static const u16 ofdm_rates[] = {
-		[ZD_OFDM_RATE_6M]  = 60,
-		[ZD_OFDM_RATE_9M]  = 90,
-		[ZD_OFDM_RATE_12M] = 120,
-		[ZD_OFDM_RATE_18M] = 180,
-		[ZD_OFDM_RATE_24M] = 240,
-		[ZD_OFDM_RATE_36M] = 360,
-		[ZD_OFDM_RATE_48M] = 480,
-		[ZD_OFDM_RATE_54M] = 540,
+		[ZD_OFDM_PLCP_RATE_6M]  = 60,
+		[ZD_OFDM_PLCP_RATE_9M]  = 90,
+		[ZD_OFDM_PLCP_RATE_12M] = 120,
+		[ZD_OFDM_PLCP_RATE_18M] = 180,
+		[ZD_OFDM_PLCP_RATE_24M] = 240,
+		[ZD_OFDM_PLCP_RATE_36M] = 360,
+		[ZD_OFDM_PLCP_RATE_48M] = 480,
+		[ZD_OFDM_PLCP_RATE_54M] = 540,
 	};
 	u16 rate;
 	if (status->frame_status & ZD_RX_OFDM) {
+		/* Deals with PLCP OFDM rate (not zd_rates) */
 		u8 ofdm_rate = zd_ofdm_plcp_header_rate(rx_frame);
 		rate = ofdm_rates[ofdm_rate & 0xf];
 	} else {
-		u8 cck_rate = zd_cck_plcp_header_rate(rx_frame);
-		switch (cck_rate) {
-		case ZD_CCK_SIGNAL_1M:
+		switch (zd_cck_plcp_header_signal(rx_frame)) {
+		case ZD_CCK_PLCP_SIGNAL_1M:
 			rate = 10;
 			break;
-		case ZD_CCK_SIGNAL_2M:
+		case ZD_CCK_PLCP_SIGNAL_2M:
 			rate = 20;
 			break;
-		case ZD_CCK_SIGNAL_5M5:
+		case ZD_CCK_PLCP_SIGNAL_5M5:
 			rate = 55;
 			break;
-		case ZD_CCK_SIGNAL_11M:
+		case ZD_CCK_PLCP_SIGNAL_11M:
 			rate = 110;
 			break;
 		default:
Index: linux/drivers/net/wireless/zd1211rw/zd_ieee80211.h
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_ieee80211.h
+++ linux/drivers/net/wireless/zd1211rw/zd_ieee80211.h
@@ -43,21 +43,25 @@ struct ofdm_plcp_header {
 	__le16 service;
 } __attribute__((packed));
 
-static inline u8 zd_ofdm_plcp_header_rate(
-	const struct ofdm_plcp_header *header)
+static inline u8 zd_ofdm_plcp_header_rate(const struct ofdm_plcp_header *header)
 {
 	return header->prefix[0] & 0xf;
 }
 
-/* These are referred to as zd_rates */
-#define ZD_OFDM_RATE_6M		0xb
-#define ZD_OFDM_RATE_9M		0xf
-#define ZD_OFDM_RATE_12M	0xa
-#define ZD_OFDM_RATE_18M	0xe
-#define ZD_OFDM_RATE_24M	0x9
-#define ZD_OFDM_RATE_36M	0xd
-#define ZD_OFDM_RATE_48M	0x8
-#define ZD_OFDM_RATE_54M	0xc
+/* The following defines give the encoding of the 4-bit rate field in the
+ * OFDM (802.11a/802.11g) PLCP header. Notify that these values are used to
+ * define the zd-rate values for OFDM.
+ *
+ * See the struct zd_ctrlset definition in zd_mac.h.
+ */
+#define ZD_OFDM_PLCP_RATE_6M		0xb
+#define ZD_OFDM_PLCP_RATE_9M		0xf
+#define ZD_OFDM_PLCP_RATE_12M	0xa
+#define ZD_OFDM_PLCP_RATE_18M	0xe
+#define ZD_OFDM_PLCP_RATE_24M	0x9
+#define ZD_OFDM_PLCP_RATE_36M	0xd
+#define ZD_OFDM_PLCP_RATE_48M	0x8
+#define ZD_OFDM_PLCP_RATE_54M	0xc
 
 struct cck_plcp_header {
 	u8 signal;
@@ -66,15 +70,22 @@ struct cck_plcp_header {
 	__le16 crc16;
 } __attribute__((packed));
 
-static inline u8 zd_cck_plcp_header_rate(const struct cck_plcp_header *header)
+static inline u8 zd_cck_plcp_header_signal(const struct cck_plcp_header *header)
 {
 	return header->signal;
 }
 
-#define ZD_CCK_SIGNAL_1M	0x0a
-#define ZD_CCK_SIGNAL_2M	0x14
-#define ZD_CCK_SIGNAL_5M5	0x37
-#define ZD_CCK_SIGNAL_11M	0x6e
+/* These defines give the encodings of the signal field in the 802.11b PLCP
+ * header. The signal field gives the bit rate of the following packet. Even
+ * if technically wrong we use CCK here also for the 1 MBit/s and 2 MBit/s
+ * rate to stay consistent with Zydas and our use of the term.
+ *
+ * Notify that these values are *not* used in the zd-rates.
+ */
+#define ZD_CCK_PLCP_SIGNAL_1M	0x0a
+#define ZD_CCK_PLCP_SIGNAL_2M	0x14
+#define ZD_CCK_PLCP_SIGNAL_5M5	0x37
+#define ZD_CCK_PLCP_SIGNAL_11M	0x6e
 
 enum ieee80211_std {
 	IEEE80211B = 0x01,
Index: linux/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_mac.c
+++ linux/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -582,28 +582,6 @@ u8 zd_mac_get_channel(struct zd_mac *mac
 	return channel;
 }
 
-/* If wrong rate is given, we are falling back to the slowest rate: 1MBit/s */
-static u8 zd_rate_typed(u8 zd_rate)
-{
-	static const u8 typed_rates[16] = {
-		[ZD_CCK_RATE_1M]	= ZD_CS_CCK|ZD_CCK_RATE_1M,
-		[ZD_CCK_RATE_2M]	= ZD_CS_CCK|ZD_CCK_RATE_2M,
-		[ZD_CCK_RATE_5_5M]	= ZD_CS_CCK|ZD_CCK_RATE_5_5M,
-		[ZD_CCK_RATE_11M]	= ZD_CS_CCK|ZD_CCK_RATE_11M,
-		[ZD_OFDM_RATE_6M]	= ZD_CS_OFDM|ZD_OFDM_RATE_6M,
-		[ZD_OFDM_RATE_9M]	= ZD_CS_OFDM|ZD_OFDM_RATE_9M,
-		[ZD_OFDM_RATE_12M]	= ZD_CS_OFDM|ZD_OFDM_RATE_12M,
-		[ZD_OFDM_RATE_18M]	= ZD_CS_OFDM|ZD_OFDM_RATE_18M,
-		[ZD_OFDM_RATE_24M]	= ZD_CS_OFDM|ZD_OFDM_RATE_24M,
-		[ZD_OFDM_RATE_36M]	= ZD_CS_OFDM|ZD_OFDM_RATE_36M,
-		[ZD_OFDM_RATE_48M]	= ZD_CS_OFDM|ZD_OFDM_RATE_48M,
-		[ZD_OFDM_RATE_54M]	= ZD_CS_OFDM|ZD_OFDM_RATE_54M,
-	};
-
-	ZD_ASSERT(ZD_CS_RATE_MASK == 0x0f);
-	return typed_rates[zd_rate & ZD_CS_RATE_MASK];
-}
-
 int zd_mac_set_mode(struct zd_mac *mac, u32 mode)
 {
 	struct ieee80211_device *ieee;
@@ -707,25 +685,30 @@ int zd_mac_get_range(struct zd_mac *mac,
 
 static int zd_calc_tx_length_us(u8 *service, u8 zd_rate, u16 tx_length)
 {
+	/* ZD_PURE_RATE() must be used to remove the modulation type flag of
+	 * the zd-rate values. */
 	static const u8 rate_divisor[] = {
-		[ZD_CCK_RATE_1M]	=  1,
-		[ZD_CCK_RATE_2M]	=  2,
-		[ZD_CCK_RATE_5_5M]	= 11, /* bits must be doubled */
-		[ZD_CCK_RATE_11M]	= 11,
-		[ZD_OFDM_RATE_6M]	=  6,
-		[ZD_OFDM_RATE_9M]	=  9,
-		[ZD_OFDM_RATE_12M]	= 12,
-		[ZD_OFDM_RATE_18M]	= 18,
-		[ZD_OFDM_RATE_24M]	= 24,
-		[ZD_OFDM_RATE_36M]	= 36,
-		[ZD_OFDM_RATE_48M]	= 48,
-		[ZD_OFDM_RATE_54M]	= 54,
+		[ZD_PURE_RATE(ZD_CCK_RATE_1M)]		=  1,
+		[ZD_PURE_RATE(ZD_CCK_RATE_2M)]		=  2,
+
+		/* bits must be doubled */
+		[ZD_PURE_RATE(ZD_CCK_RATE_5_5M)]	= 11,
+
+		[ZD_PURE_RATE(ZD_CCK_RATE_11M)]		= 11,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_6M)]		=  6,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_9M)]		=  9,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_12M)]	= 12,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_18M)]	= 18,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_24M)]	= 24,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_36M)]	= 36,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_48M)]	= 48,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_54M)]	= 54,
 	};
 
 	u32 bits = (u32)tx_length * 8;
 	u32 divisor;
 
-	divisor = rate_divisor[zd_rate];
+	divisor = rate_divisor[ZD_PURE_RATE(zd_rate)];
 	if (divisor == 0)
 		return -EINVAL;
 
@@ -748,52 +731,24 @@ static int zd_calc_tx_length_us(u8 *serv
 	return bits/divisor;
 }
 
-enum {
-	R2M_SHORT_PREAMBLE = 0x01,
-	R2M_11A		   = 0x02,
-};
-
-static u8 zd_rate_to_modulation(u8 zd_rate, int flags)
-{
-	u8 modulation;
-
-	modulation = zd_rate_typed(zd_rate);
-	if (flags & R2M_SHORT_PREAMBLE) {
-		switch (ZD_CS_RATE(modulation)) {
-		case ZD_CCK_RATE_2M:
-		case ZD_CCK_RATE_5_5M:
-		case ZD_CCK_RATE_11M:
-			modulation |= ZD_CS_CCK_PREA_SHORT;
-			return modulation;
-		}
-	}
-	if (flags & R2M_11A) {
-		if (ZD_CS_TYPE(modulation) == ZD_CS_OFDM)
-			modulation |= ZD_CS_OFDM_MODE_11A;
-	}
-	return modulation;
-}
-
 static void cs_set_modulation(struct zd_mac *mac, struct zd_ctrlset *cs,
 	                      struct ieee80211_hdr_4addr *hdr)
 {
 	struct ieee80211softmac_device *softmac = ieee80211_priv(mac->netdev);
 	u16 ftype = WLAN_FC_GET_TYPE(le16_to_cpu(hdr->frame_ctl));
-	u8 rate, zd_rate;
+	u8 rate;
 	int is_mgt = (ftype == IEEE80211_FTYPE_MGMT) != 0;
 	int is_multicast = is_multicast_ether_addr(hdr->addr1);
 	int short_preamble = ieee80211softmac_short_preamble_ok(softmac,
 		is_multicast, is_mgt);
-	int flags = 0;
 
-	/* FIXME: 802.11a? */
 	rate = ieee80211softmac_suggest_txrate(softmac, is_multicast, is_mgt);
+	cs->modulation = rate_to_zd_rate(rate);
 
-	if (short_preamble)
-		flags |= R2M_SHORT_PREAMBLE;
-
-	zd_rate = rate_to_zd_rate(rate);
-	cs->modulation = zd_rate_to_modulation(zd_rate, flags);
+	/* Set short preamble bit when appropriate */
+	if (short_preamble && ZD_MODULATION_TYPE(cs->modulation) == ZD_CCK
+	    && cs->modulation != ZD_CCK_RATE_1M)
+		cs->modulation |= ZD_CCK_PREA_SHORT;
 }
 
 static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
@@ -832,7 +787,7 @@ static void cs_set_control(struct zd_mac
 		cs->control |= ZD_CS_RTS;
 
 	/* Use CTS-to-self protection if required */
-	if (ZD_CS_TYPE(cs->modulation) == ZD_CS_OFDM &&
+	if (ZD_MODULATION_TYPE(cs->modulation) == ZD_OFDM &&
 			ieee80211softmac_protection_needed(softmac)) {
 		/* FIXME: avoid sending RTS *and* self-CTS, is that correct? */
 		cs->control &= ~ZD_CS_RTS;
@@ -893,7 +848,7 @@ static int fill_ctrlset(struct zd_mac *m
 	 * - see line 53 of zdinlinef.h
 	 */
 	cs->service = 0;
-	r = zd_calc_tx_length_us(&cs->service, ZD_CS_RATE(cs->modulation),
+	r = zd_calc_tx_length_us(&cs->service, ZD_RATE(cs->modulation),
 		                 le16_to_cpu(cs->tx_length));
 	if (r < 0)
 		return r;
@@ -902,7 +857,7 @@ static int fill_ctrlset(struct zd_mac *m
 	if (next_frag_len == 0) {
 		cs->next_frame_length = 0;
 	} else {
-		r = zd_calc_tx_length_us(NULL, ZD_CS_RATE(cs->modulation),
+		r = zd_calc_tx_length_us(NULL, ZD_RATE(cs->modulation),
 			                 next_frag_len);
 		if (r < 0)
 			return r;
Index: linux/drivers/net/wireless/zd1211rw/zd_mac.h
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_mac.h
+++ linux/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -40,28 +40,51 @@ struct zd_ctrlset {
 
 #define ZD_CS_RESERVED_SIZE	25
 
-/* zd_crtlset field modulation */
-#define ZD_CS_RATE_MASK		0x0f
-#define ZD_CS_TYPE_MASK		0x10
-#define ZD_CS_RATE(modulation) ((modulation) & ZD_CS_RATE_MASK)
-#define ZD_CS_TYPE(modulation) ((modulation) & ZD_CS_TYPE_MASK)
-
-#define ZD_CS_CCK		0x00
-#define ZD_CS_OFDM		0x10
-
-/* These are referred to as zd_rates */
-#define ZD_CCK_RATE_1M	0x00
-#define ZD_CCK_RATE_2M	0x01
-#define ZD_CCK_RATE_5_5M	0x02
-#define ZD_CCK_RATE_11M	0x03
-/* The rates for OFDM are encoded as in the PLCP header. Use ZD_OFDM_RATE_*.
+/* The field modulation of struct zd_ctrlset controls the bit rate, the use
+ * of short or long preambles in 802.11b (CCK mode) or the use of 802.11a or
+ * 802.11g in OFDM mode.
+ *
+ * The term zd-rate is used for the combination of the modulation type flag
+ * and the "pure" rate value.
  */
+#define ZD_PURE_RATE_MASK       0x0f
+#define ZD_MODULATION_TYPE_MASK 0x10
+#define ZD_RATE_MASK            (ZD_PURE_RATE_MASK|ZD_MODULATION_TYPE_MASK)
+#define ZD_PURE_RATE(modulation) ((modulation) & ZD_PURE_RATE_MASK)
+#define ZD_MODULATION_TYPE(modulation) ((modulation) & ZD_MODULATION_TYPE_MASK)
+#define ZD_RATE(modulation) ((modulation) & ZD_RATE_MASK)
+
+/* The two possible modulation types. Notify that 802.11b doesn't use the CCK
+ * codeing for the 1 and 2 MBit/s rate. We stay with the term here to remain
+ * consistent with uses the term at other places.
+  */
+#define ZD_CCK                  0x00
+#define ZD_OFDM                 0x10
+
+/* The ZD1211 firmware uses proprietary encodings of the 802.11b (CCK) rates.
+ * For OFDM the PLCP rate encodings are used. We combine these "pure" rates
+ * with the modulation type flag and call the resulting values zd-rates.
+ */
+#define ZD_CCK_RATE_1M          (ZD_CCK|0x00)
+#define ZD_CCK_RATE_2M          (ZD_CCK|0x01)
+#define ZD_CCK_RATE_5_5M        (ZD_CCK|0x02)
+#define ZD_CCK_RATE_11M         (ZD_CCK|0x03)
+#define ZD_OFDM_RATE_6M         (ZD_OFDM|ZD_OFDM_PLCP_RATE_6M)
+#define ZD_OFDM_RATE_9M         (ZD_OFDM|ZD_OFDM_PLCP_RATE_9M)
+#define ZD_OFDM_RATE_12M        (ZD_OFDM|ZD_OFDM_PLCP_RATE_12M)
+#define ZD_OFDM_RATE_18M        (ZD_OFDM|ZD_OFDM_PLCP_RATE_18M)
+#define ZD_OFDM_RATE_24M        (ZD_OFDM|ZD_OFDM_PLCP_RATE_24M)
+#define ZD_OFDM_RATE_36M        (ZD_OFDM|ZD_OFDM_PLCP_RATE_36M)
+#define ZD_OFDM_RATE_48M        (ZD_OFDM|ZD_OFDM_PLCP_RATE_48M)
+#define ZD_OFDM_RATE_54M        (ZD_OFDM|ZD_OFDM_PLCP_RATE_54M)
 
-/* bit 5 is preamble (when in CCK mode), or a/g selection (when in OFDM mode) */
-#define ZD_CS_CCK_PREA_LONG	0x00
-#define ZD_CS_CCK_PREA_SHORT	0x20
-#define ZD_CS_OFDM_MODE_11G	0x00
-#define ZD_CS_OFDM_MODE_11A	0x20
+/* The bit 5 of the zd_ctrlset modulation field controls the preamble in CCK
+ * mode or the 802.11a/802.11g selection in OFDM mode.
+ */
+#define ZD_CCK_PREA_LONG        0x00
+#define ZD_CCK_PREA_SHORT       0x20
+#define ZD_OFDM_MODE_11G        0x00
+#define ZD_OFDM_MODE_11A        0x20
 
 /* zd_ctrlset control field */
 #define ZD_CS_NEED_RANDOM_BACKOFF	0x01
