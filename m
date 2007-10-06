Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbXJFMEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:10 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605539ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:09 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/16] rt2x00: Add get_tx_data_len callback function
Date: Sat, 6 Oct 2007 14:15:46 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061415.47473.IvDoorn@gmail.com> (sfid-20071006_130414_916537_BB509BF9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX datalen must always be converted to a value rt73 and rt2500usb
understand. Both require to use a different size then skb->len.
First off this is required because the descriptor must be added,
but the second is because the value must be a multiple of either 2 or 4,
and it should not be a multiple of the USB packetmax

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   32 ++++++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +
 drivers/net/wireless/rt2x00/rt2x00usb.c |   29 ++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt73usb.c   |   16 +++++++++++++++
 4 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c1f217b..c4aa466 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1057,6 +1057,21 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 0, word);
 }
 
+static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
+				     int maxpacket, struct sk_buff *skb)
+{
+	int length;
+
+	/*
+	 * The length _must_ be a multiple of 2,
+	 * but it must _not_ be a multiple of the USB packet size.
+	 */
+	length = roundup(skb->len, 2);
+	length += (2 * !(length % maxpacket));
+
+	return length;
+}
+
 /*
  * TX data initialization
  */
@@ -1651,6 +1666,8 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 	struct data_entry *beacon;
 	struct data_entry *guardian;
+	int pipe = usb_sndbulkpipe(usb_dev, 1);
+	int max_packet = usb_maxpacket(usb_dev, pipe, 1);
 	int length;
 
 	/*
@@ -1677,16 +1694,9 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 							 ring->desc_size),
 				skb->len - ring->desc_size, control);
 
-	/*
-	 * Length passed to usb_fill_urb cannot be an odd number,
-	 * so add 1 byte to make it even.
-	 */
-	length = skb->len;
-	if (length % 2)
-		length++;
+	length = rt2500usb_get_tx_data_len(rt2x00dev, max_packet, skb);
 
-	usb_fill_bulk_urb(beacon->priv, usb_dev,
-			  usb_sndbulkpipe(usb_dev, 1),
+	usb_fill_bulk_urb(beacon->priv, usb_dev, pipe,
 			  skb->data, length, rt2500usb_beacondone, beacon);
 
 	beacon->skb = skb;
@@ -1697,8 +1707,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 * the 'flags' field we are not using for beacons.
 	 */
 	guardian->flags = 0;
-	usb_fill_bulk_urb(guardian->priv, usb_dev,
-			  usb_sndbulkpipe(usb_dev, 1),
+	usb_fill_bulk_urb(guardian->priv, usb_dev, pipe,
 			  &guardian->flags, 1, rt2500usb_beacondone, guardian);
 
 	/*
@@ -1739,6 +1748,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.link_tuner		= rt2500usb_link_tuner,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
+	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2500usb_kick_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_mac_addr	= rt2500usb_config_mac_addr,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 27bec6e..a392e2a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -396,6 +396,8 @@ struct rt2x00lib_ops {
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
 			      struct data_ring *ring, struct sk_buff *skb,
 			      struct ieee80211_tx_control *control);
+	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev, int maxpacket,
+				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
 			       unsigned int queue);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 66e4761..73cc726 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -157,9 +157,10 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 {
 	struct usb_device *usb_dev =
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	u32 length = skb->len;
+	int pipe = usb_sndbulkpipe(usb_dev, 1);
+	int max_packet = usb_maxpacket(usb_dev, pipe, 1);
+	u32 length;
 
 	if (rt2x00_ring_full(ring)) {
 		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
@@ -178,25 +179,29 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Add the descriptor in front of the skb.
 	 */
-	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
-	memset(skb->data, 0x00, rt2x00dev->hw->extra_tx_headroom);
+	skb_push(skb, ring->desc_size);
+	memset(skb->data, 0, ring->desc_size);
 
 	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
-				ieee80211hdr, length, control);
+				(struct ieee80211_hdr *)(skb->data +
+							 ring->desc_size),
+				skb->len - ring->desc_size, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	entry->skb = skb;
 
 	/*
-	 * Length passed to usb_fill_urb cannot be an odd number,
-	 * so add 1 byte to make it even.
+	 * USB devices cannot blindly pass the skb->len as the
+	 * length of the data to usb_fill_bulk_urb. Pass the skb
+	 * to the driver to determine what the length should be.
 	 */
-	length += rt2x00dev->hw->extra_tx_headroom;
-	if (length % 2)
-		length++;
+	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev,
+						      max_packet, skb);
 
+	/*
+	 * Initialize URB and send the frame to the device.
+	 */
 	__set_bit(ENTRY_OWNER_NIC, &entry->flags);
-	usb_fill_bulk_urb(entry->priv, usb_dev,
-			  usb_sndbulkpipe(usb_dev, 1),
+	usb_fill_bulk_urb(entry->priv, usb_dev, pipe,
 			  skb->data, length, rt2x00usb_interrupt_txdone, entry);
 	usb_submit_urb(entry->priv, GFP_ATOMIC);
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e7887c3..7cfdf65 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1286,6 +1286,21 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 0, word);
 }
 
+static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
+				   int maxpacket, struct sk_buff *skb)
+{
+	int length;
+
+	/*
+	 * The length _must_ be a multiple of 4,
+	 * but it must _not_ be a multiple of the USB packet size.
+	 */
+	length = roundup(skb->len, 4);
+	length += (4 * !(length % maxpacket));
+
+	return length;
+}
+
 /*
  * TX data initialization
  */
@@ -2010,6 +2025,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.link_tuner		= rt73usb_link_tuner,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
+	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt73usb_kick_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_mac_addr	= rt73usb_config_mac_addr,
-- 
1.5.3.4

