Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0LMLkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:11 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:10 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
Date: Mon, 13 Dec 2010 12:32:49 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131231.59890.IvDoorn@gmail.com> <201012131232.23491.IvDoorn@gmail.com>
In-Reply-To: <201012131232.23491.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131232.50201.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

When an rt2x00 USB device is unplugged while in use, it reliably
hangs the whole system.  After some time the watchdog prints:

BUG: soft lockup - CPU#0 stuck for 64s! [kworker/u:0:5]
...
[<c01a88d8>] (usb_submit_urb+0x0/0x2ac) from [<bf0e752c>] (rt2x00usb_kick_rx_entry+0xb4/0xe8 [rt2x00usb])
[<bf0e7478>] (rt2x00usb_kick_rx_entry+0x0/0xe8 [rt2x00usb]) from [<bf0e7588>] (rt2x00usb_clear_entry+x28/0x2c [rt2x00usb])
[<bf0e7560>] (rt2x00usb_clear_entry+0x0/0x2c [rt2x00usb]) from [<bf0d5bc4>] (rt2x00lib_rxdone+0x2e0/0x2f8 [rt2x00lib])
[<bf0d58e4>] (rt2x00lib_rxdone+0x0/0x2f8 [rt2x00lib]) from [<bf0e7e00>] (rt2x00usb_work_rxdone+0x54/0x74 [rt2x00usb])
[<bf0e7dac>] (rt2x00usb_work_rxdone+0x0/0x74 [rt2x00usb]) from [<c00542b4>] (process_one_work+0x20c/0x35c)

Clear the DEVICE_STATE_PRESENT flag when usb_submit_urb()
returns -ENODEV to fix this.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 9ac1459..3a6c83e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -235,6 +235,7 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	u32 length;
+	int status;
 
 	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags))
 		return;
@@ -251,7 +252,10 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
-	if (usb_submit_urb(entry_priv->urb, GFP_ATOMIC)) {
+	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+	if (status) {
+		if (status == -ENODEV)
+			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
 	}
@@ -435,6 +439,7 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 	    to_usb_device_intf(entry->queue->rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	int pipe;
+	int status;
 
 	entry->flags = 0;
 
@@ -445,7 +450,12 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 				rt2x00usb_interrupt_rxdone, entry);
 
 		set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-		if (usb_submit_urb(entry_priv->urb, GFP_ATOMIC)) {
+
+		status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+		if (status) {
+			if (status == -ENODEV)
+				clear_bit(DEVICE_STATE_PRESENT,
+					  &entry->queue->rt2x00dev->flags);
 			set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 			rt2x00lib_dmadone(entry);
 		}
-- 
1.7.2.3

