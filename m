Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55599 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2LJGyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 01:54:02 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>, stable@vger.kernel.org
Subject: [PATCH] bcma: mips: fix clearing device IRQ
Date: Mon, 10 Dec 2012 07:53:56 +0100
Message-Id: <1355122436-32196-1-git-send-email-zajec5@gmail.com> (sfid-20121210_075407_932822_7D3E1A9C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were using wrong IRQ number so clearing wasn't working at all.
Depending on a platform this could result in a one device having two
interrupts assigned. On BCM4706 this resulted in all IRQs being broken.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stable@vger.kernel.org
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: I guess it's too late for 3.7 fixes, so I just hope it'll hit
      3.7.x (and olders) via stable.
---
 drivers/bcma/driver_mips.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index c45ded8..792daad 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -115,7 +115,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
 			    ~(1 << irqflag));
 	else
-		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 0);
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(oldirq), 0);
 
 	/* assign the new one */
 	if (irq == 0) {
-- 
1.7.7

