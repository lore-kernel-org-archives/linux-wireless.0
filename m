Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36315 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZBLEka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:30 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:29 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42847.358511.204936@gargle.gargle.HOWL> (sfid-20090212_054033_754332_C345EB8D)
Date: Thu, 12 Feb 2009 10:06:47 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/8] ath9k: Enable TSF Out of Range Interrupt
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch lays the groundwork for handling TSF Out of Range
interrupt, which will be used for power save later on.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    3 +++
 drivers/net/wireless/ath9k/hw.c     |    8 +++++++-
 drivers/net/wireless/ath9k/hw.h     |    4 ++++
 drivers/net/wireless/ath9k/main.c   |   15 +++++++++++----
 drivers/net/wireless/ath9k/reg.h    |    4 ++--
 5 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 2e2ef35..390d510 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -753,6 +753,9 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		if (bs.bs_sleepduration > bs.bs_dtimperiod)
 			bs.bs_sleepduration = bs.bs_dtimperiod;
 
+		/* TSF out of range threshold fixed at 1 second */
+		bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
+
 		DPRINTF(sc, ATH_DBG_BEACON,
 			"tsf %llu "
 			"tsf:tu %u "
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 6939e41..4af1aac 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2803,6 +2803,8 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 				mask2 |= ATH9K_INT_GTT;
 			if (isr2 & AR_ISR_S2_CST)
 				mask2 |= ATH9K_INT_CST;
+			if (isr2 & AR_ISR_S2_TSFOOR)
+				mask2 |= ATH9K_INT_TSFOOR;
 		}
 
 		isr = REG_READ(ah, AR_ISR_RAC);
@@ -2948,7 +2950,9 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 		if (ints & ATH9K_INT_DTIMSYNC)
 			mask2 |= AR_IMR_S2_DTIMSYNC;
 		if (ints & ATH9K_INT_CABEND)
-			mask2 |= (AR_IMR_S2_CABEND);
+			mask2 |= AR_IMR_S2_CABEND;
+		if (ints & ATH9K_INT_TSFOOR)
+			mask2 |= AR_IMR_S2_TSFOOR;
 	}
 
 	if (ints & (ATH9K_INT_GTT | ATH9K_INT_CST)) {
@@ -3118,6 +3122,8 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
 		    AR_DTIM_TIMER_EN);
 
+	/* TSF Out of Range Threshold */
+	REG_WRITE(ah, AR_TSFOOR_THRESHOLD, bs->bs_tsfoor_threshold);
 }
 
 /*******************/
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 8211163..587a78d 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -249,6 +249,7 @@ enum ath9k_int {
 	ATH9K_INT_DTIMSYNC = 0x00800000,
 	ATH9K_INT_GPIO = 0x01000000,
 	ATH9K_INT_CABEND = 0x02000000,
+	ATH9K_INT_TSFOOR = 0x04000000,
 	ATH9K_INT_CST = 0x10000000,
 	ATH9K_INT_GTT = 0x20000000,
 	ATH9K_INT_FATAL = 0x40000000,
@@ -256,6 +257,7 @@ enum ath9k_int {
 	ATH9K_INT_BMISC = ATH9K_INT_TIM |
 		ATH9K_INT_DTIM |
 		ATH9K_INT_DTIMSYNC |
+		ATH9K_INT_TSFOOR |
 		ATH9K_INT_CABEND,
 	ATH9K_INT_COMMON = ATH9K_INT_RXNOFRM |
 		ATH9K_INT_RXDESC |
@@ -385,6 +387,7 @@ struct ath9k_beacon_state {
 #define ATH9K_BEACON_PERIOD       0x0000ffff
 #define ATH9K_BEACON_ENA          0x00800000
 #define ATH9K_BEACON_RESET_TSF    0x01000000
+#define ATH9K_TSFOOR_THRESHOLD    0x00004240 /* 16k us */
 	u32 bs_dtimperiod;
 	u16 bs_cfpperiod;
 	u16 bs_cfpmaxduration;
@@ -392,6 +395,7 @@ struct ath9k_beacon_state {
 	u16 bs_timoffset;
 	u16 bs_bmissthreshold;
 	u32 bs_sleepduration;
+	u32 bs_tsfoor_threshold;
 };
 
 struct chan_centers {
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index fc3460f..ab4f78d 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -574,6 +574,10 @@ irqreturn_t ath_isr(int irq, void *dev)
 					sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
 				}
 			}
+			if (status & ATH9K_INT_TSFOOR) {
+				/* FIXME: Handle this interrupt for power save */
+				sched = true;
+			}
 		}
 	} while (0);
 
@@ -2155,10 +2159,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
 	 */
-	if (ath9k_hw_phycounters(sc->sc_ah) &&
-	    ((conf->type == NL80211_IFTYPE_STATION) ||
-	     (conf->type == NL80211_IFTYPE_ADHOC)))
-		sc->imask |= ATH9K_INT_MIB;
+	if ((conf->type == NL80211_IFTYPE_STATION) ||
+	    (conf->type == NL80211_IFTYPE_ADHOC)) {
+		if (ath9k_hw_phycounters(sc->sc_ah))
+			sc->imask |= ATH9K_INT_MIB;
+		sc->imask |= ATH9K_INT_TSFOOR;
+	}
+
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 17ed190..a471832 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -1385,8 +1385,8 @@ enum {
 #define AR_PHY_COUNTMAX        (3 << 22)
 #define AR_MIBCNT_INTRMASK     (3 << 22)
 
-#define AR_TSF_THRESHOLD       0x813c
-#define AR_TSF_THRESHOLD_VAL   0x0000FFFF
+#define AR_TSFOOR_THRESHOLD       0x813c
+#define AR_TSFOOR_THRESHOLD_VAL   0x0000FFFF
 
 #define AR_PHY_ERR_EIFS_MASK   8144
 
-- 
1.6.1

