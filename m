Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:34732 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYJZSkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 14:40:06 -0400
Date: Sun, 26 Oct 2008 20:40:25 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: Re: [PATCH] ath5k: Update interrupt masking code
Message-ID: <20081026184025.GA22654@makis> (sfid-20081026_194014_130617_ACBA7643)
References: <20081026031957.GA3090@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081026031957.GA3090@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  *Properly get/set all available ISR/IMR values and review common/uncommon bits
  *Better handling of per-txq interrupts (we can now resolve what q is generating
   each interrupt -this will help in debuging wme later)
  *Some minor updates from legacy-hal
  *Properly handle RXNOFRM and TXNOFRM interrupt masking (even when we don't set
   them on IMR they keep showing up, so we disable them by zeroing AR5K_RXNOFRM
   and AR5K_TXNOFRM registers). This doesn't exist on legacy-hal but i've tested
   it on various cards and it works fine.

  *v2: Fix shift for TXNOFRM
 
  Changes-Licensed-under: ISC
  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
 
---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 53ea439..b117920 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -507,11 +507,15 @@ enum ath5k_tx_queue_id {
 #define AR5K_TXQ_FLAG_TXEOLINT_ENABLE		0x0004	/* Enable TXEOL interrupt -not used- */
 #define AR5K_TXQ_FLAG_TXDESCINT_ENABLE		0x0008	/* Enable TXDESC interrupt -not used- */
 #define AR5K_TXQ_FLAG_TXURNINT_ENABLE		0x0010	/* Enable TXURN interrupt */
-#define AR5K_TXQ_FLAG_BACKOFF_DISABLE		0x0020	/* Disable random post-backoff */
-#define AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE	0x0040	/* Enable ready time expiry policy (?)*/
-#define AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE	0x0080	/* Enable backoff while bursting */
-#define AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS		0x0100	/* Disable backoff while bursting */
-#define AR5K_TXQ_FLAG_COMPRESSION_ENABLE	0x0200	/* Enable hw compression -not implemented-*/
+#define AR5K_TXQ_FLAG_CBRORNINT_ENABLE		0x0020	/* Enable CBRORN interrupt */
+#define AR5K_TXQ_FLAG_CBRURNINT_ENABLE		0x0040	/* Enable CBRURN interrupt */
+#define AR5K_TXQ_FLAG_QTRIGINT_ENABLE		0x0080	/* Enable QTRIG interrupt */
+#define AR5K_TXQ_FLAG_TXNOFRMINT_ENABLE		0x0100	/* Enable TXNOFRM interrupt */
+#define AR5K_TXQ_FLAG_BACKOFF_DISABLE		0x0200	/* Disable random post-backoff */
+#define AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE	0x0300	/* Enable ready time expiry policy (?)*/
+#define AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE	0x0800	/* Enable backoff while bursting */
+#define AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS		0x1000	/* Disable backoff while bursting */
+#define AR5K_TXQ_FLAG_COMPRESSION_ENABLE	0x2000	/* Enable hw compression -not implemented-*/
 
 /*
  * A struct to hold tx queue's parameters
@@ -853,7 +857,7 @@ enum ath5k_ant_setting {
  * 	checked. We should do this with ath5k_hw_update_mib_counters() but
  * 	it seems we should also then do some noise immunity work.
  * @AR5K_INT_RXPHY: RX PHY Error
- * @AR5K_INT_RXKCM: ??
+ * @AR5K_INT_RXKCM: RX Key cache miss
  * @AR5K_INT_SWBA: SoftWare Beacon Alert - indicates its time to send a
  * 	beacon that must be handled in software. The alternative is if you
  * 	have VEOL support, in that case you let the hardware deal with things.
@@ -869,7 +873,7 @@ enum ath5k_ant_setting {
  * @AR5K_INT_FATAL: Fatal errors were encountered, typically caused by DMA
  * 	errors. These types of errors we can enable seem to be of type
  * 	AR5K_SIMR2_MCABT, AR5K_SIMR2_SSERR and AR5K_SIMR2_DPERR.
- * @AR5K_INT_GLOBAL: Seems to be used to clear and set the IER
+ * @AR5K_INT_GLOBAL: Used to clear and set the IER
  * @AR5K_INT_NOCARD: signals the card has been removed
  * @AR5K_INT_COMMON: common interrupts shared amogst MACs with the same
  * 	bit value
@@ -881,36 +885,61 @@ enum ath5k_ant_setting {
  * MACs.
  */
 enum ath5k_int {
-	AR5K_INT_RX	= 0x00000001, /* Not common */
+	AR5K_INT_RXOK	= 0x00000001,
 	AR5K_INT_RXDESC	= 0x00000002,
+	AR5K_INT_RXERR	= 0x00000004,
 	AR5K_INT_RXNOFRM = 0x00000008,
 	AR5K_INT_RXEOL	= 0x00000010,
 	AR5K_INT_RXORN	= 0x00000020,
-	AR5K_INT_TX	= 0x00000040, /* Not common */
+	AR5K_INT_TXOK	= 0x00000040,
 	AR5K_INT_TXDESC	= 0x00000080,
+	AR5K_INT_TXERR	= 0x00000100,
+	AR5K_INT_TXNOFRM = 0x00000200,
+	AR5K_INT_TXEOL	= 0x00000400,
 	AR5K_INT_TXURN	= 0x00000800,
 	AR5K_INT_MIB	= 0x00001000,
+	AR5K_INT_SWI	= 0x00002000,
 	AR5K_INT_RXPHY	= 0x00004000,
 	AR5K_INT_RXKCM	= 0x00008000,
 	AR5K_INT_SWBA	= 0x00010000,
+	AR5K_INT_BRSSI	= 0x00020000,
 	AR5K_INT_BMISS	= 0x00040000,
-	AR5K_INT_BNR	= 0x00100000, /* Not common */
-	AR5K_INT_GPIO	= 0x01000000,
-	AR5K_INT_FATAL	= 0x40000000, /* Not common */
-	AR5K_INT_GLOBAL	= 0x80000000,
-
-	AR5K_INT_COMMON  = AR5K_INT_RXNOFRM
-			| AR5K_INT_RXDESC
-			| AR5K_INT_RXEOL
-			| AR5K_INT_RXORN
-			| AR5K_INT_TXURN
-			| AR5K_INT_TXDESC
-			| AR5K_INT_MIB
-			| AR5K_INT_RXPHY
-			| AR5K_INT_RXKCM
-			| AR5K_INT_SWBA
-			| AR5K_INT_BMISS
-			| AR5K_INT_GPIO,
+	AR5K_INT_FATAL	= 0x00080000, /* Non common */
+	AR5K_INT_BNR	= 0x00100000, /* Non common */
+	AR5K_INT_TIM	= 0x00200000, /* Non common */
+	AR5K_INT_DTIM	= 0x00400000, /* Non common */
+	AR5K_INT_DTIM_SYNC =	0x00800000, /* Non common */
+	AR5K_INT_GPIO	=	0x01000000,
+	AR5K_INT_BCN_TIMEOUT =	0x02000000, /* Non common */
+	AR5K_INT_CAB_TIMEOUT =	0x04000000, /* Non common */
+	AR5K_INT_RX_DOPPLER =	0x08000000, /* Non common */
+	AR5K_INT_QCBRORN =	0x10000000, /* Non common */
+	AR5K_INT_QCBRURN =	0x20000000, /* Non common */
+	AR5K_INT_QTRIG	=	0x40000000, /* Non common */
+	AR5K_INT_GLOBAL =	0x80000000,
+
+	AR5K_INT_COMMON  = AR5K_INT_RXOK
+		| AR5K_INT_RXDESC
+		| AR5K_INT_RXERR
+		| AR5K_INT_RXNOFRM
+		| AR5K_INT_RXEOL
+		| AR5K_INT_RXORN
+		| AR5K_INT_TXOK
+		| AR5K_INT_TXDESC
+		| AR5K_INT_TXERR
+		| AR5K_INT_TXNOFRM
+		| AR5K_INT_TXEOL
+		| AR5K_INT_TXURN
+		| AR5K_INT_MIB
+		| AR5K_INT_SWI
+		| AR5K_INT_RXPHY
+		| AR5K_INT_RXKCM
+		| AR5K_INT_SWBA
+		| AR5K_INT_BRSSI
+		| AR5K_INT_BMISS
+		| AR5K_INT_GPIO
+		| AR5K_INT_GLOBAL,
+
 	AR5K_INT_NOCARD	= 0xffffffff
 };
 
@@ -1081,6 +1110,11 @@ struct ath5k_hw {
 	u32			ah_txq_imr_txurn;
 	u32			ah_txq_imr_txdesc;
 	u32			ah_txq_imr_txeol;
+	u32			ah_txq_imr_cbrorn;
+	u32			ah_txq_imr_cbrurn;
+	u32			ah_txq_imr_qtrig;
+	u32			ah_txq_imr_nofrm;
+	u32			ah_txq_isr;
 	u32			*ah_rf_banks;
 	size_t			ah_rf_banks_size;
 	struct ath5k_gain	ah_gain;
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 3e0eea5..5e90ef3 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2234,7 +2234,7 @@ ath5k_init(struct ath5k_softc *sc, bool is_resume)
 	 */
 	sc->curchan = sc->hw->conf.channel;
 	sc->curband = &sc->sbands[sc->curchan->band];
-	sc->imask = AR5K_INT_RX | AR5K_INT_TX | AR5K_INT_RXEOL |
+	sc->imask = AR5K_INT_RXOK | AR5K_INT_TXOK | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL |
 		AR5K_INT_MIB;
 	ret = ath5k_reset(sc, false, false);
@@ -2421,9 +2421,10 @@ ath5k_intr(int irq, void *dev_id)
 				/* bump tx trigger level */
 				ath5k_hw_update_tx_triglevel(ah, true);
 			}
-			if (status & AR5K_INT_RX)
+			if (status & (AR5K_INT_RXOK | AR5K_INT_RXERR))
 				tasklet_schedule(&sc->rxtq);
-			if (status & AR5K_INT_TX)
+			if (status & (AR5K_INT_TXOK | AR5K_INT_TXDESC
+					| AR5K_INT_TXERR | AR5K_INT_TXEOL))
 				tasklet_schedule(&sc->txtq);
 			if (status & AR5K_INT_BMISS) {
 			}
diff --git a/drivers/net/wireless/ath5k/dma.c b/drivers/net/wireless/ath5k/dma.c
index 7adceb2..7e2b1a6 100644
--- a/drivers/net/wireless/ath5k/dma.c
+++ b/drivers/net/wireless/ath5k/dma.c
@@ -472,9 +472,6 @@ bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
  *
  * NOTE: We use read-and-clear register, so after this function is called ISR
  * is zeroed.
- *
- * XXX: Why filter interrupts in sw with interrupt_mask ? No benefit at all
- * plus it can be misleading (one might thing that we save interrupts this way)
  */
 int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 {
@@ -494,11 +491,16 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 		}
 	} else {
 		/*
-		 * Read interrupt status from the Read-And-Clear
-		 * shadow register.
+		 * Read interrupt status from Interrupt
+		 * Status Register shadow copy (Read And Clear)
+		 *
 		 * Note: PISR/SISR Not available on 5210
 		 */
 		data = ath5k_hw_reg_read(ah, AR5K_RAC_PISR);
+		if (unlikely(data == AR5K_INT_NOCARD)) {
+			*interrupt_mask = data;
+			return -ENODEV;
+		}
 	}
 
 	/*
@@ -506,17 +508,9 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 	 */
 	*interrupt_mask = (data & AR5K_INT_COMMON) & ah->ah_imr;
 
-	if (unlikely(data == AR5K_INT_NOCARD))
-		return -ENODEV;
-
-	if (data & (AR5K_ISR_RXOK | AR5K_ISR_RXERR))
-		*interrupt_mask |= AR5K_INT_RX;
-
-	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR
-		| AR5K_ISR_TXDESC | AR5K_ISR_TXEOL))
-		*interrupt_mask |= AR5K_INT_TX;
-
 	if (ah->ah_version != AR5K_AR5210) {
+		u32 sisr2 = ath5k_hw_reg_read(ah, AR5K_RAC_SISR2);
+
 		/*HIU = Host Interface Unit (PCI etc)*/
 		if (unlikely(data & (AR5K_ISR_HIUERR)))
 			*interrupt_mask |= AR5K_INT_FATAL;
@@ -524,24 +518,93 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 		/*Beacon Not Ready*/
 		if (unlikely(data & (AR5K_ISR_BNR)))
 			*interrupt_mask |= AR5K_INT_BNR;
-	}
 
-	/*
-	 * XXX: BMISS interrupts may occur after association.
-	 * I found this on 5210 code but it needs testing. If this is
-	 * true we should disable them before assoc and re-enable them
-	 * after a successfull assoc + some jiffies.
-	 */
-#if 0
-	interrupt_mask &= ~AR5K_INT_BMISS;
-#endif
+		if (unlikely(sisr2 & (AR5K_SISR2_SSERR |
+					AR5K_SISR2_DPERR |
+					AR5K_SISR2_MCABT)))
+			*interrupt_mask |= AR5K_INT_FATAL;
+
+		if (data & AR5K_ISR_TIM)
+			*interrupt_mask |= AR5K_INT_TIM;
+
+		if (data & AR5K_ISR_BCNMISC) {
+			if (sisr2 & AR5K_SISR2_TIM)
+				*interrupt_mask |= AR5K_INT_TIM;
+			if (sisr2 & AR5K_SISR2_DTIM)
+				*interrupt_mask |= AR5K_INT_DTIM;
+			if (sisr2 & AR5K_SISR2_DTIM_SYNC)
+				*interrupt_mask |= AR5K_INT_DTIM_SYNC;
+			if (sisr2 & AR5K_SISR2_BCN_TIMEOUT)
+				*interrupt_mask |= AR5K_INT_BCN_TIMEOUT;
+			if (sisr2 & AR5K_SISR2_CAB_TIMEOUT)
+				*interrupt_mask |= AR5K_INT_CAB_TIMEOUT;
+		}
+
+		if (data & AR5K_ISR_RXDOPPLER)
+			*interrupt_mask |= AR5K_INT_RX_DOPPLER;
+		if (data & AR5K_ISR_QCBRORN) {
+			*interrupt_mask |= AR5K_INT_QCBRORN;
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR3),
+					AR5K_SISR3_QCBRORN);
+		}
+		if (data & AR5K_ISR_QCBRURN) {
+			*interrupt_mask |= AR5K_INT_QCBRURN;
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR3),
+					AR5K_SISR3_QCBRURN);
+		}
+		if (data & AR5K_ISR_QTRIG) {
+			*interrupt_mask |= AR5K_INT_QTRIG;
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR4),
+					AR5K_SISR4_QTRIG);
+		}
+
+		if (data & AR5K_ISR_TXOK)
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR0),
+					AR5K_SISR0_QCU_TXOK);
+
+		if (data & AR5K_ISR_TXDESC)
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR0),
+					AR5K_SISR0_QCU_TXDESC);
+
+		if (data & AR5K_ISR_TXERR)
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR1),
+					AR5K_SISR1_QCU_TXERR);
+
+		if (data & AR5K_ISR_TXEOL)
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR1),
+					AR5K_SISR1_QCU_TXEOL);
+
+		if (data & AR5K_ISR_TXURN)
+			ah->ah_txq_isr |= AR5K_REG_MS(
+					ath5k_hw_reg_read(ah, AR5K_RAC_SISR2),
+					AR5K_SISR2_QCU_TXURN);
+	} else {
+		if (unlikely(data & (AR5K_ISR_SSERR | AR5K_ISR_MCABT
+				| AR5K_ISR_HIUERR | AR5K_ISR_DPERR)))
+			*interrupt_mask |= AR5K_INT_FATAL;
+
+		/*
+		 * XXX: BMISS interrupts may occur after association.
+		 * I found this on 5210 code but it needs testing. If this is
+		 * true we should disable them before assoc and re-enable them
+		 * after a successfull assoc + some jiffies.
+			interrupt_mask &= ~AR5K_INT_BMISS;
+		 */
+	}
 
 	/*
 	 * In case we didn't handle anything,
 	 * print the register value.
 	 */
 	if (unlikely(*interrupt_mask == 0 && net_ratelimit()))
-		ATH5K_PRINTF("0x%08x\n", data);
+		ATH5K_PRINTF("ISR: 0x%08x IMR: 0x%08x\n", data, ah->ah_imr);
 
 	return 0;
 }
@@ -560,14 +623,17 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 {
 	enum ath5k_int old_mask, int_mask;
 
+	old_mask = ah->ah_imr;
+
 	/*
 	 * Disable card interrupts to prevent any race conditions
-	 * (they will be re-enabled afterwards).
+	 * (they will be re-enabled afterwards if AR5K_INT GLOBAL
+	 * is set again on the new mask).
 	 */
-	ath5k_hw_reg_write(ah, AR5K_IER_DISABLE, AR5K_IER);
-	ath5k_hw_reg_read(ah, AR5K_IER);
-
-	old_mask = ah->ah_imr;
+	if (old_mask & AR5K_INT_GLOBAL) {
+		ath5k_hw_reg_write(ah, AR5K_IER_DISABLE, AR5K_IER);
+		ath5k_hw_reg_read(ah, AR5K_IER);
+	}
 
 	/*
 	 * Add additional, chipset-dependent interrupt mask flags
@@ -575,30 +641,64 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 	 */
 	int_mask = new_mask & AR5K_INT_COMMON;
 
-	if (new_mask & AR5K_INT_RX)
-		int_mask |= AR5K_IMR_RXOK | AR5K_IMR_RXERR | AR5K_IMR_RXORN |
-			AR5K_IMR_RXDESC;
-
-	if (new_mask & AR5K_INT_TX)
-		int_mask |= AR5K_IMR_TXOK | AR5K_IMR_TXERR | AR5K_IMR_TXDESC |
-			AR5K_IMR_TXURN;
-
 	if (ah->ah_version != AR5K_AR5210) {
+		/* Preserve per queue TXURN interrupt mask */
+		u32 simr2 = ath5k_hw_reg_read(ah, AR5K_SIMR2)
+				& AR5K_SIMR2_QCU_TXURN;
+
 		if (new_mask & AR5K_INT_FATAL) {
 			int_mask |= AR5K_IMR_HIUERR;
-			AR5K_REG_ENABLE_BITS(ah, AR5K_SIMR2, AR5K_SIMR2_MCABT |
-					AR5K_SIMR2_SSERR | AR5K_SIMR2_DPERR);
+			simr2 |= (AR5K_SIMR2_MCABT | AR5K_SIMR2_SSERR
+				| AR5K_SIMR2_DPERR);
 		}
+
+		/*Beacon Not Ready*/
+		if (new_mask & AR5K_INT_BNR)
+			int_mask |= AR5K_INT_BNR;
+
+		if (new_mask & AR5K_INT_TIM)
+			int_mask |= AR5K_IMR_TIM;
+
+		if (new_mask & AR5K_INT_TIM)
+			simr2 |= AR5K_SISR2_TIM;
+		if (new_mask & AR5K_INT_DTIM)
+			simr2 |= AR5K_SISR2_DTIM;
+		if (new_mask & AR5K_INT_DTIM_SYNC)
+			simr2 |= AR5K_SISR2_DTIM_SYNC;
+		if (new_mask & AR5K_INT_BCN_TIMEOUT)
+			simr2 |= AR5K_SISR2_BCN_TIMEOUT;
+		if (new_mask & AR5K_INT_CAB_TIMEOUT)
+			simr2 |= AR5K_SISR2_CAB_TIMEOUT;
+
+		if (new_mask & AR5K_INT_RX_DOPPLER)
+			int_mask |= AR5K_IMR_RXDOPPLER;
+
+		/* Note: Per queue interrupt masks
+		 * are set via reset_tx_queue (qcu.c) */
+		ath5k_hw_reg_write(ah, int_mask, AR5K_PIMR);
+		ath5k_hw_reg_write(ah, simr2, AR5K_SIMR2);
+
+	} else {
+		if (new_mask & AR5K_INT_FATAL)
+			int_mask |= (AR5K_IMR_SSERR | AR5K_IMR_MCABT
+				| AR5K_IMR_HIUERR | AR5K_IMR_DPERR);
+
+		ath5k_hw_reg_write(ah, int_mask, AR5K_IMR);
 	}
 
-	ath5k_hw_reg_write(ah, int_mask, AR5K_PIMR);
+	/* If RXNOFRM interrupt is masked disable it
+	 * by setting AR5K_RXNOFRM to zero */
+	if (!(new_mask & AR5K_INT_RXNOFRM))
+		ath5k_hw_reg_write(ah, 0, AR5K_RXNOFRM);
 
 	/* Store new interrupt mask */
 	ah->ah_imr = new_mask;
 
-	/* ..re-enable interrupts */
-	ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
-	ath5k_hw_reg_read(ah, AR5K_IER);
+	/* ..re-enable interrupts if AR5K_INT_GLOBAL is set */
+	if (new_mask & AR5K_INT_GLOBAL) {
+		ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
+		ath5k_hw_reg_read(ah, AR5K_IER);
+	}
 
 	return old_mask;
 }
diff --git a/drivers/net/wireless/ath5k/qcu.c b/drivers/net/wireless/ath5k/qcu.c
index 01bf091..1b7bc50 100644
--- a/drivers/net/wireless/ath5k/qcu.c
+++ b/drivers/net/wireless/ath5k/qcu.c
@@ -432,13 +432,30 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXEOLINT_ENABLE)
 			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txeol, queue);
 
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_CBRORNINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_cbrorn, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_CBRURNINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_cbrurn, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_QTRIGINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_qtrig, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXNOFRMINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_nofrm, queue);
 
 		/* Update secondary interrupt mask registers */
+
+		/* Filter out inactive queues */
 		ah->ah_txq_imr_txok &= ah->ah_txq_status;
 		ah->ah_txq_imr_txerr &= ah->ah_txq_status;
 		ah->ah_txq_imr_txurn &= ah->ah_txq_status;
 		ah->ah_txq_imr_txdesc &= ah->ah_txq_status;
 		ah->ah_txq_imr_txeol &= ah->ah_txq_status;
+		ah->ah_txq_imr_cbrorn &= ah->ah_txq_status;
+		ah->ah_txq_imr_cbrurn &= ah->ah_txq_status;
+		ah->ah_txq_imr_qtrig &= ah->ah_txq_status;
+		ah->ah_txq_imr_nofrm &= ah->ah_txq_status;
 
 		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txok,
 			AR5K_SIMR0_QCU_TXOK) |
@@ -448,8 +465,24 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			AR5K_SIMR1_QCU_TXERR) |
 			AR5K_REG_SM(ah->ah_txq_imr_txeol,
 			AR5K_SIMR1_QCU_TXEOL), AR5K_SIMR1);
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txurn,
-			AR5K_SIMR2_QCU_TXURN), AR5K_SIMR2);
+		/* Update simr2 but don't overwrite rest simr2 settings */
+		AR5K_REG_DISABLE_BITS(ah, AR5K_SIMR2, AR5K_SIMR2_QCU_TXURN);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_SIMR2,
+			AR5K_REG_SM(ah->ah_txq_imr_txurn,
+			AR5K_SIMR2_QCU_TXURN));
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_cbrorn,
+			AR5K_SIMR3_QCBRORN) |
+			AR5K_REG_SM(ah->ah_txq_imr_cbrurn,
+			AR5K_SIMR3_QCBRURN), AR5K_SIMR3);
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_qtrig,
+			AR5K_SIMR4_QTRIG), AR5K_SIMR4);
+		/* Set TXNOFRM_QCU for the queues with TXNOFRM enabled */
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_nofrm,
+			AR5K_TXNOFRM_QCU), AR5K_TXNOFRM);
+		/* No queue has TXNOFRM enabled, disable the interrupt
+		 * by setting AR5K_TXNOFRM to zero */
+		if (ah->ah_txq_imr_nofrm == 0)
+			ath5k_hw_reg_write(ah, 0, AR5K_TXNOFRM);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index e557fe1..5e20495 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -234,6 +234,7 @@
 #define AR5K_TXNOFRM		0x004c
 #define	AR5K_TXNOFRM_M		0x000003ff
 #define	AR5K_TXNOFRM_QCU	0x000ffc00
+#define	AR5K_TXNOFRM_QCU_S	10
 
 /*
  * Receive frame gap timeout register
@@ -350,7 +351,7 @@
 
 #define AR5K_SISR3		0x0090			/* Register Address [5211+] */
 #define AR5K_SISR3_QCBRORN	0x000003ff	/* Mask for QCBRORN */
-#define AR5K_SISR3_QCBORN_S	0
+#define AR5K_SISR3_QCBRORN_S	0
 #define AR5K_SISR3_QCBRURN	0x03ff0000	/* Mask for QCBRURN */
 #define AR5K_SISR3_QCBRURN_S	16
 
diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
index 8f18868..6fdee89 100644
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -872,8 +872,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 	/* Pre-enable interrupts on 5211/5212*/
 	if (ah->ah_version != AR5K_AR5210)
-		ath5k_hw_set_imr(ah, AR5K_INT_RX | AR5K_INT_TX |
-				AR5K_INT_FATAL);
+		ath5k_hw_set_imr(ah, ah->ah_imr);
 
 	/*
 	 * Set RF kill flags if supported by the device (read from the EEPROM)

