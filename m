Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:48869 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbZFLJrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 05:47:37 -0400
Date: Fri, 12 Jun 2009 11:47:10 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Cc: dcbw@redhat.com, libertas-dev@lists.infradead.org,
	andrey@cozybit.com
Subject: [PATCH] net/libertas: don't recursive spin lock in if_spi_e2h()
Message-ID: <20090612094710.GA28098@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

|BUG: spinlock recursion on CPU#0, lbs_spi_thread/1030
| lock: dee9a1bc, .magic: dead4ead, .owner: lbs_spi_thread/1030, .owner_cpu: 0
|Call Trace:
|[deec3eb0] [c0007220] show_stack+0x4c/0x15c (unreliable)
|[deec3ef0] [c0187720] spin_bug+0x9c/0xb0
|[deec3f10] [c0187890] _raw_spin_lock+0x54/0x148
|[deec3f40] [c02d260c] _spin_lock_irqsave+0x2c/0x44
|[deec3f60] [e8671800] lbs_queue_event+0x7c/0x130 [libertas]
|[deec3f80] [e8725f04] lbs_spi_thread+0x538/0x58c [libertas_spi]
|[deec3fe0] [c004f270] kthread+0x4c/0x88
|[deec3ff0] [c000f33c] kernel_thread+0x4c/0x68

if_spi_e2h() is grabbing ->driver_lock just while calling
lbs_queue_event() which is grabbing the same lock.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/libertas/if_spi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index f8c2898..b3be25b 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -827,10 +827,7 @@ static void if_spi_e2h(struct if_spi_card *card)
 	/* generate a card interrupt */
 	spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG, IF_SPI_CIC_HOST_EVENT);
 
-	spin_lock_irqsave(&priv->driver_lock, flags);
 	lbs_queue_event(priv, cause & 0xff);
-	spin_unlock_irqrestore(&priv->driver_lock, flags);
-
 out:
 	if (err)
 		lbs_pr_err("%s: error %d\n", __func__, err);
-- 
1.6.0.6

