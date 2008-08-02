Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25761 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYHBXtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/12] ath9k: Channel structure cleanup
Date: Sat, 2 Aug 2008 16:48:59 -0700
Message-ID: <1217720944-23234-8-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014924_254717_BFF05997)
In-Reply-To: <1217720944-23234-7-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-6-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Remove struct hal_channel and use a single ath9k specific channel structure.
Now that channelFlags is a bitmask of all supported modes,
set the mode required when switching to a new channel.
Checking for HT20 and HT40 in channelFlags will not work for channels which
support both modes, check chanmode instead.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   44 +++++------
 drivers/net/wireless/ath9k/core.c  |   30 +++----
 drivers/net/wireless/ath9k/core.h  |    6 +-
 drivers/net/wireless/ath9k/hw.c    |  152 ++++++++++++++++--------------------
 drivers/net/wireless/ath9k/hw.h    |    2 +-
 drivers/net/wireless/ath9k/main.c  |   62 +++++++++------
 drivers/net/wireless/ath9k/phy.c   |    2 +-
 drivers/net/wireless/ath9k/phy.h   |    2 +-
 drivers/net/wireless/ath9k/regd.c  |    8 +-
 9 files changed, 149 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 8e86e11..4965afb 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -421,16 +421,6 @@ struct hal_11n_rate_series {
 	u_int RateFlags;
 };
 
-struct hal_channel {
-	u_int16_t channel;
-	u_int32_t channelFlags;
-	u_int32_t chanmode;
-	u_int8_t privFlags;
-	int8_t maxRegTxPower;
-	int8_t maxTxPower;
-	int8_t minTxPower;
-};
-
 #define CHANNEL_CW_INT    0x00002
 #define CHANNEL_CCK       0x00020
 #define CHANNEL_OFDM      0x00040
@@ -453,7 +443,6 @@ struct hal_channel {
 
 #define CHANNEL_A           (CHANNEL_5GHZ|CHANNEL_OFDM)
 #define CHANNEL_B           (CHANNEL_2GHZ|CHANNEL_CCK)
-#define CHANNEL_PUREG       (CHANNEL_2GHZ|CHANNEL_OFDM)
 #define CHANNEL_G           (CHANNEL_2GHZ|CHANNEL_OFDM)
 #define CHANNEL_G_HT20      (CHANNEL_2GHZ|CHANNEL_HT20)
 #define CHANNEL_A_HT20      (CHANNEL_5GHZ|CHANNEL_HT20)
@@ -477,6 +466,7 @@ struct ath9k_channel {
 	int8_t maxRegTxPower;
 	int8_t maxTxPower;
 	int8_t minTxPower;
+	u_int32_t chanmode;
 	int32_t CalValid;
 	bool oneTimeCalsDone;
 	int8_t iCoff;
@@ -504,8 +494,6 @@ struct ath9k_channel {
        (((_c)->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20) || \
        (((_c)->channelFlags & CHANNEL_G_HT40PLUS) == CHANNEL_G_HT40PLUS) || \
        (((_c)->channelFlags & CHANNEL_G_HT40MINUS) == CHANNEL_G_HT40MINUS))
-#define IS_CHAN_PUREG(_c) \
-	(((_c)->channelFlags & CHANNEL_PUREG) == CHANNEL_PUREG)
 #define IS_CHAN_CCK(_c) (((_c)->channelFlags & CHANNEL_CCK) != 0)
 #define IS_CHAN_OFDM(_c) (((_c)->channelFlags & CHANNEL_OFDM) != 0)
 #define IS_CHAN_5GHZ(_c) (((_c)->channelFlags & CHANNEL_5GHZ) != 0)
@@ -513,10 +501,16 @@ struct ath9k_channel {
 #define IS_CHAN_PASSIVE(_c) (((_c)->channelFlags & CHANNEL_PASSIVE) != 0)
 #define IS_CHAN_HALF_RATE(_c) (((_c)->channelFlags & CHANNEL_HALF) != 0)
 #define IS_CHAN_QUARTER_RATE(_c) (((_c)->channelFlags & CHANNEL_QUARTER) != 0)
-#define IS_CHAN_HT20(_c) (((_c)->channelFlags & CHANNEL_HT20) != 0)
-#define IS_CHAN_HT40(_c) ((((_c)->channelFlags & CHANNEL_HT40PLUS) != 0) \
-			  || (((_c)->channelFlags & CHANNEL_HT40MINUS) != 0))
+
+/* These macros check chanmode and not channelFlags */
+#define IS_CHAN_HT20(_c) (((_c)->chanmode == CHANNEL_A_HT20) ||	\
+			  ((_c)->chanmode == CHANNEL_G_HT20))
+#define IS_CHAN_HT40(_c) (((_c)->chanmode == CHANNEL_A_HT40PLUS) ||	\
+			  ((_c)->chanmode == CHANNEL_A_HT40MINUS) ||	\
+			  ((_c)->chanmode == CHANNEL_G_HT40PLUS) ||	\
+			  ((_c)->chanmode == CHANNEL_G_HT40MINUS))
 #define IS_CHAN_HT(_c) (IS_CHAN_HT20((_c)) || IS_CHAN_HT40((_c)))
+
 #define IS_CHAN_IN_PUBLIC_SAFETY_BAND(_c) ((_c) > 4940 && (_c) < 4990)
 #define IS_CHAN_A_5MHZ_SPACED(_c)			\
 	((((_c)->channelFlags & CHANNEL_5GHZ) != 0) &&	\
@@ -966,25 +960,25 @@ u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
 enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah,
 				     enum hal_int ints);
 bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
-		    struct hal_channel *chan,
+		    struct ath9k_channel *chan,
 		    enum hal_ht_macmode macmode,
 		    u_int8_t txchainmask, u_int8_t rxchainmask,
 		    enum hal_ht_extprotspacing extprotspacing,
 		    bool bChannelChange,
 		    enum hal_status *status);
 bool ath9k_hw_phy_disable(struct ath_hal *ah);
-void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
+void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 			     bool *isCalDone);
 void ath9k_hw_ani_monitor(struct ath_hal *ah,
 			  const struct hal_node_stats *stats,
-			  struct hal_channel *chan);
+			  struct ath9k_channel *chan);
 bool ath9k_hw_calibrate(struct ath_hal *ah,
-			struct hal_channel *chan,
+			struct ath9k_channel *chan,
 			u_int8_t rxchainmask,
 			bool longcal,
 			bool *isCalDone);
 int16_t ath9k_hw_getchan_noise(struct ath_hal *ah,
-			       struct hal_channel *chan);
+			       struct ath9k_channel *chan);
 void ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
 			    u_int16_t assocId);
 void ath9k_hw_setrxfilter(struct ath_hal *ah, u_int32_t bits);
@@ -1035,7 +1029,7 @@ u_int ath9k_hw_getdefantenna(struct ath_hal *ah);
 bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us);
 bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			       enum hal_ant_setting settings,
-			       struct hal_channel *chan,
+			       struct ath9k_channel *chan,
 			       u_int8_t *tx_chainmask,
 			       u_int8_t *rx_chainmask,
 			       u_int8_t *antenna_cfgd);
@@ -1061,16 +1055,16 @@ void ath9k_hw_set11n_burstduration(struct ath_hal *ah,
 void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds);
 u_int32_t ath9k_hw_reverse_bits(u_int32_t val, u_int32_t n);
 bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q);
-u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct hal_channel *chan);
+u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan);
 u_int ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
-				     struct hal_channel *chan);
+				     struct ath9k_channel *chan);
 u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
 bool ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 			      struct hal_txq_info *qInfo);
 bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
 			      const struct hal_txq_info *qInfo);
 struct ath9k_channel *ath9k_regd_check_channel(struct ath_hal *ah,
-					      const struct hal_channel *c);
+					      const struct ath9k_channel *c);
 void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
 			    u_int pktLen, enum hal_pkt_type type,
 			    u_int txPower, u_int keyIx,
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 1849e03..81679b4 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -262,29 +262,25 @@ static int ath_setup_channels(struct ath_softc *sc)
  *  exist, the lowest mode (11b) is selected.
 */
 
-static enum wireless_mode ath_chan2mode(struct hal_channel *chan)
+static enum wireless_mode ath_chan2mode(struct ath9k_channel *chan)
 {
-	if ((chan->channelFlags & CHANNEL_A) == CHANNEL_A)
+	if (chan->chanmode == CHANNEL_A)
 		return WIRELESS_MODE_11a;
-	else if ((chan->channelFlags & CHANNEL_G) == CHANNEL_G)
+	else if (chan->chanmode == CHANNEL_G)
 		return WIRELESS_MODE_11g;
-	else if ((chan->channelFlags & CHANNEL_B) == CHANNEL_B)
+	else if (chan->chanmode == CHANNEL_B)
 		return WIRELESS_MODE_11b;
-	else if ((chan->channelFlags & CHANNEL_A_HT20) == CHANNEL_A_HT20)
+	else if (chan->chanmode == CHANNEL_A_HT20)
 		return WIRELESS_MODE_11NA_HT20;
-	else if ((chan->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20)
+	else if (chan->chanmode == CHANNEL_G_HT20)
 		return WIRELESS_MODE_11NG_HT20;
-	else if ((chan->channelFlags & CHANNEL_A_HT40PLUS) ==
-		 CHANNEL_A_HT40PLUS)
+	else if (chan->chanmode == CHANNEL_A_HT40PLUS)
 		return WIRELESS_MODE_11NA_HT40PLUS;
-	else if ((chan->channelFlags & CHANNEL_A_HT40MINUS) ==
-		 CHANNEL_A_HT40MINUS)
+	else if (chan->chanmode == CHANNEL_A_HT40MINUS)
 		return WIRELESS_MODE_11NA_HT40MINUS;
-	else if ((chan->channelFlags & CHANNEL_G_HT40PLUS) ==
-		 CHANNEL_G_HT40PLUS)
+	else if (chan->chanmode == CHANNEL_G_HT40PLUS)
 		return WIRELESS_MODE_11NG_HT40PLUS;
-	else if ((chan->channelFlags & CHANNEL_G_HT40MINUS) ==
-		 CHANNEL_G_HT40MINUS)
+	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
 		return WIRELESS_MODE_11NG_HT40MINUS;
 
 	/* NB: should not get here */
@@ -298,7 +294,7 @@ static enum wireless_mode ath_chan2mode(struct hal_channel *chan)
  *  the current operating mode for the new channel.
 */
 
-static void ath_chan_change(struct ath_softc *sc, struct hal_channel *chan)
+static void ath_chan_change(struct ath_softc *sc, struct ath9k_channel *chan)
 {
 	enum wireless_mode mode;
 
@@ -407,7 +403,7 @@ void ath_scan_end(struct ath_softc *sc)
  * by reseting the chip.  To accomplish this we must first cleanup any pending
  * DMA, then restart stuff after a la ath_init.
 */
-int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan)
+int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
@@ -766,7 +762,7 @@ int ath_vap_config(struct ath_softc *sc,
 /* Core */
 /********/
 
-int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan)
+int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	enum hal_status status;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 281dc76..2f1881d 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1039,7 +1039,7 @@ struct ath_softc {
 	/* Channel, Band */
 	struct ieee80211_channel channels[IEEE80211_NUM_BANDS][ATH_CHAN_MAX];
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
-	struct hal_channel              sc_curchan; /* current h/w channel */
+	struct ath9k_channel            sc_curchan; /* current h/w channel */
 
 	/* Locks */
 	spinlock_t              sc_rxflushlock; /* lock of RX flush */
@@ -1051,13 +1051,13 @@ struct ath_softc {
 
 int ath_init(u_int16_t devid, struct ath_softc *sc);
 void ath_deinit(struct ath_softc *sc);
-int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan);
+int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan);
 int ath_suspend(struct ath_softc *sc);
 irqreturn_t ath_isr(int irq, void *dev);
 int ath_reset(struct ath_softc *sc);
 void ath_scan_start(struct ath_softc *sc);
 void ath_scan_end(struct ath_softc *sc);
-int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan);
+int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan);
 void ath_setup_rate(struct ath_softc *sc,
 		    enum wireless_mode wMode,
 		    enum RATE_TYPE type,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 0104455..3e95760 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -221,7 +221,7 @@ static struct hal_rate_table ar5416_11na_table = {
 };
 
 static enum wireless_mode ath9k_hw_chan2wmode(struct ath_hal *ah,
-				       const struct hal_channel *chan)
+				       const struct ath9k_channel *chan)
 {
 	if (IS_CHAN_CCK(chan))
 		return WIRELESS_MODE_11b;
@@ -371,7 +371,7 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 }
 
 static inline void ath9k_hw_override_ini(struct ath_hal *ah,
-					 struct hal_channel *chan)
+					 struct ath9k_channel *chan)
 {
 	if (!AR_SREV_5416_V20_OR_LATER(ah)
 	    || AR_SREV_9280_10_OR_LATER(ah))
@@ -381,7 +381,7 @@ static inline void ath9k_hw_override_ini(struct ath_hal *ah,
 }
 
 static inline void ath9k_hw_init_bb(struct ath_hal *ah,
-				    struct hal_channel *chan)
+				    struct ath9k_channel *chan)
 {
 	u_int32_t synthDelay;
 
@@ -1434,7 +1434,7 @@ static enum hal_status ath9k_hw_rf_claim(struct ath_hal *ah)
 }
 
 static inline void ath9k_hw_init_pll(struct ath_hal *ah,
-				     struct hal_channel *chan)
+				     struct ath9k_channel *chan)
 {
 	u_int32_t pll;
 
@@ -1501,7 +1501,7 @@ static inline void ath9k_hw_init_pll(struct ath_hal *ah,
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
 }
 
-static void ath9k_hw_set_regs(struct ath_hal *ah, struct hal_channel *chan,
+static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 			      enum hal_ht_macmode macmode)
 {
 	u_int32_t phymode;
@@ -1513,7 +1513,8 @@ static void ath9k_hw_set_regs(struct ath_hal *ah, struct hal_channel *chan,
 	if (IS_CHAN_HT40(chan)) {
 		phymode |= AR_PHY_FC_DYN2040_EN;
 
-		if (chan->channelFlags & CHANNEL_HT40PLUS)
+		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
+		    (chan->chanmode == CHANNEL_G_HT40PLUS))
 			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
 
 		if (ahp->ah_extprotspacing == HAL_HT_EXTPROTSPACING_25)
@@ -1552,7 +1553,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 }
 
 static inline void
-ath9k_hw_set_rfmode(struct ath_hal *ah, struct hal_channel *chan)
+ath9k_hw_set_rfmode(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	u_int32_t rfMode = 0;
 
@@ -1662,10 +1663,11 @@ static bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
 	}
 }
 
-static inline struct ath9k_channel *ath9k_hw_check_chan(
-			struct ath_hal *ah, struct hal_channel *chan)
+static inline
+struct ath9k_channel *ath9k_hw_check_chan(struct ath_hal *ah,
+					  struct ath9k_channel *chan)
 {
-	if ((IS(chan, CHANNEL_2GHZ) ^ IS(chan, CHANNEL_5GHZ)) == 0) {
+	if (!(IS_CHAN_2GHZ(chan) ^ IS_CHAN_5GHZ(chan))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; not marked as "
 			 "2GHz or 5GHz\n", __func__, chan->channel,
@@ -1673,15 +1675,14 @@ static inline struct ath9k_channel *ath9k_hw_check_chan(
 		return NULL;
 	}
 
-	if ((IS(chan, CHANNEL_OFDM)
-	     ^ IS(chan, CHANNEL_CCK)
-	     ^ IS(chan, CHANNEL_HT20)
-	     ^ IS(chan, CHANNEL_HT40PLUS)
-	     ^ IS(chan, CHANNEL_HT40MINUS)) == 0) {
+	if (!IS_CHAN_OFDM(chan) &&
+	      !IS_CHAN_CCK(chan) &&
+	      !IS_CHAN_HT20(chan) &&
+	      !IS_CHAN_HT40(chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			 "%s: invalid channel %u/0x%x; not marked as "
-			 "OFDM or CCK or HT20 or HT40PLUS or HT40MINUS\n",
-			 __func__, chan->channel, chan->channelFlags);
+			"%s: invalid channel %u/0x%x; not marked as "
+			"OFDM or CCK or HT20 or HT40PLUS or HT40MINUS\n",
+			__func__, chan->channel, chan->channelFlags);
 		return NULL;
 	}
 
@@ -1853,7 +1854,7 @@ getNoiseFloorThresh(struct ath_hal *ah,
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	switch (chan->channelFlags & CHANNEL_ALL) {
+	switch (chan->chanmode) {
 	case CHANNEL_A:
 	case CHANNEL_A_HT20:
 	case CHANNEL_A_HT40PLUS:
@@ -2413,7 +2414,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 					     aniState->firstepLevel + 1);
 		return;
 	} else {
-		mode = ath9k_hw_chan2wmode(ah, (struct hal_channel *) chan);
+		mode = ath9k_hw_chan2wmode(ah, chan);
 		if (mode == WIRELESS_MODE_11g || mode == WIRELESS_MODE_11b) {
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
@@ -2459,7 +2460,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 			ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 	} else {
-		mode = ath9k_hw_chan2wmode(ah, (struct hal_channel *) chan);
+		mode = ath9k_hw_chan2wmode(ah, chan);
 		if (mode == WIRELESS_MODE_11g || mode == WIRELESS_MODE_11b) {
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
@@ -2684,7 +2685,7 @@ static int32_t ath9k_hw_ani_get_listen_time(struct ath_hal *ah)
 
 void ath9k_hw_ani_monitor(struct ath_hal *ah,
 			  const struct hal_node_stats *stats,
-			  struct hal_channel *chan)
+			  struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
@@ -4654,8 +4655,7 @@ ath9k_hw_set_delta_slope(struct ath_hal *ah,
 }
 
 static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
-					struct hal_channel *chan,
-					struct ath9k_channel *ichan)
+					struct ath9k_channel *chan)
 {
 	int bb_spur = AR_NO_SPUR;
 	int freq;
@@ -4686,7 +4686,7 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
 	memset(&mask_m, 0, sizeof(int8_t) * 123);
 	memset(&mask_p, 0, sizeof(int8_t) * 123);
 
-	ath9k_hw_get_channel_centers(ah, ichan, &centers);
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq = centers.synth_center;
 
 	ah->ah_config.ath_hal_spurMode = SPUR_ENABLE_EEPROM;
@@ -4902,7 +4902,7 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
 }
 
 static void ath9k_hw_spur_mitigate(struct ath_hal *ah,
-				   struct hal_channel *chan)
+				   struct ath9k_channel *chan)
 {
 	int bb_spur = AR_NO_SPUR;
 	int bin, cur_bin;
@@ -5201,11 +5201,9 @@ static void ath9k_hw_set_addac(struct ath_hal *ah,
 
 static u_int ath9k_hw_mac_usec(struct ath_hal *ah, u_int clks)
 {
-	const struct hal_channel *c =
-		(const struct hal_channel *) ah->ah_curchan;
-
-	if (c != NULL)
-		return clks / CLOCK_RATE[ath9k_hw_chan2wmode(ah, c)];
+	if (ah->ah_curchan != NULL)
+		return clks /
+		CLOCK_RATE[ath9k_hw_chan2wmode(ah, ah->ah_curchan)];
 	else
 		return clks / CLOCK_RATE[WIRELESS_MODE_11b];
 }
@@ -5222,11 +5220,9 @@ static u_int ath9k_hw_mac_to_usec(struct ath_hal *ah, u_int clks)
 
 static u_int ath9k_hw_mac_clks(struct ath_hal *ah, u_int usecs)
 {
-	const struct hal_channel *c =
-		(const struct hal_channel *) ah->ah_curchan;
-
-	if (c != NULL)
-		return usecs * CLOCK_RATE[ath9k_hw_chan2wmode(ah, c)];
+	if (ah->ah_curchan != NULL)
+		return usecs * CLOCK_RATE[ath9k_hw_chan2wmode(ah,
+			ah->ah_curchan)];
 	else
 		return usecs * CLOCK_RATE[WIRELESS_MODE_11b];
 }
@@ -5328,8 +5324,7 @@ static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
 
 static inline enum hal_status
 ath9k_hw_process_ini(struct ath_hal *ah,
-		     struct hal_channel *chan,
-		     struct ath9k_channel *ichan,
+		     struct ath9k_channel *chan,
 		     enum hal_ht_macmode macmode)
 {
 	int i, regWrites = 0;
@@ -5337,7 +5332,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 	u_int modesIndex, freqIndex;
 	enum hal_status status;
 
-	switch (chan->channelFlags & CHANNEL_ALL) {
+	switch (chan->chanmode) {
 	case CHANNEL_A:
 	case CHANNEL_A_HT20:
 		modesIndex = 1;
@@ -5348,7 +5343,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 		modesIndex = 2;
 		freqIndex = 1;
 		break;
-	case CHANNEL_PUREG:
+	case CHANNEL_G:
 	case CHANNEL_G_HT20:
 	case CHANNEL_B:
 		modesIndex = 4;
@@ -5368,7 +5363,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
 
-	ath9k_hw_set_addac(ah, ichan);
+	ath9k_hw_set_addac(ah, chan);
 
 	if (AR_SREV_5416_V22_OR_LATER(ah)) {
 		REG_WRITE_ARRAY(&ahp->ah_iniAddac, 1, regWrites);
@@ -5436,11 +5431,11 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 	ath9k_hw_set_regs(ah, chan, macmode);
 	ath9k_hw_init_chain_masks(ah);
 
-	status = ath9k_hw_set_txpower(ah, &ahp->ah_eeprom, ichan,
+	status = ath9k_hw_set_txpower(ah, &ahp->ah_eeprom, chan,
 				      ath9k_regd_get_ctl(ah, chan),
 				      ath9k_regd_get_antenna_allowed(ah,
 								     chan),
-				      ichan->maxRegTxPower * 2,
+				      chan->maxRegTxPower * 2,
 				      min((u_int32_t) MAX_RATE_POWER,
 					  (u_int32_t) ah->ah_powerLimit));
 	if (status != HAL_OK) {
@@ -5449,7 +5444,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 		return HAL_EIO;
 	}
 
-	if (!ath9k_hw_set_rf_regs(ah, ichan, freqIndex)) {
+	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 			 "%s: ar5416SetRfRegs failed\n", __func__);
 		return HAL_EIO;
@@ -5606,8 +5601,7 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 
 static inline bool
 ath9k_hw_channel_change(struct ath_hal *ah,
-			struct hal_channel *chan,
-			struct ath9k_channel *ichan,
+			struct ath9k_channel *chan,
 			enum hal_ht_macmode macmode)
 {
 	u_int32_t synthDelay, qnum;
@@ -5633,23 +5627,23 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 	ath9k_hw_set_regs(ah, chan, macmode);
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		if (!(ath9k_hw_ar9280_set_channel(ah, ichan))) {
+		if (!(ath9k_hw_ar9280_set_channel(ah, chan))) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 				 "%s: failed to set channel\n", __func__);
 			return false;
 		}
 	} else {
-		if (!(ath9k_hw_set_channel(ah, ichan))) {
+		if (!(ath9k_hw_set_channel(ah, chan))) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 				 "%s: failed to set channel\n", __func__);
 			return false;
 		}
 	}
 
-	if (ath9k_hw_set_txpower(ah, &ahp->ah_eeprom, ichan,
+	if (ath9k_hw_set_txpower(ah, &ahp->ah_eeprom, chan,
 				 ath9k_regd_get_ctl(ah, chan),
 				 ath9k_regd_get_antenna_allowed(ah, chan),
-				 ichan->maxRegTxPower * 2,
+				 chan->maxRegTxPower * 2,
 				 min((u_int32_t) MAX_RATE_POWER,
 				     (u_int32_t) ah->ah_powerLimit))
 	    != HAL_OK) {
@@ -5669,21 +5663,21 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
-		ath9k_hw_set_delta_slope(ah, ichan);
+		ath9k_hw_set_delta_slope(ah, chan);
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_9280_spur_mitigate(ah, chan, ichan);
+		ath9k_hw_9280_spur_mitigate(ah, chan);
 	else
 		ath9k_hw_spur_mitigate(ah, chan);
 
-	if (!ichan->oneTimeCalsDone)
-		ichan->oneTimeCalsDone = true;
+	if (!chan->oneTimeCalsDone)
+		chan->oneTimeCalsDone = true;
 
 	return true;
 }
 
 static bool ath9k_hw_chip_reset(struct ath_hal *ah,
-				struct hal_channel *chan)
+				struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -5761,7 +5755,7 @@ void ath9k_hw_stoppcurecv(struct ath_hal *ah)
 }
 
 static bool ath9k_hw_iscal_supported(struct ath_hal *ah,
-				     struct hal_channel *chan,
+				     struct ath9k_channel *chan,
 				     enum hal_cal_types calType)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -5784,7 +5778,7 @@ static bool ath9k_hw_iscal_supported(struct ath_hal *ah,
 }
 
 static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
-				     struct hal_channel *chan)
+				     struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *ichan =
@@ -5846,7 +5840,7 @@ static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
 
 
 bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
-		    struct hal_channel *chan,
+		    struct ath9k_channel *chan,
 		    enum hal_ht_macmode macmode,
 		    u_int8_t txchainmask, u_int8_t rxchainmask,
 		    enum hal_ht_extprotspacing extprotspacing,
@@ -5856,7 +5850,6 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 #define FAIL(_code)     do { ecode = _code; goto bad; } while (0)
 	u_int32_t saveLedState;
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ath9k_channel *ichan;
 	struct ath9k_channel *curchan = ah->ah_curchan;
 	u_int32_t saveDefAntenna;
 	u_int32_t macStaId1;
@@ -5872,8 +5865,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 		ahp->ah_rxchainmask &= 0x3;
 	}
 
-	ichan = ath9k_hw_check_chan(ah, chan);
-	if (ichan == NULL) {
+	if (ath9k_hw_check_chan(ah, chan) == NULL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
@@ -5896,14 +5888,9 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 				   !IS_CHAN_A_5MHZ_SPACED(ah->
 							  ah_curchan)))) {
 
-		if (ath9k_hw_channel_change(ah, chan, ichan, macmode)) {
-			chan->channelFlags = ichan->channelFlags;
-			chan->privFlags = ichan->privFlags;
-
+		if (ath9k_hw_channel_change(ah, chan, macmode)) {
 			ath9k_hw_loadnf(ah, ah->ah_curchan);
-
 			ath9k_hw_start_nfcal(ah);
-
 			return true;
 		}
 	}
@@ -5939,19 +5926,19 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 		ath9k_hw_cfg_output(ah, 9, HAL_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	}
 
-	ecode = ath9k_hw_process_ini(ah, chan, ichan, macmode);
+	ecode = ath9k_hw_process_ini(ah, chan, macmode);
 	if (ecode != HAL_OK)
 		goto bad;
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
-		ath9k_hw_set_delta_slope(ah, ichan);
+		ath9k_hw_set_delta_slope(ah, chan);
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_9280_spur_mitigate(ah, chan, ichan);
+		ath9k_hw_9280_spur_mitigate(ah, chan);
 	else
 		ath9k_hw_spur_mitigate(ah, chan);
 
-	if (!ath9k_hw_eeprom_set_board_values(ah, ichan)) {
+	if (!ath9k_hw_eeprom_set_board_values(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: error setting board options\n", __func__);
 		FAIL(HAL_EIO);
@@ -5982,10 +5969,10 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		if (!(ath9k_hw_ar9280_set_channel(ah, ichan)))
+		if (!(ath9k_hw_ar9280_set_channel(ah, chan)))
 			FAIL(HAL_EIO);
 	} else {
-		if (!(ath9k_hw_set_channel(ah, ichan)))
+		if (!(ath9k_hw_set_channel(ah, chan)))
 			FAIL(HAL_EIO);
 	}
 
@@ -6049,8 +6036,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 		REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
 #endif
 	}
-	chan->channelFlags = ichan->channelFlags;
-	chan->privFlags = ichan->privFlags;
+
 	return true;
 bad:
 	if (status)
@@ -6073,7 +6059,7 @@ bool ath9k_hw_disable(struct ath_hal *ah)
 }
 
 bool
-ath9k_hw_calibrate(struct ath_hal *ah, struct hal_channel *chan,
+ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
 		   u_int8_t rxchainmask, bool longcal,
 		   bool *isCalDone)
 {
@@ -6395,12 +6381,11 @@ ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ath9k_channel *ichan = ah->ah_curchan;
-	struct hal_channel *chan = (struct hal_channel *) ichan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 
 	ah->ah_powerLimit = min(limit, (u_int32_t) MAX_RATE_POWER);
 
-	if (ath9k_hw_set_txpower(ah, &ahp->ah_eeprom, ichan,
+	if (ath9k_hw_set_txpower(ah, &ahp->ah_eeprom, chan,
 				 ath9k_regd_get_ctl(ah, chan),
 				 ath9k_regd_get_antenna_allowed(ah,
 								chan),
@@ -6427,7 +6412,8 @@ ath9k_hw_get_channel_centers(struct ath_hal *ah,
 		return;
 	}
 
-	if (chan->channelFlags & CHANNEL_HT40PLUS) {
+	if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
+	    (chan->chanmode == CHANNEL_G_HT40PLUS)) {
 		centers->synth_center =
 			chan->channel + HT40_CHANNEL_CENTER_SHIFT;
 		extoff = 1;
@@ -6451,7 +6437,7 @@ ath9k_hw_get_channel_centers(struct ath_hal *ah,
 }
 
 void
-ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
+ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 			bool *isCalDone)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -6612,7 +6598,7 @@ void ath9k_hw_setantenna(struct ath_hal *ah, u_int antenna)
 bool
 ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			  enum hal_ant_setting settings,
-			  struct hal_channel *chan,
+			  struct ath9k_channel *chan,
 			  u_int8_t *tx_chainmask,
 			  u_int8_t *rx_chainmask,
 			  u_int8_t *antenna_cfgd)
@@ -8445,7 +8431,7 @@ u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags)
 }
 
 int16_t
-ath9k_hw_getchan_noise(struct ath_hal *ah, struct hal_channel *chan)
+ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	struct ath9k_channel *ichan;
 
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 1a77ed3..1b6429f 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -350,7 +350,7 @@ struct ar5416_desc {
 #define CCK_OFDM_GAIN_DELTA         15
 
 struct ar5416AniState {
-	struct hal_channel c;
+	struct ath9k_channel c;
 	u_int8_t noiseImmunityLevel;
 	u_int8_t spurImmunityLevel;
 	u_int8_t firstepLevel;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index b899611..08b800f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -41,17 +41,17 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ 0 }
 };
 
-static int ath_get_chanflags(struct ath_softc *sc,
-			     struct ieee80211_channel *chan)
+static int ath_get_channel(struct ath_softc *sc,
+			   struct ieee80211_channel *chan)
 {
 	int i;
 
 	for (i = 0; i < sc->sc_ah->ah_nchan; i++) {
 		if (sc->sc_ah->ah_channels[i].channel == chan->center_freq)
-			return sc->sc_ah->ah_channels[i].channelFlags;
+			return i;
 	}
 
-	return 0;
+	return -1;
 }
 
 static u_int32_t ath_get_extchanmode(struct ath_softc *sc,
@@ -334,21 +334,24 @@ static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct hal_channel hchan;
-	int error = 0;
+	int error = 0, pos;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Starting driver with "
 		"initial channel: %d MHz\n", __func__, curchan->center_freq);
 
 	/* setup initial channel */
 
-	hchan.channel = curchan->center_freq;
-	hchan.channelFlags = ath_get_chanflags(sc, curchan);
-	hchan.chanmode = (curchan->band == IEEE80211_BAND_2GHZ) ?
-		CHANNEL_G : CHANNEL_A;
+	pos = ath_get_channel(sc, curchan);
+	if (pos == -1) {
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
+		return -EINVAL;
+	}
+
+	sc->sc_ah->ah_channels[pos].chanmode =
+		(curchan->band == IEEE80211_BAND_2GHZ) ? CHANNEL_G : CHANNEL_A;
 
 	/* open ath_dev */
-	error = ath_open(sc, &hchan);
+	error = ath_open(sc, &sc->sc_ah->ah_channels[pos]);
 	if (error) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to complete ath_open\n", __func__);
@@ -490,20 +493,24 @@ static int ath9k_config(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct hal_channel hchan;
+	int pos;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
 		__func__,
 		curchan->center_freq);
 
-	hchan.channel = curchan->center_freq;
-	hchan.channelFlags = ath_get_chanflags(sc, curchan);
-	hchan.chanmode = (curchan->band == IEEE80211_BAND_2GHZ) ?
-		CHANNEL_G : CHANNEL_A;
+	pos = ath_get_channel(sc, curchan);
+	if (pos == -1) {
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
+		return -EINVAL;
+	}
+
+	sc->sc_ah->ah_channels[pos].chanmode =
+		(curchan->band == IEEE80211_BAND_2GHZ) ? CHANNEL_G : CHANNEL_A;
 	sc->sc_config.txpowlimit = 2 * conf->power_level;
 
 	/* set h/w channel */
-	if (ath_set_channel(sc, &hchan) < 0)
+	if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
 		DPRINTF(sc, ATH_DBG_FATAL, "%s: Unable to set channel\n",
 			__func__);
 
@@ -792,8 +799,8 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct hal_channel hchan;
 	struct ath_vap *avp;
+	int pos;
 	DECLARE_MAC_BUF(mac);
 
 	if (bss_conf->assoc) {
@@ -837,16 +844,23 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			__func__,
 			curchan->center_freq);
 
-		hchan.channel = curchan->center_freq;
-		hchan.channelFlags = ath_get_chanflags(sc, curchan);
+		pos = ath_get_channel(sc, curchan);
+		if (pos == -1) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: Invalid channel\n", __func__);
+			return;
+		}
+
 		if (hw->conf.ht_conf.ht_supported)
-			hchan.chanmode = ath_get_extchanmode(sc, curchan);
+			sc->sc_ah->ah_channels[pos].chanmode =
+				ath_get_extchanmode(sc, curchan);
 		else
-			hchan.chanmode = (curchan->band == IEEE80211_BAND_2GHZ)
-				? CHANNEL_G : CHANNEL_A;
+			sc->sc_ah->ah_channels[pos].chanmode =
+				(curchan->band == IEEE80211_BAND_2GHZ) ?
+				CHANNEL_G : CHANNEL_A;
 
 		/* set h/w channel */
-		if (ath_set_channel(sc, &hchan) < 0)
+		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to set channel\n",
 				__func__);
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 28953a8..09d436f 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -382,7 +382,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 }
 
 void
-ath9k_hw_decrease_chain_power(struct ath_hal *ah, struct hal_channel *chan)
+ath9k_hw_decrease_chain_power(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	int i, regWrites = 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 77dffcd..6505e8f 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -28,7 +28,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
 				   struct ath9k_channel *chan,
 				   u_int16_t modesIndex);
 void ath9k_hw_decrease_chain_power(struct ath_hal *ah,
-				   struct hal_channel *chan);
+				   struct ath9k_channel *chan);
 bool ath9k_hw_init_rf(struct ath_hal *ah,
 			       enum hal_status *status);
 
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 588dd3d..d380460 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -916,7 +916,7 @@ done:
 
 struct ath9k_channel*
 ath9k_regd_check_channel(struct ath_hal *ah,
-			 const struct hal_channel *c)
+			 const struct ath9k_channel *c)
 {
 	struct ath9k_channel *base, *cc;
 
@@ -969,7 +969,7 @@ ath9k_regd_check_channel(struct ath_hal *ah,
 
 u_int
 ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
-			       struct hal_channel *chan)
+			       struct ath9k_channel *chan)
 {
 	struct ath9k_channel *ichan = NULL;
 
@@ -980,7 +980,7 @@ ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 	return ichan->antennaMax;
 }
 
-u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct hal_channel *chan)
+u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	u_int ctl = NO_CTL;
 	struct ath9k_channel *ichan;
@@ -1003,7 +1003,7 @@ u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct hal_channel *chan)
 			else if (IS_CHAN_G(ichan))
 				ctl = ichan->conformanceTestLimit[2];
 
-			if (IS_CHAN_PUREG(chan) && (ctl & 0xf) == CTL_11B)
+			if (IS_CHAN_G(chan) && (ctl & 0xf) == CTL_11B)
 				ctl = (ctl & ~0xf) | CTL_11G;
 		}
 	}
-- 
1.5.6.rc2.15.g457bb.dirty

