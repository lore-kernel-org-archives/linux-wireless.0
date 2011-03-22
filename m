Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36653 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307Ab1CVUy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 16:54:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k: fix beacon timer handling issues
Date: Tue, 22 Mar 2011 21:54:17 +0100
Message-Id: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP mode beacon timers in ath9k are configured in milliseconds, which breaks
when increasing ATH_BCBUF to 8 instead of 4 (due to rounding errors).
Since the hardware timers are actually configured in microseconds, it's
better to let the driver use that unit directly.

To be able to do that, the beacon interval parameter abuse for passing
certain flags needs to be removed. This is easy to do, because those flags
are completely unnecessary anyway. ATH9K_BEACON_ENA is ignored,
ATH9K_BEACON_RESET_TSF can be replaced with calling ath9k_hw_reset_tsf
from the driver directly.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h          |    2 +-
 drivers/net/wireless/ath/ath9k/beacon.c         |   78 +++++++++--------------
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    9 +--
 drivers/net/wireless/ath/ath9k/hw.c             |   36 ++++-------
 drivers/net/wireless/ath/ath9k/hw.h             |    3 +-
 5 files changed, 49 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 099bd41..07dfb31 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -386,7 +386,7 @@ struct ath_beacon {
 	u32 beaconq;
 	u32 bmisscnt;
 	u32 ast_be_xmit;
-	u64 bc_tstamp;
+	u32 bc_tstamp;
 	struct ieee80211_vif *bslot[ATH_BCBUF];
 	int slottime;
 	int slotupdate;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6d2a545f..b5eab2f 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -57,8 +57,8 @@ int ath_beaconq_config(struct ath_softc *sc)
 
 /*
  *  Associates the beacon frame buffer with a transmit descriptor.  Will set
- *  up all required antenna switch parameters, rate codes, and channel flags.
- *  Beacons are always sent out at the lowest rate, and are not retried.
+ *  up rate codes, and channel flags. Beacons are always sent out at the
+ *  lowest rate, and are not retried.
 */
 static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 			     struct ath_buf *bf, int rateidx)
@@ -68,7 +68,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_desc *ds;
 	struct ath9k_11n_rate_series series[4];
-	int flags, antenna, ctsrate = 0, ctsduration = 0;
+	int flags, ctsrate = 0, ctsduration = 0;
 	struct ieee80211_supported_band *sband;
 	u8 rate = 0;
 
@@ -76,12 +76,6 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	flags = ATH9K_TXDESC_NOACK;
 
 	ds->ds_link = 0;
-	/*
-	 * Switch antenna every beacon.
-	 * Should only switch every beacon period, not for every SWBA
-	 * XXX assumes two antennae
-	 */
-	antenna = ((sc->beacon.ast_be_xmit / sc->nbcnvifs) & 1 ? 2 : 1);
 
 	sband = &sc->sbands[common->hw->conf.channel->band];
 	rate = sband->bitrates[rateidx].hw_value;
@@ -278,7 +272,7 @@ int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 		return -ENOMEM;
 
 	tstamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	sc->beacon.bc_tstamp = le64_to_cpu(tstamp);
+	sc->beacon.bc_tstamp = (u32) le64_to_cpu(tstamp);
 	/* Calculate a TSF adjustment factor required for staggered beacons. */
 	if (avp->av_bslot > 0) {
 		u64 tsfadjust;
@@ -294,8 +288,8 @@ int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 		 * adjustment. Other slots are adjusted to get the timestamp
 		 * close to the TBTT for the BSS.
 		 */
-		tsfadjust = intval * avp->av_bslot / ATH_BCBUF;
-		avp->tsf_adjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
+		tsfadjust = TU_TO_USEC(intval * avp->av_bslot) / ATH_BCBUF;
+		avp->tsf_adjust = cpu_to_le64(tsfadjust);
 
 		ath_dbg(common, ATH_DBG_BEACON,
 			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
@@ -401,8 +395,9 @@ void ath_beacon_tasklet(unsigned long data)
 	intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
 
 	tsf = ath9k_hw_gettsf64(ah);
-	tsftu = TSF_TO_TU(tsf>>32, tsf);
-	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
+	tsf += TU_TO_USEC(ah->config.sw_beacon_response_time);
+	tsftu = TSF_TO_TU((tsf * ATH_BCBUF) >>32, tsf * ATH_BCBUF);
+	slot = (tsftu % (intval * ATH_BCBUF)) / intval;
 	/*
 	 * Reverse the slot order to get slot 0 on the TBTT offset that does
 	 * not require TSF adjustment and other slots adding
@@ -415,7 +410,7 @@ void ath_beacon_tasklet(unsigned long data)
 
 	ath_dbg(common, ATH_DBG_BEACON,
 		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
-		slot, tsf, tsftu, intval, vif);
+		slot, tsf, tsftu / ATH_BCBUF, intval, vif);
 
 	bfaddr = 0;
 	if (vif) {
@@ -463,13 +458,17 @@ static void ath9k_beacon_init(struct ath_softc *sc,
 			      u32 next_beacon,
 			      u32 beacon_period)
 {
-	if (beacon_period & ATH9K_BEACON_RESET_TSF)
+	if (sc->sc_flags & SC_OP_TSF_RESET) {
 		ath9k_ps_wakeup(sc);
+		ath9k_hw_reset_tsf(sc->sc_ah);
+	}
 
 	ath9k_hw_beaconinit(sc->sc_ah, next_beacon, beacon_period);
 
-	if (beacon_period & ATH9K_BEACON_RESET_TSF)
+	if (sc->sc_flags & SC_OP_TSF_RESET) {
 		ath9k_ps_restore(sc);
+		sc->sc_flags &= ~SC_OP_TSF_RESET;
+	}
 }
 
 /*
@@ -484,18 +483,14 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	u32 nexttbtt, intval;
 
 	/* NB: the beacon interval is kept internally in TU's */
-	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
+	intval = TU_TO_USEC(conf->beacon_interval & ATH9K_BEACON_PERIOD);
 	intval /= ATH_BCBUF;    /* for staggered beacons */
 	nexttbtt = intval;
 
-	if (sc->sc_flags & SC_OP_TSF_RESET)
-		intval |= ATH9K_BEACON_RESET_TSF;
-
 	/*
 	 * In AP mode we enable the beacon timers and SWBA interrupts to
 	 * prepare beacon frames.
 	 */
-	intval |= ATH9K_BEACON_ENA;
 	ah->imask |= ATH9K_INT_SWBA;
 	ath_beaconq_config(sc);
 
@@ -505,11 +500,6 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(ah, ah->imask);
-
-	/* Clear the reset TSF flag, so that subsequent beacon updation
-	   will not reset the HW TSF. */
-
-	sc->sc_flags &= ~SC_OP_TSF_RESET;
 }
 
 /*
@@ -643,25 +633,20 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u64 tsf;
-	u32 tsftu, intval, nexttbtt;
-
-	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
-
-
-	/* Pull nexttbtt forward to reflect the current TSF */
-
-	nexttbtt = TSF_TO_TU(sc->beacon.bc_tstamp >> 32, sc->beacon.bc_tstamp);
-	if (nexttbtt == 0)
-                nexttbtt = intval;
-        else if (intval)
-                nexttbtt = roundup(nexttbtt, intval);
-
-	tsf = ath9k_hw_gettsf64(ah);
-	tsftu = TSF_TO_TU((u32)(tsf>>32), (u32)tsf) + FUDGE;
-	do {
-		nexttbtt += intval;
-	} while (nexttbtt < tsftu);
+	u32 tsf, delta, intval, nexttbtt;
+
+	tsf = ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE);
+	intval = TU_TO_USEC(conf->beacon_interval & ATH9K_BEACON_PERIOD);
+
+	if (!sc->beacon.bc_tstamp)
+		nexttbtt = tsf + intval;
+	else {
+		if (tsf > sc->beacon.bc_tstamp)
+			delta = (tsf - sc->beacon.bc_tstamp);
+		else
+			delta = (tsf + 1 + (~0U - sc->beacon.bc_tstamp));
+		nexttbtt = tsf + roundup(delta, intval);
+	}
 
 	ath_dbg(common, ATH_DBG_BEACON,
 		"IBSS nexttbtt %u intval %u (%u)\n",
@@ -672,7 +657,6 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	 * if we need to manually prepare beacon frames.  Otherwise we use a
 	 * self-linked tx descriptor and let the hardware deal with things.
 	 */
-	intval |= ATH9K_BEACON_ENA;
 	ah->imask |= ATH9K_INT_SWBA;
 
 	ath_beaconq_config(sc);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 8d1d879..8f56158 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -155,7 +155,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 	nexttbtt = intval;
 
 	if (priv->op_flags & OP_TSF_RESET) {
-		intval |= ATH9K_BEACON_RESET_TSF;
+		ath9k_hw_reset_tsf(priv->ah);
 		priv->op_flags &= ~OP_TSF_RESET;
 	} else {
 		/*
@@ -168,8 +168,6 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		} while (nexttbtt < tsftu);
 	}
 
-	intval |= ATH9K_BEACON_ENA;
-
 	if (priv->op_flags & OP_ENABLE_BEACON)
 		imask |= ATH9K_INT_SWBA;
 
@@ -178,7 +176,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		bss_conf->beacon_interval, nexttbtt, imask);
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
+	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
 	priv->bmiss_cnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
@@ -207,7 +205,6 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 		nexttbtt += intval;
 	} while (nexttbtt < tsftu);
 
-	intval |= ATH9K_BEACON_ENA;
 	if (priv->op_flags & OP_ENABLE_BEACON)
 		imask |= ATH9K_INT_SWBA;
 
@@ -216,7 +213,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 		bss_conf->beacon_interval, nexttbtt, imask);
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
+	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
 	priv->bmiss_cnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8b86568..9513ec7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1697,21 +1697,15 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	case NL80211_IFTYPE_MESH_POINT:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
-		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
-			  TU_TO_USEC(next_beacon +
-				     (ah->atim_window ? ah->
-				      atim_window : 1)));
+		REG_WRITE(ah, AR_NEXT_NDP_TIMER, next_beacon +
+			  TU_TO_USEC(ah->atim_window ? ah->atim_window : 1));
 		flags |= AR_NDP_TIMER_EN;
 	case NL80211_IFTYPE_AP:
-		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
-		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
-			  TU_TO_USEC(next_beacon -
-				     ah->config.
-				     dma_beacon_response_time));
-		REG_WRITE(ah, AR_NEXT_SWBA,
-			  TU_TO_USEC(next_beacon -
-				     ah->config.
-				     sw_beacon_response_time));
+		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, next_beacon);
+		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, next_beacon -
+			  TU_TO_USEC(ah->config.dma_beacon_response_time));
+		REG_WRITE(ah, AR_NEXT_SWBA, next_beacon -
+			  TU_TO_USEC(ah->config.sw_beacon_response_time));
 		flags |=
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
@@ -1723,18 +1717,13 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 		break;
 	}
 
-	REG_WRITE(ah, AR_BEACON_PERIOD, TU_TO_USEC(beacon_period));
-	REG_WRITE(ah, AR_DMA_BEACON_PERIOD, TU_TO_USEC(beacon_period));
-	REG_WRITE(ah, AR_SWBA_PERIOD, TU_TO_USEC(beacon_period));
-	REG_WRITE(ah, AR_NDP_PERIOD, TU_TO_USEC(beacon_period));
+	REG_WRITE(ah, AR_BEACON_PERIOD, beacon_period);
+	REG_WRITE(ah, AR_DMA_BEACON_PERIOD, beacon_period);
+	REG_WRITE(ah, AR_SWBA_PERIOD, beacon_period);
+	REG_WRITE(ah, AR_NDP_PERIOD, beacon_period);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-	beacon_period &= ~ATH9K_BEACON_ENA;
-	if (beacon_period & ATH9K_BEACON_RESET_TSF) {
-		ath9k_hw_reset_tsf(ah);
-	}
-
 	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
 }
 EXPORT_SYMBOL(ath9k_hw_beaconinit);
@@ -2395,10 +2384,11 @@ static u32 rightmost_index(struct ath_gen_timer_table *timer_table, u32 *mask)
 	return timer_table->gen_timer_index[b];
 }
 
-static u32 ath9k_hw_gettsf32(struct ath_hw *ah)
+u32 ath9k_hw_gettsf32(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_TSF_L32);
 }
+EXPORT_SYMBOL(ath9k_hw_gettsf32);
 
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3d9fc6e..c819973 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -416,8 +416,6 @@ struct ath9k_beacon_state {
 	u32 bs_nextdtim;
 	u32 bs_intval;
 #define ATH9K_BEACON_PERIOD       0x0000ffff
-#define ATH9K_BEACON_ENA          0x00800000
-#define ATH9K_BEACON_RESET_TSF    0x01000000
 #define ATH9K_TSFOOR_THRESHOLD    0x00004240 /* 16k us */
 	u32 bs_dtimperiod;
 	u16 bs_cfpperiod;
@@ -930,6 +928,7 @@ void ath9k_hw_setopmode(struct ath_hw *ah);
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
 void ath9k_hw_setbssidmask(struct ath_hw *ah);
 void ath9k_hw_write_associd(struct ath_hw *ah);
+u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
-- 
1.7.3.2

