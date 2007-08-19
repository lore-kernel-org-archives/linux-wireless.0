Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbXHSSae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:34 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:33 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/30] rt2x00: Schedule beacon update
Date: Sun, 19 Aug 2007 20:23:37 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192023.37862.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From ddf86b88ab735fac340b1fae078a6433ed1a8fce Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 12:56:18 +0200
Subject: [PATCH 07/30] rt2x00: Schedule beacon update

ieee80211_beacon_get Doesn't allow to be called
from interrupt context. Schedule the call using
a workqueue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00.h    |    7 ++++++-
 drivers/net/wireless/rt2x00dev.c |   25 +++++++++++++++++++++----
 drivers/net/wireless/rt2x00mac.c |    2 +-
 drivers/net/wireless/rt61pci.c   |    2 +-
 6 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index d8628e6..8365171 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -1306,7 +1306,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
-		rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+		rt2x00lib_beacondone(rt2x00dev);
 
 	/*
 	 * 2 - Rx ring done interrupt.
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 4d195de..a794989 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -1482,7 +1482,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
-		rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+		rt2x00lib_beacondone(rt2x00dev);
 
 	/*
 	 * 2 - Rx ring done interrupt.
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 4b8906e..31f8a13 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -589,6 +589,11 @@ struct rt2x00_dev {
 	struct ieee80211_rx_status rx_status;
 
 	/*
+	 * Beacon scheduled work.
+	 */
+	struct work_struct beacon_work;
+
+	/*
 	 * Data ring arrays for RX, TX and Beacon.
 	 * The Beacon array also contains the Atim ring
 	 * if that is supported by the device.
@@ -725,7 +730,7 @@ struct data_ring *rt2x00lib_get_ring(struct rt2x00_dev *rt2x00dev,
 /*
  * Interrupt context handlers.
  */
-void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev, const int queue);
+void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_txdone(struct data_entry *entry,
 		      const int status, const int retry);
 void rt2x00lib_rxdone(struct data_entry *entry, char *data,
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index b7191cc..7f3eaf1 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -90,8 +90,7 @@ static void rt2x00_start_link_tune(struct rt2x00_dev *rt2x00dev)
 static void rt2x00_stop_link_tune(struct rt2x00_dev *rt2x00dev)
 {
 	if (delayed_work_pending(&rt2x00dev->link.work))
-		cancel_rearming_delayed_workqueue(rt2x00dev->hw->workqueue,
-						  &rt2x00dev->link.work);
+		cancel_rearming_delayed_work(&rt2x00dev->link.work);
 }
 
 /*
@@ -139,6 +138,12 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
+	 * Stop beacon generation.
+	 */
+	if (work_pending(&rt2x00dev->beacon_work))
+		cancel_work_sync(&rt2x00dev->beacon_work);
+
+	/*
 	 * Stop the TX queues.
 	 */
 	ieee80211_stop_queues(rt2x00dev->hw);
@@ -252,9 +257,12 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 /*
  * Interrupt context handlers.
  */
-void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev, const int queue)
+static void rt2x00lib_beacondone_scheduled(struct work_struct *work)
 {
-	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, beacon_work);
+	struct data_ring *ring =
+	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
 	struct sk_buff *skb;
 
@@ -269,6 +277,14 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev, const int queue)
 
 	dev_kfree_skb(skb);
 }
+
+void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
+{
+	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->beacon_work);
+}
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
 void rt2x00lib_txdone(struct data_entry *entry,
@@ -1012,6 +1028,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize configuration work.
 	 */
+	INIT_WORK(&rt2x00dev->beacon_work, rt2x00lib_beacondone_scheduled);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00lib_link_tuner);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00mac.c b/drivers/net/wireless/rt2x00mac.c
index 31fe0f1..2b1b910 100644
--- a/drivers/net/wireless/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00mac.c
@@ -157,7 +157,7 @@ int rt2x00mac_reset(struct ieee80211_hw *hw)
 	 */
 	if (intf->type == IEEE80211_IF_TYPE_AP ||
 	    intf->type == IEEE80211_IF_TYPE_IBSS)
-		rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+		rt2x00lib_beacondone(rt2x00dev);
 
 exit:
 	__clear_bit(INTERFACE_RESET, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 7c52a4e..edacb46 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1927,7 +1927,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
-		rt2x00lib_beacondone(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+		rt2x00lib_beacondone(rt2x00dev);
 
 	/*
 	 * 2 - Rx ring done interrupt.
-- 
1.5.3.rc5

