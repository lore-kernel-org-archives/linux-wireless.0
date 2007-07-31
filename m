Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765532AbXGaSeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:17 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:16 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/24] rt2x00: Fix interface opening/closing on suspend/resume
Date: Tue, 31 Jul 2007 20:37:25 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.25207.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From c2a2fd3eaa85367e56b01955139678fe772d1cfd Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 16:32:36 +0200
Subject: [PATCH 14/24] rt2x00: Fix interface opening/closing on suspend/resume

During suspend rt2x00lib must close/unitialize all items that
_must_ be reinitialized on resume. This means that
rt2x00lib_uninitialize() must be called because the firmware and
registers must be initialized on resume.
Also make sure the beacon transmission will get a new impulse,
and just to be safe close and reopen the debugfs entries.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00dev.c |   53 +++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00lib.h |    1 +
 drivers/net/wireless/rt2x00pci.c |   18 -------------
 drivers/net/wireless/rt2x00pci.h |    1 -
 drivers/net/wireless/rt61pci.c   |    2 +-
 7 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 838b64e..473208d 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -1277,7 +1277,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
-		rt2x00pci_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+		rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 
 	/*
 	 * 2 - Rx ring done interrupt.
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index e1e5ee2..fd7a8be 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -1446,7 +1446,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
-		rt2x00pci_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+		rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 
 	/*
 	 * 2 - Rx ring done interrupt.
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 10221bb..f369fbb 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -216,6 +216,24 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 /*
  * Interrupt context handlers.
  */
+void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev, const int queue)
+{
+	struct data_ring *ring = rt2x00_get_ring(rt2x00dev, queue);
+	struct data_entry *entry = rt2x00_get_data_entry(ring);
+	struct sk_buff *skb;
+
+	skb = ieee80211_beacon_get(rt2x00dev->hw,
+		rt2x00dev->interface.id, &entry->tx_status.control);
+	if (!skb)
+		return;
+
+	rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, skb,
+		&entry->tx_status.control);
+
+	dev_kfree_skb(skb);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
+
 void rt2x00lib_txdone(struct data_entry *entry,
 	const int status, const int retry)
 {
@@ -773,7 +791,7 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 	 */
 	status = rt2x00lib_alloc_ring_entries(rt2x00dev);
 	if (status) {
-		ERROR(rt2x00dev, "DMA allocation failed.\n");
+		ERROR(rt2x00dev, "Ring entries allocation failed.\n");
 		return status;
 	}
 
@@ -1026,7 +1044,13 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev,
 
 	NOTICE(rt2x00dev, "Going to sleep.\n");
 
+	/*
+	 * Disable radio and unitialize all items
+	 * that must be recreated on resume.
+	 */
 	rt2x00lib_disable_radio(rt2x00dev);
+	rt2x00lib_uninitialize(rt2x00dev);
+	rt2x00debug_deregister(rt2x00dev);
 
 	/*
 	 * Set device mode to sleep for power management.
@@ -1041,8 +1065,35 @@ EXPORT_SYMBOL_GPL(rt2x00lib_suspend);
 
 int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 {
+	int retval;
+
 	NOTICE(rt2x00dev, "Waking up.\n");
 
+	/*
+	 * Open the debugfs entry.
+	 */
+	rt2x00debug_register(rt2x00dev);
+
+	/*
+	 * Reinitialize device and all active interfaces.
+	 */
+	retval = rt2x00lib_init_interface(rt2x00dev);
+	if (retval)
+		return retval;
+
+	/*
+	 * We only need to continue when in Master or Ad-hoc mode.
+	 */
+	if (rt2x00dev->interface.type != IEEE80211_IF_TYPE_AP &&
+	    rt2x00dev->interface.type != IEEE80211_IF_TYPE_IBSS)
+		return 0;
+
+	/*
+	 * Restart Beacon transmitting by faking
+	 * a beacondone event.
+	 */
+	rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_resume);
diff --git a/drivers/net/wireless/rt2x00lib.h b/drivers/net/wireless/rt2x00lib.h
index 72d3f45..cf13d10 100644
--- a/drivers/net/wireless/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00lib.h
@@ -75,6 +75,7 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev);
 /*
  * Interrupt context handlers.
  */
+void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev, const int queue);
 void rt2x00lib_txdone(struct data_entry *entry,
 	const int status, const int retry);
 void rt2x00lib_rxdone(struct data_entry *entry, char *data,
diff --git a/drivers/net/wireless/rt2x00pci.c b/drivers/net/wireless/rt2x00pci.c
index b1cff2c..60d1517 100644
--- a/drivers/net/wireless/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00pci.c
@@ -72,24 +72,6 @@ int rt2x00pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_beacon_update);
 
-void rt2x00pci_beacondone(struct rt2x00_dev *rt2x00dev, const int queue)
-{
-	struct data_ring *ring = rt2x00_get_ring(rt2x00dev, queue);
-	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	struct sk_buff *skb;
-
-	skb = ieee80211_beacon_get(rt2x00dev->hw,
-		rt2x00dev->interface.id, &entry->tx_status.control);
-	if (!skb)
-		return;
-
-	rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, skb,
-		&entry->tx_status.control);
-
-	dev_kfree_skb(skb);
-}
-EXPORT_SYMBOL_GPL(rt2x00pci_beacondone);
-
 /*
  * TX data handlers.
  */
diff --git a/drivers/net/wireless/rt2x00pci.h b/drivers/net/wireless/rt2x00pci.h
index 8595cbf..86eba3e 100644
--- a/drivers/net/wireless/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00pci.h
@@ -85,7 +85,6 @@ static inline void rt2x00pci_register_multiwrite(
  */
 int rt2x00pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_tx_control *control);
-void rt2x00pci_beacondone(struct rt2x00_dev *rt2x00dev, const int queue);
 
 /*
  * TX data handlers.
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index cb50956..183464c 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1885,7 +1885,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
-		rt2x00pci_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+		rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 
 	/*
 	 * 2 - Rx ring done interrupt.
-- 
1.5.2.4

