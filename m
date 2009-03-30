Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12705 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbZC3KCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:38 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:37 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38849.477739.971186@gargle.gargle.HOWL> (sfid-20090330_120241_549795_2C8B4C3C)
Date: Mon, 30 Mar 2009 15:28:25 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 03/17] ath9k: Cleanup debug messages
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean debug messages to use appropriate levels,
remove useless messages, and trim the number of
debug levels.
---
 drivers/net/wireless/ath9k/ani.c    |    8 +--
 drivers/net/wireless/ath9k/beacon.c |    7 +--
 drivers/net/wireless/ath9k/debug.h  |   24 ++++-----
 drivers/net/wireless/ath9k/eeprom.c |   24 ++++----
 drivers/net/wireless/ath9k/hw.c     |  101 +++++++++++++++--------------------
 drivers/net/wireless/ath9k/mac.c    |   63 +++++++++++++---------
 drivers/net/wireless/ath9k/main.c   |    6 +-
 drivers/net/wireless/ath9k/phy.c    |    4 +-
 drivers/net/wireless/ath9k/phy.h    |    3 -
 drivers/net/wireless/ath9k/recv.c   |    4 +-
 10 files changed, 115 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index 6c5e887..1aeafb5 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -569,8 +569,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 					"phyCnt1 0x%x, resetting "
 					"counter value to 0x%x\n",
-					phyCnt1,
-					aniState->ofdmPhyErrBase);
+					phyCnt1, aniState->ofdmPhyErrBase);
 				REG_WRITE(ah, AR_PHY_ERR_1,
 					  aniState->ofdmPhyErrBase);
 				REG_WRITE(ah, AR_PHY_ERR_MASK_1,
@@ -580,8 +579,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 					"phyCnt2 0x%x, resetting "
 					"counter value to 0x%x\n",
-					phyCnt2,
-					aniState->cckPhyErrBase);
+					phyCnt2, aniState->cckPhyErrBase);
 				REG_WRITE(ah, AR_PHY_ERR_2,
 					  aniState->cckPhyErrBase);
 				REG_WRITE(ah, AR_PHY_ERR_MASK_2,
@@ -667,7 +665,7 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
 	u32 cc = REG_READ(ah, AR_CCCNT);
 
 	if (cycles == 0 || cycles > cc) {
-		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			"cycle counter wrap. ExtBusy = 0\n");
 		good = 0;
 	} else {
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index ec99573..5b2752b 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -43,7 +43,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 
 	if (!ath9k_hw_set_txq_props(ah, sc->beacon.beaconq, &qi)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"unable to update h/w beacon queue parameters\n");
+			"Unable to update h/w beacon queue parameters\n");
 		return 0;
 	} else {
 		ath9k_hw_resettxqueue(ah, sc->beacon.beaconq);
@@ -132,11 +132,8 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	avp = (void *)vif->drv_priv;
 	cabq = sc->beacon.cabq;
 
-	if (avp->av_bcbuf == NULL) {
-		DPRINTF(sc, ATH_DBG_BEACON, "avp=%p av_bcbuf=%p\n",
-			avp, avp->av_bcbuf);
+	if (avp->av_bcbuf == NULL)
 		return NULL;
-	}
 
 	/* Release the old beacon first */
 
diff --git a/drivers/net/wireless/ath9k/debug.h b/drivers/net/wireless/ath9k/debug.h
index 7b0e541..23298b9 100644
--- a/drivers/net/wireless/ath9k/debug.h
+++ b/drivers/net/wireless/ath9k/debug.h
@@ -19,20 +19,16 @@
 
 enum ATH_DEBUG {
 	ATH_DBG_RESET		= 0x00000001,
-	ATH_DBG_REG_IO		= 0x00000002,
-	ATH_DBG_QUEUE		= 0x00000004,
-	ATH_DBG_EEPROM		= 0x00000008,
-	ATH_DBG_CALIBRATE	= 0x00000010,
-	ATH_DBG_CHANNEL		= 0x00000020,
-	ATH_DBG_INTERRUPT	= 0x00000040,
-	ATH_DBG_REGULATORY	= 0x00000080,
-	ATH_DBG_ANI		= 0x00000100,
-	ATH_DBG_POWER_MGMT	= 0x00000200,
-	ATH_DBG_XMIT		= 0x00000400,
-	ATH_DBG_BEACON		= 0x00001000,
-	ATH_DBG_CONFIG		= 0x00002000,
-	ATH_DBG_KEYCACHE	= 0x00004000,
-	ATH_DBG_FATAL		= 0x00008000,
+	ATH_DBG_QUEUE		= 0x00000002,
+	ATH_DBG_EEPROM		= 0x00000004,
+	ATH_DBG_CALIBRATE	= 0x00000008,
+	ATH_DBG_INTERRUPT	= 0x00000010,
+	ATH_DBG_REGULATORY	= 0x00000020,
+	ATH_DBG_ANI		= 0x00000040,
+	ATH_DBG_XMIT		= 0x00000080,
+	ATH_DBG_BEACON		= 0x00000100,
+	ATH_DBG_CONFIG		= 0x00000200,
+	ATH_DBG_FATAL		= 0x00000400,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index ffc36b0..44fee5a 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -783,11 +783,11 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 					((pdadcValues[4 * j + 3] & 0xFF) << 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"PDADC (%d,%4x): %4.4x %8.8x\n",
 					i, regChainOffset, regOffset,
 					reg32);
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"PDADC: Chain %d | "
 					"PDADC %3d Value %3d | "
 					"PDADC %3d Value %3d | "
@@ -910,7 +910,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
 			"EXT_ADDITIVE %d\n",
 			ctlMode, numCtlModes, isHt40CtlMode,
@@ -918,7 +918,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 
 		for (i = 0; (i < AR5416_NUM_CTLS) &&
 				pEepData->ctlIndex[i]; i++) {
-			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
 				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
 				"chan %d\n",
@@ -941,7 +941,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 				IS_CHAN_2GHZ(chan),
 				AR5416_EEP4K_NUM_BAND_EDGES);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"    MATCH-EE_IDX %d: ch %d is2 %d "
 					"2xMinEdge %d chainmask %d chains %d\n",
 					i, freq, IS_CHAN_2GHZ(chan),
@@ -961,7 +961,7 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 
 		minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"    SEL-Min ctlMode %d pCtlMode %d "
 			"2xMaxEdge %d sP %d minCtlPwr %d\n",
 			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
@@ -2234,11 +2234,11 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 					((pdadcValues[4 * j + 3] & 0xFF) << 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"PDADC (%d,%4x): %4.4x %8.8x\n",
 					i, regChainOffset, regOffset,
 					reg32);
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"PDADC: Chain %d | PDADC %3d "
 					"Value %3d | PDADC %3d Value %3d | "
 					"PDADC %3d Value %3d | PDADC %3d "
@@ -2415,14 +2415,14 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
 			"EXT_ADDITIVE %d\n",
 			ctlMode, numCtlModes, isHt40CtlMode,
 			(pCtlMode[ctlMode] & EXT_ADDITIVE));
 
 		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
-			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
 				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
 				"chan %d\n",
@@ -2441,7 +2441,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 				rep->ctlEdges[ar5416_get_ntxchains(tx_chainmask) - 1],
 				IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"    MATCH-EE_IDX %d: ch %d is2 %d "
 					"2xMinEdge %d chainmask %d chains %d\n",
 					i, freq, IS_CHAN_2GHZ(chan),
@@ -2460,7 +2460,7 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 
 		minCtlPower = min(twiceMaxEdgePower, scaledPower);
 
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"    SEL-Min ctlMode %d pCtlMode %d "
 			"2xMaxEdge %d sP %d minCtlPwr %d\n",
 			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 22ef93f..169d8ef 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -97,7 +97,7 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 		udelay(AH_TIME_QUANTUM);
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+	DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 		"timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
 		timeout, reg, REG_READ(ah, reg), mask, val);
 
@@ -181,7 +181,7 @@ u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 		}
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Unknown phy %u (rate ix %u)\n",
 			rates->info[rateix].phy, rateix);
 		txTime = 0;
@@ -306,7 +306,7 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (rdData != wrData) {
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 					"address test failed "
 					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 					addr, wrData, rdData);
@@ -318,7 +318,7 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (wrData != rdData) {
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 					"address test failed "
 					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 					addr, wrData, rdData);
@@ -453,8 +453,8 @@ static int ath9k_hw_rfattach(struct ath_hw *ah)
 
 	rfStatus = ath9k_hw_init_rf(ah, &ecode);
 	if (!rfStatus) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-			"RF setup failed, status %u\n", ecode);
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"RF setup failed, status: %u\n", ecode);
 		return ecode;
 	}
 
@@ -478,10 +478,9 @@ static int ath9k_hw_rf_claim(struct ath_hw *ah)
 	case AR_RAD2122_SREV_MAJOR:
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"5G Radio Chip Rev 0x%02X is not "
-			"supported by this driver\n",
-			ah->hw_version.analog5GhzRev);
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"Radio Chip Rev 0x%02X not supported\n",
+			val & AR_RADIO_SREV_MAJOR);
 		return -EOPNOTSUPP;
 	}
 
@@ -503,12 +502,8 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 		ah->macaddr[2 * i] = eeval >> 8;
 		ah->macaddr[2 * i + 1] = eeval & 0xff;
 	}
-	if (sum == 0 || sum == 0xffff * 3) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"mac address read failed: %pM\n",
-			ah->macaddr);
+	if (sum == 0 || sum == 0xffff * 3)
 		return -EADDRNOTAVAIL;
-	}
 
 	return 0;
 }
@@ -565,11 +560,8 @@ static int ath9k_hw_post_attach(struct ath_hw *ah)
 {
 	int ecode;
 
-	if (!ath9k_hw_chip_test(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-			"hardware self-test failed\n");
+	if (!ath9k_hw_chip_test(ah))
 		return -ENODEV;
-	}
 
 	ecode = ath9k_hw_rf_claim(ah);
 	if (ecode != 0)
@@ -611,13 +603,13 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ah->intr_mitigation = true;
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		DPRINTF(sc, ATH_DBG_RESET, "Couldn't reset chip\n");
+		DPRINTF(sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
 		ecode = -EIO;
 		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		DPRINTF(sc, ATH_DBG_RESET, "Couldn't wakeup chip\n");
+		DPRINTF(sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
 		ecode = -EIO;
 		goto bad;
 	}
@@ -640,7 +632,7 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCIE) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_9160) &&
 	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah)) && (!AR_SREV_9285(ah))) {
-		DPRINTF(sc, ATH_DBG_RESET,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
 			ah->hw_version.macRev);
@@ -680,10 +672,6 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 
-	DPRINTF(sc, ATH_DBG_RESET,
-		"This Mac Chip Rev 0x%02x.%x is \n",
-		ah->hw_version.macVersion, ah->hw_version.macRev);
-
 	if (AR_SREV_9285_12_OR_LATER(ah)) {
 
 		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
@@ -875,8 +863,8 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	ecode = ath9k_hw_init_macaddr(ah);
 	if (ecode != 0) {
-		DPRINTF(sc, ATH_DBG_RESET,
-			"failed initializing mac address\n");
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Failed to initialize MAC address\n");
 		goto bad;
 	}
 
@@ -1193,23 +1181,23 @@ static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
 	switch (ah->hw_version.devid) {
 	case AR9280_DEVID_PCI:
 		if (reg == 0x7894) {
-			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				"ini VAL: %x  EEPROM: %x\n", value,
 				(pBase->version & 0xff));
 
 			if ((pBase->version & 0xff) > 0x0a) {
-				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"PWDCLKIND: %d\n",
 					pBase->pwdclkind);
 				value &= ~AR_AN_TOP2_PWDCLKIND;
 				value |= AR_AN_TOP2_PWDCLKIND &
 					(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
 			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					"PWDCLKIND Earlier Rev\n");
 			}
 
-			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				"final ini VAL: %x\n", value);
 		}
 		break;
@@ -1356,13 +1344,13 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 				  min((u32) MAX_RATE_POWER,
 				      (u32) ah->regulatory.power_limit));
 	if (status != 0) {
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-			"error init'ing transmit power\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"Error initializing transmit power\n");
 		return -EIO;
 	}
 
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"ar5416SetRfRegs failed\n");
 		return -EIO;
 	}
@@ -1668,7 +1656,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
 	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
 			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Could not kill baseband RX\n");
 		return false;
 	}
@@ -1677,14 +1665,14 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		if (!(ath9k_hw_ar9280_set_channel(ah, chan))) {
-			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-				"failed to set channel\n");
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				"Failed to set channel\n");
 			return false;
 		}
 	} else {
 		if (!(ath9k_hw_set_channel(ah, chan))) {
-			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-				"failed to set channel\n");
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				"Failed to set channel\n");
 			return false;
 		}
 	}
@@ -1696,7 +1684,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 			     min((u32) MAX_RATE_POWER,
 				 (u32) ah->regulatory.power_limit)) != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"error init'ing transmit power\n");
+			"Error initializing transmit power\n");
 		return false;
 	}
 
@@ -2224,7 +2212,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_mark_phy_inactive(ah);
 
 	if (!ath9k_hw_chip_reset(ah, chan)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "chip reset failed\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Chip reset failed\n");
 		return -EINVAL;
 	}
 
@@ -2367,8 +2355,8 @@ bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 	u32 keyType;
 
 	if (entry >= ah->caps.keycache_size) {
-		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-			"entry %u out of range\n", entry);
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"keychache entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2404,8 +2392,8 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 	u32 macHi, macLo;
 
 	if (entry >= ah->caps.keycache_size) {
-		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-			"entry %u out of range\n", entry);
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"keychache entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2436,8 +2424,8 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 	u32 keyType;
 
 	if (entry >= pCap->keycache_size) {
-		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-			"entry %u out of range\n", entry);
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"keycache entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2447,7 +2435,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		break;
 	case ATH9K_CIPHER_AES_CCM:
 		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				"AES-CCM not supported by mac rev 0x%x\n",
 				ah->hw_version.macRev);
 			return false;
@@ -2458,14 +2446,14 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_TKIP;
 		if (ATH9K_IS_MIC_ENABLED(ah)
 		    && entry + 64 >= pCap->keycache_size) {
-			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				"entry %u inappropriate for TKIP\n", entry);
 			return false;
 		}
 		break;
 	case ATH9K_CIPHER_WEP:
 		if (k->kv_len < LEN_WEP40) {
-			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				"WEP key length %u too small\n", k->kv_len);
 			return false;
 		}
@@ -2480,7 +2468,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_CLR;
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"cipher %u not supported\n", k->kv_type);
 		return false;
 	}
@@ -2698,7 +2686,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 				    AR_RTC_FORCE_WAKE_EN);
 		}
 		if (i == 0) {
-			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Failed to wakeup in %uus\n", POWER_UP_TIME / 20);
 			return false;
 		}
@@ -2719,9 +2707,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 		"UNDEFINED"
 	};
 
-	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s -> %s (%s)\n",
-		modes[ah->power_mode], modes[mode],
-		setChip ? "set chip " : "");
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s -> %s\n",
+		modes[ah->power_mode], modes[mode]);
 
 	switch (mode) {
 	case ATH9K_PM_AWAKE:
@@ -2735,7 +2722,7 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 		ath9k_set_power_network_sleep(ah, setChip);
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Unknown power mode %u\n", mode);
 		return false;
 	}
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index e0a6dee..8ae4ec2 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -49,7 +49,7 @@ bool ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 
 bool ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %u\n", q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Enable TXE on queue: %u\n", q);
 
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 
@@ -110,13 +110,15 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Stopping TX DMA, "
+			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Stopping TX DMA, "
+			"inactive queue: %u\n", q);
 		return false;
 	}
 
@@ -146,7 +148,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 				break;
 
 			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-				"TSF have moved while trying to set "
+				"TSF has moved while trying to set "
 				"quiet time TSF: 0x%08x\n", tsfLow);
 		}
 
@@ -158,8 +160,8 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 		wait = wait_time;
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
-				DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
-					"Failed to stop Tx DMA in 100 "
+				DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
+					"Failed to stop TX DMA in 100 "
 					"msec after killing last frame\n");
 				break;
 			}
@@ -454,17 +456,19 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Set TXQ properties, "
+			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Set TXQ properties, "
+			"inactive queue: %u\n", q);
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %p\n", qi);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Set queue properties for: %u\n", q);
 
 	qi->tqi_ver = qinfo->tqi_ver;
 	qi->tqi_subtype = qinfo->tqi_subtype;
@@ -521,13 +525,15 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Get TXQ properties, "
+			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Get TXQ properties, "
+			"inactive queue: %u\n", q);
 		return false;
 	}
 
@@ -575,22 +581,23 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
 		if (q == pCap->total_queues) {
-			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-				"no available tx queue\n");
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+				"No available TX queue\n");
 			return -1;
 		}
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "bad tx queue type %u\n", type);
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Invalid TX queue type: %u\n",
+			type);
 		return -1;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %u\n", q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Setup TX queue: %u\n", q);
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-			"tx queue %u already active\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"TX queue: %u already active\n", q);
 		return -1;
 	}
 	memset(qi, 0, sizeof(struct ath9k_tx_queue_info));
@@ -620,16 +627,18 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Release TXQ, "
+			"invalid queue: %u\n", q);
 		return false;
 	}
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Release TXQ, "
+			"inactive queue: %u\n", q);
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "release queue %u\n", q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Release TX queue: %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
 	ah->txok_interrupt_mask &= ~(1 << q);
@@ -650,17 +659,19 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	u32 cwMin, chanCwMin, value;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Reset TXQ, "
+			"invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Reset TXQ, "
+			"inactive queue: %u\n", q);
 		return true;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "reset queue %u\n", q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Reset TX queue: %u\n", q);
 
 	if (qi->tqi_cwmin == ATH9K_TXQ_USEDEFAULT) {
 		if (chan && IS_CHAN_B(chan))
@@ -894,7 +905,7 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 
 			reg = REG_READ(ah, AR_OBS_BUS_1);
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				"rx failed to go idle in 10 ms RXSM=0x%x\n", reg);
+				"RX failed to go idle in 10 ms RXSM=0x%x\n", reg);
 
 			return false;
 		}
@@ -949,8 +960,8 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 	}
 
 	if (i == 0) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-			"dma failed to stop in %d ms "
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"DMA failed to stop in %d ms "
 			"AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
 			AH_RX_STOP_DMA_TIMEOUT / 1000,
 			REG_READ(ah, AR_CR),
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 1648a4b..cc62520 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -674,7 +674,7 @@ static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
 	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
 	if (!ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, NULL)) {
 		/* TX MIC entry failed. No need to proceed further */
-		DPRINTF(sc, ATH_DBG_KEYCACHE,
+		DPRINTF(sc, ATH_DBG_FATAL,
 			"Setting TX MIC Key Failed\n");
 		return 0;
 	}
@@ -1401,7 +1401,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* Get the hardware key cache size. */
 	sc->keymax = ah->caps.keycache_size;
 	if (sc->keymax > ATH_KEYMAX) {
-		DPRINTF(sc, ATH_DBG_KEYCACHE,
+		DPRINTF(sc, ATH_DBG_ANY,
 			"Warning, using only %u entries in %u key cache\n",
 			ATH_KEYMAX, sc->keymax);
 		sc->keymax = ATH_KEYMAX;
@@ -2603,7 +2603,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	DPRINTF(sc, ATH_DBG_KEYCACHE, "Set HW Key\n");
+	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW Key\n");
 
 	switch (cmd) {
 	case SET_KEY:
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 8bcba90..5ec9ce9 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -46,7 +46,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			channelSel = ((freq - 704) * 2 - 3040) / 10;
 			bModeSynth = 1;
 		} else {
-			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Invalid channel %u MHz\n", freq);
 			return false;
 		}
@@ -79,7 +79,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		channelSel = ath9k_hw_reverse_bits((freq - 4800) / 5, 8);
 		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
 	} else {
-		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Invalid channel %u MHz\n", freq);
 		return false;
 	}
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 0f7f8e0..296d0e9 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -556,9 +556,6 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 		int r;							\
 		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
 			REG_WRITE(ah, INI_RA((iniarray), r, 0), (regData)[r]); \
-			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL, \
-				"RF 0x%x V 0x%x\n", \
-				INI_RA((iniarray), r, 0), (regData)[r]); \
 			DO_DELAY(regWr);				\
 		}							\
 	} while (0)
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 71cb18d..ea02332 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -320,7 +320,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 				  bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
 				bf->bf_mpdu = NULL;
-				DPRINTF(sc, ATH_DBG_CONFIG,
+				DPRINTF(sc, ATH_DBG_FATAL,
 					"dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
 				break;
@@ -673,7 +673,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
 			bf->bf_mpdu = NULL;
-			DPRINTF(sc, ATH_DBG_CONFIG,
+			DPRINTF(sc, ATH_DBG_FATAL,
 				"dma_mapping_error() on RX\n");
 			break;
 		}
-- 
1.6.2.1

