Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0H3TQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:47 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:46 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/10] rt2x00: Cleanup rt2x00usb_watchdog_reset_tx
Date: Mon, 30 Aug 2010 21:15:51 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302114.56989.IvDoorn@gmail.com> <201008302115.20431.IvDoorn@gmail.com>
In-Reply-To: <201008302115.20431.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302115.52394.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00usb_watchdog_reset_tx performs the same task
as rt2x00usb_kill_tx_queue, with the only difference
is that it waits for all entries to be returned to
the driver and for all frames the status has been
reported to mac80211.

We can easily split this task by calling rt2x00usb_kill_tx_queue,
sleep for a short period and invoke the TX status reporting
function. By adding the sleep() to the kill_entry we make sure
that even during shutdown we guarentee the entry has been killed when
the function returns. To make this work correctly the interrupt
handlers have to be updated to prevent checking for the RADIO_ENABLED
flag too early which prevents the ownership of the entry to be reset.
Additionally a check for the DEVICE_PRESENT flag is not required but
is nice to prevent race conditions when the device was unplugged.

Additionally rather then calling rt2x00usb_work_txdone() for
status reporting we let the driver perform the TX status reporting
first. If this is not sufficient then rt2x00usb_work_txdone() will
still be used to cleanup the mess.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   66 +++++++++++++++++++------------
 1 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index aec6440..4c5ae3d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -208,8 +208,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    !__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
@@ -227,7 +226,9 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Schedule the delayed work for reading the TX status
 	 * from the device.
 	 */
-	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
 }
 
 static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
@@ -279,6 +280,14 @@ static void rt2x00usb_kill_tx_entry(struct queue_entry *entry)
 	if ((entry->queue->qid == QID_BEACON) &&
 	    (test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags)))
 		usb_kill_urb(bcn_priv->guardian_urb);
+
+	/*
+	 * We need a short delay here to wait for
+	 * the URB to be canceled
+	 */
+	do {
+		udelay(100);
+	} while (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags));
 }
 
 void rt2x00usb_kill_tx_queue(struct data_queue *queue)
@@ -290,8 +299,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_kill_tx_queue);
 
 static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 {
-	struct queue_entry *entry;
-	struct queue_entry_priv_usb *entry_priv;
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	unsigned short threshold = queue->threshold;
 
 	WARNING(queue->rt2x00dev, "TX queue %d DMA timed out,"
@@ -305,28 +313,33 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	 * queue from being enabled during the txdone handler.
 	 */
 	queue->threshold = queue->limit;
-	ieee80211_stop_queue(queue->rt2x00dev->hw, queue->qid);
+	ieee80211_stop_queue(rt2x00dev->hw, queue->qid);
 
 	/*
-	 * Reset all currently uploaded TX frames.
+	 * Kill all entries in the queue, afterwards we need to
+	 * wait a bit for all URBs to be cancelled.
 	 */
-	while (!rt2x00queue_empty(queue)) {
-		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		entry_priv = entry->priv_data;
-		usb_kill_urb(entry_priv->urb);
+	rt2x00usb_kill_tx_queue(queue);
 
-		/*
-		 * We need a short delay here to wait for
-		 * the URB to be canceled
-		 */
-		do {
-			udelay(100);
-		} while (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags));
+	/*
+	 * In case that a driver has overriden the txdone_work
+	 * function, we invoke the TX done through there.
+	 */
+	rt2x00dev->txdone_work.func(&rt2x00dev->txdone_work);
 
-		/*
-		 * Invoke the TX done handler
-		 */
-		rt2x00usb_work_txdone_entry(entry);
+	/*
+	 * Security measure: if the driver did override the
+	 * txdone_work function, and the hardware did arrive
+	 * in a state which causes it to malfunction, it is
+	 * possible that the driver couldn't handle the txdone
+	 * event correctly. So after giving the driver the
+	 * chance to cleanup, we now force a cleanup of any
+	 * leftovers.
+	 */
+	if (!rt2x00queue_empty(queue)) {
+		WARNING(queue->rt2x00dev, "TX queue %d DMA timed out,"
+			" status handling failed, invoke hard reset", queue->qid);
+		rt2x00usb_work_txdone(&rt2x00dev->txdone_work);
 	}
 
 	/*
@@ -334,7 +347,7 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	 * queue again.
 	 */
 	queue->threshold = threshold;
-	ieee80211_wake_queue(queue->rt2x00dev->hw, queue->qid);
+	ieee80211_wake_queue(rt2x00dev->hw, queue->qid);
 }
 
 static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
@@ -394,8 +407,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    !__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
@@ -415,7 +427,9 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * Schedule the delayed work for reading the RX status
 	 * from the device.
 	 */
-	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
 }
 
 /*
-- 
1.7.2.2

