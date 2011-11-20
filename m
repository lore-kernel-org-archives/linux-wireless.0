Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KTH53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:29 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:28 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 01/13] ath5k: Switch from read-and-clear to write-to-clear method when handling PISR/SISR registers
Date: Sun, 20 Nov 2011 09:56:16 +0200
Message-Id: <1321775788-12520-2-git-send-email-mickflemm@gmail.com> (sfid-20111120_085733_821629_F10FE5DE)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since card has 12 tx queues and we want to keep track of the interrupts
per queue we can't fit all these interrupt bits on a single register.
So we have 5 registers, the primary interrupt status register (PISR) and
the 4 secondary interupt status registers (SISRs).

In order to be able to read them all at once (atomic operation) Atheros
introduced the Read-And-Clear registers to make things easier. So when
reading RAC_PISR register, hw does a read on PISR and all SISRs, returns
the value of PISR, copies all SISR values to their shadow copies (RAC_SISRx)
and clears PISR and SISRs. This saves us from reading PISR/SISRs in a sequence.

So far we 've used this approach and MadWiFi/Windows driver etc also used it
for years.

It turns out this operation is not atomic after all (at least not on all cards)
That means it's possible to loose some interrupts because they came after the
copy step and hw cleared them on the clean step !

That's probably the reason we got missed beacons, got stuck queues etc and
couldn't figure out what was going on.

With this patch we switch from RaC operation to an alternative method (that
makes more sense IMHO anyway, I just chose to be on the safe side so far).
Instead of reading RAC registers, we read the normal PISR/SISR registers and
clear any bits we got by writing them back on the register. This will clear only
the bits we got on our read step and leave any new bits unaffected (at least
that's what docs say). So if any new interrupts come up we won't miss it.

I've tested this with an AR5213 and an AR2425 and it seems O.K.

Many thanks to Adrian Chadd for debuging this !

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    8 +-
 drivers/net/wireless/ath/ath5k/base.c  |    2 +-
 drivers/net/wireless/ath/ath5k/dma.c   |  206 +++++++++++++++++++-------------
 drivers/net/wireless/ath/ath5k/reg.h   |    9 +-
 4 files changed, 134 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index fecbcd9..0f42a57 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1187,7 +1187,13 @@ struct ath5k_hw {
 	u32			ah_txq_imr_cbrurn;
 	u32			ah_txq_imr_qtrig;
 	u32			ah_txq_imr_nofrm;
-	u32			ah_txq_isr;
+
+	u32			ah_txq_isr_txok_all;
+	u32			ah_txq_isr_txurn;
+	u32			ah_txq_isr_qcborn;
+	u32			ah_txq_isr_qcburn;
+	u32			ah_txq_isr_qtrig;
+
 	u32			*ah_rf_banks;
 	size_t			ah_rf_banks_size;
 	size_t			ah_rf_regs_count;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b346d04..c18d310 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1689,7 +1689,7 @@ ath5k_tasklet_tx(unsigned long data)
 	struct ath5k_hw *ah = (void *)data;
 
 	for (i = 0; i < AR5K_NUM_TX_QUEUES; i++)
-		if (ah->txqs[i].setup && (ah->ah_txq_isr & BIT(i)))
+		if (ah->txqs[i].setup && (ah->ah_txq_isr_txok_all & BIT(i)))
 			ath5k_tx_processq(ah, &ah->txqs[i]);
 
 	ah->tx_pending = false;
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 2481f9c..3a14475 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -450,7 +450,6 @@ int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
  *
  * XXX: Link this with tx DMA size ?
  * XXX: Use it to save interrupts ?
- * TODO: Needs testing, i think it's related to bmiss...
  */
 int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
 {
@@ -523,62 +522,122 @@ bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
  * being mapped on some standard non hw-specific positions
  * (check out &ath5k_int).
  *
- * NOTE: We use read-and-clear register, so after this function is called ISR
- * is zeroed.
+ * NOTE: We do write-to-clear, so the active PISR/SISR bits at the time this
+ * function gets called are cleared on return.
  */
 int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 {
-	u32 data;
+	u32 data = 0;
 
 	/*
-	 * Read interrupt status from the Interrupt Status register
-	 * on 5210
+	 * Read interrupt status from Primary Interrupt
+	 * Register.
+	 *
+	 * Note: PISR/SISR Not available on 5210
 	 */
 	if (ah->ah_version == AR5K_AR5210) {
-		data = ath5k_hw_reg_read(ah, AR5K_ISR);
-		if (unlikely(data == AR5K_INT_NOCARD)) {
-			*interrupt_mask = data;
+		u32 isr = 0;
+		isr = ath5k_hw_reg_read(ah, AR5K_ISR);
+		if (unlikely(isr == AR5K_INT_NOCARD)) {
+			*interrupt_mask = isr;
 			return -ENODEV;
 		}
-	} else {
+
+		/*
+		 * Filter out the non-common bits from the interrupt
+		 * status.
+		 */
+		*interrupt_mask = (isr & AR5K_INT_COMMON) & ah->ah_imr;
+
+		/* Hanlde INT_FATAL */
+		if (unlikely(isr & (AR5K_ISR_SSERR | AR5K_ISR_MCABT
+						| AR5K_ISR_DPERR)))
+			*interrupt_mask |= AR5K_INT_FATAL;
+
 		/*
-		 * Read interrupt status from Interrupt
-		 * Status Register shadow copy (Read And Clear)
-		 *
-		 * Note: PISR/SISR Not available on 5210
+		 * XXX: BMISS interrupts may occur after association.
+		 * I found this on 5210 code but it needs testing. If this is
+		 * true we should disable them before assoc and re-enable them
+		 * after a successful assoc + some jiffies.
+			interrupt_mask &= ~AR5K_INT_BMISS;
 		 */
-		data = ath5k_hw_reg_read(ah, AR5K_RAC_PISR);
-		if (unlikely(data == AR5K_INT_NOCARD)) {
-			*interrupt_mask = data;
+
+		data = isr;
+	} else {
+		u32 pisr = 0;
+		u32 sisr0 = 0;
+		u32 sisr1 = 0;
+		u32 sisr2 = 0;
+		u32 sisr3 = 0;
+		u32 sisr4 = 0;
+
+		/* Read PISR and SISRs... */
+		pisr = ath5k_hw_reg_read(ah, AR5K_PISR);
+		if (unlikely(pisr == AR5K_INT_NOCARD)) {
+			*interrupt_mask = pisr;
 			return -ENODEV;
 		}
-	}
 
-	/*
-	 * Get abstract interrupt mask (driver-compatible)
-	 */
-	*interrupt_mask = (data & AR5K_INT_COMMON) & ah->ah_imr;
+		sisr0 = ath5k_hw_reg_read(ah, AR5K_SISR0);
+		sisr1 = ath5k_hw_reg_read(ah, AR5K_SISR1);
+		sisr2 = ath5k_hw_reg_read(ah, AR5K_SISR2);
+		sisr3 = ath5k_hw_reg_read(ah, AR5K_SISR3);
+		sisr4 = ath5k_hw_reg_read(ah, AR5K_SISR4);
 
-	if (ah->ah_version != AR5K_AR5210) {
-		u32 sisr2 = ath5k_hw_reg_read(ah, AR5K_RAC_SISR2);
 
-		/*HIU = Host Interface Unit (PCI etc)*/
-		if (unlikely(data & (AR5K_ISR_HIUERR)))
-			*interrupt_mask |= AR5K_INT_FATAL;
+		/*
+		 * Write to clear them...
+		 * Note: This means that each bit we write back
+		 * to the registers will get cleared, leaving the
+		 * rest unaffected. So this won't affect new interrupts
+		 * we didn't catch while reading/processing, we 'll get
+		 * them next time get_isr gets called.
+		 */
+		ath5k_hw_reg_write(ah, sisr0, AR5K_SISR0);
+		ath5k_hw_reg_write(ah, sisr1, AR5K_SISR1);
+		ath5k_hw_reg_write(ah, sisr2, AR5K_SISR2);
+		ath5k_hw_reg_write(ah, sisr3, AR5K_SISR3);
+		ath5k_hw_reg_write(ah, sisr4, AR5K_SISR4);
+		ath5k_hw_reg_write(ah, pisr, AR5K_PISR);
 
-		/*Beacon Not Ready*/
-		if (unlikely(data & (AR5K_ISR_BNR)))
-			*interrupt_mask |= AR5K_INT_BNR;
+		/*
+		 * Filter out the non-common bits from the interrupt
+		 * status.
+		 */
+		*interrupt_mask = (pisr & AR5K_INT_COMMON) & ah->ah_imr;
 
-		if (unlikely(sisr2 & (AR5K_SISR2_SSERR |
-					AR5K_SISR2_DPERR |
-					AR5K_SISR2_MCABT)))
-			*interrupt_mask |= AR5K_INT_FATAL;
 
-		if (data & AR5K_ISR_TIM)
+		/* We treat TXOK,TXDESC, TXERR and TXEOL
+		 * the same way (schedule the tx tasklet)
+		 * so we track them all together per queue */
+		if (pisr & AR5K_ISR_TXOK)
+			ah->ah_txq_isr_txok_all |= AR5K_REG_MS(sisr0,
+						AR5K_SISR0_QCU_TXOK);
+
+		if (pisr & AR5K_ISR_TXDESC)
+			ah->ah_txq_isr_txok_all |= AR5K_REG_MS(sisr0,
+						AR5K_SISR0_QCU_TXDESC);
+
+		if (pisr & AR5K_ISR_TXERR)
+			ah->ah_txq_isr_txok_all |= AR5K_REG_MS(sisr1,
+						AR5K_SISR1_QCU_TXERR);
+
+		if (pisr & AR5K_ISR_TXEOL)
+			ah->ah_txq_isr_txok_all |= AR5K_REG_MS(sisr1,
+						AR5K_SISR1_QCU_TXEOL);
+
+		/* Currently this is not much usefull since we treat
+		 * all queues the same way if we get a TXURN (update
+		 * tx trigger level) but we might need it later on*/
+		if (pisr & AR5K_ISR_TXURN)
+			ah->ah_txq_isr_txurn |= AR5K_REG_MS(sisr2,
+						AR5K_SISR2_QCU_TXURN);
+
+		/* Misc Beacon related interrupts */
+		if (pisr & AR5K_ISR_TIM)
 			*interrupt_mask |= AR5K_INT_TIM;
 
-		if (data & AR5K_ISR_BCNMISC) {
+		if (pisr & AR5K_ISR_BCNMISC) {
 			if (sisr2 & AR5K_SISR2_TIM)
 				*interrupt_mask |= AR5K_INT_TIM;
 			if (sisr2 & AR5K_SISR2_DTIM)
@@ -591,63 +650,40 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 				*interrupt_mask |= AR5K_INT_CAB_TIMEOUT;
 		}
 
-		if (data & AR5K_ISR_RXDOPPLER)
+		/* Below interrupts are unlikely to happen */
+
+		/* HIU = Host Interface Unit (PCI etc)
+		 * Can be one of MCABT, SSERR, DPERR from SISR2 */
+		if (unlikely(pisr & (AR5K_ISR_HIUERR)))
+			*interrupt_mask |= AR5K_INT_FATAL;
+
+
+		/*Beacon Not Ready*/
+		if (unlikely(pisr & (AR5K_ISR_BNR)))
+			*interrupt_mask |= AR5K_INT_BNR;
+
+		if (unlikely(pisr & (AR5K_ISR_RXDOPPLER)))
 			*interrupt_mask |= AR5K_INT_RX_DOPPLER;
-		if (data & AR5K_ISR_QCBRORN) {
+
+		if (unlikely(pisr & (AR5K_ISR_QCBRORN))) {
 			*interrupt_mask |= AR5K_INT_QCBRORN;
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR3),
-					AR5K_SISR3_QCBRORN);
+			ah->ah_txq_isr_qcborn |= AR5K_REG_MS(sisr3,
+						AR5K_SISR3_QCBRORN);
 		}
-		if (data & AR5K_ISR_QCBRURN) {
+
+		if (unlikely(pisr & (AR5K_ISR_QCBRURN))) {
 			*interrupt_mask |= AR5K_INT_QCBRURN;
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR3),
-					AR5K_SISR3_QCBRURN);
+			ah->ah_txq_isr_qcburn |= AR5K_REG_MS(sisr3,
+						AR5K_SISR3_QCBRURN);
 		}
-		if (data & AR5K_ISR_QTRIG) {
+
+		if (unlikely(pisr & (AR5K_ISR_QTRIG))) {
 			*interrupt_mask |= AR5K_INT_QTRIG;
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR4),
-					AR5K_SISR4_QTRIG);
+			ah->ah_txq_isr_qtrig |= AR5K_REG_MS(sisr4,
+						AR5K_SISR4_QTRIG);
 		}
 
-		if (data & AR5K_ISR_TXOK)
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR0),
-					AR5K_SISR0_QCU_TXOK);
-
-		if (data & AR5K_ISR_TXDESC)
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR0),
-					AR5K_SISR0_QCU_TXDESC);
-
-		if (data & AR5K_ISR_TXERR)
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR1),
-					AR5K_SISR1_QCU_TXERR);
-
-		if (data & AR5K_ISR_TXEOL)
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR1),
-					AR5K_SISR1_QCU_TXEOL);
-
-		if (data & AR5K_ISR_TXURN)
-			ah->ah_txq_isr |= AR5K_REG_MS(
-					ath5k_hw_reg_read(ah, AR5K_RAC_SISR2),
-					AR5K_SISR2_QCU_TXURN);
-	} else {
-		if (unlikely(data & (AR5K_ISR_SSERR | AR5K_ISR_MCABT
-				| AR5K_ISR_HIUERR | AR5K_ISR_DPERR)))
-			*interrupt_mask |= AR5K_INT_FATAL;
-
-		/*
-		 * XXX: BMISS interrupts may occur after association.
-		 * I found this on 5210 code but it needs testing. If this is
-		 * true we should disable them before assoc and re-enable them
-		 * after a successful assoc + some jiffies.
-			interrupt_mask &= ~AR5K_INT_BMISS;
-		 */
+		data = pisr;
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index f5c1000..688d509 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -302,16 +302,17 @@
 #define AR5K_ISR_SWBA		0x00010000	/* Software beacon alert */
 #define AR5K_ISR_BRSSI		0x00020000	/* Beacon rssi below threshold (?) */
 #define AR5K_ISR_BMISS		0x00040000	/* Beacon missed */
-#define AR5K_ISR_HIUERR		0x00080000	/* Host Interface Unit error [5211+] */
+#define AR5K_ISR_HIUERR		0x00080000	/* Host Interface Unit error [5211+]
+						 * 'or' of MCABT, SSERR, DPERR from SISR2 */
 #define AR5K_ISR_BNR		0x00100000	/* Beacon not ready [5211+] */
 #define AR5K_ISR_MCABT		0x00100000	/* Master Cycle Abort [5210] */
 #define AR5K_ISR_RXCHIRP	0x00200000	/* CHIRP Received [5212+] */
 #define AR5K_ISR_SSERR		0x00200000	/* Signaled System Error [5210] */
-#define AR5K_ISR_DPERR		0x00400000	/* Det par Error (?) [5210] */
+#define AR5K_ISR_DPERR		0x00400000	/* Bus parity error [5210] */
 #define AR5K_ISR_RXDOPPLER	0x00400000	/* Doppler chirp received [5212+] */
 #define AR5K_ISR_TIM		0x00800000	/* [5211+] */
 #define AR5K_ISR_BCNMISC	0x00800000	/* 'or' of TIM, CAB_END, DTIM_SYNC, BCN_TIMEOUT,
-						CAB_TIMEOUT and DTIM bits from SISR2 [5212+] */
+						 * CAB_TIMEOUT and DTIM bits from SISR2 [5212+] */
 #define AR5K_ISR_GPIO		0x01000000	/* GPIO (rf kill) */
 #define AR5K_ISR_QCBRORN	0x02000000	/* QCU CBR overrun [5211+] */
 #define AR5K_ISR_QCBRURN	0x04000000	/* QCU CBR underrun [5211+] */
@@ -347,7 +348,7 @@
 #define	AR5K_SISR2_BCN_TIMEOUT	0x08000000	/* Beacon Timeout [5212+] */
 #define	AR5K_SISR2_CAB_TIMEOUT	0x10000000	/* CAB Timeout [5212+] */
 #define	AR5K_SISR2_DTIM		0x20000000	/* [5212+] */
-#define	AR5K_SISR2_TSFOOR	0x80000000	/* TSF OOR (?) */
+#define	AR5K_SISR2_TSFOOR	0x80000000	/* TSF Out of range */
 
 #define AR5K_SISR3		0x0090			/* Register Address [5211+] */
 #define AR5K_SISR3_QCBRORN	0x000003ff	/* Mask for QCBRORN */
-- 
1.7.8.rc1

