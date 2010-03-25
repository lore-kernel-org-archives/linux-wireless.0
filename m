Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:18923 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0CYFt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:59 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0817986197
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:57 +0900 (JST)
Subject: [PATCH 10/10] ath5k: Adaptive Noise Immunity (ANI) Implementation
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:52 +0900
Message-ID: <20100325054952.10697.41515.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an Adaptive Noise Imunity (ANI) implementation for ath5k. I have looked
at both ath9k and HAL sources (they are nearly the same), and even though i
have implemented some things differently, the basic algorithm is practically
the same, for now. I hope that this can serve as a clean start to improve the
algorithm later.

This also adds a possibility to manually control ANI settings, right now only
thru a debugfs file:
  * set lowest sensitivity (=highest noise immunity):
	echo sens-low > /sys/kernel/debug/ath5k/phy0/ani
  * set highest sensitivity (=lowest noise immunity):
	echo sens-high > /sys/kernel/debug/ath5k/phy0/ani
  * automatically control immunity (default):
	echo ani-on > /sys/kernel/debug/ath5k/phy0/ani
  * to see the parameters in use and watch them change:
	cat /sys/kernel/debug/ath5k/phy0/ani

Manually setting sensitivity will turn the automatic control off. You can also
control each of the five immunity parameters (noise immunity, spur immunity,
firstep, ofdm weak signal detection, cck weak signal detection) manually thru
the debugfs file.

This is tested on AR5414 and nearly doubles the thruput in a noisy 2GHz band.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/Makefile |    1 
 drivers/net/wireless/ath/ath5k/ani.c    |  741 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/ani.h    |  104 ++++
 drivers/net/wireless/ath/ath5k/ath5k.h  |    9 
 drivers/net/wireless/ath/ath5k/attach.c |    1 
 drivers/net/wireless/ath/ath5k/base.c   |   32 +
 drivers/net/wireless/ath/ath5k/base.h   |    6 
 drivers/net/wireless/ath/ath5k/debug.c  |  162 +++++++
 drivers/net/wireless/ath/ath5k/debug.h  |    2 
 drivers/net/wireless/ath/ath5k/desc.c   |    1 
 drivers/net/wireless/ath/ath5k/pcu.c    |    1 
 drivers/net/wireless/ath/ath5k/reg.h    |   36 +-
 12 files changed, 1080 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/ani.c
 create mode 100644 drivers/net/wireless/ath/ath5k/ani.h

diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index 090dc6d..cc09595 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -12,5 +12,6 @@ ath5k-y				+= attach.o
 ath5k-y				+= base.o
 ath5k-y				+= led.o
 ath5k-y				+= rfkill.o
+ath5k-y				+= ani.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
new file mode 100644
index 0000000..f1ca015
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -0,0 +1,741 @@
+/*
+ * Copyright (C) 2010 Bruno Randolf <br1@einfach.org>
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
+#include "ath5k.h"
+#include "base.h"
+#include "reg.h"
+#include "debug.h"
+#include "ani.h"
+
+/**
+ * DOC: Basic ANI Operation
+ *
+ * Adaptive Noise Immunity (ANI) controls five noise immunity parameters
+ * depending on the amount of interference in the environment, increasing
+ * or reducing sensitivity as necessary.
+ *
+ * The parameters are:
+ *   - "noise immunity"
+ *   - "spur immunity"
+ *   - "firstep level"
+ *   - "OFDM weak signal detection"
+ *   - "CCK weak signal detection"
+ *
+ * Basically we look at the amount of ODFM and CCK timing errors we get and then
+ * raise or lower immunity accordingly by setting one or more of these
+ * parameters.
+ * Newer chipsets have PHY error counters in hardware which will generate a MIB
+ * interrupt when they overflow. Older hardware has too enable PHY error frames
+ * by setting a RX flag and then count every single PHY error. When a specified
+ * threshold of errors has been reached we will raise immunity.
+ * Also we regularly check the amount of errors and lower or raise immunity as
+ * necessary.
+ */
+
+
+/*** ANI parameter control ***/
+
+/**
+ * ath5k_ani_set_noise_immunity_level() - Set noise immunity level
+ *
+ * @level: level between 0 and @ATH5K_ANI_MAX_NOISE_IMM_LVL
+ */
+void
+ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
+{
+	/* TODO:
+	 * ANI documents suggest the following five levels to use, but the HAL
+	 * and ath9k use only use the last two levels, making this
+	 * essentially an on/off option. There *may* be a reason for this (???),
+	 * so i stick with the HAL version for now...
+	 */
+#if 0
+	const s8 hi[] = { -18, -18, -16, -14, -12 };
+	const s8 lo[] = { -52, -56, -60, -64, -70 };
+	const s8 sz[] = { -34, -41, -48, -55, -62 };
+	const s8 fr[] = { -70, -72, -75, -78, -80 };
+#else
+	const s8 sz[] = { -55, -62 };
+	const s8 lo[] = { -64, -70 };
+	const s8 hi[] = { -14, -12 };
+	const s8 fr[] = { -78, -80 };
+#endif
+	if (level < 0 || level > ARRAY_SIZE(sz)) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+			"level out of range %d", level);
+		return;
+	}
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_DESIRED_SIZE,
+				AR5K_PHY_DESIRED_SIZE_TOT, sz[level]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_AGCCOARSE,
+				AR5K_PHY_AGCCOARSE_LO, lo[level]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_AGCCOARSE,
+				AR5K_PHY_AGCCOARSE_HI, hi[level]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SIG,
+				AR5K_PHY_SIG_FIRPWR, fr[level]);
+
+	ah->ah_sc->ani_state.noise_imm_level = level;
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "new level %d", level);
+}
+
+
+/**
+ * ath5k_ani_set_spur_immunity_level() - Set spur immunity level
+ *
+ * @level: level between 0 and @max_spur_level (the maximum level is dependent
+ *	on the chip revision).
+ */
+void
+ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level)
+{
+	const int val[] = { 2, 4, 6, 8, 10, 12, 14, 16 };
+
+	if (level < 0 || level > ARRAY_SIZE(val) ||
+	    level > ah->ah_sc->ani_state.max_spur_level) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+			"level out of range %d", level);
+		return;
+	}
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_OFDM_SELFCORR,
+		AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1, val[level]);
+
+	ah->ah_sc->ani_state.spur_level = level;
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "new level %d", level);
+}
+
+
+/**
+ * ath5k_ani_set_firstep_level() - Set "firstep" level
+ *
+ * @level: level between 0 and @ATH5K_ANI_MAX_FIRSTEP_LVL
+ */
+void
+ath5k_ani_set_firstep_level(struct ath5k_hw *ah, int level)
+{
+	const int val[] = { 0, 4, 8 };
+
+	if (level < 0 || level > ARRAY_SIZE(val)) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+			"level out of range %d", level);
+		return;
+	}
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SIG,
+				AR5K_PHY_SIG_FIRSTEP, val[level]);
+
+	ah->ah_sc->ani_state.firstep_level = level;
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "new level %d", level);
+}
+
+
+/**
+ * ath5k_ani_set_ofdm_weak_signal_detection() - Control OFDM weak signal
+ *						detection
+ *
+ * @on: turn on or off
+ */
+void
+ath5k_ani_set_ofdm_weak_signal_detection(struct ath5k_hw *ah, bool on)
+{
+	const int m1l[] = { 127, 50 };
+	const int m2l[] = { 127, 40 };
+	const int m1[] = { 127, 0x4d };
+	const int m2[] = { 127, 0x40 };
+	const int m2cnt[] = { 31, 16 };
+	const int m2lcnt[] = { 63, 48 };
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_WEAK_OFDM_LOW_THR,
+				AR5K_PHY_WEAK_OFDM_LOW_THR_M1, m1l[on]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_WEAK_OFDM_LOW_THR,
+				AR5K_PHY_WEAK_OFDM_LOW_THR_M2, m2l[on]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_WEAK_OFDM_HIGH_THR,
+				AR5K_PHY_WEAK_OFDM_HIGH_THR_M1, m1[on]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_WEAK_OFDM_HIGH_THR,
+				AR5K_PHY_WEAK_OFDM_HIGH_THR_M2, m2[on]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_WEAK_OFDM_HIGH_THR,
+			AR5K_PHY_WEAK_OFDM_HIGH_THR_M2_COUNT, m2cnt[on]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_WEAK_OFDM_LOW_THR,
+			AR5K_PHY_WEAK_OFDM_LOW_THR_M2_COUNT, m2lcnt[on]);
+
+	if (on)
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_WEAK_OFDM_LOW_THR,
+				AR5K_PHY_WEAK_OFDM_LOW_THR_SELFCOR_EN);
+	else
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_WEAK_OFDM_LOW_THR,
+				AR5K_PHY_WEAK_OFDM_LOW_THR_SELFCOR_EN);
+
+	ah->ah_sc->ani_state.ofdm_weak_sig = on;
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "turned %s",
+			  on ? "on" : "off");
+}
+
+
+/**
+ * ath5k_ani_set_cck_weak_signal_detection() - control CCK weak signal detection
+ *
+ * @on: turn on or off
+ */
+void
+ath5k_ani_set_cck_weak_signal_detection(struct ath5k_hw *ah, bool on)
+{
+	const int val[] = { 8, 6 };
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_CCK_CROSSCORR,
+				AR5K_PHY_CCK_CROSSCORR_WEAK_SIG_THR, val[on]);
+	ah->ah_sc->ani_state.cck_weak_sig = on;
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "turned %s",
+			  on ? "on" : "off");
+}
+
+
+/*** ANI algorithm ***/
+
+/**
+ * ath5k_ani_raise_immunity() - Increase noise immunity
+ *
+ * @ofdm_trigger: If this is true we are called because of too many OFDM errors,
+ *	the algorithm will tune more parameters then.
+ *
+ * Try to raise noise immunity (=decrease sensitivity) in several steps
+ * depending on the average RSSI of the beacons we received.
+ */
+static void
+ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
+			 bool ofdm_trigger)
+{
+	int rssi = ah->ah_beacon_rssi_avg.avg;
+
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "raise immunity (%s)",
+		ofdm_trigger ? "ODFM" : "CCK");
+
+	/* first: raise noise immunity */
+	if (as->noise_imm_level < ATH5K_ANI_MAX_NOISE_IMM_LVL) {
+		ath5k_ani_set_noise_immunity_level(ah, as->noise_imm_level + 1);
+		return;
+	}
+
+	/* only OFDM: raise spur immunity level */
+	if (ofdm_trigger &&
+	    as->spur_level < ah->ah_sc->ani_state.max_spur_level) {
+		ath5k_ani_set_spur_immunity_level(ah, as->spur_level + 1);
+		return;
+	}
+
+	/* AP mode */
+	if (ah->ah_sc->opmode == NL80211_IFTYPE_AP) {
+		if (as->firstep_level < ATH5K_ANI_MAX_FIRSTEP_LVL)
+			ath5k_ani_set_firstep_level(ah, as->firstep_level + 1);
+		return;
+	}
+
+	/* STA and IBSS mode */
+
+	/* TODO: for IBSS mode it would be better to keep a beacon RSSI average
+	 * per each neighbour node and use the minimum of these, to make sure we
+	 * don't shut out a remote node by raising immunity too high. */
+
+	if (rssi > ATH5K_ANI_RSSI_THR_HIGH) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+				  "beacon RSSI high");
+		/* only OFDM: beacon RSSI is high, we can disable ODFM weak
+		 * signal detection */
+		if (ofdm_trigger && as->ofdm_weak_sig == true) {
+			ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
+			ath5k_ani_set_spur_immunity_level(ah, 0);
+			return;
+		}
+		/* as a last resort or CCK: raise firstep level */
+		if (as->firstep_level < ATH5K_ANI_MAX_FIRSTEP_LVL) {
+			ath5k_ani_set_firstep_level(ah, as->firstep_level + 1);
+			return;
+		}
+	} else if (rssi > ATH5K_ANI_RSSI_THR_LOW) {
+		/* beacon RSSI in mid range, we need OFDM weak signal detect,
+		 * but can raise firstep level */
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+				  "beacon RSSI mid");
+		if (ofdm_trigger && as->ofdm_weak_sig == false)
+			ath5k_ani_set_ofdm_weak_signal_detection(ah, true);
+		if (as->firstep_level < ATH5K_ANI_MAX_FIRSTEP_LVL)
+			ath5k_ani_set_firstep_level(ah, as->firstep_level + 1);
+		return;
+	} else if (ah->ah_current_channel->band == IEEE80211_BAND_2GHZ) {
+		/* beacon RSSI is low. in B/G mode turn of OFDM weak signal
+		 * detect and zero firstep level to maximize CCK sensitivity */
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+				  "beacon RSSI low, 2GHz");
+		if (ofdm_trigger && as->ofdm_weak_sig == true)
+			ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
+		if (as->firstep_level > 0)
+			ath5k_ani_set_firstep_level(ah, 0);
+		return;
+	}
+
+	/* TODO: why not?:
+	if (as->cck_weak_sig == true) {
+		ath5k_ani_set_cck_weak_signal_detection(ah, false);
+	}
+	*/
+}
+
+
+/**
+ * ath5k_ani_lower_immunity() - Decrease noise immunity
+ *
+ * Try to lower noise immunity (=increase sensitivity) in several steps
+ * depending on the average RSSI of the beacons we received.
+ */
+static void
+ath5k_ani_lower_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as)
+{
+	int rssi = ah->ah_beacon_rssi_avg.avg;
+
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "lower immunity");
+
+	if (ah->ah_sc->opmode == NL80211_IFTYPE_AP) {
+		/* AP mode */
+		if (as->firstep_level > 0) {
+			ath5k_ani_set_firstep_level(ah, as->firstep_level - 1);
+			return;
+		}
+	} else {
+		/* STA and IBSS mode (see TODO above) */
+		if (rssi > ATH5K_ANI_RSSI_THR_HIGH) {
+			/* beacon signal is high, leave OFDM weak signal
+			 * detection off or it may oscillate
+			 * TODO: who said it's off??? */
+		} else if (rssi > ATH5K_ANI_RSSI_THR_LOW) {
+			/* beacon RSSI is mid-range: turn on ODFM weak signal
+			 * detection and next, lower firstep level */
+			if (as->ofdm_weak_sig == false) {
+				ath5k_ani_set_ofdm_weak_signal_detection(ah,
+									 true);
+				return;
+			}
+			if (as->firstep_level > 0) {
+				ath5k_ani_set_firstep_level(ah,
+							as->firstep_level - 1);
+				return;
+			}
+		} else {
+			/* beacon signal is low: only reduce firstep level */
+			if (as->firstep_level > 0) {
+				ath5k_ani_set_firstep_level(ah,
+							as->firstep_level - 1);
+				return;
+			}
+		}
+	}
+
+	/* all modes */
+	if (as->spur_level > 0) {
+		ath5k_ani_set_spur_immunity_level(ah, as->spur_level - 1);
+		return;
+	}
+
+	/* finally, reduce noise immunity */
+	if (as->noise_imm_level > 0) {
+		ath5k_ani_set_noise_immunity_level(ah, as->noise_imm_level - 1);
+		return;
+	}
+}
+
+
+/**
+ * ath5k_hw_ani_get_listen_time() - Calculate time spent listening
+ *
+ * Return an approximation of the time spent "listening" in milliseconds (ms)
+ * since the last call of this function by deducting the cycles spent
+ * transmitting and receiving from the total cycle count.
+ * Save profile count values for debugging/statistics and because we might want
+ * to use them later.
+ *
+ * We assume no one else clears these registers!
+ */
+static int
+ath5k_hw_ani_get_listen_time(struct ath5k_hw *ah, struct ath5k_ani_state *as)
+{
+	int listen;
+
+	/* freeze */
+	ath5k_hw_reg_write(ah, AR5K_MIBC_FMC, AR5K_MIBC);
+	/* read */
+	as->pfc_cycles = ath5k_hw_reg_read(ah, AR5K_PROFCNT_CYCLE);
+	as->pfc_busy = ath5k_hw_reg_read(ah, AR5K_PROFCNT_RXCLR);
+	as->pfc_tx = ath5k_hw_reg_read(ah, AR5K_PROFCNT_TX);
+	as->pfc_rx = ath5k_hw_reg_read(ah, AR5K_PROFCNT_RX);
+	/* clear */
+	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_TX);
+	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RX);
+	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RXCLR);
+	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_CYCLE);
+	/* un-freeze */
+	ath5k_hw_reg_write(ah, 0, AR5K_MIBC);
+
+	/* TODO: where does 44000 come from? (11g clock rate?) */
+	listen = (as->pfc_cycles - as->pfc_rx - as->pfc_tx) / 44000;
+
+	if (as->pfc_cycles == 0 || listen < 0)
+		return 0;
+	return listen;
+}
+
+
+/**
+ * ath5k_ani_save_and_clear_phy_errors() - Clear and save PHY error counters
+ *
+ * Clear the PHY error counters as soon as possible, since this might be called
+ * from a MIB interrupt and we want to make sure we don't get interrupted again.
+ * Add the count of CCK and OFDM errors to our internal state, so it can be used
+ * by the algorithm later.
+ *
+ * Will be called from interrupt and tasklet context.
+ * Returns 0 if both counters are zero.
+ */
+static int
+ath5k_ani_save_and_clear_phy_errors(struct ath5k_hw *ah,
+				    struct ath5k_ani_state *as)
+{
+	unsigned int ofdm_err, cck_err;
+
+	if (!ah->ah_capabilities.cap_has_phyerr_counters)
+		return 0;
+
+	ofdm_err = ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT1);
+	cck_err = ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT2);
+
+	/* reset counters first, we might be in a hurry (interrupt) */
+	ath5k_hw_reg_write(ah, ATH5K_PHYERR_CNT_MAX - ATH5K_ANI_OFDM_TRIG_HIGH,
+			   AR5K_PHYERR_CNT1);
+	ath5k_hw_reg_write(ah, ATH5K_PHYERR_CNT_MAX - ATH5K_ANI_CCK_TRIG_HIGH,
+			   AR5K_PHYERR_CNT2);
+
+	ofdm_err = ATH5K_ANI_OFDM_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX - ofdm_err);
+	cck_err = ATH5K_ANI_CCK_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX - cck_err);
+
+	/* sometimes both can be zero, especially when there is a superfluous
+	 * second interrupt. detect that here and return an error. */
+	if (ofdm_err <= 0 && cck_err <= 0)
+		return 0;
+
+	/* avoid negative values should one of the registers overflow */
+	if (ofdm_err > 0) {
+		as->ofdm_errors += ofdm_err;
+		as->sum_ofdm_errors += ofdm_err;
+	}
+	if (cck_err > 0) {
+		as->cck_errors += cck_err;
+		as->sum_cck_errors += cck_err;
+	}
+	return 1;
+}
+
+
+/**
+ * ath5k_ani_period_restart() - Restart ANI period
+ *
+ * Just reset counters, so they are clear for the next "ani period".
+ */
+static void
+ath5k_ani_period_restart(struct ath5k_hw *ah, struct ath5k_ani_state *as)
+{
+	/* keep last values for debugging */
+	as->last_ofdm_errors = as->ofdm_errors;
+	as->last_cck_errors = as->cck_errors;
+	as->last_listen = as->listen_time;
+
+	as->ofdm_errors = 0;
+	as->cck_errors = 0;
+	as->listen_time = 0;
+}
+
+
+/**
+ * ath5k_ani_calibration() - The main ANI calibration function
+ *
+ * We count OFDM and CCK errors relative to the time where we did not send or
+ * receive ("listen" time) and raise or lower immunity accordingly.
+ * This is called regularly (every second) from the calibration timer, but also
+ * when an error threshold has been reached.
+ *
+ * In order to synchronize access from different contexts, this should be
+ * called only indirectly by scheduling the ANI tasklet!
+ */
+void
+ath5k_ani_calibration(struct ath5k_hw *ah)
+{
+	struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
+	int listen, ofdm_high, ofdm_low, cck_high, cck_low;
+
+	if (as->ani_mode != ATH5K_ANI_MODE_AUTO)
+		return;
+
+	/* get listen time since last call and add it to the counter because we
+	 * might not have restarted the "ani period" last time */
+	listen = ath5k_hw_ani_get_listen_time(ah, as);
+	as->listen_time += listen;
+
+	ath5k_ani_save_and_clear_phy_errors(ah, as);
+
+	ofdm_high = as->listen_time * ATH5K_ANI_OFDM_TRIG_HIGH / 1000;
+	cck_high = as->listen_time * ATH5K_ANI_CCK_TRIG_HIGH / 1000;
+	ofdm_low = as->listen_time * ATH5K_ANI_OFDM_TRIG_LOW / 1000;
+	cck_low = as->listen_time * ATH5K_ANI_CCK_TRIG_LOW / 1000;
+
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		"listen %d (now %d)", as->listen_time, listen);
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		"check high ofdm %d/%d cck %d/%d",
+		as->ofdm_errors, ofdm_high, as->cck_errors, cck_high);
+
+	if (as->ofdm_errors > ofdm_high || as->cck_errors > cck_high) {
+		/* too many PHY errors - we have to raise immunity */
+		bool ofdm_flag = as->ofdm_errors > ofdm_high ? true : false;
+		ath5k_ani_raise_immunity(ah, as, ofdm_flag);
+		ath5k_ani_period_restart(ah, as);
+
+	} else if (as->listen_time > 5 * ATH5K_ANI_LISTEN_PERIOD) {
+		/* If more than 5 (TODO: why 5?) periods have passed and we got
+		 * relatively little errors we can try to lower immunity */
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+			"check low ofdm %d/%d cck %d/%d",
+			as->ofdm_errors, ofdm_low, as->cck_errors, cck_low);
+
+		if (as->ofdm_errors <= ofdm_low && as->cck_errors <= cck_low)
+			ath5k_ani_lower_immunity(ah, as);
+
+		ath5k_ani_period_restart(ah, as);
+	}
+}
+
+
+/*** INTERRUPT HANDLER ***/
+
+/**
+ * ath5k_ani_mib_intr() - Interrupt handler for ANI MIB counters
+ *
+ * Just read & reset the registers quickly, so they don't generate more
+ * interrupts, save the counters and schedule the tasklet to decide whether
+ * to raise immunity or not.
+ *
+ * We just need to handle PHY error counters, ath5k_hw_update_mib_counters()
+ * should take care of all "normal" MIB interrupts.
+ */
+void
+ath5k_ani_mib_intr(struct ath5k_hw *ah)
+{
+	struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
+
+	/* nothing to do here if HW does not have PHY error counters - they
+	 * can't be the reason for the MIB interrupt then */
+	if (!ah->ah_capabilities.cap_has_phyerr_counters)
+		return;
+
+	/* not in use but clear anyways */
+	ath5k_hw_reg_write(ah, 0, AR5K_OFDM_FIL_CNT);
+	ath5k_hw_reg_write(ah, 0, AR5K_CCK_FIL_CNT);
+
+	if (ah->ah_sc->ani_state.ani_mode != ATH5K_ANI_MODE_AUTO)
+		return;
+
+	/* if one of the errors triggered, we can get a superfluous second
+	 * interrupt, even though we have already reset the register. the
+	 * function detects that so we can return early */
+	if (ath5k_ani_save_and_clear_phy_errors(ah, as) == 0)
+		return;
+
+	if (as->ofdm_errors > ATH5K_ANI_OFDM_TRIG_HIGH ||
+	    as->cck_errors > ATH5K_ANI_CCK_TRIG_HIGH)
+		tasklet_schedule(&ah->ah_sc->ani_tasklet);
+}
+
+
+/**
+ * ath5k_ani_phy_error_report() - Used by older HW to report PHY errors
+ *
+ * This is used by hardware without PHY error counters to report PHY errors
+ * on a frame-by-frame basis, instead of the interrupt.
+ */
+void
+ath5k_ani_phy_error_report(struct ath5k_hw *ah,
+			   enum ath5k_phy_error_code phyerr)
+{
+	struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
+
+	if (phyerr == AR5K_RX_PHY_ERROR_OFDM_TIMING) {
+		as->ofdm_errors++;
+		if (as->ofdm_errors > ATH5K_ANI_OFDM_TRIG_HIGH)
+			tasklet_schedule(&ah->ah_sc->ani_tasklet);
+	} else if (phyerr == AR5K_RX_PHY_ERROR_CCK_TIMING) {
+		as->cck_errors++;
+		if (as->cck_errors > ATH5K_ANI_CCK_TRIG_HIGH)
+			tasklet_schedule(&ah->ah_sc->ani_tasklet);
+	}
+}
+
+
+/*** INIT ***/
+
+/**
+ * ath5k_enable_phy_err_counters() - Enable PHY error counters
+ *
+ * Enable PHY error counters for OFDM and CCK timing errors.
+ */
+static void
+ath5k_enable_phy_err_counters(struct ath5k_hw *ah)
+{
+	ath5k_hw_reg_write(ah, ATH5K_PHYERR_CNT_MAX - ATH5K_ANI_OFDM_TRIG_HIGH,
+			   AR5K_PHYERR_CNT1);
+	ath5k_hw_reg_write(ah, ATH5K_PHYERR_CNT_MAX - ATH5K_ANI_CCK_TRIG_HIGH,
+			   AR5K_PHYERR_CNT2);
+	ath5k_hw_reg_write(ah, AR5K_PHY_ERR_FIL_OFDM, AR5K_PHYERR_CNT1_MASK);
+	ath5k_hw_reg_write(ah, AR5K_PHY_ERR_FIL_CCK, AR5K_PHYERR_CNT2_MASK);
+
+	/* not in use */
+	ath5k_hw_reg_write(ah, 0, AR5K_OFDM_FIL_CNT);
+	ath5k_hw_reg_write(ah, 0, AR5K_CCK_FIL_CNT);
+}
+
+
+/**
+ * ath5k_disable_phy_err_counters() - Disable PHY error counters
+ *
+ * Disable PHY error counters for OFDM and CCK timing errors.
+ */
+static void
+ath5k_disable_phy_err_counters(struct ath5k_hw *ah)
+{
+	ath5k_hw_reg_write(ah, 0, AR5K_PHYERR_CNT1);
+	ath5k_hw_reg_write(ah, 0, AR5K_PHYERR_CNT2);
+	ath5k_hw_reg_write(ah, 0, AR5K_PHYERR_CNT1_MASK);
+	ath5k_hw_reg_write(ah, 0, AR5K_PHYERR_CNT2_MASK);
+
+	/* not in use */
+	ath5k_hw_reg_write(ah, 0, AR5K_OFDM_FIL_CNT);
+	ath5k_hw_reg_write(ah, 0, AR5K_CCK_FIL_CNT);
+}
+
+
+/**
+ * ath5k_ani_init() - Initialize ANI
+ * @mode: Which mode to use (auto, manual high, manual low, off)
+ *
+ * Initialize ANI according to mode.
+ */
+void
+ath5k_ani_init(struct ath5k_hw *ah, enum ath5k_ani_mode mode)
+{
+	/* ANI is only possible on 5212 and newer */
+	if (ah->ah_version < AR5K_AR5212)
+		return;
+
+	/* older hardware has more spur levels than newer */
+	if (ah->ah_mac_srev < AR5K_SREV_AR2414)
+		ah->ah_sc->ani_state.max_spur_level = 7;
+	else
+		ah->ah_sc->ani_state.max_spur_level = 2;
+
+	/* initial values for our ani parameters */
+	if (mode == ATH5K_ANI_MODE_OFF) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "ANI off\n");
+	} else if  (mode == ATH5K_ANI_MODE_MANUAL_LOW) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+			"ANI manual low -> high sensitivity\n");
+		ath5k_ani_set_noise_immunity_level(ah, 0);
+		ath5k_ani_set_spur_immunity_level(ah, 0);
+		ath5k_ani_set_firstep_level(ah, 0);
+		ath5k_ani_set_ofdm_weak_signal_detection(ah, true);
+		ath5k_ani_set_cck_weak_signal_detection(ah, true);
+	} else if (mode == ATH5K_ANI_MODE_MANUAL_HIGH) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+			"ANI manual high -> low sensitivity\n");
+		ath5k_ani_set_noise_immunity_level(ah,
+					ATH5K_ANI_MAX_NOISE_IMM_LVL);
+		ath5k_ani_set_spur_immunity_level(ah,
+					ah->ah_sc->ani_state.max_spur_level);
+		ath5k_ani_set_firstep_level(ah, ATH5K_ANI_MAX_FIRSTEP_LVL);
+		ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
+		ath5k_ani_set_cck_weak_signal_detection(ah, false);
+	} else if (mode == ATH5K_ANI_MODE_AUTO) {
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "ANI auto\n");
+		ath5k_ani_set_noise_immunity_level(ah, 0);
+		ath5k_ani_set_spur_immunity_level(ah, 0);
+		ath5k_ani_set_firstep_level(ah, 0);
+		ath5k_ani_set_ofdm_weak_signal_detection(ah, true);
+		ath5k_ani_set_cck_weak_signal_detection(ah, false);
+	}
+
+	/* newer hardware has PHY error counter registers which we can use to
+	 * get OFDM and CCK error counts. older hardware has to set rxfilter and
+	 * report every single PHY error by calling ath5k_ani_phy_error_report()
+	 */
+	if (mode == ATH5K_ANI_MODE_AUTO) {
+		if (ah->ah_capabilities.cap_has_phyerr_counters)
+			ath5k_enable_phy_err_counters(ah);
+		else
+			ath5k_hw_set_rx_filter(ah, ath5k_hw_get_rx_filter(ah) |
+						   AR5K_RX_FILTER_PHYERR);
+	} else {
+		if (ah->ah_capabilities.cap_has_phyerr_counters)
+			ath5k_disable_phy_err_counters(ah);
+		else
+			ath5k_hw_set_rx_filter(ah, ath5k_hw_get_rx_filter(ah) &
+						   ~AR5K_RX_FILTER_PHYERR);
+	}
+
+	ah->ah_sc->ani_state.ani_mode = mode;
+}
+
+
+/*** DEBUG ***/
+
+#ifdef CONFIG_ATH5K_DEBUG
+
+void
+ath5k_ani_print_counters(struct ath5k_hw *ah)
+{
+	/* clears too */
+	printk(KERN_NOTICE "ACK fail\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_ACK_FAIL));
+	printk(KERN_NOTICE "RTS fail\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_RTS_FAIL));
+	printk(KERN_NOTICE "RTS success\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_RTS_OK));
+	printk(KERN_NOTICE "FCS error\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_FCS_FAIL));
+
+	/* no clear */
+	printk(KERN_NOTICE "tx\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_PROFCNT_TX));
+	printk(KERN_NOTICE "rx\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_PROFCNT_RX));
+	printk(KERN_NOTICE "busy\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_PROFCNT_RXCLR));
+	printk(KERN_NOTICE "cycles\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_PROFCNT_CYCLE));
+
+	printk(KERN_NOTICE "AR5K_PHYERR_CNT1\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT1));
+	printk(KERN_NOTICE "AR5K_PHYERR_CNT2\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT2));
+	printk(KERN_NOTICE "AR5K_OFDM_FIL_CNT\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_OFDM_FIL_CNT));
+	printk(KERN_NOTICE "AR5K_CCK_FIL_CNT\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_CCK_FIL_CNT));
+}
+
+#endif
diff --git a/drivers/net/wireless/ath/ath5k/ani.h b/drivers/net/wireless/ath/ath5k/ani.h
new file mode 100644
index 0000000..55cf26d
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/ani.h
@@ -0,0 +1,104 @@
+/*
+ * Copyright (C) 2010 Bruno Randolf <br1@einfach.org>
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
+#ifndef ANI_H
+#define ANI_H
+
+/* these thresholds are relative to the ATH5K_ANI_LISTEN_PERIOD */
+#define ATH5K_ANI_LISTEN_PERIOD		100
+#define ATH5K_ANI_OFDM_TRIG_HIGH	500
+#define ATH5K_ANI_OFDM_TRIG_LOW		200
+#define ATH5K_ANI_CCK_TRIG_HIGH		200
+#define ATH5K_ANI_CCK_TRIG_LOW		100
+
+/* average beacon RSSI thresholds */
+#define ATH5K_ANI_RSSI_THR_HIGH		40
+#define ATH5K_ANI_RSSI_THR_LOW		7
+
+/* maximum availabe levels */
+#define ATH5K_ANI_MAX_FIRSTEP_LVL	2
+#define ATH5K_ANI_MAX_NOISE_IMM_LVL	1
+
+
+/**
+ * enum ath5k_ani_mode - mode for ANI / noise sensitivity
+ *
+ * @ATH5K_ANI_MODE_OFF: Turn ANI off. This can be useful to just stop the ANI
+ *	algorithm after it has been on auto mode.
+ * ATH5K_ANI_MODE_MANUAL_LOW: Manually set all immunity parameters to low,
+ *	maximizing sensitivity. ANI will not run.
+ * ATH5K_ANI_MODE_MANUAL_HIGH: Manually set all immunity parameters to high,
+ *	minimizing sensitivity. ANI will not run.
+ * ATH5K_ANI_MODE_AUTO: Automatically control immunity parameters based on the
+ *	amount of OFDM and CCK frame errors (default).
+ */
+enum ath5k_ani_mode {
+	ATH5K_ANI_MODE_OFF		= 0,
+	ATH5K_ANI_MODE_MANUAL_LOW	= 1,
+	ATH5K_ANI_MODE_MANUAL_HIGH	= 2,
+	ATH5K_ANI_MODE_AUTO		= 3
+};
+
+
+/**
+ * struct ath5k_ani_state - ANI state and associated counters
+ *
+ * @max_spur_level: the maximum spur level is chip dependent
+ */
+struct ath5k_ani_state {
+	enum ath5k_ani_mode	ani_mode;
+
+	/* state */
+	int			noise_imm_level;
+	int			spur_level;
+	int			firstep_level;
+	bool			ofdm_weak_sig;
+	bool			cck_weak_sig;
+
+	int			max_spur_level;
+
+	/* used by the algorithm */
+	unsigned int		listen_time;
+	unsigned int		ofdm_errors;
+	unsigned int		cck_errors;
+
+	/* debug/statistics only: numbers from last ANI calibration */
+	unsigned int		pfc_tx;
+	unsigned int		pfc_rx;
+	unsigned int		pfc_busy;
+	unsigned int		pfc_cycles;
+	unsigned int		last_listen;
+	unsigned int		last_ofdm_errors;
+	unsigned int		last_cck_errors;
+	unsigned int		sum_ofdm_errors;
+	unsigned int		sum_cck_errors;
+};
+
+void ath5k_ani_init(struct ath5k_hw *ah, enum ath5k_ani_mode mode);
+void ath5k_ani_mib_intr(struct ath5k_hw *ah);
+void ath5k_ani_calibration(struct ath5k_hw *ah);
+void ath5k_ani_phy_error_report(struct ath5k_hw *ah,
+				enum ath5k_phy_error_code phyerr);
+
+/* for manual control */
+void ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level);
+void ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level);
+void ath5k_ani_set_firstep_level(struct ath5k_hw *ah, int level);
+void ath5k_ani_set_ofdm_weak_signal_detection(struct ath5k_hw *ah, bool on);
+void ath5k_ani_set_cck_weak_signal_detection(struct ath5k_hw *ah, bool on);
+
+void ath5k_ani_print_counters(struct ath5k_hw *ah);
+
+#endif /* ANI_H */
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index f578c1e..2785946 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -203,6 +203,7 @@
 #define AR5K_TUNE_DEFAULT_TXPOWER		25
 #define AR5K_TUNE_TPC_TXPOWER			false
 #define ATH5K_TUNE_CALIBRATION_INTERVAL_FULL    10000   /* 10 sec */
+#define ATH5K_TUNE_CALIBRATION_INTERVAL_ANI	1000	/* 1 sec */
 
 #define AR5K_INIT_CARR_SENSE_EN			1
 
@@ -800,9 +801,9 @@ struct ath5k_athchan_2ghz {
  * @AR5K_INT_TXURN: received when we should increase the TX trigger threshold
  * 	We currently do increments on interrupt by
  * 	(AR5K_TUNE_MAX_TX_FIFO_THRES - current_trigger_level) / 2
- * @AR5K_INT_MIB: Indicates the Management Information Base counters should be
- * 	checked. We should do this with ath5k_hw_update_mib_counters() but
- * 	it seems we should also then do some noise immunity work.
+ * @AR5K_INT_MIB: Indicates the either Management Information Base counters or
+ *	one of the PHY error counters reached the maximum value and should be
+ *	read and cleared.
  * @AR5K_INT_RXPHY: RX PHY Error
  * @AR5K_INT_RXKCM: RX Key cache miss
  * @AR5K_INT_SWBA: SoftWare Beacon Alert - indicates its time to send a
@@ -894,6 +895,7 @@ enum ath5k_int {
 enum ath5k_calibration_mask {
 	AR5K_CALIBRATION_FULL = 0x01,
 	AR5K_CALIBRATION_SHORT = 0x02,
+	AR5K_CALIBRATION_ANI = 0x04,
 };
 
 /*
@@ -1115,6 +1117,7 @@ struct ath5k_hw {
 
 	/* Calibration timestamp */
 	unsigned long		ah_cal_next_full;
+	unsigned long		ah_cal_next_ani;
 
 	/* Calibration mask */
 	u8			ah_cal_mask;
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index f80d3d5..dcf7c30 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -124,6 +124,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	ah->ah_software_retry = false;
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
 	ah->ah_noise_floor = -95;	/* until first NF calibration is run */
+	sc->ani_state.ani_mode = ATH5K_ANI_MODE_AUTO;
 
 	/*
 	 * Find the mac version
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a1c0dcb..c085a06 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -58,6 +58,7 @@
 #include "base.h"
 #include "reg.h"
 #include "debug.h"
+#include "ani.h"
 
 static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
@@ -363,6 +364,7 @@ static void 	ath5k_beacon_send(struct ath5k_softc *sc);
 static void 	ath5k_beacon_config(struct ath5k_softc *sc);
 static void	ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
 static void	ath5k_tasklet_beacon(unsigned long data);
+static void	ath5k_tasklet_ani(unsigned long data);
 
 static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 {
@@ -828,6 +830,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long)sc);
 	tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned long)sc);
 	tasklet_init(&sc->beacontq, ath5k_tasklet_beacon, (unsigned long)sc);
+	tasklet_init(&sc->ani_tasklet, ath5k_tasklet_ani, (unsigned long)sc);
 
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
@@ -2530,7 +2533,8 @@ ath5k_init(struct ath5k_softc *sc)
 	sc->curband = &sc->sbands[sc->curchan->band];
 	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
-		AR5K_INT_FATAL | AR5K_INT_GLOBAL;
+		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
+
 	ret = ath5k_reset(sc, NULL);
 	if (ret)
 		goto done;
@@ -2642,6 +2646,7 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	tasklet_kill(&sc->restq);
 	tasklet_kill(&sc->calib);
 	tasklet_kill(&sc->beacontq);
+	tasklet_kill(&sc->ani_tasklet);
 
 	ath5k_rfkill_hw_stop(sc->ah);
 
@@ -2651,7 +2656,14 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 static void
 ath5k_intr_calibration_poll(struct ath5k_hw *ah)
 {
-	if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
+	if (time_is_before_eq_jiffies(ah->ah_cal_next_ani) &&
+	    !(ah->ah_cal_mask & AR5K_CALIBRATION_FULL)) {
+		/* run ANI only when full calibration is not active */
+		ah->ah_cal_next_ani = jiffies +
+			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_ANI);
+		tasklet_schedule(&ah->ah_sc->ani_tasklet);
+
+	} else if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
 		ah->ah_cal_next_full = jiffies +
 			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
 		tasklet_schedule(&ah->ah_sc->calib);
@@ -2710,7 +2722,9 @@ ath5k_intr(int irq, void *dev_id)
 				/* TODO */
 			}
 			if (status & AR5K_INT_MIB) {
+				sc->stats.mib_intr++;
 				ath5k_hw_update_mib_counters(ah);
+				ath5k_ani_mib_intr(ah);
 			}
 			if (status & AR5K_INT_GPIO)
 				tasklet_schedule(&sc->rf_kill.toggleq);
@@ -2775,6 +2789,18 @@ ath5k_tasklet_calibrate(unsigned long data)
 }
 
 
+static void
+ath5k_tasklet_ani(unsigned long data)
+{
+	struct ath5k_softc *sc = (void *)data;
+	struct ath5k_hw *ah = sc->ah;
+
+	ah->ah_cal_mask |= AR5K_CALIBRATION_ANI;
+	ath5k_ani_calibration(ah);
+	ah->ah_cal_mask &= ~AR5K_CALIBRATION_ANI;
+}
+
+
 /********************\
 * Mac80211 functions *
 \********************/
@@ -2874,6 +2900,8 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		goto err;
 	}
 
+	ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
+
 	/*
 	 * Change channels and update the h/w rate map if we're switching;
 	 * e.g. 11a to 11b/g.
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index a572a48..53a5651 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -50,6 +50,7 @@
 
 #include "ath5k.h"
 #include "debug.h"
+#include "ani.h"
 
 #include "../regd.h"
 #include "../ath.h"
@@ -132,6 +133,8 @@ struct ath5k_statistics {
 	unsigned int rts_ok;
 	unsigned int fcs_error;
 	unsigned int beacons;
+
+	unsigned int mib_intr;
 };
 
 #if CHAN_DEBUG
@@ -221,6 +224,9 @@ struct ath5k_softc {
 	bool			enable_beacon;	/* true if beacons are on */
 
 	struct ath5k_statistics	stats;
+
+	struct ath5k_ani_state	ani_state;
+	struct tasklet_struct	ani_tasklet;	/* ANI calibration */
 };
 
 #define ath5k_hw_hasbssidmask(_ah) \
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 90247dc..946a7e3 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -69,6 +69,7 @@ module_param_named(debug, ath5k_debug, uint, 0);
 
 #include <linux/seq_file.h>
 #include "reg.h"
+#include "ani.h"
 
 static struct dentry *ath5k_global_debugfs;
 
@@ -307,6 +308,7 @@ static const struct {
 	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
 	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
 	{ ATH5K_DEBUG_TRACE,	"trace",	"trace function calls" },
+	{ ATH5K_DEBUG_ANI,	"ani",		"adaptive noise immunity" },
 	{ ATH5K_DEBUG_ANY,	"all",		"show all debug levels" },
 };
 
@@ -573,6 +575,160 @@ static const struct file_operations fops_frameerrors = {
 };
 
 
+/* debugfs: ani */
+
+static ssize_t read_file_ani(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_statistics *st = &sc->stats;
+	struct ath5k_ani_state *as = &sc->ani_state;
+
+	char buf[700];
+	unsigned int len = 0;
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"HW has PHY error counters:\t%s\n",
+			sc->ah->ah_capabilities.cap_has_phyerr_counters ?
+			"yes" : "no");
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"HW max spur immunity level:\t%d\n",
+			as->max_spur_level);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"\nANI state\n--------------------------------------------\n");
+	len += snprintf(buf+len, sizeof(buf)-len, "operating mode:\t\t\t");
+	switch (as->ani_mode) {
+	case ATH5K_ANI_MODE_OFF:
+		len += snprintf(buf+len, sizeof(buf)-len, "OFF\n");
+		break;
+	case ATH5K_ANI_MODE_MANUAL_LOW:
+		len += snprintf(buf+len, sizeof(buf)-len,
+			"MANUAL LOW\n");
+		break;
+	case ATH5K_ANI_MODE_MANUAL_HIGH:
+		len += snprintf(buf+len, sizeof(buf)-len,
+			"MANUAL HIGH\n");
+		break;
+	case ATH5K_ANI_MODE_AUTO:
+		len += snprintf(buf+len, sizeof(buf)-len, "AUTO\n");
+		break;
+	default:
+		len += snprintf(buf+len, sizeof(buf)-len,
+			"??? (not good)\n");
+		break;
+	}
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"noise immunity level:\t\t%d\n",
+			as->noise_imm_level);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"spur immunity level:\t\t%d\n",
+			as->spur_level);
+	len += snprintf(buf+len, sizeof(buf)-len, "firstep level:\t\t\t%d\n",
+			as->firstep_level);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"OFDM weak signal detection:\t%s\n",
+			as->ofdm_weak_sig ? "on" : "off");
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"CCK weak signal detection:\t%s\n",
+			as->cck_weak_sig ? "on" : "off");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"\nMIB INTERRUPTS:\t\t%u\n",
+			st->mib_intr);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"beacon RSSI average:\t%d\n",
+			sc->ah->ah_beacon_rssi_avg.avg);
+	len += snprintf(buf+len, sizeof(buf)-len, "profcnt tx\t\t%u\t(%d%%)\n",
+			as->pfc_tx,
+			as->pfc_cycles > 0 ?
+			as->pfc_tx*100/as->pfc_cycles : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "profcnt rx\t\t%u\t(%d%%)\n",
+			as->pfc_rx,
+			as->pfc_cycles > 0 ?
+			as->pfc_rx*100/as->pfc_cycles : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "profcnt busy\t\t%u\t(%d%%)\n",
+			as->pfc_busy,
+			as->pfc_cycles > 0 ?
+			as->pfc_busy*100/as->pfc_cycles : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "profcnt cycles\t\t%u\n",
+			as->pfc_cycles);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"listen time\t\t%d\tlast: %d\n",
+			as->listen_time, as->last_listen);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"OFDM errors\t\t%u\tlast: %u\tsum: %u\n",
+			as->ofdm_errors, as->last_ofdm_errors,
+			as->sum_ofdm_errors);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"CCK errors\t\t%u\tlast: %u\tsum: %u\n",
+			as->cck_errors, as->last_cck_errors,
+			as->sum_cck_errors);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"AR5K_PHYERR_CNT1\t%x\t(=%d)\n",
+			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT1),
+			ATH5K_ANI_OFDM_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX -
+			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT1)));
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"AR5K_PHYERR_CNT2\t%x\t(=%d)\n",
+			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT2),
+			ATH5K_ANI_CCK_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX -
+			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT2)));
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_ani(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	char buf[20];
+
+	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+		return -EFAULT;
+
+	if (strncmp(buf, "sens-low", 8) == 0) {
+		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_MANUAL_HIGH);
+	} else if (strncmp(buf, "sens-high", 9) == 0) {
+		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_MANUAL_LOW);
+	} else if (strncmp(buf, "ani-off", 7) == 0) {
+		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_OFF);
+	} else if (strncmp(buf, "ani-on", 6) == 0) {
+		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_AUTO);
+	} else if (strncmp(buf, "noise-low", 8) == 0) {
+		ath5k_ani_set_noise_immunity_level(sc->ah, 0);
+	} else if (strncmp(buf, "noise-high", 9) == 0) {
+		ath5k_ani_set_noise_immunity_level(sc->ah,
+						   ATH5K_ANI_MAX_NOISE_IMM_LVL);
+	} else if (strncmp(buf, "spur-low", 8) == 0) {
+		ath5k_ani_set_spur_immunity_level(sc->ah, 0);
+	} else if (strncmp(buf, "spur-high", 9) == 0) {
+		ath5k_ani_set_spur_immunity_level(sc->ah,
+						  sc->ani_state.max_spur_level);
+	} else if (strncmp(buf, "fir-low", 7) == 0) {
+		ath5k_ani_set_firstep_level(sc->ah, 0);
+	} else if (strncmp(buf, "fir-high", 8) == 0) {
+		ath5k_ani_set_firstep_level(sc->ah, ATH5K_ANI_MAX_FIRSTEP_LVL);
+	} else if (strncmp(buf, "ofdm-off", 8) == 0) {
+		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, false);
+	} else if (strncmp(buf, "ofdm-on", 7) == 0) {
+		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, true);
+	} else if (strncmp(buf, "cck-off", 7) == 0) {
+		ath5k_ani_set_cck_weak_signal_detection(sc->ah, false);
+	} else if (strncmp(buf, "cck-on", 6) == 0) {
+		ath5k_ani_set_cck_weak_signal_detection(sc->ah, true);
+	}
+	return count;
+}
+
+static const struct file_operations fops_ani = {
+	.read = read_file_ani,
+	.write = write_file_ani,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+
 /* init */
 
 void
@@ -611,6 +767,11 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 				S_IWUSR | S_IRUSR,
 				sc->debug.debugfs_phydir, sc,
 				&fops_frameerrors);
+
+	sc->debug.debugfs_ani = debugfs_create_file("ani",
+				S_IWUSR | S_IRUSR,
+				sc->debug.debugfs_phydir, sc,
+				&fops_ani);
 }
 
 void
@@ -628,6 +789,7 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 	debugfs_remove(sc->debug.debugfs_reset);
 	debugfs_remove(sc->debug.debugfs_antenna);
 	debugfs_remove(sc->debug.debugfs_frameerrors);
+	debugfs_remove(sc->debug.debugfs_ani);
 	debugfs_remove(sc->debug.debugfs_phydir);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index da24ff5..ddd5b3a 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -76,6 +76,7 @@ struct ath5k_dbg_info {
 	struct dentry		*debugfs_reset;
 	struct dentry		*debugfs_antenna;
 	struct dentry		*debugfs_frameerrors;
+	struct dentry		*debugfs_ani;
 };
 
 /**
@@ -115,6 +116,7 @@ enum ath5k_debug_level {
 	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
 	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
 	ATH5K_DEBUG_TRACE	= 0x00001000,
+	ATH5K_DEBUG_ANI		= 0x00002000,
 	ATH5K_DEBUG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 9d920fb..7d7b646 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -645,6 +645,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 			rs->rs_status |= AR5K_RXERR_PHY;
 			rs->rs_phyerr |= AR5K_REG_MS(rx_err->rx_error_1,
 					   AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);
+			ath5k_ani_phy_error_report(ah, rs->rs_phyerr);
 		}
 
 		if (rx_status->rx_status_1 &
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index c7c1fe0..710870e 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -379,7 +379,6 @@ void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
  * (ACK etc).
  *
  * NOTE: RX DMA should be already enabled using ath5k_hw_start_rx_dma
- * TODO: Init ANI here
  */
 void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 47f0493..45d62e9 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -212,10 +212,10 @@
  * MIB control register
  */
 #define AR5K_MIBC		0x0040			/* Register Address */
-#define AR5K_MIBC_COW		0x00000001	/* Warn test indicator */
+#define AR5K_MIBC_COW		0x00000001	/* Counter Overflow Warning */
 #define AR5K_MIBC_FMC		0x00000002	/* Freeze MIB Counters  */
-#define AR5K_MIBC_CMC		0x00000004	/* Clean MIB Counters  */
-#define AR5K_MIBC_MCS		0x00000008	/* MIB counter strobe */
+#define AR5K_MIBC_CMC		0x00000004	/* Clear MIB Counters  */
+#define AR5K_MIBC_MCS		0x00000008	/* MIB counter strobe, increment all */
 
 /*
  * Timeout prescale register
@@ -1516,7 +1516,14 @@
 				AR5K_NAV_5210 : AR5K_NAV_5211)
 
 /*
- * RTS success register
+ * MIB counters:
+ *
+ * max value is 0xc000, if this is reached we get a MIB interrupt.
+ * they can be controlled via AR5K_MIBC and are cleared on read.
+ */
+
+/*
+ * RTS success (MIB counter)
  */
 #define AR5K_RTS_OK_5210	0x8090
 #define AR5K_RTS_OK_5211	0x8088
@@ -1524,7 +1531,7 @@
 				AR5K_RTS_OK_5210 : AR5K_RTS_OK_5211)
 
 /*
- * RTS failure register
+ * RTS failure (MIB counter)
  */
 #define AR5K_RTS_FAIL_5210	0x8094
 #define AR5K_RTS_FAIL_5211	0x808c
@@ -1532,7 +1539,7 @@
 				AR5K_RTS_FAIL_5210 : AR5K_RTS_FAIL_5211)
 
 /*
- * ACK failure register
+ * ACK failure (MIB counter)
  */
 #define AR5K_ACK_FAIL_5210	0x8098
 #define AR5K_ACK_FAIL_5211	0x8090
@@ -1540,7 +1547,7 @@
 				AR5K_ACK_FAIL_5210 : AR5K_ACK_FAIL_5211)
 
 /*
- * FCS failure register
+ * FCS failure (MIB counter)
  */
 #define AR5K_FCS_FAIL_5210	0x809c
 #define AR5K_FCS_FAIL_5211	0x8094
@@ -1667,11 +1674,17 @@
 
 /*
  * Profile count registers
+ *
+ * These registers can be cleared and freezed with ATH5K_MIBC, but they do not
+ * generate a MIB interrupt.
+ * Instead of overflowing, they shift by one bit to the right. All registers
+ * shift together, i.e. when one reaches the max, all shift at the same time by
+ * one bit to the right. This way we should always get consistent values.
  */
 #define AR5K_PROFCNT_TX			0x80ec	/* Tx count */
 #define AR5K_PROFCNT_RX			0x80f0	/* Rx count */
-#define AR5K_PROFCNT_RXCLR		0x80f4	/* Clear Rx count */
-#define AR5K_PROFCNT_CYCLE		0x80f8	/* Cycle count (?) */
+#define AR5K_PROFCNT_RXCLR		0x80f4	/* Busy count */
+#define AR5K_PROFCNT_CYCLE		0x80f8	/* Cycle counter */
 
 /*
  * Quiet period control registers
@@ -1758,7 +1771,7 @@
 #define	AR5K_CCK_FIL_CNT		0x8128
 
 /*
- * PHY Error Counters (?)
+ * PHY Error Counters (same masks as AR5K_PHY_ERR_FIL)
  */
 #define	AR5K_PHYERR_CNT1		0x812c
 #define	AR5K_PHYERR_CNT1_MASK		0x8130
@@ -1766,6 +1779,9 @@
 #define	AR5K_PHYERR_CNT2		0x8134
 #define	AR5K_PHYERR_CNT2_MASK		0x8138
 
+/* if the PHY Error Counters reach this maximum, we get MIB interrupts */
+#define ATH5K_PHYERR_CNT_MAX		0x00c00000
+
 /*
  * TSF Threshold register (?)
  */

