Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36978 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcCRIal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 04:30:41 -0400
Received: by mail-wm0-f48.google.com with SMTP id p65so26299569wmp.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 01:30:40 -0700 (PDT)
From: Vishal Thanki <vishalthanki@gmail.com>
To: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	linux-wireless@vger.kernel.org
Cc: Vishal Thanki <vishalthanki@gmail.com>
Subject: [PATCH v3] rt2x00usb: Use usb anchor to manage URB
Date: Fri, 18 Mar 2016 09:30:36 +0100
Message-Id: <1458289836-7219-1-git-send-email-vishalthanki@gmail.com> (sfid-20160318_093223_505722_8E30B49A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With current driver, it is observed that a URB is not
completed while the USB disconnect is initiated. Due to
that, the URB completion hanlder is trying to access
the resource which was freed as a part of USB disconnect.
Managing the URBs with anchor will make sure that all
the URBs are handled gracefully before device gets
disconnected.

Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  3 +++
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 23 +++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 3282ddb..9426c75 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -38,6 +38,7 @@
 #include <linux/kfifo.h>
 #include <linux/hrtimer.h>
 #include <linux/average.h>
+#include <linux/usb.h>
 
 #include <net/mac80211.h>
 
@@ -1001,6 +1002,8 @@ struct rt2x00_dev {
 
 	/* Extra TX headroom required for alignment purposes. */
 	unsigned int extra_tx_headroom;
+
+	struct usb_anchor *anchor;
 };
 
 struct rt2x00_bar_list_entry {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 7627af6..bba1430 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -171,8 +171,11 @@ static void rt2x00usb_register_read_async_cb(struct urb *urb)
 {
 	struct rt2x00_async_read_data *rd = urb->context;
 	if (rd->callback(rd->rt2x00dev, urb->status, le32_to_cpu(rd->reg))) {
-		if (usb_submit_urb(urb, GFP_ATOMIC) < 0)
+		usb_anchor_urb(urb, rd->rt2x00dev->anchor);
+		if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
+			usb_unanchor_urb(urb);
 			kfree(rd);
+		}
 	} else
 		kfree(rd);
 }
@@ -206,8 +209,11 @@ void rt2x00usb_register_read_async(struct rt2x00_dev *rt2x00dev,
 	usb_fill_control_urb(urb, usb_dev, usb_rcvctrlpipe(usb_dev, 0),
 			     (unsigned char *)(&rd->cr), &rd->reg, sizeof(rd->reg),
 			     rt2x00usb_register_read_async_cb, rd);
-	if (usb_submit_urb(urb, GFP_ATOMIC) < 0)
+	usb_anchor_urb(urb, rt2x00dev->anchor);
+	if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
+		usb_unanchor_urb(urb);
 		kfree(rd);
+	}
 	usb_free_urb(urb);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_register_read_async);
@@ -313,8 +319,10 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
+	usb_anchor_urb(entry_priv->urb, rt2x00dev->anchor);
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
+		usb_unanchor_urb(entry_priv->urb);
 		if (status == -ENODEV)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
@@ -402,8 +410,10 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 			  entry->skb->data, entry->skb->len,
 			  rt2x00usb_interrupt_rxdone, entry);
 
+	usb_anchor_urb(entry_priv->urb, rt2x00dev->anchor);
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
+		usb_unanchor_urb(entry_priv->urb);
 		if (status == -ENODEV)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
@@ -734,6 +744,8 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
+	usb_kill_anchored_urbs(rt2x00dev->anchor);
+
 	queue_for_each(rt2x00dev, queue)
 		rt2x00usb_free_entries(queue);
 }
@@ -818,6 +830,13 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	if (retval)
 		goto exit_free_reg;
 
+	rt2x00dev->anchor = devm_kmalloc(&usb_dev->dev,
+					sizeof(struct usb_anchor),
+					GFP_KERNEL);
+	if (!rt2x00dev->anchor)
+		goto exit_free_reg;
+
+	init_usb_anchor(rt2x00dev->anchor);
 	return 0;
 
 exit_free_reg:
-- 
2.4.3

