Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:23319 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756044AbYGWSjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 14:39:23 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] ath5k: rates cleanup
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 23 Jul 2008 20:38:56 +0200
Message-ID: <20080723183856.16846.19518.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cleanup the rates structures used by ath5k. instead of separate driver and
mac80211 rate structures we now setup a static ieee80211_rate array and use it
directly. no conversion between two different rate structures has to be done
any more. a lot of unused and confusing junk was deleted.

renamed ath5k_getchannels into ath5k_setup_bands because this is what it does.
rewrote it to copy the bitrates correctly for each band. this is necessary for
running different hardware with the same driver (e.g. 5211 and 5212 based
cards).

add special handling of rates for AR5211 chipsets: it uses different rate codes
for CCK rates (which are actually like the other chips but with a 0xF mask).

setup a hardware code to rate index reverse mapping table for getting the rate
index of received frames.

the rates for control frames which have to be set in
ath5k_hw_write_rate_duration are now in one single array.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/ath5k/ath5k.h |  162 +++++------------------
 drivers/net/wireless/ath5k/base.c  |  254 +++++++++++++++++-------------------
 drivers/net/wireless/ath5k/base.h  |    8 -
 drivers/net/wireless/ath5k/debug.c |    1 
 drivers/net/wireless/ath5k/hw.c    |   76 +++--------
 5 files changed, 172 insertions(+), 329 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index ba35c30..8df517d 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -269,11 +269,6 @@ enum ath5k_driver_mode {
 /* adding this flag to rate_code enables short preamble, see ar5212_reg.h */
 #define AR5K_SET_SHORT_PREAMBLE 0x04
 
-#define HAS_SHPREAMBLE(_ix) \
-	(rt->rates[_ix].modulation == IEEE80211_RATE_SHORT_PREAMBLE)
-#define SHPREAMBLE_FLAG(_ix) \
-	(HAS_SHPREAMBLE(_ix) ? AR5K_SET_SHORT_PREAMBLE : 0)
-
 
 /****************\
   TX DEFINITIONS
@@ -566,152 +561,61 @@ struct ath5k_athchan_2ghz {
 	u16	a2_athchan;
 };
 
+
 /*
  * Rate definitions
- * TODO: Clean them up or move them on mac80211 -most of these infos are
- * 	 used by the rate control algorytm on MadWiFi.
  */
 
-/* Max number of rates on the rate table and what it seems
- * Atheros hardware supports */
-#define AR5K_MAX_RATES 32
-
 /**
- * struct ath5k_rate - rate structure
- * @valid: is this a valid rate for rate control (remove)
- * @modulation: respective mac80211 modulation
- * @rate_kbps: rate in kbit/s
- * @rate_code: hardware rate value, used in &struct ath5k_desc, on RX on
- *     &struct ath5k_rx_status.rs_rate and on TX on
- *     &struct ath5k_tx_status.ts_rate. Seems the ar5xxx harware supports
- *     up to 32 rates, indexed by 1-32. This means we really only need
- *     6 bits for the rate_code.
- * @dot11_rate: respective IEEE-802.11 rate value
- * @control_rate: index of rate assumed to be used to send control frames.
- *     This can be used to set override the value on the rate duration
- *     registers. This is only useful if we can override in the harware at
- *     what rate we want to send control frames at. Note that IEEE-802.11
- *     Ch. 9.6 (after IEEE 802.11g changes) defines the rate at which we
- *     should send ACK/CTS, if we change this value we can be breaking
- *     the spec.
+ * Seems the ar5xxx harware supports up to 32 rates, indexed by 1-32.
  *
- * This structure is used to get the RX rate or set the TX rate on the
+ * The rate code is used to get the RX rate or set the TX rate on the
  * hardware descriptors. It is also used for internal modulation control
  * and settings.
  *
- * On RX after the &struct ath5k_desc is parsed by the appropriate
- * ah_proc_rx_desc() the respective hardware rate value is set in
- * &struct ath5k_rx_status.rs_rate. On TX the desired rate is set in
- * &struct ath5k_tx_status.ts_rate which is later used to setup the
- * &struct ath5k_desc correctly. This is the hardware rate map we are
- * aware of:
+ * This is the hardware rate map we are aware of:
  *
- * rate_code   1       2       3       4       5       6       7       8
+ * rate_code   0x01    0x02    0x03    0x04    0x05    0x06    0x07    0x08
  * rate_kbps   3000    1000    ?       ?       ?       2000    500     48000
  *
- * rate_code   9       10      11      12      13      14      15      16
+ * rate_code   0x09    0x0A    0x0B    0x0C    0x0D    0x0E    0x0F    0x10
  * rate_kbps   24000   12000   6000    54000   36000   18000   9000    ?
  *
  * rate_code   17      18      19      20      21      22      23      24
  * rate_kbps   ?       ?       ?       ?       ?       ?       ?       11000
  *
  * rate_code   25      26      27      28      29      30      31      32
- * rate_kbps   5500    2000    1000    ?       ?       ?       ?       ?
+ * rate_kbps   5500    2000    1000    11000S  5500S   2000S   ?       ?
  *
+ * "S" indicates CCK rates with short preamble.
+ *
+ * AR5211 has different rate codes for CCK (802.11B) rates. It only uses the
+ * lowest 4 bits, so they are the same as below with a 0xF mask.
+ * (0xB, 0xA, 0x9 and 0x8 for 1M, 2M, 5.5M and 11M).
+ * We handle this in ath5k_setup_bands().
  */
-struct ath5k_rate {
-	u8	valid;
-	u32	modulation;
-	u16	rate_kbps;
-	u8	rate_code;
-	u8	dot11_rate;
-	u8	control_rate;
-};
-
-/* XXX: GRR all this stuff to get leds blinking ??? (check out setcurmode) */
-struct ath5k_rate_table {
-	u16	rate_count;
-	u8	rate_code_to_index[AR5K_MAX_RATES];	/* Back-mapping */
-	struct ath5k_rate rates[AR5K_MAX_RATES];
-};
-
-/*
- * Rate tables...
- * TODO: CLEAN THIS !!!
- */
-#define AR5K_RATES_11A { 8, {					\
-	255, 255, 255, 255, 255, 255, 255, 255, 6, 4, 2, 0,	\
-	7, 5, 3, 1, 255, 255, 255, 255, 255, 255, 255, 255,	\
-	255, 255, 255, 255, 255, 255, 255, 255 }, {		\
-	{ 1, 0, 6000, 11, 140, 0 },		\
-	{ 1, 0, 9000, 15, 18, 0 },		\
-	{ 1, 0, 12000, 10, 152, 2 },		\
-	{ 1, 0, 18000, 14, 36, 2 },		\
-	{ 1, 0, 24000, 9, 176, 4 },		\
-	{ 1, 0, 36000, 13, 72, 4 },		\
-	{ 1, 0, 48000, 8, 96, 4 },		\
-	{ 1, 0, 54000, 12, 108, 4 } }		\
-}
-
-#define AR5K_RATES_11B { 4, {						\
-	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,	\
-	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,	\
-	3, 2, 1, 0, 255, 255, 255, 255 }, {				\
-	{ 1, 0, 1000, 27, 130, 0 },	\
-	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 2000, 26, 132, 1 },	\
-	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 5500, 25, 139, 1 },	\
-	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 11000, 24, 150, 1 } }	\
-}
-
-#define AR5K_RATES_11G { 12, {					\
-	255, 255, 255, 255, 255, 255, 255, 255, 10, 8, 6, 4,	\
-	11, 9, 7, 5, 255, 255, 255, 255, 255, 255, 255, 255,	\
-	3, 2, 1, 0, 255, 255, 255, 255 }, {			\
-	{ 1, 0, 1000, 27, 2, 0 },		\
-	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 2000, 26, 4, 1 },		\
-	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 5500, 25, 11, 1 },		\
-	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 11000, 24, 22, 1 },	\
-	{ 0, 0, 6000, 11, 12, 4 },	\
-	{ 0, 0, 9000, 15, 18, 4 },	\
-	{ 1, 0, 12000, 10, 24, 6 },	\
-	{ 1, 0, 18000, 14, 36, 6 },	\
-	{ 1, 0, 24000, 9, 48, 8 },	\
-	{ 1, 0, 36000, 13, 72, 8 },	\
-	{ 1, 0, 48000, 8, 96, 8 },	\
-	{ 1, 0, 54000, 12, 108, 8 } }	\
-}
+#define AR5K_MAX_RATES 32
 
-#define AR5K_RATES_TURBO { 8, {					\
-	255, 255, 255, 255, 255, 255, 255, 255, 6, 4, 2, 0,	\
-	7, 5, 3, 1, 255, 255, 255, 255, 255, 255, 255, 255,	\
-	255, 255, 255, 255, 255, 255, 255, 255 }, {		\
-	{ 1, MODULATION_TURBO, 6000, 11, 140, 0 },	\
-	{ 1, MODULATION_TURBO, 9000, 15, 18, 0 },	\
-	{ 1, MODULATION_TURBO, 12000, 10, 152, 2 },	\
-	{ 1, MODULATION_TURBO, 18000, 14, 36, 2 },	\
-	{ 1, MODULATION_TURBO, 24000, 9, 176, 4 },	\
-	{ 1, MODULATION_TURBO, 36000, 13, 72, 4 },	\
-	{ 1, MODULATION_TURBO, 48000, 8, 96, 4 },	\
-	{ 1, MODULATION_TURBO, 54000, 12, 108, 4 } }	\
-}
+/* B */
+#define ATH5K_RATE_CODE_1M	0x1B
+#define ATH5K_RATE_CODE_2M	0x1A
+#define ATH5K_RATE_CODE_5_5M	0x19
+#define ATH5K_RATE_CODE_11M	0x18
+/* A and G */
+#define ATH5K_RATE_CODE_6M	0x0B
+#define ATH5K_RATE_CODE_9M	0x0F
+#define ATH5K_RATE_CODE_12M	0x0A
+#define ATH5K_RATE_CODE_18M	0x0E
+#define ATH5K_RATE_CODE_24M	0x09
+#define ATH5K_RATE_CODE_36M	0x0D
+#define ATH5K_RATE_CODE_48M	0x08
+#define ATH5K_RATE_CODE_54M	0x0C
+/* XR */
+#define ATH5K_RATE_CODE_XR_500K	0x07
+#define ATH5K_RATE_CODE_XR_1M	0x02
+#define ATH5K_RATE_CODE_XR_2M	0x06
+#define ATH5K_RATE_CODE_XR_3M	0x01
 
-#define AR5K_RATES_XR { 12, {					\
-	255, 3, 1, 255, 255, 255, 2, 0, 10, 8, 6, 4,		\
-	11, 9, 7, 5, 255, 255, 255, 255, 255, 255, 255, 255,	\
-	255, 255, 255, 255, 255, 255, 255, 255 }, {		\
-	{ 1, MODULATION_XR, 500, 7, 129, 0 },		\
-	{ 1, MODULATION_XR, 1000, 2, 139, 1 },		\
-	{ 1, MODULATION_XR, 2000, 6, 150, 2 },		\
-	{ 1, MODULATION_XR, 3000, 1, 150, 3 },		\
-	{ 1, 0, 6000, 11, 140, 4 },	\
-	{ 1, 0, 9000, 15, 18, 4 },	\
-	{ 1, 0, 12000, 10, 152, 6 },	\
-	{ 1, 0, 18000, 14, 36, 6 },	\
-	{ 1, 0, 24000, 9, 176, 8 },	\
-	{ 1, 0, 36000, 13, 72, 8 },	\
-	{ 1, 0, 48000, 8, 96, 8 },	\
-	{ 1, 0, 54000, 12, 108, 8 } }	\
-}
 
 /*
  * Crypto definitions
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 217d506..1be5439 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -133,6 +133,48 @@ static struct ath5k_srev_name srev_names[] = {
 	{ "xxxxx",	AR5K_VERSION_RAD,	AR5K_SREV_UNKNOWN },
 };
 
+static struct ieee80211_rate ath5k_rates[] = {
+	{ .bitrate = 10,
+	  .hw_value = ATH5K_RATE_CODE_1M, },
+	{ .bitrate = 20,
+	  .hw_value = ATH5K_RATE_CODE_2M,
+	  .hw_value_short = ATH5K_RATE_CODE_2M | AR5K_SET_SHORT_PREAMBLE,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55,
+	  .hw_value = ATH5K_RATE_CODE_5_5M,
+	  .hw_value_short = ATH5K_RATE_CODE_5_5M | AR5K_SET_SHORT_PREAMBLE,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110,
+	  .hw_value = ATH5K_RATE_CODE_11M,
+	  .hw_value_short = ATH5K_RATE_CODE_11M | AR5K_SET_SHORT_PREAMBLE,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60,
+	  .hw_value = ATH5K_RATE_CODE_6M,
+	  .flags = 0 },
+	{ .bitrate = 90,
+	  .hw_value = ATH5K_RATE_CODE_9M,
+	  .flags = 0 },
+	{ .bitrate = 120,
+	  .hw_value = ATH5K_RATE_CODE_12M,
+	  .flags = 0 },
+	{ .bitrate = 180,
+	  .hw_value = ATH5K_RATE_CODE_18M,
+	  .flags = 0 },
+	{ .bitrate = 240,
+	  .hw_value = ATH5K_RATE_CODE_24M,
+	  .flags = 0 },
+	{ .bitrate = 360,
+	  .hw_value = ATH5K_RATE_CODE_36M,
+	  .flags = 0 },
+	{ .bitrate = 480,
+	  .hw_value = ATH5K_RATE_CODE_48M,
+	  .flags = 0 },
+	{ .bitrate = 540,
+	  .hw_value = ATH5K_RATE_CODE_54M,
+	  .flags = 0 },
+	/* XR missing */
+};
+
 /*
  * Prototypes - PCI stack related functions
  */
@@ -219,20 +261,16 @@ static void 	ath5k_detach(struct pci_dev *pdev,
 			struct ieee80211_hw *hw);
 /* Channel/mode setup */
 static inline short ath5k_ieee2mhz(short chan);
-static unsigned int ath5k_copy_rates(struct ieee80211_rate *rates,
-				const struct ath5k_rate_table *rt,
-				unsigned int max);
 static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
 				struct ieee80211_channel *channels,
 				unsigned int mode,
 				unsigned int max);
-static int 	ath5k_getchannels(struct ieee80211_hw *hw);
+static int 	ath5k_setup_bands(struct ieee80211_hw *hw);
 static int 	ath5k_chan_set(struct ath5k_softc *sc,
 				struct ieee80211_channel *chan);
 static void	ath5k_setcurmode(struct ath5k_softc *sc,
 				unsigned int mode);
 static void	ath5k_mode_setup(struct ath5k_softc *sc);
-static void	ath5k_set_total_hw_rates(struct ath5k_softc *sc);
 
 /* Descriptor setup */
 static int	ath5k_desc_alloc(struct ath5k_softc *sc,
@@ -639,7 +677,6 @@ ath5k_pci_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 
-
 /***********************\
 * Driver Initialization *
 \***********************/
@@ -681,15 +718,12 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * on settings like the phy mode and regulatory
 	 * domain restrictions.
 	 */
-	ret = ath5k_getchannels(hw);
+	ret = ath5k_setup_bands(hw);
 	if (ret) {
 		ATH5K_ERR(sc, "can't get channels\n");
 		goto err;
 	}
 
-	/* Set *_rates so we can map hw rate index */
-	ath5k_set_total_hw_rates(sc);
-
 	/* NB: setup here so ath5k_rate_update is happy */
 	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
 		ath5k_setcurmode(sc, AR5K_MODE_11A);
@@ -806,27 +840,6 @@ ath5k_ieee2mhz(short chan)
 }
 
 static unsigned int
-ath5k_copy_rates(struct ieee80211_rate *rates,
-		const struct ath5k_rate_table *rt,
-		unsigned int max)
-{
-	unsigned int i, count;
-
-	if (rt == NULL)
-		return 0;
-
-	for (i = 0, count = 0; i < rt->rate_count && max > 0; i++) {
-		rates[count].bitrate = rt->rates[i].rate_kbps / 100;
-		rates[count].hw_value = rt->rates[i].rate_code;
-		rates[count].flags = rt->rates[i].modulation;
-		count++;
-		max--;
-	}
-
-	return count;
-}
-
-static unsigned int
 ath5k_copy_channels(struct ath5k_hw *ah,
 		struct ieee80211_channel *channels,
 		unsigned int mode,
@@ -888,74 +901,97 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 	return count;
 }
 
+static void
+ath5k_setup_rate_idx(struct ath5k_softc *sc, struct ieee80211_supported_band *b)
+{
+	u8 i;
+
+	for (i = 0; i < AR5K_MAX_RATES; i++)
+		sc->rate_idx[b->band][i] = -1;
+
+	for (i = 0; i < b->n_bitrates; i++) {
+		sc->rate_idx[b->band][b->bitrates[i].hw_value] = i;
+		if (b->bitrates[i].hw_value_short)
+			sc->rate_idx[b->band][b->bitrates[i].hw_value_short] = i;
+	}
+}
+
 static int
-ath5k_getchannels(struct ieee80211_hw *hw)
+ath5k_setup_bands(struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
-	struct ieee80211_supported_band *sbands = sc->sbands;
-	const struct ath5k_rate_table *hw_rates;
-	unsigned int max_r, max_c, count_r, count_c;
-	int mode2g = AR5K_MODE_11G;
+	struct ieee80211_supported_band *sband;
+	int max_c, count_c = 0;
+	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(sc->sbands) < IEEE80211_NUM_BANDS);
-
-	max_r = ARRAY_SIZE(sc->rates);
 	max_c = ARRAY_SIZE(sc->channels);
-	count_r = count_c = 0;
 
 	/* 2GHz band */
-	if (!test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)) {
-		mode2g = AR5K_MODE_11B;
-		if (!test_bit(AR5K_MODE_11B,
-			sc->ah->ah_capabilities.cap_mode))
-			mode2g = -1;
-	}
+	sband = &sc->sbands[IEEE80211_BAND_2GHZ];
+	sband->band = IEEE80211_BAND_2GHZ;
+	sband->bitrates = &sc->rates[IEEE80211_BAND_2GHZ][0];
 
-	if (mode2g > 0) {
-		struct ieee80211_supported_band *sband =
-			&sbands[IEEE80211_BAND_2GHZ];
+	if (test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)) {
+		/* G mode */
+		memcpy(sband->bitrates, &ath5k_rates[0],
+		       sizeof(struct ieee80211_rate) * 12);
+		sband->n_bitrates = 12;
 
-		sband->bitrates = sc->rates;
 		sband->channels = sc->channels;
-
-		sband->band = IEEE80211_BAND_2GHZ;
 		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
-					mode2g, max_c);
-
-		hw_rates = ath5k_hw_get_rate_table(ah, mode2g);
-		sband->n_bitrates = ath5k_copy_rates(sband->bitrates,
-					hw_rates, max_r);
+					AR5K_MODE_11G, max_c);
 
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
 		count_c = sband->n_channels;
-		count_r = sband->n_bitrates;
+		max_c -= count_c;
+	} else if (test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)) {
+		/* B mode */
+		memcpy(sband->bitrates, &ath5k_rates[0],
+		       sizeof(struct ieee80211_rate) * 4);
+		sband->n_bitrates = 4;
+
+		/* 5211 only supports B rates and uses 4bit rate codes
+		 * (e.g normally we have 0x1B for 1M, but on 5211 we have 0x0B)
+		 * fix them up here:
+		 */
+		if (ah->ah_version == AR5K_AR5211) {
+			for (i = 0; i < 4; i++) {
+				sband->bitrates[i].hw_value =
+					sband->bitrates[i].hw_value & 0xF;
+				sband->bitrates[i].hw_value_short =
+					sband->bitrates[i].hw_value_short & 0xF;
+			}
+		}
 
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		sband->channels = sc->channels;
+		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
+					AR5K_MODE_11B, max_c);
 
-		max_r -= count_r;
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		count_c = sband->n_channels;
 		max_c -= count_c;
-
 	}
+	ath5k_setup_rate_idx(sc, sband);
 
-	/* 5GHz band */
-
+	/* 5GHz band, A mode */
 	if (test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)) {
-		struct ieee80211_supported_band *sband =
-			&sbands[IEEE80211_BAND_5GHZ];
+		sband = &sc->sbands[IEEE80211_BAND_5GHZ];
+		sband->band = IEEE80211_BAND_5GHZ;
+		sband->bitrates = &sc->rates[IEEE80211_BAND_5GHZ][0];
 
-		sband->bitrates = &sc->rates[count_r];
-		sband->channels = &sc->channels[count_c];
+		memcpy(sband->bitrates, &ath5k_rates[4],
+		       sizeof(struct ieee80211_rate) * 8);
+		sband->n_bitrates = 8;
 
-		sband->band = IEEE80211_BAND_5GHZ;
+		sband->channels = &sc->channels[count_c];
 		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
 					AR5K_MODE_11A, max_c);
 
-		hw_rates = ath5k_hw_get_rate_table(ah, AR5K_MODE_11A);
-		sband->n_bitrates = ath5k_copy_rates(sband->bitrates,
-					hw_rates, max_r);
-
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
 	}
+	ath5k_setup_rate_idx(sc, sband);
 
 	ath5k_debug_dump_bands(sc);
 
@@ -1061,75 +1097,13 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
 }
 
-/*
- * Match the hw provided rate index (through descriptors)
- * to an index for sc->curband->bitrates, so it can be used
- * by the stack.
- *
- * This one is a little bit tricky but i think i'm right
- * about this...
- *
- * We have 4 rate tables in the following order:
- * XR (4 rates)
- * 802.11a (8 rates)
- * 802.11b (4 rates)
- * 802.11g (12 rates)
- * that make the hw rate table.
- *
- * Lets take a 5211 for example that supports a and b modes only.
- * First comes the 802.11a table and then 802.11b (total 12 rates).
- * When hw returns eg. 11 it points to the last 802.11b rate (11Mbit),
- * if it returns 2 it points to the second 802.11a rate etc.
- *
- * Same goes for 5212 who has xr/a/b/g support (total 28 rates).
- * First comes the XR table, then 802.11a, 802.11b and 802.11g.
- * When hw returns eg. 27 it points to the last 802.11g rate (54Mbits) etc
- */
-static void
-ath5k_set_total_hw_rates(struct ath5k_softc *sc) {
-
-	struct ath5k_hw *ah = sc->ah;
-
-	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
-		sc->a_rates = 8;
-
-	if (test_bit(AR5K_MODE_11B, ah->ah_modes))
-		sc->b_rates = 4;
-
-	if (test_bit(AR5K_MODE_11G, ah->ah_modes))
-		sc->g_rates = 12;
-
-	/* XXX: Need to see what what happens when
-		xr disable bits in eeprom are set */
-	if (ah->ah_version >= AR5K_AR5212)
-		sc->xr_rates = 4;
-
-}
-
 static inline int
-ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix) {
-
-	int mac80211_rix;
-
-	if(sc->curband->band == IEEE80211_BAND_2GHZ) {
-		/* We setup a g ratetable for both b/g modes */
-		mac80211_rix =
-			hw_rix - sc->b_rates - sc->a_rates - sc->xr_rates;
-	} else {
-		mac80211_rix = hw_rix - sc->xr_rates;
-	}
-
-	/* Something went wrong, fallback to basic rate for this band */
-	if ((mac80211_rix >= sc->curband->n_bitrates) ||
-		(mac80211_rix <= 0 ))
-		mac80211_rix = 1;
-
-	return mac80211_rix;
+ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
+{
+	WARN_ON(hw_rix < 0 || hw_rix > AR5K_MAX_RATES);
+	return sc->rate_idx[sc->curband->band][hw_rix];
 }
 
-
-
-
 /***************\
 * Buffers setup *
 \***************/
@@ -1806,6 +1780,12 @@ accept:
 		rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
 		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
 
+#if 0		/* add rxs.flag SHORTPRE once it is in mac80211 */
+		if (rs.rs_rate >= ATH5K_RATE_CODE_2M &&
+		    rs.rs_rate <= ATH5K_RATE_CODE_11M &&
+		    rs.rs_rate & AR5K_SET_SHORT_PREAMBLE)
+			rxs.flag |= RX_FLAG_SHORTPRE;
+#endif
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
 		/* check beacons in IBSS mode */
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 47f414b..f6bbb04 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -111,17 +111,13 @@ struct ath5k_softc {
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
-	struct ieee80211_rate	rates[AR5K_MAX_RATES * IEEE80211_NUM_BANDS];
+	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	u8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
 	enum ieee80211_if_types	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
 	struct ieee80211_supported_band		*curband;
 
-	u8			a_rates;
-	u8			b_rates;
-	u8			g_rates;
-	u8			xr_rates;
-
 #ifdef CONFIG_ATH5K_DEBUG
 	struct ath5k_dbg_info	debug;		/* debug info */
 #endif /* CONFIG_ATH5K_DEBUG */
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 41d5fa3..4c22826 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -488,6 +488,7 @@ ath5k_debug_dump_bands(struct ath5k_softc *sc)
 					band->channels[i].center_freq,
 					band->channels[i].hw_value,
 					band->channels[i].flags);
+
 		printk(KERN_DEBUG " rates:\n");
 		for (i = 0; i < band->n_bitrates; i++)
 			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index c6d12c5..8bff2b8 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -31,13 +31,6 @@
 #include "base.h"
 #include "debug.h"
 
-/* Rate tables */
-static const struct ath5k_rate_table ath5k_rt_11a = AR5K_RATES_11A;
-static const struct ath5k_rate_table ath5k_rt_11b = AR5K_RATES_11B;
-static const struct ath5k_rate_table ath5k_rt_11g = AR5K_RATES_11G;
-static const struct ath5k_rate_table ath5k_rt_turbo = AR5K_RATES_TURBO;
-static const struct ath5k_rate_table ath5k_rt_xr = AR5K_RATES_XR;
-
 /* Prototypes */
 static int ath5k_hw_nic_reset(struct ath5k_hw *, u32);
 static int ath5k_hw_nic_wakeup(struct ath5k_hw *, int, bool);
@@ -535,34 +528,6 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 }
 
 /*
- * Get the rate table for a specific operation mode
- */
-const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah,
-		unsigned int mode)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	if (!test_bit(mode, ah->ah_capabilities.cap_mode))
-		return NULL;
-
-	/* Get rate tables */
-	switch (mode) {
-	case AR5K_MODE_11A:
-		return &ath5k_rt_11a;
-	case AR5K_MODE_11A_TURBO:
-		return &ath5k_rt_turbo;
-	case AR5K_MODE_11B:
-		return &ath5k_rt_11b;
-	case AR5K_MODE_11G:
-		return &ath5k_rt_11g;
-	case AR5K_MODE_11G_TURBO:
-		return &ath5k_rt_xr;
-	}
-
-	return NULL;
-}
-
-/*
  * Free the ath5k_hw struct
  */
 void ath5k_hw_detach(struct ath5k_hw *ah)
@@ -632,45 +597,42 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 	return 0;
 }
 
+
+/*
+ * index into rates for control rates, we can set it up like this because
+ * this is only used for AR5212 and we know it supports G mode
+ */
+static int control_rates[] =
+	{ 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
+
 /**
  * ath5k_hw_write_rate_duration - set rate duration during hw resets
  *
  * @ah: the &struct ath5k_hw
  * @mode: one of enum ath5k_driver_mode
  *
- * Write the rate duration table for the current mode upon hw reset. This
- * is a helper for ath5k_hw_reset(). It seems all this is doing is setting
- * an ACK timeout for the hardware for the current mode for each rate. The
- * rates which are capable of short preamble (802.11b rates 2Mbps, 5.5Mbps,
- * and 11Mbps) have another register for the short preamble ACK timeout
- * calculation.
- *
+ * Write the rate duration table upon hw reset. This is a helper for
+ * ath5k_hw_reset(). It seems all this is doing is setting an ACK timeout for
+ * the hardware for the current mode for each rate. The rates which are capable
+ * of short preamble (802.11b rates 2Mbps, 5.5Mbps, and 11Mbps) have another
+ * register for the short preamble ACK timeout calculation.
  */
 static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
        unsigned int mode)
 {
 	struct ath5k_softc *sc = ah->ah_sc;
-	const struct ath5k_rate_table *rt;
-	struct ieee80211_rate srate = {};
+	struct ieee80211_rate *rate;
 	unsigned int i;
 
-	/* Get rate table for the current operating mode */
-	rt = ath5k_hw_get_rate_table(ah, mode);
-
 	/* Write rate duration table */
-	for (i = 0; i < rt->rate_count; i++) {
-		const struct ath5k_rate *rate, *control_rate;
-
+	for (i = 0; i < sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates; i++) {
 		u32 reg;
 		u16 tx_time;
 
-		rate = &rt->rates[i];
-		control_rate = &rt->rates[rate->control_rate];
+		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[control_rates[i]];
 
 		/* Set ACK timeout */
-		reg = AR5K_RATE_DUR(rate->rate_code);
-
-		srate.bitrate = control_rate->rate_kbps/100;
+		reg = AR5K_RATE_DUR(rate->hw_value);
 
 		/* An ACK frame consists of 10 bytes. If you add the FCS,
 		 * which ieee80211_generic_frame_duration() adds,
@@ -679,11 +641,11 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
 		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
-							sc->vif, 10, &srate));
+							sc->vif, 10, rate));
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
-		if (!HAS_SHPREAMBLE(i))
+		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
 			continue;
 
 		/*

