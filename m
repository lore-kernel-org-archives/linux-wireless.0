Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:15268 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933982AbXKOWOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 17:14:45 -0500
Received: by fk-out-0910.google.com with SMTP id z23so689785fkz
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 14:14:43 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Request usb_maxpacket() once
Date: Thu, 15 Nov 2007 23:41:31 +0100
Cc: linux-wireless@vger.kernel.org,
	"rt2400-devel" <rt2400-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711152341.31751.IvDoorn@gmail.com> (sfid-20071115_221509_433847_EAB95D94)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The usb max packet size won't change during the
device's presence. We should store it in a
variable inside rt2x00dev and use that.
This should also fix a division error when the
device is being hot-unplugged while a frame is
being send out.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

John, please queue for 2.6.24 since this fixes the kernel panic
reported in kernel bugzilla [9368]

 drivers/net/wireless/rt2x00/rt2500usb.c |    7 +++----
 drivers/net/wireless/rt2x00/rt2x00.h    |    7 ++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c |    9 ++++++---
 drivers/net/wireless/rt2x00/rt73usb.c   |    4 ++--
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b5a8f82..5bfbac4 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1072,7 +1072,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
-				     int maxpacket, struct sk_buff *skb)
+				     struct sk_buff *skb)
 {
 	int length;
 
@@ -1081,7 +1081,7 @@ static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	 * but it must _not_ be a multiple of the USB packet size.
 	 */
 	length = roundup(skb->len, 2);
-	length += (2 * !(length % maxpacket));
+	length += (2 * !(length % rt2x00dev->usb_maxpacket));
 
 	return length;
 }
@@ -1696,7 +1696,6 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	struct data_entry *beacon;
 	struct data_entry *guardian;
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
-	int max_packet = usb_maxpacket(usb_dev, pipe, 1);
 	int length;
 
 	/*
@@ -1725,7 +1724,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 							 ring->desc_size),
 				skb->len - ring->desc_size, control);
 
-	length = rt2500usb_get_tx_data_len(rt2x00dev, max_packet, skb);
+	length = rt2500usb_get_tx_data_len(rt2x00dev, skb);
 
 	usb_fill_bulk_urb(beacon->priv, usb_dev, pipe,
 			  skb->data, length, rt2500usb_beacondone, beacon);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 12382c3..84b0fc9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -497,7 +497,7 @@ struct rt2x00lib_ops {
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
 			      struct data_ring *ring, struct sk_buff *skb,
 			      struct ieee80211_tx_control *control);
-	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev, int maxpacket,
+	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
 			       unsigned int queue);
@@ -697,6 +697,11 @@ struct rt2x00_dev {
 	u32 *rf;
 
 	/*
+	 * USB Max frame size (for rt2500usb & rt73usb).
+	 */
+	u16 usb_maxpacket;
+
+	/*
 	 * Current TX power value.
 	 */
 	u16 tx_power;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index f61dee5..936e554 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -182,7 +182,6 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
-	int max_packet = usb_maxpacket(usb_dev, pipe, 1);
 	u32 length;
 
 	if (rt2x00_ring_full(ring)) {
@@ -217,8 +216,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
 	 */
-	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev,
-						      max_packet, skb);
+	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev, skb);
 
 	/*
 	 * Initialize URB and send the frame to the device.
@@ -514,6 +512,11 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->hw = hw;
 	mutex_init(&rt2x00dev->usb_cache_mutex);
 
+	rt2x00dev->usb_maxpacket =
+	    usb_maxpacket(usb_dev, usb_sndbulkpipe(usb_dev, 1), 1);
+	if (!rt2x00dev->usb_maxpacket)
+		rt2x00dev->usb_maxpacket = 1;
+
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9bd0b4f..4d1227a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1293,7 +1293,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
-				   int maxpacket, struct sk_buff *skb)
+				   struct sk_buff *skb)
 {
 	int length;
 
@@ -1302,7 +1302,7 @@ static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	 * but it must _not_ be a multiple of the USB packet size.
 	 */
 	length = roundup(skb->len, 4);
-	length += (4 * !(length % maxpacket));
+	length += (4 * !(length % rt2x00dev->usb_maxpacket));
 
 	return length;
 }
-- 
1.5.3.4

