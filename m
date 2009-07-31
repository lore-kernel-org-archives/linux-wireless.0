Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:42292 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZGaSeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:34:23 -0400
Date: Fri, 31 Jul 2009 21:34:21 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Subject: Re: [PATCH 4/4] ath5k: Use SWI to trigger calibration
Message-ID: <20090731183421.GI7963@makis>
References: <20090731181020.GE7963@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090731181020.GE7963@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Get rid of calibration timer, instead use a software interrupt
   to schedule the calibration tasklet.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/ath5k.h |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath5k/base.c  |   28 ++++++++++++++++++----------
 drivers/net/wireless/ath/ath5k/base.h  |    3 ++-
 drivers/net/wireless/ath/ath5k/phy.c   |   20 ++++++++++++++++++++
 4 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 1047a6c..76cf5b2 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -919,6 +919,12 @@ enum ath5k_int {
 	AR5K_INT_NOCARD	= 0xffffffff
 };
 
+/* Software interrupts used for calibration */
+enum ath5k_software_interrupt {
+	AR5K_SWI_FULL_CALIBRATION = 0x01,
+	AR5K_SWI_SHORT_CALIBRATION = 0x02,
+};
+
 /*
  * Power management
  */
@@ -1123,6 +1129,15 @@ struct ath5k_hw {
 	/* noise floor from last periodic calibration */
 	s32			ah_noise_floor;
 
+	/* Calibration timestamp */
+	u32			ah_cal_tstamp;
+
+	/* Calibration interval (secs) */
+	u8			ah_cal_intval;
+
+	/* Software interrupt mask */
+	u8			ah_swi_mask;
+
 	/*
 	 * Function pointers
 	 */
@@ -1276,6 +1291,7 @@ extern int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *chann
 /* PHY calibration */
 extern int ath5k_hw_phy_calibrate(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 extern int ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq);
+extern void ath5k_hw_calibration_poll(struct ath5k_hw *ah);
 /* Spur mitigation */
 bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
 				struct ieee80211_channel *channel);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b64731b..02fa71a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -59,7 +59,7 @@
 #include "reg.h"
 #include "debug.h"
 
-static int ath5k_calinterval = 10; /* Calibrate PHY every 10 secs (TODO: Fixme) */
+static u8 ath5k_calinterval = 10; /* Calibrate PHY every 10 secs (TODO: Fixme) */
 static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
@@ -376,7 +376,7 @@ static int 	ath5k_stop_hw(struct ath5k_softc *sc);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
 
-static void 	ath5k_calibrate(unsigned long data);
+static void 	ath5k_tasklet_calibrate(unsigned long data);
 
 /*
  * Module init/exit functions
@@ -799,8 +799,8 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
 	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
 	tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long)sc);
+	tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned long)sc);
 	tasklet_init(&sc->beacontq, ath5k_tasklet_beacon, (unsigned long)sc);
-	setup_timer(&sc->calib_tim, ath5k_calibrate, (unsigned long)sc);
 
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
@@ -2366,7 +2366,7 @@ ath5k_init(struct ath5k_softc *sc)
 	sc->curband = &sc->sbands[sc->curchan->band];
 	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
-		AR5K_INT_FATAL | AR5K_INT_GLOBAL;
+		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_SWI;
 	ret = ath5k_reset(sc, NULL);
 	if (ret)
 		goto done;
@@ -2383,8 +2383,8 @@ ath5k_init(struct ath5k_softc *sc)
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(ah, false);
 
-	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
-			msecs_to_jiffies(ath5k_calinterval * 1000)));
+	/* Set PHY calibration timestamp and inteval */
+	ah->ah_cal_intval = ath5k_calinterval;
 
 	ret = 0;
 done:
@@ -2477,7 +2477,6 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	mmiowb();
 	mutex_unlock(&sc->lock);
 
-	del_timer_sync(&sc->calib_tim);
 	tasklet_kill(&sc->rxtq);
 	tasklet_kill(&sc->txtq);
 	tasklet_kill(&sc->restq);
@@ -2536,6 +2535,9 @@ ath5k_intr(int irq, void *dev_id)
 			if (status & AR5K_INT_BMISS) {
 				/* TODO */
 			}
+			if (status & AR5K_INT_SWI) {
+				tasklet_schedule(&sc->calib);
+			}
 			if (status & AR5K_INT_MIB) {
 				/*
 				 * These stats are also used for ANI i think
@@ -2552,6 +2554,8 @@ ath5k_intr(int irq, void *dev_id)
 	if (unlikely(!counter))
 		ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
 
+	ath5k_hw_calibration_poll(ah);
+
 	return IRQ_HANDLED;
 }
 
@@ -2568,11 +2572,15 @@ ath5k_tasklet_reset(unsigned long data)
  * for temperature/environment changes.
  */
 static void
-ath5k_calibrate(unsigned long data)
+ath5k_tasklet_calibrate(unsigned long data)
 {
 	struct ath5k_softc *sc = (void *)data;
 	struct ath5k_hw *ah = sc->ah;
 
+	/* Only full calibration for now */
+	if (ah->ah_swi_mask != AR5K_SWI_FULL_CALIBRATION)
+		return;
+
 	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
 		ieee80211_frequency_to_channel(sc->curchan->center_freq),
 		sc->curchan->hw_value);
@@ -2590,8 +2598,8 @@ ath5k_calibrate(unsigned long data)
 			ieee80211_frequency_to_channel(
 				sc->curchan->center_freq));
 
-	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
-			msecs_to_jiffies(ath5k_calinterval * 1000)));
+	ah->ah_swi_mask = 0;
+
 }
 
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 778e422..667bd9d 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -177,6 +177,8 @@ struct ath5k_softc {
 
 	struct ath5k_rfkill	rf_kill;
 
+	struct tasklet_struct	calib;		/* calibration tasklet */
+
 	spinlock_t		block;		/* protects beacon */
 	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
 	struct ath5k_buf	*bbuf;		/* beacon buffer */
@@ -187,7 +189,6 @@ struct ath5k_softc {
 	unsigned int		nexttbtt;	/* next beacon time in TU */
 	struct ath5k_txq	*cabq;		/* content after beacon */
 
-	struct timer_list	calib_tim;	/* calibration timer */
 	int 			power_level;	/* Requested tx power in dbm */
 	bool			assoc;		/* assocate state */
 	bool			enable_beacon;	/* true if beacons are on */
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 6afba98..d30bc3b 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1104,6 +1104,26 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
   PHY calibration
 \*****************/
 
+void
+ath5k_hw_calibration_poll(struct ath5k_hw *ah)
+{
+	u32 current_time = (jiffies / HZ);
+	u32 cal_intval = ah->ah_cal_intval;
+
+	if (!ah->ah_cal_tstamp)
+		ah->ah_cal_tstamp = current_time;
+
+	/* For now we always do full calibration
+	 * Mark software interrupt mask and fire software
+	 * interrupt (bit gets auto-cleared) */
+	if ((current_time - ah->ah_cal_tstamp) >= cal_intval) {
+		ah->ah_cal_tstamp = current_time;
+		ah->ah_swi_mask = AR5K_SWI_FULL_CALIBRATION;
+		AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI);
+	}
+
+}
+
 /**
  * ath5k_hw_noise_floor_calibration - perform PHY noise floor calibration
  *

