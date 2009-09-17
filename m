Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21622 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759983AbZIQDyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:54:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:54:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.45842.560387.608415@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:24:58 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/12] ath9k: Revamp PCIE workarounds
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vivek Natarajan <vnatarajan@atheros.com>

* Disable L1 state ONLY when device is in D3 mode.
* Clear bit 22 of register 0x4004.
* Handle power on/off properly

Not setting the workarounds properly resulted in the
disappearance of the card in certain cases.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |  162 +++++++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |    8 +-
 drivers/net/wireless/ath/ath9k/reg.h  |    3 +-
 4 files changed, 103 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b6c6cca..82a2440 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -965,7 +965,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_mode_regs(ah);
 
 	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, 0);
+		ath9k_hw_configpcipowersave(ah, 0, 0);
 	else
 		ath9k_hw_disablepcie(ah);
 
@@ -3005,9 +3005,10 @@ void ath9k_ps_restore(struct ath_softc *sc)
  * Programming the SerDes must go through the same 288 bit serial shift
  * register as the other analog registers.  Hence the 9 writes.
  */
-void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
+void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore, int power_off)
 {
 	u8 i;
+	u32 val;
 
 	if (ah->is_pciexpress != true)
 		return;
@@ -3017,84 +3018,113 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		return;
 
 	/* Nothing to do on restore for 11N */
-	if (restore)
-		return;
-
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		/*
-		 * AR9280 2.0 or later chips use SerDes values from the
-		 * initvals.h initialized depending on chipset during
-		 * ath9k_hw_init()
-		 */
-		for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
-			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
-				  INI_RA(&ah->iniPcieSerdes, i, 1));
-		}
-	} else if (AR_SREV_9280(ah) &&
-		   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+	if (!restore) {
+		if (AR_SREV_9280_20_OR_LATER(ah)) {
+			/*
+			 * AR9280 2.0 or later chips use SerDes values from the
+			 * initvals.h initialized depending on chipset during
+			 * ath9k_hw_init()
+			 */
+			for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
+				REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
+					  INI_RA(&ah->iniPcieSerdes, i, 1));
+			}
+		} else if (AR_SREV_9280(ah) &&
+			   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+
+			/* RX shut off when elecidle is asserted */
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xa8000019);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
+
+			/* Shut off CLKREQ active in L1 */
+			if (ah->config.pcie_clock_req)
+				REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
+			else
+				REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
 
-		/* RX shut off when elecidle is asserted */
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xa8000019);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x00043007);
 
-		/* Shut off CLKREQ active in L1 */
-		if (ah->config.pcie_clock_req)
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
-		else
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
+			/* Load the new settings */
+			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x00043007);
+		} else {
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
 
-		/* Load the new settings */
-		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+			/* RX shut off when elecidle is asserted */
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x28000039);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x53160824);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980579);
 
-	} else {
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+			/*
+			 * Ignore ah->ah_config.pcie_clock_req setting for
+			 * pre-AR9280 11n
+			 */
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x001defff);
 
-		/* RX shut off when elecidle is asserted */
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x28000039);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x53160824);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980579);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x000e3007);
 
-		/*
-		 * Ignore ah->ah_config.pcie_clock_req setting for
-		 * pre-AR9280 11n
-		 */
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x001defff);
+			/* Load the new settings */
+			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+		}
 
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x000e3007);
+		udelay(1000);
 
-		/* Load the new settings */
-		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-	}
+		/* set bit 19 to allow forcing of pcie core into L1 state */
+		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 
-	udelay(1000);
+		/* Several PCIe massages to ensure proper behaviour */
+		if (ah->config.pcie_waen) {
+			val = ah->config.pcie_waen;
+			if (!power_off)
+				val &= (~AR_WA_D3_L1_DISABLE);
+		} else {
+			if (AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
+			    AR_SREV_9287(ah)) {
+				val = AR9285_WA_DEFAULT;
+				if (!power_off)
+					val &= (~AR_WA_D3_L1_DISABLE);
+			} else if (AR_SREV_9280(ah)) {
+				/*
+				 * On AR9280 chips bit 22 of 0x4004 needs to be
+				 * set otherwise card may disappear.
+				 */
+				val = AR9280_WA_DEFAULT;
+				if (!power_off)
+					val &= (~AR_WA_D3_L1_DISABLE);
+			} else
+				val = AR_WA_DEFAULT;
+		}
 
-	/* set bit 19 to allow forcing of pcie core into L1 state */
-	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+		REG_WRITE(ah, AR_WA, val);
+	}
 
-	/* Several PCIe massages to ensure proper behaviour */
-	if (ah->config.pcie_waen) {
-		REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
-	} else {
-		if (AR_SREV_9285(ah) || AR_SREV_9271(ah) || AR_SREV_9287(ah))
-			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
+	if (power_off) {
 		/*
-		 * On AR9280 chips bit 22 of 0x4004 needs to be set to
-		 * otherwise card may disappear.
+		 * Set PCIe workaround bits
+		 * bit 14 in WA register (disable L1) should only
+		 * be set when device enters D3 and be cleared
+		 * when device comes back to D0.
 		 */
-		else if (AR_SREV_9280(ah))
-			REG_WRITE(ah, AR_WA, AR9280_WA_DEFAULT);
-		else
-			REG_WRITE(ah, AR_WA, AR_WA_DEFAULT);
+		if (ah->config.pcie_waen) {
+			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
+				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
+		} else {
+			if (((AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
+			      AR_SREV_9287(ah)) &&
+			     (AR9285_WA_DEFAULT & AR_WA_D3_L1_DISABLE)) ||
+			    (AR_SREV_9280(ah) &&
+			     (AR9280_WA_DEFAULT & AR_WA_D3_L1_DISABLE))) {
+				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
+			}
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9106a0b..75c3041 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -650,7 +650,7 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
 bool ath9k_hw_setpower(struct ath_hw *ah,
 		       enum ath9k_power_mode mode);
-void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore);
+void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore, int power_off);
 
 /* Interrupt Handling */
 bool ath9k_hw_intrpend(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3dc7b5a..5055f18 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1131,7 +1131,7 @@ void ath_radio_enable(struct ath_softc *sc)
 	int r;
 
 	ath9k_ps_wakeup(sc);
-	ath9k_hw_configpcipowersave(ah, 0);
+	ath9k_hw_configpcipowersave(ah, 0, 0);
 
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
@@ -1202,7 +1202,7 @@ void ath_radio_disable(struct ath_softc *sc)
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
-	ath9k_hw_configpcipowersave(ah, 1);
+	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_ps_restore(sc);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 }
@@ -1942,7 +1942,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	init_channel = ath_get_curchannel(sc, hw);
 
 	/* Reset SERDES registers */
-	ath9k_hw_configpcipowersave(sc->sc_ah, 0);
+	ath9k_hw_configpcipowersave(sc->sc_ah, 0, 0);
 
 	/*
 	 * The basic interface to setting the hardware in a good
@@ -2170,7 +2170,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
-	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
+	ath9k_hw_configpcipowersave(sc->sc_ah, 1, 1);
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
 
 	sc->sc_flags |= SC_OP_INVALID;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index e5c29eb..d83b77f 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -676,8 +676,9 @@
 #define AR_RC_HOSTIF         0x00000100
 
 #define AR_WA                		0x4004
+#define AR_WA_D3_L1_DISABLE		(1 << 14)
 #define AR9285_WA_DEFAULT 		0x004a05cb
-#define AR9280_WA_DEFAULT           	0x0040073f
+#define AR9280_WA_DEFAULT           	0x0040073b
 #define AR_WA_DEFAULT               	0x0000073f
 
 
-- 
1.6.4.3

