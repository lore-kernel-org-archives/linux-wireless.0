Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53834 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZDEVEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 17:04:15 -0400
Received: by bwz17 with SMTP id 17so1627594bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 05 Apr 2009 14:04:12 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] p54spi: get rid of busy-wait loops
Date: Mon,  6 Apr 2009 01:03:09 +0400
Message-Id: <1238965389-5706-1-git-send-email-jcmvbkbc@gmail.com> (sfid-20090405_230419_047866_3E0935F0)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54spi_wakeup and p54spi_tx_frame used busy-waiting loop
to poll for 'ready' bits in SPI_ADRS_HOST_INTERRUPTS register.
With this change in place 'WR_READY timeout' messages do not
show anymore.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---

I wish I knew for sure why. My guess is that busy-waiting
somehow interferes with SPI transfer scheduling.

 drivers/net/wireless/p54/p54spi.c |   41 ++++++++++++------------------------
 1 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 2903672..e4e708e 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -153,14 +153,13 @@ static const struct p54spi_spi_reg p54spi_registers_array[] =
 static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
 {
 	int i;
-	__le32 buffer;
 
 	for (i = 0; i < 2000; i++) {
-		p54spi_spi_read(priv, reg, &buffer, sizeof(buffer));
+		__le32 buffer = p54spi_read32(priv, reg);
 		if ((buffer & bits) == bits)
 			return 1;
 
-		msleep(1);
+		msleep(0);
 	}
 	return 0;
 }
@@ -171,10 +170,10 @@ static int p54spi_spi_write_dma(struct p54s_priv *priv, __le32 base,
 	p54spi_write16(priv, SPI_ADRS_DMA_WRITE_CTRL,
 		       cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE));
 
-	if (p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
-			    cpu_to_le32(HOST_ALLOWED)) == 0) {
+	if (!p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
+			     cpu_to_le32(HOST_ALLOWED))) {
 		dev_err(&priv->spi->dev, "spi_write_dma not allowed "
-			"to DMA write.");
+			"to DMA write.\n");
 		return -EAGAIN;
 	}
 
@@ -316,21 +315,15 @@ static inline void p54spi_int_ack(struct p54s_priv *priv, u32 val)
 
 static void p54spi_wakeup(struct p54s_priv *priv)
 {
-	unsigned long timeout;
-	u32 ints;
-
 	/* wake the chip */
 	p54spi_write32(priv, SPI_ADRS_ARM_INTERRUPTS,
 		       cpu_to_le32(SPI_TARGET_INT_WAKEUP));
 
 	/* And wait for the READY interrupt */
-	timeout = jiffies + HZ;
-
-	ints =  p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
-	while (!(ints & SPI_HOST_INT_READY)) {
-		if (time_after(jiffies, timeout))
-				goto out;
-		ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+	if (!p54spi_wait_bit(priv, SPI_ADRS_HOST_INTERRUPTS,
+			     cpu_to_le32(SPI_HOST_INT_READY))) {
+		dev_err(&priv->spi->dev, "INT_READY timeout\n");
+		goto out;
 	}
 
 	p54spi_int_ack(priv, SPI_HOST_INT_READY);
@@ -418,9 +411,7 @@ static irqreturn_t p54spi_interrupt(int irq, void *config)
 static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
 {
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
-	unsigned long timeout;
 	int ret = 0;
-	u32 ints;
 
 	p54spi_wakeup(priv);
 
@@ -428,15 +419,11 @@ static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
 	if (ret < 0)
 		goto out;
 
-	timeout = jiffies + 2 * HZ;
-	ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
-	while (!(ints & SPI_HOST_INT_WR_READY)) {
-		if (time_after(jiffies, timeout)) {
-			dev_err(&priv->spi->dev, "WR_READY timeout\n");
-			ret = -1;
-			goto out;
-		}
-		ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+	if (!p54spi_wait_bit(priv, SPI_ADRS_HOST_INTERRUPTS,
+			     cpu_to_le32(SPI_HOST_INT_WR_READY))) {
+		dev_err(&priv->spi->dev, "WR_READY timeout\n");
+		ret = -1;
+		goto out;
 	}
 
 	p54spi_int_ack(priv, SPI_HOST_INT_WR_READY);
-- 
1.5.4.3

