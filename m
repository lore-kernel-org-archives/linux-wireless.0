Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25757 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYHBXtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/12] ath9k: Channel cleanup
Date: Sat, 2 Aug 2008 16:48:55 -0700
Message-ID: <1217720944-23234-4-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014917_128701_661CDE5F)
In-Reply-To: <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Rename hal_channel_internal as ath9k_channel and remove
a few unused variables.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   18 +++-------
 drivers/net/wireless/ath9k/hw.c    |   70 ++++++++++++++++++------------------
 drivers/net/wireless/ath9k/phy.c   |    6 ++--
 drivers/net/wireless/ath9k/phy.h   |    6 ++--
 drivers/net/wireless/ath9k/regd.c  |   24 ++++++------
 5 files changed, 58 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index c3294c0..de80a66 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -469,29 +469,21 @@ struct hal_channel {
 	 CHANNEL_HT40PLUS |			\
 	 CHANNEL_HT40MINUS)
 
-struct hal_channel_internal {
+struct ath9k_channel {
 	u_int16_t channel;
 	u_int32_t channelFlags;
 	u_int8_t privFlags;
 	int8_t maxRegTxPower;
 	int8_t maxTxPower;
 	int8_t minTxPower;
-	bool bssSendHere;
-	u_int8_t gainI;
-	bool iqCalValid;
 	int32_t CalValid;
 	bool oneTimeCalsDone;
 	int8_t iCoff;
 	int8_t qCoff;
 	int16_t rawNoiseFloor;
-	int16_t noiseFloorAdjust;
 	int8_t antennaMax;
 	u_int32_t regDmnFlags;
 	u_int32_t conformanceTestLimit;
-	u_int64_t ah_tsf_last;
-	u_int64_t ah_channel_time;
-	u_int16_t mainSpur;
-	u_int64_t dfsTsf;
 #ifdef ATH_NF_PER_CHAN
 	struct hal_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
@@ -902,9 +894,9 @@ struct ath_hal {
 	char ah_iso[4];
 	enum start_adhoc_option ah_adHocMode;
 	bool ah_commonMode;
-	struct hal_channel_internal ah_channels[150];
+	struct ath9k_channel ah_channels[150];
 	u_int ah_nchan;
-	struct hal_channel_internal *ah_curchan;
+	struct ath9k_channel *ah_curchan;
 	u_int16_t ah_rfsilent;
 	bool ah_rfkillEnabled;
 	bool ah_isPciExpress;
@@ -1077,7 +1069,7 @@ bool ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 			      struct hal_txq_info *qInfo);
 bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
 			      const struct hal_txq_info *qInfo);
-struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
+struct ath9k_channel *ath9k_regd_check_channel(struct ath_hal *ah,
 					      const struct hal_channel *c);
 void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
 			    u_int pktLen, enum hal_pkt_type type,
@@ -1133,7 +1125,7 @@ const char *ath9k_hw_probe(u_int16_t vendorid, u_int16_t devid);
 bool ath9k_hw_disable(struct ath_hal *ah);
 void ath9k_hw_rfdetach(struct ath_hal *ah);
 void ath9k_hw_get_channel_centers(struct ath_hal *ah,
-				  struct hal_channel_internal *chan,
+				  struct ath9k_channel *chan,
 				  struct chan_centers *centers);
 bool ath9k_get_channel_edges(struct ath_hal *ah,
 			     u_int16_t flags, u_int16_t *low,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index a16dbfb..35b9445 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -483,7 +483,7 @@ static u_int8_t ath9k_hw_get_num_ant_config(struct ath_hal_5416 *ahp,
 
 static enum hal_status
 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal_5416 *ahp,
-				struct hal_channel_internal *chan,
+				struct ath9k_channel *chan,
 				u_int8_t index,
 				u_int16_t *config)
 {
@@ -556,7 +556,7 @@ static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 /* XXX: Clean me up, make me more legible */
 static bool
 ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
-				 struct hal_channel_internal *chan)
+				 struct ath9k_channel *chan)
 {
 	struct modal_eep_header *pModal;
 	int i, regChainOffset;
@@ -1662,7 +1662,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
 	}
 }
 
-static inline struct hal_channel_internal *ath9k_hw_check_chan(
+static inline struct ath9k_channel *ath9k_hw_check_chan(
 			struct ath_hal *ah, struct hal_channel *chan)
 {
 	if ((IS(chan, CHANNEL_2GHZ) ^ IS(chan, CHANNEL_5GHZ)) == 0) {
@@ -1848,7 +1848,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 
 static bool
 getNoiseFloorThresh(struct ath_hal *ah,
-		    const struct hal_channel_internal *chan,
+		    const struct ath9k_channel *chan,
 		    int16_t *nft)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -1886,7 +1886,7 @@ static void ath9k_hw_start_nfcal(struct ath_hal *ah)
 }
 
 static void
-ath9k_hw_loadnf(struct ath_hal *ah, struct hal_channel_internal *chan)
+ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	struct hal_nfcal_hist *h;
 	int i, j;
@@ -1945,7 +1945,7 @@ ath9k_hw_loadnf(struct ath_hal *ah, struct hal_channel_internal *chan)
 }
 
 static int16_t ath9k_hw_getnf(struct ath_hal *ah,
-			      struct hal_channel_internal *chan)
+			      struct ath9k_channel *chan)
 {
 	int16_t nf, nfThresh;
 	int16_t nfarray[NUM_NF_READINGS] = { 0 };
@@ -2032,7 +2032,7 @@ static void ath9k_hw_disable_mib_counters(struct ath_hal *ah)
 }
 
 static int ath9k_hw_get_ani_channel_idx(struct ath_hal *ah,
-					struct hal_channel_internal *chan)
+					struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
@@ -2355,7 +2355,7 @@ static void ath9k_ani_restart(struct ath_hal *ah)
 static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 	struct ar5416AniState *aniState;
 	enum wireless_mode mode;
 	int32_t rssi;
@@ -2431,7 +2431,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 	struct ar5416AniState *aniState;
 	enum wireless_mode mode;
 	int32_t rssi;
@@ -2473,7 +2473,7 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
-	struct hal_channel_internal *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 	int index;
 
 	if (!DO_ANI(ah))
@@ -3581,7 +3581,7 @@ static inline bool ath9k_hw_fill_vpd_table(u_int8_t pwrMin,
 
 static inline void
 ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
-				    struct hal_channel_internal *chan,
+				    struct ath9k_channel *chan,
 				    struct cal_data_per_freq *pRawDataSet,
 				    u_int8_t *bChans,
 				    u_int16_t availPiers,
@@ -3764,7 +3764,7 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 static inline bool
 ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 			     struct ar5416_eeprom *pEepData,
-			     struct hal_channel_internal *chan,
+			     struct ath9k_channel *chan,
 			     int16_t *pTxPowerIndexOffset)
 {
 	struct cal_data_per_freq *pRawDataset;
@@ -3966,7 +3966,7 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 
 static inline void
 ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
-				  struct hal_channel_internal *chan,
+				  struct ath9k_channel *chan,
 				  struct cal_target_power_leg *powInfo,
 				  u_int16_t numChannels,
 				  struct cal_target_power_leg *pNewPower,
@@ -4032,7 +4032,7 @@ ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
 
 static inline void
 ath9k_hw_get_target_powers(struct ath_hal *ah,
-			   struct hal_channel_internal *chan,
+			   struct ath9k_channel *chan,
 			   struct cal_target_power_ht *powInfo,
 			   u_int16_t numChannels,
 			   struct cal_target_power_ht *pNewPower,
@@ -4130,7 +4130,7 @@ ath9k_hw_get_max_edge_power(u_int16_t freq,
 static inline bool
 ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				  struct ar5416_eeprom *pEepData,
-				  struct hal_channel_internal *chan,
+				  struct ath9k_channel *chan,
 				  int16_t *ratesArray,
 				  u_int16_t cfgCtl,
 				  u_int8_t AntennaReduction,
@@ -4458,7 +4458,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 static enum hal_status
 ath9k_hw_set_txpower(struct ath_hal *ah,
 		     struct ar5416_eeprom *pEepData,
-		     struct hal_channel_internal *chan,
+		     struct ath9k_channel *chan,
 		     u_int16_t cfgCtl,
 		     u_int8_t twiceAntennaReduction,
 		     u_int8_t twiceMaxRegulatoryPower,
@@ -4621,7 +4621,7 @@ static inline void ath9k_hw_get_delta_slope_vals(struct ath_hal *ah,
 
 static void
 ath9k_hw_set_delta_slope(struct ath_hal *ah,
-			 struct hal_channel_internal *chan)
+			 struct ath9k_channel *chan)
 {
 	u_int32_t coef_scaled, ds_coef_exp, ds_coef_man;
 	u_int32_t clockMhzScaled = 0x64000000;
@@ -4656,7 +4656,7 @@ ath9k_hw_set_delta_slope(struct ath_hal *ah,
 
 static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
 					struct hal_channel *chan,
-					struct hal_channel_internal *ichan)
+					struct ath9k_channel *ichan)
 {
 	int bb_spur = AR_NO_SPUR;
 	int freq;
@@ -5141,7 +5141,7 @@ static inline void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 }
 
 static void ath9k_hw_set_addac(struct ath_hal *ah,
-			       struct hal_channel_internal *chan)
+			       struct ath9k_channel *chan)
 {
 	struct modal_eep_header *pModal;
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -5213,7 +5213,7 @@ static u_int ath9k_hw_mac_usec(struct ath_hal *ah, u_int clks)
 
 static u_int ath9k_hw_mac_to_usec(struct ath_hal *ah, u_int clks)
 {
-	struct hal_channel_internal *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 
 	if (chan && IS_CHAN_HT40(chan))
 		return ath9k_hw_mac_usec(ah, clks) / 2;
@@ -5234,7 +5234,7 @@ static u_int ath9k_hw_mac_clks(struct ath_hal *ah, u_int usecs)
 
 static u_int ath9k_hw_mac_to_clks(struct ath_hal *ah, u_int usecs)
 {
-	struct hal_channel_internal *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 
 	if (chan && IS_CHAN_HT40(chan))
 		return ath9k_hw_mac_clks(ah, usecs) * 2;
@@ -5330,7 +5330,7 @@ static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
 static inline enum hal_status
 ath9k_hw_process_ini(struct ath_hal *ah,
 		     struct hal_channel *chan,
-		     struct hal_channel_internal *ichan,
+		     struct ath9k_channel *ichan,
 		     enum hal_ht_macmode macmode)
 {
 	int i, regWrites = 0;
@@ -5517,7 +5517,7 @@ static inline void ath9k_hw_reset_calibration(struct ath_hal *ah,
 
 static inline void
 ath9k_hw_per_calibration(struct ath_hal *ah,
-			 struct hal_channel_internal *ichan,
+			 struct ath9k_channel *ichan,
 			 u_int8_t rxchainmask,
 			 struct hal_cal_list *currCal,
 			 bool *isCalDone)
@@ -5563,7 +5563,7 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 					  int init_cal_count)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal ichan;
+	struct ath9k_channel ichan;
 	bool isCalDone;
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
 	const struct hal_percal_data *calData = currCal->calData;
@@ -5608,7 +5608,7 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 static inline bool
 ath9k_hw_channel_change(struct ath_hal *ah,
 			struct hal_channel *chan,
-			struct hal_channel_internal *ichan,
+			struct ath9k_channel *ichan,
 			enum hal_ht_macmode macmode)
 {
 	u_int32_t synthDelay, qnum;
@@ -5788,7 +5788,7 @@ static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
 				     struct hal_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal *ichan =
+	struct ath9k_channel *ichan =
 		ath9k_regd_check_channel(ah, chan);
 
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
@@ -5857,8 +5857,8 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 #define FAIL(_code)     do { ecode = _code; goto bad; } while (0)
 	u_int32_t saveLedState;
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal *ichan;
-	struct hal_channel_internal *curchan = ah->ah_curchan;
+	struct ath9k_channel *ichan;
+	struct ath9k_channel *curchan = ah->ah_curchan;
 	u_int32_t saveDefAntenna;
 	u_int32_t macStaId1;
 	enum hal_status ecode;
@@ -6080,7 +6080,7 @@ ath9k_hw_calibrate(struct ath_hal *ah, struct hal_channel *chan,
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
-	struct hal_channel_internal *ichan =
+	struct ath9k_channel *ichan =
 		ath9k_regd_check_channel(ah, chan);
 
 	*isCalDone = true;
@@ -6396,7 +6396,7 @@ ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal *ichan = ah->ah_curchan;
+	struct ath9k_channel *ichan = ah->ah_curchan;
 	struct hal_channel *chan = (struct hal_channel *) ichan;
 
 	ah->ah_powerLimit = min(limit, (u_int32_t) MAX_RATE_POWER);
@@ -6416,7 +6416,7 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
 
 void
 ath9k_hw_get_channel_centers(struct ath_hal *ah,
-			     struct hal_channel_internal *chan,
+			     struct ath9k_channel *chan,
 			     struct chan_centers *centers)
 {
 	int8_t extoff;
@@ -6456,7 +6456,7 @@ ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
 			bool *isCalDone)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal *ichan =
+	struct ath9k_channel *ichan =
 		ath9k_regd_check_channel(ah, chan);
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
 
@@ -6754,7 +6754,7 @@ enum hal_status
 ath9k_hw_select_antconfig(struct ath_hal *ah, u_int32_t cfg)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_channel_internal *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 	const struct hal_capabilities *pCap = &ah->ah_caps;
 	u_int16_t ant_config;
 	u_int32_t halNumAntConfig;
@@ -7648,7 +7648,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
-	struct hal_channel_internal *chan = ah->ah_curchan;
+	struct ath9k_channel *chan = ah->ah_curchan;
 	struct hal_tx_queue_info *qi;
 	u_int32_t cwMin, chanCwMin, value;
 
@@ -8448,7 +8448,7 @@ u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags)
 int16_t
 ath9k_hw_getchan_noise(struct ath_hal *ah, struct hal_channel *chan)
 {
-	struct hal_channel_internal *ichan;
+	struct ath9k_channel *ichan;
 
 	ichan = ath9k_regd_check_channel(ah, chan);
 	if (ichan == NULL) {
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 6751bed..0e70f47 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -29,7 +29,7 @@ ath9k_hw_write_regs(struct ath_hal *ah, u_int modesIndex, u_int freqIndex,
 }
 
 bool
-ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
+ath9k_hw_set_channel(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	u_int32_t channelSel = 0;
 	u_int32_t bModeSynth = 0;
@@ -105,7 +105,7 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
 
 bool
 ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
-			    struct hal_channel_internal *chan)
+			    struct ath9k_channel *chan)
 {
 	u_int16_t bMode, fracMode, aModeRefSel = 0;
 	u_int32_t freq, ndiv, channelSel = 0, channelFrac = 0, reg32 = 0;
@@ -202,7 +202,7 @@ ath9k_phy_modify_rx_buffer(u_int32_t *rfBuf, u_int32_t reg32,
 }
 
 bool
-ath9k_hw_set_rf_regs(struct ath_hal *ah, struct hal_channel_internal *chan,
+ath9k_hw_set_rf_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 		     u_int16_t modesIndex)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 6c05257..77dffcd 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -18,14 +18,14 @@
 #define PHY_H
 
 bool ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
-					  struct hal_channel_internal
+					  struct ath9k_channel
 					  *chan);
 bool ath9k_hw_set_channel(struct ath_hal *ah,
-				   struct hal_channel_internal *chan);
+				   struct ath9k_channel *chan);
 void ath9k_hw_write_regs(struct ath_hal *ah, u_int modesIndex,
 			 u_int freqIndex, int regWrites);
 bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
-				   struct hal_channel_internal *chan,
+				   struct ath9k_channel *chan,
 				   u_int16_t modesIndex);
 void ath9k_hw_decrease_chain_power(struct ath_hal *ah,
 				   struct hal_channel *chan);
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 8a99365..425450d 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -22,8 +22,8 @@
 
 static int ath9k_regd_chansort(const void *a, const void *b)
 {
-	const struct hal_channel_internal *ca = a;
-	const struct hal_channel_internal *cb = b;
+	const struct ath9k_channel *ca = a;
+	const struct ath9k_channel *cb = b;
 
 	return (ca->channel == cb->channel) ?
 	    (ca->channelFlags & CHAN_FLAGS) -
@@ -372,7 +372,7 @@ ath9k_regd_get_eeprom_reg_ext_bits(struct ath_hal *ah,
 
 #ifdef ATH_NF_PER_CHAN
 
-static void ath9k_regd_init_rf_buffer(struct hal_channel_internal *ichans,
+static void ath9k_regd_init_rf_buffer(struct ath9k_channel *ichans,
 				      int nchans)
 {
 	int i, j, next;
@@ -405,10 +405,10 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		       struct RegDmnFreqBand *fband,
 		       struct regDomain *rd,
 		       const struct cmode *cm,
-		       struct hal_channel_internal *ichans,
+		       struct ath9k_channel *ichans,
 		       bool enableExtendedChannels)
 {
-	struct hal_channel_internal icv;
+	struct ath9k_channel icv;
 
 	if (!(c_lo <= c && c <= c_hi)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
@@ -539,7 +539,7 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 	}
 
 	memcpy(&ichans[pos], &icv,
-	       sizeof(struct hal_channel_internal));
+	       sizeof(struct ath9k_channel));
 
 	return true;
 }
@@ -586,7 +586,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	struct country_code_to_enum_rd *country = NULL;
 	struct regDomain rd5GHz, rd2GHz;
 	const struct cmode *cm;
-	struct hal_channel_internal *ichans = &ah->ah_channels[0];
+	struct ath9k_channel *ichans = &ah->ah_channels[0];
 	int next = 0, b;
 	u_int8_t ctl;
 	int regdmn;
@@ -843,7 +843,7 @@ done:
 		ath9k_regd_init_rf_buffer(ichans, next);
 #endif
 		ath9k_regd_sort(ichans, next,
-				sizeof(struct hal_channel_internal),
+				sizeof(struct ath9k_channel),
 				ath9k_regd_chansort);
 		ah->ah_nchan = next;
 
@@ -883,11 +883,11 @@ done:
 	return next != 0;
 }
 
-struct hal_channel_internal*
+struct ath9k_channel*
 ath9k_regd_check_channel(struct ath_hal *ah,
 			 const struct hal_channel *c)
 {
-	struct hal_channel_internal *base, *cc;
+	struct ath9k_channel *base, *cc;
 
 	int flags = c->channelFlags & CHAN_FLAGS;
 	int n, lim;
@@ -940,7 +940,7 @@ u_int
 ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 			       struct hal_channel *chan)
 {
-	struct hal_channel_internal *ichan = NULL;
+	struct ath9k_channel *ichan = NULL;
 
 	ichan = ath9k_regd_check_channel(ah, chan);
 	if (!ichan)
@@ -952,7 +952,7 @@ ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct hal_channel *chan)
 {
 	u_int ctl = NO_CTL;
-	struct hal_channel_internal *ichan;
+	struct ath9k_channel *ichan;
 
 	if (ah->ah_countryCode == CTRY_DEFAULT && isWwrSKU(ah)) {
 		if (IS_CHAN_B(chan))
-- 
1.5.6.rc2.15.g457bb.dirty

