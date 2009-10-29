Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZJ2Bgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 21:36:37 -0400
Date: Wed, 28 Oct 2009 21:36:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni.Malinen@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC] ath9k: update hw configuration for virtual wiphys
Message-ID: <20091029013642.GA11452@bombadil.infradead.org>
References: <1256762627-1574-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1256762627-1574-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2009 at 04:43:47PM -0400, Luis R. Rodriguez wrote:
> ath9k supports its own virtual wiphys. The hardware code
> relies on the ieee80211_hw for the present interface but
> with recent changes introduced the common->hw was never
> updated and is required for virtual wiphys.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> Jouni, it seems this the right place for this, do you agree?
> 
>  drivers/net/wireless/ath/ath9k/virtual.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

Here is a bigger alternative to that 5-line patch. What it
illustrates is that the the current virtual wiphy needs to be kept
record of for asynchronous events one way or another. I list
the events below.

  Luis

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: update hw configuration for virtual wiphys

ath9k supports its own virtual wiphys. The hardware code
relies on the ieee80211_hw for the present interface but
with recent changes introduced the common->hw was never
updated and is required for virtual wiphys. Instead of
relying on the common->hw pointer remove it and instead
require all hw code to pass the currently used ieee80211_hw
struct used.

Worth noting though is that at specific events we need
the hw code to access the hw configuration and during
those events the driver has currently no way of knowing
what the currently used virtual wiphy. For now we stick
to using the sc->hw for those events. These events are:

Interrupt:

  * ISR --> ATH9K_INT_MIB --> ath9k_hw_procmibevent()
  * tasklet --> ATH9K_INT_FATAL --> ath_reset()
  * beacon tasklet --> ath_reset()

Timer:

  * ath_ani_calibrate -->
		ath9k_hw_reset_calvalid()
		ath9k_hw_ani_monitor()

Xmit:

  * ath_tx_complete_poll_work --> needreset --> ath_reset() (Xmit hang check)
  * tasklet --> tx --> ath_tx_complete_aggr() --> needreset --> ath_reset()
  * tasklet --> ath_draintxq --> ath_tx_complete_aggr() --> needreset --> ath_reset()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h           |    1 -
 drivers/net/wireless/ath/ath5k/base.c    |    1 -
 drivers/net/wireless/ath/ath9k/ani.c     |   21 +++---
 drivers/net/wireless/ath/ath9k/ani.h     |    5 +-
 drivers/net/wireless/ath/ath9k/ath9k.h   |    8 ++-
 drivers/net/wireless/ath/ath9k/beacon.c  |    4 +-
 drivers/net/wireless/ath/ath9k/calib.c   |   20 +++---
 drivers/net/wireless/ath/ath9k/calib.h   |    3 +-
 drivers/net/wireless/ath/ath9k/hw.c      |  115 ++++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hw.h      |   11 ++-
 drivers/net/wireless/ath/ath9k/main.c    |   44 +++++++-----
 drivers/net/wireless/ath/ath9k/virtual.c |    6 +-
 drivers/net/wireless/ath/ath9k/xmit.c    |    6 +-
 13 files changed, 150 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 5e19a73..e97f5c9 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -62,7 +62,6 @@ struct ath_bus_ops {
 struct ath_common {
 	void *ah;
 	void *priv;
-	struct ieee80211_hw *hw;
 	int debug_mask;
 	enum ath_device_state state;
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 07c1e52..523b359 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -594,7 +594,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	common = ath5k_hw_common(sc->ah);
 	common->ops = &ath5k_common_ops;
 	common->ah = sc->ah;
-	common->hw = hw;
 	common->cachelsz = csz << 2; /* convert to bytes */
 
 	/* Initialize device */
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2a0cd64..dd87cbd 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -273,9 +273,10 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 	aniState->cckPhyErrCount = 0;
 }
 
-static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
+static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah,
+					  struct ieee80211_hw *hw)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+	struct ieee80211_conf *conf = &hw->conf;
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
@@ -345,9 +346,10 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 	}
 }
 
-static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
+static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah,
+					 struct ieee80211_hw *hw)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+	struct ieee80211_conf *conf = &hw->conf;
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
@@ -545,6 +547,7 @@ void ath9k_ani_reset(struct ath_hw *ah)
 }
 
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
+			  struct ieee80211_hw *hw,
 			  struct ath9k_channel *chan)
 {
 	struct ar5416AniState *aniState;
@@ -619,12 +622,12 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 	} else if (aniState->listenTime > ah->aniperiod) {
 		if (aniState->ofdmPhyErrCount > aniState->listenTime *
 		    aniState->ofdmTrigHigh / 1000) {
-			ath9k_hw_ani_ofdm_err_trigger(ah);
+			ath9k_hw_ani_ofdm_err_trigger(ah, hw);
 			ath9k_ani_restart(ah);
 		} else if (aniState->cckPhyErrCount >
 			   aniState->listenTime * aniState->cckTrigHigh /
 			   1000) {
-			ath9k_hw_ani_cck_err_trigger(ah);
+			ath9k_hw_ani_cck_err_trigger(ah, hw);
 			ath9k_ani_restart(ah);
 		}
 	}
@@ -708,7 +711,7 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
  * any of the MIB counters overflow/trigger so don't assume we're
  * here because a PHY error counter triggered.
  */
-void ath9k_hw_procmibevent(struct ath_hw *ah)
+void ath9k_hw_procmibevent(struct ath_hw *ah, struct ieee80211_hw *hw)
 {
 	u32 phyCnt1, phyCnt2;
 
@@ -750,9 +753,9 @@ void ath9k_hw_procmibevent(struct ath_hw *ah)
 		 * check will never be true.
 		 */
 		if (aniState->ofdmPhyErrCount > aniState->ofdmTrigHigh)
-			ath9k_hw_ani_ofdm_err_trigger(ah);
+			ath9k_hw_ani_ofdm_err_trigger(ah, hw);
 		if (aniState->cckPhyErrCount > aniState->cckTrigHigh)
-			ath9k_hw_ani_cck_err_trigger(ah);
+			ath9k_hw_ani_cck_err_trigger(ah, hw);
 		/* NB: always restart to insure the h/w counters are reset */
 		ath9k_ani_restart(ah);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 4e1ab94..ac0592e 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -17,6 +17,8 @@
 #ifndef ANI_H
 #define ANI_H
 
+#include "hw.h"
+
 #define HAL_PROCESS_ANI           0x00000001
 
 #define DO_ANI(ah) (((ah)->proc_phyerr & HAL_PROCESS_ANI))
@@ -110,12 +112,13 @@ struct ar5416Stats {
 
 void ath9k_ani_reset(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
+			  struct ieee80211_hw *hw,
 			  struct ath9k_channel *chan);
 void ath9k_enable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
 u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
 				  u32 *rxf_pcnt, u32 *txf_pcnt);
-void ath9k_hw_procmibevent(struct ath_hw *ah);
+void ath9k_hw_procmibevent(struct ath_hw *ah, struct ieee80211_hw *hw);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
 void ath9k_hw_ani_disable(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 13dd020..3b551a7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -341,7 +341,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush);
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_setup(struct ath_softc *sc, int haltype);
-void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
+void ath_drain_all_txq(struct ath_softc *sc,
+		       struct ieee80211_hw *hw,
+		       bool retry_tx);
 void ath_draintxq(struct ath_softc *sc,
 		     struct ath_txq *txq, bool retry_tx);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
@@ -654,8 +656,8 @@ void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan);
-void ath_radio_enable(struct ath_softc *sc);
-void ath_radio_disable(struct ath_softc *sc);
+void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw);
+void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
 
 #ifdef CONFIG_PCI
 int ath_pci_init(void);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b10c884..0797207 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -385,6 +385,7 @@ void ath_beacon_tasklet(unsigned long data)
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
 	struct ath_wiphy *aphy;
+	struct ieee80211_hw *hw;
 	int slot;
 	u32 bfaddr, bc = 0, tsftu;
 	u64 tsf;
@@ -442,6 +443,7 @@ void ath_beacon_tasklet(unsigned long data)
 	slot = ATH_BCBUF - slot - 1;
 	vif = sc->beacon.bslot[slot];
 	aphy = sc->beacon.bslot_aphy[slot];
+	hw = aphy->hw;
 
 	ath_print(common, ATH_DBG_BEACON,
 		  "slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
@@ -476,7 +478,7 @@ void ath_beacon_tasklet(unsigned long data)
 		sc->beacon.updateslot = COMMIT; /* commit next beacon */
 		sc->beacon.slotupdate = slot;
 	} else if (sc->beacon.updateslot == COMMIT && sc->beacon.slotupdate == slot) {
-		ath9k_hw_setslottime(sc->sc_ah, sc->beacon.slottime);
+		ath9k_hw_setslottime(sc->sc_ah, &hw->conf, sc->beacon.slottime);
 		sc->beacon.updateslot = OK;
 	}
 	if (bfaddr != 0) {
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 238a574..cb42861 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -279,10 +279,9 @@ static bool ath9k_hw_per_calibration(struct ath_hw *ah,
 
 /* Assumes you are talking about the currently configured channel */
 static bool ath9k_hw_iscal_supported(struct ath_hw *ah,
+				     struct ieee80211_conf *conf,
 				     enum ath9k_cal_types calType)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
 	switch (calType & ah->supp_cals) {
 	case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
 		return true;
@@ -560,10 +559,10 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 }
 
 /* This is done for the currently configured channel */
-bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
+bool ath9k_hw_reset_calvalid(struct ath_hw *ah, struct ieee80211_hw *hw)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
+	struct ieee80211_conf *conf = &hw->conf;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 
 	if (!ah->curchan)
@@ -582,7 +581,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 	}
 
-	if (!ath9k_hw_iscal_supported(ah, currCal->calData->calType))
+	if (!ath9k_hw_iscal_supported(ah, conf, currCal->calData->calType))
 		return true;
 
 	ath_print(common, ATH_DBG_CALIBRATE,
@@ -1121,8 +1120,11 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 	return true;
 }
 
-bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
+bool ath9k_hw_init_cal(struct ath_hw *ah,
+		       struct ieee80211_hw *hw,
+		       struct ath9k_channel *chan)
 {
+	struct ieee80211_conf *conf = &hw->conf;
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (AR_SREV_9271(ah) || AR_SREV_9285_12_OR_LATER(ah)) {
@@ -1174,19 +1176,19 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	/* Enable IQ, ADC Gain and ADC DC offset CALs */
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
-		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, conf, ADC_GAIN_CAL)) {
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "enabling ADC Gain Calibration.\n");
 		}
-		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, conf, ADC_DC_CAL)) {
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "enabling ADC DC Calibration.\n");
 		}
-		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, conf, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ah->iq_caldata);
 			INSERT_CAL(ah, &ah->iq_caldata);
 			ath_print(common, ATH_DBG_CALIBRATE,
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index b2c873e..ff7b3c1 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -120,7 +120,7 @@ struct ath9k_pacal_info{
 	int8_t skipcount;	/* No. of times the PACAL to be skipped */
 };
 
-bool ath9k_hw_reset_calvalid(struct ath_hw *ah);
+bool ath9k_hw_reset_calvalid(struct ath_hw *ah, struct ieee80211_hw *hw);
 void ath9k_hw_start_nfcal(struct ath_hw *ah);
 void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
 int16_t ath9k_hw_getnf(struct ath_hw *ah,
@@ -130,6 +130,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
 bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal);
 bool ath9k_hw_init_cal(struct ath_hw *ah,
+		       struct ieee80211_hw *hw,
 		       struct ath9k_channel *chan);
 
 #endif /* CALIB_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 111ff04..f08cc61 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -26,7 +26,9 @@
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
+static void ath9k_hw_set_regs(struct ath_hw *ah,
+			      struct ieee80211_hw *hw,
+			      struct ath9k_channel *chan);
 static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value);
@@ -52,10 +54,10 @@ module_exit(ath9k_exit);
 /* Helper Functions */
 /********************/
 
-static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
+static u32 ath9k_hw_mac_usec(struct ath_hw *ah,
+			     struct ieee80211_conf *conf,
+			     u32 clks)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
 	if (!ah->curchan) /* should really check for CCK instead */
 		return clks / ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
@@ -64,20 +66,20 @@ static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
 	return clks / ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
-static u32 ath9k_hw_mac_to_usec(struct ath_hw *ah, u32 clks)
+static u32 ath9k_hw_mac_to_usec(struct ath_hw *ah,
+				struct ieee80211_conf *conf,
+				u32 clks)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
 	if (conf_is_ht40(conf))
-		return ath9k_hw_mac_usec(ah, clks) / 2;
+		return ath9k_hw_mac_usec(ah, conf, clks) / 2;
 	else
-		return ath9k_hw_mac_usec(ah, clks);
+		return ath9k_hw_mac_usec(ah, conf, clks);
 }
 
-static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
+static u32 ath9k_hw_mac_clks(struct ath_hw *ah,
+			     struct ieee80211_conf *conf,
+			     u32 usecs)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
 	if (!ah->curchan) /* should really check for CCK instead */
 		return usecs *ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
@@ -85,14 +87,14 @@ static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 	return usecs *ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
-static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
+static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah,
+				struct ieee80211_conf *conf,
+				u32 usecs)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
 	if (conf_is_ht40(conf))
-		return ath9k_hw_mac_clks(ah, usecs) * 2;
+		return ath9k_hw_mac_clks(ah, conf, usecs) * 2;
 	else
-		return ath9k_hw_mac_clks(ah, usecs);
+		return ath9k_hw_mac_clks(ah, conf, usecs);
 }
 
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
@@ -1205,31 +1207,43 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 	}
 }
 
-static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
+static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah,
+				     struct ieee80211_conf *conf,
+				     u32 us)
 {
-	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
+	if (us > ath9k_hw_mac_to_usec(ah,
+				      conf,
+				      MS(0xffffffff, AR_TIME_OUT_ACK))) {
 		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
 			  "bad ack timeout %u\n", us);
 		ah->acktimeout = (u32) -1;
 		return false;
 	} else {
-		REG_RMW_FIELD(ah, AR_TIME_OUT,
-			      AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
+		REG_RMW_FIELD(ah,
+			      AR_TIME_OUT,
+			      AR_TIME_OUT_ACK,
+			      ath9k_hw_mac_to_clks(ah, conf, us));
 		ah->acktimeout = us;
 		return true;
 	}
 }
 
-static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
+static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah,
+				     struct ieee80211_conf *conf,
+				     u32 us)
 {
-	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
+	if (us > ath9k_hw_mac_to_usec(ah,
+				      conf,
+				      MS(0xffffffff, AR_TIME_OUT_CTS))) {
 		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
 			  "bad cts timeout %u\n", us);
 		ah->ctstimeout = (u32) -1;
 		return false;
 	} else {
-		REG_RMW_FIELD(ah, AR_TIME_OUT,
-			      AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
+		REG_RMW_FIELD(ah,
+			      AR_TIME_OUT,
+			      AR_TIME_OUT_CTS,
+			      ath9k_hw_mac_to_clks(ah, conf, us));
 		ah->ctstimeout = us;
 		return true;
 	}
@@ -1249,7 +1263,8 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 	}
 }
 
-static void ath9k_hw_init_user_settings(struct ath_hw *ah)
+static void ath9k_hw_init_user_settings(struct ath_hw *ah,
+					struct ieee80211_conf *conf)
 {
 	ath_print(ath9k_hw_common(ah), ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
 		  ah->misc_mode);
@@ -1258,11 +1273,11 @@ static void ath9k_hw_init_user_settings(struct ath_hw *ah)
 		REG_WRITE(ah, AR_PCU_MISC,
 			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
 	if (ah->slottime != (u32) -1)
-		ath9k_hw_setslottime(ah, ah->slottime);
+		ath9k_hw_setslottime(ah, conf, ah->slottime);
 	if (ah->acktimeout != (u32) -1)
-		ath9k_hw_set_ack_timeout(ah, ah->acktimeout);
+		ath9k_hw_set_ack_timeout(ah, conf, ah->acktimeout);
 	if (ah->ctstimeout != (u32) -1)
-		ath9k_hw_set_cts_timeout(ah, ah->ctstimeout);
+		ath9k_hw_set_cts_timeout(ah, conf, ah->ctstimeout);
 	if (ah->globaltxtimeout != (u32) -1)
 		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
 }
@@ -1431,6 +1446,7 @@ static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
 }
 
 static int ath9k_hw_process_ini(struct ath_hw *ah,
+				struct ieee80211_hw *hw,
 				struct ath9k_channel *chan)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
@@ -1537,7 +1553,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	}
 
 	ath9k_hw_override_ini(ah, chan);
-	ath9k_hw_set_regs(ah, chan);
+	ath9k_hw_set_regs(ah, hw, chan);
 	ath9k_hw_init_chain_masks(ah);
 
 	if (OLC_FOR_AR9280_20_LATER)
@@ -1818,8 +1834,11 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 	}
 }
 
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan)
+static void ath9k_hw_set_regs(struct ath_hw *ah,
+			      struct ieee80211_hw *hw,
+			      struct ath9k_channel *chan)
 {
+	struct ieee80211_conf *conf = &hw->conf;
 	u32 phymode;
 	u32 enableDacFifo = 0;
 
@@ -1840,7 +1859,7 @@ static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
 
-	ath9k_hw_set11nmac2040(ah);
+	ath9k_hw_set11nmac2040(ah, conf);
 
 	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
 	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
@@ -1866,6 +1885,7 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 }
 
 static bool ath9k_hw_channel_change(struct ath_hw *ah,
+				    struct ieee80211_hw *hw,
 				    struct ath9k_channel *chan)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
@@ -1891,7 +1911,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		return false;
 	}
 
-	ath9k_hw_set_regs(ah, chan);
+	ath9k_hw_set_regs(ah, hw, chan);
 
 	r = ah->ath9k_hw_rf_set_freq(ah, chan);
 	if (r) {
@@ -1940,10 +1960,13 @@ static void ath9k_enable_rfkill(struct ath_hw *ah)
 	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
 }
 
-int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
-		    bool bChannelChange)
+int ath9k_hw_reset(struct ath_hw *ah,
+		   struct ieee80211_hw *hw,
+		   struct ath9k_channel *chan,
+		   bool bChannelChange)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &hw->conf;
 	u32 saveLedState;
 	struct ath9k_channel *curchan = ah->curchan;
 	u32 saveDefAntenna;
@@ -1969,7 +1992,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	     !(AR_SREV_9280(ah) || IS_CHAN_A_5MHZ_SPACED(chan) ||
 	     IS_CHAN_A_5MHZ_SPACED(ah->curchan))) {
 
-		if (ath9k_hw_channel_change(ah, chan)) {
+		if (ath9k_hw_channel_change(ah, hw, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah);
 			return 0;
@@ -2029,7 +2052,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
 				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
 	}
-	r = ath9k_hw_process_ini(ah, chan);
+	r = ath9k_hw_process_ini(ah, hw, chan);
 	if (r)
 		return r;
 
@@ -2095,7 +2118,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		ath9k_enable_rfkill(ah);
 
-	ath9k_hw_init_user_settings(ah);
+	ath9k_hw_init_user_settings(ah, conf);
 
 	if (AR_SREV_9287_12_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
@@ -2132,7 +2155,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_bb(ah, chan);
 
-	if (!ath9k_hw_init_cal(ah, chan))
+	if (!ath9k_hw_init_cal(ah, hw, chan))
 		return -EIO;
 
 	rx_chainmask = ah->rxchainmask;
@@ -3710,24 +3733,28 @@ void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 }
 EXPORT_SYMBOL(ath9k_hw_set_tsfadjust);
 
-bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
+bool ath9k_hw_setslottime(struct ath_hw *ah,
+			  struct ieee80211_conf *conf,
+			  u32 us)
 {
-	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
+	if (us < ATH9K_SLOT_TIME_9 ||
+	    us > ath9k_hw_mac_to_usec(ah, conf, 0xffff)) {
 		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
 			  "bad slot time %u\n", us);
 		ah->slottime = (u32) -1;
 		return false;
 	} else {
-		REG_WRITE(ah, AR_D_GBL_IFS_SLOT, ath9k_hw_mac_to_clks(ah, us));
+		REG_WRITE(ah,
+			  AR_D_GBL_IFS_SLOT,
+			  ath9k_hw_mac_to_clks(ah, conf, us));
 		ah->slottime = us;
 		return true;
 	}
 }
 EXPORT_SYMBOL(ath9k_hw_setslottime);
 
-void ath9k_hw_set11nmac2040(struct ath_hw *ah)
+void ath9k_hw_set11nmac2040(struct ath_hw *ah, struct ieee80211_conf *conf)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	u32 macmode;
 
 	if (conf_is_ht40(conf) && !ah->config.cwm_ignore_extcca)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c7b0c4d..a7ae7ac 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <net/mac80211.h>
 
 #include "mac.h"
 #include "ani.h"
@@ -635,7 +636,9 @@ static inline struct ath_regulatory *ath9k_hw_regulatory(struct ath_hw *ah)
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
 int ath9k_hw_init(struct ath_hw *ah);
-int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+int ath9k_hw_reset(struct ath_hw *ah,
+		   struct ieee80211_hw *hw,
+		   struct ath9k_channel *chan,
 		   bool bChannelChange);
 void ath9k_hw_fill_cap_info(struct ath_hw *ah);
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
@@ -689,8 +692,10 @@ u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
-bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
-void ath9k_hw_set11nmac2040(struct ath_hw *ah);
+bool ath9k_hw_setslottime(struct ath_hw *ah,
+			  struct ieee80211_conf *conf,
+			  u32 us);
+void ath9k_hw_set11nmac2040(struct ath_hw *ah, struct ieee80211_conf *conf);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9fefc51..4dec8c0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -303,7 +303,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
+	struct ieee80211_conf *conf = &hw->conf;
 	bool fastcc = true, stopped;
 	struct ieee80211_channel *channel = hw->conf.channel;
 	int r;
@@ -323,7 +323,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	 * the relevant bits of the h/w.
 	 */
 	ath9k_hw_set_interrupts(ah, 0);
-	ath_drain_all_txq(sc, false);
+	ath_drain_all_txq(sc, hw, false);
 	stopped = ath_stoprecv(sc);
 
 	/* XXX: do not flush receive queue here. We don't want
@@ -340,7 +340,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	spin_lock_bh(&sc->sc_resetlock);
 
-	r = ath9k_hw_reset(ah, hchan, fastcc);
+	r = ath9k_hw_reset(ah, hw, hchan, fastcc);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset channel (%u Mhz) "
@@ -381,6 +381,8 @@ static void ath_ani_calibrate(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	/* XXX: this is not right when using a virtual wiphy */
+	struct ieee80211_hw *hw = sc->hw;
 	bool longcal = false;
 	bool shortcal = false;
 	bool aniflag = false;
@@ -423,7 +425,7 @@ static void ath_ani_calibrate(unsigned long data)
 	} else {
 		if ((timestamp - sc->ani.resetcal_timer) >=
 		    ATH_RESTART_CALINTERVAL) {
-			sc->ani.caldone = ath9k_hw_reset_calvalid(ah);
+			sc->ani.caldone = ath9k_hw_reset_calvalid(ah, hw);
 			if (sc->ani.caldone)
 				sc->ani.resetcal_timer = timestamp;
 		}
@@ -439,7 +441,7 @@ static void ath_ani_calibrate(unsigned long data)
 	if (longcal || shortcal || aniflag) {
 		/* Call ANI routine if necessary */
 		if (aniflag)
-			ath9k_hw_ani_monitor(ah, ah->curchan);
+			ath9k_hw_ani_monitor(ah, hw, ah->curchan);
 
 		/* Perform calibration if necessary */
 		if (longcal || shortcal) {
@@ -663,7 +665,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 		 * it will clear whatever condition caused
 		 * the interrupt.
 		 */
-		ath9k_hw_procmibevent(ah);
+		/* XXX: the sc->hw is bogus here when using virtual wiphys */
+		ath9k_hw_procmibevent(ah, sc->hw);
 		ath9k_hw_set_interrupts(ah, sc->imask);
 	}
 
@@ -1200,7 +1203,7 @@ fail:
 	ath_deinit_leds(sc);
 }
 
-void ath_radio_enable(struct ath_softc *sc)
+void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1214,7 +1217,7 @@ void ath_radio_enable(struct ath_softc *sc)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
 	spin_lock_bh(&sc->sc_resetlock);
-	r = ath9k_hw_reset(ah, ah->curchan, false);
+	r = ath9k_hw_reset(ah, hw, ah->curchan, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset channel %u (%uMhz) ",
@@ -1245,7 +1248,7 @@ void ath_radio_enable(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 }
 
-void ath_radio_disable(struct ath_softc *sc)
+void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_channel *channel = sc->hw->conf.channel;
@@ -1261,7 +1264,7 @@ void ath_radio_disable(struct ath_softc *sc)
 	/* Disable interrupts */
 	ath9k_hw_set_interrupts(ah, 0);
 
-	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
+	ath_drain_all_txq(sc, hw, false); /* clear pending tx frames */
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
 
@@ -1269,7 +1272,7 @@ void ath_radio_disable(struct ath_softc *sc)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
 	spin_lock_bh(&sc->sc_resetlock);
-	r = ath9k_hw_reset(ah, ah->curchan, false);
+	r = ath9k_hw_reset(ah, hw, ah->curchan, false);
 	if (r) {
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
 			  "Unable to reset channel %u (%uMhz) "
@@ -1652,7 +1655,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->ops = &ath9k_common_ops;
 	common->bus_ops = bus_ops;
 	common->ah = ah;
-	common->hw = sc->hw;
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
 
@@ -1988,16 +1990,22 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	/*
+	 * XXX: the sc->hw may not be the active one,
+	 * we may actually be on a virtual wiphy aphy->hw
+	 * but currently have no way of knowing which is the
+	 * active one.
+	 */
 	struct ieee80211_hw *hw = sc->hw;
 	int r;
 
 	ath9k_hw_set_interrupts(ah, 0);
-	ath_drain_all_txq(sc, retry_tx);
+	ath_drain_all_txq(sc, hw, retry_tx);
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
 
 	spin_lock_bh(&sc->sc_resetlock);
-	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
+	r = ath9k_hw_reset(ah, hw, sc->sc_ah->curchan, false);
 	if (r)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d\n", r);
@@ -2308,7 +2316,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * and then setup of the interrupt mask.
 	 */
 	spin_lock_bh(&sc->sc_resetlock);
-	r = ath9k_hw_reset(ah, init_channel, false);
+	r = ath9k_hw_reset(ah, hw, init_channel, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d "
@@ -2539,7 +2547,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath9k_hw_set_interrupts(ah, 0);
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
-		ath_drain_all_txq(sc, false);
+		ath_drain_all_txq(sc, hw, false);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
 	} else
@@ -2704,7 +2712,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 				disable_radio = true;
 		}
 		else if (all_wiphys_idle) {
-			ath_radio_enable(sc);
+			ath_radio_enable(sc, hw);
 			ath_print(common, ATH_DBG_CONFIG,
 				  "not-idle: enabling radio\n");
 		}
@@ -2781,7 +2789,7 @@ skip_chan_change:
 
 	if (disable_radio) {
 		ath_print(common, ATH_DBG_CONFIG, "idle: disabling radio\n");
-		ath_radio_disable(sc);
+		ath_radio_disable(sc, hw);
 	}
 
 	mutex_unlock(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index bc7d173..2dcbfbd 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -508,6 +508,8 @@ int ath9k_wiphy_select(struct ath_wiphy *aphy)
 		sc->wiphy_select_failures++;
 		if (time_after(jiffies, sc->wiphy_select_first_fail + HZ / 2))
 		{
+			struct ieee80211_hw *hw = aphy->hw;
+
 			printk(KERN_DEBUG "ath9k: Previous wiphy select timed "
 			       "out; disable/enable hw to recover\n");
 			__ath9k_wiphy_mark_all_paused(sc);
@@ -521,8 +523,8 @@ int ath9k_wiphy_select(struct ath_wiphy *aphy)
 			 * frame being completed)
 			 */
 			spin_unlock_bh(&sc->wiphy_lock);
-			ath_radio_disable(sc);
-			ath_radio_enable(sc);
+			ath_radio_disable(sc, hw);
+			ath_radio_enable(sc, hw);
 			ieee80211_queue_work(aphy->sc->hw,
 				   &aphy->sc->chan_work);
 			return -EBUSY; /* previous select still in progress */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2a4efcb..e6c6d35 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1053,7 +1053,9 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 	}
 }
 
-void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
+void ath_drain_all_txq(struct ath_softc *sc,
+		       struct ieee80211_hw *hw,
+		       bool retry_tx)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -1082,7 +1084,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 			  "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
-		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, true);
+		r = ath9k_hw_reset(ah, hw, sc->sc_ah->curchan, true);
 		if (r)
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to reset hardware; reset status %d\n",
-- 
1.6.0.4

