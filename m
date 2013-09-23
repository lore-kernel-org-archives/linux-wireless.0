Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:38578
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab3IWUAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 16:00:10 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 3.12 1/2] Revert "cw1200: Don't perform SPI transfers in interrupt context"
Date: Mon, 23 Sep 2013 16:00:03 -0400
Message-Id: <1379966404-7047-2-git-send-email-pizza@shaftnet.org> (sfid-20130923_220025_689937_253D9A26)
In-Reply-To: <1379966404-7047-1-git-send-email-pizza@shaftnet.org>
References: <1379966404-7047-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit aec8e88c947b7017e2b4bbcb68a4bfc4a1f8ad35.

This solution turned out to cause interrupt delivery problems, and
rather than trying to fix this approach, it has been scrapped in favor
of an alternative (and far simpler) implementation.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_spi.c | 19 +++----------------
 drivers/net/wireless/cw1200/fwio.c       |  2 +-
 drivers/net/wireless/cw1200/hwbus.h      |  1 -
 drivers/net/wireless/cw1200/hwio.c       | 15 ---------------
 4 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index f5e6b48..5a64ac9 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -42,7 +42,6 @@ struct hwbus_priv {
 	spinlock_t		lock; /* Serialize all bus operations */
 	wait_queue_head_t       wq;
 	int claimed;
-	int irq_disabled;
 };
 
 #define SDIO_TO_SPI_ADDR(addr) ((addr & 0x1f)>>2)
@@ -238,8 +237,6 @@ static irqreturn_t cw1200_spi_irq_handler(int irq, void *dev_id)
 	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
-		disable_irq_nosync(self->func->irq);
-		self->irq_disabled = 1;
 		cw1200_irq_handler(self->core);
 		return IRQ_HANDLED;
 	} else {
@@ -273,22 +270,13 @@ exit:
 
 static int cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
 {
+	int ret = 0;
+
 	pr_debug("SW IRQ unsubscribe\n");
 	disable_irq_wake(self->func->irq);
 	free_irq(self->func->irq, self);
 
-	return 0;
-}
-
-static int cw1200_spi_irq_enable(struct hwbus_priv *self, int enable)
-{
-	/* Disables are handled by the interrupt handler */
-	if (enable && self->irq_disabled) {
-		enable_irq(self->func->irq);
-		self->irq_disabled = 0;
-	}
-
-	return 0;
+	return ret;
 }
 
 static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
@@ -368,7 +356,6 @@ static struct hwbus_ops cw1200_spi_hwbus_ops = {
 	.unlock			= cw1200_spi_unlock,
 	.align_size		= cw1200_spi_align_size,
 	.power_mgmt		= cw1200_spi_pm,
-	.irq_enable             = cw1200_spi_irq_enable,
 };
 
 /* Probe Function to be called by SPI stack when device is discovered */
diff --git a/drivers/net/wireless/cw1200/fwio.c b/drivers/net/wireless/cw1200/fwio.c
index 0b2061b..acdff0f 100644
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -485,7 +485,7 @@ int cw1200_load_firmware(struct cw1200_common *priv)
 
 	/* Enable interrupt signalling */
 	priv->hwbus_ops->lock(priv->hwbus_priv);
-	ret = __cw1200_irq_enable(priv, 2);
+	ret = __cw1200_irq_enable(priv, 1);
 	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	if (ret < 0)
 		goto unsubscribe;
diff --git a/drivers/net/wireless/cw1200/hwbus.h b/drivers/net/wireless/cw1200/hwbus.h
index 51dfb3a..8b2fc83 100644
--- a/drivers/net/wireless/cw1200/hwbus.h
+++ b/drivers/net/wireless/cw1200/hwbus.h
@@ -28,7 +28,6 @@ struct hwbus_ops {
 	void (*unlock)(struct hwbus_priv *self);
 	size_t (*align_size)(struct hwbus_priv *self, size_t size);
 	int (*power_mgmt)(struct hwbus_priv *self, bool suspend);
-	int (*irq_enable)(struct hwbus_priv *self, int enable);
 };
 
 #endif /* CW1200_HWBUS_H */
diff --git a/drivers/net/wireless/cw1200/hwio.c b/drivers/net/wireless/cw1200/hwio.c
index 41bd761..ff230b7 100644
--- a/drivers/net/wireless/cw1200/hwio.c
+++ b/drivers/net/wireless/cw1200/hwio.c
@@ -273,21 +273,6 @@ int __cw1200_irq_enable(struct cw1200_common *priv, int enable)
 	u16 val16;
 	int ret;
 
-	/* We need to do this hack because the SPI layer can sleep on I/O
-	   and the general path involves I/O to the device in interrupt
-	   context.
-
-	   However, the initial enable call needs to go to the hardware.
-
-	   We don't worry about shutdown because we do a full reset which
-	   clears the interrupt enabled bits.
-	*/
-	if (priv->hwbus_ops->irq_enable) {
-		ret = priv->hwbus_ops->irq_enable(priv->hwbus_priv, enable);
-		if (ret || enable < 2)
-			return ret;
-	}
-
 	if (HIF_8601_SILICON == priv->hw_type) {
 		ret = __cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, &val32);
 		if (ret < 0) {
-- 
1.8.3.1

