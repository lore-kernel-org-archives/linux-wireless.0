Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47398 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3FEKyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 06:54:06 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] rt2x00: convert rt2x00_ops.extra_tx_headroom to be a fuction
Date: Wed,  5 Jun 2013 12:53:59 +0200
Message-Id: <1370429640-31565-1-git-send-email-juhosg@openwrt.org> (sfid-20130605_125413_347404_79EEB20F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2x00_ops structure has a static field to indicate
the extra TX headroom size required for a given device.
The drawback of this is that we have to use a separate
rt2x00_ops structure for each chipset which requires
different size.

Convert the static field into a callback function.
This allows the drivers to dynamically determine the
extra TX headroom size based on the actual chipset.
Also implement the the callback in the drivers which
needs an extra TX headroom, and remove the field
initialization from the others.

Additionally, introduce a new extra_tx_headroom field
in struct rt2x00_dev, initialize its value in the probe
routine and use the cached value in the rest of the code.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
The patch depends on the 'rt2x00: get rid of static data queue descriptors'
series.
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt2500usb.c   |    8 +++++++-
 drivers/net/wireless/rt2x00/rt2800pci.c   |    8 +++++++-
 drivers/net/wireless/rt2x00/rt2800usb.c   |   13 +++++++++++--
 drivers/net/wireless/rt2x00/rt2x00.h      |    5 ++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   10 ++++++++--
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++---
 drivers/net/wireless/rt2x00/rt61pci.c     |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c     |    8 +++++++-
 10 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index e1ec9a4..3d53a09 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1813,7 +1813,6 @@ static const struct rt2x00_ops rt2400pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= 0,
 	.queue_init		= rt2400pci_queue_init,
 	.lib			= &rt2400pci_rt2x00_ops,
 	.hw			= &rt2400pci_mac80211_ops,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a1670e8..0ac5c58 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -2102,7 +2102,6 @@ static const struct rt2x00_ops rt2500pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= 0,
 	.queue_init		= rt2500pci_queue_init,
 	.lib			= &rt2500pci_rt2x00_ops,
 	.hw			= &rt2500pci_mac80211_ops,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index e5e5479..f8fa2a8 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1907,13 +1907,19 @@ static void rt2500usb_queue_init(struct data_queue *queue)
 	}
 }
 
+static unsigned int
+rt2500usb_extra_tx_headroom(struct rt2x00_dev *rt2x00dev)
+{
+	return TXD_DESC_SIZE;
+}
+
 static const struct rt2x00_ops rt2500usb_ops = {
 	.name			= KBUILD_MODNAME,
 	.max_ap_intf		= 1,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= TXD_DESC_SIZE,
+	.extra_tx_headroom	= rt2500usb_extra_tx_headroom,
 	.queue_init		= rt2500usb_queue_init,
 	.lib			= &rt2500usb_rt2x00_ops,
 	.hw			= &rt2500usb_mac80211_ops,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 260c8b4..4e69792 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1224,6 +1224,12 @@ static void rt2800pci_queue_init(struct data_queue *queue)
 	}
 }
 
+static unsigned int
+rt2800pci_extra_tx_headroom(struct rt2x00_dev *rt2x00dev)
+{
+	return TXWI_DESC_SIZE;
+}
+
 static const struct rt2x00_ops rt2800pci_ops = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
@@ -1231,7 +1237,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= TXWI_DESC_SIZE,
+	.extra_tx_headroom	= rt2800pci_extra_tx_headroom,
 	.queue_init		= rt2800pci_queue_init,
 	.lib			= &rt2800pci_rt2x00_ops,
 	.drv			= &rt2800pci_rt2800_ops,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index b81d509..57729a8 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -898,6 +898,15 @@ static void rt2800usb_queue_init(struct data_queue *queue)
 	}
 }
 
+static unsigned int
+rt2800usb_extra_tx_headroom(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2x00_rt(rt2x00dev, RT5592))
+		return TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592;
+
+	return TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
+}
+
 static const struct rt2x00_ops rt2800usb_ops = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
@@ -905,7 +914,7 @@ static const struct rt2x00_ops rt2800usb_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
+	.extra_tx_headroom	= rt2800usb_extra_tx_headroom,
 	.queue_init		= rt2800usb_queue_init,
 	.lib			= &rt2800usb_rt2x00_ops,
 	.drv			= &rt2800usb_rt2800_ops,
@@ -922,7 +931,7 @@ static const struct rt2x00_ops rt2800usb_ops_5592 = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
+	.extra_tx_headroom	= rt2800usb_extra_tx_headroom,
 	.queue_init		= rt2800usb_queue_init,
 	.lib			= &rt2800usb_rt2x00_ops,
 	.drv			= &rt2800usb_rt2800_ops,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2a17f7e..41ca342 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -648,7 +648,7 @@ struct rt2x00_ops {
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
 	const unsigned int tx_queues;
-	const unsigned int extra_tx_headroom;
+	unsigned int (*extra_tx_headroom)(struct rt2x00_dev *rt2x00dev);
 	void (*queue_init)(struct data_queue *queue);
 	const struct rt2x00lib_ops *lib;
 	const void *drv;
@@ -1007,6 +1007,9 @@ struct rt2x00_dev {
 	 */
 	struct list_head bar_list;
 	spinlock_t bar_list_lock;
+
+	/* Extra TX headroom required for alignment purposes. */
+	unsigned int extra_tx_headroom;
 };
 
 struct rt2x00_bar_list_entry {
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index dff5012..964bf1a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -334,7 +334,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	/*
 	 * Remove the extra tx headroom from the skb.
 	 */
-	skb_pull(entry->skb, rt2x00dev->ops->extra_tx_headroom);
+	skb_pull(entry->skb, rt2x00dev->extra_tx_headroom);
 
 	/*
 	 * Signal that the TX descriptor is no longer in the skb.
@@ -1049,7 +1049,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->extra_tx_headroom =
 		max_t(unsigned int, IEEE80211_TX_STATUS_HEADROOM,
-		      rt2x00dev->ops->extra_tx_headroom);
+		      rt2x00dev->extra_tx_headroom);
 
 	/*
 	 * Take TX headroom required for alignment into account.
@@ -1280,6 +1280,12 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		}
 	}
 
+	if (rt2x00dev->ops->extra_tx_headroom) {
+		/* Cache TX headroom value */
+		rt2x00dev->extra_tx_headroom =
+			rt2x00dev->ops->extra_tx_headroom(rt2x00dev);
+	}
+
 	spin_lock_init(&rt2x00dev->irqmask_lock);
 	mutex_init(&rt2x00dev->csr_mutex);
 	INIT_LIST_HEAD(&rt2x00dev->bar_list);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index c4f1e2b..6c0a91f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -542,8 +542,8 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
 	/*
 	 * Add the requested extra tx headroom in front of the skb.
 	 */
-	skb_push(entry->skb, rt2x00dev->ops->extra_tx_headroom);
-	memset(entry->skb->data, 0, rt2x00dev->ops->extra_tx_headroom);
+	skb_push(entry->skb, rt2x00dev->extra_tx_headroom);
+	memset(entry->skb->data, 0, rt2x00dev->extra_tx_headroom);
 
 	/*
 	 * Call the driver's write_tx_data function, if it exists.
@@ -596,7 +596,7 @@ static void rt2x00queue_bar_check(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_bar *bar = (void *) (entry->skb->data +
-				    rt2x00dev->ops->extra_tx_headroom);
+				    rt2x00dev->extra_tx_headroom);
 	struct rt2x00_bar_list_entry *bar_entry;
 
 	if (likely(!ieee80211_is_back_req(bar->frame_control)))
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 17507d1..53754bc6 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -3066,7 +3066,6 @@ static const struct rt2x00_ops rt61pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= 0,
 	.queue_init		= rt61pci_queue_init,
 	.lib			= &rt61pci_rt2x00_ops,
 	.hw			= &rt61pci_mac80211_ops,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b2e346a..5545fa7 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2394,13 +2394,19 @@ static void rt73usb_queue_init(struct data_queue *queue)
 	}
 }
 
+static unsigned int
+rt73usb_extra_tx_headroom(struct rt2x00_dev *rt2x00dev)
+{
+	return TXD_DESC_SIZE;
+}
+
 static const struct rt2x00_ops rt73usb_ops = {
 	.name			= KBUILD_MODNAME,
 	.max_ap_intf		= 4,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= TXD_DESC_SIZE,
+	.extra_tx_headroom	= rt73usb_extra_tx_headroom,
 	.queue_init		= rt73usb_queue_init,
 	.lib			= &rt73usb_rt2x00_ops,
 	.hw			= &rt73usb_mac80211_ops,
-- 
1.7.10

