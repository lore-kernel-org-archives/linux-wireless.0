Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53229 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab0KWSlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:41:25 -0500
Received: by ewy5 with SMTP id 5so2636287ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:41:23 -0800 (PST)
Date: Tue, 23 Nov 2010 20:41:15 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 02/30] ath5k: Add new function to stop rx/tx DMA
Message-ID: <20101123184115.GB4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add a new function to stop rx/tx dma and use in when reset starts

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    3 +-
 drivers/net/wireless/ath/ath5k/dma.c   |   52 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath5k/reset.c |   13 +++++---
 3 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 85ff822..629a5ee 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1180,8 +1180,9 @@ bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah);
 int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask);
 enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask);
 void ath5k_hw_update_mib_counters(struct ath5k_hw *ah);
-/* Init function */
+/* Init/Stop functions */
 void ath5k_hw_dma_init(struct ath5k_hw *ah);
+int ath5k_hw_dma_stop(struct ath5k_hw *ah);
 
 /* EEPROM access functions */
 int ath5k_eeprom_init(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index b991b05..ca0467e 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -126,7 +126,7 @@ int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 
 	/* Return if queue is declared inactive */
 	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return -EIO;
+		return -EINVAL;
 
 	if (ah->ah_version == AR5K_AR5210) {
 		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
@@ -174,7 +174,7 @@ int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
  *
  * Stop DMA transmit on a specific hw queue and drain queue so we don't
  * have any pending frames. Returns -EBUSY if we still have pending frames,
- * -EINVAL if queue number is out of range.
+ * -EINVAL if queue number is out of range or inactive.
  *
  */
 int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
@@ -186,7 +186,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 
 	/* Return if queue is declared inactive */
 	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return -EIO;
+		return -EINVAL;
 
 	if (ah->ah_version == AR5K_AR5210) {
 		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
@@ -733,3 +733,49 @@ void ath5k_hw_dma_init(struct ath5k_hw *ah)
 		ath5k_hw_set_imr(ah, ah->ah_imr);
 
 }
+
+/**
+ * ath5k_hw_dma_stop - stop DMA unit
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Stop tx/rx DMA and interrupts. Returns
+ * -EBUSY if tx or rx dma failed to stop.
+ *
+ * XXX: Sometimes DMA unit hangs and we have
+ * stuck frames on tx queues, only a reset
+ * can fix that.
+ */
+int ath5k_hw_dma_stop(struct ath5k_hw *ah)
+{
+	int i, qmax, err;
+	err = 0;
+
+	/* Disable interrupts */
+	ath5k_hw_set_imr(ah, 0);
+
+	/* Stop rx dma */
+	err = ath5k_hw_stop_rx_dma(ah);
+	if (err)
+		return err;
+
+	/* Clear any pending interrupts
+	 * and disable tx dma */
+	if (ah->ah_version != AR5K_AR5210) {
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
+		qmax = AR5K_NUM_TX_QUEUES;
+	} else {
+		/* PISR/SISR Not available on 5210 */
+		ath5k_hw_reg_read(ah, AR5K_ISR);
+		qmax = AR5K_NUM_TX_QUEUES_NOQCU;
+	}
+
+	for (i = 0; i < qmax; i++) {
+		err = ath5k_hw_stop_tx_dma(ah, i);
+		/* -EINVAL -> queue inactive */
+		if (err != -EINVAL)
+			return err;
+	}
+
+	return err;
+}
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 9dd5792..4f94a60 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -823,6 +823,14 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	mode = 0;
 
 	/*
+	 * Stop DMA
+	 *
+	 * Note: If DMA didn't stop continue
+	 * since only a reset will fix it.
+	 */
+	ath5k_hw_dma_stop(ah);
+
+	/*
 	 * Save some registers before a reset
 	 */
 	/*DCU/Antenna selection not available on 5210*/
@@ -1015,11 +1023,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 */
 	ath5k_hw_pcu_init(ah, op_mode, mode);
 
-	/* Clear any pending interrupts
-	 * PISR/SISR Not available on 5210 */
-	if (ah->ah_version != AR5K_AR5210)
-		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
-
 	/*
 	 * Initialize PHY
 	 */
