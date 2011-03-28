Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1C1Lgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:36:43 -0400
Received: by wwa36 with SMTP id 36so3686803wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:36:42 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/13] rt2x00: Limit rt2x00pci rxdone processing to 16 entries at once
Date: Mon, 28 Mar 2011 13:29:44 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201103281329.45470.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Instead of receiving an unlimited number of frames, stop after 16
entries and reschedule the rxdone tasklet. This allows other tasklets
to be run inbetween.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    6 ++++--
 drivers/net/wireless/rt2x00/rt2500pci.c |    6 ++++--
 drivers/net/wireless/rt2x00/rt2800pci.c |    6 ++++--
 drivers/net/wireless/rt2x00/rt2x00pci.c |    7 +++++--
 drivers/net/wireless/rt2x00/rt2x00pci.h |    5 ++++-
 drivers/net/wireless/rt2x00/rt61pci.c   |    6 ++++--
 6 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 329f328..137a24e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1368,8 +1368,10 @@ static void rt2400pci_tbtt_tasklet(unsigned long data)
 static void rt2400pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2x00pci_rxdone(rt2x00dev);
-	rt2400pci_enable_interrupt(rt2x00dev, CSR8_RXDONE);
+	if (rt2x00pci_rxdone(rt2x00dev))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
+	else
+		rt2400pci_enable_interrupt(rt2x00dev, CSR8_RXDONE);
 }
 
 static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5827787..198fc0a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1500,8 +1500,10 @@ static void rt2500pci_tbtt_tasklet(unsigned long data)
 static void rt2500pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2x00pci_rxdone(rt2x00dev);
-	rt2500pci_enable_interrupt(rt2x00dev, CSR8_RXDONE);
+	if (rt2x00pci_rxdone(rt2x00dev))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
+	else
+		rt2500pci_enable_interrupt(rt2x00dev, CSR8_RXDONE);
 }
 
 static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 808073a..4672dc9 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -806,8 +806,10 @@ static void rt2800pci_tbtt_tasklet(unsigned long data)
 static void rt2800pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2x00pci_rxdone(rt2x00dev);
-	rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
+	if (rt2x00pci_rxdone(rt2x00dev))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
+	else
+		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
 }
 
 static void rt2800pci_autowake_tasklet(unsigned long data)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 4dd82b0..9649bd0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -60,14 +60,15 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_regbusy_read);
 
-void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
+bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue = rt2x00dev->rx;
 	struct queue_entry *entry;
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
+	int max_rx = 16;
 
-	while (1) {
+	while (--max_rx) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
 		entry_priv = entry->priv_data;
 
@@ -93,6 +94,8 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		 */
 		rt2x00lib_rxdone(entry);
 	}
+
+	return !max_rx;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 746ce8f..07961b8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -101,8 +101,11 @@ struct queue_entry_priv_pci {
 /**
  * rt2x00pci_rxdone - Handle RX done events
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
+ *
+ * Returns true if there are still rx frames pending and false if all
+ * pending rx frames were processed.
  */
-void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
+bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
 
 /*
  * Device initialization handlers.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 77e8113..8ee1514 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2313,8 +2313,10 @@ static void rt61pci_tbtt_tasklet(unsigned long data)
 static void rt61pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2x00pci_rxdone(rt2x00dev);
-	rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RXDONE);
+	if (rt2x00pci_rxdone(rt2x00dev))
+		rt2x00pci_rxdone(rt2x00dev);
+	else
+		rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RXDONE);
 }
 
 static void rt61pci_autowake_tasklet(unsigned long data)
-- 
1.7.2.3

