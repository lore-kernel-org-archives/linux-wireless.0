Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48394 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0KWTHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:07:20 -0500
Received: by ewy5 with SMTP id 5so2654723ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:07:19 -0800 (PST)
Date: Tue, 23 Nov 2010 21:07:04 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 13/30] ath5k: Move tx retries setting outside reset_tx_queue
Message-ID: <20101123190704.GM4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Move setting of tx retry limits on a separate function
 (we 'll clean up this AR5210 mess later)

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/qcu.c |   92 ++++++++++++++++++++-------------
 1 files changed, 56 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 00c4908..c422d5c 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -226,11 +226,61 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 \*******************************/
 
 /*
+ * Set tx retry limits on DCU
+ */
+static void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
+					unsigned int queue)
+{
+	u32 retry_lg, retry_sh;
+
+	/*
+	 * Calculate and set retry limits
+	 */
+	if (ah->ah_software_retry) {
+		/* XXX Need to test this */
+		retry_lg = ah->ah_limit_tx_retries;
+		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
+			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
+	} else {
+		retry_lg = AR5K_INIT_LG_RETRY;
+		retry_sh = AR5K_INIT_SH_RETRY;
+	}
+
+	/* Single data queue on AR5210 */
+	if (ah->ah_version == AR5K_AR5210) {
+		struct ath5k_txq_info *tq = &ah->ah_txq[queue];
+
+		if (queue > 0)
+			return;
+
+		ath5k_hw_reg_write(ah,
+			(tq->tqi_cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
+			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
+				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
+			| AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
+				AR5K_NODCU_RETRY_LMT_SSH_RETRY)
+			| AR5K_REG_SM(retry_lg, AR5K_NODCU_RETRY_LMT_LG_RETRY)
+			| AR5K_REG_SM(retry_sh, AR5K_NODCU_RETRY_LMT_SH_RETRY),
+			AR5K_NODCU_RETRY_LMT);
+	/* DCU on AR5211+ */
+	} else {
+		ath5k_hw_reg_write(ah,
+			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
+				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
+			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
+				AR5K_DCU_RETRY_LMT_SSH_RETRY) |
+			AR5K_REG_SM(retry_lg, AR5K_DCU_RETRY_LMT_LG_RETRY) |
+			AR5K_REG_SM(retry_sh, AR5K_DCU_RETRY_LMT_SH_RETRY),
+			AR5K_QUEUE_DFS_RETRY_LIMIT(queue));
+	}
+	return;
+}
+
+/*
  * Set DFS properties for a transmit queue on DCU
  */
 int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
-	u32 retry_lg, retry_sh;
 	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
 
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
@@ -271,42 +321,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
 			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
-	}
-
-	/*
-	 * Calculate and set retry limits
-	 */
-	if (ah->ah_software_retry) {
-		/* XXX Need to test this */
-		retry_lg = ah->ah_limit_tx_retries;
-		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
-			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
 	} else {
-		retry_lg = AR5K_INIT_LG_RETRY;
-		retry_sh = AR5K_INIT_SH_RETRY;
-	}
-
-	/*No QCU/DCU [5210]*/
-	if (ah->ah_version == AR5K_AR5210) {
-		ath5k_hw_reg_write(ah,
-			(tq->tqi_cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
-			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
-			| AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_NODCU_RETRY_LMT_SSH_RETRY)
-			| AR5K_REG_SM(retry_lg, AR5K_NODCU_RETRY_LMT_LG_RETRY)
-			| AR5K_REG_SM(retry_sh, AR5K_NODCU_RETRY_LMT_SH_RETRY),
-			AR5K_NODCU_RETRY_LMT);
-	} else {
-		/*QCU/DCU [5211+]*/
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
-			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_DCU_RETRY_LMT_SSH_RETRY) |
-			AR5K_REG_SM(retry_lg, AR5K_DCU_RETRY_LMT_LG_RETRY) |
-			AR5K_REG_SM(retry_sh, AR5K_DCU_RETRY_LMT_SH_RETRY),
-			AR5K_QUEUE_DFS_RETRY_LIMIT(queue));
 
 	/*===Rest is also for QCU/DCU only [5211+]===*/
 
@@ -321,6 +336,11 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
 
 		/*
+		 * Set tx retry limits for this queue
+		 */
+		ath5k_hw_set_tx_retry_limits(ah, queue);
+
+		/*
 		 * Set misc registers
 		 */
 
