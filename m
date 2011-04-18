Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1DRNgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:01 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:00 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/23] rt2800usb: add timer to handle TX_STA_FIFO
Date: Mon, 18 Apr 2011 15:30:36 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181529.39237.IvDoorn@gmail.com> <201104181530.02029.IvDoorn@gmail.com>
In-Reply-To: <201104181530.02029.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181530.37227.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

TX status is reported by the hardware when a packet has been
sent (or after TX failed after possible retries), which is some
time after the DMA completion.  Since the rt2800usb hardware can
not signal interrupts we have to use a timer, otherwise the
TX status would only be read by the next packet's TX DMA
completion, or by the watchdog thread.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   41 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00usb.c |    5 +++-
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 69004b9..2005972 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -98,6 +98,22 @@ static void rt2800usb_stop_queue(struct data_queue *queue)
 	}
 }
 
+/*
+ * test if there is an entry in any TX queue for which DMA is done
+ * but the TX status has not been returned yet
+ */
+static bool rt2800usb_txstatus_pending(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+
+	tx_queue_for_each(rt2x00dev, queue) {
+		if (rt2x00queue_get_entry(queue, Q_INDEX_DMA_DONE) !=
+		    rt2x00queue_get_entry(queue, Q_INDEX_DONE))
+			return true;
+	}
+	return false;
+}
+
 static void rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 						 int urb_status, u32 tx_status)
 {
@@ -115,8 +131,11 @@ static void rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 		} else
 			rt2x00usb_register_read_async(rt2x00dev, TX_STA_FIFO,
 						      rt2800usb_tx_sta_fifo_read_completed);
-	} else if (!kfifo_is_empty(&rt2x00dev->txstatus_fifo))
+	} else if (!kfifo_is_empty(&rt2x00dev->txstatus_fifo)) {
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
+	} else if (rt2800usb_txstatus_pending(rt2x00dev)) {
+		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(20));
+	}
 }
 
 static void rt2800usb_tx_dma_done(struct queue_entry *entry)
@@ -127,6 +146,14 @@ static void rt2800usb_tx_dma_done(struct queue_entry *entry)
 				      rt2800usb_tx_sta_fifo_read_completed);
 }
 
+static void rt2800usb_tx_sta_fifo_timeout(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+
+	rt2x00usb_register_read_async(rt2x00dev, TX_STA_FIFO,
+				      rt2800usb_tx_sta_fifo_read_completed);
+}
+
 /*
  * Firmware functions
  */
@@ -459,6 +486,14 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 				break;
 		}
 	}
+
+	/*
+	 * The hw may delay sending the packet after DMA complete
+	 * if the medium is busy, thus the TX_STA_FIFO entry is
+	 * also delayed -> use a timer to retrieve it.
+	 */
+	if (rt2800usb_txstatus_pending(rt2x00dev))
+		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(20));
 }
 
 /*
@@ -599,6 +634,10 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
 
+	setup_timer(&rt2x00dev->txstatus_timer,
+		    rt2800usb_tx_sta_fifo_timeout,
+		    (unsigned long) rt2x00dev);
+
 	/*
 	 * Set the rssi offset.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e3b9b51..8f37121 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -37,6 +37,7 @@
 #include <linux/etherdevice.h>
 #include <linux/input-polldev.h>
 #include <linux/kfifo.h>
+#include <linux/timer.h>
 
 #include <net/mac80211.h>
 
@@ -924,6 +925,11 @@ struct rt2x00_dev {
 	DECLARE_KFIFO_PTR(txstatus_fifo, u32);
 
 	/*
+	 * Timer to ensure tx status reports are read (rt2800usb).
+	 */
+	struct timer_list txstatus_timer;
+
+	/*
 	 * Tasklet for processing tx status reports (rt2800pci).
 	 */
 	struct tasklet_struct txstatus_tasklet;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2e490e0..7776d9f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1071,6 +1071,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Stop all work.
 	 */
+	del_timer_sync(&rt2x00dev->txstatus_timer);
 	cancel_work_sync(&rt2x00dev->intf_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
 		cancel_work_sync(&rt2x00dev->rxdone_work);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 14736e2..34b8a88 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -280,7 +280,9 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Schedule the delayed work for reading the TX status
 	 * from the device.
 	 */
-	queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
+	if (!test_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags) ||
+	    !kfifo_is_empty(&rt2x00dev->txstatus_fifo))
+		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 }
 
 static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void* data)
@@ -816,6 +818,7 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 
 	INIT_WORK(&rt2x00dev->rxdone_work, rt2x00usb_work_rxdone);
 	INIT_WORK(&rt2x00dev->txdone_work, rt2x00usb_work_txdone);
+	init_timer(&rt2x00dev->txstatus_timer);
 
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
-- 
1.7.2.3

