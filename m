Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYEJMKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:08 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:07 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 09/16] rt2x00: Fix queue related oops in case of deselected mac80211 multi-queue feature.
Date: Sat, 10 May 2008 13:43:33 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101343.33638.IvDoorn@gmail.com> (sfid-20080510_141024_518773_0C081C23)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

With the integration of the mac80211 multiqueue patches it has become possible that the
mac80211 layer modifies the number of TX queues that is stored inside the ieee80211_hw
structure, especially when multi-queue is not selected.

The rt2x00 drivers are not well suited to handle that situation, as they allocate the
queue structures before mac80211 has modified the number of queues it is going to use,
and also expect the number of allocated queues to match the hardware implementation.

Hence, ensure that rt2x00 maintains by itself the number of queues that the hardware
supports, and, at the same time, making is not dependent on the preservation of contents
inside a mac80211 structure.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.h   |    5 +++++
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.h   |    5 +++++
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h   |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00.h      |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.h     |    5 +++++
 drivers/net/wireless/rt2x00/rt73usb.c     |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h     |    5 +++++
 15 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a8aae9a..0db4b52 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1374,7 +1374,6 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->queues = 2;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1621,6 +1620,7 @@ static const struct rt2x00_ops rt2400pci_ops = {
 	.max_ap_intf	= 1,
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
+	.tx_queues	= NUM_TX_QUEUES,
 	.rx		= &rt2400pci_queue_rx,
 	.tx		= &rt2400pci_queue_tx,
 	.bcn		= &rt2400pci_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index a5210f9..e9aa326 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -52,6 +52,11 @@
 #define RF_SIZE				0x0010
 
 /*
+ * Number of TX queues.
+ */
+#define NUM_TX_QUEUES			2
+
+/*
  * Control/Status Registers(CSR).
  * Some values are set in TU, whereas 1 TU == 1024 us.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1f99fad..b62dd59 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1692,7 +1692,6 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->queues = 2;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1933,6 +1932,7 @@ static const struct rt2x00_ops rt2500pci_ops = {
 	.max_ap_intf	= 1,
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
+	.tx_queues	= NUM_TX_QUEUES,
 	.rx		= &rt2500pci_queue_rx,
 	.tx		= &rt2500pci_queue_tx,
 	.bcn		= &rt2500pci_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 1389955..ea93b8f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -63,6 +63,11 @@
 #define RF_SIZE				0x0014
 
 /*
+ * Number of TX queues.
+ */
+#define NUM_TX_QUEUES			2
+
+/*
  * Control/Status Registers(CSR).
  * Some values are set in TU, whereas 1 TU == 1024 us.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 76ede93..2fa3840 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1590,7 +1590,6 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->queues = 2;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_usb(rt2x00dev)->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1826,6 +1825,7 @@ static const struct rt2x00_ops rt2500usb_ops = {
 	.max_ap_intf	= 1,
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
+	.tx_queues	= NUM_TX_QUEUES,
 	.rx		= &rt2500usb_queue_rx,
 	.tx		= &rt2500usb_queue_tx,
 	.bcn		= &rt2500usb_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index a37a068..7d50098 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -63,6 +63,11 @@
 #define RF_SIZE				0x0014
 
 /*
+ * Number of TX queues.
+ */
+#define NUM_TX_QUEUES			2
+
+/*
  * Control/Status Registers(CSR).
  * Some values are set in TU, whereas 1 TU == 1024 us.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6561484..6f7b34f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -591,6 +591,7 @@ struct rt2x00_ops {
 	const unsigned int max_ap_intf;
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
+	const unsigned int tx_queues;
 	const struct data_queue_desc *rx;
 	const struct data_queue_desc *tx;
 	const struct data_queue_desc *bcn;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8ca464f..c8255c9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -975,6 +975,11 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return status;
 
 	/*
+	 * Initialize HW fields.
+	 */
+	rt2x00dev->hw->queues = rt2x00dev->ops->tx_queues;
+
+	/*
 	 * Register HW.
 	 */
 	status = ieee80211_register_hw(rt2x00dev->hw);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 767e0ff..c5cedb2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -456,7 +456,7 @@ int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	unsigned int i;
 
-	for (i = 0; i < hw->queues; i++) {
+	for (i = 0; i < rt2x00dev->ops->tx_queues; i++) {
 		stats[i].len = rt2x00dev->tx[i].length;
 		stats[i].limit = rt2x00dev->tx[i].limit;
 		stats[i].count = rt2x00dev->tx[i].count;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e5b861f..95f8dd3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -34,7 +34,7 @@ struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 {
 	int atim = test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 
-	if (queue < rt2x00dev->hw->queues && rt2x00dev->tx)
+	if (queue < rt2x00dev->ops->tx_queues && rt2x00dev->tx)
 		return &rt2x00dev->tx[queue];
 
 	if (!rt2x00dev->bcn)
@@ -255,11 +255,11 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * We need the following queues:
 	 * RX: 1
-	 * TX: hw->queues
+	 * TX: ops->tx_queues
 	 * Beacon: 1
 	 * Atim: 1 (if required)
 	 */
-	rt2x00dev->data_queues = 2 + rt2x00dev->hw->queues + req_atim;
+	rt2x00dev->data_queues = 2 + rt2x00dev->ops->tx_queues + req_atim;
 
 	queue = kzalloc(rt2x00dev->data_queues * sizeof(*queue), GFP_KERNEL);
 	if (!queue) {
@@ -272,7 +272,7 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->rx = queue;
 	rt2x00dev->tx = &queue[1];
-	rt2x00dev->bcn = &queue[1 + rt2x00dev->hw->queues];
+	rt2x00dev->bcn = &queue[1 + rt2x00dev->ops->tx_queues];
 
 	/*
 	 * Initialize queue parameters.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 3f7cfa9..4bde98b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -397,7 +397,7 @@ struct data_queue_desc {
  * the end of the TX queue array.
  */
 #define tx_queue_end(__dev) \
-	&(__dev)->tx[(__dev)->hw->queues]
+	&(__dev)->tx[(__dev)->ops->tx_queues]
 
 /**
  * queue_loop - Loop through the queues within a specific range (HELPER MACRO).
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f42d1cc..913ef3f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2258,7 +2258,6 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->queues = 4;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2490,6 +2489,7 @@ static const struct rt2x00_ops rt61pci_ops = {
 	.max_ap_intf	= 4,
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
+	.tx_queues	= NUM_TX_QUEUES,
 	.rx		= &rt61pci_queue_rx,
 	.tx		= &rt61pci_queue_tx,
 	.bcn		= &rt61pci_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 3511bba..c5a04b9 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -54,6 +54,11 @@
 #define RF_SIZE				0x0014
 
 /*
+ * Number of TX queues.
+ */
+#define NUM_TX_QUEUES			4
+
+/*
  * PCI registers.
  */
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ceb3438..288d80a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1832,7 +1832,6 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->queues = 4;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_usb(rt2x00dev)->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2080,6 +2079,7 @@ static const struct rt2x00_ops rt73usb_ops = {
 	.max_ap_intf	= 4,
 	.eeprom_size	= EEPROM_SIZE,
 	.rf_size	= RF_SIZE,
+	.tx_queues	= NUM_TX_QUEUES,
 	.rx		= &rt73usb_queue_rx,
 	.tx		= &rt73usb_queue_tx,
 	.bcn		= &rt73usb_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 06d6874..25cdcc9 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -54,6 +54,11 @@
 #define RF_SIZE				0x0014
 
 /*
+ * Number of TX queues.
+ */
+#define NUM_TX_QUEUES			4
+
+/*
  * USB registers.
  */
 
-- 
1.5.5.1

