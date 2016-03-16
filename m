Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34014 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbcCPR3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 13:29:06 -0400
Received: by mail-wm0-f46.google.com with SMTP id p65so200237615wmp.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 10:29:05 -0700 (PDT)
From: Vishal Thanki <vishalthanki@gmail.com>
To: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	linux-wireless@vger.kernel.org
Cc: Vishal Thanki <vishalthanki@gmail.com>
Subject: [PATCH] rt2x00usb: Use usb anchors to manage URB
Date: Wed, 16 Mar 2016 18:28:51 +0100
Message-Id: <1458149331-2106-1-git-send-email-vishalthanki@gmail.com> (sfid-20160316_182912_297078_0A430BFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With current driver, it is observed that a URB is not
completed while the USB disconnect is initiated. Due to
that, the URB completion hanlder is trying to access
the resource which was freed as a part of USB disconnect.
Managing the URBs with anchors will make sure that all
the URBs are handled gracefully before device gets
disconnected.

Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 35 ++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 7627af6..a2ed3e1 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -34,6 +34,15 @@
 /*
  * Interfacing with the HW.
  */
+
+struct rt2x00usb_anchors {
+	struct usb_anchor async_urb;
+	struct usb_anchor tx_submitted;
+	struct usb_anchor rx_submitted;
+};
+
+static struct rt2x00usb_anchors *anchors;
+
 int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 			     const u8 request, const u8 requesttype,
 			     const u16 offset, const u16 value,
@@ -171,8 +180,11 @@ static void rt2x00usb_register_read_async_cb(struct urb *urb)
 {
 	struct rt2x00_async_read_data *rd = urb->context;
 	if (rd->callback(rd->rt2x00dev, urb->status, le32_to_cpu(rd->reg))) {
-		if (usb_submit_urb(urb, GFP_ATOMIC) < 0)
+		usb_anchor_urb(urb, &anchors->async_urb);
+		if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
+			usb_unanchor_urb(urb);
 			kfree(rd);
+		}
 	} else
 		kfree(rd);
 }
@@ -206,8 +218,11 @@ void rt2x00usb_register_read_async(struct rt2x00_dev *rt2x00dev,
 	usb_fill_control_urb(urb, usb_dev, usb_rcvctrlpipe(usb_dev, 0),
 			     (unsigned char *)(&rd->cr), &rd->reg, sizeof(rd->reg),
 			     rt2x00usb_register_read_async_cb, rd);
-	if (usb_submit_urb(urb, GFP_ATOMIC) < 0)
+	usb_anchor_urb(urb, &anchors->async_urb);
+	if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
+		usb_unanchor_urb(urb);
 		kfree(rd);
+	}
 	usb_free_urb(urb);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_register_read_async);
@@ -313,8 +328,10 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
+	usb_anchor_urb(entry_priv->urb, &anchors->tx_submitted);
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
+		usb_unanchor_urb(entry_priv->urb);
 		if (status == -ENODEV)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
@@ -402,8 +419,10 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 			  entry->skb->data, entry->skb->len,
 			  rt2x00usb_interrupt_rxdone, entry);
 
+	usb_anchor_urb(entry_priv->urb, &anchors->rx_submitted);
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
+		usb_unanchor_urb(entry_priv->urb);
 		if (status == -ENODEV)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
@@ -818,6 +837,14 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	if (retval)
 		goto exit_free_reg;
 
+	anchors = devm_kmalloc(&usb_dev->dev, sizeof(struct rt2x00usb_anchors),
+			       GFP_KERNEL);
+	if (!anchors)
+		goto exit_free_reg;
+
+	init_usb_anchor(&anchors->async_urb);
+	init_usb_anchor(&anchors->tx_submitted);
+	init_usb_anchor(&anchors->rx_submitted);
 	return 0;
 
 exit_free_reg:
@@ -840,6 +867,10 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
+	usb_kill_anchored_urbs(&anchors->async_urb);
+	usb_kill_anchored_urbs(&anchors->tx_submitted);
+	usb_kill_anchored_urbs(&anchors->rx_submitted);
+
 	/*
 	 * Free all allocated data.
 	 */
-- 
2.4.3

