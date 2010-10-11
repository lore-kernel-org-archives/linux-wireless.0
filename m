Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62576 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0JKNkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:40:41 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so574157ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 06:40:40 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/7] rt2x00: Fix URB error handling
Date: Mon, 11 Oct 2010 15:39:48 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010111537.26584.IvDoorn@gmail.com> <201010111538.46136.IvDoorn@gmail.com> <201010111539.05518.IvDoorn@gmail.com>
In-Reply-To: <201010111539.05518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010111539.49617.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kill_urb guarentees that when the function returns, the URB has
been fully killed. This means we don't need the extra sleeping
after the call to kill_urb.

kill_urb can however also guarentee the submit_urb to fail, as
a result, we must catch the return value from submit_urb an
correctly mark the entry as owned by the driver, and the
status as broken.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00usb.c |   18 ++++++++----------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e5e8ba3..5ba79b9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -253,6 +253,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_pretbtt);
 
 void rt2x00lib_dmadone(struct queue_entry *entry)
 {
+	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DMA_DONE);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_dmadone);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 89d77f5..b3317df 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -253,7 +253,10 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
-	usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+	if (usb_submit_urb(entry_priv->urb, GFP_ATOMIC)) {
+		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+		rt2x00lib_dmadone(entry);
+	}
 }
 
 void rt2x00usb_kick_tx_queue(struct data_queue *queue)
@@ -280,14 +283,6 @@ static void rt2x00usb_kill_tx_entry(struct queue_entry *entry)
 	if ((entry->queue->qid == QID_BEACON) &&
 	    (test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags)))
 		usb_kill_urb(bcn_priv->guardian_urb);
-
-	/*
-	 * We need a short delay here to wait for
-	 * the URB to be canceled
-	 */
-	do {
-		udelay(100);
-	} while (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags));
 }
 
 void rt2x00usb_kill_tx_queue(struct data_queue *queue)
@@ -469,7 +464,10 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 				rt2x00usb_interrupt_rxdone, entry);
 
 		set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-		usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+		if (usb_submit_urb(entry_priv->urb, GFP_ATOMIC)) {
+			set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+			rt2x00lib_dmadone(entry);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
-- 
1.7.2.3

