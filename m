Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:18834 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbXJLPFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 11:05:38 -0400
Received: by el-out-1112.google.com with SMTP id v27so227283ele
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 08:05:38 -0700 (PDT)
Date: Fri, 12 Oct 2007 11:05:43 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 3/5] Don't read AR5K_RAC_PISR on AR5210, document ath5k_int
Message-ID: <20071012150543.GD9407@pogo> (sfid-20071012_160541_318263_DA3E79D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071012150438.GC9407@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR5210 does not have AR5K_RAC_PISR so do not read it. Also lets start
trying to document all hardware interrupts.

Changes-licensed-under: ISC
Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |   65 ++++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath5k/hw.c    |   15 +++++---
 2 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index c1d3c9d..09c920b 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -720,18 +720,65 @@ enum ath5k_ant_setting {
  * HAL interrupt abstraction
  */
 
-/*
+/**
+ * enum ath5k_int - Hardware interrupt masks helpers
+ *
+ * @AR5K_INT_RX: mask to identify received frame interrupts, of type
+ * 	AR5K_ISR_RXOK or AR5K_ISR_RXERR
+ * @AR5K_INT_RXDESC: Request RX descriptor/Read RX descriptor (?)
+ * @AR5K_INT_RXNOFRM: No frame received (?)
+ * @AR5K_INT_RXEOL: received End Of List for VEOL (Virtual End Of List). The
+ * 	Queue Control Unit (QCU) signals an EOL interrupt only if a descriptor's
+ * 	LinkPtr is NULL. For more details, refer to:
+ * 	http://www.freepatentsonline.com/20030225739.html
+ * @AR5K_INT_RXORN: indicates a hardware reset is required on certain hardware.
+ * 	Note that Rx overrun is not always fatal, on some chips we can continue
+ * 	operation without reseting the card, that's why int_fatal is not
+ * 	common for all chips.
+ * @AR5K_INT_TX: mask to identify received frame interrupts, of type
+ * 	AR5K_ISR_TXOK or AR5K_ISR_TXERR
+ * @AR5K_INT_TXDESC: Request TX descriptor/Read TX status descriptor (?)
+ * @AR5K_INT_TXURN: received when we should increase the TX trigger threshold
+ * 	We currently do increments on interrupt by
+ * 	(AR5K_TUNE_MAX_TX_FIFO_THRES - current_trigger_level) / 2
+ * @AR5K_INT_MIB: Indicates the Management Information Base counters should be
+ * 	checked. We should do this with ath5k_hw_update_mib_counters() but
+ * 	it seems we should also then do some noise immunity work.
+ * @AR5K_INT_RXPHY: RX PHY Error
+ * @AR5K_INT_RXKCM: ??
+ * @AR5K_INT_SWBA: SoftWare Beacon Alert - indicates its time to send a
+ * 	beacon that must be handled in software. The alternative is if you
+ * 	have VEOL support, in that case you let the hardware deal with things.
+ * @AR5K_INT_BMISS: If in STA mode this indicates we have stopped seeing
+ * 	beacons from the AP have associated with, we should probably try to
+ * 	reassociate. When in IBSS mode this might mean we have not received
+ * 	any beacons from any local stations. Note that every station in an
+ * 	IBSS schedules to send beacons at the Target Beacon Transmission Time
+ * 	(TBTT) with a random backoff.
+ * @AR5K_INT_BNR: Beacon Not Ready interrupt - ??
+ * @AR5K_INT_GPIO: GPIO interrupt is used for RF Kill, disabled for now
+ * 	until properly handled
+ * @AR5K_INT_FATAL: Fatal errors were encountered, typically caused by DMA
+ * 	errors. These types of errors we can enable seem to be of type
+ * 	AR5K_SIMR2_MCABT, AR5K_SIMR2_SSERR and AR5K_SIMR2_DPERR.
+ * @AR5K_INT_GLOBAL: Seems to be used to clear and set the IER
+ * @AR5K_INT_NOCARD: signals the card has been removed
+ * @AR5K_INT_COMMON: common interrupts shared amogst MACs with the same
+ * 	bit value
+ *
  * These are mapped to take advantage of some common bits
- * between the MAC chips, to be able to set intr properties
- * easier. Some of them are not used yet inside OpenHAL.
+ * between the MACs, to be able to set intr properties
+ * easier. Some of them are not used yet inside hw.c. Most map
+ * to the respective hw interrupt value as they are common amogst different
+ * MACs.
  */
 enum ath5k_int {
-	AR5K_INT_RX	= 0x00000001,
+	AR5K_INT_RX	= 0x00000001, /* Not common */
 	AR5K_INT_RXDESC	= 0x00000002,
 	AR5K_INT_RXNOFRM = 0x00000008,
 	AR5K_INT_RXEOL	= 0x00000010,
 	AR5K_INT_RXORN	= 0x00000020,
-	AR5K_INT_TX	= 0x00000040,
+	AR5K_INT_TX	= 0x00000040, /* Not common */
 	AR5K_INT_TXDESC	= 0x00000080,
 	AR5K_INT_TXURN	= 0x00000800,
 	AR5K_INT_MIB	= 0x00001000,
@@ -739,12 +786,11 @@ enum ath5k_int {
 	AR5K_INT_RXKCM	= 0x00008000,
 	AR5K_INT_SWBA	= 0x00010000,
 	AR5K_INT_BMISS	= 0x00040000,
-	AR5K_INT_BNR	= 0x00100000,
+	AR5K_INT_BNR	= 0x00100000, /* Not common */
 	AR5K_INT_GPIO	= 0x01000000,
-	AR5K_INT_FATAL	= 0x40000000,
+	AR5K_INT_FATAL	= 0x40000000, /* Not common */
 	AR5K_INT_GLOBAL	= 0x80000000,
 
-	/*A sum of all the common bits*/
 	AR5K_INT_COMMON  = AR5K_INT_RXNOFRM
 			| AR5K_INT_RXDESC
 			| AR5K_INT_RXEOL
@@ -757,8 +803,7 @@ enum ath5k_int {
 			| AR5K_INT_SWBA
 			| AR5K_INT_BMISS
 			| AR5K_INT_GPIO,
-	AR5K_INT_NOCARD	= 0xffffffff /*Declare that the card
-				       has been removed*/
+	AR5K_INT_NOCARD	= 0xffffffff
 };
 
 /*
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 3fa36f5..b106ead 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -1470,14 +1470,15 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 			*interrupt_mask = data;
 			return -ENODEV;
 		}
+	} else {
+		/*
+		 * Read interrupt status from the Read-And-Clear shadow register
+		 * Note: PISR/SISR Not available on 5210
+		 */
+		data = ath5k_hw_reg_read(hal, AR5K_RAC_PISR);
 	}
 
 	/*
-	 * Read interrupt status from the Read-And-Clear shadow register
-	 */
-	data = ath5k_hw_reg_read(hal, AR5K_RAC_PISR);
-
-	/*
 	 * Get abstract interrupt mask (HAL-compatible)
 	 */
 	*interrupt_mask = (data & AR5K_INT_COMMON) & hal->ah_imr;
@@ -1503,7 +1504,9 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 
 	/*
 	 * XXX: BMISS interrupts may occur after association.
-	 * I found this on 5210 code but it needs testing
+	 * I found this on 5210 code but it needs testing. If this is
+	 * true we should disable them before assoc and re-enable them
+	 * after a successfull assoc + some jiffies.
 	 */
 #if 0
 	interrupt_mask &= ~AR5K_INT_BMISS;
-- 
1.5.2.5

