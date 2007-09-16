Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXIPMIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:09 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:09 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/24] rt2x00: Rename DEVICE_SUPPORT_ATIM to REQUIRE_BEACON_RING
Date: Sun, 16 Sep 2007 14:18:38 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.39601.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices that support the ATIM ring are also the devices
which require the Beacon ring to be allocated.
So by renaming the flag we can expand the meaning by
also including the beacon ring allocation to it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |   14 ++++++---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   42 ++++++++++++++----------------
 5 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 5a7fc18..28236dc 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1513,9 +1513,9 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2400pci_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * This device supports ATIM
+	 * This device requires the beacon ring
 	 */
-	__set_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags);
+	__set_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d24ea61..444e530 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1828,9 +1828,9 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2500pci_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * This device supports ATIM
+	 * This device requires the beacon ring
 	 */
-	__set_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags);
+	__set_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f344c2a..7e8cd47 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1582,10 +1582,10 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * USB devices require scheduled packet filter toggling
-	 * This device supports ATIM
+	 *This device requires the beacon ring
 	 */
 	__set_bit(PACKET_FILTER_SCHEDULED, &rt2x00dev->flags);
-	__set_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags);
+	__set_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 02a5adf..5ecabc8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -516,7 +516,7 @@ struct rt2x00_dev {
 #define INTERFACE_RESET			8
 #define INTERFACE_ENABLED		9
 #define INTERFACE_ENABLED_MONITOR	10
-#define DEVICE_SUPPORT_ATIM		11
+#define REQUIRE_BEACON_RING		11
 #define DEVICE_SUPPORT_HW_BUTTON	12
 #define CONFIG_FRAME_TYPE		13
 #define CONFIG_RF_SEQUENCE		14
@@ -615,6 +615,7 @@ struct rt2x00_dev {
 	 * The Beacon array also contains the Atim ring
 	 * if that is supported by the device.
 	 */
+	int data_rings;
 	struct data_ring *rx;
 	struct data_ring *tx;
 	struct data_ring *bcn;
@@ -630,14 +631,17 @@ struct rt2x00_dev {
  * All rings have been allocated as a single array,
  * this means we can create a very simply loop macro
  * that is capable of looping through all rings.
- * ring_end() and ring_loop() are helper macro's which should
- * not be used directly. Instead the following should be used:
+ * ring_end(), txring_end() and ring_loop() are helper macro's which
+ * should not be used directly. Instead the following should be used:
  * ring_for_each() - Loops through all rings (RX, TX, Beacon & Atim)
  * txring_for_each() - Loops through TX data rings (TX only)
  * txringall_for_each() - Loops through all TX rings (TX, Beacon & Atim)
  */
 #define ring_end(__dev) \
-	&(__dev)->bcn[1 + test_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags)]
+	&(__dev)->rx[(__dev)->data_rings]
+
+#define txring_end(__dev) \
+	&(__dev)->tx[(__dev)->hw->queues]
 
 #define ring_loop(__entry, __start, __end)			\
 	for ((__entry) = (__start);				\
@@ -648,7 +652,7 @@ struct rt2x00_dev {
 	ring_loop(__entry, (__dev)->rx, ring_end(__dev))
 
 #define txring_for_each(__dev, __entry) \
-	ring_loop(__entry, (__dev)->tx, (__dev)->bcn)
+	ring_loop(__entry, (__dev)->tx, txring_end(__dev))
 
 #define txringall_for_each(__dev, __entry) \
 	ring_loop(__entry, (__dev)->tx, ring_end(__dev))
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index fed2cce..81458bf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -40,24 +40,22 @@
 struct data_ring *rt2x00lib_get_ring(struct rt2x00_dev *rt2x00dev,
 				     const unsigned int queue)
 {
-	int atim = test_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags);
-
-	/*
-	 * Check if the rings have been allocated.
-	 */
-	if (!rt2x00dev->tx || !rt2x00dev->bcn)
-		return NULL;
+	int beacon = test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Check if we are requesting a reqular TX ring,
 	 * or if we are requesting a Beacon or Atim ring.
 	 * For Atim rings, we should check if it is supported.
 	 */
-	if (queue < rt2x00dev->hw->queues)
+	if (queue < rt2x00dev->hw->queues && rt2x00dev->tx)
 		return &rt2x00dev->tx[queue];
-	else if (queue == IEEE80211_TX_QUEUE_BEACON)
+
+	if (!rt2x00dev->bcn || !beacon)
+		return NULL;
+
+	if (queue == IEEE80211_TX_QUEUE_BEACON)
 		return &rt2x00dev->bcn[0];
-	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON && atim)
+	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
 		return &rt2x00dev->bcn[1];
 
 	return NULL;
@@ -790,6 +788,9 @@ static int rt2x00lib_alloc_ring_entries(struct rt2x00_dev *rt2x00dev)
 			return -ENOMEM;
 	}
 
+	if (!test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags))
+		return 0;
+
 	/*
 	 * Allocate the BEACON ring.
 	 */
@@ -800,9 +801,6 @@ static int rt2x00lib_alloc_ring_entries(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate the Atim ring.
 	 */
-	if (!test_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags))
-		return 0;
-
 	if (rt2x00lib_alloc_entries(&rt2x00dev->bcn[1], ATIM_ENTRIES,
 				    DATA_FRAME_SIZE, rt2x00dev->ops->txd_size))
 		return -ENOMEM;
@@ -960,19 +958,18 @@ void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev)
 static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
-	unsigned int ring_num;
 
 	/*
 	 * We need the following rings:
 	 * RX: 1
 	 * TX: hw->queues
-	 * Beacon: 1
-	 * Atim: 1 (if supported)
+	 * Beacon: 1 (if required)
+	 * Atim: 1 (if required)
 	 */
-	ring_num = 2 + rt2x00dev->hw->queues +
-	    test_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags);
+	rt2x00dev->data_rings = 1 + rt2x00dev->hw->queues +
+	    (2 * test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags));
 
-	ring = kzalloc(sizeof(*ring) * ring_num, GFP_KERNEL);
+	ring = kzalloc(rt2x00dev->data_rings * sizeof(*ring), GFP_KERNEL);
 	if (!ring) {
 		ERROR(rt2x00dev, "Ring allocation failed.\n");
 		return -ENOMEM;
@@ -981,9 +978,10 @@ static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize pointers
 	 */
-	rt2x00dev->rx = &ring[0];
-	rt2x00dev->tx = &ring[1];
-	rt2x00dev->bcn = &ring[1 + rt2x00dev->hw->queues];
+	rt2x00dev->rx = ring;
+	rt2x00dev->tx = &rt2x00dev->rx[1];
+	if (test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags))
+		rt2x00dev->bcn = &rt2x00dev->tx[rt2x00dev->hw->queues];
 
 	/*
 	 * Initialize ring parameters.
-- 
1.5.3
