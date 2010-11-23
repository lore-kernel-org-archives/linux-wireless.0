Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56930 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0KWTUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:20:30 -0500
Received: by eye27 with SMTP id 27so4887956eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:20:29 -0800 (PST)
Date: Tue, 23 Nov 2010 21:19:45 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 16/30] ath5k: Set all IFS intervals, not just slot time
Message-ID: <20101123191533.GP4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Replace set_slot_time with set_ifs_intervals that also sets
 the various inter-frame space intervals based on current bwmode.

 * Clean up AR5210 mess from reset_tx_queue, AR5210 only has one
 data queue and we set IFS intervals for that queue on set_ifs_intervals
 so there is nothing left to do for 5210 on reset_tx_queue.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   31 +--
 drivers/net/wireless/ath/ath5k/pcu.c   |    4 +-
 drivers/net/wireless/ath/ath5k/qcu.c   |  513 ++++++++++++++++++--------------
 drivers/net/wireless/ath/ath5k/reg.h   |    3 +-
 4 files changed, 308 insertions(+), 243 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 7df5b46..ddbbf4c 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -222,34 +222,15 @@
 
 /* Initial values */
 #define	AR5K_INIT_CYCRSSI_THR1			2
-#define AR5K_INIT_TX_LATENCY			502
-#define AR5K_INIT_USEC				39
-#define AR5K_INIT_USEC_TURBO			79
-#define AR5K_INIT_USEC_32			31
-#define AR5K_INIT_SLOT_TIME_CLOCK		396
-#define AR5K_INIT_SLOT_TIME_TURBO_CLOCK		480
-#define AR5K_INIT_ACK_CTS_TIMEOUT		1024
-#define AR5K_INIT_ACK_CTS_TIMEOUT_TURBO		0x08000800
-#define AR5K_INIT_PROG_IFS			920
-#define AR5K_INIT_PROG_IFS_TURBO		960
-#define AR5K_INIT_EIFS				3440
-#define AR5K_INIT_EIFS_TURBO			6880
-#define AR5K_INIT_SIFS_CLOCK			560
-#define AR5K_INIT_SIFS_TURBO_CLOCK		480
+
+/* Tx retry limits */
 #define AR5K_INIT_SH_RETRY			10
 #define AR5K_INIT_LG_RETRY			AR5K_INIT_SH_RETRY
+/* For station mode */
 #define AR5K_INIT_SSH_RETRY			32
 #define AR5K_INIT_SLG_RETRY			AR5K_INIT_SSH_RETRY
 #define AR5K_INIT_TX_RETRY			10
 
-#define AR5K_INIT_PROTO_TIME_CNTRL		(			\
-	(AR5K_INIT_CARR_SENSE_EN << 26) | (AR5K_INIT_EIFS << 12) |	\
-	(AR5K_INIT_PROG_IFS)						\
-)
-#define AR5K_INIT_PROTO_TIME_CNTRL_TURBO	(			\
-	(AR5K_INIT_CARR_SENSE_EN << 26) | (AR5K_INIT_EIFS_TURBO << 12) | \
-	(AR5K_INIT_PROG_IFS_TURBO)					\
-)
 
 /* Slot time */
 #define AR5K_INIT_SLOT_TIME_TURBO		6
@@ -1240,6 +1221,10 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
 
 
 /* Protocol Control Unit Functions */
+/* Helpers */
+int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
+		int len, struct ieee80211_rate *rate);
+unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah);
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
 void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
 /* RX filter control*/
@@ -1273,7 +1258,7 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
 u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
 void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
 int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
-int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
+int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time);
 /* Init function */
 int ath5k_hw_init_queues(struct ath5k_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index e691378..4556f29 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -763,7 +763,7 @@ ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval)
  * @ah: The &struct ath5k_hw
  * @coverage_class: IEEE 802.11 coverage class number
  *
- * Sets slot time, ACK timeout and CTS timeout for given coverage class.
+ * Sets IFS intervals and ACK/CTS timeouts for given coverage class.
  */
 void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
 {
@@ -772,7 +772,7 @@ void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
 	int ack_timeout = ath5k_hw_get_default_sifs(ah) + slot_time;
 	int cts_timeout = ack_timeout;
 
-	ath5k_hw_set_slot_time(ah, slot_time);
+	ath5k_hw_set_ifs_intervals(ah, slot_time);
 	ath5k_hw_set_ack_timeout(ah, ack_timeout);
 	ath5k_hw_set_cts_timeout(ah, cts_timeout);
 
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 6eb6838..e13142a 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -276,8 +276,14 @@ static void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
 	return;
 }
 
-/*
- * Set DFS properties for a transmit queue on DCU
+/**
+ * ath5k_hw_reset_tx_queue - Initialize a single hw queue
+ *
+ * @ah The &struct ath5k_hw
+ * @queue The hw queue number
+ *
+ * Set DFS properties for the given transmit queue on DCU
+ * and configures all queue-specific parameters.
  */
 int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
@@ -287,240 +293,217 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 
 	tq = &ah->ah_txq[queue];
 
-	if (tq->tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	/* Skip if queue inactive or if we are on AR5210
+	 * that doesn't have QCU/DCU */
+	if ((ah->ah_version == AR5K_AR5210) ||
+	(tq->tqi_type == AR5K_TX_QUEUE_INACTIVE))
 		return 0;
 
-	if (ah->ah_version == AR5K_AR5210) {
-		/* Only handle data queues, others will be ignored */
-		if (tq->tqi_type != AR5K_TX_QUEUE_DATA)
-			return 0;
-
-		/* Set Slot time */
-		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
-			AR5K_INIT_SLOT_TIME_TURBO_CLOCK :
-			AR5K_INIT_SLOT_TIME_CLOCK,
-			AR5K_SLOT_TIME);
-		/* Set ACK_CTS timeout */
-		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
-			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
-			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
-
-		/* Set IFS0 */
-		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
-			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO_CLOCK +
-				tq->tqi_aifs * AR5K_INIT_SLOT_TIME_TURBO_CLOCK)
-				<< AR5K_IFS0_DIFS_S) |
-				AR5K_INIT_SIFS_TURBO_CLOCK,
-				AR5K_IFS0);
-		} else {
-			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_CLOCK +
-				tq->tqi_aifs * AR5K_INIT_SLOT_TIME_CLOCK) <<
-				AR5K_IFS0_DIFS_S) |
-				AR5K_INIT_SIFS_CLOCK, AR5K_IFS0);
-		}
-
-		/* Set IFS1 */
-		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
-			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
-			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
-	} else {
-
-	/*===Rest is also for QCU/DCU only [5211+]===*/
-
-		/*
-		 * Set contention window (cw_min/cw_max)
-		 * and arbitrated interframe space (aifs)...
-		 */
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(tq->tqi_cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
-			AR5K_REG_SM(tq->tqi_cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
-			AR5K_REG_SM(tq->tqi_aifs, AR5K_DCU_LCL_IFS_AIFS),
-			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
-
-		/*
-		 * Set tx retry limits for this queue
-		 */
-		ath5k_hw_set_tx_retry_limits(ah, queue);
-
-		/*
-		 * Set misc registers
-		 */
-
-		/* Enable DCU to wait for next fragment from QCU */
+	/*
+	 * Set contention window (cw_min/cw_max)
+	 * and arbitrated interframe space (aifs)...
+	 */
+	ath5k_hw_reg_write(ah,
+		AR5K_REG_SM(tq->tqi_cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
+		AR5K_REG_SM(tq->tqi_cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
+		AR5K_REG_SM(tq->tqi_aifs, AR5K_DCU_LCL_IFS_AIFS),
+		AR5K_QUEUE_DFS_LOCAL_IFS(queue));
+
+	/*
+	 * Set tx retry limits for this queue
+	 */
+	ath5k_hw_set_tx_retry_limits(ah, queue);
+
+
+	/*
+	 * Set misc registers
+	 */
+
+	/* Enable DCU to wait for next fragment from QCU */
+	AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
+				AR5K_DCU_MISC_FRAG_WAIT);
+
+	/* On Maui and Spirit use the global seqnum on DCU */
+	if (ah->ah_mac_version < AR5K_SREV_AR5211)
 		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
-					AR5K_DCU_MISC_FRAG_WAIT);
+					AR5K_DCU_MISC_SEQNUM_CTL);
 
-		/* On Maui and Spirit use the global seqnum on DCU */
-		if (ah->ah_mac_version < AR5K_SREV_AR5211)
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
-						AR5K_DCU_MISC_SEQNUM_CTL);
+	/* Constant bit rate period */
+	if (tq->tqi_cbr_period) {
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_cbr_period,
+					AR5K_QCU_CBRCFG_INTVAL) |
+					AR5K_REG_SM(tq->tqi_cbr_overflow_limit,
+					AR5K_QCU_CBRCFG_ORN_THRES),
+					AR5K_QUEUE_CBRCFG(queue));
 
-		if (tq->tqi_cbr_period) {
-			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_cbr_period,
-				AR5K_QCU_CBRCFG_INTVAL) |
-				AR5K_REG_SM(tq->tqi_cbr_overflow_limit,
-				AR5K_QCU_CBRCFG_ORN_THRES),
-				AR5K_QUEUE_CBRCFG(queue));
+		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+					AR5K_QCU_MISC_FRSHED_CBR);
+
+		if (tq->tqi_cbr_overflow_limit)
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_CBR);
-			if (tq->tqi_cbr_overflow_limit)
-				AR5K_REG_ENABLE_BITS(ah,
-					AR5K_QUEUE_MISC(queue),
 					AR5K_QCU_MISC_CBR_THRES_ENABLE);
-		}
+	}
 
-		if (tq->tqi_ready_time &&
-		(tq->tqi_type != AR5K_TX_QUEUE_CAB))
-			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_ready_time,
-				AR5K_QCU_RDYTIMECFG_INTVAL) |
-				AR5K_QCU_RDYTIMECFG_ENABLE,
-				AR5K_QUEUE_RDYTIMECFG(queue));
+	/* Ready time interval */
+	if (tq->tqi_ready_time && (tq->tqi_type != AR5K_TX_QUEUE_CAB))
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_ready_time,
+					AR5K_QCU_RDYTIMECFG_INTVAL) |
+					AR5K_QCU_RDYTIMECFG_ENABLE,
+					AR5K_QUEUE_RDYTIMECFG(queue));
 
-		if (tq->tqi_burst_time) {
-			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_burst_time,
-				AR5K_DCU_CHAN_TIME_DUR) |
-				AR5K_DCU_CHAN_TIME_ENABLE,
-				AR5K_QUEUE_DFS_CHANNEL_TIME(queue));
+	if (tq->tqi_burst_time) {
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_burst_time,
+					AR5K_DCU_CHAN_TIME_DUR) |
+					AR5K_DCU_CHAN_TIME_ENABLE,
+					AR5K_QUEUE_DFS_CHANNEL_TIME(queue));
 
-			if (tq->tqi_flags
-			& AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE)
-				AR5K_REG_ENABLE_BITS(ah,
-					AR5K_QUEUE_MISC(queue),
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE)
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 					AR5K_QCU_MISC_RDY_VEOL_POLICY);
-		}
+	}
 
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_BACKOFF_DISABLE)
-			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
-				AR5K_QUEUE_DFS_MISC(queue));
+	/* Enable/disable Post frame backoff */
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_BACKOFF_DISABLE)
+		ath5k_hw_reg_write(ah, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
+					AR5K_QUEUE_DFS_MISC(queue));
 
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
-			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_BACKOFF_FRAG,
-				AR5K_QUEUE_DFS_MISC(queue));
+	/* Enable/disable fragmentation burst backoff */
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
+		ath5k_hw_reg_write(ah, AR5K_DCU_MISC_BACKOFF_FRAG,
+					AR5K_QUEUE_DFS_MISC(queue));
 
-		/*
-		 * Set registers by queue type
-		 */
-		switch (tq->tqi_type) {
-		case AR5K_TX_QUEUE_BEACON:
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+	/*
+	 * Set registers by queue type
+	 */
+	switch (tq->tqi_type) {
+	case AR5K_TX_QUEUE_BEACON:
+		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP_BCN_DIS |
 				AR5K_QCU_MISC_BCN_ENABLE);
 
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
+		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
 				AR5K_DCU_MISC_ARBLOCK_CTL_S) |
 				AR5K_DCU_MISC_ARBLOCK_IGNORE |
 				AR5K_DCU_MISC_POST_FR_BKOFF_DIS |
 				AR5K_DCU_MISC_BCN_ENABLE);
-			break;
+		break;
 
-		case AR5K_TX_QUEUE_CAB:
-			/* XXX: use BCN_SENT_GT, if we can figure out how */
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_DBA_GT |
-				AR5K_QCU_MISC_CBREXP_DIS |
-				AR5K_QCU_MISC_CBREXP_BCN_DIS);
+	case AR5K_TX_QUEUE_CAB:
+		/* XXX: use BCN_SENT_GT, if we can figure out how */
+		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+					AR5K_QCU_MISC_FRSHED_DBA_GT |
+					AR5K_QCU_MISC_CBREXP_DIS |
+					AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
-			ath5k_hw_reg_write(ah, ((tq->tqi_ready_time -
-				(AR5K_TUNE_SW_BEACON_RESP -
-				AR5K_TUNE_DMA_BEACON_RESP) -
+		ath5k_hw_reg_write(ah, ((tq->tqi_ready_time -
+					(AR5K_TUNE_SW_BEACON_RESP -
+					AR5K_TUNE_DMA_BEACON_RESP) -
 				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
-				AR5K_QCU_RDYTIMECFG_ENABLE,
-				AR5K_QUEUE_RDYTIMECFG(queue));
+					AR5K_QCU_RDYTIMECFG_ENABLE,
+					AR5K_QUEUE_RDYTIMECFG(queue));
 
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
-				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
-				AR5K_DCU_MISC_ARBLOCK_CTL_S));
-			break;
+		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
+					(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
+					AR5K_DCU_MISC_ARBLOCK_CTL_S));
+		break;
 
-		case AR5K_TX_QUEUE_UAPSD:
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_CBREXP_DIS);
-			break;
+	case AR5K_TX_QUEUE_UAPSD:
+		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+					AR5K_QCU_MISC_CBREXP_DIS);
+		break;
 
-		case AR5K_TX_QUEUE_DATA:
-		default:
+	case AR5K_TX_QUEUE_DATA:
+	default:
 			break;
-		}
-
-		/* TODO: Handle frame compression */
-
-		/*
-		 * Enable interrupts for this tx queue
-		 * in the secondary interrupt mask registers
-		 */
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXOKINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txok, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXERRINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txerr, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXURNINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txurn, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXDESCINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txdesc, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXEOLINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txeol, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_CBRORNINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_cbrorn, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_CBRURNINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_cbrurn, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_QTRIGINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_qtrig, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXNOFRMINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_nofrm, queue);
-
-		/* Update secondary interrupt mask registers */
-
-		/* Filter out inactive queues */
-		ah->ah_txq_imr_txok &= ah->ah_txq_status;
-		ah->ah_txq_imr_txerr &= ah->ah_txq_status;
-		ah->ah_txq_imr_txurn &= ah->ah_txq_status;
-		ah->ah_txq_imr_txdesc &= ah->ah_txq_status;
-		ah->ah_txq_imr_txeol &= ah->ah_txq_status;
-		ah->ah_txq_imr_cbrorn &= ah->ah_txq_status;
-		ah->ah_txq_imr_cbrurn &= ah->ah_txq_status;
-		ah->ah_txq_imr_qtrig &= ah->ah_txq_status;
-		ah->ah_txq_imr_nofrm &= ah->ah_txq_status;
-
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txok,
-			AR5K_SIMR0_QCU_TXOK) |
-			AR5K_REG_SM(ah->ah_txq_imr_txdesc,
-			AR5K_SIMR0_QCU_TXDESC), AR5K_SIMR0);
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txerr,
-			AR5K_SIMR1_QCU_TXERR) |
-			AR5K_REG_SM(ah->ah_txq_imr_txeol,
-			AR5K_SIMR1_QCU_TXEOL), AR5K_SIMR1);
-		/* Update simr2 but don't overwrite rest simr2 settings */
-		AR5K_REG_DISABLE_BITS(ah, AR5K_SIMR2, AR5K_SIMR2_QCU_TXURN);
-		AR5K_REG_ENABLE_BITS(ah, AR5K_SIMR2,
-			AR5K_REG_SM(ah->ah_txq_imr_txurn,
-			AR5K_SIMR2_QCU_TXURN));
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_cbrorn,
-			AR5K_SIMR3_QCBRORN) |
-			AR5K_REG_SM(ah->ah_txq_imr_cbrurn,
-			AR5K_SIMR3_QCBRURN), AR5K_SIMR3);
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_qtrig,
-			AR5K_SIMR4_QTRIG), AR5K_SIMR4);
-		/* Set TXNOFRM_QCU for the queues with TXNOFRM enabled */
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_nofrm,
-			AR5K_TXNOFRM_QCU), AR5K_TXNOFRM);
-		/* No queue has TXNOFRM enabled, disable the interrupt
-		 * by setting AR5K_TXNOFRM to zero */
-		if (ah->ah_txq_imr_nofrm == 0)
-			ath5k_hw_reg_write(ah, 0, AR5K_TXNOFRM);
-
-		/* Set QCU mask for this DCU to save power */
-		AR5K_REG_WRITE_Q(ah, AR5K_QUEUE_QCUMASK(queue), queue);
 	}
 
+	/* TODO: Handle frame compression */
+
+	/*
+	 * Enable interrupts for this tx queue
+	 * in the secondary interrupt mask registers
+	 */
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_TXOKINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txok, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_TXERRINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txerr, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_TXURNINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txurn, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_TXDESCINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txdesc, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_TXEOLINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txeol, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_CBRORNINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_cbrorn, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_CBRURNINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_cbrurn, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_QTRIGINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_qtrig, queue);
+
+	if (tq->tqi_flags & AR5K_TXQ_FLAG_TXNOFRMINT_ENABLE)
+		AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_nofrm, queue);
+
+	/* Update secondary interrupt mask registers */
+
+	/* Filter out inactive queues */
+	ah->ah_txq_imr_txok &= ah->ah_txq_status;
+	ah->ah_txq_imr_txerr &= ah->ah_txq_status;
+	ah->ah_txq_imr_txurn &= ah->ah_txq_status;
+	ah->ah_txq_imr_txdesc &= ah->ah_txq_status;
+	ah->ah_txq_imr_txeol &= ah->ah_txq_status;
+	ah->ah_txq_imr_cbrorn &= ah->ah_txq_status;
+	ah->ah_txq_imr_cbrurn &= ah->ah_txq_status;
+	ah->ah_txq_imr_qtrig &= ah->ah_txq_status;
+	ah->ah_txq_imr_nofrm &= ah->ah_txq_status;
+
+	ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txok,
+					AR5K_SIMR0_QCU_TXOK) |
+					AR5K_REG_SM(ah->ah_txq_imr_txdesc,
+					AR5K_SIMR0_QCU_TXDESC),
+					AR5K_SIMR0);
+
+	ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txerr,
+					AR5K_SIMR1_QCU_TXERR) |
+					AR5K_REG_SM(ah->ah_txq_imr_txeol,
+					AR5K_SIMR1_QCU_TXEOL),
+					AR5K_SIMR1);
+
+	/* Update SIMR2 but don't overwrite rest simr2 settings */
+	AR5K_REG_DISABLE_BITS(ah, AR5K_SIMR2, AR5K_SIMR2_QCU_TXURN);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_SIMR2,
+				AR5K_REG_SM(ah->ah_txq_imr_txurn,
+				AR5K_SIMR2_QCU_TXURN));
+
+	ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_cbrorn,
+				AR5K_SIMR3_QCBRORN) |
+				AR5K_REG_SM(ah->ah_txq_imr_cbrurn,
+				AR5K_SIMR3_QCBRURN),
+				AR5K_SIMR3);
+
+	ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_qtrig,
+				AR5K_SIMR4_QTRIG), AR5K_SIMR4);
+
+	/* Set TXNOFRM_QCU for the queues with TXNOFRM enabled */
+	ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_nofrm,
+				AR5K_TXNOFRM_QCU), AR5K_TXNOFRM);
+
+	/* No queue has TXNOFRM enabled, disable the interrupt
+	 * by setting AR5K_TXNOFRM to zero */
+	if (ah->ah_txq_imr_nofrm == 0)
+		ath5k_hw_reg_write(ah, 0, AR5K_TXNOFRM);
+
+	/* Set QCU mask for this DCU to save power */
+	AR5K_REG_WRITE_Q(ah, AR5K_QUEUE_QCUMASK(queue), queue);
+
 	return 0;
 }
 
@@ -529,24 +512,114 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 * Global QCU/DCU functions *
 \**************************/
 
-/*
- * Set slot time on DCU
+/**
+ * ath5k_hw_set_ifs_intervals  - Set global inter-frame spaces on DCU
+ *
+ * @ah The &struct ath5k_hw
+ * @slot_time Slot time in us
+ *
+ * Sets the global IFS intervals on DCU (also works on AR5210) for
+ * the given slot time and the current bwmode.
  */
-int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
+int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 {
+	struct ieee80211_channel *channel = ah->ah_current_channel;
+	struct ath5k_softc *sc = ah->ah_sc;
+	struct ieee80211_rate *rate;
+	u32 ack_tx_time, eifs, eifs_clock, sifs, sifs_clock;
 	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
 
 	if (slot_time < 6 || slot_time_clock > AR5K_SLOT_TIME_MAX)
 		return -EINVAL;
 
-	if (ah->ah_version == AR5K_AR5210)
+	sifs = ath5k_hw_get_default_sifs(ah);
+	sifs_clock = ath5k_hw_htoclock(ah, sifs);
+
+	/* EIFS
+	 * Txtime of ack at lowest rate + SIFS + DIFS
+	 * (DIFS = SIFS + 2 * Slot time)
+	 *
+	 * Note: HAL has some predefined values for EIFS
+	 * Turbo:   (37 + 2 * 6)
+	 * Default: (74 + 2 * 9)
+	 * Half:    (149 + 2 * 13)
+	 * Quarter: (298 + 2 * 21)
+	 *
+	 * (74 + 2 * 6) for AR5210 default and turbo !
+	 *
+	 * According to the formula we have
+	 * ack_tx_time = 25 for turbo and
+	 * ack_tx_time = 42.5 * clock multiplier
+	 * for default/half/quarter.
+	 *
+	 * This can't be right, 42 is what we would get
+	 * from ath5k_hw_get_frame_dur_for_bwmode or
+	 * ieee80211_generic_frame_duration for zero frame
+	 * length and without SIFS !
+	 *
+	 * Also we have different lowest rate for 802.11a
+	 */
+	if (channel->hw_value & CHANNEL_5GHZ)
+		rate = &sc->sbands[IEEE80211_BAND_5GHZ].bitrates[0];
+	else
+		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[0];
+
+	ack_tx_time = ath5k_hw_get_frame_duration(ah, 10, rate);
+
+	/* ack_tx_time includes an SIFS already */
+	eifs = ack_tx_time + sifs + 2 * slot_time;
+	eifs_clock = ath5k_hw_htoclock(ah, eifs);
+
+	/* Set IFS settings on AR5210 */
+	if (ah->ah_version == AR5K_AR5210) {
+		u32 pifs, pifs_clock, difs, difs_clock;
+
+		/* Set slot time */
 		ath5k_hw_reg_write(ah, slot_time_clock, AR5K_SLOT_TIME);
-	else
-		ath5k_hw_reg_write(ah, slot_time_clock, AR5K_DCU_GBL_IFS_SLOT);
+
+		/* Set EIFS */
+		eifs_clock = AR5K_REG_SM(eifs_clock, AR5K_IFS1_EIFS);
+
+		/* PIFS = Slot time + SIFS */
+		pifs = slot_time + sifs;
+		pifs_clock = ath5k_hw_htoclock(ah, pifs);
+		pifs_clock = AR5K_REG_SM(pifs_clock, AR5K_IFS1_PIFS);
+
+		/* DIFS = SIFS + 2 * Slot time */
+		difs = sifs + 2 * slot_time;
+		difs_clock = ath5k_hw_htoclock(ah, difs);
+
+		/* Set SIFS/DIFS */
+		ath5k_hw_reg_write(ah, (difs_clock <<
+				AR5K_IFS0_DIFS_S) | sifs_clock,
+				AR5K_IFS0);
+
+		/* Set PIFS/EIFS and preserve AR5K_INIT_CARR_SENSE_EN */
+		ath5k_hw_reg_write(ah, pifs_clock | eifs_clock |
+				(AR5K_INIT_CARR_SENSE_EN << AR5K_IFS1_CS_EN_S),
+				AR5K_IFS1);
+
+		return 0;
+	}
+
+	/* Set IFS slot time */
+	ath5k_hw_reg_write(ah, slot_time_clock, AR5K_DCU_GBL_IFS_SLOT);
+
+	/* Set EIFS interval */
+	ath5k_hw_reg_write(ah, eifs_clock, AR5K_DCU_GBL_IFS_EIFS);
+
+	/* Set SIFS interval in usecs */
+	AR5K_REG_WRITE_BITS(ah, AR5K_DCU_GBL_IFS_MISC,
+				AR5K_DCU_GBL_IFS_MISC_SIFS_DUR_USEC,
+				sifs);
+
+	/* Set SIFS interval in clock cycles */
+	ath5k_hw_reg_write(ah, sifs_clock, AR5K_DCU_GBL_IFS_SIFS);
 
 	return 0;
 }
 
+
 int ath5k_hw_init_queues(struct ath5k_hw *ah)
 {
 	int i, ret;
@@ -559,14 +632,20 @@ int ath5k_hw_init_queues(struct ath5k_hw *ah)
 	 * This also sets QCU mask on each DCU for 1:1 qcu to dcu mapping
 	 * Note: If we want we can assign multiple qcus on one dcu.
 	 */
-	for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
-		ret = ath5k_hw_reset_tx_queue(ah, i);
-		if (ret) {
-			ATH5K_ERR(ah->ah_sc,
-				"failed to reset TX queue #%d\n", i);
-			return ret;
+	if (ah->ah_version != AR5K_AR5210)
+		for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
+			ret = ath5k_hw_reset_tx_queue(ah, i);
+			if (ret) {
+				ATH5K_ERR(ah->ah_sc,
+					"failed to reset TX queue #%d\n", i);
+				return ret;
+			}
 		}
-	}
+	else
+		/* No QCU/DCU on AR5210, just set tx
+		 * retry limits. We set IFS parameters
+		 * on ath5k_hw_set_ifs_intervals */
+		ath5k_hw_set_tx_retry_limits(ah, 0);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index dc213bb..8516728 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -787,6 +787,7 @@
 #define	AR5K_DCU_GBL_IFS_MISC_LFSR_SLICE	0x00000007	/* LFSR Slice Select */
 #define	AR5K_DCU_GBL_IFS_MISC_TURBO_MODE	0x00000008	/* Turbo mode */
 #define	AR5K_DCU_GBL_IFS_MISC_SIFS_DUR_USEC	0x000003f0	/* SIFS Duration mask */
+#define	AR5K_DCU_GBL_IFS_MISC_SIFS_DUR_USEC_S	4
 #define	AR5K_DCU_GBL_IFS_MISC_USEC_DUR		0x000ffc00	/* USEC Duration mask */
 #define	AR5K_DCU_GBL_IFS_MISC_USEC_DUR_S	10
 #define	AR5K_DCU_GBL_IFS_MISC_DCU_ARB_DELAY	0x00300000	/* DCU Arbiter delay mask */
@@ -1311,7 +1312,7 @@
 #define AR5K_IFS1_EIFS		0x03fff000
 #define AR5K_IFS1_EIFS_S	12
 #define AR5K_IFS1_CS_EN		0x04000000
-
+#define AR5K_IFS1_CS_EN_S	26
 
 /*
  * CFP duration register
