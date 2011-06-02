Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:13628 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755142Ab1FBXNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 19:13:31 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: linux-mmc@vger.kernel.org
Subject: [PATCH] libertas_sdio: handle spurious interrupts
Message-Id: <20110602231327.116A79D401C@zog.reactivated.net> (sfid-20110603_011336_128549_3497D95B)
Date: Fri,  3 Jun 2011 00:13:26 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 06e8935febe687e2a561707d4c7ca4245d261dbe adds an IRQ handling
optimization for single-function SDIO cards like this one, but at the
same time exposes a small hardware bug.

During hardware init, an interrupt is generated with (apparently) no
source. Previously, mmc threw this interrupt away, but now (due to the
optimization), the mmc layer passes this onto libertas, before it is ready
(and before it has enabled interrupts), causing a crash.

Work around this hardware bug by registering the IRQ handler later and
making it capable of handling interrupts with no cause. The change that
makes the IRQ handler registration happen later actually eliminates
the spurious interrupt as well.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_sdio.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index a7b5cb0..224e985 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -907,7 +907,7 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	card = sdio_get_drvdata(func);
 
 	cause = sdio_readb(card->func, IF_SDIO_H_INT_STATUS, &ret);
-	if (ret)
+	if (ret || !cause)
 		goto out;
 
 	lbs_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
@@ -1008,10 +1008,6 @@ static int if_sdio_probe(struct sdio_func *func,
 	if (ret)
 		goto release;
 
-	ret = sdio_claim_irq(func, if_sdio_interrupt);
-	if (ret)
-		goto disable;
-
 	/* For 1-bit transfers to the 8686 model, we need to enable the
 	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
 	 * bit to allow access to non-vendor registers. */
@@ -1083,6 +1079,21 @@ static int if_sdio_probe(struct sdio_func *func,
 		card->rx_unit = 0;
 
 	/*
+	 * Set up the interrupt handler late.
+	 *
+	 * If we set it up earlier, the (buggy) hardware generates a spurious
+	 * interrupt, even before the interrupt has been enabled, with
+	 * CCCR_INTx = 0.
+	 *
+	 * We register the interrupt handler late so that we can handle any
+	 * spurious interrupts, and also to avoid generation of that known
+	 * spurious interrupt in the first place.
+	 */
+	ret = sdio_claim_irq(func, if_sdio_interrupt);
+	if (ret)
+		goto disable;
+
+	/*
 	 * Enable interrupts now that everything is set up
 	 */
 	sdio_writeb(func, 0x0f, IF_SDIO_H_INT_MASK, &ret);
-- 
1.7.5.2

