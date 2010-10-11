Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62576 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0JKNkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:40:36 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so574157ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 06:40:35 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/7] rt2x00: Make queue_entry flags access atomic
Date: Mon, 11 Oct 2010 15:38:45 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010111537.26584.IvDoorn@gmail.com> <201010111538.08677.IvDoorn@gmail.com> <201010111538.27633.IvDoorn@gmail.com>
In-Reply-To: <201010111538.27633.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010111538.46136.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All access to the queue_entry->flags can be done concurrently,
so all flags must use the atomic operators. On most locations
this was already done, so just fix the last few non-atomic
versions.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 451d637..769c534 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -208,7 +208,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 
-	if (!__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
@@ -220,7 +220,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Check if the frame was correctly uploaded
 	 */
 	if (urb->status)
-		__set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 
 	/*
 	 * Schedule the delayed work for reading the TX status
@@ -407,7 +407,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 
-	if (!__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
@@ -421,7 +421,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * a problem.
 	 */
 	if (urb->actual_length < entry->queue->desc_size || urb->status)
-		__set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 
 	/*
 	 * Schedule the delayed work for reading the RX status
-- 
1.7.2.3

