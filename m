Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:22589 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932620Ab0I0DWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Sep 2010 23:22:23 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0205217741
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:22:21 +0900 (JST)
Subject: [PATCH 2/4] ath5k: Check and fix ATIM window
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Sep 2010 12:22:21 +0900
Message-ID: <20100927032221.8754.60783.stgit@tt-desk>
In-Reply-To: <20100927032211.8754.49870.stgit@tt-desk>
References: <20100927032211.8754.49870.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds sanity-checks for the beacon timers and especially the ATIM
window to ath5k. It is basically the same what i did for madwifi two years ago
and fixes a problem in IBSS mode which has been described as "ramping" pings.

See the code comments for a more detailed description and these links:

http://madwifi-project.org/ticket/1154
http://madwifi-project.org/changeset/3867
http://thread.gmane.org/gmane.linux.drivers.madwifi.devel/6066

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 
 drivers/net/wireless/ath/ath5k/base.c  |    9 +++
 drivers/net/wireless/ath/ath5k/pcu.c   |   91 ++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 42e6e82..0cba2e3 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1195,6 +1195,7 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
 void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
 void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
 void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
+bool ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval);
 /* ACK bit rate */
 void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
 /* Clock rate related functions */
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 95072db..4103765 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1191,6 +1191,15 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 		 */
 		if (hw_tu >= sc->nexttbtt)
 			ath5k_beacon_update_timers(sc, bc_tstamp);
+
+		/* Check if the beacon timers are still correct, because a TSF
+		 * update might have created a window between them - for a
+		 * longer description see the comment of this function: */
+		if (!ath5k_hw_check_beacon_timers(sc->ah, sc->bintval)) {
+			ath5k_beacon_update_timers(sc, bc_tstamp);
+			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+				"fixed beacon timers after beacon receive\n");
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 71dca10..604114f 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -641,6 +641,97 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 }
 
 /**
+ * ath5k_check_timer_win - Check if timer B is timer A + window
+ *
+ * @a: timer a (before b)
+ * @b: timer b (after a)
+ * @window: difference between a and b
+ * @intval: timers are increased by this interval
+ *
+ * This helper function checks if timer B is timer A + window and covers
+ * cases where timer A or B might have already been updated or wrapped
+ * around (Timers are 16 bit).
+ *
+ * Returns true if O.K.
+ */
+static inline bool
+ath5k_check_timer_win(int a, int b, int window, int intval)
+{
+	/*
+	 * 1.) usually B should be A + window
+	 * 2.) A already updated, B not updated yet
+	 * 3.) A already updated and has wrapped around
+	 * 4.) B has wrapped around
+	 */
+	if ((b - a == window) ||				/* 1.) */
+	    (a - b == intval - window) ||			/* 2.) */
+	    ((a | 0x10000) - b == intval - window) ||		/* 3.) */
+	    ((b | 0x10000) - a == window))			/* 4.) */
+		return true; /* O.K. */
+	return false;
+}
+
+/**
+ * ath5k_hw_check_beacon_timers - Check if the beacon timers are correct
+ *
+ * @ah: The &struct ath5k_hw
+ * @intval: beacon interval
+ *
+ * This is a workaround for IBSS mode:
+ *
+ * The need for this function arises from the fact that we have 4 separate
+ * HW timer registers (TIMER0 - TIMER3), which are closely related to the
+ * next beacon target time (NBTT), and that the HW updates these timers
+ * seperately based on the current TSF value. The hardware increments each
+ * timer by the beacon interval, when the local TSF coverted to TU is equal
+ * to the value stored in the timer.
+ *
+ * The reception of a beacon with the same BSSID can update the local HW TSF
+ * at any time - this is something we can't avoid. If the TSF jumps to a
+ * time which is later than the time stored in a timer, this timer will not
+ * be updated until the TSF in TU wraps around at 16 bit (the size of the
+ * timers) and reaches the time which is stored in the timer.
+ *
+ * The problem is that these timers are closely related to TIMER0 (NBTT) and
+ * that they define a time "window". When the TSF jumps between two timers
+ * (e.g. ATIM and NBTT), the one in the past will be left behind (not
+ * updated), while the one in the future will be updated every beacon
+ * interval. This causes the window to get larger, until the TSF wraps
+ * around as described above and the timer which was left behind gets
+ * updated again. But - because the beacon interval is usually not an exact
+ * divisor of the size of the timers (16 bit), an unwanted "window" between
+ * these timers has developed!
+ *
+ * This is especially important with the ATIM window, because during
+ * the ATIM window only ATIM frames and no data frames are allowed to be
+ * sent, which creates transmission pauses after each beacon. This symptom
+ * has been described as "ramping ping" because ping times increase linearly
+ * for some time and then drop down again. A wrong window on the DMA beacon
+ * timer has the same effect, so we check for these two conditions.
+ *
+ * Returns true if O.K.
+ */
+bool
+ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval)
+{
+	unsigned int nbtt, atim, dma;
+
+	nbtt = ath5k_hw_reg_read(ah, AR5K_TIMER0);
+	atim = ath5k_hw_reg_read(ah, AR5K_TIMER3);
+	dma = ath5k_hw_reg_read(ah, AR5K_TIMER1) >> 3;
+
+	/* NOTE: SWBA is different. Having a wrong window there does not
+	 * stop us from sending data and this condition is catched thru
+	 * other means (SWBA interrupt) */
+
+	if (ath5k_check_timer_win(nbtt, atim, 1, intval) &&
+	    ath5k_check_timer_win(dma, nbtt, AR5K_TUNE_DMA_BEACON_RESP,
+				  intval))
+		return true; /* O.K. */
+	return false;
+}
+
+/**
  * ath5k_hw_set_coverage_class - Set IEEE 802.11 coverage class
  *
  * @ah: The &struct ath5k_hw

