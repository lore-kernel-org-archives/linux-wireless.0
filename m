Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:53777 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVcQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:32:16 -0500
Date: Fri, 13 Jan 2017 22:32:08 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 34/40] rt2x00: rt2800mmio: add a workaround for spurious
 TX_FIFO_STATUS interrupts
Message-ID: <20170113213203.GA3636@makrotopia.org> (sfid-20170113_223219_217753_34C9FA99)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
[daniel@makrotopia.org: fixed indention]
---
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c | 72 ++++++++++++++++++++-----
 drivers/net/wireless/ralink/rt2x00/rt2x00.h     |  5 ++
 2 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index 5f1936aa8fa7..750a9425b5be 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -415,9 +415,9 @@ void rt2800mmio_autowake_tasklet(unsigned long data)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_autowake_tasklet);
 
-static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
+static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev,
+					  u32 status)
 {
-	u32 status;
 	int i;
 
 	/*
@@ -438,29 +438,77 @@ static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	 * Since we have only one producer and one consumer we don't
 	 * need to lock the kfifo.
 	 */
-	for (i = 0; i < rt2x00dev->tx->limit; i++) {
-		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
-
-		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
-			break;
-
+	i = 0;
+	do {
 		if (!kfifo_put(&rt2x00dev->txstatus_fifo, status)) {
-			rt2x00_warn(rt2x00dev, "TX status FIFO overrun, drop tx status report\n");
+			rt2x00_warn(rt2x00dev,
+				    "TX status FIFO overrun, drop TX status report\n");
 			break;
 		}
-	}
+
+		if (++i >= rt2x00dev->tx->limit)
+			break;
+
+		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
+	} while (rt2x00_get_field32(status, TX_STA_FIFO_VALID));
 
 	/* Schedule the tasklet for processing the tx status. */
 	tasklet_schedule(&rt2x00dev->txstatus_tasklet);
 }
 
+#define RT2800MMIO_TXSTATUS_IRQ_MAX_RETRIES	4
+
+static bool rt2800mmio_txstatus_is_spurious(struct rt2x00_dev *rt2x00dev,
+					    u32 txstatus)
+{
+	if (likely(rt2x00_get_field32(txstatus, TX_STA_FIFO_VALID))) {
+		rt2x00dev->txstatus_irq_retries = 0;
+		return false;
+	}
+
+	rt2x00dev->txstatus_irq_retries++;
+
+	/* Ensure that we don't go into an infinite IRQ loop. */
+	if (rt2x00dev->txstatus_irq_retries >=
+	    RT2800MMIO_TXSTATUS_IRQ_MAX_RETRIES) {
+		rt2x00_warn(rt2x00dev,
+			    "%u spurious TX_FIFO_STATUS interrupt(s)\n",
+			    rt2x00dev->txstatus_irq_retries);
+		rt2x00dev->txstatus_irq_retries = 0;
+		return false;
+	}
+
+	return true;
+}
+
 irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg, mask;
+	u32 txstatus = 0;
 
-	/* Read status and ACK all interrupts */
+	/* Read status */
 	rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
+		/* Due to unknown reason the hardware generates a
+		 * TX_FIFO_STATUS interrupt before the TX_STA_FIFO
+		 * register contain valid data. Read the TX status
+		 * here to see if we have to process the actual
+		 * request.
+		 */
+		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &txstatus);
+		if (rt2800mmio_txstatus_is_spurious(rt2x00dev, txstatus)) {
+			/* Remove the TX_FIFO_STATUS bit so it won't be
+			 * processed in this turn. The hardware will
+			 * generate another IRQ for us.
+			 */
+			rt2x00_set_field32(&reg,
+					   INT_SOURCE_CSR_TX_FIFO_STATUS, 0);
+		}
+	}
+
+	/* ACK interrupts */
 	rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
 	if (!reg)
@@ -477,7 +525,7 @@ irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
 	mask = ~reg;
 
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
-		rt2800mmio_txstatus_interrupt(rt2x00dev);
+		rt2800mmio_txstatus_interrupt(rt2x00dev, txstatus);
 		/*
 		 * Never disable the TX_FIFO_STATUS interrupt.
 		 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 034a07273038..c27408b494ef 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -995,6 +995,11 @@ struct rt2x00_dev {
 	int rf_channel;
 
 	/*
+	 * Counter for tx status irq retries (rt2800pci).
+	 */
+	unsigned int txstatus_irq_retries;
+
+	/*
 	 * Protect the interrupt mask register.
 	 */
 	spinlock_t irqmask_lock;
-- 
2.11.0
