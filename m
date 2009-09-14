Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/11] atheros: add common debug printing
Date: Mon, 14 Sep 2009 04:37:20 -0400
Message-Id: <1252917448-10744-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k uses this for now, ath9k_htc is expected to re-use this
as well. We lave ath5k as is, but it certainly can also be
converted later.

The ath9k module parameter and debugfs entry is kept.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Kconfig             |    8 +
 drivers/net/wireless/ath/Makefile            |    2 +
 drivers/net/wireless/ath/ath.h               |    3 +
 drivers/net/wireless/ath/ath9k/Kconfig       |    4 +
 drivers/net/wireless/ath/ath9k/ahb.c         |    7 +-
 drivers/net/wireless/ath/ath9k/ani.c         |  133 +++++++-----
 drivers/net/wireless/ath/ath9k/ath9k.h       |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c      |   80 ++++---
 drivers/net/wireless/ath/ath9k/calib.c       |  303 +++++++++++++------------
 drivers/net/wireless/ath/ath9k/calib.h       |    2 +
 drivers/net/wireless/ath/ath9k/debug.c       |   26 +--
 drivers/net/wireless/ath/ath9k/debug.h       |   27 ---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   81 ++++----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   89 ++++----
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   75 ++++---
 drivers/net/wireless/ath/ath9k/hw.c          |  254 ++++++++++++----------
 drivers/net/wireless/ath/ath9k/hw.h          |    1 +
 drivers/net/wireless/ath/ath9k/mac.c         |  118 ++++++-----
 drivers/net/wireless/ath/ath9k/main.c        |  266 +++++++++++++----------
 drivers/net/wireless/ath/ath9k/phy.c         |   23 +-
 drivers/net/wireless/ath/ath9k/rc.c          |   28 ++-
 drivers/net/wireless/ath/ath9k/recv.c        |   38 ++--
 drivers/net/wireless/ath/ath9k/xmit.c        |  100 +++++----
 drivers/net/wireless/ath/debug.c             |   32 +++
 drivers/net/wireless/ath/debug.h             |   77 +++++++
 25 files changed, 1005 insertions(+), 773 deletions(-)
 create mode 100644 drivers/net/wireless/ath/debug.c
 create mode 100644 drivers/net/wireless/ath/debug.h

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 11ded15..6ce86cb 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -16,7 +16,15 @@ menuconfig ATH_COMMON
 	  http://wireless.kernel.org/en/users/Drivers/Atheros
 
 if ATH_COMMON
+
+config ATH_DEBUG
+	bool "Atheros wireless debugging"
+	---help---
+	  Say Y, if you want to debug atheros wireless drivers.
+	  Right now only ath9k makes use of this.
+
 source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/ar9170/Kconfig"
+
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 6ebf214..5c8e6b2 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_ATH_COMMON)	+= ath.o
 ath-objs :=	main.o \
 		regd.o \
 		hw.o
+
+ath-$(CONFIG_ATH_DEBUG) += debug.o
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 8865413..2ca9701 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -48,11 +48,14 @@ struct ath_ops {
 struct ath_common {
 	void *ah;
 	struct ieee80211_hw *hw;
+	int debug_mask;
+
 	u16 cachelsz;
 	u16 curaid;
 	u8 macaddr[ETH_ALEN];
 	u8 curbssid[ETH_ALEN];
 	u8 bssidmask[ETH_ALEN];
+
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;
 };
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index ef5f59c..de4aeea 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -16,6 +16,8 @@ config ATH9K
 
 	  If you choose to build a module, it'll be called ath9k.
 
+if ATH_DEBUG
+
 config ATH9K_DEBUG
 	bool "Atheros ath9k debugging"
 	depends on ATH9K
@@ -26,3 +28,5 @@ config ATH9K_DEBUG
 	  modprobe ath9k debug=0x00000200
 
 	  Look in ath9k/debug.h for possible debug masks
+
+endif # ATH_DEBUG
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 41e16ed..095973e 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -40,9 +40,10 @@ static bool ath_ahb_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
 
 	pdata = (struct ath9k_platform_data *) pdev->dev.platform_data;
 	if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"%s: flash read failed, offset %08x is out of range\n",
-				__func__, off);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "%s: flash read failed, offset %08x "
+			  "is out of range\n",
+			  __func__, off);
 		return false;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 9682c49..bb0a6d9 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -31,8 +31,8 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 		}
 	}
 
-	DPRINTF(ah, ATH_DBG_ANI,
-		"No more channel states left. Using channel 0\n");
+	ath_print(ath9k_hw_common(ah), ATH_DBG_ANI,
+		  "No more channel states left. Using channel 0\n");
 
 	return 0;
 }
@@ -41,16 +41,17 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 				 enum ath9k_ani_cmd cmd, int param)
 {
 	struct ar5416AniState *aniState = ah->curani;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	switch (cmd & ah->ani_function) {
 	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
-			DPRINTF(ah, ATH_DBG_ANI,
-				"level out of range (%u > %u)\n",
-				level,
-				(unsigned)ARRAY_SIZE(ah->totalSizeDesired));
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned)ARRAY_SIZE(ah->totalSizeDesired));
 			return false;
 		}
 
@@ -152,10 +153,10 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(firstep)) {
-			DPRINTF(ah, ATH_DBG_ANI,
-				"level out of range (%u > %u)\n",
-				level,
-				(unsigned) ARRAY_SIZE(firstep));
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(firstep));
 			return false;
 		}
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
@@ -174,11 +175,10 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1)) {
-			DPRINTF(ah, ATH_DBG_ANI,
-				"level out of range (%u > %u)\n",
-				level,
-				(unsigned)
-				ARRAY_SIZE(cycpwrThr1));
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(cycpwrThr1));
 			return false;
 		}
 		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
@@ -194,25 +194,28 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 	case ATH9K_ANI_PRESENT:
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_ANI,
-			"invalid cmd %u\n", cmd);
+		ath_print(common, ATH_DBG_ANI,
+			  "invalid cmd %u\n", cmd);
 		return false;
 	}
 
-	DPRINTF(ah, ATH_DBG_ANI, "ANI parameters:\n");
-	DPRINTF(ah, ATH_DBG_ANI,
-		"noiseImmunityLevel=%d, spurImmunityLevel=%d, "
-		"ofdmWeakSigDetectOff=%d\n",
-		aniState->noiseImmunityLevel, aniState->spurImmunityLevel,
-		!aniState->ofdmWeakSigDetectOff);
-	DPRINTF(ah, ATH_DBG_ANI,
-		"cckWeakSigThreshold=%d, "
-		"firstepLevel=%d, listenTime=%d\n",
-		aniState->cckWeakSigThreshold, aniState->firstepLevel,
-		aniState->listenTime);
-	DPRINTF(ah, ATH_DBG_ANI,
+	ath_print(common, ATH_DBG_ANI, "ANI parameters:\n");
+	ath_print(common, ATH_DBG_ANI,
+		  "noiseImmunityLevel=%d, spurImmunityLevel=%d, "
+		  "ofdmWeakSigDetectOff=%d\n",
+		  aniState->noiseImmunityLevel,
+		  aniState->spurImmunityLevel,
+		  !aniState->ofdmWeakSigDetectOff);
+	ath_print(common, ATH_DBG_ANI,
+		  "cckWeakSigThreshold=%d, "
+		  "firstepLevel=%d, listenTime=%d\n",
+		  aniState->cckWeakSigThreshold,
+		  aniState->firstepLevel,
+		  aniState->listenTime);
+	ath_print(common, ATH_DBG_ANI,
 		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
-		aniState->cycleCount, aniState->ofdmPhyErrCount,
+		aniState->cycleCount,
+		aniState->ofdmPhyErrCount,
 		aniState->cckPhyErrCount);
 
 	return true;
@@ -231,6 +234,7 @@ static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!DO_ANI(ah))
 		return;
@@ -240,24 +244,24 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 
 	if (aniState->ofdmTrigHigh > AR_PHY_COUNTMAX) {
 		aniState->ofdmPhyErrBase = 0;
-		DPRINTF(ah, ATH_DBG_ANI,
-			"OFDM Trigger is too high for hw counters\n");
+		ath_print(common, ATH_DBG_ANI,
+			  "OFDM Trigger is too high for hw counters\n");
 	} else {
 		aniState->ofdmPhyErrBase =
 			AR_PHY_COUNTMAX - aniState->ofdmTrigHigh;
 	}
 	if (aniState->cckTrigHigh > AR_PHY_COUNTMAX) {
 		aniState->cckPhyErrBase = 0;
-		DPRINTF(ah, ATH_DBG_ANI,
-			"CCK Trigger is too high for hw counters\n");
+		ath_print(common, ATH_DBG_ANI,
+			  "CCK Trigger is too high for hw counters\n");
 	} else {
 		aniState->cckPhyErrBase =
 			AR_PHY_COUNTMAX - aniState->cckTrigHigh;
 	}
-	DPRINTF(ah, ATH_DBG_ANI,
-		"Writing ofdmbase=%u   cckbase=%u\n",
-		aniState->ofdmPhyErrBase,
-		aniState->cckPhyErrBase);
+	ath_print(common, ATH_DBG_ANI,
+		  "Writing ofdmbase=%u   cckbase=%u\n",
+		  aniState->ofdmPhyErrBase,
+		  aniState->cckPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
@@ -464,6 +468,7 @@ void ath9k_ani_reset(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 	struct ath9k_channel *chan = ah->curchan;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int index;
 
 	if (!DO_ANI(ah))
@@ -475,8 +480,8 @@ void ath9k_ani_reset(struct ath_hw *ah)
 
 	if (DO_ANI(ah) && ah->opmode != NL80211_IFTYPE_STATION
 	    && ah->opmode != NL80211_IFTYPE_ADHOC) {
-		DPRINTF(ah, ATH_DBG_ANI,
-			"Reset ANI state opmode %u\n", ah->opmode);
+		ath_print(common, ATH_DBG_ANI,
+			  "Reset ANI state opmode %u\n", ah->opmode);
 		ah->stats.ast_ani_reset++;
 
 		if (ah->opmode == NL80211_IFTYPE_AP) {
@@ -543,6 +548,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 			  struct ath9k_channel *chan)
 {
 	struct ar5416AniState *aniState;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int32_t listenTime;
 	u32 phyCnt1, phyCnt2;
 	u32 ofdmPhyErrCnt, cckPhyErrCnt;
@@ -569,20 +575,22 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 	if (phyCnt1 < aniState->ofdmPhyErrBase ||
 	    phyCnt2 < aniState->cckPhyErrBase) {
 		if (phyCnt1 < aniState->ofdmPhyErrBase) {
-			DPRINTF(ah, ATH_DBG_ANI,
-				"phyCnt1 0x%x, resetting "
-				"counter value to 0x%x\n",
-				phyCnt1, aniState->ofdmPhyErrBase);
+			ath_print(common, ATH_DBG_ANI,
+				  "phyCnt1 0x%x, resetting "
+				  "counter value to 0x%x\n",
+				  phyCnt1,
+				  aniState->ofdmPhyErrBase);
 			REG_WRITE(ah, AR_PHY_ERR_1,
 				  aniState->ofdmPhyErrBase);
 			REG_WRITE(ah, AR_PHY_ERR_MASK_1,
 				  AR_PHY_ERR_OFDM_TIMING);
 		}
 		if (phyCnt2 < aniState->cckPhyErrBase) {
-			DPRINTF(ah, ATH_DBG_ANI,
-				"phyCnt2 0x%x, resetting "
-				"counter value to 0x%x\n",
-				phyCnt2, aniState->cckPhyErrBase);
+			ath_print(common, ATH_DBG_ANI,
+				  "phyCnt2 0x%x, resetting "
+				  "counter value to 0x%x\n",
+				  phyCnt2,
+				  aniState->cckPhyErrBase);
 			REG_WRITE(ah, AR_PHY_ERR_2,
 				  aniState->cckPhyErrBase);
 			REG_WRITE(ah, AR_PHY_ERR_MASK_2,
@@ -624,7 +632,9 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
-	DPRINTF(ah, ATH_DBG_ANI, "Enable MIB counters\n");
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_print(common, ATH_DBG_ANI, "Enable MIB counters\n");
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
@@ -640,7 +650,10 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 /* Freeze the MIB counters, get the stats and then clear them */
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 {
-	DPRINTF(ah, ATH_DBG_ANI, "Disable MIB counters\n");
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_print(common, ATH_DBG_ANI, "Disable MIB counters\n");
+
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
@@ -653,6 +666,7 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
 				  u32 *rxf_pcnt,
 				  u32 *txf_pcnt)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	static u32 cycles, rx_clear, rx_frame, tx_frame;
 	u32 good = 1;
 
@@ -662,8 +676,8 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
 	u32 cc = REG_READ(ah, AR_CCCNT);
 
 	if (cycles == 0 || cycles > cc) {
-		DPRINTF(ah, ATH_DBG_ANI,
-			"cycle counter wrap. ExtBusy = 0\n");
+		ath_print(common, ATH_DBG_ANI,
+			  "cycle counter wrap. ExtBusy = 0\n");
 		good = 0;
 	} else {
 		u32 cc_d = cc - cycles;
@@ -762,9 +776,10 @@ void ath9k_hw_ani_setup(struct ath_hw *ah)
 
 void ath9k_hw_ani_init(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	int i;
 
-	DPRINTF(ah, ATH_DBG_ANI, "Initialize ANI\n");
+	ath_print(common, ATH_DBG_ANI, "Initialize ANI\n");
 
 	memset(ah->ani, 0, sizeof(ah->ani));
 	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
@@ -786,11 +801,11 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 			AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH;
 	}
 
-	DPRINTF(ah, ATH_DBG_ANI,
-		"Setting OfdmErrBase = 0x%08x\n",
-		ah->ani[0].ofdmPhyErrBase);
-	DPRINTF(ah, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
-		ah->ani[0].cckPhyErrBase);
+	ath_print(common, ATH_DBG_ANI,
+		  "Setting OfdmErrBase = 0x%08x\n",
+		  ah->ani[0].ofdmPhyErrBase);
+	ath_print(common, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
+		  ah->ani[0].cckPhyErrBase);
 
 	REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
@@ -803,7 +818,7 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 
 void ath9k_hw_ani_disable(struct ath_hw *ah)
 {
-	DPRINTF(ah, ATH_DBG_ANI, "Disabling ANI\n");
+	ath_print(ath9k_hw_common(ah), ATH_DBG_ANI, "Disabling ANI\n");
 
 	ath9k_hw_disable_mib_counters(ah);
 	REG_WRITE(ah, AR_PHY_ERR_1, 0);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7c740cf..9864461 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -26,6 +26,7 @@
 #include "rc.h"
 #include "debug.h"
 #include "../ath.h"
+#include "../debug.h"
 
 struct ath_node;
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index fb4ff55..2f00313 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -26,6 +26,7 @@
 static int ath_beaconq_config(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info qi;
 
 	ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
@@ -42,8 +43,8 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	}
 
 	if (!ath9k_hw_set_txq_props(ah, sc->beacon.beaconq, &qi)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to update h/w beacon queue parameters\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to update h/w beacon queue parameters\n");
 		return 0;
 	} else {
 		ath9k_hw_resettxqueue(ah, sc->beacon.beaconq);
@@ -119,6 +120,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_buf *bf;
 	struct ath_vif *avp;
 	struct sk_buff *skb;
@@ -172,7 +174,8 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "dma_mapping_error on beaconing\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "dma_mapping_error on beaconing\n");
 		return NULL;
 	}
 
@@ -192,8 +195,8 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 
 	if (skb && cabq_depth) {
 		if (sc->nvifs > 1) {
-			DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-				"Flushing previous cabq traffic\n");
+			ath_print(common, ATH_DBG_BEACON,
+				  "Flushing previous cabq traffic\n");
 			ath_draintxq(sc, cabq, false);
 		}
 	}
@@ -216,6 +219,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc,
 				   struct ieee80211_vif *vif)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf;
 	struct ath_vif *avp;
 	struct sk_buff *skb;
@@ -233,8 +237,8 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc,
 	/* NB: caller is known to have already stopped tx dma */
 	ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bf->bf_daddr);
 	ath9k_hw_txstart(ah, sc->beacon.beaconq);
-	DPRINTF(ah, ATH_DBG_BEACON, "TXDP%u = %llx (%p)\n",
-		sc->beacon.beaconq, ito64(bf->bf_daddr), bf->bf_desc);
+	ath_print(common, ATH_DBG_BEACON, "TXDP%u = %llx (%p)\n",
+		  sc->beacon.beaconq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
 int ath_beaconq_setup(struct ath_hw *ah)
@@ -252,6 +256,7 @@ int ath_beaconq_setup(struct ath_hw *ah)
 int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
@@ -309,7 +314,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	/* NB: the beacon data buffer must be 32-bit aligned. */
 	skb = ieee80211_beacon_get(sc->hw, vif);
 	if (skb == NULL) {
-		DPRINTF(sc->sc_ah, ATH_DBG_BEACON, "cannot get skb\n");
+		ath_print(common, ATH_DBG_BEACON, "cannot get skb\n");
 		return -ENOMEM;
 	}
 
@@ -333,9 +338,10 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 		tsfadjust = intval * avp->av_bslot / ATH_BCBUF;
 		avp->tsf_adjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
 
-		DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
-			avp->av_bslot, intval, (unsigned long long)tsfadjust);
+		ath_print(common, ATH_DBG_BEACON,
+			  "stagger beacons, bslot %d intval "
+			  "%u tsfadjust %llu\n",
+			  avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
 		((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp =
 			avp->tsf_adjust;
@@ -349,8 +355,8 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"dma_mapping_error on beacon alloc\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "dma_mapping_error on beacon alloc\n");
 		return -ENOMEM;
 	}
 
@@ -386,6 +392,7 @@ void ath_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
 	struct ath_wiphy *aphy;
@@ -405,12 +412,12 @@ void ath_beacon_tasklet(unsigned long data)
 		sc->beacon.bmisscnt++;
 
 		if (sc->beacon.bmisscnt < BSTUCK_THRESH) {
-			DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-				"missed %u consecutive beacons\n",
-				sc->beacon.bmisscnt);
+			ath_print(common, ATH_DBG_BEACON,
+				  "missed %u consecutive beacons\n",
+				  sc->beacon.bmisscnt);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
-			DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-				"beacon is officially stuck\n");
+			ath_print(common, ATH_DBG_BEACON,
+				  "beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
 			ath_reset(sc, false);
 		}
@@ -419,9 +426,9 @@ void ath_beacon_tasklet(unsigned long data)
 	}
 
 	if (sc->beacon.bmisscnt != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-			"resume beacon xmit after %u misses\n",
-			sc->beacon.bmisscnt);
+		ath_print(common, ATH_DBG_BEACON,
+			  "resume beacon xmit after %u misses\n",
+			  sc->beacon.bmisscnt);
 		sc->beacon.bmisscnt = 0;
 	}
 
@@ -447,9 +454,9 @@ void ath_beacon_tasklet(unsigned long data)
 	vif = sc->beacon.bslot[slot];
 	aphy = sc->beacon.bslot_aphy[slot];
 
-	DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
-		slot, tsf, tsftu, intval, vif);
+	ath_print(common, ATH_DBG_BEACON,
+		  "slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
+		  slot, tsf, tsftu, intval, vif);
 
 	bfaddr = 0;
 	if (vif) {
@@ -490,7 +497,7 @@ void ath_beacon_tasklet(unsigned long data)
 		 * are still pending on the queue.
 		 */
 		if (!ath9k_hw_stoptxdma(ah, sc->beacon.beaconq)) {
-			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
+			ath_print(common, ATH_DBG_FATAL,
 				"beacon queue %u did not stop?\n", sc->beacon.beaconq);
 		}
 
@@ -568,6 +575,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 static void ath_beacon_config_sta(struct ath_softc *sc,
 				  struct ath_beacon_config *conf)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_beacon_state bs;
 	int dtimperiod, dtimcount, sleepduration;
 	int cfpperiod, cfpcount;
@@ -664,11 +672,11 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	/* TSF out of range threshold fixed at 1 second */
 	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
-	DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
-		bs.bs_bmissthreshold, bs.bs_sleepduration,
-		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
+	ath_print(common, ATH_DBG_BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
+	ath_print(common, ATH_DBG_BEACON,
+		  "bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
+		  bs.bs_bmissthreshold, bs.bs_sleepduration,
+		  bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
 
 	/* Set the computed STA beacon timers */
 
@@ -682,6 +690,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 				    struct ath_beacon_config *conf,
 				    struct ieee80211_vif *vif)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u64 tsf;
 	u32 tsftu, intval, nexttbtt;
 
@@ -702,9 +711,9 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 		nexttbtt += intval;
 	} while (nexttbtt < tsftu);
 
-	DPRINTF(sc->sc_ah, ATH_DBG_BEACON,
-		"IBSS nexttbtt %u intval %u (%u)\n",
-		nexttbtt, intval, conf->beacon_interval);
+	ath_print(common, ATH_DBG_BEACON,
+		  "IBSS nexttbtt %u intval %u (%u)\n",
+		  nexttbtt, intval, conf->beacon_interval);
 
 	/*
 	 * In IBSS mode enable the beacon timers but only enable SWBA interrupts
@@ -732,6 +741,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	enum nl80211_iftype iftype;
 
 	/* Setup the beacon configuration parameters */
@@ -772,8 +782,8 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 		ath_beacon_config_sta(sc, cur_conf);
 		break;
 	default:
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-			"Unsupported beaconing mode\n");
+		ath_print(common, ATH_DBG_CONFIG,
+			  "Unsupported beaconing mode\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index edf1fdd..ce0b759 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -15,6 +15,7 @@
  */
 
 #include "ath9k.h"
+#include "hw.h"
 
 /* We can tune this as we go by monitoring really low values */
 #define ATH9K_NF_TOO_LOW	-60
@@ -26,11 +27,11 @@
 static bool ath9k_hw_nf_in_range(struct ath_hw *ah, s16 nf)
 {
 	if (nf > ATH9K_NF_TOO_LOW) {
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"noise floor value detected (%d) is "
-			"lower than what we think is a "
-			"reasonable value (%d)\n",
-			nf, ATH9K_NF_TOO_LOW);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			  "noise floor value detected (%d) is "
+			  "lower than what we think is a "
+			  "reasonable value (%d)\n",
+			  nf, ATH9K_NF_TOO_LOW);
 		return false;
 	}
 	return true;
@@ -89,6 +90,7 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
 static void ath9k_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	int16_t nf;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
@@ -98,8 +100,8 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah, ATH_DBG_CALIBRATE,
-		"NF calibrated [ctl] [chain 0] is %d\n", nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
 	nfarray[0] = nf;
 
 	if (!AR_SREV_9285(ah)) {
@@ -112,8 +114,8 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"NF calibrated [ctl] [chain 1] is %d\n", nf);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "NF calibrated [ctl] [chain 1] is %d\n", nf);
 		nfarray[1] = nf;
 
 		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
@@ -121,8 +123,8 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 					AR_PHY_CH2_MINCCA_PWR);
 			if (nf & 0x100)
 				nf = 0 - ((nf ^ 0x1ff) + 1);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"NF calibrated [ctl] [chain 2] is %d\n", nf);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "NF calibrated [ctl] [chain 2] is %d\n", nf);
 			nfarray[2] = nf;
 		}
 	}
@@ -136,8 +138,8 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah, ATH_DBG_CALIBRATE,
-		"NF calibrated [ext] [chain 0] is %d\n", nf);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "NF calibrated [ext] [chain 0] is %d\n", nf);
 	nfarray[3] = nf;
 
 	if (!AR_SREV_9285(ah)) {
@@ -150,8 +152,8 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"NF calibrated [ext] [chain 1] is %d\n", nf);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "NF calibrated [ext] [chain 1] is %d\n", nf);
 		nfarray[4] = nf;
 
 		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
@@ -159,8 +161,8 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 					AR_PHY_CH2_EXT_MINCCA_PWR);
 			if (nf & 0x100)
 				nf = 0 - ((nf ^ 0x1ff) + 1);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"NF calibrated [ext] [chain 2] is %d\n", nf);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "NF calibrated [ext] [chain 2] is %d\n", nf);
 			nfarray[5] = nf;
 		}
 	}
@@ -188,6 +190,8 @@ static bool getNoiseFloorThresh(struct ath_hw *ah,
 static void ath9k_hw_setup_calibration(struct ath_hw *ah,
 				       struct ath9k_cal_list *currCal)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+
 	REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
 		      AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX,
 		      currCal->calData->calCountMax);
@@ -195,23 +199,23 @@ static void ath9k_hw_setup_calibration(struct ath_hw *ah,
 	switch (currCal->calData->calType) {
 	case IQ_MISMATCH_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"starting IQ Mismatch Calibration\n");
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting IQ Mismatch Calibration\n");
 		break;
 	case ADC_GAIN_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_GAIN);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"starting ADC Gain Calibration\n");
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting ADC Gain Calibration\n");
 		break;
 	case ADC_DC_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_PER);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"starting ADC DC Calibration\n");
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting ADC DC Calibration\n");
 		break;
 	case ADC_DC_INIT_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_INIT);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"starting Init ADC DC Calibration\n");
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting Init ADC DC Calibration\n");
 		break;
 	}
 
@@ -304,11 +308,11 @@ static void ath9k_hw_iqcal_collect(struct ath_hw *ah)
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
 		ah->totalIqCorrMeas[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
-			ah->cal_samples, i, ah->totalPowerMeasI[i],
-			ah->totalPowerMeasQ[i],
-			ah->totalIqCorrMeas[i]);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			  "%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
+			  ah->cal_samples, i, ah->totalPowerMeasI[i],
+			  ah->totalPowerMeasQ[i],
+			  ah->totalIqCorrMeas[i]);
 	}
 }
 
@@ -326,14 +330,14 @@ static void ath9k_hw_adc_gaincal_collect(struct ath_hw *ah)
 		ah->totalAdcQEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
-			"oddq=0x%08x; evenq=0x%08x;\n",
-			ah->cal_samples, i,
-			ah->totalAdcIOddPhase[i],
-			ah->totalAdcIEvenPhase[i],
-			ah->totalAdcQOddPhase[i],
-			ah->totalAdcQEvenPhase[i]);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			  "%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
+			  "oddq=0x%08x; evenq=0x%08x;\n",
+			  ah->cal_samples, i,
+			  ah->totalAdcIOddPhase[i],
+			  ah->totalAdcIEvenPhase[i],
+			  ah->totalAdcQOddPhase[i],
+			  ah->totalAdcQEvenPhase[i]);
 	}
 }
 
@@ -351,19 +355,20 @@ static void ath9k_hw_adc_dccal_collect(struct ath_hw *ah)
 		ah->totalAdcDcOffsetQEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
-			"oddq=0x%08x; evenq=0x%08x;\n",
-			ah->cal_samples, i,
-			ah->totalAdcDcOffsetIOddPhase[i],
-			ah->totalAdcDcOffsetIEvenPhase[i],
-			ah->totalAdcDcOffsetQOddPhase[i],
-			ah->totalAdcDcOffsetQEvenPhase[i]);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			  "%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
+			  "oddq=0x%08x; evenq=0x%08x;\n",
+			  ah->cal_samples, i,
+			  ah->totalAdcDcOffsetIOddPhase[i],
+			  ah->totalAdcDcOffsetIEvenPhase[i],
+			  ah->totalAdcDcOffsetQOddPhase[i],
+			  ah->totalAdcDcOffsetQEvenPhase[i]);
 	}
 }
 
 static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 powerMeasQ, powerMeasI, iqCorrMeas;
 	u32 qCoffDenom, iCoffDenom;
 	int32_t qCoff, iCoff;
@@ -374,13 +379,13 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		powerMeasQ = ah->totalPowerMeasQ[i];
 		iqCorrMeas = ah->totalIqCorrMeas[i];
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Starting IQ Cal and Correction for Chain %d\n",
-			i);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Starting IQ Cal and Correction for Chain %d\n",
+			  i);
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Orignal: Chn %diq_corr_meas = 0x%08x\n",
-			i, ah->totalIqCorrMeas[i]);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Orignal: Chn %diq_corr_meas = 0x%08x\n",
+			  i, ah->totalIqCorrMeas[i]);
 
 		iqCorrNeg = 0;
 
@@ -389,12 +394,12 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			iqCorrNeg = 1;
 		}
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
-		DPRINTF(ah, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
-			iqCorrNeg);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
+		ath_print(common, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
+			  iqCorrNeg);
 
 		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 128;
 		qCoffDenom = powerMeasQ / 64;
@@ -402,14 +407,14 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		if (powerMeasQ != 0) {
 			iCoff = iqCorrMeas / iCoffDenom;
 			qCoff = powerMeasI / qCoffDenom - 64;
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"Chn %d iCoff = 0x%08x\n", i, iCoff);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"Chn %d qCoff = 0x%08x\n", i, qCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d iCoff = 0x%08x\n", i, iCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d qCoff = 0x%08x\n", i, qCoff);
 
 			iCoff = iCoff & 0x3f;
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"New: Chn %d iCoff = 0x%08x\n", i, iCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "New: Chn %d iCoff = 0x%08x\n", i, iCoff);
 			if (iqCorrNeg == 0x0)
 				iCoff = 0x40 - iCoff;
 
@@ -418,9 +423,9 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			else if (qCoff <= -16)
 				qCoff = 16;
 
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
-				i, iCoff, qCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
+				  i, iCoff, qCoff);
 
 			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
 				      AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF,
@@ -428,9 +433,9 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
 				      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
 				      qCoff);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"IQ Cal and Correction done for Chain %d\n",
-				i);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "IQ Cal and Correction done for Chain %d\n",
+				  i);
 		}
 	}
 
@@ -440,6 +445,7 @@ static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 
 static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 iOddMeasOffset, iEvenMeasOffset, qOddMeasOffset, qEvenMeasOffset;
 	u32 qGainMismatch, iGainMismatch, val, i;
 
@@ -449,21 +455,21 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 		qOddMeasOffset = ah->totalAdcQOddPhase[i];
 		qEvenMeasOffset = ah->totalAdcQEvenPhase[i];
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Starting ADC Gain Cal for Chain %d\n", i);
-
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_i = 0x%08x\n", i,
-			iOddMeasOffset);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_i = 0x%08x\n", i,
-			iEvenMeasOffset);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_q = 0x%08x\n", i,
-			qOddMeasOffset);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_q = 0x%08x\n", i,
-			qEvenMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Starting ADC Gain Cal for Chain %d\n", i);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_i = 0x%08x\n", i,
+			  iOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_i = 0x%08x\n", i,
+			  iEvenMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_q = 0x%08x\n", i,
+			  qOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_q = 0x%08x\n", i,
+			  qEvenMeasOffset);
 
 		if (iOddMeasOffset != 0 && qEvenMeasOffset != 0) {
 			iGainMismatch =
@@ -473,20 +479,20 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 				((qOddMeasOffset * 32) /
 				 qEvenMeasOffset) & 0x3f;
 
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"Chn %d gain_mismatch_i = 0x%08x\n", i,
-				iGainMismatch);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"Chn %d gain_mismatch_q = 0x%08x\n", i,
-				qGainMismatch);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d gain_mismatch_i = 0x%08x\n", i,
+				  iGainMismatch);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d gain_mismatch_q = 0x%08x\n", i,
+				  qGainMismatch);
 
 			val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
 			val &= 0xfffff000;
 			val |= (qGainMismatch) | (iGainMismatch << 6);
 			REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"ADC Gain Cal done for Chain %d\n", i);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "ADC Gain Cal done for Chain %d\n", i);
 		}
 	}
 
@@ -497,6 +503,7 @@ static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 
 static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 iOddMeasOffset, iEvenMeasOffset, val, i;
 	int32_t qOddMeasOffset, qEvenMeasOffset, qDcMismatch, iDcMismatch;
 	const struct ath9k_percal_data *calData =
@@ -510,41 +517,41 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 		qOddMeasOffset = ah->totalAdcDcOffsetQOddPhase[i];
 		qEvenMeasOffset = ah->totalAdcDcOffsetQEvenPhase[i];
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Starting ADC DC Offset Cal for Chain %d\n", i);
-
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_i = %d\n", i,
-			iOddMeasOffset);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_i = %d\n", i,
-			iEvenMeasOffset);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_q = %d\n", i,
-			qOddMeasOffset);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_q = %d\n", i,
-			qEvenMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			   "Starting ADC DC Offset Cal for Chain %d\n", i);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_i = %d\n", i,
+			  iOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_i = %d\n", i,
+			  iEvenMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_q = %d\n", i,
+			  qOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_q = %d\n", i,
+			  qEvenMeasOffset);
 
 		iDcMismatch = (((iEvenMeasOffset - iOddMeasOffset) * 2) /
 			       numSamples) & 0x1ff;
 		qDcMismatch = (((qOddMeasOffset - qEvenMeasOffset) * 2) /
 			       numSamples) & 0x1ff;
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d dc_offset_mismatch_i = 0x%08x\n", i,
-			iDcMismatch);
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Chn %d dc_offset_mismatch_q = 0x%08x\n", i,
-			qDcMismatch);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d dc_offset_mismatch_i = 0x%08x\n", i,
+			  iDcMismatch);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d dc_offset_mismatch_q = 0x%08x\n", i,
+			  qDcMismatch);
 
 		val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
 		val &= 0xc0000fff;
 		val |= (qDcMismatch << 12) | (iDcMismatch << 21);
 		REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"ADC DC Offset Cal done for Chain %d\n", i);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "ADC DC Offset Cal done for Chain %d\n", i);
 	}
 
 	REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0),
@@ -555,7 +562,8 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 /* This is done for the currently configured channel */
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &common->hw->conf;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 
 	if (!ah->curchan)
@@ -568,18 +576,18 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 
 	if (currCal->calState != CAL_DONE) {
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"Calibration state incorrect, %d\n",
-			currCal->calState);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Calibration state incorrect, %d\n",
+			  currCal->calState);
 		return true;
 	}
 
 	if (!ath9k_hw_iscal_supported(ah, currCal->calData->calType))
 		return true;
 
-	DPRINTF(ah, ATH_DBG_CALIBRATE,
-		"Resetting Cal %d state for channel %u\n",
-		currCal->calData->calType, conf->channel->center_freq);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "Resetting Cal %d state for channel %u\n",
+		  currCal->calData->calType, conf->channel->center_freq);
 
 	ah->curchan->CalValid &= ~currCal->calData->calType;
 	currCal->calState = CAL_WAITING;
@@ -655,6 +663,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	int16_t nf, nfThresh;
 	int16_t nfarray[NUM_NF_READINGS] = { 0 };
 	struct ath9k_nfcal_hist *h;
@@ -662,8 +671,8 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
-		DPRINTF(ah, ATH_DBG_CALIBRATE,
-			"NF did not complete in calibration window\n");
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "NF did not complete in calibration window\n");
 		nf = 0;
 		chan->rawNoiseFloor = nf;
 		return chan->rawNoiseFloor;
@@ -672,10 +681,10 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		nf = nfarray[0];
 		if (getNoiseFloorThresh(ah, c->band, &nfThresh)
 		    && nf > nfThresh) {
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"noise floor failed detected; "
-				"detected %d, threshold %d\n",
-				nf, nfThresh);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "noise floor failed detected; "
+				  "detected %d, threshold %d\n",
+				  nf, nfThresh);
 			chan->channelFlags |= CHANNEL_CW_INT;
 		}
 	}
@@ -863,7 +872,7 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah)
 
 static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
 {
-
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regVal;
 	int i, offset, offs_6_1, offs_0;
 	u32 ccomp_org, reg_field;
@@ -877,7 +886,7 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ 0x7838, 0 },
 	};
 
-	DPRINTF(ah, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+	ath_print(common, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
 
 	/* PA CAL is not needed for high power solution */
 	if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) ==
@@ -1026,6 +1035,8 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 
 static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+
 	REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
 	if (IS_CHAN_HT20(chan)) {
 		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
@@ -1036,9 +1047,9 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
-			DPRINTF(ah, ATH_DBG_CALIBRATE, "offset "
-				"calibration failed to complete in "
-				"1ms; noisy ??\n");
+			ath_print(common, ATH_DBG_CALIBRATE, "offset "
+				  "calibration failed to complete in "
+				  "1ms; noisy ??\n");
 			return false;
 		}
 		REG_CLR_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
@@ -1051,8 +1062,8 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
 	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
 			  0, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah, ATH_DBG_CALIBRATE, "offset calibration "
-				"failed to complete in 1ms; noisy ??\n");
+		ath_print(common, ATH_DBG_CALIBRATE, "offset calibration "
+			  "failed to complete in 1ms; noisy ??\n");
 		return false;
 	}
 
@@ -1065,6 +1076,8 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 
 bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+
 	if (AR_SREV_9285_12_OR_LATER(ah)) {
 		if (!ar9285_clc(ah, chan))
 			return false;
@@ -1085,9 +1098,9 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		/* Poll for offset calibration complete */
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
 				   0, AH_WAIT_TIMEOUT)) {
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"offset calibration failed to complete in 1ms; "
-				"noisy environment?\n");
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "offset calibration failed to "
+				  "complete in 1ms; noisy environment?\n");
 			return false;
 		}
 
@@ -1115,20 +1128,20 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"enabling ADC Gain Calibration.\n");
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "enabling ADC Gain Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"enabling ADC DC Calibration.\n");
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "enabling ADC DC Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ah->iq_caldata);
 			INSERT_CAL(ah, &ah->iq_caldata);
-			DPRINTF(ah, ATH_DBG_CALIBRATE,
-				"enabling IQ Calibration.\n");
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "enabling IQ Calibration.\n");
 		}
 
 		ah->cal_list_curr = ah->cal_list;
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 019bcbb..c08f8c6 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -17,6 +17,8 @@
 #ifndef CALIB_H
 #define CALIB_H
 
+#include "hw.h"
+
 extern const struct ath9k_percal_data iq_cal_multi_sample;
 extern const struct ath9k_percal_data iq_cal_single_sample;
 extern const struct ath9k_percal_data adc_gain_cal_multi_sample;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index babfd37..5dfc0e9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -18,26 +18,11 @@
 
 #include "ath9k.h"
 
-static unsigned int ath9k_debug = DBG_DEFAULT;
+static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
 
 static struct dentry *ath9k_debugfs_root;
 
-void DPRINTF(struct ath_hw *ah, int dbg_mask, const char *fmt, ...)
-{
-	if (!ah->ah_sc)
-		return;
-
-	if (ah->ah_sc->debug.debug_mask & dbg_mask) {
-		va_list args;
-
-		va_start(args, fmt);
-		printk(KERN_DEBUG "ath9k: ");
-		vprintk(fmt, args);
-		va_end(args);
-	}
-}
-
 static int ath9k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -48,10 +33,11 @@ static ssize_t read_file_debug(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	char buf[32];
 	unsigned int len;
 
-	len = snprintf(buf, sizeof(buf), "0x%08x\n", sc->debug.debug_mask);
+	len = snprintf(buf, sizeof(buf), "0x%08x\n", common->debug_mask);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -59,6 +45,7 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	unsigned long mask;
 	char buf[32];
 	ssize_t len;
@@ -71,7 +58,7 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 	if (strict_strtoul(buf, 0, &mask))
 		return -EINVAL;
 
-	sc->debug.debug_mask = mask;
+	common->debug_mask = mask;
 	return count;
 }
 
@@ -571,8 +558,9 @@ static const struct file_operations fops_xmit = {
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_softc *sc = ah->ah_sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	sc->debug.debug_mask = ath9k_debug;
+	common->debug_mask = ath9k_debug;
 
 	if (!ath9k_debugfs_root)
 		return -ENOENT;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index c9c1aac..749e85d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -19,26 +19,6 @@
 
 #include "hw.h"
 
-enum ATH_DEBUG {
-	ATH_DBG_RESET		= 0x00000001,
-	ATH_DBG_QUEUE		= 0x00000002,
-	ATH_DBG_EEPROM		= 0x00000004,
-	ATH_DBG_CALIBRATE	= 0x00000008,
-	ATH_DBG_INTERRUPT	= 0x00000010,
-	ATH_DBG_REGULATORY	= 0x00000020,
-	ATH_DBG_ANI		= 0x00000040,
-	ATH_DBG_XMIT		= 0x00000080,
-	ATH_DBG_BEACON		= 0x00000100,
-	ATH_DBG_CONFIG		= 0x00000200,
-	ATH_DBG_FATAL		= 0x00000400,
-	ATH_DBG_PS		= 0x00000800,
-	ATH_DBG_HWTIMER		= 0x00001000,
-	ATH_DBG_BTCOEX		= 0x00002000,
-	ATH_DBG_ANY		= 0xffffffff
-};
-
-#define DBG_DEFAULT (ATH_DBG_FATAL)
-
 struct ath_txq;
 struct ath_buf;
 
@@ -142,7 +122,6 @@ struct ath_stats {
 };
 
 struct ath9k_debug {
-	int debug_mask;
 	struct dentry *debugfs_phy;
 	struct dentry *debugfs_debug;
 	struct dentry *debugfs_dma;
@@ -153,7 +132,6 @@ struct ath9k_debug {
 	struct ath_stats stats;
 };
 
-void DPRINTF(struct ath_hw *ah, int dbg_mask, const char *fmt, ...);
 int ath9k_init_debug(struct ath_hw *ah);
 void ath9k_exit_debug(struct ath_hw *ah);
 
@@ -168,11 +146,6 @@ void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 
 #else
 
-static inline void DPRINTF(struct ath_hw *ah, int dbg_mask,
-			   const char *fmt, ...)
-{
-}
-
 static inline int ath9k_init_debug(struct ath_hw *ah)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 0675cd5..079dd20 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -15,6 +15,7 @@
  */
 
 #include "ath9k.h"
+#include "hw.h"
 
 static int ath9k_hw_4k_get_eeprom_ver(struct ath_hw *ah)
 {
@@ -29,20 +30,21 @@ static int ath9k_hw_4k_get_eeprom_rev(struct ath_hw *ah)
 static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
+	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eep_data = (u16 *)&ah->eeprom.map4k;
 	int addr, eep_start_loc = 0;
 
 	eep_start_loc = 64;
 
 	if (!ath9k_hw_use_flash(ah)) {
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Reading from EEPROM, not flash\n");
 	}
 
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
-			DPRINTF(ah, ATH_DBG_EEPROM,
-			       "Unable to read eeprom region \n");
+			ath_print(common, ATH_DBG_EEPROM,
+				  "Unable to read eeprom region \n");
 			return false;
 		}
 		eep_data++;
@@ -55,6 +57,7 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 {
 #define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar5416_eeprom_4k *eep =
 		(struct ar5416_eeprom_4k *) &ah->eeprom.map4k;
 	u16 *eepdata, temp, magic, magic2;
@@ -66,13 +69,13 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 	if (!ath9k_hw_use_flash(ah)) {
 		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
 					 &magic)) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Reading Magic # failed\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "Reading Magic # failed\n");
 			return false;
 		}
 
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"Read Magic = 0x%04X\n", magic);
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -87,16 +90,16 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 					eepdata++;
 				}
 			} else {
-				DPRINTF(ah, ATH_DBG_FATAL,
-					"Invalid EEPROM Magic. "
-					"endianness mismatch.\n");
+				ath_print(common, ATH_DBG_FATAL,
+					  "Invalid EEPROM Magic. "
+					  "endianness mismatch.\n");
 				return -EINVAL;
 			}
 		}
 	}
 
-	DPRINTF(ah, ATH_DBG_EEPROM, "need_swap = %s.\n",
-		need_swap ? "True" : "False");
+	ath_print(common, ATH_DBG_EEPROM, "need_swap = %s.\n",
+		  need_swap ? "True" : "False");
 
 	if (need_swap)
 		el = swab16(ah->eeprom.map4k.baseEepHeader.length);
@@ -117,8 +120,8 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		u32 integer;
 		u16 word;
 
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"EEPROM Endianness is not native.. Changing\n");
+		ath_print(common, ATH_DBG_EEPROM,
+			  "EEPROM Endianness is not native.. Changing\n");
 
 		word = swab16(eep->baseEepHeader.length);
 		eep->baseEepHeader.length = word;
@@ -160,9 +163,9 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
 	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ah->eep_ops->get_eeprom_ver(ah));
+		ath_print(common, ATH_DBG_FATAL,
+			  "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			  sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
 	}
 
@@ -385,6 +388,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct cal_data_per_freq_4k *pRawDataset;
 	u8 *pCalBChans = NULL;
@@ -470,21 +474,21 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 					((pdadcValues[4 * j + 3] & 0xFF) << 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				DPRINTF(ah, ATH_DBG_EEPROM,
-					"PDADC (%d,%4x): %4.4x %8.8x\n",
-					i, regChainOffset, regOffset,
-					reg32);
-				DPRINTF(ah, ATH_DBG_EEPROM,
-					"PDADC: Chain %d | "
-					"PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d |\n",
-					i, 4 * j, pdadcValues[4 * j],
-					4 * j + 1, pdadcValues[4 * j + 1],
-					4 * j + 2, pdadcValues[4 * j + 2],
-					4 * j + 3,
-					pdadcValues[4 * j + 3]);
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PDADC (%d,%4x): %4.4x %8.8x\n",
+					  i, regChainOffset, regOffset,
+					  reg32);
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PDADC: Chain %d | "
+					  "PDADC %3d Value %3d | "
+					  "PDADC %3d Value %3d | "
+					  "PDADC %3d Value %3d | "
+					  "PDADC %3d Value %3d |\n",
+					  i, 4 * j, pdadcValues[4 * j],
+					  4 * j + 1, pdadcValues[4 * j + 1],
+					  4 * j + 2, pdadcValues[4 * j + 2],
+					  4 * j + 3,
+					  pdadcValues[4 * j + 3]);
 
 				regOffset += 4;
 			}
@@ -1148,20 +1152,21 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_MAP4K_SPURCHAN \
 	(ah->eeprom.map4k.modalHeader.spurChans[i].spurChan)
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	u16 spur_val = AR_NO_SPUR;
 
-	DPRINTF(ah, ATH_DBG_ANI,
-		"Getting spur idx %d is2Ghz. %d val %x\n",
-		i, is2GHz, ah->config.spurchans[i][is2GHz]);
+	ath_print(common, ATH_DBG_ANI,
+		  "Getting spur idx %d is2Ghz. %d val %x\n",
+		  i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
 	case SPUR_DISABLE:
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		DPRINTF(ah, ATH_DBG_ANI,
-			"Getting spur val from new loc. %d\n", spur_val);
+		ath_print(common, ATH_DBG_ANI,
+			  "Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
 		spur_val = EEP_MAP4K_SPURCHAN;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index c6a4325..6ffe85d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -15,6 +15,7 @@
  */
 
 #include "ath9k.h"
+#include "hw.h"
 
 static int ath9k_hw_AR9287_get_eeprom_ver(struct ath_hw *ah)
 {
@@ -29,20 +30,21 @@ static int ath9k_hw_AR9287_get_eeprom_rev(struct ath_hw *ah)
 static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eep_data;
 	int addr, eep_start_loc = AR9287_EEP_START_LOC;
 	eep_data = (u16 *)eep;
 
 	if (!ath9k_hw_use_flash(ah)) {
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Reading from EEPROM, not flash\n");
 	}
 
 	for (addr = 0; addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
 			addr++)	{
 		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
-			DPRINTF(ah, ATH_DBG_EEPROM,
-				"Unable to read eeprom region \n");
+			ath_print(common, ATH_DBG_EEPROM,
+				  "Unable to read eeprom region \n");
 			return false;
 		}
 		eep_data++;
@@ -57,17 +59,18 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	int i, addr;
 	bool need_swap = false;
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_use_flash(ah)) {
 		if (!ath9k_hw_nvram_read
 		    (ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Reading Magic # failed\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "Reading Magic # failed\n");
 			return false;
 		}
 
-		DPRINTF(ah, ATH_DBG_EEPROM,
-				"Read Magic = 0x%04X\n", magic);
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Read Magic = 0x%04X\n", magic);
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
 
@@ -83,15 +86,15 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 					eepdata++;
 				}
 			} else {
-				DPRINTF(ah, ATH_DBG_FATAL,
-					"Invalid EEPROM Magic. "
-					"endianness mismatch.\n");
+				ath_print(common, ATH_DBG_FATAL,
+					  "Invalid EEPROM Magic. "
+					  "endianness mismatch.\n");
 				return -EINVAL;
 			}
 		}
 	}
-	DPRINTF(ah, ATH_DBG_EEPROM, "need_swap = %s.\n", need_swap ?
-		"True" : "False");
+	ath_print(common, ATH_DBG_EEPROM, "need_swap = %s.\n", need_swap ?
+		  "True" : "False");
 
 	if (need_swap)
 		el = swab16(ah->eeprom.map9287.baseEepHeader.length);
@@ -148,9 +151,9 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR9287_EEP_VER
 	    || ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			 sum, ah->eep_ops->get_eeprom_ver(ah));
+		ath_print(common, ATH_DBG_FATAL,
+			  "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			   sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
 	}
 
@@ -436,6 +439,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 						struct ath9k_channel *chan,
 						int16_t *pTxPowerIndexOffset)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct cal_data_per_freq_ar9287 *pRawDataset;
 	struct cal_data_op_loop_ar9287 *pRawDatasetOpenLoop;
 	u8  *pCalBChans = NULL;
@@ -564,24 +568,25 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 						  & 0xFF) << 24) ;
 					REG_WRITE(ah, regOffset, reg32);
 
-					DPRINTF(ah, ATH_DBG_EEPROM,
-						"PDADC (%d,%4x): %4.4x %8.8x\n",
-						i, regChainOffset, regOffset,
-						reg32);
-
-					DPRINTF(ah, ATH_DBG_EEPROM,
-						"PDADC: Chain %d | "
-						"PDADC %3d Value %3d | "
-						"PDADC %3d Value %3d | "
-						"PDADC %3d Value %3d | "
-						"PDADC %3d Value %3d |\n",
-						i, 4 * j, pdadcValues[4 * j],
-						4 * j + 1,
-						pdadcValues[4 * j + 1],
-						4 * j + 2,
-						pdadcValues[4 * j + 2],
-						4 * j + 3,
-						pdadcValues[4 * j + 3]);
+					ath_print(common, ATH_DBG_EEPROM,
+						  "PDADC (%d,%4x): %4.4x "
+						  "%8.8x\n",
+						  i, regChainOffset, regOffset,
+						  reg32);
+
+					ath_print(common, ATH_DBG_EEPROM,
+						  "PDADC: Chain %d | "
+						  "PDADC %3d Value %3d | "
+						  "PDADC %3d Value %3d | "
+						  "PDADC %3d Value %3d | "
+						  "PDADC %3d Value %3d |\n",
+						  i, 4 * j, pdadcValues[4 * j],
+						  4 * j + 1,
+						  pdadcValues[4 * j + 1],
+						  4 * j + 2,
+						  pdadcValues[4 * j + 2],
+						  4 * j + 3,
+						  pdadcValues[4 * j + 3]);
 
 					regOffset += 4;
 				}
@@ -831,6 +836,7 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 {
 #define INCREASE_MAXPOW_BY_TWO_CHAIN     6
 #define INCREASE_MAXPOW_BY_THREE_CHAIN   10
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
@@ -966,8 +972,8 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 			INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"Invalid chainmask configuration\n");
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Invalid chainmask configuration\n");
 		break;
 	}
 }
@@ -1138,19 +1144,20 @@ static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
 {
 #define EEP_MAP9287_SPURCHAN \
 	(ah->eeprom.map9287.modalHeader.spurChans[i].spurChan)
+	struct ath_common *common = ath9k_hw_common(ah);
 	u16 spur_val = AR_NO_SPUR;
 
-	DPRINTF(ah, ATH_DBG_ANI,
-		"Getting spur idx %d is2Ghz. %d val %x\n",
-		i, is2GHz, ah->config.spurchans[i][is2GHz]);
+	ath_print(common, ATH_DBG_ANI,
+		  "Getting spur idx %d is2Ghz. %d val %x\n",
+		  i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
 	case SPUR_DISABLE:
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		DPRINTF(ah, ATH_DBG_ANI,
-		       "Getting spur val from new loc. %d\n", spur_val);
+		ath_print(common, ATH_DBG_ANI,
+			  "Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
 		spur_val = EEP_MAP9287_SPURCHAN;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index f152ff3..567d939 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -15,6 +15,7 @@
  */
 
 #include "ath9k.h"
+#include "hw.h"
 
 static void ath9k_get_txgain_index(struct ath_hw *ah,
 		struct ath9k_channel *chan,
@@ -95,8 +96,8 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
 					 eep_data)) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Unable to read eeprom region\n");
+			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+				  "Unable to read eeprom region\n");
 			return false;
 		}
 		eep_data++;
@@ -109,19 +110,20 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 {
 	struct ar5416_eeprom_def *eep =
 		(struct ar5416_eeprom_def *) &ah->eeprom.def;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eepdata, temp, magic, magic2;
 	u32 sum = 0, el;
 	bool need_swap = false;
 	int i, addr, size;
 
 	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
-		DPRINTF(ah, ATH_DBG_FATAL, "Reading Magic # failed\n");
+		ath_print(common, ATH_DBG_FATAL, "Reading Magic # failed\n");
 		return false;
 	}
 
 	if (!ath9k_hw_use_flash(ah)) {
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"Read Magic = 0x%04X\n", magic);
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -137,16 +139,16 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 					eepdata++;
 				}
 			} else {
-				DPRINTF(ah, ATH_DBG_FATAL,
-					"Invalid EEPROM Magic. "
-					"Endianness mismatch.\n");
+				ath_print(common, ATH_DBG_FATAL,
+					  "Invalid EEPROM Magic. "
+					  "Endianness mismatch.\n");
 				return -EINVAL;
 			}
 		}
 	}
 
-	DPRINTF(ah, ATH_DBG_EEPROM, "need_swap = %s.\n",
-		need_swap ? "True" : "False");
+	ath_print(common, ATH_DBG_EEPROM, "need_swap = %s.\n",
+		  need_swap ? "True" : "False");
 
 	if (need_swap)
 		el = swab16(ah->eeprom.def.baseEepHeader.length);
@@ -167,8 +169,8 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		u32 integer, j;
 		u16 word;
 
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"EEPROM Endianness is not native.. Changing.\n");
+		ath_print(common, ATH_DBG_EEPROM,
+			  "EEPROM Endianness is not native.. Changing.\n");
 
 		word = swab16(eep->baseEepHeader.length);
 		eep->baseEepHeader.length = word;
@@ -214,8 +216,8 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
 	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+		ath_print(common, ATH_DBG_FATAL,
+			  "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
 	}
@@ -744,7 +746,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 #define SM_PD_GAIN(x) SM(0x38, AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_##x)
 #define SM_PDGAIN_B(x, y) \
 		SM((gainBoundaries[x]), AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_##y)
-
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct cal_data_per_freq *pRawDataset;
 	u8 *pCalBChans = NULL;
@@ -868,20 +870,20 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 					((pdadcValues[4 * j + 3] & 0xFF) << 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				DPRINTF(ah, ATH_DBG_EEPROM,
-					"PDADC (%d,%4x): %4.4x %8.8x\n",
-					i, regChainOffset, regOffset,
-					reg32);
-				DPRINTF(ah, ATH_DBG_EEPROM,
-					"PDADC: Chain %d | PDADC %3d "
-					"Value %3d | PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d | PDADC %3d "
-					"Value %3d |\n",
-					i, 4 * j, pdadcValues[4 * j],
-					4 * j + 1, pdadcValues[4 * j + 1],
-					4 * j + 2, pdadcValues[4 * j + 2],
-					4 * j + 3,
-					pdadcValues[4 * j + 3]);
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PDADC (%d,%4x): %4.4x %8.8x\n",
+					  i, regChainOffset, regOffset,
+					  reg32);
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PDADC: Chain %d | PDADC %3d "
+					  "Value %3d | PDADC %3d Value %3d | "
+					  "PDADC %3d Value %3d | PDADC %3d "
+					  "Value %3d |\n",
+					  i, 4 * j, pdadcValues[4 * j],
+					  4 * j + 1, pdadcValues[4 * j + 1],
+					  4 * j + 2, pdadcValues[4 * j + 2],
+					  4 * j + 3,
+					  pdadcValues[4 * j + 3]);
 
 				regOffset += 4;
 			}
@@ -1309,8 +1311,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_EEPROM,
-			"Invalid chainmask configuration\n");
+		ath_print(ath9k_hw_common(ah), ATH_DBG_EEPROM,
+			  "Invalid chainmask configuration\n");
 		break;
 	}
 }
@@ -1347,20 +1349,21 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_DEF_SPURCHAN \
 	(ah->eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	u16 spur_val = AR_NO_SPUR;
 
-	DPRINTF(ah, ATH_DBG_ANI,
-		"Getting spur idx %d is2Ghz. %d val %x\n",
-		i, is2GHz, ah->config.spurchans[i][is2GHz]);
+	ath_print(common, ATH_DBG_ANI,
+		  "Getting spur idx %d is2Ghz. %d val %x\n",
+		  i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
 	case SPUR_DISABLE:
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		DPRINTF(ah, ATH_DBG_ANI,
-			"Getting spur val from new loc. %d\n", spur_val);
+		ath_print(common, ATH_DBG_ANI,
+			  "Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
 		spur_val = EEP_DEF_SPURCHAN;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0fe8644..cd98719 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -94,9 +94,9 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 		udelay(AH_TIME_QUANTUM);
 	}
 
-	DPRINTF(ah, ATH_DBG_ANY,
-		"timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
-		timeout, reg, REG_READ(ah, reg), mask, val);
+	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY,
+		  "timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
+		  timeout, reg, REG_READ(ah, reg), mask, val);
 
 	return false;
 }
@@ -178,9 +178,9 @@ u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 		}
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unknown phy %u (rate ix %u)\n",
-			rates->info[rateix].phy, rateix);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Unknown phy %u (rate ix %u)\n",
+			  rates->info[rateix].phy, rateix);
 		txTime = 0;
 		break;
 	}
@@ -285,6 +285,7 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 
 static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
 	u32 regHold[2];
 	u32 patternData[4] = { 0x55555555,
@@ -303,10 +304,11 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (rdData != wrData) {
-				DPRINTF(ah, ATH_DBG_FATAL,
-					"address test failed "
-					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
-					addr, wrData, rdData);
+				ath_print(common, ATH_DBG_FATAL,
+					  "address test failed "
+					  "addr: 0x%08x - wr:0x%08x != "
+					  "rd:0x%08x\n",
+					  addr, wrData, rdData);
 				return false;
 			}
 		}
@@ -315,10 +317,11 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 			REG_WRITE(ah, addr, wrData);
 			rdData = REG_READ(ah, addr);
 			if (wrData != rdData) {
-				DPRINTF(ah, ATH_DBG_FATAL,
-					"address test failed "
-					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
-					addr, wrData, rdData);
+				ath_print(common, ATH_DBG_FATAL,
+					  "address test failed "
+					  "addr: 0x%08x - wr:0x%08x != "
+					  "rd:0x%08x\n",
+					  addr, wrData, rdData);
 				return false;
 			}
 		}
@@ -440,8 +443,8 @@ static int ath9k_hw_rfattach(struct ath_hw *ah)
 
 	rfStatus = ath9k_hw_init_rf(ah, &ecode);
 	if (!rfStatus) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"RF setup failed, status: %u\n", ecode);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "RF setup failed, status: %u\n", ecode);
 		return ecode;
 	}
 
@@ -465,9 +468,9 @@ static int ath9k_hw_rf_claim(struct ath_hw *ah)
 	case AR_RAD2122_SREV_MAJOR:
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Radio Chip Rev 0x%02X not supported\n",
-			val & AR_RADIO_SREV_MAJOR);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Radio Chip Rev 0x%02X not supported\n",
+			  val & AR_RADIO_SREV_MAJOR);
 		return -EOPNOTSUPP;
 	}
 
@@ -559,8 +562,10 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	if (ecode != 0)
 		return ecode;
 
-	DPRINTF(ah, ATH_DBG_CONFIG, "Eeprom VER: %d, REV: %d\n",
-		ah->eep_ops->get_eeprom_ver(ah), ah->eep_ops->get_eeprom_rev(ah));
+	ath_print(ath9k_hw_common(ah), ATH_DBG_CONFIG,
+		  "Eeprom VER: %d, REV: %d\n",
+		  ah->eep_ops->get_eeprom_ver(ah),
+		  ah->eep_ops->get_eeprom_rev(ah));
 
 	ecode = ath9k_hw_rfattach(ah);
 	if (ecode != 0)
@@ -874,6 +879,7 @@ static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
 
 int ath9k_hw_init(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
 	if (!ath9k_hw_devid_supported(ah->hw_version.devid))
@@ -883,12 +889,13 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_config(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		DPRINTF(ah, ATH_DBG_FATAL, "Couldn't reset chip\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Couldn't reset chip\n");
 		return -EIO;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		DPRINTF(ah, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
+		ath_print(common, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
 		return -EIO;
 	}
 
@@ -903,14 +910,14 @@ int ath9k_hw_init(struct ath_hw *ah)
 		}
 	}
 
-	DPRINTF(ah, ATH_DBG_RESET, "serialize_regmode is %d\n",
+	ath_print(common, ATH_DBG_RESET, "serialize_regmode is %d\n",
 		ah->config.serialize_regmode);
 
 	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Mac Chip Rev 0x%02x.%x is not supported by "
-			"this driver\n", ah->hw_version.macVersion,
-			ah->hw_version.macRev);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Mac Chip Rev 0x%02x.%x is not supported by "
+			  "this driver\n", ah->hw_version.macVersion,
+			  ah->hw_version.macRev);
 		return -EOPNOTSUPP;
 	}
 
@@ -948,8 +955,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Failed to initialize MAC address\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Failed to initialize MAC address\n");
 		return r;
 	}
 
@@ -1133,7 +1140,8 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
 {
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
-		DPRINTF(ah, ATH_DBG_RESET, "bad ack timeout %u\n", us);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "bad ack timeout %u\n", us);
 		ah->acktimeout = (u32) -1;
 		return false;
 	} else {
@@ -1147,7 +1155,8 @@ static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
 static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 {
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
-		DPRINTF(ah, ATH_DBG_RESET, "bad cts timeout %u\n", us);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "bad cts timeout %u\n", us);
 		ah->ctstimeout = (u32) -1;
 		return false;
 	} else {
@@ -1161,8 +1170,8 @@ static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 {
 	if (tu > 0xFFFF) {
-		DPRINTF(ah, ATH_DBG_XMIT,
-			"bad global tx timeout %u\n", tu);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_XMIT,
+			  "bad global tx timeout %u\n", tu);
 		ah->globaltxtimeout = (u32) -1;
 		return false;
 	} else {
@@ -1174,8 +1183,8 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 
 static void ath9k_hw_init_user_settings(struct ath_hw *ah)
 {
-	DPRINTF(ah, ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
-		ah->misc_mode);
+	ath_print(ath9k_hw_common(ah), ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
+		  ah->misc_mode);
 
 	if (ah->misc_mode != 0)
 		REG_WRITE(ah, AR_PCU_MISC,
@@ -1258,28 +1267,29 @@ static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
 			      u32 reg, u32 value)
 {
 	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	switch (ah->hw_version.devid) {
 	case AR9280_DEVID_PCI:
 		if (reg == 0x7894) {
-			DPRINTF(ah, ATH_DBG_EEPROM,
+			ath_print(common, ATH_DBG_EEPROM,
 				"ini VAL: %x  EEPROM: %x\n", value,
 				(pBase->version & 0xff));
 
 			if ((pBase->version & 0xff) > 0x0a) {
-				DPRINTF(ah, ATH_DBG_EEPROM,
-					"PWDCLKIND: %d\n",
-					pBase->pwdclkind);
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PWDCLKIND: %d\n",
+					  pBase->pwdclkind);
 				value &= ~AR_AN_TOP2_PWDCLKIND;
 				value |= AR_AN_TOP2_PWDCLKIND &
 					(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
 			} else {
-				DPRINTF(ah, ATH_DBG_EEPROM,
-					"PWDCLKIND Earlier Rev\n");
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PWDCLKIND Earlier Rev\n");
 			}
 
-			DPRINTF(ah, ATH_DBG_EEPROM,
-				"final ini VAL: %x\n", value);
+			ath_print(common, ATH_DBG_EEPROM,
+				  "final ini VAL: %x\n", value);
 		}
 		break;
 	}
@@ -1451,8 +1461,8 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 				 (u32) regulatory->power_limit));
 
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"ar5416SetRfRegs failed\n");
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "ar5416SetRfRegs failed\n");
 		return -EIO;
 	}
 
@@ -1657,8 +1667,8 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 
 	REG_WRITE(ah, AR_RTC_RC, 0);
 	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah, ATH_DBG_RESET,
-			"RTC stuck in MAC reset\n");
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "RTC stuck in MAC reset\n");
 		return false;
 	}
 
@@ -1694,7 +1704,8 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 			   AR_RTC_STATUS_M,
 			   AR_RTC_STATUS_ON,
 			   AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah, ATH_DBG_RESET, "RTC not waking up\n");
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "RTC not waking up\n");
 		return false;
 	}
 
@@ -1774,13 +1785,15 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 				    enum ath9k_ht_macmode macmode)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *channel = chan->chan;
 	u32 synthDelay, qnum;
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
-			DPRINTF(ah, ATH_DBG_QUEUE,
-				"Transmit frames pending on queue %d\n", qnum);
+			ath_print(common, ATH_DBG_QUEUE,
+				  "Transmit frames pending on "
+				  "queue %d\n", qnum);
 			return false;
 		}
 	}
@@ -1788,8 +1801,8 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
 	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
 			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Could not kill baseband RX\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Could not kill baseband RX\n");
 		return false;
 	}
 
@@ -1799,8 +1812,8 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		ath9k_hw_ar9280_set_channel(ah, chan);
 	} else {
 		if (!(ath9k_hw_set_channel(ah, chan))) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Failed to set channel\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "Failed to set channel\n");
 			return false;
 		}
 	}
@@ -2356,7 +2369,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	if (!ath9k_hw_chip_reset(ah, chan)) {
-		DPRINTF(ah, ATH_DBG_FATAL, "Chip reset failed\n");
+		ath_print(common, ATH_DBG_FATAL, "Chip reset failed\n");
 		return -EINVAL;
 	}
 
@@ -2507,13 +2520,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		u32 mask;
 		mask = REG_READ(ah, AR_CFG);
 		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
-			DPRINTF(ah, ATH_DBG_RESET,
+			ath_print(common, ATH_DBG_RESET,
 				"CFG Byte Swap Set 0x%x\n", mask);
 		} else {
 			mask =
 				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
 			REG_WRITE(ah, AR_CFG, mask);
-			DPRINTF(ah, ATH_DBG_RESET,
+			ath_print(common, ATH_DBG_RESET,
 				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
 		}
 	} else {
@@ -2541,8 +2554,8 @@ bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 	u32 keyType;
 
 	if (entry >= ah->caps.keycache_size) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"keychache entry %u out of range\n", entry);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "keychache entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2575,8 +2588,8 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 	u32 macHi, macLo;
 
 	if (entry >= ah->caps.keycache_size) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"keychache entry %u out of range\n", entry);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "keychache entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2603,12 +2616,13 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const u8 *mac)
 {
 	const struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 key0, key1, key2, key3, key4;
 	u32 keyType;
 
 	if (entry >= pCap->keycache_size) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"keycache entry %u out of range\n", entry);
+		ath_print(common, ATH_DBG_FATAL,
+			  "keycache entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2618,9 +2632,9 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		break;
 	case ATH9K_CIPHER_AES_CCM:
 		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
-			DPRINTF(ah, ATH_DBG_ANY,
-				"AES-CCM not supported by mac rev 0x%x\n",
-				ah->hw_version.macRev);
+			ath_print(common, ATH_DBG_ANY,
+				  "AES-CCM not supported by mac rev 0x%x\n",
+				  ah->hw_version.macRev);
 			return false;
 		}
 		keyType = AR_KEYTABLE_TYPE_CCM;
@@ -2629,15 +2643,15 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_TKIP;
 		if (ATH9K_IS_MIC_ENABLED(ah)
 		    && entry + 64 >= pCap->keycache_size) {
-			DPRINTF(ah, ATH_DBG_ANY,
-				"entry %u inappropriate for TKIP\n", entry);
+			ath_print(common, ATH_DBG_ANY,
+				  "entry %u inappropriate for TKIP\n", entry);
 			return false;
 		}
 		break;
 	case ATH9K_CIPHER_WEP:
 		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
-			DPRINTF(ah, ATH_DBG_ANY,
-				"WEP key length %u too small\n", k->kv_len);
+			ath_print(common, ATH_DBG_ANY,
+				  "WEP key length %u too small\n", k->kv_len);
 			return false;
 		}
 		if (k->kv_len <= WLAN_KEY_LEN_WEP40)
@@ -2651,8 +2665,8 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_CLR;
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"cipher %u not supported\n", k->kv_type);
+		ath_print(common, ATH_DBG_FATAL,
+			  "cipher %u not supported\n", k->kv_type);
 		return false;
 	}
 
@@ -2869,8 +2883,9 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 				    AR_RTC_FORCE_WAKE_EN);
 		}
 		if (i == 0) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Failed to wakeup in %uus\n", POWER_UP_TIME / 20);
+			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+				  "Failed to wakeup in %uus\n",
+				  POWER_UP_TIME / 20);
 			return false;
 		}
 	}
@@ -2882,6 +2897,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	int status = true, setChip = true;
 	static const char *modes[] = {
 		"AWAKE",
@@ -2893,8 +2909,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	if (ah->power_mode == mode)
 		return status;
 
-	DPRINTF(ah, ATH_DBG_RESET, "%s -> %s\n",
-		modes[ah->power_mode], modes[mode]);
+	ath_print(common, ATH_DBG_RESET, "%s -> %s\n",
+		  modes[ah->power_mode], modes[mode]);
 
 	switch (mode) {
 	case ATH9K_PM_AWAKE:
@@ -2908,8 +2924,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 		ath9k_set_power_network_sleep(ah, setChip);
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unknown power mode %u\n", mode);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unknown power mode %u\n", mode);
 		return false;
 	}
 	ah->power_mode = mode;
@@ -3049,6 +3065,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	u32 sync_cause = 0;
 	bool fatal_int = false;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!AR_SREV_9100(ah)) {
 		if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
@@ -3122,8 +3139,8 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 		}
 
 		if (isr & AR_ISR_RXORN) {
-			DPRINTF(ah, ATH_DBG_INTERRUPT,
-				"receive FIFO overrun interrupt\n");
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "receive FIFO overrun interrupt\n");
 		}
 
 		if (!AR_SREV_9100(ah)) {
@@ -3165,25 +3182,25 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 
 		if (fatal_int) {
 			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
-				DPRINTF(ah, ATH_DBG_ANY,
-					"received PCI FATAL interrupt\n");
+				ath_print(common, ATH_DBG_ANY,
+					  "received PCI FATAL interrupt\n");
 			}
 			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
-				DPRINTF(ah, ATH_DBG_ANY,
-					"received PCI PERR interrupt\n");
+				ath_print(common, ATH_DBG_ANY,
+					  "received PCI PERR interrupt\n");
 			}
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
-			DPRINTF(ah, ATH_DBG_INTERRUPT,
-				"AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
-			DPRINTF(ah, ATH_DBG_INTERRUPT,
-				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "AR_INTR_SYNC_LOCAL_TIMEOUT\n");
 		}
 
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
@@ -3198,11 +3215,12 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	u32 omask = ah->mask_reg;
 	u32 mask, mask2;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
 
-	DPRINTF(ah, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
+	ath_print(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
 	if (omask & ATH9K_INT_GLOBAL) {
-		DPRINTF(ah, ATH_DBG_INTERRUPT, "disable IER\n");
+		ath_print(common, ATH_DBG_INTERRUPT, "disable IER\n");
 		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
 		(void) REG_READ(ah, AR_IER);
 		if (!AR_SREV_9100(ah)) {
@@ -3259,7 +3277,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			mask2 |= AR_IMR_S2_CST;
 	}
 
-	DPRINTF(ah, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
+	ath_print(common, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
 	REG_WRITE(ah, AR_IMR, mask);
 	mask = REG_READ(ah, AR_IMR_S2) & ~(AR_IMR_S2_TIM |
 					   AR_IMR_S2_DTIM |
@@ -3279,7 +3297,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	}
 
 	if (ints & ATH9K_INT_GLOBAL) {
-		DPRINTF(ah, ATH_DBG_INTERRUPT, "enable IER\n");
+		ath_print(common, ATH_DBG_INTERRUPT, "enable IER\n");
 		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
 		if (!AR_SREV_9100(ah)) {
 			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
@@ -3292,8 +3310,8 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			REG_WRITE(ah, AR_INTR_SYNC_MASK,
 				  AR_INTR_SYNC_DEFAULT);
 		}
-		DPRINTF(ah, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
-			 REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
+		ath_print(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
+			  REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
 	}
 
 	return omask;
@@ -3340,9 +3358,9 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_BEACON,
-			"%s: unsupported opmode: %d\n",
-			__func__, ah->opmode);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_BEACON,
+			  "%s: unsupported opmode: %d\n",
+			  __func__, ah->opmode);
 		return;
 		break;
 	}
@@ -3366,6 +3384,7 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 {
 	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
 
@@ -3391,10 +3410,10 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	else
 		nextTbtt = bs->bs_nexttbtt;
 
-	DPRINTF(ah, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
-	DPRINTF(ah, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
-	DPRINTF(ah, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
-	DPRINTF(ah, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
+	ath_print(common, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
+	ath_print(common, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
+	ath_print(common, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
+	ath_print(common, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
 
 	REG_WRITE(ah, AR_NEXT_DTIM,
 		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
@@ -3431,6 +3450,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	u16 capField = 0, eeval;
@@ -3452,8 +3472,8 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			regulatory->current_rd += 5;
 		else if (regulatory->current_rd == 0x41)
 			regulatory->current_rd = 0x43;
-		DPRINTF(ah, ATH_DBG_REGULATORY,
-			"regdomain mapped to 0x%x\n", regulatory->current_rd);
+		ath_print(common, ATH_DBG_REGULATORY,
+			  "regdomain mapped to 0x%x\n", regulatory->current_rd);
 	}
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
@@ -3979,8 +3999,8 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 {
 	if (!ath9k_hw_wait(ah, AR_SLP32_MODE, AR_SLP32_TSF_WRITE_STATUS, 0,
 			   AH_TSF_WRITE_TIMEOUT))
-		DPRINTF(ah, ATH_DBG_RESET,
-			"AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
 
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
 }
@@ -3996,7 +4016,8 @@ void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
 	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
-		DPRINTF(ah, ATH_DBG_RESET, "bad slot time %u\n", us);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "bad slot time %u\n", us);
 		ah->slottime = (u32) -1;
 		return false;
 	} else {
@@ -4081,8 +4102,9 @@ struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 	timer = kzalloc(sizeof(struct ath_gen_timer), GFP_KERNEL);
 
 	if (timer == NULL) {
-		printk(KERN_DEBUG "Failed to allocate memory"
-		       "for hw timer[%d]\n", timer_index);
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Failed to allocate memory"
+			  "for hw timer[%d]\n", timer_index);
 		return NULL;
 	}
 
@@ -4110,8 +4132,9 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 
 	tsf = ath9k_hw_gettsf32(ah);
 
-	DPRINTF(ah, ATH_DBG_HWTIMER, "curent tsf %x period %x"
-		"timer_next %x\n", tsf, timer_period, timer_next);
+	ath_print(ath9k_hw_common(ah), ATH_DBG_HWTIMER,
+		  "curent tsf %x period %x"
+		  "timer_next %x\n", tsf, timer_period, timer_next);
 
 	/*
 	 * Pull timer_next forward if the current TSF already passed it
@@ -4173,6 +4196,7 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 	struct ath_gen_timer *timer;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 trigger_mask, thresh_mask, index;
 
 	/* get hardware generic timer interrupt status */
@@ -4187,8 +4211,8 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &thresh_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		DPRINTF(ah, ATH_DBG_HWTIMER,
-			"TSF overflow for Gen timer %d\n", index);
+		ath_print(common, ATH_DBG_HWTIMER,
+			  "TSF overflow for Gen timer %d\n", index);
 		timer->overflow(timer->arg);
 	}
 
@@ -4196,8 +4220,8 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &trigger_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		DPRINTF(ah, ATH_DBG_HWTIMER,
-			"Gen timer[%d] trigger\n", index);
+		ath_print(common, ATH_DBG_HWTIMER,
+			  "Gen timer[%d] trigger\n", index);
 		timer->trigger(timer->arg);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3120c21..0fe814f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -30,6 +30,7 @@
 #include "btcoex.h"
 
 #include "../regd.h"
+#include "../debug.h"
 
 #define ATHEROS_VENDOR_ID	0x168c
 #define AR5416_DEVID_PCI	0x0023
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index b4d2f20..926f201 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -15,15 +15,16 @@
  */
 
 #include "ath9k.h"
+#include "hw.h"
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
 {
-	DPRINTF(ah, ATH_DBG_INTERRUPT,
-		"tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
-		ah->txok_interrupt_mask, ah->txerr_interrupt_mask,
-		ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
-		ah->txurn_interrupt_mask);
+	ath_print(ath9k_hw_common(ah), ATH_DBG_INTERRUPT,
+		  "tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
+		  ah->txok_interrupt_mask, ah->txerr_interrupt_mask,
+		  ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
+		  ah->txurn_interrupt_mask);
 
 	REG_WRITE(ah, AR_IMR_S0,
 		  SM(ah->txok_interrupt_mask, AR_IMR_S0_QCU_TXOK)
@@ -47,7 +48,8 @@ void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
-	DPRINTF(ah, ATH_DBG_QUEUE, "Enable TXE on queue: %u\n", q);
+	ath_print(ath9k_hw_common(ah), ATH_DBG_QUEUE,
+		  "Enable TXE on queue: %u\n", q);
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 }
 
@@ -98,22 +100,22 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 {
 #define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
 #define ATH9K_TIME_QUANTUM		100     /* usec */
-
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 	u32 tsfLow, j, wait;
 	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Stopping TX DMA, "
-			"invalid queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Stopping TX DMA, "
+			  "invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Stopping TX DMA, "
-			"inactive queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Stopping TX DMA, "
+			  "inactive queue: %u\n", q);
 		return false;
 	}
 
@@ -126,9 +128,9 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 	}
 
 	if (ath9k_hw_numtxpending(ah, q)) {
-		DPRINTF(ah, ATH_DBG_QUEUE,
-			"%s: Num of pending TX Frames %d on Q %d\n",
-			__func__, ath9k_hw_numtxpending(ah, q), q);
+		ath_print(common, ATH_DBG_QUEUE,
+			  "%s: Num of pending TX Frames %d on Q %d\n",
+			  __func__, ath9k_hw_numtxpending(ah, q), q);
 
 		for (j = 0; j < 2; j++) {
 			tsfLow = REG_READ(ah, AR_TSF_L32);
@@ -142,9 +144,9 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 			if ((REG_READ(ah, AR_TSF_L32) >> 10) == (tsfLow >> 10))
 				break;
 
-			DPRINTF(ah, ATH_DBG_QUEUE,
-				"TSF has moved while trying to set "
-				"quiet time TSF: 0x%08x\n", tsfLow);
+			ath_print(common, ATH_DBG_QUEUE,
+				  "TSF has moved while trying to set "
+				  "quiet time TSF: 0x%08x\n", tsfLow);
 		}
 
 		REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
@@ -155,9 +157,9 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 		wait = wait_time;
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
-				DPRINTF(ah, ATH_DBG_QUEUE,
-					"Failed to stop TX DMA in 100 "
-					"msec after killing last frame\n");
+				ath_print(common, ATH_DBG_QUEUE,
+					  "Failed to stop TX DMA in 100 "
+					  "msec after killing last frame\n");
 				break;
 			}
 			udelay(ATH9K_TIME_QUANTUM);
@@ -445,23 +447,24 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo)
 {
 	u32 cw;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Set TXQ properties, "
-			"invalid queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Set TXQ properties, "
+			  "invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Set TXQ properties, "
-			"inactive queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Set TXQ properties, "
+			  "inactive queue: %u\n", q);
 		return false;
 	}
 
-	DPRINTF(ah, ATH_DBG_QUEUE, "Set queue properties for: %u\n", q);
+	ath_print(common, ATH_DBG_QUEUE, "Set queue properties for: %u\n", q);
 
 	qi->tqi_ver = qinfo->tqi_ver;
 	qi->tqi_subtype = qinfo->tqi_subtype;
@@ -514,19 +517,20 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 			    struct ath9k_tx_queue_info *qinfo)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Get TXQ properties, "
-			"invalid queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Get TXQ properties, "
+			  "invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Get TXQ properties, "
-			"inactive queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Get TXQ properties, "
+			  "inactive queue: %u\n", q);
 		return false;
 	}
 
@@ -551,6 +555,7 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			  const struct ath9k_tx_queue_info *qinfo)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info *qi;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int q;
@@ -574,23 +579,23 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
 		if (q == pCap->total_queues) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"No available TX queue\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "No available TX queue\n");
 			return -1;
 		}
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_FATAL, "Invalid TX queue type: %u\n",
-			type);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Invalid TX queue type: %u\n", type);
 		return -1;
 	}
 
-	DPRINTF(ah, ATH_DBG_QUEUE, "Setup TX queue: %u\n", q);
+	ath_print(common, ATH_DBG_QUEUE, "Setup TX queue: %u\n", q);
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"TX queue: %u already active\n", q);
+		ath_print(common, ATH_DBG_FATAL,
+			  "TX queue: %u already active\n", q);
 		return -1;
 	}
 	memset(qi, 0, sizeof(struct ath9k_tx_queue_info));
@@ -617,21 +622,22 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Release TXQ, "
-			"invalid queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Release TXQ, "
+			  "invalid queue: %u\n", q);
 		return false;
 	}
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Release TXQ, "
-			"inactive queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Release TXQ, "
+			  "inactive queue: %u\n", q);
 		return false;
 	}
 
-	DPRINTF(ah, ATH_DBG_QUEUE, "Release TX queue: %u\n", q);
+	ath_print(common, ATH_DBG_QUEUE, "Release TX queue: %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
 	ah->txok_interrupt_mask &= ~(1 << q);
@@ -647,24 +653,25 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ath9k_tx_queue_info *qi;
 	u32 cwMin, chanCwMin, value;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Reset TXQ, "
-			"invalid queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Reset TXQ, "
+			  "invalid queue: %u\n", q);
 		return false;
 	}
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah, ATH_DBG_QUEUE, "Reset TXQ, "
-			"inactive queue: %u\n", q);
+		ath_print(common, ATH_DBG_QUEUE, "Reset TXQ, "
+			  "inactive queue: %u\n", q);
 		return true;
 	}
 
-	DPRINTF(ah, ATH_DBG_QUEUE, "Reset TX queue: %u\n", q);
+	ath_print(common, ATH_DBG_QUEUE, "Reset TX queue: %u\n", q);
 
 	if (qi->tqi_cwmin == ATH9K_TXQ_USEDEFAULT) {
 		if (chan && IS_CHAN_B(chan))
@@ -911,8 +918,9 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 				     AR_DIAG_RX_ABORT));
 
 			reg = REG_READ(ah, AR_OBS_BUS_1);
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"RX failed to go idle in 10 ms RXSM=0x%x\n", reg);
+			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+				  "RX failed to go idle in 10 ms RXSM=0x%x\n",
+				  reg);
 
 			return false;
 		}
@@ -954,7 +962,7 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 {
 #define AH_RX_STOP_DMA_TIMEOUT 10000   /* usec */
 #define AH_RX_TIME_QUANTUM     100     /* usec */
-
+	struct ath_common *common = ath9k_hw_common(ah);
 	int i;
 
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
@@ -967,12 +975,12 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 	}
 
 	if (i == 0) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"DMA failed to stop in %d ms "
-			"AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
-			AH_RX_STOP_DMA_TIMEOUT / 1000,
-			REG_READ(ah, AR_CR),
-			REG_READ(ah, AR_DIAG_SW));
+		ath_print(common, ATH_DBG_FATAL,
+			  "DMA failed to stop in %d ms "
+			  "AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
+			  AH_RX_STOP_DMA_TIMEOUT / 1000,
+			  REG_READ(ah, AR_CR),
+			  REG_READ(ah, AR_DIAG_SW));
 		return false;
 	} else {
 		return true;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5cd4b78..214ce65 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -225,8 +225,9 @@ static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 		}
 		sband->n_bitrates++;
 
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Rate: %2dMbps, ratecode: %2d\n",
-			rate[i].bitrate / 10, rate[i].hw_value);
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
+			  "Rate: %2dMbps, ratecode: %2d\n",
+			  rate[i].bitrate / 10, rate[i].hw_value);
 	}
 }
 
@@ -297,6 +298,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	bool fastcc = true, stopped;
 	struct ieee80211_channel *channel = hw->conf.channel;
 	int r;
@@ -326,19 +328,19 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
 		fastcc = false;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-		"(%u MHz) -> (%u MHz), chanwidth: %d\n",
-		sc->sc_ah->curchan->channel,
-		channel->center_freq, sc->tx_chan_width);
+	ath_print(common, ATH_DBG_CONFIG,
+		  "(%u MHz) -> (%u MHz), chanwidth: %d\n",
+		  sc->sc_ah->curchan->channel,
+		  channel->center_freq, sc->tx_chan_width);
 
 	spin_lock_bh(&sc->sc_resetlock);
 
 	r = ath9k_hw_reset(ah, hchan, fastcc);
 	if (r) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Unable to reset channel (%u Mhz) "
-			"reset status %d\n",
-			channel->center_freq, r);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to reset channel (%u Mhz) "
+			  "reset status %d\n",
+			  channel->center_freq, r);
 		spin_unlock_bh(&sc->sc_resetlock);
 		goto ps_restore;
 	}
@@ -347,8 +349,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	sc->sc_flags &= ~SC_OP_FULL_RESET;
 
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Unable to restart recv logic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to restart recv logic\n");
 		r = -EIO;
 		goto ps_restore;
 	}
@@ -373,6 +375,7 @@ static void ath_ani_calibrate(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	bool longcal = false;
 	bool shortcal = false;
 	bool aniflag = false;
@@ -399,7 +402,7 @@ static void ath_ani_calibrate(unsigned long data)
 	/* Long calibration runs independently of short calibration. */
 	if ((timestamp - sc->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
 		longcal = true;
-		DPRINTF(sc->sc_ah, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
+		ath_print(common, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
 		sc->ani.longcal_timer = timestamp;
 	}
 
@@ -407,7 +410,8 @@ static void ath_ani_calibrate(unsigned long data)
 	if (!sc->ani.caldone) {
 		if ((timestamp - sc->ani.shortcal_timer) >= short_cal_interval) {
 			shortcal = true;
-			DPRINTF(sc->sc_ah, ATH_DBG_ANI, "shortcal @%lu\n", jiffies);
+			ath_print(common, ATH_DBG_ANI,
+				  "shortcal @%lu\n", jiffies);
 			sc->ani.shortcal_timer = timestamp;
 			sc->ani.resetcal_timer = timestamp;
 		}
@@ -441,9 +445,11 @@ static void ath_ani_calibrate(unsigned long data)
 				sc->ani.noise_floor = ath9k_hw_getchan_noise(ah,
 								     ah->curchan);
 
-			DPRINTF(sc->sc_ah, ATH_DBG_ANI," calibrate chan %u/%x nf: %d\n",
-				ah->curchan->channel, ah->curchan->channelFlags,
-				sc->ani.noise_floor);
+			ath_print(common, ATH_DBG_ANI,
+				  " calibrate chan %u/%x nf: %d\n",
+				  ah->curchan->channel,
+				  ah->curchan->channelFlags,
+				  sc->ani.noise_floor);
 		}
 	}
 
@@ -496,8 +502,9 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 		sc->rx_chainmask = 1;
 	}
 
-	DPRINTF(ah, ATH_DBG_CONFIG, "tx chmask: %d, rx chmask: %d\n",
-		sc->tx_chainmask, sc->rx_chainmask);
+	ath_print(ath9k_hw_common(ah), ATH_DBG_CONFIG,
+		  "tx chmask: %d, rx chmask: %d\n",
+		  sc->tx_chainmask, sc->rx_chainmask);
 }
 
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
@@ -527,6 +534,7 @@ static void ath9k_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	u32 status = sc->intrstatus;
 
@@ -552,7 +560,8 @@ static void ath9k_tasklet(unsigned long data)
 		 * TSF sync does not look correct; remain awake to sync with
 		 * the next Beacon.
 		 */
-		DPRINTF(ah, ATH_DBG_PS, "TSFOOR - Sync with next Beacon\n");
+		ath_print(common, ATH_DBG_PS,
+			  "TSFOOR - Sync with next Beacon\n");
 		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
 	}
 
@@ -752,8 +761,8 @@ static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
 	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
 	if (!ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, NULL)) {
 		/* TX MIC entry failed. No need to proceed further */
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Setting TX MIC Key Failed\n");
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Setting TX MIC Key Failed\n");
 		return 0;
 	}
 
@@ -957,8 +966,9 @@ static void setup_ht_cap(struct ath_softc *sc,
 	rx_streams = !(sc->rx_chainmask & (sc->rx_chainmask - 1)) ? 1 : 2;
 
 	if (tx_streams != rx_streams) {
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "TX streams %d, RX streams: %d\n",
-			tx_streams, rx_streams);
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
+			  "TX streams %d, RX streams: %d\n",
+			  tx_streams, rx_streams);
 		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
 		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
 				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
@@ -979,8 +989,9 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (bss_conf->assoc) {
-		DPRINTF(ah, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
-			bss_conf->aid, common->curbssid);
+		ath_print(common, ATH_DBG_CONFIG,
+			  "Bss Info ASSOC %d, bssid: %pM\n",
+			   bss_conf->aid, common->curbssid);
 
 		/* New association, store aid */
 		common->curaid = bss_conf->aid;
@@ -1001,7 +1012,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		ath_start_ani(sc);
 	} else {
-		DPRINTF(ah, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
+		ath_print(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		common->curaid = 0;
 		/* Stop ANI */
 		del_timer_sync(&sc->ani.timer);
@@ -1094,8 +1105,8 @@ static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
 
 	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
 	if (ret)
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Failed to register led:%s", led->name);
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Failed to register led:%s", led->name);
 	else
 		led->registered = 1;
 	return ret;
@@ -1179,6 +1190,7 @@ fail:
 void ath_radio_enable(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *channel = sc->hw->conf.channel;
 	int r;
 
@@ -1191,17 +1203,17 @@ void ath_radio_enable(struct ath_softc *sc)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Unable to reset channel %u (%uMhz) ",
-			"reset status %d\n",
-			channel->center_freq, r);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to reset channel %u (%uMhz) ",
+			  "reset status %d\n",
+			  channel->center_freq, r);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath_update_txpow(sc);
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Unable to restart recv logic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to restart recv logic\n");
 		return;
 	}
 
@@ -1246,10 +1258,10 @@ void ath_radio_disable(struct ath_softc *sc)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Unable to reset channel %u (%uMhz) "
-			"reset status %d\n",
-			channel->center_freq, r);
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Unable to reset channel %u (%uMhz) "
+			  "reset status %d\n",
+			  channel->center_freq, r);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1371,8 +1383,8 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	if (time_after(jiffies, btcoex->bt_priority_time +
 			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
 		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
-			DPRINTF(sc->sc_ah, ATH_DBG_BTCOEX,
-				"BT priority traffic detected");
+			ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_BTCOEX,
+				  "BT priority traffic detected");
 			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
 		} else {
 			sc->sc_flags &= ~SC_OP_BT_PRIORITY_DETECTED;
@@ -1405,7 +1417,8 @@ static void ath9k_btcoex_bt_stomp(struct ath_softc *sc,
 					   AR_STOMP_NONE_WLAN_WGHT);
 		break;
 	default:
-		DPRINTF(ah, ATH_DBG_BTCOEX, "Invalid Stomptype\n");
+		ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+			  "Invalid Stomptype\n");
 		break;
 	}
 
@@ -1485,7 +1498,8 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	DPRINTF(ah, ATH_DBG_BTCOEX, "no stomp timer running \n");
+	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+		  "no stomp timer running \n");
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
@@ -1618,18 +1632,18 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 
 	r = ath9k_hw_init(ah);
 	if (r) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to initialize hardware; "
-			"initialization status: %d\n", r);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to initialize hardware; "
+			  "initialization status: %d\n", r);
 		goto bad;
 	}
 
 	/* Get the hardware key cache size. */
 	sc->keymax = ah->caps.keycache_size;
 	if (sc->keymax > ATH_KEYMAX) {
-		DPRINTF(ah, ATH_DBG_ANY,
-			"Warning, using only %u entries in %u key cache\n",
-			ATH_KEYMAX, sc->keymax);
+		ath_print(common, ATH_DBG_ANY,
+			  "Warning, using only %u entries in %u key cache\n",
+			  ATH_KEYMAX, sc->keymax);
 		sc->keymax = ATH_KEYMAX;
 	}
 
@@ -1657,15 +1671,15 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	 */
 	sc->beacon.beaconq = ath_beaconq_setup(ah);
 	if (sc->beacon.beaconq == -1) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to setup a beacon xmit queue\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup a beacon xmit queue\n");
 		r = -EIO;
 		goto bad2;
 	}
 	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 	if (sc->beacon.cabq == NULL) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to setup CAB xmit queue\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup CAB xmit queue\n");
 		r = -EIO;
 		goto bad2;
 	}
@@ -1679,27 +1693,27 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	/* Setup data queues */
 	/* NB: ensure BK queue is the lowest priority h/w queue */
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to setup xmit queue for BK traffic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup xmit queue for BK traffic\n");
 		r = -EIO;
 		goto bad2;
 	}
 
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to setup xmit queue for BE traffic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup xmit queue for BE traffic\n");
 		r = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to setup xmit queue for VI traffic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup xmit queue for VI traffic\n");
 		r = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to setup xmit queue for VO traffic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup xmit queue for VO traffic\n");
 		r = -EIO;
 		goto bad2;
 	}
@@ -1937,6 +1951,7 @@ error_attach:
 int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hw *hw = sc->hw;
 	int r;
 
@@ -1948,12 +1963,13 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
 	if (r)
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to reset hardware; reset status %d\n", r);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to reset hardware; reset status %d\n", r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
-		DPRINTF(ah, ATH_DBG_FATAL, "Unable to start recv logic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to start recv logic\n");
 
 	/*
 	 * We may be doing a reset in response to a request
@@ -1996,18 +2012,19 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
 #define ATH_DESC_4KB_BOUND_CHECK(_daddr) ((((_daddr) & 0xFFF) > 0xF7F) ? 1 : 0)
 #define ATH_DESC_4KB_BOUND_NUM_SKIPPED(_len) ((_len) / 4096)
-
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_desc *ds;
 	struct ath_buf *bf;
 	int i, bsize, error;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
-		name, nbuf, ndesc);
+	ath_print(common, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
+		  name, nbuf, ndesc);
 
 	INIT_LIST_HEAD(head);
 	/* ath_desc must be a multiple of DWORDs */
 	if ((sizeof(struct ath_desc) % 4) != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "ath_desc not DWORD aligned\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "ath_desc not DWORD aligned\n");
 		ASSERT((sizeof(struct ath_desc) % 4) == 0);
 		error = -ENOMEM;
 		goto fail;
@@ -2041,9 +2058,9 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		goto fail;
 	}
 	ds = dd->dd_desc;
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
-		name, ds, (u32) dd->dd_desc_len,
-		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
+	ath_print(common, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
+		  name, ds, (u32) dd->dd_desc_len,
+		  ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
 
 	/* allocate buffers */
 	bsize = sizeof(struct ath_buf) * nbuf;
@@ -2193,7 +2210,8 @@ static void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_hw *ah = sc->sc_ah;
 
-	DPRINTF(ah, ATH_DBG_BTCOEX, "Starting btcoex timers");
+	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+		  "Starting btcoex timers");
 
 	/* make sure duty cycle timer is also stopped when resuming */
 	if (btcoex->hw_timer_enabled)
@@ -2211,12 +2229,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath9k_channel *init_channel;
 	int r;
 
-	DPRINTF(ah, ATH_DBG_CONFIG, "Starting driver with "
-		"initial channel: %d MHz\n", curchan->center_freq);
+	ath_print(common, ATH_DBG_CONFIG,
+		  "Starting driver with initial channel: %d MHz\n",
+		  curchan->center_freq);
 
 	mutex_lock(&sc->mutex);
 
@@ -2260,10 +2280,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, init_channel, false);
 	if (r) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Unable to reset hardware; reset status %d "
-			"(freq %u MHz)\n", r,
-			curchan->center_freq);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to reset hardware; reset status %d "
+			  "(freq %u MHz)\n", r,
+			  curchan->center_freq);
 		spin_unlock_bh(&sc->sc_resetlock);
 		goto mutex_unlock;
 	}
@@ -2283,7 +2303,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * here except setup the interrupt mask.
 	 */
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(ah, ATH_DBG_FATAL, "Unable to start recv logic\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to start recv logic\n");
 		r = -EIO;
 		goto mutex_unlock;
 	}
@@ -2335,12 +2356,14 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_tx_control txctl;
 	int hdrlen, padsize;
 
 	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
-		printk(KERN_DEBUG "ath9k: %s: TX in unexpected wiphy state "
-		       "%d\n", wiphy_name(hw->wiphy), aphy->state);
+		ath_print(common, ATH_DBG_XMIT,
+			  "ath9k: %s: TX in unexpected wiphy state "
+			  "%d\n", wiphy_name(hw->wiphy), aphy->state);
 		goto exit;
 	}
 
@@ -2353,8 +2376,8 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		if (ieee80211_is_data(hdr->frame_control) &&
 		    !ieee80211_is_nullfunc(hdr->frame_control) &&
 		    !ieee80211_has_pm(hdr->frame_control)) {
-			DPRINTF(sc->sc_ah, ATH_DBG_PS, "Add PM=1 for a TX frame "
-				"while in PS mode\n");
+			ath_print(common, ATH_DBG_PS, "Add PM=1 for a TX frame "
+				  "while in PS mode\n");
 			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 		}
 	}
@@ -2369,11 +2392,12 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		ath9k_ps_wakeup(sc);
 		ath9k_hw_setrxabort(sc->sc_ah, 0);
 		if (ieee80211_is_pspoll(hdr->frame_control)) {
-			DPRINTF(sc->sc_ah, ATH_DBG_PS, "Sending PS-Poll to pick a "
-				"buffered frame\n");
+			ath_print(common, ATH_DBG_PS,
+				  "Sending PS-Poll to pick a buffered frame\n");
 			sc->sc_flags |= SC_OP_WAIT_FOR_PSPOLL_DATA;
 		} else {
-			DPRINTF(sc->sc_ah, ATH_DBG_PS, "Wake up to complete TX\n");
+			ath_print(common, ATH_DBG_PS,
+				  "Wake up to complete TX\n");
 			sc->sc_flags |= SC_OP_WAIT_FOR_TX_ACK;
 		}
 		/*
@@ -2415,10 +2439,10 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	if (!txctl.txq)
 		goto exit;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
+	ath_print(common, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "TX failed\n");
+		ath_print(common, ATH_DBG_XMIT, "TX failed\n");
 		goto exit;
 	}
 
@@ -2449,6 +2473,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	mutex_lock(&sc->mutex);
 
@@ -2463,7 +2488,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	}
 
 	if (sc->sc_flags & SC_OP_INVALID) {
-		DPRINTF(ah, ATH_DBG_ANY, "Device not present\n");
+		ath_print(common, ATH_DBG_ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
 	}
@@ -2501,7 +2526,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	mutex_unlock(&sc->mutex);
 
-	DPRINTF(ah, ATH_DBG_CONFIG, "Driver halt\n");
+	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -2509,6 +2534,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
 	int ret = 0;
@@ -2535,13 +2561,14 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		ic_opmode = conf->type;
 		break;
 	default:
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
+		ath_print(common, ATH_DBG_FATAL,
 			"Interface type %d not yet supported\n", conf->type);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Attach a VIF of type: %d\n", ic_opmode);
+	ath_print(common, ATH_DBG_CONFIG,
+		  "Attach a VIF of type: %d\n", ic_opmode);
 
 	/* Set the VIF opmode */
 	avp->av_opmode = ic_opmode;
@@ -2591,10 +2618,11 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 	int i;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Detach Interface\n");
+	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
 
 	mutex_lock(&sc->mutex);
 
@@ -2629,6 +2657,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ath_hw *ah = sc->sc_ah;
 	bool all_wiphys_idle = false, disable_radio = false;
@@ -2648,8 +2677,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 		else if (all_wiphys_idle) {
 			ath_radio_enable(sc);
-			DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-				"not-idle: enabling radio\n");
+			ath_print(common, ATH_DBG_CONFIG,
+				  "not-idle: enabling radio\n");
 		}
 	}
 
@@ -2702,8 +2731,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			goto skip_chan_change;
 		}
 
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
-			curchan->center_freq);
+		ath_print(common, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
+			  curchan->center_freq);
 
 		/* XXX: remove me eventualy */
 		ath9k_update_ichannel(sc, hw, &sc->sc_ah->channels[pos]);
@@ -2711,7 +2740,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_update_chainmask(sc, conf_is_ht(conf));
 
 		if (ath_set_channel(sc, hw, &sc->sc_ah->channels[pos]) < 0) {
-			DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "Unable to set channel\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
 		}
@@ -2722,7 +2752,7 @@ skip_chan_change:
 		sc->config.txpowlimit = 2 * conf->power_level;
 
 	if (disable_radio) {
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "idle: disabling radio\n");
+		ath_print(common, ATH_DBG_CONFIG, "idle: disabling radio\n");
 		ath_radio_disable(sc);
 	}
 
@@ -2759,7 +2789,8 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 	ath9k_ps_restore(sc);
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", rfilt);
+	ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
+		  "Set HW RX filter: 0x%x\n", rfilt);
 }
 
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
@@ -2787,6 +2818,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_tx_queue_info qi;
 	int ret = 0, qnum;
 
@@ -2803,15 +2835,15 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	qi.tqi_burstTime = params->txop;
 	qnum = ath_get_hal_qnum(queue, sc);
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-		"Configure tx [queue/halq] [%d/%d],  "
-		"aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
-		queue, qnum, params->aifs, params->cw_min,
-		params->cw_max, params->txop);
+	ath_print(common, ATH_DBG_CONFIG,
+		  "Configure tx [queue/halq] [%d/%d],  "
+		  "aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
+		  queue, qnum, params->aifs, params->cw_min,
+		  params->cw_max, params->txop);
 
 	ret = ath_txq_update(sc, qnum, &qi);
 	if (ret)
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "TXQ Update failed\n");
+		ath_print(common, ATH_DBG_FATAL, "TXQ Update failed\n");
 
 	mutex_unlock(&sc->mutex);
 
@@ -2826,6 +2858,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
 	if (modparam_nohwcrypt)
@@ -2833,7 +2866,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Set HW Key\n");
+	ath_print(common, ATH_DBG_CONFIG, "Set HW Key\n");
 
 	switch (cmd) {
 	case SET_KEY:
@@ -2908,9 +2941,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			/* Set aggregation protection mode parameters */
 			sc->config.ath_aggr_prot = 0;
 
-			DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-				"RX filter 0x%x bssid %pM aid 0x%x\n",
-				rfilt, common->curbssid, common->curaid);
+			ath_print(common, ATH_DBG_CONFIG,
+				  "RX filter 0x%x bssid %pM aid 0x%x\n",
+				  rfilt, common->curbssid, common->curaid);
 
 			/* need to reconfigure the beacon */
 			sc->sc_flags &= ~SC_OP_BEACONS ;
@@ -2957,8 +2990,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath_update_chainmask(sc, 0);
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
-			bss_conf->use_short_preamble);
+		ath_print(common, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
+			  bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			sc->sc_flags |= SC_OP_PREAMBLE_SHORT;
 		else
@@ -2966,8 +2999,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
-			bss_conf->use_cts_prot);
+		ath_print(common, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
+			  bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot &&
 		    hw->conf.channel->band != IEEE80211_BAND_5GHZ)
 			sc->sc_flags |= SC_OP_PROTECT_ENABLE;
@@ -2976,7 +3009,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
+		ath_print(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
 		ath9k_bss_assoc_info(sc, vif, bss_conf);
 	}
@@ -3061,7 +3094,8 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		ath_tx_aggr_resume(sc, sta, tid);
 		break;
 	default:
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "Unknown AMPDU action\n");
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Unknown AMPDU action\n");
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 1166f72..b263025 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -26,6 +26,7 @@ ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
 bool
 ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 channelSel = 0;
 	u32 bModeSynth = 0;
 	u32 aModeRefSel = 0;
@@ -46,8 +47,8 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			channelSel = ((freq - 704) * 2 - 3040) / 10;
 			bModeSynth = 1;
 		} else {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Invalid channel %u MHz\n", freq);
+			ath_print(common, ATH_DBG_FATAL,
+				  "Invalid channel %u MHz\n", freq);
 			return false;
 		}
 
@@ -79,8 +80,8 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		channelSel = ath9k_hw_reverse_bits((freq - 4800) / 5, 8);
 		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
 	} else {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"Invalid channel %u MHz\n", freq);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Invalid channel %u MHz\n", freq);
 		return false;
 	}
 
@@ -285,6 +286,8 @@ ath9k_hw_rf_free(struct ath_hw *ah)
 
 bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+
 	if (!AR_SREV_9280_10_OR_LATER(ah)) {
 		ah->analogBank0Data =
 		    kzalloc((sizeof(u32) *
@@ -315,8 +318,8 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 		    || ah->analogBank6Data == NULL
 		    || ah->analogBank6TPCData == NULL
 		    || ah->analogBank7Data == NULL) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Cannot allocate RF banks\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "Cannot allocate RF banks\n");
 			*status = -ENOMEM;
 			return false;
 		}
@@ -326,8 +329,8 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 			     ah->iniAddac.ia_rows *
 			     ah->iniAddac.ia_columns), GFP_KERNEL);
 		if (ah->addac5416_21 == NULL) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Cannot allocate addac5416_21\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "Cannot allocate addac5416_21\n");
 			*status = -ENOMEM;
 			return false;
 		}
@@ -336,8 +339,8 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 		    kzalloc((sizeof(u32) *
 			     ah->iniBank6.ia_rows), GFP_KERNEL);
 		if (ah->bank6Temp == NULL) {
-			DPRINTF(ah, ATH_DBG_FATAL,
-				"Cannot allocate bank6Temp\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "Cannot allocate bank6Temp\n");
 			*status = -ENOMEM;
 			return false;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index cafe1ec..7346649 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1160,6 +1160,7 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 					     bool is_cw_40)
 {
 	int mode = 0;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	switch(band) {
 	case IEEE80211_BAND_2GHZ:
@@ -1177,14 +1178,14 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 			mode = ATH9K_MODE_11NA_HT40PLUS;
 		break;
 	default:
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Invalid band\n");
+		ath_print(common, ATH_DBG_CONFIG, "Invalid band\n");
 		return NULL;
 	}
 
 	BUG_ON(mode >= ATH9K_MODE_MAX);
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-		"Choosing rate table for mode: %d\n", mode);
+	ath_print(common, ATH_DBG_CONFIG,
+		  "Choosing rate table for mode: %d\n", mode);
 	return sc->hw_rate_table[mode];
 }
 
@@ -1195,12 +1196,13 @@ static void ath_rc_init(struct ath_softc *sc,
 			const struct ath_rate_table *rate_table)
 {
 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u8 *ht_mcs = (u8 *)&ath_rc_priv->neg_ht_rates;
 	u8 i, j, k, hi = 0, hthi = 0;
 
 	if (!rate_table) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Rate table not initialized\n");
+		ath_print(common, ATH_DBG_FATAL,
+			  "Rate table not initialized\n");
 		return;
 	}
 
@@ -1263,9 +1265,9 @@ static void ath_rc_init(struct ath_softc *sc,
 	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
 	sc->cur_rate_table = rate_table;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-		"RC Initialized with capabilities: 0x%x\n",
-		ath_rc_priv->ht_cap);
+	ath_print(common, ATH_DBG_CONFIG,
+		  "RC Initialized with capabilities: 0x%x\n",
+		  ath_rc_priv->ht_cap);
 }
 
 static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -1441,9 +1443,9 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 						   oper_cw40, oper_sgi40);
 			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 
-			DPRINTF(sc->sc_ah, ATH_DBG_CONFIG,
-				"Operating HT Bandwidth changed to: %d\n",
-				sc->hw->conf.channel_type);
+			ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
+				  "Operating HT Bandwidth changed to: %d\n",
+				  sc->hw->conf.channel_type);
 		}
 	}
 }
@@ -1466,8 +1468,8 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 
 	rate_priv = kzalloc(sizeof(struct ath_rate_priv), gfp);
 	if (!rate_priv) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Unable to allocate private rc structure\n");
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Unable to allocate private rc structure\n");
 		return NULL;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fb635a0..6caef1b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -309,16 +309,16 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
 				 min(common->cachelsz, (u16)64));
 
-	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-		common->cachelsz, sc->rx.bufsize);
+	ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
+		  common->cachelsz, sc->rx.bufsize);
 
 	/* Initialize rx descriptors */
 
 	error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
 				  "rx", nbufs, 1);
 	if (error != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"failed to allocate rx descriptors: %d\n", error);
+		ath_print(common, ATH_DBG_FATAL,
+			  "failed to allocate rx descriptors: %d\n", error);
 		goto err;
 	}
 
@@ -337,8 +337,8 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 					       bf->bf_buf_addr))) {
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
-			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-				"dma_mapping_error() on RX init\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "dma_mapping_error() on RX init\n");
 			error = -ENOMEM;
 			goto err;
 		}
@@ -543,8 +543,9 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 
 	if (sc->sc_flags & SC_OP_BEACON_SYNC) {
 		sc->sc_flags &= ~SC_OP_BEACON_SYNC;
-		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Reconfigure Beacon timers based on "
-			"timestamp from the AP\n");
+		ath_print(common, ATH_DBG_PS,
+			  "Reconfigure Beacon timers based on "
+			  "timestamp from the AP\n");
 		ath_beacon_config(sc, NULL);
 	}
 
@@ -556,8 +557,8 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 * a backup trigger for returning into NETWORK SLEEP state,
 		 * so we are waiting for it as well.
 		 */
-		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Received DTIM beacon indicating "
-			"buffered broadcast/multicast frame(s)\n");
+		ath_print(common, ATH_DBG_PS, "Received DTIM beacon indicating "
+			  "buffered broadcast/multicast frame(s)\n");
 		sc->sc_flags |= SC_OP_WAIT_FOR_CAB | SC_OP_WAIT_FOR_BEACON;
 		return;
 	}
@@ -569,13 +570,15 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 * been delivered.
 		 */
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
-		DPRINTF(sc->sc_ah, ATH_DBG_PS, "PS wait for CAB frames timed out\n");
+		ath_print(common, ATH_DBG_PS,
+			  "PS wait for CAB frames timed out\n");
 	}
 }
 
 static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 
@@ -593,14 +596,15 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 		 * point.
 		 */
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
-		DPRINTF(sc->sc_ah, ATH_DBG_PS, "All PS CAB frames received, back to "
-			"sleep\n");
+		ath_print(common, ATH_DBG_PS,
+			  "All PS CAB frames received, back to sleep\n");
 	} else if ((sc->sc_flags & SC_OP_WAIT_FOR_PSPOLL_DATA) &&
 		   !is_multicast_ether_addr(hdr->addr1) &&
 		   !ieee80211_has_morefrags(hdr->frame_control)) {
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_PSPOLL_DATA;
-		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Going back to sleep after having "
-			"received PS-Poll data (0x%x)\n",
+		ath_print(common, ATH_DBG_PS,
+			  "Going back to sleep after having received "
+			  "PS-Poll data (0x%x)\n",
 			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
 					SC_OP_WAIT_FOR_CAB |
 					SC_OP_WAIT_FOR_PSPOLL_DATA |
@@ -816,8 +820,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
 			bf->bf_mpdu = NULL;
-			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-				"dma_mapping_error() on RX\n");
+			ath_print(common, ATH_DBG_FATAL,
+				  "dma_mapping_error() on RX\n");
 			ath_rx_send_to_mac80211(sc, skb, &rx_status);
 			break;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ddd3062..3665050 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -815,6 +815,7 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info qi;
 	int qnum;
 
@@ -854,9 +855,9 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		return NULL;
 	}
 	if (qnum >= ARRAY_SIZE(sc->tx.txq)) {
-		DPRINTF(ah, ATH_DBG_FATAL,
-			"qnum %u out of range, max %u!\n",
-			qnum, (unsigned int)ARRAY_SIZE(sc->tx.txq));
+		ath_print(common, ATH_DBG_FATAL,
+			  "qnum %u out of range, max %u!\n",
+			  qnum, (unsigned int)ARRAY_SIZE(sc->tx.txq));
 		ath9k_hw_releasetxqueue(ah, qnum);
 		return NULL;
 	}
@@ -884,9 +885,9 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 	switch (qtype) {
 	case ATH9K_TX_QUEUE_DATA:
 		if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
-			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-				"HAL AC %u out of range, max %zu!\n",
-				haltype, ARRAY_SIZE(sc->tx.hwq_map));
+			ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+				  "HAL AC %u out of range, max %zu!\n",
+				  haltype, ARRAY_SIZE(sc->tx.hwq_map));
 			return -1;
 		}
 		qnum = sc->tx.hwq_map[haltype];
@@ -914,9 +915,9 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 	spin_lock_bh(&txq->axq_lock);
 
 	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
-		DPRINTF(sc->sc_ah, ATH_DBG_XMIT,
-			"TX queue: %d is full, depth: %d\n",
-			qnum, txq->axq_depth);
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_XMIT,
+			  "TX queue: %d is full, depth: %d\n",
+			  qnum, txq->axq_depth);
 		ieee80211_stop_queue(sc->hw, skb_get_queue_mapping(skb));
 		txq->stopped = 1;
 		spin_unlock_bh(&txq->axq_lock);
@@ -955,8 +956,8 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 	qi.tqi_readyTime = qinfo->tqi_readyTime;
 
 	if (!ath9k_hw_set_txq_props(ah, qnum, &qi)) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Unable to update hardware queue %u!\n", qnum);
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "Unable to update hardware queue %u!\n", qnum);
 		error = -EIO;
 	} else {
 		ath9k_hw_resettxqueue(ah, qnum);
@@ -1055,6 +1056,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_txq *txq;
 	int i, npend = 0;
 
@@ -1076,14 +1078,15 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 	if (npend) {
 		int r;
 
-		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
+		ath_print(common, ATH_DBG_XMIT,
+			  "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, true);
 		if (r)
-			DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-				"Unable to reset hardware; reset status %d\n",
-				r);
+			ath_print(common, ATH_DBG_FATAL,
+				  "Unable to reset hardware; reset status %d\n",
+				  r);
 		spin_unlock_bh(&sc->sc_resetlock);
 	}
 
@@ -1147,8 +1150,8 @@ int ath_tx_setup(struct ath_softc *sc, int haltype)
 	struct ath_txq *txq;
 
 	if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"HAL AC %u out of range, max %zu!\n",
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "HAL AC %u out of range, max %zu!\n",
 			 haltype, ARRAY_SIZE(sc->tx.hwq_map));
 		return 0;
 	}
@@ -1172,6 +1175,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf;
 
 	/*
@@ -1188,19 +1192,19 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	txq->axq_depth++;
 	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
 
-	DPRINTF(sc->sc_ah, ATH_DBG_QUEUE,
-		"qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
+	ath_print(common, ATH_DBG_QUEUE,
+		  "qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
 	if (txq->axq_link == NULL) {
 		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
-		DPRINTF(sc->sc_ah, ATH_DBG_XMIT,
-			"TXDP[%u] = %llx (%p)\n",
-			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
+		ath_print(common, ATH_DBG_XMIT,
+			  "TXDP[%u] = %llx (%p)\n",
+			  txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
 	} else {
 		*txq->axq_link = bf->bf_daddr;
-		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
-			txq->axq_qnum, txq->axq_link,
-			ito64(bf->bf_daddr), bf->bf_desc);
+		ath_print(common, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
+			  txq->axq_qnum, txq->axq_link,
+			  ito64(bf->bf_daddr), bf->bf_desc);
 	}
 	txq->axq_link = &(bf->bf_lastbf->bf_desc->ds_link);
 	ath9k_hw_txstart(ah, txq->axq_qnum);
@@ -1587,8 +1591,8 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_mpdu = NULL;
 		kfree(tx_info_priv);
 		tx_info->rate_driver_data[0] = NULL;
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"dma_mapping_error() on TX\n");
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+			  "dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 
@@ -1670,12 +1674,13 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_buf *bf;
 	int r;
 
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
-		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "TX buffers are full\n");
+		ath_print(common, ATH_DBG_XMIT, "TX buffers are full\n");
 		return -1;
 	}
 
@@ -1683,7 +1688,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(r)) {
 		struct ath_txq *txq = txctl->txq;
 
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL, "TX mem alloc failure\n");
+		ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
 
 		/* upon ath_tx_processq() this TX queue will be resumed, we
 		 * guarantee this will happen by knowing beforehand that
@@ -1713,6 +1718,7 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int hdrlen, padsize;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_control txctl;
@@ -1737,8 +1743,8 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (hdrlen & 3) {
 		padsize = hdrlen % 4;
 		if (skb_headroom(skb) < padsize) {
-			DPRINTF(sc->sc_ah, ATH_DBG_XMIT,
-				"TX CABQ padding failed\n");
+			ath_print(common, ATH_DBG_XMIT,
+				  "TX CABQ padding failed\n");
 			dev_kfree_skb_any(skb);
 			return;
 		}
@@ -1748,10 +1754,11 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	txctl.txq = sc->beacon.cabq;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
+	ath_print(common, ATH_DBG_XMIT,
+		  "transmitting CABQ packet, skb: %p\n", skb);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "CABQ TX failed\n");
+		ath_print(common, ATH_DBG_XMIT, "CABQ TX failed\n");
 		goto exit;
 	}
 
@@ -1770,10 +1777,11 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int hdrlen, padsize;
 	int frame_type = ATH9K_NOT_INTERNAL;
 
-	DPRINTF(sc->sc_ah, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
+	ath_print(common, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
 	if (tx_info_priv) {
 		hw = tx_info_priv->aphy->hw;
@@ -1807,8 +1815,9 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	if (sc->sc_flags & SC_OP_WAIT_FOR_TX_ACK) {
 		sc->sc_flags &= ~SC_OP_WAIT_FOR_TX_ACK;
-		DPRINTF(sc->sc_ah, ATH_DBG_PS, "Going back to sleep after having "
-			"received TX status (0x%x)\n",
+		ath_print(common, ATH_DBG_PS,
+			  "Going back to sleep after having "
+			  "received TX status (0x%x)\n",
 			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
 					SC_OP_WAIT_FOR_CAB |
 					SC_OP_WAIT_FOR_PSPOLL_DATA |
@@ -1938,15 +1947,16 @@ static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf, *lastbf, *bf_held = NULL;
 	struct list_head bf_head;
 	struct ath_desc *ds;
 	int txok;
 	int status;
 
-	DPRINTF(ah, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
-		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
-		txq->axq_link);
+	ath_print(common, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
+		  txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
+		  txq->axq_link);
 
 	for (;;) {
 		spin_lock_bh(&txq->axq_lock);
@@ -2066,7 +2076,8 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 		}
 
 	if (needreset) {
-		DPRINTF(sc->sc_ah, ATH_DBG_RESET, "tx hung, resetting the chip\n");
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
+			  "tx hung, resetting the chip\n");
 		ath_reset(sc, false);
 	}
 
@@ -2095,6 +2106,7 @@ void ath_tx_tasklet(struct ath_softc *sc)
 
 int ath_tx_init(struct ath_softc *sc, int nbufs)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int error = 0;
 
 	spin_lock_init(&sc->tx.txbuflock);
@@ -2102,16 +2114,16 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
 				  "tx", nbufs, 1);
 	if (error != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Failed to allocate tx descriptors: %d\n", error);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Failed to allocate tx descriptors: %d\n", error);
 		goto err;
 	}
 
 	error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
 				  "beacon", ATH_BCBUF, 1);
 	if (error != 0) {
-		DPRINTF(sc->sc_ah, ATH_DBG_FATAL,
-			"Failed to allocate beacon descriptors: %d\n", error);
+		ath_print(common, ATH_DBG_FATAL,
+			  "Failed to allocate beacon descriptors: %d\n", error);
 		goto err;
 	}
 
diff --git a/drivers/net/wireless/ath/debug.c b/drivers/net/wireless/ath/debug.c
new file mode 100644
index 0000000..53e77bd
--- /dev/null
+++ b/drivers/net/wireless/ath/debug.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath.h"
+#include "debug.h"
+
+void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
+{
+	va_list args;
+
+	if (likely(!(common->debug_mask & dbg_mask)))
+		return;
+
+	va_start(args, fmt);
+	printk(KERN_DEBUG "ath: ");
+	vprintk(fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL(ath_print);
diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
new file mode 100644
index 0000000..d6b685a
--- /dev/null
+++ b/drivers/net/wireless/ath/debug.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef ATH_DEBUG_H
+#define ATH_DEBUG_H
+
+#include "ath.h"
+
+/**
+ * enum ath_debug_level - atheros wireless debug level
+ *
+ * @ATH_DBG_RESET: reset processing
+ * @ATH_DBG_QUEUE: hardware queue management
+ * @ATH_DBG_EEPROM: eeprom processing
+ * @ATH_DBG_CALIBRATE: periodic calibration
+ * @ATH_DBG_INTERRUPT: interrupt processing
+ * @ATH_DBG_REGULATORY: regulatory processing
+ * @ATH_DBG_ANI: adaptive noise immunitive processing
+ * @ATH_DBG_XMIT: basic xmit operation
+ * @ATH_DBG_BEACON: beacon handling
+ * @ATH_DBG_CONFIG: configuration of the hardware
+ * @ATH_DBG_FATAL: fatal errors, this is the default, DBG_DEFAULT
+ * @ATH_DBG_PS: power save processing
+ * @ATH_DBG_HWTIMER: hardware timer handling
+ * @ATH_DBG_BTCOEX: bluetooth coexistance
+ * @ATH_DBG_ANY: enable all debugging
+ *
+ * The debug level is used to control the amount and type of debugging output
+ * we want to see. Each driver has its own method for enabling debugging and
+ * modifying debug level states -- but this is typically done through a
+ * module parameter 'debug' along with a respective 'debug' debugfs file
+ * entry.
+ */
+enum ATH_DEBUG {
+	ATH_DBG_RESET		= 0x00000001,
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
+	ATH_DBG_PS		= 0x00000800,
+	ATH_DBG_HWTIMER		= 0x00001000,
+	ATH_DBG_BTCOEX		= 0x00002000,
+	ATH_DBG_ANY		= 0xffffffff
+};
+
+#define ATH_DBG_DEFAULT (ATH_DBG_FATAL)
+
+#ifdef CONFIG_ATH_DEBUG
+void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...);
+#else
+static inline void ath_print(struct ath_common *common,
+			     int dbg_mask,
+			     const char *fmt, ...)
+{
+}
+#endif /* CONFIG_ATH_DEBUG */
+
+#endif /* ATH_DEBUG_H */
-- 
1.6.3.3

