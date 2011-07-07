Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:59399 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab1GGT6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 15:58:25 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] net/b43: don't return IRQ_HANDLED if nothing was done
Date: Thu,  7 Jul 2011 21:58:10 +0200
Message-Id: <1310068690-17892-1-git-send-email-bigeasy@linutronix.de> (sfid-20110707_215830_331996_9294E237)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Compiled tested only.

 drivers/net/wireless/b43/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index eb41596..16ffee9 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1923,7 +1923,7 @@ static irqreturn_t b43_do_interrupt(struct b43_wldev *dev)
 		return IRQ_NONE;
 	reason &= dev->irq_mask;
 	if (!reason)
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	dev->dma_reason[0] = b43_read32(dev, B43_MMIO_DMA0_REASON)
 	    & 0x0001DC00;
-- 
1.7.4.4

