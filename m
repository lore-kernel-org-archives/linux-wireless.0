Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KTH5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:31 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:30 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 02/13] ath5k: Maintain PISR snapshot
Date: Sun, 20 Nov 2011 09:56:17 +0200
Message-Id: <1321775788-12520-3-git-send-email-mickflemm@gmail.com> (sfid-20111120_085734_814369_5F4A3CD2)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we dont read a snapshot of the interrupt
registers it might be possible to get a new interrupt
while reading them. In this case we should make sure
that we clear all SISR bits we get from PISR.

Tested on an AR2425

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/dma.c |   49 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath5k/reg.h |   12 +++++++-
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 3a14475..6a7b907 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -578,16 +578,59 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 			return -ENODEV;
 		}
 
+		/* Sanity checks:
+		 * Since we read these registers sequentialy
+		 * we might get a new interrupt while reading
+		 * e.g. SISR0 that we didn't catch when reading
+		 * PISR. So since we are going to handle it on
+		 * this run of get_isr, we need to clear it
+		 * from PISR also (PISR contains the logical OR of
+		 * various interrupt bits from SISRs -see reg.h).
+		 *
+		 * NOTE: We could check if PISR is inconsistent
+		 * with SISRs but it 'll take more time for no
+		 * reason. If e.g. a TXOK bit is set on SISR0
+		 * it 'll also get set on PISR by hw anyway. */
+
 		sisr0 = ath5k_hw_reg_read(ah, AR5K_SISR0);
+		if (sisr0 & AR5K_SISR0_QCU_TXOK)
+			pisr |= AR5K_ISR_TXOK;
+		if (sisr0 & AR5K_SISR0_QCU_TXDESC)
+			pisr |= AR5K_ISR_TXDESC;
+
 		sisr1 = ath5k_hw_reg_read(ah, AR5K_SISR1);
+		if (sisr1 & AR5K_SISR1_QCU_TXERR)
+			pisr |= AR5K_ISR_TXERR;
+		if (sisr1 & AR5K_SISR1_QCU_TXEOL)
+			pisr |= AR5K_ISR_TXEOL;
+
 		sisr2 = ath5k_hw_reg_read(ah, AR5K_SISR2);
+		if (sisr2 & AR5K_SISR2_QCU_TXURN)
+			pisr |= AR5K_ISR_TXURN;
+		if (sisr2 & (AR5K_SISR2_MCABT | AR5K_SISR2_SSERR
+		| AR5K_SISR2_DPERR))
+			pisr |= AR5K_ISR_HIUERR;
+		if (sisr2 & (AR5K_SISR2_TIM | AR5K_SISR2_CAB_END
+		| AR5K_SISR2_DTIM_SYNC | AR5K_SISR2_BCN_TIMEOUT
+		| AR5K_SISR2_CAB_TIMEOUT | AR5K_SISR2_DTIM))
+			pisr |= AR5K_ISR_BCNMISC;
+		/* XXX: How about TSFOOR ? Docs say nothing about
+		 * it being bart of BCNMISC, it doesn't make sense ! */
+
 		sisr3 = ath5k_hw_reg_read(ah, AR5K_SISR3);
-		sisr4 = ath5k_hw_reg_read(ah, AR5K_SISR4);
+		if (sisr3 & AR5K_SISR3_QCBRORN)
+			pisr |= AR5K_ISR_QCBRORN;
+		if (sisr3 & AR5K_SISR3_QCBRURN)
+			pisr |= AR5K_ISR_QCBRURN;
 
+		sisr4 = ath5k_hw_reg_read(ah, AR5K_SISR4);
+		if (sisr4 & AR5K_SISR4_QTRIG)
+			pisr |= AR5K_ISR_QTRIG;
 
 		/*
 		 * Write to clear them...
-		 * Note: This means that each bit we write back
+		 *
+		 * NOTE: This means that each bit we write back
 		 * to the registers will get cleared, leaving the
 		 * rest unaffected. So this won't affect new interrupts
 		 * we didn't catch while reading/processing, we 'll get
@@ -634,9 +677,11 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 						AR5K_SISR2_QCU_TXURN);
 
 		/* Misc Beacon related interrupts */
+		/* This one is for 5211 */
 		if (pisr & AR5K_ISR_TIM)
 			*interrupt_mask |= AR5K_INT_TIM;
 
+		/* For 5212+ */
 		if (pisr & AR5K_ISR_BCNMISC) {
 			if (sisr2 & AR5K_SISR2_TIM)
 				*interrupt_mask |= AR5K_INT_TIM;
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 688d509..99bbfb4 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -280,6 +280,10 @@
  * 5211/5212 we have one primary and 4 secondary registers.
  * So we have AR5K_ISR for 5210 and AR5K_PISR /SISRx for 5211/5212.
  * Most of these bits are common for all chipsets.
+ *
+ * NOTE: On 5211+ TXOK, TXDESC, TXERR, TXEOL and TXURN contain
+ * the logical OR from per-queue interrupt bits found on SISR registers
+ * (see below).
  */
 #define AR5K_ISR		0x001c			/* Register Address [5210] */
 #define AR5K_PISR		0x0080			/* Register Address [5211+] */
@@ -292,7 +296,10 @@
 #define AR5K_ISR_TXOK		0x00000040	/* Frame successfully transmitted */
 #define AR5K_ISR_TXDESC		0x00000080	/* TX descriptor request */
 #define AR5K_ISR_TXERR		0x00000100	/* Transmit error */
-#define AR5K_ISR_TXNOFRM	0x00000200	/* No frame transmitted (transmit timeout) */
+#define AR5K_ISR_TXNOFRM	0x00000200	/* No frame transmitted (transmit timeout)
+						 * NOTE: We don't have per-queue info for this
+						 * one, but we can enable it per-queue through
+						 * TXNOFRM_QCU field on TXNOFRM register */
 #define AR5K_ISR_TXEOL		0x00000400	/* Empty TX descriptor */
 #define AR5K_ISR_TXURN		0x00000800	/* Transmit FIFO underrun */
 #define AR5K_ISR_MIB		0x00001000	/* Update MIB counters */
@@ -311,7 +318,8 @@
 #define AR5K_ISR_DPERR		0x00400000	/* Bus parity error [5210] */
 #define AR5K_ISR_RXDOPPLER	0x00400000	/* Doppler chirp received [5212+] */
 #define AR5K_ISR_TIM		0x00800000	/* [5211+] */
-#define AR5K_ISR_BCNMISC	0x00800000	/* 'or' of TIM, CAB_END, DTIM_SYNC, BCN_TIMEOUT,
+#define AR5K_ISR_BCNMISC	0x00800000	/* Misc beacon related interrupt
+						 * 'or' of TIM, CAB_END, DTIM_SYNC, BCN_TIMEOUT,
 						 * CAB_TIMEOUT and DTIM bits from SISR2 [5212+] */
 #define AR5K_ISR_GPIO		0x01000000	/* GPIO (rf kill) */
 #define AR5K_ISR_QCBRORN	0x02000000	/* QCU CBR overrun [5211+] */
-- 
1.7.8.rc1

