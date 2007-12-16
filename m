Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:59720 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbXLPA65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 19:58:57 -0500
Date: Sun, 16 Dec 2007 02:58:57 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 4/9] ath5k: Implement per-queue interrupts
Message-ID: <20071216005857.GD5482@makis.domain.invalid> (sfid-20071216_005900_315489_8697AC7F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Implement per-queue interrupt handling. For now treat TXDESC and TXEOL as INT_TX so we can handle them in base.c.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 2e13d79..a30f28c 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -339,17 +339,17 @@ enum ath5k_tx_queue_id {
 
 /*
  * Flags to set hw queue's parameters...
- * TODO: Implement missing stuff (almost there,
- * probably have to tweak with SISR).
  */
-#define AR5K_TXQ_FLAG_TXINT_ENABLE		0x0001	/* Enable TXOK and TXERR interrupts -not used- */
-#define AR5K_TXQ_FLAG_TXDESCINT_ENABLE		0x0002	/* Enable TXDESC interrupt -not implemented- */
-#define AR5K_TXQ_FLAG_BACKOFF_DISABLE		0x0004	/* Disable random post-backoff */
-#define AR5K_TXQ_FLAG_COMPRESSION_ENABLE	0x0008	/* Enable hw compression -not implemented-*/
-#define AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE	0x0010	/* Enable ready time expiry policy (?)*/
-#define AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE	0x0020	/* Enable backoff while bursting */
-#define AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS		0x0040	/* Disable backoff while bursting */
-#define AR5K_TXQ_FLAG_TXEOLINT_ENABLE		0x0080	/* Enable TXEOL interrupt -not implemented-*/
+#define AR5K_TXQ_FLAG_TXOKINT_ENABLE		0x0001	/* Enable TXOK interrupt */
+#define AR5K_TXQ_FLAG_TXERRINT_ENABLE		0x0002	/* Enable TXERR interrupt */
+#define AR5K_TXQ_FLAG_TXEOLINT_ENABLE		0x0004	/* Enable TXEOL interrupt -not used- */
+#define AR5K_TXQ_FLAG_TXDESCINT_ENABLE		0x0008	/* Enable TXDESC interrupt -not used- */
+#define AR5K_TXQ_FLAG_TXURNINT_ENABLE		0x0010	/* Enable TXURN interrupt */
+#define AR5K_TXQ_FLAG_BACKOFF_DISABLE		0x0020	/* Disable random post-backoff */
+#define AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE	0x0040	/* Enable ready time expiry policy (?)*/
+#define AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE	0x0080	/* Enable backoff while bursting */
+#define AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS		0x0100	/* Disable backoff while bursting */
+#define AR5K_TXQ_FLAG_COMPRESSION_ENABLE	0x0200	/* Enable hw compression -not implemented-*/
 
 /*
  * A struct to hold tx queue's parameters
@@ -981,8 +981,12 @@ struct ath5k_hw {
 	struct ath5k_capabilities ah_capabilities;
 
 	struct ath5k_txq_info	ah_txq[AR5K_NUM_TX_QUEUES];
-	u32			ah_txq_interrupts;
-
+	u32			ah_txq_status;
+	u32			ah_txq_imr_txok;
+	u32			ah_txq_imr_txerr;
+	u32			ah_txq_imr_txurn;
+	u32			ah_txq_imr_txdesc;
+	u32			ah_txq_imr_txeol;
 	u32			*ah_rf_banks;
 	size_t			ah_rf_banks_size;
 	struct ath5k_gain	ah_gain;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 8357cac..72d0432 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -1441,7 +1441,8 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 	if (data & (AR5K_ISR_RXOK | AR5K_ISR_RXERR))
 		*interrupt_mask |= AR5K_INT_RX;
 
-	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR))
+	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR
+		| AR5K_ISR_TXDESC | AR5K_ISR_TXEOL))
 		*interrupt_mask |= AR5K_INT_TX;
 
 	if (ah->ah_version != AR5K_AR5210) {
@@ -3080,11 +3081,11 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 			return ret;
 	}
 	/*
-	 * We use ah_txq_interrupts to hold a temp value for
+	 * We use ah_txq_status to hold a temp value for
 	 * the Secondary interrupt mask registers on 5211+
 	 * check out ath5k_hw_reset_tx_queue
 	 */
-	AR5K_Q_ENABLE_BITS(ah->ah_txq_interrupts, queue);
+	AR5K_Q_ENABLE_BITS(ah->ah_txq_status, queue);
 
 	return queue;
 }
@@ -3136,7 +3137,7 @@ void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	/* This queue will be skipped in further operations */
 	ah->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
 	/*For SIMR setup*/
-	AR5K_Q_DISABLE_BITS(ah->ah_txq_interrupts, queue);
+	AR5K_Q_DISABLE_BITS(ah->ah_txq_status, queue);
 }
 
 /*
@@ -3371,15 +3372,41 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		}
 
 		/*
-		 * Enable tx queue in the secondary interrupt mask registers
+		 * Enable interrupts for this tx queue
+		 * in the secondary interrupt mask registers
 		 */
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_interrupts,
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXOKINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txok, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXERRINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txerr, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXURNINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txurn, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXDESCINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txdesc, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXEOLINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txeol, queue);
+
+
+		/* Update secondary interrupt mask registers */
+		ah->ah_txq_imr_txok &= ah->ah_txq_status;
+		ah->ah_txq_imr_txerr &= ah->ah_txq_status;
+		ah->ah_txq_imr_txurn &= ah->ah_txq_status;
+		ah->ah_txq_imr_txdesc &= ah->ah_txq_status;
+		ah->ah_txq_imr_txeol &= ah->ah_txq_status;
+
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txok,
 			AR5K_SIMR0_QCU_TXOK) |
-			AR5K_REG_SM(ah->ah_txq_interrupts,
+			AR5K_REG_SM(ah->ah_txq_imr_txdesc,
 			AR5K_SIMR0_QCU_TXDESC), AR5K_SIMR0);
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_interrupts,
-			AR5K_SIMR1_QCU_TXERR), AR5K_SIMR1);
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_interrupts,
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txerr,
+			AR5K_SIMR1_QCU_TXERR) |
+			AR5K_REG_SM(ah->ah_txq_imr_txeol,
+			AR5K_SIMR1_QCU_TXEOL), AR5K_SIMR1);
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txurn,
 			AR5K_SIMR2_QCU_TXURN), AR5K_SIMR2);
 	}
 



