Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54032 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZIIXpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:45:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/15] ath9k: use ath_hw for DPRINTF() and debug init/exit
Date: Wed,  9 Sep 2009 19:44:47 -0400
Message-Id: <1252539901-20679-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DPRINTF() is used in hw specific related code, as such
ensure we don't rely on the private driver core ath_softc
struct when calling it. Drivers can then implement their
own DPRINTF() as they see fit.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c         |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c         |   44 ++++----
 drivers/net/wireless/ath/ath9k/beacon.c      |   32 +++---
 drivers/net/wireless/ath/ath9k/btcoex.c      |    8 +-
 drivers/net/wireless/ath/ath9k/calib.c       |  102 +++++++++---------
 drivers/net/wireless/ath/ath9k/debug.c       |   16 ++-
 drivers/net/wireless/ath/ath9k/debug.h       |   15 ++-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   24 ++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   24 ++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   24 ++--
 drivers/net/wireless/ath/ath9k/hw.c          |  120 +++++++++++-----------
 drivers/net/wireless/ath/ath9k/mac.c         |   48 ++++----
 drivers/net/wireless/ath/ath9k/main.c        |  148 +++++++++++++-------------
 drivers/net/wireless/ath/ath9k/phy.c         |   10 +-
 drivers/net/wireless/ath/ath9k/rc.c          |   15 ++-
 drivers/net/wireless/ath/ath9k/recv.c        |   18 ++--
 drivers/net/wireless/ath/ath9k/xmit.c        |   46 ++++----
 17 files changed, 356 insertions(+), 340 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 2ad7d02..41e16ed 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -40,7 +40,7 @@ static bool ath_ahb_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
 
 	pdata = (struct ath9k_platform_data *) pdev->dev.platform_data;
 	if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"%s: flash read failed, offset %08x is out of range\n",
 				__func__, off);
 		return false;
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index a7cbb07..f5cd7da 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -31,7 +31,7 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 		}
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"No more channel states left. Using channel 0\n");
 
 	return 0;
@@ -47,7 +47,7 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			DPRINTF(ah, ATH_DBG_ANI,
 				"level out of range (%u > %u)\n",
 				level,
 				(unsigned)ARRAY_SIZE(ah->totalSizeDesired));
@@ -152,7 +152,7 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(firstep)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			DPRINTF(ah, ATH_DBG_ANI,
 				"level out of range (%u > %u)\n",
 				level,
 				(unsigned) ARRAY_SIZE(firstep));
@@ -174,7 +174,7 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			DPRINTF(ah, ATH_DBG_ANI,
 				"level out of range (%u > %u)\n",
 				level,
 				(unsigned)
@@ -194,23 +194,23 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 	case ATH9K_ANI_PRESENT:
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 			"invalid cmd %u\n", cmd);
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "ANI parameters:\n");
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI, "ANI parameters:\n");
+	DPRINTF(ah, ATH_DBG_ANI,
 		"noiseImmunityLevel=%d, spurImmunityLevel=%d, "
 		"ofdmWeakSigDetectOff=%d\n",
 		aniState->noiseImmunityLevel, aniState->spurImmunityLevel,
 		!aniState->ofdmWeakSigDetectOff);
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"cckWeakSigThreshold=%d, "
 		"firstepLevel=%d, listenTime=%d\n",
 		aniState->cckWeakSigThreshold, aniState->firstepLevel,
 		aniState->listenTime);
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
 		aniState->cycleCount, aniState->ofdmPhyErrCount,
 		aniState->cckPhyErrCount);
@@ -240,7 +240,7 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 
 	if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
 		aniState->ofdmPhyErrBase = 0;
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 			"OFDM Trigger is too high for hw counters\n");
 	} else {
 		aniState->ofdmPhyErrBase =
@@ -248,13 +248,13 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 	}
 	if (aniState->cckTrigHigh > AR_PHY_COUNTMAX) {
 		aniState->cckPhyErrBase = 0;
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 			"CCK Trigger is too high for hw counters\n");
 	} else {
 		aniState->cckPhyErrBase =
 			AR_PHY_COUNTMAX - aniState->cckTrigHigh;
 	}
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"Writing ofdmbase=%u   cckbase=%u\n",
 		aniState->ofdmPhyErrBase,
 		aniState->cckPhyErrBase);
@@ -473,7 +473,7 @@ void ath9k_ani_reset(struct ath_hw *ah)
 
 	if (DO_ANI(ah) && ah->opmode != NL80211_IFTYPE_STATION
 	    && ah->opmode != NL80211_IFTYPE_ADHOC) {
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 			"Reset ANI state opmode %u\n", ah->opmode);
 		ah->stats.ast_ani_reset++;
 
@@ -567,7 +567,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 	if (phyCnt1 < aniState->ofdmPhyErrBase ||
 	    phyCnt2 < aniState->cckPhyErrBase) {
 		if (phyCnt1 < aniState->ofdmPhyErrBase) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			DPRINTF(ah, ATH_DBG_ANI,
 				"phyCnt1 0x%x, resetting "
 				"counter value to 0x%x\n",
 				phyCnt1, aniState->ofdmPhyErrBase);
@@ -577,7 +577,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 				  AR_PHY_ERR_OFDM_TIMING);
 		}
 		if (phyCnt2 < aniState->cckPhyErrBase) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			DPRINTF(ah, ATH_DBG_ANI,
 				"phyCnt2 0x%x, resetting "
 				"counter value to 0x%x\n",
 				phyCnt2, aniState->cckPhyErrBase);
@@ -622,7 +622,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Enable MIB counters\n");
+	DPRINTF(ah, ATH_DBG_ANI, "Enable MIB counters\n");
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
@@ -638,7 +638,7 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 /* Freeze the MIB counters, get the stats and then clear them */
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Disable MIB counters\n");
+	DPRINTF(ah, ATH_DBG_ANI, "Disable MIB counters\n");
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
@@ -660,7 +660,7 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
 	u32 cc = REG_READ(ah, AR_CCCNT);
 
 	if (cycles == 0 || cycles > cc) {
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 			"cycle counter wrap. ExtBusy = 0\n");
 		good = 0;
 	} else {
@@ -762,7 +762,7 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 {
 	int i;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Initialize ANI\n");
+	DPRINTF(ah, ATH_DBG_ANI, "Initialize ANI\n");
 
 	memset(ah->ani, 0, sizeof(ah->ani));
 	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
@@ -784,10 +784,10 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 			AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"Setting OfdmErrBase = 0x%08x\n",
 		ah->ani[0].ofdmPhyErrBase);
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
+	DPRINTF(ah, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
 		ah->ani[0].cckPhyErrBase);
 
 	REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
@@ -801,7 +801,7 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 
 void ath9k_hw_ani_disable(struct ath_hw *ah)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Disabling ANI\n");
+	DPRINTF(ah, ATH_DBG_ANI, "Disabling ANI\n");
 
 	ath9k_hw_disable_mib_counters(ah);
 	REG_WRITE(ah, AR_PHY_ERR_1, 0);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 45c4ea5..6e7a519 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -42,7 +42,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	}
 
 	if (!ath9k_hw_set_txq_props(ah, sc->beacon.beaconq, &qi)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to update h/w beacon queue parameters\n");
 		return 0;
 	} else {
@@ -172,7 +172,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc, ATH_DBG_FATAL, "dma_mapping_error on beaconing\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "dma_mapping_error on beaconing\n");
 		return NULL;
 	}
 
@@ -192,7 +192,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 
 	if (skb && cabq_depth) {
 		if (sc->nvifs > 1) {
-			DPRINTF(sc, ATH_DBG_BEACON,
+			DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 				"Flushing previous cabq traffic\n");
 			ath_draintxq(sc, cabq, false);
 		}
@@ -233,7 +233,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc,
 	/* NB: caller is known to have already stopped tx dma */
 	ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bf->bf_daddr);
 	ath9k_hw_txstart(ah, sc->beacon.beaconq);
-	DPRINTF(sc, ATH_DBG_BEACON, "TXDP%u = %llx (%p)\n",
+	DPRINTF(ah, ATH_DBG_BEACON, "TXDP%u = %llx (%p)\n",
 		sc->beacon.beaconq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
@@ -309,7 +309,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	/* NB: the beacon data buffer must be 32-bit aligned. */
 	skb = ieee80211_beacon_get(sc->hw, vif);
 	if (skb == NULL) {
-		DPRINTF(sc, ATH_DBG_BEACON, "cannot get skb\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_BEACON, "cannot get skb\n");
 		return -ENOMEM;
 	}
 
@@ -333,7 +333,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 		tsfadjust = intval * avp->av_bslot / ATH_BCBUF;
 		avp->tsf_adjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
 
-		DPRINTF(sc, ATH_DBG_BEACON,
+		DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
@@ -349,7 +349,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"dma_mapping_error on beacon alloc\n");
 		return -ENOMEM;
 	}
@@ -405,11 +405,11 @@ void ath_beacon_tasklet(unsigned long data)
 		sc->beacon.bmisscnt++;
 
 		if (sc->beacon.bmisscnt < BSTUCK_THRESH) {
-			DPRINTF(sc, ATH_DBG_BEACON,
+			DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 				"missed %u consecutive beacons\n",
 				sc->beacon.bmisscnt);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
-			DPRINTF(sc, ATH_DBG_BEACON,
+			DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 				"beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
 			ath_reset(sc, false);
@@ -419,7 +419,7 @@ void ath_beacon_tasklet(unsigned long data)
 	}
 
 	if (sc->beacon.bmisscnt != 0) {
-		DPRINTF(sc, ATH_DBG_BEACON,
+		DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 			"resume beacon xmit after %u misses\n",
 			sc->beacon.bmisscnt);
 		sc->beacon.bmisscnt = 0;
@@ -447,7 +447,7 @@ void ath_beacon_tasklet(unsigned long data)
 	vif = sc->beacon.bslot[slot];
 	aphy = sc->beacon.bslot_aphy[slot];
 
-	DPRINTF(sc, ATH_DBG_BEACON,
+	DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
 		slot, tsf, tsftu, intval, vif);
 
@@ -490,7 +490,7 @@ void ath_beacon_tasklet(unsigned long data)
 		 * are still pending on the queue.
 		 */
 		if (!ath9k_hw_stoptxdma(ah, sc->beacon.beaconq)) {
-			DPRINTF(sc, ATH_DBG_FATAL,
+			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 				"beacon queue %u did not stop?\n", sc->beacon.beaconq);
 		}
 
@@ -651,8 +651,8 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	/* TSF out of range threshold fixed at 1 second */
 	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
-	DPRINTF(sc, ATH_DBG_BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
-	DPRINTF(sc, ATH_DBG_BEACON,
+	DPRINTF(sc->sc_ah, ATH_DBG_BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
+	DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
 		bs.bs_bmissthreshold, bs.bs_sleepduration,
 		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
@@ -689,7 +689,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 		nexttbtt += intval;
 	} while (nexttbtt < tsftu);
 
-	DPRINTF(sc, ATH_DBG_BEACON,
+	DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
 		"IBSS nexttbtt %u intval %u (%u)\n",
 		nexttbtt, intval, conf->beacon_interval);
 
@@ -759,7 +759,7 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 		ath_beacon_config_sta(sc, cur_conf);
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_CONFIG,
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
 			"Unsupported beaconing mode\n");
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 55f607b..e19a9c9 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -56,7 +56,7 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	if (time_after(jiffies, btinfo->bt_priority_time +
 			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
 		if (btinfo->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
-			DPRINTF(sc, ATH_DBG_BTCOEX,
+			DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX,
 				"BT priority traffic detected");
 			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
 		} else {
@@ -90,7 +90,7 @@ static void ath_btcoex_bt_stomp(struct ath_softc *sc,
 				      AR_STOMP_NONE_WLAN_WGHT);
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
 		break;
 	}
 
@@ -142,7 +142,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
 
-	DPRINTF(sc, ATH_DBG_BTCOEX, "no stomp timer running \n");
+	DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
 
 	spin_lock_bh(&btinfo->btcoex_lock);
 
@@ -326,7 +326,7 @@ void ath_btcoex_timer_resume(struct ath_softc *sc,
 			     struct ath_btcoex_info *btinfo)
 {
 
-	DPRINTF(sc, ATH_DBG_BTCOEX, "Starting btcoex timers");
+	DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX, "Starting btcoex timers");
 
 	/* make sure duty cycle timer is also stopped when resuming */
 	if (btinfo->hw_timer_enabled)
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 3234995..dfd9565 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -26,7 +26,7 @@
 static bool ath9k_hw_nf_in_range(struct ath_hw *ah, s16 nf)
 {
 	if (nf > ATH9K_NF_TOO_LOW) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"noise floor value detected (%d) is "
 			"lower than what we think is a "
 			"reasonable value (%d)\n",
@@ -98,7 +98,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+	DPRINTF(ah, ATH_DBG_CALIBRATE,
 		"NF calibrated [ctl] [chain 0] is %d\n", nf);
 	nfarray[0] = nf;
 
@@ -112,7 +112,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"NF calibrated [ctl] [chain 1] is %d\n", nf);
 		nfarray[1] = nf;
 
@@ -121,7 +121,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 					AR_PHY_CH2_MINCCA_PWR);
 			if (nf & 0x100)
 				nf = 0 - ((nf ^ 0x1ff) + 1);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"NF calibrated [ctl] [chain 2] is %d\n", nf);
 			nfarray[2] = nf;
 		}
@@ -136,7 +136,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+	DPRINTF(ah, ATH_DBG_CALIBRATE,
 		"NF calibrated [ext] [chain 0] is %d\n", nf);
 	nfarray[3] = nf;
 
@@ -150,7 +150,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"NF calibrated [ext] [chain 1] is %d\n", nf);
 		nfarray[4] = nf;
 
@@ -159,7 +159,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 					AR_PHY_CH2_EXT_MINCCA_PWR);
 			if (nf & 0x100)
 				nf = 0 - ((nf ^ 0x1ff) + 1);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"NF calibrated [ext] [chain 2] is %d\n", nf);
 			nfarray[5] = nf;
 		}
@@ -195,22 +195,22 @@ static void ath9k_hw_setup_calibration(struct ath_hw *ah,
 	switch (currCal->calData->calType) {
 	case IQ_MISMATCH_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"starting IQ Mismatch Calibration\n");
 		break;
 	case ADC_GAIN_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_GAIN);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"starting ADC Gain Calibration\n");
 		break;
 	case ADC_DC_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_PER);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"starting ADC DC Calibration\n");
 		break;
 	case ADC_DC_INIT_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_INIT);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"starting Init ADC DC Calibration\n");
 		break;
 	}
@@ -304,7 +304,7 @@ static void ath9k_hw_iqcal_collect(struct ath_hw *ah)
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
 		ah->totalIqCorrMeas[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
 			ah->cal_samples, i, ah->totalPowerMeasI[i],
 			ah->totalPowerMeasQ[i],
@@ -326,7 +326,7 @@ static void ath9k_hw_adc_gaincal_collect(struct ath_hw *ah)
 		ah->totalAdcQEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
 			ah->cal_samples, i,
@@ -351,7 +351,7 @@ static void ath9k_hw_adc_dccal_collect(struct ath_hw *ah)
 		ah->totalAdcDcOffsetQEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
 			ah->cal_samples, i,
@@ -374,11 +374,11 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		powerMeasQ = ah->totalPowerMeasQ[i];
 		iqCorrMeas = ah->totalIqCorrMeas[i];
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Starting IQ Cal and Correction for Chain %d\n",
 			i);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
 			i, ah->totalIqCorrMeas[i]);
 
@@ -389,11 +389,11 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			iqCorrNeg = 1;
 		}
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
+		DPRINTF(ah, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
 			iqCorrNeg);
 
 		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 128;
@@ -402,13 +402,13 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		if (powerMeasQ != 0) {
 			iCoff = iqCorrMeas / iCoffDenom;
 			qCoff = powerMeasI / qCoffDenom - 64;
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"Chn %d iCoff = 0x%08x\n", i, iCoff);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"Chn %d qCoff = 0x%08x\n", i, qCoff);
 
 			iCoff = iCoff & 0x3f;
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"New: Chn %d iCoff = 0x%08x\n", i, iCoff);
 			if (iqCorrNeg == 0x0)
 				iCoff = 0x40 - iCoff;
@@ -418,7 +418,7 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			else if (qCoff <= -16)
 				qCoff = 16;
 
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
 				i, iCoff, qCoff);
 
@@ -428,7 +428,7 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
 				      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
 				      qCoff);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"IQ Cal and Correction done for Chain %d\n",
 				i);
 		}
@@ -449,19 +449,19 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 		qOddMeasOffset = ah->totalAdcQOddPhase[i];
 		qEvenMeasOffset = ah->totalAdcQEvenPhase[i];
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Starting ADC Gain Cal for Chain %d\n", i);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_odd_i = 0x%08x\n", i,
 			iOddMeasOffset);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_even_i = 0x%08x\n", i,
 			iEvenMeasOffset);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_odd_q = 0x%08x\n", i,
 			qOddMeasOffset);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_even_q = 0x%08x\n", i,
 			qEvenMeasOffset);
 
@@ -473,10 +473,10 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 				((qOddMeasOffset * 32) /
 				 qEvenMeasOffset) & 0x3f;
 
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"Chn %d gain_mismatch_i = 0x%08x\n", i,
 				iGainMismatch);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"Chn %d gain_mismatch_q = 0x%08x\n", i,
 				qGainMismatch);
 
@@ -485,7 +485,7 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 			val |= (qGainMismatch) | (iGainMismatch << 6);
 			REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"ADC Gain Cal done for Chain %d\n", i);
 		}
 	}
@@ -510,19 +510,19 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 		qOddMeasOffset = ah->totalAdcDcOffsetQOddPhase[i];
 		qEvenMeasOffset = ah->totalAdcDcOffsetQEvenPhase[i];
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Starting ADC DC Offset Cal for Chain %d\n", i);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_odd_i = %d\n", i,
 			iOddMeasOffset);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_even_i = %d\n", i,
 			iEvenMeasOffset);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_odd_q = %d\n", i,
 			qOddMeasOffset);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d pwr_meas_even_q = %d\n", i,
 			qEvenMeasOffset);
 
@@ -531,10 +531,10 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 		qDcMismatch = (((qOddMeasOffset - qEvenMeasOffset) * 2) /
 			       numSamples) & 0x1ff;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d dc_offset_mismatch_i = 0x%08x\n", i,
 			iDcMismatch);
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Chn %d dc_offset_mismatch_q = 0x%08x\n", i,
 			qDcMismatch);
 
@@ -543,7 +543,7 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 		val |= (qDcMismatch << 12) | (iDcMismatch << 21);
 		REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"ADC DC Offset Cal done for Chain %d\n", i);
 	}
 
@@ -568,7 +568,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 
 	if (currCal->calState != CAL_DONE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"Calibration state incorrect, %d\n",
 			currCal->calState);
 		return true;
@@ -577,7 +577,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 	if (!ath9k_hw_iscal_supported(ah, currCal->calData->calType))
 		return true;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+	DPRINTF(ah, ATH_DBG_CALIBRATE,
 		"Resetting Cal %d state for channel %u\n",
 		currCal->calData->calType, conf->channel->center_freq);
 
@@ -662,7 +662,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+		DPRINTF(ah, ATH_DBG_CALIBRATE,
 			"NF did not complete in calibration window\n");
 		nf = 0;
 		chan->rawNoiseFloor = nf;
@@ -672,7 +672,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		nf = nfarray[0];
 		if (getNoiseFloorThresh(ah, c->band, &nfThresh)
 		    && nf > nfThresh) {
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"noise floor failed detected; "
 				"detected %d, threshold %d\n",
 				nf, nfThresh);
@@ -877,7 +877,7 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ 0x7838, 0 },
 	};
 
-	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+	DPRINTF(ah, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
 
 	/* PA CAL is not needed for high power solution */
 	if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) ==
@@ -1036,7 +1036,7 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "offset "
+			DPRINTF(ah, ATH_DBG_CALIBRATE, "offset "
 				"calibration failed to complete in "
 				"1ms; noisy ??\n");
 			return false;
@@ -1051,7 +1051,7 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
 	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
 			  0, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "offset calibration "
+		DPRINTF(ah, ATH_DBG_CALIBRATE, "offset calibration "
 				"failed to complete in 1ms; noisy ??\n");
 		return false;
 	}
@@ -1085,7 +1085,7 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		/* Poll for offset calibration complete */
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
 				   0, AH_WAIT_TIMEOUT)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"offset calibration failed to complete in 1ms; "
 				"noisy environment?\n");
 			return false;
@@ -1115,19 +1115,19 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"enabling ADC Gain Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"enabling ADC DC Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ah->iq_caldata);
 			INSERT_CAL(ah, &ah->iq_caldata);
-			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			DPRINTF(ah, ATH_DBG_CALIBRATE,
 				"enabling IQ Calibration.\n");
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 2be4c22..babfd37 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -23,12 +23,12 @@ module_param_named(debug, ath9k_debug, uint, 0);
 
 static struct dentry *ath9k_debugfs_root;
 
-void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
+void DPRINTF(struct ath_hw *ah, int dbg_mask, const char *fmt, ...)
 {
-	if (!sc)
+	if (!ah->ah_sc)
 		return;
 
-	if (sc->debug.debug_mask & dbg_mask) {
+	if (ah->ah_sc->debug.debug_mask & dbg_mask) {
 		va_list args;
 
 		va_start(args, fmt);
@@ -568,8 +568,10 @@ static const struct file_operations fops_xmit = {
 	.owner = THIS_MODULE
 };
 
-int ath9k_init_debug(struct ath_softc *sc)
+int ath9k_init_debug(struct ath_hw *ah)
 {
+	struct ath_softc *sc = ah->ah_sc;
+
 	sc->debug.debug_mask = ath9k_debug;
 
 	if (!ath9k_debugfs_root)
@@ -619,12 +621,14 @@ int ath9k_init_debug(struct ath_softc *sc)
 
 	return 0;
 err:
-	ath9k_exit_debug(sc);
+	ath9k_exit_debug(ah);
 	return -ENOMEM;
 }
 
-void ath9k_exit_debug(struct ath_softc *sc)
+void ath9k_exit_debug(struct ath_hw *ah)
 {
+	struct ath_softc *sc = ah->ah_sc;
+
 	debugfs_remove(sc->debug.debugfs_xmit);
 	debugfs_remove(sc->debug.debugfs_wiphy);
 	debugfs_remove(sc->debug.debugfs_rcstat);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 7241f47..c9c1aac 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -17,6 +17,8 @@
 #ifndef DEBUG_H
 #define DEBUG_H
 
+#include "hw.h"
+
 enum ATH_DEBUG {
 	ATH_DBG_RESET		= 0x00000001,
 	ATH_DBG_QUEUE		= 0x00000002,
@@ -151,9 +153,10 @@ struct ath9k_debug {
 	struct ath_stats stats;
 };
 
-void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
-int ath9k_init_debug(struct ath_softc *sc);
-void ath9k_exit_debug(struct ath_softc *sc);
+void DPRINTF(struct ath_hw *ah, int dbg_mask, const char *fmt, ...);
+int ath9k_init_debug(struct ath_hw *ah);
+void ath9k_exit_debug(struct ath_hw *ah);
+
 int ath9k_debug_create_root(void);
 void ath9k_debug_remove_root(void);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
@@ -165,17 +168,17 @@ void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 
 #else
 
-static inline void DPRINTF(struct ath_softc *sc, int dbg_mask,
+static inline void DPRINTF(struct ath_hw *ah, int dbg_mask,
 			   const char *fmt, ...)
 {
 }
 
-static inline int ath9k_init_debug(struct ath_softc *sc)
+static inline int ath9k_init_debug(struct ath_hw *ah)
 {
 	return 0;
 }
 
-static inline void ath9k_exit_debug(struct ath_softc *sc)
+static inline void ath9k_exit_debug(struct ath_hw *ah)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index b8eca7b..0675cd5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -35,13 +35,13 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 	eep_start_loc = 64;
 
 	if (!ath9k_hw_use_flash(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"Reading from EEPROM, not flash\n");
 	}
 
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			DPRINTF(ah, ATH_DBG_EEPROM,
 			       "Unable to read eeprom region \n");
 			return false;
 		}
@@ -66,12 +66,12 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 	if (!ath9k_hw_use_flash(ah)) {
 		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
 					 &magic)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Reading Magic # failed\n");
 			return false;
 		}
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
@@ -87,7 +87,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 					eepdata++;
 				}
 			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				DPRINTF(ah, ATH_DBG_FATAL,
 					"Invalid EEPROM Magic. "
 					"endianness mismatch.\n");
 				return -EINVAL;
@@ -95,7 +95,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n",
+	DPRINTF(ah, ATH_DBG_EEPROM, "need_swap = %s.\n",
 		need_swap ? "True" : "False");
 
 	if (need_swap)
@@ -117,7 +117,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		u32 integer;
 		u16 word;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"EEPROM Endianness is not native.. Changing\n");
 
 		word = swab16(eep->baseEepHeader.length);
@@ -160,7 +160,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
 	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
@@ -470,11 +470,11 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 					((pdadcValues[4 * j + 3] & 0xFF) << 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah, ATH_DBG_EEPROM,
 					"PDADC (%d,%4x): %4.4x %8.8x\n",
 					i, regChainOffset, regOffset,
 					reg32);
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah, ATH_DBG_EEPROM,
 					"PDADC: Chain %d | "
 					"PDADC %3d Value %3d | "
 					"PDADC %3d Value %3d | "
@@ -1151,7 +1151,7 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 
 	u16 spur_val = AR_NO_SPUR;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"Getting spur idx %d is2Ghz. %d val %x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
@@ -1160,7 +1160,7 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 			"Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index c20c21a..c6a4325 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -34,14 +34,14 @@ static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 	eep_data = (u16 *)eep;
 
 	if (!ath9k_hw_use_flash(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"Reading from EEPROM, not flash\n");
 	}
 
 	for (addr = 0; addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
 			addr++)	{
 		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			DPRINTF(ah, ATH_DBG_EEPROM,
 				"Unable to read eeprom region \n");
 			return false;
 		}
@@ -61,12 +61,12 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	if (!ath9k_hw_use_flash(ah)) {
 		if (!ath9k_hw_nvram_read
 		    (ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Reading Magic # failed\n");
 			return false;
 		}
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 				"Read Magic = 0x%04X\n", magic);
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -83,14 +83,14 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 					eepdata++;
 				}
 			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				DPRINTF(ah, ATH_DBG_FATAL,
 					"Invalid EEPROM Magic. "
 					"endianness mismatch.\n");
 				return -EINVAL;
 			}
 		}
 	}
-	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n", need_swap ?
+	DPRINTF(ah, ATH_DBG_EEPROM, "need_swap = %s.\n", need_swap ?
 		"True" : "False");
 
 	if (need_swap)
@@ -148,7 +148,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR9287_EEP_VER
 	    || ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			 sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
@@ -564,12 +564,12 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 						  & 0xFF) << 24) ;
 					REG_WRITE(ah, regOffset, reg32);
 
-					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+					DPRINTF(ah, ATH_DBG_EEPROM,
 						"PDADC (%d,%4x): %4.4x %8.8x\n",
 						i, regChainOffset, regOffset,
 						reg32);
 
-					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+					DPRINTF(ah, ATH_DBG_EEPROM,
 						"PDADC: Chain %d | "
 						"PDADC %3d Value %3d | "
 						"PDADC %3d Value %3d | "
@@ -966,7 +966,7 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 			INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"Invalid chainmask configuration\n");
 		break;
 	}
@@ -1140,7 +1140,7 @@ static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
 	(ah->eeprom.map9287.modalHeader.spurChans[i].spurChan)
 	u16 spur_val = AR_NO_SPUR;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"Getting spur idx %d is2Ghz. %d val %x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
@@ -1149,7 +1149,7 @@ static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 		       "Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index ae7fb5d..f152ff3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -95,7 +95,7 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
 					 eep_data)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Unable to read eeprom region\n");
 			return false;
 		}
@@ -115,12 +115,12 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	int i, addr, size;
 
 	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Reading Magic # failed\n");
+		DPRINTF(ah, ATH_DBG_FATAL, "Reading Magic # failed\n");
 		return false;
 	}
 
 	if (!ath9k_hw_use_flash(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
@@ -137,7 +137,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 					eepdata++;
 				}
 			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				DPRINTF(ah, ATH_DBG_FATAL,
 					"Invalid EEPROM Magic. "
 					"Endianness mismatch.\n");
 				return -EINVAL;
@@ -145,7 +145,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n",
+	DPRINTF(ah, ATH_DBG_EEPROM, "need_swap = %s.\n",
 		need_swap ? "True" : "False");
 
 	if (need_swap)
@@ -167,7 +167,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		u32 integer, j;
 		u16 word;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"EEPROM Endianness is not native.. Changing.\n");
 
 		word = swab16(eep->baseEepHeader.length);
@@ -214,7 +214,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
 	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
@@ -868,11 +868,11 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 					((pdadcValues[4 * j + 3] & 0xFF) << 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah, ATH_DBG_EEPROM,
 					"PDADC (%d,%4x): %4.4x %8.8x\n",
 					i, regChainOffset, regOffset,
 					reg32);
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah, ATH_DBG_EEPROM,
 					"PDADC: Chain %d | PDADC %3d "
 					"Value %3d | PDADC %3d Value %3d | "
 					"PDADC %3d Value %3d | PDADC %3d "
@@ -1309,7 +1309,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah, ATH_DBG_EEPROM,
 			"Invalid chainmask configuration\n");
 		break;
 	}
@@ -1350,7 +1350,7 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 
 	u16 spur_val = AR_NO_SPUR;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+	DPRINTF(ah, ATH_DBG_ANI,
 		"Getting spur idx %d is2Ghz. %d val %x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
@@ -1359,7 +1359,7 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		DPRINTF(ah, ATH_DBG_ANI,
 			"Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b6c6cca..39431c3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -126,7 +126,7 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 		udelay(AH_TIME_QUANTUM);
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+	DPRINTF(ah, ATH_DBG_ANY,
 		"timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
 		timeout, reg, REG_READ(ah, reg), mask, val);
 
@@ -210,7 +210,7 @@ u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 		}
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unknown phy %u (rate ix %u)\n",
 			rates->info[rateix].phy, rateix);
 		txTime = 0;
@@ -335,7 +335,7 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (rdData != wrData) {
-				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				DPRINTF(ah, ATH_DBG_FATAL,
 					"address test failed "
 					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 					addr, wrData, rdData);
@@ -347,7 +347,7 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (wrData != rdData) {
-				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				DPRINTF(ah, ATH_DBG_FATAL,
 					"address test failed "
 					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 					addr, wrData, rdData);
@@ -472,7 +472,7 @@ static int ath9k_hw_rfattach(struct ath_hw *ah)
 
 	rfStatus = ath9k_hw_init_rf(ah, &ecode);
 	if (!rfStatus) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"RF setup failed, status: %u\n", ecode);
 		return ecode;
 	}
@@ -497,7 +497,7 @@ static int ath9k_hw_rf_claim(struct ath_hw *ah)
 	case AR_RAD2122_SREV_MAJOR:
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Radio Chip Rev 0x%02X not supported\n",
 			val & AR_RADIO_SREV_MAJOR);
 		return -EOPNOTSUPP;
@@ -590,7 +590,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	if (ecode != 0)
 		return ecode;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_CONFIG, "Eeprom VER: %d, REV: %d\n",
+	DPRINTF(ah, ATH_DBG_CONFIG, "Eeprom VER: %d, REV: %d\n",
 		ah->eep_ops->get_eeprom_ver(ah), ah->eep_ops->get_eeprom_rev(ah));
 
 	ecode = ath9k_hw_rfattach(ah);
@@ -914,12 +914,12 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_config(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
+		DPRINTF(ah, ATH_DBG_FATAL, "Couldn't reset chip\n");
 		return -EIO;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
+		DPRINTF(ah, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
 		return -EIO;
 	}
 
@@ -934,11 +934,11 @@ int ath9k_hw_init(struct ath_hw *ah)
 		}
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
+	DPRINTF(ah, ATH_DBG_RESET, "serialize_regmode is %d\n",
 		ah->config.serialize_regmode);
 
 	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
 			ah->hw_version.macRev);
@@ -979,7 +979,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Failed to initialize MAC address\n");
 		return r;
 	}
@@ -1164,7 +1164,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
 {
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad ack timeout %u\n", us);
+		DPRINTF(ah, ATH_DBG_RESET, "bad ack timeout %u\n", us);
 		ah->acktimeout = (u32) -1;
 		return false;
 	} else {
@@ -1178,7 +1178,7 @@ static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
 static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 {
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad cts timeout %u\n", us);
+		DPRINTF(ah, ATH_DBG_RESET, "bad cts timeout %u\n", us);
 		ah->ctstimeout = (u32) -1;
 		return false;
 	} else {
@@ -1192,7 +1192,7 @@ static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 {
 	if (tu > 0xFFFF) {
-		DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
+		DPRINTF(ah, ATH_DBG_XMIT,
 			"bad global tx timeout %u\n", tu);
 		ah->globaltxtimeout = (u32) -1;
 		return false;
@@ -1205,7 +1205,7 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 
 static void ath9k_hw_init_user_settings(struct ath_hw *ah)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
+	DPRINTF(ah, ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
 		ah->misc_mode);
 
 	if (ah->misc_mode != 0)
@@ -1293,23 +1293,23 @@ static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
 	switch (ah->hw_version.devid) {
 	case AR9280_DEVID_PCI:
 		if (reg == 0x7894) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			DPRINTF(ah, ATH_DBG_EEPROM,
 				"ini VAL: %x  EEPROM: %x\n", value,
 				(pBase->version & 0xff));
 
 			if ((pBase->version & 0xff) > 0x0a) {
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah, ATH_DBG_EEPROM,
 					"PWDCLKIND: %d\n",
 					pBase->pwdclkind);
 				value &= ~AR_AN_TOP2_PWDCLKIND;
 				value |= AR_AN_TOP2_PWDCLKIND &
 					(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
 			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah, ATH_DBG_EEPROM,
 					"PWDCLKIND Earlier Rev\n");
 			}
 
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			DPRINTF(ah, ATH_DBG_EEPROM,
 				"final ini VAL: %x\n", value);
 		}
 		break;
@@ -1482,7 +1482,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 				 (u32) regulatory->power_limit));
 
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"ar5416SetRfRegs failed\n");
 		return -EIO;
 	}
@@ -1688,7 +1688,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 
 	REG_WRITE(ah, AR_RTC_RC, 0);
 	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+		DPRINTF(ah, ATH_DBG_RESET,
 			"RTC stuck in MAC reset\n");
 		return false;
 	}
@@ -1725,7 +1725,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 			   AR_RTC_STATUS_M,
 			   AR_RTC_STATUS_ON,
 			   AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "RTC not waking up\n");
+		DPRINTF(ah, ATH_DBG_RESET, "RTC not waking up\n");
 		return false;
 	}
 
@@ -1810,7 +1810,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
+			DPRINTF(ah, ATH_DBG_QUEUE,
 				"Transmit frames pending on queue %d\n", qnum);
 			return false;
 		}
@@ -1819,7 +1819,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
 	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
 			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Could not kill baseband RX\n");
 		return false;
 	}
@@ -1830,7 +1830,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		ath9k_hw_ar9280_set_channel(ah, chan);
 	} else {
 		if (!(ath9k_hw_set_channel(ah, chan))) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Failed to set channel\n");
 			return false;
 		}
@@ -2386,7 +2386,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	if (!ath9k_hw_chip_reset(ah, chan)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Chip reset failed\n");
+		DPRINTF(ah, ATH_DBG_FATAL, "Chip reset failed\n");
 		return -EINVAL;
 	}
 
@@ -2540,13 +2540,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		u32 mask;
 		mask = REG_READ(ah, AR_CFG);
 		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+			DPRINTF(ah, ATH_DBG_RESET,
 				"CFG Byte Swap Set 0x%x\n", mask);
 		} else {
 			mask =
 				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
 			REG_WRITE(ah, AR_CFG, mask);
-			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+			DPRINTF(ah, ATH_DBG_RESET,
 				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
 		}
 	} else {
@@ -2574,7 +2574,7 @@ bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 	u32 keyType;
 
 	if (entry >= ah->caps.keycache_size) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"keychache entry %u out of range\n", entry);
 		return false;
 	}
@@ -2608,7 +2608,7 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 	u32 macHi, macLo;
 
 	if (entry >= ah->caps.keycache_size) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"keychache entry %u out of range\n", entry);
 		return false;
 	}
@@ -2640,7 +2640,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 	u32 keyType;
 
 	if (entry >= pCap->keycache_size) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"keycache entry %u out of range\n", entry);
 		return false;
 	}
@@ -2651,7 +2651,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		break;
 	case ATH9K_CIPHER_AES_CCM:
 		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			DPRINTF(ah, ATH_DBG_ANY,
 				"AES-CCM not supported by mac rev 0x%x\n",
 				ah->hw_version.macRev);
 			return false;
@@ -2662,14 +2662,14 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_TKIP;
 		if (ATH9K_IS_MIC_ENABLED(ah)
 		    && entry + 64 >= pCap->keycache_size) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			DPRINTF(ah, ATH_DBG_ANY,
 				"entry %u inappropriate for TKIP\n", entry);
 			return false;
 		}
 		break;
 	case ATH9K_CIPHER_WEP:
 		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			DPRINTF(ah, ATH_DBG_ANY,
 				"WEP key length %u too small\n", k->kv_len);
 			return false;
 		}
@@ -2684,7 +2684,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_CLR;
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"cipher %u not supported\n", k->kv_type);
 		return false;
 	}
@@ -2902,7 +2902,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 				    AR_RTC_FORCE_WAKE_EN);
 		}
 		if (i == 0) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Failed to wakeup in %uus\n", POWER_UP_TIME / 20);
 			return false;
 		}
@@ -2927,7 +2927,7 @@ static bool ath9k_hw_setpower_nolock(struct ath_hw *ah,
 	if (ah->power_mode == mode)
 		return status;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s -> %s\n",
+	DPRINTF(ah, ATH_DBG_RESET, "%s -> %s\n",
 		modes[ah->power_mode], modes[mode]);
 
 	switch (mode) {
@@ -2942,7 +2942,7 @@ static bool ath9k_hw_setpower_nolock(struct ath_hw *ah,
 		ath9k_set_power_network_sleep(ah, setChip);
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unknown power mode %u\n", mode);
 		return false;
 	}
@@ -3201,7 +3201,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 		}
 
 		if (isr & AR_ISR_RXORN) {
-			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
+			DPRINTF(ah, ATH_DBG_INTERRUPT,
 				"receive FIFO overrun interrupt\n");
 		}
 
@@ -3244,24 +3244,24 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 
 		if (fatal_int) {
 			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
-				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+				DPRINTF(ah, ATH_DBG_ANY,
 					"received PCI FATAL interrupt\n");
 			}
 			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
-				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+				DPRINTF(ah, ATH_DBG_ANY,
 					"received PCI PERR interrupt\n");
 			}
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
-			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
+			DPRINTF(ah, ATH_DBG_INTERRUPT,
 				"AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
-			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
+			DPRINTF(ah, ATH_DBG_INTERRUPT,
 				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
 		}
 
@@ -3278,10 +3278,10 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	u32 mask, mask2;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
+	DPRINTF(ah, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
 	if (omask & ATH9K_INT_GLOBAL) {
-		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "disable IER\n");
+		DPRINTF(ah, ATH_DBG_INTERRUPT, "disable IER\n");
 		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
 		(void) REG_READ(ah, AR_IER);
 		if (!AR_SREV_9100(ah)) {
@@ -3338,7 +3338,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			mask2 |= AR_IMR_S2_CST;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
+	DPRINTF(ah, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
 	REG_WRITE(ah, AR_IMR, mask);
 	mask = REG_READ(ah, AR_IMR_S2) & ~(AR_IMR_S2_TIM |
 					   AR_IMR_S2_DTIM |
@@ -3358,7 +3358,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	}
 
 	if (ints & ATH9K_INT_GLOBAL) {
-		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "enable IER\n");
+		DPRINTF(ah, ATH_DBG_INTERRUPT, "enable IER\n");
 		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
 		if (!AR_SREV_9100(ah)) {
 			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
@@ -3371,7 +3371,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			REG_WRITE(ah, AR_INTR_SYNC_MASK,
 				  AR_INTR_SYNC_DEFAULT);
 		}
-		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
+		DPRINTF(ah, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
 			 REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
 	}
 
@@ -3419,7 +3419,7 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_BEACON,
+		DPRINTF(ah, ATH_DBG_BEACON,
 			"%s: unsupported opmode: %d\n",
 			__func__, ah->opmode);
 		return;
@@ -3470,10 +3470,10 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	else
 		nextTbtt = bs->bs_nexttbtt;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
+	DPRINTF(ah, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
+	DPRINTF(ah, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
+	DPRINTF(ah, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
+	DPRINTF(ah, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
 
 	REG_WRITE(ah, AR_NEXT_DTIM,
 		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
@@ -3531,7 +3531,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			regulatory->current_rd += 5;
 		else if (regulatory->current_rd == 0x41)
 			regulatory->current_rd = 0x43;
-		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+		DPRINTF(ah, ATH_DBG_REGULATORY,
 			"regdomain mapped to 0x%x\n", regulatory->current_rd);
 	}
 
@@ -4063,7 +4063,7 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 	ath9k_ps_wakeup(ah->ah_sc);
 	if (!ath9k_hw_wait(ah, AR_SLP32_MODE, AR_SLP32_TSF_WRITE_STATUS, 0,
 			   AH_TSF_WRITE_TIMEOUT))
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+		DPRINTF(ah, ATH_DBG_RESET,
 			"AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
 
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
@@ -4081,7 +4081,7 @@ void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
 	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad slot time %u\n", us);
+		DPRINTF(ah, ATH_DBG_RESET, "bad slot time %u\n", us);
 		ah->slottime = (u32) -1;
 		return false;
 	} else {
@@ -4194,7 +4194,7 @@ void ath_gen_timer_start(struct ath_hw *ah,
 
 	tsf = ath9k_hw_gettsf32(ah);
 
-	DPRINTF(ah->ah_sc, ATH_DBG_HWTIMER, "curent tsf %x period %x"
+	DPRINTF(ah, ATH_DBG_HWTIMER, "curent tsf %x period %x"
 		"timer_next %x\n", tsf, timer_period, timer_next);
 
 	/*
@@ -4284,7 +4284,7 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &thresh_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		DPRINTF(ah->ah_sc, ATH_DBG_HWTIMER,
+		DPRINTF(ah, ATH_DBG_HWTIMER,
 			"TSF overflow for Gen timer %d\n", index);
 		timer->overflow(timer->arg);
 	}
@@ -4293,7 +4293,7 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &trigger_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		DPRINTF(ah->ah_sc, ATH_DBG_HWTIMER,
+		DPRINTF(ah, ATH_DBG_HWTIMER,
 			"Gen timer[%d] trigger\n", index);
 		timer->trigger(timer->arg);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 800bfab..b4d2f20 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -19,7 +19,7 @@
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
+	DPRINTF(ah, ATH_DBG_INTERRUPT,
 		"tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
 		ah->txok_interrupt_mask, ah->txerr_interrupt_mask,
 		ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
@@ -47,7 +47,7 @@ void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Enable TXE on queue: %u\n", q);
+	DPRINTF(ah, ATH_DBG_QUEUE, "Enable TXE on queue: %u\n", q);
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 }
 
@@ -105,14 +105,14 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Stopping TX DMA, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Stopping TX DMA, "
 			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Stopping TX DMA, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Stopping TX DMA, "
 			"inactive queue: %u\n", q);
 		return false;
 	}
@@ -126,7 +126,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 	}
 
 	if (ath9k_hw_numtxpending(ah, q)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
+		DPRINTF(ah, ATH_DBG_QUEUE,
 			"%s: Num of pending TX Frames %d on Q %d\n",
 			__func__, ath9k_hw_numtxpending(ah, q), q);
 
@@ -142,7 +142,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 			if ((REG_READ(ah, AR_TSF_L32) >> 10) == (tsfLow >> 10))
 				break;
 
-			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
+			DPRINTF(ah, ATH_DBG_QUEUE,
 				"TSF has moved while trying to set "
 				"quiet time TSF: 0x%08x\n", tsfLow);
 		}
@@ -155,7 +155,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 		wait = wait_time;
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
-				DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
+				DPRINTF(ah, ATH_DBG_QUEUE,
 					"Failed to stop TX DMA in 100 "
 					"msec after killing last frame\n");
 				break;
@@ -449,19 +449,19 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Set TXQ properties, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Set TXQ properties, "
 			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Set TXQ properties, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Set TXQ properties, "
 			"inactive queue: %u\n", q);
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Set queue properties for: %u\n", q);
+	DPRINTF(ah, ATH_DBG_QUEUE, "Set queue properties for: %u\n", q);
 
 	qi->tqi_ver = qinfo->tqi_ver;
 	qi->tqi_subtype = qinfo->tqi_subtype;
@@ -518,14 +518,14 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Get TXQ properties, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Get TXQ properties, "
 			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Get TXQ properties, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Get TXQ properties, "
 			"inactive queue: %u\n", q);
 		return false;
 	}
@@ -574,22 +574,22 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
 		if (q == pCap->total_queues) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"No available TX queue\n");
 			return -1;
 		}
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Invalid TX queue type: %u\n",
+		DPRINTF(ah, ATH_DBG_FATAL, "Invalid TX queue type: %u\n",
 			type);
 		return -1;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Setup TX queue: %u\n", q);
+	DPRINTF(ah, ATH_DBG_QUEUE, "Setup TX queue: %u\n", q);
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"TX queue: %u already active\n", q);
 		return -1;
 	}
@@ -620,18 +620,18 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Release TXQ, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Release TXQ, "
 			"invalid queue: %u\n", q);
 		return false;
 	}
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Release TXQ, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Release TXQ, "
 			"inactive queue: %u\n", q);
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Release TX queue: %u\n", q);
+	DPRINTF(ah, ATH_DBG_QUEUE, "Release TX queue: %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
 	ah->txok_interrupt_mask &= ~(1 << q);
@@ -652,19 +652,19 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	u32 cwMin, chanCwMin, value;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Reset TXQ, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Reset TXQ, "
 			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Reset TXQ, "
+		DPRINTF(ah, ATH_DBG_QUEUE, "Reset TXQ, "
 			"inactive queue: %u\n", q);
 		return true;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Reset TX queue: %u\n", q);
+	DPRINTF(ah, ATH_DBG_QUEUE, "Reset TX queue: %u\n", q);
 
 	if (qi->tqi_cwmin == ATH9K_TXQ_USEDEFAULT) {
 		if (chan && IS_CHAN_B(chan))
@@ -911,7 +911,7 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 				     AR_DIAG_RX_ABORT));
 
 			reg = REG_READ(ah, AR_OBS_BUS_1);
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"RX failed to go idle in 10 ms RXSM=0x%x\n", reg);
 
 			return false;
@@ -967,7 +967,7 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 	}
 
 	if (i == 0) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"DMA failed to stop in %d ms "
 			"AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
 			AH_RX_STOP_DMA_TIMEOUT / 1000,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3dc7b5a..5e05e1d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -224,7 +224,7 @@ static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 		}
 		sband->n_bitrates++;
 
-		DPRINTF(sc, ATH_DBG_CONFIG, "Rate: %2dMbps, ratecode: %2d\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Rate: %2dMbps, ratecode: %2d\n",
 			rate[i].bitrate / 10, rate[i].hw_value);
 	}
 }
@@ -280,7 +280,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
 		fastcc = false;
 
-	DPRINTF(sc, ATH_DBG_CONFIG,
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
 		"(%u MHz) -> (%u MHz), chanwidth: %d\n",
 		sc->sc_ah->curchan->channel,
 		channel->center_freq, sc->tx_chan_width);
@@ -289,7 +289,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	r = ath9k_hw_reset(ah, hchan, fastcc);
 	if (r) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to reset channel (%u Mhz) "
 			"reset status %d\n",
 			channel->center_freq, r);
@@ -301,7 +301,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	sc->sc_flags &= ~SC_OP_FULL_RESET;
 
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to restart recv logic\n");
 		r = -EIO;
 		goto ps_restore;
@@ -353,7 +353,7 @@ static void ath_ani_calibrate(unsigned long data)
 	/* Long calibration runs independently of short calibration. */
 	if ((timestamp - sc->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
 		longcal = true;
-		DPRINTF(sc, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
+		DPRINTF(sc->sc_ah, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
 		sc->ani.longcal_timer = timestamp;
 	}
 
@@ -361,7 +361,7 @@ static void ath_ani_calibrate(unsigned long data)
 	if (!sc->ani.caldone) {
 		if ((timestamp - sc->ani.shortcal_timer) >= short_cal_interval) {
 			shortcal = true;
-			DPRINTF(sc, ATH_DBG_ANI, "shortcal @%lu\n", jiffies);
+			DPRINTF(sc->sc_ah, ATH_DBG_ANI, "shortcal @%lu\n", jiffies);
 			sc->ani.shortcal_timer = timestamp;
 			sc->ani.resetcal_timer = timestamp;
 		}
@@ -395,7 +395,7 @@ static void ath_ani_calibrate(unsigned long data)
 				sc->ani.noise_floor = ath9k_hw_getchan_noise(ah,
 								     ah->curchan);
 
-			DPRINTF(sc, ATH_DBG_ANI," calibrate chan %u/%x nf: %d\n",
+			DPRINTF(sc->sc_ah, ATH_DBG_ANI," calibrate chan %u/%x nf: %d\n",
 				ah->curchan->channel, ah->curchan->channelFlags,
 				sc->ani.noise_floor);
 		}
@@ -448,7 +448,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 		sc->rx_chainmask = 1;
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "tx chmask: %d, rx chmask: %d\n",
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "tx chmask: %d, rx chmask: %d\n",
 		sc->tx_chainmask, sc->rx_chainmask);
 }
 
@@ -502,7 +502,7 @@ static void ath9k_tasklet(unsigned long data)
 		 * TSF sync does not look correct; remain awake to sync with
 		 * the next Beacon.
 		 */
-		DPRINTF(sc, ATH_DBG_PS, "TSFOOR - Sync with next Beacon\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_PS, "TSFOOR - Sync with next Beacon\n");
 		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
 	}
 
@@ -702,7 +702,7 @@ static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
 	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
 	if (!ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, NULL)) {
 		/* TX MIC entry failed. No need to proceed further */
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Setting TX MIC Key Failed\n");
 		return 0;
 	}
@@ -907,7 +907,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 	rx_streams = !(sc->rx_chainmask & (sc->rx_chainmask - 1)) ? 1 : 2;
 
 	if (tx_streams != rx_streams) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "TX streams %d, RX streams: %d\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "TX streams %d, RX streams: %d\n",
 			tx_streams, rx_streams);
 		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
 		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
@@ -927,7 +927,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 {
 
 	if (bss_conf->assoc) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
 			bss_conf->aid, sc->curbssid);
 
 		/* New association, store aid */
@@ -949,7 +949,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		ath_start_ani(sc);
 	} else {
-		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		sc->curaid = 0;
 		/* Stop ANI */
 		del_timer_sync(&sc->ani.timer);
@@ -1042,7 +1042,7 @@ static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
 
 	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
 	if (ret)
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Failed to register led:%s", led->name);
 	else
 		led->registered = 1;
@@ -1139,7 +1139,7 @@ void ath_radio_enable(struct ath_softc *sc)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) ",
 			"reset status %d\n",
 			channel->center_freq, r);
@@ -1148,7 +1148,7 @@ void ath_radio_enable(struct ath_softc *sc)
 
 	ath_update_txpow(sc);
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to restart recv logic\n");
 		return;
 	}
@@ -1194,7 +1194,7 @@ void ath_radio_disable(struct ath_softc *sc)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
 			"reset status %d\n",
 			channel->center_freq, r);
@@ -1253,11 +1253,12 @@ void ath_cleanup(struct ath_softc *sc)
 void ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
+	struct ath_hw *ah = sc->sc_ah;
 	int i = 0;
 
 	ath9k_ps_wakeup(sc);
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
+	dev_dbg(sc->dev, "Detach ATH hw\n");
 
 	ath_deinit_leds(sc);
 
@@ -1277,7 +1278,7 @@ void ath_detach(struct ath_softc *sc)
 	tasklet_kill(&sc->bcon_tasklet);
 
 	if (!(sc->sc_flags & SC_OP_INVALID))
-		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+		ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
 
 	/* cleanup tx queues */
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
@@ -1286,11 +1287,11 @@ void ath_detach(struct ath_softc *sc)
 
 	if ((sc->btcoex_info.no_stomp_timer) &&
 	    sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-		ath_gen_timer_free(sc->sc_ah, sc->btcoex_info.no_stomp_timer);
+		ath_gen_timer_free(ah, sc->btcoex_info.no_stomp_timer);
 
-	ath9k_hw_detach(sc->sc_ah);
+	ath9k_hw_detach(ah);
+	ath9k_exit_debug(sc->sc_ah);
 	sc->sc_ah = NULL;
-	ath9k_exit_debug(sc);
 }
 
 static int ath9k_reg_notifier(struct wiphy *wiphy,
@@ -1319,9 +1320,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	/* XXX: hardware will not be ready until ath_open() being called */
 	sc->sc_flags |= SC_OP_INVALID;
 
-	if (ath9k_init_debug(sc) < 0)
-		printk(KERN_ERR "Unable to create debugfs files\n");
-
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
@@ -1351,9 +1349,12 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
 
+	if (ath9k_init_debug(ah) < 0)
+		dev_err(sc->dev, "Unable to create debugfs files\n");
+
 	r = ath9k_hw_init(ah);
 	if (r) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to initialize hardware; "
 			"initialization status: %d\n", r);
 		goto bad;
@@ -1362,7 +1363,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	/* Get the hardware key cache size. */
 	sc->keymax = ah->caps.keycache_size;
 	if (sc->keymax > ATH_KEYMAX) {
-		DPRINTF(sc, ATH_DBG_ANY,
+		DPRINTF(ah, ATH_DBG_ANY,
 			"Warning, using only %u entries in %u key cache\n",
 			ATH_KEYMAX, sc->keymax);
 		sc->keymax = ATH_KEYMAX;
@@ -1392,14 +1393,14 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	 */
 	sc->beacon.beaconq = ath_beaconq_setup(ah);
 	if (sc->beacon.beaconq == -1) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to setup a beacon xmit queue\n");
 		r = -EIO;
 		goto bad2;
 	}
 	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 	if (sc->beacon.cabq == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to setup CAB xmit queue\n");
 		r = -EIO;
 		goto bad2;
@@ -1414,26 +1415,26 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	/* Setup data queues */
 	/* NB: ensure BK queue is the lowest priority h/w queue */
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for BK traffic\n");
 		r = -EIO;
 		goto bad2;
 	}
 
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for BE traffic\n");
 		r = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for VI traffic\n");
 		r = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for VO traffic\n");
 		r = -EIO;
 		goto bad2;
@@ -1533,9 +1534,9 @@ bad2:
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 bad:
 	ath9k_hw_detach(ah);
-	sc->sc_ah = NULL;
 bad_no_ah:
-	ath9k_exit_debug(sc);
+	ath9k_exit_debug(sc->sc_ah);
+	sc->sc_ah = NULL;
 
 	return r;
 }
@@ -1581,18 +1582,21 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid)
 {
 	struct ieee80211_hw *hw = sc->hw;
+	struct ath_hw *ah;
 	int error = 0, i;
 	struct ath_regulatory *reg;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
+	dev_dbg(sc->dev, "Attach ATH hw\n");
 
 	error = ath_init_softc(devid, sc, subsysid);
 	if (error != 0)
 		return error;
 
+	ah = sc->sc_ah;
+
 	/* get mac address from hardware and set in mac80211 */
 
-	SET_IEEE80211_PERM_ADDR(hw, sc->sc_ah->macaddr);
+	SET_IEEE80211_PERM_ADDR(hw, ah->macaddr);
 
 	ath_set_hw_capab(sc, hw);
 
@@ -1603,9 +1607,9 @@ int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid)
 
 	reg = &sc->common.regulatory;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
+		if (test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes))
 			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
@@ -1643,9 +1647,9 @@ error_attach:
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	ath9k_hw_detach(sc->sc_ah);
+	ath9k_hw_detach(ah);
+	ath9k_exit_debug(ah);
 	sc->sc_ah = NULL;
-	ath9k_exit_debug(sc);
 
 	return error;
 }
@@ -1664,12 +1668,12 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
 	if (r)
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Unable to reset hardware; reset status %d\n", r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
-		DPRINTF(sc, ATH_DBG_FATAL, "Unable to start recv logic\n");
+		DPRINTF(ah, ATH_DBG_FATAL, "Unable to start recv logic\n");
 
 	/*
 	 * We may be doing a reset in response to a request
@@ -1717,13 +1721,13 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	struct ath_buf *bf;
 	int i, bsize, error;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
 		name, nbuf, ndesc);
 
 	INIT_LIST_HEAD(head);
 	/* ath_desc must be a multiple of DWORDs */
 	if ((sizeof(struct ath_desc) % 4) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL, "ath_desc not DWORD aligned\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "ath_desc not DWORD aligned\n");
 		ASSERT((sizeof(struct ath_desc) % 4) == 0);
 		error = -ENOMEM;
 		goto fail;
@@ -1757,7 +1761,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		goto fail;
 	}
 	ds = dd->dd_desc;
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
 		name, ds, (u32) dd->dd_desc_len,
 		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
 
@@ -1909,7 +1913,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath9k_channel *init_channel;
 	int r;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
 
 	mutex_lock(&sc->mutex);
@@ -1954,7 +1958,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(sc->sc_ah, init_channel, false);
 	if (r) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to reset hardware; reset status %d "
 			"(freq %u MHz)\n", r,
 			curchan->center_freq);
@@ -1977,7 +1981,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * here except setup the interrupt mask.
 	 */
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL, "Unable to start recv logic\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "Unable to start recv logic\n");
 		r = -EIO;
 		goto mutex_unlock;
 	}
@@ -2046,7 +2050,7 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		if (ieee80211_is_data(hdr->frame_control) &&
 		    !ieee80211_is_nullfunc(hdr->frame_control) &&
 		    !ieee80211_has_pm(hdr->frame_control)) {
-			DPRINTF(sc, ATH_DBG_PS, "Add PM=1 for a TX frame "
+			DPRINTF(sc->sc_ah, ATH_DBG_PS, "Add PM=1 for a TX frame "
 				"while in PS mode\n");
 			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 		}
@@ -2062,11 +2066,11 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		ath9k_ps_wakeup(sc);
 		ath9k_hw_setrxabort(sc->sc_ah, 0);
 		if (ieee80211_is_pspoll(hdr->frame_control)) {
-			DPRINTF(sc, ATH_DBG_PS, "Sending PS-Poll to pick a "
+			DPRINTF(sc->sc_ah, ATH_DBG_PS, "Sending PS-Poll to pick a "
 				"buffered frame\n");
 			sc->sc_flags |= SC_OP_WAIT_FOR_PSPOLL_DATA;
 		} else {
-			DPRINTF(sc, ATH_DBG_PS, "Wake up to complete TX\n");
+			DPRINTF(sc->sc_ah, ATH_DBG_PS, "Wake up to complete TX\n");
 			sc->sc_flags |= SC_OP_WAIT_FOR_TX_ACK;
 		}
 		/*
@@ -2108,10 +2112,10 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	if (!txctl.txq)
 		goto exit;
 
-	DPRINTF(sc, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
+	DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		DPRINTF(sc, ATH_DBG_XMIT, "TX failed\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "TX failed\n");
 		goto exit;
 	}
 
@@ -2139,7 +2143,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	}
 
 	if (sc->sc_flags & SC_OP_INVALID) {
-		DPRINTF(sc, ATH_DBG_ANY, "Device not present\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
 	}
@@ -2177,7 +2181,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	mutex_unlock(&sc->mutex);
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Driver halt\n");
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -2211,13 +2215,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		ic_opmode = conf->type;
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Interface type %d not yet supported\n", conf->type);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Attach a VIF of type: %d\n", ic_opmode);
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Attach a VIF of type: %d\n", ic_opmode);
 
 	/* Set the VIF opmode */
 	avp->av_opmode = ic_opmode;
@@ -2270,7 +2274,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 	int i;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Detach Interface\n");
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Detach Interface\n");
 
 	mutex_lock(&sc->mutex);
 
@@ -2324,7 +2328,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 		else if (all_wiphys_idle) {
 			ath_radio_enable(sc);
-			DPRINTF(sc, ATH_DBG_CONFIG,
+			DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
 				"not-idle: enabling radio\n");
 		}
 	}
@@ -2378,7 +2382,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			goto skip_chan_change;
 		}
 
-		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
 		/* XXX: remove me eventualy */
@@ -2387,7 +2391,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_update_chainmask(sc, conf_is_ht(conf));
 
 		if (ath_set_channel(sc, hw, &sc->sc_ah->channels[pos]) < 0) {
-			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
+			DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
 		}
@@ -2398,7 +2402,7 @@ skip_chan_change:
 		sc->config.txpowlimit = 2 * conf->power_level;
 
 	if (disable_radio) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "idle: disabling radio\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "idle: disabling radio\n");
 		ath_radio_disable(sc);
 	}
 
@@ -2435,7 +2439,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 	ath9k_ps_restore(sc);
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", rfilt);
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", rfilt);
 }
 
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
@@ -2479,7 +2483,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	qi.tqi_burstTime = params->txop;
 	qnum = ath_get_hal_qnum(queue, sc);
 
-	DPRINTF(sc, ATH_DBG_CONFIG,
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
 		"Configure tx [queue/halq] [%d/%d],  "
 		"aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
 		queue, qnum, params->aifs, params->cw_min,
@@ -2487,7 +2491,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	ret = ath_txq_update(sc, qnum, &qi);
 	if (ret)
-		DPRINTF(sc, ATH_DBG_FATAL, "TXQ Update failed\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "TXQ Update failed\n");
 
 	mutex_unlock(&sc->mutex);
 
@@ -2509,7 +2513,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW Key\n");
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Set HW Key\n");
 
 	switch (cmd) {
 	case SET_KEY:
@@ -2583,7 +2587,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			/* Set aggregation protection mode parameters */
 			sc->config.ath_aggr_prot = 0;
 
-			DPRINTF(sc, ATH_DBG_CONFIG,
+			DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
 				"RX filter 0x%x bssid %pM aid 0x%x\n",
 				rfilt, sc->curbssid, sc->curaid);
 
@@ -2632,7 +2636,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath_update_chainmask(sc, 0);
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
 			bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			sc->sc_flags |= SC_OP_PREAMBLE_SHORT;
@@ -2641,7 +2645,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
 			bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot &&
 		    hw->conf.channel->band != IEEE80211_BAND_5GHZ)
@@ -2651,7 +2655,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
 		ath9k_bss_assoc_info(sc, vif, bss_conf);
 	}
@@ -2732,7 +2736,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		ath_tx_aggr_resume(sc, sta, tid);
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_FATAL, "Unknown AMPDU action\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "Unknown AMPDU action\n");
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 63bf9a3..1166f72 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -46,7 +46,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			channelSel = ((freq - 704) * 2 - 3040) / 10;
 			bModeSynth = 1;
 		} else {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Invalid channel %u MHz\n", freq);
 			return false;
 		}
@@ -79,7 +79,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		channelSel = ath9k_hw_reverse_bits((freq - 4800) / 5, 8);
 		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
 	} else {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"Invalid channel %u MHz\n", freq);
 		return false;
 	}
@@ -315,7 +315,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 		    || ah->analogBank6Data == NULL
 		    || ah->analogBank6TPCData == NULL
 		    || ah->analogBank7Data == NULL) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Cannot allocate RF banks\n");
 			*status = -ENOMEM;
 			return false;
@@ -326,7 +326,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 			     ah->iniAddac.ia_rows *
 			     ah->iniAddac.ia_columns), GFP_KERNEL);
 		if (ah->addac5416_21 == NULL) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Cannot allocate addac5416_21\n");
 			*status = -ENOMEM;
 			return false;
@@ -336,7 +336,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 		    kzalloc((sizeof(u32) *
 			     ah->iniBank6.ia_rows), GFP_KERNEL);
 		if (ah->bank6Temp == NULL) {
-			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			DPRINTF(ah, ATH_DBG_FATAL,
 				"Cannot allocate bank6Temp\n");
 			*status = -ENOMEM;
 			return false;
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 16a2717..cafe1ec 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1177,13 +1177,14 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 			mode = ATH9K_MODE_11NA_HT40PLUS;
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_CONFIG, "Invalid band\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Invalid band\n");
 		return NULL;
 	}
 
 	BUG_ON(mode >= ATH9K_MODE_MAX);
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Choosing rate table for mode: %d\n", mode);
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
+		"Choosing rate table for mode: %d\n", mode);
 	return sc->hw_rate_table[mode];
 }
 
@@ -1198,7 +1199,8 @@ static void ath_rc_init(struct ath_softc *sc,
 	u8 i, j, k, hi = 0, hthi = 0;
 
 	if (!rate_table) {
-		DPRINTF(sc, ATH_DBG_FATAL, "Rate table not initialized\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
+			"Rate table not initialized\n");
 		return;
 	}
 
@@ -1261,7 +1263,8 @@ static void ath_rc_init(struct ath_softc *sc,
 	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
 	sc->cur_rate_table = rate_table;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "RC Initialized with capabilities: 0x%x\n",
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
+		"RC Initialized with capabilities: 0x%x\n",
 		ath_rc_priv->ht_cap);
 }
 
@@ -1438,7 +1441,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 						   oper_cw40, oper_sgi40);
 			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 
-			DPRINTF(sc, ATH_DBG_CONFIG,
+			DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
 				"Operating HT Bandwidth changed to: %d\n",
 				sc->hw->conf.channel_type);
 		}
@@ -1463,7 +1466,7 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 
 	rate_priv = kzalloc(sizeof(struct ath_rate_priv), gfp);
 	if (!rate_priv) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to allocate private rc structure\n");
 		return NULL;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ec0abf8..ee1e8b4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -306,7 +306,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
 				 min(sc->common.cachelsz, (u16)64));
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
+	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
 		sc->common.cachelsz, sc->rx.bufsize);
 
 	/* Initialize rx descriptors */
@@ -314,7 +314,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
 				  "rx", nbufs, 1);
 	if (error != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"failed to allocate rx descriptors: %d\n", error);
 		goto err;
 	}
@@ -334,7 +334,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 					       bf->bf_buf_addr))) {
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
-			DPRINTF(sc, ATH_DBG_FATAL,
+			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 				"dma_mapping_error() on RX init\n");
 			error = -ENOMEM;
 			goto err;
@@ -539,7 +539,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 
 	if (sc->sc_flags & SC_OP_BEACON_SYNC) {
 		sc->sc_flags &= ~SC_OP_BEACON_SYNC;
-		DPRINTF(sc, ATH_DBG_PS, "Reconfigure Beacon timers based on "
+		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Reconfigure Beacon timers based on "
 			"timestamp from the AP\n");
 		ath_beacon_config(sc, NULL);
 	}
@@ -552,7 +552,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 * a backup trigger for returning into NETWORK SLEEP state,
 		 * so we are waiting for it as well.
 		 */
-		DPRINTF(sc, ATH_DBG_PS, "Received DTIM beacon indicating "
+		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Received DTIM beacon indicating "
 			"buffered broadcast/multicast frame(s)\n");
 		sc->sc_flags |= SC_OP_WAIT_FOR_CAB | SC_OP_WAIT_FOR_BEACON;
 		return;
@@ -565,7 +565,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 * been delivered.
 		 */
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
-		DPRINTF(sc, ATH_DBG_PS, "PS wait for CAB frames timed out\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_PS, "PS wait for CAB frames timed out\n");
 	}
 }
 
@@ -589,13 +589,13 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 		 * point.
 		 */
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
-		DPRINTF(sc, ATH_DBG_PS, "All PS CAB frames received, back to "
+		DPRINTF(sc->sc_ah, ATH_DBG_PS, "All PS CAB frames received, back to "
 			"sleep\n");
 	} else if ((sc->sc_flags & SC_OP_WAIT_FOR_PSPOLL_DATA) &&
 		   !is_multicast_ether_addr(hdr->addr1) &&
 		   !ieee80211_has_morefrags(hdr->frame_control)) {
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_PSPOLL_DATA;
-		DPRINTF(sc, ATH_DBG_PS, "Going back to sleep after having "
+		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Going back to sleep after having "
 			"received PS-Poll data (0x%x)\n",
 			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
 					SC_OP_WAIT_FOR_CAB |
@@ -811,7 +811,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
 			bf->bf_mpdu = NULL;
-			DPRINTF(sc, ATH_DBG_FATAL,
+			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 				"dma_mapping_error() on RX\n");
 			ath_rx_send_to_mac80211(sc, skb, &rx_status);
 			break;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 42551a4..ddd3062 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -854,7 +854,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		return NULL;
 	}
 	if (qnum >= ARRAY_SIZE(sc->tx.txq)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah, ATH_DBG_FATAL,
 			"qnum %u out of range, max %u!\n",
 			qnum, (unsigned int)ARRAY_SIZE(sc->tx.txq));
 		ath9k_hw_releasetxqueue(ah, qnum);
@@ -884,7 +884,7 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 	switch (qtype) {
 	case ATH9K_TX_QUEUE_DATA:
 		if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
-			DPRINTF(sc, ATH_DBG_FATAL,
+			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 				"HAL AC %u out of range, max %zu!\n",
 				haltype, ARRAY_SIZE(sc->tx.hwq_map));
 			return -1;
@@ -914,7 +914,7 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 	spin_lock_bh(&txq->axq_lock);
 
 	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
-		DPRINTF(sc, ATH_DBG_XMIT,
+		DPRINTF(sc->sc_ah, ATH_DBG_XMIT,
 			"TX queue: %d is full, depth: %d\n",
 			qnum, txq->axq_depth);
 		ieee80211_stop_queue(sc->hw, skb_get_queue_mapping(skb));
@@ -955,7 +955,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 	qi.tqi_readyTime = qinfo->tqi_readyTime;
 
 	if (!ath9k_hw_set_txq_props(ah, qnum, &qi)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Unable to update hardware queue %u!\n", qnum);
 		error = -EIO;
 	} else {
@@ -1076,12 +1076,12 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 	if (npend) {
 		int r;
 
-		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, true);
 		if (r)
-			DPRINTF(sc, ATH_DBG_FATAL,
+			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 				"Unable to reset hardware; reset status %d\n",
 				r);
 		spin_unlock_bh(&sc->sc_resetlock);
@@ -1147,7 +1147,7 @@ int ath_tx_setup(struct ath_softc *sc, int haltype)
 	struct ath_txq *txq;
 
 	if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"HAL AC %u out of range, max %zu!\n",
 			 haltype, ARRAY_SIZE(sc->tx.hwq_map));
 		return 0;
@@ -1188,17 +1188,17 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	txq->axq_depth++;
 	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
 
-	DPRINTF(sc, ATH_DBG_QUEUE,
+	DPRINTF(sc->sc_ah, ATH_DBG_QUEUE,
 		"qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
 	if (txq->axq_link == NULL) {
 		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
-		DPRINTF(sc, ATH_DBG_XMIT,
+		DPRINTF(sc->sc_ah, ATH_DBG_XMIT,
 			"TXDP[%u] = %llx (%p)\n",
 			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
 	} else {
 		*txq->axq_link = bf->bf_daddr;
-		DPRINTF(sc, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
+		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
 			txq->axq_qnum, txq->axq_link,
 			ito64(bf->bf_daddr), bf->bf_desc);
 	}
@@ -1587,7 +1587,8 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_mpdu = NULL;
 		kfree(tx_info_priv);
 		tx_info->rate_driver_data[0] = NULL;
-		DPRINTF(sc, ATH_DBG_FATAL, "dma_mapping_error() on TX\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
+			"dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 
@@ -1674,7 +1675,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
-		DPRINTF(sc, ATH_DBG_XMIT, "TX buffers are full\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "TX buffers are full\n");
 		return -1;
 	}
 
@@ -1682,7 +1683,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(r)) {
 		struct ath_txq *txq = txctl->txq;
 
-		DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "TX mem alloc failure\n");
 
 		/* upon ath_tx_processq() this TX queue will be resumed, we
 		 * guarantee this will happen by knowing beforehand that
@@ -1736,7 +1737,8 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (hdrlen & 3) {
 		padsize = hdrlen % 4;
 		if (skb_headroom(skb) < padsize) {
-			DPRINTF(sc, ATH_DBG_XMIT, "TX CABQ padding failed\n");
+			DPRINTF(sc->sc_ah, ATH_DBG_XMIT,
+				"TX CABQ padding failed\n");
 			dev_kfree_skb_any(skb);
 			return;
 		}
@@ -1746,10 +1748,10 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	txctl.txq = sc->beacon.cabq;
 
-	DPRINTF(sc, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
+	DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		DPRINTF(sc, ATH_DBG_XMIT, "CABQ TX failed\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "CABQ TX failed\n");
 		goto exit;
 	}
 
@@ -1771,7 +1773,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	int hdrlen, padsize;
 	int frame_type = ATH9K_NOT_INTERNAL;
 
-	DPRINTF(sc, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
+	DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
 	if (tx_info_priv) {
 		hw = tx_info_priv->aphy->hw;
@@ -1805,7 +1807,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	if (sc->sc_flags & SC_OP_WAIT_FOR_TX_ACK) {
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_TX_ACK;
-		DPRINTF(sc, ATH_DBG_PS, "Going back to sleep after having "
+		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Going back to sleep after having "
 			"received TX status (0x%x)\n",
 			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
 					SC_OP_WAIT_FOR_CAB |
@@ -1942,7 +1944,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	int txok;
 	int status;
 
-	DPRINTF(sc, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
+	DPRINTF(ah, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
 		txq->axq_link);
 
@@ -2064,7 +2066,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 		}
 
 	if (needreset) {
-		DPRINTF(sc, ATH_DBG_RESET, "tx hung, resetting the chip\n");
+		DPRINTF(sc->sc_ah, ATH_DBG_RESET, "tx hung, resetting the chip\n");
 		ath_reset(sc, false);
 	}
 
@@ -2100,7 +2102,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
 				  "tx", nbufs, 1);
 	if (error != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Failed to allocate tx descriptors: %d\n", error);
 		goto err;
 	}
@@ -2108,7 +2110,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
 				  "beacon", ATH_BCBUF, 1);
 	if (error != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
 			"Failed to allocate beacon descriptors: %d\n", error);
 		goto err;
 	}
-- 
1.6.3.3

