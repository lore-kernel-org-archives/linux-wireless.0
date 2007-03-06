Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:62888 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863AbXCFB36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 20:29:58 -0500
Date: Mon, 05 Mar 2007 19:28:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: stable@kernel.org
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix assertion failures in interrupt handler
Message-ID: <45ecc3a0.8we8IxI7lp6G5Y6l%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Roskin <proski@gnu.org>

In the bcm43xx interrupt handler, sanity checks are wrongly done before the
verification that the interrupt is for the bcm43xx.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index 057541f..21d4ecd 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1858,9 +1858,6 @@ static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
 
 	spin_lock(&bcm->irq_lock);
 
-	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
-	assert(bcm->current_core->id == BCM43xx_COREID_80211);
-
 	reason = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
 	if (reason == 0xffffffff) {
 		/* irq not for us (shared irq) */
@@ -1871,6 +1868,9 @@ static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
 	if (!reason)
 		goto out;
 
+	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
+	assert(bcm->current_core->id == BCM43xx_COREID_80211);
+
 	bcm->dma_reason[0] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA0_REASON)
 			     & 0x0001DC00;
 	bcm->dma_reason[1] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA1_REASON)

---

