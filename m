Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0LMLka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:30 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:30 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/17] rt2x00: Introduce extra queue entry sanity flag
Date: Mon, 13 Dec 2010 12:36:18 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131235.41811.IvDoorn@gmail.com> <201012131236.01268.IvDoorn@gmail.com>
In-Reply-To: <201012131236.01268.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131236.19791.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a queue entry flag ENTRY_DATA_STATUS_PENDING,
which can be used to indicate a queue entry has
returned from the hardware and is waiting for
status processing. Using this flag we can add
some extra sanity checks to prevent queue corruption.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.h |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   12 ++++++++----
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f3ae949..87a421b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -235,6 +235,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);
 
 void rt2x00lib_dmadone(struct queue_entry *entry)
 {
+	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
 	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DMA_DONE);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index baa39b7..4765934 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -340,12 +340,16 @@ struct txentry_desc {
  * @ENTRY_DATA_IO_FAILED: Hardware indicated that an IO error occured
  *	while transfering the data to the hardware. No TX status report will
  *	be expected from the hardware.
+ * @ENTRY_DATA_STATUS_PENDING: The entry has been send to the device and
+ *	returned. It is now waiting for the status reporting before the
+ *	entry can be reused again.
  */
 enum queue_entry_flags {
 	ENTRY_BCN_ASSIGNED,
 	ENTRY_OWNER_DEVICE_DATA,
 	ENTRY_DATA_PENDING,
-	ENTRY_DATA_IO_FAILED
+	ENTRY_DATA_IO_FAILED,
+	ENTRY_DATA_STATUS_PENDING,
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index cd29ebc..8a16b51 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -195,7 +195,8 @@ static void rt2x00usb_work_txdone(struct work_struct *work)
 		while (!rt2x00queue_empty(queue)) {
 			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 
-			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+			    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 				break;
 
 			rt2x00usb_work_txdone_entry(entry);
@@ -237,7 +238,8 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 	u32 length;
 	int status;
 
-	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags))
+	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags) ||
+	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 		return;
 
 	/*
@@ -275,7 +277,8 @@ static void rt2x00usb_work_rxdone(struct work_struct *work)
 	while (!rt2x00queue_empty(rt2x00dev->rx)) {
 		entry = rt2x00queue_get_entry(rt2x00dev->rx, Q_INDEX_DONE);
 
-		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+		    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 			break;
 
 		/*
@@ -327,7 +330,8 @@ static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	int status;
 
-	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 		return;
 
 	rt2x00lib_dmastart(entry);
-- 
1.7.2.3

