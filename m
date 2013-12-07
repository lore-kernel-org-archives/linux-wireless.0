Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:59003 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3LGCSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 21:18:53 -0500
Received: by mail-we0-f182.google.com with SMTP id q59so1406175wes.41
        for <linux-wireless@vger.kernel.org>; Fri, 06 Dec 2013 18:18:52 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	klebanov@kit.edu, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH] ath5k: Reset Tx interrupt bits also on PISR
Date: Sat,  7 Dec 2013 02:17:40 +0000
Message-Id: <1386382660-5040-1-git-send-email-mickflemm@gmail.com> (sfid-20131207_031857_542225_E30A94AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cards don't update the PISR properly when all SISR bits
for Tx interrupts are being cleared and as a result we get
interrupt storm. Since we handle all tx queues all together
(so we don't really use the SISR bits to do per-queue interrupt
handling), we can manualy update PISR by doing a write-to-clear
on its Tx interrupt bits.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/dma.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index ce86f15..84c01c5 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -616,7 +616,16 @@ ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 		 * SISRs will also clear PISR so no need to worry here.
 		 */
 
-		pisr_clear = pisr & ~AR5K_ISR_BITS_FROM_SISRS;
+		/* XXX: There seems to be  an issue on some cards
+		 *	with tx interrupt flags not being updated
+		 *	on PISR despite that all Tx interrupt bits
+		 * 	are cleared on SISRs. Since we handle all
+		 *	Tx queues all together it shouldn't be an
+		 *	issue if we clear Tx interrupt flags also
+		 * 	on PISR to avoid that.
+		 */
+		pisr_clear = (pisr & ~AR5K_ISR_BITS_FROM_SISRS) |
+					(pisr & AR5K_INT_TX_ALL);
 
 		/*
 		 * Write to clear them...
-- 
1.8.4.4

