Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54821 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYHNIIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:08:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 01:08:50 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18595.58716.968278.970981@localhost.localdomain> (sfid-20080814_100854_922544_F09EBBA9)
Date: Thu, 14 Aug 2008 13:27:16 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/6] ath9k: Miscellaneous fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes ath_vap_listen() and dma wrapper macros.
Also, Inline abuse is cleaned up and a few typos are fixed.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |   52 ++++++++++++------------
 drivers/net/wireless/ath9k/core.c   |   74 ++---------------------------------
 drivers/net/wireless/ath9k/core.h   |    6 +--
 drivers/net/wireless/ath9k/hw.c     |   68 ++++++++++++++++----------------
 drivers/net/wireless/ath9k/main.c   |   19 +-------
 drivers/net/wireless/ath9k/xmit.c   |   29 +++++--------
 6 files changed, 79 insertions(+), 169 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index a020f9a..89e5c65 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -114,21 +114,21 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
 		rate |= rt->info[rix].shortPreamble;
 
-	ath9k_hw_set11n_txdesc(ah, ds
-			      , skb->len + FCS_LEN /* frame length */
-			      , ATH9K_PKT_TYPE_BEACON /* Atheros packet type */
-			      , avp->av_btxctl.txpower /* txpower XXX */
-			      , ATH9K_TXKEYIX_INVALID /* no encryption */
-			      , ATH9K_KEY_TYPE_CLEAR /* no encryption */
-			      , flags /* no ack, veol for beacons */
+	ath9k_hw_set11n_txdesc(ah, ds,
+			       skb->len + FCS_LEN, /* frame length */
+			       ATH9K_PKT_TYPE_BEACON, /* Atheros packet type */
+			       avp->av_btxctl.txpower, /* txpower XXX */
+			       ATH9K_TXKEYIX_INVALID, /* no encryption */
+			       ATH9K_KEY_TYPE_CLEAR, /* no encryption */
+			       flags /* no ack, veol for beacons */
 		);
 
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
-	ath9k_hw_filltxdesc(ah, ds
-			   , roundup(skb->len, 4) /* buffer length */
-			   , true /* first segment */
-			   , true /* last segment */
-			   , ds /* first descriptor */
+	ath9k_hw_filltxdesc(ah, ds,
+			    roundup(skb->len, 4), /* buffer length */
+			    true, /* first segment */
+			    true, /* last segment */
+			    ds /* first descriptor */
 		);
 
 	memzero(series, sizeof(struct ath9k_11n_rate_series) * 4);
@@ -551,7 +551,7 @@ void ath_beacon_free(struct ath_softc *sc)
 
 void ath9k_beacon_tasklet(unsigned long data)
 {
-#define TSF_TO_TU(_h,_l)					\
+#define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
 	struct ath_softc *sc = (struct ath_softc *)data;
@@ -898,19 +898,19 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			"cfp:period %u "
 			"maxdur %u "
 			"next %u "
-			"timoffset %u\n"
-			, __func__
-			, (unsigned long long)tsf, tsftu
-			, bs.bs_intval
-			, bs.bs_nexttbtt
-			, bs.bs_dtimperiod
-			, bs.bs_nextdtim
-			, bs.bs_bmissthreshold
-			, bs.bs_sleepduration
-			, bs.bs_cfpperiod
-			, bs.bs_cfpmaxduration
-			, bs.bs_cfpnext
-			, bs.bs_timoffset
+			"timoffset %u\n",
+			__func__,
+			(unsigned long long)tsf, tsftu,
+			bs.bs_intval,
+			bs.bs_nexttbtt,
+			bs.bs_dtimperiod,
+			bs.bs_nextdtim,
+			bs.bs_bmissthreshold,
+			bs.bs_sleepduration,
+			bs.bs_cfpperiod,
+			bs.bs_cfpmaxduration,
+			bs.bs_cfpnext,
+			bs.bs_timoffset
 			);
 
 		ath9k_hw_set_interrupts(ah, 0);
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index e3682b6..57645ee 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -51,10 +51,8 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
  *  Set current operating mode
  *
  *  This function initializes and fills the rate table in the ATH object based
- *  on the operating mode.  The blink rates are also set up here, although
- *  they have been superceeded by the ath_led module.
+ *  on the operating mode.
 */
-
 static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 {
 	const struct ath9k_rate_table *rt;
@@ -232,7 +230,7 @@ static int ath_setup_channels(struct ath_softc *sc)
  *  Determine mode from channel flags
  *
  *  This routine will provide the enumerated WIRELESSS_MODE value based
- *  on the settings of the channel flags.  If ho valid set of flags
+ *  on the settings of the channel flags.  If no valid set of flags
  *  exist, the lowest mode (11b) is selected.
 */
 
@@ -257,7 +255,8 @@ static enum wireless_mode ath_chan2mode(struct ath9k_channel *chan)
 	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
 		return ATH9K_MODE_11NG_HT40MINUS;
 
-	/* NB: should not get here */
+	WARN_ON(1); /* should not get here */
+
 	return ATH9K_MODE_11B;
 }
 
@@ -278,8 +277,6 @@ static int ath_stop(struct ath_softc *sc)
 	/*
 	 * Shutdown the hardware and driver:
 	 *    stop output from above
-	 *    reset 802.11 state machine
-	 *      (sends station deassoc/deauth frames)
 	 *    turn off timers
 	 *    disable interrupts
 	 *    clear transmit machinery
@@ -499,69 +496,6 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 /* VAP management */
 /******************/
 
-/*
- *  VAP in Listen mode
- *
- *  This routine brings the VAP out of the down state into a "listen" state
- *  where it waits for association requests.  This is used in AP and AdHoc
- *  modes.
-*/
-
-int ath_vap_listen(struct ath_softc *sc, int if_id)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_vap *avp;
-	u32 rfilt = 0;
-	DECLARE_MAC_BUF(mac);
-
-	avp = sc->sc_vaps[if_id];
-	if (avp == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: invalid interface id %u\n",
-			__func__, if_id);
-		return -EINVAL;
-	}
-
-#ifdef CONFIG_SLOW_ANT_DIV
-	ath_slow_ant_div_stop(&sc->sc_antdiv);
-#endif
-
-	/* update ratectrl about the new state */
-	ath_rate_newstate(sc, avp);
-
-	rfilt = ath_calcrxfilter(sc);
-	ath9k_hw_setrxfilter(ah, rfilt);
-
-	if (sc->sc_ah->ah_opmode == ATH9K_M_STA ||
-	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
-		memcpy(sc->sc_curbssid, ath_bcast_mac, ETH_ALEN);
-		ath9k_hw_write_associd(ah, sc->sc_curbssid, sc->sc_curaid);
-	} else
-		sc->sc_curaid = 0;
-
-	DPRINTF(sc, ATH_DBG_CONFIG,
-		"%s: RX filter 0x%x bssid %s aid 0x%x\n",
-		__func__, rfilt, print_mac(mac,
-			sc->sc_curbssid), sc->sc_curaid);
-
-	/*
-	 * XXXX
-	 * Disable BMISS interrupt when we're not associated
-	 */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
-		ath9k_hw_set_interrupts(ah, sc->sc_imask & ~ATH9K_INT_BMISS);
-		sc->sc_imask &= ~ATH9K_INT_BMISS;
-	} else {
-		ath9k_hw_set_interrupts(
-			ah,
-			sc->sc_imask & ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS));
-		sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-	}
-	/* need to reconfigure the beacons when it moves to RUN */
-	sc->sc_flags &= ~SC_OP_BEACONS;
-
-	return 0;
-}
-
 int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 51bf528..406225b 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -82,9 +82,6 @@ struct ath_node;
 /* XXX: remove */
 #define memzero(_buf, _len) memset(_buf, 0, _len)
 
-#define get_dma_mem_context(var, field) (&((var)->field))
-#define copy_dma_mem_context(dst, src)  (*dst = *src)
-
 #define ATH9K_BH_STATUS_INTACT		0
 #define ATH9K_BH_STATUS_CHANGE		1
 
@@ -769,8 +766,7 @@ int ath_vap_attach(struct ath_softc *sc,
 		   enum ath9k_opmode opmode);
 int ath_vap_detach(struct ath_softc *sc, int if_id);
 int ath_vap_config(struct ath_softc *sc,
-	int if_id, struct ath_vap_config *if_config);
-int ath_vap_listen(struct ath_softc *sc, int if_id);
+		   int if_id, struct ath_vap_config *if_config);
 
 /*********************/
 /* Antenna diversity */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 23eb789..41d613b 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -348,7 +348,7 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 	ah->ah_config.intr_mitigation = 0;
 }
 
-static inline void ath9k_hw_override_ini(struct ath_hal *ah,
+static void ath9k_hw_override_ini(struct ath_hal *ah,
 					 struct ath9k_channel *chan)
 {
 	if (!AR_SREV_5416_V20_OR_LATER(ah)
@@ -358,8 +358,8 @@ static inline void ath9k_hw_override_ini(struct ath_hal *ah,
 	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
 }
 
-static inline void ath9k_hw_init_bb(struct ath_hal *ah,
-				    struct ath9k_channel *chan)
+static void ath9k_hw_init_bb(struct ath_hal *ah,
+			     struct ath9k_channel *chan)
 {
 	u32 synthDelay;
 
@@ -374,8 +374,8 @@ static inline void ath9k_hw_init_bb(struct ath_hal *ah,
 	udelay(synthDelay + BASE_ACTIVATE_DELAY);
 }
 
-static inline void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
-						 enum ath9k_opmode opmode)
+static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
+					  enum ath9k_opmode opmode)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -405,7 +405,7 @@ static inline void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
 	}
 }
 
-static inline void ath9k_hw_init_qos(struct ath_hal *ah)
+static void ath9k_hw_init_qos(struct ath_hal *ah)
 {
 	REG_WRITE(ah, AR_MIC_QOS_CONTROL, 0x100aa);
 	REG_WRITE(ah, AR_MIC_QOS_SELECT, 0x3210);
@@ -500,7 +500,7 @@ static inline bool ath9k_hw_nvram_read(struct ath_hal *ah,
 		return ath9k_hw_eeprom_read(ah, off, data);
 }
 
-static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
+static bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
@@ -767,7 +767,7 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 	return true;
 }
 
-static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
+static int ath9k_hw_check_eeprom(struct ath_hal *ah)
 {
 	u32 sum = 0, el;
 	u16 *eepdata;
@@ -1272,7 +1272,7 @@ u32 ath9k_hw_get_eeprom(struct ath_hal_5416 *ahp,
 	}
 }
 
-static inline int ath9k_hw_get_radiorev(struct ath_hal *ah)
+static int ath9k_hw_get_radiorev(struct ath_hal *ah)
 {
 	u32 val;
 	int i;
@@ -1285,7 +1285,7 @@ static inline int ath9k_hw_get_radiorev(struct ath_hal *ah)
 	return ath9k_hw_reverse_bits(val, 8);
 }
 
-static inline int ath9k_hw_init_macaddr(struct ath_hal *ah)
+static int ath9k_hw_init_macaddr(struct ath_hal *ah)
 {
 	u32 sum;
 	int i;
@@ -1367,7 +1367,7 @@ static u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
 	return spur_val;
 }
 
-static inline int ath9k_hw_rfattach(struct ath_hal *ah)
+static int ath9k_hw_rfattach(struct ath_hal *ah)
 {
 	bool rfStatus = false;
 	int ecode = 0;
@@ -1412,8 +1412,8 @@ static int ath9k_hw_rf_claim(struct ath_hal *ah)
 	return 0;
 }
 
-static inline void ath9k_hw_init_pll(struct ath_hal *ah,
-				     struct ath9k_channel *chan)
+static void ath9k_hw_init_pll(struct ath_hal *ah,
+			      struct ath9k_channel *chan)
 {
 	u32 pll;
 
@@ -1531,7 +1531,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 	}
 }
 
-static inline void
+static void
 ath9k_hw_set_rfmode(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	u32 rfMode = 0;
@@ -1601,7 +1601,7 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 	return true;
 }
 
-static inline bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
+static bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 {
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
@@ -1642,7 +1642,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
 	}
 }
 
-static inline
+static
 struct ath9k_channel *ath9k_hw_check_chan(struct ath_hal *ah,
 					  struct ath9k_channel *chan)
 {
@@ -2076,7 +2076,7 @@ static void ath9k_hw_ani_attach(struct ath_hal *ah)
 		ahp->ah_procPhyErr |= HAL_PROCESS_ANI;
 }
 
-static inline void ath9k_hw_ani_setup(struct ath_hal *ah)
+static void ath9k_hw_ani_setup(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
@@ -2861,7 +2861,7 @@ static u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
 	}
 }
 
-static inline int ath9k_hw_post_attach(struct ath_hal *ah)
+static int ath9k_hw_post_attach(struct ath_hal *ah)
 {
 	int ecode;
 
@@ -3573,7 +3573,7 @@ static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin,
 	return true;
 }
 
-static inline void
+static void
 ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 				    struct ath9k_channel *chan,
 				    struct cal_data_per_freq *pRawDataSet,
@@ -3755,7 +3755,7 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 	return;
 }
 
-static inline bool
+static bool
 ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 			     struct ar5416_eeprom *pEepData,
 			     struct ath9k_channel *chan,
@@ -3958,7 +3958,7 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 	}
 }
 
-static inline void
+static void
 ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
 				  struct ath9k_channel *chan,
 				  struct cal_target_power_leg *powInfo,
@@ -4024,7 +4024,7 @@ ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
 	}
 }
 
-static inline void
+static void
 ath9k_hw_get_target_powers(struct ath_hal *ah,
 			   struct ath9k_channel *chan,
 			   struct cal_target_power_ht *powInfo,
@@ -4091,7 +4091,7 @@ ath9k_hw_get_target_powers(struct ath_hal *ah,
 	}
 }
 
-static inline u16
+static u16
 ath9k_hw_get_max_edge_power(u16 freq,
 			    struct cal_ctl_edges *pRdEdgesPower,
 			    bool is2GHz)
@@ -4121,7 +4121,7 @@ ath9k_hw_get_max_edge_power(u16 freq,
 	return twiceMaxEdgePower;
 }
 
-static inline bool
+static bool
 ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				  struct ar5416_eeprom *pEepData,
 				  struct ath9k_channel *chan,
@@ -5096,7 +5096,7 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah,
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
-static inline void ath9k_hw_init_chain_masks(struct ath_hal *ah)
+static void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	int rx_chainmask, tx_chainmask;
@@ -5300,7 +5300,7 @@ bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us)
 	}
 }
 
-static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
+static void ath9k_hw_init_user_settings(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -5319,7 +5319,7 @@ static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
 		ath9k_hw_set_global_txtimeout(ah, ahp->ah_globaltxtimeout);
 }
 
-static inline int
+static int
 ath9k_hw_process_ini(struct ath_hal *ah,
 		     struct ath9k_channel *chan,
 		     enum ath9k_ht_macmode macmode)
@@ -5450,7 +5450,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 	return 0;
 }
 
-static inline void ath9k_hw_setup_calibration(struct ath_hal *ah,
+static void ath9k_hw_setup_calibration(struct ath_hal *ah,
 					      struct hal_cal_list *currCal)
 {
 	REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
@@ -5486,8 +5486,8 @@ static inline void ath9k_hw_setup_calibration(struct ath_hal *ah,
 		    AR_PHY_TIMING_CTRL4_DO_CAL);
 }
 
-static inline void ath9k_hw_reset_calibration(struct ath_hal *ah,
-					      struct hal_cal_list *currCal)
+static void ath9k_hw_reset_calibration(struct ath_hal *ah,
+				       struct hal_cal_list *currCal)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	int i;
@@ -5506,7 +5506,7 @@ static inline void ath9k_hw_reset_calibration(struct ath_hal *ah,
 	ahp->ah_CalSamples = 0;
 }
 
-static inline void
+static void
 ath9k_hw_per_calibration(struct ath_hal *ah,
 			 struct ath9k_channel *ichan,
 			 u8 rxchainmask,
@@ -5596,7 +5596,7 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 	return true;
 }
 
-static inline bool
+static bool
 ath9k_hw_channel_change(struct ath_hal *ah,
 			struct ath9k_channel *chan,
 			enum ath9k_ht_macmode macmode)
@@ -5773,8 +5773,8 @@ static bool ath9k_hw_iscal_supported(struct ath_hal *ah,
 	return retval;
 }
 
-static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
-				     struct ath9k_channel *chan)
+static bool ath9k_hw_init_cal(struct ath_hal *ah,
+			      struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *ichan =
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8fbde89..605599e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -212,12 +212,10 @@ static int ath_key_config(struct ath_softc *sc,
 
 static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 {
-#define ATH_MAX_NUM_KEYS 4
 	int freeslot;
 
-	freeslot = (key->keyidx >= ATH_MAX_NUM_KEYS) ? 1 : 0;
+	freeslot = (key->keyidx >= 4) ? 1 : 0;
 	ath_key_reset(sc, key->keyidx, freeslot);
-#undef ATH_MAX_NUM_KEYS
 }
 
 static void setup_ht_cap(struct ieee80211_ht_info *ht_info)
@@ -620,7 +618,8 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	}
 
 	if ((conf->changed & IEEE80211_IFCC_BEACON) &&
-	    (vif->type == IEEE80211_IF_TYPE_IBSS)) {
+	    ((vif->type == IEEE80211_IF_TYPE_IBSS) ||
+	     (vif->type == IEEE80211_IF_TYPE_AP))) {
 		/*
 		 * Allocate and setup the beacon frame.
 		 *
@@ -638,18 +637,6 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		ath_beacon_sync(sc, 0);
 	}
 
-	if ((conf->changed & IEEE80211_IFCC_BEACON) &&
-	    (vif->type == IEEE80211_IF_TYPE_AP)) {
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
-
-		error = ath_beacon_alloc(sc, 0);
-		if (error != 0)
-			return error;
-
-		ath_beacon_config(sc, 0);
-		sc->sc_flags |= SC_OP_BEACONS;
-	}
-
 	/* Check for WLAN_CAPABILITY_PRIVACY ? */
 	if ((avp->av_opmode != IEEE80211_IF_TYPE_STA)) {
 		for (i = 0; i < IEEE80211_WEP_NKID; i++)
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 8d31ad7..04f94d2 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -499,7 +499,6 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ath_xmit_status tx_status;
-	dma_addr_t *pa;
 
 	/*
 	 * Set retry information.
@@ -519,9 +518,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 			tx_status.flags |= ATH_TX_XRETRY;
 	}
 	/* Unmap this frame */
-	pa = get_dma_mem_context(bf, bf_dmacontext);
 	pci_unmap_single(sc->pdev,
-			 *pa,
+			 bf->bf_dmacontext,
 			 skb->len,
 			 PCI_DMA_TODEVICE);
 	/* complete this frame */
@@ -1172,11 +1170,8 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 						tbf->bf_lastfrm->bf_desc);
 
 					/* copy the DMA context */
-					copy_dma_mem_context(
-						get_dma_mem_context(tbf,
-							bf_dmacontext),
-						get_dma_mem_context(bf_last,
-							bf_dmacontext));
+					tbf->bf_dmacontext =
+						bf_last->bf_dmacontext;
 				}
 				list_add_tail(&tbf->list, &bf_head);
 			} else {
@@ -1185,7 +1180,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				 * software retry
 				 */
 				ath9k_hw_cleartxdesc(sc->sc_ah,
-					bf->bf_lastfrm->bf_desc);
+						     bf->bf_lastfrm->bf_desc);
 			}
 
 			/*
@@ -2045,8 +2040,7 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 	/*
 	 * Save the DMA context in the first ath_buf
 	 */
-	copy_dma_mem_context(get_dma_mem_context(bf, bf_dmacontext),
-			     get_dma_mem_context(txctl, dmacontext));
+	bf->bf_dmacontext = txctl->dmacontext;
 
 	/*
 	 * Formulate first tx descriptor with tx controls.
@@ -2127,25 +2121,26 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 
 static void xmit_map_sg(struct ath_softc *sc,
 			struct sk_buff *skb,
-			dma_addr_t *pa,
 			struct ath_tx_control *txctl)
 {
 	struct ath_xmit_status tx_status;
 	struct ath_atx_tid *tid;
 	struct scatterlist sg;
 
-	*pa = pci_map_single(sc->pdev, skb->data, skb->len, PCI_DMA_TODEVICE);
+	txctl->dmacontext = pci_map_single(sc->pdev, skb->data,
+					   skb->len, PCI_DMA_TODEVICE);
 
 	/* setup S/G list */
 	memset(&sg, 0, sizeof(struct scatterlist));
-	sg_dma_address(&sg) = *pa;
+	sg_dma_address(&sg) = txctl->dmacontext;
 	sg_dma_len(&sg) = skb->len;
 
 	if (ath_tx_start_dma(sc, skb, &sg, 1, txctl) != 0) {
 		/*
 		 *  We have to do drop frame here.
 		 */
-		pci_unmap_single(sc->pdev, *pa, skb->len, PCI_DMA_TODEVICE);
+		pci_unmap_single(sc->pdev, txctl->dmacontext,
+				 skb->len, PCI_DMA_TODEVICE);
 
 		tx_status.retries = 0;
 		tx_status.flags = ATH_TX_ERROR;
@@ -2419,9 +2414,7 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb)
 		 * ath_tx_start_dma() will be called either synchronously
 		 * or asynchrounsly once DMA is complete.
 		 */
-		xmit_map_sg(sc, skb,
-			    get_dma_mem_context(&txctl, dmacontext),
-			    &txctl);
+		xmit_map_sg(sc, skb, &txctl);
 	else
 		ath_node_put(sc, txctl.an, ATH9K_BH_STATUS_CHANGE);
 
-- 
1.5.6.5

