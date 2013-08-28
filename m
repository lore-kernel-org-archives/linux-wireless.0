Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:47282
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab3H1A3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 20:29:53 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 2/2] cw1200: Prevent a lock-related hang in the cw1200_spi driver
Date: Tue, 27 Aug 2013 20:29:47 -0400
Message-Id: <1377649787-2817-2-git-send-email-pizza@shaftnet.org> (sfid-20130828_023000_957657_B704BB2F)
In-Reply-To: <1377649787-2817-1-git-send-email-pizza@shaftnet.org>
References: <1377649787-2817-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cw1200_spi driver tries to mirror the cw1200_sdio driver's lock
API, which relies on sdio_claim_host/sdio_release_host to serialize
hardware operations across multiple threads.

Unfortunately the implementation was flawed, as it lacked a way to wake 
up the lock requestor when there was contention, often resulting in a 
hang.

This problem was uncovered while trying to fix the 
spi-transfers-in-interrupt-context BUG() corrected in the previous 
patch.  Many thanks to Dave Sizeburns for his assistance in fixing this.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
Please consider this for 3.11-rc; without this patch SPI users are all 
but guaranteed to deadlock while running this driver.

 drivers/net/wireless/cw1200/cw1200_spi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index c31580b..f5e6b48 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -40,6 +40,7 @@ struct hwbus_priv {
 	struct cw1200_common	*core;
 	const struct cw1200_platform_data_spi *pdata;
 	spinlock_t		lock; /* Serialize all bus operations */
+	wait_queue_head_t       wq;
 	int claimed;
 	int irq_disabled;
 };
@@ -198,8 +199,11 @@ static void cw1200_spi_lock(struct hwbus_priv *self)
 {
 	unsigned long flags;
 
+	DECLARE_WAITQUEUE(wait, current);
+
 	might_sleep();
 
+	add_wait_queue(&self->wq, &wait);
 	spin_lock_irqsave(&self->lock, flags);
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -212,6 +216,7 @@ static void cw1200_spi_lock(struct hwbus_priv *self)
 	set_current_state(TASK_RUNNING);
 	self->claimed = 1;
 	spin_unlock_irqrestore(&self->lock, flags);
+	remove_wait_queue(&self->wq, &wait);
 
 	return;
 }
@@ -223,6 +228,8 @@ static void cw1200_spi_unlock(struct hwbus_priv *self)
 	spin_lock_irqsave(&self->lock, flags);
 	self->claimed = 0;
 	spin_unlock_irqrestore(&self->lock, flags);
+	wake_up(&self->wq);
+
 	return;
 }
 
@@ -413,6 +420,8 @@ static int cw1200_spi_probe(struct spi_device *func)
 
 	spi_set_drvdata(func, self);
 
+	init_waitqueue_head(&self->wq);
+
 	status = cw1200_spi_irq_subscribe(self);
 
 	status = cw1200_core_probe(&cw1200_spi_hwbus_ops,
-- 
1.8.3.1

