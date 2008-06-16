Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:44255 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYFPRox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:53 -0400
Received: by py-out-1112.google.com with SMTP id p76so2084603pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:44:53 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/9] rt2x00: Fix sparse warning on nested container_of()
Date: Mon, 16 Jun 2008 19:57:11 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806161954.04241.IvDoorn@gmail.com> <200806161956.31465.IvDoorn@gmail.com> <200806161956.54342.IvDoorn@gmail.com>
In-Reply-To: <200806161956.54342.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161957.11757.IvDoorn@gmail.com> (sfid-20080616_194504_946205_7571BF3B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sparse produces warnings about nested contain_of() statements,
this means that lines like:
	interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
will upset sparse.
Add a new macro to rt2x00usb.h which will convert to device
structure to the usb_device pointer in 2 steps to prevent this
sparse warning.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 +--
 drivers/net/wireless/rt2x00/rt2x00usb.c |    9 +++------
 drivers/net/wireless/rt2x00/rt2x00usb.h |    6 ++++++
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6b6e7b9..d095800 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1672,8 +1672,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 static int rt2500usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct usb_device *usb_dev =
-		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
+	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_usb_bcn *bcn_priv;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index b94c461..5593b9a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -40,8 +40,7 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 			     void *buffer, const u16 buffer_length,
 			     const int timeout)
 {
-	struct usb_device *usb_dev =
-		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
+	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	int status;
 	unsigned int i;
 	unsigned int pipe =
@@ -162,8 +161,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 int rt2x00usb_write_tx_data(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct usb_device *usb_dev =
-		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
+	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
 	u32 length;
@@ -319,8 +317,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 void rt2x00usb_init_rxentry(struct rt2x00_dev *rt2x00dev,
 			    struct queue_entry *entry)
 {
-	struct usb_device *usb_dev =
-		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
+	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 
 	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index b1187c8..aad794a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -26,6 +26,12 @@
 #ifndef RT2X00USB_H
 #define RT2X00USB_H
 
+#define to_usb_device_intf(d) \
+({ \
+	struct usb_interface *intf = to_usb_interface(d); \
+	interface_to_usbdev(intf); \
+})
+
 /*
  * This variable should be used with the
  * usb_driver structure initialization.
-- 
1.5.5.4

