Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:12951 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbXHEXS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 19:18:29 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: consistent handling of ZD1211 specific rates
Message-Id: <20070805231815.C9CC77B409F@zog.reactivated.net>
Date: Mon,  6 Aug 2007 00:18:15 +0100 (BST)
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
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.c   |   54 ++++++++-------
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.h   |    5 +-
 .../net/wireless/zd1211rw-mac80211/zd_ieee80211.h  |   42 +++++++----
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c    |   72 ++++++++++---------
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.h    |   62 ++++++++++++-----
 5 files changed, 139 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
index 5adefd8..4513675 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
@@ -1308,7 +1308,7 @@ int zd_chip_set_basic_rates(struct zd_chip *chip, u16 cr_rates)
 	return r;
 }
 
-static int ofdm_qual_db(u8 status_quality, u8 rate, unsigned int size)
+static int ofdm_qual_db(u8 status_quality, u8 zd_rate, unsigned int size)
 {
 	static const u16 constants[] = {
 		715, 655, 585, 540, 470, 410, 360, 315,
@@ -1322,7 +1322,7 @@ static int ofdm_qual_db(u8 status_quality, u8 rate, unsigned int size)
 	/* It seems that their quality parameter is somehow per signal
 	 * and is now transferred per bit.
 	 */
-	switch (rate) {
+	switch (zd_rate) {
 	case ZD_OFDM_RATE_6M:
 	case ZD_OFDM_RATE_12M:
 	case ZD_OFDM_RATE_24M:
@@ -1349,7 +1349,7 @@ static int ofdm_qual_db(u8 status_quality, u8 rate, unsigned int size)
 			break;
 	}
 
-	switch (rate) {
+	switch (zd_rate) {
 	case ZD_OFDM_RATE_6M:
 	case ZD_OFDM_RATE_9M:
 		i += 3;
@@ -1373,11 +1373,11 @@ static int ofdm_qual_db(u8 status_quality, u8 rate, unsigned int size)
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
@@ -1438,52 +1438,54 @@ static int cck_qual_percent(u8 status_quality)
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
+				  zd_rate_from_ofdm_plcp_header(rx_frame),
 			          size) :
 		cck_qual_percent(status->signal_quality_cck);
 }
 
 /**
- * zd_rx_rate - report rate as expected by mac80211
+ * zd_rx_rate - report zd-rate
  * @rx_frame - received frame
  * @rx_status - rx_status as given by the device
  *
- * This function converts the rate as provided in struct rx_status to the
- * format expected by the mac80211 stack. The stack expects the reported rate
- * to use the same format as used in the rates table. This driver has to use
- * the same values as used in the tx control set.
+ * This function converts the rate as encoded in the received packet to the
+ * zd-rate, we are using on other places in the driver.
  */
-u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
+u8 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
 {
-	u16 rate;
+	u8 zd_rate;
 	if (status->frame_status & ZD_RX_OFDM) {
-		rate = ZD_CS_OFDM | zd_ofdm_plcp_header_rate(rx_frame);
+		zd_rate = zd_rate_from_ofdm_plcp_header(rx_frame);
 	} else {
-		u8 cck_rate = zd_cck_plcp_header_rate(rx_frame);
-		switch (cck_rate) {
-		case ZD_CCK_SIGNAL_1M:
-			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_1M;
+		switch (zd_cck_plcp_header_signal(rx_frame)) {
+		case ZD_CCK_PLCP_SIGNAL_1M:
+			zd_rate = ZD_CCK_RATE_1M;
 			break;
-		case ZD_CCK_SIGNAL_2M:
-			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_2M;
+		case ZD_CCK_PLCP_SIGNAL_2M:
+			zd_rate = ZD_CCK_RATE_2M;
 			break;
-		case ZD_CCK_SIGNAL_5M5:
-			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_5_5M;
+		case ZD_CCK_PLCP_SIGNAL_5M5:
+			zd_rate = ZD_CCK_RATE_5_5M;
 			break;
-		case ZD_CCK_SIGNAL_11M:
-			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_11M;
+		case ZD_CCK_PLCP_SIGNAL_11M:
+			zd_rate = ZD_CCK_RATE_11M;
 			break;
 		default:
-			rate = 0;
+			zd_rate = 0;
 		}
 	}
 
-	return rate;
+	return zd_rate;
 }
 
 int zd_chip_switch_radio_on(struct zd_chip *chip)
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
index 1ab15a0..1145827 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
@@ -433,9 +433,10 @@ enum {
 #define CR_GROUP_HASH_P2		CTL_REG(0x0628)
 
 #define CR_RX_TIMEOUT			CTL_REG(0x062C)
+
 /* Basic rates supported by the BSS. When producing ACK or CTS messages, the
  * device will use a rate in this table that is less than or equal to the rate
- * of the incoming frame which prompted the response */
+ * of the incoming frame which prompted the response. */
 #define CR_BASIC_RATE_TBL		CTL_REG(0x0630)
 #define CR_RATE_1M	(1 <<  0)	/* 802.11b */
 #define CR_RATE_2M	(1 <<  1)	/* 802.11b */
@@ -873,7 +874,7 @@ struct rx_status;
 u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 	               const struct rx_status *status);
 
-u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
+u8 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
 
 struct zd_mc_hash {
 	u32 low;
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_ieee80211.h b/drivers/net/wireless/zd1211rw-mac80211/zd_ieee80211.h
index 6485f98..98b87cf 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_ieee80211.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_ieee80211.h
@@ -28,20 +28,25 @@ struct ofdm_plcp_header {
 	__le16 service;
 } __attribute__((packed));
 
-static inline u8 zd_ofdm_plcp_header_rate(
-	const struct ofdm_plcp_header *header)
+static inline u8 zd_ofdm_plcp_header_rate(const struct ofdm_plcp_header *header)
 {
 	return header->prefix[0] & 0xf;
 }
 
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
+#define ZD_OFDM_PLCP_RATE_6M	0xb
+#define ZD_OFDM_PLCP_RATE_9M	0xf
+#define ZD_OFDM_PLCP_RATE_12M	0xa
+#define ZD_OFDM_PLCP_RATE_18M	0xe
+#define ZD_OFDM_PLCP_RATE_24M	0x9
+#define ZD_OFDM_PLCP_RATE_36M	0xd
+#define ZD_OFDM_PLCP_RATE_48M	0x8
+#define ZD_OFDM_PLCP_RATE_54M	0xc
 
 struct cck_plcp_header {
 	u8 signal;
@@ -50,14 +55,21 @@ struct cck_plcp_header {
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
 
 #endif /* _ZD_IEEE80211_H */
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
index d646bfd..cef5492 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
@@ -28,46 +28,46 @@
 #include "zd_rf.h"
 #include "zd_util.h"
 
-/* TODO: remove this once we have a general modes/channels/rates filling func */
+/* This table contains the hardware specific values for the modulation rates. */
 static const struct ieee80211_rate zd_rates[] = {
 	{ .rate = 10,
-	  .val = ZD_CS_CCK | ZD_CS_CCK_RATE_1M,
+	  .val = ZD_CCK_RATE_1M,
 	  .flags = IEEE80211_RATE_CCK },
 	{ .rate = 20,
-	  .val = ZD_CS_CCK | ZD_CS_CCK_RATE_2M,
-	  .val2 = ZD_CS_CCK | ZD_CS_CCK_RATE_2M | ZD_CS_CCK_PREA_SHORT,
+	  .val = ZD_CCK_RATE_2M,
+	  .val2 = ZD_CCK_RATE_2M | ZD_CCK_PREA_SHORT,
 	  .flags = IEEE80211_RATE_CCK_2 },
 	{ .rate = 55,
-	  .val = ZD_CS_CCK | ZD_CS_CCK_RATE_5_5M,
-	  .val2 = ZD_CS_CCK | ZD_CS_CCK_RATE_5_5M | ZD_CS_CCK_PREA_SHORT,
+	  .val = ZD_CCK_RATE_5_5M,
+	  .val2 = ZD_CCK_RATE_5_5M | ZD_CCK_PREA_SHORT,
 	  .flags = IEEE80211_RATE_CCK_2 },
 	{ .rate = 110,
-	  .val = ZD_CS_CCK | ZD_CS_CCK_RATE_11M,
-	  .val2 = ZD_CS_CCK | ZD_CS_CCK_RATE_11M | ZD_CS_CCK_PREA_SHORT,
+	  .val = ZD_CCK_RATE_11M,
+	  .val2 = ZD_CCK_RATE_11M | ZD_CCK_PREA_SHORT,
 	  .flags = IEEE80211_RATE_CCK_2 },
 	{ .rate = 60,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_6M,
+	  .val = ZD_OFDM_RATE_6M,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 90,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_9M,
+	  .val = ZD_OFDM_RATE_9M,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 120,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_12M,
+	  .val = ZD_OFDM_RATE_12M,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 180,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_18M,
+	  .val = ZD_OFDM_RATE_18M,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 240,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_24M,
+	  .val = ZD_OFDM_RATE_24M,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 360,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_36M,
+	  .val = ZD_OFDM_RATE_36M,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 480,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_48M,
+	  .val = ZD_OFDM_RATE_48M,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 540,
-	  .val = ZD_CS_OFDM | ZD_OFDM_RATE_54M,
+	  .val = ZD_OFDM_RATE_54M,
 	  .flags = IEEE80211_RATE_OFDM },
 };
 
@@ -426,35 +426,39 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 	}
 }
 
-static int zd_calc_tx_length_us(u8 *service, u8 cs_rate, u16 tx_length)
+static int zd_calc_tx_length_us(u8 *service, u8 zd_rate, u16 tx_length)
 {
+	/* ZD_PURE_RATE() must be used to remove the modulation type flag of
+	 * the zd-rate values.
+	 */
 	static const u8 rate_divisor[] = {
-		[ZD_CS_CCK_RATE_1M]	=  1,
-		[ZD_CS_CCK_RATE_2M]	=  2,
-		[ZD_CS_CCK_RATE_5_5M]	= 11, /* bits must be doubled */
-		[ZD_CS_CCK_RATE_11M]	= 11,
-		[ZD_OFDM_RATE_6M]	=  6,
-		[ZD_OFDM_RATE_9M]	=  9,
-		[ZD_OFDM_RATE_12M]	= 12,
-		[ZD_OFDM_RATE_18M]	= 18,
-		[ZD_OFDM_RATE_24M]	= 24,
-		[ZD_OFDM_RATE_36M]	= 36,
-		[ZD_OFDM_RATE_48M]	= 48,
-		[ZD_OFDM_RATE_54M]	= 54,
+		[ZD_PURE_RATE(ZD_CCK_RATE_1M)]   =  1,
+		[ZD_PURE_RATE(ZD_CCK_RATE_2M)]	 =  2,
+		/* Bits must be doubled. */
+		[ZD_PURE_RATE(ZD_CCK_RATE_5_5M)] = 11,
+		[ZD_PURE_RATE(ZD_CCK_RATE_11M)]	 = 11,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_6M)]  =  6,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_9M)]  =  9,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_12M)] = 12,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_18M)] = 18,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_24M)] = 24,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_36M)] = 36,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_48M)] = 48,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_54M)] = 54,
 	};
 
 	u32 bits = (u32)tx_length * 8;
 	u32 divisor;
 
-	divisor = rate_divisor[cs_rate];
+	divisor = rate_divisor[ZD_PURE_RATE(zd_rate)];
 	if (divisor == 0)
 		return -EINVAL;
 
-	switch (cs_rate) {
-	case ZD_CS_CCK_RATE_5_5M:
+	switch (zd_rate) {
+	case ZD_CCK_RATE_5_5M:
 		bits = (2*bits) + 10; /* round up to the next integer */
 		break;
-	case ZD_CS_CCK_RATE_11M:
+	case ZD_CCK_RATE_11M:
 		if (service) {
 			u32 t = bits % 11;
 			*service &= ~ZD_PLCP_SERVICE_LENGTH_EXTENSION;
@@ -555,7 +559,7 @@ static int fill_ctrlset(struct zd_mac *mac,
 	 * - see line 53 of zdinlinef.h
 	 */
 	cs->service = 0;
-	r = zd_calc_tx_length_us(&cs->service, ZD_CS_RATE(cs->modulation),
+	r = zd_calc_tx_length_us(&cs->service, ZD_RATE(cs->modulation),
 		                 le16_to_cpu(cs->tx_length));
 	if (r < 0)
 		return r;
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
index 4255b10..27289a7 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
@@ -37,27 +37,51 @@ struct zd_ctrlset {
 
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
-#define ZD_CS_CCK_RATE_1M	0x00
-#define ZD_CS_CCK_RATE_2M	0x01
-#define ZD_CS_CCK_RATE_5_5M	0x02
-#define ZD_CS_CCK_RATE_11M	0x03
-/* The rates for OFDM are encoded as in the PLCP header. Use ZD_OFDM_RATE_*.
+/* The field modulation of struct zd_ctrlset controls the bit rate, the use
+ * of short or long preambles in 802.11b (CCK mode) or the use of 802.11a or
+ * 802.11g in OFDM mode.
+ *
+ * The term zd-rate is used for the combination of the modulation type flag
+ * and the "pure" rate value.
+ */
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
  */
+#define ZD_CCK                  0x00
+#define ZD_OFDM                 0x10
 
-/* bit 5 is preamble (when in CCK mode), or a/g selection (when in OFDM mode) */
-#define ZD_CS_CCK_PREA_LONG	0x00
-#define ZD_CS_CCK_PREA_SHORT	0x20
-#define ZD_CS_OFDM_MODE_11G	0x00
-#define ZD_CS_OFDM_MODE_11A	0x20
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
+
+/* The bit 5 of the zd_ctrlset modulation field controls the preamble in CCK
+ * mode or the 802.11a/802.11g selection in OFDM mode.
+ */
+#define ZD_CCK_PREA_LONG        0x00
+#define ZD_CCK_PREA_SHORT       0x20
+#define ZD_OFDM_MODE_11G        0x00
+#define ZD_OFDM_MODE_11A        0x20
 
 /* zd_ctrlset control field */
 #define ZD_CS_NEED_RANDOM_BACKOFF	0x01
-- 
1.5.2.4

