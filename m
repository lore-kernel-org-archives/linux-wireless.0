Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:50657 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYGINEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:04:12 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2127384wri.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 06:04:11 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] rt2x00: Reorganize beacon handling
Date: Wed, 9 Jul 2008 15:12:44 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200807091511.14288.IvDoorn@gmail.com> <200807091511.45779.IvDoorn@gmail.com> <200807091512.06678.IvDoorn@gmail.com>
In-Reply-To: <200807091512.06678.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200807091512.44544.IvDoorn@gmail.com> (sfid-20080709_150416_968744_F9EB1D9C)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new beacon handling from mac80211 we can
reorganize the beacon handling in rt2x00 as well.
This patch will move the function to the TX handlers,
and move all duplicate code into rt2x00queue.c.

After this change the descriptor helper functions
from rt2x00queue.c no longer need to be exported
outside of rt2x00lib and can be declared static.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   89 +++++++----------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   90 +++++++----------
 drivers/net/wireless/rt2x00/rt2500usb.c   |  154 +++++++++++------------------
 drivers/net/wireless/rt2x00/rt2x00.h      |   36 +-------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    9 +--
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    8 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   31 ++----
 drivers/net/wireless/rt2x00/rt2x00queue.c |   64 +++++++++++-
 drivers/net/wireless/rt2x00/rt61pci.c     |  103 +++++++-------------
 drivers/net/wireless/rt2x00/rt73usb.c     |  115 ++++++++-------------
 10 files changed, 289 insertions(+), 410 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d0f226e..4c0538d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1069,6 +1069,40 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
+static void rt2400pci_write_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	u32 word;
+	u32 reg;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
+	/*
+	 * Replace rt2x00lib allocated descriptor with the
+	 * pointer to the _real_ hardware descriptor.
+	 * After that, map the beacon to DMA and update the
+	 * descriptor.
+	 */
+	memcpy(entry_priv->desc, skbdesc->desc, skbdesc->desc_len);
+	skbdesc->desc = entry_priv->desc;
+
+	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
+
+	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
+	rt2x00_desc_write(entry_priv->desc, 1, word);
+}
+
 static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				    const enum data_queue_qid queue)
 {
@@ -1515,59 +1549,6 @@ static u64 rt2400pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
-	struct queue_entry_priv_pci *entry_priv;
-	struct skb_frame_desc *skbdesc;
-	struct txentry_desc txdesc;
-	u32 reg;
-
-	if (unlikely(!intf->beacon))
-		return -ENOBUFS;
-	entry_priv = intf->beacon->priv_data;
-
-	/*
-	 * Copy all TX descriptor information into txdesc,
-	 * after that we are free to use the skb->cb array
-	 * for our information.
-	 */
-	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
-
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->desc = entry_priv->desc;
-	skbdesc->desc_len = intf->beacon->queue->desc_size;
-	skbdesc->entry = intf->beacon;
-
-	/*
-	 * Disable beaconing while we are reloading the beacon data,
-	 * otherwise we might be sending out invalid data.
-	 */
-	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
-	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
-
-	/*
-	 * Enable beacon generation.
-	 * Write entire beacon with descriptor to register,
-	 * and kick the beacon generator.
-	 */
-	rt2x00queue_map_txskb(rt2x00dev, intf->beacon->skb);
-	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
-
-	return 0;
-}
-
 static int rt2400pci_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1609,9 +1590,9 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.link_tuner		= rt2400pci_link_tuner,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
+	.write_beacon		= rt2400pci_write_beacon,
 	.kick_tx_queue		= rt2400pci_kick_tx_queue,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
-	.beacon_update		= rt2400pci_beacon_update,
 	.config_filter		= rt2400pci_config_filter,
 	.config_intf		= rt2400pci_config_intf,
 	.config_erp		= rt2400pci_config_erp,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 7ee6b74..aa6dfb8 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1227,6 +1227,40 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
+static void rt2500pci_write_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	u32 word;
+	u32 reg;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
+	/*
+	 * Replace rt2x00lib allocated descriptor with the
+	 * pointer to the _real_ hardware descriptor.
+	 * After that, map the beacon to DMA and update the
+	 * descriptor.
+	 */
+	memcpy(entry_priv->desc, skbdesc->desc, skbdesc->desc_len);
+	skbdesc->desc = entry_priv->desc;
+
+	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
+
+	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
+	rt2x00_desc_write(entry_priv->desc, 1, word);
+}
+
 static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				    const enum data_queue_qid queue)
 {
@@ -1808,60 +1842,6 @@ static u64 rt2500pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
-	struct queue_entry_priv_pci *entry_priv;
-	struct skb_frame_desc *skbdesc;
-	struct txentry_desc txdesc;
-	u32 reg;
-
-	if (unlikely(!intf->beacon))
-		return -ENOBUFS;
-
-	entry_priv = intf->beacon->priv_data;
-
-	/*
-	 * Copy all TX descriptor information into txdesc,
-	 * after that we are free to use the skb->cb array
-	 * for our information.
-	 */
-	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
-
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->desc = entry_priv->desc;
-	skbdesc->desc_len = intf->beacon->queue->desc_size;
-	skbdesc->entry = intf->beacon;
-
-	/*
-	 * Disable beaconing while we are reloading the beacon data,
-	 * otherwise we might be sending out invalid data.
-	 */
-	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
-	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
-
-	/*
-	 * Enable beacon generation.
-	 * Write entire beacon with descriptor to register,
-	 * and kick the beacon generator.
-	 */
-	rt2x00queue_map_txskb(rt2x00dev, intf->beacon->skb);
-	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
-
-	return 0;
-}
-
 static int rt2500pci_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1903,9 +1883,9 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.link_tuner		= rt2500pci_link_tuner,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
+	.write_beacon		= rt2500pci_write_beacon,
 	.kick_tx_queue		= rt2500pci_kick_tx_queue,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
-	.beacon_update		= rt2500pci_beacon_update,
 	.config_filter		= rt2500pci_config_filter,
 	.config_intf		= rt2500pci_config_intf,
 	.config_erp		= rt2500pci_config_erp,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c6d78e2..3558cb2 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1107,6 +1107,65 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 0, word);
 }
 
+/*
+ * TX data initialization
+ */
+static void rt2500usb_beacondone(struct urb *urb);
+
+static void rt2500usb_write_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
+	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	int pipe = usb_sndbulkpipe(usb_dev, 1);
+	int length;
+	u16 reg;
+
+	/*
+	 * Add the descriptor in front of the skb.
+	 */
+	skb_push(entry->skb, entry->queue->desc_size);
+	memcpy(entry->skb->data, skbdesc->desc, skbdesc->desc_len);
+	skbdesc->desc = entry->skb->data;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+
+	/*
+	 * USB devices cannot blindly pass the skb->len as the
+	 * length of the data to usb_fill_bulk_urb. Pass the skb
+	 * to the driver to determine what the length should be.
+	 */
+	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev, entry->skb);
+
+	usb_fill_bulk_urb(bcn_priv->urb, usb_dev, pipe,
+			  entry->skb->data, length, rt2500usb_beacondone,
+			  entry);
+
+	/*
+	 * Second we need to create the guardian byte.
+	 * We only need a single byte, so lets recycle
+	 * the 'flags' field we are not using for beacons.
+	 */
+	bcn_priv->guardian_data = 0;
+	usb_fill_bulk_urb(bcn_priv->guardian_urb, usb_dev, pipe,
+			  &bcn_priv->guardian_data, 1, rt2500usb_beacondone,
+			  entry);
+
+	/*
+	 * Send out the guardian byte.
+	 */
+	usb_submit_urb(bcn_priv->guardian_urb, GFP_ATOMIC);
+}
+
 static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 				     struct sk_buff *skb)
 {
@@ -1122,9 +1181,6 @@ static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	return length;
 }
 
-/*
- * TX data initialization
- */
 static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				    const enum data_queue_qid queue)
 {
@@ -1679,96 +1735,6 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-/*
- * IEEE80211 stack callback functions.
- */
-static int rt2500usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
-	struct queue_entry_priv_usb_bcn *bcn_priv;
-	struct skb_frame_desc *skbdesc;
-	struct txentry_desc txdesc;
-	int pipe = usb_sndbulkpipe(usb_dev, 1);
-	int length;
-	u16 reg;
-
-	if (unlikely(!intf->beacon))
-		return -ENOBUFS;
-
-	bcn_priv = intf->beacon->priv_data;
-
-	/*
-	 * Copy all TX descriptor information into txdesc,
-	 * after that we are free to use the skb->cb array
-	 * for our information.
-	 */
-	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
-
-	/*
-	 * Add the descriptor in front of the skb.
-	 */
-	skb_push(skb, intf->beacon->queue->desc_size);
-	memset(skb->data, 0, intf->beacon->queue->desc_size);
-
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->desc = skb->data;
-	skbdesc->desc_len = intf->beacon->queue->desc_size;
-	skbdesc->entry = intf->beacon;
-
-	/*
-	 * Disable beaconing while we are reloading the beacon data,
-	 * otherwise we might be sending out invalid data.
-	 */
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
-	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
-	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
-
-	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
-
-	/*
-	 * USB devices cannot blindly pass the skb->len as the
-	 * length of the data to usb_fill_bulk_urb. Pass the skb
-	 * to the driver to determine what the length should be.
-	 */
-	length = rt2500usb_get_tx_data_len(rt2x00dev, skb);
-
-	usb_fill_bulk_urb(bcn_priv->urb, usb_dev, pipe,
-			  skb->data, length, rt2500usb_beacondone,
-			  intf->beacon);
-
-	/*
-	 * Second we need to create the guardian byte.
-	 * We only need a single byte, so lets recycle
-	 * the 'flags' field we are not using for beacons.
-	 */
-	bcn_priv->guardian_data = 0;
-	usb_fill_bulk_urb(bcn_priv->guardian_urb, usb_dev, pipe,
-			  &bcn_priv->guardian_data, 1, rt2500usb_beacondone,
-			  intf->beacon);
-
-	/*
-	 * Send out the guardian byte.
-	 */
-	usb_submit_urb(bcn_priv->guardian_urb, GFP_ATOMIC);
-
-	/*
-	 * Enable beacon generation.
-	 */
-	rt2500usb_kick_tx_queue(rt2x00dev, QID_BEACON);
-
-	return 0;
-}
-
 static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -1796,10 +1762,10 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.link_tuner		= rt2500usb_link_tuner,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
+	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2500usb_kick_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
-	.beacon_update		= rt2500usb_beacon_update,
 	.config_filter		= rt2500usb_config_filter,
 	.config_intf		= rt2500usb_config_intf,
 	.config_erp		= rt2500usb_config_erp,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b32fedf..f0d7e08 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -521,6 +521,7 @@ struct rt2x00lib_ops {
 			       struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
 	int (*write_tx_data) (struct queue_entry *entry);
+	void (*write_beacon) (struct queue_entry *entry);
 	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
@@ -535,8 +536,6 @@ struct rt2x00lib_ops {
 	/*
 	 * Configuration handlers.
 	 */
-	int (*beacon_update) (struct ieee80211_hw *hw, struct sk_buff *bcn);
-
 	void (*config_filter) (struct rt2x00_dev *rt2x00dev,
 			       const unsigned int filter_flags);
 	void (*config_intf) (struct rt2x00_dev *rt2x00dev,
@@ -913,39 +912,6 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
- * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
- * @entry: The entry which will be used to transfer the TX frame.
- * @txdesc: rt2x00 TX descriptor which will be initialized by this function.
- *
- * This function will initialize the &struct txentry_desc based on information
- * from mac80211. This descriptor can then be used by rt2x00lib and the drivers
- * to correctly initialize the hardware descriptor.
- * Note that before calling this function the skb->cb array must be untouched
- * by rt2x00lib. Only after this function completes will it be save to
- * overwrite the skb->cb information.
- * The reason for this is that mac80211 writes its own tx information into
- * the skb->cb array, and this function will use that information to initialize
- * the &struct txentry_desc structure.
- */
-void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
-				      struct txentry_desc *txdesc);
-
-/**
- * rt2x00queue_write_tx_descriptor - Write TX descriptor to hardware
- * @entry: The entry which will be used to transfer the TX frame.
- * @txdesc: TX descriptor which will be used to write hardware descriptor
- *
- * This function will write a TX descriptor initialized by
- * &rt2x00queue_create_tx_descriptor to the hardware. After this call
- * has completed the frame is now owned by the hardware, the hardware
- * queue will have automatically be kicked unless this frame was generated
- * by rt2x00lib, in which case the frame is "special" and must be kicked
- * by the caller.
- */
-void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
-				     struct txentry_desc *txdesc);
-
-/**
  * rt2x00queue_get_queue - Convert queue index to queue pointer
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @queue: rt2x00 queue index (see &enum data_queue_qid).
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 1b7f877..8c93eb8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -434,13 +434,8 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
-	if (delayed_flags & DELAYED_UPDATE_BEACON) {
-		struct ieee80211_if_conf conf;
-		conf.bssid = conf.ssid = NULL;
-		conf.ssid_len = 0;
-		conf.changed = IEEE80211_IFCC_BEACON;
-		rt2x00dev->ops->hw->config_interface(rt2x00dev->hw, vif, &conf);
-	}
+	if (delayed_flags & DELAYED_UPDATE_BEACON)
+		rt2x00queue_update_beacon(rt2x00dev, vif);
 
 	if (delayed_flags & DELAYED_CONFIG_ERP)
 		rt2x00lib_config_erp(rt2x00dev, intf, &conf);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index eae5ce1..f2c9b0e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -139,6 +139,14 @@ void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb);
 
 /**
+ * rt2x00queue_update_beacon - Send new beacon from mac80211 to hardware
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @vif: Interface for which the beacon should be updated.
+ */
+int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
+			      struct ieee80211_vif *vif);
+
+/**
  * rt2x00queue_index_inc - Index incrementation function
  * @queue: Queue (&struct data_queue) to perform the action on.
  * @index: Index type (&enum queue_index) to perform the action on.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index ff853c4..214130e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -348,8 +348,8 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
-	struct sk_buff *beacon;
-	int status;
+	int update_bssid = 0;
+	int status = 0;
 
 	/*
 	 * Mac80211 might be calling this function while we are trying
@@ -361,15 +361,13 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 	spin_lock(&intf->lock);
 
 	/*
-	 * If the interface does not work in master mode,
-	 * then the bssid value in the interface structure
-	 * should now be set.
-	 *
 	 * conf->bssid can be NULL if coming from the internal
 	 * beacon update routine.
 	 */
-	if (conf->bssid && vif->type != IEEE80211_IF_TYPE_AP)
+	if (conf->changed & IEEE80211_IFCC_BSSID && conf->bssid) {
+		update_bssid = 1;
 		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
+	}
 
 	spin_unlock(&intf->lock);
 
@@ -379,23 +377,14 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 	 * values as arguments we make keep access to rt2x00_intf thread safe
 	 * even without the lock.
 	 */
-	rt2x00lib_config_intf(rt2x00dev, intf, vif->type, NULL, conf->bssid);
+	rt2x00lib_config_intf(rt2x00dev, intf, vif->type, NULL,
+			      update_bssid ? conf->bssid : NULL);
 
 	/*
-	 * We only need to initialize the beacon when in master/ibss mode.
+	 * Update the beacon.
 	 */
-	if ((vif->type != IEEE80211_IF_TYPE_AP &&
-	     vif->type != IEEE80211_IF_TYPE_IBSS) ||
-	    !(conf->changed & IEEE80211_IFCC_BEACON))
-		return 0;
-
-	beacon = ieee80211_beacon_get(rt2x00dev->hw, vif);
-	if (!beacon)
-		return -ENOMEM;
-
-	status = rt2x00dev->ops->lib->beacon_update(rt2x00dev->hw, beacon);
-	if (status)
-		dev_kfree_skb(beacon);
+	if (conf->changed & IEEE80211_IFCC_BEACON)
+		status = rt2x00queue_update_beacon(rt2x00dev, vif);
 
 	return status;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index ecf57f8..7f44203 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -115,8 +115,8 @@ void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
-void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
-				      struct txentry_desc *txdesc)
+static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
+					     struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
@@ -240,10 +240,9 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 			txdesc->signal |= 0x08;
 	}
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_create_tx_descriptor);
 
-void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
-				     struct txentry_desc *txdesc)
+static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
+					    struct txentry_desc *txdesc)
 {
 	struct data_queue *queue = entry->queue;
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
@@ -273,7 +272,6 @@ void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 	    !test_bit(ENTRY_TXD_BURST, &txdesc->flags))
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, queue->qid);
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_write_tx_descriptor);
 
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 {
@@ -323,6 +321,60 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	return 0;
 }
 
+int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
+			      struct ieee80211_vif *vif)
+{
+	struct rt2x00_intf *intf = vif_to_intf(vif);
+	struct skb_frame_desc *skbdesc;
+	struct txentry_desc txdesc;
+	__le32 desc[16];
+
+	if (unlikely(!intf->beacon))
+		return -ENOBUFS;
+
+	intf->beacon->skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
+	if (!intf->beacon->skb)
+		return -ENOMEM;
+
+	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * For the descriptor we use a local array from where the
+	 * driver can move it to the correct location required for
+	 * the hardware.
+	 */
+	memset(desc, 0, sizeof(desc));
+
+	/*
+	 * Fill in skb descriptor
+	 */
+	skbdesc = get_skb_frame_desc(intf->beacon->skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
+	skbdesc->desc = desc;
+	skbdesc->desc_len = intf->beacon->queue->desc_size;
+	skbdesc->entry = intf->beacon;
+
+	/*
+	 * Write TX descriptor into reserved room in front of the beacon.
+	 */
+	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Send beacon to hardware.
+	 * Also enable beacon generation, which might have been disabled
+	 * by the driver during the config_beacon() callback function.
+	 */
+	rt2x00dev->ops->lib->write_beacon(intf->beacon);
+	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
+
+	return 0;
+}
+
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 					 const enum data_queue_qid queue)
 {
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 34d0fd0..70ef7bf 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1600,6 +1600,41 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
+static void rt61pci_write_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	unsigned int beacon_base;
+	u32 reg;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
+	 * Write entire beacon with descriptor to register.
+	 */
+	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
+	rt2x00pci_register_multiwrite(rt2x00dev,
+				      beacon_base,
+				      skbdesc->desc, skbdesc->desc_len);
+	rt2x00pci_register_multiwrite(rt2x00dev,
+				      beacon_base + skbdesc->desc_len,
+				      entry->skb->data, entry->skb->len);
+
+	/*
+	 * Clean up beacon skb.
+	 */
+	dev_kfree_skb_any(entry->skb);
+	entry->skb = NULL;
+}
+
 static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				  const enum data_queue_qid queue)
 {
@@ -2355,72 +2390,6 @@ static u64 rt61pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
-	struct queue_entry_priv_pci *entry_priv;
-	struct skb_frame_desc *skbdesc;
-	struct txentry_desc txdesc;
-	unsigned int beacon_base;
-	u32 reg;
-
-	if (unlikely(!intf->beacon))
-		return -ENOBUFS;
-
-	/*
-	 * Copy all TX descriptor information into txdesc,
-	 * after that we are free to use the skb->cb array
-	 * for our information.
-	 */
-	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
-
-	entry_priv = intf->beacon->priv_data;
-	memset(entry_priv->desc, 0, intf->beacon->queue->desc_size);
-
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->desc = entry_priv->desc;
-	skbdesc->desc_len = intf->beacon->queue->desc_size;
-	skbdesc->entry = intf->beacon;
-
-	/*
-	 * Disable beaconing while we are reloading the beacon data,
-	 * otherwise we might be sending out invalid data.
-	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
-
-	/*
-	 * Write entire beacon with descriptor to register,
-	 * and kick the beacon generator.
-	 */
-	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
-	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
-				      skbdesc->desc, skbdesc->desc_len);
-	rt2x00pci_register_multiwrite(rt2x00dev,
-				      beacon_base + skbdesc->desc_len,
-				      skb->data, skb->len);
-	rt61pci_kick_tx_queue(rt2x00dev, QID_BEACON);
-
-	/*
-	 * Clean up beacon skb.
-	 */
-	dev_kfree_skb_any(skb);
-	intf->beacon->skb = NULL;
-
-	return 0;
-}
-
 static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -2455,9 +2424,9 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.link_tuner		= rt61pci_link_tuner,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
+	.write_beacon		= rt61pci_write_beacon,
 	.kick_tx_queue		= rt61pci_kick_tx_queue,
 	.fill_rxdone		= rt61pci_fill_rxdone,
-	.beacon_update		= rt61pci_beacon_update,
 	.config_filter		= rt61pci_config_filter,
 	.config_intf		= rt61pci_config_intf,
 	.config_erp		= rt61pci_config_erp,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 501c2d9..34c6ff2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1343,6 +1343,49 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 0, word);
 }
 
+/*
+ * TX data initialization
+ */
+static void rt73usb_write_beacon(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	unsigned int beacon_base;
+	u32 reg;
+
+	/*
+	 * Add the descriptor in front of the skb.
+	 */
+	skb_push(entry->skb, entry->queue->desc_size);
+	memcpy(entry->skb->data, skbdesc->desc, skbdesc->desc_len);
+	skbdesc->desc = entry->skb->data;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
+	 * Write entire beacon with descriptor to register.
+	 */
+	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
+	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
+				 USB_VENDOR_REQUEST_OUT, beacon_base, 0,
+				 entry->skb->data, entry->skb->len,
+				 REGISTER_TIMEOUT32(entry->skb->len));
+
+	/*
+	 * Clean up the beacon skb.
+	 */
+	dev_kfree_skb(entry->skb);
+	entry->skb = NULL;
+}
+
 static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 				   struct sk_buff *skb)
 {
@@ -1358,9 +1401,6 @@ static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	return length;
 }
 
-/*
- * TX data initialization
- */
 static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				  const enum data_queue_qid queue)
 {
@@ -1958,73 +1998,6 @@ static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 #define rt73usb_get_tsf	NULL
 #endif
 
-static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
-	struct skb_frame_desc *skbdesc;
-	struct txentry_desc txdesc;
-	unsigned int beacon_base;
-	u32 reg;
-
-	if (unlikely(!intf->beacon))
-		return -ENOBUFS;
-
-	/*
-	 * Copy all TX descriptor information into txdesc,
-	 * after that we are free to use the skb->cb array
-	 * for our information.
-	 */
-	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
-
-	/*
-	 * Add the descriptor in front of the skb.
-	 */
-	skb_push(skb, intf->beacon->queue->desc_size);
-	memset(skb->data, 0, intf->beacon->queue->desc_size);
-
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->desc = skb->data;
-	skbdesc->desc_len = intf->beacon->queue->desc_size;
-	skbdesc->entry = intf->beacon;
-
-	/*
-	 * Disable beaconing while we are reloading the beacon data,
-	 * otherwise we might be sending out invalid data.
-	 */
-	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
-
-	/*
-	 * Write entire beacon with descriptor to register,
-	 * and kick the beacon generator.
-	 */
-	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
-	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
-				 USB_VENDOR_REQUEST_OUT, beacon_base, 0,
-				 skb->data, skb->len,
-				 REGISTER_TIMEOUT32(skb->len));
-	rt73usb_kick_tx_queue(rt2x00dev, QID_BEACON);
-
-	/*
-	 * Clean up the beacon skb.
-	 */
-	dev_kfree_skb(skb);
-	intf->beacon->skb = NULL;
-
-	return 0;
-}
-
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -2057,10 +2030,10 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.link_tuner		= rt73usb_link_tuner,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
+	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt73usb_kick_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
-	.beacon_update		= rt73usb_beacon_update,
 	.config_filter		= rt73usb_config_filter,
 	.config_intf		= rt73usb_config_intf,
 	.config_erp		= rt73usb_config_erp,
-- 
1.5.6.1

