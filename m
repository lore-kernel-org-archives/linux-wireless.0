Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:51863 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbYBDCvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 21:51:09 -0500
Date: Sun, 3 Feb 2008 21:51:04 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	johannes@sipsolutions.net
Subject: [PATCH 1/7] ath5k: Port to new bitrate/channel API
Message-ID: <67abed819770e9d38c69f0e015e153427b3522be.1202092325.git.mcgrof@winlab.rutgers.edu> (sfid-20080204_025114_702832_4DF6BFE0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Author: Nick Kossifidis <mickflemm@gmail.com>

Tested on 5211, 5213+5112, 5213A+2112A and it wors fine.

Also i figured out a way to process rate vallue found
on status descriptors, it's still buggy but we are getting
closer (i think it improved stability a little).

Changes to hw.c, initvals.c, phy.c
Changes-licensed-under: ISC

Changes to ath5k.h, base.c, base.h
Changes-licensed-under: 3-Clause-BSD

Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/Kconfig          |    1 -
 drivers/net/wireless/ath5k/Makefile   |    2 +-
 drivers/net/wireless/ath5k/ath5k.h    |  100 +++++-----
 drivers/net/wireless/ath5k/base.c     |  346 ++++++++++++++++++---------------
 drivers/net/wireless/ath5k/base.h     |   14 +-
 drivers/net/wireless/ath5k/hw.c       |  170 +++++------------
 drivers/net/wireless/ath5k/initvals.c |    2 +-
 drivers/net/wireless/ath5k/phy.c      |   66 +++---
 8 files changed, 329 insertions(+), 372 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 69dc9c1..9b1e042 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -743,7 +743,6 @@ config P54_PCI
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
-	depends on BROKEN
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.
diff --git a/drivers/net/wireless/ath5k/Makefile b/drivers/net/wireless/ath5k/Makefile
index 321641f..ada1095 100644
--- a/drivers/net/wireless/ath5k/Makefile
+++ b/drivers/net/wireless/ath5k/Makefile
@@ -1,2 +1,2 @@
-ath5k-objs		= base.o hw.o regdom.o initvals.o phy.o debug.o
+ath5k-objs		= base.o hw.o initvals.o phy.o debug.o
 obj-$(CONFIG_ATH5K)	+= ath5k.o
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index c79066b..3b03600 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -30,7 +30,6 @@
 #include <net/mac80211.h>
 
 #include "hw.h"
-#include "regdom.h"
 
 /* PCI IDs */
 #define PCI_DEVICE_ID_ATHEROS_AR5210 		0x0007 /* AR5210 */
@@ -251,18 +250,20 @@ struct ath5k_srev_name {
  */
 #define MODULATION_TURBO	0x00000080
 
-enum ath5k_vendor_mode {
-	MODE_ATHEROS_TURBO = NUM_IEEE80211_MODES+1,
-	MODE_ATHEROS_TURBOG
+enum ath5k_driver_mode {
+	AR5K_MODE_11A		=	0,
+	AR5K_MODE_11A_TURBO	=	1,
+	AR5K_MODE_11B		=	2,
+	AR5K_MODE_11G		=	3,
+	AR5K_MODE_11G_TURBO	=	4,
+	AR5K_MODE_XR		=	0,
+	AR5K_MODE_MAX		=	5
 };
 
-/* Number of supported mac80211 enum ieee80211_phymode modes by this driver */
-#define NUM_DRIVER_MODES	3
-
 /* adding this flag to rate_code enables short preamble, see ar5212_reg.h */
 #define AR5K_SET_SHORT_PREAMBLE 0x04
 
-#define HAS_SHPREAMBLE(_ix) (rt->rates[_ix].modulation == IEEE80211_RATE_CCK_2)
+#define HAS_SHPREAMBLE(_ix) (rt->rates[_ix].modulation == IEEE80211_RATE_SHORT_PREAMBLE)
 #define SHPREAMBLE_FLAG(_ix) (HAS_SHPREAMBLE(_ix) ? AR5K_SET_SHORT_PREAMBLE : 0)
 
 /****************\
@@ -560,8 +561,8 @@ struct ath5k_desc {
  * Used internaly in OpenHAL (ar5211.c/ar5212.c
  * for reset_tx_queue). Also see struct struct ieee80211_channel.
  */
-#define IS_CHAN_XR(_c)	((_c.val & CHANNEL_XR) != 0)
-#define IS_CHAN_B(_c)	((_c.val & CHANNEL_B) != 0)
+#define IS_CHAN_XR(_c)	((_c.hw_value & CHANNEL_XR) != 0)
+#define IS_CHAN_B(_c)	((_c.hw_value & CHANNEL_B) != 0)
 
 /*
  * The following structure will be used to map 2GHz channels to
@@ -584,7 +585,7 @@ struct ath5k_athchan_2ghz {
 
 /**
  * struct ath5k_rate - rate structure
- * @valid: is this a valid rate for the current mode
+ * @valid: is this a valid rate for rate control (remove)
  * @modulation: respective mac80211 modulation
  * @rate_kbps: rate in kbit/s
  * @rate_code: hardware rate value, used in &struct ath5k_desc, on RX on
@@ -643,47 +644,48 @@ struct ath5k_rate_table {
 
 /*
  * Rate tables...
+ * TODO: CLEAN THIS !!!
  */
 #define AR5K_RATES_11A { 8, {					\
 	255, 255, 255, 255, 255, 255, 255, 255, 6, 4, 2, 0,	\
 	7, 5, 3, 1, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	255, 255, 255, 255, 255, 255, 255, 255 }, {		\
-	{ 1, IEEE80211_RATE_OFDM, 6000, 11, 140, 0 },		\
-	{ 1, IEEE80211_RATE_OFDM, 9000, 15, 18, 0 },		\
-	{ 1, IEEE80211_RATE_OFDM, 12000, 10, 152, 2 },		\
-	{ 1, IEEE80211_RATE_OFDM, 18000, 14, 36, 2 },		\
-	{ 1, IEEE80211_RATE_OFDM, 24000, 9, 176, 4 },		\
-	{ 1, IEEE80211_RATE_OFDM, 36000, 13, 72, 4 },		\
-	{ 1, IEEE80211_RATE_OFDM, 48000, 8, 96, 4 },		\
-	{ 1, IEEE80211_RATE_OFDM, 54000, 12, 108, 4 } }		\
+	{ 1, 0, 6000, 11, 140, 0 },		\
+	{ 1, 0, 9000, 15, 18, 0 },		\
+	{ 1, 0, 12000, 10, 152, 2 },		\
+	{ 1, 0, 18000, 14, 36, 2 },		\
+	{ 1, 0, 24000, 9, 176, 4 },		\
+	{ 1, 0, 36000, 13, 72, 4 },		\
+	{ 1, 0, 48000, 8, 96, 4 },		\
+	{ 1, 0, 54000, 12, 108, 4 } }		\
 }
 
 #define AR5K_RATES_11B { 4, {						\
 	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	3, 2, 1, 0, 255, 255, 255, 255 }, {				\
-	{ 1, IEEE80211_RATE_CCK, 1000, 27, 130, 0 },	\
-	{ 1, IEEE80211_RATE_CCK_2, 2000, 26, 132, 1 },	\
-	{ 1, IEEE80211_RATE_CCK_2, 5500, 25, 139, 1 },	\
-	{ 1, IEEE80211_RATE_CCK_2, 11000, 24, 150, 1 } }	\
+	{ 1, 0, 1000, 27, 130, 0 },	\
+	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 2000, 26, 132, 1 },	\
+	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 5500, 25, 139, 1 },	\
+	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 11000, 24, 150, 1 } }	\
 }
 
 #define AR5K_RATES_11G { 12, {					\
 	255, 255, 255, 255, 255, 255, 255, 255, 10, 8, 6, 4,	\
 	11, 9, 7, 5, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	3, 2, 1, 0, 255, 255, 255, 255 }, {			\
-	{ 1, IEEE80211_RATE_CCK, 1000, 27, 2, 0 },		\
-	{ 1, IEEE80211_RATE_CCK_2, 2000, 26, 4, 1 },		\
-	{ 1, IEEE80211_RATE_CCK_2, 5500, 25, 11, 1 },		\
-	{ 1, IEEE80211_RATE_CCK_2, 11000, 24, 22, 1 },	\
-	{ 0, IEEE80211_RATE_OFDM, 6000, 11, 12, 4 },	\
-	{ 0, IEEE80211_RATE_OFDM, 9000, 15, 18, 4 },	\
-	{ 1, IEEE80211_RATE_OFDM, 12000, 10, 24, 6 },	\
-	{ 1, IEEE80211_RATE_OFDM, 18000, 14, 36, 6 },	\
-	{ 1, IEEE80211_RATE_OFDM, 24000, 9, 48, 8 },	\
-	{ 1, IEEE80211_RATE_OFDM, 36000, 13, 72, 8 },	\
-	{ 1, IEEE80211_RATE_OFDM, 48000, 8, 96, 8 },	\
-	{ 1, IEEE80211_RATE_OFDM, 54000, 12, 108, 8 } }	\
+	{ 1, 0, 1000, 27, 2, 0 },		\
+	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 2000, 26, 4, 1 },		\
+	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 5500, 25, 11, 1 },		\
+	{ 1, IEEE80211_RATE_SHORT_PREAMBLE, 11000, 24, 22, 1 },	\
+	{ 0, 0, 6000, 11, 12, 4 },	\
+	{ 0, 0, 9000, 15, 18, 4 },	\
+	{ 1, 0, 12000, 10, 24, 6 },	\
+	{ 1, 0, 18000, 14, 36, 6 },	\
+	{ 1, 0, 24000, 9, 48, 8 },	\
+	{ 1, 0, 36000, 13, 72, 8 },	\
+	{ 1, 0, 48000, 8, 96, 8 },	\
+	{ 1, 0, 54000, 12, 108, 8 } }	\
 }
 
 #define AR5K_RATES_TURBO { 8, {					\
@@ -708,14 +710,14 @@ struct ath5k_rate_table {
 	{ 1, MODULATION_XR, 1000, 2, 139, 1 },		\
 	{ 1, MODULATION_XR, 2000, 6, 150, 2 },		\
 	{ 1, MODULATION_XR, 3000, 1, 150, 3 },		\
-	{ 1, IEEE80211_RATE_OFDM, 6000, 11, 140, 4 },	\
-	{ 1, IEEE80211_RATE_OFDM, 9000, 15, 18, 4 },	\
-	{ 1, IEEE80211_RATE_OFDM, 12000, 10, 152, 6 },	\
-	{ 1, IEEE80211_RATE_OFDM, 18000, 14, 36, 6 },	\
-	{ 1, IEEE80211_RATE_OFDM, 24000, 9, 176, 8 },	\
-	{ 1, IEEE80211_RATE_OFDM, 36000, 13, 72, 8 },	\
-	{ 1, IEEE80211_RATE_OFDM, 48000, 8, 96, 8 },	\
-	{ 1, IEEE80211_RATE_OFDM, 54000, 12, 108, 8 } }	\
+	{ 1, 0, 6000, 11, 140, 4 },	\
+	{ 1, 0, 9000, 15, 18, 4 },	\
+	{ 1, 0, 12000, 10, 152, 6 },	\
+	{ 1, 0, 18000, 14, 36, 6 },	\
+	{ 1, 0, 24000, 9, 176, 8 },	\
+	{ 1, 0, 36000, 13, 72, 8 },	\
+	{ 1, 0, 48000, 8, 96, 8 },	\
+	{ 1, 0, 54000, 12, 108, 8 } }	\
 }
 
 /*
@@ -895,7 +897,7 @@ struct ath5k_capabilities {
 	 * Supported PHY modes
 	 * (ie. CHANNEL_A, CHANNEL_B, ...)
 	 */
-	DECLARE_BITMAP(cap_mode, NUM_DRIVER_MODES);
+	DECLARE_BITMAP(cap_mode, AR5K_MODE_MAX);
 
 	/*
 	 * Frequency range (without regulation restrictions)
@@ -908,14 +910,6 @@ struct ath5k_capabilities {
 	} cap_range;
 
 	/*
-	 * Active regulation domain settings
-	 */
-	struct {
-		enum ath5k_regdom reg_current;
-		enum ath5k_regdom reg_hw;
-	} cap_regdomain;
-
-	/*
 	 * Values stored in the EEPROM (some of them...)
 	 */
 	struct ath5k_eeprom_info	cap_eeprom;
@@ -1129,8 +1123,6 @@ extern int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio);
 extern u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio);
 extern int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
 extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio, u32 interrupt_level);
-/* Regulatory Domain/Channels Setup */
-extern u16 ath5k_get_regdomain(struct ath5k_hw *ah);
 /* Misc functions */
 extern int ath5k_hw_get_capability(struct ath5k_hw *ah, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
 
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index ddc8714..d94bace 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -240,6 +240,8 @@ static int 	ath5k_chan_set(struct ath5k_softc *sc,
 static void	ath5k_setcurmode(struct ath5k_softc *sc,
 				unsigned int mode);
 static void	ath5k_mode_setup(struct ath5k_softc *sc);
+static void	ath5k_set_total_hw_rates(struct ath5k_softc *sc);
+
 /* Descriptor setup */
 static int	ath5k_desc_alloc(struct ath5k_softc *sc,
 				struct pci_dev *pdev);
@@ -515,12 +517,12 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		/* Single chip radio (!RF5111) */
 		if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
 			/* No 5GHz support -> report 2GHz radio */
-			if(!test_bit(MODE_IEEE80211A, sc->ah->ah_capabilities.cap_mode)){
+			if(!test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)){
 				ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
 							sc->ah->ah_radio_5ghz_revision);
 			/* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio */
-			} else if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){
+			} else if(!test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)){
 				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
 							sc->ah->ah_radio_5ghz_revision);
@@ -690,11 +692,14 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		goto err;
 	}
 
+	/* Set *_rates so we can map hw rate index */
+	ath5k_set_total_hw_rates(sc);
+
 	/* NB: setup here so ath5k_rate_update is happy */
-	if (test_bit(MODE_IEEE80211A, ah->ah_modes))
-		ath5k_setcurmode(sc, MODE_IEEE80211A);
+	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
+		ath5k_setcurmode(sc, AR5K_MODE_11A);
 	else
-		ath5k_setcurmode(sc, MODE_IEEE80211B);
+		ath5k_setcurmode(sc, AR5K_MODE_11B);
 
 	/*
 	 * Allocate tx+rx descriptors and populate the lists.
@@ -834,12 +839,9 @@ ath5k_copy_rates(struct ieee80211_rate *rates,
 		return 0;
 
 	for (i = 0, count = 0; i < rt->rate_count && max > 0; i++) {
-		if (!rt->rates[i].valid)
-			continue;
-		rates->rate = rt->rates[i].rate_kbps / 100;
-		rates->val = rt->rates[i].rate_code;
-		rates->flags = rt->rates[i].modulation;
-		rates++;
+		rates[count].bitrate = rt->rates[i].rate_kbps / 100;
+		rates[count].hw_value = rt->rates[i].rate_code;
+		rates[count].flags = rt->rates[i].modulation;
 		count++;
 		max--;
 	}
@@ -853,43 +855,22 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		unsigned int mode,
 		unsigned int max)
 {
-	static const struct { unsigned int mode, mask, chan; } map[] = {
-		[MODE_IEEE80211A] = { CHANNEL_OFDM, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_A },
-		[MODE_ATHEROS_TURBO] = { CHANNEL_OFDM|CHANNEL_TURBO, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_T },
-		[MODE_IEEE80211B] = { CHANNEL_CCK, CHANNEL_CCK, CHANNEL_B },
-		[MODE_IEEE80211G] = { CHANNEL_OFDM, CHANNEL_OFDM, CHANNEL_G },
-		[MODE_ATHEROS_TURBOG] = { CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_OFDM | CHANNEL_TURBO, CHANNEL_TG },
-	};
-	static const struct ath5k_regchannel chans_2ghz[] =
-		IEEE80211_CHANNELS_2GHZ;
-	static const struct ath5k_regchannel chans_5ghz[] =
-		IEEE80211_CHANNELS_5GHZ;
-	const struct ath5k_regchannel *chans;
-	enum ath5k_regdom dmn;
-	unsigned int i, count, size, chfreq, all, f, ch;
+	unsigned int i, count, size, chfreq, freq, ch;
 
 	if (!test_bit(mode, ah->ah_modes))
 		return 0;
 
-	all = ah->ah_regdomain == DMN_DEFAULT || CHAN_DEBUG == 1;
-
 	switch (mode) {
-	case MODE_IEEE80211A:
-	case MODE_ATHEROS_TURBO:
+	case AR5K_MODE_11A:
+	case AR5K_MODE_11A_TURBO:
 		/* 1..220, but 2GHz frequencies are filtered by check_channel */
-		size = all ? 220 : ARRAY_SIZE(chans_5ghz);
-		chans = chans_5ghz;
-		dmn = ath5k_regdom2flag(ah->ah_regdomain,
-				IEEE80211_CHANNELS_5GHZ_MIN);
+		size = 220 ;
 		chfreq = CHANNEL_5GHZ;
 		break;
-	case MODE_IEEE80211B:
-	case MODE_IEEE80211G:
-	case MODE_ATHEROS_TURBOG:
-		size = all ? 26 : ARRAY_SIZE(chans_2ghz);
-		chans = chans_2ghz;
-		dmn = ath5k_regdom2flag(ah->ah_regdomain,
-				IEEE80211_CHANNELS_2GHZ_MIN);
+	case AR5K_MODE_11B:
+	case AR5K_MODE_11G:
+	case AR5K_MODE_11G_TURBO:
+		size = 26;
 		chfreq = CHANNEL_2GHZ;
 		break;
 	default:
@@ -898,25 +879,26 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 	}
 
 	for (i = 0, count = 0; i < size && max > 0; i++) {
-		ch = all ? i + 1 : chans[i].chan;
-		f = ath5k_ieee2mhz(ch);
-		/* Check if channel is supported by the chipset */
-		if (!ath5k_channel_ok(ah, f, chfreq))
-			continue;
+		ch = i + 1 ;
+		freq = ath5k_ieee2mhz(ch);
 
-		/* Match regulation domain */
-		if (!all && !(IEEE80211_DMN(chans[i].domain) &
-							IEEE80211_DMN(dmn)))
+		/* Check if channel is supported by the chipset */
+		if (!ath5k_channel_ok(ah, freq, chfreq))
 			continue;
 
-		if (!all && (chans[i].mode & map[mode].mask) != map[mode].mode)
-			continue;
+		/* Write channel info and increment counter */
+		channels[count].center_freq = freq;
+
+		if((mode == AR5K_MODE_11A) ||
+		(mode == AR5K_MODE_11G)){
+			channels[count].hw_value = chfreq|CHANNEL_OFDM;
+		} else if((mode == AR5K_MODE_11A_TURBO) ||
+		(mode == AR5K_MODE_11G_TURBO)){
+			channels[count].hw_value = chfreq|CHANNEL_OFDM|CHANNEL_TURBO;
+		}if(mode == AR5K_MODE_11B) {
+			channels[count].hw_value = CHANNEL_B;
+		}
 
-		/* Write channel and increment counter */
-		channels->chan = ch;
-		channels->freq = f;
-		channels->val = map[mode].chan;
-		channels++;
 		count++;
 		max--;
 	}
@@ -924,95 +906,76 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 	return count;
 }
 
-/* Only tries to register modes our EEPROM says it can support */
-#define REGISTER_MODE(m) do { \
-	ret = ath5k_register_mode(hw, m); \
-	if (ret) \
-		return ret; \
-} while (0) \
-
-static inline int
-ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
+static int
+ath5k_getchannels(struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
-	struct ieee80211_hw_mode *modes = sc->modes;
-	unsigned int i;
-	int ret;
+	struct ath5k_hw *ah = sc->ah;
+	struct ieee80211_supported_band *sbands = sc->sbands;
+	const struct ath5k_rate_table *hw_rates;
+	unsigned int max_r, max_c, count_r, count_c;
+	int mode2g = AR5K_MODE_11G;
 
-	if (!test_bit(m, sc->ah->ah_capabilities.cap_mode))
-		return 0;
+	BUILD_BUG_ON(ARRAY_SIZE(sc->sbands) < IEEE80211_NUM_BANDS);
 
-	for (i = 0; i < NUM_DRIVER_MODES; i++) {
-		if (modes[i].mode != m || !modes[i].num_channels)
-			continue;
-		ret = ieee80211_register_hwmode(hw, &modes[i]);
-		if (ret) {
-			ATH5K_ERR(sc, "can't register hwmode %u\n", m);
-			return ret;
+	max_r = ARRAY_SIZE(sc->rates);
+	max_c = ARRAY_SIZE(sc->channels);
+	count_r = count_c = 0;
+
+	/* 2GHz band */
+	if(!test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)){
+		mode2g = AR5K_MODE_11B;
+		if(!test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)){
+			mode2g = -1;
 		}
-		return 0;
 	}
-	BUG();
-}
 
-static int
-ath5k_getchannels(struct ieee80211_hw *hw)
-{
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
-	struct ieee80211_hw_mode *modes = sc->modes;
-	unsigned int i, max_r, max_c;
-	int ret;
+	if(mode2g > 0){
+		struct ieee80211_supported_band *sband = &sbands[IEEE80211_BAND_2GHZ];
 
-	BUILD_BUG_ON(ARRAY_SIZE(sc->modes) < 3);
+		sband->bitrates = sc->rates;
+		sband->channels = sc->channels;
 
-	/* The order here does not matter */
-	modes[0].mode = MODE_IEEE80211G;
-	modes[1].mode = MODE_IEEE80211B;
-	modes[2].mode = MODE_IEEE80211A;
+		sband->band = IEEE80211_BAND_2GHZ;
+		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
+					mode2g, max_c);
 
-	max_r = ARRAY_SIZE(sc->rates);
-	max_c = ARRAY_SIZE(sc->channels);
+		hw_rates = ath5k_hw_get_rate_table(ah, mode2g);
+		sband->n_bitrates = ath5k_copy_rates(sband->bitrates,
+					hw_rates,max_r);
 
-	for (i = 0; i < NUM_DRIVER_MODES; i++) {
-		struct ieee80211_hw_mode *mode = &modes[i];
-		const struct ath5k_rate_table *hw_rates;
+		count_c = sband->n_channels;
+		count_r = sband->n_bitrates;
 
-		if (i == 0) {
-			modes[0].rates	= sc->rates;
-			modes->channels	= sc->channels;
-		} else {
-			struct ieee80211_hw_mode *prev_mode = &modes[i-1];
-			int prev_num_r	= prev_mode->num_rates;
-			int prev_num_c	= prev_mode->num_channels;
-			mode->rates	= &prev_mode->rates[prev_num_r];
-			mode->channels	= &prev_mode->channels[prev_num_c];
-		}
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+
+		max_r -= count_r;
+		max_c -= count_c;
 
-		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
-		mode->num_rates    = ath5k_copy_rates(mode->rates, hw_rates,
-			max_r);
-		mode->num_channels = ath5k_copy_channels(ah, mode->channels,
-			mode->mode, max_c);
-		max_r -= mode->num_rates;
-		max_c -= mode->num_channels;
 	}
 
-	/* We try to register all modes this driver supports. We don't bother
-	 * with MODE_IEEE80211B for AR5212 as MODE_IEEE80211G already accounts
-	 * for that as per mac80211. Then, REGISTER_MODE() will will actually
-	 * check the eeprom reading for more reliable capability information.
-	 * Order matters here as per mac80211's latest preference. This will
-	 * all hopefullly soon go away. */
+	/* 5GHz band */
 
-	REGISTER_MODE(MODE_IEEE80211G);
-	if (ah->ah_version != AR5K_AR5212)
-		REGISTER_MODE(MODE_IEEE80211B);
-	REGISTER_MODE(MODE_IEEE80211A);
+	if(test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)){
+		struct ieee80211_supported_band *sband = &sbands[IEEE80211_BAND_5GHZ];
 
-	ath5k_debug_dump_modes(sc, modes);
+		sband->bitrates = &sc->rates[count_r];
+		sband->channels = &sc->channels[count_c];
 
-	return ret;
+		sband->band = IEEE80211_BAND_5GHZ;
+		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
+					AR5K_MODE_11A, max_c);
+
+		hw_rates = ath5k_hw_get_rate_table(ah, AR5K_MODE_11A);
+		sband->n_bitrates = ath5k_copy_rates(sband->bitrates,
+					hw_rates,max_r);
+
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+	}
+
+/* FIXME:	ath5k_debug_dump_modes(sc, modes); */
+
+	return 0;
 }
 
 /*
@@ -1027,11 +990,15 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "%u (%u MHz) -> %u (%u MHz)\n",
-		sc->curchan->chan, sc->curchan->freq,
-		chan->chan, chan->freq);
+	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
+		sc->curchan->center_freq, chan->center_freq);
+
+	if (chan->center_freq != sc->curchan->center_freq ||
+		chan->hw_value != sc->curchan->hw_value) {
+
+		sc->curchan = chan;
+		sc->curband = &sc->sbands[chan->band];
 
-	if (chan->freq != sc->curchan->freq || chan->val != sc->curchan->val) {
 		/*
 		 * To switch channels clear any pending DMA operations;
 		 * wait long enough for the RX fifo to drain, reset the
@@ -1041,13 +1008,13 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		ath5k_hw_set_intr(ah, 0);	/* disable interrupts */
 		ath5k_txq_cleanup(sc);		/* clear pending tx frames */
 		ath5k_rx_stop(sc);		/* turn off frame recv */
-		ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
+		ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
 		if (ret) {
-			ATH5K_ERR(sc, "%s: unable to reset channel %u "
-				"(%u Mhz)\n", __func__, chan->chan, chan->freq);
+			ATH5K_ERR(sc, "%s: unable to reset channel "
+				"(%u Mhz)\n", __func__, chan->center_freq);
 			return ret;
 		}
-		sc->curchan = chan;
+
 		ath5k_hw_set_txpower_limit(sc->ah, 0);
 
 		/*
@@ -1078,6 +1045,9 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	return 0;
 }
 
+/*
+ * TODO: CLEAN THIS !!!
+ */
 static void
 ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 {
@@ -1118,10 +1088,6 @@ ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 				continue;
 			}
 			sc->hwmap[i].txflags = IEEE80211_RADIOTAP_F_DATAPAD;
-			if (SHPREAMBLE_FLAG(ix) || rt->rates[ix].modulation ==
-					IEEE80211_RATE_OFDM)
-				sc->hwmap[i].txflags |=
-						IEEE80211_RADIOTAP_F_SHORTPRE;
 			/* receive frames include FCS */
 			sc->hwmap[i].rxflags = sc->hwmap[i].txflags |
 					IEEE80211_RADIOTAP_F_FCS;
@@ -1139,6 +1105,12 @@ ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 	}
 
 	sc->curmode = mode;
+
+	if(mode == AR5K_MODE_11A){
+		sc->curband = &sc->sbands[IEEE80211_BAND_5GHZ];
+	} else {
+		sc->curband = &sc->sbands[IEEE80211_BAND_2GHZ];
+	}
 }
 
 static void
@@ -1161,6 +1133,72 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
 }
 
+/*
+ * Match the hw provided rate index (through descriptors)
+ * to an index for sc->curband->bitrates, so it can be used
+ * by the stack.
+ *
+ * This one is a little bit tricky but i think i'm right
+ * about this...
+ *
+ * We have 4 rate tables in the following order:
+ * XR (4 rates)
+ * 802.11a (8 rates)
+ * 802.11b (4 rates)
+ * 802.11g (12 rates)
+ * that make the hw rate table.
+ *
+ * Lets take a 5211 for example that supports a and b modes only.
+ * First comes the 802.11a table and then 802.11b (total 12 rates).
+ * When hw returns eg. 11 it points to the last 802.11b rate (11Mbit),
+ * if it returns 2 it points to the second 802.11a rate etc.
+ *
+ * Same goes for 5212 who has xr/a/b/g support (total 28 rates).
+ * First comes the XR table, then 802.11a, 802.11b and 802.11g.
+ * When hw returns eg. 27 it points to the last 802.11g rate (54Mbits) etc
+ */
+static void
+ath5k_set_total_hw_rates(struct ath5k_softc *sc){
+
+	struct ath5k_hw *ah = sc->ah;
+
+	if(test_bit(AR5K_MODE_11A, ah->ah_modes))
+		sc->a_rates = 8;
+
+	if(test_bit(AR5K_MODE_11B, ah->ah_modes))
+		sc->b_rates = 4;
+
+	if(test_bit(AR5K_MODE_11G, ah->ah_modes))
+		sc->g_rates = 12;
+	
+	/* XXX: Need to see what what happens when
+		xr disable bits in eeprom are set */
+	if(ah->ah_version >= AR5K_AR5212)
+		sc->xr_rates = 4;
+
+}
+
+static inline int
+ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix){
+
+	int mac80211_rix;
+
+	if(sc->curband->band == IEEE80211_BAND_2GHZ){
+		/* We setup a g ratetable for both b/g modes */
+		mac80211_rix = hw_rix - sc->b_rates - sc->a_rates - sc->xr_rates;
+	} else {
+		mac80211_rix = hw_rix - sc->xr_rates;
+	}
+
+	/* Something went wrong, fallback to basic rate for this band */
+	if((mac80211_rix >= sc->curband->n_bitrates) || 
+	(mac80211_rix <= 0 )){
+		mac80211_rix = 1;
+	}
+
+	return mac80211_rix;
+}
+
 
 
 
@@ -1265,7 +1303,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
-		(ctl->power_level * 2), ctl->tx_rate, ctl->retry_limit, keyidx, 0, flags, 0, 0);
+		(sc->power_level * 2), ctl->tx_rate->hw_value, ctl->retry_limit, keyidx, 0, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
 
@@ -1787,9 +1825,8 @@ accept:
 		rxs.mactime = ath5k_extend_tsf(sc->ah, ds->ds_rxstat.rs_tstamp);
 		rxs.flag |= RX_FLAG_TSFT;
 
-		rxs.freq = sc->curchan->freq;
-		rxs.channel = sc->curchan->chan;
-		rxs.phymode = sc->curmode;
+		rxs.freq = sc->curchan->center_freq;
+		rxs.band = sc->curband->band;
 
 		/*
 		 * signal quality:
@@ -1807,7 +1844,7 @@ accept:
 		rxs.signal = ds->ds_rxstat.rs_rssi * 100 / 64;
 
 		rxs.antenna = ds->ds_rxstat.rs_antenna;
-		rxs.rate = ds->ds_rxstat.rs_rate;
+		rxs.rate_idx = ath5k_hw_to_driver_rix(sc,ds->ds_rxstat.rs_rate);
 		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb);
 
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
@@ -1954,7 +1991,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len + FCS_LEN,
 			ieee80211_get_hdrlen_from_skb(skb),
-			AR5K_PKT_TYPE_BEACON, (ctl->power_level * 2), ctl->tx_rate, 1,
+			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2), ctl->tx_rate->hw_value, 1,
 			AR5K_TXKEYIX_INVALID, antenna, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
@@ -2206,7 +2243,8 @@ ath5k_init(struct ath5k_softc *sc)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	sc->curchan = sc->hw->conf.chan;
+	sc->curchan = sc->hw->conf.channel;
+	sc->curband = &sc->sbands[sc->curchan->band];
 	ret = ath5k_hw_reset(sc->ah, sc->opmode, sc->curchan, false);
 	if (ret) {
 		ATH5K_ERR(sc, "unable to reset hardware: %d\n", ret);
@@ -2442,7 +2480,7 @@ ath5k_calibrate(unsigned long data)
 	struct ath5k_hw *ah = sc->ah;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
-		sc->curchan->chan, sc->curchan->val);
+		ieee80211_frequency_to_channel(sc->curchan->center_freq), sc->curchan->hw_value);
 
 	if (ath5k_hw_get_rf_gain(ah) == AR5K_RFGAIN_NEED_CHANGE) {
 		/*
@@ -2454,7 +2492,7 @@ ath5k_calibrate(unsigned long data)
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
 		ATH5K_ERR(sc, "calibration of channel %u failed\n",
-				sc->curchan->chan);
+				ieee80211_frequency_to_channel(sc->curchan->center_freq));
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
@@ -2552,7 +2590,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		memmove(skb->data, skb->data+pad, hdrlen);
 	}
 
-	sc->led_txrate = ctl->tx_rate;
+	sc->led_txrate = ctl->tx_rate->hw_value;
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
 	if (list_empty(&sc->txbuf)) {
@@ -2591,11 +2629,6 @@ ath5k_reset(struct ieee80211_hw *hw)
 	int ret;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
-	/*
-	 * Convert to a hw channel description with the flags
-	 * constrained to reflect the current operating mode.
-	 */
-	sc->curchan = hw->conf.chan;
 
 	ath5k_hw_set_intr(ah, 0);
 	ath5k_txq_cleanup(sc);
@@ -2686,6 +2719,9 @@ end:
 	mutex_unlock(&sc->lock);
 }
 
+/*
+ * TODO: Phy disable/diversity etc
+ */
 static int
 ath5k_config(struct ieee80211_hw *hw,
 			struct ieee80211_conf *conf)
@@ -2693,9 +2729,9 @@ ath5k_config(struct ieee80211_hw *hw,
 	struct ath5k_softc *sc = hw->priv;
 
 	sc->bintval = conf->beacon_int;
-	ath5k_setcurmode(sc, conf->phymode);
+	sc->power_level = conf->power_level;
 
-	return ath5k_chan_set(sc, conf->chan);
+	return ath5k_chan_set(sc, conf->channel);
 }
 
 static int
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 8287ae7..bbe7a54 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -83,7 +83,7 @@ struct ath5k_txq {
 #if CHAN_DEBUG
 #define ATH_CHAN_MAX	(26+26+26+200+200)
 #else
-#define ATH_CHAN_MAX	(14+14+14+252+20)	/* XXX what's the max? */
+#define ATH_CHAN_MAX	(14+14+14+252+20)
 #endif
 
 /* Software Carrier, keeps track of the driver state
@@ -95,12 +95,19 @@ struct ath5k_softc {
 	struct ieee80211_tx_queue_stats tx_stats;
 	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
-	struct ieee80211_hw_mode modes[NUM_DRIVER_MODES];
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
-	struct ieee80211_rate	rates[AR5K_MAX_RATES * NUM_DRIVER_MODES];
+	struct ieee80211_rate	rates[AR5K_MAX_RATES * IEEE80211_NUM_BANDS];
 	enum ieee80211_if_types	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
+	struct ieee80211_supported_band		*curband;
+
+	u8			a_rates;
+	u8			b_rates;
+	u8			g_rates;
+	u8			xr_rates;
+
 #if ATH5K_DEBUG
 	struct ath5k_dbg_info	debug;		/* debug info */
 #endif
@@ -169,6 +176,7 @@ struct ath5k_softc {
 	unsigned int		nexttbtt;	/* next beacon time in TU */
 
 	struct timer_list	calib_tim;	/* calibration timer */
+	int 			power_level;	/* Requested tx power in dbm */
 };
 
 #define ath5k_hw_hasbssidmask(_ah) \
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 3a4bf40..ac7f715 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -140,9 +140,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	 * HW information
 	 */
 
-	/* Get reg domain from eeprom */
-	ath5k_get_regdomain(ah);
-
 	ah->ah_op_mode = IEEE80211_IF_TYPE_STA;
 	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
 	ah->ah_turbo = false;
@@ -405,15 +402,15 @@ const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah,
 
 	/* Get rate tables */
 	switch (mode) {
-	case MODE_IEEE80211A:
+	case AR5K_MODE_11A:
 		return &ath5k_rt_11a;
-	case MODE_ATHEROS_TURBO:
+	case AR5K_MODE_11A_TURBO:
 		return &ath5k_rt_turbo;
-	case MODE_IEEE80211B:
+	case AR5K_MODE_11B:
 		return &ath5k_rt_11b;
-	case MODE_IEEE80211G:
+	case AR5K_MODE_11G:
 		return &ath5k_rt_11g;
-	case MODE_ATHEROS_TURBOG:
+	case AR5K_MODE_11G_TURBO:
 		return &ath5k_rt_xr;
 	}
 
@@ -457,15 +454,15 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 		ds_coef_exp, ds_coef_man, clock;
 
 	if (!(ah->ah_version == AR5K_AR5212) ||
-		!(channel->val & CHANNEL_OFDM))
+		!(channel->hw_value & CHANNEL_OFDM))
 		BUG();
 
 	/* Seems there are two PLLs, one for baseband sampling and one
 	 * for tuning. Tuning basebands are 40 MHz or 80MHz when in
 	 * turbo. */
-	clock = channel->val & CHANNEL_TURBO ? 80 : 40;
+	clock = channel->hw_value & CHANNEL_TURBO ? 80 : 40;
 	coef_scaled = ((5 * (clock << 24)) / 2) /
-	channel->freq;
+	channel->center_freq;
 
 	for (coef_exp = 31; coef_exp > 0; coef_exp--)
 		if ((coef_scaled >> coef_exp) & 0x1)
@@ -492,8 +489,7 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
  * ath5k_hw_write_rate_duration - set rate duration during hw resets
  *
  * @ah: the &struct ath5k_hw
- * @driver_mode: one of enum ieee80211_phymode or our one of our own
- *     vendor modes
+ * @mode: one of enum ath5k_driver_mode
  *
  * Write the rate duration table for the current mode upon hw reset. This
  * is a helper for ath5k_hw_reset(). It seems all this is doing is setting
@@ -504,19 +500,20 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
  *
  */
 static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
-       unsigned int driver_mode)
+       unsigned int mode)
 {
 	struct ath5k_softc *sc = ah->ah_sc;
 	const struct ath5k_rate_table *rt;
+	struct ieee80211_rate srate = {};
 	unsigned int i;
 
 	/* Get rate table for the current operating mode */
-	rt = ath5k_hw_get_rate_table(ah,
-		driver_mode);
+	rt = ath5k_hw_get_rate_table(ah, mode);
 
 	/* Write rate duration table */
 	for (i = 0; i < rt->rate_count; i++) {
 		const struct ath5k_rate *rate, *control_rate;
+
 		u32 reg;
 		u16 tx_time;
 
@@ -526,6 +523,8 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
 		/* Set ACK timeout */
 		reg = AR5K_RATE_DUR(rate->rate_code);
 
+		srate.bitrate = control_rate->rate_kbps/100;
+
 		/* An ACK frame consists of 10 bytes. If you add the FCS,
 		 * which ieee80211_generic_frame_duration() adds,
 		 * its 14 bytes. Note we use the control rate and not the
@@ -533,7 +532,7 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
 		tx_time = ieee80211_generic_frame_duration(sc->hw,
-			sc->vif, 10, control_rate->rate_kbps/100);
+			sc->vif, 10, &srate);
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
@@ -567,7 +566,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 data, s_seq, s_ant, s_led[3];
-	unsigned int i, mode, freq, ee_mode, ant[2], driver_mode = -1;
+	unsigned int i, mode, freq, ee_mode, ant[2];
 	int ret;
 
 	ATH5K_TRACE(ah->ah_sc);
@@ -602,7 +601,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 
 	/*Wakeup the device*/
-	ret = ath5k_hw_nic_wakeup(ah, channel->val, false);
+	ret = ath5k_hw_nic_wakeup(ah, channel->hw_value, false);
 	if (ret)
 		return ret;
 
@@ -624,37 +623,32 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 			return -EINVAL;
 		}
 
-		switch (channel->val & CHANNEL_MODES) {
+		switch (channel->hw_value & CHANNEL_MODES) {
 		case CHANNEL_A:
-			mode = AR5K_INI_VAL_11A;
+			mode = AR5K_MODE_11A;
 			freq = AR5K_INI_RFGAIN_5GHZ;
 			ee_mode = AR5K_EEPROM_MODE_11A;
-			driver_mode = MODE_IEEE80211A;
 			break;
 		case CHANNEL_G:
-			mode = AR5K_INI_VAL_11G;
+			mode = AR5K_MODE_11G;
 			freq = AR5K_INI_RFGAIN_2GHZ;
 			ee_mode = AR5K_EEPROM_MODE_11G;
-			driver_mode = MODE_IEEE80211G;
 			break;
 		case CHANNEL_B:
-			mode = AR5K_INI_VAL_11B;
+			mode = AR5K_MODE_11B;
 			freq = AR5K_INI_RFGAIN_2GHZ;
 			ee_mode = AR5K_EEPROM_MODE_11B;
-			driver_mode = MODE_IEEE80211B;
 			break;
 		case CHANNEL_T:
-			mode = AR5K_INI_VAL_11A_TURBO;
+			mode = AR5K_MODE_11A_TURBO;
 			freq = AR5K_INI_RFGAIN_5GHZ;
 			ee_mode = AR5K_EEPROM_MODE_11A;
-			driver_mode = MODE_ATHEROS_TURBO;
 			break;
 		/*Is this ok on 5211 too ?*/
 		case CHANNEL_TG:
-			mode = AR5K_INI_VAL_11G_TURBO;
+			mode = AR5K_MODE_11G_TURBO;
 			freq = AR5K_INI_RFGAIN_2GHZ;
 			ee_mode = AR5K_EEPROM_MODE_11G;
-			driver_mode = MODE_ATHEROS_TURBOG;
 			break;
 		case CHANNEL_XR:
 			if (ah->ah_version == AR5K_AR5211) {
@@ -662,14 +656,13 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 					"XR mode not available on 5211");
 				return -EINVAL;
 			}
-			mode = AR5K_INI_VAL_XR;
+			mode = AR5K_MODE_XR;
 			freq = AR5K_INI_RFGAIN_5GHZ;
 			ee_mode = AR5K_EEPROM_MODE_11A;
-			driver_mode = MODE_IEEE80211A;
 			break;
 		default:
 			ATH5K_ERR(ah->ah_sc,
-				"invalid channel: %d\n", channel->freq);
+				"invalid channel: %d\n", channel->center_freq);
 			return -EINVAL;
 		}
 
@@ -702,7 +695,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		if (ah->ah_version > AR5K_AR5211){ /* found on 5213+ */
 			ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
 
-			if (channel->val == CHANNEL_G)
+			if (channel->hw_value == CHANNEL_G)
 				ath5k_hw_reg_write(ah, 0x00f80d80, AR5K_PHY(83)); /* 0x00fc0ec0 */
 			else
 				ath5k_hw_reg_write(ah, 0x00000000, AR5K_PHY(83));
@@ -720,7 +713,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 				AR5K_SREV_RAD_5112A) {
 			ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
 					AR5K_PHY_CCKTXCTL);
-			if (channel->val & CHANNEL_5GHZ)
+			if (channel->hw_value & CHANNEL_5GHZ)
 				data = 0xffb81020;
 			else
 				data = 0xffb80d20;
@@ -740,7 +733,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		 * mac80211 are integrated */
 		if (ah->ah_version == AR5K_AR5212 &&
 			ah->ah_sc->vif != NULL)
-			ath5k_hw_write_rate_duration(ah, driver_mode);
+			ath5k_hw_write_rate_duration(ah, mode);
 
 		/*
 		 * Write RF registers
@@ -756,7 +749,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 		/* Write OFDM timings on 5212*/
 		if (ah->ah_version == AR5K_AR5212 &&
-			channel->val & CHANNEL_OFDM) {
+			channel->hw_value & CHANNEL_OFDM) {
 			ret = ath5k_hw_write_ofdm_timings(ah, channel);
 			if (ret)
 				return ret;
@@ -765,7 +758,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		/*Enable/disable 802.11b mode on 5111
 		(enable 2111 frequency converter + CCK)*/
 		if (ah->ah_radio == AR5K_RF5111) {
-			if (driver_mode == MODE_IEEE80211B)
+			if (mode == AR5K_MODE_11B)
 				AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG,
 				    AR5K_TXCFG_B_MODE);
 			else
@@ -903,7 +896,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	if (ah->ah_version != AR5K_AR5210) {
 		data = ath5k_hw_reg_read(ah, AR5K_PHY_RX_DELAY) &
 			AR5K_PHY_RX_DELAY_M;
-		data = (channel->val & CHANNEL_CCK) ?
+		data = (channel->hw_value & CHANNEL_CCK) ?
 			((data << 2) / 22) : (data / 10);
 
 		udelay(100 + data);
@@ -920,11 +913,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_CAL, 0, false)) {
 		ATH5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
-			channel->freq);
+			channel->center_freq);
 		return -EAGAIN;
 	}
 
-	ret = ath5k_hw_noise_floor_calibration(ah, channel->freq);
+	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
 	if (ret)
 		return ret;
 
@@ -932,7 +925,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 	/* A and G modes can use QAM modulation which requires enabling
 	 * I and Q calibration. Don't bother in B mode. */
-	if (!(driver_mode == MODE_IEEE80211B)) {
+	if (!(mode == AR5K_MODE_11B)) {
 		ah->ah_calibration = true;
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
 				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
@@ -1590,9 +1583,10 @@ static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
 /*
  * Write to eeprom - currently disabled, use at your own risk
  */
+#if 0
 static int ath5k_hw_eeprom_write(struct ath5k_hw *ah, u32 offset, u16 data)
 {
-#if 0
+
 	u32 status, timeout;
 
 	ATH5K_TRACE(ah->ah_sc);
@@ -1634,10 +1628,11 @@ static int ath5k_hw_eeprom_write(struct ath5k_hw *ah, u32 offset, u16 data)
 		}
 		udelay(15);
 	}
-#endif
+
 	ATH5K_ERR(ah->ah_sc, "EEPROM Write is disabled!");
 	return -EIO;
 }
+#endif
 
 /*
  * Translate binary channel representation in EEPROM to frequency
@@ -2043,50 +2038,6 @@ static int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 }
 
 /*
- * Read/Write regulatory domain
- */
-static bool ath5k_eeprom_regulation_domain(struct ath5k_hw *ah, bool write,
-	enum ath5k_regdom *regdomain)
-{
-	u16 ee_regdomain;
-
-	/* Read current value */
-	if (write != true) {
-		ee_regdomain = ah->ah_capabilities.cap_eeprom.ee_regdomain;
-		*regdomain = ath5k_regdom_to_ieee(ee_regdomain);
-		return true;
-	}
-
-	ee_regdomain = ath5k_regdom_from_ieee(*regdomain);
-
-	/* Try to write a new value */
-	if (ah->ah_capabilities.cap_eeprom.ee_protect &
-			AR5K_EEPROM_PROTECT_WR_128_191)
-		return false;
-	if (ath5k_hw_eeprom_write(ah, AR5K_EEPROM_REG_DOMAIN, ee_regdomain)!=0)
-		return false;
-
-	ah->ah_capabilities.cap_eeprom.ee_regdomain = ee_regdomain;
-
-	return true;
-}
-
-/*
- * Use the above to write a new regulatory domain
- */
-int ath5k_hw_set_regdomain(struct ath5k_hw *ah, u16 regdomain)
-{
-	enum ath5k_regdom ieee_regdomain;
-
-	ieee_regdomain = ath5k_regdom_to_ieee(regdomain);
-
-	if (ath5k_eeprom_regulation_domain(ah, true, &ieee_regdomain) == true)
-		return 0;
-
-	return -EIO;
-}
-
-/*
  * Fill the capabilities struct
  */
 static int ath5k_hw_get_capabilities(struct ath5k_hw *ah)
@@ -2108,8 +2059,8 @@ static int ath5k_hw_get_capabilities(struct ath5k_hw *ah)
 		ah->ah_capabilities.cap_range.range_2ghz_max = 0;
 
 		/* Set supported modes */
-		__set_bit(MODE_IEEE80211A, ah->ah_capabilities.cap_mode);
-		__set_bit(MODE_ATHEROS_TURBO, ah->ah_capabilities.cap_mode);
+		__set_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode);
+		__set_bit(AR5K_MODE_11A_TURBO, ah->ah_capabilities.cap_mode);
 	} else {
 		/*
 		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
@@ -2131,12 +2082,12 @@ static int ath5k_hw_get_capabilities(struct ath5k_hw *ah)
 			ah->ah_capabilities.cap_range.range_5ghz_max = 6100;
 
 			/* Set supported modes */
-			__set_bit(MODE_IEEE80211A,
+			__set_bit(AR5K_MODE_11A,
 					ah->ah_capabilities.cap_mode);
-			__set_bit(MODE_ATHEROS_TURBO,
+			__set_bit(AR5K_MODE_11A_TURBO,
 					ah->ah_capabilities.cap_mode);
 			if (ah->ah_version == AR5K_AR5212)
-				__set_bit(MODE_ATHEROS_TURBOG,
+				__set_bit(AR5K_MODE_11G_TURBO,
 						ah->ah_capabilities.cap_mode);
 		}
 
@@ -2148,11 +2099,11 @@ static int ath5k_hw_get_capabilities(struct ath5k_hw *ah)
 			ah->ah_capabilities.cap_range.range_2ghz_max = 2732;
 
 			if (AR5K_EEPROM_HDR_11B(ee_header))
-				__set_bit(MODE_IEEE80211B,
+				__set_bit(AR5K_MODE_11B,
 						ah->ah_capabilities.cap_mode);
 
 			if (AR5K_EEPROM_HDR_11G(ee_header))
-				__set_bit(MODE_IEEE80211G,
+				__set_bit(AR5K_MODE_11G,
 						ah->ah_capabilities.cap_mode);
 		}
 	}
@@ -4242,35 +4193,6 @@ void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
 }
 
 
-/*********************************\
- Regulatory Domain/Channels Setup
-\*********************************/
-
-u16 ath5k_get_regdomain(struct ath5k_hw *ah)
-{
-	u16 regdomain;
-	enum ath5k_regdom ieee_regdomain;
-#ifdef COUNTRYCODE
-	u16 code;
-#endif
-
-	ath5k_eeprom_regulation_domain(ah, false, &ieee_regdomain);
-	ah->ah_capabilities.cap_regdomain.reg_hw = ieee_regdomain;
-
-#ifdef COUNTRYCODE
-	/*
-	 * Get the regulation domain by country code. This will ignore
-	 * the settings found in the EEPROM.
-	 */
-	code = ieee80211_name2countrycode(COUNTRYCODE);
-	ieee_regdomain = ieee80211_countrycode2regdomain(code);
-#endif
-
-	regdomain = ath5k_regdom_from_ieee(ieee_regdomain);
-	ah->ah_capabilities.cap_regdomain.reg_current = regdomain;
-
-	return regdomain;
-}
 
 
 /****************\
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 2c22f1d..a255d8b 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1317,7 +1317,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 	/* For AR5211 */
 	} else if (ah->ah_version == AR5K_AR5211) {
 
-		if(mode > 2){ /* AR5K_INI_VAL_11B */
+		if(mode > 2){ /* AR5K_MODE_11B */
 			ATH5K_ERR(ah->ah_sc,"unsupported channel mode: %d\n", mode);
 			return -EINVAL;
 		}
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index b959417..8b576b3 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1018,7 +1018,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 	int obdb = -1, bank = -1;
 	u32 ee_mode;
 
-	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
+	AR5K_ASSERT_ENTRY(mode, AR5K_MODE_MAX);
 
 	rf = ah->ah_rf_banks;
 
@@ -1038,8 +1038,8 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 	}
 
 	/* Modify bank 0 */
-	if (channel->val & CHANNEL_2GHZ) {
-		if (channel->val & CHANNEL_CCK)
+	if (channel->hw_value & CHANNEL_2GHZ) {
+		if (channel->hw_value & CHANNEL_CCK)
 			ee_mode = AR5K_EEPROM_MODE_11B;
 		else
 			ee_mode = AR5K_EEPROM_MODE_11G;
@@ -1058,10 +1058,10 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 	} else {
 		/* For 11a, Turbo and XR */
 		ee_mode = AR5K_EEPROM_MODE_11A;
-		obdb =	 channel->freq >= 5725 ? 3 :
-			(channel->freq >= 5500 ? 2 :
-			(channel->freq >= 5260 ? 1 :
-			 (channel->freq > 4000 ? 0 : -1)));
+		obdb =	 channel->center_freq >= 5725 ? 3 :
+			(channel->center_freq >= 5500 ? 2 :
+			(channel->center_freq >= 5260 ? 1 :
+			 (channel->center_freq > 4000 ? 0 : -1)));
 
 		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_pwd_84, 1, 51, 3, true))
@@ -1119,12 +1119,12 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 	int obdb = -1, bank = -1;
 	u32 ee_mode;
 
-	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
+	AR5K_ASSERT_ENTRY(mode, AR5K_MODE_MAX);
 
 	rf = ah->ah_rf_banks;
 
 	if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_2112A
-		&& !test_bit(MODE_IEEE80211A, ah->ah_capabilities.cap_mode)){
+		&& !test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode)){
 		rf_ini = rfregs_2112a;
 		rf_size = ARRAY_SIZE(rfregs_5112a);
 		if (mode < 2) {
@@ -1156,8 +1156,8 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 	}
 
 	/* Modify bank 6 */
-	if (channel->val & CHANNEL_2GHZ) {
-		if (channel->val & CHANNEL_OFDM)
+	if (channel->hw_value & CHANNEL_2GHZ) {
+		if (channel->hw_value & CHANNEL_OFDM)
 			ee_mode = AR5K_EEPROM_MODE_11G;
 		else
 			ee_mode = AR5K_EEPROM_MODE_11B;
@@ -1173,10 +1173,10 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 	} else {
 		/* For 11a, Turbo and XR */
 		ee_mode = AR5K_EEPROM_MODE_11A;
-		obdb = channel->freq >= 5725 ? 3 :
-		    (channel->freq >= 5500 ? 2 :
-			(channel->freq >= 5260 ? 1 :
-			    (channel->freq > 4000 ? 0 : -1)));
+		obdb = channel->center_freq >= 5725 ? 3 :
+		    (channel->center_freq >= 5500 ? 2 :
+			(channel->center_freq >= 5260 ? 1 :
+			    (channel->center_freq > 4000 ? 0 : -1)));
 
 		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
@@ -1219,7 +1219,7 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
 	unsigned int rf_size, i;
 	int bank = -1;
 
-	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
+	AR5K_ASSERT_ENTRY(mode, AR5K_MODE_MAX);
 
 	rf = ah->ah_rf_banks;
 
@@ -1445,7 +1445,7 @@ static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
 	 * newer chipsets like the AR5212A who have a completely
 	 * different RF/PHY part.
 	 */
-	athchan = (ath5k_hw_bitswap((channel->chan - 24) / 2, 5) << 1) |
+	athchan = (ath5k_hw_bitswap((ieee80211_frequency_to_channel(channel->center_freq) - 24) / 2, 5) << 1) |
 		(1 << 6) | 0x1;
 
 	return athchan;
@@ -1506,7 +1506,7 @@ static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	struct ath5k_athchan_2ghz ath5k_channel_2ghz;
-	unsigned int ath5k_channel = channel->chan;
+	unsigned int ath5k_channel = ieee80211_frequency_to_channel(channel->center_freq);
 	u32 data0, data1, clock;
 	int ret;
 
@@ -1515,9 +1515,9 @@ static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 	 */
 	data0 = data1 = 0;
 
-	if (channel->val & CHANNEL_2GHZ) {
+	if (channel->hw_value & CHANNEL_2GHZ) {
 		/* Map 2GHz channel to 5GHz Atheros channel ID */
-		ret = ath5k_hw_rf5111_chan2athchan(channel->chan,
+		ret = ath5k_hw_rf5111_chan2athchan(ieee80211_frequency_to_channel(channel->center_freq),
 				&ath5k_channel_2ghz);
 		if (ret)
 			return ret;
@@ -1555,7 +1555,7 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 	u16 c;
 
 	data = data0 = data1 = data2 = 0;
-	c = channel->freq;
+	c = channel->center_freq;
 
 	/*
 	 * Set the channel on the RF5112 or newer
@@ -1604,13 +1604,13 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	 * Check bounds supported by the PHY
 	 * (don't care about regulation restrictions at this point)
 	 */
-	if ((channel->freq < ah->ah_capabilities.cap_range.range_2ghz_min ||
-	    channel->freq > ah->ah_capabilities.cap_range.range_2ghz_max) &&
-	    (channel->freq < ah->ah_capabilities.cap_range.range_5ghz_min ||
-	    channel->freq > ah->ah_capabilities.cap_range.range_5ghz_max)) {
+	if ((channel->center_freq < ah->ah_capabilities.cap_range.range_2ghz_min ||
+	    channel->center_freq > ah->ah_capabilities.cap_range.range_2ghz_max) &&
+	    (channel->center_freq < ah->ah_capabilities.cap_range.range_5ghz_min ||
+	    channel->center_freq > ah->ah_capabilities.cap_range.range_5ghz_max)) {
 		ATH5K_ERR(ah->ah_sc,
 			"channel out of supported range (%u MHz)\n",
-			channel->freq);
+			channel->center_freq);
 		return -EINVAL;
 	}
 
@@ -1632,9 +1632,9 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	if (ret)
 		return ret;
 
-	ah->ah_current_channel.freq = channel->freq;
-	ah->ah_current_channel.val = channel->val;
-	ah->ah_turbo = channel->val == CHANNEL_T ? true : false;
+	ah->ah_current_channel.center_freq = channel->center_freq;
+	ah->ah_current_channel.hw_value = channel->hw_value;
+	ah->ah_turbo = channel->hw_value == CHANNEL_T ? true : false;
 
 	return 0;
 }
@@ -1797,11 +1797,11 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 
 	if (ret) {
 		ATH5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
-				channel->freq);
+				channel->center_freq);
 		return ret;
 	}
 
-	ret = ath5k_hw_noise_floor_calibration(ah, channel->freq);
+	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
 	if (ret)
 		return ret;
 
@@ -1848,10 +1848,10 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
 
 done:
-	ath5k_hw_noise_floor_calibration(ah, channel->freq);
+	ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
 
 	/* Request RF gain */
-	if (channel->val & CHANNEL_5GHZ) {
+	if (channel->hw_value & CHANNEL_5GHZ) {
 		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txpower.txp_max,
 			AR5K_PHY_PAPD_PROBE_TXPOWER) |
 			AR5K_PHY_PAPD_PROBE_TX_NEXT, AR5K_PHY_PAPD_PROBE);
-- 
1.5.3.7

