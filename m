Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36386 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0KDTn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:58 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so1281902ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:57 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 11/13] rt2x00: Fix crash on USB unplug
Date: Thu, 4 Nov 2010 20:41:05 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042040.12419.IvDoorn@gmail.com> <201011042040.47235.IvDoorn@gmail.com>
In-Reply-To: <201011042040.47235.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042041.06812.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By not scheduling the TX/RX completion worker threads
when Radio is disabled, or hardware has been unplugged,
the queues cannot be completely cleaned.

This causes crashes when the hardware has been unplugged while
the radio is still enabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 ++++++++++--
 drivers/net/wireless/rt2x00/rt2x00usb.c |    8 ++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a5c7a4f..b6822cd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -483,6 +483,10 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	unsigned int header_length;
 	int rate_idx;
 
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
+	    !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		goto submit_entry;
+
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 		goto submit_entry;
 
@@ -567,9 +571,13 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	entry->skb = skb;
 
 submit_entry:
-	rt2x00dev->ops->lib->clear_entry(entry);
-	rt2x00queue_index_inc(entry->queue, Q_INDEX);
+	entry->flags = 0;
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags)) {
+		rt2x00dev->ops->lib->clear_entry(entry);
+		rt2x00queue_index_inc(entry->queue, Q_INDEX);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 6dd9619..9ac1459 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -226,9 +226,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Schedule the delayed work for reading the TX status
 	 * from the device.
 	 */
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
-	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
 }
 
 static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
@@ -409,9 +407,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * Schedule the delayed work for reading the RX status
 	 * from the device.
 	 */
-	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
-	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
 }
 
 /*
-- 
1.7.2.3

