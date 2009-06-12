Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34076 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbZFLTha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 15:37:30 -0400
Date: Fri, 12 Jun 2009 21:37:31 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Cc: dcbw@redhat.com, andrey@cozybit.com,
	libertas-dev@lists.infradead.org
Subject: [PATCH v2] net/libertas: don't recursive spin lock in if_spi_e2h()
Message-ID: <20090612193731.GA21528@Chamillionaire.breakpoint.cc>
References: <20090612094710.GA28098@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <20090612094710.GA28098@www.tglx.de>
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
v1..v2: remove flags

 drivers/net/wireless/libertas/if_spi.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index f8c2898..583162c 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -812,7 +812,6 @@ out:
 static void if_spi_e2h(struct if_spi_card *card)
 {
 	int err = 0;
-	unsigned long flags;
 	u32 cause;
 	struct lbs_private *priv = card->priv;
 
@@ -827,10 +826,7 @@ static void if_spi_e2h(struct if_spi_card *card)
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

