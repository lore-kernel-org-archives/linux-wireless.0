Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:3212 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbXJMUIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 16:08:37 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1275045wxd
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 13:08:36 -0700 (PDT)
Date: Sat, 13 Oct 2007 16:08:29 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath5k: Fix and clean mode initialization, prefer G
	for AR5212
Message-ID: <20071013200829.GA8951@pogo> (sfid-20071013_210848_041769_72A202B4)
References: <20071012150438.GC9407@pogo> <20071012150543.GD9407@pogo> <20071012150709.GE9407@pogo> <20071012150745.GF9407@pogo> <4af2d03a0710121433r1f32aaabt4bb8d50c61ef12d5@mail.gmail.com> <20071012223757.GA4994@pogo> <40f31dec0710130221o4b38d5fcld4239b48d24e8206@mail.gmail.com> <40f31dec0710130230xa5d4869x814ccdfad10802be@mail.gmail.com> <47109214.3030409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47109214.3030409@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 13, 2007 at 11:38:28AM +0200, Jiri Slaby wrote:
> On 10/13/2007 11:30 AM, Nick Kossifidis wrote:
> > I mean something like this...
> > 
> > if(test_bit(MODE_IEEE80211B,hal->ah_capabilities.cap_mode)) {
> 
> this reminds me I wanted to get rid of locked set_bit and use __set_bit 
> instead ;-).
> 
> > REGISTER_MODE(MODE_IEEE80211B);
> > }
> 
> or do it directly in register_mode. I'm for making function from the macro in
> that case.

OK well here's another patch taking these things into consideration.
Resulting ath_dump_modes()'s is below as well for AR5210, AR5211, and
AR5212.

----------------------- AR5210 --------------------------------------
Mode 0: channels 0, rates 0
 channels:
 rates:
Mode 1: channels 0, rates 0
 channels:
 rates:
Mode 2: channels 8, rates 8
 channels:
   36 5180 0140 0007
   40 5200 0140 0007
   44 5220 0140 0007
   48 5240 0140 0007
   52 5260 0140 0007
   56 5280 0140 0007
   60 5300 0140 0007
   64 5320 0140 0007
 rates:
    60 000b 0132 0000
    90 000f 0030 0000
   120 000a 0132 0000
   180 000e 0030 0000
   240 0009 0132 0000
   360 000d 0030 0000
   480 0008 0030 0000
   540 000c 0030 0000
phy4: Selected rate control algorithm 'simple'
ath_pci 0000:15:00.0: AR5210 chip found: mac 0.0 phy 0.3
----------------------- AR5211 --------------------------------------
Mode 0: channels 0, rates 0
 channels:
 rates:
Mode 1: channels 11, rates 4
 channels:
    1 2412 00a0 0007
    2 2417 00a0 0007
    3 2422 00a0 0007
    4 2427 00a0 0007
    5 2432 00a0 0007
    6 2437 00a0 0007
    7 2442 00a0 0007
    8 2447 00a0 0007
    9 2452 00a0 0007
   10 2457 00a0 0007
   11 2462 00a0 0007
 rates:
    10 001b 0152 0000
    20 001a 0056 0000
    55 0019 0054 0000
   110 0018 0054 0000
Mode 2: channels 13, rates 8
 channels:
   36 5180 0140 0007
   40 5200 0140 0007
   44 5220 0140 0007
   48 5240 0140 0007
   52 5260 0140 0007
   56 5280 0140 0007
   60 5300 0140 0007
   64 5320 0140 0007
  149 5745 0140 0007
  153 5765 0140 0007
  157 5785 0140 0007
  161 5805 0140 0007
  165 5825 0140 0007
 rates:
    60 000b 0132 0000
    90 000f 0030 0000
   120 000a 0132 0000
   180 000e 0030 0000
   240 0009 0132 0000
   360 000d 0030 0000
   480 0008 0030 0000
   540 000c 0030 0000
phy3: Selected rate control algorithm 'simple'
ath_pci 0000:15:00.0: AR5211 chip found: mac 4.4 phy 3.0
----------------------- AR5212 --------------------------------------
Mode 0: channels 11, rates 10
 channels:
    1 2412 00c0 0007
    2 2417 00c0 0007
    3 2422 00c0 0007
    4 2427 00c0 0007
    5 2432 00c0 0007
    6 2437 00c0 0007
    7 2442 00c0 0007
    8 2447 00c0 0007
    9 2452 00c0 0007
   10 2457 00c0 0007
   11 2462 00c0 0007
 rates:
    10 001b 0152 0000
    20 001a 0156 0000
    55 0019 0156 0000
   110 0018 0156 0000
   120 000a 0131 0000
   180 000e 0031 0000
   240 0009 0131 0000
   360 000d 0031 0000
   480 0008 0031 0000
   540 000c 0031 0000
Mode 1: channels 11, rates 4
 channels:
    1 2412 00a0 0000
    2 2417 00a0 0000
    3 2422 00a0 0000
    4 2427 00a0 0000
    5 2432 00a0 0000
    6 2437 00a0 0000
    7 2442 00a0 0000
    8 2447 00a0 0000
    9 2452 00a0 0000
   10 2457 00a0 0000
   11 2462 00a0 0000
 rates:
    10 001b 0040 0000
    20 001a 0044 0000
    55 0019 0044 0000
   110 0018 0044 0000
Mode 2: channels 13, rates 8
 channels:
   36 5180 0140 0007
   40 5200 0140 0007
   44 5220 0140 0007
   48 5240 0140 0007
   52 5260 0140 0007
   56 5280 0140 0007
   60 5300 0140 0007
   64 5320 0140 0007
  149 5745 0140 0007
  153 5765 0140 0007
  157 5785 0140 0007
  161 5805 0140 0007
  165 5825 0140 0007
 rates:
    60 000b 0132 0000
    90 000f 0030 0000
   120 000a 0132 0000
   180 000e 0030 0000
   240 0009 0132 0000
   360 000d 0030 0000
   480 0008 0030 0000
   540 000c 0030 0000
phy1: Selected rate control algorithm 'simple'
ath_pci 0000:15:00.0: AR5212 chip found: mac 5.5 phy 4.3
---------------------------------------------------------------------

[PATCH 5/5] ath5k: Fix and clean mode initialization, prefer G for AR5212

Currently you get locked on B mode with AR5212s. This could be partly
mac80211's fault with a recent regression introduced but ath5k mode
initialization right now is pretty sloppy. For AR5212s we also currently
start scanning in 5GHz. I've made the mode initialization on ath5k a bit
clearer and only am registering G mode now instead of both B and G for
AR5212s. We now also check eeprom reading for capabilities before registering
a specific mode. For AR5212 I get reliable rates only up to 18Mbps for a 
throughput of up to 5 Mbits/sec. At least now we can work and test the
other rates again.

Also use a static driver specific NUM_DRIVER_MODES instead of mac80211's 
NUM_IEEE80211_MODES.

This patch has been tested on AR5210, AR5211 and AR5212.

Note: mac80211 simple rate algo throws us to 1Mbps after assoc, this is by
        design. I recommend users to set rate to 11M for now after assoc.

Changes to base.[ch]
Changes-licensed-under: 3-clause-BSD

Changes to ath5k.h
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    5 +-
 drivers/net/wireless/ath5k/base.c  |  125 +++++++++++++++++++++---------------
 drivers/net/wireless/ath5k/base.h  |    5 +-
 3 files changed, 79 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 09c920b..bcf1041 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -214,6 +214,9 @@ enum ath5k_vendor_mode {
 	MODE_ATHEROS_TURBOG
 };
 
+/* Number of supported mac80211 enum ieee80211_phymode modes by this driver */
+#define NUM_DRIVER_MODES	3
+
 /* adding this flag to rate_code enables short preamble, see ar5212_reg.h */
 #define AR5K_SET_SHORT_PREAMBLE 0x04
 
@@ -865,7 +868,7 @@ struct ath5k_capabilities {
 	 * Supported PHY modes
 	 * (ie. CHANNEL_A, CHANNEL_B, ...)
 	 */
-	DECLARE_BITMAP(cap_mode, NUM_IEEE80211_MODES);
+	DECLARE_BITMAP(cap_mode, NUM_DRIVER_MODES);
 
 	/*
 	 * Frequency range (without regulation restrictions)
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 18ee995..db37ceb 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1896,7 +1896,7 @@ static void ath_dump_modes(struct ieee80211_hw_mode *modes)
 {
 	unsigned int m, i;
 
-	for (m = 0; m < NUM_IEEE80211_MODES; m++) {
+	for (m = 0; m < NUM_DRIVER_MODES; m++) {
 		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
 				modes[m].num_channels, modes[m].num_rates);
 		printk(KERN_DEBUG " channels:\n");
@@ -1919,71 +1919,92 @@ static void ath_dump_modes(struct ieee80211_hw_mode *modes)
 static inline void ath_dump_modes(struct ieee80211_hw_mode *modes) {}
 #endif
 
+static inline int ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ieee80211_hw_mode *modes = sc->modes;
+	int i, ret;
+
+	for (i = 0; i < NUM_DRIVER_MODES; i++) {
+		if (modes[i].mode != m || !modes[i].num_channels)
+			continue;
+		ret = ieee80211_register_hwmode(hw, &modes[i]);
+		if (ret) {
+			printk(KERN_ERR "can't register hwmode %u\n", m);
+			return ret;
+		}
+		return 0;
+	}
+	return 1;
+}
+
+/* Only tries to register modes our EEPROM says it can support */
+#define REGISTER_MODE(m) do { \
+	if (test_bit(m, ah->ah_capabilities.cap_mode)) { \
+		ret = ath5k_register_mode(hw, m); \
+		if (ret) \
+			return ret; \
+	} \
+} while (0) \
+
 static int ath_getchannels(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->ah;
 	struct ieee80211_hw_mode *modes = sc->modes;
-	unsigned int i, max;
+	unsigned int i, max_r, max_c;
 	int ret;
-	enum {
-		A = MODE_IEEE80211A,
-		B = MODE_IEEE80211G, /* this is not a typo, but workaround */
-		G = MODE_IEEE80211B, /* to prefer g over b */
-		T = MODE_ATHEROS_TURBO,
-		TG = MODE_ATHEROS_TURBOG,
-	};
 
 	BUILD_BUG_ON(ARRAY_SIZE(sc->modes) < 3);
 
 	ah->ah_country_code = countrycode;
 
-	modes[A].mode = MODE_IEEE80211A;
-	modes[B].mode = MODE_IEEE80211B;
-	modes[G].mode = MODE_IEEE80211G;
-
-	max = ARRAY_SIZE(sc->rates);
-	modes[A].rates = sc->rates;
-	max -= modes[A].num_rates = ath_copy_rates(modes[A].rates,
-			ath5k_hw_get_rate_table(ah, MODE_IEEE80211A), max);
-	modes[B].rates = &modes[A].rates[modes[A].num_rates];
-	max -= modes[B].num_rates = ath_copy_rates(modes[B].rates,
-			ath5k_hw_get_rate_table(ah, MODE_IEEE80211B), max);
-	modes[G].rates = &modes[B].rates[modes[B].num_rates];
-	max -= modes[G].num_rates = ath_copy_rates(modes[G].rates,
-			ath5k_hw_get_rate_table(ah, MODE_IEEE80211G), max);
-
-	if (!max)
-		printk(KERN_WARNING "yet another rates found, but there is not "
-				"sufficient space to store them\n");
-
-	max = ARRAY_SIZE(sc->channels);
-	modes[A].channels = sc->channels;
-	max -= modes[A].num_channels = ath_copy_channels(ah, modes[A].channels,
-			MODE_IEEE80211A, max);
-	modes[B].channels = &modes[A].channels[modes[A].num_channels];
-	max -= modes[B].num_channels = ath_copy_channels(ah, modes[B].channels,
-			MODE_IEEE80211B, max);
-	modes[G].channels = &modes[B].channels[modes[B].num_channels];
-	max -= modes[G].num_channels = ath_copy_channels(ah, modes[G].channels,
-			MODE_IEEE80211G, max);
-
-	if (!max)
-		printk(KERN_WARNING "yet another modes found, but there is not "
-				"sufficient space to store them\n");
-
-	for (i = 0; i < ARRAY_SIZE(sc->modes); i++)
-		if (modes[i].num_channels) {
-			ret = ieee80211_register_hwmode(hw, &modes[i]);
-			if (ret) {
-				printk(KERN_ERR "can't register hwmode %u\n",i);
-				goto err;
-			}
+	/* The order here does not matter */
+	modes[0].mode = MODE_IEEE80211G;
+	modes[1].mode = MODE_IEEE80211B;
+	modes[2].mode = MODE_IEEE80211A;
+
+	max_r = ARRAY_SIZE(sc->rates);
+	max_c = ARRAY_SIZE(sc->channels);
+
+	for (i = 0; i < NUM_DRIVER_MODES; i++) {
+		struct ieee80211_hw_mode *mode = &modes[i];
+		const struct ath5k_rate_table *hw_rates;
+
+		if (i == 0) {
+			modes[0].rates	= sc->rates;
+			modes->channels	= sc->channels;
+		} else {
+			struct ieee80211_hw_mode *prev_mode = &modes[i-1];
+			int prev_num_r	= prev_mode->num_rates;
+			int prev_num_c	= prev_mode->num_channels;
+			mode->rates	= &prev_mode->rates[prev_num_r];
+			mode->channels	= &prev_mode->channels[prev_num_c];
 		}
+
+		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
+		mode->num_rates    = ath_copy_rates(mode->rates, hw_rates,
+			max_r);
+		mode->num_channels = ath_copy_channels(ah, mode->channels,
+			mode->mode, max_c);
+		max_r -= mode->num_rates;
+		max_c -= mode->num_channels;
+	}
+
+	/* We try to register all modes this driver supports. We don't bother
+	 * with MODE_IEEE80211B for AR5212 as MODE_IEEE80211G already accounts
+	 * for that as per mac80211. Then, REGISTER_MODE() will will actually
+	 * check the eeprom reading for more reliable capability information.
+	 * Order matters here as per mac80211's latest preference. This will
+	 * all hopefullly soon go away. */
+
+	REGISTER_MODE(MODE_IEEE80211G);
+	if (ah->ah_version != AR5K_AR5212)
+		REGISTER_MODE(MODE_IEEE80211B);
+	REGISTER_MODE(MODE_IEEE80211A);
+
 	ath_dump_modes(modes);
 
-	return 0;
-err:
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 4a624cc..390d3d7 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -116,7 +116,6 @@ struct ath_txq {
 #define ATH_CHAN_MAX	(14+14+14+252+20)	/* XXX what's the max? */
 #endif
 
-
 /* Software Carrier, keeps track of the driver state
  * associated with an instance of a device */
 struct ath_softc {
@@ -126,9 +125,9 @@ struct ath_softc {
 	struct ieee80211_tx_queue_stats tx_stats;
 	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
-	struct ieee80211_hw_mode modes[NUM_IEEE80211_MODES];
+	struct ieee80211_hw_mode modes[NUM_DRIVER_MODES];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
-	struct ieee80211_rate	rates[AR5K_MAX_RATES * NUM_IEEE80211_MODES];
+	struct ieee80211_rate	rates[AR5K_MAX_RATES * NUM_DRIVER_MODES];
 	enum ieee80211_if_types	opmode;
 	struct ath_hw		*ah;		/* Atheros HW */
 
