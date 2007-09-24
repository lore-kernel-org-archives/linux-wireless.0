Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47684 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbXIXSk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 14:40:27 -0400
Message-id: <31460273016629243@pripojeni.net>
In-reply-to: <2595810412809010611@pripojeni.net>
Subject: [PATCH 3/3 try 3] Net: ath5k, use int as retval
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <mcgrof@gmail.com>
Date: Mon, 24 Sep 2007 14:40:27 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k, use int as retval

Changes-licensed-under: ISC
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>

---
commit beb56ba7270e1bf4e2f5a5e69195b082b2a14f29
tree 4232ba30c9392ed8c10c85e1b567502fb0b3780a
parent bb9a4a146644d5b50ae0ab8c3fc57304064c57c2
author Jiri Slaby <jirislaby@gmail.com> Mon, 24 Sep 2007 20:35:08 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 24 Sep 2007 20:35:08 +0200

 drivers/net/wireless/ath5k/ath5k.h      |   27 ++---
 drivers/net/wireless/ath5k/ath5k_base.c |    2 
 drivers/net/wireless/ath5k/ath5k_hw.c   |  169 ++++++++++++++-----------------
 3 files changed, 91 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index b069f45..69e2efe 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -979,10 +979,10 @@ extern int ath5k_hw_stop_rx_dma(struct ath_hw *hal);
 extern u32 ath5k_hw_get_rx_buf(struct ath_hw *hal);
 extern void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr);
 extern int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue);
-extern bool ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
+extern int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
 extern u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue);
 extern int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr);
-extern bool ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
+extern int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
 /* Interrupt handling */
 extern bool ath5k_hw_is_intr_pending(struct ath_hw *hal);
 extern int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask);
@@ -990,19 +990,19 @@ extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_m
 /* EEPROM access functions */
 extern int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain);
 /* Protocol Control Unit Functions */
-extern void ath5k_hw_set_opmode(struct ath_hw *hal);
+extern int ath5k_hw_set_opmode(struct ath_hw *hal);
 /* BSSID Functions */
 extern void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac);
-extern bool ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
+extern int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
 extern void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id);
-extern bool ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
+extern int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
 /* Receive start/stop functions */
 extern void ath5k_hw_start_rx_pcu(struct ath_hw *hal);
 extern void ath5k_hw_stop_pcu_recv(struct ath_hw *hal);
 /* RX Filter functions */
 extern void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1);
-extern bool ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
-extern bool ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
+extern int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
+extern int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
 extern u32 ath5k_hw_get_rx_filter(struct ath_hw *ah);
 extern void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter);
 /* Beacon related functions */
@@ -1010,14 +1010,14 @@ extern u32 ath5k_hw_get_tsf32(struct ath_hw *hal);
 extern u64 ath5k_hw_get_tsf64(struct ath_hw *hal);
 extern void ath5k_hw_reset_tsf(struct ath_hw *hal);
 extern void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval);
-extern void ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
+extern int ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
 extern void ath5k_hw_reset_beacon(struct ath_hw *hal);
-extern bool ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
+extern int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
 extern void ath5k_hw_update_mib_counters(struct ath_hw *hal, struct ath5k_mib_stats *statistics);
 /* ACK/CTS Timeouts */
-extern bool ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
+extern int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
 extern unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal);
-extern bool ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
+extern int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
 extern unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal);
 /* Key table (WEP) functions */
 extern int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry);
@@ -1031,7 +1031,7 @@ extern int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue, struct ath5
 extern void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue);
 extern int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue);
 extern u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue);
-extern bool ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
+extern int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
 extern unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal);
 /* Hardware Descriptor Functions */
 extern int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc, u32 size, unsigned int flags);
@@ -1047,9 +1047,6 @@ extern u16 ath5k_get_regdomain(struct ath_hw *hal);
 /* Misc functions */
 extern void ath5k_hw_dump_state(struct ath_hw *hal);
 extern int ath5k_hw_get_capability(struct ath_hw *hal, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
-bool ath5k_hw_query_pspoll_support(struct ath_hw *hal);
-bool ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid, u16 assoc_id);
-bool ath5k_hw_disable_pspoll(struct ath_hw *hal);
 
 
 /* Initial register settings functions */
diff --git a/drivers/net/wireless/ath5k/ath5k_base.c b/drivers/net/wireless/ath5k/ath5k_base.c
index fead9a7..665f775 100644
--- a/drivers/net/wireless/ath5k/ath5k_base.c
+++ b/drivers/net/wireless/ath5k/ath5k_base.c
@@ -579,7 +579,7 @@ static void ath_beacon_send(struct ath_softc *sc)
 	 * This should never fail since we check above that no frames
 	 * are still pending on the queue.
 	 */
-	if (unlikely(!ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
+	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
 		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
 				sc->bhalq);
 		/* NB: the HAL still stops DMA, so proceed */
diff --git a/drivers/net/wireless/ath5k/ath5k_hw.c b/drivers/net/wireless/ath5k/ath5k_hw.c
index b221ced..bba42de 100644
--- a/drivers/net/wireless/ath5k/ath5k_hw.c
+++ b/drivers/net/wireless/ath5k/ath5k_hw.c
@@ -61,6 +61,9 @@ static int ath5k_hw_get_capabilities(struct ath_hw *);
 static int ath5k_eeprom_init(struct ath_hw *);
 static int ath5k_eeprom_read_mac(struct ath_hw *, u8 *);
 
+static int ath5k_hw_enable_pspoll(struct ath_hw *, u8 *, u16);
+static int ath5k_hw_disable_pspoll(struct ath_hw *);
+
 /*
  * Enable to overwrite the country code (use "00" for debug)
  */
@@ -1267,8 +1270,7 @@ int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue)
  * Stop DMA transmit for a specific queue
  * (see also QCU/DCU functions)
  */
-bool
-ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 {
 	unsigned int i = 100;
 	u32 tx_queue, pending;
@@ -1278,7 +1280,7 @@ ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 
 	/* Return if queue is declared inactive */
 	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return false;
+		return -EIO;
 
 	if (hal->ah_version == AR5K_AR5210) {
 		tx_queue = ath5k_hw_reg_read(hal, AR5K_CR);
@@ -1297,7 +1299,7 @@ ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 			ath5k_hw_reg_write(hal, 0, AR5K_BSR);
 			break;
 		default:
-			return false;
+			return -EINVAL;
 		}
 
 		/* Stop queue */
@@ -1320,8 +1322,8 @@ ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 		ath5k_hw_reg_write(hal, 0, AR5K_QCU_TXD);
 	}
 
-	/* TODO: Check for success else return false */
-	return true;
+	/* TODO: Check for success else return error */
+	return 0;
 }
 
 /*
@@ -1406,11 +1408,10 @@ int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
 /*
  * Update tx trigger level
  */
-bool
-ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
+int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 {
 	u32 trigger_level, imr;
-	bool status = false;
+	int ret = -EIO;
 
 	AR5K_TRACE;
 
@@ -1439,7 +1440,7 @@ ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 		AR5K_REG_WRITE_BITS(hal, AR5K_TXCFG,
 				AR5K_TXCFG_TXFULL, trigger_level);
 
-	status = true;
+	ret = 0;
 
 done:
 	/*
@@ -1447,7 +1448,7 @@ done:
 	 */
 	ath5k_hw_set_intr(hal, imr);
 
-	return status;
+	return ret;
 }
 
 /*
@@ -2254,8 +2255,7 @@ static int ath5k_hw_get_capabilities(struct ath_hw *hal)
 /*
  * Set Operation mode
  */
-void
-ath5k_hw_set_opmode(struct ath_hw *hal)
+int ath5k_hw_set_opmode(struct ath_hw *hal)
 {
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
@@ -2290,7 +2290,7 @@ ath5k_hw_set_opmode(struct ath_hw *hal)
 		break;
 
 	default:
-		return;
+		return -EINVAL;
 	}
 
 	/*
@@ -2306,6 +2306,8 @@ ath5k_hw_set_opmode(struct ath_hw *hal)
 	 */
 	if (hal->ah_version == AR5K_AR5210)
 		ath5k_hw_reg_write(hal, beacon_reg, AR5K_BCR);
+
+	return 0;
 }
 
 /*
@@ -2324,8 +2326,7 @@ void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac)
 /*
  * Set station id
  */
-bool
-ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
+int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
 {
 	u32 low_id, high_id;
 
@@ -2339,14 +2340,13 @@ ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
 	ath5k_hw_reg_write(hal, low_id, AR5K_STA_ID0);
 	ath5k_hw_reg_write(hal, high_id, AR5K_STA_ID1);
 
-	return true;
+	return 0;
 }
 
 /*
  * Set BSSID
  */
-void
-ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
+void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 {
 	u32 low_id, high_id;
 	u16 tim_offset = 0;
@@ -2383,8 +2383,7 @@ ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 /*
  * Set BSSID mask on 5212
  */
-bool
-ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
+int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 {
 	u32 low_id, high_id;
 	AR5K_TRACE;
@@ -2396,10 +2395,10 @@ ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 		ath5k_hw_reg_write(hal, low_id, AR5K_BSS_IDM0);
 		ath5k_hw_reg_write(hal, high_id, AR5K_BSS_IDM1);
 
-		return true;
+		return 0;
 	}
 
-	return false;
+	return -EIO;
 }
 
 /*
@@ -2409,8 +2408,7 @@ ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 /*
  * Start receive on PCU
  */
-void
-ath5k_hw_start_rx_pcu(struct ath_hw *hal)
+void ath5k_hw_start_rx_pcu(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
@@ -2419,8 +2417,7 @@ ath5k_hw_start_rx_pcu(struct ath_hw *hal)
 /*
  * Stop receive on PCU
  */
-void
-ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
+void ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
@@ -2433,8 +2430,7 @@ ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
 /*
  * Set multicast filter
  */
-void
-ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
+void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
 {
 	AR5K_TRACE;
 	/* Set the multicat filter */
@@ -2445,46 +2441,43 @@ ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
 /*
  * Set multicast filter by index
  */
-bool
-ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
+int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
-		return false;
+		return -EINVAL;
 	else if (index >= 32)
 		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
 		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
 
-	return true;
+	return 0;
 }
 
 /*
  * Clear Multicast filter by index
  */
-bool
-ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index)
+int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
-		return false;
+		return -EINVAL;
 	else if (index >= 32)
 		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
 		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
 
-	return true;
+	return 0;
 }
 
 /*
  * Get current rx filter
  */
-u32
-ath5k_hw_get_rx_filter(struct ath_hw *ah)
+u32 ath5k_hw_get_rx_filter(struct ath_hw *ah)
 {
 	u32 data, filter = 0;
 
@@ -2626,8 +2619,7 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 /*
  * Set beacon timers
  */
-void
-ath5k_hw_set_beacon_timers(struct ath_hw *hal,
+int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 		const struct ath5k_beacon_state *state)
 {
 	u32 cfp_period, next_cfp, dtim, interval, next_beacon;
@@ -2647,7 +2639,7 @@ ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	AR5K_TRACE;
 	/* Return on an invalid beacon state */
 	if (state->bs_interval < 1)
-		return;
+		return -EINVAL;
 
 	interval = state->bs_interval;
 	dtim = state->bs_dtim_period;
@@ -2727,7 +2719,7 @@ ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 			dtim = state->bs_sleep_duration;
 
 		if (interval > dtim)
-			return;
+			return -EINVAL;
 
 		next_beacon = interval == dtim ? state->bs_next_dtim :
 			state->bs_next_beacon;
@@ -2747,13 +2739,14 @@ ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 			AR5K_REG_SM(interval, AR5K_SLEEP2_TIM_PER) |
 			AR5K_REG_SM(dtim, AR5K_SLEEP2_DTIM_PER), AR5K_SLEEP2);
 	}
+
+	return 0;
 }
 
 /*
  * Reset beacon timers
  */
-void
-ath5k_hw_reset_beacon(struct ath_hw *hal)
+void ath5k_hw_reset_beacon(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	/*
@@ -2773,11 +2766,10 @@ ath5k_hw_reset_beacon(struct ath_hw *hal)
  * Wait for beacon queue to finish
  * TODO: This function's name is misleading, rename
  */
-bool
-ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
+int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 {
 	unsigned int i;
-	bool ret;
+	int ret;
 
 	AR5K_TRACE;
 
@@ -2804,17 +2796,17 @@ ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
 					AR5K_BCR);
 
-			return false;
+			return -EIO;
 		}
-		ret = true;
+		ret = 0;
 	} else {
 	/*5211/5212*/
 		ret = ath5k_hw_register_timeout(hal,
 			AR5K_QUEUE_STATUS(AR5K_TX_QUEUE_ID_BEACON),
-			AR5K_QCU_STS_FRMPENDCNT, 0, false) ? false : true;
+			AR5K_QCU_STS_FRMPENDCNT, 0, false);
 
 		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
-			return false;
+			return -EIO;
 	}
 
 	return ret;
@@ -2823,8 +2815,7 @@ ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 /*
  * Update mib counters (statistics)
  */
-void
-ath5k_hw_update_mib_counters(struct ath_hw *hal,
+void ath5k_hw_update_mib_counters(struct ath_hw *hal,
 		struct ath5k_mib_stats *statistics)
 {
 	AR5K_TRACE;
@@ -2851,58 +2842,54 @@ ath5k_hw_update_mib_counters(struct ath_hw *hal,
 /*
  * Set ACK timeout on PCU
  */
-bool
-ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
 			hal->ah_turbo) <= timeout)
-		return false;
+		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
 		ath5k_hw_htoclock(timeout, hal->ah_turbo));
 
-	return true;
+	return 0;
 }
 
 /*
  * Read the ACK timeout from PCU
  */
-unsigned int
-ath5k_hw_get_ack_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 
-	return (ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), hal->ah_turbo));
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), hal->ah_turbo);
 }
 
 /*
  * Set CTS timeout on PCU
  */
-bool
-ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
 			hal->ah_turbo) <= timeout)
-		return false;
+		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
 			ath5k_hw_htoclock(timeout, hal->ah_turbo));
 
-	return true;
+	return 0;
 }
 
 /*
  * Read CTS timeout from PCU
  */
-unsigned int
-ath5k_hw_get_cts_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal)
 {
 	AR5K_TRACE;
-	return (ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), hal->ah_turbo));
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), hal->ah_turbo);
 }
 
 /*
@@ -3390,8 +3377,7 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
  * Get number of pending frames
  * for a specific queue [5211+]
  */
-u32
-ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
+u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
 	AR5K_TRACE;
 	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
 
@@ -3409,12 +3395,11 @@ ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
 /*
  * Set slot time
  */
-bool
-ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
+int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
 {
 	AR5K_TRACE;
 	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
-		return false;
+		return -EINVAL;
 
 	if (hal->ah_version == AR5K_AR5210)
 		ath5k_hw_reg_write(hal, ath5k_hw_htoclock(slot_time,
@@ -3422,19 +3407,18 @@ ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
 	else
 		ath5k_hw_reg_write(hal, slot_time, AR5K_DCU_GBL_IFS_SLOT);
 
-	return true;
+	return 0;
 }
 
 /*
  * Get slot time
  */
-unsigned int
-ath5k_hw_get_slot_time(struct ath_hw *hal)
+unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	if (hal->ah_version == AR5K_AR5210)
-		return (ath5k_hw_clocktoh(ath5k_hw_reg_read(hal,
-				AR5K_SLOT_TIME) & 0xffff, hal->ah_turbo));
+		return ath5k_hw_clocktoh(ath5k_hw_reg_read(hal,
+				AR5K_SLOT_TIME) & 0xffff, hal->ah_turbo);
 	else
 		return ath5k_hw_reg_read(hal, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
 }
@@ -4360,38 +4344,41 @@ yes:
 	return 0;
 }
 
-bool
-ath5k_hw_query_pspoll_support(struct ath_hw *hal)
+#if 0
+static bool ath5k_hw_query_pspoll_support(struct ath_hw *hal)
 {
 	AR5K_TRACE;
+
 	if (hal->ah_version == AR5K_AR5210)
-		return(true);
+		return true;
 
 	return false;
 }
+#endif
 
-bool
-ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid, u16 assoc_id)
+static int ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid,
+		u16 assoc_id)
 {
 	AR5K_TRACE;
+
 	if (hal->ah_version == AR5K_AR5210) {
 		AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
-		return true;
+		return 0;
 	}
 
-	return false;
+	return -EIO;
 }
 
-bool
-ath5k_hw_disable_pspoll(struct ath_hw *hal)
+static int ath5k_hw_disable_pspoll(struct ath_hw *hal)
 {
 	AR5K_TRACE;
+
 	if (hal->ah_version == AR5K_AR5210) {
 		AR5K_REG_ENABLE_BITS(hal, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
-		return true;
+		return 0;
 	}
 
-	return false;
+	return -EIO;
 }
