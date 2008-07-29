Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17142 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbYG2Frj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:39 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:39 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, Sujith <Sujith.Manoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/16] ath9k: Revamp debugging
Date: Mon, 28 Jul 2008 22:47:17 -0700
Message-ID: <a3ab6130aec50ccc58b625652051946ff6f0bf3e.1217309551.git.lrodriguez@atheros.com> (sfid-20080729_074749_175455_5AF08D08)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |   34 ---
 drivers/net/wireless/ath9k/beacon.c |   44 ++--
 drivers/net/wireless/ath9k/core.c   |   72 +++---
 drivers/net/wireless/ath9k/core.h   |   36 ++--
 drivers/net/wireless/ath9k/hw.c     |  437 ++++++++++++++++++-----------------
 drivers/net/wireless/ath9k/main.c   |   92 ++++----
 drivers/net/wireless/ath9k/phy.c    |   12 +-
 drivers/net/wireless/ath9k/phy.h    |    2 +-
 drivers/net/wireless/ath9k/rc.c     |   26 +-
 drivers/net/wireless/ath9k/recv.c   |   24 +-
 drivers/net/wireless/ath9k/regd.c   |   90 ++++----
 drivers/net/wireless/ath9k/xmit.c   |   40 ++--
 12 files changed, 439 insertions(+), 470 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 1f858b0..6fa1eb6 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -238,7 +238,6 @@ struct hal_ops_config {
 	u_int16_t ath_hal_antennaSwitchSwap;
 	int ath_hal_serializeRegMode;
 	int ath_hal_intrMitigation;
-	int ath_hal_debug;
 #define SPUR_DISABLE        	0
 #define SPUR_ENABLE_IOCTL   	1
 #define SPUR_ENABLE_EEPROM  	2
@@ -618,33 +617,6 @@ struct hal_country_entry {
 	u_int8_t iso[3];
 };
 
-#define HAL_DBG_RESET           0x00000001
-#define HAL_DBG_PHY_IO          0x00000002
-#define HAL_DBG_REG_IO          0x00000004
-#define HAL_DBG_RF_PARAM        0x00000008
-#define HAL_DBG_QUEUE           0x00000010
-#define HAL_DBG_EEPROM_DUMP     0x00000020
-#define HAL_DBG_EEPROM          0x00000040
-#define HAL_DBG_NF_CAL          0x00000080
-#define HAL_DBG_CALIBRATE       0x00000100
-#define HAL_DBG_CHANNEL         0x00000200
-#define HAL_DBG_INTERRUPT       0x00000400
-#define HAL_DBG_DFS             0x00000800
-#define HAL_DBG_DMA             0x00001000
-#define HAL_DBG_REGULATORY      0x00002000
-#define HAL_DBG_TX              0x00004000
-#define HAL_DBG_TXDESC          0x00008000
-#define HAL_DBG_RX              0x00010000
-#define HAL_DBG_RXDESC          0x00020000
-#define HAL_DBG_ANI             0x00040000
-#define HAL_DBG_BEACON          0x00080000
-#define HAL_DBG_KEYCACHE        0x00100000
-#define HAL_DBG_POWER_MGMT      0x00200000
-#define HAL_DBG_MALLOC          0x00400000
-#define HAL_DBG_POWER_OVERRIDE  0x01000000
-#define HAL_DBG_SPUR_MITIGATE   0x02000000
-#define HAL_DBG_UNMASKABLE      0xFFFFFFFF
-
 #define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
 #define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
 
@@ -944,12 +916,6 @@ struct ath_hal {
 #endif
 };
 
-#define HDPRINTF(_ah, _m, _fmt, ...) do {				\
-		if (((_ah) == NULL && _m == HAL_DBG_UNMASKABLE) ||	\
-		    (((struct ath_hal *)(_ah))->ah_config.ath_hal_debug & _m)) \
-			printk(KERN_DEBUG _fmt , ##__VA_ARGS__);	\
-	} while (0)
-
 enum wireless_mode {
 	WIRELESS_MODE_11a = 0,
 	WIRELESS_MODE_11b = 2,
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 699159e..0507940 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -45,7 +45,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	}
 
 	if (!ath9k_hw_settxqueueprops(ah, sc->sc_bhalq, &qi)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to update h/w beacon queue parameters\n",
 			__func__);
 		return 0;
@@ -76,7 +76,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	int ctsduration = 0;
 	struct hal_11n_rate_series  series[4];
 
-	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: m %p len %u\n",
+	DPRINTF(sc, ATH_DBG_BEACON, "%s: m %p len %u\n",
 		__func__, skb, skb->len);
 
 	/* setup descriptors */
@@ -219,7 +219,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	ASSERT(avp);
 
 	if (avp->av_bcbuf == NULL) {
-		DPRINTF(sc, ATH_DEBUG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
+		DPRINTF(sc, ATH_DBG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
 			__func__, avp, avp->av_bcbuf);
 		return NULL;
 	}
@@ -274,7 +274,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		 */
 		if (sc->sc_nvaps > 1 && sc->sc_stagbeacons) {
 			ath_tx_draintxq(sc, cabq, false);
-			DPRINTF(sc, ATH_DEBUG_BEACON,
+			DPRINTF(sc, ATH_DBG_BEACON,
 				"%s: flush previous cabq traffic\n", __func__);
 		}
 	}
@@ -309,7 +309,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 	ASSERT(avp);
 
 	if (avp->av_bcbuf == NULL) {
-		DPRINTF(sc, ATH_DEBUG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
+		DPRINTF(sc, ATH_DBG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
 			__func__, avp, avp != NULL ? avp->av_bcbuf : NULL);
 		return;
 	}
@@ -322,7 +322,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 	/* NB: caller is known to have already stopped tx dma */
 	ath9k_hw_puttxbuf(ah, sc->sc_bhalq, bf->bf_daddr);
 	ath9k_hw_txstart(ah, sc->sc_bhalq);
-	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: TXDP%u = %llx (%p)\n", __func__,
+	DPRINTF(sc, ATH_DBG_BEACON, "%s: TXDP%u = %llx (%p)\n", __func__,
 		sc->sc_bhalq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
@@ -424,7 +424,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	 */
 	skb = ieee80211_beacon_get(sc->hw, avp->av_if_data);
 	if (skb == NULL) {
-		DPRINTF(sc, ATH_DEBUG_BEACON, "%s: cannot get skb\n",
+		DPRINTF(sc, ATH_DBG_BEACON, "%s: cannot get skb\n",
 			__func__);
 		return -ENOMEM;
 	}
@@ -458,7 +458,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		tsfadjust = (intval * (ATH_BCBUF - avp->av_bslot)) / ATH_BCBUF;
 		val = cpu_to_le64(tsfadjust << 10);     /* TU->TSF */
 
-		DPRINTF(sc, ATH_DEBUG_BEACON,
+		DPRINTF(sc, ATH_DBG_BEACON,
 			"%s: %s beacons, bslot %d intval %u tsfadjust %llu\n",
 			__func__, sc->sc_stagbeacons ? "stagger" : "burst",
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
@@ -576,7 +576,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		 */
 		if (sc->sc_bmisscount < BSTUCK_THRESH) {
 			if (sc->sc_noreset) {
-				DPRINTF(sc, ATH_DEBUG_BEACON,
+				DPRINTF(sc, ATH_DBG_BEACON,
 					"%s: missed %u consecutive beacons\n",
 					__func__, sc->sc_bmisscount);
 				if (show_cycles) {
@@ -586,19 +586,19 @@ void ath9k_beacon_tasklet(unsigned long data)
 					 * stickiness.
 					 */
 					DPRINTF(sc,
-						ATH_DEBUG_BEACON,
+						ATH_DBG_BEACON,
 						"%s: busy times: rx_clear=%d, "
 						"rx_frame=%d, tx_frame=%d\n",
 						__func__, rx_clear, rx_frame,
 						tx_frame);
 				} else {
 					DPRINTF(sc,
-						ATH_DEBUG_BEACON,
+						ATH_DBG_BEACON,
 						"%s: unable to obtain "
 						"busy times\n", __func__);
 				}
 			} else {
-				DPRINTF(sc, ATH_DEBUG_BEACON,
+				DPRINTF(sc, ATH_DBG_BEACON,
 					"%s: missed %u consecutive beacons\n",
 					__func__, sc->sc_bmisscount);
 			}
@@ -606,13 +606,13 @@ void ath9k_beacon_tasklet(unsigned long data)
 			if (sc->sc_noreset) {
 				if (sc->sc_bmisscount == BSTUCK_THRESH) {
 					DPRINTF(sc,
-						ATH_DEBUG_BEACON,
+						ATH_DBG_BEACON,
 						"%s: beacon is officially "
 						"stuck\n", __func__);
 					ath9k_hw_dmaRegDump(ah);
 				}
 			} else {
-				DPRINTF(sc, ATH_DEBUG_BEACON,
+				DPRINTF(sc, ATH_DBG_BEACON,
 					"%s: beacon is officially stuck\n",
 					__func__);
 				ath_bstuck_process(sc);
@@ -624,11 +624,11 @@ void ath9k_beacon_tasklet(unsigned long data)
 	if (sc->sc_bmisscount != 0) {
 		if (sc->sc_noreset) {
 			DPRINTF(sc,
-				ATH_DEBUG_BEACON,
+				ATH_DBG_BEACON,
 				"%s: resume beacon xmit after %u misses\n",
 				__func__, sc->sc_bmisscount);
 		} else {
-			DPRINTF(sc, ATH_DEBUG_BEACON,
+			DPRINTF(sc, ATH_DBG_BEACON,
 				"%s: resume beacon xmit after %u misses\n",
 				__func__, sc->sc_bmisscount);
 		}
@@ -655,7 +655,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		tsftu = TSF_TO_TU(tsf>>32, tsf);
 		slot = ((tsftu % intval) * ATH_BCBUF) / intval;
 		if_id = sc->sc_bslot[(slot + 1) % ATH_BCBUF];
-		DPRINTF(sc, ATH_DEBUG_BEACON,
+		DPRINTF(sc, ATH_DBG_BEACON,
 			"%s: slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
 			__func__, slot, (unsigned long long) tsf, tsftu,
 			intval, if_id);
@@ -716,7 +716,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		 * are still pending on the queue.
 		 */
 		if (!ath9k_hw_stoptxdma(ah, sc->sc_bhalq)) {
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: beacon queue %u did not stop?\n",
 				__func__, sc->sc_bhalq);
 			/* NB: the HAL still stops DMA, so proceed */
@@ -740,7 +740,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 
 void ath_bstuck_process(struct ath_softc *sc)
 {
-	DPRINTF(sc, ATH_DEBUG_BEACON,
+	DPRINTF(sc, ATH_DBG_BEACON,
 		"%s: stuck beacon; resetting (bmiss count %u)\n",
 		__func__, sc->sc_bmisscount);
 	ath_internal_reset(sc);
@@ -816,7 +816,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		nexttbtt = intval;
 	else if (intval)        /* NB: can be 0 for monitor mode */
 		nexttbtt = roundup(nexttbtt, intval);
-	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
+	DPRINTF(sc, ATH_DBG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
 		__func__, nexttbtt, intval, conf.beacon_interval);
 	/* Check for HAL_M_HOSTAP and sc_nostabeacons for WDS client */
 	if ((sc->sc_opmode == HAL_M_STA) ||
@@ -905,7 +905,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		if (bs.bs_sleepduration > bs.bs_dtimperiod)
 			bs.bs_sleepduration = bs.bs_dtimperiod;
 
-		DPRINTF(sc, ATH_DEBUG_BEACON,
+		DPRINTF(sc, ATH_DBG_BEACON,
 			"%s: tsf %llu "
 			"tsf:tu %u "
 			"intval %u "
@@ -959,7 +959,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 				} while (nexttbtt < tsftu);
 			}
 #undef FUDGE
-			DPRINTF(sc, ATH_DEBUG_BEACON,
+			DPRINTF(sc, ATH_DBG_BEACON,
 				"%s: IBSS nexttbtt %u intval %u (%u)\n",
 				__func__, nexttbtt,
 				intval & ~HAL_BEACON_RESET_TSF,
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 99ba213..5229710 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -152,7 +152,7 @@ static int ath_rate_setup(struct ath_softc *sc, enum wireless_mode mode)
 				ATH9K_MODE_SEL_11NG_HT40MINUS);
 		break;
 	default:
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: invalid mode %u\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: invalid mode %u\n",
 			__func__, mode);
 		return 0;
 	}
@@ -187,7 +187,7 @@ static int ath_getchannels(struct ath_softc *sc,
 
 	chans = kmalloc(ATH_CHAN_MAX * sizeof(struct hal_channel), GFP_KERNEL);
 	if (chans == NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to allocate channel table\n", __func__);
 		return -ENOMEM;
 	}
@@ -205,7 +205,7 @@ static int ath_getchannels(struct ath_softc *sc,
 				      xchanMode)) {
 		u_int32_t rd = ah->ah_currentRD;
 
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to collect channel list from hal; "
 			"regdomain likely %u country code %u\n",
 			__func__, rd, cc);
@@ -290,7 +290,7 @@ static int ath_stop(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: invalid %u\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: invalid %u\n",
 		__func__, sc->sc_invalid);
 
 	/*
@@ -342,7 +342,7 @@ void ath_scan_start(struct ath_softc *sc)
 
 	/* Restore previous power management state. */
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%d.%03d | %s: RX filter 0x%x aid 0\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%d.%03d | %s: RX filter 0x%x aid 0\n",
 		now / 1000, now % 1000, __func__, rfilt);
 }
 
@@ -365,7 +365,7 @@ void ath_scan_end(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, rfilt);
 	ath9k_hw_write_associd(ah, sc->sc_curbssid, sc->sc_curaid);
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%d.%03d | %s: RX filter 0x%x aid 0x%x\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%d.%03d | %s: RX filter 0x%x aid 0x%x\n",
 		now / 1000, now % 1000, __func__, rfilt, sc->sc_curaid);
 }
 
@@ -385,7 +385,7 @@ int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan)
 	if (sc->sc_invalid)	/* if the device is invalid or removed */
 		return -EIO;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG,
+	DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: %u (%u MHz) -> %u (%u MHz), cflags:%x\n",
 		__func__,
 		ath9k_hw_mhz2ieee(ah, sc->sc_curchan.channel,
@@ -426,7 +426,7 @@ int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan)
 					sc->sc_rx_chainmask,
 					sc->sc_ht_extprotspacing,
 					fastcc, &status)) {
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: unable to reset channel %u (%uMhz) "
 				"flags 0x%x hal status %u\n", __func__,
 				ath9k_hw_mhz2ieee(ah, hchan->channel,
@@ -443,7 +443,7 @@ int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan)
 
 		/* Re-enable rx framework */
 		if (ath_startrecv(sc) != 0) {
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: unable to restart recv logic\n", __func__);
 			return -EIO;
 		}
@@ -558,7 +558,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 		sc->sc_rx_chainmask = 1;
 	}
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: tx chmask: %d, rx chmask: %d\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: tx chmask: %d, rx chmask: %d\n",
 		__func__, sc->sc_tx_chainmask, sc->sc_rx_chainmask);
 }
 
@@ -583,7 +583,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 
 	avp = sc->sc_vaps[if_id];
 	if (avp == NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: invalid interface id %u\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: invalid interface id %u\n",
 			__func__, if_id);
 		return -EINVAL;
 	}
@@ -605,7 +605,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 	} else
 		sc->sc_curaid = 0;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG,
+	DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: RX filter 0x%x bssid %s aid 0x%x\n",
 		__func__, rfilt, print_mac(mac,
 			sc->sc_curbssid), sc->sc_curaid);
@@ -633,7 +633,7 @@ int ath_vap_attach(struct ath_softc *sc,
 	struct ath_vap *avp;
 
 	if (if_id >= ATH_BCBUF || sc->sc_vaps[if_id] != NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Invalid interface id = %u\n", __func__, if_id);
 		return -EINVAL;
 	}
@@ -702,7 +702,7 @@ int ath_vap_detach(struct ath_softc *sc, int if_id)
 
 	avp = sc->sc_vaps[if_id];
 	if (avp == NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: invalid interface id %u\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: invalid interface id %u\n",
 			__func__, if_id);
 		return -EINVAL;
 	}
@@ -738,7 +738,7 @@ int ath_vap_config(struct ath_softc *sc,
 	struct ath_vap *avp;
 
 	if (if_id >= ATH_BCBUF) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Invalid interface id = %u\n", __func__, if_id);
 		return -EINVAL;
 	}
@@ -763,7 +763,7 @@ int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan)
 	int error = 0;
 	enum hal_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: mode %d\n", __func__, sc->sc_opmode);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: mode %d\n", __func__, sc->sc_opmode);
 
 	/*
 	 * Stop anything previously setup.  This is safe
@@ -791,7 +791,7 @@ int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan)
 	if (!ath9k_hw_reset(ah, sc->sc_opmode, &sc->sc_curchan, ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			   sc->sc_ht_extprotspacing, false, &status)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to reset hardware; hal status %u "
 			"(freq %u flags 0x%x)\n", __func__, status,
 			sc->sc_curchan.channel, sc->sc_curchan.channelFlags);
@@ -814,7 +814,7 @@ int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan)
 	 * here except setup the interrupt mask.
 	 */
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to start recv logic\n", __func__);
 		error = -EIO;
 		goto done;
@@ -885,7 +885,7 @@ static int ath_reset_end(struct ath_softc *sc, u_int32_t flag)
 	struct ath_hal *ah = sc->sc_ah;
 
 	if (ath_startrecv(sc) != 0)	/* restart recv */
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to start recv logic\n", __func__);
 
 	/*
@@ -928,7 +928,7 @@ int ath_reset(struct ath_softc *sc)
 			   ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			   sc->sc_ht_extprotspacing, false, &status)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to reset hardware; hal status %u\n",
 			__func__, status);
 		error = -EIO;
@@ -1131,7 +1131,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	sc->sc_invalid = 1;
 
 	sc->sc_debug = DBG_DEFAULT;
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: devid 0x%x\n", __func__, devid);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: devid 0x%x\n", __func__, devid);
 
 	/* Initialize tasklet */
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
@@ -1150,7 +1150,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 
 	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
 	if (ah == NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to attach hardware; HAL status %u\n",
 			__func__, status);
 		error = -ENXIO;
@@ -1164,7 +1164,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	/* Get the hardware key cache size. */
 	sc->sc_keymax = ah->ah_caps.halKeyCacheSize;
 	if (sc->sc_keymax > ATH_KEYMAX) {
-		DPRINTF(sc, ATH_DEBUG_KEYCACHE,
+		DPRINTF(sc, ATH_DBG_KEYCACHE,
 			"%s: Warning, using only %u entries in %u key cache\n",
 			__func__, ATH_KEYMAX, sc->sc_keymax);
 		sc->sc_keymax = ATH_KEYMAX;
@@ -1223,14 +1223,14 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	 */
 	sc->sc_bhalq = ath_beaconq_setup(ah);
 	if (sc->sc_bhalq == -1) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup a beacon xmit queue\n", __func__);
 		error = -EIO;
 		goto bad2;
 	}
 	sc->sc_cabq = ath_txq_setup(sc, HAL_TX_QUEUE_CAB, 0);
 	if (sc->sc_cabq == NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup CAB xmit queue\n", __func__);
 		error = -EIO;
 		goto bad2;
@@ -1245,7 +1245,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	/* Setup data queues */
 	/* NB: ensure BK queue is the lowest priority h/w queue */
 	if (!ath_tx_setup(sc, HAL_WME_AC_BK)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for BK traffic\n",
 			__func__);
 		error = -EIO;
@@ -1253,21 +1253,21 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	}
 
 	if (!ath_tx_setup(sc, HAL_WME_AC_BE)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for BE traffic\n",
 			__func__);
 		error = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, HAL_WME_AC_VI)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for VI traffic\n",
 			__func__);
 		error = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, HAL_WME_AC_VO)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for VO traffic\n",
 			__func__);
 		error = -EIO;
@@ -1397,7 +1397,7 @@ void ath_deinit(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	int i;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s\n", __func__);
 
 	ath_stop(sc);
 	if (!sc->sc_invalid)
@@ -1441,9 +1441,6 @@ struct ath_node *ath_node_attach(struct ath_softc *sc, u8 *addr, int if_id)
 	ath_chainmask_sel_timerstart(&an->an_chainmask_sel);
 	list_add(&an->list, &sc->node_list);
 
-	DPRINTF(sc, ATH_DEBUG_NODE, "%s: an %p for: %s\n",
-		__func__, an, print_mac(mac, addr));
-
 	return an;
 }
 
@@ -1467,9 +1464,6 @@ void ath_node_detach(struct ath_softc *sc, struct ath_node *an, bool bh_flag)
 
 	spin_unlock_irqrestore(&sc->node_lock, flags);
 
-	DPRINTF(sc, ATH_DEBUG_NODE, "%s: an %p for: %s\n",
-		__func__, an, print_mac(mac, an->an_addr));
-
 	kfree(an);
 }
 
@@ -1767,12 +1761,12 @@ int ath_descdma_setup(struct ath_softc *sc,
 	struct ath_buf *bf;
 	int i, bsize, error;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: %s DMA: %u buffers %u desc/buf\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA: %u buffers %u desc/buf\n",
 		__func__, name, nbuf, ndesc);
 
 	/* ath_desc must be a multiple of DWORDs */
 	if ((sizeof(struct ath_desc) % 4) != 0) {
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: ath_desc not DWORD aligned\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: ath_desc not DWORD aligned\n",
 			__func__);
 		ASSERT((sizeof(struct ath_desc) % 4) == 0);
 		error = -ENOMEM;
@@ -1809,7 +1803,7 @@ int ath_descdma_setup(struct ath_softc *sc,
 		goto fail;
 	}
 	ds = dd->dd_desc;
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: %s DMA map: %p (%u) -> %llx (%u)\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA map: %p (%u) -> %llx (%u)\n",
 		__func__, dd->dd_name, ds, (u_int32_t) dd->dd_desc_len,
 		ito64(dd->dd_desc_paddr), /*XXX*/(u_int32_t) dd->dd_desc_len);
 
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4eaf942..964ba58 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -100,23 +100,29 @@ static inline unsigned long get_timestamp(void)
 /*************/
 
 enum ATH_DEBUG {
-	ATH_DEBUG_XMIT          = 0x00000001,   /* basic xmit operation */
-	ATH_DEBUG_RECV          = 0x00000002,   /* basic recv operation */
-	ATH_DEBUG_BEACON        = 0x00000004,   /* beacon handling */
-	ATH_DEBUG_TX_PROC       = 0x00000008,   /* tx ISR proc */
-	ATH_DEBUG_RX_PROC       = 0x00000010,   /* rx ISR proc */
-	ATH_DEBUG_BEACON_PROC   = 0x00000020,   /* beacon ISR proc */
-	ATH_DEBUG_RATE          = 0x00000040,   /* rate control */
-	ATH_DEBUG_CONFIG        = 0x00000080,   /* configuration */
-	ATH_DEBUG_KEYCACHE      = 0x00000100,   /* key cache management */
-	ATH_DEBUG_NODE          = 0x00000200,   /* node management */
-	ATH_DEBUG_AGGR		= 0x00000400,	/* Aggregation */
-	ATH_DEBUG_CWM		= 0x00000800,	/* Channel Width Management */
-	ATH_DEBUG_FATAL         = 0x00001000,   /* fatal errors */
-	ATH_DEBUG_ANY           = 0xffffffff
+	ATH_DBG_RESET		= 0x00000001,
+	ATH_DBG_PHY_IO		= 0x00000002,
+	ATH_DBG_REG_IO		= 0x00000004,
+	ATH_DBG_QUEUE		= 0x00000008,
+	ATH_DBG_EEPROM		= 0x00000010,
+	ATH_DBG_NF_CAL		= 0x00000020,
+	ATH_DBG_CALIBRATE	= 0x00000040,
+	ATH_DBG_CHANNEL		= 0x00000080,
+	ATH_DBG_INTERRUPT	= 0x00000100,
+	ATH_DBG_REGULATORY	= 0x00000200,
+	ATH_DBG_ANI		= 0x00000400,
+	ATH_DBG_POWER_MGMT	= 0x00000800,
+	ATH_DBG_XMIT		= 0x00001000,
+	ATH_DBG_BEACON		= 0x00002000,
+	ATH_DBG_RATE		= 0x00004000,
+	ATH_DBG_CONFIG		= 0x00008000,
+	ATH_DBG_KEYCACHE	= 0x00010000,
+	ATH_DBG_AGGR		= 0x00020000,
+	ATH_DBG_FATAL		= 0x00040000,
+	ATH_DBG_ANY		= 0xffffffff
 };
 
-#define DBG_DEFAULT (ATH_DEBUG_FATAL)
+#define DBG_DEFAULT (ATH_DBG_FATAL)
 
 #define	DPRINTF(sc, _m, _fmt, ...) do {			\
 		if (sc->sc_debug & (_m))                \
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 081fee3..c755ec9 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -16,7 +16,7 @@
 
 #include <linux/io.h>
 
-#include "ath9k.h"
+#include "core.h"
 #include "hw.h"
 #include "reg.h"
 #include "phy.h"
@@ -243,7 +243,7 @@ static bool ath9k_hw_wait(struct ath_hal *ah,
 
 		udelay(AH_TIME_QUANTUM);
 	}
-	HDPRINTF(ah, HAL_DBG_PHY_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
 		 "%s: timeout on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
 		 __func__, reg, REG_READ(ah, reg), mask, val);
 	return false;
@@ -274,7 +274,7 @@ static enum hal_status ath9k_hw_flash_map(struct ath_hal *ah)
 	ahp->ah_cal_mem = ioremap(AR5416_EEPROM_START_ADDR, AR5416_EEPROM_MAX);
 
 	if (!ahp->ah_cal_mem) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: cannot remap eeprom region \n", __func__);
 		return HAL_EIO;
 	}
@@ -368,7 +368,6 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 	}
 
 	ah->ah_config.ath_hal_intrMitigation = 0;
-	ah->ah_config.ath_hal_debug = 0;
 }
 
 static inline void ath9k_hw_override_ini(struct ath_hal *ah,
@@ -531,7 +530,7 @@ static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 	int addr, ar5416_eep_start_loc = 0;
 
 	if (!ath9k_hw_use_flash(ah)) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: Reading from EEPROM, not flash\n", __func__);
 		ar5416_eep_start_loc = 256;
 	}
@@ -544,7 +543,7 @@ static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 	     addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
 					 eep_data)) {
-			HDPRINTF(ah, HAL_DBG_EEPROM,
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				 "%s: Unable to read eeprom region \n",
 				 __func__);
 			return false;
@@ -728,7 +727,7 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 					  AR_AN_TOP2_LOCALBIAS,
 					  AR_AN_TOP2_LOCALBIAS_S,
 					  pModal->local_bias);
-		HDPRINTF(NULL, HAL_DBG_UNMASKABLE, "ForceXPAon: %d\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_ANY, "ForceXPAon: %d\n",
 			 pModal->force_xpaon);
 		OS_REG_RMW_FIELD(ah, AR_PHY_XPA_CFG, AR_PHY_FORCE_XPA_CFG,
 				 pModal->force_xpaon);
@@ -805,11 +804,11 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 
 		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
 					&magic)) {
-			HDPRINTF(ah, HAL_DBG_EEPROM,
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				 "%s: Reading Magic # failed\n", __func__);
 			return false;
 		}
-		HDPRINTF(ah, HAL_DBG_EEPROM, "%s: Read Magic = 0x%04X\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "%s: Read Magic = 0x%04X\n",
 			 __func__, magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
@@ -829,22 +828,22 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 					*eepdata = temp;
 					eepdata++;
 
-					HDPRINTF(ah, HAL_DBG_EEPROM_DUMP,
+					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 						 "0x%04X  ", *eepdata);
 					if (((addr + 1) % 6) == 0)
-						HDPRINTF(ah,
-							 HAL_DBG_EEPROM_DUMP,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_EEPROM,
 							 "\n");
 				}
 			} else {
-				HDPRINTF(ah, HAL_DBG_EEPROM,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					 "Invalid EEPROM Magic. "
 					"endianness missmatch.\n");
 				return HAL_EEBADSUM;
 			}
 		}
 	}
-	HDPRINTF(ah, HAL_DBG_EEPROM, "need_swap = %s.\n",
+	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n",
 		 need_swap ? "True" : "False");
 
 	if (need_swap)
@@ -866,7 +865,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 		u_int32_t integer, j;
 		u_int16_t word;
 
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "EEPROM Endianness is not native.. Changing \n");
 
 		word = swab16(eep->baseEepHeader.length);
@@ -913,7 +912,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 
 	if (sum != 0xffff || ar5416_get_eep_ver(ahp) != AR5416_EEP_VER ||
 	    ar5416_get_eep_rev(ahp) < AR5416_EEP_NO_BACK_VER) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			 sum, ar5416_get_eep_ver(ahp));
 		return HAL_EEBADSUM;
@@ -942,7 +941,7 @@ static bool ath9k_hw_chip_test(struct ath_hal *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (rdData != wrData) {
-				HDPRINTF(ah, HAL_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 				 "%s: address test failed "
 				"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 				 __func__, addr, wrData, rdData);
@@ -954,7 +953,7 @@ static bool ath9k_hw_chip_test(struct ath_hal *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (wrData != rdData) {
-				HDPRINTF(ah, HAL_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 				 "%s: address test failed "
 				"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 				 __func__, addr, wrData, rdData);
@@ -1054,17 +1053,17 @@ void ath9k_hw_dmaRegDump(struct ath_hal *ah)
 		   (AR_MACMISC_MISC_OBS_BUS_1 <<
 		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
 
-	HDPRINTF(ah, HAL_DBG_REG_IO, "Raw DMA Debug values:\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "Raw DMA Debug values:\n");
 	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++) {
 		if (i % 4 == 0)
-			HDPRINTF(ah, HAL_DBG_REG_IO, "\n");
+			DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "\n");
 
 		val[i] = REG_READ(ah, AR_DMADBG_0 + (i * sizeof(u_int32_t)));
-		HDPRINTF(ah, HAL_DBG_REG_IO, "%d: %08x ", i, val[i]);
+		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "%d: %08x ", i, val[i]);
 	}
 
-	HDPRINTF(ah, HAL_DBG_REG_IO, "\n\n");
-	HDPRINTF(ah, HAL_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "\n\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 		 "Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
 
 	for (i = 0; i < ATH9K_NUM_QUEUES;
@@ -1079,7 +1078,7 @@ void ath9k_hw_dmaRegDump(struct ath_hal *ah)
 			dcuBase++;
 		}
 
-		HDPRINTF(ah, HAL_DBG_REG_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 			 "%2d          %2x      %1x     %2x           %2x\n",
 			 i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
 			 (*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset +
@@ -1088,29 +1087,30 @@ void ath9k_hw_dmaRegDump(struct ath_hal *ah)
 			 (*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
 	}
 
-	HDPRINTF(ah, HAL_DBG_REG_IO, "\n");
-	HDPRINTF(ah, HAL_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 		 "qcu_stitch state:   %2x    qcu_fetch state:        %2x\n",
 		 (val[3] & 0x003c0000) >> 18, (val[3] & 0x03c00000) >> 22);
-	HDPRINTF(ah, HAL_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 		 "qcu_complete state: %2x    dcu_complete state:     %2x\n",
 		 (val[3] & 0x1c000000) >> 26, (val[6] & 0x3));
-	HDPRINTF(ah, HAL_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 		 "dcu_arb state:      %2x    dcu_fp state:           %2x\n",
 		 (val[5] & 0x06000000) >> 25, (val[5] & 0x38000000) >> 27);
-	HDPRINTF(ah, HAL_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 		 "chan_idle_dur:     %3d    chan_idle_dur_valid:     %1d\n",
 		 (val[6] & 0x000003fc) >> 2, (val[6] & 0x00000400) >> 10);
-	HDPRINTF(ah, HAL_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 		 "txfifo_valid_0:      %1d    txfifo_valid_1:          %1d\n",
 		 (val[6] & 0x00000800) >> 11, (val[6] & 0x00001000) >> 12);
-	HDPRINTF(ah, HAL_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 		 "txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
 		 (val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
 
-	HDPRINTF(ah, HAL_DBG_REG_IO, "pcu observe 0x%x \n",
-		 REG_READ(ah, AR_OBS_BUS_1));
-	HDPRINTF(ah, HAL_DBG_REG_IO, "AR_CR 0x%x \n", REG_READ(ah, AR_CR));
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "pcu observe 0x%x \n",
+		REG_READ(ah, AR_OBS_BUS_1));
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+		"AR_CR 0x%x \n", REG_READ(ah, AR_CR));
 }
 
 u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
@@ -1127,7 +1127,7 @@ u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
 	u_int32_t cc = REG_READ(ah, AR_CCCNT);
 
 	if (cycles == 0 || cycles > cc) {
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: cycle counter wrap. ExtBusy = 0\n",
 			 __func__);
 		good = 0;
@@ -1185,7 +1185,7 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
 
 	ahp = kzalloc(sizeof(struct ath_hal_5416), GFP_KERNEL);
 	if (ahp == NULL) {
-		HDPRINTF(NULL, HAL_DBG_UNMASKABLE,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			 "%s: cannot allocate memory for state block\n",
 			 __func__);
 		*status = HAL_ENOMEM;
@@ -1321,7 +1321,7 @@ static inline enum hal_status ath9k_hw_init_macaddr(struct ath_hal *ah)
 		ahp->ah_macaddr[2 * i + 1] = eeval & 0xff;
 	}
 	if (sum == 0 || sum == 0xffff * 3) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: mac address read failed: %s\n", __func__,
 			 print_mac(mac, ahp->ah_macaddr));
 		return HAL_EEBADMAC;
@@ -1367,7 +1367,7 @@ static u_int16_t ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
 		(struct ar5416_eeprom *) &ahp->ah_eeprom;
 	u_int16_t spur_val = AR_NO_SPUR;
 
-	HDPRINTF(ah, HAL_DBG_ANI,
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		 "Getting spur idx %d is2Ghz. %d val %x\n",
 		 i, is2GHz, ah->ah_config.ath_hal_spurChans[i][is2GHz]);
 
@@ -1376,7 +1376,7 @@ static u_int16_t ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->ah_config.ath_hal_spurChans[i][is2GHz];
-		HDPRINTF(ah, HAL_DBG_ANI,
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			 "Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
@@ -1394,7 +1394,7 @@ static inline enum hal_status ath9k_hw_rfattach(struct ath_hal *ah)
 
 	rfStatus = ath9k_hw_init_rf(ah, &ecode);
 	if (!rfStatus) {
-		HDPRINTF(ah, HAL_DBG_RESET,
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			 "%s: RF setup failed, status %u\n", __func__,
 			 ecode);
 		return ecode;
@@ -1420,7 +1420,7 @@ static enum hal_status ath9k_hw_rf_claim(struct ath_hal *ah)
 	case AR_RAD2122_SREV_MAJOR:
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: 5G Radio Chip Rev 0x%02X is not "
 			"supported by this driver\n",
 			 __func__, ah->ah_analog5GhzRev);
@@ -1603,8 +1603,9 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 
 	REG_WRITE(ah, (u_int16_t) (AR_RTC_RC), 0);
 	if (!ath9k_hw_wait(ah, (u_int16_t) (AR_RTC_RC), AR_RTC_RC_M, 0)) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: RTC stuck in MAC reset\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+			"%s: RTC stuck in MAC reset\n",
+			__func__);
 		return false;
 	}
 
@@ -1631,7 +1632,7 @@ static inline bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 			   AR_RTC_STATUS,
 			   AR_RTC_STATUS_M,
 			   AR_RTC_STATUS_ON)) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: RTC not waking up\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: RTC not waking up\n",
 			 __func__);
 		return false;
 	}
@@ -1664,7 +1665,7 @@ static inline struct hal_channel_internal *ath9k_hw_check_chan(
 			struct ath_hal *ah, struct hal_channel *chan)
 {
 	if ((IS(chan, CHANNEL_2GHZ) ^ IS(chan, CHANNEL_5GHZ)) == 0) {
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; not marked as "
 			 "2GHz or 5GHz\n", __func__, chan->channel,
 			 chan->channelFlags);
@@ -1676,7 +1677,7 @@ static inline struct hal_channel_internal *ath9k_hw_check_chan(
 	     ^ IS(chan, CHANNEL_HT20)
 	     ^ IS(chan, CHANNEL_HT40PLUS)
 	     ^ IS(chan, CHANNEL_HT40MINUS)) == 0) {
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; not marked as "
 			 "OFDM or CCK or HT20 or HT40PLUS or HT40MINUS\n",
 			 __func__, chan->channel, chan->channelFlags);
@@ -1780,7 +1781,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	HDPRINTF(ah, HAL_DBG_CALIBRATE,
+	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 		 "NF calibrated [ctl] [chain 0] is %d\n", nf);
 	nfarray[0] = nf;
 
@@ -1793,7 +1794,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	HDPRINTF(ah, HAL_DBG_NF_CAL,
+	DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
 		 "NF calibrated [ctl] [chain 1] is %d\n", nf);
 	nfarray[1] = nf;
 
@@ -1802,7 +1803,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 			AR_PHY_CH2_MINCCA_PWR);
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		HDPRINTF(ah, HAL_DBG_NF_CAL,
+		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
 			 "NF calibrated [ctl] [chain 2] is %d\n", nf);
 		nfarray[2] = nf;
 	}
@@ -1816,7 +1817,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	HDPRINTF(ah, HAL_DBG_NF_CAL,
+	DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
 		 "NF calibrated [ext] [chain 0] is %d\n", nf);
 	nfarray[3] = nf;
 
@@ -1829,7 +1830,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	HDPRINTF(ah, HAL_DBG_CALIBRATE,
+	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 		 "NF calibrated [ext] [chain 1] is %d\n", nf);
 	nfarray[4] = nf;
 
@@ -1838,7 +1839,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 			AR_PHY_CH2_EXT_MINCCA_PWR);
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		HDPRINTF(ah, HAL_DBG_NF_CAL,
+		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
 			 "NF calibrated [ext] [chain 2] is %d\n", nf);
 		nfarray[5] = nf;
 	}
@@ -1866,7 +1867,7 @@ getNoiseFloorThresh(struct ath_hal *ah,
 		*nft = (int16_t) ath9k_hw_get_eeprom(ahp, EEP_NFTHRESH_2);
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel flags 0x%x\n", __func__,
 			 chan->channelFlags);
 		return false;
@@ -1957,7 +1958,7 @@ static int16_t ath9k_hw_getnf(struct ath_hal *ah,
 
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: NF did not complete in calibration window\n",
 			 __func__);
 		nf = 0;
@@ -1968,7 +1969,7 @@ static int16_t ath9k_hw_getnf(struct ath_hal *ah,
 		nf = nfarray[0];
 		if (getNoiseFloorThresh(ah, chan, &nfThresh)
 		    && nf > nfThresh) {
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "%s: noise floor failed detected; "
 				 "detected %d, threshold %d\n", __func__,
 				 nf, nfThresh);
@@ -2002,7 +2003,7 @@ static void ath9k_enable_mib_counters(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	HDPRINTF(ah, HAL_DBG_ANI, "Enable mib counters\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Enable mib counters\n");
 
 	ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
 
@@ -2019,7 +2020,7 @@ static void ath9k_hw_disable_mib_counters(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	HDPRINTF(ah, HAL_DBG_ANI, "Disabling MIB counters\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Disabling MIB counters\n");
 
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC | AR_MIBC_CMC);
 
@@ -2045,7 +2046,7 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hal *ah,
 		}
 	}
 
-	HDPRINTF(ah, HAL_DBG_ANI,
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		 "No more channel states left. Using channel 0\n");
 	return 0;
 }
@@ -2079,10 +2080,11 @@ static void ath9k_hw_ani_attach(struct ath_hal *ah)
 		}
 	}
 	if (ahp->ah_hasHwPhyCounters) {
-		HDPRINTF(ah, HAL_DBG_ANI, "Setting OfdmErrBase = 0x%08x\n",
-			 ahp->ah_ani[0].ofdmPhyErrBase);
-		HDPRINTF(ah, HAL_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
-			 ahp->ah_ani[0].cckPhyErrBase);
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			"Setting OfdmErrBase = 0x%08x\n",
+			ahp->ah_ani[0].ofdmPhyErrBase);
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
+			ahp->ah_ani[0].cckPhyErrBase);
 
 		REG_WRITE(ah, AR_PHY_ERR_1, ahp->ah_ani[0].ofdmPhyErrBase);
 		REG_WRITE(ah, AR_PHY_ERR_2, ahp->ah_ani[0].cckPhyErrBase);
@@ -2115,7 +2117,7 @@ static void ath9k_hw_ani_detach(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	HDPRINTF(ah, HAL_DBG_ANI, "Detaching Ani\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Detaching Ani\n");
 	if (ahp->ah_hasHwPhyCounters) {
 		ath9k_hw_disable_mib_counters(ah);
 		REG_WRITE(ah, AR_PHY_ERR_1, 0);
@@ -2135,7 +2137,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		u_int level = param;
 
 		if (level >= ARRAY_SIZE(ahp->ah_totalSizeDesired)) {
-			HDPRINTF(ah, HAL_DBG_ANI,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				 "%s: level out of range (%u > %u)\n",
 				 __func__, level,
 				 (unsigned) ARRAY_SIZE(ahp->
@@ -2241,7 +2243,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		u_int level = param;
 
 		if (level >= ARRAY_SIZE(firstep)) {
-			HDPRINTF(ah, HAL_DBG_ANI,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				 "%s: level out of range (%u > %u)\n",
 				 __func__, level,
 				 (unsigned) ARRAY_SIZE(firstep));
@@ -2263,7 +2265,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		u_int level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1)) {
-			HDPRINTF(ah, HAL_DBG_ANI,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				 "%s: level out of range (%u > %u)\n",
 				 __func__, level,
 				 (unsigned)
@@ -2283,23 +2285,23 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 	case HAL_ANI_PRESENT:
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_ANI, "%s: invalid cmd %u\n", __func__,
-			 cmd);
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			"%s: invalid cmd %u\n", __func__, cmd);
 		return false;
 	}
 
-	HDPRINTF(ah, HAL_DBG_ANI, "%s: ANI parameters:\n", __func__);
-	HDPRINTF(ah, HAL_DBG_ANI,
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "%s: ANI parameters:\n", __func__);
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		"noiseImmunityLevel=%d, spurImmunityLevel=%d, "
 		"ofdmWeakSigDetectOff=%d\n",
 		 aniState->noiseImmunityLevel, aniState->spurImmunityLevel,
 		 !aniState->ofdmWeakSigDetectOff);
-	HDPRINTF(ah, HAL_DBG_ANI,
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		"cckWeakSigThreshold=%d, "
 		"firstepLevel=%d, listenTime=%d\n",
 		 aniState->cckWeakSigThreshold, aniState->firstepLevel,
 		 aniState->listenTime);
-	HDPRINTF(ah, HAL_DBG_ANI,
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		 "cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
 		 aniState->cycleCount, aniState->ofdmPhyErrCount,
 		 aniState->cckPhyErrCount);
@@ -2320,7 +2322,7 @@ static void ath9k_ani_restart(struct ath_hal *ah)
 	if (ahp->ah_hasHwPhyCounters) {
 		if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
 			aniState->ofdmPhyErrBase = 0;
-			HDPRINTF(ah, HAL_DBG_ANI,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				 "OFDM Trigger is too high for hw counters\n");
 		} else {
 			aniState->ofdmPhyErrBase =
@@ -2328,13 +2330,13 @@ static void ath9k_ani_restart(struct ath_hal *ah)
 		}
 		if (aniState->cckTrigHigh > AR_PHY_COUNTMAX) {
 			aniState->cckPhyErrBase = 0;
-			HDPRINTF(ah, HAL_DBG_ANI,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				 "CCK Trigger is too high for hw counters\n");
 		} else {
 			aniState->cckPhyErrBase =
 				AR_PHY_COUNTMAX - aniState->cckTrigHigh;
 		}
-		HDPRINTF(ah, HAL_DBG_ANI,
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			 "%s: Writing ofdmbase=%u   cckbase=%u\n",
 			 __func__, aniState->ofdmPhyErrBase,
 			 aniState->cckPhyErrBase);
@@ -2482,7 +2484,7 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 
 	if (DO_ANI(ah) && ah->ah_opmode != HAL_M_STA
 	    && ah->ah_opmode != HAL_M_IBSS) {
-		HDPRINTF(ah, HAL_DBG_ANI,
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			 "%s: Reset ANI state opmode %u\n", __func__,
 			 ah->ah_opmode);
 		ahp->ah_stats.ast_ani_reset++;
@@ -2549,7 +2551,7 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int32_t phyCnt1, phyCnt2;
 
-	HDPRINTF(ah, HAL_DBG_ANI, "Processing Mib Intr\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Processing Mib Intr\n");
 
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
@@ -2711,7 +2713,7 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 		if (phyCnt1 < aniState->ofdmPhyErrBase ||
 		    phyCnt2 < aniState->cckPhyErrBase) {
 			if (phyCnt1 < aniState->ofdmPhyErrBase) {
-				HDPRINTF(ah, HAL_DBG_ANI,
+				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 					 "%s: phyCnt1 0x%x, resetting "
 					 "counter value to 0x%x\n",
 					 __func__, phyCnt1,
@@ -2722,7 +2724,7 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 					  AR_PHY_ERR_OFDM_TIMING);
 			}
 			if (phyCnt2 < aniState->cckPhyErrBase) {
-				HDPRINTF(ah, HAL_DBG_ANI,
+				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 					 "%s: phyCnt2 0x%x, resetting "
 					 "counter value to 0x%x\n",
 					 __func__, phyCnt2,
@@ -2883,7 +2885,7 @@ static inline enum hal_status ath9k_hw_post_attach(struct ath_hal *ah)
 	enum hal_status ecode;
 
 	if (!ath9k_hw_chip_test(ah)) {
-		HDPRINTF(ah, HAL_DBG_REG_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 			 "%s: hardware self-test failed\n", __func__);
 		return HAL_ESELFTEST;
 	}
@@ -2915,23 +2917,23 @@ static u_int32_t ath9k_hw_ini_fixup(struct ath_hal *ah,
 	switch (ah->ah_devid) {
 	case AR9280_DEVID_PCI:
 		if (reg == 0x7894) {
-			HDPRINTF(NULL, HAL_DBG_UNMASKABLE,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				 "ini VAL: %x  EEPROM: %x\n", value,
 				 (pBase->version & 0xff));
 
 			if ((pBase->version & 0xff) > 0x0a) {
-				HDPRINTF(NULL, HAL_DBG_UNMASKABLE,
+				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 					 "PWDCLKIND: %d\n",
 					 pBase->pwdclkind);
 				value &= ~AR_AN_TOP2_PWDCLKIND;
 				value |= AR_AN_TOP2_PWDCLKIND & (pBase->
 					 pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
 			} else {
-				HDPRINTF(NULL, HAL_DBG_UNMASKABLE,
+				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 					 "PWDCLKIND Earlier Rev\n");
 			}
 
-			HDPRINTF(NULL, HAL_DBG_UNMASKABLE,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				 "final ini VAL: %x\n", value);
 		}
 		break;
@@ -2960,7 +2962,7 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 			ah->ah_currentRD += 5;
 		else if (ah->ah_currentRD == 0x41)
 			ah->ah_currentRD = 0x43;
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			 "%s: regdomain mapped to 0x%x\n", __func__,
 			 ah->ah_currentRD);
 	}
@@ -3189,7 +3191,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 				       AR_RTC_FORCE_WAKE_EN);
 		}
 		if (i == 0) {
-			HDPRINTF(ah, HAL_DBG_POWER_MGMT,
+			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 				 "%s: Failed to wakeup in %uus\n",
 				 __func__, POWER_UP_TIME / 20);
 			return false;
@@ -3212,7 +3214,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 	};
 	int status = true, setChip = true;
 
-	HDPRINTF(ah, HAL_DBG_POWER_MGMT, "%s: %s -> %s (%s)\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s: %s -> %s (%s)\n", __func__,
 		 modes[ahp->ah_powerMode], modes[mode],
 		 setChip ? "set chip " : "");
 
@@ -3228,7 +3230,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 		ath9k_set_power_network_sleep(ah, setChip);
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 			 "%s: unknown power mode %u\n", __func__, mode);
 		return false;
 	}
@@ -3261,14 +3263,14 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 		ahp->ah_intrMitigation = true;
 
 	if (!ath9k_hw_set_reset_reg(ah, HAL_RESET_POWER_ON)) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: couldn't reset chip\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't reset chip\n",
 			 __func__);
 		ecode = HAL_EIO;
 		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE)) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: couldn't wakeup chip\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't wakeup chip\n",
 			 __func__);
 		ecode = HAL_EIO;
 		goto bad;
@@ -3283,14 +3285,15 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 				SER_REG_MODE_OFF;
 		}
 	}
-	HDPRINTF(ah, HAL_DBG_RESET, "%s: ath_hal_serializeRegMode is %d\n",
-		 __func__, ah->ah_config.ath_hal_serializeRegMode);
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
+		"%s: ath_hal_serializeRegMode is %d\n",
+		__func__, ah->ah_config.ath_hal_serializeRegMode);
 
 	if ((ah->ah_macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->ah_macVersion != AR_SREV_VERSION_5416_PCIE) &&
 	    (ah->ah_macVersion != AR_SREV_VERSION_9160) &&
 	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah))) {
-		HDPRINTF(ah, HAL_DBG_RESET,
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			 "%s: Mac Chip Rev 0x%02x.%x is not supported by "
 			 "this driver\n", __func__,
 			 ah->ah_macVersion, ah->ah_macRev);
@@ -3339,7 +3342,7 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 		}
 	}
 
-	HDPRINTF(ah, HAL_DBG_RESET,
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 		 "%s: This Mac Chip Rev 0x%02x.%x is \n", __func__,
 		 ah->ah_macVersion, ah->ah_macRev);
 
@@ -3474,7 +3477,7 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 #endif
 
 	if (!ath9k_hw_fill_cap_info(ah)) {
-		HDPRINTF(ah, HAL_DBG_RESET,
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			 "%s:failed ath9k_hw_fill_cap_info\n", __func__);
 		ecode = HAL_EEREAD;
 		goto bad;
@@ -3482,7 +3485,7 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 
 	ecode = ath9k_hw_init_macaddr(ah);
 	if (ecode != HAL_OK) {
-		HDPRINTF(ah, HAL_DBG_RESET,
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			 "%s: failed initializing mac address\n",
 			 __func__);
 		goto bad;
@@ -3871,11 +3874,11 @@ ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 					 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				HDPRINTF(ah, HAL_DBG_PHY_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
 					 "PDADC (%d,%4x): %4.4x %8.8x\n",
 					 i, regChainOffset, regOffset,
 					 reg32);
-				HDPRINTF(ah, HAL_DBG_PHY_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
 				"PDADC: Chain %d | PDADC %3d Value %3d | "
 				"PDADC %3d Value %3d | PDADC %3d Value %3d | "
 				"PDADC %3d Value %3d |\n",
@@ -4300,7 +4303,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 		    && ar5416_get_eep_rev(ahp) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
-		HDPRINTF(ah, HAL_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
 			"EXT_ADDITIVE %d\n",
 			 ctlMode, numCtlModes, isHt40CtlMode,
@@ -4308,7 +4311,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 
 		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i];
 		     i++) {
-			HDPRINTF(ah, HAL_DBG_POWER_MGMT,
+			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 				 "  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
 				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
 				"chan %d chanctl 0x%x\n",
@@ -4336,7 +4339,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 						IS_CHAN_2GHZ
 						(chan));
 
-				HDPRINTF(ah, HAL_DBG_POWER_MGMT,
+				DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 					"    MATCH-EE_IDX %d: ch %d is2 %d "
 					"2xMinEdge %d chainmask %d chains %d\n",
 					 i, freq, IS_CHAN_2GHZ(chan),
@@ -4357,7 +4360,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 
 		minCtlPower = min(twiceMaxEdgePower, scaledPower);
 
-		HDPRINTF(ah, HAL_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 				"    SEL-Min ctlMode %d pCtlMode %d "
 				"2xMaxEdge %d sP %d minCtlPwr %d\n",
 			 ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
@@ -4480,7 +4483,7 @@ ath9k_hw_set_txpower(struct ath_hal *ah,
 					       twiceAntennaReduction,
 					       twiceMaxRegulatoryPower,
 					       powerLimit)) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"ath9k_hw_set_txpower: unable to set "
 			"tx power per rate table\n");
 		return HAL_EIO;
@@ -4488,7 +4491,7 @@ ath9k_hw_set_txpower(struct ath_hal *ah,
 
 	if (!ath9k_hw_set_power_cal_table
 	    (ah, pEepData, chan, &txPowerIndexOffset)) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "ath9k_hw_set_txpower: unable to set power table\n");
 		return HAL_EIO;
 	}
@@ -5243,7 +5246,7 @@ static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u_int us)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: bad ack timeout %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad ack timeout %u\n",
 			 __func__, us);
 		ahp->ah_acktimeout = (u_int) -1;
 		return false;
@@ -5260,7 +5263,7 @@ static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u_int us)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: bad cts timeout %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad cts timeout %u\n",
 			 __func__, us);
 		ahp->ah_ctstimeout = (u_int) -1;
 		return false;
@@ -5277,8 +5280,8 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah,
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (tu > 0xFFFF) {
-		HDPRINTF(ah, HAL_DBG_TX, "%s: bad global tx timeout %u\n",
-			 __func__, tu);
+		DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
+			"%s: bad global tx timeout %u\n", __func__, tu);
 		ahp->ah_globaltxtimeout = (u_int) -1;
 		return false;
 	} else {
@@ -5293,7 +5296,7 @@ bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us < HAL_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: bad slot time %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad slot time %u\n",
 			 __func__, us);
 		ahp->ah_slottime = (u_int) -1;
 		return false;
@@ -5308,7 +5311,7 @@ static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	HDPRINTF(ah, HAL_DBG_RESET, "--AP %s ahp->ah_miscMode 0x%x\n",
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "--AP %s ahp->ah_miscMode 0x%x\n",
 		 __func__, ahp->ah_miscMode);
 	if (ahp->ah_miscMode != 0)
 		REG_WRITE(ah, AR_PCU_MISC,
@@ -5441,13 +5444,13 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 				      min((u_int32_t) MAX_RATE_POWER,
 					  (u_int32_t) ah->ah_powerLimit));
 	if (status != HAL_OK) {
-		HDPRINTF(ah, HAL_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 			 "%s: error init'ing transmit power\n", __func__);
 		return HAL_EIO;
 	}
 
 	if (!ath9k_hw_set_rf_regs(ah, ichan, freqIndex)) {
-		HDPRINTF(ah, HAL_DBG_REG_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 			 "%s: ar5416SetRfRegs failed\n", __func__);
 		return HAL_EIO;
 	}
@@ -5465,23 +5468,23 @@ static inline void ath9k_hw_setup_calibration(struct ath_hal *ah,
 	switch (currCal->calData->calType) {
 	case IQ_MISMATCH_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: starting IQ Mismatch Calibration\n",
 			 __func__);
 		break;
 	case ADC_GAIN_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_GAIN);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: starting ADC Gain Calibration\n", __func__);
 		break;
 	case ADC_DC_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_PER);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: starting ADC DC Calibration\n", __func__);
 		break;
 	case ADC_DC_INIT_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_INIT);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: starting Init ADC DC Calibration\n",
 			 __func__);
 		break;
@@ -5575,7 +5578,7 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 
 		if (!ath9k_hw_wait(ah, AR_PHY_TIMING_CTRL4(0),
 				   AR_PHY_TIMING_CTRL4_DO_CAL, 0)) {
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "%s: Cal %d failed to complete in 100ms.\n",
 				 __func__, calData->calType);
 
@@ -5587,7 +5590,7 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 		ath9k_hw_per_calibration(ah, &ichan, ahp->ah_rxchainmask,
 					 currCal, &isCalDone);
 		if (!isCalDone) {
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "%s: Not able to run Init Cal %d.\n",
 				 __func__, calData->calType);
 		}
@@ -5612,7 +5615,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
-			HDPRINTF(ah, HAL_DBG_QUEUE,
+			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 				 "%s: Transmit frames pending on queue %d\n",
 				 __func__, qnum);
 			return false;
@@ -5622,7 +5625,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
 	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
 			   AR_PHY_RFBUS_GRANT_EN)) {
-		HDPRINTF(ah, HAL_DBG_PHY_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
 			 "%s: Could not kill baseband RX\n", __func__);
 		return false;
 	}
@@ -5631,13 +5634,13 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		if (!(ath9k_hw_ar9280_set_channel(ah, ichan))) {
-			HDPRINTF(ah, HAL_DBG_CHANNEL,
+			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 				 "%s: failed to set channel\n", __func__);
 			return false;
 		}
 	} else {
 		if (!(ath9k_hw_set_channel(ah, ichan))) {
-			HDPRINTF(ah, HAL_DBG_CHANNEL,
+			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 				 "%s: failed to set channel\n", __func__);
 			return false;
 		}
@@ -5650,7 +5653,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 				 min((u_int32_t) MAX_RATE_POWER,
 				     (u_int32_t) ah->ah_powerLimit))
 	    != HAL_OK) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: error init'ing transmit power\n", __func__);
 		return false;
 	}
@@ -5729,10 +5732,11 @@ bool ath9k_hw_stopdmarecv(struct ath_hal *ah)
 {
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
 	if (!ath9k_hw_wait(ah, AR_CR, AR_CR_RXE, 0)) {
-		HDPRINTF(ah, HAL_DBG_RX, "%s: dma failed to stop in 10ms\n"
-			 "AR_CR=0x%08x\nAR_DIAG_SW=0x%08x\n",
-			 __func__,
-			 REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
+			"%s: dma failed to stop in 10ms\n"
+			"AR_CR=0x%08x\nAR_DIAG_SW=0x%08x\n",
+			__func__,
+			REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
 		return false;
 	} else {
 		return true;
@@ -5792,7 +5796,7 @@ static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
 
 	if (!ath9k_hw_wait
 	    (ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL, 0)) {
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: offset calibration failed to complete in 1ms; "
 			 "noisy environment?\n", __func__);
 		return false;
@@ -5809,21 +5813,21 @@ static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
 		if (ath9k_hw_iscal_supported(ah, chan, ADC_GAIN_CAL)) {
 			INIT_CAL(&ahp->ah_adcGainCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcGainCalData);
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "%s: enabling ADC Gain Calibration.\n",
 				 __func__);
 		}
 		if (ath9k_hw_iscal_supported(ah, chan, ADC_DC_CAL)) {
 			INIT_CAL(&ahp->ah_adcDcCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcDcCalData);
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "%s: enabling ADC DC Calibration.\n",
 				 __func__);
 		}
 		if (ath9k_hw_iscal_supported(ah, chan, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ahp->ah_iqCalData);
 			INSERT_CAL(ahp, &ahp->ah_iqCalData);
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "%s: enabling IQ Calibration.\n",
 				 __func__);
 		}
@@ -5870,7 +5874,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 
 	ichan = ath9k_hw_check_chan(ah, chan);
 	if (ichan == NULL) {
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
 		FAIL(HAL_EINVAL);
@@ -5917,7 +5921,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 	ath9k_hw_mark_phy_inactive(ah);
 
 	if (!ath9k_hw_chip_reset(ah, chan)) {
-		HDPRINTF(ah, HAL_DBG_RESET, "%s: chip reset failed\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: chip reset failed\n",
 			 __func__);
 		FAIL(HAL_EIO);
 	}
@@ -5948,7 +5952,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 		ath9k_hw_spur_mitigate(ah, chan);
 
 	if (!ath9k_hw_eeprom_set_board_values(ah, ichan)) {
-		HDPRINTF(ah, HAL_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: error setting board options\n", __func__);
 		FAIL(HAL_EIO);
 	}
@@ -6029,14 +6033,14 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 		u_int32_t mask;
 		mask = REG_READ(ah, AR_CFG);
 		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
-			HDPRINTF(ah, HAL_DBG_RESET,
+			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 				 "%s CFG Byte Swap Set 0x%x\n", __func__,
 				 mask);
 		} else {
 			mask =
 				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
 			REG_WRITE(ah, AR_CFG, mask);
-			HDPRINTF(ah, HAL_DBG_RESET,
+			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 				 "%s Setting CFG 0x%x\n", __func__,
 				 REG_READ(ah, AR_CFG));
 		}
@@ -6081,7 +6085,7 @@ ath9k_hw_calibrate(struct ath_hal *ah, struct hal_channel *chan,
 	*isCalDone = true;
 
 	if (ichan == NULL) {
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
 		return false;
@@ -6129,7 +6133,7 @@ static void ath9k_hw_iqcal_collect(struct ath_hal *ah)
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
 		ahp->ah_totalIqCorrMeas[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
 			 ahp->ah_CalSamples, i, ahp->ah_totalPowerMeasI[i],
 			 ahp->ah_totalPowerMeasQ[i],
@@ -6152,7 +6156,7 @@ static void ath9k_hw_adc_gaincal_collect(struct ath_hal *ah)
 		ahp->ah_totalAdcQEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
 			 ahp->ah_CalSamples, i,
@@ -6178,7 +6182,7 @@ static void ath9k_hw_adc_dccal_collect(struct ath_hal *ah)
 		ahp->ah_totalAdcDcOffsetQEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
 			"oddq=0x%08x; evenq=0x%08x;\n",
 			 ahp->ah_CalSamples, i,
@@ -6202,11 +6206,11 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
 		powerMeasQ = ahp->ah_totalPowerMeasQ[i];
 		iqCorrMeas = ahp->ah_totalIqCorrMeas[i];
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Starting IQ Cal and Correction for Chain %d\n",
 			 i);
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Orignal: Chn %diq_corr_meas = 0x%08x\n",
 			 i, ahp->ah_totalIqCorrMeas[i]);
 
@@ -6218,11 +6222,11 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
 			iqCorrNeg = 1;
 		}
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
 			 iqCorrNeg);
 
 		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 128;
@@ -6232,14 +6236,14 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
 
 			iCoff = iqCorrMeas / iCoffDenom;
 			qCoff = powerMeasI / qCoffDenom - 64;
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "Chn %d iCoff = 0x%08x\n", i, iCoff);
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "Chn %d qCoff = 0x%08x\n", i, qCoff);
 
 
 			iCoff = iCoff & 0x3f;
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "New: Chn %d iCoff = 0x%08x\n", i, iCoff);
 			if (iqCorrNeg == 0x0)
 				iCoff = 0x40 - iCoff;
@@ -6249,7 +6253,7 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
 			else if (qCoff <= -16)
 				qCoff = 16;
 
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
 				 i, iCoff, qCoff);
 
@@ -6259,7 +6263,7 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
 			OS_REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
 					 AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
 					 qCoff);
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "IQ Cal and Correction done for Chain %d\n",
 				 i);
 		}
@@ -6283,19 +6287,19 @@ ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 		qOddMeasOffset = ahp->ah_totalAdcQOddPhase[i];
 		qEvenMeasOffset = ahp->ah_totalAdcQEvenPhase[i];
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Starting ADC Gain Cal for Chain %d\n", i);
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_odd_i = 0x%08x\n", i,
 			 iOddMeasOffset);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_even_i = 0x%08x\n", i,
 			 iEvenMeasOffset);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_odd_q = 0x%08x\n", i,
 			 qOddMeasOffset);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_even_q = 0x%08x\n", i,
 			 qEvenMeasOffset);
 
@@ -6307,10 +6311,10 @@ ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 				((qOddMeasOffset * 32) /
 				 qEvenMeasOffset) & 0x3f;
 
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "Chn %d gain_mismatch_i = 0x%08x\n", i,
 				 iGainMismatch);
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "Chn %d gain_mismatch_q = 0x%08x\n", i,
 				 qGainMismatch);
 
@@ -6319,7 +6323,7 @@ ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 			val |= (qGainMismatch) | (iGainMismatch << 6);
 			REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-			HDPRINTF(ah, HAL_DBG_CALIBRATE,
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "ADC Gain Cal done for Chain %d\n", i);
 		}
 	}
@@ -6346,19 +6350,19 @@ ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 		qOddMeasOffset = ahp->ah_totalAdcDcOffsetQOddPhase[i];
 		qEvenMeasOffset = ahp->ah_totalAdcDcOffsetQEvenPhase[i];
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Starting ADC DC Offset Cal for Chain %d\n", i);
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_odd_i = %d\n", i,
 			 iOddMeasOffset);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_even_i = %d\n", i,
 			 iEvenMeasOffset);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_odd_q = %d\n", i,
 			 qOddMeasOffset);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d pwr_meas_even_q = %d\n", i,
 			 qEvenMeasOffset);
 
@@ -6367,10 +6371,10 @@ ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 		qDcMismatch = (((qOddMeasOffset - qEvenMeasOffset) * 2) /
 			       numSamples) & 0x1ff;
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d dc_offset_mismatch_i = 0x%08x\n", i,
 			 iDcMismatch);
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "Chn %d dc_offset_mismatch_q = 0x%08x\n", i,
 			 qDcMismatch);
 
@@ -6379,7 +6383,7 @@ ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 		val |= (qDcMismatch << 12) | (iDcMismatch << 21);
 		REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "ADC DC Offset Cal done for Chain %d\n", i);
 	}
 
@@ -6464,7 +6468,7 @@ ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
 		return;
 
 	if (ichan == NULL) {
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
 		return;
@@ -6472,7 +6476,7 @@ ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
 
 
 	if (currCal->calState != CAL_DONE) {
-		HDPRINTF(ah, HAL_DBG_CALIBRATE,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			 "%s: Calibration state incorrect, %d\n",
 			 __func__, currCal->calState);
 		return;
@@ -6483,7 +6487,7 @@ ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
 		return;
 	}
 
-	HDPRINTF(ah, HAL_DBG_CALIBRATE,
+	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 		 "%s: Resetting Cal %d state for channel %u/0x%x\n",
 		 __func__, currCal->calData->calType, chan->channel,
 		 chan->channelFlags);
@@ -6585,7 +6589,7 @@ void ath9k_hw_reset_tsf(struct ath_hal *ah)
 	while (REG_READ(ah, AR_SLP32_MODE) & AR_SLP32_TSF_WRITE_STATUS) {
 		count++;
 		if (count > 10) {
-			HDPRINTF(ah, HAL_DBG_RESET,
+			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			 "%s: AR_SLP32_TSF_WRITE_STATUS limit exceeded\n",
 				 __func__);
 			break;
@@ -6877,7 +6881,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 		}
 
 		if (isr & AR_ISR_RXORN) {
-			HDPRINTF(ah, HAL_DBG_INTERRUPT,
+			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
 				 "%s: receive FIFO overrun interrupt\n",
 				 __func__);
 		}
@@ -6902,18 +6906,18 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 
 		if (fatal_int) {
 			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
-				HDPRINTF(ah, HAL_DBG_UNMASKABLE,
+				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 					 "%s: received PCI FATAL interrupt\n",
 					 __func__);
 			}
 			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
-				HDPRINTF(ah, HAL_DBG_UNMASKABLE,
+				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 					 "%s: received PCI PERR interrupt\n",
 					 __func__);
 			}
 		}
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
-			HDPRINTF(ah, HAL_DBG_INTERRUPT,
+			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
 				 "%s: AR_INTR_SYNC_RADM_CPL_TIMEOUT\n",
 				 __func__);
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
@@ -6921,7 +6925,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 			*masked |= HAL_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
-			HDPRINTF(ah, HAL_DBG_INTERRUPT,
+			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
 				 "%s: AR_INTR_SYNC_LOCAL_TIMEOUT\n",
 				 __func__);
 		}
@@ -6944,11 +6948,11 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 	u_int32_t mask, mask2;
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
-	HDPRINTF(ah, HAL_DBG_INTERRUPT, "%s: 0x%x => 0x%x\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: 0x%x => 0x%x\n", __func__,
 		 omask, ints);
 
 	if (omask & HAL_INT_GLOBAL) {
-		HDPRINTF(ah, HAL_DBG_INTERRUPT, "%s: disable IER\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: disable IER\n",
 			 __func__);
 		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
 		(void) REG_READ(ah, AR_IER);
@@ -7004,7 +7008,7 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 			mask2 |= AR_IMR_S2_CST;
 	}
 
-	HDPRINTF(ah, HAL_DBG_INTERRUPT, "%s: new IMR 0x%x\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: new IMR 0x%x\n", __func__,
 		 mask);
 	REG_WRITE(ah, AR_IMR, mask);
 	mask = REG_READ(ah, AR_IMR_S2) & ~(AR_IMR_S2_TIM |
@@ -7025,7 +7029,7 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 	}
 
 	if (ints & HAL_INT_GLOBAL) {
-		HDPRINTF(ah, HAL_DBG_INTERRUPT, "%s: enable IER\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: enable IER\n",
 			 __func__);
 		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
 		if (!AR_SREV_9100(ah)) {
@@ -7039,7 +7043,7 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 			REG_WRITE(ah, AR_INTR_SYNC_MASK,
 				  AR_INTR_SYNC_DEFAULT);
 		}
-		HDPRINTF(ah, HAL_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
 			 REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
 	}
 
@@ -7131,13 +7135,13 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 	else
 		nextTbtt = bs->bs_nexttbtt;
 
-	HDPRINTF(ah, HAL_DBG_BEACON, "%s: next DTIM %d\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: next DTIM %d\n", __func__,
 		 bs->bs_nextdtim);
-	HDPRINTF(ah, HAL_DBG_BEACON, "%s: next beacon %d\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: next beacon %d\n", __func__,
 		 nextTbtt);
-	HDPRINTF(ah, HAL_DBG_BEACON, "%s: beacon period %d\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: beacon period %d\n", __func__,
 		 beaconintval);
-	HDPRINTF(ah, HAL_DBG_BEACON, "%s: DTIM period %d\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: DTIM period %d\n", __func__,
 		 dtimperiod);
 
 	REG_WRITE(ah, AR_NEXT_DTIM,
@@ -7180,7 +7184,7 @@ bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry)
 	u_int32_t keyType;
 
 	if (entry >= ah->ah_caps.halKeyCacheSize) {
-		HDPRINTF(ah, HAL_DBG_KEYCACHE,
+		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
 		return false;
 	}
@@ -7218,7 +7222,7 @@ ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
 	u_int32_t macHi, macLo;
 
 	if (entry >= ah->ah_caps.halKeyCacheSize) {
-		HDPRINTF(ah, HAL_DBG_KEYCACHE,
+		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
 		return false;
 	}
@@ -7253,7 +7257,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (entry >= pCap->halKeyCacheSize) {
-		HDPRINTF(ah, HAL_DBG_KEYCACHE,
+		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
 		return false;
 	}
@@ -7263,7 +7267,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		break;
 	case HAL_CIPHER_AES_CCM:
 		if (!pCap->halCipherAesCcmSupport) {
-			HDPRINTF(ah, HAL_DBG_KEYCACHE,
+			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: AES-CCM not supported by "
 				 "mac rev 0x%x\n", __func__,
 				 ah->ah_macRev);
@@ -7275,7 +7279,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		keyType = AR_KEYTABLE_TYPE_TKIP;
 		if (ATH9K_IS_MIC_ENABLED(ah)
 		    && entry + 64 >= pCap->halKeyCacheSize) {
-			HDPRINTF(ah, HAL_DBG_KEYCACHE,
+			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: entry %u inappropriate for TKIP\n",
 				 __func__, entry);
 			return false;
@@ -7283,7 +7287,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		break;
 	case HAL_CIPHER_WEP:
 		if (k->kv_len < 40 / NBBY) {
-			HDPRINTF(ah, HAL_DBG_KEYCACHE,
+			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: WEP key length %u too small\n",
 				 __func__, k->kv_len);
 			return false;
@@ -7299,7 +7303,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		keyType = AR_KEYTABLE_TYPE_CLR;
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_KEYCACHE,
+		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			 "%s: cipher %u not supported\n", __func__,
 			 k->kv_type);
 		return false;
@@ -7412,12 +7416,12 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 	u_int32_t cw;
 
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
 		return false;
 	}
 
-	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: queue %p\n", __func__, qi);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %p\n", __func__, qi);
 
 	qi->tqi_ver = qInfo->tqi_ver;
 	qi->tqi_subtype = qInfo->tqi_subtype;
@@ -7473,7 +7477,7 @@ bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
 	if (q >= pCap->halTotalQueues) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
 	}
@@ -7485,7 +7489,7 @@ static bool ath9k_hw_get_txq_props(struct ath_hal *ah,
 				   const struct hal_tx_queue_info *qi)
 {
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
 		return false;
 	}
@@ -7516,7 +7520,7 @@ ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
 	if (q >= pCap->halTotalQueues) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
 	}
@@ -7551,22 +7555,22 @@ ath9k_hw_setuptxqueue(struct ath_hal *ah, enum hal_tx_queue type,
 			    HAL_TX_QUEUE_INACTIVE)
 				break;
 		if (q == pCap->halTotalQueues) {
-			HDPRINTF(ah, HAL_DBG_QUEUE,
+			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 				 "%s: no available tx queue\n", __func__);
 			return -1;
 		}
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: bad tx queue type %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: bad tx queue type %u\n",
 			 __func__, type);
 		return -1;
 	}
 
-	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: queue %u\n", __func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %u\n", __func__, q);
 
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type != HAL_TX_QUEUE_INACTIVE) {
-		HDPRINTF(ah, HAL_DBG_QUEUE,
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 			 "%s: tx queue %u already active\n", __func__, q);
 		return -1;
 	}
@@ -7597,7 +7601,7 @@ ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	HDPRINTF(ah, HAL_DBG_INTERRUPT,
+	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
 		 "%s: tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
 		 __func__, ahp->ah_txOkInterruptMask,
 		 ahp->ah_txErrInterruptMask, ahp->ah_txDescInterruptMask,
@@ -7622,18 +7626,19 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 	struct hal_tx_queue_info *qi;
 
 	if (q >= pCap->halTotalQueues) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
 	}
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue %u\n",
 			 __func__, q);
 		return false;
 	}
 
-	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: release queue %u\n", __func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: release queue %u\n",
+		__func__, q);
 
 	qi->tqi_type = HAL_TX_QUEUE_INACTIVE;
 	ahp->ah_txOkInterruptMask &= ~(1 << q);
@@ -7655,18 +7660,18 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 	u_int32_t cwMin, chanCwMin, value;
 
 	if (q >= pCap->halTotalQueues) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
 	}
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
-		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue %u\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue %u\n",
 			 __func__, q);
 		return true;
 	}
 
-	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: reset queue %u\n", __func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: reset queue %u\n", __func__, q);
 
 	if (qi->tqi_cwmin == HAL_TXQ_USEDEFAULT) {
 		if (chan && IS_CHAN_B(chan))
@@ -8120,7 +8125,7 @@ bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 					AR_DIAG_RX_ABORT));
 
 			reg = REG_READ(ah, AR_OBS_BUS_1);
-			HDPRINTF(ah, HAL_DBG_RX,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"%s: rx failed to go idle in 10 ms RXSM=0x%x\n",
 				__func__, reg);
 
@@ -8281,7 +8286,7 @@ const struct hal_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
 		rt = &ar5416_11na_table;
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_CHANNEL, "%s: invalid mode 0x%x\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL, "%s: invalid mode 0x%x\n",
 			 __func__, mode);
 		return NULL;
 	}
@@ -8326,7 +8331,7 @@ struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 		ah = ath9k_hw_do_attach(devid, sc, mem, error);
 		break;
 	default:
-		HDPRINTF(ah, HAL_DBG_UNMASKABLE,
+		DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 			 "devid=0x%x not supported.\n", devid);
 		ah = NULL;
 		*error = HAL_ENXIO;
@@ -8398,7 +8403,7 @@ ath9k_hw_computetxtime(struct ath_hal *ah,
 		break;
 
 	default:
-		HDPRINTF(ah, HAL_DBG_PHY_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
 			 "%s: unknown phy %u (rate ix %u)\n", __func__,
 			 rates->info[rateix].phy, rateix);
 		txTime = 0;
@@ -8454,7 +8459,7 @@ ath9k_hw_getchan_noise(struct ath_hal *ah, struct hal_channel *chan)
 
 	ichan = ath9k_regd_check_channel(ah, chan);
 	if (ichan == NULL) {
-		HDPRINTF(ah, HAL_DBG_NF_CAL,
+		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
 		return 0;
@@ -8499,7 +8504,7 @@ bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
 
 bool ath9k_hw_txstart(struct ath_hal *ah, u_int q)
 {
-	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: queue %u\n", __func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %u\n", __func__, q);
 
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 
@@ -8534,7 +8539,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 	if (ath9k_hw_numtxpending(ah, q)) {
 		u_int32_t tsfLow, j;
 
-		HDPRINTF(ah, HAL_DBG_QUEUE,
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 			 "%s: Num of pending TX Frames %d on Q %d\n",
 			 __func__, ath9k_hw_numtxpending(ah, q), q);
 
@@ -8551,7 +8556,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 			    (tsfLow >> 10)) {
 				break;
 			}
-			HDPRINTF(ah, HAL_DBG_QUEUE,
+			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 				"%s: TSF have moved while trying to set "
 				"quiet time TSF: 0x%08x\n",
 				__func__, tsfLow);
@@ -8566,7 +8571,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
-				HDPRINTF(ah, HAL_DBG_TX,
+				DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
 					"%s: Failed to stop Tx DMA in 100 "
 					"msec after killing last frame\n",
 					__func__);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index aeeb962..24f69ef 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -108,7 +108,7 @@ static int ath_setkey_tkip(struct ath_softc *sc,
 	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
 	if (!ath_keyset(sc, key->keyidx, hk, NULL)) {
 		/* Txmic entry failed. No need to proceed further */
-		DPRINTF(sc, ATH_DEBUG_KEYCACHE,
+		DPRINTF(sc, ATH_DBG_KEYCACHE,
 			"%s Setting TX MIC Key Failed\n", __func__);
 		return 0;
 	}
@@ -321,7 +321,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct hal_channel hchan;
 	int error = 0;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Starting driver with "
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Starting driver with "
 		"initial channel: %d MHz\n", __func__, curchan->center_freq);
 
 	/* setup initial channel */
@@ -332,7 +332,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	/* open ath_dev */
 	error = ath_open(sc, &hchan);
 	if (error) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to complete ath_open\n", __func__);
 		return error;
 	}
@@ -357,12 +357,12 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		memmove(skb->data, skb->data + padsize, hdrlen);
 	}
 
-	DPRINTF(sc, ATH_DEBUG_XMIT, "%s: transmitting packet, skb: %p\n",
+	DPRINTF(sc, ATH_DBG_XMIT, "%s: transmitting packet, skb: %p\n",
 		__func__,
 		skb);
 
 	if (ath_tx_start(sc, skb) != 0) {
-		DPRINTF(sc, ATH_DEBUG_XMIT, "%s: TX failed\n", __func__);
+		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX failed\n", __func__);
 		dev_kfree_skb_any(skb);
 		/* FIXME: Check for proper return value from ATH_DEV */
 		return 0;
@@ -376,11 +376,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	int error;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Driver halt\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Driver halt\n", __func__);
 
 	error = ath_suspend(sc);
 	if (error)
-		DPRINTF(sc, ATH_DEBUG_CONFIG,
+		DPRINTF(sc, ATH_DBG_CONFIG,
 			"%s: Device is no longer present\n", __func__);
 
 	ieee80211_stop_queues(hw);
@@ -408,13 +408,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		break;
 	}
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Attach a VAP of type: %d\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach a VAP of type: %d\n",
 		__func__,
 		ic_opmode);
 
 	error = ath_vap_attach(sc, 0, conf->vif, ic_opmode, ic_opmode, 0);
 	if (error) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to attach vap, error: %d\n",
 			__func__, error);
 		goto bad;
@@ -432,11 +432,11 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	struct ath_vap *avp;
 	int error;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Detach VAP\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach VAP\n", __func__);
 
 	avp = sc->sc_vaps[0];
 	if (avp == NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: Invalid interface\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
 			__func__);
 		return;
 	}
@@ -462,7 +462,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	error = ath_vap_detach(sc, 0);
 	if (error)
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to detach vap, error: %d\n",
 			__func__, error);
 }
@@ -474,7 +474,7 @@ static int ath9k_config(struct ieee80211_hw *hw,
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct hal_channel hchan;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Set channel: %d MHz\n",
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
 		__func__,
 		curchan->center_freq);
 
@@ -484,7 +484,7 @@ static int ath9k_config(struct ieee80211_hw *hw,
 
 	/* set h/w channel */
 	if (ath_set_channel(sc, &hchan) < 0)
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: Unable to set channel\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: Unable to set channel\n",
 			__func__);
 
 	return 0;
@@ -502,7 +502,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 
 	avp = sc->sc_vaps[0];
 	if (avp == NULL) {
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: Invalid interface\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
 			__func__);
 		return -EINVAL;
 	}
@@ -549,7 +549,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 						~(HAL_INT_SWBA | HAL_INT_BMISS));
 			sc->sc_imask &= ~(HAL_INT_SWBA | HAL_INT_BMISS);
 
-			DPRINTF(sc, ATH_DEBUG_CONFIG,
+			DPRINTF(sc, ATH_DBG_CONFIG,
 				"%s: RX filter 0x%x bssid %s aid 0x%x\n",
 				__func__, rfilt,
 				print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
@@ -646,7 +646,7 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 		spin_lock_irqsave(&sc->node_lock, flags);
 		if (!an) {
 			ath_node_attach(sc, (u8 *)addr, 0);
-			DPRINTF(sc, ATH_DEBUG_NODE, "%s: Attach a node: %s\n",
+			DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach a node: %s\n",
 				__func__,
 				print_mac(mac, addr));
 		} else {
@@ -656,12 +656,12 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 		break;
 	case STA_NOTIFY_REMOVE:
 		if (!an)
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Removal of a non-existent node\n",
 				__func__);
 		else {
 			ath_node_put(sc, an, ATH9K_BH_STATUS_INTACT);
-			DPRINTF(sc, ATH_DEBUG_NODE, "%s: Put a node: %s\n",
+			DPRINTF(sc, ATH_DBG_CONFIG, "%s: Put a node: %s\n",
 				__func__,
 				print_mac(mac, addr));
 		}
@@ -688,7 +688,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	qi.tqi_burstTime = params->txop;
 	qnum = ath_get_hal_qnum(queue, sc);
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG,
+	DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: Configure tx [queue/halq] [%d/%d],  "
 		"aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
 		__func__,
@@ -701,7 +701,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 
 	ret = ath_txq_update(sc, qnum, &qi);
 	if (ret)
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: TXQ Update failed\n", __func__);
 
 	return ret;
@@ -716,7 +716,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
-	DPRINTF(sc, ATH_DEBUG_KEYCACHE, " %s: Set HW Key\n", __func__);
+	DPRINTF(sc, ATH_DBG_KEYCACHE, " %s: Set HW Key\n", __func__);
 
 	switch (cmd) {
 	case SET_KEY:
@@ -781,13 +781,13 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 	DECLARE_MAC_BUF(mac);
 
 	if (bss_conf->assoc) {
-		DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Bss Info ASSOC %d\n",
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info ASSOC %d\n",
 			__func__,
 			bss_conf->aid);
 
 		avp = sc->sc_vaps[0];
 		if (avp == NULL) {
-			DPRINTF(sc, ATH_DEBUG_FATAL, "%s: Invalid interface\n",
+			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
 				__func__);
 			return;
 		}
@@ -815,12 +815,12 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		/* Update chainmask */
 		ath_update_chainmask(sc, bss_conf->assoc_ht);
 
-		DPRINTF(sc, ATH_DEBUG_CONFIG,
+		DPRINTF(sc, ATH_DBG_CONFIG,
 			"%s: bssid %s aid 0x%x\n",
 			__func__,
 			print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
 
-		DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Set channel: %d MHz\n",
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
 			__func__,
 			curchan->center_freq);
 
@@ -829,11 +829,11 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		/* set h/w channel */
 		if (ath_set_channel(sc, &hchan) < 0)
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to set channel\n",
 				__func__);
 	} else {
-		DPRINTF(sc, ATH_DEBUG_CONFIG,
+		DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: Bss Info DISSOC\n", __func__);
 		sc->sc_curaid = 0;
 	}
@@ -847,7 +847,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: BSS Changed PREAMBLE %d\n",
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed PREAMBLE %d\n",
 			__func__,
 			bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
@@ -857,7 +857,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: BSS Changed CTS PROT %d\n",
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed CTS PROT %d\n",
 			__func__,
 			bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot &&
@@ -868,14 +868,14 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: BSS Changed HT %d\n",
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed HT %d\n",
 			__func__,
 			bss_conf->assoc_ht);
 		ath9k_ht_conf(sc, bss_conf);
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: BSS Changed ASSOC %d\n",
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed ASSOC %d\n",
 			__func__,
 			bss_conf->assoc);
 		ath9k_bss_assoc_info(sc, bss_conf);
@@ -914,21 +914,21 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_START:
 		ret = ath_rx_aggr_start(sc, addr, tid, ssn);
 		if (ret < 0)
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to start RX aggregation\n",
 				__func__);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		ret = ath_rx_aggr_stop(sc, addr, tid);
 		if (ret < 0)
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to stop RX aggregation\n",
 				__func__);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		ret = ath_tx_aggr_start(sc, addr, tid, ssn);
 		if (ret < 0)
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to start TX aggregation\n",
 				__func__);
 		else
@@ -937,14 +937,14 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_STOP:
 		ret = ath_tx_aggr_stop(sc, addr, tid);
 		if (ret < 0)
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to stop TX aggregation\n",
 				__func__);
 
 		ieee80211_stop_tx_ba_cb_irqsafe(hw, (u8 *)addr, tid);
 		break;
 	default:
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unknown AMPDU action\n", __func__);
 	}
 
@@ -1077,7 +1077,7 @@ void ath_setup_channel_list(struct ath_softc *sc,
 					flags;
 				sc->sbands[IEEE80211_BAND_2GHZ].n_channels++;
 				a++;
-				DPRINTF(sc, ATH_DEBUG_CONFIG,
+				DPRINTF(sc, ATH_DBG_CONFIG,
 					"%s: 2MHz channel: %d, "
 					"channelFlags: 0x%x\n",
 					__func__,
@@ -1104,7 +1104,7 @@ void ath_setup_channel_list(struct ath_softc *sc,
 					flags = flags;
 				sc->sbands[IEEE80211_BAND_5GHZ].n_channels++;
 				b++;
-				DPRINTF(sc, ATH_DEBUG_CONFIG,
+				DPRINTF(sc, ATH_DBG_CONFIG,
 					"%s: 5MHz channel: %d, "
 					"channelFlags: 0x%x\n",
 					__func__,
@@ -1144,7 +1144,7 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 
-	DPRINTF(sc, ATH_DEBUG_XMIT,
+	DPRINTF(sc, ATH_DBG_XMIT,
 		"%s: TX complete: skb: %p\n", __func__, skb);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
@@ -1270,7 +1270,7 @@ void ath_setup_rate(struct ath_softc *sc,
 		maxrates = rt->rateCount;
 
 	if ((band_2ghz->n_bitrates != 0) && (band_5ghz->n_bitrates != 0)) {
-		DPRINTF(sc, ATH_DEBUG_CONFIG,
+		DPRINTF(sc, ATH_DBG_CONFIG,
 			"%s: Rates already setup\n", __func__);
 		return;
 	}
@@ -1297,7 +1297,7 @@ void ath_setup_rate(struct ath_softc *sc,
 
 	if (band_2ghz->n_bitrates) {
 		for (i = 0; i < band_2ghz->n_bitrates; i++) {
-			DPRINTF(sc, ATH_DEBUG_CONFIG,
+			DPRINTF(sc, ATH_DBG_CONFIG,
 				"%s: 2GHz Rate: %2dMbps, ratecode: %2d\n",
 				__func__,
 				rates_2ghz[i].bitrate / 10,
@@ -1305,7 +1305,7 @@ void ath_setup_rate(struct ath_softc *sc,
 		}
 	} else if (band_5ghz->n_bitrates) {
 		for (i = 0; i < band_5ghz->n_bitrates; i++) {
-			DPRINTF(sc, ATH_DEBUG_CONFIG,
+			DPRINTF(sc, ATH_DBG_CONFIG,
 				"%s: 5Ghz Rate: %2dMbps, ratecode: %2d\n",
 				__func__,
 				rates_5ghz[i].bitrate / 10,
@@ -1318,7 +1318,7 @@ static int ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Detach ATH hw\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
 
 	/* Unregister hw */
 
@@ -1345,7 +1345,7 @@ static int ath_attach(u_int16_t devid,
 	struct ieee80211_hw *hw = sc->hw;
 	int error = 0;
 
-	DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: Attach ATH hw\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach ATH hw\n", __func__);
 
 	error = ath_init(devid, sc);
 	if (error != 0)
@@ -1400,7 +1400,7 @@ static int ath_attach(u_int16_t devid,
 	hw->rate_control_algorithm = "ath9k_rate_control";
 	error = ath_rate_control_register();
 	if (error != 0) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to register rate control "
 			"algorithm:%d\n", __func__, error);
 		ath_rate_control_unregister();
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 37af73e..e1fc9c6 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
+#include "core.h"
 #include "hw.h"
 #include "reg.h"
 #include "phy.h"
@@ -51,7 +51,7 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
 			channelSel = ((freq - 704) * 2 - 3040) / 10;
 			bModeSynth = 1;
 		} else {
-			HDPRINTF(ah, HAL_DBG_CHANNEL,
+			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 				 "%s: invalid channel %u MHz\n", __func__,
 				 freq);
 			return false;
@@ -85,7 +85,7 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
 		channelSel = ath9k_hw_reverse_bits((freq - 4800) / 5, 8);
 		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
 	} else {
-		HDPRINTF(ah, HAL_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u MHz\n", __func__, freq);
 		return false;
 	}
@@ -362,7 +362,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 		    || ahp->ah_analogBank6Data == NULL
 		    || ahp->ah_analogBank6TPCData == NULL
 		    || ahp->ah_analogBank7Data == NULL) {
-			HDPRINTF(ah, HAL_DBG_MALLOC,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				 "%s: cannot allocate RF banks\n",
 				 __func__);
 			*status = HAL_ENOMEM;
@@ -374,7 +374,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 			     ahp->ah_iniAddac.ia_rows *
 			     ahp->ah_iniAddac.ia_columns), GFP_KERNEL);
 		if (ahp->ah_addac5416_21 == NULL) {
-			HDPRINTF(ah, HAL_DBG_MALLOC,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				 "%s: cannot allocate ah_addac5416_21\n",
 				 __func__);
 			*status = HAL_ENOMEM;
@@ -385,7 +385,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 		    kzalloc((sizeof(u_int32_t) *
 			     ahp->ah_iniBank6.ia_rows), GFP_KERNEL);
 		if (ahp->ah_bank6Temp == NULL) {
-			HDPRINTF(ah, HAL_DBG_MALLOC,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				 "%s: cannot allocate ah_bank6Temp\n",
 				 __func__);
 			*status = HAL_ENOMEM;
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 9b75467..6c05257 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -518,7 +518,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah,
 		int r;							\
 		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
 			REG_WRITE(ah, INI_RA((iniarray), r, 0), (regData)[r]); \
-			HDPRINTF(ah, HAL_DBG_CHANNEL, \
+			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL, \
 				"RF 0x%x V 0x%x\n", \
 				INI_RA((iniarray), r, 0), (regData)[r]); \
 			DO_DELAY(regWr);				\
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 3c2b1cb..996b54c 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1149,7 +1149,7 @@ void ath_rate_findrate(struct ath_softc *sc,
 {
 	struct ath_vap         *avp = ath_rc_priv->avp;
 
-	DPRINTF(sc, ATH_DEBUG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
 	if (!num_rates || !num_tries)
 		return;
 
@@ -1822,7 +1822,7 @@ static void ath_setup_rates(struct ieee80211_local *local, struct sta_info *sta)
 	struct ath_rate_node *rc_priv = sta->rate_ctrl_priv;
 	int i, j = 0;
 
-	DPRINTF(sc, ATH_DEBUG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
 	sband =  local->hw.wiphy->bands[local->hw.conf.channel->band];
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[local->hw.conf.channel->band] & BIT(i)) {
@@ -1920,7 +1920,7 @@ static void ath_tx_aggr_resp(struct ath_softc *sc,
 		txtid->addba_exchangeinprogress = 0;
 		txtid->baw_size = buffersize;
 
-		DPRINTF(sc, ATH_DEBUG_AGGR,
+		DPRINTF(sc, ATH_DBG_AGGR,
 			"%s: Resuming tid, buffersize: %d\n",
 			__func__,
 			buffersize);
@@ -1949,7 +1949,7 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 	u8 *qc, tid;
 	DECLARE_MAC_BUF(mac);
 
-	DPRINTF(sc, ATH_DEBUG_RATE, "%s\n", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
 	/* allocate driver private area of tx_info */
 	tx_info->driver_data[0] = kzalloc(sizeof(*tx_info_priv), GFP_ATOMIC);
@@ -1999,7 +1999,7 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 			spin_unlock_bh(&sc->node_lock);
 
 			if (!an) {
-				DPRINTF(sc, ATH_DEBUG_AGGR,
+				DPRINTF(sc, ATH_DBG_AGGR,
 					"%s: Node not found to "
 					"init/chk TX aggr\n", __func__);
 				return;
@@ -2010,13 +2010,13 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 				ret = ieee80211_start_tx_ba_session(hw,
 					hdr->addr1, tid);
 				if (ret)
-					DPRINTF(sc, ATH_DEBUG_AGGR,
+					DPRINTF(sc, ATH_DBG_AGGR,
 						"%s: Unable to start tx "
 						"aggr for: %s\n",
 						__func__,
 						print_mac(mac, hdr->addr1));
 				else
-					DPRINTF(sc, ATH_DEBUG_AGGR,
+					DPRINTF(sc, ATH_DBG_AGGR,
 						"%s: Started tx aggr for: %s\n",
 						__func__,
 						print_mac(mac, hdr->addr1));
@@ -2037,7 +2037,7 @@ static void ath_rate_init(void *priv, void *priv_sta,
 	struct hal_channel hchan;
 	int i, j = 0;
 
-	DPRINTF(sc, ATH_DEBUG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	sta->txrate_idx = rate_lowest_index(local, sband, sta);
@@ -2045,7 +2045,7 @@ static void ath_rate_init(void *priv, void *priv_sta,
 	hchan.channel = conf->channel->center_freq;
 	hchan.channelFlags = ath_chan2flags(conf->channel, sc);
 	if (ath_set_channel(sc, &hchan) < 0)
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s: Unable to set channel\n",
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: Unable to set channel\n",
 			__func__);
 	ath_setup_rates(local, sta);
 	if (conf->flags&IEEE80211_CONF_SUPPORT_HT_MODE) {
@@ -2071,7 +2071,7 @@ static void *ath_rate_alloc(struct ieee80211_local *local)
 	struct ieee80211_hw *hw = local_to_hw(local);
 	struct ath_softc *sc = hw->priv;
 
-	DPRINTF(sc, ATH_DEBUG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
 	return local->hw.priv;
 }
 
@@ -2086,10 +2086,10 @@ static void *ath_rate_alloc_sta(void *priv, gfp_t gfp)
 	struct ath_vap *avp = sc->sc_vaps[0];
 	struct ath_rate_node *rate_priv;
 
-	DPRINTF(sc, ATH_DEBUG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
 	rate_priv = ath_rate_node_alloc(avp, sc->sc_rc, gfp);
 	if (!rate_priv) {
-		DPRINTF(sc, ATH_DEBUG_FATAL, "%s:Unable to allocate"
+		DPRINTF(sc, ATH_DBG_FATAL, "%s:Unable to allocate"
 				"private rate control structure", __func__);
 		return NULL;
 	}
@@ -2102,7 +2102,7 @@ static void ath_rate_free_sta(void *priv, void *priv_sta)
 	struct ath_rate_node *rate_priv = priv_sta;
 	struct ath_softc *sc = priv;
 
-	DPRINTF(sc, ATH_DEBUG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
 	ath_rate_node_free(rate_priv);
 }
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 4b724c1..963bcd9 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -457,7 +457,7 @@ static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc,
 		if (off != 0)
 			skb_reserve(skb, sc->sc_cachelsz - off);
 	} else {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: skbuff alloc of size %u failed\n",
 			__func__, len);
 		return NULL;
@@ -545,7 +545,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 	mfilt[0] = mfilt[1] = ~0;
 
 	ath9k_hw_setmcastfilter(ah, mfilt[0], mfilt[1]);
-	DPRINTF(sc, ATH_DEBUG_RECV ,
+	DPRINTF(sc, ATH_DBG_CONFIG ,
 		"%s: RX filter 0x%x, MC filter %08x:%08x\n",
 		__func__, rfilt, mfilt[0], mfilt[1]);
 }
@@ -571,7 +571,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 					   min(sc->sc_cachelsz,
 					       (u_int16_t)64));
 
-		DPRINTF(sc, ATH_DEBUG_CONFIG, "%s: cachelsz %u rxbufsize %u\n",
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: cachelsz %u rxbufsize %u\n",
 			__func__, sc->sc_cachelsz, sc->sc_rxbufsize);
 
 		/* Initialize rx descriptors */
@@ -579,7 +579,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		error = ath_descdma_setup(sc, &sc->sc_rxdma, &sc->sc_rxbuf,
 					  "rx", nbufs, 1);
 		if (error != 0) {
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: failed to allocate rx descriptors: %d\n",
 				__func__, error);
 			break;
@@ -802,8 +802,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	enum hal_status retval;
 	__le16 fc;
 
-	DPRINTF(sc, ATH_DEBUG_RX_PROC, "%s\n", __func__);
-
 	do {
 		/* If handling rx interrupt and flush is in progress => exit */
 		if (sc->sc_rxflush && (flush == 0))
@@ -1160,7 +1158,7 @@ rx_next:
 	} while (TRUE);
 
 	if (chainreset) {
-		DPRINTF(sc, ATH_DEBUG_CONFIG,
+		DPRINTF(sc, ATH_DBG_CONFIG,
 			"%s: Reset rx chain mask. "
 			"Do internal reset\n", __func__);
 		ASSERT(flush == 0);
@@ -1189,7 +1187,7 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 	spin_unlock_bh(&sc->node_lock);
 
 	if (!an) {
-		DPRINTF(sc, ATH_DEBUG_AGGR,
+		DPRINTF(sc, ATH_DBG_AGGR,
 			"%s: Node not found to initialize RX aggregation\n",
 			__func__);
 		return -1;
@@ -1214,7 +1212,7 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 		rxtid->seq_next = *ssn;
 
 		/* Allocate the receive buffers for this TID */
-		DPRINTF(sc, ATH_DEBUG_AGGR,
+		DPRINTF(sc, ATH_DBG_AGGR,
 			"%s: Allcating rxbuffer for TID %d\n", __func__, tid);
 
 		if (rxtid->rxbuf == NULL) {
@@ -1229,7 +1227,7 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 				sizeof(struct ath_rxbuf), GFP_ATOMIC);
 		}
 		if (rxtid->rxbuf == NULL) {
-			DPRINTF(sc, ATH_DEBUG_AGGR,
+			DPRINTF(sc, ATH_DBG_AGGR,
 				"%s: Unable to allocate RX buffer, "
 				"refusing ADDBA\n", __func__);
 		} else {
@@ -1237,7 +1235,7 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 			 * pointers are null) */
 			memzero(rxtid->rxbuf, ATH_TID_MAX_BUFS *
 				sizeof(struct ath_rxbuf));
-			DPRINTF(sc, ATH_DEBUG_AGGR,
+			DPRINTF(sc, ATH_DBG_AGGR,
 				"%s: Allocated @%p\n", __func__, rxtid->rxbuf);
 
 			/* Allow aggregation reception */
@@ -1262,7 +1260,7 @@ int ath_rx_aggr_stop(struct ath_softc *sc,
 	spin_unlock_bh(&sc->node_lock);
 
 	if (!an) {
-		DPRINTF(sc, ATH_DEBUG_AGGR,
+		DPRINTF(sc, ATH_DBG_AGGR,
 			"%s: RX aggr stop for non-existent node\n", __func__);
 		return -1;
 	}
@@ -1288,7 +1286,7 @@ void ath_rx_aggr_teardown(struct ath_softc *sc,
 	/* De-allocate the receive buffer array allocated when addba started */
 
 	if (rxtid->rxbuf) {
-		DPRINTF(sc, ATH_DEBUG_AGGR,
+		DPRINTF(sc, ATH_DBG_AGGR,
 			"%s: Deallocating TID %d rxbuff @%p\n",
 			__func__, tid, rxtid->rxbuf);
 		kfree(rxtid->rxbuf);
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index d2ab67f..d2c7109 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -16,7 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include "ath9k.h"
+#include "core.h"
 #include "regd.h"
 #include "regd_common.h"
 
@@ -76,7 +76,7 @@ static bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
 			if (regDomainPairs[i].regDmnEnum == rd)
 				return true;
 	}
-	HDPRINTF(ah, HAL_DBG_REGULATORY,
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 		 "%s: invalid regulatory domain/country code 0x%x\n",
 		 __func__, rd);
 	return false;
@@ -107,12 +107,12 @@ static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
 		return true;
 #endif
 	rd = ath9k_regd_get_eepromRD(ah);
-	HDPRINTF(ah, HAL_DBG_REGULATORY, "%s: EEPROM regdomain 0x%x\n",
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: EEPROM regdomain 0x%x\n",
 		 __func__, rd);
 
 	if (rd & COUNTRY_ERD_FLAG) {
 
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			 "%s: EEPROM setting is country code %u\n",
 			 __func__, rd & ~COUNTRY_ERD_FLAG);
 		return cc == (rd & ~COUNTRY_ERD_FLAG);
@@ -292,7 +292,7 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 			}
 		}
 		if (!found) {
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				 "%s: Failed to find reg domain pair %u\n",
 				 __func__, regDmn);
 			return false;
@@ -309,7 +309,7 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 
 	found = ath9k_regd_is_valid_reg_domain(regDmn, rd);
 	if (!found) {
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			 "%s: Failed to find unitary reg domain %u\n",
 			 __func__, regDmn);
 		return false;
@@ -416,21 +416,21 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	int regdmn;
 	u_int16_t chanSep;
 
-	HDPRINTF(ah, HAL_DBG_REGULATORY, "%s: cc %u mode 0x%x%s%s\n",
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: cc %u mode 0x%x%s%s\n",
 		 __func__, cc, modeSelect,
 		 enableOutdoor ? " Enable outdoor" : " ",
 		 enableExtendedChannels ? " Enable ecm" : "");
 
 	if (!ath9k_regd_is_ccode_valid(ah, cc)) {
 
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			 "%s: invalid country code %d\n", __func__, cc);
 		return false;
 	}
 
 	if (!ath9k_regd_is_eeprom_valid(ah)) {
 
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			 "%s: invalid EEPROM contents\n", __func__);
 		return false;
 	}
@@ -456,7 +456,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		country = ath9k_regd_find_country(ah->ah_countryCode);
 
 		if (country == NULL) {
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				 "Country is NULL!!!!, cc= %d\n",
 				 ah->ah_countryCode);
 			return false;
@@ -482,7 +482,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 
 	if (!ath9k_regd_get_wmode_regdomain
 	    (ah, regdmn, ~CHANNEL_2GHZ, &rd5GHz)) {
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"%s: couldn't find unitary "
 			"5GHz reg domain for country %u\n",
 			 __func__, ah->ah_countryCode);
@@ -490,7 +490,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	}
 	if (!ath9k_regd_get_wmode_regdomain
 	    (ah, regdmn, CHANNEL_2GHZ, &rd2GHz)) {
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"%s: couldn't find unitary 2GHz "
 			"reg domain for country %u\n",
 			 __func__, ah->ah_countryCode);
@@ -504,7 +504,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 
 			if (!ath9k_regd_get_wmode_regdomain
 			    (ah, FCC3_FCCA, ~CHANNEL_2GHZ, &rd5GHz)) {
-				HDPRINTF(ah, HAL_DBG_REGULATORY,
+				DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 					"%s: couldn't find unitary 5GHz "
 					"reg domain for country %u\n",
 					 __func__, ah->ah_countryCode);
@@ -538,13 +538,13 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		int8_t low_adj = 0, hi_adj = 0;
 
 		if ((cm->mode & modeSelect) == 0) {
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				 "%s: skip mode 0x%x flags 0x%x\n",
 				 __func__, cm->mode, cm->flags);
 			continue;
 		}
 		if ((cm->mode & modesAvail) == 0) {
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				 "%s: !avail mode 0x%x (0x%x) flags 0x%x\n",
 				 __func__, modesAvail, cm->mode,
 				 cm->flags);
@@ -552,7 +552,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		}
 		if (!ath9k_get_channel_edges(ah, cm->flags, &c_lo, &c_hi)) {
 
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				"%s: channels 0x%x not supported "
 				"by hardware\n",
 				 __func__, cm->flags);
@@ -584,7 +584,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 			ctl = rd->conformanceTestLimit | CTL_11G;
 			break;
 		default:
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				 "%s: Unkonwn HAL mode 0x%x\n", __func__,
 				 cm->mode);
 			continue;
@@ -649,8 +649,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 						}
 					}
 					if (skipband) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							 "%s: Skipping %d "
 							"freq band.\n",
 							 __func__,
@@ -688,8 +688,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					struct hal_channel_internal icv;
 
 					if (!(c_lo <= c && c <= c_hi)) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"%s: c %u out of "
 							"range [%u..%u]\n",
 							 __func__, c, c_lo,
@@ -699,8 +699,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					if ((fband->channelBW ==
 					     CHANNEL_HALF_BW) &&
 					    !is_halfchan_cap) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							 "%s: Skipping %u half "
 							"rate channel\n",
 							 __func__, c);
@@ -710,8 +710,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					if ((fband->channelBW ==
 					     CHANNEL_QUARTER_BW) &&
 					    !is_quarterchan_cap) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"%s: Skipping %u "
 							"quarter rate "
 							"channel\n",
@@ -721,8 +721,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 
 					if (((c + fband->channelSep) / 2) >
 					    (maxChan + HALF_MAXCHANBW)) {
-						HDPRINTF(ah,
-							HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							ATH_DBG_REGULATORY,
 							"%s: c %u > "
 							"maxChan %u\n",
 							__func__, c,
@@ -730,8 +730,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 						continue;
 					}
 					if (next >= maxchans) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"%s: too many "
 							"channels for channel "
 							"table\n",
@@ -741,8 +741,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					if ((fband->
 					     usePassScan & IS_ECM_CHAN)
 					    && !enableExtendedChannels) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"Skipping ecm "
 							"channel\n");
 						continue;
@@ -750,8 +750,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					if ((rd->flags & NO_HOSTAP) &&
 					    (ah->ah_opmode ==
 					     HAL_M_HOSTAP)) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"Skipping HOSTAP "
 							"channel\n");
 						continue;
@@ -764,8 +764,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					    && (rd->conformanceTestLimit !=
 						MKK)) {
 
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"Skipping HT40 "
 							"channel "
 							"(en_fcc_dfs_ht40 = "
@@ -780,8 +780,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					    && !(fband->useDfs)
 					    && (rd->conformanceTestLimit ==
 						MKK)) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"Skipping HT40 "
 							"channel (en_jap_ht40 "
 							"= 0)\n");
@@ -794,8 +794,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					    && (fband->useDfs)
 					    && (rd->conformanceTestLimit ==
 						MKK)) {
-						HDPRINTF(ah,
-							 HAL_DBG_REGULATORY,
+						DPRINTF(ah->ah_sc,
+							 ATH_DBG_REGULATORY,
 							"Skipping HT40 channel"
 							" (en_jap_dfs_ht40 = "
 							"0)\n");
@@ -916,7 +916,7 @@ done:
 
 
 		if (next > ARRAY_SIZE(ah->ah_channels)) {
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				 "%s: too many channels %u; truncating to %u\n",
 				 __func__, next,
 				 (int) ARRAY_SIZE(ah->ah_channels));
@@ -932,9 +932,9 @@ done:
 				ath9k_regd_chansort);
 		ah->ah_nchan = next;
 
-		HDPRINTF(ah, HAL_DBG_REGULATORY, "Channel list:\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "Channel list:\n");
 		for (i = 0; i < next; i++) {
-			HDPRINTF(ah, HAL_DBG_REGULATORY,
+			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				 "chan: %d flags: 0x%x\n",
 				 ichans[i].channel,
 				 ichans[i].channelFlags);
@@ -975,7 +975,7 @@ struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
 	int flags = c->channelFlags & CHAN_FLAGS;
 	int n, lim;
 
-	HDPRINTF(ah, HAL_DBG_REGULATORY,
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 		 "%s: channel %u/0x%x (0x%x) requested\n", __func__,
 		 c->channel, c->channelFlags, flags);
 
@@ -1006,7 +1006,7 @@ struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
 			}
 			d = flags - (cc->channelFlags & CHAN_FLAGS);
 		}
-		HDPRINTF(ah, HAL_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			 "%s: channel %u/0x%x d %d\n", __func__,
 			 cc->channel, cc->channelFlags, d);
 		if (d > 0) {
@@ -1014,7 +1014,7 @@ struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
 			lim--;
 		}
 	}
-	HDPRINTF(ah, HAL_DBG_REGULATORY, "%s: no match for %u/0x%x\n",
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: no match for %u/0x%x\n",
 		 __func__, c->channel, c->channelFlags);
 	return NULL;
 }
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 4f46517..152f9f4 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -118,11 +118,11 @@ static void ath_tx_mcastqaddbuf(struct ath_softc *sc,
 	txq->axq_totalqueued++;
 	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
 
-	DPRINTF(sc, ATH_DEBUG_TX_PROC,
+	DPRINTF(sc, ATH_DBG_QUEUE,
 		"%s: txq depth = %d\n", __func__, txq->axq_depth);
 	if (txq->axq_link != NULL) {
 		*txq->axq_link = bf->bf_daddr;
-		DPRINTF(sc, ATH_DEBUG_XMIT,
+		DPRINTF(sc, ATH_DBG_XMIT,
 			"%s: link[%u](%p)=%llx (%p)\n",
 			__func__,
 			txq->axq_qnum, txq->axq_link,
@@ -158,18 +158,18 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc,
 	txq->axq_totalqueued++;
 	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
 
-	DPRINTF(sc, ATH_DEBUG_TX_PROC,
+	DPRINTF(sc, ATH_DBG_QUEUE,
 		"%s: txq depth = %d\n", __func__, txq->axq_depth);
 
 	if (txq->axq_link == NULL) {
 		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
-		DPRINTF(sc, ATH_DEBUG_XMIT,
+		DPRINTF(sc, ATH_DBG_XMIT,
 			"%s: TXDP[%u] = %llx (%p)\n",
 			__func__, txq->axq_qnum,
 			ito64(bf->bf_daddr), bf->bf_desc);
 	} else {
 		*txq->axq_link = bf->bf_daddr;
-		DPRINTF(sc, ATH_DEBUG_XMIT, "%s: link[%u] (%p)=%llx (%p)\n",
+		DPRINTF(sc, ATH_DBG_XMIT, "%s: link[%u] (%p)=%llx (%p)\n",
 			__func__,
 			txq->axq_qnum, txq->axq_link,
 			ito64(bf->bf_daddr), bf->bf_desc);
@@ -334,7 +334,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 
 	/* Try to avoid running out of descriptors */
 	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: TX queue: %d is full, depth: %d\n",
 			__func__,
 			txctl->qnum,
@@ -1260,7 +1260,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	int nacked, txok, nbad = 0, isrifs = 0;
 	enum hal_status status;
 
-	DPRINTF(sc, ATH_DEBUG_TX_PROC,
+	DPRINTF(sc, ATH_DBG_QUEUE,
 		"%s: tx queue %d (%x), link %p\n", __func__,
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
 		txq->axq_link);
@@ -1417,7 +1417,7 @@ static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_hal *ah = sc->sc_ah;
 
 	(void) ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-	DPRINTF(sc, ATH_DEBUG_XMIT, "%s: tx queue [%u] %x, link %p\n",
+	DPRINTF(sc, ATH_DBG_XMIT, "%s: tx queue [%u] %x, link %p\n",
 		__func__, txq->axq_qnum,
 		ath9k_hw_gettxbuf(ah, txq->axq_qnum), txq->axq_link);
 }
@@ -1449,7 +1449,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 		enum hal_status status;
 
 		/* TxDMA not stopped, reset the hal */
-		DPRINTF(sc, ATH_DEBUG_XMIT,
+		DPRINTF(sc, ATH_DBG_XMIT,
 			"%s: Unable to stop TxDMA. Reset HAL!\n", __func__);
 
 		spin_lock_bh(&sc->sc_resetlock);
@@ -1458,7 +1458,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 			sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			sc->sc_ht_extprotspacing, true, &status)) {
 
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: unable to reset hardware; hal status %u\n",
 				__func__,
 				status);
@@ -2163,7 +2163,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 		error = ath_descdma_setup(sc, &sc->sc_txdma, &sc->sc_txbuf,
 			"tx", nbufs * ATH_FRAG_PER_MSDU, ATH_TXDESC);
 		if (error != 0) {
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: failed to allocate tx descriptors: %d\n",
 				__func__, error);
 			break;
@@ -2173,7 +2173,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 		error = ath_descdma_setup(sc, &sc->sc_bdma, &sc->sc_bbuf,
 					  "beacon", ATH_BCBUF, 1);
 		if (error != 0) {
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: failed to allocate "
 				"beacon descripotrs: %d\n",
 				__func__, error);
@@ -2247,7 +2247,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		return NULL;
 	}
 	if (qnum >= ARRAY_SIZE(sc->sc_txq)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: hal qnum %u out of range, max %u!\n",
 			__func__, qnum, (unsigned int)ARRAY_SIZE(sc->sc_txq));
 		ath9k_hw_releasetxqueue(ah, qnum);
@@ -2294,7 +2294,7 @@ int ath_tx_setup(struct ath_softc *sc, int haltype)
 	struct ath_txq *txq;
 
 	if (haltype >= ARRAY_SIZE(sc->sc_haltype2q)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: HAL AC %u out of range, max %zu!\n",
 			__func__, haltype, ARRAY_SIZE(sc->sc_haltype2q));
 		return 0;
@@ -2314,7 +2314,7 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 	switch (qtype) {
 	case HAL_TX_QUEUE_DATA:
 		if (haltype >= ARRAY_SIZE(sc->sc_haltype2q)) {
-			DPRINTF(sc, ATH_DEBUG_FATAL,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: HAL AC %u out of range, max %zu!\n",
 				__func__,
 				haltype, ARRAY_SIZE(sc->sc_haltype2q));
@@ -2362,7 +2362,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum, struct hal_txq_info *qi0)
 	qi.tqi_readyTime = qi0->tqi_readyTime;
 
 	if (!ath9k_hw_settxqueueprops(ah, qnum, &qi)) {
-		DPRINTF(sc, ATH_DEBUG_FATAL,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to update hardware queue %u!\n",
 			__func__, qnum);
 		error = -EIO;
@@ -2509,7 +2509,7 @@ void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 	 * we go to INIT state */
 	if (!sc->sc_invalid) {
 		(void) ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
-		DPRINTF(sc, ATH_DEBUG_XMIT, "%s: beacon queue %x\n", __func__,
+		DPRINTF(sc, ATH_DBG_XMIT, "%s: beacon queue %x\n", __func__,
 			ath9k_hw_gettxbuf(sc->sc_ah, sc->sc_bhalq));
 	}
 
@@ -2575,7 +2575,7 @@ int ath_tx_aggr_start(struct ath_softc *sc,
 	spin_unlock_bh(&sc->node_lock);
 
 	if (!an) {
-		DPRINTF(sc, ATH_DEBUG_AGGR,
+		DPRINTF(sc, ATH_DBG_AGGR,
 			"%s: Node not found to initialize "
 			"TX aggregation\n", __func__);
 		return -1;
@@ -2603,7 +2603,7 @@ int ath_tx_aggr_stop(struct ath_softc *sc,
 	spin_unlock_bh(&sc->node_lock);
 
 	if (!an) {
-		DPRINTF(sc, ATH_DEBUG_AGGR,
+		DPRINTF(sc, ATH_DBG_AGGR,
 			"%s: TX aggr stop for non-existent node\n", __func__);
 		return -1;
 	}
@@ -2628,7 +2628,7 @@ void ath_tx_aggr_teardown(struct ath_softc *sc,
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
 
-	DPRINTF(sc, ATH_DEBUG_AGGR, "%s: teardown TX aggregation\n", __func__);
+	DPRINTF(sc, ATH_DBG_AGGR, "%s: teardown TX aggregation\n", __func__);
 
 	if (txtid->cleanup_inprogress) /* cleanup is in progress */
 		return;
-- 
1.5.4.3

