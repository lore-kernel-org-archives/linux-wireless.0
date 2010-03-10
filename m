Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37367 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab0CJQPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 11:15:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, mickflemm@gmail.com, proski@gnu.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] ath5k: remove unused beacon timer code
Date: Wed, 10 Mar 2010 11:08:50 -0500
Message-Id: <1268237330-30013-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1268237330-30013-2-git-send-email-linville@tuxdriver.com>
References: <1268237330-30013-1-git-send-email-linville@tuxdriver.com>
 <1268237330-30013-2-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   28 -----
 drivers/net/wireless/ath/ath5k/pcu.c   |  197 --------------------------------
 2 files changed, 0 insertions(+), 225 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 4de7fe0..3e77332 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -614,28 +614,6 @@ struct ath5k_rx_status {
 #define AR5K_BEACON_ENA		0x00800000 /*enable beacon xmit*/
 #define AR5K_BEACON_RESET_TSF	0x01000000 /*force a TSF reset*/
 
-#if 0
-/**
- * struct ath5k_beacon_state - Per-station beacon timer state.
- * @bs_interval: in TU's, can also include the above flags
- * @bs_cfp_max_duration: if non-zero hw is setup to coexist with a
- * 	Point Coordination Function capable AP
- */
-struct ath5k_beacon_state {
-	u32	bs_next_beacon;
-	u32	bs_next_dtim;
-	u32	bs_interval;
-	u8	bs_dtim_period;
-	u8	bs_cfp_period;
-	u16	bs_cfp_max_duration;
-	u16	bs_cfp_du_remain;
-	u16	bs_tim_offset;
-	u16	bs_sleep_duration;
-	u16	bs_bmiss_threshold;
-	u32  	bs_cfp_next;
-};
-#endif
-
 
 /*
  * TSF to TU conversion:
@@ -1218,12 +1196,6 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
 void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
 void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
 void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
-#if 0
-int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
-			       const struct ath5k_beacon_state *state);
-void ath5k_hw_reset_beacon(struct ath5k_hw *ah);
-int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr);
-#endif
 /* ACK bit rate */
 void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
 /* Clock rate related functions */
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 8eaa5d6..8f95189 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -648,203 +648,6 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 
 }
 
-#if 0
-/*
- * Set beacon timers
- */
-int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
-		const struct ath5k_beacon_state *state)
-{
-	u32 cfp_period, next_cfp, dtim, interval, next_beacon;
-
-	/*
-	 * TODO: should be changed through *state
-	 * review struct ath5k_beacon_state struct
-	 *
-	 * XXX: These are used for cfp period bellow, are they
-	 * ok ? Is it O.K. for tsf here to be 0 or should we use
-	 * get_tsf ?
-	 */
-	u32 dtim_count = 0; /* XXX */
-	u32 cfp_count = 0; /* XXX */
-	u32 tsf = 0; /* XXX */
-
-	ATH5K_TRACE(ah->ah_sc);
-	/* Return on an invalid beacon state */
-	if (state->bs_interval < 1)
-		return -EINVAL;
-
-	interval = state->bs_interval;
-	dtim = state->bs_dtim_period;
-
-	/*
-	 * PCF support?
-	 */
-	if (state->bs_cfp_period > 0) {
-		/*
-		 * Enable PCF mode and set the CFP
-		 * (Contention Free Period) and timer registers
-		 */
-		cfp_period = state->bs_cfp_period * state->bs_dtim_period *
-			state->bs_interval;
-		next_cfp = (cfp_count * state->bs_dtim_period + dtim_count) *
-			state->bs_interval;
-
-		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
-				AR5K_STA_ID1_DEFAULT_ANTENNA |
-				AR5K_STA_ID1_PCF);
-		ath5k_hw_reg_write(ah, cfp_period, AR5K_CFP_PERIOD);
-		ath5k_hw_reg_write(ah, state->bs_cfp_max_duration,
-				AR5K_CFP_DUR);
-		ath5k_hw_reg_write(ah, (tsf + (next_cfp == 0 ? cfp_period :
-						next_cfp)) << 3, AR5K_TIMER2);
-	} else {
-		/* Disable PCF mode */
-		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
-				AR5K_STA_ID1_DEFAULT_ANTENNA |
-				AR5K_STA_ID1_PCF);
-	}
-
-	/*
-	 * Enable the beacon timer register
-	 */
-	ath5k_hw_reg_write(ah, state->bs_next_beacon, AR5K_TIMER0);
-
-	/*
-	 * Start the beacon timers
-	 */
-	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_BEACON) &
-		~(AR5K_BEACON_PERIOD | AR5K_BEACON_TIM)) |
-		AR5K_REG_SM(state->bs_tim_offset ? state->bs_tim_offset + 4 : 0,
-		AR5K_BEACON_TIM) | AR5K_REG_SM(state->bs_interval,
-		AR5K_BEACON_PERIOD), AR5K_BEACON);
-
-	/*
-	 * Write new beacon miss threshold, if it appears to be valid
-	 * XXX: Figure out right values for min <= bs_bmiss_threshold <= max
-	 * and return if its not in range. We can test this by reading value and
-	 * setting value to a largest value and seeing which values register.
-	 */
-
-	AR5K_REG_WRITE_BITS(ah, AR5K_RSSI_THR, AR5K_RSSI_THR_BMISS,
-			state->bs_bmiss_threshold);
-
-	/*
-	 * Set sleep control register
-	 * XXX: Didn't find this in 5210 code but since this register
-	 * exists also in ar5k's 5210 headers i leave it as common code.
-	 */
-	AR5K_REG_WRITE_BITS(ah, AR5K_SLEEP_CTL, AR5K_SLEEP_CTL_SLDUR,
-			(state->bs_sleep_duration - 3) << 3);
-
-	/*
-	 * Set enhanced sleep registers on 5212
-	 */
-	if (ah->ah_version == AR5K_AR5212) {
-		if (state->bs_sleep_duration > state->bs_interval &&
-				roundup(state->bs_sleep_duration, interval) ==
-				state->bs_sleep_duration)
-			interval = state->bs_sleep_duration;
-
-		if (state->bs_sleep_duration > dtim && (dtim == 0 ||
-				roundup(state->bs_sleep_duration, dtim) ==
-				state->bs_sleep_duration))
-			dtim = state->bs_sleep_duration;
-
-		if (interval > dtim)
-			return -EINVAL;
-
-		next_beacon = interval == dtim ? state->bs_next_dtim :
-			state->bs_next_beacon;
-
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM((state->bs_next_dtim - 3) << 3,
-			AR5K_SLEEP0_NEXT_DTIM) |
-			AR5K_REG_SM(10, AR5K_SLEEP0_CABTO) |
-			AR5K_SLEEP0_ENH_SLEEP_EN |
-			AR5K_SLEEP0_ASSUME_DTIM, AR5K_SLEEP0);
-
-		ath5k_hw_reg_write(ah, AR5K_REG_SM((next_beacon - 3) << 3,
-			AR5K_SLEEP1_NEXT_TIM) |
-			AR5K_REG_SM(10, AR5K_SLEEP1_BEACON_TO), AR5K_SLEEP1);
-
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(interval, AR5K_SLEEP2_TIM_PER) |
-			AR5K_REG_SM(dtim, AR5K_SLEEP2_DTIM_PER), AR5K_SLEEP2);
-	}
-
-	return 0;
-}
-
-/*
- * Reset beacon timers
- */
-void ath5k_hw_reset_beacon(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	/*
-	 * Disable beacon timer
-	 */
-	ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
-
-	/*
-	 * Disable some beacon register values
-	 */
-	AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
-			AR5K_STA_ID1_DEFAULT_ANTENNA | AR5K_STA_ID1_PCF);
-	ath5k_hw_reg_write(ah, AR5K_BEACON_PERIOD, AR5K_BEACON);
-}
-
-/*
- * Wait for beacon queue to finish
- */
-int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
-{
-	unsigned int i;
-	int ret;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/* 5210 doesn't have QCU*/
-	if (ah->ah_version == AR5K_AR5210) {
-		/*
-		 * Wait for beaconn queue to finish by checking
-		 * Control Register and Beacon Status Register.
-		 */
-		for (i = AR5K_TUNE_BEACON_INTERVAL / 2; i > 0; i--) {
-			if (!(ath5k_hw_reg_read(ah, AR5K_BSR) & AR5K_BSR_TXQ1F)
-					||
-			    !(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_BSR_TXQ1F))
-				break;
-			udelay(10);
-		}
-
-		/* Timeout... */
-		if (i <= 0) {
-			/*
-			 * Re-schedule the beacon queue
-			 */
-			ath5k_hw_reg_write(ah, phys_addr, AR5K_NOQCU_TXDP1);
-			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
-					AR5K_BCR);
-
-			return -EIO;
-		}
-		ret = 0;
-	} else {
-	/*5211/5212*/
-		ret = ath5k_hw_register_timeout(ah,
-			AR5K_QUEUE_STATUS(AR5K_TX_QUEUE_ID_BEACON),
-			AR5K_QCU_STS_FRMPENDCNT, 0, false);
-
-		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
-			return -EIO;
-	}
-
-	return ret;
-}
-#endif
-
 
 /*********************\
 * Key table functions *
-- 
1.6.2.5

