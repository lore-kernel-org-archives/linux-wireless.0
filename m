Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:9400 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753225Ab0IPJvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 05:51:37 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-050693696
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 18:51:36 +0900 (JST)
Subject: [PATCH 8/9] ath5k: Simplify cw_min/max and AIFS configuration
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Sep 2010 18:51:54 +0900
Message-ID: <20100916095154.17637.41992.stgit@tt-desk>
In-Reply-To: <20100916095112.17637.17207.stgit@tt-desk>
References: <20100916095112.17637.17207.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of overly complicated cw_min/max and AIFS configuration:

* Validate values in ath5k_hw_set_tx_queueprops(), so we can use them directly
  without further checks or computation in ath5k_hw_reset_tx_queue().

* Simplifiy by using AR5K_TUNE_AIFS|CWMIN|CWMAX variables directly since we
  don't support XR or B channels. That way we can also remove
  AR5K_TXQ_USEDEFAULT and the confusing logic around it.

* Update data types: AIFS is u8, CW's are u16.

* Remove now unneeded variables in ath5k_hw.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |   11 +--
 drivers/net/wireless/ath/ath5k/attach.c |    2 -
 drivers/net/wireless/ath/ath5k/base.c   |   18 +++---
 drivers/net/wireless/ath/ath5k/qcu.c    |   99 ++++++++++++++++---------------
 4 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 9475b21..b96bb98 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -258,8 +258,6 @@
 	(AR5K_INIT_PROG_IFS_TURBO)					\
 )
 
-/* token to use for aifs, cwmin, cwmax in MadWiFi */
-#define	AR5K_TXQ_USEDEFAULT	((u32) -1)
 
 /* GENERIC CHIPSET DEFINITIONS */
 
@@ -530,9 +528,9 @@ struct ath5k_txq_info {
 	enum ath5k_tx_queue tqi_type;
 	enum ath5k_tx_queue_subtype tqi_subtype;
 	u16	tqi_flags;	/* Tx queue flags (see above) */
-	u32	tqi_aifs;	/* Arbitrated Interframe Space */
-	s32	tqi_cw_min;	/* Minimum Contention Window */
-	s32	tqi_cw_max;	/* Maximum Contention Window */
+	u8	tqi_aifs;	/* Arbitrated Interframe Space */
+	u16	tqi_cw_min;	/* Minimum Contention Window */
+	u16	tqi_cw_max;	/* Maximum Contention Window */
 	u32	tqi_cbr_period; /* Constant bit rate period */
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
@@ -1044,9 +1042,6 @@ struct ath5k_hw {
 #define ah_ee_version		ah_capabilities.cap_eeprom.ee_version
 
 	u32			ah_atim_window;
-	u32			ah_aifs;
-	u32			ah_cw_min;
-	u32			ah_cw_max;
 	u32			ah_limit_tx_retries;
 	u8			ah_coverage_class;
 
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 20d178e..6e02de3 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -119,8 +119,6 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
 	ah->ah_imr = 0;
 	ah->ah_atim_window = 0;
-	ah->ah_aifs = AR5K_TUNE_AIFS;
-	ah->ah_cw_min = AR5K_TUNE_CWMIN;
 	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
 	ah->ah_software_retry = false;
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9b67cee..cfa9243 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -853,9 +853,11 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 	struct ath5k_txq *txq;
 	struct ath5k_txq_info qi = {
 		.tqi_subtype = subtype,
-		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_max = AR5K_TXQ_USEDEFAULT
+		/* XXX: default values not correct for B and XR channels,
+		 * but who cares? */
+		.tqi_aifs = AR5K_TUNE_AIFS,
+		.tqi_cw_min = AR5K_TUNE_CWMIN,
+		.tqi_cw_max = AR5K_TUNE_CWMAX
 	};
 	int qnum;
 
@@ -905,9 +907,11 @@ static int
 ath5k_beaconq_setup(struct ath5k_hw *ah)
 {
 	struct ath5k_txq_info qi = {
-		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_min = AR5K_TXQ_USEDEFAULT,
-		.tqi_cw_max = AR5K_TXQ_USEDEFAULT,
+		/* XXX: default values not correct for B and XR channels,
+		 * but who cares? */
+		.tqi_aifs = AR5K_TUNE_AIFS,
+		.tqi_cw_min = AR5K_TUNE_CWMIN,
+		.tqi_cw_max = AR5K_TUNE_CWMAX,
 		/* NB: for dynamic turbo, don't enable any other interrupts */
 		.tqi_flags = AR5K_TXQ_FLAG_TXDESCINT_ENABLE
 	};
@@ -941,7 +945,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 		 */
 		qi.tqi_aifs = 0;
 		qi.tqi_cw_min = 0;
-		qi.tqi_cw_max = 2 * ah->ah_cw_min;
+		qi.tqi_cw_max = 2 * AR5K_TUNE_CWMIN;
 	}
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 4186ff4..84c717d 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -36,24 +36,58 @@ int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
 }
 
 /*
+ * Make sure cw is a power of 2 minus 1 and smaller than 1024
+ */
+static u16 ath5k_cw_validate(u16 cw_req)
+{
+	u32 cw = 1;
+	cw_req = min(cw_req, (u16)1023);
+
+	while (cw < cw_req)
+		cw = (cw << 1) | 1;
+
+	return cw;
+}
+
+/*
  * Set properties for a transmit queue
  */
 int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
-				const struct ath5k_txq_info *queue_info)
+				const struct ath5k_txq_info *qinfo)
 {
+	struct ath5k_txq_info *qi;
+
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
-	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	qi = &ah->ah_txq[queue];
+
+	if (qi->tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return -EIO;
 
-	memcpy(&ah->ah_txq[queue], queue_info, sizeof(struct ath5k_txq_info));
+	/* copy and validate values */
+	qi->tqi_type = qinfo->tqi_type;
+	qi->tqi_subtype = qinfo->tqi_subtype;
+	qi->tqi_flags = qinfo->tqi_flags;
+	/*
+	 * According to the docs: Although the AIFS field is 8 bit wide,
+	 * the maximum supported value is 0xFC. Setting it higher than that
+	 * will cause the DCU to hang.
+	 */
+	qi->tqi_aifs = min(qinfo->tqi_aifs, (u8)0xFC);
+	qi->tqi_cw_min = ath5k_cw_validate(qinfo->tqi_cw_min);
+	qi->tqi_cw_max = ath5k_cw_validate(qinfo->tqi_cw_max);
+	qi->tqi_cbr_period = qinfo->tqi_cbr_period;
+	qi->tqi_cbr_overflow_limit = qinfo->tqi_cbr_overflow_limit;
+	qi->tqi_burst_time = qinfo->tqi_burst_time;
+	qi->tqi_ready_time = qinfo->tqi_ready_time;
 
 	/*XXX: Is this supported on 5210 ?*/
-	if ((queue_info->tqi_type == AR5K_TX_QUEUE_DATA &&
-			((queue_info->tqi_subtype == AR5K_WME_AC_VI) ||
-			(queue_info->tqi_subtype == AR5K_WME_AC_VO))) ||
-			queue_info->tqi_type == AR5K_TX_QUEUE_UAPSD)
-		ah->ah_txq[queue].tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
+	/*XXX: Is this correct for AR5K_WME_AC_VI,VO ???*/
+	if ((qinfo->tqi_type == AR5K_TX_QUEUE_DATA &&
+		((qinfo->tqi_subtype == AR5K_WME_AC_VI) ||
+		 (qinfo->tqi_subtype == AR5K_WME_AC_VO))) ||
+	     qinfo->tqi_type == AR5K_TX_QUEUE_UAPSD)
+		qi->tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
 
 	return 0;
 }
@@ -186,7 +220,7 @@ void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
  */
 int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
-	u32 cw_min, cw_max, retry_lg, retry_sh;
+	u32 retry_lg, retry_sh;
 	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
 
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
@@ -217,14 +251,13 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		/* Set IFS0 */
 		if (ah->ah_turbo) {
 			 ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
-				(ah->ah_aifs + tq->tqi_aifs) *
-				AR5K_INIT_SLOT_TIME_TURBO) <<
+				tq->tqi_aifs * AR5K_INIT_SLOT_TIME_TURBO) <<
 				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
 				AR5K_IFS0);
 		} else {
 			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
-				(ah->ah_aifs + tq->tqi_aifs) *
-				AR5K_INIT_SLOT_TIME) << AR5K_IFS0_DIFS_S) |
+				tq->tqi_aifs * AR5K_INIT_SLOT_TIME) <<
+				AR5K_IFS0_DIFS_S) |
 				AR5K_INIT_SIFS, AR5K_IFS0);
 		}
 
@@ -248,35 +281,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	}
 
 	/*
-	 * Calculate cwmin/max by channel mode
-	 */
-	cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN;
-	cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX;
-	ah->ah_aifs = AR5K_TUNE_AIFS;
-	/*XR is only supported on 5212*/
-	if (IS_CHAN_XR(ah->ah_current_channel) &&
-			ah->ah_version == AR5K_AR5212) {
-		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_XR;
-		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_XR;
-		ah->ah_aifs = AR5K_TUNE_AIFS_XR;
-	/*B mode is not supported on 5210*/
-	} else if (IS_CHAN_B(ah->ah_current_channel) &&
-			ah->ah_version != AR5K_AR5210) {
-		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_11B;
-		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_11B;
-		ah->ah_aifs = AR5K_TUNE_AIFS_11B;
-	}
-
-	cw_min = 1;
-	while (cw_min < ah->ah_cw_min)
-		cw_min = (cw_min << 1) | 1;
-
-	cw_min = tq->tqi_cw_min < 0 ? (cw_min >> (-tq->tqi_cw_min)) :
-		((cw_min << tq->tqi_cw_min) + (1 << tq->tqi_cw_min) - 1);
-	cw_max = tq->tqi_cw_max < 0 ? (cw_max >> (-tq->tqi_cw_max)) :
-		((cw_max << tq->tqi_cw_max) + (1 << tq->tqi_cw_max) - 1);
-
-	/*
 	 * Calculate and set retry limits
 	 */
 	if (ah->ah_software_retry) {
@@ -292,7 +296,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	/*No QCU/DCU [5210]*/
 	if (ah->ah_version == AR5K_AR5210) {
 		ath5k_hw_reg_write(ah,
-			(cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
+			(tq->tqi_cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
 			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
 				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
 			| AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
@@ -314,14 +318,13 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	/*===Rest is also for QCU/DCU only [5211+]===*/
 
 		/*
-		 * Set initial content window (cw_min/cw_max)
+		 * Set contention window (cw_min/cw_max)
 		 * and arbitrated interframe space (aifs)...
 		 */
 		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
-			AR5K_REG_SM(cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
-			AR5K_REG_SM(ah->ah_aifs + tq->tqi_aifs,
-				AR5K_DCU_LCL_IFS_AIFS),
+			AR5K_REG_SM(tq->tqi_cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
+			AR5K_REG_SM(tq->tqi_cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
+			AR5K_REG_SM(tq->tqi_aifs, AR5K_DCU_LCL_IFS_AIFS),
 			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
 
 		/*

