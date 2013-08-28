Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:47277
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab3H1A3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 20:29:52 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 1/2] cw1200:  Don't perform SPI transfers in interrupt context
Date: Tue, 27 Aug 2013 20:29:46 -0400
Message-Id: <1377649787-2817-1-git-send-email-pizza@shaftnet.org> (sfid-20130828_023000_285477_B504F4D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we get an interrupt from the hardware, the first thing the driver does
is tell the device to mask off the interrupt line.  Unfortunately this
involves a SPI transaction in interrupt context.  Some (most?) SPI
controllers perform the transfer asynchronously and try to sleep.
This is bad, and triggers a BUG().

So, work around this by using adding a hwbus hook for the cw1200 driver 
core to call.  The cw1200_spi driver translates this into 
irq_disable()/irq_enable() calls instead, which can safely be called in 
interrupt context.

Apparently the platforms I used to develop the cw1200_spi driver used 
synchronous spi_sync() implementations, which is why this didn't surface 
until now.

Many thanks to Dave Sizeburns for the inital bug report and his services 
as a tester.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
Please consider this for 3.11-rc; without this patch many SPI users
will immediately trigger a BUG().

 drivers/net/wireless/cw1200/cw1200_spi.c | 19 ++++++++++++++++---
 drivers/net/wireless/cw1200/fwio.c       |  2 +-
 drivers/net/wireless/cw1200/hwbus.h      |  1 +
 drivers/net/wireless/cw1200/hwio.c       | 15 +++++++++++++++
 4 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index d063760..c31580b 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -41,6 +41,7 @@ struct hwbus_priv {
 	const struct cw1200_platform_data_spi *pdata;
 	spinlock_t		lock; /* Serialize all bus operations */
 	int claimed;
+	int irq_disabled;
 };
 
 #define SDIO_TO_SPI_ADDR(addr) ((addr & 0x1f)>>2)
@@ -230,6 +231,8 @@ static irqreturn_t cw1200_spi_irq_handler(int irq, void *dev_id)
 	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
+		disable_irq_nosync(self->func->irq);
+		self->irq_disabled = 1;
 		cw1200_irq_handler(self->core);
 		return IRQ_HANDLED;
 	} else {
@@ -263,13 +266,22 @@ exit:
 
 static int cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
 {
-	int ret = 0;
-
 	pr_debug("SW IRQ unsubscribe\n");
 	disable_irq_wake(self->func->irq);
 	free_irq(self->func->irq, self);
 
-	return ret;
+	return 0;
+}
+
+static int cw1200_spi_irq_enable(struct hwbus_priv *self, int enable)
+{
+	/* Disables are handled by the interrupt handler */
+	if (enable && self->irq_disabled) {
+		enable_irq(self->func->irq);
+		self->irq_disabled = 0;
+	}
+
+	return 0;
 }
 
 static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
@@ -349,6 +361,7 @@ static struct hwbus_ops cw1200_spi_hwbus_ops = {
 	.unlock			= cw1200_spi_unlock,
 	.align_size		= cw1200_spi_align_size,
 	.power_mgmt		= cw1200_spi_pm,
+	.irq_enable             = cw1200_spi_irq_enable,
 };
 
 /* Probe Function to be called by SPI stack when device is discovered */
diff --git a/drivers/net/wireless/cw1200/fwio.c b/drivers/net/wireless/cw1200/fwio.c
index acdff0f..0b2061b 100644
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -485,7 +485,7 @@ int cw1200_load_firmware(struct cw1200_common *priv)
 
 	/* Enable interrupt signalling */
 	priv->hwbus_ops->lock(priv->hwbus_priv);
-	ret = __cw1200_irq_enable(priv, 1);
+	ret = __cw1200_irq_enable(priv, 2);
 	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	if (ret < 0)
 		goto unsubscribe;
diff --git a/drivers/net/wireless/cw1200/hwbus.h b/drivers/net/wireless/cw1200/hwbus.h
index 8b2fc83..51dfb3a 100644
--- a/drivers/net/wireless/cw1200/hwbus.h
+++ b/drivers/net/wireless/cw1200/hwbus.h
@@ -28,6 +28,7 @@ struct hwbus_ops {
 	void (*unlock)(struct hwbus_priv *self);
 	size_t (*align_size)(struct hwbus_priv *self, size_t size);
 	int (*power_mgmt)(struct hwbus_priv *self, bool suspend);
+	int (*irq_enable)(struct hwbus_priv *self, int enable);
 };
 
 #endif /* CW1200_HWBUS_H */
diff --git a/drivers/net/wireless/cw1200/hwio.c b/drivers/net/wireless/cw1200/hwio.c
index ff230b7..41bd761 100644
--- a/drivers/net/wireless/cw1200/hwio.c
+++ b/drivers/net/wireless/cw1200/hwio.c
@@ -273,6 +273,21 @@ int __cw1200_irq_enable(struct cw1200_common *priv, int enable)
 	u16 val16;
 	int ret;
 
+	/* We need to do this hack because the SPI layer can sleep on I/O
+	   and the general path involves I/O to the device in interrupt
+	   context.
+
+	   However, the initial enable call needs to go to the hardware.
+
+	   We don't worry about shutdown because we do a full reset which
+	   clears the interrupt enabled bits.
+	*/
+	if (priv->hwbus_ops->irq_enable) {
+		ret = priv->hwbus_ops->irq_enable(priv->hwbus_priv, enable);
+		if (ret || enable < 2)
+			return ret;
+	}
+
 	if (HIF_8601_SILICON == priv->hw_type) {
 		ret = __cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, &val32);
 		if (ret < 0) {
-- 
1.8.3.1

